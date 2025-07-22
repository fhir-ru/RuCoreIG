Profile: Core_Encounter
Parent: Encounter
Id: core-encounter
Title: "Случай оказания медицинской помощи RuCore"
Description: "Профиль Encounter для RuCore"

* subject ^short = "Пациент"
* subject only Reference(Core_Patient)

* episodeOfCare ^short = "Эпизод медицинской помощи"
* episodeOfCare only Reference(Core_EpisodeOfCare)

* serviceProvider ^short = "Поставщик медицинских услуг"
* serviceProvider only Reference(Core_Organization)

