Profile: Core_ServiceRequest
Id:      core-servicerequest
Parent:       ServiceRequest
Title: "Core Service Request (Заказ услуги)"
Description: "Заказ услуги"

* subject 1..1
* subject ^short = "Пациент"
* subject only Reference(Core_Patient)

//----------instance-full-------------------------------

Instance:   core-servicerequest-instance-full
InstanceOf: Core_ServiceRequest
Title: "Core Instance Service Request Full"
Description: "запрос услуги (неполный! - непонятно что заказано)"
Usage: #example

* status = #active

* intent = #plan

* subject = Reference(core-patient-instance-full)