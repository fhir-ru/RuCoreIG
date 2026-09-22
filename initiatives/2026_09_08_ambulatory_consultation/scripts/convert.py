#!/usr/bin/env python3
"""Example-scoped CDA R5-edition consultation -> FHIR R5 experiment.

No NLP, identity repair, or production conversion claims. Every source scalar is
accounted for in trace.json, including values intentionally kept only in reports.
"""
import argparse
import base64
import csv
import hashlib
import html
import json
import re
from collections import Counter
from pathlib import Path
from uuid import NAMESPACE_URL, uuid5

from lxml import etree as E

ROOT = Path(__file__).resolve().parents[1]
CORE = 'https://fhir.ru/ig/core/'
SD = CORE + 'StructureDefinition/'
CS = CORE + 'CodeSystem/core-cs-'
DAR = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason'
NS = {'cda': 'urn:hl7-org:v3', 'identity': 'urn:hl7-ru:identity',
      'address': 'urn:hl7-ru:address', 'fias': 'urn:hl7-ru:fias',
      'medService': 'urn:hl7-ru:medService', 'xsi': 'http://www.w3.org/2001/XMLSchema-instance'}
PREFIX = {v: k for k, v in NS.items()}
NORMALIZE = {
    '1.2.643.5.1.13.13.11.1039': CS + 'nsi-sources-of-payment',
    '1.2.643.5.1.13.13.11.1002': CS + 'nsi-medical-workers-positions',
    '1.2.643.5.1.13.13.99.2.48': CS + 'nsi-identity-document',
    '1.2.643.5.1.13.13.11.1504': CS + 'nsi-address-type',
    '1.2.643.5.1.13.13.99.2.206': CS + 'nsi-region-rf',
    '1.2.643.5.1.13.13.11.1070': CS + 'nsi-medical-services',
    '1.2.643.5.1.13.13.11.1077': CS + 'nsi-diagnosis-nosology-kind',
    '1.2.643.5.1.13.13.99.2.795': CS + 'nsi-diagnosis-justification-degree',
    '1.2.643.5.1.13.13.99.2.724': CS + 'nsi-coverage-document',
}


def qname(tag):
    q = E.QName(tag)
    return PREFIX.get(q.namespace, 'ns') + ':' + q.localname if q.namespace else q.localname


def xpath(el):
    parts = []
    while el is not None:
        parent = el.getparent()
        siblings = [x for x in parent if x.tag == el.tag] if parent is not None else [el]
        parts.append(qname(el.tag) + '[' + str(siblings.index(el) + 1) + ']')
        el = parent
    return '/' + '/'.join(reversed(parts))


def one(el, path):
    return el.find(path, NS) if el is not None else None


def many(el, path):
    return el.findall(path, NS) if el is not None else []


def absent(reason='unknown'):
    return {'extension': [{'url': DAR, 'valueCode': reason}]}


def ts(value):
    """Preserve supplied precision and timezone; reject unsupported CDA TS."""
    m = re.fullmatch(r'(\d{4})(\d{2})?(\d{2})?(?:(\d{2})(\d{2})(\d{2})?([+-]\d{4}|Z))?', value)
    if not m:
        raise ValueError('Unsupported CDA TS: ' + value)
    y, mo, d, h, mi, sec, zone = m.groups()
    out = y + ('-' + mo if mo else '') + ('-' + d if d else '')
    if h:
        out += 'T' + h + ':' + mi + ':' + (sec or '00')
        out += zone if zone == 'Z' else zone[:3] + ':' + zone[3:]
    return out


class Conversion:
    def __init__(self, source, assembled_at):
        self.raw = source.read_bytes()
        self.doc = E.fromstring(self.raw, E.XMLParser(remove_comments=True, resolve_entities=False, no_network=True))
        self.assembled_at = assembled_at
        if one(self.doc, 'cda:templateId').get('root') != '1.2.643.5.1.13.13.15.13.5':
            raise ValueError('This prototype supports consultation edition 5 only')
        self.trace = {}
        self.resources = []
        self.locations = {}
        for el in self.doc.iter():
            for attr, value in el.attrib.items():
                self.add_scalar(el, '@' + qname(attr), value)
            if el.text and el.text.strip():
                self.add_scalar(el, 'text()', el.text.strip())
            if el.tail and el.tail.strip():
                self.add_scalar(el, 'following-sibling::text()[1]', el.tail.strip())

    def add_scalar(self, el, suffix, value):
        key = xpath(el) + '/' + suffix
        self.trace[key] = {'xpath': key, 'line': el.sourceline, 'value': value,
                           'status': 'report-only', 'targets': [], 'rule': 'GAP: no structured rule; source retained'}

    def mark(self, el, attr, target, rule, status='mapped'):
        if el is None:
            return
        suffix = attr if attr in ('text()', 'following-sibling::text()[1]') else '@' + qname(attr)
        row = self.trace.get(xpath(el) + '/' + suffix)
        if row:
            row['status'] = status
            row['rule'] = rule
            if target and target not in row['targets']:
                row['targets'].append(target)

    def scalar(self, el, attr, target, rule='copy', transform=None):
        if el is None:
            return None
        value = (el.text or '').strip() if attr == 'text()' else el.get(attr)
        if value is None:
            return None
        self.mark(el, attr, target, rule)
        return transform(value) if transform else value

    def subtree(self, el, target, rule, status):
        if el is None:
            return
        for x in el.iter():
            for a in x.attrib:
                self.mark(x, a, target, rule, status)
            for a in ('text()', 'following-sibling::text()[1]'):
                self.mark(x, a, target, rule, status)

    def resource(self, kind, el, suffix='', profile=None):
        identifier = str(uuid5(NAMESPACE_URL, 'rucore-consultation-experiment:' + kind + ':' + xpath(el) + ':' + suffix))
        r = {'resourceType': kind, 'id': identifier}
        if profile:
            r['meta'] = {'profile': [SD + profile]}
        self.resources.append(r)
        self.locations[id(r)] = kind + '/' + identifier + '#'
        return r

    def loc(self, r):
        return self.locations[id(r)]

    def ref(self, r):
        return {'reference': 'urn:uuid:' + r['id']}

    def code(self, el, target, retain_original=True):
        if el is None:
            return {'text': 'Не указан в исходном CDA'}
        if el.get('nullFlavor'):
            nf = el.get('nullFlavor')
            self.mark(el, 'nullFlavor', target + '/extension', 'CDA NullFlavor -> data-absent-reason')
            return absent({'NA': 'not-applicable', 'OTH': 'unsupported'}.get(nf, 'unknown'))
        codings = []
        for node in [el] + many(el, 'cda:translation'):
            dest = target + '/coding/' + str(len(codings))
            system = self.scalar(node, 'codeSystem', dest + '/system', 'OID -> canonical RuCore URI or urn:oid',
                                 lambda x: NORMALIZE.get(x, 'urn:oid:' + x))
            c = {'system': system, 'code': self.scalar(node, 'code', dest + '/code')}
            for src, dst in [('displayName', 'display')]:
                if node.get(src):
                    c[dst] = self.scalar(node, src, dest + '/' + dst)
            normalized = node.get('codeSystem') in NORMALIZE
            if node.get('codeSystemVersion') and not normalized:
                c['version'] = self.scalar(node, 'codeSystemVersion', dest + '/version')
            codings.append({k: v for k, v in c.items() if v is not None})
            if normalized and retain_original:
                # NSI edition is not the version of the RuCore CodeSystem.
                original_dest = target + '/coding/' + str(len(codings))
                original = dict(c)
                original['system'] = 'urn:oid:' + node.get('codeSystem')
                for src, dst in [('codeSystem', 'system'), ('code', 'code'), ('displayName', 'display')]:
                    self.mark(node, src, original_dest + '/' + dst, 'retain original NSI coding alongside canonical RuCore coding')
                if node.get('codeSystemVersion'):
                    original['version'] = self.scalar(node, 'codeSystemVersion', original_dest + '/version', 'NSI edition belongs to source OID coding')
                codings.append(original)
        out = {'coding': codings}
        if one(el, 'cda:originalText') is not None:
            out['text'] = self.scalar(one(el, 'cda:originalText'), 'text()', target + '/text')
        return out

    def identifier(self, el, target, semantic=None, system=None):
        if el.get('nullFlavor'):
            self.mark(el, 'nullFlavor', target + '/_value/extension', 'absent source identifier value')
            return {'_value': absent()}
        root = self.scalar(el, 'root', target + '/system', 'OID namespace -> URI')
        value = self.scalar(el, 'extension', target + '/value')
        if value is None:
            # A root-only II names the object, not its namespace.
            system, value = 'urn:ietf:rfc:3986', 'urn:oid:' + root
            self.mark(el, 'root', target + '/value', 'root-only II -> globally unique URI identifier')
        out = {'system': system or 'urn:oid:' + root, 'value': value}
        if semantic:
            out['type'] = {'coding': [{'system': CS + 'semd-identifier-type', 'code': semantic}]}
        if el.get('assigningAuthorityName'):
            out['assigner'] = {'display': self.scalar(el, 'assigningAuthorityName', target + '/assigner/display')}
        return out

    def date_field(self, r, key, el, dest=None):
        if el is None:
            return
        target = dest or self.loc(r) + '/' + key
        if el.get('nullFlavor'):
            reason = {'NA': 'not-applicable'}.get(el.get('nullFlavor'), 'unknown')
            r['_' + key] = absent(reason)
            self.mark(el, 'nullFlavor', target.rsplit('/', 1)[0] + '/_' + key + '/extension', 'NullFlavor on primitive')
        elif el.get('value'):
            r[key] = self.scalar(el, 'value', target, 'CDA TS -> FHIR temporal value (minute precision padded with :00)', ts)

    def period(self, el, target):
        out = {}
        for src, dst in [('low', 'start'), ('high', 'end')]:
            node = one(el, 'cda:' + src)
            if node is None:
                node = one(el, 'identity:' + src)
            self.date_field(out, dst, node, target + '/' + dst)
        return out

    def name(self, el, target):
        out = {'use': 'official'}
        out['family'] = self.scalar(one(el, 'cda:family'), 'text()', target + '/family')
        out['given'] = []
        for x in many(el, 'cda:given') + many(el, 'identity:Patronymic'):
            out['given'].append(self.scalar(x, 'text()', target + '/given/' + str(len(out['given']))))
        return out

    def telecom(self, el, target):
        value = el.get('value', '')
        scheme, sep, tail = value.partition(':')
        if scheme not in ('tel', 'mailto') or not sep:
            raise ValueError('Unsupported contact: ' + value)
        out = {'system': {'tel': 'phone', 'mailto': 'email'}[scheme],
               'value': self.scalar(el, 'value', target + '/value', 'URI -> ContactPoint', lambda _: tail)}
        self.mark(el, 'value', target + '/system', 'URI scheme -> ContactPoint.system')
        if el.get('use'):
            out['use'] = self.scalar(el, 'use', target + '/use', 'CDA contact use', lambda x: {'WP': 'work', 'HP': 'home', 'MC': 'mobile'}[x])
        return out

    def address(self, el, target):
        out = {}
        for src, dst in [('cda:streetAddressLine', 'text'), ('cda:postalCode', 'postalCode')]:
            node = one(el, src)
            if node is not None:
                out[dst] = self.scalar(node, 'text()', target + '/' + dst)
        ext = []
        for src, name in [('address:Type', 'address-type'), ('address:stateCode', 'regionRF')]:
            node = one(el, src)
            if node is not None:
                ext.append({'url': SD + name, 'valueCodeableConcept': self.code(node, target + '/extension/' + str(len(ext)) + '/valueCodeableConcept')})
        fias = one(el, 'fias:Address')
        if fias is not None:
            nested = []
            for name in ['AOGUID', 'HOUSEGUID']:
                node = one(fias, 'fias:' + name)
                if node is not None:
                    dest = target + '/extension/' + str(len(ext)) + '/extension/' + str(len(nested))
                    nested.append({'url': name.lower(), 'valueIdentifier': {'system': 'urn:hl7-ru:fias:' + name.lower(),
                        'value': self.scalar(node, 'text()', dest + '/valueIdentifier/value')}})
            if nested:
                ext.append({'url': SD + 'fias', 'extension': nested})
        if ext:
            out['extension'] = ext
        return out

    def organization(self, el):
        r = self.resource('Organization', el, profile='core-organization'); dest = self.loc(r)
        r['name'] = self.scalar(one(el, 'cda:name'), 'text()', dest + '/name')
        r['identifier'] = []
        for node in many(el, 'cda:id'):
            root = node.get('root', '')
            target = dest + '/identifier/' + str(len(r['identifier']))
            if root.startswith('1.2.643.5.1.13.13.12.2.'):
                # Distinct contextual organizations retained; conflicting identities not merged.
                r['identifier'].append({'system': CORE + 'systems/frmo', 'value': self.scalar(node, 'root', target + '/value', 'FRMO organization OID')})
                if node.get('extension'):
                    target = dest + '/identifier/' + str(len(r['identifier']))
                    r['identifier'].append(self.identifier(node, target))
            elif root == '1.2.643.5.1.13.2.1.1.1504.101':
                q = {'code': {'text': 'Лицензия на осуществление медицинской деятельности'},
                     'identifier': [self.identifier(node, dest + '/qualification/0/identifier/0', system=CORE + 'systems/medlicense')]}
                r['qualification'] = [q]
            else:
                r['identifier'].append(self.identifier(node, target))
        props = one(el, 'identity:Props')
        for tag, system in [('Ogrn', 'ogrn'), ('Okpo', 'okpo')]:
            node = one(props, 'identity:' + tag)
            if node is not None:
                target = dest + '/identifier/' + str(len(r['identifier']))
                r['identifier'].append({'system': CORE + 'systems/' + system, 'value': self.scalar(node, 'text()', target + '/value')})
        okato = one(props, 'identity:Okato')
        if okato is not None:
            r['extension'] = [{'url': SD + 'okato', 'valueCodeableConcept': {'coding': [{'system': CS + 'nsi-okato',
                'code': self.scalar(okato, 'text()', dest + '/extension/0/valueCodeableConcept/coding/0/code')}]}}]
        contact = {}
        if many(el, 'cda:telecom'):
            contact['telecom'] = [self.telecom(x, dest + '/contact/0/telecom/' + str(i)) for i, x in enumerate(many(el, 'cda:telecom'))]
        if one(el, 'cda:addr') is not None:
            contact['address'] = self.address(one(el, 'cda:addr'), dest + '/contact/0/address')
        if contact:
            r['contact'] = [contact]
        return r

    def actor(self, el, fallback_org=None):
        role = self.resource('PractitionerRole', el); dest = self.loc(role)
        ids = many(el, 'cda:id'); role['identifier'] = []
        valid = True
        for node in ids:
            if node.get('root', '').endswith('.70'):
                root = node.get('root', '')
                valid &= bool(re.fullmatch(r'[0-2](\.(0|[1-9][0-9]*))+\.70', root))
                role['identifier'].append(self.identifier(node, dest + '/identifier/' + str(len(role['identifier'])), 'mis-practitioner-role'))
        if valid:
            role['meta'] = {'profile': [SD + 'core-practitionerrole']}
        code = one(el, 'cda:code')
        if code is not None:
            role['code'] = [self.code(code, dest + '/code/0')]
        person = one(el, 'cda:assignedPerson')
        if person is None:
            person = one(el, 'cda:associatedPerson')
        if person is not None:
            pr = self.resource('Practitioner', person, profile='core-practitioner'); pd = self.loc(pr)
            pr['name'] = [self.name(one(person, 'cda:name'), pd + '/name/0')]
            pr['identifier'] = [self.identifier(x, pd + '/identifier/0', system=CORE + 'systems/snils') for x in ids if x.get('root') == '1.2.643.100.3']
            if one(el, 'cda:addr') is not None:
                pr['address'] = [self.address(one(el, 'cda:addr'), pd + '/address/0')]
            role['practitioner'] = self.ref(pr)
        if many(el, 'cda:telecom'):
            role['contact'] = [{'telecom': [self.telecom(x, dest + '/contact/0/telecom/' + str(i)) for i, x in enumerate(many(el, 'cda:telecom'))]}]
        org = one(el, 'cda:representedOrganization')
        if org is None:
            org = one(el, 'cda:scopingOrganization')
        if org is not None:
            role['organization'] = self.ref(self.organization(org))
        elif fallback_org is not None:
            role['organization'] = self.ref(fallback_org)
        return role

    def policy_id(self, node, target, patient=True):
        codings = ([{'system': CS + 'semd-identifier-type', 'code': 'oms-policy'}] if patient else [])
        codings.append({'system': CS + 'nsi-coverage-document', 'code': '1'})
        c = self.code(one(node, 'identity:InsurancePolicyType'), target + '/type')
        # Rebase the source targets from standalone concept coding to combined types.
        for row in self.trace.values():
            row['targets'] = [t.replace(target + '/type/coding/0', target + '/type/coding/' + str(len(codings))) for t in row['targets']]
        codings.extend(c.get('coding', []))
        series = self.scalar(one(node, 'identity:Series'), 'text()', target + '/value', 'series + space + number')
        number = self.scalar(one(node, 'identity:Number'), 'text()', target + '/value', 'series + space + number')
        return {'system': CORE + 'systems/oms', 'value': ' '.join(x for x in [series, number] if x), 'type': {'coding': codings}}

    def quantity(self, el, target):
        out = {'value': self.scalar(el, 'value', target + '/value', 'decimal', lambda x: float(x))}
        if el.get('unit'):
            out['unit'] = self.scalar(el, 'unit', target + '/unit', 'literal source unit; no silent UCUM repair')
            # CDA units are nominally UCUM, but the sample includes kg/m^2.
            unit = el.get('unit')
            if unit != 'kg/m^2':
                out['system'] = 'http://unitsofmeasure.org'; out['code'] = unit
                self.mark(el, 'unit', target + '/code', 'CDA PQ UCUM unit')
        for tr in many(el, 'cda:translation'):
            index = len(out.setdefault('extension', []))
            dest = target + '/extension/' + str(index) + '/valueQuantity'
            translated = {'value': self.scalar(tr, 'value', dest + '/value', 'translated quantity', float),
                          'system': self.scalar(tr, 'codeSystem', dest + '/system', 'original unit code system', lambda x: 'urn:oid:' + x),
                          'code': self.scalar(tr, 'code', dest + '/code'),
                          'unit': self.scalar(tr, 'displayName', dest + '/unit')}
            out['extension'].append({'url': 'http://hl7.org/fhir/StructureDefinition/iso21090-PQ-translation', 'valueQuantity': translated})
        return out

    def narrative(self, el, target):
        def transform(node):
            tag = E.QName(node).localname
            tags = {'text': 'div', 'paragraph': 'p', 'content': 'span', 'list': 'ul', 'item': 'li', 'linkHtml': 'a'}
            name = tags.get(tag, tag)
            if tag == 'list' and node.get('listType') == 'ordered':
                name = 'ol'
            if name not in {'div', 'p', 'span', 'ul', 'ol', 'li', 'a', 'table', 'thead', 'tbody', 'tfoot', 'tr', 'td', 'th', 'br', 'caption', 'sup', 'sub'}:
                name = 'span'
            out = E.Element('{http://www.w3.org/1999/xhtml}' + name, nsmap={None: 'http://www.w3.org/1999/xhtml'} if tag == 'text' else None)
            out.text = node.text
            for key, value in node.attrib.items():
                if key in ('colspan', 'rowspan', 'href', 'ID'):
                    out.set('id' if key == 'ID' else key, value)
            for child in node:
                c = transform(child); out.append(c); c.tail = child.tail
            return out
        self.subtree(el, target, 'CDA narrative -> XHTML; text/order/tables retained; presentation attributes may differ', 'narrative')
        return {'status': 'additional', 'div': E.tostring(transform(el), encoding='unicode')}

    def document_reference(self, el, code=None, description=None):
        r = self.resource('DocumentReference', el); dest = self.loc(r)
        # Status is the lifecycle of this newly created reference record, not
        # the clinical status (docStatus) of the unavailable source document.
        r['status'] = 'current'; r['subject'] = self.ref(self.patient)
        r['identifier'] = [self.identifier(x, dest + '/identifier/' + str(i)) for i, x in enumerate(many(el, 'cda:id'))]
        if code is not None:
            r['type'] = self.code(code, dest + '/type')
        if description is not None:
            r['description'] = self.scalar(description, 'text()', dest + '/description')
        r['content'] = [{'attachment': {'extension': [{'url': DAR, 'valueCode': 'unknown'}],
                                       'title': 'Ссылка из CDA; содержимое документа не включено в источник'}}]
        return r

    def observation(self, el, time=None):
        r = self.resource('Observation', el); dest = self.loc(r)
        r['status'] = 'unknown'; r['subject'] = self.ref(self.patient); r['encounter'] = self.ref(self.encounter)
        r['code'] = self.code(one(el, 'cda:code'), dest + '/code')
        date = one(el, 'cda:effectiveTime')
        if date is None:
            date = time
        if date is not None:
            if many(date, 'cda:low'):
                r['effectivePeriod'] = self.period(date, dest + '/effectivePeriod')
            else:
                self.date_field(r, 'effectiveDateTime', date)
        txt = one(el, 'cda:text')
        if txt is not None:
            r['note'] = [{'text': self.scalar(txt, 'text()', dest + '/note/0/text')}]
        val = one(el, 'cda:value')
        if val is not None:
            typ = val.get('{' + NS['xsi'] + '}type')
            if val.get('nullFlavor'):
                r['dataAbsentReason'] = {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/data-absent-reason',
                    'code': {'NA': 'not-applicable'}.get(val.get('nullFlavor'), 'unknown')}]}
                self.mark(val, 'nullFlavor', dest + '/dataAbsentReason', 'CDA NullFlavor -> observation dataAbsentReason')
            elif typ == 'CD':
                r['valueCodeableConcept'] = self.code(val, dest + '/valueCodeableConcept')
            elif typ == 'ST':
                r['valueString'] = self.scalar(val, 'text()', dest + '/valueString')
            elif typ == 'BL':
                r['valueBoolean'] = self.scalar(val, 'value', dest + '/valueBoolean', 'CDA boolean', lambda x: {'true': True, 'false': False}[x])
            elif typ == 'PQ':
                r['valueQuantity'] = self.quantity(val, dest + '/valueQuantity')
            else:
                raise ValueError('Unsupported observation type ' + str(typ))
        for i, node in enumerate(many(el, 'cda:id')):
            # .52 is a document-local reference key; it must not become a business identifier.
            self.subtree(node, dest + '/id', 'CDA local key -> contextual deterministic resource id; original key in trace', 'transformed')
        members = []
        for relation in many(el, 'cda:entryRelationship'):
            child = one(relation, 'cda:observation')
            if child is not None:
                members.append(self.ref(self.observation(child)))
                self.mark(relation, 'typeCode', dest + '/hasMember/' + str(len(members) - 1), 'CDA COMP -> associated component observation; exact relation in trace', 'transformed')
        if members:
            r['hasMember'] = members
        performers = many(el, 'cda:performer/cda:assignedEntity')
        if performers:
            r['performer'] = [self.ref(self.actor(x)) for x in performers]
        docs = many(el, 'cda:reference/cda:externalDocument')
        if docs:
            r['derivedFrom'] = [self.ref(self.document_reference(x)) for x in docs]
        return r

    def section(self, el, target):
        out = {'code': self.code(one(el, 'cda:code'), target + '/code'),
               'title': self.scalar(one(el, 'cda:title'), 'text()', target + '/title')}
        if one(el, 'cda:text') is not None:
            out['text'] = self.narrative(one(el, 'cda:text'), target + '/text/div')
        else:
            # This official example has no section/text. Generate a readable view
            # from entries without pretending that it was supplied narrative.
            items = []
            for entry in many(el, 'cda:entry'):
                for node in entry.iter():
                    tag = E.QName(node).localname
                    if tag in ('code', 'value') and node.get('displayName'):
                        items.append(node.get('displayName'))
                    if node.text and node.text.strip():
                        items.append(node.text.strip())
                    if tag in ('value', 'doseQuantity', 'period') and node.get('value'):
                        items.append(node.get('value') + (' ' + node.get('unit') if node.get('unit') else ''))
            out['text'] = {'status': 'generated', 'div': '<div xmlns="http://www.w3.org/1999/xhtml">' +
                (''.join('<p>' + html.escape(x) + '</p>' for x in items) or '<p>См. вложенные разделы.</p>') + '</div>'}
        entries = []
        kind = one(el, 'cda:code').get('code')
        for entry in many(el, 'cda:entry'):
            node = next(iter(entry))
            if kind == 'DGN':
                r = self.resource('Condition', node); dest = self.loc(r)
                r['subject'] = self.ref(self.patient); r['encounter'] = self.ref(self.encounter)
                r['clinicalStatus'] = {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/condition-clinical', 'code': 'unknown'}]}
                r['code'] = self.code(one(node, 'cda:value'), dest + '/code')
                r['code']['text'] = self.scalar(one(node, 'cda:text'), 'text()', dest + '/code/text')
                # effectiveTime here is date of diagnosis, not onset of disease.
                self.date_field(r, 'recordedDate', one(node, 'cda:effectiveTime'))
                i = len(self.encounter.setdefault('diagnosis', [])); dd = self.loc(self.encounter) + '/diagnosis/' + str(i)
                dg = {'condition': [{'reference': self.ref(r)}], 'use': [self.code(one(node, 'cda:code'), dd + '/use/0', retain_original=False)]}
                for rel in many(node, 'cda:entryRelationship'):
                    o = one(rel, 'cda:observation')
                    if one(o, 'cda:code').get('code') == '7026':
                        dg['use'].append(self.code(one(o, 'cda:value'), dd + '/use/1', retain_original=False))
                        self.subtree(one(o, 'cda:code'), dd + '/use/1', 'field discriminator: diagnosis justification', 'technical')
                    else:
                        extra = self.observation(o); extra['focus'] = [self.ref(r)]; entries.append(self.ref(extra))
                self.encounter['diagnosis'].append(dg); entries.append(self.ref(r))
            elif kind == 'SERVICES':
                r = self.resource('Procedure', node, profile='core-procedure'); dest = self.loc(r)
                r['status'] = 'completed'; r['subject'] = self.ref(self.patient); r['encounter'] = self.ref(self.encounter)
                value = one(node, 'cda:entryRelationship/cda:observation/cda:value')
                r['code'] = self.code(value, dest + '/code')
                r['occurrencePeriod'] = self.period(one(node, 'cda:effectiveTime'), dest + '/occurrencePeriod')
                r['performer'] = [{'actor': self.ref(self.actor(x))} for x in many(node, 'cda:performer/cda:assignedEntity')]
                # No identifier-based resolution to author: source .70 is ambiguous.
                self.subtree(one(node, 'cda:code'), dest + '/status', 'performed services section -> completed procedure', 'transformed')
                entries.append(self.ref(r))
            elif kind == 'REGIME':
                r = self.resource('CarePlan', node); dest = self.loc(r)
                r['status'] = 'unknown'; r['intent'] = 'proposal'; r['subject'] = self.ref(self.patient); r['encounter'] = self.ref(self.encounter)
                r['description'] = self.scalar(one(node, 'cda:value'), 'text()', dest + '/description', 'recommendation text retained; no drug/dose NLP')
                self.subtree(one(node, 'cda:code'), dest + '/description', 'CDA textual-description field discriminator', 'technical')
                entries.append(self.ref(r))
            elif kind == 'DRUG':
                r = self.resource('MedicationStatement', node); dest = self.loc(r)
                r['status'] = 'recorded'; r['subject'] = self.ref(self.patient); r['encounter'] = self.ref(self.encounter)
                material = one(node, 'cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code')
                r['medication'] = {'concept': self.code(material, dest + '/medication/concept')}
                times = many(node, 'cda:effectiveTime')
                r['effectivePeriod'] = self.period(times[0], dest + '/effectivePeriod')
                dosage = {'doseAndRate': [{'doseQuantity': self.quantity(one(node, 'cda:doseQuantity'), dest + '/dosage/0/doseAndRate/0/doseQuantity')}]}
                interval = one(times[1], 'cda:period')
                dosage['timing'] = {'repeat': {'frequency': 1,
                    'period': self.scalar(interval, 'value', dest + '/dosage/0/timing/repeat/period', 'CDA periodic interval', float),
                    'periodUnit': self.scalar(interval, 'unit', dest + '/dosage/0/timing/repeat/periodUnit')}}
                pre = one(node, 'cda:precondition/cda:criterion/cda:value')
                dosage['patientInstruction'] = self.scalar(pre, 'text()', dest + '/dosage/0/patientInstruction')
                route = one(node, 'cda:routeCode')
                if route is not None:
                    dosage['route'] = self.code(route, dest + '/dosage/0/route')
                r['dosage'] = [dosage]
                form = one(node, 'cda:administrationUnitCode')
                medication = self.resource('Medication', material)
                medication['code'] = self.code(material, self.loc(medication) + '/code')
                medication['doseForm'] = self.code(form, self.loc(medication) + '/doseForm')
                r['medication']['reference'] = self.ref(medication)
                entries.append(self.ref(r))
            elif kind == 'ALL':
                r = self.resource('AllergyIntolerance', node); dest = self.loc(r)
                r['patient'] = self.ref(self.patient); r['encounter'] = self.ref(self.encounter)
                substance = one(node, 'cda:participant/cda:participantRole/cda:playingEntity')
                r['code'] = {'text': self.scalar(one(substance, 'cda:desc'), 'text()', dest + '/code/text')}
                original_code = one(substance, 'cda:code')
                if original_code is not None and original_code.get('nullFlavor'):
                    r['code']['extension'] = [{'url': 'http://hl7.org/fhir/StructureDefinition/iso21090-nullFlavor',
                        'valueCode': self.scalar(original_code, 'nullFlavor', dest + '/code/extension/0/valueCode')}]
                symptom = one(node, 'cda:entryRelationship/cda:observation/cda:value')
                reaction = {'manifestation': [{'concept': self.code(symptom, dest + '/reaction/0/manifestation/0/concept')}]}
                self.date_field(reaction, 'onset', one(node, 'cda:effectiveTime'), dest + '/reaction/0/onset')
                r['reaction'] = [reaction]
                r['category'] = ['food']
                self.subtree(one(node, 'cda:value'), dest + '/category/0', 'source type food allergy -> category food; original coding in trace', 'transformed')
                entries.append(self.ref(r))
            elif kind == 'LINKDOCS':
                external = one(node, 'cda:reference/cda:externalDocument')
                r = self.document_reference(external, one(node, 'cda:code'), one(node, 'cda:text'))
                entries.append(self.ref(r))
                # Additional form/number fields are explicit observations focused on the document.
                for o in many(node, 'cda:entryRelationship/cda:observation'):
                    obs = self.observation(o); obs['focus'] = [self.ref(r)]; entries.append(self.ref(obs))
            elif E.QName(node).localname == 'organizer':
                group = self.resource('Observation', node, suffix='group'); gd = self.loc(group)
                group['status'] = 'unknown'
                # completed organizer is not necessarily a final clinical result.
                self.subtree(one(node, 'cda:statusCode'), None, 'CDA organizer lifecycle has no exact Observation.status equivalent', 'technical')
                group['code'] = self.code(one(el, 'cda:code'), gd + '/code')
                group['subject'] = self.ref(self.patient); group['encounter'] = self.ref(self.encounter)
                time = one(node, 'cda:effectiveTime'); self.date_field(group, 'effectiveDateTime', time)
                group['hasMember'] = [self.ref(self.observation(o, time)) for o in many(node, 'cda:component/cda:observation')]
                entries.append(self.ref(group))
            else:
                entries.append(self.ref(self.observation(node)))
        if entries:
            out['entry'] = entries
        children = many(el, 'cda:component/cda:section')
        if children:
            out['section'] = [self.section(x, target + '/section/' + str(i)) for i, x in enumerate(children)]
        return out

    def build(self):
        comp = self.resource('Composition', self.doc, profile='core-composition'); cd = self.loc(comp)
        comp['status'] = 'unknown'; comp['type'] = self.code(one(self.doc, 'cda:code'), cd + '/type')
        comp['title'] = self.scalar(one(self.doc, 'cda:title'), 'text()', cd + '/title')
        self.date_field(comp, 'date', one(self.doc, 'cda:effectiveTime'))
        comp['language'] = self.scalar(one(self.doc, 'cda:languageCode'), 'code', cd + '/language')
        comp['identifier'] = [self.identifier(one(self.doc, 'cda:setId'), cd + '/identifier/0', 'mis-document-set')]
        comp['version'] = self.scalar(one(self.doc, 'cda:versionNumber'), 'value', cd + '/version')
        security = self.code(one(self.doc, 'cda:confidentialityCode'), cd + '/meta/security-wrapper')
        comp['meta']['security'] = security['coding']
        for row in self.trace.values():
            row['targets'] = [t.replace('/meta/security-wrapper/coding', '/meta/security') for t in row['targets']]
        pat = one(self.doc, 'cda:recordTarget/cda:patientRole')
        self.patient = self.resource('Patient', pat, profile='core-patient'); pr = self.patient; pd = self.loc(pr)
        pr['identifier'] = []
        for node in many(pat, 'cda:id'):
            snils = node.get('root') == '1.2.643.100.3'
            pr['identifier'].append(self.identifier(node, pd + '/identifier/' + str(len(pr['identifier'])),
                'snils' if snils else 'mis-patient', CORE + 'systems/snils' if snils else None))
        identity = one(pat, 'identity:IdentityDoc'); it = pd + '/identifier/' + str(len(pr['identifier']))
        docid = {'system': CORE + 'systems/identity-document', 'type': self.code(one(identity, 'identity:IdentityCardType'), it + '/type')}
        docid['type']['coding'].append({'system': CS + 'semd-identifier-type', 'code': 'identity-document'})
        docid['value'] = ' '.join(self.scalar(one(identity, 'identity:' + x), 'text()', it + '/value', 'series + space + number') for x in ['Series', 'Number'])
        docid['assigner'] = {'display': self.scalar(one(identity, 'identity:IssueOrgName'), 'text()', it + '/assigner/display')}
        # Agreed Russian-passport convention (APP-01); do not generalize to other documents.
        if one(identity, 'identity:IdentityCardType').get('code') == '1':
            issue_date = one(identity, 'identity:IssueDate')
            if issue_date is not None:
                docid['period'] = {}
                self.date_field(docid['period'], 'start', issue_date, it + '/period/start')
        issue_code = one(identity, 'identity:IssueOrgCode')
        if issue_code is not None:
            docid['assigner']['identifier'] = {
                'system': CORE + 'systems/ns-division-code',
                'value': self.scalar(issue_code, 'text()', it + '/assigner/identifier/value')}

        pr['identifier'].append(docid)
        pr['identifier'].append(self.policy_id(one(pat, 'identity:InsurancePolicy'), pd + '/identifier/' + str(len(pr['identifier']))))
        person = one(pat, 'cda:patient')
        pr['name'] = [self.name(one(person, 'cda:name'), pd + '/name/0')]
        gender = one(person, 'cda:administrativeGenderCode')
        pr['gender'] = self.scalar(gender, 'code', pd + '/gender', 'NSI sex -> FHIR administrative gender', lambda x: {'1': 'male', '2': 'female', '3': 'unknown'}[x])
        self.date_field(pr, 'birthDate', one(person, 'cda:birthTime'))
        pr['address'] = [self.address(x, pd + '/address/' + str(i)) for i, x in enumerate(many(pat, 'cda:addr'))]
        pr['telecom'] = [self.telecom(x, pd + '/telecom/' + str(i)) for i, x in enumerate(many(pat, 'cda:telecom'))]
        org = self.organization(one(pat, 'cda:providerOrganization'))
        comp['subject'] = [self.ref(pr)]
        comp['author'] = [self.ref(self.actor(one(self.doc, 'cda:author/cda:assignedAuthor')))]
        cust = one(self.doc, 'cda:custodian/cda:assignedCustodian/cda:representedCustodianOrganization')
        comp['custodian'] = self.ref(self.organization(cust))
        auth = one(self.doc, 'cda:legalAuthenticator')
        party = self.actor(one(auth, 'cda:assignedEntity'))
        att = {'mode': {'coding': [{'system': 'http://hl7.org/fhir/composition-attestation-mode', 'code': 'legal'}]}, 'party': self.ref(party)}
        self.date_field(att, 'time', one(auth, 'cda:time'), cd + '/attester/0/time'); comp['attester'] = [att]
        enc = one(self.doc, 'cda:componentOf/cda:encompassingEncounter')
        self.encounter = self.resource('Encounter', enc, profile='core-encounter'); er = self.encounter; ed = self.loc(er)
        er['status'] = 'unknown'; er['subject'] = self.ref(pr); er['serviceProvider'] = self.ref(org)
        # Consultation R5, U1-22: .15 identifies the encounter; .16/.17 identifies the chart.
        er['identifier'] = []
        for node in many(enc, 'cda:id'):
            suffix = node.get('root', '').rsplit('.', 1)[-1]
            if suffix == '15':
                er['identifier'].append(self.identifier(node, ed + '/identifier/' + str(len(er['identifier'])), 'mis-encounter'))
            elif suffix in ('16', '17'):
                if 'partOf' in er:
                    raise ValueError('Multiple chart identifiers require an explicit mapping decision')
                target = ed + '/partOf/identifier'
                chart = self.identifier(node, target)
                chart['type'] = self.code(one(enc, 'cda:code'), target + '/type')
                chart['type']['coding'].append({'system': CS + 'semd-identifier-type',
                    'code': 'mis-inpatient-record' if suffix == '16' else 'mis-ambulatory-encounter'})
                er['partOf'] = {'type': 'Encounter', 'identifier': chart}
            else:
                raise ValueError('Unrecognized encounter identifier namespace: ' + node.get('root', ''))
        er['actualPeriod'] = self.period(one(enc, 'cda:effectiveTime'), ed + '/actualPeriod')
        comp['encounter'] = self.ref(er)
        event = one(self.doc, 'cda:documentationOf/cda:serviceEvent')
        # service event vs encounter may differ. Keep separate Procedure with source period.
        service = self.resource('Procedure', event, suffix='consultation'); sd = self.loc(service)
        service['status'] = 'completed'; service['subject'] = self.ref(pr); service['encounter'] = self.ref(er)
        service['code'] = self.code(one(event, 'cda:code'), sd + '/code')
        service['occurrencePeriod'] = self.period(one(event, 'cda:effectiveTime'), sd + '/occurrencePeriod')
        er['class'] = [self.code(one(event, 'medService:serviceCond'), ed + '/class/0')]
        er['priority'] = self.code(one(event, 'medService:serviceForm'), ed + '/priority')
        er['serviceType'] = [{'concept': self.code(one(event, 'medService:serviceType'), ed + '/serviceType/0/concept')}]
        service['performer'] = []
        for i, x in enumerate(many(event, 'cda:performer')):
            actor = self.actor(one(x, 'cda:assignedEntity'))
            perf = {'actor': self.ref(actor), 'function': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/v3-ParticipationType',
                'code': self.scalar(x, 'typeCode', sd + '/performer/' + str(i) + '/function/coding/0/code')}]}}
            service['performer'].append(perf)
        admin = [self.ref(service)]
        admin_sections = []
        admin_index = len(many(self.doc, 'cda:component/cda:structuredBody/cda:component/cda:section'))

        def context(title, resource, source_el=None):
            index = len(admin_sections)
            admin_sections.append({'title': title, 'entry': [self.ref(resource)],
                'text': {'status': 'generated', 'div': '<div xmlns="http://www.w3.org/1999/xhtml"><p>' + html.escape(title) + '</p></div>'}})
            if source_el is not None:
                self.mark(source_el, 'typeCode', cd + '/section/' + str(admin_index) + '/section/' + str(index) + '/entry/0',
                          'CDA participation role -> explicitly labeled document context subsection', 'transformed')
        for recipient in many(self.doc, 'cda:informationRecipient/cda:intendedRecipient/cda:receivedOrganization'):
            context('Получатель документа', self.organization(recipient))
        for participant in many(self.doc, 'cda:participant'):
            ent = one(participant, 'cda:associatedEntity')
            if participant.get('typeCode') == 'IND':
                cv = self.resource('Coverage', ent, profile='core-coverage'); vd = self.loc(cv)
                # Newly constructed, unverified resource; not a statement that
                # insurance was active on the encounter or conversion date.
                cv['status'] = 'draft'; cv['kind'] = 'insurance'; cv['beneficiary'] = self.ref(pr)
                cv['type'] = self.code(one(ent, 'cda:code'), vd + '/type')
                info = one(ent, 'identity:DocInfo')
                cv['identifier'] = [self.policy_id(info, vd + '/identifier/0', patient=False)]
                cv['period'] = self.period(one(info, 'identity:effectiveTime'), vd + '/period')
                insurer = self.organization(one(ent, 'cda:scopingOrganization'))
                inn = one(info, 'identity:INN'); target = self.loc(insurer) + '/identifier/' + str(len(insurer['identifier']))
                insurer['identifier'].append({'system': CORE + 'systems/inn', 'type': {'coding': [{'system': 'http://terminology.hl7.org/CodeSystem/v2-0203', 'code': 'TAX'}]},
                    'value': self.scalar(inn, 'text()', target + '/value')})
                cv['insurer'] = self.ref(insurer)
                context('Источник оплаты консультации', cv, participant)
            else:
                actor = self.actor(ent); context('Направившее лицо', actor, participant)
        for order in many(self.doc, 'cda:inFulfillmentOf/cda:order'):
            context('Документ направления', self.document_reference(order, one(order, 'cda:code')))
        comp['section'] = [self.section(x, cd + '/section/' + str(i)) for i, x in enumerate(many(self.doc, 'cda:component/cda:structuredBody/cda:component/cda:section'))]
        comp['section'].append({'title': 'Контекст исходного CDA (раздел добавлен преобразователем)',
            'text': {'status': 'generated', 'div': '<div xmlns="http://www.w3.org/1999/xhtml"><p>Документируемое событие и исходный CDA. Источник оплаты, получатель и направившее лицо выделены во вложенных подразделах.</p></div>'}, 'entry': admin, 'section': admin_sections})
        # Byte-exact source retained separately, not counted as structured coverage.
        source = self.resource('DocumentReference', self.doc, suffix='source')
        source['status'] = 'current'; source['subject'] = self.ref(pr)
        source['description'] = 'Исходный учебный XML из руководства СЭМД 227, редакция 5; без исправлений'
        source['content'] = [{'attachment': {'contentType': 'application/xml', 'data': base64.b64encode(self.raw).decode()}}]
        comp['section'][-1]['entry'].append(self.ref(source))
        for key, row in self.trace.items():
            if row['status'] != 'report-only':
                continue
            attr = key.rsplit('/@', 1)[-1]
            if attr in ['classCode', 'moodCode', 'determinerCode', 'xsi:type', 'typeCode', 'codeSystemName']:
                row.update(status='technical', rule='CDA structural/type/dictionary-label metadata; exact value in trace/source')
            if '/cda:realmCode[' in key or '/cda:typeId[' in key or '/cda:templateId[' in key:
                row.update(status='technical', rule='CDA conformance metadata; not a FHIR meta.profile')
        def clean(v):
            if isinstance(v, dict):
                return {k: clean(x) for k, x in v.items() if x is not None and x != [] and x != {}}
            if isinstance(v, list):
                return [clean(x) for x in v]
            return v
        bundle = {'resourceType': 'Bundle', 'id': str(uuid5(NAMESPACE_URL, hashlib.sha256(self.raw).hexdigest())),
            'meta': {'profile': [SD + 'core-bundle']}, 'type': 'document',
            'identifier': self.identifier(one(self.doc, 'cda:id'), 'Bundle#/identifier', 'mis-document'),
            'timestamp': self.assembled_at, 'entry': [{'fullUrl': 'urn:uuid:' + r['id'], 'resource': clean(r)} for r in self.resources]}
        # Every narrative resource gets a minimal generated summary; original section text remains additional.
        for entry in bundle['entry']:
            r = entry['resource']
            if 'text' not in r:
                name = r.get('title') or r.get('description') or r.get('resourceType')
                if not isinstance(name, str): name = r['resourceType']
                r['text'] = {'status': 'generated', 'div': '<div xmlns="http://www.w3.org/1999/xhtml"><p>' + html.escape(name) + '</p></div>'}
        return bundle


def run(source, output, assembled_at):
    c = Conversion(source, assembled_at); bundle = c.build()
    output.mkdir(parents=True, exist_ok=True)
    (output / 'consultation-bundle.json').write_text(json.dumps(bundle, ensure_ascii=False, indent=2) + '\n')
    trace = list(c.trace.values())
    for i, row in enumerate(trace, 1):
        row['id'] = f'amb-map-{i:04}'
    (output / 'trace.json').write_text(json.dumps(trace, ensure_ascii=False, indent=2) + '\n')
    with (output / 'mapping.tsv').open('w') as f:
        writer = csv.writer(f, delimiter='\t', lineterminator='\n')
        writer.writerow(['id', 'source_xpath', 'source_line', 'source_value', 'status', 'FHIR_targets', 'rule'])
        for row in trace:
            writer.writerow([row['id'], row['xpath'], row['line'], row['value'], row['status'], '; '.join(row['targets']), row['rule']])
    stats = {'source_sha256': hashlib.sha256(c.raw).hexdigest(), 'source_values': len(trace),
             'coverage': dict(Counter(x['status'] for x in trace)),
             'resources': dict(Counter(e['resource']['resourceType'] for e in bundle['entry'])),
             'resource_count': len(bundle['entry']), 'source_sections': len(c.doc.findall('.//cda:section', NS))}
    (output / 'summary.json').write_text(json.dumps(stats, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(stats, ensure_ascii=False))


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--source', type=Path, default=ROOT / 'source/consultation.xml')
    ap.add_argument('--output', type=Path, default=ROOT / 'examples')
    ap.add_argument('--assembled-at', default=json.loads((ROOT / 'source/manifest.json').read_text())['assembled_at'])
    args = ap.parse_args()
    run(args.source, args.output, args.assembled_at)
