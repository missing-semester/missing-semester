---
layout: lecture
title: "Survol du cours + le shell"
date: 2020-01-13
ready: true
video:
  aspect: 56.25
  id: Z56Jmr9Z34Q
---

# Motivation

En tant qu'informaticiens, on sait que les ordinateur sont utiles à nous
aider avec les tâches répétitives. Pourtant, on oublie parfois que cela 
s'applique aussi à notre _utilisation_ de l'ordinateur ainsi qu'aux calculs 
qu'on veut que nos programmes exécutent. Nous avons un arsenal
d'outils à portée de main qui nous permettent d'être plus productif et de
résoudre des problêmes plus complexes quand on travaille sur une tâche
reliée aux ordinateurs. Mais encore, plusieurs d'entre nous utilisent
seulement une fraction des ces outils; nous savons seulement quelques 
incantations magiques par coeur pour se débrouiller et nous copions 
aveuglément des commandes tirées d'internet quand on est pris.

L'objectif de cette classe est de rectifier ceci.

Nous voulons vous apprendre comment ressortir le plus des outils que vous
connaissez, vous montrer de nouveau outils à ajouter à votre boîte et vous 
inspirer à explorer (et peut-être construire) plus d'outils par vous 
même. C'est ce que nous pensons être le trimestre manquand de votre curriculum
informatique.

# Structure du cours

Le cours consiste de 11 présentations de 1 heure, chacune se concentrant
sur un [sujet en particulier](/2020/). Les leçons sont principalement 
indépendantes, mais plus tard dans le trimestre nous assumerons que vous
êtes familiers avec le contenu des leçons précédentes. Nous avons des notes
de cours en ligne, mais il y aura beaucoup de contenu vu en classe (comme 
des présentations) qui ne sera pas nécessairement dans les notes. Nous allons
enregistrer les leçons et nous les afficherons en ligne.

Nous essayons de couvrir beaucoup de matériel, donc les leçons seront 
particulièrement denses. Pour vous laisser vous familiariser avec le 
contenu à votre propre vitesse, chaque leçon aura un ensemble d'exercices
pour vous guider à travers les points clés des leçons. Après chaque leçon,
nous organisons des heures de bureau où nous serons présent pour aider à
répondre aux questions que vous pourriez avoir. Si vous assistez au cours
en ligne, vous pouvez envoyez des questions à
[missing-semester@mit.edu](mailto:missing-semester@mit.edu).

À cause des limitations temporelles du cours, nous ne pourrons pas couvrir 
tous les outils de façon aussi détaillé qu'un cours complet le pourrait. 
Nous essayerons de vous montrer des ressources pour en apprendre plus sur
un outil ou un sujet, mais si quelque chose de particulier vous intéresse, 
n'hésitez pas à nous demander de vous indiquer où chercher!

# Topic 1: La Shell

## Qu'est-ce que le shell?

Les ordinateurs de nos jours ont plusieurs interfaces pour recevoir des 
commandes; les outils d'interfaces graphiques, les interfaces vocaux et
même la RA/RV sont omniprésents. Ces interfaces sont utiles pour 80% des 
cas, mais ils sont fondamentalement restreints dans leurs fonctionalités 
\- on ne peut pas appuyer sur un bouton qui n'est pas là ou donner une 
commande vocale qui n'a pas été programmée. Pour prendre avantage des 
outils que votre ordinateur détient, il faut qu'on aille old-school et 
qu'on revienne à un interface textuel: La Shell (Coquille).

Presque toutes les plateformes que vous pouvez mettre la main dessus aura 
un shell d'une forme ou d'une autre et plusieurs d'entre elles ont plusieurs 
shell que vous pouvez choisir. Même si elles ont quelques détails différents, 
elles sont tous similaires à leur coeur(?): elles vous laisse rouler des 
programmes, leur saisir des données et inspecter leur résultats de façon 
semi-structurée.

Dans cette leçon, nous allons nous concentrer sur la Bourne Again SHell, ou 
simplement "bash". C'est le shell le plus utilisée et sa syntaxe est similaire 
à celle que vous voyeriez dans plusieurs autres shells. Pour ouvrir un 
_invite_ du shell (où vous pouvez écrire des commandes), vous devez tout 
d'abord avoir un _terminal_. Votre appareil est probablement expédié avec 
un terminal installé. Sinon, vous pouvez en installer un assez facilement.

## Utiliser le shell

Quand vous démarrerez votre terminal, vous verrez une _invite_ qui ressemble à:

```console
missing:~$ 
```

Ceci est l'interface textuel du shell. Elle indique que vous êtes sur
l'appareil `missing` et que votre "current working directory", où vous êtes
présentement, est `~` (raccourci pour "home"). Le `$` indique que vous n'êtes 
pas l'utilisateur racine (plus d'information ultérieurement). À cette invite
vous pouvez entrer une _commande_, qui sera interpretée par le shell. La 
commande la plus simple est l'exécution d'un programme:

```console
missing:~$ date
Fri 10 Jan 2020 11:49:31 AM EST
missing:~$ 
```

Ici, nous avons exécuté le programme `date`, qui (sans surprise) imprime 
la date et le temps. Le shell ensuite nous demande une autre commande a 
exécuter. On peut aussi exécuter une commande avec des _arguments_: 

```console
missing:~$ echo hello
hello
```

Dans ce cas, nous avons demandé au shell d'exécuter le programme `echo` 
avec l'argument `hello`. Le programme `echo` imprime simplement ses arguments. 
Le shell analyse la commande en la séparant par les espaces, pour ensuite 
rouler le programme indiqué par le premier mot, soumettant chaque autre mot 
comme un argument que le programme peut accéder. Si vous voulez donner un 
argument qui contient des espaces ou d'autres charactères spéciaux (comme 
une fillière nommée "Mes Photos"), vous pouvez soit mettre des guillemets 
( `'` ou '"': `"Mes Photos"`), ou échapper seulement les charactères 
concernés avec une `\` (`"Mes\ Photos"`).

Mais comment le shell reconnait où trouver le programme `echo` ou le programme 
`date`? Puisque le shell est un environnement de programmation, comme Python 
ou Ruby, elle est capable d'utiliser des variables, des conditions, des boucles 
et des fonctions (prochaine leçon!). Quand vous roulez des commandes dans votre 
shell, vous êtes en fait en train d'écrire un peu de code que votre shell 
interprète. Si vous demandez au shell d'exécuter une commande qui ne 
correspond pas à un de ses mots clés de programmation, elle consulte une 
_variable d'environnement_ nommée `$PATH` qui liste quelles fillières que 
le shell devrait chercher pour des programmes quand on lui donne une commande.


```console
missing:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
missing:~$ which echo
/bin/echo
missing:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Quand on run la commande `echo`, le shell voit qu'elle devrait exécuter
le programme `echo` et cherche à travers la liste de fillières séparée
par un `:` dans `$PATH` pour un fichier qui a ce nom. Quand elle le trouve, 
elle le roule (si le fichier est _exécutable_; on en reparlera plus tard). 
Nous pouvons trouver quel fichier est exécuté pour un programme en utilisant 
le programme `which`. On peut aussi contourner la variable `$PATH` entièrement 
en donnant le _chemin_ vers le fichier qu'on veut exécuter.

## Naviguer le shell

Un chemin sur le shell est une liste de fillières séparé par une `/` sur 
Linux et macOS et `\` sur Windows. Sur Linux et macOS, le chemin `/` est 
la "racine" du système de fichiers, sous laquelle tous les autres fillières 
et fichiers reposent, tandis que sur Windows il y a une racine pour chaque 
partition de disque (ex: `C:\`). Nous allons assumer généralement 
que vous utilisez un système de fichiers Linux dans ce cours. Un chemin qui 
commence avec `/` est un chemin _absolu_. Tout autre chemin est un chemin 
_relatif_. Les chemins relatif sont relatif à la fillière qui est présentement 
sélectionnée, qu'on peut voir avec la commande `pwd` et qu'on peut changer 
avec la commande `cd`. Dans un chemin,  `.` fait référence à la fillière 
sélectionnée et `..` à la fillière parente:

```console
missing:~$ pwd
/home/missing
missing:~$ cd /home
missing:/home$ pwd
/home
missing:/home$ cd ..
missing:/$ pwd
/
missing:/$ cd ./home
missing:/home$ pwd
/home
missing:/home$ cd missing
missing:~$ pwd
/home/missing
missing:~$ ../../bin/echo hello
hello
```

Remarquez que notre invite du shell nous garde informés sur le nom de
notre fillière sélectionnée. Vous pouvez configurer votre invite pour 
afficher toute sorte d'information utile, que nous couvrirons dans une 
autre leçon.

Généralement, quand on roule un programme, il va opérer dans la 
fillière sélectionnée à moin qu'on lui dise autrement. Par exemple, 
il cherchera ici et créera des nouveau fichiers si cela s'avère 
nécessaire.

In general, when we run a program, it will operate in the current
directory unless we tell it otherwise. For example, it will usually
search for files there, and create new files there if it needs to.

To see what lives in a given directory, we use the `ls` command:

```console
missing:~$ ls
missing:~$ cd ..
missing:/home$ ls
missing
missing:/home$ cd ..
missing:/$ ls
bin
boot
dev
etc
home
...
```

Unless a directory is given as its first argument, `ls` will print the
contents of the current directory. Most commands accept flags and
options (flags with values) that start with `-` to modify their
behavior. Usually, running a program with the `-h` or `--help` flag
will print some help text that tells you what flags
and options are available. For example, `ls --help` tells us:

```
  -l                         use a long listing format
```

```console
missing:~$ ls -l /home
drwxr-xr-x 1 missing  users  4096 Jun 15  2019 missing
```

This gives us a bunch more information about each file or directory
present. First, the `d` at the beginning of the line tells us that
`missing` is a directory. Then follow three groups of three characters
(`rwx`). These indicate what permissions the owner of the file
(`missing`), the owning group (`users`), and everyone else respectively
have on the relevant item. A `-` indicates that the given principal does
not have the given permission. Above, only the owner is allowed to
modify (`w`) the `missing` directory (i.e., add/remove files in it). To
enter a directory, a user must have "search" (represented by "execute":
`x`) permissions on that directory (and its parents). To list its
contents, a user must have read (`r`) permissions on that directory. For
files, the permissions are as you would expect. Notice that nearly all
the files in `/bin` have the `x` permission set for the last group,
"everyone else", so that anyone can execute those programs.

Some other handy programs to know about at this point are `mv` (to
rename/move a file), `cp` (to copy a file), and `mkdir` (to make a new
directory).

If you ever want _more_ information about a program's arguments, inputs,
outputs, or how it works in general, give the `man` program a try. It
takes as an argument the name of a program, and shows you its _manual
page_. Press `q` to exit.

```console
missing:~$ man ls
```

## Connecting programs

In the shell, programs have two primary "streams" associated with them:
their input stream and their output stream. When the program tries to
read input, it reads from the input stream, and when it prints
something, it prints to its output stream. Normally, a program's input
and output are both your terminal. That is, your keyboard as input and
your screen as output. However, we can also rewire those streams!

The simplest form of redirection is `< file` and `> file`. These let you
rewire the input and output streams of a program to a file respectively:

```console
missing:~$ echo hello > hello.txt
missing:~$ cat hello.txt
hello
missing:~$ cat < hello.txt
hello
missing:~$ cat < hello.txt > hello2.txt
missing:~$ cat hello2.txt
hello
```

Demonstrated in the example above, `cat` is a program that con`cat`enates
files. When given file names as arguments, it prints the contents of each of
the files in sequence to its output stream. But when `cat` is not given any
arguments, it prints contents from its input stream to its output stream (like
in the third example above).

You can also use `>>` to append to a file. Where this kind of
input/output redirection really shines is in the use of _pipes_. The `|`
operator lets you "chain" programs such that the output of one is the
input of another:

```console
missing:~$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2019 var
missing:~$ curl --head --silent google.com | grep --ignore-case content-length | cut --delimiter=' ' -f2
219
```

We will go into a lot more detail about how to take advantage of pipes
in the lecture on data wrangling.

## A versatile and powerful tool

On most Unix-like systems, one user is special: the "root" user. You may
have seen it in the file listings above. The root user is above (almost)
all access restrictions, and can create, read, update, and delete any
file in the system. You will not usually log into your system as the
root user though, since it's too easy to accidentally break something.
Instead, you will be using the `sudo` command. As its name implies, it
lets you "do" something "as su" (short for "super user", or "root").
When you get permission denied errors, it is usually because you need to
do something as root. Though make sure you first double-check that you
really wanted to do it that way!

One thing you need to be root in order to do is writing to the `sysfs` file
system mounted under `/sys`. `sysfs` exposes a number of kernel parameters as
files, so that you can easily reconfigure the kernel on the fly without
specialized tools. **Note that sysfs does not exist on Windows or macOS.**

For example, the brightness of your laptop's screen is exposed through a file
called `brightness` under

```
/sys/class/backlight
```

By writing a value into that file, we can change the screen brightness.
Your first instinct might be to do something like:

```console
$ sudo find -L /sys/class/backlight -maxdepth 2 -name '*brightness*'
/sys/class/backlight/thinkpad_screen/brightness
$ cd /sys/class/backlight/thinkpad_screen
$ sudo echo 3 > brightness
An error occurred while redirecting file 'brightness'
open: Permission denied
```

This error may come as a surprise. After all, we ran the command with
`sudo`! This is an important thing to know about the shell. Operations
like `|`, `>`, and `<` are done _by the shell_, not by the individual
program. `echo` and friends do not "know" about `|`. They just read from
their input and write to their output, whatever it may be. In the case
above, the _shell_ (which is authenticated just as your user) tries to
open the brightness file for writing, before setting that as `sudo
echo`'s output, but is prevented from doing so since the shell does not
run as root. Using this knowledge, we can work around this:

```console
$ echo 3 | sudo tee brightness
```

Since the `tee` program is the one to open the `/sys` file for writing,
and _it_ is running as `root`, the permissions all work out. You can
control all sorts of fun and useful things through `/sys`, such as the
state of various system LEDs (your path might be different):

```console
$ echo 1 | sudo tee /sys/class/leds/input6::scrolllock/brightness
```

# Next steps

At this point you know your way around a shell enough to accomplish
basic tasks. You should be able to navigate around to find files of
interest and use the basic functionality of most programs. In the next
lecture, we will talk about how to perform and automate more complex
tasks using the shell and the many handy command-line programs out
there.

# Exercises

All classes in this course are accompanied by a series of exercises. Some give
you a specific task to do, while others are open-ended, like "try using X and Y
programs". We highly encourage you to try them out.

We have not written solutions for the exercises. If you are stuck on anything
in particular, feel free to send us an email describing what you've tried so
far, and we will try to help you out.

 1. For this course, you need to be using a Unix shell like Bash or ZSH. If you
    are on Linux or macOS, you don't have to do anything special. If you are on
    Windows, you need to make sure you are not running cmd.exe or PowerShell;
    you can use [Windows Subsystem for
    Linux](https://docs.microsoft.com/en-us/windows/wsl/) or a Linux virtual
    machine to use Unix-style command-line tools. To make sure you're running
    an appropriate shell, you can try the command `echo $SHELL`. If it says
    something like `/bin/bash` or `/usr/bin/zsh`, that means you're running the
    right program.
 1. Create a new directory called `missing` under `/tmp`.
 1. Look up the `touch` program. The `man` program is your friend.
 1. Use `touch` to create a new file called `semester` in `missing`.
 1. Write the following into that file, one line at a time:
    ```
    #!/bin/sh
    curl --head --silent https://missing.csail.mit.edu
    ```
    The first line might be tricky to get working. It's helpful to know that
    `#` starts a comment in Bash, and `!` has a special meaning even within
    double-quoted (`"`) strings. Bash treats single-quoted strings (`'`)
    differently: they will do the trick in this case. See the Bash
    [quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html)
    manual page for more information.
 1. Try to execute the file, i.e. type the path to the script (`./semester`)
    into your shell and press enter. Understand why it doesn't work by
    consulting the output of `ls` (hint: look at the permission bits of the
    file).
 1. Run the command by explicitly starting the `sh` interpreter, and giving it
    the file `semester` as the first argument, i.e. `sh semester`. Why does
    this work, while `./semester` didn't?
 1. Look up the `chmod` program (e.g. use `man chmod`).
 1. Use `chmod` to make it possible to run the command `./semester` rather than
    having to type `sh semester`. How does your shell know that the file is
    supposed to be interpreted using `sh`? See this page on the
    [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) line for more
    information.
 1. Use `|` and `>` to write the "last modified" date output by
    `semester` into a file called `last-modified.txt` in your home
    directory.
 1. Write a command that reads out your laptop battery's power level or your
    desktop machine's CPU temperature from `/sys`. Note: if you're a macOS
    user, your OS doesn't have sysfs, so you can skip this exercise.
