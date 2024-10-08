Profile: Core_Patient
Id:      core-patient
Parent:       Patient
Title: "Core Patient (Пациент)"
Description: "Пациент"

* address ^short = "Адрес пациента"
* address only Core_Address

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка по типам идентификаторов пациента - Паспорт РФ, ИНН, СНИЛС, полис ОМС, свидетельство о рождении, номер пациента в МИС"
* identifier contains birthCertificate 0..1 
  and INN 0..1 
  and SNILS 0..1
  and passportRF 0..1
// номер пациента в МИС, полис ОМС

* identifier[birthCertificate] ^short = "Государственное свидетельство о рождении"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/core/systems/birth-certificate"
  * type 1..1
  * type ^short = "Тип идентификатора, кодируется по НСИ"
//  * type from $Ядро_НаборЗначений_ДокументыУдостоверяющиеЛичность (required)
  * type from Core_Vs_Nsi_Identity_Documents (required)
//  * type = $МЗРФ_Справочник_ДокументыУдостоверяющиеЛичность#6
  * type = Core_Cs_Nsi_Identity_Document#6 

* identifier[INN] ^short = "Государственный идентификационный номер налогоплательщика (ИНН)"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/core/systems/inn" 
  * type 1..1
  * type ^short = "Тип идентификатора, кодируется по Fixed value: http://terminology.hl7.org/CodeSystem/v2-0203" 
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#TAX
//  * type from http://terminology.hl7.org/CodeSystem/v2-0203

* identifier[passportRF] ^short = "Паспорт гражданина Российской Федерации"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/core/systems/passport-RF"
  * type 1..1
  * type ^short = "Тип идентификатора, кодируется по НСИ"
//  * type from $Ядро_НаборЗначений_ДокументыУдостоверяющиеЛичность (required)
  * type from Core_Vs_Nsi_Identity_Documents (required)
//  * type = $МЗРФ_Справочник_ДокументыУдостоверяющиеЛичность#1
  * type = Core_Cs_Nsi_Identity_Document#1

* identifier[SNILS] ^short = "Страховой номер индивидуального лицевого счёта, СНИЛС — уникальный номер индивидуального лицевого счёта застрахованного лица в системе обязательного пенсионного страхования"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/core/systems/snils"
  * type 1..1
  * type ^short = "Тип идентификатора, кодируется по Fixed value: http://terminology.hl7.org/CodeSystem/v2-0203" 
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#SB
//  * type from http://terminology.hl7.org/CodeSystem/v2-0203
  
* name ^short = "ФИО пациента"
  * family ^short = "Фамилия пациента"
  * given ^short = "Имя и отчество пациента. Первым должно идти имя, вторым - отчество"
  * use ^short = "Тип имени пациента. Рекомендуемое значение: official"
  
* gender ^short = "Пол пациента. Используются позиции: male | female | unknown. Other - не используется для совместимости со Справочником НСИМЗ Пол пациента"
* gender 0..1


//----------instance-full-------------------------------
Instance:   core-patient-instance-full
InstanceOf: Core_Patient
Title: "Core Instance Patient Full"
Description: "Пациент с паспортом, свидетельством о рождении, ИНН, СНИЛСом и парой телефонов"
Usage: #example

* address = core-address-instance-full

* birthDate = "1955-01-10"

* identifier[birthCertificate]
  * system = "http://fhir.ru/core/systems/birth-certificate"
  * value = "IIЮБ-123456"
  //* type = $МЗРФ_Справочник_ДокументыУдостоверяющиеЛичность#6  
  * type = Core_Cs_Nsi_Identity_Document#6
  
* identifier[INN]
  * system = "http://fhir.ru/core/systems/inn"
  * value = "463217055385"
//  * type = #TAX
  
* identifier[passportRF]
  * system = "http://fhir.ru/core/systems/passport-RF"
  * value = "7412 809982"
  //* type = $МЗРФ_Справочник_ДокументыУдостоверяющиеЛичность#1
  * type = Core_Cs_Nsi_Identity_Document#1
  
* identifier[SNILS]
  * system = "http://fhir.ru/core/systems/snils"
  * value = "152-873-614 14"
//  * type = #SB

* name
  * family = "Габсбург-Лотарингская"
  * given[0] = "Мария-Антуанетта"
  * given[1] = "Иоганновна"
  * use = #official

* gender = #female

* telecom[0]
  * system = #phone
  * value = "+7 960 700 5745"
  * use = #mobile
  
* telecom[1]
  * system = #phone
  * value = "+7 999 800 5577"
  * use = #work  
