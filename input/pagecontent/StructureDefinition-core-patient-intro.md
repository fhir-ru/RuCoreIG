# Core_Patient — Профиль пациента

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходима возможность указать СНИЛС | identifier[snils] | Определен срез, распознаваемый по семантическому коду `snils`; система идентификатора остается канонической системой RuCore для СНИЛС |
| Необходима возможность указать ИНН | identifier[inn] | Определен срез, распознаваемый по семантическому коду `inn`; тип также должен содержать стандартный код HL7 `TAX` |
| Необходима возможность указать документ, удостоверяющий личность | identifier[identityDocument] | Определен срез, распознаваемый по семантическому коду `identity-document`; дополнительное кодирование указывает конкретный вид документа по НСИ МЗ РФ |
| Необходима возможность указать полис ОМС | identifier[omsPolicy] | Определен срез, распознаваемый по семантическому коду `oms-policy`. Тип также содержит фиксированный код `Полис ОМС` из справочника документов-оснований оплаты и конкретный вид полиса по НСИ МЗ РФ |
| Необходима возможность передать идентификатор пациента в экземпляре МИС по правилам СЭМД | identifier[misPatient] | Определен необязательный срез `0..1`, распознаваемый по коду `mis-patient`; `system` строго следует формуле СЭМД с типовым узлом `.10` |
| Указание отчества | name.given | Используется массив, первым должно идти имя, вторым - отчество |
| Указание пола, так чтобы это соответствовало справочнику МЗРФ | gender | Используются позиции: male \| female \| unknown. В комментарии к атрибуту указываем, что Other - не используется для совместимости со Справочником НСИ Пол пациента |
| Описание адреса пациента на территории РФ должно соответствовать требованиям РФ | address | Для адресов на территории РФ применяется профиль Core_Address; для иностранных адресов используется базовый тип Address |
| Описание организации прикрепления должно соответствовать требованиям РФ | managingOrganization | Должен быть представлен профилем Core_Organization |

## Описание профиля

Профиль Core_Patient расширяет стандартный ресурс Patient для поддержки российских требований:

- Использование российских идентификаторов (СНИЛС, ИНН, документ, удостоверяющий личность, полис ОМС) и идентификатора пациента в экземпляре МИС
- Открытая нарезка `identifier` по шаблону `Identifier.type`: стабильный семантический код определяет срез, а дополнительные coding сохраняют стандартную или предметную классификацию
- Для `identifier[misPatient]` применяется формула `urn:oid:1.2.643.5.1.13.13.12.2.{субъект РФ}.{медицинская организация ФРМО}.100.{МИС}.{экземпляр МИС}.10`
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
* identifier contains
  snils 0..1 and
  inn 0..1 and
  identityDocument 0..* and
  omsPolicy 0..1 and
  misPatient 0..1

* identifier[snils]
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#snils
  * system = "https://fhir.ru/ig/core/systems/snils"

* identifier[inn]
  * type 1..1
  * type ^patternCodeableConcept.coding[0].system = "https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type"
  * type ^patternCodeableConcept.coding[0].code = #inn
  * type.coding ^slicing.discriminator.type = #pattern
  * type.coding ^slicing.discriminator.path = "$this"
  * type.coding ^slicing.rules = #open
  * type.coding contains identifierType 1..1 and taxType 1..1
  * type.coding[identifierType] = Core_Cs_Semd_Identifier_Type#inn
  * type.coding[taxType] = http://terminology.hl7.org/CodeSystem/v2-0203#TAX
  * system = "https://fhir.ru/ig/core/systems/inn"

* identifier[identityDocument]
  * type 1..1
  * type ^patternCodeableConcept.coding[0].system = "https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type"
  * type ^patternCodeableConcept.coding[0].code = #identity-document
  * type from Core_Vs_Nsi_Identity_Documents (extensible)
  * system = "https://fhir.ru/ig/core/systems/identity-document"

* identifier[omsPolicy]
  * type 1..1
  * type ^patternCodeableConcept.coding[0].system = "https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type"
  * type ^patternCodeableConcept.coding[0].code = #oms-policy
  * type.coding ^slicing.discriminator.type = #pattern
  * type.coding ^slicing.discriminator.path = "$this"
  * type.coding ^slicing.rules = #open
  * type.coding contains identifierType 1..1 and coverageDocumentType 1..1 and omsType 1..1
  * type.coding[identifierType] = Core_Cs_Semd_Identifier_Type#oms-policy
  * type.coding[coverageDocumentType] = Core_Cs_Nsi_Coverage_Document#1
  * type.coding[omsType].code from Core_Vs_Nsi_Coverage_Document_OMS (extensible)
  * system = "https://fhir.ru/ig/core/systems/oms"

* identifier[misPatient]
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-patient
  * system 1..1
  * value 1..1
  * obeys core-patient-mis-patient-system

* name.given ^short = "Имя и отчество"
* name.given ^comment = "Первым элементом должно быть имя, вторым - отчество"

* gender ^comment = "Используются только male, female, unknown. Other не используется для совместимости со Справочником НСИ Пол пациента"

* address ^comment = "Для адресов на территории Российской Федерации следует использовать правила профиля Core_Address. Для адресов вне территории Российской Федерации применяется базовый тип Address."

* managingOrganization only Reference(Core_Organization)

Invariant: core-patient-mis-patient-system
Description: "Система идентификатора пациента в МИС должна соответствовать структуре с корнем ФРМО и типовым узлом 10"
Severity: #error
Expression: "system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]10$')"
``` 
