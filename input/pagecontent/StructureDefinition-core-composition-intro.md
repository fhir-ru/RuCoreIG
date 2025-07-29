# Core_Composition — Профиль состава документа

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Описание пациента должно соответствовать требованиям РФ | subject | Должен быть представлен профилем Core_Patient |
| Описание автора документа должно соответствовать требованиям РФ | author | Должен быть представлен профилем Core_PractitionerRole |
| Описание хранителя документа должно соответствовать требованиям РФ | custodian | Должен быть представлен профилем Core_Organization |
| Описание лица, придавшего документу юридическую силу, должно соответствовать требованиям РФ | attester | Должен быть представлен профилем Core_PractitionerRole |

## Описание профиля

Профиль Core_Composition расширяет стандартный ресурс Composition для поддержки российских требований:
- Субъект документа (пациент) должен быть представлен профилем Core_Patient
- Автор документа должен быть представлен профилем Core_PractitionerRole
- Хранитель документа должен быть представлен профилем Core_Organization
- Лицо, придавшее документу юридическую силу, должно быть представлено профилем Core_PractitionerRole

---

### FSH-код профиля

```fsh
Profile: Core_Composition
Parent: Composition
Id: core-composition
Title: "Core Composition (Состав документа)"
Description: "Базовый профиль состава документа для российских FHIR-реализаций"

* subject only Reference(Core_Patient)
* author only Reference(Core_PractitionerRole)
* custodian only Reference(Core_Organization)
* attester
  * party only Reference(Core_PractitionerRole)
``` 