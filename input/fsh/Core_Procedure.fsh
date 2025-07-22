Profile: Core_Procedure
Parent: Procedure
Id: core-procedure
Title: "Core Procedure (Процедура)"
Description: "Базовый профиль процедуры для российских FHIR-реализаций"

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка по типам идентификаторов процедуры"
* identifier contains 
  medicalServiceCode 0..1

* identifier[medicalServiceCode] ^short = "Код услуги по Номенклатуре медицинских услуг МЗ РФ"
  * value only string
  * system 1..1
  * system = "urn:oid:1.2.643.5.1.13.13.11.1070"
  * type 1..1
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#PLAC

* status ^short = "Статус процедуры"
* status from http://hl7.org/fhir/ValueSet/event-status-codes (required)

* code ^short = "Код процедуры"
* code from Core_Vs_Nsi_Medical_Services (required)

* subject ^short = "Пациент"
* subject only Reference(Core_Patient)

* occurrence[x] ^short = "Дата и время выполнения процедуры"

* performer ^short = "Исполнитель процедуры"
* performer.actor only Reference(Core_PractitionerRole)

* reason ^short = "Причина выполнения процедуры"
* reason from http://hl7.org/fhir/ValueSet/procedure-reason (extensible)

* note ^short = "Примечания к процедуре"
