# Core_PractitionerRole — Профиль роли медицинского работника

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Необходима возможность передать локальный идентификатор роли сотрудника в экземпляре МИС по правилам СЭМД | identifier[misPractitionerRole] | Определен необязательный срез без discriminator; правило формирования `system` описано комментарием и проверяется инвариантом |
| Описание сотрудника должен соответствовать требованиям | practitioner | Должен быть представлен профилем Core_Practitioner |
| Описание организации должен соответствовать требованиям | organization | Должен быть представлен профилем Core_Organization |
| Должность следует указывать по справочнику должностей медицинских работников НСИ | code | Должна быть указана по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-workers-positions), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-workers-positions)) |

## Описание профиля

Профиль Core_PractitionerRole расширяет стандартный ресурс PractitionerRole для поддержки российских требований:
- Для идентификатора роли сотрудника в экземпляре МИС определен необязательный срез `identifier[misPractitionerRole]`
- `identifier[misPractitionerRole].system` передается как `urn:oid:<OID медицинской организации>.<ветка МИС>.<номер МИС>.<номер экземпляра МИС>.70`; структура проверяется инвариантом
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

* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка для идентификаторов роли медицинского работника; срезы распознаются по совокупности установленных для них ограничений"
* identifier contains misPractitionerRole 0..*
* identifier[misPractitionerRole]
  * system 1..1
  * value 1..1
  * obeys core-practitionerrole-mis-system

* practitioner only Reference(Core_Practitioner)
* organization only Reference(Core_Organization)
* code from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-workers-positions (extensible)

Invariant: core-practitionerrole-mis-system
Description: "Система идентификатора роли медицинского работника в МИС должна быть URI-формой OID, сформированного по правилам СЭМД и оканчивающегося узлом 70"
Severity: #error
Expression: "system.matches('^urn:oid:[0-2]([.](0|[1-9][0-9]*)){2,}[.][1-9][0-9]*[.][1-9][0-9]*[.][1-9][0-9]*[.]70$')"
```
