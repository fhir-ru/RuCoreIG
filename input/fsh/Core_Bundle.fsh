Profile: Core_Bundle
Parent: Bundle
Id: core-bundle
Title: "Core Bundle (Пакет ресурсов)"
Description: "Базовый профиль Bundle для RuCore"

* identifier.type from Core_Vs_Identifier_Type (extensible)
* identifier ^short = "Идентификатор пакета, в том числе экземпляра документа в МИС"
* identifier ^comment = "Если Identifier.type содержит код mis-document, Identifier.system содержит OID в URI-форме urn:oid:... с конечным узлом .51 (корень организации и промежуточные узлы не ограничиваются), а Identifier.value обязателен. Этот идентификатор соответствует CDA ClinicalDocument.id и зависит от версии документа. CDA ClinicalDocument.versionNumber соответствует базовому элементу Composition.version, который RuCore дополнительно не ограничивает. Bundle.identifier имеет кардинальность 0..1 и потому не может быть нарезан средствами FHIR; идентификатор иного типа остается допустимым."
* identifier obeys core-bundle-mis-id-system

Invariant: core-bundle-mis-id-system
Description: "Система идентификатора экземпляра документа в МИС должна быть OID в URI-форме urn:oid:... с конечным узлом .51"
Severity: #error
Expression: "type.coding.where(system = 'https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type' and code = 'mis-document').exists() implies (system.exists() and value.exists() and system.matches('^urn:oid:[0-2]([.](0|[1-9][0-9]*))+[.]51$'))"
