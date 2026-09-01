Profile: Core_Patient
Parent: Patient
Id: core-patient
Title: "Core Patient (Пациент)"
Description: "Базовый профиль пациента для российских FHIR-реализаций"

* identifier.type from Core_Vs_Identifier_Type (extensible)
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка по семантическому типу идентификатора пациента"
* identifier contains 
  snils 0..1 and
  inn 0..1 and
  identityDocument 0..* and
  omsPolicy 0..1 and
  misPatient 0..1

* identifier[snils] ^short = "Страховой номер индивидуального лицевого счёта (СНИЛС)"
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#snils
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/snils"

* identifier[inn] ^short = "Идентификационный номер налогоплательщика (ИНН)"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/inn"
  * type 1..1
  * type ^patternCodeableConcept.coding[0].system = "https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type"
  * type ^patternCodeableConcept.coding[0].code = #inn
  * type.coding ^slicing.discriminator.type = #pattern
  * type.coding ^slicing.discriminator.path = "$this"
  * type.coding ^slicing.rules = #open
  * type.coding contains
      identifierType 1..1 and
      taxType 1..1
  * type.coding[identifierType] = Core_Cs_Semd_Identifier_Type#inn
  * type.coding[taxType] = http://terminology.hl7.org/CodeSystem/v2-0203#TAX

* identifier[identityDocument] ^short = "Документ, удостоверяющий личность"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/identity-document"
  * type 1..1
  * type ^patternCodeableConcept.coding[0].system = "https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type"
  * type ^patternCodeableConcept.coding[0].code = #identity-document
  * type from Core_Vs_Nsi_Identity_Documents (extensible)

* identifier[omsPolicy] ^short = "Полис ОМС"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/oms"
  * type 1..1
  * type ^patternCodeableConcept.coding[0].system = "https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type"
  * type ^patternCodeableConcept.coding[0].code = #oms-policy
  * type.coding ^slicing.discriminator.type = #pattern
  * type.coding ^slicing.discriminator.path = "$this"
  * type.coding ^slicing.rules = #open
  * type.coding contains
      identifierType 1..1 and
      coverageDocumentType 1..1 and
      omsType 1..1
  * type.coding[identifierType] = Core_Cs_Semd_Identifier_Type#oms-policy
  * type.coding[coverageDocumentType] = Core_Cs_Nsi_Coverage_Document#1
  * type.coding[omsType]
    * ^patternCoding.system = "urn:oid:1.2.643.5.1.13.13.11.1035"
    * system 1..1
    * code 1..1
    * code from Core_Vs_Nsi_Coverage_Document_OMS (extensible)

* identifier[misPatient] ^short = "Идентификатор пациента в экземпляре МИС"
* identifier[misPatient] ^definition = "Локальный идентификатор пациента в конкретном экземпляре медицинской информационной системы."
* identifier[misPatient] ^comment = "Identifier.system формируется как urn:oid:1.2.643.5.1.13.13.12.2.{код субъекта Российской Федерации}.{идентификатор медицинской организации в ФРМО}.100.{номер МИС}.{номер экземпляра МИС}.10."
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-patient
  * system 1..1
  * value 1..1
  * obeys core-patient-mis-patient-system

* name ^short = "ФИО пациента"
  * family ^short = "Фамилия"
  * given ^short = "Имя и отчество пациента"
  * given ^definition = "Массив строк: первый элемент - имя, второй элемент - отчество"
  * use ^short = "Тип имени пациента. Рекомендуемое значение: official"

* gender ^short = "Пол пациента. Используются позиции: male | female | unknown. Other - не используется для совместимости со Справочником НСИ Пол пациента"

* birthDate ^short = "Дата рождения пациента, формат YYYY-MM-DD или YYYY-MM-DDTHH:MM для новорождённых"

* address ^short = "Адрес пациента"
* address ^comment = "Для адресов на территории Российской Федерации следует использовать правила профиля Core_Address. Для адресов вне территории Российской Федерации применяется базовый тип Address."

* managingOrganization ^short = "Ответственная организация"
* managingOrganization only Reference(Core_Organization) 

Invariant: core-patient-mis-patient-system
Description: "Система идентификатора пациента в МИС должна соответствовать структуре urn:oid:1.2.643.5.1.13.13.12.2.{субъект РФ}.{медицинская организация ФРМО}.100.{МИС}.{экземпляр МИС}.10"
Severity: #error
Expression: "system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]10$')"
