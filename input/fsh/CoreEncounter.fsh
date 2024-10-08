Profile: Core_Encounter
Id:      core-encounter
Parent:  Encounter
Title: "Core Encounter (Случай обслуживания)"
Description: "Cлучай оказания медицинской помощи, то есть взаимодействия между пациентом и системой здравоохранения с целью оказания медицинских услуг или оценки состояния здоровья пациентах"

//На этот профиль ссылается EncounterClinicalDx, но описаний отличий его от Encounter не описано
// 
//--------------------------------------
Instance: core-encounter-instance-full
InstanceOf: Core_Encounter
Title: "Core Instance Encounter Full"
Description: "Случай обслуживания госпитализация - надо дополнять"
Usage: #example
* status = #in-progress
* class = http://terminology.hl7.org/CodeSystem/v3-ActCode#IMP

