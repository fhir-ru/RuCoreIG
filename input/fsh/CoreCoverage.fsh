Profile: Core_Coverage
Id:      core-coverage
Parent:       Coverage
Title: "Core Coverage (Источник финансирования)"
Description: "Источник финансирования"

* type ^short = "Тип страхового покрытия. Binding:  Core_Vs_Nsi_Sources_Of_Paymente(required) Справочник НСИ Минздрава Источники оплаты медицинской помощи"

* payor ^short = "Плательщик: пациент, родственник или организация"
* payor 1..*
* payor only Reference(Core_Organization_Payer or Core_Patient_Payer or Core_Related_Person or Core_Related_Person_Payer)

* beneficiary 1..1
* beneficiary ^short = "Ссылка на пациента"
* beneficiary only Reference(Core_Patient)
 
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка по типам документов-оснований для оплаты медицинских услуг. ОМС; ДМС; Контракт"

* identifier contains OMS 0..1 
  and DMS 0..1 
  and Contract 0..1

* identifier[OMS] ^short = "Полис ОМС- обязательного медицинского страхования"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/core/systems/OMS"
  * type 1..1
  * type ^short = "Тип идентификатора, кодируется по НСИ"
//  * type from $Ядро_НаборЗначений_ДокументыОснованияОплаты (required)
  * type from Core_Vs_Nsi_Coverage_Document (required)
//  * type = $МЗРФ_Справочник_ДокументыОснованияОплаты#1
  * type = Core_Cs_Nsi_Coverage_Document#1
// второй слой слайсинга по типам полиса ОМС = старые, новые, электронные

* identifier[DMS] ^short = "Полис ДМС - добровольного медицинского страхования"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/core/systems/DMS"
  * type 1..1
  * type ^short = "Тип идентификатора, кодируется по НСИ"
//  * type from $Ядро_НаборЗначений_ДокументыОснованияОплаты (required)
  * type from Core_Vs_Nsi_Coverage_Document (required)
//  * type = $МЗРФ_Справочник_ДокументыОснованияОплаты#2
  * type = Core_Cs_Nsi_Coverage_Document#2

* identifier[Contract] ^short = "Договор на оказание платных медицинских услугя"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/core/systems/Contract"
  * type 1..1
  * type ^short = "Тип идентификатора, кодируется по НСИ"
//  * type from $Ядро_НаборЗначений_ДокументыОснованияОплаты (required)
  * type from Core_Vs_Nsi_Coverage_Document (required)
//  * type = $МЗРФ_Справочник_ДокументыОснованияОплаты#3
  * type = Core_Cs_Nsi_Coverage_Document#3

//----------instance-full-------------------------------
Instance: core-coverage-instance-full
InstanceOf: Core_Coverage
Title: "Core Instance Coverage Full"
Description: "Полное заполнение страховки, полис ОМС, но плательщиком указано физ лицо"
Usage: #example

//* type = $МЗРФ_Справочник_ИсточникиОплаты#1
* type = Core_Cs_Nsi_Sources_Of_Payment#1

* payor
  * identifier[+]
    * system = "http://fhir.ru/core/systems/ffoms_smo"
    * value = "22001"
  * display = "Ресо Алтай"

* beneficiary = Reference(core-patient-instance-full)

* identifier[OMS]
  * system = "http://fhir.ru/core/systems/OMS"
  * value = "1234567898765432"
//  * type = $МЗРФ_Справочник_ДокументыОснованияОплаты#1
  * type = Core_Cs_Nsi_Coverage_Document#1
* status = #active
 
