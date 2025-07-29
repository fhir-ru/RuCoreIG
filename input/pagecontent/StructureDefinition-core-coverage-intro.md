# Core_Coverage — Профиль страхового покрытия

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходимо указать тип источника оплаты по НСИ МЗ РФ | type | Должен быть указан по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-type), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-type)). |
| В случае страховки по ОМС необходимо указать данные полиса | identifier[omsPolicy] | Определен вариант идентификатора страхового покрытия – Полис ОМС. |
| В случае страховки ОМС необходимо указывать тип полиса | identifier.type.coding[omsType] | Определен вариант кодирования типа идентификатора – omsType. Заполняется типом полисов ОМС по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-oms-policy-type), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-oms-policy-type)). |
| Необходимо корректно вести связанную информацию | beneficiary | Должен быть представлен профилем Core_Patient |

## Описание профиля

Профиль Core_Coverage расширяет стандартный ресурс Coverage для поддержки российских требований:
- Использование справочника НСИ МЗ РФ для типов источников оплаты
- Поддержка идентификаторов полисов ОМС с указанием типа полиса
- Связь с пациентом через профиль Core_Patient

### Используемые справочники и системы идентификации
- [НСИ МЗ РФ — Типы источников оплаты (CodeSystem)](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-type)
- [НСИ МЗ РФ — Типы источников оплаты (ValueSet)](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-type)
- [НСИ МЗ РФ — Типы полисов ОМС (CodeSystem)](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-oms-policy-type)
- [НСИ МЗ РФ — Типы полисов ОМС (ValueSet)](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-oms-policy-type)

---

### FSH-код профиля

```fsh
Profile: Core_Coverage
Parent: Coverage
Id: core-coverage
Title: "Core Coverage (Страховое покрытие)"
Description: "Базовый профиль страхового покрытия для российских FHIR-реализаций"

* type from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-type (required)

* identifier contains
    omsPolicy 0..1 and
    omsType 0..1

* identifier[omsPolicy] ^short = "Полис ОМС"

* identifier[omsType] ^short = "Тип полиса ОМС"
* identifier[omsType].type.coding from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-oms-policy-type (required)

* beneficiary only Reference(Core_Patient)
``` 