Instance:   core-ns-nsi-register-of-medical-organizations
InstanceOf: NamingSystem
Title: "Core NamingSystem NSI register of med organizations (Реестр медицинских организаций)"
Usage: #definition

* name =   "Core_Ns_Nsi_Register_Of_Medical_Organizations"

* status = #active

* kind = #codesystem

* date = "2023-12-01"

* description = "Справочник НСИ Минздрава <Реестр медицинских организаций Российской Федерации>, может быть известен под следующими идентификаторами: OID: 1.2.643.5.1.13.13.11.1461, Дополнительный OID:???, предпочтительно URI: http://fhir.ru/core/CodeSystem/core-ns-nsi-register_of_ medical_organizations"

* uniqueId[0]
  * type = #oid
  * value = "1.2.643.5.1.13.13.11.1461"
  * comment = "Основной"


//Alias: $МЗРФ_Справочник_РеестрМедицинскихОрганизаций = Core_Cs_Nsi_Register_Of_Medical_Organizations
CodeSystem: Core_Cs_Nsi_Register_Of_Medical_Organizations
Id:         core-cs-nsi-register-of-medical-organizations
Title: "Core CodeSystem NSI register of medical organizations (Реестр медицинских организаций)"
Description: "НСИ МЗ РФ справочник [Реестр медицинских организаций](http://fhir.ru/core/CodeSystem/core-cs-nsi-register_of_ medical_organizations)"

* ^experimental = false

* ^caseSensitive = false

* ^content = #not-present