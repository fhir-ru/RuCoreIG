#!/usr/bin/env python3
"""Check RuCore's local terminology publication contract after running SUSHI.

Usage: python3 scripts/check_terminology.py [fsh-generated/resources] [--self-test]
This is an integrity guard, not validation against the original NSI dictionaries.
It deliberately does not enumerate or assert the full external code vocabulary.
"""
import argparse
from collections import Counter
from copy import deepcopy
import json
from pathlib import Path
import re
import sys
import tempfile

CANONICAL = "https://fhir.ru/ig/core"
LOCAL_CS = CANONICAL + "/CodeSystem/"
NSI_CS = LOCAL_CS + "core-cs-nsi-"
SEMANTIC_CS = LOCAL_CS + "core-cs-semd-identifier-type"


def concepts(resource):
    for concept in resource.get("concept", []):
        yield concept
        yield from concepts(concept)


def check(directory, expected_count=15):
    resources = [json.loads(path.read_text()) for path in sorted(Path(directory).glob("*.json"))]
    systems = {r["url"]: r for r in resources if r.get("resourceType") == "CodeSystem"}
    value_sets = {r["url"]: r for r in resources if r.get("resourceType") == "ValueSet"}
    errors = []
    if len(systems) != expected_count:
        errors.append(f"CodeSystem inventory: expected {expected_count}, found {len(systems)}")
    for url, resource in systems.items():
        mode = resource.get("content")
        listed = list(concepts(resource))
        if mode == "not-present" and listed:
            errors.append(f"{url}: not-present contains concepts")
        if "тестовое значение" in json.dumps(resource, ensure_ascii=False).casefold():
            errors.append(f"{url}: placeholder 'тестовое значение'")
        if url.startswith(NSI_CS) and mode == "complete":
            errors.append(f"{url}: external complete without reviewed source evidence; current policy has no approved exceptions")
        if mode == "complete" and url != SEMANTIC_CS:
            errors.append(f"{url}: complete is not an approved locally owned system")
        if mode == "fragment":
            description = resource.get("description", "").casefold()
            if not (re.search(r"границ|scope", description) and re.search(r"сопровожд|maintain", description)):
                errors.append(f"{url}: fragment description must explain scope and maintenance")
            if not listed:
                errors.append(f"{url}: fragment has no concepts")
    if SEMANTIC_CS not in systems or systems[SEMANTIC_CS].get("content") != "complete":
        errors.append("Locally owned semantic identifier CodeSystem must remain complete")

    # Current NSI ValueSets represent entire systems. Enumerating the local fragment
    # would silently narrow their meaning; RelatedPerson's deliberate subset is separate.
    nsi_sets = {u: r for u, r in value_sets.items() if r.get("id", "").startswith("core-vs-nsi-")}
    if not nsi_sets:
        errors.append("No NSI ValueSets found")
    for url, resource in nsi_sets.items():
        compose = resource.get("compose", {})
        includes = compose.get("include", [])
        if len(includes) != 1 or compose.get("exclude"):
            errors.append(f"{url}: expected one whole-system inclusion without exclusions")
        for include in includes:
            system = include.get("system", "")
            if not system.startswith(NSI_CS) or system not in systems:
                errors.append(f"{url}: unknown or noncanonical local NSI system {system}")
            if any(include.get(k) for k in ("concept", "filter", "valueSet")):
                errors.append(f"{url}: inclusion narrowed or redirected instead of all system codes")

    # Verify the two OMS classifications resolve to the same systems throughout
    # Patient/Coverage and their bound ValueSets. The optionality of omsType is
    # orthogonal to a required binding on its code when it is supplied.
    expected = {
        "coverageDocumentType": NSI_CS + "coverage-document",
        "omsType": NSI_CS + "coverage-document-oms",
    }
    profiles = {r.get("id"): r for r in resources if r.get("resourceType") == "StructureDefinition"}
    for profile_id in ("core-patient", "core-coverage"):
        profile = profiles.get(profile_id)
        if not profile:
            errors.append(f"Missing profile {profile_id}")
            continue
        elements = profile.get("differential", {}).get("element", [])
        for slice_name, system in expected.items():
            matches = [e for e in elements if e.get("sliceName") == slice_name]
            if not matches:
                errors.append(f"{profile_id}: missing {slice_name} coding")
            for element in matches:
                coding = element.get("patternCoding", element.get("fixedCoding", {}))
                if coding.get("system") != system:
                    errors.append(f"{profile_id}/{slice_name}: coding system disagrees with canonical {system}")
                if coding.get("code") is not None and coding["code"] not in {c.get("code") for c in concepts(systems.get(system, {}))}:
                    errors.append(f"{profile_id}/{slice_name}: recognition code missing from published local fragment")
                if slice_name == "omsType":
                    code = next((e for e in elements if e.get("id") == element["id"] + ".code"), {})
                    binding = code.get("binding", {})
                    bound = value_sets.get(binding.get("valueSet"), {})
                    bound_systems = {i.get("system") for i in bound.get("compose", {}).get("include", [])}
                    if binding.get("strength") != "required" or bound_systems != {system}:
                        errors.append(f"{profile_id}/{slice_name}: required code binding must resolve to its canonical system")
        if profile_id == "core-coverage":
            binding = next((e.get("binding", {}) for e in elements
                            if e.get("id") == "Coverage.identifier:coverageDocument.type"), {})
            bound = value_sets.get(binding.get("valueSet"), {})
            bound_systems = {i.get("system") for i in bound.get("compose", {}).get("include", [])}
            if binding.get("strength") != "required" or bound_systems != {expected["coverageDocumentType"]}:
                errors.append("core-coverage: document recognition binding must resolve to document CodeSystem")

    return {"passed": not errors, "code_systems": len(systems), "nsi_value_sets": len(nsi_sets),
            "content_counts": dict(Counter(r.get("content", "missing") for r in systems.values())),
            "errors": errors,
            "limits": "Checks publication integrity only; does not verify codes/displays or completeness against source NSI."}


def self_test(directory, expected_count):
    """Real negative controls: mutate frozen copies, never the actual generated files."""
    with tempfile.TemporaryDirectory(prefix="rucore-terminology-check-") as tmp:
        target = Path(tmp)
        for path in Path(directory).glob("*.json"):
            (target / path.name).write_bytes(path.read_bytes())
        baseline = check(target, expected_count)
        if not baseline["passed"]:
            raise ValueError("Self-test requires a passing baseline: " + "; ".join(baseline["errors"]))
        candidates = [(p, json.loads(p.read_text())) for p in target.glob("CodeSystem-*.json")]
        path, original = next((p, r) for p, r in candidates if r.get("url", "").startswith(NSI_CS)
                              and r.get("content") == "not-present")
        mutations = [
            ("placeholder", {"content": "fragment", "concept": [{"code": "SENTINEL", "display": "тестовое значение"}]}),
            ("not-present contains concepts", {"concept": [{"code": "SENTINEL"}]}),
            ("external complete", {"content": "complete"}),
        ]
        passed = []
        for expected_error, mutation in mutations:
            changed = deepcopy(original)
            changed.update(mutation)
            path.write_text(json.dumps(changed, ensure_ascii=False))
            result = check(target, expected_count)
            if not any(expected_error in e for e in result["errors"]):
                raise AssertionError(f"Negative control not detected: {expected_error}")
            passed.append(expected_error)
            path.write_text(json.dumps(original, ensure_ascii=False))
        return passed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", nargs="?", default="fsh-generated/resources")
    parser.add_argument("--expected-count", type=int, default=15, help="Intentional inventory guard; update when adding a reviewed system")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    result = check(args.directory, args.expected_count)
    if args.self_test and result["passed"]:
        result["negative_controls"] = self_test(args.directory, args.expected_count)
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if result["passed"] else 1


if __name__ == "__main__":
    sys.exit(main())
