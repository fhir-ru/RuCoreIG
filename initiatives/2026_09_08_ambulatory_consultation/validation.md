# Проверки и воспроизведение

APP-03 закрыт для прототипа в RuCore 0.24.0: проверяются URI-форма OID и конечный узел; исходный исторический OID сохранён, PractitionerRole заявляет профиль Core. FHIR Validator: 0 errors / 256 warnings / 152 information (`-tx n/a`). Принадлежность OID организации не подтверждается этой проверкой. [Результат](reports/rucore-0.24.0/summary.json).

Предыдущая проверка после APP-01/02 на RuCore 0.23.0: **0 errors, 257 warnings, 151 information** (FHIR Validator 6.10.4, `-tx n/a`). [Сводка и ограничения](reports/rucore-0.23.0/summary.json), [OperationOutcome](reports/rucore-0.23.0/fhir-validation.json). Семантические проверки пройдены: 1347 исходных значений, 1049 разрешимых целей, 225 внутренних ссылок; логическая ссылка на карту проверена отдельно без требования экземпляра. Ниже сохранён исторический результат первоначального прототипа.

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

Проверены 56 положительных и отрицательных вариантов семи регулярных выражений из сгенерированных профилей (`scripts/verify_suffixes.py`, запуск из корня репозитория). Отдельный запуск FHIR Validator на `/tmp/semd-alternate.json` и `/tmp/semd-wrong-suffix.json` подтвердил: иной корень/ветка 199 принимаются; неверный суффикс вызывает `core-practitionerrole-mis-system`. [Отчёт](reports/rucore-0.24.0/suffix-validator.json). По сравнению с 0.23.0 убрано одно предупреждение базовой привязки Identifier.type и добавлено информационное сообщение о проверке Core_PractitionerRole; новых диагностических проблем нет.

Публикация 0.24.0 отправлена коммитом `8b61e50`. Исходный QA 0.23.0: 49 errors / 167 warnings / 98 hints; сохранён в `reports/rucore-0.24.0/publisher-before.json`. Эти ошибки Publisher не относятся к успешной локальной проверке примера.

## 22.09.2026 — подразделения (APP-04)

APP-04 закрыт для прототипа: МО и подразделение разделены. Encounter.serviceProvider и PractitionerRole.organization ссылаются на подразделение исполнителя при его наличии, иначе на МО. У подразделения identifier.system = `https://fhir.ru/ig/core/systems/frmo-department`, value — исходный extension; partOf ссылается на МО с исходным root в идентификаторе frmo. Название, контакты и реквизиты МО остаются у МО; несуществующие сведения о подразделении не добавляются. Остальные организационные роли (хранитель, получатель, страховщик) автоматически не переключаются на подразделение. Контекстные экземпляры с противоречащими исходными идентификаторами не объединяются (SRC-01 остаётся открытым).

Обе цепочки проверены, включая вариант без extension у providerOrganization. Результат: 99 ресурсов, 230 внутренних ссылок, 1347 исходных значений, 1044 цели трассировки. Пять прежних целей system для root/extension заменены структурной связью partOf: root уже учтён в идентификаторе МО. FHIR Validator: 0 errors / 256 warnings / 157 information, `-tx n/a`. [Отчёт](reports/rucore-0.25.0/summary.json). Полнота проверки реестров и терминологий не заявляется.

В проект протокола 29.09.2026 внесено утверждение среза и NamingSystem подразделений; одобрение группы пока не получено. ГОСТ не менялся.
