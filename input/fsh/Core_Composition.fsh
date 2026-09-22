Profile: Core_Composition
Parent: Composition
Id: core-composition
Title: "Core Composition (Документ)"
Description: "Базовый профиль Composition для РФ"

* identifier.type from Core_Vs_Identifier_Type (extensible)
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Идентификатор набора версий документа в экземпляре МИС; срез распознается по семантическому типу идентификатора"
* identifier contains
  misDocumentSet 0..1

* identifier[misDocumentSet] ^short = "Идентификатор набора версий документа в экземпляре МИС"
* identifier[misDocumentSet] ^definition = "Локальный идентификатор набора версий документа (CDA setId) в экземпляре медицинской информационной системы по правилам СЭМД."
* identifier[misDocumentSet] ^comment = "Identifier.system передаётся в URI-форме urn:oid:... с конечным узлом .50. RuCore проверяет URI-форму OID и конечный узел типа; корень медицинской организации, ветка и номера МИС не ограничиваются. Принадлежность OID организации требует отдельной проверки по реестру. Этот идентификатор соответствует CDA ClinicalDocument.setId и остается общим для набора версий. Идентификатор экземпляра документа с узлом 51 соответствует Bundle.identifier."
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-document-set
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
Description: "Система идентификатора набора версий документа в МИС должна быть OID в URI-форме urn:oid:... с конечным узлом .50"
Severity: #error
Expression: "system.matches('^urn:oid:[0-2]([.](0|[1-9][0-9]*))+[.]50$')"
