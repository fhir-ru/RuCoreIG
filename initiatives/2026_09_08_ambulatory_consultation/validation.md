# Проверки и воспроизведение

## Сохранённый результат

| Проверка | Результат |
|---|---|
| Специализированная XSD из архива | XML валиден |
| Схематрон 227 v1.10 | 959 правил, 3291 assert; 615 правил встретили контекст, 961 совпадение контекстов, 0 нарушений |
| Отрицательный контроль схематрона | Удаление templateId обнаруживается; оригинал не изменён |
| scripts/verify.py | PASS: хеши, воспроизводимость, все XPath/цели, 225 внутренних ссылок, идентификаторы, отсутствие дат, конфликтующие сущности, клинические значения, единицы, диагнозы, лечение/рекомендации, все ST и 18 разделов |
| SUSHI 3.15.0, неизменённая база Core | 0 errors, 0 warnings |
| HL7 FHIR Validator 6.10.4, FHIR R5 5.0.0 и сгенерированные определения Core 0.18.0 | **12 errors, 254 warnings, 215 information**; соответствие Core не подтверждено |

Отчёты: [source-validation.json](reports/source-validation.json), [source-schematron.xml](reports/source-schematron.xml), [verification.json](reports/verification.json), [fhir-validation.json](reports/fhir-validation.json), [полный лог и версии пакетов](reports/fhir-validator.log), [sushi-output.txt](reports/sushi-output.txt).

Схематрон исполняется SaxonC-HE через ограниченный адаптер: в пакете один rule на pattern, нет фаз, abstract/let. Неподдерживаемая форма отвергается. Для непредварённых префиксом имён элементов задано пространство CDA; это необходимо для XPath данного пакета. Отчёт содержит количество контекстов каждого правила, чтобы отсутствие ошибок не маскировало отсутствие исполнения. Это проверка данного схематрона, не универсальный процессор ISO Schematron.

FHIR проверен Java 21.0.12.1, validator 6.10.4 (Git 1b90fb13f77b), с `-tx n/a`: сетевой терминологический сервер выключен. Загруженные локальные пакеты включают `hl7.fhir.r5.core#5.0.0`, `hl7.fhir.uv.extensions.r5#5.3.0`, `hl7.terminology#7.3.0`. Полнота НСИ и всех кодов UCUM не подтверждена. Среди предупреждений — недоступные определения исходных НСИ, рекомендации о наличии времени/исполнителя, неопределённые сведения о содержимом внешних документов. Они не заменены вымышленными значениями ради чистого отчёта. Три причины errors и зависимые ошибки ссылок разобраны в [gaps.md](gaps.md).

## Повторить

Из корня репозитория, в экспериментальной ветке. Python 3.10+; для Python-зависимостей и первого запуска FHIR Validator нужен доступ к пакетам.

```sh
python3 -m venv /tmp/ambulatory-venv
/tmp/ambulatory-venv/bin/pip install -r initiatives/2026_09_08_ambulatory_consultation/requirements.txt
/tmp/ambulatory-venv/bin/python initiatives/2026_09_08_ambulatory_consultation/scripts/validate_source.py
/tmp/ambulatory-venv/bin/python initiatives/2026_09_08_ambulatory_consultation/scripts/convert.py
/tmp/ambulatory-venv/bin/python initiatives/2026_09_08_ambulatory_consultation/scripts/verify.py
/tmp/ambulatory-venv/bin/python initiatives/2026_09_08_ambulatory_consultation/scripts/render_report.py
bash run_sushi.sh
cat sushi_output.txt
```

Для FHIR Validator установить Java 21 и скачать [validator_cli.jar релиза 6.10.4](https://github.com/hapifhir/org.hl7.fhir.core/releases/tag/6.10.4). Пути ниже заменить путями к локальной Java 21 и JAR:

```sh
/path/to/java21/bin/java -Xmx3g -jar /path/to/validator_cli.jar \
  initiatives/2026_09_08_ambulatory_consultation/examples/consultation-bundle.json \
  -version 5.0.0 -ig fsh-generated/resources -tx n/a -show-message-ids \
  -output initiatives/2026_09_08_ambulatory_consultation/reports/fhir-validation.json
```

Ненулевой код завершения FHIR Validator ожидаем при зафиксированных errors; считать этот шаг зелёным нельзя. Версии авторазрешаемых терминологических пакетов могут изменить диагностические сообщения при повторном сетевом запуске. Сохранённый OperationOutcome фиксирует результат данного запуска. Время Bundle.timestamp закреплено в manifest для воспроизводимости и относится к созданию представления, а не к дате документа. Конвертер не меняет исходный архив/XML.
