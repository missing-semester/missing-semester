---
layout: lecture
title: "Éditeurs (Vim)"
date: 2020-01-15
ready: true
video:
  aspect: 56.25
  id: a6Q8Na575qc
---

Écrire des textes en anglais et écrire du code sont des activités très différentes. En programmation, vous passez plus de temps à changer de fichier, à lire, à naviguer et à éditer du code qu'à écrire un long texte. Il est donc logique qu'il existe différents types de programmes pour écrire des textes en anglais et du code (par exemple, Microsoft Word et Visual Studio Code).

En tant que programmeurs, nous passons le plus clair de notre temps à éditer du code, et il vaut donc la peine d'investir du temps dans la maîtrise d'un éditeur adapté à vos besoins. Voici comment apprendre un nouvel éditeur :

- Commencez par un tutoriel (c'est-à-dire ce cours, plus les ressources que nous indiquons).
- Utilisez l'éditeur pour tous vos besoins en matière d'édition de texte (même si cela vous ralentit au début).
- Renseignez-vous au fur et à mesure : si vous avez l'impression qu'il devrait y avoir une meilleure façon de faire quelque chose, c'est probablement le cas.

Si vous suivez la méthode ci-dessus, en vous engageant pleinement à utiliser le nouveau programme pour tous vos besoins d'édition de texte, la ligne du temps d'apprentissage d'un éditeur de texte sophistiqué se présente comme suit. En une heure ou deux, vous apprendrez les fonctionnalités de base de l'éditeur, telles que l'ouverture et la modification de fichiers, enregistrer/quitter et la navigation dans le texte. Au bout de 20 heures, vous devriez être aussi rapide qu'avec votre ancien éditeur. Après cela, les avantages commencent : vous aurez acquis suffisamment de connaissances et de mémoire musculaire pour que l'utilisation du nouvel éditeur vous fasse gagner du temps. Les éditeurs de texte modernes sont des outils sophistiqués et puissants, de sorte que l'apprentissage ne s'arrête jamais : vous deviendrez encore plus rapide au fur et à mesure que vous en apprendrez davantage.

# Quel éditeur apprendre ?

Les programmeurs ont des [opinions bien arrêtées](https://en.wikipedia.org/wiki/Editor_war) sur leurs éditeurs de texte préférés.

Quels sont les éditeurs les plus populaires aujourd'hui ? Voir [cette enquête de Stack Overflow](https://insights.stackoverflow.com/survey/2019/#development-environments-and-tools) (il pourrait y avoir des biais car les utilisateurs de Stack Overflow ne sont pas forcément représentatifs de l'ensemble des programmeurs). [Visual Studio
Code](https://code.visualstudio.com/) est l'éditeur le plus populaire. [Vim](https://www.vim.org/) est l'éditeur en ligne de commande le plus populaire.

## Vim

Tous les professeurs de ce cours utilisent Vim comme éditeur. Vim a une histoire riche ; il est issu de l'éditeur Vi (1976), et il est toujours en cours de développement aujourd'hui. Vim a des idées vraiment intéressantes, et c'est pourquoi de nombreux outils supportent un mode d'émulation Vim (par exemple, 1,4 million de personnes ont installé [l'émulation Vim pour VS code](https://github.com/VSCodeVim/Vim)). Vim vaut probablement la peine d'être appris même si vous finissez par passer à un autre éditeur de texte.

Il n'est pas possible d'enseigner toutes les fonctionnalités de Vim en 50 minutes, c'est pourquoi nous allons nous concentrer sur l'explication de la philosophie de Vim, vous enseigner les bases, vous montrer quelques fonctionnalités plus avancées et vous donner les ressources nécessaires pour maîtriser l'outil.

# La philosophie de Vim

En programmation, on passe le plus clair de son temps à lire/éditer, et non à écrire. C'est pourquoi Vim est un éditeur _modal_ : il dispose de différents modes pour l'insertion de texte et la manipulation de texte. Vim est programmable (avec Vimscript et d'autres langages comme Python), et l'interface de Vim elle-même est un langage de programmation : les touches (avec des noms mnémoniques) sont des commandes, et ces commandes sont composables. Vim évite l'utilisation de la souris, parce qu'elle est trop lente ; Vim évite même d'utiliser les touches fléchées, parce qu'elles nécessitent trop de mouvements.

Le résultat final est un éditeur qui peut s'adapter à la vitesse à laquelle vous pensez.

# L'édition modale

La conception de Vim repose sur l'idée qu'une grande partie du temps des programmeurs est consacrée à la lecture, à la navigation et à de petites modifications, plutôt qu'à l'écriture de longs textes. C'est pourquoi Vim possède plusieurs modes de fonctionnement.

- **Normal** : pour se déplacer dans un fichier et effectuer des modifications
- **Insert** : pour insérer du texte
- **Replace** : pour remplacer du texte
- **Visual** (simple, ligne ou bloc) : pour sélectionner des blocs de texte
- **Command-line** : pour exécuter une commande

Les touches ont des significations différentes selon les modes de fonctionnement. Par exemple, la lettre `x` en mode Insert insère simplement le caractère littéral "x", mais en mode Normal, elle supprime le caractère sous le curseur, et en mode Visuel, elle supprime la sélection.

Dans sa configuration par défaut, Vim affiche le mode actuel en bas à gauche. Le mode initial/par défaut est le mode Normal. Vous passerez généralement le plus clair de votre temps entre le mode Normal et le mode Insert.

Vous pouvez changer de mode en appuyant sur `<ESC>` (la touche escape) pour passer de n'importe quel mode au mode Normal. En mode Normal, vous pouvez passer en mode Insert avec `i`, en mode Replace avec `R`, en mode Visual avec `v`, en mode Visual Line avec `V`, en mode Visual Block avec `<C-v>` (Ctrl-V, parfois aussi écrit `^V`), et en mode Command-Line avec `:`.

Vous utiliserez souvent la touche `<ESC>` lorsque vous utiliserez Vim : envisagez de remapper Caps Lock par Escape ([instructions pour macOS](https://vim.fandom.com/wiki/Map_caps_lock_to_escape_in_macOS)).


# Notions de base

## Insérer du texte

En mode Normal, appuyez sur `i` pour passer en mode Insert. Vim se comporte alors comme n'importe quel autre éditeur de texte, jusqu'à ce que vous appuyiez sur `<ESC>` pour revenir au mode Normal. Ceci, ainsi que les bases expliquées ci-dessus, sont tout ce dont vous avez besoin pour commencer à éditer des fichiers en utilisant Vim (bien que ce ne soit pas particulièrement efficace, si vous passez tout votre temps à éditer à partir du mode Insert).

## Buffers, onglets et fenêtres

Vim conserve un ensemble de fichiers ouverts, appelés "buffers". Une session Vim comporte un certain nombre d'onglets, chacun d'entre eux comportant un certain nombre de fenêtres (split panes). Chaque fenêtre affiche un seul buffer. Contrairement à d'autres programmes que vous connaissez, comme les navigateurs web, il n'y a pas de correspondance 1 à 1 entre les buffer et les fenêtres ; les fenêtres sont simplement des "vues". Un buffer donné peut être ouvert dans _plusieurs_ fenêtres, même dans le même onglet. Cela peut être très pratique, par exemple, pour visualiser deux parties différentes d'un fichier en même temps.

Par défaut, Vim s'ouvre avec un seul onglet, qui contient une seule fenêtre.

## Command-line

Le mode Command-line est accessible en tapant `:` en mode Normal. Votre curseur passera à la ligne de commande en bas de l'écran en appuyant sur `:`. Ce mode offre de nombreuses fonctionnalités, notamment l'ouverture, l'enregistrement et la fermeture de fichiers, ainsi que [quitter Vim](https://twitter.com/iamdevloper/status/435555976687923200).

- `:q` quit (fermer la fenêtre)
- `:w` save (sauvegarder)
- `:wq` save and quit (sauvegarder et quitter)
- `:e {nom du fichier}` ouvrir le fichier pour l'éditer
- `:ls` afficher les buffers ouverts
- `:help {sujet}` ouvrir l'aide
    - `:help :w` ouvrir l'aide pour la commande `:w`
    - `:help w` ouvrir l'aide pour le mouvement `w`

# L'interface de Vim est un langage de programmation

L'idée la plus importante de Vim est que l'interface de Vim elle-même est un langage de programmation. Les frappes au clavier (avec des noms mnémoniques) sont des commandes, et ces commandes se _composent_. Cela permet des déplacements et des modifications efficaces, surtout une fois que les commandes sont devenues mémoire musculaire.


## Déplacements

Vous devriez passer la plupart de votre temps en mode Normal, en utilisant les commandes de mouvement pour naviguer dans le buffer. Les mouvements dans Vim sont également appelés "noms", car ils font référence à des morceaux de texte.

- Mouvement de base : `hjkl` (gauche, bas, haut, droite)
- Mots : `w` (mot suivant), `b` (début du mot), `e` (fin du mot)
- Lignes : `0` (début de ligne), `^` (premier caractère non vide), `$` (fin de ligne)
- Écran : `H` (haut de l'écran), `M` (milieu de l'écran), `L` (bas de l'écran)
- Défilement : `Ctrl-u` (haut), `Ctrl-d` (bas)
- Fichier : `gg` (début du fichier), `G` (fin du fichier)
- Numéros de ligne : :`{numéro}<CR>` ou `{numéro}G` (ligne {numéro})
- Divers : `%` (élément correspondant)
- Recherche : `f{caractère}`, `t{caractère}`, `F{caractère}`, `T{caractère}`
    - rechercher/aller avant/arrière {caractère} sur la ligne en cours
    - `,` / `;` pour naviguer entre les matchs
- Recherche : `/{regex}`, `n` / `N ` pour naviguer entre les matchs

## Selection

La sélection

Modes Visual :

- Visual: `v`
- Visual Line: `V`
- Visual Block: `Ctrl-v`

Vous pouvez utiliser les touches de déplacement pour effectuer une sélection.

## Édition

Tout ce que vous faisiez auparavant avec la souris, vous le faites maintenant avec le clavier en utilisant des commandes d'édition qui se composent avec des commandes de mouvement. C'est ici que l'interface de Vim commence à ressembler à un langage de programmation. Les commandes d'édition de Vim sont également appelées "verbes", car les verbes agissent sur les noms.

- `i` entrer en mode Insert
    - mais pour manipuler/supprimer du texte, il faut utiliser autre chose que la touche backspace
- `o` / `O` insérer une ligne en dessous / au-dessus
- `d{mouvement}` supprimer {mouvement}
    - par exemple, `dw` efface un mot, `d$` efface jusqu'à la fin de la ligne, `d0` efface jusqu'au début de la ligne
- `c{mouvement}` changer {mouvement}
    - par exemple, `cw` change un mot
    - comme `d{mouvement}` suivi de `i`
- `x` supprimer un caractère (égal à `dl`)
- `s` substituer un caractère (égal à `cl`)
- Mode Visual + manipulation
    -  sélectionner le texte, `d` pour le supprimer ou `c` pour le modifier
- `u` pour undo, `<C-r>` pour redo
- `y` pour copier / "yank" (d'autres commandes comme `d` copient aussi)
- `p` pour coller
- Beaucoup d'autres choses à apprendre : par exemple, `~` inverse la casse d'un caractère

## Comptes

Vous pouvez combiner des noms et des verbes avec un nombre, qui permet d'effectuer une action donnée un certain nombre de fois.

- `3w` avance de 3 mots
- `5j` déplace 5 lignes vers le bas
- `7dw` supprime 7 mots

## Modificateurs

Vous pouvez utiliser des modificateurs pour changer le sens d'un nom. Parmi les modificateurs, citons `i`, qui signifie "inner" ou "inside", et `a`, qui signifie "around".

- `ci(` modifie le contenu de la paire de parenthèses actuelle
- `ci[` modifie le contenu de la paire de crochets actuelle
- `da'` supprime une chaîne de caractères entre guillemets simples, y compris les guillemets simples qui l'entourent

# Démonstration

Voici un exemple d'implémentation incorrecte de [fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz) :

```python
def fizz_buzz(limit):
    for i in range(limit):
        if i % 3 == 0:
            print('fizz')
        if i % 5 == 0:
            print('fizz')
        if i % 3 and i % 5:
            print(i)

def main():
    fizz_buzz(10)
```

Nous allons corriger les problèmes suivants :

- Main n'est jamais appelé
- Commence à 0 au lieu de 1
- Affiche "fizz" et "buzz" sur des lignes séparées pour les multiples de 15
- Affiche "fizz" pour les multiples de 5
- Utilise un argument hardcodé de 10 au lieu de prendre un argument de ligne de commande.

Regardez la vidéo du cours pour la démonstration. Comparez la façon dont les modifications ci-dessus sont effectuées à l'aide de Vim à la façon dont vous pourriez effectuer les mêmes modifications à l'aide d'un autre programme. Remarquez que Vim ne nécessite que très peu de frappes, ce qui vous permet d'éditer à la vitesse à laquelle vous pensez.


# Personnalisation de Vim

Vim est personnalisé via un fichier texte de configuration dans `~/.vimrc` (contenant des commandes Vimscript). Il y a probablement beaucoup de paramètres de base que vous souhaitez activer.

Nous fournissons une configuration de base bien documentée que vous pouvez utiliser comme point de départ. Nous vous recommandons de l'utiliser parce qu'elle corrige certains comportements bizarres de Vim par défaut. **Téléchargez notre configuration [ici](/2020/files/vimrc) et sauvegardez-la dans `~/.vimrc`**.

Vim est hautement personnalisable, et cela vaut la peine de passer du temps à explorer les options de personnalisation. Vous pouvez vous inspirer des dotfiles d'autres sur GitHub, par exemple, les configurations Vim de vos instructeurs ([Anish](https://github.com/anishathalye/dotfiles/blob/master/vimrc),
[Jon](https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.vim) (utilises [neovim](https://neovim.io/)),
[Jose](https://github.com/JJGO/dotfiles/blob/master/vim/.vimrc)). Il y a aussi beaucoup de bons articles de blog sur ce sujet. Essayez de ne pas copier-coller la configuration complète des gens, mais lisez-la, comprenez-la, et prenez ce dont vous avez besoin.

# Extension de Vim

Il existe des tonnes de plugins pour étendre Vim. Contrairement aux vieux conseils que vous pouvez trouver sur Internet, vous n'avez pas besoin d'utiliser un gestionnaire de plugins pour Vim (depuis Vim 8.0). Au lieu de cela, vous pouvez utiliser le système de gestion de paquets intégré. Créez simplement le répertoire `~/.vim/pack/vendor/start/`, et mettez-y les plugins (par exemple via `git clone`).

Voici quelques-uns de nos plugins préférés :

- [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim): fuzzy file finder
- [ack.vim](https://github.com/mileszs/ack.vim): code search
- [nerdtree](https://github.com/scrooloose/nerdtree): file explorer
- [vim-easymotion](https://github.com/easymotion/vim-easymotion): magic motions

Nous essayons d'éviter de donner une liste trop longue de plugins ici. Vous pouvez consulter les dotfiles des instructeurs ([Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/JJGO/dotfiles)) pour voir quels autres plugins nous utilisons. Consultez [Vim Awesome](https://vimawesome.com/) pour d'autres plugins Vim géniaux. Il y a également des tonnes d'articles de blog sur ce sujet : il suffit de chercher "best Vim plugins".

# Le mode Vim dans d'autres programmes

De nombreux outils prennent en charge l'émulation de Vim. La qualité varie de bonne à excellente ; selon l'outil, il se peut qu'il ne prenne pas en charge les fonctions les plus sophistiquées de Vim, mais la plupart d'entre eux couvrent assez bien les bases.


## Le shell

Si vous utilisez Bash, utilisez `set -o vi`. Si vous utilisez Zsh, utilisez `bindkey -v`. Pour Fish, `fish_vi_key_bindings`. De plus, quel que soit le shell utilisé, vous pouvez utiliser `export EDITOR=vim`. Il s'agit de la variable d'environnement utilisée pour décider quel éditeur est lancé lorsqu'un programme veut démarrer un éditeur. Par exemple, `git` utilisera cet éditeur pour les messages de commit.

## Readline

De nombreux programmes utilisent la librairie [GNU
Readline](https://tiswww.case.edu/php/chet/readline/rltop.html) pour leur interface de ligne de commande. Readline supporte également l'émulation (basique) de Vim, qui peut être activée en ajoutant la ligne suivante au fichier `~/.inputrc` :

```
set editing-mode vi
```

Avec ce paramètre, par exemple, la Python REPL prendra en charge les liens Vim.

## Autres

Il existe même des extensions de raccourcis clavier Vim pour les [navigateurs](http://vim.wikia.com/wiki/Vim_key_bindings_for_web_browsers) web - parmi les plus populaires, citons [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en) pour Google Chrome et [Tridactyl](https://github.com/tridactyl/tridactyl) pour Firefox. Vous pouvez même obtenir des liaisons Vim dans les [Jupyter
notebooks](https://github.com/lambdalisue/jupyter-vim-binding). Voici une [longue liste](https://reversed.top/2016-08-13/big-list-of-vim-like-software) de logiciels avec des raccourcis clavier de type Vim.

# Vim avancé

Voici quelques exemples pour vous montrer la puissance de l'éditeur. Nous ne pouvons pas vous enseigner toutes ces choses, mais vous les apprendrez au fur et à mesure. Une bonne heuristique : chaque fois que vous utilisez votre éditeur et que vous pensez "il doit y avoir une meilleure façon de faire ceci", il y en a probablement une : regardez en ligne.

## Recherche et substitution

commande `:s` (substituer) ([documentation](http://vim.wikia.com/wiki/Search_and_replace)).

- `%s/foo/bar/g`
    - remplace foo par bar dans tout le fichier
- `%s/\[.*\](\(.*\))/\1/g`
    - remplace les liens Markdown par des URL simples

## Fenêtres multiples

- `:sp` / `:vsp` pour diviser les fenêtres
- Possibilité d'avoir plusieurs vues du même buffer.

## Macros

- `q{caractère}` pour lancer l'enregistrement d'une macro dans le registre` {caractère}`
- `q` pour arrêter l'enregistrement
- `@{caractère}` rejoue la macro
- L'exécution de la macro s'arrête en cas d'erreur
- `{nombre}@{caractère}` exécute une macro {nombre} fois
- Les macros peuvent être récursives
    - effacez d'abord la macro avec `q{caractère}q`
    - enregistrez la macro, avec `@{caractère}` pour invoquer la macro de manière récursive (ce sera un no-op jusqu'à ce que l'enregistrement soit terminé)
- Exemple : conversion de xml en json ([fichier](/2020/files/example-data.xml))
    - Tableau d'objets avec les clés "name" / "email"
    - Utiliser un programme Python ?
    - Utiliser sed / regexes
        - g/people/d
        - `%s/<personne>/{/g`
        - `%s/<nom>\(.*\)<\N/nom>/"nom" : "\1",/g`
        -  ...
    - Commandes / macros Vim
        - `Gdd`, `ggdd` efface la première et la dernière ligne
        - Macro pour formater un seul élément (registre `e`)
            - Aller à la ligne avec `<nom>`
            - `qe^r "f>s" : "<ESC>f<C"<ESC>q`
        - Macro pour formater une personne
            - Aller à la ligne avec `<personne>`
            - `qpS{<ESC>j@eA,<ESC>j@ejS},<ESC>q`
        - Macro pour formater une personne et passer à la personne suivante
            - Aller à la ligne avec `<personne>`
            - `qq@pjq`
        - Exécuter la macro jusqu'à la fin du fichier
            - `999@q`
        - Supprimer manuellement la dernière `,` et ajouter les délimiteurs `[` et `]`.

# Ressources



- `vimtutor` est un tutoriel installé avec Vim - si Vim est installé, vous devriez pouvoir lancer `vimtutor` à partir de votre shell.
- [Vim Adventures](https://vim-adventures.com/) est un jeu pour apprendre Vim
- [Vim Tips Wiki](http://vim.wikia.com/wiki/Vim_Tips_Wiki)
- [Vim Advent Calendar](https://vimways.org/2019/) contient divers conseils sur Vim
- [Vim Golf](http://www.vimgolf.com/) est un [code golf](https://en.wikipedia.org/wiki/Code_golf), mais où le langage de programmation est l'interface utilisateur de Vim
- [Vi/Vim Stack Exchange](https://vi.stackexchange.com/)
- [Vim Screencasts](http://vimcasts.org/)
- [Practical Vim](https://pragprog.com/titles/dnvim2/) (livre)

# Exercices

1. Finissez `vimtutor`. Note : il est préférable d'utiliser une fenêtre de terminal de [80x24](https://en.wikipedia.org/wiki/VT100) (80 colonnes par 24 lignes).
1. Téléchargez notre [vimrc de base](/2020/files/vimrc) et sauvegardez-le dans `~/.vimrc`. Lisez le fichier bien commenté (en utilisant Vim !), et observez comment Vim se présente et se comporte légèrement différemment avec la nouvelle configuration.
1. Installez et configurez un plugin : [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim).
    1. Créez le répertoire des plugins avec `mkdir -p ~/.vim/pack/vendor/start`
    1. Téléchargez le plugin : `cd ~/.vim/pack/vendor/start ; git clone https://github.com/ctrlpvim/ctrlp.vim`
    1. Lisez la [documentation](https://github.com/ctrlpvim/ctrlp.vim/blob/master/readme.md) du plugin. Essayez d'utiliser CtrlP pour trouver un fichier en naviguant jusqu'au dossier d'un projet, en ouvrant Vim et en utilisant la ligne de commande de Vim pour lancer `:CtrlP`.
    1. Personnalisez CtrlP en ajoutant une [configuration](https://github.com/ctrlpvim/ctrlp.vim/blob/master/readme.md#basic-options) à votre `~/.vimrc` pour ouvrir CtrlP en appuyant sur Ctrl-P.
1. Pour vous entraîner à utiliser Vim, refaites la [démo](#demo) du cours sur votre propre machine.
1. Utilisez Vim pour _tous_ vos travaux d'édition de texte pendant un mois. Si quelque chose vous semble inefficace, ou si vous pensez qu'il doit y avoir un meilleur moyen, essayez de chercher sur Google, il y en a probablement un. Si vous êtes bloqué, venez aux heures de permanence ou envoyez-nous un mail.
1. Configurez vos autres outils pour qu'ils utilisent les "bindings" Vim (voir les instructions ci-dessus).
1. Personnalisez davantage votre `~/.vimrc` et installez d'autres plugins.
1. (Avancé) Convertir du XML en JSON ([fichier d'exemple](/2020/files/example-data.xml)) en utilisant les macros Vim. Essayez de le faire par vous-même, mais vous pouvez consulter la section sur les [macros](#macros) ci-dessus si vous êtes bloqué.