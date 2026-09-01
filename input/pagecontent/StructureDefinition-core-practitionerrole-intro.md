# Core_PractitionerRole — Профиль роли медицинского работника

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходима возможность передать локальный идентификатор роли сотрудника в экземпляре МИС по правилам СЭМД | identifier[misPractitionerRole] | Определен необязательный срез кратностью `0..1`, распознаваемый по коду `mis-practitioner-role` в `Identifier.type`; правило формирования `system` описано комментарием и проверяется инвариантом |
| Описание сотрудника должен соответствовать требованиям | practitioner | Должен быть представлен профилем Core_Practitioner |
| Описание организации должен соответствовать требованиям | organization | Должен быть представлен профилем Core_Organization |
| Должность следует указывать по справочнику должностей медицинских работников НСИ | code | Должна быть указана по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-workers-positions), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-workers-positions)) |

## Описание профиля

Профиль Core_PractitionerRole расширяет стандартный ресурс PractitionerRole для поддержки российских требований:

- Для идентификатора роли сотрудника в экземпляре МИС определен необязательный срез `identifier[misPractitionerRole]`
- Срез распознается по семантическому коду `mis-practitioner-role` из `Core_Cs_Semd_Identifier_Type`; открытая нарезка допускает идентификаторы других типов
- `identifier[misPractitionerRole].system` строго соответствует формуле `urn:oid:1.2.643.5.1.13.13.12.2.{субъект РФ}.{медицинская организация ФРМО}.100.{МИС}.{экземпляр МИС}.70`; структура проверяется инвариантом
- Медицинский работник должен быть представлен профилем Core_Practitioner
- Организация должна быть представлена профилем Core_Organization
- Должность должна быть указана по справочнику НСИ МЗ РФ

### Используемые справочники и системы идентификации

- Идентификатор роли медицинского работника в МИС использует динамически формируемую URI-форму OID по правилам СЭМД; отдельный фиксированный `NamingSystem` для каждого OID не создается
- [НСИ МЗ РФ — Должности медицинских работников (CodeSystem)](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-workers-positions)
- [НСИ МЗ РФ — Должности медицинских работников (ValueSet)](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-workers-positions)

---

### FSH-код профиля

```fsh
Profile: Core_PractitionerRole
Parent: PractitionerRole
Id: core-practitionerrole
Title: "Core PractitionerRole (Роль медицинского работника)"
Description: "Базовый профиль роли медицинского работника для российских FHIR-реализаций"

* identifier.type from Core_Vs_Identifier_Type (extensible)
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier contains misPractitionerRole 0..1
* identifier[misPractitionerRole]
  * type 1..1
  * type = Core_Cs_Semd_Identifier_Type#mis-practitioner-role
  * system 1..1
  * value 1..1
  * obeys core-practitionerrole-mis-system

* practitioner only Reference(Core_Practitioner)
* organization only Reference(Core_Organization)
* code from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-workers-positions (extensible)

Invariant: core-practitionerrole-mis-system
Description: "Система идентификатора роли медицинского работника в МИС должна соответствовать структуре с корнем ФРМО и типовым узлом 70"
Severity: #error
Expression: "system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]70$')"
```
