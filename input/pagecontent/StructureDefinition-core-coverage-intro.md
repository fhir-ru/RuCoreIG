# Core_Coverage — Профиль страхового покрытия

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходимо указать тип источника оплаты по НСИ МЗ РФ | type | Должен быть указан по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-sources-of-payment), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-sources-of-payment)). |
| Необходимо указать документ-основание для оплаты | identifier[coverageDocument] | Определен общий вариант идентификатора документа-основания оплаты. Тип документа указывается по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document)). |
| В случае страховки по ОМС необходимо указать данные полиса | identifier[omsPolicy] | Определен вариант идентификатора страхового покрытия – Полис ОМС. |
| В случае страховки ОМС вид полиса может быть передан по НСИ МЗ РФ | identifier[omsPolicy].type.coding | Для `omsPolicy` определен нормированный опциональный вариант кодирования вида полиса: `omsType`. Он использует справочник видов полиса ОМС НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document-oms), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document-oms)). |
| Необходимо корректно вести связанную информацию | beneficiary | Должен быть представлен профилем Core_Patient |

## Описание профиля

Профиль Core_Coverage расширяет стандартный ресурс Coverage для поддержки российских требований:
- Использование справочника НСИ МЗ РФ для типов источников оплаты
- Поддержка общих документов-оснований оплаты медицинских услуг
- Поддержка идентификаторов полисов ОМС с возможностью при необходимости указать вид полиса по справочнику НСИ МЗ РФ
- Связь с пациентом через профиль Core_Patient

<div style="background:#fff3cd; border-left:4px solid #f0ad4e; padding:12px; margin:12px 0;">
<strong>Вопрос для обсуждения сообщества.</strong> В текущей редакции профиля для пациента с полисом ОМС один и тот же номер документа приходится указывать дважды: как общий документ-основание оплаты в <code>identifier[coverageDocument]</code> и как специализированный идентификатор полиса в <code>identifier[omsPolicy]</code>. Это решение пока не утверждено сообществом и подлежит отдельному обсуждению.
</div>

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
  * type.coding contains
      omsType 0..1

* identifier[omsPolicy].type.coding[omsType] from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document-oms (extensible)

* beneficiary only Reference(Core_Patient)
``` 
