Profile: Core_Encounter
Parent: Encounter
Id: core-encounter
Title: "Core Encounter (Случай оказания медицинской помощи)"
Description: "Профиль Encounter для RuCore"

* subject ^short = "Пациент"
* subject only Reference(Core_Patient)

* episodeOfCare ^short = "Эпизод медицинской помощи"
* episodeOfCare only Reference(Core_EpisodeOfCare)

* serviceProvider ^short = "Поставщик медицинских услуг"
* serviceProvider only Reference(Core_Organization)

