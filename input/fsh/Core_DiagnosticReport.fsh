Profile: Core_DiagnosticReport
Parent: DiagnosticReport
Id: core-diagnosticreport
Title: "Core DiagnosticReport (Протокол исследования)"
Description: "Профиль DiagnosticReport для RuCore"


* subject ^short = "Пациент"
* subject only Reference(Core_Patient or Group or Device or Location or Core_Organization or Core_Practitioner or Medication or Substance or BiologicallyDerivedProduct)

* encounter ^short = "Случай оказания медицинской помощи"
* encounter only Reference(Core_Encounter)

* basedOn ^short = "Основание для исследования"
* basedOn only Reference(CarePlan or ImmunizationRecommendation or MedicationRequest or NutritionOrder or Core_ServiceRequest)

* performer ^short = "Исполнитель"
* performer only Reference(Core_Practitioner or Core_PractitionerRole or Core_Organization or Core_CareTeam)

* resultsInterpreter ^short = "Интерпретатор результатов"
* resultsInterpreter only Reference(Core_Practitioner or Core_PractitionerRole or Core_Organization or Core_CareTeam)
