Profile: Core_Practitioner
Id:      core-practitioner
Parent:       Practitioner
Title: "Core Practitioner (Врач/сотрудник)"
Description: "Врач, медицинский работник, специалист"

* address only Core_Address

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка по типам идентификаторов специалиста - Паспорт РФ, ИНН, СНИЛС"

* identifier contains INN 0..1 
  and SNILS 0..1
  and passportRF 0..1

* identifier[INN] ^short = "Государственный идентификационный номер налогоплательщика (ИНН)"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/core/systems/inn" 
  * type 0..1
  * type ^short = "Тип идентификатора, кодируется по НСИ" 

* identifier[passportRF] ^short = "Паспорт гражданина Российской Федерации"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/core/systems/passport-RF"
  * type 1..1
  * type ^short = "Тип идентификатора, кодируется по НСИ"
  //* type from $Ядро_НаборЗначений_ДокументыУдостоверяющиеЛичность (required)
  * type from Core_Vs_Nsi_Identity_Documents (required)
  //* type = $МЗРФ_Справочник_ДокументыУдостоверяющиеЛичность#1
  * type = Core_Cs_Nsi_Identity_Document#1

* identifier[SNILS] ^short = "Страховой номер индивидуального лицевого счёта, СНИЛС — уникальный номер индивидуального лицевого счёта застрахованного лица в системе обязательного пенсионного страхования"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/core/systems/snils"
  * type 0..1
  * type ^short = "Тип идентификатора, кодируется по НСИ"
  
* gender ^short = "Пол специалиста. Используются позиции: male | female | unknown. Other - не используется для совместимости со Справочником НСИМЗ Пол пациента"
* gender 0..1

* qualification.code from http://terminology.hl7.org/ValueSet/v2-0360  

//----------instance-full-------------------------------
Instance: core-practitioner-instance-full
InstanceOf: Core_Practitioner
Title: "Core Instance Practitioner Full"
Description: "Врач с паспортом, ИНН, СНИЛСом и адресом"
Usage: #example

* identifier[INN]
  * system = "http://fhir.ru/core/systems/inn"
  * value = "463217055385"

* identifier[passportRF]
  * system = "http://fhir.ru/core/systems/passport-RF"
  * value = "7412 809982"
  //* type = $МЗРФ_Справочник_ДокументыУдостоверяющиеЛичность#1
  * type = Core_Cs_Nsi_Identity_Document#1
  
* identifier[SNILS]
  * system = "http://fhir.ru/core/systems/snils"
  * value = "152-873-614 14"

* name
  * family = "Иванова"
  * given[0] = "Мария"
  * given[1] = "Ивановна"
  * use = #official

* address = core-address-instance-full 

* gender = #female