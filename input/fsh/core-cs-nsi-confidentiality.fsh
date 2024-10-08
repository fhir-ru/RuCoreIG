Instance:   core-ns-nsi-confidentiality 
InstanceOf: NamingSystem
Title: "Core NamingSystem NSI confidentiality (Уровень конфиденциальности медицинского документа)"
Usage: #definition

* name =   "Core_Ns_Nsi_Confidentiality"

* status = #active

* kind = #codesystem

* date = "2024-01-01"

* description = "Справочник НСИ Минздрава <Уровень конфиденциальности медицинского документа>, может быть известен под следующими идентификаторами: OID: 1.2.643.5.1.13.13.99.2.285, Дополнительный OID:???, предпочтительно URI: https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.285/passport/1.2"

* uniqueId[0]
  * type = #oid
  * value = "1.2.643.5.1.13.13.99.2.285"
  * comment = "Основной"

* uniqueId[1]
  * type = #uri
  * preferred = true
  * value = "http://fhir.ru/core/CodeSystem/core-ns-nsi-confidentiality"

* uniqueId[2]
  * type = #uri
  * value = "https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.285/passport/1.2"


//Alias: $МЗРФ_Справочник_УровеньКонфиденциальностиМедицинскогоДокумента = Core_Cs_Nsi_Confidentiality
CodeSystem: Core_Cs_Nsi_Confidentiality
Id:         core-cs-nsi-confidentiality
Title: "Core CodeSystem NSI Confidentiality (Уровень конфиденциальности медицинского документа)"
Description: "НСИ МЗ РФ справочник [Уровень конфиденциальности медицинского документа](http://fhir.ru/core/CodeSystem/core-cs-nsi-confidentiality)"

* ^experimental = false

* ^caseSensitive = false

* ^content = #complete

* #1 "Обычный доступ"
* #2 "Ограниченный доступ"
* #3 "Крайне ограниченный доступ"