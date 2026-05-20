# Core_DiagnosticReport — Профиль диагностического отчета

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Описание субъекта отчета должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | subject | Для `Patient`, `Practitioner`, `Organization` используются профили RuCore, при этом сохраняются остальные допустимые типы из базового R5 |
| Описание случая обслуживания должно соответствовать требованиям РФ | encounter | Должен быть представлен профилем Core_Encounter |
| Направление на исследование должно соответствовать требованиям РФ, если ссылка указывает на `ServiceRequest` | basedOn | Для `ServiceRequest` должен использоваться профиль Core_ServiceRequest, при этом сохраняются остальные допустимые типы `basedOn` из R5 |
| Описание исполнителя исследования должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | performer | Для `Practitioner`, `PractitionerRole`, `Organization`, `CareTeam` используются профили RuCore |
| Описание интерпретатора исследования должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | resultsInterpreter | Для `Practitioner`, `PractitionerRole`, `Organization`, `CareTeam` используются профили RuCore |

## Описание профиля

Профиль Core_DiagnosticReport расширяет стандартный ресурс DiagnosticReport для поддержки российских требований:
- Если `subject` ссылается на профилируемый ресурс RuCore, должен использоваться соответствующий профиль RuCore, при этом остальные допустимые типы R5 сохранены
- Случай обслуживания должен быть представлен профилем Core_Encounter
- Если `basedOn` ссылается на `ServiceRequest`, должен использоваться профиль Core_ServiceRequest, при этом остальные допустимые типы R5 сохранены
- Если `performer` и `resultsInterpreter` ссылаются на профилируемые ресурсы RuCore, должны использоваться соответствующие профили RuCore

---

### FSH-код профиля

```fsh
Profile: Core_DiagnosticReport
Parent: DiagnosticReport
Id: core-diagnosticreport
Title: "Core DiagnosticReport (Диагностический отчет)"
Description: "Базовый профиль диагностического отчета для российских FHIR-реализаций"

* subject only Reference(Core_Patient or Group or Device or Location or Core_Organization or Core_Practitioner or Medication or Substance or BiologicallyDerivedProduct)
* encounter only Reference(Core_Encounter)
* basedOn only Reference(CarePlan or ImmunizationRecommendation or MedicationRequest or NutritionOrder or Core_ServiceRequest)
* performer only Reference(Core_Practitioner or Core_PractitionerRole or Core_Organization or Core_CareTeam)
* resultsInterpreter only Reference(Core_Practitioner or Core_PractitionerRole or Core_Organization or Core_CareTeam)
``` 
