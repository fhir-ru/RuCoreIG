# Core_Patient — Профиль пациента

Вид полиса ОМС необязателен. Для него нормировано кодирование с canonical URI RuCore; альтернативный OID `urn:oid:1.2.643.5.1.13.13.11.1035` сохранён в NamingSystem и допускается открытой нарезкой без отдельного среза. Ограничения `omsType` к OID-кодированию не применяются: NamingSystem не обеспечивает автоматическую эквивалентность при валидации. Полноту проверки альтернативных кодирований определяют прикладные профили и их средства валидации; базовые ограничения FHIR и RuCore сохраняются.

Для российского паспорта дата выдачи передаётся в `identifier[identityDocument].period.start`: по принятому соглашению она совпадает с началом действия идентификатора. Для остальных видов документов это совпадение не предполагается. Наименование выдавшего органа передаётся в `assigner.display`, код подразделения — в `assigner.identifier.value` с `system = "https://fhir.ru/ig/core/systems/ns-division-code"` ([NamingSystem](NamingSystem-core-ns-rf-ns-division-code.html)). Дата, наименование органа и код подразделения необязательны; при передаче кода обязательны его `system` и `value`.

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходима возможность указать СНИЛС | identifier[snils] | Определен срез, распознаваемый по семантическому коду `snils`; система идентификатора остается канонической системой RuCore для СНИЛС |
| Необходима возможность указать ИНН | identifier[inn] | Определен срез, распознаваемый по семантическому коду `inn`; тип также должен содержать стандартный код HL7 `TAX` |
| Необходима возможность указать документ, удостоверяющий личность | identifier[identityDocument] | Определен срез, распознаваемый по семантическому коду `identity-document`; дополнительное кодирование указывает конкретный вид документа по НСИ МЗ РФ |
| Необходима возможность указать полис ОМС | identifier[omsPolicy] | Определен срез, распознаваемый по семантическому коду `oms-policy`. Тип также содержит фиксированный код `Полис ОМС` из справочника документов-оснований оплаты и, при наличии, вид полиса по НСИ МЗ РФ |
| Необходима возможность передать идентификатор пациента в экземпляре МИС по правилам СЭМД | identifier[misPatient] | Определен необязательный срез `0..1`, распознаваемый по коду `mis-patient`; `system` строго следует формуле СЭМД с типовым узлом `.10` |
| Указание отчества | name.given | Используется массив, первым должно идти имя, вторым - отчество |
| Указание пола, так чтобы это соответствовало справочнику МЗРФ | gender | Используются позиции: male \| female \| unknown. В комментарии к атрибуту указываем, что Other - не используется для совместимости со Справочником НСИ Пол пациента |
| Описание адреса пациента на территории РФ должно соответствовать требованиям РФ | address | Для адресов на территории РФ применяется профиль Core_Address; для иностранных адресов используется базовый тип Address |
| Описание организации прикрепления должно соответствовать требованиям РФ | managingOrganization | Должен быть представлен профилем Core_Organization |

## Описание профиля

Профиль Core_Patient расширяет стандартный ресурс Patient для поддержки российских требований:

- Использование российских идентификаторов (СНИЛС, ИНН, документ, удостоверяющий личность, полис ОМС) и идентификатора пациента в экземпляре МИС
- Открытая нарезка `identifier` по шаблону `Identifier.type`: стабильный семантический код определяет срез, а дополнительные coding сохраняют стандартную или предметную классификацию
- Для `identifier[misPatient]` проверяются URI-форма OID и конечный узел `.10`
- Поддержка отчества в структуре имени
- Использование справочника НСИ МЗ РФ для пола пациента
- Использование профиля Core_Address для адресов на территории РФ
- Использование профиля Core_Organization для организации прикрепления

### Используемые справочники и системы идентификации

- [Типы идентификаторов](https://fhir.ru/ig/core/ValueSet/core-vs-identifier-type) — объединенный набор типов HL7 и RuCore
- [СНИЛС](https://www.pfrf.ru/) (Страховой номер индивидуального лицевого счета)
- [ИНН](https://www.nalog.gov.ru/) (Индивидуальный номер налогоплательщика)

---

### FSH-код профиля

```fsh
Profile: Core_Patient
Parent: Patient
Id: core-patient
Title: "Core Patient (Пациент)"
Description: "Базовый профиль пациента для российских FHIR-реализаций"

* identifier.type from Core_Vs_Identifier_Type (extensible)
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка по семантическому типу идентификатора пациента"
* identifier contains
  snils 0..1 and
  inn 0..1 and
  identityDocument 0..* and
  omsPolicy 0..1 and
  misPatient 0..1

* identifier[snils] ^short = "Страховой номер индивидуального лицевого счёта (СНИЛС)"
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#snils
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/snils"

* identifier[inn] ^short = "Идентификационный номер налогоплательщика (ИНН)"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/inn"
  * type 1..1
  * type ^patternCodeableConcept.coding[0].system = "https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type"
  * type ^patternCodeableConcept.coding[0].code = #inn
  * type.coding ^slicing.discriminator.type = #pattern
  * type.coding ^slicing.discriminator.path = "$this"
  * type.coding ^slicing.rules = #open
  * type.coding contains
      identifierType 1..1 and
      taxType 1..1
  * type.coding[identifierType] = Core_Cs_Semd_Identifier_Type#inn
  * type.coding[taxType] = http://terminology.hl7.org/CodeSystem/v2-0203#TAX

* identifier[identityDocument] ^short = "Документ, удостоверяющий личность"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/identity-document"
  * type 1..1
  * type ^patternCodeableConcept.coding[0].system = "https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type"
  * type ^patternCodeableConcept.coding[0].code = #identity-document
  * type from Core_Vs_Nsi_Identity_Documents (extensible)
  * period.start ^short = "Начало действия документа; для российского паспорта — дата выдачи"
  * period.start ^comment = "Для российского паспорта дата выдачи передаётся как начало действия идентификатора в period.start. Это соглашение не распространяется автоматически на другие виды документов. Наличие даты не обязательно."
  * assigner.display ^short = "Наименование органа, выдавшего документ"
  * assigner.identifier ^short = "Код подразделения, выдавшего документ"
  * assigner.identifier ^comment = "Код подразделения необязателен. При его передаче обязательны system и value; используется существующая система идентификации RuCore ns-division-code."
  * assigner.identifier.system 1..1
  * assigner.identifier.system = "https://fhir.ru/ig/core/systems/ns-division-code"
  * assigner.identifier.value 1..1

* identifier[omsPolicy] ^short = "Полис ОМС"
  * value only string
  * system = "https://fhir.ru/ig/core/systems/oms"
  * type 1..1
  * type ^patternCodeableConcept.coding[0].system = "https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type"
  * type ^patternCodeableConcept.coding[0].code = #oms-policy
  * type.coding ^comment = "Срез omsType проверяет кодирование с canonical URI RuCore. Эквивалентное обозначение системы urn:oid:1.2.643.5.1.13.13.11.1035 сохранено в NamingSystem и допускается открытой нарезкой, но ограничения omsType к такому coding не применяются. NamingSystem не обеспечивает автоматическую эквивалентность при валидации; полноту проверки альтернативных кодирований определяют прикладные профили и их средства валидации."
  * type.coding ^slicing.discriminator.type = #pattern
  * type.coding ^slicing.discriminator.path = "$this"
  * type.coding ^slicing.rules = #open
  * type.coding contains
      identifierType 1..1 and
      coverageDocumentType 1..1 and
      omsType 0..1
  * type.coding[identifierType] = Core_Cs_Semd_Identifier_Type#oms-policy
  * type.coding[coverageDocumentType] = Core_Cs_Nsi_Coverage_Document#1
  * type.coding[omsType]
    * ^patternCoding.system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document-oms"
    * system 1..1
    * code 1..1
    * code from Core_Vs_Nsi_Coverage_Document_OMS (required)

* identifier[misPatient] ^short = "Идентификатор пациента в экземпляре МИС"
* identifier[misPatient] ^definition = "Локальный идентификатор пациента в конкретном экземпляре медицинской информационной системы."
* identifier[misPatient] ^comment = "Identifier.system передаётся в URI-форме urn:oid:... с конечным узлом .10. RuCore проверяет URI-форму OID и конечный узел типа; корень медицинской организации, ветка и номера МИС не ограничиваются. Принадлежность OID организации требует отдельной проверки по реестру."
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-patient
  * system 1..1
  * value 1..1
  * obeys core-patient-mis-patient-system

* name ^short = "ФИО пациента"
  * family ^short = "Фамилия"
  * given ^short = "Имя и отчество пациента"
  * given ^definition = "Массив строк: первый элемент - имя, второй элемент - отчество"
  * use ^short = "Тип имени пациента. Рекомендуемое значение: official"

* gender ^short = "Пол пациента. Используются позиции: male | female | unknown. Other - не используется для совместимости со Справочником НСИ Пол пациента"

* birthDate ^short = "Дата рождения пациента, формат YYYY-MM-DD или YYYY-MM-DDTHH:MM для новорождённых"

* address ^short = "Адрес пациента"
* address ^comment = "Для адресов на территории Российской Федерации следует использовать правила профиля Core_Address. Для адресов вне территории Российской Федерации применяется базовый тип Address."

* managingOrganization ^short = "Ответственная организация"
* managingOrganization only Reference(Core_Organization)

Invariant: core-patient-mis-patient-system
Description: "Система идентификатора пациента в МИС должна быть OID в URI-форме urn:oid:... с конечным узлом .10"
Severity: #error
Expression: "system.matches('^urn:oid:[0-2]([.](0|[1-9][0-9]*))+[.]10$')"
```

RuCore проверяет URI-форму OID и конечный узел типа; корень медицинской организации, ветка и номера МИС не ограничиваются. Принадлежность OID организации требует отдельной проверки по реестру. Подробнее: [Идентификаторы СЭМД](semd-identifiers.html).
