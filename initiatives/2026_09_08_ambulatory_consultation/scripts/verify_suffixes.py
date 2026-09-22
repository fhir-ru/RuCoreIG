import json,re
from pathlib import Path
base=Path('fsh-generated/resources');checks=[]
for p in base.glob('StructureDefinition-core-*.json'):
 d=json.loads(p.read_text())
 for e in d.get('differential',{}).get('element',[]):
  for c in e.get('constraint',[]):
   exp=c.get('expression','')
   if "system.matches('^urn:oid:" not in exp:continue
   regex=re.search(r"matches\('([^']+)'\)",exp)[1];suffix=re.search(r'\[\.\](\d+)\$',regex)[1]
   cases={f'urn:oid:1.2.643.5.1.13.3.25.77.50.100.1.1.{suffix}':True,f'urn:oid:1.2.643.5.1.13.13.12.2.77.7831.199.1.1.{suffix}':True,f'urn:oid:2.999.{suffix}':True,f'urn:oid:1.02.{suffix}':False,f'urn:oid:1..2.{suffix}':False,f'urn:oid:1.2.{suffix}.1':False,'urn:oid:1.2.99':False,f'http://example.org/{suffix}':False}
   for value,expected in cases.items():assert bool(re.fullmatch(regex,value))==expected,(c['key'],value)
   checks.append({'invariant':c['key'],'expression':exp,'cases':len(cases),'passed':True})
assert len(checks)==7
Path('initiatives/2026_09_08_ambulatory_consultation/reports/rucore-0.24.0/suffix-checks.json').write_text(json.dumps(checks,ensure_ascii=False,indent=2)+'\n')
b=json.loads(Path('initiatives/2026_09_08_ambulatory_consultation/examples/consultation-bundle.json').read_text())
r=next(e['resource'] for e in b['entry'] if e['resource']['resourceType']=='PractitionerRole' and any(i['system'].startswith('urn:oid:1.2.643.5.1.13.3.25.') for i in e['resource']['identifier']))
for label,value in [('alternate','urn:oid:2.999.199.1.1.70'),('wrong-suffix','urn:oid:2.999.71')]:
 q={'resourceType':'PractitionerRole','id':label,'meta':r['meta'],'identifier':[dict(r['identifier'][0],system=value)]}
 Path('/tmp/semd-'+label+'.json').write_text(json.dumps(q))
print('7 invariants, 56 cases passed')
