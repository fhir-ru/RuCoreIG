#!/usr/bin/env python3
"""Validate the frozen example with its supplied XSD and flat XPath2 Schematron.

The supplied .sch has one rule per pattern, no abstract rules/lets/phases.
Compile these rules to XSLT 3 using SaxonC; bind unprefixed element names to CDA.
This adapter is deliberately restricted to that schema shape and fails otherwise.
"""
import json
import tempfile
from pathlib import Path
from zipfile import ZipFile

from lxml import etree as E
from saxonche import PySaxonProcessor

ROOT = Path(__file__).resolve().parents[1]
SCH = 'http://purl.oclc.org/dsdl/schematron'
XSL = 'http://www.w3.org/1999/XSL/Transform'


def main():
    reports = ROOT / 'reports'
    reports.mkdir(exist_ok=True)
    source = ROOT / 'source/consultation.xml'
    result = {}
    with tempfile.TemporaryDirectory(prefix='amb-source-') as tmp:
        with ZipFile(ROOT / 'source/package.zip') as z:
            for item in z.infolist():
                if not Path(tmp, item.filename).resolve().is_relative_to(Path(tmp).resolve()):
                    raise ValueError('Archive path escapes extraction directory')
            z.extractall(tmp)
        package = next(Path(tmp).iterdir())
        schema = E.XMLSchema(E.parse(str(next(package.glob('xsd/XSD_CDA*/CDA.xsd')))))
        xml = E.parse(str(source))
        result['xsd'] = {'valid': schema.validate(xml), 'errors': [str(e) for e in schema.error_log]}
        sch = E.parse(str(next(package.glob('schematron/*.sch'))))
        allowed = {'schema', 'ns', 'pattern', 'rule', 'assert'}
        if any(E.QName(e).localname not in allowed for e in sch.iter() if isinstance(e.tag, str)):
            raise ValueError('Unsupported Schematron construct')
        patterns = sch.findall('{' + SCH + '}pattern')
        if any(len(p.findall('{' + SCH + '}rule')) != 1 or p.attrib for p in patterns):
            raise ValueError('Expected exactly one simple rule per pattern')
        ns = {'xsl': XSL}
        for e in sch.findall('{' + SCH + '}ns'):
            ns[e.get('prefix')] = e.get('uri')
        style = E.Element('{' + XSL + '}stylesheet', nsmap=ns, version='3.0',
                          attrib={'xpath-default-namespace': 'urn:hl7-org:v3'})
        template = E.SubElement(style, '{' + XSL + '}template', match='/')
        report = E.SubElement(template, 'schematron-report')
        assertions = 0
        for i, pattern in enumerate(patterns):
            rule = pattern[0]; context = rule.get('context')
            select = context if context.startswith('/') else '//' + context
            node = E.SubElement(report, 'rule', index=str(i + 1), context=context)
            count = E.SubElement(node, '{' + XSL + '}attribute', name='contexts')
            E.SubElement(count, '{' + XSL + '}value-of', select='count(' + select + ')')
            loop = E.SubElement(node, '{' + XSL + '}for-each', select=select)
            for assertion in rule:
                if not isinstance(assertion.tag, str):
                    continue
                assertions += 1
                cond = E.SubElement(loop, '{' + XSL + '}if', test='not(' + assertion.get('test') + ')')
                fail = E.SubElement(cond, 'failure', test=assertion.get('test'))
                loc = E.SubElement(fail, '{' + XSL + '}attribute', name='location')
                E.SubElement(loc, '{' + XSL + '}value-of', select='path()')
                E.SubElement(fail, '{' + XSL + '}text').text = ''.join(assertion.itertext())
        with PySaxonProcessor(license=False) as proc:
            xslt = proc.new_xslt30_processor().compile_stylesheet(stylesheet_text=E.tostring(style, encoding='unicode'))
            output = xslt.transform_to_string(source_file=str(source.resolve()))
            negative = E.parse(str(source))
            negative.getroot().remove(negative.find('{urn:hl7-org:v3}templateId'))
            negative_path = Path(tmp) / 'negative.xml'
            negative.write(str(negative_path), encoding='utf-8')
            negative_output = xslt.transform_to_string(source_file=str(negative_path))
            negative_failures = len(E.fromstring(negative_output.encode()).findall('.//failure'))
            result['negative_control'] = {'mutation': 'remove ClinicalDocument.templateId',
                                          'schematron_failures': negative_failures,
                                          'passed': negative_failures > 0}
        (reports / 'source-schematron.xml').write_text(output)
        parsed = E.fromstring(output.encode())
        result['schematron'] = {
            'engine': 'SaxonC-HE; flat-schema adapter with xpath-default-namespace=urn:hl7-org:v3',
            'rules': len(patterns), 'assertions': assertions,
            'matched_rules': sum(int(r.get('contexts')) > 0 for r in parsed),
            'matched_contexts': sum(int(r.get('contexts')) for r in parsed),
            'failures': [{'location': f.get('location'), 'test': f.get('test'), 'message': f.text} for f in parsed.findall('.//failure')],
        }
        result['schematron']['valid'] = not result['schematron']['failures']
    (reports / 'source-validation.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print('XSD:', result['xsd']['valid'], 'Schematron failures:', len(result['schematron']['failures']))
    if not (result['xsd']['valid'] and result['schematron']['valid'] and result['negative_control']['passed']):
        raise SystemExit(1)


if __name__ == '__main__':
    main()
