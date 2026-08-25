# Core_Composition — Профиль состава документа

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходимо передавать идентификатор набора версий документа в экземпляре МИС по правилам СЭМД | identifier | Определен необязательный срез `misDocumentSet` без discriminator; он представляет CDA `setId`, а структура динамического `system` описана комментарием и инвариантом |
| Описание субъекта документа должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | subject | Тип `Composition.subject` в R5 не сужается, чтобы не потерять допустимые варианты `Reference(Any)` |
| Описание автора документа должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | author | Для `Organization`, `Patient`, `Practitioner`, `PractitionerRole`, `RelatedPerson` используются профили RuCore, остальные допустимые типы R5 сохранены |
| Описание хранителя документа должно соответствовать требованиям РФ | custodian | Должен быть представлен профилем Core_Organization |
| Описание лица, придавшего документу юридическую силу, должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | attester | Для `Organization`, `Patient`, `Practitioner`, `PractitionerRole`, `RelatedPerson` используются профили RuCore |

## Описание профиля

Профиль Core_Composition расширяет стандартный ресурс Composition для поддержки российских требований:
- Для идентификатора набора версий документа (CDA `setId`) определен необязательный срез `identifier[misDocumentSet]` с типовым узлом OID `50`
- `identifier[misDocumentSet].system` передается в URI-форме OID и может содержать дочерние узлы после `50`; `system` и `value` обязательны только при использовании среза
- `Composition.subject` оставлен без сужения типов, чтобы сохранить полную семантику `Reference(Any)` из R5
- Если `author` ссылается на профилируемый ресурс RuCore, должен использоваться соответствующий профиль RuCore
- Хранитель документа должен быть представлен профилем Core_Organization
- Если `attester.party` ссылается на профилируемый ресурс RuCore, должен использоваться соответствующий профиль RuCore

Срез открыт и не имеет discriminator, поскольку `system` динамически зависит от медицинской организации, МИС и экземпляра МИС. В RuCore он документирует единое представление идентификатора; строгую проверку принадлежности срезу должны обеспечивать системы СЭМД и наследованные прикладные профили. Идентификатор конкретной версии документа с типовым узлом `51` относится к документному `Bundle.identifier`, а не к `Composition.identifier`.

---

### FSH-код профиля

```fsh
Profile: Core_Composition
Parent: Composition
Id: core-composition
Title: "Core Composition (Состав документа)"
Description: "Базовый профиль состава документа для российских FHIR-реализаций"

* identifier ^slicing.rules = #open
* identifier contains misDocumentSet 0..1

* identifier[misDocumentSet]
  * system 1..1
  * value 1..1
  * obeys core-composition-mis-document-set-system

* author only Reference(Device or Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)
* custodian only Reference(Core_Organization)
* attester
  * party only Reference(Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)

Invariant: core-composition-mis-document-set-system
Description: "Система идентификатора набора версий документа в МИС должна быть URI-формой OID по правилам СЭМД с типовым узлом 50"
Severity: #error
Expression: "system.matches('^urn:oid:[0-2]([.](0|[1-9][0-9]*)){2,}[.][1-9][0-9]*[.][1-9][0-9]*[.][1-9][0-9]*[.]50([.](0|[1-9][0-9]*))*$')"
``` 
