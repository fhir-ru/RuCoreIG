# Core_PractitionerRole — Профиль роли медицинского работника

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Описание сотрудника должен соответствовать требованиям | practitioner | Должен быть представлен профилем Core_Practitioner |
| Описание организации должен соответствовать требованиям | organization | Должен быть представлен профилем Core_Organization |
| Должность следует указывать по справочнику должностей медицинских работников НСИ | code | Должна быть указана по справочнику НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-worker-position), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-worker-position)) |

## Описание профиля

Профиль Core_PractitionerRole расширяет стандартный ресурс PractitionerRole для поддержки российских требований:
- Медицинский работник должен быть представлен профилем Core_Practitioner
- Организация должна быть представлена профилем Core_Organization
- Должность должна быть указана по справочнику НСИ МЗ РФ

### Используемые справочники и системы идентификации
- [НСИ МЗ РФ — Должности медицинских работников (CodeSystem)](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-worker-position)
- [НСИ МЗ РФ — Должности медицинских работников (ValueSet)](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-worker-position)

---

### FSH-код профиля

```fsh
Profile: Core_PractitionerRole
Parent: PractitionerRole
Id: core-practitionerrole
Title: "Core PractitionerRole (Роль медицинского работника)"
Description: "Базовый профиль роли медицинского работника для российских FHIR-реализаций"

* practitioner only Reference(Core_Practitioner)
* organization only Reference(Core_Organization)
* code from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-worker-position (required)
``` 