//Расширения для Core

// --- Расширение: Тип адреса ---
Extension: AddressType
Id: address-type
Title: "Тип адреса"
Description: "Расширение для хранения типа адреса по НСИ 2.1504"

* ^url = "https://fhir.ru/ig/core/StructureDefinition/address-type"
* value[x] only CodeableConcept
* valueCodeableConcept from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-address-type (required)
* valueCodeableConcept ^short = "Код типа адреса (по НСИ 2.1504)"
* ^context.type = #element
* ^context.expression = "Address"

// --- Расширение: Код региона ---
Extension: RegionRF
Id: regionRF
Title: "Код региона РФ"
Description: "Расширение для хранения кода региона по НСИ 2.206"
* ^url = "https://fhir.ru/ig/core/StructureDefinition/regionRF"
* value[x] only CodeableConcept
* valueCodeableConcept from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-region-rf (required)
* valueCodeableConcept ^short = "Код региона (по НСИ 2.206)"
* ^context.type = #element
* ^context.expression = "Address"

// --- Расширение: FIAS ---
Extension: FIAS
Id: fias
Title: "ФИАС"
Description: "Расширение для хранения идентификаторов ФИАС"
* ^url = "https://fhir.ru/ig/core/StructureDefinition/fias"
* extension contains
    aoguid 1..1 and
    houseguid 0..1
* ^context.type = #element
* ^context.expression = "Address"

// --- Расширение: FIAS AOGUID ---
Extension: AOGUID
Id: aoguid
Title: "ФИАС AOGUID"
Description: "Расширение для хранения идентификатора AOGUID по ФИАС"
* ^url = "https://fhir.ru/ig/core/StructureDefinition/aoguid"
* value[x] only Identifier
* valueIdentifier.system = "urn:hl7-ru:fias:aoguid"
* valueIdentifier ^short = "FIAS AOGUID"
* ^context.type = #extension
* ^context.expression = "fias"

// --- Расширение: FIAS HOUSEGUID ---
Extension: HOUSEGUID
Id: houseguid
Title: "ФИАС HOUSEGUID"
Description: "Расширение для хранения идентификатора HOUSEGUID по ФИАС"
* ^url = "https://fhir.ru/ig/core/StructureDefinition/houseguid"
* value[x] only Identifier
* valueIdentifier.system = "urn:hl7-ru:fias:houseguid"
* valueIdentifier ^short = "FIAS HOUSEGUID"
* ^context.type = #extension
* ^context.expression = "fias"

// --- Расширение: ОКАТО ---
Extension: OKATO
Id: okato
Title: "Код ОКАТО"
Description: "Расширение для хранения кода по Общероссийскому классификатору административно-территориальных образований (ОКАТО)"
* ^url = "https://fhir.ru/ig/core/StructureDefinition/okato"
* value[x] only CodeableConcept
* valueCodeableConcept from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-okato (required)
* valueCodeableConcept ^short = "Код ОКАТО"
* ^context.type = #element
* ^context.expression = "Organization"
