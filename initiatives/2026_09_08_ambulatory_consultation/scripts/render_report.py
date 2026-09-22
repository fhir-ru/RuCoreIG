#!/usr/bin/env python3
"""Render the frozen generated Bundle for local review, without external assets."""
import html
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
bundle = json.loads((ROOT / 'examples/consultation-bundle.json').read_text())
esc = html.escape
parts = ['<!doctype html><html lang="ru"><meta charset="utf-8">',
         '<title>Эксперимент: протокол консультации</title>',
         '<style>body{font:16px/1.5 system-ui;max-width:1100px;margin:40px auto;padding:0 24px;color:#152536}section{border-left:3px solid #dae4ed;padding-left:20px;margin:24px 0}pre{white-space:pre-wrap;overflow-wrap:anywhere;background:#f3f6f8;padding:16px}a{color:#155ca0}td,th{text-align:left;border-bottom:1px solid #dde;padding:8px}table{border-collapse:collapse;width:100%}</style>',
         '<h1>Протокол консультации: эксперимент СЭМД → FHIR</h1>',
         '<p>СЭМД 227, редакция 5. Это исследовательское представление исходного примера, не официальный документ и не пример подтверждённого соответствия RuCore. Актуальные результаты проверки и её ограничения — в <a href="../gaps.md">списке пробелов</a>.</p>',
         '<p>Narrative сформирована из структурированных entry: исходный XML не содержит section/text. <a href="consultation-bundle.json">Полный Bundle</a> · <a href="mapping.tsv">Маппинг</a> · <a href="../reports/report-only.md">Значения без структурного переноса</a></p>']

def section(s):
    parts.append('<section><h2>' + esc(s.get('title', 'Раздел')) + '</h2>')
    # This XHTML was generated locally by convert.py from escaped source values.
    parts.append(s.get('text', {}).get('div', ''))
    for ref in s.get('entry', []):
        rid = ref.get('reference', '').removeprefix('urn:uuid:')
        parts.append('<p><a href="#' + esc(rid) + '">' + esc(ref.get('display', rid)) + '</a></p>')
    for child in s.get('section', []):
        section(child)
    parts.append('</section>')

for s in bundle['entry'][0]['resource'].get('section', []):
    section(s)
parts.append('<h2>Ресурсы Bundle</h2><p>Вложенный XML в этом просмотре сокращён; в JSON сохранён целиком.</p>')
for entry in bundle['entry']:
    res = json.loads(json.dumps(entry['resource']))
    for c in res.get('content', []):
        if 'data' in c.get('attachment', {}):
            c['attachment']['data'] = '[original XML base64: see consultation-bundle.json]'
    title = res['resourceType'] + '/' + res['id']
    parts.append('<details id="' + esc(res['id']) + '"><summary>' + esc(title) + '</summary><pre>' + esc(json.dumps(res, ensure_ascii=False, indent=2)) + '</pre></details>')
parts.append('</html>')
(ROOT / 'examples/consultation.html').write_text('\n'.join(parts), encoding='utf-8')
