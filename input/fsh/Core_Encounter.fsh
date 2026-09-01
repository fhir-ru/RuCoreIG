Profile: Core_Encounter
Parent: Encounter
Id: core-encounter
Title: "Core Encounter (Случай оказания медицинской помощи)"
Description: "Профиль Encounter для RuCore"

* identifier.type from Core_Vs_Identifier_Type (extensible)
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Идентификаторы случаев оказания медицинской помощи в экземпляре МИС; срезы распознаются по семантическому типу идентификатора"
* identifier contains
  misEncounter 0..1 and
  misInpatientRecord 0..1 and
  misAmbulatoryEncounter 0..1

* identifier[misEncounter] ^short = "Идентификатор случая оказания медицинской помощи в экземпляре МИС"
* identifier[misEncounter] ^definition = "Локальный идентификатор общего случая оказания медицинской помощи в экземпляре медицинской информационной системы по правилам СЭМД."
* identifier[misEncounter] ^comment = "Identifier.system формируется как urn:oid:1.2.643.5.1.13.13.12.2.{код субъекта Российской Федерации}.{идентификатор медицинской организации в ФРМО}.100.{номер МИС}.{номер экземпляра МИС}.15."
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-encounter
  * system 1..1
  * value 1..1
  * obeys core-encounter-mis-encounter-system

* identifier[misInpatientRecord] ^short = "Номер стационарной медицинской карты в экземпляре МИС"
* identifier[misInpatientRecord] ^definition = "Локальный номер стационарной медицинской карты (истории болезни), связанной со случаем обслуживания, в экземпляре медицинской информационной системы по правилам СЭМД."
* identifier[misInpatientRecord] ^comment = "Identifier.system формируется как urn:oid:1.2.643.5.1.13.13.12.2.{код субъекта Российской Федерации}.{идентификатор медицинской организации в ФРМО}.100.{номер МИС}.{номер экземпляра МИС}.16."
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-inpatient-record
  * system 1..1
  * value 1..1
  * obeys core-encounter-mis-inpatient-system

* identifier[misAmbulatoryEncounter] ^short = "Идентификатор амбулаторного случая или посещения в экземпляре МИС"
* identifier[misAmbulatoryEncounter] ^definition = "Локальный идентификатор посещения или случая оказания медицинской помощи в амбулаторных условиях, в том числе передаваемый как номер амбулаторной медицинской карты, в экземпляре медицинской информационной системы по правилам СЭМД."
* identifier[misAmbulatoryEncounter] ^comment = "Identifier.system формируется как urn:oid:1.2.643.5.1.13.13.12.2.{код субъекта Российской Федерации}.{идентификатор медицинской организации в ФРМО}.100.{номер МИС}.{номер экземпляра МИС}.17."
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-ambulatory-encounter
  * system 1..1
  * value 1..1
  * obeys core-encounter-mis-ambulatory-system

* subject ^short = "Пациент"
* subject only Reference(Core_Patient or Group)

* episodeOfCare ^short = "Эпизод медицинской помощи"
* episodeOfCare only Reference(Core_EpisodeOfCare)

* serviceProvider ^short = "Поставщик медицинских услуг"
* serviceProvider only Reference(Core_Organization)

* diagnosis ^short = "Диагноз случая оказания медицинской помощи"
* diagnosis ^definition = "Диагноз случая. Допускается несколько диагнозов, в том числе несколько записей одной рубрики. Требование ровно одного основного диагноза относится к прикладным профилям, а не к Core."
* diagnosis.extension contains DiagnosisRank named rank 0..1
* diagnosis.extension[rank] ^short = "Порядок диагноза в авторской последовательности врача"
* diagnosis.extension[rank] ^definition = "Восстанавливает исключенный в FHIR R5 элемент Encounter.diagnosis.rank. Используется, когда в одной рубрике несколько диагнозов и врачу важно сохранить их приоритет."

* diagnosis.condition 1..*
* diagnosis.condition ^short = "Диагноз как код/текст и/или ссылка на Condition"
* diagnosis.condition ^definition = "В FHIR R5 элемент имеет тип CodeableReference(Condition): диагноз можно передать ссылкой на Condition либо кодом и текстом внутри Encounter, без обязательного создания отдельного ресурса."
* diagnosis.condition ^comment = "МКБ-10 принимается как базовый и наиболее распространенный пример кодирования. Для специализированных областей допускаются профильные классификаторы. Состояния после процедур кодируются как диагнозы/состояния, а не ссылками на Procedure."
* diagnosis.condition only CodeableReference(Condition)
* diagnosis.condition obeys core-encounter-diagnosis-condition

* diagnosis.use 0..*
* diagnosis.use ^slicing.discriminator.type = #value
* diagnosis.use ^slicing.discriminator.path = "coding.system"
* diagnosis.use ^slicing.rules = #open
* diagnosis.use ^slicing.description = "Две оси классификации: структура диагноза (рубрика) и этапность установления"
* diagnosis.use contains
  diagnosisStructure 0..1 and
  diagnosisStage 0..1

* diagnosis.use[diagnosisStructure] ^short = "Структура диагноза (рубрика)"
* diagnosis.use[diagnosisStructure] ^definition = "Ось классификации по справочнику НСИ МЗ РФ «Виды нозологических единиц диагноза». При нескольких диагнозах позволяет выделить основное заболевание. Категории, исключенные из актуальной версии справочника, в том числе сочетанные заболевания, не требуются."
* diagnosis.use[diagnosisStructure] from Core_Vs_Nsi_Diagnosis_Nosology_Kind (required)
  * coding 1..1
    * system 1..1
    * system = Canonical(Core_Cs_Nsi_Diagnosis_Nosology_Kind)
    * code 1..1
    * code from Core_Vs_Nsi_Diagnosis_Nosology_Kind (required)

* diagnosis.use[diagnosisStage] ^short = "Этапность установления диагноза"
* diagnosis.use[diagnosisStage] ^definition = "Опциональная ось классификации по справочнику НСИ МЗ РФ «Степень обоснованности диагноза». Используется, чтобы зафиксировать этап случая или историю развития диагноза. В стационарной практике предварительный диагноз соответствует диагнозу при поступлении, заключительный — выписному."
* diagnosis.use[diagnosisStage] from Core_Vs_Nsi_Diagnosis_Justification_Degree (extensible)
  * coding 1..1
    * system 1..1
    * system = Canonical(Core_Cs_Nsi_Diagnosis_Justification_Degree)
    * code 1..1
    * code from Core_Vs_Nsi_Diagnosis_Justification_Degree (extensible)

Invariant: core-encounter-mis-encounter-system
Description: "Система идентификатора общего случая в МИС должна соответствовать структуре urn:oid:1.2.643.5.1.13.13.12.2.{субъект РФ}.{медицинская организация ФРМО}.100.{МИС}.{экземпляр МИС}.15"
Severity: #error
Expression: "system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]15$')"

Invariant: core-encounter-mis-inpatient-system
Description: "Система номера стационарной медицинской карты в МИС должна соответствовать структуре urn:oid:1.2.643.5.1.13.13.12.2.{субъект РФ}.{медицинская организация ФРМО}.100.{МИС}.{экземпляр МИС}.16"
Severity: #error
Expression: "system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]16$')"

Invariant: core-encounter-mis-ambulatory-system
Description: "Система идентификатора амбулаторного случая или посещения в МИС должна соответствовать структуре urn:oid:1.2.643.5.1.13.13.12.2.{субъект РФ}.{медицинская организация ФРМО}.100.{МИС}.{экземпляр МИС}.17"
Severity: #error
Expression: "system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]17$')"

Invariant: core-encounter-diagnosis-condition
Description: "В диагнозе случая должен быть указан код и/или текст и/или ссылка на ресурс Condition"
Severity: #error
Expression: "concept.exists() or reference.exists()"
