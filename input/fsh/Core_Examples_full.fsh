// Примеры экземпляров для Core профилей и расширений
// Полные примеры с максимально заполненными атрибутами

// ========================================
// ПРИМЕРЫ ПРОФИЛЕЙ
// ========================================

// Пример 1: Core_Patient
Instance: example-core-patient-ivanov
InstanceOf: Core_Patient
Title: "Пример пациента - Иван Иванов"
Description: "Полный пример пациента с использованием Core_Patient профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/snils"
  * value = "123-456-789-01"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#SB
  * use = #official
  * assigner.display = "ПФР РФ"

* identifier[1]
  * system = "https://www.nalog.gov.ru/inn"
  * value = "123456789012"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#TAX
  * use = #official

* identifier[2]
  * system = "https://fhir.ru/ig/core/systems/passport"
  * value = "4510-123456"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#PPN
  * use = #official

* identifier[3]
  * system = "https://fhir.ru/ig/core/systems/oms"
  * value = "1234567890123456"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#PPN
  * use = #official

* active = true
* name[0]
  * use = #official
  * family = "Иванов"
  * given[0] = "Иван"
  * given[1] = "Петрович"
  * text = "Иванов Иван Петрович"

* gender = #male
* birthDate = "1985-03-15"
* deceasedBoolean = false

* address[0]
  * use = #home
  * type = #physical
  * text = "г. Москва, ул. Тверская, д. 1, кв. 15"
  * line[0] = "ул. Тверская, д. 1, кв. 15"
  * city = "Москва"
  * state = "Москва"
  * postalCode = "125009"
  * country = "RU"
  * extension[0]
    * url = "https://fhir.ru/ig/core/StructureDefinition/fias"
    * valueCodeableConcept
      * coding[0]
        * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-fias"
        * code = #"7700000000000000000000000"
        * display = "г. Москва"
  * extension[1]
    * url = "https://fhir.ru/ig/core/StructureDefinition/regionRF"
    * valueCodeableConcept
      * coding[0]
        * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-region-rf"
        * code = #77
        * display = "г. Москва"
  * extension[2]
    * url = "https://fhir.ru/ig/core/StructureDefinition/address-type"
    * valueCodeableConcept
      * coding[0]
        * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-address-type"
        * code = #3
        * display = "Домашний адрес"

* maritalStatus
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/v3-MaritalStatus"
    * code = #M
    * display = "Married"
  * text = "Женат"

* managingOrganization
  * reference = "Organization/example-core-organization-polyclinic"
  * display = "ГБУЗ Городская поликлиника №1"

// Пример 2: Core_Organization
Instance: example-core-organization-polyclinic
InstanceOf: Core_Organization
Title: "Пример организации - Городская поликлиника №1"
Description: "Полный пример медицинской организации с использованием Core_Organization профиля"

* identifier[0]
  * system = "https://www.nalog.gov.ru/inn"
  * value = "7701234567"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#TAX
  * use = #official

* identifier[1]
  * system = "https://egrul.nalog.ru/ogrn"
  * value = "1027700000001"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#TAX
  * use = #official

* identifier[2]
  * system = "https://classifikators.ru/okpo"
  * value = "12345678"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#TAX
  * use = #official

* identifier[3]
  * system = "https://www.rosminzdrav.ru/frmo"
  * value = "7701001"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#TAX
  * use = #official

* active = true
* name = "ГБУЗ Городская поликлиника №1"
* alias[0] = "Поликлиника №1"
* alias[1] = "ГП №1"

* contact[0]
  * address
    * use = #work
    * type = #physical
    * text = "г. Москва, ул. Тверская, д. 10"
    * line[0] = "ул. Тверская, д. 10"
    * city = "Москва"
    * state = "Москва"
    * postalCode = "125009"
    * country = "RU"
    * extension[0]
      * url = "https://fhir.ru/ig/core/StructureDefinition/okato"
      * valueCodeableConcept
        * coding[0]
          * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-okato"
          * code = #"45000000000"
          * display = "г. Москва"

* type[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/organization-type"
    * code = #prov
    * display = "Healthcare Provider"

* qualification[0]
  * identifier[0]
    * system = "https://www.rosminzdrav.ru/license"
    * value = "ЛО-77-01-000001"
  * code
    * coding[0]
      * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-license"
      * code = #"01"
      * display = "Медицинская деятельность"
  * period
    * start = "2020-01-01"
    * end = "2030-01-01"
  * issuer.display = "Департамент здравоохранения г. Москвы"

// Пример 3: Core_Practitioner
Instance: example-core-practitioner-smirnov
InstanceOf: Core_Practitioner
Title: "Пример медицинского работника - доктор Смирнов"
Description: "Полный пример медицинского работника с использованием Core_Practitioner профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/snils"
  * value = "987-654-321-09"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#SB
  * use = #official

* identifier[1]
  * system = "https://fhir.ru/ig/core/systems/passport"
  * value = "4510-654321"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#PPN
  * use = #official

* active = true
* name[0]
  * use = #official
  * family = "Смирнов"
  * given[0] = "Александр"
  * given[1] = "Иванович"
  * text = "Смирнов Александр Иванович"

* gender = #male
* birthDate = "1975-06-20"

* address[0]
  * use = #home
  * type = #physical
  * text = "г. Москва, ул. Арбат, д. 25, кв. 8"
  * line[0] = "ул. Арбат, д. 25, кв. 8"
  * city = "Москва"
  * state = "Москва"
  * postalCode = "119002"
  * country = "RU"

* qualification[0]
  * identifier[0]
    * system = "https://www.rosminzdrav.ru/medical-education"
    * value = "МЕД-123456"
  * code
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/v2-0360"
      * code = #MD
      * display = "Doctor of Medicine"
  * period
    * start = "2000-06-01"
  * issuer.display = "Первый Московский государственный медицинский университет им. И.М. Сеченова"

// Пример 4: Core_PractitionerRole
Instance: example-core-practitionerrole-smirnov-therapist
InstanceOf: Core_PractitionerRole
Title: "Пример роли медицинского работника - терапевт Смирнов"
Description: "Полный пример роли медицинского работника с использованием Core_PractitionerRole профиля"

* active = true
* practitioner
  * reference = "Practitioner/example-core-practitioner-smirnov"
  * display = "Смирнов Александр Иванович"

* organization
  * reference = "Organization/example-core-organization-polyclinic"
  * display = "ГБУЗ Городская поликлиника №1"

* code[0]
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-workers-positions"
    * code = #"1"
    * display = "Врач-терапевт участковый"

* specialty[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/c80-practice-codes"
    * code = #GP
    * display = "General Practice"

* location[0]
  * reference = "Location/example-core-location-therapy-office"
  * display = "Кабинет терапевта №15"

* healthcareService[0]
  * reference = "HealthcareService/example-core-healthcareservice-therapy"
  * display = "Терапевтическая помощь"

* period
  * start = "2020-01-01"

// Пример 5: Core_Address (как отдельный ресурс)
Instance: example-core-address-moscow-home
InstanceOf: Core_Address
Usage: #inline
Title: "Пример адреса - домашний адрес в Москве"
Description: "Полный пример адреса с использованием Core_Address профиля"

* use = #home
* type = #physical
* text = "г. Москва, ул. Тверская, д. 1, кв. 15"
* line[0] = "ул. Тверская, д. 1, кв. 15"
* city = "Москва"
* state = "Москва"
* postalCode = "125009"
* country = "RU"

* extension[0]
  * url = "https://fhir.ru/ig/core/StructureDefinition/fias"
  * valueCodeableConcept
    * coding[0]
      * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-fias"
      * code = #"7700000000000000000000000"
      * display = "г. Москва"

* extension[1]
  * url = "https://fhir.ru/ig/core/StructureDefinition/regionRF"
  * valueCodeableConcept
    * coding[0]
      * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-region-rf"
      * code = #77
      * display = "г. Москва"

* extension[2]
  * url = "https://fhir.ru/ig/core/StructureDefinition/address-type"
  * valueCodeableConcept
    * coding[0]
      * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-address-type"
      * code = #3
      * display = "Домашний адрес"

* period
  * start = "2020-01-01" 

// Пример 6: Core_Encounter
Instance: example-core-encounter-consultation
InstanceOf: Core_Encounter
Title: "Пример случая обслуживания - консультация терапевта"
Description: "Полный пример случая обслуживания с использованием Core_Encounter профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/encounter"
  * value = "ENC-2024-001"
  * use = #official

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

* priority
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/v3-ActPriority"
    * code = #R
    * display = "Routine"

* subject
  * reference = "Patient/example-core-patient-ivanov"
  * display = "Иванов Иван Петрович"

* episodeOfCare[0]
  * reference = "EpisodeOfCare/example-core-episodeofcare-ivanov-2024"
  * display = "Эпизод лечения Иванова И.П. 2024"

* participant[0]
  * type[0]
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
      * code = #ATND
      * display = "attender"
  * actor
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
    * display = "Смирнов Александр Иванович"

* participant[1]
  * type[0]
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
      * code = #PPRF
      * display = "primary performer"
  * actor
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
    * display = "Смирнов Александр Иванович"

* appointment[0]
  * reference = "Appointment/example-core-appointment-ivanov-consultation"
  * display = "Прием пациента Иванова И.П."

* length
  * value = 30
  * unit = "min"
  * system = "http://unitsofmeasure.org"
  * code = #min

* serviceProvider
  * reference = "Organization/example-core-organization-polyclinic"
  * display = "ГБУЗ Городская поликлиника №1"

// Пример 7: Core_EpisodeOfCare
Instance: example-core-episodeofcare-ivanov-2024
InstanceOf: Core_EpisodeOfCare
Title: "Пример эпизода лечения - Иванов И.П. 2024"
Description: "Полный пример эпизода лечения с использованием Core_EpisodeOfCare профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/episode"
  * value = "EP-2024-001"
  * use = #official

* status = #active
* type[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/episodeofcare-type"
    * code = #hacc
    * display = "Home and Community Care"

* patient
  * reference = "Patient/example-core-patient-ivanov"
  * display = "Иванов Иван Петрович"

* managingOrganization
  * reference = "Organization/example-core-organization-polyclinic"
  * display = "ГБУЗ Городская поликлиника №1"

* period
  * start = "2024-01-01"
  * end = "2024-12-31"

* careManager
  * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
  * display = "Смирнов Александр Иванович"

// Пример 8: Core_CareTeam
Instance: example-core-careteam-ivanov
InstanceOf: Core_CareTeam
Title: "Пример бригады - бригада по лечению Иванова И.П."
Description: "Полный пример бригады с использованием Core_CareTeam профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/careteam"
  * value = "CT-2024-001"
  * use = #official

* status = #active
* name = "Бригада по лечению Иванова И.П."

* subject
  * reference = "Patient/example-core-patient-ivanov"
  * display = "Иванов Иван Петрович"

* period
  * start = "2024-01-01"
  * end = "2024-12-31"

* participant[0]
  * role
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/participant-role"
      * code = #PPRF
      * display = "Primary Care Provider"
  * member
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
    * display = "Смирнов Александр Иванович"
  * onBehalfOf
    * reference = "Organization/example-core-organization-polyclinic"
    * display = "ГБУЗ Городская поликлиника №1"

* participant[1]
  * role
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/participant-role"
      * code = #ADM
      * display = "Admitter"
  * member
    * reference = "PractitionerRole/example-core-practitionerrole-nurse"
    * display = "Медсестра Петрова М.И."
  * onBehalfOf
    * reference = "Organization/example-core-organization-polyclinic"
    * display = "ГБУЗ Городская поликлиника №1"

* managingOrganization[0]
  * reference = "Organization/example-core-organization-polyclinic"
  * display = "ГБУЗ Городская поликлиника №1"

* note[0]
  * authorReference
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
    * display = "Смирнов Александр Иванович"
  * time = "2024-01-15T10:30:00Z"
  * text = "Пациент направлен на дополнительные обследования"

// Пример 9: Core_Composition
Instance: example-core-composition-ivanov-consultation
InstanceOf: Core_Composition
Title: "Пример состава документа - консультация Иванова И.П."
Description: "Полный пример состава документа с использованием Core_Composition профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/composition"
  * value = "COMP-2024-001"
  * use = #official

* status = #final
* type
  * coding[0]
    * system = "http://loinc.org"
    * code = #"11506-3"
    * display = "Progress note"
  * text = "Запись о приеме"

* category[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/document-classcodes"
    * code = #"11506-3"
    * display = "Progress note"

* subject
  * reference = "Patient/example-core-patient-ivanov"
  * display = "Иванов Иван Петрович"

* encounter
  * reference = "Encounter/example-core-encounter-consultation"
  * display = "Консультация терапевта"

* date = "2024-01-15T10:30:00Z"
* title = "Запись о приеме пациента Иванова И.П."

* author
  * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
  * display = "Смирнов Александр Иванович"

* attester[0]
  * mode = #legal
  * time = "2024-01-15T10:30:00Z"
  * party
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
    * display = "Смирнов Александр Иванович"

* custodian
  * reference = "Organization/example-core-organization-polyclinic"
  * display = "ГБУЗ Городская поликлиника №1"

* section[0]
  * title = "Жалобы"
  * code
    * coding[0]
      * system = "http://loinc.org"
      * code = #"46239-0"
      * display = "Chief complaint"
  * text
    * status = #generated
    * div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">Пациент жалуется на повышенную температуру тела 38.5°C в течение 3 дней</div>"
  * entry[0]
    * reference = "Observation/example-core-observation-ivanov-temperature"
    * display = "Температура тела 38.5°C"

* section[1]
  * title = "Объективный статус"
  * code
    * coding[0]
      * system = "http://loinc.org"
      * code = #"8716-3"
      * display = "Vital signs"
  * text
    * status = #generated
    * div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">Состояние удовлетворительное. Температура тела 38.5°C. Кожные покровы бледные.</div>"
  * entry[0]
    * reference = "Observation/example-core-observation-ivanov-temperature"
    * display = "Температура тела 38.5°C"

* section[2]
  * title = "Диагноз"
  * code
    * coding[0]
      * system = "http://loinc.org"
      * code = #"11506-3"
      * display = "Progress note"
  * text
    * status = #generated
    * div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">Предварительный диагноз: ОРВИ</div>"
  * entry[0]
    * reference = "Condition/example-core-condition-ivanov-fever"
    * display = "Повышенная температура"

* section[3]
  * title = "Назначения"
  * code
    * coding[0]
      * system = "http://loinc.org"
      * code = #"11506-3"
      * display = "Progress note"
  * text
    * status = #generated
    * div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">1. Парацетамол 500 мг 3 раза в день<br/>2. Обильное питье<br/>3. Постельный режим</div>"
  * entry[0]
    * reference = "MedicationRequest/example-core-medicationrequest-ivanov-paracetamol"
    * display = "Назначение парацетамола"

// Пример 10: Core_Coverage
Instance: example-core-coverage-ivanov-oms
InstanceOf: Core_Coverage
Title: "Пример страхового покрытия - ОМС Иванова И.П."
Description: "Полный пример страхового покрытия с использованием Core_Coverage профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/oms"
  * value = "1234567890123456"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#PPN
  * use = #official

* status = #active
* kind = #insurance
* type
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-sources-of-payment"
    * code = #"1"
    * display = "ОМС"

* subscriber
  * reference = "Patient/example-core-patient-ivanov"
  * display = "Иванов Иван Петрович"

* subscriberId
  * value = "1234567890123456"
  * system = "https://fhir.ru/ig/core/systems/oms"

* beneficiary
  * reference = "Patient/example-core-patient-ivanov"
  * display = "Иванов Иван Петрович"

* dependent = "1"
* relationship
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/subscriber-relationship"
    * code = #self
    * display = "Self"

* period
  * start = "2024-01-01"
  * end = "2024-12-31"

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

* order = 1
* network = "ОМС"
* costToBeneficiary[0]
  * type
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/benefit-category"
      * code = #medical
      * display = "Medical"
  * valueQuantity
    * value = 0
    * unit = "руб"
    * system = "http://unitsofmeasure.org"
    * code = #RUB

* subrogation = false

// Пример 19: Core_RelatedPerson
Instance: example-core-relatedperson-ivanov-spouse
InstanceOf: Core_RelatedPerson
Title: "Пример связанного лица - супруга Иванова И.П."
Description: "Полный пример связанного лица с использованием Core_RelatedPerson профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/snils"
  * value = "111-222-333-44"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#SB
  * use = #official

* active = true
* patient
  * reference = "Patient/example-core-patient-ivanov"
  * display = "Иванов Иван Петрович"

* relationship
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-relatedperson-codesystem"
    * code = #SPS
    * display = "Spouse"

* name[0]
  * use = #official
  * family = "Иванова"
  * given[0] = "Мария"
  * given[1] = "Сергеевна"
  * text = "Иванова Мария Сергеевна"

* gender = #female
* birthDate = "1987-08-12"

* address[0]
  * use = #home
  * type = #physical
  * text = "г. Москва, ул. Тверская, д. 1, кв. 15"
  * line[0] = "ул. Тверская, д. 1, кв. 15"
  * city = "Москва"
  * state = "Москва"
  * postalCode = "125009"
  * country = "RU"

* telecom[0]
  * system = #phone
  * value = "+7-495-123-45-67"
  * use = #home

* telecom[1]
  * system = #email
  * value = "maria.ivanova@email.com"
  * use = #home

// Пример 20: Core_ServiceRequest
Instance: example-core-servicerequest-ivanov-consultation
InstanceOf: Core_ServiceRequest
Title: "Пример запроса на услугу - консультация Иванова И.П."
Description: "Полный пример запроса на услугу с использованием Core_ServiceRequest профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/servicerequest"
  * value = "SR-2024-001"
  * use = #official

* status = #active
* intent = #order
* category[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/servicerequest-category"
    * code = #consultation
    * display = "Consultation"

* priority = #routine
* code
  * concept
    * coding[0]
      * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-services"
      * code = #"A11.12.009"
      * display = "Взятие крови из периферической вены"
    * text = "Консультация терапевта"

* subject
  * reference = "Patient/example-core-patient-ivanov"
  * display = "Иванов Иван Петрович"

* encounter
  * reference = "Encounter/example-core-encounter-consultation"
  * display = "Консультация терапевта"

* authoredOn = "2024-01-15T09:00:00Z"
* requester
  * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
  * display = "Смирнов Александр Иванович"

* performer[0]
  * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
  * display = "Смирнов Александр Иванович"

* reason[0]
  * concept
    * coding[0]
      * system = "http://snomed.info/sct"
      * code = #"386661006"
      * display = "Fever"

* reason[1]
  * reference
    * reference = "Observation/example-core-observation-ivanov-temperature"
    * display = "Температура тела 38.5°C"

* insurance[0]
  * reference = "Coverage/example-core-coverage-ivanov-oms"
  * display = "ОМС Иванова И.П."

* supportingInfo[0]
  * reference
    * reference = "Observation/example-core-observation-ivanov-temperature"
    * display = "Температура тела 38.5°C"

* specimen[0]
  * reference = "Specimen/example-core-specimen-ivanov-blood"
  * display = "Образец крови Иванова И.П."

* bodySite[0]
  * coding[0]
    * system = "http://snomed.info/sct"
    * code = #"368209003"
    * display = "Right arm"

* note[0]
  * authorReference
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
    * display = "Смирнов Александр Иванович"
  * time = "2024-01-15T09:00:00Z"
  * text = "Пациент жалуется на повышенную температуру"

// Пример 21: Core_DiagnosticReport
Instance: example-core-diagnosticreport-ivanov-blood
InstanceOf: Core_DiagnosticReport
Title: "Пример диагностического отчета - анализ крови Иванова И.П."
Description: "Полный пример диагностического отчета с использованием Core_DiagnosticReport профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/diagnosticreport"
  * value = "DR-2024-001"
  * use = #official

* status = #final
* category[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/v2-0074"
    * code = #LAB
    * display = "Laboratory"

* code
  * coding[0]
    * system = "http://loinc.org"
    * code = #"58410-2"
    * display = "CBC panel - Blood by Automated count"
  * text = "Общий анализ крови"

* subject
  * reference = "Patient/example-core-patient-ivanov"
  * display = "Иванов Иван Петрович"

* encounter
  * reference = "Encounter/example-core-encounter-consultation"
  * display = "Консультация терапевта"

* effectiveDateTime = "2024-01-15T08:00:00Z"
* issued = "2024-01-15T10:00:00Z"

* performer[0]
  * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
  * display = "Смирнов Александр Иванович"

* resultsInterpreter[0]
  * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
  * display = "Смирнов Александр Иванович"

* specimen[0]
  * reference = "Specimen/example-core-specimen-ivanov-blood"
  * display = "Образец крови Иванова И.П."

* result[0]
  * reference = "Observation/example-core-observation-ivanov-hemoglobin"
  * display = "Гемоглобин 145 г/л"

* result[1]
  * reference = "Observation/example-core-observation-ivanov-leukocytes"
  * display = "Лейкоциты 6.5×10^9/л"

* study[0]
  * reference = "ImagingStudy/example-core-imagingstudy-ivanov-chest"
  * display = "Рентгенография грудной клетки"

* media[0]
  * comment = "Микрофотография мазка крови"
  * link
    * reference = "Media/example-core-media-ivanov-blood-smear"
    * display = "Микрофотография мазка крови"

* conclusion = "Показатели крови в пределах нормы"
* conclusionCode[0]
  * coding[0]
    * system = "http://snomed.info/sct"
    * code = #"260413007"
    * display = "None"

* presentedForm[0]
  * contentType = #application/pdf
  * language = #ru
  * data = "JVBERi0xLjQK"
  * url = "https://fhir.ru/ig/core/reports/DR-2024-001.pdf"
  * size = 24576
  * hash = "MTIzNDU2Nzg5MA=="

// Пример 22: Core_Procedure
Instance: example-core-procedure-ivanov-consultation
InstanceOf: Core_Procedure
Title: "Пример процедуры - консультация Иванова И.П."
Description: "Полный пример процедуры с использованием Core_Procedure профиля"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/procedure"
  * value = "PROC-2024-001"
  * use = #official

* status = #completed
* statusReason
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/procedure-not-performed-reason"
    * code = #patient-request
    * display = "Patient request"

* category[0]
  * coding[0]
    * system = "http://snomed.info/sct"
    * code = #"103693007"
    * display = "Diagnostic procedure"

* code
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-services"
    * code = #"A11.12.009"
    * display = "Взятие крови из периферической вены"
  * text = "Консультация терапевта"

* subject
  * reference = "Patient/example-core-patient-ivanov"
  * display = "Иванов Иван Петрович"

* encounter
  * reference = "Encounter/example-core-encounter-consultation"
  * display = "Консультация терапевта"

* occurrenceDateTime = "2024-01-15T10:15:00Z"

* recorder
  * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
  * display = "Смирнов Александр Иванович"

* recorder
  * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
  * display = "Смирнов Александр Иванович"

* performer[0]
  * function
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/performer-role"
      * code = #primary
      * display = "Primary performer"
  * actor
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
    * display = "Смирнов Александр Иванович"
  * onBehalfOf
    * reference = "Organization/example-core-organization-polyclinic"
    * display = "ГБУЗ Городская поликлиника №1"

* location
  * reference = "Location/example-core-location-therapy-office"
  * display = "Кабинет терапевта №15"

* reason[0]
  * concept
    * coding[0]
      * system = "http://snomed.info/sct"
      * code = #"386661006"
      * display = "Fever"

* reason[1]
  * reference
    * reference = "Observation/example-core-observation-ivanov-temperature"
    * display = "Температура тела 38.5°C"

* bodySite[0]
  * coding[0]
    * system = "http://snomed.info/sct"
    * code = #"368209003"
    * display = "Right arm"

* outcome
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/procedure-outcome"
    * code = #successful
    * display = "Successful"

* report[0]
  * reference = "DiagnosticReport/example-core-diagnosticreport-ivanov-blood"
  * display = "Общий анализ крови"

* complication[0]
  * concept
    * coding[0]
      * system = "http://snomed.info/sct"
      * code = #"260413007"
      * display = "None"

* followUp[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/procedure-followup"
    * code = #routine
    * display = "Routine"

* note[0]
  * authorReference
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
    * display = "Смирнов Александр Иванович"
  * time = "2024-01-15T10:30:00Z"
  * text = "Процедура выполнена успешно, осложнений нет" 


// ========================================
// ПРИМЕРЫ РАСШИРЕНИЙ
// ========================================

// Пример 11: Расширение FIAS
Instance: example-extension-fias-moscow
InstanceOf: fias
Usage: #inline
Title: "Пример расширения FIAS - г. Москва"
Description: "Полный пример расширения FIAS с использованием Core расширения"

* url = "https://fhir.ru/ig/core/StructureDefinition/fias"
* extension[aoguid]
  * valueIdentifier
    * system = "urn:hl7-ru:fias:aoguid"
    * value = "7700000000000000000000000"
* extension[houseguid]
  * valueIdentifier
    * system = "urn:hl7-ru:fias:houseguid"
    * value = "12345678-1234-1234-1234-123456789012"

// Пример 12: Расширение RegionRF
Instance: example-extension-regionrf-moscow
InstanceOf: regionRF
Usage: #inline
Title: "Пример расширения RegionRF - г. Москва"
Description: "Полный пример расширения RegionRF с использованием Core расширения"

* url = "https://fhir.ru/ig/core/StructureDefinition/regionRF"
* valueCodeableConcept
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-region-rf"
    * code = #77
    * display = "г. Москва"
  * text = "г. Москва"

// Пример 13: Расширение AddressType
Instance: example-extension-addresstype-home
InstanceOf: address-type
Usage: #inline
Title: "Пример расширения AddressType - домашний адрес"
Description: "Полный пример расширения AddressType с использованием Core расширения"

* url = "https://fhir.ru/ig/core/StructureDefinition/address-type"
* valueCodeableConcept
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-address-type"
    * code = #3
    * display = "Домашний адрес"
  * text = "Домашний адрес"

// Пример 14: Расширение OKATO
Instance: example-extension-okato-moscow
InstanceOf: okato
Usage: #inline
Title: "Пример расширения OKATO - г. Москва"
Description: "Полный пример расширения OKATO с использованием Core расширения"

* url = "https://fhir.ru/ig/core/StructureDefinition/okato"
* valueCodeableConcept
  * coding[0]
    * system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-okato"
    * code = #"45000000000"
    * display = "г. Москва"
  * text = "г. Москва"

// Пример 15: Расширение HouseGuid
Instance: example-extension-houseguid-moscow
InstanceOf: houseguid
Usage: #inline
Title: "Пример расширения HouseGuid - дом в Москве"
Description: "Полный пример расширения HouseGuid с использованием Core расширения"

* url = "https://fhir.ru/ig/core/StructureDefinition/houseguid"
* valueIdentifier
  * system = "urn:hl7-ru:fias:houseguid"
  * value = "12345678-1234-1234-1234-123456789012"

// ========================================
// ДОПОЛНИТЕЛЬНЫЕ РЕСУРСЫ ДЛЯ ССЫЛОК
// ========================================

// Пример 16: Location (для ссылок)
Instance: example-core-location-therapy-office
InstanceOf: Location
Title: "Пример локации - кабинет терапевта №15"
Description: "Пример локации для использования в ссылках"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/location"
  * value = "LOC-15"
  * use = #official

* status = #active
* name = "Кабинет терапевта №15"
* description = "Кабинет участкового терапевта Смирнова А.И."

* type[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/v3-ServiceDeliveryLocationRoleType"
    * code = #AMB
    * display = "Ambulatory"

* address
  * use = #work
  * type = #physical
  * text = "г. Москва, ул. Тверская, д. 10, кабинет 15"
  * line[0] = "ул. Тверская, д. 10, кабинет 15"
  * city = "Москва"
  * state = "Москва"
  * postalCode = "125009"
  * country = "RU"

* position
  * longitude = 37.6173
  * latitude = 55.7558
  * altitude = 150

* managingOrganization
  * reference = "Organization/example-core-organization-polyclinic"
  * display = "ГБУЗ Городская поликлиника №1"

// Пример 17: HealthcareService (для ссылок)
Instance: example-core-healthcareservice-therapy
InstanceOf: HealthcareService
Title: "Пример медицинской услуги - терапевтическая помощь"
Description: "Пример медицинской услуги для использования в ссылках"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/healthcareservice"
  * value = "HS-THERAPY-001"
  * use = #official

* active = true
* providedBy
  * reference = "Organization/example-core-organization-polyclinic"
  * display = "ГБУЗ Городская поликлиника №1"

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

* specialty[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/c80-practice-codes"
    * code = #GP
    * display = "General Practice"

* location[0]
  * reference = "Location/example-core-location-therapy-office"
  * display = "Кабинет терапевта №15"

* name = "Терапевтическая помощь"
* comment = "Оказание первичной медико-санитарной помощи"

* extraDetails = "Прием ведется по предварительной записи"

* photo
  * contentType = #image/jpeg
  * data = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=="

* coverageArea[0]
  * reference = "Location/example-core-location-moscow"
  * display = "г. Москва"

* serviceProvisionCode[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/service-provision-conditions"
    * code = #free
    * display = "Free"

* eligibility[0]
  * code
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/benefit-category"
      * code = #medical
      * display = "Medical"
  * comment = "Для застрахованных по ОМС"

* program[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/program"
    * code = #1
    * display = "ОМС"

* communication[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/communication"
    * code = #ru
    * display = "Russian"

* referralMethod[0]
  * coding[0]
    * system = "http://terminology.hl7.org/CodeSystem/service-referral-method"
    * code = #phone
    * display = "Phone"

* appointmentRequired = true

* endpoint[0]
  * reference = "Endpoint/example-core-endpoint-therapy"
  * display = "Электронная регистратура"

// Пример 18: Appointment (для ссылок)
Instance: example-core-appointment-ivanov-consultation
InstanceOf: Appointment
Title: "Пример приема - консультация Иванова И.П."
Description: "Пример приема для использования в ссылках"

* identifier[0]
  * system = "https://fhir.ru/ig/core/systems/appointment"
  * value = "APT-2024-001"
  * use = #official

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

* supportingInformation[0]
  * reference = "Observation/example-core-observation-ivanov-temperature"
  * display = "Температура тела 38.5°C"

* start = "2024-01-15T10:00:00Z"
* end = "2024-01-15T10:30:00Z"
* minutesDuration = 30

* participant[0]
  * type[0]
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
      * code = #ATND
      * display = "attender"
  * actor
    * reference = "PractitionerRole/example-core-practitionerrole-smirnov-therapist"
    * display = "Смирнов Александр Иванович"
  * required = true
  * status = #accepted

* participant[1]
  * type[0]
    * coding[0]
      * system = "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
      * code = #PPRF
      * display = "primary performer"
  * actor
    * reference = "Patient/example-core-patient-ivanov"
    * display = "Иванов Иван Петрович"
  * required = true
  * status = #accepted

* requestedPeriod[0]
  * start = "2024-01-15T09:00:00Z"
  * end = "2024-01-15T11:00:00Z"

