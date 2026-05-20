# Core_Composition — Профиль состава документа

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Описание субъекта документа должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | subject | Тип `Composition.subject` в R5 не сужается, чтобы не потерять допустимые варианты `Reference(Any)` |
| Описание автора документа должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | author | Для `Organization`, `Patient`, `Practitioner`, `PractitionerRole`, `RelatedPerson` используются профили RuCore, остальные допустимые типы R5 сохранены |
| Описание хранителя документа должно соответствовать требованиям РФ | custodian | Должен быть представлен профилем Core_Organization |
| Описание лица, придавшего документу юридическую силу, должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | attester | Для `Organization`, `Patient`, `Practitioner`, `PractitionerRole`, `RelatedPerson` используются профили RuCore |

## Описание профиля

Профиль Core_Composition расширяет стандартный ресурс Composition для поддержки российских требований:
- `Composition.subject` оставлен без сужения типов, чтобы сохранить полную семантику `Reference(Any)` из R5
- Если `author` ссылается на профилируемый ресурс RuCore, должен использоваться соответствующий профиль RuCore
- Хранитель документа должен быть представлен профилем Core_Organization
- Если `attester.party` ссылается на профилируемый ресурс RuCore, должен использоваться соответствующий профиль RuCore

---

### FSH-код профиля

```fsh
Profile: Core_Composition
Parent: Composition
Id: core-composition
Title: "Core Composition (Состав документа)"
Description: "Базовый профиль состава документа для российских FHIR-реализаций"

* author only Reference(Device or Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)
* custodian only Reference(Core_Organization)
* attester
  * party only Reference(Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)
``` 
