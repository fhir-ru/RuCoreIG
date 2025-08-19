# Документация примеров

## Таблица примеров для профилей и расширений

| Профиль/Расширение | Пример full | Пример min |
|-------------------|-------------|------------|
| **Профили** |
| Core_Patient | `example-core-patient-ivanov` | `example-core-patient-ivanov-min` |
| Core_Organization | `example-core-organization-polyclinic` | `example-core-organization-polyclinic-min` |
| Core_Practitioner | `example-core-practitioner-smirnov` | `example-core-practitioner-smirnov-min` |
| Core_PractitionerRole | `example-core-practitionerrole-smirnov-therapist` | `example-core-practitionerrole-smirnov-therapist-min` |
| Core_Address | `example-core-address-moscow-home` | `example-core-address-moscow-home-min` |
| Core_Encounter | `example-core-encounter-consultation` | `example-core-encounter-consultation-min` |
| Core_EpisodeOfCare | `example-core-episodeofcare-ivanov-2024` | `example-core-episodeofcare-ivanov-2024-min` |
| Core_CareTeam | `example-core-careteam-ivanov` | `example-core-careteam-ivanov-min` |
| Core_Composition | `example-core-composition-ivanov-consultation` | `example-core-composition-ivanov-consultation-min` |
| Core_Coverage | `example-core-coverage-ivanov-oms` | `example-core-coverage-ivanov-oms-min` |
| Core_RelatedPerson | `example-core-relatedperson-ivanov-spouse` | `example-core-relatedperson-ivanov-spouse-min` |
| Core_ServiceRequest | `example-core-servicerequest-ivanov-consultation` | `example-core-servicerequest-ivanov-consultation-min` |
| Core_DiagnosticReport | `example-core-diagnosticreport-ivanov-blood` | `example-core-diagnosticreport-ivanov-blood-min` |
| Core_Procedure | `example-core-procedure-ivanov-consultation` | `example-core-procedure-ivanov-consultation-min` |
| Core_Location | `example-core-location-therapy-office` | `example-core-location-therapy-office-min` |
| Core_HealthcareService | `example-core-healthcareservice-therapy` | `example-core-healthcareservice-therapy-min` |
| Core_Appointment | `example-core-appointment-ivanov-consultation` | `example-core-appointment-ivanov-consultation-min` |
| **Расширения** |
| Extension.fias | `example-extension-fias-moscow` | `example-extension-fias-moscow-min` |
| Extension.regionRF | `example-extension-regionrf-moscow` | `example-extension-regionrf-moscow-min` |
| Extension.address-type | `example-extension-addresstype-home` | `example-extension-addresstype-home-min` |
| Extension.okato | `example-extension-okato-moscow` | `example-extension-okato-moscow-min` |
| Extension.houseguid | `example-extension-houseguid-moscow` | `example-extension-houseguid-moscow-min` |

## Дополнительные примеры для ссылок

| Ресурс | Пример full |
|--------|-------------|
| **Дополнительные ресурсы** |
| PractitionerRole (медсестра) | `example-core-practitionerrole-nurse` |
| Observation (температура) | `example-core-observation-ivanov-temperature` |
| Condition (лихорадка) | `example-core-condition-ivanov-fever` |
| MedicationRequest (парацетамол) | `example-core-medicationrequest-ivanov-paracetamol` |

## Статистика

- **Всего профилей:** 17
- **Всего расширений:** 5
- **Всего примеров:** 49 (27 full + 22 min)
- **Дополнительных примеров для ссылок:** 5

## Примечания

- Все примеры имеют соответствующие пары full/min
- Имена примеров следуют единому формату: `example-core-{resource}-{description}`
- Минимальные примеры имеют суффикс `-min`
- Расширения имеют префикс `example-extension-` вместо `example-core-`
- Дополнительные примеры для ссылок помечены как "пример для ссылки" и содержат минимальное заполнение 