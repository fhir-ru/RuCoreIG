Instance:   core-ns-nsi-coverage-document
InstanceOf: NamingSystem
Title: "Core NamingSystem NSI coverage document (Типы документов оснований)"
Usage: #definition

* name =   "Core_Ns_Nsi_Coverage_Document"
 
* status = #active

* kind = #codesystem

* date = "2024-01-01"

* description = "Справочник НСИ Минздрава <Типы документов оснований>, может быть известен под следующими идентификаторами: OID: 1.2.643.5.1.13.13.99.2.724, предпочтительно URI: http://fhir.ru/core/CodeSystem/core-cs-nsi-coverage-document "

* uniqueId[0]
  * type = #oid
  * value = "1.2.643.5.1.13.13.99.2.724"
  * comment = "Основной"

* uniqueId[1]
  * type = #uri
  * preferred = true
  * value = "http://fhir.ru/core/CodeSystem/core-ns-nsi-coverage-document"

* uniqueId[2]
  * type = #uri
  * value = "https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.724/passport/1.1"


//Alias: $МЗРФ_Справочник_ДокументыОснованияОплаты = Core_Cs_Nsi_Coverage_Document
CodeSystem: Core_Cs_Nsi_Coverage_Document
Id:         core-cs-nsi-coverage-document
Title: "Core CodeSystem NSI coverage document (Документы-основания для оплаты медицинских услуг)"
Description: "НСИ МЗ РФ справочник [Документы-основания для оплаты](http://fhir.ru/core/CodeSystem/core-cs-nsi-coverage-document)"

* ^experimental = false

* ^caseSensitive = false

* ^content = #complete

* #1 "Полис ОМС"
* #2 "Полис ДМС"
* #3 "Договор на оказание платных медицинских услуг"