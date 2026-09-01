// Системы кодирования


// Источники оплаты медицинской помощи - 1

CodeSystem: Core_Cs_Nsi_Sources_Of_Payment
Id:         core-cs-nsi-sources-of-payment
Title: "Core CodeSystem Источники оплаты медицинской помощи"
Description: "НСИ МЗ РФ справочник [Источники оплаты медицинской помощи](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1039)"
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
Description: "НСИ МЗ РФ справочник [Документы-основания для оплаты](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.724)"

* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete

* #1 "Полис ОМС"
* #2 "Полис ДМС"
* #3 "Договор на оказание платных медицинских услуг"


// Виды полиса ОМС - 3

CodeSystem: Core_Cs_Nsi_Coverage_Document_OMS  
Id: core-cs-nsi-coverage-document-oms  
Title: "Core CodeSystem Виды полиса ОМС"
Description: "НСИ МЗ РФ справочник [Виды полиса ОМС](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1035)"

* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document-oms"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete

* #1 "Полис ОМС старого образца"  
* #2 "Полис ОМС единого образца, бессрочный"
* #3 "Полис ОМС единого образца, со сроком действия"
* #4 "Временное свидетельство"


// Документы, удостоверяющие личность - 4

CodeSystem: Core_Cs_Nsi_Identity_Document
Id:         core-cs-nsi-identity-document
Title: "Core CodeSystem Документы удостоверяющие личность"
Description: "НСИ МЗ РФ справочник [документы удостоверяющие личность](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.48)"
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
Description: "НСИ МЗ РФ справочник [Должности медицинских и фармацевтических работников](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1002)"
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
Description: "НСИ МЗ РФ справочник [Реестр медицинских организаций](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1461)"
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
Description: "НСИ МЗ РФ справочник [Тип адреса](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1504)"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-address-type"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete
          
* #1 "Адрес по месту жительства (постоянной регистрации)"


// Регионы РФ - 8

CodeSystem: Core_Cs_Nsi_Region_RF
Id:         core-cs-nsi-region-rf
Title: "Core CodeSystem Регионы РФ"
Description: "НСИ МЗ РФ справочник [Регионы РФ](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.206)"
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
Title: "Core CodeSystem Номенклатура медицинских услуг"
Description: "Ссылка на НСИ МЗ РФ справочник [медицинских услуг](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1070)"

* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-medical-services"
* ^status = #active
* ^experimental = false
* ^content = #not-present
* ^caseSensitive = false


// Единицы измерения - 10

CodeSystem: Core_Cs_Nsi_Units_Of_Measurement
Id: core-cs-nsi-units-of-measurement
Title: "Core CodeSystem Единицы измерения"
Description: "НСИ МЗ РФ справочник [единиц измерения](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1358)"
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
Description: "НСИ МЗ РФ справочник [Отраслевой классификатор объектов административно-территориального деления](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.2.1.1.608)"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-okato"
* ^experimental = false
* ^caseSensitive = false

//* ^content = #not-present
* ^content = #complete
* #1 "тестовое значение"


// Страховые медицинские организации (страховщики) - 12

CodeSystem: Core_Cs_Nsi_Insurer
Id: core-cs-nsi-insurer
Title: "Core CodeSystem Страховые медицинские организации"
Description: "НСИ МЗ РФ справочник [Страховые медицинские организации](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.183)"
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-insurer"
* ^experimental = false
* ^caseSensitive = false
* ^content = #not-present


// Виды нозологических единиц диагноза - 13

CodeSystem: Core_Cs_Nsi_Diagnosis_Nosology_Kind
Id: core-cs-nsi-diagnosis-nosology-kind
Title: "Core CodeSystem Виды нозологических единиц диагноза"
Description: "НСИ МЗ РФ справочник [Виды нозологических единиц диагноза](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1077). Состав зафиксирован по актуальной версии справочника; ранее исключенные категории, в том числе сочетанные заболевания, не требуются."
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-diagnosis-nosology-kind"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete

* #1 "Основное заболевание"
* #2 "Осложнение основного заболевания"
* #3 "Сопутствующее заболевание"
* #4 "Конкурирующее заболевание"
* #5 "Внешние причины заболеваемости и смертности"
* #6 "Фоновое заболевание"
* #7 "Осложнение сопутствующего заболевания"


// Степень обоснованности диагноза - 14

CodeSystem: Core_Cs_Nsi_Diagnosis_Justification_Degree
Id: core-cs-nsi-diagnosis-justification-degree
Title: "Core CodeSystem Степень обоснованности диагноза"
Description: "НСИ МЗ РФ справочник [Степень обоснованности диагноза](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.795). Состав зафиксирован по актуальной версии 3.2 справочника, включая иерархию клинических, патолого-анатомических и судебно-медицинских диагнозов. В стационарной практике предварительный клинический диагноз соответствует диагнозу при поступлении, заключительный клинический — выписному."
* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-diagnosis-justification-degree"
* ^experimental = false
* ^caseSensitive = false
* ^content = #complete
* ^hierarchyMeaning = #is-a

* #10 "Клинический диагноз"
  * #1 "Предварительный клинический диагноз"
  * #2 "Этапный клинический диагноз"
  * #3 "Заключительный клинический диагноз"
* #4 "Патолого-анатомический диагноз"
  * #41 "Предварительный патолого-анатомический диагноз"
  * #42 "Заключительный патолого-анатомический диагноз"
* #5 "Судебно-медицинский диагноз"
  * #51 "Предварительный судебно-медицинский диагноз"
  * #52 "Заключительный судебно-медицинский диагноз"


// Типы идентификаторов СЭМД

CodeSystem: Core_Cs_Semd_Identifier_Type
Id: core-cs-semd-identifier-type
Title: "Core CodeSystem Типы идентификаторов СЭМД"
Description: "Семантические типы идентификаторов, используемых при представлении СЭМД в FHIR. Тип внутренней ссылки на документ не включен, поскольку такая ссылка в зависимости от контекста представляется Element.id, Reference или другим элементом FHIR, а не универсальным Identifier."

* ^url = "https://fhir.ru/ig/core/CodeSystem/core-cs-semd-identifier-type"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

* #mis-patient "Идентификатор пациента в экземпляре МИС" "Тип идентификатора пациента, для которого Identifier.system формируется с типовым узлом 10."
* #mis-encounter "Идентификатор случая оказания медицинской помощи в экземпляре МИС" "Тип идентификатора случая оказания медицинской помощи с типовым узлом 15."
* #mis-inpatient-record "Номер стационарной медицинской карты в экземпляре МИС" "Тип номера стационарной медицинской карты с типовым узлом 16."
* #mis-ambulatory-encounter "Идентификатор амбулаторного случая или посещения в экземпляре МИС" "Тип идентификатора амбулаторного случая или посещения с типовым узлом 17."
* #mis-document-set "Идентификатор набора версий документа в экземпляре МИС" "Тип идентификатора набора версий документа, соответствующего CDA ClinicalDocument.setId, с типовым узлом 50."
* #mis-document "Идентификатор экземпляра документа в МИС, зависящий от версии" "Тип идентификатора конкретного экземпляра документа, соответствующего CDA ClinicalDocument.id, с типовым узлом 51."
* #mis-practitioner-role "Идентификатор роли медицинского работника в экземпляре МИС" "Тип идентификатора роли медицинского работника с типовым узлом 70."
