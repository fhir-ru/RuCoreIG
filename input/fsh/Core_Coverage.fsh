Profile: Core_Coverage
Parent: Coverage
Id: core-coverage
Title: "Core Coverage (Страховое покрытие)"
Description: "Базовый профиль страхового покрытия для российских FHIR-реализаций"

* type ^short = "Тип источника оплаты"
* type from Core_Vs_Nsi_Sources_Of_Payment (extensible)

* beneficiary ^short = "Бенефициар"
* beneficiary only Reference(Core_Patient)

// Документы-основания оплаты медицинской помощи.
// Наличие документа не обязательно; тип обязателен для распознавания среза.
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Документы оплаты распознаются по принадлежности типа к справочнику НСИ"
* identifier contains coverageDocument 0..*

* identifier[coverageDocument]
  * ^short = "Документ-основание оплаты медицинской помощи"
  * ^definition = "Идентификатор документа, подтверждающего основание оплаты медицинской помощи. Тип документа указывается по справочнику НСИ МЗ РФ «Документы-основания для оплаты медицинских услуг»."
  * type 1..1
  * type from Core_Vs_Nsi_Coverage_Document (required)
  * system ^short = "Пространство уникальности номера документа"
  * value ^short = "Номер документа"

// Вложенный срез наследует открытый slicing по type.
* identifier[coverageDocument] contains omsPolicy 0..1

* identifier[coverageDocument/omsPolicy]
  * ^short = "Полис обязательного медицинского страхования"
  * system = "https://fhir.ru/ig/core/systems/oms"
  * type ^patternCodeableConcept.coding[0].system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document"
  * type ^patternCodeableConcept.coding[0].code = #1
  * type.coding ^comment = "Срез omsType проверяет кодирование с canonical URI RuCore. Эквивалентное обозначение системы urn:oid:1.2.643.5.1.13.13.11.1035 сохранено в NamingSystem и допускается открытой нарезкой, но ограничения omsType к такому coding не применяются. NamingSystem не обеспечивает автоматическую эквивалентность при валидации; полноту проверки альтернативных кодирований определяют прикладные профили и их средства валидации."
  * type.coding ^slicing.discriminator.type = #pattern
  * type.coding ^slicing.discriminator.path = "$this"
  * type.coding ^slicing.rules = #open
  * type.coding ^slicing.description = "Тип документа обязателен; вид полиса ОМС указывается при наличии"
  * type.coding contains
      coverageDocumentType 1..1 and
      omsType 0..1
  * type.coding[coverageDocumentType]
    * ^short = "Полис ОМС по справочнику документов-оснований оплаты"
    * system 1..1
    * ^patternCoding.system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document"
    * code 1..1
    * ^patternCoding.code = #1
  * type.coding[omsType]
    * ^short = "Вид полиса ОМС по справочнику НСИ МЗ РФ"
    * system 1..1
    * ^patternCoding.system = "https://fhir.ru/ig/core/CodeSystem/core-cs-nsi-coverage-document-oms"
    * code 1..1
    * code from Core_Vs_Nsi_Coverage_Document_OMS (required)
