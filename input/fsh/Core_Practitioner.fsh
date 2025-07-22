Profile: Core_Practitioner
Parent: Practitioner
Id: core-practitioner
Title: "Core Practitioner (Медицинский работник)"
Description: "Базовый профиль медицинского работника для российских FHIR-реализаций"

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка по типам идентификаторов медицинского работника"
* identifier contains 
  snils 0..1 and
  identityDocument 0..*

* identifier[snils] ^short = "Страховой номер индивидуального лицевого счёта (СНИЛС)"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/semd/systems/snils"
  * type 1..1
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#SB

* identifier[identityDocument] ^short = "Документ, удостоверяющий личность"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/semd/systems/identity-document"
  * type 1..1
  * type from Core_Vs_Nsi_Identity_Documents (required)

* name ^short = "ФИО медицинского работника"
  * family ^short = "Фамилия"
  * given ^short = "Имя и отчество. Первым должно идти имя, вторым - отчество"
  * use ^short = "Тип имени. Рекомендуемое значение: official"

* gender ^short = "Пол. Используются позиции: male | female | unknown. Other - не используется для совместимости со Справочником НСИ Пол пациента"

* address ^short = "Адрес медицинского работника"
* address only Core_Address 