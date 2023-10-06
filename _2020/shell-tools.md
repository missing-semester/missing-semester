---
layout: lecture
title: "Les outils du Shell et les scripts"
date: 2020-01-14
ready: true
video:
  aspect: 56.25
  id: kgII-YWo3Zw
---

Dans ce cours, nous présenterons quelques bases de l'utilisation de bash comme langage script, ainsi qu'un certain nombre d'outils de l'interpréteur de commandes qui couvrent plusieurs des tâches les plus courantes, que vous serez amené à effectuer en ligne de commande.

# Shell Scripting

Jusqu'à présent, nous avons vu comment exécuter des commandes dans l'interpréteur de commandes et les relier entre elles.
Cependant, dans de nombreux cas, vous voudrez exécuter une série de commandes et utiliser des expressions de flux de contrôle telles que des conditionnelles ou des boucles.

Les scripts Shell constituent l'étape suivante en termes de complexité.
La plupart des shells possèdent leur propre langage de script avec des variables, un flux de contrôle et sa propre syntaxe.
Ce qui différencie les scripts shell des autres langages de programmation de scripts, c'est qu'ils sont optimisés pour effectuer des tâches liées à l'interpréteur de commandes.
Ainsi, la création de pipelines de commandes, l'enregistrement des résultats dans des fichiers et la lecture de l'entrée standard sont des primitives du langage de script shell, ce qui le rend plus facile à utiliser que les langages de script à usage général.
Dans cette section, nous nous concentrerons sur les scripts bash, qui sont les plus courants.

Pour assigner des variables en bash, on utilise la syntaxe `foo=bar` et on accède à la valeur de la variable avec `$foo`.
A noter que `foo = bar` ne fonctionnera pas car elle est interprétée comme appelant le programme `foo` avec les arguments `=` et `bar`.

En général, dans les scripts shell, le caractère espace permet de diviser les arguments. Ce comportement peut être perturbant au début, c'est pourquoi il faut toujours le vérifier.

Les chaînes de caractères dans bash peuvent être définies avec les délimiteurs `'` et `"`, mais ne sont pas équivalents.
Les chaînes délimitées par `'` sont des chaînes littérales et ne remplacent pas les valeurs des variables, alors que les chaînes délimitées par `"` le font.

```bash
foo=bar
echo "$foo"
# affiche bar
echo '$foo'
# affiche $foo
```

Comme la plupart des langages de programmation, bash supporte des techniques de flux de contrôle comme `if`, `case`, `while` et `for`.
De la même façon, `bash` possède des fonctions qui prennent des arguments et peuvent opérer avec eux. Voici un exemple d'une fonction qui crée un répertoire et `cd`(changer de répertoire) dans celui-ci.

```bash
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```

Ici, `$1` est le premier argument du script/fonction.
Contrairement à d'autres langages de script, bash utilise une variété de variables spéciales pour faire référence aux arguments, aux codes d'erreur et à d'autres variables pertinentes. Voici une liste de quelques-unes d'entre elles. Une liste plus complète peut être trouvée [ici](https://tldp.org/LDP/abs/html/special-chars.html).
- `$0` - Nom du script
- `$1` à `$9` - Arguments du script. `$1` est le premier argument et ainsi de suite.
- `$@` - Tous les arguments
- `$#` - Nombre d'arguments
- `$?` - Code de retour de la commande précédente
- `$$` - Numéro d'identification du processus (PID) pour le script actuel
- `!!` - L'intégralité de la dernière commande, y compris les arguments. Un cas courant est l'exécution d'une commande qui échoue en raison de permissions manquantes ; vous pouvez rapidement réexécuter la commande avec sudo en faisant `sudo !!`
- `$_` - Dernier argument de la dernière commande. Si vous êtes dans un shell interactif, vous pouvez également obtenir rapidement cette valeur en tapant `Esc` suivi de `.` ou `Alt+.`

Les commandes vont souvent renvoyer des résultats en utilisant `STDOUT`, des erreurs en utilisant `STDERR`, et un code de retour pour signaler les erreurs d'une manière plus script-friendly.
Le code de retour ou le statut de sortie est la façon dont les scripts/commandes doivent communiquer la façon dont l'exécution s'est déroulée.

Une valeur de 0 signifie généralement que tout s'est bien passé ; toute valeur différente de 0 signifie qu'une erreur s'est produite.

Les codes de sortie peuvent être utilisés pour exécuter des commandes de manière conditionnelle à l'aide de `&&` (opérateur et) et `||` (opérateur ou), qui sont tous deux des opérateurs de [court-circuitage](https://en.wikipedia.org/wiki/Short-circuit_evaluation). Les commandes peuvent également être séparées sur une même ligne par un point-virgule `;`.
La commande `true` aura toujours un code de retour de 0 et la commande `false` aura toujours un code de retour de 1.
Voici quelques exemples
```bash
false || echo "Oups, c'est raté"
# Oups, c'est raté

true || echo "Ne sera pas imprimé"
#

true && echo "Tout s'est bien passé"
# Tout s'est bien passé

false && echo "Ne sera pas imprimé"
#

true ; echo "Cette opération sera toujours exécutée"
# Cette opération sera toujours exécutée

false ; echo "Cette opération sera toujours exécutée"
# Cette opération sera toujours exécutée
```

Un autre cas courant consiste à vouloir obtenir la sortie d'une commande sous la forme d'une variable. Cela peut être fait avec la _substitution de commandes_.
Lorsque vous placez `$( CMD )` il exécutera `CMD`, et récupèra la sortie de la commande et la remplacera.
Par exemple, si vous faites  `for file in $(ls)`,  l'interpréteur de commandes appellera d'abord `ls` et itérera ensuite sur ces valeurs.
Une fonction similaire moins connue est la  _substitution de commandes_, `<( CMD )` qui exécute `CMD` et place la sortie dans un fichier temporaire et remplace le `<()` par le nom de ce fichier. Ceci est utile lorsque les commandes s'attendent à ce que les valeurs soient transmises par un fichier plutôt que par STDIN. Par exemple, `diff <(ls foo) <(ls bar)` montrera les différences entre les fichiers des répertoires `foo` et `bar`.

Puisque c'est beacoup d'informations d'un coup, voyons un exemple qui illustre certaines de ces fonctionnalités. Le script va parcourir les arguments que nous lui fournissons. Il va `grep` la chaîne de caractères `foobar`, et l'ajouter au fichier en tant que commentaire si elle n'est pas trouvée.

```bash
#!/bin/bash

echo "Le programme commence à $(date)" # Date will be substituted

echo "Execution du programme $0 avec $# arguments et avec le pid $$"

for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    # Si le pattern n'est pas trouvé, grep a le statut de sortie 1.
    # Nous redirigeons STDOUT et STDERR vers un registre nul puisque nous ne nous en soucions pas.
    if [[ $? -ne 0 ]]; then
        echo "Fichier $file n'a pas de foobar, on en ajoute un"
        echo "# foobar" >> "$file"
    fi
done
```

Dans la comparaison, nous avons testé si `$?` était différent de 0.
Bash implémente de nombreuses comparaisons de ce type - vous pouvez trouver une liste détaillée des comparaisons dans la page de manuel de [`test`](https://www.man7.org/linux/man-pages/man1/test.1.html).
Lorsque vous effectuez des comparaisons dans bash, essayez d'utiliser des doubles crochets `[[ ]]` au lieu de simples crochets `[ ]`. Les chances de faire des erreurs sont plus faibles, bien qu'ils ne soient pas compatibles avec `sh`. Une explication plus détaillée peut être trouvée [ici](http://mywiki.wooledge.org/BashFAQ/031).

Lorsque vous lancez des scripts, vous souhaitez souvent fournir des arguments similaires. Bash dispose de moyens pour faciliter cette tâche, en développant les expressions par l'intermédiaire de l'expansion des noms de fichiers. Ces techniques sont souvent appelées shell _globbing_.

- Wildcards (jokers) - Lorsque vous souhaitez effectuer une sorte de recherche avec des wildcards, vous pouvez utiliser `?` et `*` pour faire correspondre un ou plusieurs caractères respectivement. Par exemple, avec les fichiers `foo`, `foo1`, `foo2`, `foo10` et `bar`, la commande `rm foo?` supprimera `foo1` et `foo2` alors que `rm foo*` supprimera tout sauf `bar`.

- Accolades `{}` - Lorsque vous avez une sous-chaîne commune dans une série de commandes, vous pouvez utiliser les accolades pour que bash l'étende automatiquement. C'est très pratique pour déplacer ou convertir des fichiers.

```bash
convert image.{png,jpg}
# S'étendra à
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# S'étendra à
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# Les techniques de Globbing peuvent également être combinées
mv *{.py,.sh} folder
# Déplacera tous les fichiers *.py et *.sh 


mkdir foo bar
# Crée les fichiers foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h
touch {foo,bar}/{a..h}
touch foo/x bar/y
# Montre les différences entre les fichiers foo et bar
diff <(ls foo) <(ls bar)
# Sorties
# < x
# ---
# > y
```

<!--Enfin, les tuyaux `|` sont une caractéristique essentielle des scripts. Les pipes connectent la sortie d'un programme à l'entrée du programme suivant. Nous les aborderons plus en détail dans le cours sur le traitement des données. -->

L'écriture de scripts `bash` peut être compliquée et non-intuitive. Il existe des outils comme [shellcheck](https://github.com/koalaman/shellcheck) qui vous aideront à trouver des erreurs dans vos scripts sh/bash.

Notez que les scripts ne doivent pas nécessairement être écrits en bash pour être appelés depuis le terminal. Par exemple, voici un script Python simple qui affiche ses arguments dans l'ordre inverse :

```python
#!/usr/local/bin/python
import sys
for arg in reversed(sys.argv[1:]):
    print(arg)
```

Le noyau sait qu'il doit exécuter ce script avec un interpréteur python au lieu d'une commande shell parce que nous avons inclus une ligne [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) au début du script. C'est une bonne pratique d'écrire les lignes shebang en utilisant la commande [`env`](https://www.man7.org/linux/man-pages/man1/env.1.html) qui résoudra l'emplacement de la commande dans le système, augmentant ainsi la portabilité de vos scripts. Pour déterminer l'emplacement, `env` utilisera la variable d'environnement `PATH` que nous avons introduite dans le premier cours.
Pour cet exemple, la ligne shebang ressemblerait à `#!/usr/bin/env python`.

Voici quelques différences entre les fonctions de l'interpréteur de commandes et les scripts que vous devez garder à l'esprit :
- Les fonctions doivent être écrites dans le même langage que le shell, alors que les scripts peuvent être écrits dans n'importe quel langage. C'est pourquoi il est important d'inclure un shebang pour les scripts.
- Les fonctions sont chargées une fois lorsque leur définition est lue. Les scripts sont chargés à chaque fois qu'ils sont exécutés. Les fonctions sont donc légèrement plus rapides à charger, mais chaque fois que vous les modifiez, vous devez recharger leur définition.
- Les fonctions sont exécutées dans l'environnement actuel du shell alors que les scripts s'exécutent dans leur propre processus. Ainsi, les fonctions peuvent modifier les variables d'environnement, par exemple changer votre répertoire actuel, alors que les scripts ne le peuvent pas. Les scripts se verront passer par valeur les variables d'environnement qui ont été exportées en utilisant [`export`](https://www.man7.org/linux/man-pages/man1/export.1p.html).
- Comme dans tout langage de programmation, les fonctions sont un moyen puissant d'assurer la modularité, la réutilisation du code et la clarté du code de l'interpréteur de commandes. Souvent, les scripts shell incluent leurs propres définitions de fonctions.

# Outils Shell

## Savoir utiliser les commandes

À ce stade, vous vous demandez peut-être comment trouver les flags pour les commandes de la section des alias telles que `ls -l`, `mv -i` et `mkdir -p`.
Plus généralement, à partir d'une commande, comment faire pour savoir ce qu'elle fait et quelles sont ses différentes options ?
Vous pouvez toujours commencer à chercher sur Google, mais comme UNIX est antérieur à StackOverflow, il existe des moyens intégrés pour obtenir ces informations.

Comme nous l'avons vu dans le cours sur l'interpréteur de commandes, l'approche de premier ordre est d'appeler cette commande avec les flags `-h` ou `--help`. Une approche plus détaillée consiste à utiliser la commande `man`.
Abréviation de manual, [`man`](https://www.man7.org/linux/man-pages/man1/man.1.html) fournit une page de manuel (appelée manpage) pour une commande que vous spécifiez.
Par exemple, `man rm` affichera le comportement de la commande `rm` ainsi que les flags qu'elle utilise, y compris le flag `-i` que nous avons montré plus tôt.
En fait, ce que j'ai lié jusqu'à présent pour chaque commande est la version en ligne des pages de manuel de Linux pour les commandes.
Même les commandes non natives que vous installez auront des entrées de pages de manuel si le développeur les ont écrites et incluses dans le processus d'installation.
Pour les outils interactifs tels que ceux basés sur ncurses, l'aide pour les commandes est souvent accessible à l'intérieur du programme en utilisant la commande `:help` ou en tapant `?`.

Parfois, les pages de manuel fournissent des descriptions trop détaillées des commandes, ce qui rend difficile le déchiffrage des flags et de la syntaxe à utiliser pour les cas d'utilisation courants.
Les [pages TLDR](https://tldr.sh/) sont une solution complémentaire intéressante qui se concentre sur des exemples d'utilisation d'une commande afin que vous puissiez rapidement comprendre quelles options utiliser.
Par exemple, je me réfère plus souvent aux pages tldr pour [`tar`](https://tldr.inbrowser.app/pages/common/tar) et [`ffmpeg`](https://tldr.inbrowser.app/pages/common/ffmpeg) qu'aux pages de manuel.


## Trouver des fichiers

L'une des tâches répétitives les plus courantes auxquelles tout programmeur est confronté est la recherche de fichiers ou de répertoires. Tous les systèmes de type UNIX sont munis de [`find`](https://www.man7.org/linux/man-pages/man1/find.1.html), un excellent outil de l'interpréteur de commandes pour trouver des fichiers. `find` recherche de manière récursive les fichiers correspondant à certains critères. Quelques exemples :

```bash
# Trouver tous les répertoires nommés src
find . -name src -type d
# Trouver tous les fichiers python qui ont un dossier nommé test dans leur chemin d'accès
find . -path '*/test/*.py' -type f
# Trouver tous les fichiers modifiés au cours de la dernière journée
find . -mtime -1
# Trouver tous les fichiers zip dont la taille est comprise entre 500k et 10M
find . -size +500k -size -10M -name '*.tar.gz'
```
Outre la liste des fichiers, find peut également effectuer des actions sur les fichiers qui répondent à votre demande.
Cette propriété peut s'avérer extrêmement utile pour simplifier des tâches qui pourraient être relativement rébarbatives.
```bash
# Supprimer tous les fichiers portant l'extension .tmpn
find . -name '*.tmp' -exec rm {} \;
# Trouver tous les fichiers PNG et les convertir en JPG
find . -name '*.png' -exec convert {} {}.jpg \;
```

Malgré l'omniprésence de `find`, sa syntaxe peut parfois être difficile à mémoriser.
Par exemple, pour trouver simplement les fichiers qui correspondent à un motif `PATTERN`, vous devez exécuter `find -name '*PATTERN*'` (ou `-iname` si vous souhaitez que le pattern soit insensible à la casse).
Vous pourriez commencer à construire des alias pour ces scénarios, mais une partie de la philosophie du shell est qu'il est bon d'explorer des alternatives.
Rappelez-vous que l'une des meilleures propriétés de l'interpréteur de commandes est que vous ne faites qu'appeler des programmes, vous pouvez donc trouver (ou même écrire vous-même) des remplacements pour certains d'entre eux.
Par exemple, [`fd`](https://github.com/sharkdp/fd) est une alternative simple, rapide et facile à utiliser à `find`.
Il offre des options par défaut intéressantes comme la sortie en couleur, la correspondance par défaut des expressions rationnelles, et le support de l'Unicode. Il a aussi, selon moi, une syntaxe plus intuitive.
Par exemple, la syntaxe pour trouver un motif `PATTERN` est `fd PATTERN`.

La plupart des gens sont d'accord pour dire que `find` et `fd` sont bons, mais certains d'entre vous peuvent se demander s'il est plus efficace de chercher des fichiers à chaque fois que de compiler une sorte d'index ou de base de données pour une recherche rapide.
C'est à cela que sert [`locate`](https://www.man7.org/linux/man-pages/man1/locate.1.html).
`locate` utilise une base de données qui est mise à jour en utilisant [`updatedb`](https://www.man7.org/linux/man-pages/man1/updatedb.1.html).
Dans la plupart des systèmes, `updatedb` est mis à jour quotidiennement via [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html).
Par conséquent, l'un des compromis entre les deux est la rapidité contre la fraicheur des données.
De plus, `find` et les outils similaires peuvent également trouver des fichiers en utilisant des attributs tels que la taille du fichier, la date de modification, ou les permissions du fichier, alors que `locate` n'utilise que le nom du fichier.
Une comparaison plus approfondie peut être trouvée [ici](https://unix.stackexchange.com/questions/60205/locate-vs-find-usage-pros-and-cons-of-each-other).

## Recherche de code

La recherche de fichiers par leur nom est utile, mais il arrive souvent que vous souhaitiez effectuer une recherche basée sur le *contenu* du fichier. 
Un scénario courant consiste à rechercher tous les fichiers qui contiennent un certain pattern, ainsi que l'emplacement de ce pattern dans ces fichiers.
Pour ce faire, la plupart des systèmes de type UNIX fournissent [`grep`](https://www.man7.org/linux/man-pages/man1/grep.1.html), un outil générique pour faire correspondre des patterns à partir d'un texte d'entrée.
`grep` est un outil shell incroyablement précieux que nous aborderons plus en détail lors de la leçon sur le traitement des données.

Pour l'instant, sachez que `grep` possède de nombreux flags qui en font un outil très polyvalent.
Certains que j'utilise fréquemment sont `-C` pour obtenir le **C**ontexte autour de la ligne correspondante et `-v` pour in**v**erser la correspondance, c'est-à-dire afficher toutes les lignes qui ne **corresponde pas** au pattern. Par exemple, `grep -C 5` affichera 5 lignes avant et après la correspondance.
Quand il s'agit de rechercher rapidement dans de nombreux fichiers, vous voudrez utiliser `-R` puisqu'il va **R**ecursivement dans les répertoires et chercher les fichiers pour la chaîne de caractères correspondante.

Mais `grep -R` peut être amélioré de nombreuses façons, comme ignorer les dossiers `.git`, utiliser le support multi CPU, etc.
De nombreuses alternatives à `grep` ont été développées, dont [ack](https://github.com/beyondgrep/ack3), [ag](https://github.com/ggreer/the_silver_searcher) et [rg](https://github.com/BurntSushi/ripgrep).
Toutes sont fantastiques et fournissent à peu près les mêmes fonctionnalités.
Pour l'instant, je m'en tiens à ripgrep (`rg`), en raison de sa rapidité et de son intuitivité. Quelques exemples :
```bash
# Trouver tous les fichiers python où j'ai utilisé la librairie requests
rg -t py 'import requests'
# Trouver tous les fichiers (y compris les fichiers cachés) sans ligne shebang
rg -u --files-without-match "^#\!"
# Trouver toutes les correspondances de foo et imprimer les 5 lignes suivantes
rg foo -A 5
# Imprimer les statistiques des correspondances (nombre de lignes et de fichiers correspondants)
rg --stats PATTERN
```

Notez que, comme pour `find`/`fd`, il est important que vous sachiez que ces problèmes peuvent être rapidement résolus en utilisant l'un de ces outils, alors que les outils spécifiques que vous utilisez ne sont pas aussi importants.
## Recherche de commandes shell

Jusqu'à présent, nous avons vu comment trouver des fichiers et du code, mais lorsque vous passerez plus de temps dans l'interpréteur de commandes, vous voudrez peut-être retrouver des commandes spécifiques que vous avez tapées à un moment donné.
La première chose à savoir est qu'en tapant la flèche vers le haut, vous retrouverez votre dernière commande, et si vous continuez à appuyer sur cette flèche, vous parcourrez lentement l'historique de l'interpréteur de commandes.

La commande `history` vous permet d'accéder à l'historique de votre shell de manière programmatique.
Elle affichera l'historique de votre shell sur la sortie standard.
Si nous voulons y faire des recherches, nous pouvons diriger cette sortie vers `grep` et rechercher des patterns.
`history | grep find` affichera les commandes qui contiennent la sous-chaîne "find".

Dans la plupart des shells, vous pouvez utiliser `Ctrl+R` pour effectuer une recherche dans votre historique.
Après avoir appuyé sur `Ctrl+R`, vous pouvez taper une chaîne de caractères que vous voulez faire correspondre aux commandes de votre historique.
En continuant d'appuyer sur cette touche, vous ferez défiler les correspondances dans votre historique.
Ceci peut également être activé avec les flèches UP/DOWN dans [zsh](https://github.com/zsh-users/zsh-history-substring-search).
Un ajout intéressant à `Ctrl+R` est l'utilisation des liens [fzf](https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#ctrl-r).
`fzf` est un outil de recherche à usage général qui peut être utilisé avec de nombreuses commandes.
Ici, il est utilisé pour faire des recherches dans votre historique et présenter les résultats d'une manière pratique et agréable à l'œil.

Les **autosuggestions basées sur l'historique** sont une autre astuce liée à l'histoire que j'apprécie particulièrement.
Introduite pour la première fois par [fish](https://fishshell.com/) shell, cette fonctionnalité autocomplète dynamiquement la commande courante de l'interpréteur de commandes avec la commande la plus récente que vous avez tapée et qui partage un préfixe commun avec elle.
Elle peut être activée dans [zsh](https://github.com/zsh-users/zsh-autosuggestions) et constitue un excellent moyen d'améliorer l'expérience utilisateur de votre interpréteur de commandes.

Vous pouvez modifier le comportement de l'historique de votre interpréteur de commandes, en empêchant par exemple les commandes comportant un espace en début de ligne d'être incluses. C'est très pratique lorsque vous tapez des commandes contenant des mots de passe ou d'autres informations sensibles.
Pour ce faire, ajoutez `HISTCONTROL=ignorespace` à votre `.bashrc` ou `setopt HIST_IGNORE_SPACE` à votre `.zshrc`.
Si vous faites l'erreur de ne pas ajouter l'espace, vous pouvez toujours supprimer manuellement l'entrée en éditant votre `.bash_history` ou `.zsh_history`.

## Navigation dans les répertoires

Jusque là, nous avons supposé que vous étiez déjà à l'endroit où vous deviez être pour effectuer ces actions. Mais comment faire pour naviguer rapidement dans les répertoires ?
Il existe de nombreuses méthodes simples pour y parvenir, telles que l'écriture d'alias dans l'interpréteur de commandes ou la création de liens symboliques avec [ln -s](https://www.man7.org/linux/man-pages/man1/ln.1.html), mais la vérité est que les développeurs ont déjà trouvé des solutions assez intelligentes et sophistiquées.

Comme pour le thème de ce cours, il est souvent préférable d'optimiser pour les cas les plus courants.
La recherche de fichiers et de répertoires fréquents et/ou récents peut être effectuée à l'aide d'outils tels que [`fasd`](https://github.com/clvv/fasd) et [`autojump`](https://github.com/wting/autojump).
Fasd classe les fichiers et les répertoires par [_frecency_](https://web.archive.org/web/20210421120120/https://developer.mozilla.org/en-US/docs/Mozilla/Tech/Places/Frecency_algorithm), c'est-à-dire à la fois par _frequency_ et _recency_.
Par défaut, `fasd` ajoute une commande `z` que vous pouvez utiliser pour accélérer `cd` en utilisant une sous-chaîne d'un répertoire _frecent_. Par exemple, si vous allez souvent dans `/home/user/files/cool_project`, vous pouvez simplement utiliser `z cool` pour y aller. En utilisant autojump, ce même changement de répertoire pourrait être réalisé en utilisant `j cool`.

Des outils plus complexes existent pour obtenir rapidement une vue d'ensemble de la structure d'un répertoire : [`tree`](https://linux.die.net/man/1/tree), [`broot`](https://github.com/Canop/broot) ou même des gestionnaires de fichiers à part entière comme [`nnn`](https://github.com/jarun/nnn) ou [`ranger`](https://github.com/ranger/ranger).

# Exercises

1. Lisez [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) et écrivez une commande `ls` qui liste les fichiers de la manière suivante

    - Inclut tous les fichiers, y compris les fichiers cachés
    - Les tailles sont indiquées dans un format facilement lisible (par exemple, 454M au lieu de 454279954).
    - Les fichiers sont classés par ordre de récence
    - La sortie est colorisée

    Voici un exemple de sortie
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

1. Ecrivez les fonctions bash `marco` et `polo` qui font ce qui suit.
Quand vous exécutez `marco`, le répertoire de travail courant doit être sauvegardé d'une manière ou d'une autre, puis quand vous exécutez `polo`, quel que soit le répertoire dans lequel vous êtes, `polo` doit vous `cd` vers le répertoire où vous avez exécuté `marco`.
Pour faciliter le débogage, vous pouvez écrire le code dans un fichier `marco.sh` et (re)charger les définitions dans votre shell en exécutant `source marco.sh`.

{% comment %}
marco() {
    export MARCO=$(pwd)
}

polo() {
    cd "$MARCO"
}
{% endcomment %}

1. Supposons que vous ayez une commande qui échoue rarement. Pour la déboguer, vous devez capturer sa sortie, mais il peut être long d'obtenir une exécution d'échec. Ecrivez un script bash qui exécute le script suivant jusqu'à ce qu'il échoue et capture ses flux de sortie standard et d'erreur dans des fichiers et imprime tout à la fin. Des points bonus si vous pouvez aussi rapporter combien d'exécutions ont été nécessaires pour que le script échoue.
    ```bash
    #!/usr/bin/env bash

    n=$(( RANDOM % 100 ))

    if [[ n -eq 42 ]]; then
       echo "Quelque chose s'est mal passé"
       >&2 echo "L'erreur est due à l'utilisation de nombres magiques"
       exit 1
    fi

    echo "Tout s'est déroulé comme prévu"
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

1. Comme nous l'avons vu dans le cours l'option `-exec` de `find`  peut être très puissant pour effectuer des opérations sur les fichiers que nous recherchons.
Cependant, que faire si nous voulons faire quelque chose avec **tous** les fichiers, comme créer un fichier zip ?
Comme vous l'avez vu jusqu'à présent, les commandes prennent en entrée les arguments et STDIN.
Lorsque nous 'chaînons' (`|`) des commandes, nous connectons STDOUT à STDIN, mais certaines commandes comme `tar` prennent des entrées à partir des arguments.
Pour combler cette lacune, il existe la commande [`xargs`](https://www.man7.org/linux/man-pages/man1/xargs.1.html) qui exécute une commande en utilisant STDIN comme argument.
Par exemple, `ls | xargs rm` effacera les fichiers du répertoire courant.

    Votre tâche est d'écrire une commande qui trouve récursivement tous les fichiers HTML dans le dossier et en fait un fichier zip. Notez que votre commande devrait fonctionner même si les fichiers ont des espaces (indice : regardez le flag `-d` pour `xargs`).
    {% comment %}
    find . -type f -name "*.html" | xargs -d '\n'  tar -cvzf archive.tar.gz
    {% endcomment %}

    Si vous êtes sous macOS, notez que le `find` de BSD par défaut est différent de celui inclus dans [GNU coreutils](https://en.wikipedia.org/wiki/List_of_GNU_Core_Utilities_commands). Vous pouvez utiliser `-print0` sur `find` et le flag `-0` sur `xargs`. En tant qu'utilisateur de macOS, vous devez être conscient que les utilitaires de ligne de commande livrés avec macOS peuvent être différents de leurs équivalents GNU ; vous pouvez installer les versions GNU si vous le souhaitez en utilisant [brew](https://formulae.brew.sh/formula/coreutils).

1. (Avancé) Écrire une commande ou un script pour trouver de manière récursive le fichier le plus récemment modifié dans un répertoire. Plus généralement, pouvez-vous lister tous les fichiers par récence ?
