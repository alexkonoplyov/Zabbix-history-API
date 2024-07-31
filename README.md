# ahz
Zabbix history api
Предназачен для проверки наличия истории (history) и динамики изменений (trends) для одного или нескольких узлов.
## Настройка
В теле скрипта найти строку № 3 `apiurl=` и указать в кавычках путь к API сервера. Например, `apiurl="http://127.0.0.1/api_jsonrpc.php"` или `apiurl="http://127.0.0.1/zabbix/api_jsonrpc.php"`
## Структура скрипта
Рядом со скриптом создаётся директория temp с двумя временными папками.
## Ключи
### -login
После ключа -login нужно указать логин и пароль пользователя для подключения к API. Например, `api.sh -login admin password`
### -history
После ключа -history указываем ID узлов. Например, `api.sh -history 14967 12580`. Скрипт выдаст шесть чисел: пять покажут число записей в истории zabbix, последнее — число записей в динамике изменений. Нули означают, что узел или узлы не имеют записей в базе данных без учёта веб-проверок.
### -trends
Как и предыдущий ключ принимает в качестве аргументов ID узлов, но возвращает только число записей в динамике изменений. Пример использования: `api.sh -trends 14967 12580`
### -test
Просмотр текущего API-ключа и пути к API сервера.
### -logout
Отключение сессии с удалением API-ключа.
