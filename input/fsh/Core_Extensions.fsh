//Расширения для Core

// --- Расширение: Тип адреса ---
Extension: AddressType
Id: address-type
Title: "Core Extension AddressType (Тип адреса)"
Description: "Расширение для хранения типа адреса по НСИ 2.1504"

* ^url = "https://fhir.ru/ig/core/StructureDefinition/address-type"
* value[x] only CodeableConcept
* valueCodeableConcept from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-address-type (extensible)
* valueCodeableConcept ^short = "Код типа адреса (по НСИ 2.1504)"
* ^context.type = #element
* ^context.expression = "Address"

// --- Расширение: Код региона ---
Extension: RegionRF
Id: regionRF
Title: "Core Extension RegionRF (Регион РФ)"
Description: "Расширение для хранения кода региона по НСИ 2.206"
* ^url = "https://fhir.ru/ig/core/StructureDefinition/regionRF"
* value[x] only CodeableConcept
* valueCodeableConcept from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-region-rf (extensible)
* valueCodeableConcept ^short = "Код региона (по НСИ 2.206)"
* ^context.type = #element
* ^context.expression = "Address"

// --- Расширение: FIAS ---
Extension: FIAS
Id: fias
Title: "Core Extension FIAS (коды ФИАС)"
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
Title: "Core Extension AOGUID (код адресного объекта ФИАС)"
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
Title: "Core Extension HOUSEGUID (код дома ФИАС)"
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
Title: "Core Extension OKATO (Код ОКАТО)"
Description: "Расширение для хранения кода по Общероссийскому классификатору административно-территориальных образований (ОКАТО)"
* ^url = "https://fhir.ru/ig/core/StructureDefinition/okato"
* value[x] only CodeableConcept
* valueCodeableConcept from https://fhir.ru/ig/core/ValueSet/core-vs-nsi-okato (extensible)
* valueCodeableConcept ^short = "Код ОКАТО"
* ^context.type = #element
* ^context.expression = "Organization"

// --- Расширение: порядок диагноза случая ---
Extension: DiagnosisRank
Id: diagnosis-rank
Title: "Core Extension DiagnosisRank (Порядок диагноза)"
Description: "Порядковый номер диагноза в авторской последовательности врача. Восстанавливает исключенный в FHIR R5 элемент Encounter.diagnosis.rank и используется, когда в одной рубрике несколько диагнозов."
* ^url = "https://fhir.ru/ig/core/StructureDefinition/diagnosis-rank"
* value[x] 1..1
* value[x] only positiveInt
* valuePositiveInt ^short = "Порядковый номер диагноза"
* ^context.type = #element
* ^context.expression = "Encounter.diagnosis"
