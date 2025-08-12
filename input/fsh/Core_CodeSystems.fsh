// Системы кодирования


// Источники финансирования - 1

CodeSystem: Core_Cs_Nsi_Sources_Of_Payment
Id:         core-cs-nsi-sources-of-payment
Title: "Core CodeSystem Источники финансирования"
Description: "НСИ МЗ РФ справочник [Источники финансирования](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-sources-of-payment)"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-sources-of-payment"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete
* #1 "Средства обязательного медицинского страхования"
* #3 "Средства добровольного медицинского страхования"
* #4 "Средства пациента"
* #5 "Средства третьих физических лиц"
* #6 "Средства третьих юридических лиц"
* #8 "Средства федерального бюджета"
* #9 "Средства регионального бюджета"
* #10 "Средства обязательного социального страхования"
* #11 "Средства бюджета медицинской организации"
* #12 "Средства федерального и регионального бюджета"


// Типы документов - оснований оплаты - 2

CodeSystem: Core_Cs_Nsi_Coverage_Document
Id:         core-cs-nsi-coverage-document
Title: "Core CodeSystem Документы-основания для оплаты медицинских услуг"
Description: "НСИ МЗ РФ справочник [Документы-основания для оплаты](http://fhir.ru/core/CodeSystem/core-cs-nsi-coverage-document)"

* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete

* #1 "Полис ОМС"
* #2 "Полис ДМС"
* #3 "Договор на оказание платных медицинских услуг"


// Типы полисов ОМС - 3

CodeSystem: Core_Cs_Nsi_Coverage_Document_OMS  
Id: core-cs-nsi-coverage-document-oms  
Title: "Core CodeSystem Типы полисов ОМС"
Description: "НСИ МЗ РФ справочник [Типы полисов ОМС](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.245/passport/1.1)"

* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document-oms"
* ^version = "1.1"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete

* #1 "Полис ОМС старого образца"  
* #2 "Временное свидетельство"  
* #3 "Полис ОМС единого образца"


// Документы, удостоверяющие личность - 4

CodeSystem: Core_Cs_Nsi_Identity_Document
Id:         core-cs-nsi-identity-document
Title: "Core CodeSystem Документы удостоверяющие личность"
Description: "НСИ МЗ РФ справочник [документы удостоверяющие личность]"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-identity-document"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete
* ^hierarchyMeaning = #is-a

* #100 "Общегражданские документы"
  * #1 "Паспорт гражданина Российской Федерации"
  * #42 "Заграничный паспорт гражданина Российской Федерации"
  * #2 "Заграничный паспорт гражданина РФ с электронным носителем информации"
  * #5 "Временное удостоверение личности гражданина РФ"
  * #4 "Служебный паспорт гражданина РФ"
  * #6 "Свидетельство о рождении"
  * #24 "Медицинское свидетельство о рождении" "для детей в возрасте до 1 месяца"
  * #43 "Свидетельство о смерти"
* #400 "Специальные документы, связанные с удостоверением личности"
  * #36 "Водительское удостоверение"


// Должности медицинских работников - 5

CodeSystem: Core_Cs_Nsi_Medical_Workers_Positions
Id:         core-cs-nsi-medical-workers-positions
Title: "Core CodeSystem Должности медицинских работников"
Description: "НСИ МЗ РФ справочник [Должности медицинских и фармацевтических работников](https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-workers-positions)"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-workers-positions"
* ^experimental = false
* ^caseSensitive = false

//* ^content = #not-present
* ^content = #complete
* #1 "тестовое значение"


// Реестр медицинских организаций (ФРМО) - 6

CodeSystem: Core_Cs_Nsi_Register_Of_Medical_Organizations
Id:         core-cs-nsi-register-of-medical-organizations
Title: "Core CodeSystem Реестр медицинских организаций"
Description: "НСИ МЗ РФ справочник Реестр медицинских организаций"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-register-of-medical-organizations"
* ^experimental = false
* ^caseSensitive = false

//* ^content = #not-present
* ^content = #complete
* #1 "тестовое значение"


// Типы адресов - 7

CodeSystem: Core_Cs_Nsi_Address_Type
Id:         core-cs-nsi-address-type
Title: "Core CodeSystem Типы адреса"
Description: "НСИ МЗ РФ Тип адреса"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-address-type"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete
          
* #1 "Адрес по месту жительства (постоянной регистрации)"


// Регионы РФ - 8

CodeSystem: Core_Cs_Nsi_Region_RF
Id:         core-cs-nsi-region-rf
Title: "Регионы РФ"
Description: "Core CodeSystem Регионы РФ"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-region-rf"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete

* #77 "г. Москва" 
* #22 "Алтайский край"


// Медицинские услуги - 9
/*
CodeSystem: Core_Cs_Nsi_Medical_Services
Id: core-cs-nsi-medical-services
Title: "Core CodeSystem NSI Medical Services (Медицинские услуги)"
Description: "НСИ МЗ РФ справочник медицинских услуг"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-services"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete

* #B03.016.002 "Общий (клинический) анализ крови"
* #A11.12.009 "Взятие крови из периферической вены"
*/

CodeSystem: Core_Cs_Nsi_Medical_Services
Id: core-cs-nsi-medical-services
Title: "Core CodeSystem Медицинские услуги"
Description: "Ссылка на НСИ МЗ РФ справочник медицинских услуг"

* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-services"
* ^status = #active
* ^experimental = false
* ^content = #not-present  // Ключевое отличие!
* ^caseSensitive = false


// Единицы измерения - 10

CodeSystem: Core_Cs_Nsi_Units_Of_Measurement
Id: core-cs-nsi-units-of-measurement
Title: "Core CodeSystem NSI Units Of Measurement (Единицы измерения)"
Description: "Core CodeSystem Единицы измерения"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-units-of-measurement"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete

* #16 "мл"
* #20 "фл"
* #53 "%"
* #60 "г/л"
* #13 "пг"
* #322 "10^9/л"
* #328 "10^12/л"

// Виды медицинских карт
//Гипотеза в том, что справочник возник случайно и должен быть удален

//CodeSystem: Core_Cs_Nsi_Types_Medical_Cards
//Id: core-cs-nsi-types-medical-cards
//Title: "Core CodeSystem NSI types medical cards (Виды медицинских карт)"
//Description: "НСИ МЗ РФ справочник видов медицинских карт"
//* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-types-medical-cards"
//* ^experimental = false
//* ^caseSensitive = false
//* ^content = #complete

//* #1 "Амбулаторная карта"
//* #2 "Стационарная карта"

// ОКАТО - 11

CodeSystem: Core_Cs_Nsi_OKATO
Id: core-cs-nsi-okato
Title: "Core CodeSystem ОКАТО"
Description: "НСИ МЗ РФ справочник Отраслевой классификатор объектов административно-территориального деления"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-okato"
* ^experimental = false
* ^caseSensitive = false

//* ^content = #not-present
* ^content = #complete
* #1 "тестовое значение"


CodeSystem: Core_RelatedPerson_Relationship
Id: core-relatedperson-relationship
Title: "Core CodeSystem Типы родственных связей"
Description: "Коды родственных связей по справочнику HL7 и их переводы для СЭМД"

* ^url = "https://fhir.ru/ig/core/CodeSystem/core-relatedperson-relationship"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^language = #ru

// Set the default language for display to Russian
//* ^property[0].code = #display
//* ^property[0].uri = "http://hl7.org/fhir/ValueSet/designation-use"
//* ^property[0].description = "The display value for this code"
//* ^property[0].type = #string

// Family member relationships from v3-RoleCode
* #WIFE "Жена"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Жена"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "wife"


* #HUSB "Муж"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Муж"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "husband"

* #SON "Сын"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Сын"
//  * ^designation[1].language = #en-US
// * ^designation[1].value = "son"

* #DAU "Дочь"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Дочь"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "daughter"

* #FTH "Отец"
//  * ^designation[0].language = #ru
// * ^designation[0].use = #primary
//  * ^designation[0].value = "Отец"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "father"

* #MTH "Мать"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Мать"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "mother"

* #BRO "Брат"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Брат"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "brother"

* #SIS "Сестра"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Сестра"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "sister"

// Additional relationships from v2-0131
* #GUARD "Опекун"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Опекун"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "guardian"

* #PARNT "Родитель"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Родитель"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "parent"

// Common Russian healthcare relationships from NSI
* #1 "Законный представитель"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Законный представитель"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "legal representative"

* #2 "Опекун"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Опекун"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "guardian"

* #3 "Попечитель"
//  * ^designation[0].language = #ru
//  * ^designation[0].use = #primary
//  * ^designation[0].value = "Попечитель"
//  * ^designation[1].language = #en-US
//  * ^designation[1].value = "trustee"
