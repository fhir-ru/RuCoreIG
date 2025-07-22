Profile: Core_Coverage
Parent: Coverage
Id: core-coverage
Title: "Core Coverage (Страховое покрытие)"
Description: "Базовый профиль страхового покрытия для российских FHIR-реализаций"

* type ^short = "Тип источника оплаты"
* type from Core_Vs_Nsi_Sources_Of_Payment (required)

* beneficiary ^short = "Бенефициар"
* beneficiary only Reference(Core_Patient)

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка по типам документов подтверждения страховки"
* identifier contains 
  omsPolicy 0..1

* identifier[omsPolicy] ^short = "Документ, подтверждающий страховку по ОМС"
  * value only string
  * system 1..1
  * system = "http://fhir.ru/ig/core/systems/oms"
  * type 1..1
  * type.coding 2..*
  * type.coding ^slicing.discriminator.type = #value
  * type.coding ^slicing.discriminator.path = "system"
  * type.coding ^slicing.rules = #open
  * type.coding ^slicing.description = "Нарезка по способу указания кода полиса ОМС - HL7 и РФ"
  * type.coding contains 
      hl7Type 1..1 and
      omsType 1..1
  * type.coding[hl7Type] = http://terminology.hl7.org/CodeSystem/v2-0203#SB
  * type.coding[omsType] ^short = "Тип полиса ОМС по справочнику НСИ МЗ РФ"
    * system 1..1
    * system = "urn:oid:1.2.643.5.1.13.13.99.2.245"
    * code 1..1
    * code from Core_Vs_Nsi_Coverage_Document_OMS (required)
