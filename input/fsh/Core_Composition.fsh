Profile: Core_Composition
Parent: Composition
Id: core-composition
Title: "Core Composition (Документ)"
Description: "Базовый профиль Composition для РФ"

* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Идентификатор набора версий документа в экземпляре МИС по правилам СЭМД; срез распознается по совокупности установленных для него ограничений"
* identifier contains
  misDocumentSet 0..1

* identifier[misDocumentSet] ^short = "Идентификатор набора версий документа в экземпляре МИС"
* identifier[misDocumentSet] ^definition = "Локальный идентификатор набора версий документа (CDA setId) в экземпляре медицинской информационной системы по правилам СЭМД."
* identifier[misDocumentSet] ^comment = "Identifier.system указывается в URI-форме OID: urn:oid:{OID медицинской организации}.{ветка МИС}.{номер МИС}.{номер экземпляра МИС}.50[.{дочерний узел}...]. Для ветки МИС обычно используется узел 100; если он уже занят, допускается другой узел. Идентификатор отдельной версии документа с узлом 51 соответствует идентификатору документного Bundle, а не Composition.identifier."
  * system 1..1
  * value 1..1
  * obeys core-composition-mis-document-set-system

* type ^short = "Тип документа"

* subject ^short = "Пациент"

* author ^short = "Автор"
* author only Reference(Device or Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)

* custodian ^short = "Хранитель документа"
* custodian only Reference(Core_Organization)

* attester ^short = "Лицо, придавшее юридическую силу"
* attester.party only Reference(Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)

Invariant: core-composition-mis-document-set-system
Description: "Система идентификатора набора версий документа в МИС должна быть URI-формой OID по правилам СЭМД с типовым узлом 50"
Severity: #error
Expression: "system.matches('^urn:oid:[0-2]([.](0|[1-9][0-9]*)){2,}[.][1-9][0-9]*[.][1-9][0-9]*[.][1-9][0-9]*[.]50([.](0|[1-9][0-9]*))*$')"
