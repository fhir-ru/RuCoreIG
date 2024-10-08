Instance:   core-ns-nsi-medical-workers-positions
InstanceOf: NamingSystem
Title: "Core NamingSystem NSI medical workers position (Должности мед и фарм работников)"
Usage: #definition

* name =   "Core_Ns_Nsi_Medical_Workers_Positions"

* status = #active

* kind = #codesystem

* date = "2024-01-01"

* description = "Справочник НСИ Минздрава <Должности медицинских и фармацевтических работников>, может быть известен под следующими идентификаторами: OID: 1.2.643.5.1.13.13.11.1002, Дополнительный OID:???, предпочтительно URI: https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1002/passport/9.5"

* uniqueId[0]
  * type = #oid
  * value = "1.2.643.5.1.13.13.11.1002"
  * comment = "Основной"

* uniqueId[1]
  * type = #uri
  * preferred = true
  * value = "http://fhir.ru/core/CodeSystem/core-ns-nsi-medical-workers-positions"

* uniqueId[2]
  * type = #uri
  * value = "https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1002/passport/9.5"


//Alias: $МЗРФ_Справочник_ДолжностиМедицинскихРаботников = Core_Cs_Nsi_Medical_Workers_Positions
CodeSystem: Core_Cs_Nsi_Medical_Workers_Positions
Id:         core-cs-nsi-medical-workers-positions
Title: "Core CodeSystem NSI medical workers positions (Должности медицинских работников)"
Description: "НСИ МЗ РФ справочник [Должности медицинских и фармацевтических работников](http://fhir.ru/core/CodeSystem/core-cs-nsi-medical-workers-positions)"

* ^experimental = false

* ^caseSensitive = false

* ^content = #not-present