# Core_Coverage — Профиль страхового покрытия

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходимо указать тип источника оплаты по НСИ МЗ РФ | type | Должен быть указан по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-sources-of-payment), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-sources-of-payment)). |
| Необходимо указать документ-основание для оплаты | identifier[coverageDocument] | Определен общий вариант идентификатора документа-основания оплаты. Тип документа указывается по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document)). |
| В случае страховки по ОМС необходимо указать данные полиса | identifier[omsPolicy] | Определен единый идентификатор полиса ОМС. Его тип содержит два обязательных кодирования: фиксированный код `Полис ОМС` из справочника документов-оснований оплаты и конкретный вид полиса из справочника видов полиса ОМС. |
| Необходимо корректно вести связанную информацию | beneficiary | Должен быть представлен профилем Core_Patient |

## Описание профиля

Профиль Core_Coverage расширяет стандартный ресурс Coverage для поддержки российских требований:
- Использование справочника НСИ МЗ РФ для типов источников оплаты
- Поддержка общих документов-оснований оплаты медицинских услуг
- Поддержка единого идентификатора полиса ОМС с двумя уровнями классификации по справочникам НСИ МЗ РФ
- Связь с пациентом через профиль Core_Patient

Для оплаты по ОМС передается только `identifier[omsPolicy]`: повторять тот же номер в `identifier[coverageDocument]` не требуется. Кодирование `coverageDocumentType` относит идентификатор к документам-основаниям оплаты, а `omsType` уточняет вид полиса ОМС.

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

* type from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-sources-of-payment (extensible)

* identifier contains
    coverageDocument 0..* and
    omsPolicy 0..1

* identifier[coverageDocument].type from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document (extensible)

* identifier[omsPolicy] ^short = "Полис ОМС"
  * type 1..1
  * type.coding contains
      coverageDocumentType 1..1 and
      omsType 1..1

* identifier[omsPolicy].type.coding[coverageDocumentType] = https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document#1
* identifier[omsPolicy].type.coding[omsType] from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document-oms (extensible)

* beneficiary only Reference(Core_Patient)
``` 
