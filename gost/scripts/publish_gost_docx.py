#!/usr/bin/env python3
from __future__ import annotations

import argparse
import shutil
import subprocess
import tempfile
from pathlib import Path
from xml.etree import ElementTree as ET
from zipfile import ZIP_DEFLATED, ZipFile


PROJECT_ROOT = Path(__file__).resolve().parents[2]
GOST_ROOT = PROJECT_ROOT / "gost"
ORDER_FILE = GOST_ROOT / "order.txt"
DEFAULT_OUTPUT = PROJECT_ROOT / "input" / "assets" / "gost" / "GOST_Interoperability.docx"
REFERENCE_DOC = GOST_ROOT / "templates" / "reference-styles.docx"

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
R = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
ET.register_namespace("w", W)
ET.register_namespace("r", R)


def q(tag: str) -> str:
    return f"{{{W}}}{tag}"


def find_pandoc(explicit: str | None) -> str:
    candidates = [
        explicit,
        shutil.which("pandoc"),
        str(Path.home() / ".local" / "bin" / "pandoc"),
    ]
    for candidate in candidates:
        if candidate and Path(candidate).exists():
            return str(candidate)
    raise SystemExit(
        "pandoc не найден. Установите pandoc или передайте путь через --pandoc."
    )


def read_order() -> list[Path]:
    files: list[Path] = []
    for raw_line in ORDER_FILE.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        files.append(PROJECT_ROOT / line)
    missing = [path for path in files if not path.exists()]
    if missing:
        missing_text = "\n".join(str(path) for path in missing)
        raise SystemExit(f"Не найдены файлы глав:\n{missing_text}")
    return files


def build_markdown(files: list[Path]) -> str:
    parts = []
    for path in files:
        parts.append(path.read_text(encoding="utf-8").strip())
    return "\n\n".join(parts) + "\n"


def parent_map(root: ET.Element) -> dict[ET.Element, ET.Element]:
    return {child: parent for parent in root.iter() for child in parent}


def has_ancestor(elem: ET.Element, parents: dict[ET.Element, ET.Element], tag: str) -> bool:
    cur = elem
    while cur in parents:
        cur = parents[cur]
        if cur.tag == q(tag):
            return True
    return False


def paragraph_style(p: ET.Element) -> str:
    style = p.find("./" + q("pPr") + "/" + q("pStyle"))
    return style.get(q("val"), "") if style is not None else ""


def set_paragraph_style(p: ET.Element, style_name: str) -> None:
    ppr = p.find(q("pPr"))
    if ppr is None:
        ppr = ET.Element(q("pPr"))
        p.insert(0, ppr)
    style = ppr.find(q("pStyle"))
    if style is None:
        style = ET.Element(q("pStyle"))
        ppr.insert(0, style)
    style.set(q("val"), style_name)


def paragraph_text(p: ET.Element) -> str:
    return "".join(t.text or "" for t in p.iter(q("t"))).strip()


def paragraph_instr(p: ET.Element) -> str:
    return "".join(t.text or "" for t in p.iter(q("instrText"))).strip()


def is_body_text_paragraph(p: ET.Element, parents: dict[ET.Element, ET.Element]) -> bool:
    if has_ancestor(p, parents, "tbl"):
        return False
    style = paragraph_style(p)
    excluded_prefixes = ("Heading", "TOC")
    excluded_styles = {"Title", "Subtitle", "TOCHeading"}
    return style not in excluded_styles and not style.startswith(excluded_prefixes)


def set_paragraph_text(p: ET.Element, value: str) -> None:
    text_nodes = list(p.iter(q("t")))
    if text_nodes:
        text_nodes[0].text = value
        for text in text_nodes[1:]:
            text.text = ""
        return
    run = ET.Element(q("r"))
    text = ET.Element(q("t"))
    text.text = value
    run.append(text)
    p.append(run)


def first_body_element(root: ET.Element, tag: str) -> ET.Element | None:
    body = root.find(q("body"))
    if body is None:
        return None
    for child in body:
        if child.tag == q(tag):
            return child
    return None


def apply_title_and_toc_layout(root: ET.Element) -> None:
    body = root.find(q("body"))
    if body is None:
        return

    children = list(body)
    toc_block = None
    for child in children:
        if child.tag == q("sdt") and paragraph_instr(child).startswith("TOC "):
            toc_block = child
            for p in child.iter(q("p")):
                if paragraph_text(p) == "Table of Contents":
                    set_paragraph_text(p, "Оглавление")
                    set_paragraph_style(p, "TOCHeading")
                    break
            break

    paragraphs = [child for child in children if child.tag == q("p")]
    title_paragraph = None
    toc_heading = None
    toc_field = None

    for p in paragraphs:
        text = paragraph_text(p)
        instr = paragraph_instr(p)
        if text == "Table of Contents":
            toc_heading = p
            set_paragraph_text(p, "Оглавление")
            set_paragraph_style(p, "TOCHeading")
        elif instr.startswith("TOC "):
            toc_field = p
        elif text and title_paragraph is None:
            title_paragraph = p

    if title_paragraph is None:
        return

    set_paragraph_style(title_paragraph, "Title")

    if toc_block is not None:
        if toc_block in body:
            body.remove(toc_block)
        title_index = list(body).index(title_paragraph)
        body.insert(title_index + 1, toc_block)
        return

    if toc_heading is not None and toc_field is not None:
        for p in (title_paragraph, toc_heading, toc_field):
            if p in body:
                body.remove(p)
        insert_at = 0
        set_paragraph_text(toc_heading, "Оглавление")
        set_paragraph_style(toc_heading, "TOCHeading")
        for offset, p in enumerate((title_paragraph, toc_heading, toc_field)):
            body.insert(insert_at + offset, p)


def flatten_hyperlinks(root: ET.Element) -> int:
    parents = parent_map(root)
    count = 0
    for hyperlink in list(root.iter(q("hyperlink"))):
        if hyperlink.get(q("anchor")):
            continue
        parent = parents.get(hyperlink)
        if parent is None:
            continue
        index = list(parent).index(hyperlink)
        children = list(hyperlink)
        for child in children:
            hyperlink.remove(child)
        parent.remove(hyperlink)
        for offset, child in enumerate(children):
            parent.insert(index + offset, child)
        count += 1
    return count


def remove_hyperlink_relationships(root: ET.Element) -> ET.Element:
    for rel in list(root):
        if rel.get("Type", "").endswith("/hyperlink"):
            root.remove(rel)
    return root


def set_table_borders(tbl: ET.Element) -> None:
    tbl_pr = tbl.find(q("tblPr"))
    if tbl_pr is None:
        tbl_pr = ET.Element(q("tblPr"))
        tbl.insert(0, tbl_pr)

    borders = tbl_pr.find(q("tblBorders"))
    if borders is None:
        borders = ET.Element(q("tblBorders"))
        tbl_pr.append(borders)

    for name in ("top", "left", "bottom", "right", "insideH", "insideV"):
        border = borders.find(q(name))
        if border is None:
            border = ET.Element(q(name))
            borders.append(border)
        border.set(q("val"), "single")
        border.set(q("sz"), "4")
        border.set(q("space"), "0")
        border.set(q("color"), "auto")


def set_table_run_size(tbl: ET.Element) -> None:
    for run in tbl.iter(q("r")):
        rpr = run.find(q("rPr"))
        if rpr is None:
            rpr = ET.Element(q("rPr"))
            run.insert(0, rpr)
        for tag in ("sz", "szCs"):
            size = rpr.find(q(tag))
            if size is None:
                size = ET.Element(q(tag))
                rpr.append(size)
            size.set(q("val"), "20")


def set_body_text_paragraph_format(p: ET.Element) -> None:
    ppr = p.find(q("pPr"))
    if ppr is None:
        ppr = ET.Element(q("pPr"))
        p.insert(0, ppr)

    jc = ppr.find(q("jc"))
    if jc is None:
        jc = ET.Element(q("jc"))
        ppr.append(jc)
    jc.set(q("val"), "both")

    spacing = ppr.find(q("spacing"))
    if spacing is None:
        spacing = ET.Element(q("spacing"))
        ppr.append(spacing)
    spacing.set(q("before"), "180")
    spacing.set(q("after"), "0")
    spacing.set(q("line"), "276")
    spacing.set(q("lineRule"), "auto")

    for run in p.iter(q("r")):
        rpr = run.find(q("rPr"))
        if rpr is None:
            rpr = ET.Element(q("rPr"))
            run.insert(0, rpr)
        fonts = rpr.find(q("rFonts"))
        if fonts is None:
            fonts = ET.Element(q("rFonts"))
            rpr.insert(0, fonts)
        for attr in ("ascii", "hAnsi", "cs", "eastAsia"):
            fonts.set(q(attr), "Times New Roman")
        for tag in ("sz", "szCs"):
            size = rpr.find(q(tag))
            if size is None:
                size = ET.Element(q(tag))
                rpr.append(size)
            size.set(q("val"), "24")


def postprocess_docx(path: Path) -> tuple[int, int]:
    tmp = path.with_suffix(".docx.tmp")
    with ZipFile(path, "r") as zin:
        root = ET.fromstring(zin.read("word/document.xml"))
        apply_title_and_toc_layout(root)
        flatten_hyperlinks(root)
        parents = parent_map(root)

        tables = list(root.iter(q("tbl")))
        for tbl in tables:
            set_table_borders(tbl)
            set_table_run_size(tbl)

        body_paragraphs = [
            p for p in root.iter(q("p")) if is_body_text_paragraph(p, parents)
        ]
        for paragraph in body_paragraphs:
            set_body_text_paragraph_format(paragraph)

        document_xml = ET.tostring(root, encoding="utf-8", xml_declaration=True)
        with ZipFile(tmp, "w", ZIP_DEFLATED) as zout:
            for item in zin.infolist():
                if item.filename == "word/document.xml":
                    data = document_xml
                elif item.filename == "word/_rels/document.xml.rels":
                    rels_root = ET.fromstring(zin.read(item.filename))
                    data = ET.tostring(
                        remove_hyperlink_relationships(rels_root),
                        encoding="utf-8",
                        xml_declaration=True,
                    )
                else:
                    data = zin.read(item.filename)
                zout.writestr(item, data)

    shutil.move(tmp, path)
    return len(tables), len(body_paragraphs)


def publish(output: Path, pandoc_path: str) -> None:
    files = read_order()
    markdown = build_markdown(files)
    output.parent.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="gost-docx-") as tmpdir:
        tmp_md = Path(tmpdir) / "combined.md"
        tmp_md.write_text(markdown, encoding="utf-8")

        cmd = [
            pandoc_path,
            str(tmp_md),
            "-f",
            "gfm",
            "-t",
            "docx",
            f"--resource-path={PROJECT_ROOT / 'input'}",
            "--toc",
            "--toc-depth=3",
            "-o",
            str(output),
        ]
        if REFERENCE_DOC.exists():
            cmd.insert(-2, f"--reference-doc={REFERENCE_DOC}")
        subprocess.run(cmd, check=True)

    tables, paragraphs = postprocess_docx(output)
    print(f"Готово: {output}")
    print(f"Обработано таблиц: {tables}")
    print(f"Обработано абзацев вне таблиц: {paragraphs}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Сборка общего ГОСТ DOCX из Markdown-глав.")
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--pandoc", help="Путь к исполняемому файлу pandoc")
    args = parser.parse_args()

    pandoc_path = find_pandoc(args.pandoc)
    publish(args.output, pandoc_path)


if __name__ == "__main__":
    main()
