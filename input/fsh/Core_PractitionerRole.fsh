Profile: Core_PractitionerRole
Parent: PractitionerRole
Id: core-practitionerrole
Title: "Core PractitionerRole (Роль медицинского работника)"
Description: "Профиль PractitionerRole для RuCore"

* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка для идентификаторов роли медицинского работника; срезы распознаются по совокупности установленных для них ограничений"
* identifier contains
  misPractitionerRole 0..*

* identifier[misPractitionerRole] ^short = "Идентификатор роли медицинского работника в экземпляре МИС"
* identifier[misPractitionerRole] ^definition = "Локальный идентификатор роли медицинского работника в экземпляре медицинской информационной системы, передаваемый с system, сформированным по правилам СЭМД."
* identifier[misPractitionerRole] ^comment = "Identifier.system указывается в URI-форме OID: urn:oid:<OID медицинской организации>.<ветка МИС>.<номер МИС>.<номер экземпляра МИС>.70. Для ветки МИС обычно используется узел 100; если он уже занят, допускается другой узел при сохранении структуры дочерних OID."
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
Description: "Система идентификатора роли медицинского работника в МИС должна быть URI-формой OID, сформированного по правилам СЭМД и оканчивающегося узлом 70"
Severity: #error
Expression: "system.matches('^urn:oid:[0-2]([.](0|[1-9][0-9]*)){2,}[.][1-9][0-9]*[.][1-9][0-9]*[.][1-9][0-9]*[.]70$')"
