# Core_EpisodeOfCare — Профиль эпизода лечения

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Описание пациента должно соответствовать требованиям РФ | patient | Должен быть представлен профилем Core_Patient |
| Описание организации, ответственной за эпизод помощи, должно соответствовать требованиям РФ | managingOrganization | Должен быть представлен профилем Core_Organization |

## Описание профиля

Профиль Core_EpisodeOfCare расширяет стандартный ресурс EpisodeOfCare для поддержки российских требований:
- Пациент должен быть представлен профилем Core_Patient
- Организация, ответственная за эпизод помощи, должна быть представлена профилем Core_Organization

---

### FSH-код профиля

```fsh
Profile: Core_EpisodeOfCare
Parent: EpisodeOfCare
Id: core-episodeofcare
Title: "Core EpisodeOfCare (Эпизод лечения)"
Description: "Базовый профиль эпизода лечения для российских FHIR-реализаций"

* patient only Reference(Core_Patient)
* managingOrganization only Reference(Core_Organization)
``` 