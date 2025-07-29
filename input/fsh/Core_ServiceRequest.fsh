Profile: Core_ServiceRequest
Parent: ServiceRequest
Id: core-servicerequest
Title: "Core ServiceRequest (Запрос на оказание услуги)"
Description: "Базовый профиль запроса на оказание услуги для российских FHIR-реализаций"

* subject ^short = "Пациент"
* subject only Reference(Core_Patient)

* requester ^short = "Запрашивающий"
* requester only Reference(Core_PractitionerRole)

* performer ^short = "Исполнитель"
* performer only Reference(Core_PractitionerRole)

* encounter ^short = "Случай оказания медицинской помощи"
* encounter only Reference(Core_Encounter) 

* insurance ^short = "Страховое покрытие"
* insurance only Reference(Core_Coverage) 