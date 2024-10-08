Profile: Core_Related_Person_Payer
Id: core-related-person-payer
Parent: Core_Related_Person
Title: "Core Related Person Payer (Лицо-плательщик, имеющее связь с пациентом)"
Description: "Лицо-плательщик, имеющее связь с пациентом"
* identifier 1..1
* identifier ^short = "Государственный идентификационный номер налогоплательщика (ИНН)"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/core/systems/inn" 
  * type 0..1
  * type ^short = "Тип идентификатора, кодируется по НСИ" 
 
//----------instance-full-------------------------------
Instance: core-related-person-payer-instance-full
InstanceOf: Core_Related_Person_Payer
Title: "Core Instance Related Person Payer Full"
Description: "Физлицо с ФИО адресом ссылкой на пациента и ИНН"
Usage: #example
* patient = Reference(core-patient-instance-full)

* address = core-address-instance-full 

* birthDate = "1960-10-20"

* name
  * family = "Габсбург-Лотарингский"
  * given[0] = "Михаил"
  * given[1] = "Иванович"
  * use = #official

* identifier
  * system = "http://fhir.ru/core/systems/inn"
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#TAX
  * value = "463217055385" 

* gender = #male   