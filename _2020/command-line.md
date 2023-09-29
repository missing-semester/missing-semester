---
layout : lecture
title : "Environnement de la ligne de commande"
date : 2020-01-21
ready : true
video :
  aspect : 56.25
  id : e8BO_dYxk5c
---

Dans ce cours, nous verrons plusieurs façons d'améliorer votre efficacité lors de l'utilisation de l'interpréteur de commandes. Nous travaillons avec l'interpréteur de commandes depuis un certain temps, mais nous nous sommes surtout concentrés sur l'exécution de différentes commandes. Nous allons maintenant voir comment lancer plusieurs processus en même temps, comment arrêter ou mettre en pause un processus spécifique et comment faire en sorte qu'un processus s'exécute en arrière-plan.

Nous allons également découvrir différentes façons d'améliorer votre interpréteur de commandes et d'autres outils, en définissant des alias et en les configurant à l'aide de "dotfiles". Ces deux méthodes peuvent vous aider à gagner du temps, par exemple en utilisant les mêmes configurations sur toutes vos machines sans avoir à taper de longues commandes. Nous allons également voir comment travailler avec des machines distantes en utilisant SSH.


# Contrôle des tâches

Dans certains cas, vous aurez besoin d'interrompre une commande en cours d'exécution, par exemple si une commande prend trop de temps à s'exécuter (comme un `find` avec une très grande structure de répertoires à parcourir).
La plupart du temps, vous pouvez faire `Ctrl-C` et la commande s'arrêtera.
Mais comment cela fonctionne-t-il réellement et pourquoi cela échoue-t-il parfois à arrêter le processus ?

## Tuer un processus

Votre shell utilise un mécanisme de communication UNIX appelé _signal_ pour communiquer des informations au processus.  Lorsqu'un processus reçoit un signal, il arrête son exécution, traite le signal et modifie éventuellement le flux d'exécution sur base des informations fournies par le signal. C'est pourquoi les signaux sont des _interruptions logicielles_.

Dans notre cas, en tapant `Ctrl-C`, l'interpréteur de commandes envoie un signal `SIGINT` au processus.

Voici un exemple minimal d'un programme Python qui capture le signal `SIGINT` et l'ignore, ne s'arrêtant plus. Pour arrêter ce programme, nous pouvons maintenant utiliser le signal `SIGQUIT` à la place, en tapant `Ctrl-\`.

```python
#!/usr/bin/env python
import signal, time

def handler(signum, time) :
    print("J'ai reçu un SIGINT, mais je ne m'arrête pas")

signal.signal(signal.SIGINT, handler)
i = 0
while True :
    time.sleep(.1)
    print("\r{}".format(i), end="")
    i += 1
```

Voici ce qui se passe si nous envoyons deux fois `SIGINT` à ce programme, suivi de `SIGQUIT`. Notez que `^` est la façon dont `Ctrl` est affiché lorsqu'il est tapé dans le terminal.

```
$ python sigint.py
24^C
J'ai reçu un SIGINT, mais je ne m'arrête pas
26^C
J'ai reçu un SIGINT, mais je ne m'arrête pas
30^\[1] 39913 quit python sigint.py
```

Alors que `SIGINT` et `SIGQUIT` sont habituellement associés à des requêtes liées au terminal, un signal plus générique pour demander à un processus de quitter gracieusement est le signal `SIGTERM`.
Pour envoyer ce signal, nous pouvons utiliser la commande [`kill`](https://www.man7.org/linux/man-pages/man1/kill.1.html), avec la syntaxe `kill -TERM <PID>`.

## Mise en pause et mise en arrière-plan des processus

Les signaux peuvent faire d'autres choses que de terminer un processus. Par exemple, `SIGSTOP` met en pause un processus. Taper `Ctrl-Z` dans le terminal demandera à l'interpréteur de commandes d'envoyer un signal `SIGTSTP`, abréviation de "Terminal Stop" (c'est à dire la version du terminal de `SIGSTOP`).

Nous pouvons reprendre un processus en pause au premier plan ou en arrière-plan en utilisant [`fg`](https://www.man7.org/linux/man-pages/man1/fg.1p.html) ou [`bg`](http://man7.org/linux/man-pages/man1/bg.1p.html), respectivement.

La commande [`jobs`](https://www.man7.org/linux/man-pages/man1/jobs.1p.html) liste les jobs non terminés associés à la session de terminal en cours.
Vous pouvez vous référer à ces jobs en utilisant leur pid (vous pouvez utiliser [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) pour le trouver).
Plus intuitivement, vous pouvez aussi vous référer à un processus en utilisant le symbole "%" suivi de son numéro de job (affiché par `jobs`). Pour faire référence au dernier job mis en arrière-plan, vous pouvez utiliser le paramètre spécial `$!`.

Une autre chose à savoir est que le suffixe `&` dans une commande exécutera la commande en arrière-plan, vous rendant le prompt, bien qu'il utilisera toujours le STDOUT de l'interpréteur de commandes, ce qui peut être ennuyeux (utilisez les redirections de l'interpréteur de commandes dans ce cas).

Pour mettre en arrière-plan un programme déjà en cours d'exécution, vous pouvez faire `Ctrl-Z` suivi de `bg`.
Notez que les processus en arrière-plan sont toujours des processus enfants de votre terminal et ils mourront si vous fermez le terminal (ce qui enverra un autre signal, `SIGHUP`).
Pour éviter cela, vous pouvez lancer le programme avec [`nohup`](https://www.man7.org/linux/man-pages/man1/nohup.1.html) (un wrapper pour ignorer `SIGHUP`), ou utiliser `disown` si le processus a déjà été lancé.
Alternativement, vous pouvez utiliser un multiplexeur de terminal comme nous le verrons dans la section suivante.

Voici un exemple de session pour illustrer certains de ces concepts.

```
$ sleep 1000
^Z
[1]  + 18653 suspended  sleep 1000

$ nohup sleep 2000 &
[2] 18745
appending output to nohup.out

$ jobs
[1]  + suspended  sleep 1000
[2]  - running    nohup sleep 2000

$ bg %1
[1]  - 18653 continued  sleep 1000

$ jobs
[1]  - running    sleep 1000
[2]  + running    nohup sleep 2000

$ kill -STOP %1
[1]  + 18653 suspended (signal)  sleep 1000

$ jobs
[1]  + suspended (signal)  sleep 1000
[2]  - running    nohup sleep 2000

$ kill -SIGHUP %1
[1]  + 18653 hangup     sleep 1000

$ jobs
[2]  + running    nohup sleep 2000

$ kill -SIGHUP %2

$ jobs
[2]  + running    nohup sleep 2000

$ kill %2
[2]  + 18745 terminated  nohup sleep 2000

$ jobs

```

Un signal spécial est `SIGKILL` puisqu'il ne peut pas être capturé par le processus et qu'il le terminera toujours immédiatement. Cependant, il peut avoir des effets secondaires néfastes tels que laisser des processus enfants orphelins.

Vous pouvez en apprendre plus sur ces signaux et d'autres [ici](https://en.wikipedia.org/wiki/Signal_(IPC)) ou en tapant [`man signal`](https://www.man7.org/linux/man-pages/man7/signal.7.html) ou `kill -l`.


# Multiplexeurs de terminaux

Lorsque vous utilisez l'interface de ligne de commande, vous voudrez souvent exécuter plusieurs tâches en même temps.
Par exemple, vous voudrez peut-être exécuter votre éditeur et votre programme côte à côte.
Bien que cela puisse être réalisé en ouvrant de nouvelles fenêtres de terminal, l'utilisation d'un multiplexeur de terminal est une solution plus polyvalente.

Les multiplexeurs de terminal comme [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) vous permettent de multiplexer les fenêtres de terminal en utilisant des panneaux et des onglets afin que vous puissiez interagir avec plusieurs sessions de terminaux.
De plus, les multiplexeurs de terminaux vous permettent de détacher une session de terminal en cours et de la rattacher plus tard.
Cela peut améliorer votre efficacité lorsque vous travaillez sur des machines distantes, puisque vous n'avez pas besoin d'utiliser `nohup` et d'autres astuces similaires.

Le multiplexeur de terminal le plus populaire de nos jours est [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html). `tmux` est hautement configurable et en utilisant les raccourcis clavier associés, vous pouvez créer de multiples onglets et panneaux et naviguer rapidement entre eux.

`tmux` s'attend à ce que vous connaissiez ses raccourcis clavier, et ils ont tous la forme `<C-b> x` où cela signifie : (1) appuyez sur `Ctrl+b`, (2) relâchez `Ctrl+b`, et enfin (3) appuyez sur `x`. `tmux` possède la hiérarchie d'objets suivante :
- **Sessions** - une session est un espace de travail indépendant avec une ou plusieurs fenêtres
    + `tmux` démarre une nouvelle session.
    + `tmux new -s NOM` la démarre avec ce nom.
    + `tmux ls` liste les sessions en cours.
    + Dans `tmux`, taper `<C-b> d` détache la session en cours
    + `tmux a` attache la dernière session. Vous pouvez utiliser le drapeau `-t` pour spécifier quelle session vous souhaitez attacher

- **Fenêtres** - Équivalentes aux onglets dans les éditeurs ou les navigateurs web, elles sont des parties visuellement séparées de la même session.
    + `<C-b> c` Créer une nouvelle fenêtre. Pour la fermer, vous pouvez simplement terminer le shell en faisant `<C-d>`
    + `<C-b> N` Aller à la _N_ ième fenêtre. Notez qu'elles sont numérotées
    + `<C-b> p` Aller à la fenêtre précédente
    + `<C-b> n` Passer à la fenêtre suivante
    + `<C-b> ,` Renommer la fenêtre courante
    + `<C-b> w` Lister les fenêtres actuelles

- **Panneaux** - Comme les splits de vim, les panes vous permettent d'avoir plusieurs shells dans le même affichage visuel.
    + `<C-b> "` Séparer le panneau courant horizontalement
    + `<C-b> %` Séparer le panneau courant verticalement
    + `<C-b> <direction>` Se déplacer vers le panneau dans la _direction_ spécifiée. La direction signifie ici les touches flèches du clavier.
    + `<C-b> z` Activer le zoom pour le panneau actuel
    + `<C-b> [` Démarrer le défilement arrière. Vous pouvez ensuite appuyer sur `<espace>` pour commencer une sélection et sur `<enter>` pour copier cette sélection.
    + `<C-b> <space>` Faire défiler les dispositions des panneaux.

Pour plus d'informations, cliquez 
[ici](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) pour un tutoriel rapide sur `tmux` et [ici](http://linuxcommand.org/lc3_adv_termmux.php) pour une explication plus détaillée qui couvre la commande originale `screen`. Vous voudez aussi peut-être vous familiariser avec [`screen`](https://www.man7.org/linux/man-pages/man1/screen.1.html), puisqu'il est installé dans la plupart des systèmes UNIX.

# Alias

Il peut devenir fastidieux de taper de longues commandes qui contiennent de nombreux drapeaux ou des options verbeuses.
C'est pourquoi la plupart des interpréteurs de commandes supportent l'_aliasing_.
Un alias d'interpréteur de commandes est une forme courte pour une autre commande que votre interpréteur de commandes remplacera automatiquement pour vous.
Par exemple, un alias en bash possède la structure suivante :

```bash
alias alias_name="command_to_alias arg1 arg2"
```

Notez qu'il n'y a pas d'espace autour du signe égal `=`, car [`alias`](https://www.man7.org/linux/man-pages/man1/alias.1p.html) est une commande shell qui prend un seul argument.

Les alias ont de nombreuses utilités très pratiques :

```bash
# Faire des raccourcis pour les drapeaux communs
alias ll="ls -lh"

# Eviter de taper de longues commandes utilisées fréquemment
alias gs="git status"
alias gc= "git commit"
alias v="vim"

# Eviter les fautes de frappe
alias sl=ls

# Remplacer des commandes existantes avec de meilleures valeurs par défaut
alias mv="mv -i" # -i demande une confirmation avant d'écraser un fichier/dossier
alias mkdir="mkdir -p" # -p crée les répertoires parents s'ils manquent
alias df="df -h" # -h améliore la lisibilité

# Les alias peuvent être composés
alias la="ls -A"
alias lla="la -l"

# Pour ignorer un alias, exécutez-le en le faisant précéder par \
\ls
# Ou désactivez complètement un alias avec unalias
unalias la

# Pour obtenir une définition d'alias existant, il suffit de l'appeler avec alias
alias ll
# Imprime ll='ls -lh'
```

Notez que les alias ne se conservent pas entre plusieurs sessions de l'interpréteur de commandes par défaut.
Pour rendre un alias persistant, vous devez l'inclure dans les fichiers de démarrage de l'interpréteur de commandes, comme `.bashrc` ou `.zshrc`, que nous allons présenter dans la section suivante.


# Dotfiles

De nombreux programmes sont configurés à l'aide de fichiers texte connus sous le nom de _dotfiles_
(parce que les noms des fichiers commencent par un `.`, par exemple `~/.vimrc`, de sorte qu'ils soient
cachés dans le résultat de la commande `ls` par défaut).

Les shells sont un exemple de programmes configurés avec de tels fichiers. Au démarrage, votre interpréteur de commandes lira de nombreux fichiers pour charger sa configuration.
Selon l'interpréteur de commandes, que vous lanciez une session de connexion et/ou interactive, l'ensemble du processus peut s'avérer assez complexe.
[Cliquez ici](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) pour une excellente ressource sur le sujet.

Pour `bash`, modifier votre fichier `.bashrc` ou `.bash_profile` fonctionnera dans la plupart des systèmes.
Vous pouvez y inclure les commandes que vous voulez lancer au démarrage, comme l'alias que nous venons de décrire ou les modifications de votre variable d'environnement `PATH`.
En fait, de nombreux programmes vous demanderont d'inclure une ligne comme `export PATH="$PATH:/path/to/program/bin"` dans votre fichier de configuration de l'interpréteur de commandes afin que leurs binaires puissent être trouvés.

D'autres exemples d'outils qui peuvent être configurés à l'aide des fichiers dotfiles sont :

- `bash` - `~/.bashrc`, `~/.bash_profile`
- `git` - `~/.gitconfig`
- `vim` - `~/.vimrc` et le dossier `~/.vim`.
- `ssh` - `~/.ssh/config`
- `tmux` - `~/.tmux.conf`

Comment devez-vous organiser vos fichiers dotfiles ? Ils devraient être dans leur propre dossier,
sous contrôle de version, et **symlinkés** à l'aide d'un script. Cela présente les
les avantages suivants :

- **Installation facile** : si vous vous connectez à une nouvelle machine, la mise en place de vos configurations ne prendra 
qu'une minute.
- **Portabilité** : vos outils fonctionneront partout de la même manière.
- **Synchronisation** : vous pouvez mettre à jour vos fichiers dotfiles n'importe où et les garder tous 
synchronisés.
- **Suivi des modifications** : vous allez probablement maintenir vos fichiers dotfiles
pour toute votre carrière de programmeur, et l'historique des versions est utile
pour les projets de longue durée.

Que devriez-vous mettre dans vos dotfiles ?
Vous pouvez vous renseigner sur les paramètres de votre outil en lisant sa documentation en ligne ou les
[pages de manuel](https://en.wikipedia.org/wiki/Man_page). Une autre méthode consiste à chercher sur internet des articles 
de blog sur des programmes spécifiques, où les auteurs vous parleront de leurs
configurations préférées. Une autre façon d'en apprendre plus sur les personnalisations possibles
est de consulter les fichiers dotfiles d'autres personnes : vous pouvez trouver pleins de
[dépôts
dotfiles](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories)
sur Github --- voir le plus populaire
[ici](https://github.com/mathiasbynens/dotfiles) (nous vous conseillons cependant de ne pas
de copier aveuglément les configurations).
[Cliquez ici](https://dotfiles.github.io/) pour une autre bonne ressource sur le sujet.

Tous les professeurs du cours ont leurs dotfiles accessibles publiquement sur GitHub : [Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/jjgo/dotfiles).


## Portabilité

Un problème courant avec les dotfiles est que les configurations peuvent ne pas fonctionner lorsque l'on travaille avec plusieurs machines, par exemple si elles ont des systèmes d'exploitation ou des shells différents. Parfois, on voudrait également qu'une configuration ne soit appliquée que sur une seule machine.

Il existe quelques astuces pour faciliter cette tâche.
Si le fichier de configuration le permet, utilisez l'équivalent des conditions "if" pour
appliquer des personnalisations spécifiques à une machine. Par exemple, votre interpréteur de commandes pourrait avoir quelque chose
comme :

```bash
if [[ "$(uname)" == "Linux" ]] ; then {do_something} ; fi

# Vérification avant d'utiliser des fonctionnalités spécifiques à un certain interpréteur de commandes
if [[ "$SHELL" == "zsh" ]] ; then {do_something} ; fi

# Vous pouvez aussi le rendre spécifique à la machine
if [[ "$(hostname)" == "myServer" ]] ; then {do_something} ; fi
```

Si le fichier de configuration le permet, utilisez les includes. Par exemple, un fichier `~/.gitconfig` 
peut contenir un paramètre :

```
[include]
    path = ~/.gitconfig_local
```

Sur chaque machine, `~/.gitconfig_local` peut contenir des paramètres spécifiques à cette
machine. Vous pouvez même gérer ces fichiers dans un dépôt GitHub séparé pour les
paramètres spécifiques à chaque machine.

Cette idée est également utile si vous voulez que différents programmes partagent certaines configurations. Par exemple, si vous voulez que `bash` et `zsh` partagent le même ensemble d'alias, vous pouvez les écrire dans `.aliases` et avoir le bloc suivant dans les deux fichiers de configuration:

```bash
# Tester si ~/.aliases existe et le référencer
if [ -f ~/.aliases ] ; then
    source ~/.aliases
fi
```

# Machines distantes

Il est de plus en plus courant pour les programmeurs d'utiliser des serveurs distants dans leur travail quotidien. Si vous avez besoin d'utiliser des serveurs distants pour déployer des logiciels backend ou si vous avez besoin d'un serveur doté de capacités de calcul plus importantes, vous finirez par utiliser un Secure Shell (SSH). Comme la plupart des outils abordés, SSH est hautement configurable, il vaut donc la peine d'apprendre à le connaître.

Pour se connecter sur un serveur en `ssh`, vous devrez exécuter une commande comme suit

```bash
ssh foo@bar.mit.edu
```

Ici, nous essayons de nous connecter en tant qu'utilisateur `foo` au serveur `bar.mit.edu`.
Le serveur peut être spécifié par une URL (comme `bar.mit.edu`) ou une IP (quelque chose comme `foobar@192.168.1.42`). Plus tard, nous verrons que si nous modifions le fichier de configuration de ssh, vous pourrez accéder au serveur en utilisant une commande comme `ssh bar`.

## Exécuter des commandes

Une fonctionnalité souvent négligée de `ssh` est la possibilité d'exécuter des commandes directement.
`ssh foobar@server ls` exécutera `ls` dans le dossier home de foobar.
Cela fonctionne aussi avec les pipes, donc `ssh foobar@server ls | grep PATTERN` va "greper" localement la sortie distante de `ls` et `ls | ssh foobar@server grep PATTERN` va "greper" à distance la sortie locale de `ls`.


## Clés SSH

L'authentification par clé utilise la cryptographie à clé publique pour prouver au serveur que le client possède la clé privée secrète sans révéler la clé. De cette façon, vous n'avez pas besoin de ressaisir votre mot de passe à chaque fois. Néanmoins, la clé privée (souvent `~/.ssh/id_rsa` et plus récemment `~/.ssh/id_ed25519`) est en fait votre mot de passe, alors traitez-la comme tel.

### Génération des clés

Pour générer une paire de clés, vous pouvez lancer [`ssh-keygen`](https://www.man7.org/linux/man-pages/man1/ssh-keygen.1.html).
```bash
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519
```
Vous devrez choisir une phrase secrète, afin d'éviter que quelqu'un qui s'empare de votre clé privée n'accède aux serveurs autorisés. Utilisez [`ssh-agent`](https://www.man7.org/linux/man-pages/man1/ssh-agent.1.html) ou [`gpg-agent`](https://linux.die.net/man/1/gpg-agent) pour ne pas avoir à taper votre phrase secrète à chaque fois.

Si vous avez déjà configuré la connexion vers GitHub en utilisant des clés SSH, alors vous avez probablement fait les étapes décrites [ici](https://help.github.com/articles/connecting-to-github-with-ssh/) et vous avez déjà une paire de clés valide. Pour vérifier si vous avez une phrase secrète et la valider, vous pouvez lancer `ssh-keygen -y -f /path/to/key`.

### Authentification par clé

`ssh` va regarder dans le fichier `.ssh/authorized_keys` pour déterminer quels clients il doit laisser entrer. Pour copier une clé publique dans ce fichier, vous pouvez utiliser :

```bash
cat .ssh/id_ed25519.pub | ssh foobar@remote 'cat >> ~/.ssh/authorized_keys'
```

Une solution plus simple est d'utiliser `ssh-copy-id` lorsqu'il est disponible :

```bash
ssh-copy-id -i .ssh/id_ed25519 foobar@remote
```

## Copier des fichiers via SSH

Il y a plusieurs façons de copier des fichiers via ssh :

- `ssh+tee`, la plus simple est d'utiliser l'exécution de la commande `ssh` et l'entrée STDIN en faisant `cat localfile | ssh remote_server tee serverfile`. Rappelons que [`tee`](https://www.man7.org/linux/man-pages/man1/tee.1.html) écrit la sortie de STDIN dans un fichier.
- [`scp`](https://www.man7.org/linux/man-pages/man1/scp.1.html) Lors de la copie d'un grand nombre de fichiers/dossiers, la commande de copie sécurisée `scp` est plus pratique car elle peut facilement parcourir la structure des fichiers/dossiers. La syntaxe est `scp path/to/local_file remote_host:path/to/remote_file`
- [`rsync`](https://www.man7.org/linux/man-pages/man1/rsync.1.html) améliore `scp` en détectant les fichiers identiques en local et à distance, et en empêchant de les copier à nouveau. Il fournit également un contrôle plus fin sur les liens symboliques, les permissions et possède des fonctionnalités supplémentaires comme le drapeau `--partial` qui permet de reprendre une copie précédemment interrompue. `rsync` a une syntaxe similaire à `scp`.

## Redirection de port

Dans de nombreux scénarios, vous rencontrerez des logiciels qui écoutent des ports spécifiques de la machine. Lorsque cela se passe sur votre machine locale, vous pouvez taper `localhost:PORT` ou `127.0.0.1:PORT`, mais que faites-vous avec un serveur distant qui n'a pas ses ports directement disponibles à travers le réseau/internet ?

C'est ce que l'on appelle le _port forwarding_ et il
se présente sous deux formes : Local Port Forwarding et Remote Port Forwarding (voir les images pour plus de détails, crédit des images de [ce post StackOverflow](https://unix.stackexchange.com/questions/115897/whats-ssh-port-forwarding-and-whats-the-difference-between-ssh-local-and-remot)).

**Local Port Forwarding**
![Local Port Forwarding](https://i.stack.imgur.com/a28N8.png "Local Port Forwarding")

**Remote Port Forwarding** 
![Remote Port Forwarding](https://i.stack.imgur.com/4iK3b.png "Remote Port Forwarding")

Le scénario le plus courant est le "Local Port Forwarding", où un service sur machine distante écoute sur un port et vous voulez lier un port sur votre machine locale en redirection vers le port distant. Par exemple, nous exécutons `jupyter notebook` sur le serveur distant qui écoute sur le port `8888`. Ainsi, pour le transférer sur le port local `9999`, nous ferons `ssh -L 9999:localhost:8888 foobar@remote_server` et ensuite nous naviguerons vers `localhost:9999` sur notre machine locale.


## Configuration SSH

Nous avons déjà vu de nombreux arguments que nous pouvons passer à la commande ssh. Une alternative tentante serait de créer des alias shell qui ressemblent à
```bash
alias my_server="ssh -i ~/.id_ed25519 --port 2222 -L 9999:localhost:8888 foobar@remote_server
```

Cependant, il existe une meilleure alternative en utilisant le fichier de configuration `~/.ssh/config`.

```bash
Host vm
    User foobar
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
    LocalForward 9999 localhost:8888

# Les configurations peuvent également contenir des wildcards
Host *.mit.edu
    User foobaz
```

Un avantage supplémentaire de l'utilisation du fichier `~/.ssh/config` par rapport aux alias est que d'autres programmes comme `scp`, `rsync`, `mosh`, etc. sont capables de le lire aussi et de convertir les réglages en drapeaux correspondants.


Notez que le fichier `~/.ssh/config` peut être considéré comme un fichier dotfile, et en général il est acceptable qu'il soit inclus avec le reste de vos fichiers dotfiles. Cependant, si vous le rendez public, pensez aux informations que vous fournissez potentiellement aux étrangers sur Internet : adresses de vos serveurs, utilisateurs, ports ouverts, etc. Cela pourrait faciliter certains types d'attaques, alors réfléchissez bien avant de partager votre configuration SSH.

La configuration côté serveur est habituellement spécifiée dans `/etc/ssh/sshd_config`. Ici vous pouvez faire des changements comme désactiver l'authentification par mot de passe, changer les ports ssh, activer la redirection X11, etc. Vous pouvez aussi spécifier les paramètres de configuration pour chaque utilisateur.

## Divers

Les déconnexions dues à l'arrêt de l'ordinateur, à sa mise en veille ou à un changement de réseau sont des problèmes courant lorsque l'on se connecte à un serveur distant. De plus, si l'on dispose d'une connexion avec un décalage important, l'utilisation de ssh peut devenir très frustrante. [Mosh](https://mosh.org/), l'interpréteur de commandes mobile, améliore ssh en permettant des connexions itinérantes, une connectivité intermittente et en fournissant un écho local intelligent.

Il est parfois pratique de monter un dossier distant. [sshfs](https://github.com/libfuse/sshfs) permet de monter localement un dossier sur un serveur distant, 
ce qui permet d'utiliser un éditeur local.


# Shells et frameworks

Dans le cours "Les outils de Shell et les scripts", nous avons abordé l'interpréteur de commandes `bash` car c'est de loin l'interpréteur le plus répandu et la plupart des systèmes l'ont par défaut. Néanmoins, ce n'est pas la seule option.

Par exemple, l'interpréteur de commandes `zsh` est un surensemble de `bash` et fournit de nombreuses fonctionnalités pratiques telles que :

- Des filtres sur les fichiers plus intelligents, `**`
- L'expansion des wildcards
- Correction orthographique
- Meilleure complétion/sélection de tabulations
- Expansion de chemin (`cd /u/lo/b` sera étendu en `/usr/local/bin`)

Des **frameworks** peuvent également améliorer votre interpréteur de commandes. Quelques frameworks généraux populaires sont [prezto](https://github.com/sorin-ionescu/prezto) ou [oh-my-zsh](https://ohmyz.sh/), et d'autres plus petits qui se concentrent sur des fonctionnalités spécifiques comme [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) ou [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search). Des shells comme [fish](https://fishshell.com/) incluent par défaut un grand nombre de ces fonctionnalités user-friendly. Voici quelques-unes de ces fonctionnalités :

- Invite de commande à droite
- Coloration syntaxique des commandes
- Recherche de sous-chaînes de caractères dans l'historique
- Complétions des drapeaux basées sur la page de manuel
- Autocomplétion plus intelligente
- Thèmes d'invite de commande

Une chose à noter lorsque vous utilisez ces frameworks est qu'ils peuvent ralentir votre shell, en particulier si le code qu'ils exécutent n'est pas correctement optimisé ou s'il y a trop de code. Vous pouvez toujours profiler le temps d'exécution et désactiver les fonctionnalités que vous n'utilisez pas souvent ou que vous ne privilégiez pas par rapport à la vitesse.

# Emulateurs de terminal

En plus de personnaliser votre shell, il vaut la peine de passer un peu de temps à choisir votre **émulateur de terminal** et à le paramétrer. Il existe de nombreux émulateurs de terminal (voici une [comparaison](https://anarc.at/blog/2018-04-12-terminal-emulators-1/)).

Comme vous risquez de passer des centaines, voire des milliers d'heures dans votre terminal, il vaut la peine de se pencher sur ses paramètres. Voici quelques-uns des aspects que vous souhaiterez peut-être modifier dans votre terminal :

- le choix de la police de caractères
- Palette de couleurs
- Raccourcis clavier
- Prise en charge des onglets et des volets
- Configuration du défilement
- Performance (certains terminaux plus récents comme [Alacritty](https://github.com/jwilm/alacritty) ou [kitty](https://sw.kovidgoyal.net/kitty/) proposent l'accélération GPU).

# Exercices

## Contrôle des tâches

1. D'après ce que nous avons vu, nous pouvons utiliser quelques commandes `ps aux | grep` pour obtenir les pids de nos jobs et ensuite les tuer, mais il y a de meilleures façons de le faire. Démarrez un job `sleep 10000` dans un terminal, mettez-le en tâche de fond avec `Ctrl-Z` et continuez son exécution avec `bg`. Maintenant, utilisez [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) pour trouver son pid et [`pkill`](http://man7.org/linux/man-pages/man1/pgrep.1.html) pour le tuer sans jamais taper le pid lui-même. (Astuce : utilisez les drapeaux `-af`).

1. Supposons que vous ne souhaitez pas lancer un processus tant qu'un autre n'est pas terminé. Comment feriez-vous ? Dans cet exercice, notre processus limitant sera toujours `sleep 60 &`.
Une façon d'y parvenir est d'utiliser la commande [`wait`](https://www.man7.org/linux/man-pages/man1/wait.1p.html). Essayez de lancer la commande sleep et de faire patienter `ls` jusqu'à ce que le processus en arrière-plan se termine.

    Cependant, cette stratégie échouera si nous démarrons dans une session bash différente, puisque `wait` ne fonctionne que pour les processus enfants. Une caractéristique que nous n'avons pas abordée dans les notes est que le statut de sortie de la commande `kill` sera zéro en cas de succès et non nul dans le cas contraire. `kill -0` n'envoie pas de signal mais donnera un statut de sortie non nul si le processus n'existe pas.
    Ecrivez une fonction bash appelée `pidwait` qui prend un pid et attend que le processus donné se termine. Vous devriez utiliser `sleep` pour éviter de gaspiller du temps CPU inutilement.

## Multiplexeur de terminaux

1. Suivez ce [tutoriel](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) `tmux` et apprenez ensuite à faire quelques personnalisations de base en suivant [ces étapes](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/).

## Alias

1. Créez un alias `dc` qui se résout en `cd` pour les cas où vous le taperiez mal.

1.  Lancez `history | awk '{$1="";print substr($0,2)}' | tri | uniq -c | sort -n | tail -n 10` pour obtenir vos 10 commandes les plus utilisées et envisagez d'écrire des alias plus courts pour celles-ci. Note : ceci fonctionne pour Bash ; si vous utilisez ZSH, utilisez `history 1` au lieu de `history`.


## Dotfiles

Familiarisons nous avec les dotfiles.
1. Créez un dossier pour vos dotfiles et mettez en place un contrôle de
   version.
1. Ajoutez une configuration pour au moins un programme, par exemple votre shell, avec un peu de personnalisation (pour commencer, cela peut être quelque chose d'aussi simple que de personnaliser l'invite de votre shell en définissant `$PS1`).
1. Mettez en place une méthode pour installer vos dotfiles rapidement (et sans effort manuel) sur une nouvelle machine. Cela peut être aussi simple qu'un script shell qui appelle `ln -s` pour chaque fichier, ou vous pouvez utiliser un [utilitaire spécialisé](https://dotfiles.github.io/utilities/).
1. Testez votre script d'installation sur une nouvelle machine virtuelle.
1. Migrez toutes vos configurations d'outils actuelles vers votre dépôt de vos dotfiles.
1. Publiez vos dotfiles sur GitHub.

## Machines distantes

Installez une machine virtuelle Linux (ou utilisez une machine virtuelle existante) pour cet exercice. Si vous n'êtes pas familier avec les machines virtuelles, consultez [ce tutoriel](https://hibbard.eu/install-ubuntu-virtual-box/) pour en installer une.

1. Allez dans `~/.ssh/` et vérifiez si vous avez une paire de clés SSH. Si ce n'est pas le cas, générez-les avec `ssh-keygen -o -a 100 -t ed25519`. Il est recommandé d'utiliser un mot de passe et `ssh-agent`, plus d'informations [ici](https://www.ssh.com/ssh/agent).
1. Editez votre fichier `.ssh/config` pour avoir une entrée comme suit

    ```bash
    Host vm
        User username_goes_here
        HostName ip_goes_here
        IdentityFile ~/.ssh/id_ed25519
        LocalForward 9999 localhost:8888
    ```


1. Utilisez `ssh-copy-id vm` pour copier votre clé ssh sur le serveur.
1. Démarrez un serveur web dans votre VM en exécutant `python -m http.server 8888`. Accédez au serveur web de la VM en naviguant sur `http://localhost:9999` sur votre machine.
1. Editez la configuration de votre serveur SSH en faisant `sudo vim /etc/ssh/sshd_config` et désactivez l'authentification par mot de passe en éditant la valeur de `PasswordAuthentication`. Désactivez le login root en éditant la valeur de `PermitRootLogin`. Redémarrez le service `ssh` avec `sudo service sshd restart`. Essayez de vous connecter à nouveau.
1. (Défi) Installez [`mosh`](https://mosh.org/) dans la VM et établissez une connexion. Ensuite, déconnectez l'adaptateur réseau du serveur/VM. Est-ce que mosh peut s'en remettre correctement ?
1. (Défi) Regardez ce que font les drapeaux `-N` et `-f` dans la commande `ssh` et trouvez une commande pour réaliser une redirection de port en arrière-plan.