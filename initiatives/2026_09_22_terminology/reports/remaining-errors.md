# Оставшиеся ошибки Publisher 0.21.0

Все 49 ошибок по существу присутствовали в baseline 0.20.0. Они сохранены для следующей самостоятельной работы; данная итерация не объявляет весь IG валидным. Полные сообщения — [qa.xml](after/qa.xml), [qa.txt](after/qa.txt).

| Message ID | Количество |
|---|---:|
| Type_Specific_Checks_DT_URL_Resolve | 17 |
| Reference_REF_CantResolve | 8 |
| Display_Name_for__should_be_one_of__instead_of | 6 |
| Unknown_Code_in_Version | 3 |
| Validation_VAL_Profile_Minimum | 3 |
| http://hl7.org/fhir/StructureDefinition/CareTeam#ctm-1 | 2 |
| (без message-id) | 2 |
| TYPE_SPECIFIC_CHECKS_DT_ATT_SIZE_CORRECT | 1 |
| TYPE_SPECIFIC_CHECKS_DT_ATT_HASH_MISMATCH | 1 |
| Terminology_TX_NoValid_1_CC | 1 |
| Extension_EXTP_Context_Wrong | 1 |
| Extension_EXT_Type | 1 |
| Validation_VAL_Profile_Minimum_SLICE | 1 |
| Validation_VAL_Profile_Maximum | 1 |
| http://hl7.org/fhir/StructureDefinition/Procedure#prc-1 | 1 |

## Сообщения

- **Type_Specific_Checks_DT_URL_Resolve** — Appointment/example-core-appointment-ivanov-consultation: Appointment.specialty[0].coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/c80-practice-codes'
- **Display_Name_for__should_be_one_of__instead_of** — Appointment/example-core-appointment-ivanov-consultation: Appointment.appointmentType.coding[0].display
  Wrong Display Name 'Routine' for http://terminology.hl7.org/CodeSystem/v2-0276#ROUTINE. Valid display is 'Routine appointment - default if not valued' (for the language(s) 'en-US')
- **Type_Specific_Checks_DT_URL_Resolve** — Appointment/example-core-appointment-ivanov-consultation-min: Appointment.specialty[0].coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/c80-practice-codes'
- **Display_Name_for__should_be_one_of__instead_of** — Appointment/example-core-appointment-ivanov-consultation-min: Appointment.appointmentType.coding[0].display
  Wrong Display Name 'Routine' for http://terminology.hl7.org/CodeSystem/v2-0276#ROUTINE. Valid display is 'Routine appointment - default if not valued' (for the language(s) 'en-US')
- **http://hl7.org/fhir/StructureDefinition/CareTeam#ctm-1** — CareTeam/example-core-careteam-ivanov: CareTeam.participant[0]
  Constraint failed: ctm-1: 'CareTeam.participant.onBehalfOf can only be populated when CareTeam.participant.member is a Practitioner (onBehalfOf.exists() implies (member.resolve() is Practitioner))' (defined in http://hl7.org/fhir/StructureDefinition/CareTeam)
- **Type_Specific_Checks_DT_URL_Resolve** — CareTeam/example-core-careteam-ivanov: CareTeam.participant[0].role.coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/participant-role'
- **http://hl7.org/fhir/StructureDefinition/CareTeam#ctm-1** — CareTeam/example-core-careteam-ivanov: CareTeam.participant[1]
  Constraint failed: ctm-1: 'CareTeam.participant.onBehalfOf can only be populated when CareTeam.participant.member is a Practitioner (onBehalfOf.exists() implies (member.resolve() is Practitioner))' (defined in http://hl7.org/fhir/StructureDefinition/CareTeam)
- **Type_Specific_Checks_DT_URL_Resolve** — CareTeam/example-core-careteam-ivanov: CareTeam.participant[1].role.coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/participant-role'
- **Type_Specific_Checks_DT_URL_Resolve** — CareTeam/example-core-careteam-ivanov-min: CareTeam.participant[0].role.coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/participant-role'
- **Type_Specific_Checks_DT_URL_Resolve** — Composition/example-core-composition-ivanov-consultation: Composition.category[0].coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/document-classcodes'
- **Display_Name_for__should_be_one_of__instead_of** — Composition/example-core-composition-ivanov-consultation: Composition.section[0].code.coding[0].display
  Wrong Display Name 'Chief complaint' for http://loinc.org#46239-0. Valid display is one of 3 choices: 'Chief complaint+Reason for visit Narrative' (en-US), 'Chief complaint+Reason for visit Narrative' (en-US) or 'Chief complaint+Reason for visit' (en-US) (for the language(s) 'en-US')
- **Display_Name_for__should_be_one_of__instead_of** — Composition/example-core-composition-ivanov-consultation: Composition.section[1].code.coding[0].display
  Wrong Display Name 'Vital signs' for http://loinc.org#8716-3. Valid display is one of 3 choices: 'Vital signs note' (en-US), 'Vital signs note' (en-US) or 'Vital signs note' (en-US) (for the language(s) 'en-US')
- **Type_Specific_Checks_DT_URL_Resolve** — Coverage/example-core-coverage-ivanov-oms: Coverage.costToBeneficiary[0].type.coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/benefit-category'
- **Unknown_Code_in_Version** — Coverage/example-core-coverage-ivanov-oms: Coverage.costToBeneficiary[0].value.ofType(Quantity).code
  Unknown code 'RUB' in the CodeSystem 'http://unitsofmeasure.org' version '2.2'
- **Reference_REF_CantResolve** — DiagnosticReport/example-core-diagnosticreport-ivanov-blood: DiagnosticReport.specimen[0]
  Unable to resolve resource with reference 'Specimen/example-core-specimen-ivanov-blood'
- **Reference_REF_CantResolve** — DiagnosticReport/example-core-diagnosticreport-ivanov-blood: DiagnosticReport.result[0]
  Unable to resolve resource with reference 'Observation/example-core-observation-ivanov-hemoglobin'
- **Reference_REF_CantResolve** — DiagnosticReport/example-core-diagnosticreport-ivanov-blood: DiagnosticReport.result[1]
  Unable to resolve resource with reference 'Observation/example-core-observation-ivanov-leukocytes'
- **Reference_REF_CantResolve** — DiagnosticReport/example-core-diagnosticreport-ivanov-blood: DiagnosticReport.study[0]
  Unable to resolve resource with reference 'ImagingStudy/example-core-imagingstudy-ivanov-chest'
- **Reference_REF_CantResolve** — DiagnosticReport/example-core-diagnosticreport-ivanov-blood: DiagnosticReport.media[0].link
  Unable to resolve resource with reference 'Media/example-core-media-ivanov-blood-smear'
- **TYPE_SPECIFIC_CHECKS_DT_ATT_SIZE_CORRECT** — DiagnosticReport/example-core-diagnosticreport-ivanov-blood: DiagnosticReport.presentedForm[0]
  Stated Attachment Size 24,576 does not match actual attachment size 9
- **TYPE_SPECIFIC_CHECKS_DT_ATT_HASH_MISMATCH** — DiagnosticReport/example-core-diagnosticreport-ivanov-blood: DiagnosticReport.presentedForm[0]
  The hash of the data did not match the data (stated: 'MTIzNDU2Nzg5MA==', actual: 'lWB7AtSKeGy3hol9cnEU/HmBSx4=')
- **Unknown_Code_in_Version** — Encounter/example-core-encounter-consultation: Encounter.type[0].coding[0].code
  Unknown code 'CONS' in the CodeSystem 'http://terminology.hl7.org/CodeSystem/encounter-type' version '1.0.1'
- **Unknown_Code_in_Version** — Encounter/example-core-encounter-consultation-min: Encounter.type[0].coding[0].code
  Unknown code 'CONS' in the CodeSystem 'http://terminology.hl7.org/CodeSystem/encounter-type' version '1.0.1'
- **Type_Specific_Checks_DT_URL_Resolve** — HealthcareService/example-core-healthcareservice-therapy: HealthcareService.specialty[0].coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/c80-practice-codes'
- **Reference_REF_CantResolve** — HealthcareService/example-core-healthcareservice-therapy: HealthcareService.coverageArea[0]
  Unable to resolve resource with reference 'Location/example-core-location-moscow'
- **Type_Specific_Checks_DT_URL_Resolve** — HealthcareService/example-core-healthcareservice-therapy: HealthcareService.eligibility[0].code.coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/benefit-category'
- **Display_Name_for__should_be_one_of__instead_of** — HealthcareService/example-core-healthcareservice-therapy: HealthcareService.program[0].coding[0].display
  Wrong Display Name 'ОМС' for http://terminology.hl7.org/CodeSystem/program#1. Valid display is 'Acquired Brain Injury (ABI) Program' (for the language(s) 'en-US')
- **Terminology_TX_NoValid_1_CC** — HealthcareService/example-core-healthcareservice-therapy: HealthcareService.communication[0]
  None of the codings provided are in the value set 'All Languages' (http://hl7.org/fhir/ValueSet/all-languages|5.0.0), and a coding from this value set is required) (codes = http://terminology.hl7.org/CodeSystem/communication#ru)
- **Type_Specific_Checks_DT_URL_Resolve** — HealthcareService/example-core-healthcareservice-therapy: HealthcareService.communication[0].coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/communication'
- **Reference_REF_CantResolve** — HealthcareService/example-core-healthcareservice-therapy: HealthcareService.endpoint[0]
  Unable to resolve resource with reference 'Endpoint/example-core-endpoint-therapy'
- **без ID** — HealthcareService.text.div
  Hyperlink 'Location/example-core-location-moscow' at 'div/p/a' for 'г. Москва' does not resolve
- **без ID** — HealthcareService.text.div
  Hyperlink 'Endpoint/example-core-endpoint-therapy' at 'div/p/a' for 'Электронная регистратура' does not resolve
- **Type_Specific_Checks_DT_URL_Resolve** — Location/example-core-location-therapy-office: Location.type[0].coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/v3-ServiceDeliveryLocationRoleType'
- **Display_Name_for__should_be_one_of__instead_of** — MedicationRequest/example-core-medicationrequest-ivanov-paracetamol: MedicationRequest.medication.concept.coding[0].display
  Wrong Display Name 'Acetaminophen 500 MG Oral Tablet' for http://www.nlm.nih.gov/research/umls/rxnorm#313782. Valid display is one of 3 choices: 'acetaminophen 325 MG Oral Tablet' (en-US), 'APAP 325 MG Oral Tablet' (en-US) or 'acetaminophen 325 MG Oral Tablet' (en-US) (for the language(s) 'en-US')
- **Extension_EXTP_Context_Wrong** — Organization/example-core-organization-polyclinic: Organization.contact[0].address
  The extension https://fhir.ru/ig/core/StructureDefinition/okato v0.21.0 is not allowed to be used at this point (this element is [Address, ExtendedContactDetail.address, Organization.contact.address]; allowed for this version = e:Organization)
- **Validation_VAL_Profile_Minimum** — Organization/example-core-organization-polyclinic-min: Organization.identifier[0]
  Organization.identifier:INN.type: minimum required = 1, but only found 0 (from https://fhir.ru/ig/core/StructureDefinition/core-organization|0.21.0)
- **Extension_EXT_Type** — Patient/example-core-patient-ivanov: Patient.address[0].extension[0]
  The Extension 'https://fhir.ru/ig/core/StructureDefinition/fias' definition allows for the types [] but found type CodeableConcept
- **Validation_VAL_Profile_Minimum** — Patient/example-core-patient-ivanov: Patient.address[0].extension[0]
  Extension.extension: minimum required = 1, but only found 0 (from https://fhir.ru/ig/core/StructureDefinition/fias|0.21.0)
- **Validation_VAL_Profile_Minimum_SLICE** — Patient/example-core-patient-ivanov: Patient.address[0].extension[0]
  Slice 'Extension.extension:aoguid': a matching slice is required, but not found (from https://fhir.ru/ig/core/StructureDefinition/fias|0.21.0). Note that other slices are allowed in addition to this required slice
- **Validation_VAL_Profile_Maximum** — Patient/example-core-patient-ivanov: Patient.address[0].extension[0]
  Extension.value[x]: max allowed = 0, but found 1 (from https://fhir.ru/ig/core/StructureDefinition/fias|0.21.0)
- **Validation_VAL_Profile_Minimum** — Practitioner/example-core-practitioner-smirnov: Practitioner.identifier[1]
  Practitioner.identifier:identityDocument.type: minimum required = 1, but only found 0 (from https://fhir.ru/ig/core/StructureDefinition/core-practitioner|0.21.0)
- **Type_Specific_Checks_DT_URL_Resolve** — PractitionerRole/example-core-practitionerrole-smirnov-therapist: PractitionerRole.specialty[0].coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/c80-practice-codes'
- **Type_Specific_Checks_DT_URL_Resolve** — Procedure/example-core-procedure-ivanov-consultation: Procedure.statusReason.coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/procedure-not-performed-reason'
- **http://hl7.org/fhir/StructureDefinition/Procedure#prc-1** — Procedure/example-core-procedure-ivanov-consultation: Procedure.performer[0]
  Constraint failed: prc-1: 'Procedure.performer.onBehalfOf can only be populated when performer.actor isn't Practitioner or PractitionerRole (onBehalfOf.exists() and actor.resolve().exists() implies actor.resolve().where($this is Practitioner or $this is PractitionerRole).empty())' (defined in http://hl7.org/fhir/StructureDefinition/Procedure)
- **Type_Specific_Checks_DT_URL_Resolve** — Procedure/example-core-procedure-ivanov-consultation: Procedure.performer[0].function.coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/performer-role'
- **Type_Specific_Checks_DT_URL_Resolve** — Procedure/example-core-procedure-ivanov-consultation: Procedure.outcome.coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/procedure-outcome'
- **Type_Specific_Checks_DT_URL_Resolve** — Procedure/example-core-procedure-ivanov-consultation: Procedure.followUp[0].coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/procedure-followup'
- **Type_Specific_Checks_DT_URL_Resolve** — ServiceRequest/example-core-servicerequest-ivanov-consultation: ServiceRequest.category[0].coding[0].system
  No definition could be found for URL value 'http://terminology.hl7.org/CodeSystem/servicerequest-category'
- **Reference_REF_CantResolve** — ServiceRequest/example-core-servicerequest-ivanov-consultation: ServiceRequest.specimen[0]
  Unable to resolve resource with reference 'Specimen/example-core-specimen-ivanov-blood'
