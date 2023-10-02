---
layout: lecture
title: "Débogage et profilage"
date: 2020-01-23
ready: true
video:
  aspect: 56.25
  id: l812pUnKxME
---

Une règle d'or en programmation est que le code ne fait pas ce que vous attendez de lui, mais ce que vous lui dites de faire. Combler ce fossé peut parfois s'avérer difficile. Dans ce cours, nous allons aborder des techniques utiles pour corriger les bugs et améliorer du code inefficace : le débogage et le profilage.

# Débogage


## Déboguer avec Printf et les logs

"L'outil de débogage le plus efficace reste une réflexion approfondie, associée à des instructions 'print' judicieusement placées" - Brian Kernighan, _Unix for Beginners_.

Une première approche pour déboguer un programme consiste à ajouter des instructions "print" autour de l'endroit où vous avez détecté le problème, et de continuer à itérer jusqu'à ce que vous ayez extrait suffisamment d'informations pour comprendre ce qui est à l'origine du problème.

Une deuxième approche consiste à utiliser des logs dans votre programme, au lieu d'instructions "print" ad hoc. Utiliser des logs est préférable aux instructions "print" classiques pour plusieurs raisons :

- Vous pouvez les enregistrer dans des fichiers, des sockets ou même des serveurs distants au lieu de la sortie standard.
- Les logs supportent des niveaux de gravité (tels que INFO, DEBUG, WARN, ERROR, etc), qui vous permettent de filtrer la sortie en conséquence.
- Pour les nouveaux problèmes, il y a de fortes chances que vos logs contiennent suffisamment d'informations pour détecter ce qui ne va pas.

[Voici](/static/files/logger.py) un exemple de code qui log des messages :

```bash
$ python logger.py
# Sortie brute comme avec uniquement des "print"
$ python logger.py log
# Sortie formatée avec des logs
$ python logger.py log ERROR
# Ne print que les niveaus ERROR ou supérieurs
$ python logger.py color
# Sortie formatée avec des couleurs
```

L'une de mes astuces préférées pour rendre les logs plus lisibles est de leur attribuer un code couleur. Vous avez probablement déjà réalisé que votre terminal utilise des couleurs pour rendre les choses plus lisibles. Mais comment le fait-il ? Des programmes comme `ls` ou `grep` utilisent des [caractères ANSI (escape codes)](https://en.wikipedia.org/wiki/ANSI_escape_code), qui sont des séquences spéciales de caractères indiquant à l'interpréteur de commandes de changer la couleur de la sortie. Par exemple, l'exécution de `echo -e "\e[38;2;255;0;0mCeci est rouge\e[0m"` affiche le message `Ceci est rouge` en rouge dans votre terminal, à condition qu'il prenne en charge [true color](https://github.com/termstandard/colors#truecolor-support-in-output-devices). Si votre terminal ne le supporte pas (par exemple Terminal.app de macOS), vous pouvez utiliser les escape codes plus universellement supportés pour 16 choix de couleurs, par exemple `echo -e "\e[31;1mCeci est rouge\e[0m"`.

Le script suivant montre comment afficher plusieurs couleurs RGB dans votre terminal (à condition qu'il supporte true color).

```bash
#!/usr/bin/env bash
for R in $(seq 0 20 255); do
    for G in $(seq 0 20 255); do
        for B in $(seq 0 20 255); do
            printf "\e[38;2;${R};${G};${B}m█\e[0m";
        done
    done
done
```

# Logs d'applications tierces

Au fur et à mesure que vous construisez des systèmes logiciels plus importants, vous rencontrerez très probablement des dépendances qui s'exécutent en tant que programmes distincts. Les serveurs web, les bases de données ou les messages brokers sont des exemples courants de ce type de dépendances. Lorsque vous interagissez avec ces systèmes, il est souvent nécessaire de lire leurs logs, car les messages d'erreur côté client peuvent ne pas suffire.

Heureusement, la plupart des programmes écrivent leurs propres logs quelque part dans votre système. Dans les systèmes UNIX, il est courant que les programmes écrivent leurs logs dans `/var/log`. Par exemple, le serveur web [NGINX](https://www.nginx.com/) écrit ses logs dans `/var/log/nginx`. Plus récemment, les systèmes ont commencé à utiliser les **logs système**, qui est de plus en plus souvent l'endroit où vont tous les messages de log. La plupart des systèmes Linux (mais pas tous) utilisent `systemd`, un daemon système qui contrôle de nombreux éléments de votre système, tels que quels services sont activés et en cours d'exécution. `systemd` écrit les logs dans `/var/log/journal` dans un format spécial et vous pouvez utiliser la commande [`journalctl`](https://www.man7.org/linux/man-pages/man1/journalctl.1.html) pour afficher les messages. De même, sur macOS, il y a toujours `/var/log/system.log`, mais un nombre croissant d'outils utilisent les logs système, qui peut être affiché avec [`log show`](https://www.manpagez.com/man/1/log/). Sur la plupart des systèmes UNIX, vous pouvez également utiliser la commande [`dmesg`](https://www.man7.org/linux/man-pages/man1/dmesg.1.html) pour accéder aux logs du noyau.

Pour écrire des logs dans les logs système, vous pouvez utiliser le programme shell [`logger`](https://www.man7.org/linux/man-pages/man1/logger.1.html). Voici un exemple d'utilisation de `logger` et de comment vérifier que le log a bien été écrit dans les logs système. De plus, la plupart des langages de programmation ont des "bindings" (sorte de lien qui permet à un language de programmation à communiquer avec un autre service) qui permettent d'écrire des données dans les logs système.

```bash
logger "Hello Logs"
# Sur macOS
log show --last 1m | grep Hello
# Sur Linux
journalctl --since "1m ago" | grep Hello
```

Comme nous l'avons vu dans le cours sur le traitement des données, les logs peuvent être assez verbeux et nécessitent un certain niveau de traitement et de filtrage pour en tirer les informations souhaitées. Si vous vous retrouvez à filtrer lourdement `journalctl` et `log show`, vous pouvez envisager d'utiliser leurs flags, qui peuvent effectuer un premier passage de filtrage de leur sortie. Il existe également des outils comme [`lnav`](http://lnav.org/), qui améliorent la présentation et la navigation dans les fichiers de log.

## Débogueurs

Lorsque le débogage avec printf ne suffit pas, vous devrez utiliser un débogueur. Les débogueurs sont des programmes qui vous permettent d'interagir avec l'exécution d'un programme. Ils permettent :

- d'arrêter l'exécution du programme lorsqu'il atteint une certaine ligne
- de faire avancer le programme une instruction à la fois
- d'inspecter les valeurs des variables après que le programme se soit arrêté.
- d'arrêter l'exécution sous condition qu'une certaine condition donnée soit remplie.
- et bien d'autres fonctionnalités plus avancées

De nombreux langages de programmation sont dotés d'une forme ou d'une autre de débogueur. En Python, il s'agit du débogueur Python [`pdb`](https://docs.python.org/3/library/pdb.html).

Voici une brève description de certaines des commandes que `pdb` prend en charge :

- **l**(ist) - Affiche 11 lignes autour de la ligne actuelle ou continue la liste précédente.
- **s**(tep) - Exécute la ligne actuelle, s'arrête à la première occasion possible.
- **n**(ext) -  Poursuit l'exécution jusqu'à ce que la ligne suivante de la fonction en cours d'exécution soit atteinte ou qu'on arrive à une instruction return.
- **b**(reak) - Définit un point d'arrêt (breakpoint) (en fonction de l'argument fourni).
- **p**(rint) - Évaluer l'expression dans le contexte actuel et afficher sa valeur. Il y a aussi **pp** pour l'afficher en utilisant [`pprint`](https://docs.python.org/3/library/pprint.html) à la place.
- **r**(eturn) - Continue l'exécution jusqu'à ce que la fonction en cours retourne.
- **q**(uit) -  Quitte le débogueur.

Voyons un exemple d'utilisation de `pdb` pour corriger le code python bogué suivant. (Voir la vidéo du cours).

```python
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n):
            if arr[j] > arr[j+1]:
                arr[j] = arr[j+1]
                arr[j+1] = arr[j]
    return arr

print(bubble_sort([4, 2, 1, 8, 7, 6]))
```

Notez que puisque Python est un langage interprété, nous pouvons utiliser le shell `pdb` pour exécuter des commandes et des instructions. [`ipdb`](https://pypi.org/project/ipdb/) est un `pdb` amélioré qui utilise le REPL [`IPython`](https://ipython.org) permettant la complétion de tabulation, la coloration syntaxique, de meilleures tracebacks et une meilleure introspection tout en conservant la même interface que le module `pdb`.

Pour de la programmation de plus bas niveau, vous voudrez probablement vous tourner vers [`gdb`](https://www.gnu.org/software/gdb/) (et son amélioration plus intuitive [`pwndbg`](https://github.com/pwndbg/pwndbg)) et [`lldb`](https://lldb.llvm.org/). Ils sont optimisés pour le débogage en langage C mais vous permettront de sonder à peu près n'importe quel processus et d'obtenir son état actuel : registres, pile, compteur de programme, etc.


## Outils spécialisés

Même si ce que vous essayez de déboguer est une boîte noire binaire, il existe des outils qui peuvent vous aider. Lorsque des programmes doivent effectuer des actions que seul le noyau peut réaliser, ils utilisent des [appels système](https://en.wikipedia.org/wiki/System_call). Il existe des commandes qui vous permettent de tracer les appels système effectués par votre programme. Sous Linux, il existe [`strace`](https://www.man7.org/linux/man-pages/man1/strace.1.html) et macOS et BSD possèdent [`dtrace`](http://dtrace.org/blogs/about/). `dtrace` peut être difficile à utiliser parce qu'il utilise son propre langage `D`, mais il existe un wrapper appelé [`dtruss`](https://www.manpagez.com/man/1/dtruss/) qui fournit une interface plus similaire à `strace` (plus de détails [ici](https://8thlight.com/blog/colin-jones/2015/11/06/dtrace-even-better-than-strace-for-osx.html)).

Voici quelques exemples d'utilisation de `strace` ou de `dtruss` pour afficher les traces des appels de système à [`stat`](https://www.man7.org/linux/man-pages/man2/stat.2.html) pour une exécution de `ls`. Pour une plongée plus profonde dans `strace`, [cet article](https://blogs.oracle.com/linux/strace-the-sysadmins-microscope-v2) et [ce fanzine](https://jvns.ca/strace-zine-unfolded.pdf) sont de bonnes lectures.

```bash
# Sur Linux
sudo strace -e lstat ls -l > /dev/null
# Sur macOS
sudo dtruss -t lstat64_extended ls -l > /dev/null
```

Dans certaines circonstances, il peut être nécessaire d'examiner les paquets réseau pour trouver le problème dans votre programme. Des outils comme [`tcpdump`](https://www.man7.org/linux/man-pages/man1/tcpdump.1.html) et [Wireshark](https://www.wireshark.org/) sont des analyseurs de paquets réseau qui vous permettent de lire le contenu des paquets réseau et de les filtrer en fonction de différents critères.

Pour le développement web, les outils de développement Chrome/Firefox sont très pratiques. Ils proposent un grand nombre d'outils, notamment :

- Code source - Inspectez le code source HTML/CSS/JS de n'importe quel site web.
- Modification HTML, CSS, JS en direct - Modifiez le contenu, les styles et le comportement du site web pour le tester (vous pouvez constater par vous-même que les captures d'écran de sites web ne sont pas des preuves valables).
- Shell javascript - Exécutez des commandes dans le JS REPL.
- Réseau - Analysez la chronologie des requêtes.
- Stockage - Examinez les cookies et le stockage local de l'application.

## Analyse statique

Pour certains problèmes, il n'est pas nécessaire d'exécuter du code. Par exemple, en examinant attentivement un morceau de code, vous pouvez vous rendre compte que votre variable de boucle cache une variable déjà existante ou un nom de fonction, ou qu'un programme lit une variable avant de la définir. C'est là que les outils [d'analyse statique](https://en.wikipedia.org/wiki/Static_program_analysis) entrent en jeu. Les programmes d'analyse statique prennent le code source en entrée et l'analysent à l'aide de règles prédéfinies pour en déterminer l'exactitude.

L'extrait Python suivant contient plusieurs erreurs. Tout d'abord, notre variable de boucle `foo` cache la définition précédente de la fonction `foo`. Nous avons également écrit `baz` au lieu de `bar` dans la dernière ligne, de sorte que le programme crashera après avoir effectué l'appel à `sleep` (qui prendra une minute).

```python
import time

def foo():
    return 42

for foo in range(5):
    print(foo)
bar = 1
bar *= 0.2
time.sleep(60)
print(baz)
```

Les outils d'analyse statique peuvent identifier ce type de problèmes. Lorsque nous exécutons [`pyflakes`](https://pypi.org/project/pyflakes) sur le code, nous obtenons les erreurs liées aux deux bugs. [`mypy`](http://mypy-lang.org/) est un autre outil qui peut détecter les problèmes de vérification de type. Ici, `mypy` nous avertira que `bar` est initialement un `int` et qu'il est ensuite casté en `float`. Encore une fois, notez que tous ces problèmes ont été détectés sans avoir à exécuter le code.

```bash
$ pyflakes foobar.py
foobar.py:6: redefinition of unused 'foo' from line 3
foobar.py:11: undefined name 'baz'

$ mypy foobar.py
foobar.py:6: error: Incompatible types in assignment (expression has type "int", variable has type "Callable[[], Any]")
foobar.py:9: error: Incompatible types in assignment (expression has type "float", variable has type "int")
foobar.py:11: error: Name 'baz' is not defined
Found 3 errors in 1 file (checked 1 source file)
```

Dans le cours sur les outils du shell, nous avons abordé [`shellcheck`](https://www.shellcheck.net/), qui est un outil similaire pour les scripts shell.

La plupart des éditeurs et des IDE permettent d'afficher la sortie de ces outils dans l'éditeur lui-même, en mettant en évidence l'emplacement des avertissements et des erreurs. C'est ce que l'on appelle souvent le **code linting** et il peut également être utilisé pour afficher d'autres types de problèmes tels que les violations de style ou les constructions insécurisées.

Dans Vim, les plugins [`ale`](https://vimawesome.com/plugin/ale) ou [`syntastic`](https://vimawesome.com/plugin/syntastic) vous permettront de le faire. Pour Python, [`pylint`](https://github.com/PyCQA/pylint) et [`pep8`](https://pypi.org/project/pep8/) sont des exemples de linters stylistiques et [`bandit`](https://pypi.org/project/bandit/) est un outil conçu pour trouver les problèmes de sécurité courants. Pour d'autres langages, des personnes ont rassemblé des listes complètes d'outils d'analyse statique utiles, comme [Awesome Static Analysis](https://github.com/mre/awesome-static-analysis) (vous pouvez jeter un coup d'oeil à la section _Writing_) et pour les linters, il existe [Awesome Linters](https://github.com/caramelomartins/awesome-linters).

Un outil complémentaire à l'analyse stylistique sont les formateurs de code, tel que [`black`](https://github.com/psf/black) pour Python, `gofmt` pour Go, `rustfmt` pour Rust ou [`prettier`](https://prettier.io/) pour JavaScript, HTML et CSS. Ces outils autoformatent votre code de manière à ce qu'il soit cohérent avec les modèles stylistiques courants pour le langage de programmation en question. Même si vous n'êtes pas disposé à donner le contrôle stylistique de votre code, la normalisation du format du code aidera les autres à lire votre code et vous permettra de mieux lire le code des autres (normalisé sur le plan stylistique).

# Profilage

Même si votre code se comporte fonctionnellement comme vous l'attendez, ce n'est peut-être pas suffisant s'il utilise tout votre CPU ou votre mémoire lors de son exécution. Les cours d'algorithmique enseignent souvent la notation big _O_, mais pas la manière de trouver les points sensibles dans vos programmes. [L'optimisation prématurée étant la racine de tous les maux](http://wiki.c2.com/?PrematureOptimization), vous devriez vous familiariser avec les profileurs et les outils de monitoring. Ils vous aideront à comprendre quelles parties de votre programme prennent le plus de temps et/ou de ressources afin que vous puissiez vous concentrer sur l'optimisation de ces parties.


## Timing

Comme dans le cas du débogage, dans de nombreux scénarios, il peut suffire d'imprimer le temps que votre code a mis entre deux points. Voici un exemple en Python utilisant le module [`time`](https://docs.python.org/3/library/time.html).

```python
import time, random
n = random.randint(1, 10) * 100

# Get current time
start = time.time()

# Do some work
print("Sleeping for {} ms".format(n))
time.sleep(n/1000)

# Compute time between start and now
print(time.time() - start)

# Output
# Sleeping for 500 ms
# 0.5713930130004883
```

Cependant, le temps calculé par le programme peut être trompeur car votre ordinateur peut exécuter d'autres processus en même temps ou attendre que des événements se produisent. Il est courant que les outils fassent une distinction entre le temps _réel_ (Real), le temps _utilisateur_ (User) et le temps _système_ (Sys). En général, _User_ + _Sys_ vous indique combien de temps votre processus a réellement passé dans le CPU (explication plus détaillée [ici](https://stackoverflow.com/questions/556405/what-do-real-user-and-sys-mean-in-the-output-of-time1)).

- _Real_ - Temps écoulé du début à la fin du programme, y compris le temps pris par d'autres processus et le temps bloqué (par exemple, attente d'I/O ou de réseau).
- _User_ - Temps passé par le CPU à exécuter du code utilisateur.
- _Sys_ - Temps passé par le CPU à exécuter du code noyau.

Par exemple, essayez d'exécuter une commande qui effectue une requête HTTP et rajouter [`time`](https://www.man7.org/linux/man-pages/man1/time.1.html) devant. Si vous disposez d'une connexion lente, vous obtiendrez peut-être un résultat comme celui présenté ci-dessous. Ici, la requête a mis plus de 2 secondes à se terminer, mais le processus n'a pris que 15 ms de temps utilisateur sur le CPU et 12 ms de temps CPU sur le noyau.

```bash
$ time curl https://missing.csail.mit.edu &> /dev/null
real    0m2.561s
user    0m0.015s
sys     0m0.012s
```

## Profileurs

### CPU

La plupart du temps, lorsque l'on parle de _profileurs_, il s'agit en fait de _profileurs de CPU_, qui sont les plus courants. Il existe deux types principaux de profileurs de CPU : les profileurs de _trace_ et les profileurs d'_échantillonnage_. Les profileurs de trace enregistrent chaque appel de fonction effectué par votre programme, tandis que les profileurs d'échantillonnage sondent votre programme périodiquement (généralement toutes les millisecondes) et enregistrent la pile (stack) du programme. Ils utilisent ces enregistrements pour présenter des statistiques globales sur ce que votre programme a passé le plus de temps à faire. [Voici](https://jvns.ca/blog/2017/12/17/how-do-ruby---python-profilers-work-) un bon article d'introduction si vous voulez plus de détails sur ce sujet.

La plupart des langages de programmation disposent d'une sorte de profileur en ligne de commande que vous pouvez utiliser pour analyser votre code. Ils s'intègrent souvent à des IDE complets, mais pour ce cours, nous allons nous concentrer sur les outils en ligne de commande.

En Python, nous pouvons utiliser le module `cProfile` pour profiler le temps par appel de fonction. Voici un exemple simple qui implémente un grep rudimentaire en Python :

```python
#!/usr/bin/env python

import sys, re

def grep(pattern, file):
    with open(file, 'r') as f:
        print(file)
        for i, line in enumerate(f.readlines()):
            pattern = re.compile(pattern)
            match = pattern.search(line)
            if match is not None:
                print("{}: {}".format(i, line), end="")

if __name__ == '__main__':
    times = int(sys.argv[1])
    pattern = sys.argv[2]
    for i in range(times):
        for file in sys.argv[3:]:
            grep(pattern, file)
```

Nous pouvons profiler ce code en utilisant la commande suivante. En analysant la sortie, nous pouvons voir que l'IO prend la plupart du temps et que la compilation de la regex prend également beaucoup de temps. Puisque la regex ne doit être compilée qu'une seule fois, nous pouvons l'exclure du for.

```
$ python -m cProfile -s tottime grep.py 1000 '^(import|\s*def)[^,]*$' *.py

[omitted program output]

 ncalls  tottime  percall  cumtime  percall filename:lineno(function)
     8000    0.266    0.000    0.292    0.000 {built-in method io.open}
     8000    0.153    0.000    0.894    0.000 grep.py:5(grep)
    17000    0.101    0.000    0.101    0.000 {built-in method builtins.print}
     8000    0.100    0.000    0.129    0.000 {method 'readlines' of '_io._IOBase' objects}
    93000    0.097    0.000    0.111    0.000 re.py:286(_compile)
    93000    0.069    0.000    0.069    0.000 {method 'search' of '_sre.SRE_Pattern' objects}
    93000    0.030    0.000    0.141    0.000 re.py:231(compile)
    17000    0.019    0.000    0.029    0.000 codecs.py:318(decode)
        1    0.017    0.017    0.911    0.911 grep.py:3(<module>)

[omitted lines]
```

Une mise en garde concernant le profileur `cProfile` de Python (et de nombreux profileurs d'ailleurs) est qu'ils affichent le temps par appel de fonction. Cela peut vite devenir non intuitif, surtout si vous utilisez des bibliothèques tierces dans votre code puisque les appels de fonctions internes sont également pris en compte. Une manière plus intuitive d'afficher les informations de profilage est d'inclure le temps pris par ligne de code, ce que font les _profileurs de ligne_ (line profilers).

Par exemple, le morceau de code Python suivant effectue une requête vers le site web du cours et analyse la réponse pour obtenir toutes les URL de la page :

```python
#!/usr/bin/env python
import requests
from bs4 import BeautifulSoup

# This is a decorator that tells line_profiler
# that we want to analyze this function
@profile
def get_urls():
    response = requests.get('https://missing.csail.mit.edu')
    s = BeautifulSoup(response.content, 'lxml')
    urls = []
    for url in s.find_all('a'):
        urls.append(url['href'])

if __name__ == '__main__':
    get_urls()
```

Si nous avions utilisé le profileur `cProfile` de Python, nous obtiendrions plus de 2500 lignes de sortie, et même en les triant, il serait difficile de comprendre où le programme a passé le plus de temps. Une exécution rapide avec [`line_profiler`](https://github.com/pyutils/line_profiler) montre le temps pris par ligne :

```bash
$ kernprof -l -v a.py
Wrote profile results to urls.py.lprof
Timer unit: 1e-06 s

Total time: 0.636188 s
File: a.py
Function: get_urls at line 5

Line #  Hits         Time  Per Hit   % Time  Line Contents
==============================================================
 5                                           @profile
 6                                           def get_urls():
 7         1     613909.0 613909.0     96.5      response = requests.get('https://missing.csail.mit.edu')
 8         1      21559.0  21559.0      3.4      s = BeautifulSoup(response.content, 'lxml')
 9         1          2.0      2.0      0.0      urls = []
10        25        685.0     27.4      0.1      for url in s.find_all('a'):
11        24         33.0      1.4      0.0          urls.append(url['href'])
```

### Mémoire

Dans des langages comme le C ou le C++, les fuites de mémoire peuvent faire en sorte que votre programme ne libère jamais la mémoire dont il n'a plus besoin. Pour vous aider dans le processus de débogage de la mémoire, vous pouvez utiliser des outils comme [Valgrind](https://valgrind.org/) qui vous aideront à identifier les fuites de mémoire.

Dans les langages avec garbage collector comme Python, il est également utile d'utiliser un profileur de mémoire car tant que vous avez des pointeurs sur des objets en mémoire, ils ne seront pas supprimés par le garbage collector. Voici un exemple de programme et sa sortie associée lorsqu'il est exécuté avec [memory-profiler](https://pypi.org/project/memory-profiler/) (notez le décorateur comme dans `line-profiler`).

```python
@profile
def my_func():
    a = [1] * (10 ** 6)
    b = [2] * (2 * 10 ** 7)
    del b
    return a

if __name__ == '__main__':
    my_func()
```

```bash
$ python -m memory_profiler example.py
Line #    Mem usage  Increment   Line Contents
==============================================
     3                           @profile
     4      5.97 MB    0.00 MB   def my_func():
     5     13.61 MB    7.64 MB       a = [1] * (10 ** 6)
     6    166.20 MB  152.59 MB       b = [2] * (2 * 10 ** 7)
     7     13.61 MB -152.59 MB       del b
     8     13.61 MB    0.00 MB       return a
```

### Profilage d'événements

Comme dans le cas de `strace` pour le débogage, vous pouriez vouloir ignorer les spécificités du code que vous exécutez et le traiter comme une boîte noire lors du profilage. La commande [`perf`](https://www.man7.org/linux/man-pages/man1/perf.1.html) fait abstraction des différences entre les CPU et ne rapporte pas le temps ou la mémoire, mais plutôt les événements système liés à vos programmes. Par exemple, `perf` peut facilement signaler une mauvaise utilisation de la localité du cache, un grand nombre de "page faults" ou des "livelocks". Voici un aperçu de la commande :

- `perf list` - Liste les événements qui peuvent être suivis avec perf
- `perf stat COMMAND ARG1 ARG2` - Obtient le compte des différents événements liés à un processus ou à une commande.
- `perf record COMMAND ARG1 ARG2` - Enregistre l'exécution d'une commande et sauvegarde les données statistiques dans un fichier appelé `perf.data`
- `perf report` - Formate et print les données collectées dans `perf.data`

### Visualisation

La sortie du profileur pour des programmes de taille réele contiendra de grandes quantités d'informations en raison de la complexité inhérente aux projets logiciels. Les êtres humains sont des créatures visuelles et ne sont pas très doués pour lire de grandes quantités de chiffres et leur donner un sens. Il existe donc de nombreux outils permettant d'afficher les résultats d'un profileur de manière plus facile à analyser.

Une façon courante d'afficher les informations de profilage du CPU pour les profileurs d'échantillonnage est d'utiliser un [Flame Graph](http://www.brendangregg.com/flamegraphs.html), qui affichera une hiérarchie d'appels de fonctions sur l'axe Y et le temps pris proportionnellement sur l'axe X. Ces graphiques sont également interactifs, vous permettant de zoomer sur les données et d'afficher les résultats. Ils sont également interactifs, vous permettant de zoomer sur des parties spécifiques du programme et d'obtenir leurs stack traces (essayez de cliquer sur l'image ci-dessous).

[![FlameGraph](http://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)](http://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)

Les graphes d'appels (call graphs) ou graphes de flux de contrôle (control flow graphs) affichent les relations entre les sous-programmes d'un programme en incluant les fonctions en tant que noeuds et les appels de fonctions entre eux en tant qu'arêtes dirigées. Associés à des informations de profilage telles que le nombre d'appels et le temps d'exécution, les graphes d'appels peuvent s'avérer très utiles pour interpréter le flux d'un programme. En Python, vous pouvez utiliser la librarie [`pycallgraph`](https://pycallgraph.readthedocs.io/) pour les générer.

![Call Graph](https://upload.wikimedia.org/wikipedia/commons/2/2f/A_Call_Graph_generated_by_pycallgraph.png)

## Monitoring des ressources

Parfois, la première étape de l'analyse des performances de votre programme consiste à comprendre quelle est sa consommation réelle de ressources. Les programmes s'exécutent souvent lentement lorsqu'ils sont limités en ressources, par exemple s'ils n'ont pas assez de mémoire ou si leur connexion réseau est lente. Il existe une myriade d'outils en ligne de commande permettant de sonder et d'afficher les différentes ressources du système, telles que l'utilisation du processeur, de la mémoire, du réseau, du disque, etc.

- **Monitoring général** - Le plus populaire est probablement [`htop`](https://htop.dev/), qui est une version améliorée de [`top`](https://www.man7.org/linux/man-pages/man1/top.1.html). `htop` présente diverses statistiques sur les processus en cours d'exécution sur le système. `htop` dispose d'une myriade d'options et de raccourcis clavier, dont certains sont utiles : `<F6>` pour trier les processus, `t` pour afficher l'arborescence et `h` pour alterner les threads. Voir aussi [`glances`](https://nicolargo.github.io/glances/) pour une implémentation similaire avec une superbe interface utilisateur. Pour obtenir des mesures globales sur l'ensemble des processus, [`dstat`](http://dag.wiee.rs/home-made/dstat/) est un autre outil astucieux qui calcule des mesures de ressources en temps réel pour de nombreux sous-systèmes différents tels que I/O, le réseau, l'utilisation du CPU, les changements de contexte, etc.
- **Opérations I/O** - [`iotop`](https://www.man7.org/linux/man-pages/man8/iotop.8.html) affiche en temps réel des informations sur l'utilisation I/O et permet de vérifier si un processus effectue de nombreuses opérations I/O sur le disque.
- **Utilisation du disque** - [`df`](https://www.man7.org/linux/man-pages/man1/df.1.html) affiche les métriques par partition et [`du`](http://man7.org/linux/man-pages/man1/du.1.html) (**d**isk **u**sage) affiche l'utilisation du disque par fichier pour le répertoire courant. Dans ces outils, le flag `-h` indique au programme d'écrire dans un format lisible par l'**h**omme. Une version plus interactive de `du` est [`ncdu`](https://dev.yorhel.nl/ncdu), qui vous permet de naviguer dans les dossiers et de supprimer des fichiers et des dossiers au fur et à mesure de votre navigation.
- **Utilisation de la mémoire** - [`free`](https://www.man7.org/linux/man-pages/man1/free.1.html) affiche la quantité totale de mémoire libre et utilisée dans le système. La mémoire est également affichée dans des outils tels que `htop`.
- **Fichiers ouverts** - [`lsof`](https://www.man7.org/linux/man-pages/man8/lsof.8.html) répertorie les informations sur les fichiers ouverts par les processus. Il peut être très utile pour vérifier quel processus a ouvert un fichier spécifique.
- **Connexions et configuration réseau** - [`ss`](https://www.man7.org/linux/man-pages/man8/ss.8.html) vous permet de surveiller les statistiques des paquets réseau entrants et sortants, ainsi que les statistiques des interfaces. Un cas d'utilisation courant de `ss` est de savoir quel processus utilise un port donné sur une machine. Pour afficher le routage, les périphériques réseau et les interfaces, vous pouvez utiliser [`ip`](http://man7.org/linux/man-pages/man8/ip.8.html). Notez que `netstat` et `ifconfig` ont été abandonnés au profit des outils précédents.
- **Utilisation du réseau** - [`nethogs`](https://github.com/raboof/nethogs) et [`iftop`](http://www.ex-parrot.com/pdw/iftop/) sont de bons outils interactifs pour monitorer l'utilisation du réseau.

Si vous souhaitez tester ces outils, vous pouvez également imposer des charges artificielles sur la machine à l'aide de la commande [`stress`](https://linux.die.net/man/1/stress).


### Outils spécialisés

Parfois, une analyse comparative "black box" suffit pour déterminer quel logiciel utiliser. Des outils comme [`hyperfine`](https://github.com/sharkdp/hyperfine) vous permettent d'évaluer rapidement les programmes en ligne de commande. Par exemple, dans le cours sur les outils de l'interpréteur de commandes et les scripts, nous avons recommandé `fd` plutôt que `find`. Nous pouvons utiliser `hyperfine` pour les comparer dans des tâches que nous exécutons souvent. Par exemple, dans l'exemple ci-dessous, `fd` était 20 fois plus rapide que `find` sur ma machine.

```bash
$ hyperfine --warmup 3 'fd -e jpg' 'find . -iname "*.jpg"'
Benchmark #1: fd -e jpg
  Time (mean ± σ):      51.4 ms ±   2.9 ms    [User: 121.0 ms, System: 160.5 ms]
  Range (min … max):    44.2 ms …  60.1 ms    56 runs

Benchmark #2: find . -iname "*.jpg"
  Time (mean ± σ):      1.126 s ±  0.101 s    [User: 141.1 ms, System: 956.1 ms]
  Range (min … max):    0.975 s …  1.287 s    10 runs

Summary
  'fd -e jpg' ran
   21.89 ± 2.33 times faster than 'find . -iname "*.jpg"'
```

Comme c'était le cas pour le débogage, les navigateurs sont également dotés d'un ensemble d'outils fantastiques pour profiler le chargement des pages web, ce qui vous permet de déterminer où le plus de temps est passé (chargement, rendu, scripts, etc). Plus d'informations pour [Firefox](https://profiler.firefox.com/docs/) et [Chrome](https://developers.google.com/web/tools/chrome-devtools/rendering-tools).

# Exercices


## Débogage

1. Utilisez `journalctl` sous Linux ou `log show` sous macOS pour obtenir les accès et commandes du super utilisateur au cours des dernières 24H. S'il n'y en a pas, vous pouvez exécuter des commandes inoffensives telles que `sudo ls` et vérifier à nouveau.

1. Faites [ce tutoriel](https://github.com/spiside/pdb-tutorial) pratique sur `pdb` pour vous familiariser avec les commandes. Pour un tutoriel plus approfondi, lisez [ceci](https://realpython.com/python-debugging-pdb).

1. Installez [`shellcheck`](https://www.shellcheck.net/) et essayez de vérifier le script suivant. Qu'est-ce qui ne va pas dans le code ? Corrigez-le. Installez un plugin linter dans votre éditeur afin d'obtenir des avertissements automatiquement.
    ```bash
   #!/bin/sh
   ## Example: a typical script with several problems
   for f in $(ls *.m3u)
   do
     grep -qi hq.*mp3 $f \
       && echo -e 'Playlist $f contains a HQ file in mp3 format'
   done
   ```

1. (Avancé) Lisez ceci sur le [débogage réversible](https://undo.io/resources/reverse-debugging-whitepaper/) et faites fonctionner un exemple simple en utilisant [`rr`](https://rr-project.org/) ou [`RevPDB`](https://morepypy.blogspot.com/2016/07/reverse-debugging-for-python.html).

## Profilage

1. [Voici](/static/files/sorts.py) quelques implémentations d'algorithmes de tri. Utilisez [`cProfile`](https://docs.python.org/3/library/profile.html) et [`line_profiler`](https://github.com/pyutils/line_profiler) pour comparer la durée d'exécution du tri par insertion et du tri sélectif. Quel est le bottleneck de chaque algorithme ? Utilisez ensuite `memory_profiler` pour vérifier la consommation de mémoire, pourquoi le tri par insertion est-il meilleur ? Vérifiez maintenant la version en place de quicksort. Défi : Utilisez `perf` pour regarder le nombre de cycles et les cache hits et cache misses de chaque algorithme.

1. Voici un code Python (sans doute alambiqué) pour calculer les nombres de Fibonacci à l'aide d'une fonction pour chaque nombre.

    ```python
   #!/usr/bin/env python
   def fib0(): return 0

   def fib1(): return 1

   s = """def fib{}(): return fib{}() + fib{}()"""

   if __name__ == '__main__':

       for n in range(2, 10):
           exec(s.format(n, n-1, n-2))
       # from functools import lru_cache
       # for n in range(10):
       #     exec("fib{} = lru_cache(1)(fib{})".format(n, n))
       print(eval("fib9()"))
   ```

    Mettez le code dans un fichier et rendez-le exécutable. Installez les prérequis : [`pycallgraph`](https://pycallgraph.readthedocs.io/) et [`graphviz`](http://graphviz.org/) (si vous pouvez exécuter `dot`, vous avez déjà GraphViz). Exécutez le code tel quel avec `pycallgraph graphviz -- ./fib.py` et regardez le fichier `pycallgraph.png`. Combien de fois `fib0` est-il appelé ? Nous pouvons faire mieux que cela en mémorisant les fonctions. Décommentez les lignes commentées et régénérez les images. Combien de fois appelons-nous chaque fonction `fibN` maintenant ?

1. Un problème courant est qu'un port que vous souhaitez écouter est déjà occupé par un autre processus. Apprenons à découvrir le pid de ce processus. Exécutez d'abord `python -m http.server 4444` pour démarrer un serveur web minimal écoutant sur le port `4444`. Dans un autre terminal, exécutez `lsof | grep LISTEN` pour afficher tous les processus et ports en écoute. Trouvez le pid de ce processus et mettez-y fin en exécutant `kill <PID>`.

1. Limiter les ressources d'un processus peut être un autre outil pratique dans votre boîte à outils. Essayez d'exécuter `stress -c 3` et regardez la consommation du processeur avec `htop`. Maintenant, exécutez `taskset --cpu-list 0,2 stress -c 3` et regardez la consommation à nouveau. Est-ce que `stress` utilise trois CPU ? Pourquoi ? Lisez [`man taskset`](https://www.man7.org/linux/man-pages/man1/taskset.1.html). Défi : réaliser la même chose en utilisant [`cgroups`](https://www.man7.org/linux/man-pages/man7/cgroups.7.html). Essayez de limiter la consommation de mémoire de `stress -m`.

1. (Avancé) La commande `curl ipinfo.io` effectue une requête HTTP et récupère des informations sur votre IP publique. Ouvrez [Wireshark](https://www.wireshark.org/) et essayez de sniffer les paquets de requête et de réponse que `curl` a envoyés et reçus. (Conseil : utilisez le filtre `http` pour ne regarder que les paquets HTTP).
