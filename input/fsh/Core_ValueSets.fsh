
// ValueSet для источников финансирования - 1

ValueSet: Core_Vs_Nsi_Sources_Of_Payment
Id: core-vs-nsi-sources-of-payment
Title: "Источники оплаты"
Description: "Источники оплаты по НСИ"

* ^url = "https://fhir.ru/ig/core/ValueSet/core-vs-nsi-sources-of-payment"
* ^status = #active
* ^experimental = false

* include codes from system https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-sources-of-payment

//ValueSet для документов - оснований оплаты - 2

// ValueSet для типов полисов ОМС - 3
ValueSet: Core_Vs_Nsi_Coverage_Document_OMS
Id: core-vs-nsi-coverage-document-oms
Title: "Типы полисов ОМС"
Description: "Типы полисов ОМС по НСИ МЗ РФ"

* ^url = "http://fhir.ru/ig/core/ValueSet/core-vs-nsi-coverage-document-oms"
* ^status = #active
* ^experimental = false

* include codes from system https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document-oms


// ValueSet для документов, удостоверяющих личность - 4
ValueSet: Core_Vs_Nsi_Identity_Documents
Id: core-vs-nsi-identity-documents
Title: "Документы, удостоверяющие личность"
Description: "Документы, удостоверяющие личность по НСИ"

* ^url = "https://fhir.ru/ig/core/ValueSet/core-vs-nsi-identity-documents"
* ^status = #active
* ^experimental = false

* include codes from system https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-identity-document


// ValueSet для должностей медицинских работников - 5
ValueSet: Core_Vs_Nsi_Medical_Workers_Positions
Id: core-vs-nsi-medical-workers-positions
Title: "Должности медицинских работников"
Description: "Должности медицинских и фармацевтических работников по НСИ"

* ^url = "https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-workers-positions"
* ^status = #active
* ^experimental = false

* include codes from system https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-workers-positions


// ValueSet Федеральный реестр медицинских организаций (НСИ-ФРМО) - 6
ValueSet: Core_Vs_Nsi_Register_Of_Medical_Organizations
Id: core-vs-nsi-register-of-medical-organizations
Title: "Core ValueSet NSI-FRMO (Федеральный реестр медицинских организаций)"
Description: "НСИ МЗ РФ Федеральный реестр медицинских организаций (ФРМО) - все значения кодовой системы."

* ^url = "https://fhir.ru/ig/core/ValueSet/core-vs-nsi-register-of-medical-organizations"
* ^status = #active
* ^experimental = false

* include codes from system https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-register-of-medical-organizations


// ValueSet для типов адресов - 7
ValueSet: Core_Vs_Nsi_Address_Type
Id: core-vs-nsi-address-type
Title: "Типы адресов"
Description: "Типы адресов по НСИ"

* ^url = "https://fhir.ru/ig/core/ValueSet/core-vs-nsi-address-type"
* ^status = #active
* ^experimental = false

* include codes from system https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-address-type


// Регионы РФ - 8

ValueSet: Core_Vs_Nsi_Region_RF
Id: core-vs-nsi-region-rf
Title: "Регионы РФ"
Description: "НСИ МЗ РФ справочник [Регионы РФ]"

* ^url = "https://fhir.ru/ig/core/ValueSet/core-vs-nsi-region-rf"
* ^status = #active
* ^experimental = false

* include codes from system https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-region-rf


// ValueSet для медицинских услуг - 9

ValueSet: Core_Vs_Nsi_Medical_Services
Id: core-vs-nsi-medical-services
Title: "Медицинские услуги"
Description: "Медицинские услуги по Номенклатуре медицинских услуг МЗ РФ"

* ^url = "https://fhir.ru/ig/core/ValueSet/core-vs-nsi-medical-services"
* ^status = #active
* ^experimental = false

* include codes from system https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-services


// Единицы измерения - 10

ValueSet: Core_Vs_Nsi_Units_Of_Measurement
Id: core-vs-nsi-units-of-measurement
Title: "Единицы измерения"
Description: "Справочник единиц измерения"

* ^url = "https://fhir.ru/ig/core/ValueSet/core-vs-nsi-units-of-measurement"
* ^status = #active
* ^experimental = false

* include codes from system https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-units-of-measurement


// ОКАТО - 11

ValueSet: Core_Vs_Nsi_OKATO
Id: core-vs-nsi-okato
Title: "Отраслевой классификатор административно-территориальных объектов"
Description: "НСИ МЗ РФ справочник Отраслевой классификатор объектов административно-территориального деления"

* ^url = "https://fhir.ru/ig/core/ValueSet/core-vs-nsi-okato"
* ^status = #active
* ^experimental = false

* include codes from system https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-okato




// ValueSet для видов медицинских карт
//Гипотеза в том, что справочник возник случайно и должен быть удален
//ValueSet: Core_Vs_Nsi_Types_Medical_Cards
//Id: core-vs-nsi-types-medical-cards
//Title: "Виды медицинских карт"
//Description: "Виды медицинских карт по НСИ МЗ РФ"

//* ^url = "https://fhir.ru/ig/core/ValueSet/core-vs-nsi-types-medical-cards"
//* ^status = #active
//* ^experimental = false

//* include codes from system https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-types-medical-cards
