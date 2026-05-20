Profile: Core_Composition
Parent: Composition
Id: core-composition
Title: "Core Composition (Документ)"
Description: "Базовый профиль Composition для РФ"

* type ^short = "Тип документа"

* subject ^short = "Пациент"

* author ^short = "Автор"
* author only Reference(Device or Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)

* custodian ^short = "Хранитель документа"
* custodian only Reference(Core_Organization)

* attester ^short = "Лицо, придавшее юридическую силу"
* attester.party only Reference(Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)
