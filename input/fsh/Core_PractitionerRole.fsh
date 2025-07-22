Profile: Core_PractitionerRole
Parent: PractitionerRole
Id: core-practitionerrole
Title: "Роль медицинского работника"
Description: "Профиль PractitionerRole для RuCore"

* practitioner ^short = "Медицинский работник"
* practitioner only Reference(Core_Practitioner)

* organization ^short = "Организация"
* organization only Reference(Core_Organization)

* code ^short = "Должность медицинского работника"
* code from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-workers-positions (required) 