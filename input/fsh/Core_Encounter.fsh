Profile: Core_Encounter
Parent: Encounter
Id: core-encounter
Title: "Core Encounter (Случай оказания медицинской помощи)"
Description: "Профиль Encounter для RuCore"

* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Идентификаторы случаев оказания медицинской помощи в экземпляре МИС по правилам СЭМД; срезы распознаются по совокупности установленных для них ограничений"
* identifier contains
  misEncounter 0..* and
  misInpatientRecord 0..* and
  misAmbulatoryEncounter 0..*

* identifier[misEncounter] ^short = "Идентификатор случая оказания медицинской помощи в экземпляре МИС"
* identifier[misEncounter] ^definition = "Локальный идентификатор общего случая оказания медицинской помощи в экземпляре медицинской информационной системы по правилам СЭМД."
* identifier[misEncounter] ^comment = "Identifier.system указывается в URI-форме OID: urn:oid:{OID медицинской организации}.{ветка МИС}.{номер МИС}.{номер экземпляра МИС}.15[.{дочерний узел}...]. Для ветки МИС обычно используется узел 100; если он уже занят, допускается другой узел."
  * system 1..1
  * value 1..1
  * obeys core-encounter-mis-encounter-system

* identifier[misInpatientRecord] ^short = "Номер стационарной медицинской карты в экземпляре МИС"
* identifier[misInpatientRecord] ^definition = "Локальный номер стационарной медицинской карты (истории болезни), связанной со случаем обслуживания, в экземпляре медицинской информационной системы по правилам СЭМД."
* identifier[misInpatientRecord] ^comment = "Identifier.system указывается в URI-форме OID: urn:oid:{OID медицинской организации}.{ветка МИС}.{номер МИС}.{номер экземпляра МИС}.16[.{дочерний узел}...]. Для ветки МИС обычно используется узел 100; если он уже занят, допускается другой узел."
  * system 1..1
  * value 1..1
  * obeys core-encounter-mis-inpatient-system

* identifier[misAmbulatoryEncounter] ^short = "Идентификатор амбулаторного случая или посещения в экземпляре МИС"
* identifier[misAmbulatoryEncounter] ^definition = "Локальный идентификатор посещения или случая оказания медицинской помощи в амбулаторных условиях, в том числе передаваемый как номер амбулаторной медицинской карты, в экземпляре медицинской информационной системы по правилам СЭМД."
* identifier[misAmbulatoryEncounter] ^comment = "Identifier.system указывается в URI-форме OID: urn:oid:{OID медицинской организации}.{ветка МИС}.{номер МИС}.{номер экземпляра МИС}.17[.{дочерний узел}...]. Для ветки МИС обычно используется узел 100; если он уже занят, допускается другой узел."
  * system 1..1
  * value 1..1
  * obeys core-encounter-mis-ambulatory-system

* subject ^short = "Пациент"
* subject only Reference(Core_Patient or Group)

* episodeOfCare ^short = "Эпизод медицинской помощи"
* episodeOfCare only Reference(Core_EpisodeOfCare)

* serviceProvider ^short = "Поставщик медицинских услуг"
* serviceProvider only Reference(Core_Organization)

Invariant: core-encounter-mis-encounter-system
Description: "Система идентификатора общего случая в МИС должна быть URI-формой OID по правилам СЭМД с типовым узлом 15"
Severity: #error
Expression: "system.matches('^urn:oid:[0-2]([.](0|[1-9][0-9]*)){2,}[.][1-9][0-9]*[.][1-9][0-9]*[.][1-9][0-9]*[.]15([.](0|[1-9][0-9]*))*$')"

Invariant: core-encounter-mis-inpatient-system
Description: "Система номера стационарной медицинской карты в МИС должна быть URI-формой OID по правилам СЭМД с типовым узлом 16"
Severity: #error
Expression: "system.matches('^urn:oid:[0-2]([.](0|[1-9][0-9]*)){2,}[.][1-9][0-9]*[.][1-9][0-9]*[.][1-9][0-9]*[.]16([.](0|[1-9][0-9]*))*$')"

Invariant: core-encounter-mis-ambulatory-system
Description: "Система идентификатора амбулаторного случая или посещения в МИС должна быть URI-формой OID по правилам СЭМД с типовым узлом 17"
Severity: #error
Expression: "system.matches('^urn:oid:[0-2]([.](0|[1-9][0-9]*)){2,}[.][1-9][0-9]*[.][1-9][0-9]*[.][1-9][0-9]*[.]17([.](0|[1-9][0-9]*))*$')"
