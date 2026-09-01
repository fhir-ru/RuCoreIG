# Core_Encounter — Профиль случая обслуживания

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходимо передавать идентификатор случая, номер связанной стационарной карты и идентификатор амбулаторного случая или посещения в экземпляре МИС по правилам СЭМД | identifier | Определены необязательные срезы `misEncounter`, `misInpatientRecord` и `misAmbulatoryEncounter` без discriminator; структура динамического `system` описана комментарием и инвариантом |
| Описание субъекта случая обслуживания должно соответствовать требованиям, если ссылка указывает на `Patient` | subject | Для `Patient` должен использоваться профиль Core_Patient, при этом тип `Group` из базового R5 сохраняется |
| Описание эпизода лечения должно соответствовать требованиям | episodeOfCare | Должен быть представлен профилем Core_EpisodeOfCare. Рекомендуется использовать данный атрибут для включения данного Encounter в медицинский эпизод, например, диагностика и лечение определенного заболевания в различных организациях. В то же время, для моделирования учета медицинской помощи в одной организации следует использовать иерархию Encounter, например: Амбулаторная карта – Случай амбулаторного обслуживания – Посещение врача. |
| Описание исполняющей организации должно соответствовать требованиям | serviceProvider | Должен быть представлен профилем Core_Organization |
| Диагноз случая нужно передавать либо ссылкой на `Condition`, либо кодом и текстом внутри Encounter | diagnosis.condition | Используется тип FHIR R5 `CodeableReference(Condition)`. Отдельный ресурс `Condition` не обязателен. МКБ-10 принята как базовый пример кодирования; профильные классификаторы допускаются. Состояния после процедур кодируются как диагнозы, а не ссылками на `Procedure` |
| При нескольких диагнозах можно указать структуру диагноза, в том числе основное заболевание | diagnosis.use | Две оси в множественном `CodeableConcept` `0..*`: рубрика по НСИ `1.2.643.5.1.13.13.11.1077` и этапность по НСИ `1.2.643.5.1.13.13.99.2.795`. Стандартный preferred ValueSet HL7 признан недостаточным. Требование ровно одного основного диагноза выносится в прикладные профили СЭМД |
| Нужно сохранить авторский порядок врача, если в одной рубрике несколько диагнозов | diagnosis.extension[rank] | Добавлено расширение `diagnosis-rank` (`positiveInt`), восстанавливающее исключенный в FHIR R5 элемент `Encounter.diagnosis.rank` |

## Описание профиля

Профиль Core_Encounter расширяет стандартный ресурс Encounter для поддержки российских требований:
- Для идентификаторов СЭМД определены необязательные срезы `identifier[misEncounter]`, `identifier[misInpatientRecord]` и `identifier[misAmbulatoryEncounter]` с типовыми узлами OID `15`, `16` и `17`
- Каждый `Identifier.system` передается в URI-форме OID и может содержать дочерние узлы после типового узла; `system` и `value` обязательны только при использовании соответствующего среза
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

Срезы идентификаторов открыты и не имеют discriminator, поскольку их `system` динамически зависит от медицинской организации, МИС и экземпляра МИС. В RuCore они документируют единое представление идентификаторов; строгую проверку принадлежности срезу должны обеспечивать системы СЭМД и наследованные прикладные профили.

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

* identifier ^slicing.rules = #open
* identifier contains
  misEncounter 0..* and
  misInpatientRecord 0..* and
  misAmbulatoryEncounter 0..*

* identifier[misEncounter]
  * system 1..1
  * value 1..1
  * obeys core-encounter-mis-encounter-system

* identifier[misInpatientRecord]
  * system 1..1
  * value 1..1
  * obeys core-encounter-mis-inpatient-system

* identifier[misAmbulatoryEncounter]
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
```
