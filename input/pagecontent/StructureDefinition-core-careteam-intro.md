# Core_CareTeam — Профиль бригады (CareTeam)

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Описание участника бригады должно соответствовать требованиям РФ | Participant.member | Должен быть представлен профилем Core_PractitionerRole |

## Описание профиля

Профиль Core_CareTeam расширяет стандартный ресурс CareTeam для поддержки требований РФ. Участник бригады должен быть представлен профилем Core_PractitionerRole.

---

### FSH-код профиля

```fsh
Profile: Core_CareTeam
Parent: CareTeam
Id: core-careteam
Title: "Core CareTeam (Бригада)"
Description: "Профиль CareTeam для РФ"

* participant
  * member only Reference(Core_PractitionerRole)
``` 