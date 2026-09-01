// Примеры экземпляров для Core профилей и расширений
// Минимальные примеры с только обязательными атрибутами

// ========================================
// ПРИМЕРЫ ПРОФИЛЕЙ
// ========================================

// Пример 1: Core_Patient
Instance: example-core-patient-ivanov-min
InstanceOf: Core_Patient
Title: "Пример пациента - Иван Иванов (минимальный)"
Description: "Минимальный пример пациента с использованием Core_Patient профиля"

* identifier[snils]
  * type = Core_Cs_Semd_Identifier_Type#snils
  * system = "https://fhir.ru/ig/core/systems/snils"
  * value = "123-456-789-01"

* active = true
* name[0]
  * family = "Иванов"
  * given[0] = "Иван"

* gender = #male
* birthDate = "1985-03-15"

// Дополнительный пример Core_Patient по протоколу лабораторного исследования СЭМД, редакция 4
Instance: example-core-patient-laboratory-semd-min
InstanceOf: Core_Patient
Title: "Пример пациента из протокола лабораторного исследования СЭМД"
Description: "Проверочный пример идентификатора пациента в МИС по исходному XML протокола лабораторного исследования СЭМД редакции 4"

* identifier[misPatient]
  * type = Core_Cs_Semd_Identifier_Type#mis-patient
  * system = "urn:oid:1.2.643.5.1.13.13.12.2.77.8312.100.1.1.10"
  * value = "735486"
* name[0]
  * family = "Иванов"
  * given[0] = "Иван"
* gender = #male
* birthDate = "1985-03-15"

// Пример 2: Core_Organization
Instance: example-core-organization-polyclinic-min
InstanceOf: Core_Organization
Title: "Пример организации - Городская поликлиника №1 (минимальный)"
Description: "Минимальный пример медицинской организации с использованием Core_Organization профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/inn"
  * value = "7701234567"

* active = true
* name = "ГБУЗ Городская поликлиника №1"

* contact[0]
  * address
    * city = "Москва"
    * country = "RU"

// Пример 3: Core_Practitioner
Instance: example-core-practitioner-smirnov-min
InstanceOf: Core_Practitioner
Title: "Пример медицинского работника - Александр Смирнов"
Description: "Минимальный пример медицинского работника с использованием Core_Practitioner профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/snils"
  * value = "987-654-321-09"

* active = true
* name[0]
  * family = "Смирнов"
  * given[0] = "Александр"

* gender = #male
* birthDate = "1975-06-20"

// Пример 4: Core_PractitionerRole
Instance: example-core-practitionerrole-smirnov-therapist-min
InstanceOf: Core_PractitionerRole
Title: "Пример роли медицинского работника - Смирнов А.И. терапевт"
Description: "Минимальный пример роли медицинского работника с использованием Core_PractitionerRole профиля"

* active = true
* practitioner
  * reference = "Practitioner/example-core-practitioner-smirnov-min"

* organization
  * reference = "Organization/example-core-organization-polyclinic-min"

* code[0]
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-workers-positions"
    * code = #"01.001"
    * display = "Врач-терапевт участковый"

// Проверочный пример с точной парой root/extension из СЭМД
Instance: example-core-practitionerrole-laboratory-semd-min
InstanceOf: Core_PractitionerRole
Title: "Пример роли автора протокола лабораторного исследования СЭМД"
Description: "Проверочный пример идентификатора роли автора по исходному XML протокола лабораторного исследования СЭМД редакции 4"

* identifier[misPractitionerRole]
  * type = Core_Cs_Semd_Identifier_Type#mis-practitioner-role
  * system = "urn:oid:1.2.643.5.1.13.13.12.2.77.8312.100.1.1.70"
  * value = "542177"

// Пример 5: Core_RelatedPerson
Instance: example-core-relatedperson-ivanov-spouse-min
InstanceOf: Core_RelatedPerson
Title: "Пример связанного лица - супруга Иванова И.П."
Description: "Минимальный пример связанного лица с использованием Core_RelatedPerson профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/snils"
  * value = "111-222-333-44"

* active = true
* patient
  * reference = "Patient/example-core-patient-ivanov-min"

* relationship
  * coding[0]
    * system = "urn:oid:1.2.643.5.1.13.13.11.1021"
    * code = #"1"
    * display = "Супруг(а)"

* name[0]
  * family = "Иванова"
  * given[0] = "Мария"

* gender = #female
* birthDate = "1987-08-12"

// Пример 6: Core_Encounter
Instance: example-core-encounter-consultation-min
InstanceOf: Core_Encounter
Title: "Пример обращения - консультация терапевта"
Description: "Минимальный пример обращения с использованием Core_Encounter профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/encounter"
  * value = "ENC-2024-001"

* status = #completed
* class[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
    * code = #AMB
    * display = "ambulatory"

* type[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/encounter-type"
    * code = #CONS
    * display = "Consultation"

* subject
  * reference = "Patient/example-core-patient-ivanov-min"

* participant[0]
  * type[0]
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
      * code = #ATND
      * display = "attender"
  * actor
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist-min"

* serviceProvider
  * reference = "Organization/example-core-organization-polyclinic-min"

// Дополнительный пример Core_Encounter по выписному эпикризу СЭМД, редакция 6
Instance: example-core-encounter-inpatient-discharge-semd-min
InstanceOf: Core_Encounter
Title: "Пример стационарного случая по выписному эпикризу СЭМД"
Description: "Проверочный пример идентификаторов общего и стационарного случаев по исходному XML выписного эпикриза СЭМД редакции 6"

* identifier[misEncounter]
  * type = Core_Cs_Semd_Identifier_Type#mis-encounter
  * system = "urn:oid:1.2.643.5.1.13.13.12.2.66.6770.100.1.1.15"
  * value = "2120"

* identifier[misInpatientRecord]
  * type = Core_Cs_Semd_Identifier_Type#mis-inpatient-record
  * system = "urn:oid:1.2.643.5.1.13.13.12.2.66.6770.100.1.1.16"
  * value = "2120/23-3"

* status = #completed
* class[0].coding[0]
  * system = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
  * code = #IMP
  * display = "inpatient encounter"

* subject.reference = "Patient/example-core-patient-ivanov-min"
* serviceProvider.reference = "Organization/example-core-organization-polyclinic-min"

* diagnosis[0]
  * extension[rank].valuePositiveInt = 1
  * condition
    * concept
      * coding[0]
        * system = "urn:oid:1.2.643.5.1.13.13.11.1005"
        * code = #I20.8
        * display = "Другие формы стенокардии"
      * text = "Стенокардия"
  * use[diagnosisStructure]
    * coding[0]
      * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-diagnosis-nosology-kind"
      * code = #1
      * display = "Основное заболевание"
  * use[diagnosisStage]
    * coding[0]
      * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-diagnosis-justification-degree"
      * code = #3
      * display = "Заключительный клинический диагноз"

// Дополнительный пример Core_Encounter по протоколу лабораторного исследования СЭМД, редакция 4
Instance: example-core-encounter-laboratory-semd-min
InstanceOf: Core_Encounter
Title: "Пример амбулаторного случая по протоколу лабораторного исследования СЭМД"
Description: "Проверочный пример идентификаторов общего и амбулаторного случаев по исходному XML протокола лабораторного исследования СЭМД редакции 4"

* identifier[misEncounter]
  * type = Core_Cs_Semd_Identifier_Type#mis-encounter
  * system = "urn:oid:1.2.643.5.1.13.13.12.2.77.8312.100.1.1.15"
  * value = "5469-16"

* identifier[misAmbulatoryEncounter]
  * type = Core_Cs_Semd_Identifier_Type#mis-ambulatory-encounter
  * system = "urn:oid:1.2.643.5.1.13.13.12.2.77.8312.100.1.1.17"
  * value = "5316-16"

* status = #completed
* class[0].coding[0]
  * system = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
  * code = #AMB
  * display = "ambulatory"

* subject.reference = "Patient/example-core-patient-ivanov-min"
* serviceProvider.reference = "Organization/example-core-organization-polyclinic-min"

// Пример 7: Core_EpisodeOfCare
Instance: example-core-episodeofcare-ivanov-2024-min
InstanceOf: Core_EpisodeOfCare
Title: "Пример эпизода лечения - Иванов И.П. 2024"
Description: "Минимальный пример эпизода лечения с использованием Core_EpisodeOfCare профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/episode"
  * value = "EP-2024-001"

* status = #active
* patient
  * reference = "Patient/example-core-patient-ivanov-min"

* managingOrganization
  * reference = "Organization/example-core-organization-polyclinic-min"

// Пример 8: Core_CareTeam
Instance: example-core-careteam-ivanov-min
InstanceOf: Core_CareTeam
Title: "Пример бригады - бригада по лечению Иванова И.П."
Description: "Минимальный пример бригады с использованием Core_CareTeam профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/careteam"
  * value = "CT-2024-001"

* status = #active
* name = "Бригада по лечению Иванова И.П."

* subject
  * reference = "Patient/example-core-patient-ivanov-min"

* participant[0]
  * role
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/participant-role"
      * code = #PPRF
      * display = "Primary Care Provider"
  * member
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist-min"

// Пример 9: Core_Composition
Instance: example-core-composition-ivanov-consultation-min
InstanceOf: Core_Composition
Title: "Пример состава документа - консультация Иванова И.П."
Description: "Минимальный пример состава документа с использованием Core_Composition профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/composition"
  * value = "COMP-2024-001"

* status = #final
* type
  * coding[0]
    * system = "http://loinc.org"
    * code = #"11506-3"
    * display = "Progress note"

* subject
  * reference = "Patient/example-core-patient-ivanov-min"

* date = "2024-01-15T10:30:00Z"
* title = "Запись о приеме пациента Иванова И.П."

* author
  * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist-min"

// Дополнительный пример Core_Composition по протоколу лабораторного исследования СЭМД, редакция 4
Instance: example-core-composition-laboratory-semd-min
InstanceOf: Core_Composition
Title: "Пример набора версий протокола лабораторного исследования СЭМД"
Description: "Проверочный пример Composition.identifier по исходному XML протокола лабораторного исследования СЭМД редакции 4"

* identifier[misDocumentSet]
  * type = Core_Cs_Semd_Identifier_Type#mis-document-set
  * system = "urn:oid:1.2.643.5.1.13.13.12.2.77.8312.100.1.1.50"
  * value = "9633"

* status = #final
* type.coding[0]
  * system = "urn:oid:1.2.643.5.1.13.13.11.1522"
  * code = #7
  * display = "Протокол лабораторного исследования"
* date = "2024-01-15T10:30:00Z"
* title = "Протокол лабораторного исследования"
* author.reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist-min"

// Дополнительный пример Core_Bundle по протоколу лабораторного исследования СЭМД, редакция 4
Instance: example-core-bundle-laboratory-semd-min
InstanceOf: Core_Bundle
Title: "Пример пакета протокола лабораторного исследования СЭМД"
Description: "Проверочный пример Bundle.identifier по исходному XML протокола лабораторного исследования СЭМД редакции 4"

* identifier
  * type = Core_Cs_Semd_Identifier_Type#mis-document
  * system = "urn:oid:1.2.643.5.1.13.13.12.2.77.8312.100.1.1.51"
  * value = "7854321"

* type = #document
* timestamp = "2024-01-15T10:30:00Z"
* entry[0]
  * fullUrl = "https://fhir.ru/ig/core/Composition/example-core-composition-laboratory-semd-min"
  * resource = example-core-composition-laboratory-semd-min
* entry[1]
  * fullUrl = "https://fhir.ru/ig/core/PractitionerRole/example-core-practitionerrole-smirnov-therapist-min"
  * resource = example-core-practitionerrole-smirnov-therapist-min

// Пример 10: Core_Coverage
Instance: example-core-coverage-ivanov-oms-min
InstanceOf: Core_Coverage
Title: "Пример страхового покрытия - ОМС Иванова И.П."
Description: "Минимальный пример страхового покрытия с использованием Core_Coverage профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/oms"
  * value = "1234567890123456"
  * type
    * coding[0]
      * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document"
      * code = #1
    * coding[1]
      * system = "urn:oid:1.2.643.5.1.13.13.11.1035"
      * code = #2

* status = #active
* kind = #insurance
* type
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-sources-of-payment"
    * code = #"1"
    * display = "Средства обязательного медицинского страхования"

* subscriber
  * reference = "Patient/example-core-patient-ivanov-min"

* beneficiary
  * reference = "Patient/example-core-patient-ivanov-min"

* class[0]
  * type
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/coverage-class"
      * code = #group
      * display = "Group"
  * value
    * system = "https://fhir.ru/ig/core/systems/oms"
    * value = "ОМС-001"
  * name = "Обязательное медицинское страхование"

// Пример 11: Core_ServiceRequest
Instance: example-core-servicerequest-ivanov-consultation-min
InstanceOf: Core_ServiceRequest
Title: "Пример запроса на услугу - консультация Иванова И.П."
Description: "Минимальный пример запроса на услугу с использованием базового ServiceRequest ресурса"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/servicerequest"
  * value = "SR-2024-001"

* status = #active
* intent = #order
* code
  * concept
    * coding[0]
      * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-services"
      * code = #"A11.12.009"
      * display = "Взятие крови из периферической вены"

* subject
  * reference = "Patient/example-core-patient-ivanov-min"

* requester
  * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist-min"

// Пример 12: Core_DiagnosticReport
Instance: example-core-diagnosticreport-ivanov-blood-min
InstanceOf: Core_DiagnosticReport
Title: "Пример диагностического отчета - анализ крови Иванова И.П."
Description: "Минимальный пример диагностического отчета с использованием Core_DiagnosticReport профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/diagnosticreport"
  * value = "DR-2024-001"

* status = #final
* code[0]
  * coding[0]
    * system = "http://loinc.org"
    * code = #"58410-2"
    * display = "CBC panel - Blood by Automated count"

* subject
  * reference = "Patient/example-core-patient-ivanov-min"

* encounter
  * reference = "Encounter/example-core-encounter-consultation-min"

* effectiveDateTime = "2024-01-15T08:00:00Z"
* issued = "2024-01-15T10:00:00Z"

* performer[0]
  * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist-min"

// Пример 13: Core_Procedure
Instance: example-core-procedure-ivanov-consultation-min
InstanceOf: Core_Procedure
Title: "Пример процедуры - консультация Иванова И.П."
Description: "Минимальный пример процедуры с использованием Core_Procedure профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/procedure"
  * value = "PROC-2024-001"

* status = #completed
* code[0]
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-services"
    * code = #"A11.12.009"
    * display = "Взятие крови из периферической вены"

* subject
  * reference = "Patient/example-core-patient-ivanov-min"

* encounter
  * reference = "Encounter/example-core-encounter-consultation-min"

* performer[0]
  * actor
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist-min"

// ========================================
// ПРИМЕРЫ РАСШИРЕНИЙ
// ========================================

// Пример 14: Расширение FIAS
Instance: example-extension-fias-moscow-min
InstanceOf: fias
Usage: #inline
Title: "Пример расширения FIAS - г. Москва"
Description: "Минимальный пример расширения FIAS с использованием Core расширения"

* url = "https://fhir.ru/ig/core/StructureDefinition/fias"
* extension[aoguid]
  * valueIdentifier
    * system = "urn:hl7-ru:fias:aoguid"
    * value = "7700000000000000000000000"
* extension[houseguid]
  * valueIdentifier
    * system = "urn:hl7-ru:fias:houseguid"
    * value = "12345678-1234-1234-1234-123456789012"

// Пример 15: Расширение RegionRF
Instance: example-extension-regionrf-moscow-min
InstanceOf: regionRF
Usage: #inline
Title: "Пример расширения RegionRF - г. Москва"
Description: "Минимальный пример расширения RegionRF с использованием Core расширения"

* url = "https://fhir.ru/ig/core/StructureDefinition/regionRF"
* valueCodeableConcept
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-region-rf"
    * code = #77
    * display = "г. Москва"

// Пример 16: Расширение AddressType
Instance: example-extension-addresstype-home-min
InstanceOf: address-type
Usage: #inline
Title: "Пример расширения AddressType - домашний адрес"
Description: "Минимальный пример расширения AddressType с использованием Core расширения"

* url = "https://fhir.ru/ig/core/StructureDefinition/address-type"
* valueCodeableConcept
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-address-type"
    * code = #3
    * display = "Домашний адрес"

// Пример 17: Расширение OKATO
Instance: example-extension-okato-moscow-min
InstanceOf: okato
Usage: #inline
Title: "Пример расширения OKATO - г. Москва"
Description: "Минимальный пример расширения OKATO с использованием Core расширения"

* url = "https://fhir.ru/ig/core/StructureDefinition/okato"
* valueCodeableConcept
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-okato"
    * code = #"45000000000"
    * display = "г. Москва"

// Пример 18: Расширение HouseGuid
Instance: example-extension-houseguid-moscow-min
InstanceOf: houseguid
Usage: #inline
Title: "Пример расширения HouseGuid - дом в Москве"
Description: "Минимальный пример расширения HouseGuid с использованием Core расширения"

* url = "https://fhir.ru/ig/core/StructureDefinition/houseguid"
* valueIdentifier
  * system = "urn:hl7-ru:fias:houseguid"
  * value = "12345678-1234-1234-1234-123456789012"

// ========================================
// ДОПОЛНИТЕЛЬНЫЕ РЕСУРСЫ ДЛЯ ССЫЛОК
// ========================================

// Пример 19: Location (для ссылок)
Instance: example-core-location-therapy-office-min
InstanceOf: Location
Title: "Пример локации - кабинет терапевта №15"
Description: "Минимальный пример локации для использования в ссылках"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/location"
  * value = "LOC-15"

* status = #active
* name = "Кабинет терапевта №15"

* address
  * city = "Москва"
  * country = "RU"

* managingOrganization
  * reference = "Organization/example-core-organization-polyclinic-min"

// Пример 20: HealthcareService (для ссылок)
Instance: example-core-healthcareservice-therapy-min
InstanceOf: HealthcareService
Title: "Пример медицинской услуги - терапевтическая помощь"
Description: "Минимальный пример медицинской услуги для использования в ссылках"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/healthcareservice"
  * value = "HS-THERAPY-001"

* active = true
* providedBy
  * reference = "Organization/example-core-organization-polyclinic-min"

* category[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/service-category"
    * code = #17
    * display = "General Practice"

* type[0]
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-services"
    * code = #"A11.12.009"
    * display = "Взятие крови из периферической вены"

* name = "Терапевтическая помощь"

// Пример 21: Appointment (для ссылок)
Instance: example-core-appointment-ivanov-consultation-min
InstanceOf: Appointment
Title: "Пример приема - консультация Иванова И.П."
Description: "Минимальный пример приема для использования в ссылках"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/appointment"
  * value = "APT-2024-001"

* status = #fulfilled
* serviceCategory[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/service-category"
    * code = #17
    * display = "General Practice"

* specialty[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/c80-practice-codes"
    * code = #GP
    * display = "General Practice"

* appointmentType
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/v2-0276"
    * code = #ROUTINE
    * display = "Routine"

* priority
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/v3-ActPriority"
    * code = #R
    * display = "Routine"

* description = "Консультация терапевта по поводу повышенной температуры"

* start = "2024-01-15T10:00:00Z"
* end = "2024-01-15T10:30:00Z"

* participant[0]
  * type[0]
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
      * code = #ATND
      * display = "attender"
  * actor
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist-min"
  * required = true
  * status = #accepted

* participant[1]
  * type[0]
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
      * code = #PPRF
      * display = "primary performer"
  * actor
    * reference = "Patient/example-core-patient-ivanov-min"
  * required = true
  * status = #accepted

// Пример 22: Core_Address
Instance: example-core-address-moscow-home-min
InstanceOf: Core_Address
Usage: #inline
Title: "Пример адреса - домашний адрес в Москве (минимальный)"
Description: "Минимальный пример адреса на территории РФ с использованием профиля Core_Address"

* use = #home
* type = #physical
* city = "Москва"
* country = "RU" 
