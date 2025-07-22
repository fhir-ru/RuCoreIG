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
