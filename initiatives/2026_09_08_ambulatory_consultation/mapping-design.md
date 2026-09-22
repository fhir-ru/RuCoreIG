# Реализованный маппинг

Полная единица трассировки — атрибут либо непустой текст/хвост XML. [trace.json](examples/trace.json) содержит стабильный `amb-map-NNNN`, исходный XPath с пространствами имён и индексами, номер строки, значение, правило, статус и список целей. Цель имеет вид `ResourceType/id#/JSON/pointer` либо `Bundle#/identifier`. [mapping.tsv](examples/mapping.tsv) — тот же материал для табличного просмотра. Все XPath и цели проверяются кодом.

## Основные группы

Пути ниже сокращены относительно ClinicalDocument; точные индексированные пути приведены в полной таблице.

| Источник CDA | Реализация FHIR | Ограничение / решение |
|---|---|---|
| `id`, `setId`, `versionNumber` | Bundle.identifier (.51), Composition.identifier (.50), Composition.version | Версия документа и идентичность серии не смешиваются |
| `effectiveTime`, `code`, `title`, `confidentialityCode` | Composition.date / причина отсутствия, type, title, confidentiality | Исходная дата NA; Bundle.timestamp — время преобразования |
| `recordTarget/patientRole` | Patient, паспорт и ОМС, адресные расширения Core | Дата выдачи и код органа паспорта пока в отчёте |
| `author`, `legalAuthenticator`, `informationRecipient`, участники | Practitioner, PractitionerRole, Organization; author, attester и административный раздел | Совпадающие ID при противоречивых именах не объединяются |
| `representedOrganization`, provider/custodian | Organization, qualification, идентификаторы и адреса Core | Подразделение сохраняется как II, отдельная иерархия не выводится |
| `documentationOf/serviceEvent` | Procedure события, участники, период | Тип события не подменяется кодом медицинской услуги |
| `componentOf/encompassingEncounter` | Encounter, период, локальные идентификаторы | Идентификатор .15 — Encounter.identifier посещения; .17 и код типа карты — partOf.identifier и его type; экземпляр карты и СПО не создаются |
| Плательщик, `identity:DocInfo` | Coverage и Patient.identifier | Срез Core Coverage блокирует валидацию |
| DOCINFO / LINKDOCS, сведения о направлении | DocumentReference | При отсутствии файла — название и причина отсутствия, без выдуманного URL |
| COMPLNTS, ANAM, LANAM, SOCANAM, EPIDEM | Observation с исходными кодами, значениями и вложенными hasMember | Текст переносится без NLP; связи COMP сохраняются как группировка |
| ALL | AllergyIntolerance, substance.text, reaction.manifestation.concept | Нет выдуманных active/confirmed; дискриминаторы исходных записей в отчёте |
| RESCONS, RESINSTR, RESLAB | Observation, исполнители, документные ссылки | Не создаётся DiagnosticReport с придуманным статусом |
| DRUG | MedicationStatement, Medication, дозировка, период, путь введения | Проведённое лечение: Бендазол; не MedicationRequest |
| VITALPARAM | Observation группы и измерений, effectiveDateTime, valueQuantity | Исходные единицы не исправляются молча |
| SCORES | Observation результата и параметров | Кодированные значения CD не превращаются в числа по displayName |
| DGN | Condition, Encounter.diagnosis с осями роли и этапа, Observation характера болезни | recordedDate — дата установления; onset не выводится |
| REGIME | CarePlan, intent=proposal, status=unknown, description | Рекомендация Бисопролола остаётся текстом, не смешивается с DRUG |
| SERVICES | Procedure услуги с кодом НСИ | Не объединяется автоматически с событием документа |
| structuredBody/section | Composition.section, 18 исходных разделов с иерархией | В XML нет section/text; narrative сформирован из структурных значений |

## Правила преобразования

Реализация — [scripts/convert.py](scripts/convert.py). UUIDv5 вычисляются из исходного контекста, поэтому результат воспроизводим. ID не являются решением задачи мастер-индекса. Все ресурсы замкнуты внутри document Bundle. В отдельном административном разделе помещены ссылки на контекст и оригинальный XML.

Справочники нормализуются к canonical Core там, где Core требует его. Исходное OID-кодирование с версией сохраняется дополнительным coding. Исключение — Encounter.diagnosis.use, где Core допускает только один coding: версии исходного НСИ остаются в отчёте, не приписываются новой canonical-системе. Полная таблица нормализации находится в `NORMALIZE` конвертера.

Отсутствие клинического статуса не означает final/active. Composition и Observation имеют unknown, Condition.clinicalStatus — unknown. Новые технические записи DocumentReference имеют status=current, Coverage — draft (непроверенная запись), что не утверждает актуальность клинического документа или действительность страхового покрытия. docStatus не выдумывается. Исходные nullFlavor учитываются отдельно.

Даты сохраняют точность: отсутствующие даты не заменяются датой встречи/сборки; к времени с минутной точностью добавляются нулевые секунды для синтаксиса FHIR, часовой пояс не придумывается. Для российского паспорта принято соглашение: дата выдачи передаётся в identifier.period.start; код подразделения — в assigner.identifier с системой RuCore ns-division-code.

У Quantity сохранено исходное значение и unit. Альтернативная единица НСИ переносится стандартным расширением `iso21090-PQ-translation`. Исходное `kg/m^2` оставлено в unit без объявления валидным UCUM code. Пульс `100 U/s` сохранён с предупреждением о качестве источника. Версия НСИ единиц не помещается в несуществующее поле Quantity.version.

`technical` означает исключение CDA-метаданных из клинической модели, а не доказательство ненужности их семантики при обратном экспорте. `report-only` означает отсутствие самостоятельного структурного представления. Сохранение XML обеспечивает доступ к оригиналу, но не семантическую полноту FHIR-модели.
