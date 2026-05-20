# Core_CareTeam — Профиль бригады (CareTeam)

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Описание участника бригады должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | Participant.member | Для `Practitioner`, `PractitionerRole`, `RelatedPerson`, `Patient`, `Organization`, `CareTeam` используются профили RuCore |

## Описание профиля

Профиль Core_CareTeam расширяет стандартный ресурс CareTeam для поддержки требований РФ. Если `participant.member` ссылается на профилируемый ресурс RuCore, должен использоваться соответствующий профиль RuCore, при этом сохраняются все допустимые типы из базового R5.

---

### FSH-код профиля

```fsh
Profile: Core_CareTeam
Parent: CareTeam
Id: core-careteam
Title: "Core CareTeam (Бригада)"
Description: "Профиль CareTeam для РФ"

* participant
  * member only Reference(Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson or Core_Patient or Core_Organization or Core_CareTeam)
``` 
