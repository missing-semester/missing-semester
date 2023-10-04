---
layout: lecture
title: "Pot-pourri"
date: 2020-01-29
ready: true
video:
  aspect: 56.25
  id: JZDt-PRq0uo
---

## Table des matières

- [Configuration du clavier](#configuration-du-clavier)
- [Daemons](#daemons)
- [FUSE](#fuse)
- [Sauvegardes](#sauvegardes)
- [APIs](#apis)
- [Flags/patterns courants de la ligne de commande](#flagspatterns-courants-de-la-ligne-de-commande)
- [Gestionnaires de fenêtres](#gestionnaires-de-fenêtres)
- [VPNs](#vpns)
- [Markdown](#markdown)
- [Hammerspoon (automatisation du bureau sur macOS)](#hammerspoon-automatisation-du-bureau-sur-macOS)
- [Démarrage + Live USB](#démarrage--live-USB)
- [Docker, Vagrant, VMs, Cloud, OpenStack](#docker-vagrant-vms-cloud-openstack)
- [Notebook programming](#notebook-programming)
- [GitHub](#github)

## Configuration du clavier

En tant que programmeur, votre clavier est votre principale méthode d'entrée. Comme pour la plupart des éléments de votre ordinateur, il est configurable (et mérite de l'être).

La modification la plus élémentaire consiste à réaffecter les touches. Cela implique généralement un logiciel qui écoute et, chaque fois qu'une certaine touche est pressée, intercepte cet événement et le remplace par un autre événement correspondant à une touche différente. Quelques exemples :
- Remplacer Caps Lock par Ctrl ou Escape. Nous (les instructeurs) encourageons vivement ce réglage, car Caps Lock est situé à un endroit très pratique, mais est rarement utilisé.
- Remplacer PrtSc par Play/Pause music. La plupart des systèmes d'exploitation disposent d'une touche de lecture/pause.
- Échanger Ctrl et la touche Meta (Windows ou Commande).

Vous pouvez également associer des touches à des commandes arbitraires de votre choix. Cette fonction est utile pour les tâches courantes que vous effectuez. Ici, un logiciel est à l'écoute d'une combinaison de touches spécifique et exécute un script dès que cet événement est détecté.
- Ouvrir une nouvelle fenêtre de terminal ou de navigateur.
- Insérer un texte spécifique, par exemple votre adresse mail ou votre numéro d'identification MIT.
- Mettre en veille l'ordinateur ou les écrans.

Il existe des modifications encore plus complexes que vous pouvez configurer :
- Remplacement de séquences de touches, par exemple en appuyant cinq fois sur la touche Majuscule pour activer le Caps Lock.
- Remplacer par example la touche Caps Lock par la touche Esc si vous la touchez rapidement, mais remplacée par la touche Ctrl si vous la maintenez enfoncée.
- Le fait que les remplacements soient spécifiques au clavier ou au logiciel.


Quelques ressources logicielles pour commencer sur le sujet :

- macOS - [karabiner-elements](https://karabiner-elements.pqrs.org/), [skhd](https://github.com/koekeishiya/skhd) ou [BetterTouchTool](https://folivora.ai/)
- Linux - [xmodmap](https://wiki.archlinux.org/index.php/Xmodmap) ou [Autokey](https://github.com/autokey/autokey)
- Windows - intégré dans le panneau de configuration, [AutoHotkey](https://www.autohotkey.com/) ou [SharpKeys](https://www.randyrants.com/category/sharpkeys/)
- QMK - Si votre clavier prend en charge un firmware personnalisé, vous pouvez utiliser [QMK](https://docs.qmk.fm/) pour configurer le périphérique matériel lui-même afin que les remplacements fonctionnent sur toutes les machines avec lesquelles vous utilisez le clavier.

## Daemons

Vous êtes probablement déjà familiarisé avec la notion de daemon, même si le mot vous semble nouveau. La plupart des ordinateurs disposent d'une série de processus qui tournent en permanence en arrière-plan plutôt que d'attendre qu'un utilisateur les lance et interagisse avec eux. Ces processus sont appelés daemons et les programmes qui s'exécutent en tant que daemons se terminent souvent par un `d` pour l'indiquer. Par exemple, `sshd`, le daemon SSH, est le programme chargé d'écouter les requêtes SSH entrantes et de vérifier que l'utilisateur distant dispose des informations d'identification nécessaires pour se connecter.

Sous Linux, `systemd` (le daemon système) est la solution la plus courante pour exécuter et configurer les processus daemon. Vous pouvez exécuter `systemctl status` pour obtenir la liste des daemons en cours d'exécution. La plupart d'entre eux peuvent sembler peu familiers, mais ils sont responsables de parties essentielles du système, telles que la gestion du réseau, la résolution des requêtes DNS ou l'affichage de l'interface graphique du système. Vous pouvez interagir avec Systemd avec la commande `systemctl` afin d'activer (`enable`), de désactiver (`disable`), de démarrer (`start`), d'arrêter (`stop`), de redémarrer (`restart`) ou de vérifier  l'état des services (`status`) (ce sont les commandes `systemctl`).

Plus intéressant encore, `systemd` dispose d'une interface assez accessible pour configurer et activer de nouveaux daemons (ou services). Voici un exemple de daemon permettant d'exécuter une simple application Python. Nous n'entrerons pas dans les détails, mais comme vous pouvez le voir, la plupart des champs sont assez explicites.

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Custom App
After=network.target

[Service]
User=foo
Group=foo
WorkingDirectory=/home/foo/projects/mydaemon
ExecStart=/usr/bin/local/python3.7 app.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

De même, si vous souhaitez simplement exécuter un programme à une fréquence donnée, il n'est pas nécessaire de créer un daemon personnalisé. Vous pouvez utiliser [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html), un daemon que votre système exécute déjà pour effectuer des tâches planifiées.

## FUSE

Les systèmes logiciels modernes sont généralement composés de blocs plus petits qui sont assemblés ensemble. Votre système d'exploitation prend en charge l'utilisation de différents backends de systèmes de fichiers parce qu'il existe un langage commun pour les opérations qu'un système de fichiers prend en charge. Par exemple, lorsque vous exécutez `touch` pour créer un fichier, `touch` effectue un appel système au noyau pour créer le fichier et le noyau effectue l'appel système de fichiers approprié pour créer le fichier donné. Une mise en garde s'impose : les systèmes de fichiers UNIX sont traditionnellement mis en oeuvre en tant que modules du noyau et seul le noyau est autorisé à effectuer des appels au système de fichiers.

[FUSE](https://en.wikipedia.org/wiki/Filesystem_in_Userspace) (Filesystem in User Space) permet aux systèmes de fichiers d'être implementé par un programme utilisateur. FUSE permet aux utilisateurs d'exécuter le code de l'espace utilisateur pour les appels au système de fichiers, puis d'établir des ponts entre les appels nécessaires et les interfaces du noyau. En pratique, cela signifie que les utilisateurs peuvent mettre en oeuvre des fonctionnalités arbitraires pour les appels au système de fichiers.

Par exemple, FUSE peut être utilisé pour que chaque fois que vous effectuez une opération dans un système de fichiers virtuel, cette opération soit transmise via SSH à une machine distante, y soit exécutée et que la sortie vous soit renvoyée. De cette manière, les programmes locaux peuvent voir le fichier comme s'il se trouvait sur votre ordinateur alors qu'en réalité il se trouve sur un serveur distant. C'est concrètement ce que fait `sshfs`.

Voici quelques exemples intéressants de systèmes de fichiers FUSE :

- [sshfs](https://github.com/libfuse/sshfs) Ouvrir localement des fichiers/dossiers distants via une connexion SSH.
- [rclone](https://rclone.org/commands/rclone_mount/) - Monter des services de stockage cloud comme Dropbox, GDrive, Amazon S3 ou Google Cloud Storage et ouvrir les données localement.
- [gocryptfs](https://nuetzlich.net/gocryptfs/) - Système de recouvrement chiffré. Les fichiers sont stockés de manière cryptée, mais une fois que le système de fichiers est monté, ils apparaissent en clair dans le point de montage.
- [kbfs](https://keybase.io/docs/kbfs) - Système de fichiers distribué avec chiffrement de bout en bout. Vous pouvez avoir des dossiers privés, partagés et publics.
- [borgbackup](https://borgbackup.readthedocs.io/en/stable/usage/mount.html) - Monter vos sauvegardes dédupliquées, compressées et cryptées pour faciliter la navigation.

## Sauvegardes

Toutes les données que vous n'avez pas sauvegardées sont des données qui peuvent disparaître à tout moment, pour toujours. Il est facile de copier des données, mais il est difficile de les sauvegarder de manière fiable. Voici quelques bonnes bases de sauvegarde et les pièges de certaines approches.

Tout d'abord, une copie des données sur le même disque n'est pas une sauvegarde, car le disque est le seul point de défaillance pour toutes les données. De même, un disque externe à votre domicile n'est pas non plus une bonne solution de sauvegarde, car il peut être perdu en cas d'incendie, de vol, etc. Il est donc recommandé d'effectuer une sauvegarde off-site.

Les solutions de synchronisation ne sont pas des sauvegardes. Par exemple, Dropbox/GDrive sont des solutions pratiques, mais lorsque des données sont effacées ou corrompues, elles propagent le changement. Pour la même raison, les solutions de mise en miroir de disques comme RAID ne sont pas des sauvegardes. Elles ne sont d'aucune utilité si les données sont supprimées, corrompues ou cryptées par un ransomware.

Les principales caractéristiques d'une bonne solution de sauvegarde sont le versioning, la déduplication et la sécurité. Les sauvegardes de versions vous permettent d'accéder à l'historique des modifications et de récupérer efficacement les fichiers. Les solutions de sauvegarde efficaces utilisent la déduplication des données pour ne stocker que les modifications incrémentielles et réduire la charge de stockage. En ce qui concerne la sécurité, vous devez vous demander ce que quelqu'un devrait savoir ou posséder pour lire vos données et, plus important encore, pour supprimer toutes vos données et les sauvegardes associées. Enfin, faire aveuglément confiance aux sauvegardes est une mauvaise idée et vous devriez vérifier régulièrement que vous pouvez les utiliser pour récupérer des données.

Les sauvegardes vont au-delà des fichiers locaux de votre ordinateur. Compte tenu de la croissance significative des applications web, de grandes quantités de vos données sont stockées uniquement dans le cloud. Par exemple, votre webmail, vos photos sur les réseaux sociaux, vos playlists de musique dans les services de streaming ou vos documents en ligne disparaissent si vous perdez l'accès aux comptes correspondants. L'idéal est de disposer d'une copie hors ligne de ces informations, et vous pouvez trouver des outils en ligne conçus pour récupérer les données et les sauvegarder.

Pour une explication plus détaillée, voir les notes de cours de 2019 sur les [sauvegardes](/2019/backups). 

## APIs

Nous avons beaucoup parlé dans ce cours de l'utilisation plus efficace de votre ordinateur pour accomplir des tâches _en local_, mais vous constaterez que bon nombre de ces leçons s'appliquent également à l'Internet au sens large. La plupart des services en ligne ont des "API" qui vous permettent d'accéder à leurs données via la programmation. Par exemple, le gouvernement américain dispose d'une API qui vous permet d'obtenir les prévisions météorologiques, que vous pouvez utiliser pour obtenir facilement des prévisions météorologiques dans votre shell.

La plupart de ces API ont un format similaire. Il s'agit d'URL structurées, souvent basée sur `api.service.com`, où le chemin et les paramètres de la requête indiquent les données que vous voulez lire ou l'action que vous voulez effectuer. Pour les données météorologiques américaines, par exemple, afin d'obtenir les prévisions pour un lieu particulier, vous envoyez une requête GET (avec `curl` par exemple) à https://api.weather.gov/points/42.3604,-71.094. La réponse elle-même contient une série d'autres URL qui vous permettent d'obtenir des prévisions spécifiques pour cette région. En général, les réponses sont formatées en JSON, que vous pouvez ensuite passer à un outil comme [`jq`](https://stedolan.github.io/jq/) pour en extraire ce qui vous intéresse.

Certaines API nécessitent une authentification, qui prend généralement la forme d'une sorte de _jeton_ (token) secret que vous devez inclure dans la requête. Vous devriez lire la documentation de l'API pour savoir ce que le service particulier que vous recherchez utilise, mais "[OAuth](https://www.oauth.com/)" est un protocole que vous verrez souvent utilisé. En résumé, OAuth est un moyen de vous donner des tokens qui peuvent "agir comme vous" sur un service donné, et qui ne peuvent être utilisés qu'à des fins particulières.  Gardez à l'esprit que ces tokens sont _secrets_, et que toute personne ayant accès à votre token peut faire tout ce que le token autorise avec _votre_ identifiant !

[IFTTT](https://ifttt.com/) est un site web et un service centré sur l'idée d'API - il fournit des intégrations avec des tonnes de services, et vous permet de chaîner des événements à partir d'eux de manière presque arbitraire. Jetez-y un coup d'oeil !

## Flags/patterns courants de la ligne de commande

Les outils de ligne de commande varient beaucoup et vous voudrez souvent consulter leurs pages de manuel (`man`) avant de les utiliser. Cependant, ils présentent souvent des caractéristiques communes qu'il peut être utile de connaître :

- La plupart des outils supportent une sorte de flag `--help` pour afficher de brèves instructions d'utilisation de l'outil.
- De nombreux outils qui peuvent entraîner des modifications irrévocables prennent en charge la notion d'"exécution à blanc", dans laquelle ils se contentent d'afficher ce qu'ils _auraient fait_, mais n'effectuent pas réellement la modification. De même, ils disposent souvent d'un flag "interactif" qui vous averti avant d'effectuer chaque action destructrice.
- Vous pouvez généralement utiliser `--version` ou `-V` pour que le programme affiche sa version (pratique pour signaler les bugs !).
- Presque tous les outils disposent d'un flag `--verbose` ou `-v` pour produire une sortie plus verbeuse. Vous pouvez généralement inclure le flag plusieurs fois (`-vvv`) pour obtenir une sortie _encore plus_ verbeuse, ce qui peut s'avérer pratique pour le débogage. De même, de nombreux outils disposent d'une option `--quiet` pour n'afficher que les erreurs.
- Dans de nombreux outils, `-` à la place d'un nom de fichier signifie "entrée standard" ou "sortie standard", en fonction de l'argument.
- Les outils éventuellement destructifs ne sont généralement pas récursifs par défaut, mais supportent un flag "récursif" (souvent `-r`) pour les rendre récursifs.
- Parfois, vous souhaitez passer quelque chose qui _ressemble_ à un flag en tant qu'argument normal. Par exemple, imaginez que vous souhaitiez supprimer un fichier appelé `-r`. Ou vous voulez exécuter un programme "à travers" un autre, comme `ssh machine foo`, et vous voulez passer un flag au programme "interne" (`foo`). L'argument spécial `--` permet au programme de ne _pas_ traiter les flags et les options (les choses commençant par `-`) dans ce qui suit, ce qui vous permet de passer des choses qui ressemblent à des drapeaux sans qu'elles soient interprétées comme telles : `rm -- -r` ou `ssh machine --for-ssh -- foo --for-foo`.

## Gestionnaires de fenêtres

La plupart d'entre vous ont l'habitude d'utiliser un gestionnaire de fenêtres par "glisser-déposer", comme celui fourni par défaut avec Windows, macOS et Ubuntu. Il s'agit de fenêtres qui restent suspendues à l'écran et que vous pouvez déplacer, redimensionner et faire se chevaucher. Mais il ne s'agit que d'un seul _type_ de gestionnaire de fenêtres, souvent appelé "flottant". Il en existe de nombreux autres, en particulier sous Linux. Une alternative particulièrement courante est le gestionnaire de fenêtres "en mosaïque". Dans un gestionnaire de fenêtres en mosaïque, les fenêtres ne se chevauchent jamais et sont disposées comme des tuiles sur votre écran, un peu comme les panneaux dans tmux. Avec un gestionnaire de fenêtres en mosaïque, l'écran est toujours rempli par les fenêtres ouvertes, disposées selon une certaine _disposition_. Si vous n'avez qu'une seule fenêtre, elle occupe tout l'écran. Si vous en ouvrez une autre, la fenêtre d'origine se rétrécit pour lui faire de la place (souvent quelque chose comme 2/3 et 1/3). Si vous en ouvrez une troisième, les autres fenêtres se rétrécissent à nouveau pour faire de la place à la nouvelle fenêtre. Tout comme avec les panneaux tmux, vous pouvez naviguer dans ces fenêtres en mosaïque avec votre clavier, et vous pouvez les redimensionner et les déplacer, le tout sans toucher à la souris. Cela vaut la peine d'y jeter un coup d'oeil !

## VPNs

Les réseaux privés virtuels (VPN) font fureur de nos jours, mais il n'est pas certain que ce soit pour [une bonne raison](https://web.archive.org/web/20230710155258/https://gist.github.com/joepie91/5a9909939e6ce7d09e29). Vous devez savoir ce qu'un VPN vous apporte et ce qu'il ne vous apporte pas. Dans le meilleur des cas, un VPN n'est _en fait_ qu'un moyen de changer de fournisseur d'accès à l'internet. Tout votre trafic semblera provenir du fournisseur VPN au lieu de votre emplacement "réel", et le réseau auquel vous êtes connecté ne verra que du trafic encrypté.

Bien que cela puisse sembler attrayant, gardez à l'esprit que lorsque vous utilisez un VPN, tout ce que vous faites réellement est de transférer votre confiance de votre ISP actuel à la société d'hébergement du VPN. Ce que votre ISP _pourrait_ voir, le fournisseur de VPN le voit maintenant _à sa place_. Si vous lui faites _plus_ confiance qu'à votre fournisseur d'accès, c'est une victoire, mais dans le cas contraire, il n'est pas certain que vous ayez gagné grand-chose. Si vous êtes connecté sur un Wi-Fi public douteux et non crypté dans un aéroport, vous ne faites peut-être pas beaucoup confiance à la connexion, mais à la maison, le compromis n'est pas aussi clair.

Vous devez également savoir que de nos jours, une grande partie de votre trafic, au moins de nature sensible, est _déjà_ encryptée par HTTPS ou TLS de manière plus générale. Dans ce cas, il importe généralement peu que vous soyez sur un "mauvais" réseau ou non - l'opérateur du réseau ne saura que les serveurs auxquels vous vous adressez, mais rien sur les données échangées.


Remarquez que j'ai dit "dans le meilleur des cas" ci-dessus. Il n'est pas rare que les fournisseurs de VPN configurent accidentellement mal leur logiciel, de sorte que l'encryptage est soit faible, soit entièrement désactivé. Certains fournisseurs de VPN sont malveillants (ou au moins opportunistes) et enregistrent tout votre trafic, voire vendent ces informations à des tiers. Choisir un mauvais fournisseur de VPN est souvent pire que de ne pas en utiliser un.

À la rigueur, le MIT [gère un VPN](https://ist.mit.edu/vpn) pour ses étudiants, ce qui peut valoir la peine d'y jeter un coup d'oeil. Par ailleurs, si vous souhaitez créer votre propre VPN, jetez un coup d'oeil à [WireGuard](https://www.wireguard.com/).

## Markdown

Il y a de fortes chances que vous écriviez du texte au cours de votre carrière. Et souvent, vous voudrez marquer ce texte de manière simple. Vous souhaitez mettre du texte en gras ou en italique, ou ajouter des en-têtes, des liens et des fragments de code. Au lieu de sortir un outil lourd comme Word ou LaTeX, vous pouvez envisager d'utiliser le langage de balisage léger [Markdown](https://commonmark.org/help/).

Vous avez probablement déjà vu du Markdown, ou du moins une de ses variantes. Des sous-ensembles de ce langage sont utilisés et pris en charge presque partout, même si ce n'est pas sous le nom de Markdown. À la base, Markdown est une tentative de codification de la manière dont les gens marquent déjà souvent le texte lorsqu'ils écrivent des documents en texte brut. L'accentuation (*italique*) est ajoutée en entourant un mot d'un `*`. L'accentuation forte (**gras**) est ajoutée en utilisant `**`. Les lignes commençant par `#` sont des titres (et le nombre de `#` correspond au niveau du sous-titre). Toute ligne commençant par `-` est un élément de liste à puces, et toute ligne commençant par un chiffre + `.` est un élément de liste numéroté. La coche arrière (\`) est utilisée pour montrer les mots en `police de code`, et un bloc de code peut être saisi en indentant une ligne de quatre espaces ou en l'entourant de trois coche arrière :

    ```
    insérer du code ici
    ```
  
Pour ajouter un lien, placez le _texte_ du lien entre crochets et l'URL suivant immédiatement entre parenthèses : `[nom](url)`. Markdown est facile à prendre en main et vous pouvez l'utiliser presque partout. En fait, les notes de lecture de ce cours, et de tous les autres, sont écrites en Markdown, et vous pouvez voir le Markdown brut [ici](https://raw.githubusercontent.com/missing-semester/missing-semester/master/_2020/potpourri.md).

## Hammerspoon (automatisation du bureau sur macOS)

[Hammerspoon](https://www.hammerspoon.org/) est un framework d'automatisation du bureau pour macOS. Il vous permet d'écrire des scripts Lua qui s'accrochent aux fonctionnalités du système d'exploitation, vous permettant d'interagir avec le clavier/la souris, les fenêtres, les écrans, le système de fichiers, et bien plus encore.

Voici quelques exemples de ce que vous pouvez faire avec Hammerspoon :

- Lier des touches de raccourci pour déplacer des fenêtres à des endroits spécifiques
- Créer un bouton dans la barre de menu qui affiche automatiquement les fenêtres dans une disposition spécifique.
- Couper le son de votre haut-parleur lorsque vous arrivez en salle de cours (en détectant le réseau WiFi).
- Afficher un avertissement si vous avez accidentellement pris le chargeur de votre ami.

À un niveau élevé, Hammerspoon vous permet d'exécuter un code Lua arbitraire, lié à des boutons de menu, des pressions de touches ou des événements, et Hammerspoon fournit une large librairie pour interagir avec le système, de sorte qu'il n'y a pratiquement aucune limite à ce que vous pouvez faire avec. De nombreuses personnes ont rendu publiques leurs configurations Hammerspoon, de sorte que vous pouvez généralement trouver ce dont vous avez besoin en cherchant sur Internet, mais vous pouvez toujours écrire votre propre code à partir de zéro.

### Ressources

- [Débuter avec Hammerspoon](https://www.hammerspoon.org/go/)
- [Exemples de configuration](https://github.com/Hammerspoon/hammerspoon/wiki/Sample-Configurations)
- [Congiruation Hammerspoon d'Anish](https://github.com/anishathalye/dotfiles-local/tree/mac/hammerspoon)

## Démarrage + Live USBs

Lorsque votre machine démarre, avant que le système d'exploitation ne soit chargé, le [BIOS](https://en.wikipedia.org/wiki/BIOS)/[UEFI](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) initialise le système. Au cours de ce processus, vous pouvez appuyer sur une combinaison de touches spécifique pour configurer cette couche logicielle. Par exemple, votre ordinateur peut dire quelque chose comme "Appuyez sur F9 pour configurer le BIOS. Appuyez sur F12 pour accéder au menu de démarrage" pendant le processus de démarrage. Vous pouvez configurer toutes sortes de paramètres liés au matériel dans le menu BIOS. Vous pouvez également accéder au menu de démarrage pour démarrer à partir d'un autre périphérique au lieu de votre disque dur.

Les [Live USBs](https://en.wikipedia.org/wiki/Live_USB) sont des clés USB contenant un système d'exploitation. Vous pouvez en créer une en téléchargeant un système d'exploitation (par exemple, une distribution Linux) et en le flashant sur la clé USB. Ce processus est un peu plus compliqué que la simple copie d'un fichier `.iso` sur le disque. Il existe des outils comme [UNetbootin](https://unetbootin.github.io/) pour vous aider à créer des live USB.

Les Live USB sont utiles à toutes sortes de fins. Entre autres, si vous cassez votre système d'exploitation existant et qu'il ne démarre plus, vous pouvez utiliser une clé live USB pour récupérer des données ou réparer le système d'exploitation.

## Docker, Vagrant, VMs, Cloud, OpenStack

Les [machines virtuelles](https://fr.wikipedia.org/wiki/Machine_virtuelle) et les outils similaires comme les conteneurs vous permettent d'émuler un système informatique complet, y compris le système d'exploitation. Cela peut être utile pour créer un environnement isolé à des fins de test, de développement ou d'exploration (par exemple, l'exécution d'un code potentiellement malveillant).

[Vagrant](https://www.vagrantup.com/) est un outil qui vous permet de décrire des configurations machine (système d'exploitation, services, paquets, etc.) en code, puis d'instancier des machines virtuelles à l'aide d'un simple commande `vagrant up`. [Docker](https://www.docker.com/) est conceptuellement similaire, mais il utilise des conteneurs à la place.

Vous pouvez également louer des machines virtuelles dans le cloud, et c'est un bon moyen d'obtenir un accès instantané à:

- une machine bon marché toujours active qui possède une adresse IP publique, utilisée pour héberger des services
- une machine avec beaucoup de CPU, de disques, de RAM et/ou de GPU
- beaucoup plus de machines que celles auxquelles vous avez physiquement accès (la facturation se fait souvent à la seconde, donc si vous voulez beaucoup de puissance de calcul pendant une courte période, il est possible de louer 1000 ordinateurs pendant quelques minutes).

Les services les plus courants sont [Amazon AWS](https://aws.amazon.com/), [Google Cloud](https://cloud.google.com/), [ Microsoft Azure](https://azure.microsoft.com/), [DigitalOcean](https://www.digitalocean.com/).

Si vous êtes membre CSAIL du MIT, vous pouvez obtenir des machines virtuelles gratuites à des fins de recherche grâce à l'instance [OpenStack du CSAIL](https://tig.csail.mit.edu/shared-computing/open-stack/).

## Notebook programming

Les [environnements de programmation notebook](https://en.wikipedia.org/wiki/Notebook_interface) peuvent s'avérer très pratiques pour certains types de développements interactifs ou exploratoires. L'environnement de programmation notebook le plus populaire aujourd'hui est sans doute [Jupyter](https://jupyter.org/), pour Python (et plusieurs autres langages). [Wolfram Mathematica](https://www.wolfram.com/mathematica/) est un autre environnement de programmation notebook, idéal pour la programmation orientée vers les mathématiques.


## GitHub

[GitHub](https://github.com/) est l'une des plateformes les plus populaires pour le développement de logiciels open-source. De nombreux outils dont nous avons parlé dans ce cours, de [vim](https://github.com/vim/vim) à [Hammerspoon](https://github.com/Hammerspoon/hammerspoon), sont hébergés sur GitHub. Il est facile de commencer à contribuer aux logiciels open-source afin d'améliorer les outils que vous utilisez tous les jours.

Il y a deux façons principales de contribuer aux projets sur GitHub :

- Créer une [issue](https://help.github.com/en/github/managing-your-work-on-github/creating-an-issue). Cela permet de signaler des bugs ou de demander une nouvelle fonctionnalité. Aucun de ces éléments n'implique de lire ou d'écrire du code, ce qui rend l'opération assez légère. Des rapports de bugs de qualité peuvent être extrêmement précieux pour les développeurs. Commenter des discussions existantes peut également s'avérer utile.
- Contribuer au code par le biais d'une [pull
request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests). Cette démarche est généralement plus complexe que la création d'une issue. Vous pouvez [forker](https://help.github.com/en/github/getting-started-with-github/fork-a-repo) un repository sur GitHub, cloner votre fork, créer une nouvelle branche, apporter des modifications (par exemple, corriger un bug ou implémenter une fonctionnalité), push la branche, puis [créer une
pull
request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request). Après cela, il y aura généralement des échanges avec les responsables du projet, qui vous donneront un retour sur votre correctif.  Enfin, si tout se passe bien, votre correctif sera intégré dans le dépôt amont. Souvent, les grands projets disposent d'un guide de contribution, d'une étiquette pour les problèmes pour débutants, et certains ont même des programmes de mentorat pour aider les nouveaux contributeurs à se familiariser avec le projet.