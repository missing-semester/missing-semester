---
layout: lecture
title: "Оболочка и скрипты"
date: 2020-01-14
ready: false
video:
  aspect: 56.25
  id: kgII-YWo3Zw
---

В этой лекции мы покажем некоторые основные варианты использования bash в качестве языка скриптов, а также инструменты оболочки,
которые решают несколько наиболее распространенных задач.

# Скрипты

До этого мы видели, как выполнять команды в оболочке и объединять их в конвейер (это серия команд, соединенных операторами конвейера).
Но есть много задач, в которых нужно выполнить серию команд и управлять серией выражений, таких как условные операторы или циклы. 
Скрипты оболочки – следующий по сложности шаг. У большинства оболочек есть свой язык сценариев с переменными и собственным синтаксисом.
Что отличает сценарии оболочки от других сценарных языков? Они оптимизированы для выполнения задач, связанных с оболочкой. Таким образом, создание конвейеров, сохранение результатов в файлы и чтение из стандартного ввода – это примитивы в сценариях оболочки, которые упрощают работу в сравнении со скриптовыми языками общего назначения. В этом разделе мы сосредоточимся на bash-скриптах, как на наиболее распространенных.
Строки в `bash` можно определять с помощью кавычек – одинарных `'` или двойных `"`, но они не равнозначны. Строки с `'` читаются буквально и не заменяют значение переменной, в то время как `"` – заменяют.
Для присвоения переменной в bash используется синтаксис `foo=bar`, для получения доступа к значению переменной - `$foo`. А `foo = bar`
интерпретируется как вызов программы `foo` с аргументами `=` и `bar`. Обратите внимание, что в скриптах пробел служит разделителем между аргументами. 

```bash
foo=bar
echo "$foo"
# prints bar
echo '$foo'
# prints $foo
```

Как и большинство языков программирования, bash поддерживает порядок вычислений, включая `if`, `case`, `while` и `for`. Точно так же в bash есть функции, которые получают аргументы и позволяют выполнять операции. Вот пример функции, которая создает папку (`mkdir`) и заходит (`cd`) в нее

```bash
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```

`$1` — обозначение аргумента в функции/скрипте. В отличие от других сценарных языков, bash использует специальные переменные для ссылки на аргументы и для кодов ошибок. Ниже перечислены несколько из обозначений. Полный список можно найти [здесь](https://www.tldp.org/LDP/abs/html/special-chars.html).
- `$0` - имя скрипта
- `$1` до `$9` - аргументы скрипта
- `$@` - все аргументы, переданные скрипту (параметры выводятся отдельными строками)
- `$#` - количество аргументов
- `$?` - код возврата предыдущей команды
- `$$` - pid текущего shell (самого процесса-сценария)
- `!!` - полное повторение предыдущей команды. Распространенное применение – когда команда не была выполнена из-за отсутствия прав, то можно повторить ее, просто вызвав `sudo !!`
- `$_` - последний аргумент предыдущей команды

Команды часто возвращают выходные данные с `STDOUT`, ошибки с `STDERR` и кодом возврата – это более удобный для скриптов способ. Код возврата – это способ, которым сценарий/команды должны сообщать о завершении процесса. Значение 0 обычно означает, что все прошло хорошо; любое значение, кроме 0, означает ошибку.
Код возврата может использоваться для условного выполнения команды с помощью `&&` (оператор И) и `||` (оператор ИЛИ), где оба являются [операторами оценки короткого замыкания](https://en.wikipedia.org/wiki/Short-circuit_evaluation). Команды также могут быть разделены в одной строке точкой с запятой `;`. `True` программа всегда будет иметь код возврата `0`, а команда `False` всегда будет иметь код возврата `1`. Посмотрим на несколько примеров.

```bash
false || echo "Oops, fail"
# Oops, fail
true || echo "Will not be printed"
#
true && echo "Things went well"
# Things went well
false && echo "Will not be printed"
#
true ; echo "This will always run"
# This will always run

false ; echo "This will always run"
# This will always run
```

Другой распространенный шаблон – подстановка результата выполнения команды в виде переменной. Делается это через `$`. Если ввести в командную строку `$(cmd)`, то консоль подставит результат `cmd` как данные переменной. Например, `for file in $(ls)` — итерация по всем сущностям текущей папки.
Похожая, но менее известная команда — _подстановка процесса_ (process substitution). Например, результат выполнения `diff <(ls foo) <(ls bar)` покажет разницу между файлами в директориях `foo` и `bar`.
Давайте разберем на конкретном примере. Допустим, с помощью команды `grep` (это построковый поиск по регулярному выражению) попытаемся найти строку `foobar` в файле.

```bash
#!/bin/bash

echo "Starting program at $(date)" # Date will be substituted

echo "Running program $0 with $# arguments with pid $$"

for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    # When pattern is not found, grep has exit status 1
    # We redirect STDOUT and STDERR to a null register since we do not care about them
    if [[ $? -ne 0 ]]; then
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
done
```

Выше мы также проверили, действительно ли `$?` не равен 0.
Bash проводит много сравнений подобного рода - вы можете найти подробный список на странице руководства [`test`](https://www.man7.org/linux/man-pages/man1/test.1.html).
Выполняя сравнение в bash, попробуйте использовать двойные квадратные скобки `[[ ]]` вместо обычных `[ ]`. Это уменьшит вероятность ошибок. Подробное объяснение можно найти [здесь](http://mywiki.wooledge.org/BashFAQ/031).
В скриптах часто встречается ситуация, когда нужно выполнить операцию над несколькими объектами файловой системы. В bash можно выполнить подстановку имен файлов - _«globbing»_ (по историческим причинам; в русском также известно как «универсализация файловых имен»).
- Шаблоны (wildcards) -  для сопостовления и последующего удаления, поиска или архивирования большого количества файлов можно пользоваться `?` (для одного символа) и `*` (все символы). Например, даны файлы `foo`, `foo1`, `foo2`, `foo10` и `bar`, комманда `rm foo?` удалит `foo1` и `foo2`, тогда как команда `rm foo*` удалит все, кроме `bar`.
- Фигурные скобки `{}` - удобно использовать в случае, когда к файлу применяется серия команд. Например, при перемещении или конвертации. 

```bash
convert image.{png,jpg}
# Will expand to
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# Will expand to
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# Globbing techniques can also be combined
mv *{.py,.sh} folder
# Will move all *.py and *.sh files

mkdir foo bar
# This creates files foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h
touch {foo,bar}/{a..h}
touch foo/x bar/y
# Show differences between files in foo and bar
diff <(ls foo) <(ls bar)
# Outputs
# < x
# ---
# > y
```

<!-- Lastly, pipes `|` are a core feature of scripting. Pipes connect one program's output to the next program's input. We will cover them more in detail in the data wrangling lecture. -->

Инструмент [shellcheck](https://github.com/koalaman/shellcheck) помогает отследить и исправить ошибки в скриптах. 
Обратите внимание, что сценарии не обязательно должны быть написаны на bash для вызова из терминала. Например, это простой скрипт Python, который печатает аргументы в обратном порядке:

```python
#!/usr/local/bin/python
import sys
for arg in reversed(sys.argv[1:]):
    print(arg)
```
Ядро понимает, что нужно выполнить этот скрипт с помощью интерпретатора Python, а не с помощью оболочки, потому что мы включили [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) в самый верх скрипта. Хорошей практикой является написание shebang с помощью команды [`env`](https://www.man7.org/linux/man-pages/man1/env.1.html). В нашем примере shebang выглядит так: `#!/usr/bin/env python`.
Разница между функциями и скриптами: 
- Функции задаются на языке оболочки, тогда как скрипты могут быть написаны на разных языках программирования. Для этого используется shebang.
- Скрипты загружаются каждый раз при выполнении, а не единожды, как функции. 
- Функции выполняются в текущей среде оболочки, а скрипты - в специальном процессе. Кроме того, функции могут изменять переменные, например текущий каталог. 
- Функции хороши для достижения модульности, повторного использования кода и его чистоты. Обычно сценарии оболочки включают собственное определение функции. 


# Инструменты оболочки

## Как использовать команды

На этом этапе вы, вероятно, задаетесь вопросом, как найти флаги команд, например, `ls -l`, `mv -i` и `mkdir -p`. И в общем, как узнавать, какая команда отвечает за конкретное действие? Всегда можно воспользоваться гуглом, но поскольку UNIX старше StackOverflow, в нем уже есть встроенные способы получения этой информации.
Как мы помним из лекции про оболочку, у нас есть `-h` или `--help`. Более детальная информация находится по команде `man` (это сокращение от мануала, manual или [`man`](https://www.man7.org/linux/man-pages/man1/man.1.html)).
Например, `man rm` выведет полную информацию о команде `rm`, включая ее флаги (ранее мы уже сталкивались с флагом `-i`). В `man` внесены абсолютно все команды, даже созданные сторонними разработчиками.

В других программах, например, написанных с использованием ncurses (это библиотека, предназначенная для управления вводом-выводом на терминал), информацию о командах можно найти в `:help` или флаге `?`.

Иногда страницы руководства могут содержать слишком подробное описание команд. Проект [TLDR](https://tldr.sh/) - сайт альтернативных справочных страниц. Авторы проекта позиционируют его как «коллекцию упрощённых и создаваемых сообществом man-страниц».
Так, авторы этого курса чаще всего пользуются страницами о [`tar`](https://tldr.ostera.io/tar) и [`ffmpeg`](https://tldr.ostera.io/ffmpeg).


## Поиск файлов

Одна из часто повторяемых задач - поиск файлов и/или директорий. Для этого во всех UNIX-подобных системах есть утилита [`find`](https://www.man7.org/linux/man-pages/man1/find.1.html). Пример:

```bash
# Find all directories named src
find . -name src -type d
# Find all python files that have a folder named test in their path
find . -path '*/test/*.py' -type f
# Find all files modified in the last day
find . -mtime -1
# Find all zip files with size in range 500k to 10M
find . -size +500k -size -10M -name '*.tar.gz'
```
Помимо простого поиска, `find` также может изменять найденные файлы:

```bash
# Delete all files with .tmp extension
find . -name '*.tmp' -exec rm {} \;
# Find all PNG files and convert them to JPG
find . -name '*.png' -exec convert {} {}.jpg \;
```

Ниже примеры синтаксиса для разных задач. 
Чтобы просто найти файлы, которые удовлетворяют заданным критериям (назовем их `PATTERN`), необходимо выполнить `find -name '*PATTERN*'` (или `-iname` если сопоставление должно быть нечувствительным к регистру). 
Можете создавать псевдонимы для таких скриптов, но важно рассмотреть и альтернативные варианты решения. 
Помните, что одна из главных особенностей оболочки - это то, что вы вызываете программы, а значит, можно найти (или даже написать самостоятельно) замену некоторым из них. Например, [`fd`](https://github.com/sharkdp/fd) - это простая, быстрая и удобная альтернатива `find`. Она предлагает цветной вывод, сопоставление регулярных выражений по умолчанию и поддержку Unicode. Плюс легче запомнить синтаксис - для примера выше: `fd PATTERN`.

Но насколько вообще эффективно использовать `find` и `fd` для поиска по всей иерархии директорий? Не лучше ли применить команду  [`locate`](https://www.man7.org/linux/man-pages/man1/locate.1.html), которая ведет поиск по собственной базе данных. `locate` использует базу данных, которая обновляется с помощью [`updatedb`](https://www.man7.org/linux/man-pages/man1/updatedb.1.html). В большинстве систем `updatedb` обновляется по [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html).

Но `find` ищет файлы не только по названию, а также по другим атрибутам (размер, время изменения, разрешения) поиска и аналогичные инструменты также могут находить файлы с помощью атрибутов, таких как размер файла, время изменения, права доступа к файлу, в то время как locate ищет только по имени файла только имя файла. Больше информации [здесь](https://unix.stackexchange.com/questions/60205/locate-vs-find-usage-pros-and-cons-of-each-other).

## Поиск кода

Поиск файла по имени полезен, но часто вам нужно будет искать файлы по их *содержимому*. 
Обычный сценарий - поиск всех файлов, содержащих определенные строки/значения. Для таких случаев в UNIX-подобных системах есть [`grep`](https://www.man7.org/linux/man-pages/man1/grep.1.html). Более подробно `grep` мы рассмотрим в лекции по управлению данными.  

У `grep` есть много флагов, что делает его по-настоящему универсальным.
`-C` используется для получения числа строк контекста, `-v` для вывода строк, которые не сопадают с тем, что ищем. `-R` используется для быстрого поиска.
У `grep` есть альтернавы, такие как [ack](https://beyondgrep.com/), [ag](https://github.com/ggreer/the_silver_searcher) и [rg](https://github.com/BurntSushi/ripgrep). Они имеют схожий функционал.

Рассмотрим другой аналог ripgrep (`rg`). Он быстрее ищет по коду, так как по умолчанию не проходит .git директории и бинарные файлы.
```bash
# Find all python files where I used the requests library
rg -t py 'import requests'
# Find all files (including hidden files) without a shebang line
rg -u --files-without-match "^#!"
# Find all matches of foo and print the following 5 lines
rg foo -A 5
# Print statistics of matches (# of matched lines and files )
rg --stats PATTERN
```

## Поиск команд

Выше мы рассматривали способы поиска файлов, директорий и кода. При долгой работе в оболочке обязательно возникнет необходимость в поиске ранее ипользованной команды. 
Во-первых, нажатие стрелки вверх вернет последнюю вызванную команду. Если продолжить нажимать ее, она медленно пройдет через историю работы.

Команда `history` позволит получить доступ к истории. Все действия будут выведены на экран. Для последующего поиска по истории воспользуйтесь `grep`. Так, `history | grep find` выведет подстроки, содержащие "find".

В большинстве оболочек вы можете использовать `Ctrl+R` для поиска по истории оболочки. После выполнения этой команды можно ввести подстроку, которую необходимо найти.

По такому же принципу стрелки вверх-вниз работают в командной оболочке [zsh](https://github.com/zsh-users/zsh-history-substring-search).
Хороший поиск предлагает утилита [fzf](https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#ctrl-r) bindings.
`fzf` предоставляет возможность нечеткого поиска с использованием множества команд. Результат поиска выводится в визуально приятном стиле.

Еще один удобный прием - автодополнение (**history-based autosuggestions**). Впервые появился в оболочке [fish](https://fishshell.com/). При вводе команды плагин читает историю и дозаполняет последнюю команду из истории, начинающуюся с тех же символов. Функция доступна и в [zsh](https://github.com/zsh-users/zsh-autosuggestions) and it is a great quality of life trick for your shell.

И последнее, о чем стоит помнить: если в начале команды стоит пробел, она не будет добавлена в историю. Это удобно при вводе пароля и другой конфиденциальной информации. 
Если вы ошиблись и не добавили начальный пробел, вы всегда можете вручную удалить запись, отредактировав `.bash_history` или `.zhistory`.

## Навигация по директории

До сих пор мы рассматривали примеры, когда вы выполняете команды в нужном месте каталога. Но что насчет быстрой навигации по директориям? 
Есть много простых способов переходить между каталогами, например, написать псевдоним оболочки или создать символические ссылки с помощью [ln -s](https://www.man7.org/linux/man-pages/man1/ln.1.html), но есть варианты легче и быстрее. Нужно научиться оптимизировать повторяющиеся задачи. 

Найти часто используемые или недавно открытые файлы и директории можно с помощью утилит [`fasd`](https://github.com/clvv/fasd) и [`autojump`](https://github.com/wting/autojump).
`fasd` ранжирует файлы и каталоги по особому весовому коэффициенту [_frecency_](https://developer.mozilla.org/en/The_Places_frecency_algorithm) (от _frequency_ и _recency_).
По умолчанию, `fasd` добавляет команду `z` для перехода между директориями (тогда как обычно для этого используется `cd`). Например, если часто посещаемая директория `/home/user/files/cool_project`, вы можете перейти в нее, выполнив `z cool`. А используя перепрыгивание (autojump), перейти в эту же директорию можно, выполнив `j cool`.

Для просмотра структуры каталогов существуют более сложные утилиты: [`tree`](https://linux.die.net/man/1/tree), [`broot`](https://github.com/Canop/broot); файловые менеджеры [`nnn`](https://github.com/jarun/nnn) или [`ranger`](https://github.com/ranger/ranger).

# Упражнения

1. Read [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) and write an `ls` command that lists files in the following manner

    - Includes all files, including hidden files
    - Sizes are listed in human readable format (e.g. 454M instead of 454279954)
    - Files are ordered by recency
    - Output is colorized

    A sample output would look like this

    ```
    -rw-r--r--   1 user group 1.1M Jan 14 09:53 baz
    drwxr-xr-x   5 user group  160 Jan 14 09:53 .
    -rw-r--r--   1 user group  514 Jan 14 06:42 bar
    -rw-r--r--   1 user group 106M Jan 13 12:12 foo
    drwx------+ 47 user group 1.5K Jan 12 18:08 ..
    ```

{% comment %}
ls -lath --color=auto
{% endcomment %}

1. Write bash functions  `marco` and `polo` that do the following.
Whenever you execute `marco` the current working directory should be saved in some manner, then when you execute `polo`, no matter what directory you are in, `polo` should `cd` you back to the directory where you executed `marco`.
For ease of debugging you can write the code in a file `marco.sh` and (re)load the definitions to your shell by executing `source marco.sh`.

{% comment %}
marco() {
    export MARCO=$(pwd)
}

polo() {
    cd "$MARCO"
}
{% endcomment %}

1. Say you have a command that fails rarely. In order to debug it you need to capture its output but it can be time consuming to get a failure run.
Write a bash script that runs the following script until it fails and captures its standard output and error streams to files and prints everything at the end.
Bonus points if you can also report how many runs it took for the script to fail.

    ```bash
    #!/usr/bin/env bash

    n=$(( RANDOM % 100 ))

    if [[ n -eq 42 ]]; then
       echo "Something went wrong"
       >&2 echo "The error was using magic numbers"
       exit 1
    fi

    echo "Everything went according to plan"
    ```

{% comment %}
#!/usr/bin/env bash

count=0
until [[ "$?" -ne 0 ]];
do
  count=$((count+1))
  ./random.sh &> out.txt
done

echo "found error after $count runs"
cat out.txt
{% endcomment %}

1. As we covered in the lecture `find`'s `-exec` can be very powerful for performing operations over the files we are searching for.
However, what if we want to do something with **all** the files, like creating a zip file?
As you have seen so far commands will take input from both arguments and STDIN.
When piping commands, we are connecting STDOUT to STDIN, but some commands like `tar` take inputs from arguments.
To bridge this disconnect there's the [`xargs`](https://www.man7.org/linux/man-pages/man1/xargs.1.html) command which will execute a command using STDIN as arguments.
For example `ls | xargs rm` will delete the files in the current directory.

    Your task is to write a command that recursively finds all HTML files in the folder and makes a zip with them. Note that your command should work even if the files have spaces (hint: check `-d` flag for `xargs`)
    {% comment %}
    find . -type f -name "*.html" | xargs -d '\n'  tar -cvzf archive.tar.gz
    {% endcomment %}

1. (Advanced) Write a command or script to recursively find the most recently modified file in a directory. More generally, can you list all files by recency?
