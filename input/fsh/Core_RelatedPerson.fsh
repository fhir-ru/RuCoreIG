Profile: Core_RelatedPerson
Parent: RelatedPerson
Id: core-relatedperson
Title: "Представитель пациента"
Description: "Базовый профиль RelatedPerson для РФ. Определено использвание СНИЛС как идентификатора, справочник типов родственных связей."

* patient ^short = "Пациент"
* patient only Reference(Core_Patient)

* relationship ^short = "Отношение представителя к пациенту"
* relationship from https://fhir.ru/ig/core/ValueSet/relatedperson-relationship (required)
* relationship.coding.system = "https://fhir.ru/ig/core/CodeSystem/core-relatedperson-codesystem" (exactly)

* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains
    snils 0..1

* identifier[snils] ^short = "СНИЛС представителя пациента"
  * system = "https://fhir.ru/ig/core/systems/snils" (exactly)
  * type 1..1
  * type ^short = "Тип идентификатора, кодируется по Fixed value: http://terminology.hl7.org/CodeSystem/v2-0203" 
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#SB

* name ^short = "ФИО представителя пациента"
  * family ^short = "Фамилия представителя пациента"
  * given ^short = "Имя и отчество представителя пациента. Первым должно идти имя, вторым - отчество"
  * use ^short = "Тип имени представителя пациента. Рекомендуемое значение: official"

* telecom ^short = "Контакты представителя пациента"
* telecom.system from http://hl7.org/fhir/ValueSet/contact-point-system (required)
* telecom.value 1..1

* address ^short = "Адрес представителя пациента"
* address only Core_Address
