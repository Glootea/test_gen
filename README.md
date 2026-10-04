Возможности:
- составление варианта из нескольких блоков
- вариант содержит заданное количество вопросов из каждого блока
- блок содержит свой банк заданий 
- вопрос может содержать несколько картинок
- к вопросу могут быть добавлены скрываемые ответ и ссылка на оригинал задания

# Установка
- Установите Typst
    - Скачайте [Typst](https://typst.app/open-source/#download)
    - Убедитесь, что он находится в PATH (справка для [Windows](https://remontka.pro/add-to-path-variable-windows/)) и доступен из командной строки (команда `typst` выдает приветственное сообщение)
- Установка инструмента
    - Скачайте [инструмент](https://github.com/Glootea/test_gen/archive/refs/heads/main.zip)
    - Расположите его в согласно [инструкции](https://github.com/typst/packages/blob/main/README.md#local-packages). Например, для Windows путь должен быть: C:/Users/[Пользователь]/AppData/typst/packages/local/. Внутри данной папки должны находится скачанные `test_gen_package` и `test_gen_template`
- Создание вариантов, используя редактор Visual Studio Code
    - Установите расширение Tinymist Typst ([ссылка](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist))
    - Откройте папку, где хотите хранить тесты, и вызовите в консоли: `typst init @local/test_gen_template`
    - Для предпросмотра теста используйте команду VS Code `Typst Preview: Preview Opened File` (ctrl + shift + p)
    - Для создания pdf: `typst compile gen.typ output.pdf`, где `output.pdf` название выходного файла.


## Создание тестов
Используется json файл (по умолчанию `test.json`), который опирается на схему данных. Схема помогает исследовать возможные варианты создания тестов и не допускает ошибок при составлении. Схема описана в [здесь](/scheme_description.md) и находится в [здесь](/local/test_gen_template/1.0.0/copy/schema.json). 

Для создания последующих тестов создайте файл аналогичный `test.json` (важно: укажите  `"$schema": "schema.json"` в корневом объекте для подсказок редактора) и замените путь в файле `gen.typ` на созданный файл (например:  `read("test.json", encoding: none)` -> `read("myTest.json", encoding: none)`)