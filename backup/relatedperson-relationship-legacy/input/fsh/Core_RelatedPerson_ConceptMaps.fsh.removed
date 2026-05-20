Alias: $ru-relatedperson = https://fhir.ru/ig/core/CodeSystem/core-relatedperson-relationship
Alias: $hl7-rolecode = http://terminology.hl7.org/CodeSystem/v3-RoleCode
Alias: $nsi-rel-14 = urn:oid:1.2.643.5.1.13.13.99.2.14
Alias: $nsi-rel-1021 = urn:oid:1.2.643.5.1.13.13.11.1021
Alias: $nsi-rel-240 = urn:oid:1.2.643.5.1.13.13.99.2.240

Instance: core-cm-relatedperson-hl7
InstanceOf: ConceptMap
Usage: #definition
Title: "Core ConceptMap RuCore -> HL7 RoleCode"
Description: "Соответствия между каноническими отношениями RuCore и [кодами HL7 RoleCode](https://terminology.hl7.org/CodeSystem-v3-RoleCode.html) для `RelatedPerson`."

* url = "https://fhir.ru/ig/core/ConceptMap/core-cm-relatedperson-hl7"
* name = "CoreCmRelatedpersonHl7"
* status = #active
* experimental = false
* sourceScopeUri = "https://fhir.ru/ig/core/CodeSystem/core-relatedperson-relationship"
* targetScopeUri = "http://terminology.hl7.org/CodeSystem/v3-RoleCode"
* group[0].source = $ru-relatedperson
* group[0].target = $hl7-rolecode
* group[0].element[0].code = #mother
* group[0].element[0].display = "Мать"
* group[0].element[0].target[0].code = #MTH
* group[0].element[0].target[0].display = "mother"
* group[0].element[0].target[0].relationship = #equivalent
* group[0].element[1].code = #father
* group[0].element[1].display = "Отец"
* group[0].element[1].target[0].code = #FTH
* group[0].element[1].target[0].display = "father"
* group[0].element[1].target[0].relationship = #equivalent
* group[0].element[2].code = #parent
* group[0].element[2].display = "Родитель"
* group[0].element[2].target[0].code = #PARNT
* group[0].element[2].target[0].display = "parent"
* group[0].element[2].target[0].relationship = #equivalent
* group[0].element[3].code = #spouse
* group[0].element[3].display = "Супруг(а)"
* group[0].element[3].target[0].code = #SPS
* group[0].element[3].target[0].display = "spouse"
* group[0].element[3].target[0].relationship = #equivalent
* group[0].element[4].code = #child
* group[0].element[4].display = "Ребенок"
* group[0].element[4].target[0].code = #CHILD
* group[0].element[4].target[0].display = "child"
* group[0].element[4].target[0].relationship = #equivalent
* group[0].element[5].code = #sibling
* group[0].element[5].display = "Брат или сестра"
* group[0].element[5].target[0].code = #SIB
* group[0].element[5].target[0].display = "sibling"
* group[0].element[5].target[0].relationship = #equivalent
* group[0].element[6].code = #grandparent
* group[0].element[6].display = "Дедушка или бабушка"
* group[0].element[6].target[0].code = #GRPRN
* group[0].element[6].target[0].display = "grandparent"
* group[0].element[6].target[0].relationship = #equivalent
* group[0].element[7].code = #grandchild
* group[0].element[7].display = "Внук или внучка"
* group[0].element[7].target[0].code = #GRNDCHILD
* group[0].element[7].target[0].display = "grandchild"
* group[0].element[7].target[0].relationship = #equivalent
* group[0].element[8].code = #adoptive-parent
* group[0].element[8].display = "Усыновитель"
* group[0].element[8].target[0].code = #ADOPTP
* group[0].element[8].target[0].display = "adoptive parent"
* group[0].element[8].target[0].relationship = #equivalent
* group[0].element[9].code = #adopted-child
* group[0].element[9].display = "Усыновленный"
* group[0].element[9].target[0].code = #CHLDADOPT
* group[0].element[9].target[0].display = "adopted child"
* group[0].element[9].target[0].relationship = #equivalent
* group[0].element[10].code = #guardian
* group[0].element[10].display = "Опекун"
* group[0].element[10].target[0].code = #GUARD
* group[0].element[10].target[0].display = "guardian"
* group[0].element[10].target[0].relationship = #equivalent
* group[0].element[11].code = #relative
* group[0].element[11].display = "Родственник"
* group[0].element[11].target[0].code = #FAMMEMB
* group[0].element[11].target[0].display = "family member"
* group[0].element[11].target[0].relationship = #source-is-narrower-than-target
* group[0].element[12].code = #authorized-person
* group[0].element[12].display = "Уполномоченное лицо"
* group[0].element[12].target[0].code = #GUARD
* group[0].element[12].target[0].display = "guardian"
* group[0].element[12].target[0].relationship = #related-to
* group[0].element[12].target[0].comment = "В HL7 RoleCode нет точного аналога для общего понятия 'уполномоченное лицо'; guardian используется как частичное приближение."

Instance: core-cm-relatedperson-nsi-14
InstanceOf: ConceptMap
Usage: #definition
Title: "Core ConceptMap RuCore -> НСИ МЗ РФ 1.2.643.5.1.13.13.99.2.14"
Description: "Соответствия между каноническими отношениями RuCore и [справочником НСИ МЗ РФ 1.2.643.5.1.13.13.99.2.14 «Родственные и иные связи»](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.14)."

* url = "https://fhir.ru/ig/core/ConceptMap/core-cm-relatedperson-nsi-14"
* name = "CoreCmRelatedpersonNsi14"
* status = #active
* experimental = false
* sourceScopeUri = "https://fhir.ru/ig/core/CodeSystem/core-relatedperson-relationship"
* targetScopeUri = "https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.14"
* group[0].source = $ru-relatedperson
* group[0].target = $nsi-rel-14
* group[0].element[0].code = #mother
* group[0].element[0].target[0].code = #1
* group[0].element[0].target[0].display = "Мать"
* group[0].element[0].target[0].relationship = #equivalent
* group[0].element[1].code = #father
* group[0].element[1].target[0].code = #2
* group[0].element[1].target[0].display = "Отец"
* group[0].element[1].target[0].relationship = #equivalent
* group[0].element[2].code = #relative
* group[0].element[2].target[0].code = #3
* group[0].element[2].target[0].display = "Родственник"
* group[0].element[2].target[0].relationship = #equivalent
* group[0].element[3].code = #authorized-person
* group[0].element[3].target[0].code = #4
* group[0].element[3].target[0].display = "Уполномоченное лицо"
* group[0].element[3].target[0].relationship = #equivalent
* group[0].element[4].code = #parent
* group[0].element[4].target[0].code = #1
* group[0].element[4].target[0].display = "Мать"
* group[0].element[4].target[0].relationship = #source-is-broader-than-target
* group[0].element[4].target[1].code = #2
* group[0].element[4].target[1].display = "Отец"
* group[0].element[4].target[1].relationship = #source-is-broader-than-target

Instance: core-cm-relatedperson-nsi-1021
InstanceOf: ConceptMap
Usage: #definition
Title: "Core ConceptMap RuCore -> НСИ МЗ РФ 1.2.643.5.1.13.13.11.1021"
Description: "Соответствия между каноническими отношениями RuCore и [справочником НСИ МЗ РФ 1.2.643.5.1.13.13.11.1021 «Тип родственной связи»](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1021)."

* url = "https://fhir.ru/ig/core/ConceptMap/core-cm-relatedperson-nsi-1021"
* name = "CoreCmRelatedpersonNsi1021"
* status = #active
* experimental = false
* sourceScopeUri = "https://fhir.ru/ig/core/CodeSystem/core-relatedperson-relationship"
* targetScopeUri = "https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.11.1021"
* group[0].source = $ru-relatedperson
* group[0].target = $nsi-rel-1021
* group[0].element[0].code = #spouse
* group[0].element[0].target[0].code = #1
* group[0].element[0].target[0].display = "Супруг(а)"
* group[0].element[0].target[0].relationship = #equivalent
* group[0].element[1].code = #child
* group[0].element[1].target[0].code = #2
* group[0].element[1].target[0].display = "Ребенок"
* group[0].element[1].target[0].relationship = #equivalent
* group[0].element[2].code = #parent
* group[0].element[2].target[0].code = #3
* group[0].element[2].target[0].display = "Родитель"
* group[0].element[2].target[0].relationship = #equivalent
* group[0].element[3].code = #sibling
* group[0].element[3].target[0].code = #4
* group[0].element[3].target[0].display = "Родной (ая) брат/сестра"
* group[0].element[3].target[0].relationship = #equivalent
* group[0].element[4].code = #grandchild
* group[0].element[4].target[0].code = #5
* group[0].element[4].target[0].display = "Внук/внучка"
* group[0].element[4].target[0].relationship = #equivalent
* group[0].element[5].code = #grandparent
* group[0].element[5].target[0].code = #6
* group[0].element[5].target[0].display = "Дедушка/бабушка"
* group[0].element[5].target[0].relationship = #equivalent
* group[0].element[6].code = #adopted-child
* group[0].element[6].target[0].code = #7
* group[0].element[6].target[0].display = "Усыновлённый"
* group[0].element[6].target[0].relationship = #equivalent
* group[0].element[7].code = #adoptive-parent
* group[0].element[7].target[0].code = #8
* group[0].element[7].target[0].display = "Усыновитель"
* group[0].element[7].target[0].relationship = #equivalent
* group[0].element[8].code = #mother
* group[0].element[8].target[0].code = #3
* group[0].element[8].target[0].display = "Родитель"
* group[0].element[8].target[0].relationship = #source-is-narrower-than-target
* group[0].element[9].code = #father
* group[0].element[9].target[0].code = #3
* group[0].element[9].target[0].display = "Родитель"
* group[0].element[9].target[0].relationship = #source-is-narrower-than-target

Instance: core-cm-relatedperson-nsi-240
InstanceOf: ConceptMap
Usage: #definition
Title: "Core ConceptMap RuCore -> НСИ МЗ РФ 1.2.643.5.1.13.13.99.2.240"
Description: "Соответствия между каноническими отношениями RuCore и [справочником НСИ МЗ РФ 1.2.643.5.1.13.13.99.2.240 «Трансплантология. Типы родственной связи»](https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.240)."

* url = "https://fhir.ru/ig/core/ConceptMap/core-cm-relatedperson-nsi-240"
* name = "CoreCmRelatedpersonNsi240"
* status = #active
* experimental = false
* sourceScopeUri = "https://fhir.ru/ig/core/CodeSystem/core-relatedperson-relationship"
* targetScopeUri = "https://nsi.rosminzdrav.ru/dictionaries/1.2.643.5.1.13.13.99.2.240"
* group[0].source = $ru-relatedperson
* group[0].target = $nsi-rel-240
* group[0].element[0].code = #spouse
* group[0].element[0].target[0].code = #1
* group[0].element[0].target[0].display = "Супруг(-а)"
* group[0].element[0].target[0].relationship = #equivalent
* group[0].element[1].code = #child
* group[0].element[1].target[0].code = #2
* group[0].element[1].target[0].display = "Сын / дочь"
* group[0].element[1].target[0].relationship = #equivalent
* group[0].element[2].code = #parent
* group[0].element[2].target[0].code = #3
* group[0].element[2].target[0].display = "Отец / мать"
* group[0].element[2].target[0].relationship = #equivalent
* group[0].element[3].code = #sibling
* group[0].element[3].target[0].code = #4
* group[0].element[3].target[0].display = "Родной(-ая) брат / сестра"
* group[0].element[3].target[0].relationship = #equivalent
* group[0].element[4].code = #grandchild
* group[0].element[4].target[0].code = #5
* group[0].element[4].target[0].display = "Внук / внучка"
* group[0].element[4].target[0].relationship = #equivalent
* group[0].element[5].code = #grandparent
* group[0].element[5].target[0].code = #6
* group[0].element[5].target[0].display = "Дедушка / бабушка"
* group[0].element[5].target[0].relationship = #equivalent
* group[0].element[6].code = #adopted-child
* group[0].element[6].target[0].code = #7
* group[0].element[6].target[0].display = "Усыновленный"
* group[0].element[6].target[0].relationship = #equivalent
* group[0].element[7].code = #adoptive-parent
* group[0].element[7].target[0].code = #8
* group[0].element[7].target[0].display = "Усыновитель"
* group[0].element[7].target[0].relationship = #equivalent
* group[0].element[8].code = #guardian
* group[0].element[8].target[0].code = #9
* group[0].element[8].target[0].display = "Опекун"
* group[0].element[8].target[0].relationship = #equivalent
* group[0].element[9].code = #mother
* group[0].element[9].target[0].code = #3
* group[0].element[9].target[0].display = "Отец / мать"
* group[0].element[9].target[0].relationship = #source-is-narrower-than-target
* group[0].element[10].code = #father
* group[0].element[10].target[0].code = #3
* group[0].element[10].target[0].display = "Отец / мать"
* group[0].element[10].target[0].relationship = #source-is-narrower-than-target
