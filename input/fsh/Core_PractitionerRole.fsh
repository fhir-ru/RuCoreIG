Profile: Core_PractitionerRole
Parent: PractitionerRole
Id: core-practitionerrole
Title: "Core PractitionerRole (Роль медицинского работника)"
Description: "Профиль PractitionerRole для RuCore"

* identifier.type from Core_Vs_Identifier_Type (extensible)
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка для идентификаторов роли медицинского работника; срез распознается по семантическому типу идентификатора"
* identifier contains
  misPractitionerRole 0..1

* identifier[misPractitionerRole] ^short = "Идентификатор роли медицинского работника в экземпляре МИС"
* identifier[misPractitionerRole] ^definition = "Локальный идентификатор роли медицинского работника в экземпляре медицинской информационной системы, передаваемый с system, сформированным по правилам СЭМД."
* identifier[misPractitionerRole] ^comment = "Identifier.system формируется как urn:oid:1.2.643.5.1.13.13.12.2.{код субъекта Российской Федерации}.{идентификатор медицинской организации в ФРМО}.100.{номер МИС}.{номер экземпляра МИС}.70."
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-practitioner-role
  * system 1..1
  * value 1..1
  * obeys core-practitionerrole-mis-system

* practitioner ^short = "Медицинский работник"
* practitioner only Reference(Core_Practitioner)

* organization ^short = "Организация"
* organization only Reference(Core_Organization)

* code ^short = "Должность медицинского работника"
* code from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-workers-positions (extensible)

Invariant: core-practitionerrole-mis-system
Description: "Система идентификатора роли медицинского работника в МИС должна соответствовать структуре urn:oid:1.2.643.5.1.13.13.12.2.{субъект РФ}.{медицинская организация ФРМО}.100.{МИС}.{экземпляр МИС}.70"
Severity: #error
Expression: "system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]70$')"
