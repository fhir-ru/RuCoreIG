# Core_Coverage — Профиль страхового покрытия

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходимо указать тип источника оплаты по НСИ МЗ РФ | type | Должен быть указан по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-sources-of-payment), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-sources-of-payment)). |
| В случае страховки по ОМС необходимо указать данные полиса | identifier[omsPolicy] | Определен вариант идентификатора страхового покрытия – Полис ОМС. |
| В случае страховки ОМС вид полиса может быть передан по HL7 или по НСИ МЗ РФ | identifier[omsPolicy].type.coding | Для `omsPolicy` определены два нормированных опциональных варианта кодирования вида идентификатора: `hl7Type` и `omsType`. `omsType` использует справочник видов полиса ОМС НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document-oms), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document-oms)). |
| Необходимо корректно вести связанную информацию | beneficiary | Должен быть представлен профилем Core_Patient |

## Описание профиля

Профиль Core_Coverage расширяет стандартный ресурс Coverage для поддержки российских требований:
- Использование справочника НСИ МЗ РФ для типов источников оплаты
- Поддержка идентификаторов полисов ОМС с возможностью при необходимости указать вид полиса
- Связь с пациентом через профиль Core_Patient

### Используемые справочники и системы идентификации
- [НСИ МЗ РФ — Источники оплаты (CodeSystem)](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-sources-of-payment)
- [НСИ МЗ РФ — Источники оплаты (ValueSet)](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-sources-of-payment)
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
    omsPolicy 0..1

* identifier[omsPolicy] ^short = "Полис ОМС"
  * type.coding contains
      hl7Type 0..1 and
      omsType 0..1

* identifier[omsPolicy].type.coding[hl7Type] = http://terminology.hl7.org/CodeSystem/v2-0203#SB
* identifier[omsPolicy].type.coding[omsType] from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document-oms (extensible)

* beneficiary only Reference(Core_Patient)
``` 
