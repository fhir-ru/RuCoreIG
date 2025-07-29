Profile: Core_Composition
Parent: Composition
Id: core-composition
Title: "Core Composition (Документ)"
Description: "Базовый профиль Composition для РФ"

* type ^short = "Тип документа"

* subject ^short = "Пациент"
* subject only Reference(Core_Patient)

* author ^short = "Автор"
* author only Reference(Core_PractitionerRole)

* custodian ^short = "Хранитель документа"
* custodian only Reference(Core_Organization)

* attester ^short = "Лицо, придавшее юридическую силу"
* attester.party only Reference(Core_PractitionerRole)
