---
layout: lecture
title: "Contrôle de version (Git)"
date: 2020-01-22
ready: true
video:
  aspect: 56.25
  id: 2sjqTHE0zok
---


Les systèmes de contrôle de version (VCS) sont des outils utilisés pour suivre les modifications apportées au code source (ou à d'autres collections de fichiers et de dossiers).
(ou d'autres collections de fichiers et de dossiers). Comme leur nom l'indique, ces outils
permettent de conserver un historique des modifications ; ils facilitent en outre la collaboration. Les VCS suivent les modifications apportées à un dossier et à son contenu dans une série d'instantanés, où
où chaque instantané encapsule l'état complet des fichiers/dossiers d'un répertoire de premier niveau.
de premier niveau. Les VCS conservent également des métadonnées telles que la personne qui a créé chaque instantané, les messages associés à chaque instantané, etc.
messages associés à chaque instantané, etc.

Pourquoi le contrôle de version est-il utile ? Même lorsque vous travaillez seul, il peut vous permettre de
vous permettre de consulter d'anciens instantanés d'un projet, de garder une trace des raisons pour lesquelles certaines modifications ont été effectuées, de travailler sur des branches parallèles du développement, et bien plus encore.
travailler sur des branches de développement parallèles, et bien plus encore. Lorsque vous travaillez
avec d'autres, c'est un outil inestimable pour voir ce que d'autres personnes ont modifié,
ainsi que pour résoudre les conflits dans le cadre d'un développement simultané.

Les VCS modernes vous permettent également de répondre facilement (et souvent automatiquement) à des questions telles que
comme :
- Qui a écrit ce module ?
- Quand cette ligne particulière de ce fichier particulier a-t-elle été éditée ? Par qui ? Pourquoi a-t-elle été éditée ?
  Pourquoi a-t-elle été éditée ?
- Au cours des 1000 dernières révisions, quand/pourquoi un test unitaire particulier a-t-il cessé de fonctionner ?
de fonctionner ?

While other VCSs exist, **Git** is the de facto standard for version control.
This [XKCD comic](https://xkcd.com/1597/) captures Git's reputation:
Bien qu'il existe d'autres systèmes de contrôle de version, Git est la norme de facto en matière de contrôle de version. Cette bande dessinée de  [XKCD comic](https://xkcd.com/1597/) illustre la réputation de Git :

![xkcd 1597](https://imgs.xkcd.com/comics/git.png)

Parce que l'interface de Git est une grande abstraction, apprendre Git de haut en bas (en commençant par son interface / son interface en ligne de commande) peut conduire à beaucoup de confusion.
Il est possible de mémoriser une poignée de commandes et de les considérer comme des incantations magiques, et de suivre l'approche de la bande dessinée ci-dessus chaque fois que quelque chose ne va pas.
comme des incantations magiques, et de suivre l'approche de la bande dessinée ci-dessus dès que quelque chose ne va plus.

Bien que l'interface de Git soit laide, sa conception et ses idées sous-jacentes sont belles. Alors qu'une interface laide doit être _mémorisée_, une belle conception peut être _comprise_. C'est pourquoi nous expliquons Git de manière ascendante, en commençant par son modèle de données et en couvrant ensuite l'interface en ligne de commande. Une fois le modèle de données compris, les commandes peuvent être mieux comprises en termes de manipulation du modèle de données sous-jacent.

# Modèle de données de Git

Il existe de nombreuses approches ad hoc pour le contrôle des versions. Git a un modèle modèle bien pensé qui permet de bénéficier de toutes les fonctionnalités intéressantes du contrôle de version, comme la conservation de l'historique, la prise en charge des branches et la collaboration, comme la conservation de l'historique, la prise en charge des branches et la collaboration.

## Instantanés

Git modélise l'historique d'une collection de fichiers et de dossiers au sein d'un répertoire de premier niveau comme une série d'instantanés. Dans la terminologie de Git, un fichier est appelé "blob", et c'est juste un tas d'octets. Un répertoire est appelé "arbre", et il associe des noms à des blobs ou à des arbres (les répertoires peuvent donc contenir d'autres répertoires). Un instantané est l'arbre de premier niveau qui est traqué. Par exemple, nous pourrions avoir une arborescence comme suit :

```
<root> (tree)
|
+- foo (tree)
|  |
|  + bar.txt (blob, contents = "hello world")
|
+- baz.txt (blob, contents = "git est un outil formidable")
```

L'arbre de premier niveau contient deux éléments, un arbre "foo" (qui contient lui-même un élément, un blob "bar.txt"), et un blob "baz.txt".

## Modélisation de l'histoire : des instantanés 

Comment un système de contrôle des versions doit-il relier les instantanés ? Un modèle simple consisterait à avoir un historique linéaire. Un historique serait une liste d'instantanés classés dans le temps. Pour de nombreuses raisons, Git n'utilise pas un modèle aussi simple.

Dans Git, un historique est un graphe acyclique dirigé (DAG) d'instantanés. Cela peut sembler être un mot mathématique compliqué, mais ne vous laissez pas intimider. Tout ce que cela signifie, c'est que chaque instantané dans Git fait référence à un ensemble de "parents", les instantanés qui l'ont précédé. Il s'agit d'un ensemble de parents plutôt que d'un seul parent (comme ce serait le cas dans un historique linéaire) car un instantané peut descendre de plusieurs parents, par exemple, en raison de la combinaison (fusion) de deux branches parallèles de développement.

Git appelle ces instantanés des "commit". La visualisation de l'historique des livraisons peut ressembler à quelque chose comme ceci :

```
o <-- o <-- o <-- o
            ^
             \
              --- o <-- o
```
Dans l'image ASCII ci-dessus, les `o`s correspondent à des commits individuels (instantanés). Les flèches pointent vers le parent de chaque commit (il s'agit d'une relation "vient auparavant", et non "vient postérieurement"). Après le troisième commit, l'historique se divise en deux branches distinctes. Cela peut correspondre, par exemple, à deux fonctionnalités distinctes développées en parallèle, indépendamment l'une de l'autre. À l'avenir, ces branches peuvent être fusionnées pour créer un nouvel instantané qui intègre les deux fonctionnalités, produisant un nouvel historique qui ressemble à ceci, avec le nouveau commit de fusion en gras :

<pre class="highlight">
<code>
o <-- o <-- o <-- o <---- <strong>o</strong>
            ^            /
             \          v
              --- o <-- o
</code>
</pre>

Dans Git, les commits sont immuables. Cela ne signifie pas que les erreurs ne peuvent pas être corrigées, cependant ; c'est juste que les "éditions" de l'historique des commits créent en fait des commits entièrement nouveaux, et les références (voir ci-dessous) sont mises à jour pour pointer vers les nouveaux.
## Modèle de données, sous forme de pseudocode

Il peut être instructif de voir le modèle de données de Git écrit en pseudo-code :
```
// un fichier est un ensemble d'octets
type blob = array<byte>

// un répertoire contient des fichiers et des répertoires nommés
type tree = map<string, tree | blob>

// un commit a des parents, des métadonnées et l'arbre de premier niveau  
type commit = struct {
    parents: array<commit>
    author: string
    message: string
    snapshot: tree
}
```

Il s'agit d'un modèle d'histoire simple et clair.

## Objets et adressage du contenu

Un "objet" est un blob, un arbre ou un engagement :

```
type object = blob | tree | commit
```

Dans le stockage de données de Git, tous les objets sont adressés en fonction de leur contenu par leur [SHA-1 hash](https://en.wikipedia.org/wiki/SHA-1).

```
objects = map<string, object>

def store(object):
    id = sha1(object)
    objects[id] = object

def load(id):
    return objects[id]
```

Les blobs, les arbres et les commits sont unifiés de cette manière : ce sont tous des objets. Lorsqu'ils font référence à d'autres objets, ils ne les contiennent pas réellement dans leur représentation sur disque, mais y font référence par leur hachage.

Par exemple, l'arbre de l'exemple de structure de répertoire ci-dessus (visualisé à l'aide de la fonction `git cat-file -p 698281bc680d1995c5f4caaf3359721a5a58d48d`),


Ressemble à :

```
100644 blob 4448adbf7ecd394f42ae135bbeed9676e894af85    baz.txt
040000 tree c68d233a33c5c06e0340e4c224f0afca87c8ce87    foo
```

L'arbre lui-même contient des pointeurs vers son contenu, baz.txt (un blob) et foo (un arbre). Si nous regardons le contenu adressé par le hash correspondant à baz.txt avec `git cat-file -p 4448adbf7ecd394f42ae135bbeed9676e894af85`, nous obtenons ce qui suit :

```
git est merveilleux
```

## Références

Désormais, tous les instantanés peuvent être identifiés par leur hachage SHA-1. Cela n'est pas pratique, car les humains ne sont pas doués pour se souvenir de chaînes de 40 caractères hexadécimaux.

La solution de Git à ce problème est d'utiliser des noms lisibles par l'homme pour les hashs SHA-1, appelés "références". Les références sont des pointeurs vers les commits. Contrairement aux objets, qui sont immuables, les références sont mutables (elles peuvent être mises à jour pour pointer vers un nouveau commit). Par exemple, la référence `master` pointe généralement vers le dernier commit de la branche principale de développement.

```
references = map<string, string>

def update_reference(name, id):
    references[name] = id

def read_reference(name):
    return references[name]

def load_reference(name_or_id):
    if name_or_id in references:
        return load(references[name_or_id])
    else:
        return load(name_or_id)
```

Grâce à cela, Git peut utiliser des noms lisibles par l'homme comme `master` pour se référer à un instantané particulier dans l'historique, au lieu d'une longue chaîne hexadécimale.

Un détail est que nous voulons souvent avoir une notion de "l'endroit où nous sommes actuellement" dans l'historique, de sorte que lorsque nous prenons un nouvel instantané, nous savons à quoi il est relatif (comment nous définissons le champ `parents` du commit). Dans Git, cet "endroit où nous sommes actuellement" est une référence spéciale appelée "HEAD".

## Repositories

Enfin, nous pouvons définir ce qu'est (en gros) un dépôt Git : il s'agit des `objets` de données et des `références`.

Sur le disque, tout ce que Git stocke, ce sont des objets et des références : c'est tout ce qu'il y a dans le modèle de données de Git. Toutes les commandes `Git` se traduisent par une manipulation du DAG de commit par l'ajout d'objets et l'ajout/mise à jour de références.

Chaque fois que vous tapez une commande, pensez à la manipulation qu'elle effectue sur la structure de données graphique sous-jacente. Inversement, si vous essayez d'apporter un type particulier de changement au DAG des livraisons, par exemple "écarter les changements non livrés et faire pointer le ref 'master' sur la livraison `5d83f9e`", il y a probablement une commande pour le faire (par exemple, dans ce cas, `git checkout master; git reset
--hard 5d83f9e`).

# Zone d'attente

Il s'agit d'un autre concept orthogonal au modèle de données, mais qui fait partie de l'interface de création de commits.

L'une des façons d'implémenter l'instantané tel que décrit ci-dessus est d'avoir une commande "create snapshot" qui crée un nouvel instantané basé sur l'_état_ _actuel_ du répertoire de travail. Certains outils de contrôle de version fonctionnent ainsi, mais pas Git. Nous voulons des instantanés propres, et il n'est pas toujours idéal de faire un instantané à partir de l'état actuel. Par exemple, imaginez un scénario dans lequel vous avez implémenté deux fonctionnalités distinctes, et vous voulez créer deux commits distincts, où le premier introduit la première fonctionnalité, et le suivant introduit la seconde fonctionnalité. Ou imaginez un scénario dans lequel vous avez ajouté des instructions de débogage (print statements) partout dans votre code, ainsi qu'une correction de bugs ; vous voulez valider la correction de bugs tout en supprimant toutes les instructions de débogage (print statements).

Git s'adapte à ces scénarios en vous permettant de spécifier quelles modifications doivent être incluses dans le prochain instantané grâce à un mécanisme appelé "staging area" (zone d'attente).

# Interface de ligne de commande Git

Pour éviter de dupliquer les informations, nous n'allons pas expliquer les commandes ci-dessous en détail. Consultez le très recommandé [Pro Git](https://git-scm.com/book/en/v2) pour plus d'informations, ou regardez la vidéo de présentation.

## Bases

{% comment %}

The `git init` command initializes a new Git repository, with repository
metadata being stored in the `.git` directory:

```console
$ mkdir myproject
$ cd myproject
$ git init
Initialized empty Git repository in /home/missing-semester/myproject/.git/
$ git status
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

How do we interpret this output? "No commits yet" basically means our version
history is empty. Let's fix that.

```console
$ echo "hello, git" > hello.txt
$ git add hello.txt
$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   hello.txt

$ git commit -m 'Initial commit'
[master (root-commit) 4515d17] Initial commit
 1 file changed, 1 insertion(+)
 create mode 100644 hello.txt
```

With this, we've `git add`ed a file to the staging area, and then `git
commit`ed that change, adding a simple commit message "Initial commit". If we
didn't specify a `-m` option, Git would open our text editor to allow us type a
commit message.

Now that we have a non-empty version history, we can visualize the history.
Visualizing the history as a DAG can be especially helpful in understanding the
current status of the repo and connecting it with your understanding of the Git
data model.

The `git log` command visualizes history. By default, it shows a flattened
version, which hides the graph structure. If you use a command like `git log
--all --graph --decorate`, it will show you the full version history of the
repository, visualized in graph form.

```console
$ git log --all --graph --decorate
* commit 4515d17a167bdef0a91ee7d50d75b12c9c2652aa (HEAD -> master)
  Author: Missing Semester <missing-semester@mit.edu>
  Date:   Tue Jan 21 22:18:36 2020 -0500

      Initial commit
```

This doesn't look all that graph-like, because it only contains a single node.
Let's make some more changes, author a new commit, and visualize the history
once more.

```console
$ echo "another line" >> hello.txt
$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   hello.txt

no changes added to commit (use "git add" and/or "git commit -a")
$ git add hello.txt
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   hello.txt

$ git commit -m 'Add a line'
[master 35f60a8] Add a line
 1 file changed, 1 insertion(+)
```

Now, if we visualize the history again, we'll see some of the graph structure:

```
* commit 35f60a825be0106036dd2fbc7657598eb7b04c67 (HEAD -> master)
| Author: Missing Semester <missing-semester@mit.edu>
| Date:   Tue Jan 21 22:26:20 2020 -0500
|
|     Add a line
|
* commit 4515d17a167bdef0a91ee7d50d75b12c9c2652aa
  Author: Anish Athalye <me@anishathalye.com>
  Date:   Tue Jan 21 22:18:36 2020 -0500

      Initial commit
```

Also, note that it shows the current HEAD, along with the current branch
(master).

We can look at old versions using the `git checkout` command.

```console
$ git checkout 4515d17  # previous commit hash; yours will be different
Note: checking out '4515d17'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 4515d17 Initial commit
$ cat hello.txt
hello, git
$ git checkout master
Previous HEAD position was 4515d17 Initial commit
Switched to branch 'master'
$ cat hello.txt
hello, git
another line
```

Git can show you how files have evolved (differences, or diffs) using the `git
diff` command:

```console
$ git diff 4515d17 hello.txt
diff --git c/hello.txt w/hello.txt
index 94bab17..f0013b2 100644
--- c/hello.txt
+++ w/hello.txt
@@ -1 +1,2 @@
 hello, git
 +another line
```

{% endcomment %}

- `git help <command>`: obtient de l'aide pour une commande git
- `git init`: crée un nouveau repo git, dont les données sont stockées dans le répertoire `.git`.
- `git status`: vous indique ce qui se passe
- `git add <filename>`: ajoute des fichiers à la zone d'attente
- `git commit`: crée un nouveau commit
    - Écrivez [de bons commentaires qui ont du sens](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)!
    - Encore plus de raisons d'écrire [de bons commentaires qui ont du sens](https://chris.beams.io/posts/git-commit/)!
- `git log`: montre un historique aplati des logs
- `git log --all --graph --decorate`: visualise l'histoire sous la forme d'un DAG
- `git diff <filename>`: montre les changements que vous avez effectués par rapport à la zone de transit
- `git diff <revision> <filename>`: montre les différences dans un fichier entre les instantanés
- `git checkout <revision>`: met à jour HEAD et la branche actuelle

## Branchement et fusion

{% comment %}

Branching allows you to "fork" version history. It can be helpful for working
on independent features or bug fixes in parallel. The `git branch` command can
be used to create new branches; `git checkout -b <branch name>` creates and
branch and checks it out.

Merging is the opposite of branching: it allows you to combine forked version
histories, e.g. merging a feature branch back into master. The `git merge`
command is used for merging.

{% endcomment %}

- `git branch`: affiche les branches
- `git branch <name>`: crée une branche
- `git checkout -b <name>`: crée une branche et y accède
    - identique que `git branch <name>; git checkout <name>`
- `git merge <revision>`: fusionne dans la branche courante
- `git mergetool`: utilise un outil sophistiqué pour aider à résoudre les conflits de fusion
- `git rebase`: rebase un ensemble de patches sur une nouvelle base

## Remotes

- `git remote`: list des remotes
- `git remote add <name> <url>`: ajoute un remote
- `git push <remote> <local branch>:<remote branch>`: envoie des objets à la branche remote, et met à jour la référence remote
- `git branch --set-upstream-to=<remote>/<remote branch>`: établit une correspondance entre la branche locale et la branche remote
- `git fetch`: récupère des objets/références d'une branche remote
- `git pull`: même chose que `git fetch; git merge`
- `git clone`: télécharge le dépôt à partir d'une branche remote

## Annuler

- `git commit --amend`: éditer le contenu/message d'un commit
- `git reset HEAD <file>`: rétablit l'état d'un fichier
- `git checkout -- <file>`: rejette les modifications

# Advanced Git

- `git config`: Git est [très personnalisable](https://git-scm.com/docs/git-config)
- `git clone --depth=1`: clone superficiel, sans l'historique complet des versions
- `git add -p`: staging interactif
- `git rebase -i`:  rebasement interactif
- `git blame`: montre qui a édité quelle ligne en dernier
- `git stash`: supprimer temporairement les modifications dans le répertoire de travail
- `git bisect`: historique de recherche binaire (par exemple pour les régressions)
- `.gitignore`: [spécifie](https://git-scm.com/docs/gitignore) les fichiers intentionnellement à ignorer

# Divers  

- **GUIs**: il existe de nombreux [clients GUI ](https://git-scm.com/downloads/guis)
pour git. Personnellement, nous ne les utilisons pas et utilisons plutôt l'interface en ligne de commande.
- **Intégration au shell**: il est très pratique d'avoir un statut Git dans le prompt du shell  ([zsh](https://github.com/olivierverdier/zsh-git-prompt),
[bash](https://github.com/magicmonty/bash-git-prompt)). Souvent inclus dans des frameworks comme Oh My Zsh. [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh).
- **Intégration de l'éditeur**: de la même manière que ci-dessus, des intégrations pratiques avec de nombreuses fonctionnalités. [fugitive.vim](https://github.com/tpope/vim-fugitive) est l'intégration standard pour Vim.
- **Workflows**: nous vous avons enseigné le modèle de données, ainsi que quelques commandes de base ; nous ne vous avons pas dit quelles pratiques suivre lorsque vous travaillez sur de grands projets [beaucoup](https://nvie.com/posts/a-successful-git-branching-model/)
[d'approches](https://www.endoflineblog.com/gitflow-considered-harmful)
[différentes](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).
- **GitHub**: Git n'est pas GitHub. GitHub a une façon spécifique de contribuer au code d'autres projets, appelée  [pull requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests).
- **Autres fournisseurs Git**: GitHub n'est pas un cas particulier : il existe de nombreux hébergeurs de dépôts Git, comme [GitLab](https://about.gitlab.com/) et
[BitBucket](https://bitbucket.org/).

# Resources

- La lecture de [Pro Git](https://git-scm.com/book/en/v2) est **fortement recommandée**.
En parcourant les chapitres 1 à 5, vous devriez apprendre l'essentiel de ce dont vous avez besoin pour utiliser Git de manière efficace, maintenant que vous comprenez le modèle de données. Les derniers chapitres contiennent des informations intéressantes et avancées.
- [Oh Shit, Git!?!](https://ohshitgit.com/) est un petit guide sur la façon de se remettre de certaines erreurs courantes de Git.
- [Git pour les informaticiens](https://eagain.net/articles/git-for-computer-scientists/) est une courte explication du modèle de données de Git, avec moins de pseudocode et plus de diagrammes que les notes ce cours.
- [Git depuis le début](https://jwiegley.github.io/git-from-the-bottom-up/)
explication détaillée de l'implémentation de Git au-delà du modèle de données, pour les curieux.
- [Comment expliquer git en quelques mots](https://smusamashah.github.io/blog/2017/10/14/explain-git-in-simple-words)
- [Apprendre le branchement Git](https://learngitbranching.js.org/) est un jeu par navigateur qui vous apprend le Git.

# Exercices

1. Si vous n'avez pas d'expérience avec Git, essayez de lire les deux premiers chapitres de  [Pro Git](https://git-scm.com/book/en/v2)ou suivez un tutoriel tel que [Learn Git Branching](https://learngitbranching.js.org/). Pendant que vous travaillez, faites le lien entre les commandes Git et le modèle de données.
1. Clonez le dépôt du [site web de la classe](https://github.com/missing-semester/missing-semester).
    1. Explorer l'historique des versions en le visualisant sous la forme d'un graphique.
    1. Qui a été la dernière personne à modifier `README.md`? (Indice: utiliser `git log` avec un argument).
    1. Quel était le commentaire associé à la dernière modification de la ligne
       `collections:` de `_config.yml`? (Indice: utiliser `git blame` et `git
       show`).
1. Une erreur fréquente lors de l'apprentissage de Git est de livrer des fichiers volumineux qui ne devraient pas être gérés par Git ou d'ajouter des informations sensibles. Essayez d'ajouter un fichier à un dépôt, d'effectuer quelques livraisons, puis de supprimer ce fichier de l'historique (vous pouvez consulter cette [rubrique](https://help.github.com/articles/removing-sensitive-data-from-a-repository/)).
1. Cloner un dépôt depuis GitHub, et modifier un de ses fichiers existants. Que se passe-t-il lorsque vous faites `git stash`? Que voyez-vous lorsque vous exécutez `git log --all --oneline`? Exécutez `git stash pop` pour annuler ce que vous avez fait avec `git stash`.
  Dans quel scénario cela peut-il être utile ?
1. Comme beaucoup d'outils en ligne de commande, Git fournit un fichier de configuration (ou fichier point) appelé  `~/.gitconfig`. Créez un alias dans `~/.gitconfig` pour que lorsque vous lancez `git graph`, vous obteniez la sortie de  `git log --all --graph --decorate --oneline`.Des informations sur les alias git peuvent être trouvées [ici](https://git-scm.com/docs/git-config#Documentation/git-config.txt-alias).
1. Vous pouvez définir des motifs d'ignorance globaux dans `~/.gitignore_global`  après avoir exécuté
   `git config --global core.excludesfile ~/.gitignore_global`. Faites cela, et configurez votre fichier gitignore global pour ignorer les fichiers temporaires spécifiques à un système d'exploitation ou à un éditeur, comme `.DS_Store`.
1. Faisez un Fork sur le [répertoire du site web de la classe](https://github.com/missing-semester missing-semester), trouvez une coquille ou une autre amélioration que vous pouvez apporter, et soumettez une demande de modification (pull request) sur GitHub (vous voulez peut-être jeter un oeil [ici](https://github.com/firstcontributions/first-contributions)).
  Veuillez ne soumettre que des RP utiles (ne nous spammez pas, s'il vous plaît !). Si vous ne trouvez pas d'amélioration à apporter, vous pouvez ignorer cet exercice.