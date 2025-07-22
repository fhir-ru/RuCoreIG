# Core_Address — Профиль адреса

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| При кодировании адреса необходимо использовать адресную систему ФИАС | fias | Определено расширение для указания кода адресного объекта и кода дома по адресной системе ФИАС ([описание](https://fias.nalog.ru/)). |
| В адресе должен быть указан код региона по справочнику | regionRF | Определено расширение для указания кода региона по справочнику регионов РФ ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-region-rf), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-region-rf)). |
| Требуется указание использования адреса для прописки или проживания | address-type | Атрибут use не точно соответствует требованиям, поэтому определено расширение для указания типа использования адреса, заполняется по справочнику ([ValueSet](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-address-type), [CodeSystem](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-address-type)). <br/> <span style="color: #888; font-size: 90%">В принципе, можно описать соответствие Address.use и данного справочника НСИ. billing = 1 — адрес постоянной регистрации, temp = 2 — адрес временной регистрации, home = 3 — домашний адрес, work = 4 — адрес работы/учёбы, old — не используется. Вопрос не решался на встречах сообщества.</span> |

## Описание профиля

Профиль Core_Address расширяет стандартный ресурс Address для поддержки российских требований:
- Использование идентификаторов ФИАС для адресных объектов (расширение fias)
- Указание кода региона РФ по справочнику (расширение regionRF)
- Указание типа адреса по справочнику НСИ (расширение address-type)

### Используемые справочники и системы идентификации
- [НСИ МЗ РФ — Типы адресов (CodeSystem)](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-address-type)
- [НСИ МЗ РФ — Типы адресов (ValueSet)](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-address-type)
- [НСИ МЗ РФ — Регионы РФ (CodeSystem)](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-region-rf)
- [НСИ МЗ РФ — Регионы РФ (ValueSet)](https://fhir.ru/ig/core/ValueSet/core-vs-nsi-region-rf)
- [ФИАС](https://fias.nalog.ru/) (официальный сайт)

---

### FSH-код профиля

```fsh
Profile: Core_Address
Parent: Address
Id: core-address
Title: "Core Address (Адрес)"
Description: "Базовый профиль адреса для российских FHIR-реализаций"

* extension contains
    https://fhir.ru/ig/core/StructureDefinition/fias named fias 0..1 and
    https://fhir.ru/ig/core/StructureDefinition/regionRF named regionRF 0..1 and
    https://fhir.ru/ig/core/StructureDefinition/address-type named addressType 0..1

* extension[fias] ^short = "ФИАС"

* extension[regionRF] ^short = "Код региона РФ"

* extension[addressType] ^short = "Тип адреса"

* text ^short = "Текстовое представление адреса"

* postalCode ^short = "Почтовый индекс"

* state ^short = "Регион"
``` 