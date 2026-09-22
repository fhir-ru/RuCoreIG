# Заключительная независимая проверка

Повторно разобраны исходные baseline/qa.xml и after/qa.xml: 54/158/89 → 49/166/98 (error/warning/information). В обоих файлах нет SLICING_CANNOT_BE_EVALUATED и сообщений на Coverage.identifier. Прежняя ошибка контекста расширения okato отличается только версией 0.20.0 → 0.21.0; обновлённое сравнение нормализует эту разницу. Новых ошибок по существу не выявлено.

Классификация новых сообщений подтверждена программно: четыре UNKNOWN_CODESYSTEM, один UNKNOWN_CODE_IN_FRAGMENT, три предупреждения нераскрываемого ValueSet, девять VALUESET_INCLUDE_CS_CONTENT. Все соответствуют изменению content внешних справочников. Это не подтверждение корректности кодов примеров, для которых недоступны полные данные НСИ.

## Положительный и отрицательный контроль complete

FHIR Validator 6.10.4, Temurin Java 21.0.12.1+1, R5 5.0.0, `-ig fsh-generated/resources -tx n/a -show-message-ids`. Проверены два Parameters.valueCoding с одной и той же собственной системой RuCore `core-cs-semd-identifier-type`, сохраняющей content=complete:

- `oms-policy`: 0 errors, 0 warnings, 1 информационное сообщение о проверяемом базовом профиле.
- `RUC_TERMINOLOGY_NEGATIVE_SENTINEL`: 1 error Unknown code, 0 warnings, 1 информационное сообщение о профиле.

Следовательно, проверка кодов не отключена глобально: неизвестный код в собственной полной системе по-прежнему отвергается локальным валидатором. Контроль не доказывает полноту проверки внешних fragment/not-present или альтернативных OID.

Входы и полные результаты: `local-fragments/Parameters-valid.json`, `Parameters-invalid.json`, `complete-control-validation.json`, `complete-control-validation.log`. Исходники руководства и коммиты этой проверкой не изменены.
