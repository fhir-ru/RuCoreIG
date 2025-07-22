Profile: Core_EpisodeOfCare
Parent: EpisodeOfCare
Id: core-episodeofcare
Title: "Эпизод медицинской помощи"
Description: "Профиль EpisodeOfCare для RuCore"

* patient ^short = "Пациент"
* patient only Reference(Core_Patient)

* managingOrganization ^short = "Ответственная организация"
* managingOrganization only Reference(Core_Organization) 