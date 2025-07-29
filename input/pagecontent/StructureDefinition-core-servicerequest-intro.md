# Core_ServiceRequest — Профиль запроса на услугу

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Описание пациента должен соответствовать требованиям РФ | subject | Должен быть представлен профилем Core_Patient |
| Описание направляющего врача должен соответствовать требованиям РФ | requester | Должен быть представлен профилем Core_PractitionerRole |
| Описание исполнителя должен соответствовать требованиям РФ | performer | Должен быть представлен профилем Core_PractitionerRole |
| Описание случая обслуживания должен соответствовать требованиям РФ | encounter | Должен быть представлен профилем Core_Encounter |
| Описание страхового покрытия должен соответствовать требованиям РФ | coverage | Должен быть представлен профилем Core_Coverage |

## Описание профиля

Профиль Core_ServiceRequest расширяет стандартный ресурс ServiceRequest для поддержки российских требований:
- Субъект запроса (пациент) должен быть представлен профилем Core_Patient
- Направляющий врач должен быть представлен профилем Core_PractitionerRole
- Исполнитель должен быть представлен профилем Core_PractitionerRole
- Случай обслуживания должен быть представлен профилем Core_Encounter
- Страховое покрытие должно быть представлено профилем Core_Coverage

---

### FSH-код профиля

```fsh
Profile: Core_ServiceRequest
Parent: ServiceRequest
Id: core-servicerequest
Title: "Core ServiceRequest (Запрос на услугу)"
Description: "Базовый профиль запроса на услугу для российских FHIR-реализаций"

* subject only Reference(Core_Patient)
* requester only Reference(Core_PractitionerRole)
* performer only Reference(Core_PractitionerRole)
* encounter only Reference(Core_Encounter)
* coverage only Reference(Core_Coverage)
``` 