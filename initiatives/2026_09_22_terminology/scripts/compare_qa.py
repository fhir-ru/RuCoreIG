#!/usr/bin/env python3
"""Compare Publisher QA messages, retaining duplicate counts. Python 3 stdlib only.

Usage: compare_qa.py BASELINE_DIR AFTER_DIR --output comparison
Download qa.xml, qa.json and qa.txt into each directory. qa.xml is authoritative;
qa.json commonly contains only counts. FHIR JSON OperationOutcome/Bundle also works.
Never substitutes a comparison of totals for a comparison of individual messages.
"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import xml.etree.ElementTree as ET

NS = {"f": "http://hl7.org/fhir"}
NORMALIZATION = [
    "Collapse whitespace in message fields.",
    "Replace absolute build-root prefixes before output/, input/, fsh-generated/ or temp/ with <ROOT>/.",
    "Replace ru.core#<ig-ver> and local StructureDefinition |<ig-ver> or v<ig-ver> with <IG_VERSION>.",
    "Do not replace CodeSystem/ValueSet versions, systems, codes, indexes or other numbers.",
    "Ignore source line/column offsets; compare file, expression, severity, message-id, source and text.",
    "Keep duplicate occurrence counts; no fuzzy matching. Changed text becomes resolved + new.",
]


def normalize(value, version):
    value = " ".join(str(value or "").split())
    value = re.sub(r"(?<![:\w])/(?:[^\s<>\"']+/)+(?=(?:output|input|fsh-generated|temp)/)",
                   "<ROOT>/", value)
    if version:
        value = value.replace("ru.core#" + version, "ru.core#<IG_VERSION>")
        value = re.sub(r"(https://fhir\.ru/ig/core/StructureDefinition/[^\s|'\"<>]+\|)"
                       + re.escape(version) + r"(?![\w.])", r"\1<IG_VERSION>", value)
        value = re.sub(r"(https://fhir\.ru/ig/core/StructureDefinition/[^\s|'\"<>]+ v)"
                       + re.escape(version) + r"(?![\w.])", r"\1<IG_VERSION>", value)
    return value


def check_normalization():
    """Guard against hiding terminology changes while ignoring IG profile versions."""
    version = "0.21.0"
    profile = "https://fhir.ru/ig/core/StructureDefinition/okato"
    for separator in ("|", " v"):
        assert normalize(profile + separator + version, version) == profile + separator + "<IG_VERSION>"
    for text in (
        "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-okato|0.21.0",
        "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-okato v0.21.0",
        "Unknown code '3' in CodeSystem 'https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-address-type' version '0.21.0'",
        "https://fhir.ru/ig/core/ValueSet/core-vs-nsi-okato|0.21.0",
        profile + " v0.21.0.1",
        profile + " v0.20.0",
    ):
        assert normalize(text, version) == text, text


def xml_value(parent, path):
    item = parent.find(path, NS)
    return item.get("value", "") if item is not None else ""


def extensions_xml(parent):
    return {item.get("url", "").rsplit("/", 1)[-1]: next(iter(item)).get("value", "")
            for item in parent.findall("f:extension", NS) if len(item)}


def xml_messages(path):
    root = ET.parse(path).getroot()
    outcomes = [root] if root.tag.endswith("}OperationOutcome") else root.findall(".//f:OperationOutcome", NS)
    for outcome in outcomes:
        file = extensions_xml(outcome).get("operationoutcome-file", "Build Errors")
        for issue in outcome.findall("f:issue", NS):
            ext = extensions_xml(issue)
            yield {"severity": xml_value(issue, "f:severity"), "file": file,
                   "location": " | ".join(i.get("value", "") for i in issue.findall("f:expression", NS)),
                   "message_id": ext.get("operationoutcome-message-id", ""),
                   "source": ext.get("operationoutcome-issue-source", ""),
                   "text": xml_value(issue, "f:details/f:text") or xml_value(issue, "f:diagnostics")}


def json_messages(data):
    outcomes = [data] if data.get("resourceType") == "OperationOutcome" else [e.get("resource", {}) for e in data.get("entry", [])]
    for outcome in outcomes:
        if outcome.get("resourceType") != "OperationOutcome":
            continue
        def ext(obj):
            return {e["url"].rsplit("/", 1)[-1]: next((v for k, v in e.items() if k.startswith("value")), "")
                    for e in obj.get("extension", [])}
        file = ext(outcome).get("operationoutcome-file", "Build Errors")
        for issue in outcome.get("issue", []):
            extension = ext(issue)
            yield {"severity": issue.get("severity", ""), "file": file,
                   "location": " | ".join(issue.get("expression", issue.get("location", []))),
                   "message_id": extension.get("operationoutcome-message-id", ""),
                   "source": extension.get("operationoutcome-issue-source", ""),
                   "text": issue.get("details", {}).get("text", issue.get("diagnostics", ""))}


def load(path):
    path = Path(path)
    directory = path if path.is_dir() else path.parent
    summary_path = directory / "qa.json"
    summary = json.loads(summary_path.read_text()) if summary_path.exists() else {}
    metadata = {k: summary[k] for k in ("ig-ver", "dateISO8601", "errs", "warnings", "hints", "version", "tool") if k in summary}
    txt = directory / "qa.txt"
    if txt.exists():
        match = re.search(r"IG Publisher Version:\s*([^\r\n]+)", txt.read_text())
        if match:
            metadata["publisher_version"] = match.group(1)
    if path.is_dir() or path.name == "qa.json":
        messages = list(json_messages(summary))
        source = summary_path
        if not messages:
            source = directory / "qa.xml"
            if not source.exists():
                raise ValueError(f"{path}: qa.json has no messages; download qa.xml (HTML/text totals are insufficient)")
            messages = list(xml_messages(source))
    elif path.suffix == ".xml":
        source, messages = path, list(xml_messages(path))
    elif path.suffix == ".json":
        source, messages = path, list(json_messages(json.loads(path.read_text())))
    else:
        raise ValueError("Use a QA directory, qa.xml, or a FHIR JSON OperationOutcome/Bundle")
    if not messages:
        raise ValueError(f"{source}: no OperationOutcome issues found; cannot establish a baseline")
    counts = Counter(m["severity"] for m in messages)
    for key, severity in (("errs", "error"), ("warnings", "warning"), ("hints", "information")):
        actual = counts[severity] + (counts["fatal"] if severity == "error" else 0)
        if key in summary and summary[key] != actual:
            raise ValueError(f"{source}: {key} summary {summary[key]} differs from issues {actual}; artifacts may be incomplete or from different builds")
    normalized = Counter(json.dumps({k: normalize(v, summary.get("ig-ver")) for k, v in m.items()},
                                    ensure_ascii=False, sort_keys=True) for m in messages)
    metadata.update({"source": str(source), "sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
                     "counts": dict(counts), "total": len(messages)})
    return normalized, metadata


def records(counter):
    return [dict(json.loads(key), count=count) for key, count in sorted(counter.items())]


def compare(before, after):
    old, baseline_metadata = load(before)
    new, after_metadata = load(after)
    groups = {"new": new - old, "resolved": old - new, "unchanged": old & new}
    return {"normalization": NORMALIZATION, "baseline": baseline_metadata, "after": after_metadata,
            "counts": {name: {"occurrences": sum(group.values()), "distinct": len(group),
                              "by_severity": dict(sum((Counter({json.loads(k)["severity"]: v}) for k, v in group.items()), Counter()))}
                       for name, group in groups.items()},
            **{name: records(group) for name, group in groups.items()}}


def markdown(result):
    lines = ["# Publisher QA comparison", "", "| Category | Occurrences | Distinct |", "|---|---:|---:|"]
    for name, counts in result["counts"].items():
        lines.append(f"| {name} | {counts['occurrences']} | {counts['distinct']} |")
    lines += ["", "## Normalization", ""] + ["- " + rule for rule in NORMALIZATION]
    for group in ("new", "resolved", "unchanged"):
        lines += ["", "## " + group, ""]
        if not result[group]:
            lines.append("None.")
        for message in result[group]:
            lines += [f"- **{message['severity']} ×{message['count']}** `{message['message_id'] or '(no message ID)'}` — `{message['file']}`",
                      f"  - Location: `{message['location']}`", "  - " + message["text"]]
    return "\n".join(lines) + "\n"


def main():
    check_normalization()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("baseline")
    parser.add_argument("after")
    parser.add_argument("--output", type=Path, required=True, help="Output prefix; .json and .md are appended")
    args = parser.parse_args()
    result = compare(args.baseline, args.after)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    Path(str(args.output) + ".json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    Path(str(args.output) + ".md").write_text(markdown(result))
    print(json.dumps(result["counts"], ensure_ascii=False))


if __name__ == "__main__":
    main()
