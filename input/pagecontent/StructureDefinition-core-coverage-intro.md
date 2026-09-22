# Core_Coverage — Профиль страхового покрытия

Вид полиса ОМС необязателен. Для него нормировано кодирование с canonical URI RuCore; альтернативный OID `urn:oid:1.2.643.5.1.13.13.11.1035` сохранён в NamingSystem и допускается открытой нарезкой без отдельного среза. Ограничения `omsType` к OID-кодированию не применяются: NamingSystem не обеспечивает автоматическую эквивалентность при валидации. Полноту проверки альтернативных кодирований определяют прикладные профили и их средства валидации; базовые ограничения FHIR и RuCore сохраняются.

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходимо указать тип источника оплаты по НСИ МЗ РФ | type | Должен быть указан по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-sources-of-payment), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-sources-of-payment)). |
| При передаче документа-основания оплаты | identifier[coverageDocument] | Определен общий вариант идентификатора документа-основания оплаты. Тип документа указывается по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document)). |
| При передаче идентификатора ОМС | identifier[coverageDocument/omsPolicy] | Определен единый идентификатор полиса ОМС. Тип содержит обязательный код `Полис ОМС` из справочника документов оплаты; вид полиса необязателен. Номер и система номера не обязательны. |
| Необходимо корректно вести связанную информацию | beneficiary | Должен быть представлен профилем Core_Patient |

## Описание профиля

Профиль Core_Coverage расширяет стандартный ресурс Coverage для поддержки российских требований:
- Использование справочника НСИ МЗ РФ для типов источников оплаты
- Поддержка общих документов-оснований оплаты медицинских услуг
- Поддержка единого идентификатора полиса ОМС с двумя уровнями классификации по справочникам НСИ МЗ РФ
- Связь с пациентом через профиль Core_Patient

При передаче идентификатора ОМС используется `identifier[coverageDocument/omsPolicy]`: повторять тот же номер в `identifier[coverageDocument]` не требуется. Кодирование `coverageDocumentType` относит идентификатор к документам-основаниям оплаты, а необязательный `omsType` уточняет вид полиса ОМС.

### Используемые справочники и системы идентификации
- [НСИ МЗ РФ — Источники оплаты (CodeSystem)](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-sources-of-payment)
- [НСИ МЗ РФ — Источники оплаты (ValueSet)](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-sources-of-payment)
- [НСИ МЗ РФ — Документы-основания для оплаты (CodeSystem)](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document)
- [НСИ МЗ РФ — Документы-основания для оплаты (ValueSet)](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document)
- [НСИ МЗ РФ — Виды полиса ОМС (CodeSystem)](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document-oms)
- [НСИ МЗ РФ — Виды полиса ОМС (ValueSet)](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document-oms)

---

### FSH-код профиля

```fsh
Profile: Core_Coverage
Parent: Coverage
Id: core-coverage
Title: "Core Coverage (Страховое покрытие)"
Description: "Базовый профиль страхового покрытия для российских FHIR-реализаций"

* type ^short = "Тип источника оплаты"
* type from Core_Vs_Nsi_Sources_Of_Payment (extensible)

* beneficiary ^short = "Бенефициар"
* beneficiary only Reference(Core_Patient)

// Документы-основания оплаты медицинской помощи.
// Наличие документа не обязательно; тип обязателен для распознавания среза.
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Документы оплаты распознаются по принадлежности типа к справочнику НСИ"
* identifier contains coverageDocument 0..*

* identifier[coverageDocument]
  * ^short = "Документ-основание оплаты медицинской помощи"
  * ^definition = "Идентификатор документа, подтверждающего основание оплаты медицинской помощи. Тип документа указывается по справочнику НСИ МЗ РФ «Документы-основания для оплаты медицинских услуг»."
  * type 1..1
  * type from Core_Vs_Nsi_Coverage_Document (required)
  * system ^short = "Пространство уникальности номера документа"
  * value ^short = "Номер документа"

// Вложенный срез наследует открытый slicing по type.
* identifier[coverageDocument] contains omsPolicy 0..1

* identifier[coverageDocument/omsPolicy]
  * ^short = "Полис обязательного медицинского страхования"
  * system = "https://fhir.ru/ig/core/systems/oms"
  * type ^patternCodeableConcept.coding[0].system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document"
  * type ^patternCodeableConcept.coding[0].code = #1
  * type.coding ^comment = "Срез omsType проверяет кодирование с canonical URI RuCore. Эквивалентное обозначение системы urn:oid:1.2.643.5.1.13.13.11.1035 сохранено в NamingSystem и допускается открытой нарезкой, но ограничения omsType к такому coding не применяются. NamingSystem не обеспечивает автоматическую эквивалентность при валидации; полноту проверки альтернативных кодирований определяют прикладные профили и их средства валидации."
  * type.coding ^slicing.discriminator.type = #pattern
  * type.coding ^slicing.discriminator.path = "$this"
  * type.coding ^slicing.rules = #open
  * type.coding ^slicing.description = "Тип документа обязателен; вид полиса ОМС указывается при наличии"
  * type.coding contains
      coverageDocumentType 1..1 and
      omsType 0..1
  * type.coding[coverageDocumentType]
    * ^short = "Полис ОМС по справочнику документов-оснований оплаты"
    * system 1..1
    * ^patternCoding.system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document"
    * code 1..1
    * ^patternCoding.code = #1
  * type.coding[omsType]
    * ^short = "Вид полиса ОМС по справочнику НСИ МЗ РФ"
    * system 1..1
    * ^patternCoding.system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document-oms"
    * code 1..1
    * code from Core_Vs_Nsi_Coverage_Document_OMS (required)
```
