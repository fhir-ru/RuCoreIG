#!/usr/bin/env python3
"""Semantic/reproducibility checks independent of the FHIR validator."""
import base64
import hashlib
import json
from collections import Counter
from pathlib import Path
from zipfile import ZipFile

from lxml import etree as E

from convert import Conversion, NS, ROOT, SD, ts


def main():
    source = ROOT / 'source/consultation.xml'
    manifest = json.loads((ROOT / 'source/manifest.json').read_text())
    archive = ROOT / 'source/package.zip'
    assert hashlib.sha256(archive.read_bytes()).hexdigest() == manifest['archive_sha256']
    assert hashlib.sha256(source.read_bytes()).hexdigest() == manifest['source_xml_sha256']
    with ZipFile(archive) as z:
        assert z.read(manifest['archive_root'] + '/xml/Протокол консультации.xml') == source.read_bytes()
    c = Conversion(source, manifest['assembled_at'])
    result = c.build()
    saved = json.loads((ROOT / 'examples/consultation-bundle.json').read_text())
    assert result == saved, 'Output is not reproducible'
    assert result == Conversion(source, manifest['assembled_at']).build(), 'Repeated conversion changed output'
    trace = json.loads((ROOT / 'examples/trace.json').read_text())
    assert len(trace) == len(c.trace) and len({x['xpath'] for x in trace}) == len(trace)
    for row in trace:
        matches = c.doc.xpath(row['xpath'], namespaces=NS)
        assert len(matches) == 1, ('Ambiguous source XPath', row['xpath'])
        assert str(matches[0]).strip() == row['value'], row['xpath']
    resources = {e['resource']['resourceType'] + '/' + e['resource']['id']: e['resource'] for e in result['entry']}
    urls = {e['fullUrl'] for e in result['entry']}
    assert len(urls) == len(resources) == len(result['entry'])

    def resolve_target(t):
        resource, pointer = t.split('#', 1)
        value = result if resource == 'Bundle' else resources[resource]
        for key in pointer.strip('/').split('/') if pointer else []:
            key = key.replace('~1', '/').replace('~0', '~')
            value = value[int(key)] if isinstance(value, list) else value[key]
        return value

    for row in trace:
        for target in row['targets']:
            try:
                resolve_target(target)
            except (KeyError, IndexError, TypeError) as exc:
                raise AssertionError(('Broken mapping destination', row['id'], target)) from exc
    references = []

    def walk(value):
        if isinstance(value, dict):
            if isinstance(value.get('reference'), str):
                references.append(value['reference'])
                assert value['reference'] in urls, value['reference']
            for child in value.values():
                walk(child)
        elif isinstance(value, list):
            for child in value:
                walk(child)
    walk(result)
    encounter = next(r for r in resources.values() if r['resourceType'] == 'Encounter')
    by_url = {e['fullUrl']: e['resource'] for e in result['entry']}
    department = by_url[encounter['serviceProvider']['reference']]
    assert department['identifier'] == [{'system': 'https://fhir.ru/ig/core/systems/frmo-department',
                                        'value': '1.2.643.5.1.13.13.12.2.77.7831.0.107531'}]
    parent = by_url[department['partOf']['reference']]
    assert any(i['system'] == 'https://fhir.ru/ig/core/systems/frmo' and
               i['value'] == '1.2.643.5.1.13.13.12.2.77.7831' for i in parent['identifier'])
    assert 'name' not in department and parent['name']
    assert not any(i['system'].endswith('/frmo-department') for i in parent['identifier'])
    # Removing only the provider's subdivision yields a direct link to the same MO.
    alternate = Conversion(source, manifest['assembled_at'])
    provider_id = alternate.doc.xpath('cda:recordTarget/cda:patientRole/cda:providerOrganization/cda:id', namespaces=NS)[0]
    del provider_id.attrib['extension']
    alternate_bundle = alternate.build()
    alternate_urls = {e['fullUrl']: e['resource'] for e in alternate_bundle['entry']}
    alternate_encounter = next(r for r in alternate_urls.values() if r['resourceType'] == 'Encounter')
    alternate_provider = alternate_urls[alternate_encounter['serviceProvider']['reference']]
    assert alternate_provider['id'] == parent['id']
    assert not any(i['system'].endswith('/frmo-department') for i in alternate_provider['identifier'])
    assert [(i['system'].rsplit('.', 1)[-1], i['value']) for i in encounter['identifier']] == [('15', '5469-16')]
    chart = encounter['partOf']['identifier']
    assert encounter['partOf']['type'] == 'Encounter' and 'reference' not in encounter['partOf']
    assert chart['system'].endswith('.17') and chart['value'] == '5499-16'
    assert any(c['system'] == 'urn:oid:1.2.643.5.1.13.13.99.2.723' and c['code'] == '1' and c['version'] == '1.1' for c in chart['type']['coding'])
    assert not any(r['resourceType'] == 'EpisodeOfCare' for r in resources.values())
    assert sum(r['resourceType'] == 'Encounter' for r in resources.values()) == 1
    patient = next(r for r in resources.values() if r['resourceType'] == 'Patient')
    passport = next(i for i in patient['identifier'] if i.get('system', '').endswith('/identity-document'))
    assert passport['period']['start'] == '2005-02-18'
    assert passport['assigner']['identifier'] == {'system': 'https://fhir.ru/ig/core/systems/ns-division-code', 'value': '770-095'}
    comp = result['entry'][0]['resource']
    assert comp['resourceType'] == 'Composition'
    assert comp['identifier'][0]['system'].endswith('.50')
    assert result['identifier']['system'].endswith('.51')
    assert comp['identifier'][0]['value'] == '163725' and result['identifier']['value'] == '144632'
    assert comp['version'] == '1'
    assert 'date' not in comp and comp['_date']['extension'][0]['valueCode'] == 'not-applicable'
    assert result['timestamp'] == manifest['assembled_at']
    assert ts('202305021530+0300') == '2023-05-02T15:30:00+03:00'
    assert ts('20230502') == '2023-05-02'
    assert ts('202305') == '2023-05'
    all_resources = list(resources.values())
    original = next(r for r in all_resources if r.get('description', '').startswith('Исходный учебный XML'))
    assert base64.b64decode(original['content'][0]['attachment']['data']) == source.read_bytes()
    # Source person collisions must not be collapsed into a single person.
    names = {r['name'][0]['family'] for r in all_resources if r['resourceType'] == 'Practitioner'}
    assert {'Смирнов', 'Иванов', 'Иванова', 'Кузнецов'} <= names
    # Legacy OID is preserved and now conforms to the suffix-only Core constraint.
    legacy = [r for r in all_resources if r['resourceType'] == 'PractitionerRole' and
              any(x.get('system', '').startswith('urn:oid:1.2.643.5.1.13.3.25.') for x in r.get('identifier', []))]
    assert len(legacy) == 1 and legacy[0]['meta']['profile'] == [SD + 'core-practitionerrole']
    # True source observations survive numerically, including clinically suspect pulse unit.
    obs = [r for r in all_resources if r['resourceType'] == 'Observation']
    pulse = next(r for r in obs if any(x.get('code') == '5' and x.get('system', '').endswith('.262') for x in r['code'].get('coding', [])))
    assert pulse['valueQuantity']['value'] == 100 and pulse['valueQuantity']['unit'] == 'Ед/с'
    assert pulse['valueQuantity']['system'] == 'urn:oid:1.2.643.5.1.13.13.11.1358'
    assert pulse['valueQuantity']['code'] == '168'
    assert pulse['valueQuantity']['extension'][0]['valueQuantity']['unit'] == 'U/s'
    # DGN maps to Condition and the two independent Encounter.diagnosis.use axes.
    enc = next(r for r in all_resources if r['resourceType'] == 'Encounter')
    assert len(enc['diagnosis']) == 2 and all(len(x['use']) == 2 for x in enc['diagnosis'])
    for diagnosis, rubric in zip(enc['diagnosis'], ['1', '2']):
        structure, stage = diagnosis['use']
        assert len(structure['coding']) == len(stage['coding']) == 1
        assert structure['coding'][0]['system'].endswith('/core-cs-nsi-diagnosis-nosology-kind')
        assert structure['coding'][0]['code'] == rubric
        assert structure['coding'][0]['version'] == '2.1'
        assert stage['coding'][0]['system'].endswith('/core-cs-nsi-diagnosis-justification-degree')
        assert stage['coding'][0]['code'] == '3' and stage['coding'][0]['version'] == '3.1'
    for row in trace:
        if row['id'] in {'amb-map-1176', 'amb-map-1198', 'amb-map-1214', 'amb-map-1237'}:
            assert row['status'] == 'mapped' and len(row['targets']) == 1
            assert resolve_target(row['targets'][0]) == row['value']
    assert {r['code']['coding'][0]['code'] for r in all_resources if r['resourceType'] == 'Condition'} == {'I11.9', 'H35.0'}
    # Completed treatment and recommendations must not be conflated or parsed with NLP.
    medication = next(r for r in all_resources if r['resourceType'] == 'MedicationStatement')
    assert medication['dosage'][0]['timing']['repeat']['period'] == 12
    repeat = medication['dosage'][0]['timing']['repeat']
    assert repeat['periodUnit'] == 'h' and repeat['frequency'] == 1
    assert repeat['extension'] == [{'url': 'http://hl7.org/fhir/StructureDefinition/timing-exact', 'valueBoolean': True}]
    dose = medication['dosage'][0]['doseAndRate'][0]['doseQuantity']
    assert dose['system'] == 'urn:oid:1.2.643.5.1.13.13.11.1358' and dose['code'] == '293'
    assert dose['value'] == 1 and dose['unit'] == 'шт'
    assert dose['extension'][0]['valueQuantity']['unit'] == '{таблетка}'
    for flag, expected in [('true', False), ('1', False), ('false', True), ('0', True), (None, None)]:
        variant = Conversion(source, manifest['assembled_at'])
        periodic = variant.doc.xpath('//*[@institutionSpecified]', namespaces=NS)[0]
        if flag is None:
            del periodic.attrib['institutionSpecified']
        else:
            periodic.set('institutionSpecified', flag)
        vb = variant.build()
        vm = next(e['resource'] for e in vb['entry'] if e['resource']['resourceType'] == 'MedicationStatement')
        vr = vm['dosage'][0]['timing']['repeat']
        if expected is None:
            assert 'extension' not in vr
        else:
            assert vr['extension'][0]['valueBoolean'] is expected

    assert 'БЕНДАЗОЛ' in medication['medication']['concept']['coding'][0]['display']
    plan = next(r for r in all_resources if r['resourceType'] == 'CarePlan')
    assert 'Бисопролол' in plan['description'] and 'activity' not in plan
    # Every ST text is present in a structured value, description, instruction or exact source.
    for el in c.doc.xpath('//cda:value[@xsi:type="ST"]', namespaces=NS):
        text = (el.text or '').strip()
        assert any(row['value'] == text and row['status'] == 'mapped' for row in trace), text[:80]
    section_count = 0

    def sections(nodes):
        nonlocal section_count
        for section in nodes:
            if 'code' in section:
                section_count += 1
            E.fromstring(section['text']['div'].encode())
            sections(section.get('section', []))
    sections(comp['section'])
    assert section_count == 18
    report = {'passed': True, 'source_values_accounted_for': len(trace),
              'resolvable_mapping_targets': sum(len(r['targets']) for r in trace),
              'internal_references': len(references), 'resources': len(resources),
              'source_sections': section_count, 'coverage': dict(Counter(x['status'] for x in trace)),
              'checks': ['frozen archive/XML identity', 'deterministic output', 'every XPath and target resolves',
                         'reference closure', 'identifier semantics', 'missing dates', 'identity collision preservation',
                         'legacy OID preservation', 'clinical values and units', 'diagnosis axes',
                         'treatment vs recommendation', 'all ST source values mapped', '18 readable sections']}
    (ROOT / 'reports/verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(report, ensure_ascii=False))


if __name__ == '__main__':
    main()
