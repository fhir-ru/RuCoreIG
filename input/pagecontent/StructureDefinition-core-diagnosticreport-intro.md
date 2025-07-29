# Core_DiagnosticReport — Профиль диагностического отчета

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Описание пациента должно соответствовать требованиям РФ | subject | Должен быть представлен профилем Core_Patient |
| Описание случая обслуживания должно соответствовать требованиям РФ | encounter | Должен быть представлен профилем Core_Encounter |
| Направление на исследование должно соответствовать требованиям РФ | basedOn | Должен быть представлен профилем Core_ServiceRequest |
| Описание исполнителя исследования должно соответствовать требованиям РФ | performer | Должен быть представлен профилем Core_PractitionerRole |
| Описание интерпретатора исследования должно соответствовать требованиям РФ | resultsInterpreter | Должен быть представлен профилем Core_PractitionerRole |

## Описание профиля

Профиль Core_DiagnosticReport расширяет стандартный ресурс DiagnosticReport для поддержки российских требований:
- Субъект отчета (пациент) должен быть представлен профилем Core_Patient
- Случай обслуживания должен быть представлен профилем Core_Encounter
- Направление на исследование должно быть представлено профилем Core_ServiceRequest
- Исполнитель исследования должен быть представлен профилем Core_PractitionerRole
- Интерпретатор результатов должен быть представлен профилем Core_PractitionerRole

---

### FSH-код профиля

```fsh
Profile: Core_DiagnosticReport
Parent: DiagnosticReport
Id: core-diagnosticreport
Title: "Core DiagnosticReport (Диагностический отчет)"
Description: "Базовый профиль диагностического отчета для российских FHIR-реализаций"

* subject only Reference(Core_Patient)
* encounter only Reference(Core_Encounter)
* basedOn only Reference(Core_ServiceRequest)
* performer only Reference(Core_PractitionerRole)
* resultsInterpreter only Reference(Core_PractitionerRole)
``` 