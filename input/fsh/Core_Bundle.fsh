Profile: Core_Bundle
Parent: Bundle
Id: core-bundle
Title: "Core Bundle (Пакет ресурсов)"
Description: "Базовый профиль Bundle для RuCore"

* identifier.type from Core_Vs_Identifier_Type (extensible)
* identifier ^short = "Идентификатор пакета, в том числе экземпляра документа в МИС"
* identifier ^comment = "Если Identifier.type содержит код mis-document, Identifier.system формируется как urn:oid:1.2.643.5.1.13.13.12.2.{код субъекта Российской Федерации}.{идентификатор медицинской организации в ФРМО}.100.{номер МИС}.{номер экземпляра МИС}.51, а Identifier.value обязателен. Этот идентификатор соответствует CDA ClinicalDocument.id и зависит от версии документа. CDA ClinicalDocument.versionNumber соответствует базовому элементу Composition.version, который RuCore дополнительно не ограничивает. Bundle.identifier имеет кардинальность 0..1 и потому не может быть нарезан средствами FHIR; идентификатор иного типа остается допустимым."
* identifier obeys core-bundle-mis-id-system

Invariant: core-bundle-mis-id-system
Description: "Система идентификатора экземпляра документа в МИС должна соответствовать структуре urn:oid:1.2.643.5.1.13.13.12.2.{субъект РФ}.{медицинская организация ФРМО}.100.{МИС}.{экземпляр МИС}.51"
Severity: #error
Expression: "type.coding.where(system = 'https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type' and code = 'mis-document').exists() implies (system.exists() and value.exists() and system.matches('^urn:oid:1[.]2[.]643[.]5[.]1[.]13[.]13[.]12[.]2[.](0|[1-9][0-9]*)[.][1-9][0-9]*[.]100[.][1-9][0-9]*[.][1-9][0-9]*[.]51$'))"
