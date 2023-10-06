---
layout : lecture
title : "Aperçu du cours + le shell"
date : 2020-01-13
ready : true
video :
  aspect : 56.25
  id : Z56Jmr9Z34Q
---

# Motivation

En tant qu'informaticiens, nous savons que les ordinateurs sont parfaits pour faciliter les tâches répétitives. Cependant, nous oublions trop souvent que cela s'applique aussi bien à notre utilisation de l'ordinateur qu'aux calculs que nous voulons que nos programmes effectuent. Nous disposons d'une vaste gamme d'outils qui nous permettent d'être plus productifs et de résoudre des problèmes plus complexes lorsque nous travaillons sur un problème informatique. Pourtant, beaucoup d'entre nous n'utilisent qu'une petite partie de ces outils ; nous ne connaissons que suffisamment d'incantations magiques par coeur pour nous débrouiller, et nous copions-collons aveuglément des commandes trouvés sur Internet lorsque nous sommes bloqués.

Ce cours est une tentative d'y remédier.

Nous voulons vous apprendre à tirer le meilleur parti des outils que vous connaissez, vous montrer de nouveaux outils à ajouter à votre boîte à outils et, nous l'espérons, vous donner envie d'explorer (et peut-être de construire) d'autres outils par vous-même. C'est ce que nous pensons être le cours manquant dans la plupart des programmes d'enseignement de l'informatique.

# Structure du cours

Le cours se compose de 11 conférences d'une heure, chacune centrée sur un [sujet particulier](/2020/). Les conférences sont largement indépendantes, bien qu'au fur et à mesure que le semestre avance, nous supposerons que vous êtes familier avec le contenu des conférences précédentes. Nous avons des notes de cours en ligne, mais il y aura beaucoup de contenu couvert en classe (par exemple sous la forme de démonstrations live) qui ne figure pas dans les notes. Nous enregistrerons les cours et mettrons les enregistrements en ligne.

Nous essayons de couvrir un large éventail de sujets en seulement 11 cours d'une heure, c'est pourquoi les cours sont assez denses. Pour vous permettre de vous familiariser avec le contenu à votre propre rythme, chaque conférence comprend une série d'exercices qui vous guident à travers les points clés de la conférence. Après chaque cours, nous organisons des heures de bureau où nous serons présents pour répondre à vos questions. Si vous suivez le cours en ligne, vous pouvez nous envoyer vos questions à l'adresse [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

En raison du temps limité dont nous disposons, nous ne pourrons pas couvrir tous les outils avec le même niveau de détail qu'un cours complet. Dans la mesure du possible, nous essaierons de vous indiquer des ressources pour approfondir un outil ou un sujet, mais si quelque chose vous intéresse particulièrement, n'hésitez pas à nous contacter et à nous demander des conseils !

# Sujet 1: Le Shell

## Qu'est ce qu'un shell ?

De nos jours, les ordinateurs disposent d'une grande variété d'interfaces pour leur donner des commandes ; les interfaces graphiques fantaisistes, les interfaces vocales et même l'AR/VR sont omniprésentes. Ces interfaces sont excellentes pour 80 % des cas d'utilisation, mais elles sont souvent fondamentalement limitées dans ce qu'elles vous permettent de faire - vous ne pouvez pas appuyer sur un bouton qui n'existe pas ou donner une commande vocale qui n'a pas été programmée. Pour tirer pleinement parti des outils fournis par l'ordinateur, il faut passer à l'ancienne et utiliser à une interface textuelle : Le Shell.

Presque toutes les plateformes sur lesquelles vous pouvez mettre la main ont un shell sous une forme ou une autre, et beaucoup d'entre elles ont plusieurs shells parmi lesquels vous pouvez choisir. Bien qu'ils puissent varier dans les détails, à la base ils sont tous à peu près les mêmes : ils vous permettent d'exécuter des programmes, de leur donner des entrées, et d'inspecter leur sortie d'une manière semi-structurée.

Dans ce cours, nous nous concentrerons sur le Bourne Again SHell, ou "bash" en abrégé. Il s'agit de l'un des shells les plus utilisés, et sa syntaxe est similaire à celle de nombreux autres shells. Pour ouvrir une _invite_ de l'interpréteur de commandes (où vous pouvez saisir des commandes), vous devez d'abord disposer d'un _terminal_. Votre appareil possède probablement un terminal pré-installé, ou vous pouvez en installer un assez facilement.

## Utilisation du shell

Lorsque vous lancez votre terminal, vous voyez apparaître une _invite_ qui ressemble souvent à ceci :

```console
missing:~$ 
```

Il s'agit de l'interface textuelle principale de l'interpréteur de commandes. Elle vous indique que vous êtes sur la machine `missing` et que votre "répertoire de travail courant", ou l'endroit où vous vous trouvez actuellement, est `~` (abréviation de "home"). Le `$` indique que vous n'êtes pas l'utilisateur root (nous y reviendrons). À cette invite, vous pouvez taper une _commande_, qui sera ensuite interprétée par l'interpréteur de commandes (shell). La commande la plus élémentaire consiste à exécuter un programme :

```console
missing:~$ date
Fri 10 Jan 2020 11:49:31 AM EST
missing:~$ 
```

Ici, nous avons exécuté le programme `date`, qui (sans surprise) affiche la date et l'heure actuelle. L'interpréteur de commandes nous demande ensuite d'exécuter une autre commande. Nous pouvons également exécuter une commande avec des arguments :

```console
missing:~$ echo hello
hello
```

Dans ce cas, nous avons demandé à l'interpréteur de commandes d'exécuter le programme `echo` avec l'argument `hello`. Le programme `echo` imprime simplement ses arguments. L'interpréteur de commandes analyse la commande en la séparant par des espaces, puis exécute le programme indiqué par le premier mot, en fournissant chaque mot suivant comme un argument auquel le programme peut accéder. Si vous souhaitez fournir un argument contenant des espaces ou d'autres caractères spéciaux (par exemple, un dossier nommé "Mes photos"), vous pouvez soit mettre l'argument entre guillemets avec `'` ou `"` (`"Mes photos"`), soit éviter uniquement les caractères pertinents avec `\` (`Mes\ photos`).

Mais comment l'interpréteur de commandes sait-il où trouver les programmes `date` ou `echo` ? L'interpréteur de commandes est un environnement de programmation, tout comme Python ou Ruby, et il dispose donc de variables, de conditions, de boucles et de fonctions (prochain cours !). Lorsque vous exécutez des commandes dans votre shell, vous écrivez en fait un petit bout de code que votre shell interprète. Si l'interpréteur de commandes est invité à exécuter une commande qui ne correspond pas à l'un de ses mots-clés de programmation, il consulte une _variable d'environnement_ appelée `$PATH`, qui répertorie les dossiers dans lesquels l'interpréteur de commandes doit rechercher des programmes lorsqu'il reçoit une commande :

```console
missing:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
missing:~$ which echo
/bin/echo
missing:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Lorsque nous lançons la commande `echo`, le shell voit qu'il doit exécuter le programme `echo`, puis recherche un fichier portant ce nom dans la liste des répertoires séparés par `:` dans `$PATH`. Lorsqu'il le trouve, il l'exécute (en supposant que le fichier soit _exécutable_ ; nous y reviendrons plus tard). Le programme `which` permet de savoir quel fichier est exécuté pour un nom de programme donné. Il est également possible de contourner `$PATH` en indiquant le _chemin d'accès_ au fichier à exécuter.

## Naviguer dans l'interpréteur de commandes

Un chemin d'accès dans l'interpréteur de commandes est une liste délimitée de répertoires (dossiers), séparés par `/` sous Linux et macOS et par `\` sous Windows. Sous Linux et macOS, le chemin `/` est la "racine" du système de fichiers, sous laquelle se trouvent tous les répertoires et fichiers, alors que sous Windows, il y a une racine pour chaque partition de disque (par exemple, `C:\`). Dans ce cours, nous supposerons que vous utilisez un système de fichiers Linux. Un chemin qui commence par `/` est appelé chemin _absolu_. Tout autre chemin est un chemin _relatif_. Les chemins relatifs sont relatifs au répertoire de travail actuel, que nous pouvons afficher avec la commande `pwd` et changer avec la commande `cd`. Dans un chemin d'accès, `.` fait référence au répertoire actuel et `..` à son répertoire parent :

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

Remarquez que l'invite de notre shell nous a permis de savoir quel était notre répertoire de travail actuel. Vous pouvez configurer votre invite pour qu'elle vous montre toutes sortes d'informations utiles, que nous aborderons dans un cours ultérieur.

En général, lorsque nous lançons un programme, il fonctionne dans le répertoire courant, sauf indication contraire de notre part. Par exemple, il recherchera généralement des fichiers dans ce répertoire et en créera de nouveaux si nécessaire.

Pour voir ce qui se trouve dans un répertoire donné, nous utilisons la commande `ls` :

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

À moins qu'un répertoire ne soit donné comme premier argument, `ls` affiche le contenu du répertoire courant. La plupart des commandes acceptent des drapeaux (flags) et des options (drapeaux avec valeurs) commençant par `-` pour modifier leur comportement. En général, l'exécution d'un programme avec le flag `-h` ou `--help` entraîne l'affichage d'un texte d'aide indiquant les options et les flags disponibles. Par exemple, `ls --help` nous indique :

```
  -l                         utilise un format d’affichage long
```

```console
missing:~$ ls -l /home
drwxr-xr-x 1 missing  users  4096 Jun 15  2019 missing
```

Cela nous donne un tas d'informations supplémentaires sur chaque fichier ou répertoire présent. Tout d'abord, le `d` au début de la ligne nous indique que `missing` est un dossier. Viennent ensuite trois groupes de trois caractères (`rwx`). Ceux-ci indiquent les autorisations dont disposent respectivement le propriétaire du fichier (`missing`), le groupe propriétaire (`users`) et tous les autres utilisateurs sur l'élément concerné. Un `-` indique que le principal concerné n'a pas la permission en question. Ci-dessus, seul le propriétaire est autorisé à modifier (`w`) le répertoire `missing` (c'est-à-dire à y ajouter/supprimer des fichiers). Pour entrer dans un répertoire, un utilisateur doit disposer des autorisations de "recherche" (représentées par "exécuter" : `x`) sur ce répertoire (et ses parents). Pour lister son contenu, un utilisateur doit avoir les droits de lecture (`r`) sur ce répertoire. Pour les fichiers, les autorisations sont telles que vous les auriez imaginées. Remarquez que presque tous les fichiers dans `/bin` ont la permission `x` définie pour le dernier groupe, "tous les autres utilisateurs", de sorte que n'importe qui puisse exécuter ces programmes.

D'autres programmes pratiques à connaître à ce stade sont `mv` (pour renommer/déplacer un fichier), `cp` (pour copier un fichier) et `mkdir` (pour créer un nouveau répertoire).

Si vous souhaitez obtenir _davantage_ d'informations sur les arguments, les entrées et les sorties d'un programme, ou sur son fonctionnement général, essayez le programme `man`. Il prend comme argument le nom d'un programme et affiche sa _page de manuel_. Appuyez sur `q` pour quitter.

```console
missing:~$ man ls
```

## Lier des programmes

Dans l'interpréteur de commandes, les programmes sont associés à deux "flux" principaux : leur flux d'entrée et leur flux de sortie. Lorsque le programme tente de lire une entrée, il lit à partir du flux d'entrée, et lorsqu'il imprime quelque chose, il l'imprime sur son flux de sortie. Normalement, l'entrée et la sortie d'un programme sont toutes deux situées dans votre terminal. C'est-à-dire votre clavier comme entrée et votre écran comme sortie. Cependant, nous pouvons également rediriger ces flux !

La forme la plus simple de redirection est `< fichier` et `> fichier`. Elles vous permettent de rediriger les flux d'entrée et de sortie d'un programme vers un fichier, respectivement :

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

Comme montré dans l'exemple ci-dessus, `cat` est un programme qui con`cat`ène des fichiers. Lorsqu'il reçoit des noms de fichiers comme arguments, il imprime le contenu de chacun des fichiers dans l'ordre sur son flux de sortie. Mais lorsque `cat` ne reçoit aucun argument, il imprime le contenu de son flux d'entrée dans son flux de sortie (comme dans le troisième exemple ci-dessus).


Vous pouvez également utiliser `>>` pour ajouter des données à un fichier. Ce type de redirection des entrées/sorties est particulièrement utile dans l'utilisation des _pipes_. L'opérateur `|` vous permet de "chaîner" des programmes de manière à ce que la sortie de l'un soit l'entrée d'un autre :

```console
missing:~$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2019 var
missing:~$ curl --head --silent google.com | grep --ignore-case content-length | cut --delimiter=' ' -f2
219
```

Nous reviendrons plus en détail sur la manière de tirer parti des pipes dans le cours sur le traitement des données.


## Un outil polyvalent et puissant

Sur la plupart des systèmes de type Unix, un utilisateur est spécial : l'utilisateur "root". Vous l'avez peut-être vu dans les résultat du listing de fichiers ci-dessus. L'utilisateur "root" est au-dessus de (presque) toutes les restrictions d'accès et peut créer, lire, mettre à jour et supprimer n'importe quel fichier du système. Cependant, vous ne vous connecterez généralement pas à votre système en tant qu'utilisateur root, car il est trop facile de casser accidentellement quelque chose. Vous utiliserez plutôt la commande `sudo`. Comme son nom l'indique, elle vous permet de "faire" (do) quelque chose "en tant que su" (abréviation de "super utilisateur" (super user) ou "root"). Lorsque vous obtenez des erreurs de refus de permission, c'est généralement parce que vous devez faire quelque chose en tant que super-utilisateur. Cependant, assurez-vous d'abord de vérifier que vous voulez vraiment le faire de cette façon !

L'une des choses que vous devez faire en tant que root est d'écrire dans le système de fichiers `sysfs` monté sous `/sys`. `sysfs` expose un certain nombre de paramètres du noyau sous forme de fichiers, de sorte que vous pouvez facilement reconfigurer le noyau à la volée sans outils spécialisés. **Notez que sysfs n'existe pas sous Windows ou macOS.**

Par exemple, la luminosité de l'écran de votre ordinateur portable est exposée par le biais d'un fichier appelé `brightness` dans

```
/sys/class/backlight
```

En écrivant une valeur dans ce fichier, nous pouvons modifier la luminosité de l'écran. Votre premier réflexe pourrait être de faire quelque chose comme :

```console
$ sudo find -L /sys/class/backlight -maxdepth 2 -name '*brightness*'
/sys/class/backlight/thinkpad_screen/brightness
$ cd /sys/class/backlight/thinkpad_screen
$ sudo echo 3 > brightness
An error occurred while redirecting file 'brightness'
open: Permission denied
```

Cette erreur peut surprendre. Après tout, nous avons exécuté la commande avec `sudo` ! C'est une chose importante à savoir sur l'interpréteur de commandes. Les opérations telles que `|`, `>` et `<` sont effectuées _par l'interpréteur de commandes_, et non par le programme individuel. `echo` et ses amis ne "savent" pas ce qu'est `|`. Ils se contentent de lire à partir de leur entrée et d'écrire sur leur sortie, quelle qu'elle soit. Dans le cas ci-dessus, _l'interpréteur de commandes_ (qui est authentifié comme votre utilisateur) essaie d'ouvrir le fichier brightness pour y écrire, avant d'en faire la sortie de `sudo echo`, mais il en est empêché car l'interpréteur de commandes ne s'exécute pas en tant que root. En utilisant cette connaissance, nous pouvons contourner ce problème :

```console
$ echo 3 | sudo tee brightness
```

Comme le programme `tee` est celui qui ouvre le fichier `/sys` à l'écriture et qu'_il_ est exécuté en tant que `root`, les permissions sont respectées. Vous pouvez contrôler toutes sortes de choses amusantes et utiles par le biais de `/sys`, comme l'état des différents voyants LEDs du système (votre chemin d'accès peut être différent) :

```console
$ echo 1 | sudo tee /sys/class/leds/input6::scrolllock/brightness
```

# Prochaines étapes

À ce stade, vous connaissez suffisamment l'interpréteur de commandes pour accomplir des tâches de base. Vous devriez être en mesure de naviguer pour trouver les fichiers qui vous intéressent et d'utiliser les fonctionnalités de base de la plupart des programmes. Dans le prochain cours, nous verrons comment effectuer et automatiser des tâches plus complexes à l'aide de l'interpréteur de commandes et des nombreux programmes de ligne de commande disponibles.

# Exercices

Tous les cours de ce programme sont accompagnés d'une série d'exercices. Certains vous donnent une tâche spécifique à effectuer, tandis que d'autres sont plus ouverts, comme "essayez d'utiliser les programmes X et Y". Nous vous encourageons vivement à les essayer.

Nous n'avons pas rédigé de solutions pour les exercices. Si vous êtes bloqué sur un point particulier, n'hésitez pas à nous envoyer un e-mail décrivant ce que vous avez essayé jusqu'à présent, et nous essaierons de vous aider.

1. Pour ce cours, vous devez utiliser un shell Unix comme Bash ou ZSH. Si vous êtes sous Linux ou macOS, vous n'avez rien de particulier à faire. Si vous êtes sous Windows, vous devez vous assurer que vous n'exécutez pas cmd.exe ou PowerShell ; vous pouvez utiliser [Windows Subsystem for
    Linux](https://docs.microsoft.com/en-us/windows/wsl/) ou une machine virtuelle Linux pour utiliser des outils de ligne de commande de type Unix. Pour vous assurer que vous utilisez un shell approprié, vous pouvez essayer la commande `echo $SHELL`. Si elle indique quelque chose comme `/bin/bash` ou `/usr/bin/zsh`, cela signifie que vous exécutez le bon programme.

1. Créez un nouveau répertoire appelé `missing` dans `/tmp`.
1. Recherchez le programme `touch`. Le programme `man` est votre ami.
1. Utilisez `touch` pour créer un nouveau fichier appelé `semester` dans `missing`.
1. Ecrivez ce qui suit dans ce fichier, une ligne à la fois :
    ```
    #!/bin/sh
    curl --head --silent https://missing.csail.mit.edu
    ```

    La première ligne peut être difficile à faire fonctionner. Il est utile de savoir que `#` commence un commentaire en Bash, et que `!` a une signification particulière, même dans les chaînes de caractères entre guillemets doubles (`"`). Bash traite différemment les chaînes entre guillemets simples (`'`) : elles feront l'affaire dans ce cas. Voir la page de manuel de Bash sur les [guillemets](https://www.gnu.org/software/bash/manual/html_node/Quoting.html) pour plus d'informations.

1. Essayez d'exécuter le fichier, c'est-à-dire tapez le chemin du script (`./semestre`) dans votre shell et appuyez sur enter. Comprenez pourquoi cela ne fonctionne pas en consultant la sortie de `ls` (indice : regardez les bits de permission du fichier).
1. Exécutez la commande en lançant explicitement l'interpréteur `sh` et en lui donnant le fichier `semester` comme premier argument, c'est-à-dire `sh semester`. Pourquoi cela fonctionne-t-il, alors que `./semestre` ne fonctionne pas ?
1. Consultez le programme `chmod` (par exemple, utilisez `man chmod`).
1. Utilisez `chmod` pour rendre possible l'exécution de la commande `./semestre` au lieu de devoir taper `sh semestre`. Comment votre shell sait-il que le fichier est censé être interprété à l'aide de `sh` ? Voir cette page sur la ligne [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) pour plus d'informations.
1. Utilisez `|` et `>` pour écrire la date de "dernière modification" produite par `semestre` dans un fichier appelé `last-modified.txt` dans votre répertoire "home".
1. Écrivez une commande qui lit le niveau de puissance de la batterie de votre ordinateur portable ou la température du processeur de votre ordinateur à partir de `/sys`. Note : si vous utilisez macOS, votre système d'exploitation ne possède pas `sysfs`, vous pouvez donc passer cet exercice.