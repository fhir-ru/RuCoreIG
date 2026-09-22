Profile: Core_Organization
Parent: Organization
Id: core-organization
Title: "Core Organization (Организация)"
Description: "Базовый профиль организации для российских FHIR-реализаций"

* extension contains OKATO named okato 0..1
* extension[okato] ^short = "Код по Общероссийскому классификатору административно-территориальных образований (ОКАТО)"

* name ^short = "Полное название организации"

* alias ^short = "Сокращенное наименование организации"

* contact
  * address ^short = "Адрес организации"
  * address ^comment = "Для адресов на территории Российской Федерации следует использовать правила профиля Core_Address. Для адресов вне территории Российской Федерации применяется базовый тип Address."

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Нарезка по системам идентификаторов организации"
* identifier contains  
  INN 0..1 and
  OGRN 0..1 and
  OKPO 0..1 and
  NSI-FRMO 0..1 and
  NSI-FRMO-Department 0..1

* identifier[INN] ^short = "Государственный идентификационный номер налогоплательщика (ИНН)"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/inn"
  * type 1..1
  * type = http://terminology.hl7.org/CodeSystem/v2-0203#TAX

* identifier[OGRN] ^short = "Основной государственный регистрационный номер юридического лица (ОГРН)"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/ogrn"

* identifier[OKPO] ^short = "Код ОКПО"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/okpo"

* identifier[NSI-FRMO] ^short = "Федеральный реестр медицинских организаций МЗ РФ (ФРМО)"
  * value only string
  * system 1..1
  * system = "https://fhir.ru/ig/core/systems/frmo"

* identifier[NSI-FRMO] ^comment = "OID самой медицинской организации. Если ресурс представляет подразделение, OID головной организации указывается в Organization, на которую ссылается partOf, а не как идентификатор подразделения."

* identifier[NSI-FRMO-Department] ^short = "OID структурного подразделения по ФРМО"
* identifier[NSI-FRMO-Department] ^comment = "Используется, если Organization представляет структурное подразделение. Значение — поле «OID структурного подразделения» справочника 1.2.643.5.1.13.13.99.2.114, без префикса urn:oid:. Срез необязателен; при его использовании system и value обязательны. Принадлежность подразделения медицинской организации представляется через partOf."
* identifier[NSI-FRMO-Department].system 1..1
* identifier[NSI-FRMO-Department].system = "https://fhir.ru/ig/core/systems/frmo-department"
* identifier[NSI-FRMO-Department].value 1..1

* qualification ^slicing.discriminator.type = #value
* qualification ^slicing.discriminator.path = "code.text"
* qualification ^slicing.rules = #open
* qualification ^slicing.description = "Нарезка по типам квалификаций организации"
* qualification contains medLicense 0..* 

* qualification[medLicense] ^short = "Медицинская лицензия"
  * code.text = "Лицензия на осуществление медицинской деятельности"
  * identifier 1..1
  * identifier.system = "https://fhir.ru/ig/core/systems/medlicense"
  * identifier.value 1..1
  * period 0..1
  * issuer 0..1
