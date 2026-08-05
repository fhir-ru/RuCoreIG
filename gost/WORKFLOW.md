# Технология подготовки общего DOCX

Основными исходниками глав считаются Markdown-файлы `gost-*.md` в каталоге
`input/pagecontent`. Они одновременно используются как страницы сайта RuCore.
Файл DOCX является публикуемым артефактом и пересобирается из тех же исходников.

Порядок включения файлов задается в `gost/order.txt`.
Название стандарта задается в `gost/title.md`.
Оглавление формируется при публикации как обновляемое поле Word.

Для публикации выполнить:

```bash
python3 gost/scripts/publish_gost_docx.py
```

Для сборки требуется `pandoc`. Проверенная версия: `3.9.0.2`.
Скрипт ищет `pandoc` в `PATH`, а затем в устойчивом пользовательском пути
`~/.local/bin/pandoc`. На системах с поддерживаемой Homebrew-конфигурацией
его можно установить командой:

```bash
brew install pandoc
```

На macOS arm64 без подходящего Homebrew-пакета можно установить официальный
ZIP-релиз в пользовательский каталог:

```bash
mkdir -p ~/.local/bin ~/.local/pandoc-3.9.0.2
curl -fL https://github.com/jgm/pandoc/releases/download/3.9.0.2/pandoc-3.9.0.2-arm64-macOS.zip -o /tmp/pandoc.zip
unzip -q /tmp/pandoc.zip -d /tmp/pandoc-unpacked
install -m 755 /tmp/pandoc-unpacked/pandoc-3.9.0.2-arm64/bin/pandoc ~/.local/pandoc-3.9.0.2/pandoc
ln -sfn ~/.local/pandoc-3.9.0.2/pandoc ~/.local/bin/pandoc
```

Скрипт собирает единый Markdown во временный файл, вызывает `pandoc`,
затем применяет правила оформления из `PUBLICATION_RULES.md`.
В итоговый DOCX добавляются название стандарта и обновляемое оглавление.
При первом открытии Word может предложить обновить поля документа; это
ожидаемо для пересчета страниц оглавления.

Файл `gost/templates/reference-styles.docx` используется при публикации как
reference DOCX для pandoc: из него берутся стили Word. Канонический итоговый
файл создается как `input/assets/gost/GOST_Interoperability.docx`. Скрипт также
создает синхронную копию `input/images/GOST_Interoperability.docx`, которую
IG Publisher копирует в корень публикуемого сайта.

Локальные справочные материалы, промежуточные версии и другие файлы, которые
не должны попадать в Git, хранятся в исключенном каталоге `gost-local`.
