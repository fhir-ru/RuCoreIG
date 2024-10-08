Instance:   core-ns-rf-birth-certificate
InstanceOf: NamingSystem
Title: "Core NamingSystem RF Birth Certificate (Номер гос свидетельства о рождении)"
Usage: #definition

* name =   "Core_Ns_Rf_Birth_Certificate"

* description = "Номера государственных свидетельств о рождении формируются государственной системой органов записи актов гражданского состояния (ЗАГС), с внесением в единый реестр записей актов гражданского состояния (ЕГР ЗАГС). Предполагается, что номер уникален, сведений об ограничении срока уникальности номера нет."

* status = #active

* kind = #identifier

* date = "2023-11-22"

* uniqueId
  * type = #uri
  * value = "http://fhir.ru/core/systems/birth-certificate"
  * preferred = true