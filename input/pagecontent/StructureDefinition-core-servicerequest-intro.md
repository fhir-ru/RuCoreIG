# Core_ServiceRequest — Профиль запроса на услугу

## Принятые решения по профилированию

| Бизнес-требование | Атрибут | Решение по профилированию |
|-------------------|---------|---------------------------|
| Описание пациента должно соответствовать требованиям РФ, если `subject` указывает на `Patient` | subject | Для `Patient` должен использоваться профиль Core_Patient, при этом сохраняются остальные допустимые типы из базового R5 |
| Описание направляющего лица должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | requester | Для `Patient`, `Practitioner`, `PractitionerRole`, `Organization`, `RelatedPerson` используются профили RuCore, остальные допустимые типы R5 сохранены |
| Описание исполнителя должно соответствовать требованиям РФ, если ссылка указывает на профилируемый ресурс RuCore | performer | Для `CareTeam`, `Patient`, `Practitioner`, `PractitionerRole`, `Organization`, `RelatedPerson` используются профили RuCore, остальные допустимые типы R5 сохранены |
| Описание случая обслуживания должен соответствовать требованиям РФ | encounter | Должен быть представлен профилем Core_Encounter |
| Описание страхового покрытия должен соответствовать требованиям РФ | coverage | Должен быть представлен профилем Core_Coverage |

## Описание профиля

Профиль Core_ServiceRequest расширяет стандартный ресурс ServiceRequest для поддержки российских требований:
- Если `subject` ссылается на `Patient`, должен использоваться профиль Core_Patient, при этом сохраняются остальные допустимые типы `ServiceRequest.subject` из R5
- Если `requester` ссылается на профилируемый ресурс RuCore, должен использоваться соответствующий профиль RuCore
- Если `performer` ссылается на профилируемый ресурс RuCore, должен использоваться соответствующий профиль RuCore
- Случай обслуживания должен быть представлен профилем Core_Encounter
- Если `insurance` ссылается на `Coverage`, должен использоваться профиль Core_Coverage

---

### FSH-код профиля

```fsh
Profile: Core_ServiceRequest
Parent: ServiceRequest
Id: core-servicerequest
Title: "Core ServiceRequest (Запрос на услугу)"
Description: "Базовый профиль запроса на услугу для российских FHIR-реализаций"

* subject only Reference(Core_Patient or Group or Location or Device)
* requester only Reference(Device or Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)
* performer only Reference(Core_CareTeam or Device or HealthcareService or Core_Organization or Core_Patient or Core_Practitioner or Core_PractitionerRole or Core_RelatedPerson)
* encounter only Reference(Core_Encounter)
* insurance only Reference(ClaimResponse or Core_Coverage)
``` 
