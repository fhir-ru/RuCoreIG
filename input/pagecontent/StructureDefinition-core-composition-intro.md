# Core_Composition — Профиль состава документа

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходимо передавать идентификатор набора версий документа в экземпляре МИС по правилам СЭМД | identifier | Определен необязательный срез `misDocumentSet` кратностью `0..1`; открытая нарезка распознает его по коду `mis-document-set` в `Identifier.type`, он представляет CDA `ClinicalDocument.setId`, а структура `system` проверяется инвариантом |
| Описание субъекта документа должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | subject | Тип `Composition.subject` в R5 не сужается, чтобы не потерять допустимые варианты `Reference(Any)` |
| Описание автора документа должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | author | Для `Organization`, `Patient`, `Practitioner`, `PractitionerRole`, `RelatedPerson` используются профили RuCore, остальные допустимые типы R5 сохранены |
| Описание хранителя документа должно соответствовать требованиям РФ | custodian | Должен быть представлен профилем Core_Organization |
| Описание лица, придавшего документу юридическую силу, должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | attester | Для `Organization`, `Patient`, `Practitioner`, `PractitionerRole`, `RelatedPerson` используются профили RuCore |

## Описание профиля

Профиль Core_Composition расширяет стандартный ресурс Composition для поддержки российских требований:

- Для идентификатора набора версий документа (CDA `setId`) определен необязательный срез `identifier[misDocumentSet]` с типовым узлом OID `50`
- Срез распознается по семантическому коду `mis-document-set` из `Core_Cs_Semd_Identifier_Type`; нарезка остается открытой для идентификаторов других типов
- `identifier[misDocumentSet].system` строго соответствует формуле `urn:oid:1.2.643.5.1.13.13.12.2.{субъект РФ}.{медицинская организация ФРМО}.100.{МИС}.{экземпляр МИС}.50`; `system` и `value` обязательны только при использовании среза
- `Composition.subject` оставлен без сужения типов, чтобы сохранить полную семантику `Reference(Any)` из R5
- Если `author` ссылается на профилируемый ресурс RuCore, должен использоваться соответствующий профиль RuCore
- Хранитель документа должен быть представлен профилем Core_Organization
- Если `attester.party` ссылается на профилируемый ресурс RuCore, должен использоваться соответствующий профиль RuCore

Идентификатор с узлом `.50` остается одинаковым для всех версий документа. Идентификатор конкретного экземпляра документа с узлом `.51` передается в `Core_Bundle.identifier`. Его не следует путать с номером версии: CDA `ClinicalDocument.versionNumber` соответствует базовому элементу `Composition.version`, который RuCore дополнительно не профилирует.

```text
CDA ClinicalDocument.id            -> Bundle.identifier (.51)
CDA ClinicalDocument.setId         -> Composition.identifier (.50)
CDA ClinicalDocument.versionNumber -> Composition.version
```

---

### FSH-код профиля

```fsh
Profile: Core_Composition
Parent: Composition
Id: core-composition
Title: "Core Composition (Состав документа)"
Description: "Базовый профиль состава документа для российских FHIR-реализаций"

* identifier.type from Core_Vs_Identifier_Type (extensible)
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier contains misDocumentSet 0..1

* identifier[misDocumentSet]
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-document-set
  * system 1..1
  * value 1..1
  * obeys core-composition-mis-document-set-system

* author only Reference(Device or Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)
* custodian only Reference(Core_Organization)
* attester
  * party only Reference(Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)

Invariant: core-composition-mis-document-set-system
Description: "Система идентификатора набора версий документа в МИС должна соответствовать структуре с корнем ФРМО и типовым узлом 50"
Severity: #error
Expression: "system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]50$')"
``` 
