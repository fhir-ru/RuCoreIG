# Core_Encounter — Профиль случая обслуживания

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходимо передавать идентификатор случая, номер связанной стационарной карты и идентификатор амбулаторного случая или посещения в экземпляре МИС по правилам СЭМД | identifier | Определены необязательные срезы `misEncounter`, `misInpatientRecord` и `misAmbulatoryEncounter` кратностью `0..1`; открытая нарезка распознает их по семантическому `Identifier.type`, а точная структура `system` проверяется инвариантами |
| Описание субъекта случая обслуживания должно соответствовать требованиям, если ссылка указывает на `Patient` | subject | Для `Patient` должен использоваться профиль Core_Patient, при этом тип `Group` из базового R5 сохраняется |
| Описание эпизода лечения должно соответствовать требованиям | episodeOfCare | Должен быть представлен профилем Core_EpisodeOfCare. Рекомендуется использовать данный атрибут для включения данного Encounter в медицинский эпизод, например, диагностика и лечение определенного заболевания в различных организациях. В то же время, для моделирования учета медицинской помощи в одной организации следует использовать иерархию Encounter, например: Амбулаторная карта – Случай амбулаторного обслуживания – Посещение врача. |
| Описание исполняющей организации должно соответствовать требованиям | serviceProvider | Должен быть представлен профилем Core_Organization |
| Диагноз случая нужно передавать либо ссылкой на `Condition`, либо кодом и текстом внутри Encounter | diagnosis.condition | Используется тип FHIR R5 `CodeableReference(Condition)`. Отдельный ресурс `Condition` не обязателен. МКБ-10 принята как базовый пример кодирования; профильные классификаторы допускаются. Состояния после процедур кодируются как диагнозы, а не ссылками на `Procedure` |
| При нескольких диагнозах можно указать структуру диагноза, в том числе основное заболевание | diagnosis.use | Две оси в множественном `CodeableConcept` `0..*`: рубрика по НСИ `1.2.643.5.1.13.13.11.1077` и этапность по НСИ `1.2.643.5.1.13.13.99.2.795`. Стандартный preferred ValueSet HL7 признан недостаточным. Требование ровно одного основного диагноза выносится в прикладные профили СЭМД |
| Нужно сохранить авторский порядок врача, если в одной рубрике несколько диагнозов | diagnosis.extension[rank] | Добавлено расширение `diagnosis-rank` (`positiveInt`), восстанавливающее исключенный в FHIR R5 элемент `Encounter.diagnosis.rank` |

## Описание профиля

Профиль Core_Encounter расширяет стандартный ресурс Encounter для поддержки российских требований:

- Для идентификаторов СЭМД определены необязательные срезы `identifier[misEncounter]`, `identifier[misInpatientRecord]` и `identifier[misAmbulatoryEncounter]` кратностью `0..1` с типовыми узлами OID `15`, `16` и `17`
- Срезы распознаются по кодам `mis-encounter`, `mis-inpatient-record` и `mis-ambulatory-encounter` из `Core_Cs_Semd_Identifier_Type`; нарезка остается открытой для идентификаторов других типов
- Каждый `Identifier.system` строго соответствует формуле `urn:oid:1.2.643.5.1.13.13.12.2.{субъект РФ}.{медицинская организация ФРМО}.100.{МИС}.{экземпляр МИС}.{типовой узел}`; дополнительные узлы после `15`, `16` или `17` не допускаются
- Если `subject` ссылается на `Patient`, должен использоваться профиль Core_Patient, при этом тип `Group` из R5 сохраняется
- Эпизод лечения должен быть представлен профилем Core_EpisodeOfCare
- Исполняющая организация должна быть представлена профилем Core_Organization
- Диагноз случая передается в `diagnosis.condition` как `CodeableReference(Condition)`: ссылкой на `Condition` и/или кодом и текстом внутри Encounter
- Ось `diagnosis.use[diagnosisStructure]` кодирует рубрику по справочнику НСИ «Виды нозологических единиц диагноза»; ось `diagnosis.use[diagnosisStage]` кодирует этапность по справочнику НСИ «Степень обоснованности диагноза». Обе оси необязательны
- Порядок диагнозов внутри рубрики передается расширением `diagnosis.extension[rank]`

### Особенности использования

Профиль поддерживает два основных сценария использования:

1. **Межорганизационные эпизоды** - использование атрибута `episodeOfCare` для связывания случаев обслуживания в различных организациях в рамках одного медицинского эпизода
2. **Внутриорганизационная иерархия** - использование иерархии Encounter для моделирования учета медицинской помощи в одной организации (например: Амбулаторная карта → Случай амбулаторного обслуживания → Посещение врача)

Динамическая часть `system` не используется для распознавания среза: принадлежность определяется стабильным семантическим кодом в `Identifier.type`. Инварианты отдельно проверяют корень пространства ФРМО, фиксированный узел `100`, номера МИС и экземпляра МИС и конечный типовой узел.

`Core_Encounter` остается гибким национальным профилем: допускаются несколько диагнозов одной рубрики и несколько основных заболеваний. Более строгие правила, например требование ровно одного основного диагноза, должны вводиться прикладным профилем СЭМД как сужение Core.

В стационарной практике предварительный диагноз соответствует диагнозу при поступлении, заключительный клинический — выписному. Эти соответствия относятся к применению справочника этапности и не добавляют отдельных кодов в RuCore.

---

### FSH-код профиля

```fsh
Profile: Core_Encounter
Parent: Encounter
Id: core-encounter
Title: "Core Encounter (Случай обслуживания)"
Description: "Базовый профиль случая обслуживания для российских FHIR-реализаций"

* identifier.type from Core_Vs_Identifier_Type (extensible)
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier contains
  misEncounter 0..1 and
  misInpatientRecord 0..1 and
  misAmbulatoryEncounter 0..1

* identifier[misEncounter]
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-encounter
  * system 1..1
  * value 1..1
  * obeys core-encounter-mis-encounter-system

* identifier[misInpatientRecord]
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-inpatient-record
  * system 1..1
  * value 1..1
  * obeys core-encounter-mis-inpatient-system

* identifier[misAmbulatoryEncounter]
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-ambulatory-encounter
  * system 1..1
  * value 1..1
  * obeys core-encounter-mis-ambulatory-system

* subject only Reference(Core_Patient or Group)
* episodeOfCare only Reference(Core_EpisodeOfCare)
* serviceProvider only Reference(Core_Organization)

* diagnosis.extension contains DiagnosisRank named rank 0..1
* diagnosis.condition 1..*
* diagnosis.condition only CodeableReference(Condition)
* diagnosis.use 0..*
* diagnosis.use contains
  diagnosisStructure 0..1 and
  diagnosisStage 0..1
* diagnosis.use[diagnosisStructure] from Core_Vs_Nsi_Diagnosis_Nosology_Kind (required)
* diagnosis.use[diagnosisStage] from Core_Vs_Nsi_Diagnosis_Justification_Degree (extensible)

Invariant: core-encounter-mis-encounter-system
Description: "Система идентификатора общего случая в МИС должна соответствовать структуре с корнем ФРМО и типовым узлом 15"
Severity: #error
Expression: "system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]15$')"

Invariant: core-encounter-mis-inpatient-system
Description: "Система номера стационарной карты в МИС должна соответствовать структуре с корнем ФРМО и типовым узлом 16"
Severity: #error
Expression: "system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]16$')"

Invariant: core-encounter-mis-ambulatory-system
Description: "Система идентификатора амбулаторного случая или посещения в МИС должна соответствовать структуре с корнем ФРМО и типовым узлом 17"
Severity: #error
Expression: "system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]17$')"
```
