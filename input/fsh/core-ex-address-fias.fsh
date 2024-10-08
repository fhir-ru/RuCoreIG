//Alias: $Ядро_Расширение_КодыФИАС = Core_Ex_Address_Fias
Extension: Core_Ex_Address_Fias
Id:        core-ex-address-fias
Title: "Core Extension address fias (Кодирование адреса по ФИАС)"
Description: "Кодирование адреса по ФИАС. При маппинге на СЭМД данный url соответствует urn:hl7-ru:fias"
Context: Address

* extension contains
    aoguid 1..1 MS and
    houseguid 0..1 MS

* extension[aoguid]
  * value[x] only Identifier
  * valueIdentifier
    * system = "urn:hl7-ru:fias:aoguid"
    * value 1..1 MS
    * value ^short = "GUID адресного объекта."

* extension[houseguid]
  * value[x] only Identifier
  * valueIdentifier
    * system = "urn:hl7-ru:fias:houseguid"
    * value 1..1 MS
    * value ^short = "GUID дома."