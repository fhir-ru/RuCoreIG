Profile: Core_Patient_Payer
Id: core-patient-payer
Parent: Core_Patient
Title: "Core Patient Payer (Пациент - плательщик)"
Description: "Пациент – плательщик, передача ИНН обязательна"

* identifier[INN] 1..1

//----------instance-full-------------------------------
Instance: core-patient-payer-instance-full 
InstanceOf: Core_Patient_Payer
Title: "Core Instance Patient Payer Full"
Description: "Пациент с ИНН"
Usage: #example

* address = core-address-instance-full

* birthDate = "1955-01-10"

* identifier[passportRF]
  * system = "http://fhir.ru/core/systems/passport-RF"
  * value = "7412 809982"
  //* type = $МЗРФ_Справочник_ДокументыУдостоверяющиеЛичность#1
  * type = Core_Cs_Nsi_Identity_Document#1
 
* identifier[INN]
  * system = "http://fhir.ru/core/systems/inn"
//  * type = #TAX
  * value = "463217055385"

* name
  * family = "Корольков"
  * given[0] = "Владимир"
  * given[1] = "Геннадиевич"
  * use = #official

* gender = #male