---
layout: lecture
title: "Metaprogramming"
details: build systems, dependency management, testing, CI
date: 2020-01-27
ready: true
video:
  aspect: 56.25
  id: _Ms1Z4xfqv4
---

Qu'entendons-nous par "metaprogramming" ? C'est le meilleur terme global que nous ayons trouvé pour désigner l'ensemble des choses qui relèvent davantage du _processus_ que de l'écriture de code ou d'un travail plus efficace. Dans ce cours, nous examinerons les systèmes pour build et tester votre code, ainsi que la gestion des dépendances. Ces éléments peuvent sembler avoir une importance limitée dans votre quotidien d'étudiant, mais dès que vous interagirez avec une base de code plus importante dans le cadre d'un stage ou une fois que vous entrerez dans le "monde réel", vous les verrez partout. Il convient de noter que "metaprogramming" peut également signifier "[programmes qui opèrent sur des programmes](https://en.wikipedia.org/wiki/Metaprogramming)", bien que ce ne soit pas tout à fait la définition que nous utilisons dans le cadre de ce cours.

# Build systems

Si vous écrivez un article en LaTeX, quelles sont les commandes que vous devez exécuter pour produire votre article ? Qu'en est-il de celles utilisées pour exécuter vos benchmarks, tracer un graphique, puis insérer ce graphique dans votre document ? Ou pour compiler le code fourni dans le cours que vous suivez et ensuite exécuter les tests ?

Pour la plupart des projets, qu'ils contiennent du code ou non, il existe un "processus de construction" (build process). Il s'agit d'une séquence d'opérations que vous devez effectuer pour passer de vos entrées à vos sorties. Souvent, ce processus peut comporter de nombreuses étapes et de nombreuses branches. Exécutez ceci pour générer ce graphique, cela pour générer ces résultats, et autre chose pour produire le document final. Comme pour beaucoup de choses que nous avons vues dans ce cours, vous n'êtes pas le premier à rencontrer ce problème, et heureusement, il existe de nombreux outils pour vous aider !

Ces outils sont généralement appelés "build systems", et il en existe de _nombreux_. Celui que vous utiliserez dépendra de la tâche à accomplir, de votre langue de prédilection et de la taille du projet. Au fond, ils sont tous très similaires. Vous définissez un certain nombre de _dépendances_, un certain nombre de _cibles_, et des _règles_ pour passer de l'une à l'autre. Vous dites au build system que vous voulez une cible particulière, et son travail consiste à trouver toutes les dépendances pour cette cible, puis à appliquer les règles pour produire des cibles intermédiaires jusqu'à ce que la cible finale ait été produite. Idéalement, le build system fait cela sans exécuter inutilement des règles pour des cibles dont les dépendances n'ont pas changé et dont le résultat est disponible depuis une compilation précédente.

`make` est l'un des build system les plus courants, et vous le trouverez généralement installé sur presque tous les ordinateurs UNIX. Il a ses défauts, mais fonctionne assez bien pour les projets simples à moyens. Lorsque vous lancez `make`, il consulte un fichier appelé `Makefile` dans le répertoire courant. Toutes les cibles, leurs dépendances et les règles sont définies dans ce fichier. Jetons un coup d'oeil à un de ces fichiers :

```make
paper.pdf: paper.tex plot-data.png
	pdflatex paper.tex

plot-%.png: %.dat plot.py
	./plot.py -i $*.dat -o $@
```

Chaque directive de ce fichier est une règle permettant de produire le côté gauche en utilisant le côté droit. En d'autres termes, les éléments nommés dans la partie droite sont des dépendances, et la partie gauche est la cible. Le bloc indenté est une séquence de programmes permettant de produire la cible à partir de ces dépendances. Dans `make`, la première directive définit également l'objectif par défaut. Si vous exécutez `make` sans arguments, c'est la cible qu'il construira. Sinon, vous pouvez exécuter quelque chose comme `make plot-data.png`, et il construira cette cible à la place.

Le `%` dans une règle est un "pattern", et correspondra à la même chaîne de caractères à gauche et à droite. Par exemple, si la cible `plot-foo.png` est demandée, `make` cherchera les dépendances `foo.dat` et `plot.py`. Voyons maintenant ce qui se passe si nous lançons `make` avec un répertoire source vide.

```console
$ make
make: *** No rule to make target 'paper.tex', needed by 'paper.pdf'.  Stop.
```

`make` nous dit que pour construire `paper.pdf`, il a besoin de `paper.tex`, et qu'il n'a pas de règle lui indiquant comment créer ce fichier. Essayons de le créer !

```console
$ touch paper.tex
$ make
make: *** No rule to make target 'plot-data.png', needed by 'paper.pdf'.  Stop.
```

Hmm, intéressant, il y a _bien_ une règle pour faire `plot-data.png`, mais c'est une règle de type pattern. Puisque les fichiers sources n'existent pas (`data.dat`), `make` déclare simplement qu'il ne peut pas créer ce fichier. Essayons de créer tous les fichiers :

```console
$ cat paper.tex
\documentclass{article}
\usepackage{graphicx}
\begin{document}
\includegraphics[scale=0.65]{plot-data.png}
\end{document}
$ cat plot.py
#!/usr/bin/env python
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-i', type=argparse.FileType('r'))
parser.add_argument('-o')
args = parser.parse_args()

data = np.loadtxt(args.i)
plt.plot(data[:, 0], data[:, 1])
plt.savefig(args.o)
$ cat data.dat
1 1
2 2
3 3
4 4
5 8
```

Que se passe-t-il maintenant si nous lançons `make` ?

```console
$ make
./plot.py -i data.dat -o plot-data.png
pdflatex paper.tex
... lots of output ...
```

Et regardez, il a créé un PDF pour nous ! Et si nous lancions à nouveau `make` ?

```console
$ make
make: 'paper.pdf' is up to date.
```

Il n'a rien fait ! Pourquoi ? Eh bien, parce qu'il n'en avait pas besoin. Il a vérifié que toutes les cibles précédemment construites étaient toujours à jour en ce qui concerne leurs dépendances listées. Nous pouvons tester cela en modifiant `paper.tex` et en relançant `make` :

```console
$ vim paper.tex
$ make
pdflatex paper.tex
...
```
Notez que `make` n'a pas relancé `plot.py` car ce n'était pas nécessaire ; aucune des dépendances de `plot-data.png` n'a changé !

# Gestion des dépendances

À un niveau plus macro, vos projets logiciels sont susceptibles d'avoir des dépendances qui sont elles-mêmes des projets. Vous pouriez dépendre de programmes installés (comme `python`), de packages système (comme `openssl`) ou de librairies dans votre langage de programmation (comme `matplotlib`). De nos jours, la plupart des dépendances sont disponibles par l'intermédiaire d'un _repository_ (dépôt) qui héberge un grand nombre de ces dépendances en un seul endroit et fournit un mécanisme pratique pour les installer. Parmi les exemples, citons les "Ubuntu package repositories" pour les packages système Ubuntu, auxquels vous accédez via l'outil `apt`, RubyGems pour les librairies Ruby, PyPi pour les librairies Python, ou l'Arch User Repository pour les packages contribués par les utilisateurs d'Arch Linux.

Comme les mécanismes exacts d'interaction avec ces repositories varient beaucoup d'un repository à l'autre et d'un outil à l'autre, nous n'entrerons pas trop dans les détails d'aucun d'entre eux dans ce cours. Ce que nous _allons_ aborder, c'est une partie de la terminologie commune qu'ils utilisent tous. Le premier d'entre eux est le _versioning_. La plupart des projets dont dépendent d'autres projets publient un _numéro de version_ à chaque sortie. Il s'agit généralement de quelque chose comme 8.1.3 ou 64.1.20192004. Il s'agit souvent, mais pas toujours, d'un numéro. Les numéros de version ont de nombreuses fonctions, l'une des plus importantes étant de s'assurer que le logiciel continue de fonctionner. Imaginons, par exemple, que je publie une nouvelle version de ma librairie dans laquelle j'ai renommé une fonction particulière. Si quelqu'un essaie de créer un logiciel qui dépend de ma librairie après la publication de cette mise à jour, la création risque d'échouer parce qu'elle fait appel à une fonction qui n'existe plus ! Le versioning tente de résoudre ce problème en permettant à un projet de dire qu'il dépend d'une version particulière, ou d'une série de versions, d'un autre projet. Ainsi, même si la librairie sous-jacente change, le logiciel dépendant continue à fonctionner en utilisant une version plus ancienne de ma librairie.

Mais ce n'est pas non plus la solution idéale ! Que se passe-t-il si je publie une mise à jour de sécurité qui ne modifie _pas_ l'interface publique de ma librairie (son "API"), et que tout projet dépendant de l'ancienne version doit immédiatement commencer à utiliser ? C'est là qu'interviennent les différents groupes de chiffres d'une version. La signification exacte de chacun varie d'un projet à l'autre, mais une norme relativement commune est le [_semantic
versioning_](https://semver.org/). Avec le versioning sémantique, chaque numéro de version est de la forme : major.minor.patch. Les règles sont les suivantes :

- Si une nouvelle version ne modifie pas l'API, augmentez la version du patch.
- Si vous ajoutez des éléments à votre API de manière rétrocompatible, augmentez la version minor.
- Si vous modifiez l'API d'une manière non rétrocompatible, augmentez la version major.

Cela présente déjà des avantages majeurs. Maintenant, si mon projet dépend de votre projet, il _devrait_ fonctionner en utilisant la dernière version avec la même version majeure que celle sur laquelle je l'ai construit quand je l'ai développé, tant que sa version mineure est au moins ce qu'elle était à l'époque. En d'autres termes, si je dépends de votre librairie à la version `1.3.7`, il ne _devrait_ pas y avoir de problème à la construire avec `1.3.8`, `1.6.1`, ou même `1.3.0`. La version `2.2.4` ne conviendrait probablement pas, car la version majeure a été augmentée. Les numéros de version de Python sont un exemple de versioning sémantique. Beaucoup d'entre vous savent probablement que les codes Python 2 et Python 3 ne se mélangent pas très bien, c'est pourquoi il y a eu une augmentation de la version _majeure_. De même, le code écrit pour Python 3.5 peut fonctionner correctement sur Python 3.7, mais peut-être pas sur 3.4.

Lorsque vous travaillez avec des systèmes de gestion des dépendances, vous pouvez également rencontrer la notion de  _lock files_. Un lock file est simplement un fichier qui répertorie la version exacte de chaque dépendance dont vous dépendez _actuellement_. Habituellement, vous devez explicitement lancer un programme de mise à jour pour passer à une version plus récente de vos dépendances. Il y a de nombreuses raisons à cela, comme éviter les recompilations inutiles, avoir des builds reproductibles, ou ne pas mettre à jour automatiquement vers la dernière version (qui peut ne pas bien fonctionner). Une version extrême de ce type de verrouillage des dépendances est le _vendoring_, qui consiste à copier tout le code de vos dépendances dans votre propre projet. Cela vous donne un contrôle total sur toutes les modifications qui y sont apportées et vous permet d'y introduire vos propres changements, mais cela signifie également que vous devez explicitement intégrer les mises à jour des développeurs au fil du temps.

# Systèmes d'intégration continue

Au fur et à mesure que vous travaillez sur des projets de plus en plus importants, vous vous apercevrez qu'il y a souvent des tâches supplémentaires à effectuer chaque fois que vous y apportez une modification. Vous pourriez avoir à publier une nouvelle version de la documentation, publier une version compilée quelque part, publier le code sur pypi, exécuter votre suite de tests, et toutes sortes d'autres choses. Peut-être qu'à chaque fois que quelqu'un vous envoie une pull request sur GitHub, vous voulez que son code soit vérifié du point de vue du style et que des benchmarks soient exécutés ? Lorsque ce genre de besoins se présente, il est temps de jeter un coup d'oeil à l'intégration continue.

L'intégration continue, ou CI, est un terme générique qui désigne les "choses qui s'exécutent chaque fois que votre code est modifié", et il existe de nombreuses entreprises qui fournissent différents types de CI, souvent gratuitement pour les projets open-source. Parmi les plus importantes, citons Travis CI, Azure Pipelines et GitHub Actions. Ils fonctionnent tous à peu près de la même manière : vous ajoutez un fichier à votre repository qui décrit ce qui doit se passer lorsque diverses choses se produisent dans ce dépôt. La règle la plus courante est, de loin, une règle du type "lorsque quelqu'un push du code, exécuter la suite de tests". Lorsque l'événement se déclenche, le fournisseur de CI met en route une machine virtuelle (ou plus), exécute les commandes de votre "recette", puis note généralement les résultats quelque part. Vous pouvez le configurer de manière à être notifié si la suite de tests ne passe plus, ou de manière à ce qu'un petit badge apparaisse sur votre repository tant que les tests passent.

Comme exemple de système de CI, le site web de du cours est configuré en utilisant GitHub Pages. Pages est une action CI qui exécute le logiciel de blog Jekyll à chaque push vers `master` et rend le site compilé disponible sur un domaine GitHub particulier. Cela nous permet de mettre à jour le site web en toute simplicité ! Il nous suffit d'effectuer nos modifications localement, de les commit avec git, puis de les push. Le CI s'occupe du reste.

## Petite parenthèse sur les tests

La plupart des grands projets logiciels sont accompagnés d'une "suite de tests". Vous êtes peut-être déjà familiarisé avec le concept général des tests, mais nous avons pensé mentionner rapidement quelques approches des tests et de la terminologie des tests que vous pourriez rencontrer:

- Suite de tests : un terme générique pour tous les tests
- Test unitaire (unit test) : un "micro-test" qui teste une fonctionnalité spécifique de manière isolée.
- Test d'intégration : un "macro-test" qui exécute une plus grande partie du système pour vérifier que les différentes fonctionnalités ou composants fonctionnent _ensemble_.
- Test de régression : un test qui met en oeuvre un modèle particulier qui a _précédemment_ causé un bug afin de s'assurer que le bug ne réapparaîsse pas.
- Mocking : remplacement d'une fonction, d'un module ou d'un type par une fausse implémentation afin d'éviter de tester des fonctionnalités non liées. Par exemple, vous pouvez "simuler (mock) le réseau" ou "simuler (mock) le disque".

# Exercices

1. La plupart des makefiles fournissent une cible appelée `clean`. Cette cible n'est pas destinée à produire un fichier appelé `clean`, mais plutôt à nettoyer tous les fichiers qui peuvent être recompilés par make. Pensez-y comme un moyen d'"annuler" toutes les étapes de la compilation. Implémentez une cible `clean` pour le `Makefile` `paper.pdf` ci-dessus. Vous devrez rendre la cible [phony](https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html). La sous-commande [`git
    ls-files`](https://git-scm.com/docs/git-ls-files) peut s'avérer utile. Un certain nombre d'autres cibles make très courantes sont listées [ici](https://www.gnu.org/software/make/manual/html_node/Standard-Targets.html#Standard-Targets).
2. Jetez un oeil aux différentes façons de spécifier les exigences de version pour les dépendances dans le [Rust's build system](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html). La plupart des repositories de packages supportent une syntaxe similaire. Pour chacune d'entre elles (caret, tilde, joker, comparaison et d'autres), essayez de trouver un cas d'utilisation dans lequel ce type particulier d'exigence a du sens.
3. Git peut agir comme un simple système de CI à lui tout seul. Dans `.git/hooks` à l'intérieur de n'importe quel repository git, vous trouverez des fichiers (actuellement inactifs) qui sont exécutés en tant que scripts lorsqu'une action particulière se produit. Ecrivez un hook [`pre-commit`](https://git-scm.com/docs/githooks#_pre_commit) qui exécute `make paper.pdf` et refuse le commit si la commande `make` échoue. Cela devrait empêcher tout commit d'avoir une version non-compilable du document.
4. Mettre en place une simple page auto-publiée en utilisant [GitHub Pages](https://pages.github.com/). Ajoutez une [GitHub Action](https://github.com/features/actions) au repository pour exécuter `shellcheck` sur tous les fichiers shell dans ce repository (voici [une façon de faire](https://github.com/marketplace/actions/shellcheck)). Vérifiez que cela fonctionne !
5. [Créez votre propre](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/building-actions) GitHub Action pour exécuter [`proselint`](http://proselint.com/) ou [`write-good`](https://github.com/btford/write-good) sur tous les fichiers `.md` du repository.  Activez-la dans votre dépôt, et vérifiez qu'elle fonctionne en déposant une pull request avec une faute de frappe.