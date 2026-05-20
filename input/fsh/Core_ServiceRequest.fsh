Profile: Core_ServiceRequest
Parent: ServiceRequest
Id: core-servicerequest
Title: "Core ServiceRequest (Запрос на оказание услуги)"
Description: "Базовый профиль запроса на оказание услуги для российских FHIR-реализаций"

* subject ^short = "Пациент"
* subject only Reference(Core_Patient or Group or Location or Device)

* requester ^short = "Запрашивающий"
* requester only Reference(Device or Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)

* performer ^short = "Исполнитель"
* performer only Reference(Core_CareTeam or Device or HealthcareService or Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)

* encounter ^short = "Случай оказания медицинской помощи"
* encounter only Reference(Core_Encounter) 

* insurance ^short = "Страховое покрытие"
* insurance only Reference(ClaimResponse or Core_Coverage) 
