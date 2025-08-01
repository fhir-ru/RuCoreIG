# Core_RelatedPerson — Профиль связанного лица

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Описание пациента должно соответствовать требованиям РФ | patient | Должен быть представлен профилем Core_Patient |
| Требуется указать отношение представителя к пациенту по НСИ МЗ РФ | relationship | Уточнен атрибут – значение может браться из справочника НСИ МЗ РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-relatedperson-relationship), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-relatedperson-relationship)) |
| Требуется указать СНИЛС представителя | identifier[snils] | Определен вариант атрибута Identifier[snils] |
| Требуется указать отчество представителя | name.given[1] | Аналогично пациенту и медицинскому работнику, определено, что отчество указывается в массиве name.given вторым элементом (при наличии) |
| Описание адреса должно соответствовать требованиям РФ | address | Должен быть представлен профилем Core_Address |

## Описание профиля

Профиль Core_RelatedPerson расширяет стандартный ресурс RelatedPerson для поддержки российских требований:
- Пациент должен быть представлен профилем Core_Patient
- Отношение к пациенту должно быть указано по справочнику НСИ МЗ РФ
- Использование российских идентификаторов (СНИЛС)
- Поддержка отчества в структуре имени (аналогично Core_Patient)
- Использование профиля Core_Address для адресов

### Используемые справочники и системы идентификации
- [СНИЛС](https://www.pfrf.ru/) (Страховой номер индивидуального лицевого счета)
- [НСИ МЗ РФ — Отношения связанного лица (CodeSystem)](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-relatedperson-relationship)
- [НСИ МЗ РФ — Отношения связанного лица (ValueSet)](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-relatedperson-relationship)

### Соответствие отношений
Справочник НСИ МЗ РФ для отношений связанного лица включает следующие основные категории:
- **Родители** - мать, отец
- **Дети** - сын, дочь
- **Супруги** - муж, жена
- **Другие родственники** - брат, сестра, бабушка, дедушка и др.
- **Законные представители** - опекун, попечитель
- **Доверенные лица** - по доверенности

---

### FSH-код профиля

```fsh
Profile: Core_RelatedPerson
Parent: RelatedPerson
Id: core-relatedperson
Title: "Core RelatedPerson (Связанное лицо)"
Description: "Базовый профиль связанного лица для российских FHIR-реализаций"

* patient only Reference(Core_Patient)

* relationship from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-relatedperson-relationship (required)

* identifier contains
    snils 0..1

* identifier[snils] ^short = "СНИЛС"

* name.given ^short = "Имя и отчество"
* name.given ^comment = "Первым элементом должно быть имя, вторым - отчество (при наличии)"

* address only Core_Address
``` 