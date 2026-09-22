#!/usr/bin/env python3
"""Capture an already published FHIR CI build and verify its source fingerprints.

Does not trigger builds. Requires expected version and generated directory from
an immutable source commit. Metadata records evidence; the CI has no SHA stamp.
"""
import argparse
import concurrent.futures
import datetime
import hashlib
import json
from pathlib import Path
import urllib.request

BASE = 'https://build.fhir.org/ig/fhir-ru/RuCoreIG/'
FILES = ['qa.json', 'qa.xml', 'qa.txt', 'qa.html', 'build.log', 'qa-txservers.html']
PROFILES = ['StructureDefinition-core-coverage.json', 'StructureDefinition-core-patient.json']
EXAMPLES = ['Patient-example-core-patient-oms-no-kind.json', 'Patient-example-core-patient-oms-oid.json']


def fetch(name):
    request = urllib.request.Request(BASE + name, headers={'Cache-Control': 'no-cache'})
    with urllib.request.urlopen(request, timeout=40) as response:
        return response.read(), response.headers.get('Last-Modified')


def fingerprint(resource):
    if resource['resourceType'] == 'StructureDefinition':
        # Publisher inserts an unconstrained root element; ignore only that scaffolding.
        return {'element': [e for e in resource['differential']['element']
                            if not (set(e) == {'id', 'path'} and '.' not in e['path'])]}
    if resource['resourceType'] == 'CodeSystem':
        return {k: resource.get(k) for k in ['url', 'content', 'concept', 'description']}
    return {k: v for k, v in resource.items() if k not in ['text', 'meta']}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('output', type=Path)
    parser.add_argument('--version', required=True)
    parser.add_argument('--commit', required=True)
    parser.add_argument('--generated', type=Path, required=True)
    args = parser.parse_args()
    initial, _ = fetch('qa.json')
    qa = json.loads(initial)
    if qa['ig-ver'] != args.version:
        raise SystemExit(f"Not ready: published {qa['ig-ver']} at {qa.get('date')}; expected {args.version}")
    args.output.mkdir(parents=True, exist_ok=True)
    expected = PROFILES + [p.name for p in args.generated.glob('CodeSystem-*.json')]
    expected += [name for name in EXAMPLES if (args.generated / name).exists()]
    names = FILES + expected
    manifest = {'base': BASE, 'expected_source_commit': args.commit, 'expected_version': args.version,
                'captured_at': datetime.datetime.now(datetime.timezone.utc).isoformat(), 'files': {},
                'source_evidence': 'Expected version plus exact profile differential / CodeSystem content / example fingerprints; autobuilder does not publish commit SHA.'}
    matches = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        futures = {pool.submit(fetch, name): name for name in names}
        for future in concurrent.futures.as_completed(futures):
            name = futures[future]
            try:
                data, modified = future.result()
                (args.output / name).write_bytes(data)
                record = {'sha256': hashlib.sha256(data).hexdigest(), 'bytes': len(data), 'last_modified': modified}
                if name in expected:
                    actual = fingerprint(json.loads(data))
                    wanted = fingerprint(json.loads((args.generated / name).read_text()))
                    record['matches_expected_source'] = actual == wanted
                    matches.append(record['matches_expected_source'])
                manifest['files'][name] = record
            except Exception as exc:
                manifest['files'][name] = {'error': str(exc)}
                matches.append(False)
    final, _ = fetch('qa.json')
    stable = json.loads(final) == qa and json.loads((args.output / 'qa.json').read_text()) == qa
    manifest['stable_qa_during_capture'] = stable
    manifest['verified'] = stable and bool(matches) and all(matches)
    (args.output / 'capture.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'verified': manifest['verified'], 'version': qa['ig-ver'], 'errors': qa['errs'], 'warnings': qa['warnings'], 'hints': qa['hints']}))
    if not manifest['verified']:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
