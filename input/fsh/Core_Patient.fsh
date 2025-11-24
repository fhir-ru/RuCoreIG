Profile: Core_Patient
Parent: Patient
Id: core-patient
Title: "Core Patient (Пациент)"
Description: "Базовый профиль пациента для российских FHIR-реализаций"

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка по типам идентификаторов пациента"
* identifier contains 
  snils 0..1 and
  inn 0..1 and
  identityDocument 0..* and
  omsPolicy 0..1

* identifier[snils] ^short = "Страховой номер индивидуального лицевого счёта (СНИЛС)"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/snils"
  * type 1..1
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#SB

* identifier[inn] ^short = "Идентификационный номер налогоплательщика (ИНН)"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/inn"
  * type 1..1
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#TAX

* identifier[identityDocument] ^short = "Документ, удостоверяющий личность"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/identity-document"
  * type 1..1
  * type from Core_Vs_Nsi_Identity_Documents (required)

* identifier[omsPolicy] ^short = "Полис ОМС"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/OMS"
  * type 1..1
  * type.coding ^slicing.discriminator.type = #value
  * type.coding ^slicing.discriminator.path = "system"
  * type.coding ^slicing.rules = #open
  * type.coding ^slicing.description = "Нарезка по способу указания кода полиса ОМС"
  * type.coding contains 
      hl7Type 0..1
  * type.coding[hl7Type] = http://terminology.hl7.org/CodeSystem/v2-0203#SB

* name ^short = "ФИО пациента"
  * family ^short = "Фамилия"
  * given ^short = "Имя и отчество пациента"
  * given ^definition = "Массив строк: первый элемент - имя, второй элемент - отчество"
  * use ^short = "Тип имени пациента. Рекомендуемое значение: official"

* gender ^short = "Пол пациента. Используются позиции: male | female | unknown. Other - не используется для совместимости со Справочником НСИ Пол пациента"

* birthDate ^short = "Дата рождения пациента, формат YYYY-MM-DD или YYYY-MM-DDTHH:MM для новорождённых"

* address ^short = "Адрес пациента"
* address only Core_Address

* managingOrganization ^short = "Ответственная организация"
* managingOrganization only Reference(Core_Organization) 