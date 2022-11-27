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

En tant qu'informaticiens, on sait que les ordinateur sont utiles à nous aider
avec les tâches répétitives. Pourtant, on oublie parfois que cela s'applique
aussi à notre _utilisation_ de l'ordinateur ainsi qu'aux calculs qu'on veut que
nos programmes exécutent. Nous avons un arsenal d'outils à portée de main qui
nous permettent d'être plus productif et de résoudre des problêmes plus
complexes quand on travaille sur une tâche reliée aux ordinateurs. Mais encore,
plusieurs d'entre nous utilisent seulement une fraction des ces outils; nous
savons seulement quelques incantations magiques par coeur pour se débrouiller
et nous copions aveuglément des commandes tirées d'internet quand on est pris.

L'objectif de cette classe est de rectifier ceci.

Nous voulons vous apprendre comment ressortir le plus des outils que vous
connaissez, vous montrer de nouveau outils à ajouter à votre boîte et vous
inspirer à explorer (et peut-être construire) plus d'outils par vous même.
C'est ce que nous pensons être le trimestre manquand de votre curriculum
informatique.

# Structure du cours

Le cours consiste de 11 présentations de 1 heure, chacune se concentrant sur un
[sujet en particulier](/2020/). Les leçons sont principalement indépendantes,
mais plus tard dans le trimestre nous assumerons que vous êtes familiers avec
le contenu des leçons précédentes. Nous avons des notes de cours en ligne, mais
il y aura beaucoup de contenu vu en classe (comme des présentations) qui ne
sera pas nécessairement dans les notes. Nous allons enregistrer les leçons et
nous les afficherons en ligne.

Nous essayons de couvrir beaucoup de matériel, donc les leçons seront
particulièrement denses. Pour vous laisser vous familiariser avec le contenu à
votre propre vitesse, chaque leçon aura un ensemble d'exercices pour vous
guider à travers les points clés des leçons. Après chaque leçon, nous
organisons des heures de bureau où nous serons présent pour aider à répondre
aux questions que vous pourriez avoir. Si vous assistez au cours en ligne, vous
pouvez envoyez des questions à
[missing-semester@mit.edu](mailto:missing-semester@mit.edu).

À cause des limitations temporelles du cours, nous ne pourrons pas couvrir tous
les outils de façon aussi détaillé qu'un cours complet le pourrait.  Nous
essayerons de vous montrer des ressources pour en apprendre plus sur un outil
ou un sujet, mais si quelque chose de particulier vous intéresse, n'hésitez pas
à nous demander de vous indiquer où chercher!

# 1^er sujet: Le Shell

## Qu'est-ce que le shell?

Les ordinateurs de nos jours ont plusieurs interfaces pour recevoir des
commandes; les outils d'interfaces graphiques, les interfaces vocaux et même la
RA/RV sont omniprésents. Ces interfaces sont utiles pour 80% des cas, mais ils
sont fondamentalement restreints dans leurs fonctionalités \- on ne peut pas
appuyer sur un bouton qui n'est pas là ou donner une commande vocale qui n'a
pas été programmée. Pour prendre avantage des outils que votre ordinateur
détient, il faut qu'on aille old-school et qu'on revienne à un interface
textuel: La Shell (Coquille).

Presque toutes les plateformes que vous pouvez mettre la main dessus aura un
shell d'une forme ou d'une autre et plusieurs d'entre elles ont plusieurs shell
que vous pouvez choisir. Même si elles ont quelques détails différents, elles
sont tous similaires à leur coeur(?): elles vous laisse rouler des programmes,
leur saisir des données et inspecter leur résultats de façon semi-structurée.

Dans cette leçon, nous allons nous concentrer sur la Bourne Again SHell, ou
simplement "bash". C'est le shell le plus utilisée et sa syntaxe est similaire
à celle que vous voyeriez dans plusieurs autres shells. Pour ouvrir un _invite_
du shell (où vous pouvez écrire des commandes), vous devez tout d'abord avoir
un _terminal_. Votre appareil est probablement expédié avec un terminal
installé. Sinon, vous pouvez en installer un assez facilement.

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

Dans ce cas, nous avons demandé au shell d'exécuter le programme `echo` avec
l'argument `hello`. Le programme `echo` imprime simplement ses arguments.  Le
shell analyse la commande en la séparant par les espaces, pour ensuite rouler
le programme indiqué par le premier mot, soumettant chaque autre mot comme un
argument que le programme peut accéder. Si vous voulez donner un argument qui
contient des espaces ou d'autres charactères spéciaux (comme un répertoire
nommé "Mes Photos"), vous pouvez soit mettre des guillemets ( `'` ou '"': `"Mes
Photos"`), ou échapper seulement les charactères concernés avec une `\` (`"Mes\
Photos"`).

Mais comment le shell reconnait où trouver le programme `echo` ou le programme
`date`? Puisque le shell est un environnement de programmation, comme Python ou
Ruby, elle est capable d'utiliser des variables, des conditions, des boucles et
des fonctions (prochaine leçon!). Quand vous roulez des commandes dans votre
shell, vous êtes en fait en train d'écrire un peu de code que votre shell
interprète. Si vous demandez au shell d'exécuter une commande qui ne correspond
pas à un de ses mots clés de programmation, elle consulte une _variable
d'environnement_ nommée `$PATH` qui liste quel répertoires que le shell devrait
chercher pour des programmes quand on lui donne une commande.


```console
missing:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
missing:~$ which echo
/bin/echo
missing:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Quand on run la commande `echo`, le shell voit qu'elle devrait exécuter le
programme `echo` et cherche à travers la liste de répertoires séparée par un
`:` dans `$PATH` pour un fichier qui a ce nom. Quand elle le trouve, elle le
roule (si le fichier est _exécutable_; on en reparlera plus tard).  Nous
pouvons trouver quel fichier est exécuté pour un programme en utilisant le
programme `which`. On peut aussi contourner la variable `$PATH` entièrement en
donnant le _chemin_ vers le fichier qu'on veut eéxécuter.

## Naviguer le shell

Un chemin sur le shell est une liste de répertoires séparé par une `/` sur
Linux et macOS et `\` sur Windows. Sur Linux et macOS, le chemin `/` est la
"racine" du système de fichiers, sous laquelle tous les autres répertoires et
fichiers reposent, tandis que sur Windows il y a une racine pour chaque
partition de disque (ex: `C:\`). Nous allons assumer généralement que vous
utilisez un système de fichiers Linux dans ce cours. Un chemin qui commence
avec `/` est un chemin _absolu_. Tout autre chemin est un chemin _relatif_. Les
chemins relatif sont relatif au répertoire qui est présentement sélectionné (le
répertoire de travail), qu'on peut voir avec la commande `pwd` et qu'on peut
changer avec la commande `cd`. Dans un chemin,  `.` fait référence au
répertoire sélectionné et `..` au répertoire parent:

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
notre répertoire sélectionnée. Vous pouvez configurer votre invite pour 
afficher toute sorte d'information utile, que nous couvrirons dans une 
autre leçon.

Généralement, quand on roule un programme, il va opérer dans la 
répertoire sélectionné à moins qu'on lui dise autrement. Par exemple, 
il cherchera et créera des nouveau fichiers dans la si cela s'avère 
nécessaire.

Pour afficher le contenu d'un répertoire, nous utilisons la commande `ls`:

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

À moins qu'un répertoire soit donné comme premier argument, `ls` imprimera le
contenu du répertoire de travail. La plupart des commandes acceptent des
drapeaux (flags) et des options (des flags avec des valeurs) qui commencent
avec `-` pour modifier leur comportement. Habituellement, exécuter un programme
avec le flag `-h` ou `--help` affichera du texte pour vous informer sur les
différents flags et options qui sont disponible. Par exemple, `ls --help` dit:

```
  -l                         use a long listing format
  			     (utiliser un long format)
```

```console
missing:~$ ls -l /home
drwxr-xr-x 1 missing  users  4096 Jun 15  2019 missing
```
Ceci nous donne plein d'autre information sur chaque fichier et répertoire
présent. Premièrement, le `d` au début de la ligne nous informe que `missing`
est un répertoire. Ensuite, il y a trois groupes de charactères (`rwx`). Le
premier nous informe sur les permissions du propriétaire du fichier
(`missing`), le deuxième sur le groupe propriétaire (`users`) et le dernier sur
le reste des utilisateurs. Un `-` indique que le commettant n'a pas les
permissions requises. Ci-haut, seulement le propriétaire est en mesure de
modifier (`w`) le répertoire `missing` (c.-à-d., y ajouter ou retirer des
fichiers). Pour entrer dans un répertoire, un utilisateur doit avoir les
permissions de "recherche" (représenté par "execute":`x`) sur le répertoire (et
ses parents). Pour énumérer son contenu, l'utilisateur doit avoir la permission
de lire (`r`) sur le répertoire. Pour les fichiers, les permissions sont
similaires. Notez que presque tous les fichiers dans `/bin` ont activé la
permission `x` pour le dernier groupe, "le reste du monde", pour que tout le
monde puisse exécuter ces programmes.

Quelques autre programmes utiles à savoir sont `mv` (pour renommer/bouger un
ficher), `cp` (pour copier un fichier) et `mkdir` (pour créer un nouveau
répertoire).

Si vous voulez en savoir _plus_ sur les arguments, leur entrée, leur sortie ou
comment ils fonctionnent en général, essayez le programme `man`. Il prend le
nom d'un programme comme argument et il vous montre sa _page de manuel_.
Appuyez sur `q` pour sortir.

```console
missing:~$ man ls
```

## Lier des programmes.

Dans le shell, les programmes possèdent deux "flux": leur flux d'entrée et leur
flux de sortie. Quand le programme essaie de lire l'entrée, il lit du flux
d'entrée et quand il imprime quelque chose, il imprime sur le flux de sortie.
Normalement, le flux d'entrée et de sortie d'un programme est votre terminal.
C'est à dire, votre clavier est le flux d'entrée et votre écran est la sortie.
Mais on peut recâbler ces flux!

La forme la plus simple de redirection est `< fichier` et `> fichier`. Ces
méthodes vous permettent de retransmettre le flux d'entrée et de sortie d'un
programme à un fichier:

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

Démontré dans l'exemple ci-haut, `cat` est un programme qui con`cat`enate
(enchaîne) les fichiers. Quand on lui donne des fichiers comme arguments, il
imprime le contenu de chaque fichier séquentiellement au flux de sortie. Mais
quand `cat` n'a aucun arguments, il imprime le contenu de son flux d'entrée à
son flux de sortie (comme le troisième exemple ci-haut).

Vous pouvez aussi utiliser `>>` pour rajouter à un fichier. Où ce genre de
retransimission de flux d'éntrée/sortie est vraiment utile est lorsqu'on
utilise des _tuyaux_. L'opérateur `|` vous laisse enchaîner des programme pour
avoir la sortie d'un programme comme entrée pour un autre:

```console
missing:~$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2019 var
missing:~$ curl --head --silent google.com | grep --ignore-case content-length | cut --delimiter=' ' -f2
219
```
Nous irons plus en détail sur la façon d'utiliser les tuyaux dans la leçon 
sur le façonnage de données. 

## Un outil puissant et versatile. 

Sur la plupart des système Unix, un utilisateur est spécial: l'utilisateur
"root" (racine). Vous l'avez peu-être vu dans le système de fichier ci-haut.
L'utilisateur root est supérieur à (presque) toutes les restrictions d'accès et
peut créer, écrire et supprimer n'importe quel fichier dans le système. Vous ne
vous connecterez pas comme utilisateur root, car il serait trop facile de
briser quelque chose accidentellement.  Au lieu de se connecter avec root, vous
allez utiliser la commande `sudo`. Comme son nom l'indique, elle vous laisse
faire ("do") quelque chose en tant qu'utilisateur super (root "as su"). Quand
vous avez des erreurs de permissions refusées, il y a de bonne chances que vous
devez faire quelque chose en tant que root. Soyez certain que vous voulez
vraiment exécuter la commande en tant que root avant de poursuivre.

Un exemple qui requiert d'être root pour achever est d'écrire dans le fichier
`sysfs` monté sous `/sys`. `sysfs` expose des paramètres du noyau (kernel) en
tant que fichier, pour vous laisser reconfigurer le noyau sans outils
spécialisés.  **Notez que sysfs n'existe pas sur Windows ou macOS.**

Par exemple, la luminosité de l'écran de votre portalble est exposé à travers un 
fichier appelé `brightness` sous

```
/sys/class/backlight
```

En écrivant une valeur dans ce fichier, nous pouvons changer la luminosité 
de l'écran. Vous voudriez peut-être exécuter ceci en premier:

```console
$ sudo find -L /sys/class/backlight -maxdepth 2 -name '*brightness*'
/sys/class/backlight/thinkpad_screen/brightness
$ cd /sys/class/backlight/thinkpad_screen
$ sudo echo 3 > brightness
An error occurred while redirecting file 'brightness'
open: Permission denied
```

Cette erreur est peut-être un choc. Après tout, nous avons roulé la commande
avec `sudo`! Cela est une chose importante à savoir à propos du shell. Les
opérations comme `|`, `>` et `<` sont faites _par le shell_, et non par le
programme lui-même. `echo` et ses amis ne sont pas "au courant" de `|`. Ils
vont seulement lire l'entrée et seulement écrire à leur sortie, peut-importe le
contenu. Dans le cas ci-haut, le _shell_ (qui est authentifié sous votre
utilisateur) essaie d'ouvrir le fichier de luminosité pour y écrire le résutat
de `sudo echo`, mais son accès est refusé car le shell n'exécute pas en tant
que root. En prenant avantage de cette propriété, nous pouvons exécuter:


```console
$ echo 3 | sudo tee brightness
```

Puisque le programme `tee`est le seul à ouvrir le fichier `/sys` pour y 
écrire, et qu'_il_ est exécuté en tant que `root`, les permissions vont 
fonctionner. Vous pouvez contrôler toute sorte de choses utiles et amusantes 
à travers `/sys`, comme l'état de différentes DELs (votre chemin peut varier)


```console
$ echo 1 | sudo tee /sys/class/leds/input6::scrolllock/brightness
```

# Prochaines étapes

Présentement vous savez comment utiliser le shell assez pour accomplir 
des tâches simples. Vous devriez être capable de naviguer pour trouver 
des fichiers intéressant et utiliser les fonctionalités de base de la 
plupart des programmes. Dans la prochaine leçon, nous visiterons comment 
accomplir et automatiser des tâches plus complexes et utiliser le shell et 
les plusieurs prgrammes d'invite de commande utiles existant.

# Exercices

Toutes les leçons de ce cours sont accompaniés par une série d'exercices. Il y
en a qui vous donne une tâche spécifique à accomplir, tandis que d'autre sont
plus libres, comme "essayer d'utiliser prgramme X et Y". Nous vous encourageons
fortement de les essayer.

Nous n'avons pas de solutions pour les exercices. Si vous êtes mépris sur
n'importe quoi, n'hésitez pas à nous envoyer un courriel décrivant ce que vous
avez fait jusqu'à présent, et nous essayerons de vous aider.


 1. Pour ce cours, vous devez utiliser un shell comme Bash ou ZSH. Si vous êtes
    sur Linux ou macOS, vous n'avez rien de spécial à faire. Si vous êtes sur
    Windows, vous devez être certain que vous ne soyez pas en train d'exécuter
    cmd.exe ou Powershell; vous pouvez utiliser le [sous-système pour
    Linux](https://docs.microsoft.com/en-us/windows/wsl/) ou une machine
    virtuell qui roule Linux pour utiliser les commandes de style Unix. Pour
    être certain que vous avez le bon shell, vous pouvez essayer la commande
    `echo $SHELL`. Si elle dit quelque chose comme `/bin/bash` ou
    `/usr/bin/zsh`, cela signifie que vous exéctutez le bon programme.

 1. Créez un nouveau répertoir appelé `missing` sous `/tmp`.
 1. Recherchez en plus sur la commande `touch`. Le programme `man` est votre
    meilleur ami.
 1. Utilisez `touch` pour créer un nouveau fichier appelé `semester` dans
    `missing`.
 1. Écrivez le contenu suivant dans ce fichier, une ligne à la fois.
    ```
    #!/bin/sh
    curl --head --silent https://missing.csail.mit.edu
    ```
    La première ligne pourrait être difficile à faire fonctionner. C'est utile
    de savoir que `#` commence un commentaire dans Bash, et que `!` a une
    significance même à l'intérieur des string doubles guillemets (`"`). Bash
    traite les strings qui ont seulement un guillemet (`'`) différamment: ils
    seront suffisant pour cette situation. Lisez la section
    [quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html)
    pour plus d'information.
 1. Essayez d'exécuter le fichier, c. -à-d. écrivez le chemin du script
    (`./semester`) dans votre shell et appuyez sur entrée. Concevez pourquoi
    cela ne fonctionne pas en consultant la sortie de `ls` (astuce: regardez
    les bits de permission du fichier).

 1. Roulez la commande explicitement en exécutant l'interpréteur `sh` et en lui
    donnant le fichier `semester` comme premier argument, c. -à-d. `sh
    semester`. Pourquoi est-ce que cela fonctionne, tandis que c'est le
    contraire pour `./semester`?

 1. Rechercher le programme `chmod` (ex: utilisez `man chmod`).Look up the
    `chmod` program (e.g. use `man chmod`).
 1. Utilisez `chmod` pour rendre possible d'exécuter `./semester` à la place de
    devoir écrire `sh semester`. Comment votre shell sait que le fichier est
    sensé être interprété en utilisant `sh`? Lisez cette page sur la ligne
    [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) pour plus
    d'information. 
 1. Utilisez `|` et `>` pour écrire la date "dernièrement modifiée" que
    `semester` donne dans un fichier nommé `last-modified.txt` dans votre
    répertoir maison.
 1. Écrivez une commande qui lis le niveau de la pile de votre portable ou la
    température du CPU de votre ordinateur de bureau de `/sys`. Notez que si
    vous êtes un utilisateur macOS, votre OS n'a pas sysfs, donc vous pouvez
    sauter cet exercice.
