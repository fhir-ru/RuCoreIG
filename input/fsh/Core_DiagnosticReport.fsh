Profile: Core_DiagnosticReport
Parent: DiagnosticReport
Id: core-diagnosticreport
Title: "Протокол исследования"
Description: "Профиль DiagnosticReport для RuCore"


* subject ^short = "Пациент"
* subject only Reference(Core_Patient)

* encounter ^short = "Случай оказания медицинской помощи"
* encounter only Reference(Core_Encounter)

* basedOn ^short = "Основание для исследования"
* basedOn only Reference(Core_ServiceRequest)

* performer ^short = "Исполнитель"
* performer only Reference(Core_PractitionerRole or Core_CareTeam)

* resultsInterpreter ^short = "Интерпретатор результатов"
* resultsInterpreter only Reference(Core_PractitionerRole)

