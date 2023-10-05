---
layout: lecture
title: "Q&A"
date: 2020-01-30
ready: true
video:
  aspect: 56.25
  id: Wz50FvGG6xU
---

Pour le dernier cours, nous répondons aux questions posées par les étudiants :

- [Avez-vous des recommandations sur l'apprentissage de sujets liés aux systèmes d'exploitation tels que les processus, la mémoire virtuelle, les interruptions, la gestion de la mémoire, etc. ?](#avez-vous-des-recommandations-sur-lapprentissage-de-sujets-liés-aux-systèmes-dexploitation-tels-que-les-processus-la-mémoire-virtuelle-les-interruptions-la-gestion-de-la-mémoire-etc-)
- [Quels sont les outils que vous conseillez d'apprendre en priorité ?](#quels-sont-les-outils-que-vous-conseillez-dapprendre-en-priorité-)
- [Quand dois-je utiliser Python plutôt qu'un script Bash ou un autre langage ?](#quand-dois-je-utiliser-python-plutôt-quun-script-bash-ou-un-autre-langage-)
- [Quelle est la différence entre `source script.sh` et `./script.sh` ?](#quelle-est-la-différence-entre-source-scriptsh-et-scriptsh-)
- [Quels sont les endroits où sont stockés les différents paquets et outils et comment les référencer ? Qu'est-ce que `/bin` ou `/lib` ?](#quels-sont-les-endroits-où-sont-stockés-les-différents-paquets-et-outils-et-comment-les-référencer--quest-ce-que-bin-ou-lib-)
- [Dois-je utiliser `apt-get install` ou `pip install` pour installer un package ?](#dois-je-utiliser-apt-get-install-ou-pip-install-pour-installer-un-package-)
- [Quels sont les outils de profilage les plus simples et les meilleurs à utiliser pour améliorer les performances de mon code ?](#quels-sont-les-outils-de-profilage-les-plus-simples-et-les-meilleurs-à-utiliser-pour-améliorer-les-performances-de-mon-code-)
- [Quels plugins de navigateur utilisez-vous ?](#quels-plugins-de-navigateur-utilisez-vous-)
- [Quels sont les autres outils utiles de manipulation de données ?](#quels-sont-les-autres-outils-danalyse-de-données-utiles-)
- [Quelle est la différence entre Docker et une machine virtuelle ?](#quelle-est-la-différence-entre-docker-et-une-machine-virtuelle-)
- [Quels sont les avantages et les inconvénients de chaque système d'exploitation et comment en choisir un (par exemple, choisir la meilleure distribution Linux pour nos besoins) ?](#quels-sont-les-avantages-et-les-inconvénients-de-chaque-système-dexploitation-et-comment-en-choisir-un-par-exemple-choisir-la-meilleure-distribution-linux-pour-nos-besoins-)
- [Vim ou Emacs ?](#vim-ou-emacs-)
- [Des conseils ou des astuces pour les applications de machine learning ?](#des-conseils-ou-des-astuces-pour-les-applications-de-machine-learning-)
- [D'autres astuces pour Vim ?](#dautres-conseils-pour-vim-)
- [Qu'est-ce que l'authentification à deux facteurs et pourquoi devrais-je l'utiliser ?](#quest-ce-que-lauthentification-à-deux-facteurs-et-pourquoi-devrais-je-lutiliser-)
- [Des commentaires sur les différences entre les navigateurs web ?](#des-commentaires-sur-les-différences-entre-les-navigateurs-web-)

## Avez-vous des recommandations sur l'apprentissage de sujets liés aux systèmes d'exploitation tels que les processus, la mémoire virtuelle, les interruptions, la gestion de la mémoire, etc. ?

Tout d'abord, il n'est pas certain que vous ayez besoin d'être très familier avec tous ces sujets puisqu'il s'agit de sujets très bas niveau. Ils seront importants lorsque vous commencerez à écrire du code de plus bas niveau, comme l'implémentation ou la modification d'un noyau. Sinon, la plupart des sujets ne seront pas pertinents, à l'exception des processus et des signaux qui ont été brièvement abordés dans d'autres cours.

Quelques bonnes ressources pour en apprendre plus sur ce sujet :

- [Cours 6.828 du MIT](https://pdos.csail.mit.edu/6.828/) - Cours de niveau supérieur sur l'ingénierie des systèmes d'exploitation. Les supports de cours sont accessibles au public.
- Modern Operating Systems (4th ed) - par Andrew S. Tanenbaum est une bonne vue d'ensemble des concepts mentionnés.
- The Design and Implementation of the FreeBSD Operating System - Une bonne ressource sur le système d'exploitation FreeBSD (notez que ce n'est pas Linux).
- D'autres guides comme [Writing an OS in Rust](https://os.phil-opp.com/) où des personnes implémentent un noyau étape par étape dans différents langages, principalement à des fins d'enseignement.

## Quels sont les outils que vous conseillez d'apprendre en priorité ?

Certains sujets méritent d'être traités en priorité :

- Apprendre à utiliser davantage le clavier et moins la souris. Cela peut se faire par le biais de raccourcis clavier, en changeant d'interface, etc.
- Apprendre à bien utiliser son éditeur. En tant que programmeur, vous passez la majeure partie de votre temps à éditer des fichiers, il est donc très utile de bien apprendre cette compétence.
- Apprendre à automatiser et/ou simplifier les tâches répétitives dans votre travail, car le gain de temps sera énorme...
- Apprendre les outils de contrôle de version comme Git et comment les utiliser en conjonction avec GitHub pour collaborer à des projets logiciels modernes.

## Quand dois-je utiliser Python plutôt qu'un script Bash ou un autre langage ?

En général, les scripts bash sont utiles pour les scripts simples et courts, lorsque vous voulez simplement exécuter une série spécifique de commandes. bash a un ensemble de bizarreries qui le rendent difficile à utiliser pour des programmes ou des scripts plus importants :

- bash est facile à utiliser pour un cas d'utilisation simple, mais il peut être très difficile à utiliser pour toutes les entrées possibles. Par exemple, les espaces dans les arguments des scripts ont conduit à d'innombrables bugs dans les scripts bash.
- bash ne se prête pas à la réutilisation de code, il peut donc être difficile de réutiliser des composants de programmes précédents que vous avez écrits. Plus généralement, il n'y a pas de concept de librairie logicielles en bash.
- bash s'appuie sur de nombreuses chaînes magiques comme `$?` ou `$@` pour se référer à des valeurs spécifiques, alors que d'autres langages s'y réfèrent explicitement, comme `exitCode` ou `sys.args` respectivement.

Par conséquent, pour des scripts plus importants et/ou plus complexes, nous recommandons d'utiliser des langages de script plus matures comme Python ou Ruby. Vous pouvez trouver en ligne d'innombrables librairies que des personnes ont déjà écrites pour résoudre des problèmes courants dans ces langages. Si vous trouvez une bibliothèque qui implémente la fonctionnalité spécifique qui vous intéresse dans un certain langage, la meilleure chose à faire est généralement d'utiliser ce langage.

## Quelle est la différence entre `source script.sh` et `./script.sh` ?

Dans les deux cas, le fichier `script.sh` sera lu et exécuté dans une session bash, la différence résidant dans quelle session exécute les commandes. Dans le cas du `source`, les commandes sont exécutées dans votre session bash actuelle et, par conséquent, toute modification apportée à l'environnement actuel, comme le changement de répertoire ou la définition de fonctions, persistera dans la session actuelle une fois que la commande `source` aura fini d'être exécutée. Lorsque vous exécutez le script de manière autonome, comme `./script.sh`, votre session bash actuelle démarre une nouvelle instance de bash qui exécutera les commandes de `script.sh`. Ainsi, si `script.sh` change de répertoire, la nouvelle instance de bash changera de répertoire, mais une fois qu'elle aura quitté la session bash parent et lui aura rendu le contrôle, la session parent restera au même endroit. De même, si `script.sh` définit une fonction à laquelle vous voulez accéder dans votre terminal, vous devez la `source` pour qu'elle soit définie dans votre session bash actuelle. Sinon, si vous l'exécutez, c'est le nouveau processus bash qui traitera la définition de la fonction au lieu de votre shell actuel.

## Quels sont les endroits où sont stockés les différents paquets et outils et comment les référencer ? Qu'est-ce que `/bin` ou `/lib` ?

En ce qui concerne les programmes que vous exécutez dans votre terminal, ils se trouvent tous dans les répertoires énumérés dans votre variable d'environnement `PATH` et vous pouvez utiliser la commande `which` (ou la commande `type`) pour vérifier où votre interpréteur de commandes trouve un programme spécifique. En général, il existe des conventions concernant l'emplacement de certains types de fichiers. Voici quelques-uns des types de fichiers dont nous avons parlé. Consultez la [Filesystem, Hierarchy Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard) pour obtenir une liste plus complète.

- `/bin` - Fichiers binaires de commande essentiels
- `/sbin` - Fichiers binaires essentiels du système, généralement exécutés par le super-utilisateur (root)
- `/dev` - Fichiers de périphériques, fichiers spéciaux qui sont souvent des interfaces vers des périphériques matériels
- `/etc` - Fichiers de configuration du système spécifiques à l'hôte
- `/home` - Répertoires personnels des utilisateurs du système
- `/lib` - Bibliothèques communes pour les programmes système
- `/opt` - Logiciel d'application optionnel
- `/sys` - Contient les informations et la configuration du système (abordé dans le [premier cours](/2020/course-shell/))
- `/tmp` - Fichiers temporaires (également `/var/tmp`). Ils sont généralement supprimés entre les redémarrages.
- `/usr/` - Données utilisateur en lecture seule
  + `/usr/bin` - Binaires de commande non essentiels
  + `/usr/sbin` - Binaires système non essentiels, généralement exécutés par le super-utilisateur.
  + `/usr/local/bin` - Binaires pour les programmes compilés par l'utilisateur
- `/var` - Fichiers variables tels que les logs ou les caches

## Dois-je utiliser `apt-get install` ou `pip install` pour installer un package ?

Il n'y a pas de réponse universelle à cette question. Elle est liée à la question plus générale de savoir si vous devez utiliser le gestionnaire de paquets de votre système ou un gestionnaire de paquets spécifique à votre langage pour installer un logiciel. Voici quelques éléments à prendre en compte :

- Les paquets courants sont disponibles dans les deux cas, mais les paquets moins populaires ou plus récents peuvent ne pas être disponibles dans le gestionnaire de paquets de votre système. Dans ce cas, il est préférable d'utiliser l'outil spécifique au langage.
- De même, les gestionnaires de paquets spécifiques à un langage disposent généralement de versions plus récentes des paquets que les gestionnaires de paquets système.
- Lorsque vous utilisez votre gestionnaire de paquets système, les librairies sont installées sur l'ensemble du système. Cela signifie que si vous avez besoin de différentes versions d'une librairie à des fins de développement, le gestionnaire de paquets système peut ne pas suffire. Dans ce cas, la plupart des langages de programmation proposent une sorte d'environnement isolé ou virtuel qui vous permet d'installer différentes versions de librairies sans risque de conflit. Pour Python, il y a virtualenv, et pour Ruby, il y a RVM.
- En fonction du système d'exploitation et de l'architecture matérielle, certains de ces paquets peuvent être livrés avec des binaires ou doivent être compilés. Par exemple, sur les ordinateurs ARM comme le Raspberry Pi, il peut être préférable d'utiliser le gestionnaire de paquets système plutôt qu'un gestionnaire de paquets spécifique à un langage si le premier se présente sous la forme de binaires et que le second doit être compilé. Cela dépend fortement de votre configuration spécifique.

Vous devriez essayer d'utiliser l'une ou l'autre solution et non les deux, car cela peut conduire à des conflits difficiles à déboguer. Nous recommandons d'utiliser le gestionnaire de paquets spécifique au langage chaque fois que possible, et d'utiliser des environnements isolés (comme le virtualenv de Python) pour éviter de polluer l'environnement global.

## Quels sont les outils de profilage les plus simples et les meilleurs à utiliser pour améliorer les performances de mon code ?

L'outil le plus simple et le plus utile pour le profilage est le [print timing](/2020/debugging-profiling/#timing). Il vous suffit de calculer manuellement le temps écoulé entre les différentes parties de votre code. En répétant cette opération, vous pouvez effectuer une recherche binaire sur votre code et trouver le segment de code qui a pris le plus de temps.

Pour des outils plus avancés, [Callgrind](http://valgrind.org/docs/manual/cl-manual.html) de Valgrind vous permet d'exécuter votre programme et de mesurer le temps nécessaire à chaque étape ainsi que toutes les piles d'appels, à savoir quelle fonction a appelé quelle autre fonction. Il produit ensuite une version annotée du code source de votre programme avec le temps pris par ligne. Cependant, il ralentit votre programme d'un ordre de grandeur et ne supporte pas les threads. Pour les autres cas, l'outil [`perf`](http://www.brendangregg.com/perf.html) et d'autres profileurs d'échantillonnage spécifiques au langage peuvent produire des données utiles assez rapidement. Les [Flamegraphs](http://www.brendangregg.com/flamegraphs.html) sont un bon outil de visualisation des résultats de ces profileurs d'échantillonnage. Vous devriez également essayer d'utiliser des outils spécifiques au langage de programmation ou à la tâche sur laquelle vous travaillez. Par exemple, pour le développement web, les outils de développement intégrés à Chrome et Firefox disposent de profilers fantastiques.

Parfois, la partie lente de votre code est due au fait que votre système attend un événement tel qu'une lecture de disque ou un paquet réseau. Dans ce cas, il est utile de vérifier que les calculs effectués à l'envers sur la vitesse théorique en fonction des capacités du matériel ne s'écartent pas des relevés réels. Il existe également des outils spécialisés pour analyser les temps d'attente dans les appels système. Il s'agit notamment d'outils tels que [eBPF](http://www.brendangregg.com/blog/2019-01-01/learn-ebpf-tracing.html), qui effectuent un traçage du noyau des programmes utilisateur. En particulier, [`bpftrace`](https://github.com/iovisor/bpftrace) vaut la peine d'être considéré si vous avez besoin d'effectuer ce type de profilage de bas niveau.

## Quels plugins de navigateur utilisez-vous ?

Quelques-uns de nos favoris, principalement liés à la sécurité et à la facilité d'utilisation :

- [uBlock Origin](https://github.com/gorhill/uBlock) - Il s'agit d'un bloqueur à [large spectre](https://github.com/gorhill/uBlock/wiki/Blocking-mode) qui ne se contente pas de bloquer les publicités, mais toutes sortes de communications tierces qu'une page peut tenter d'établir. Il couvre également les scripts et d'autres types de chargement de ressources. Si vous êtes prêt à passer un peu de temps sur la configuration pour faire fonctionner les choses, passez en [mode moyen](https://github.com/gorhill/uBlock/wiki/Blocking-mode:-medium-mode) ou même en [mode difficile](https://github.com/gorhill/uBlock/wiki/Blocking-mode:-hard-mode). Certains sites ne fonctionneront pas tant que vous n'aurez pas suffisamment manipulé les paramètres, mais votre sécurité en ligne s'en trouvera considérablement améliorée. Sinon, le [mode facile](https://github.com/gorhill/uBlock/wiki/Blocking-mode:-easy-mode) est déjà un bon mode par défaut qui bloque la plupart des publicités et du suivi. Vous pouvez également définir vos propres règles concernant les objets de sites web à bloquer.
- [Stylus](https://github.com/openstyles/stylus/) - un dérivé de Stylish (n'utilisez pas Stylish, il a été démontré qu'il [volait l'historique de navigation des utilisateurs](https://www.theregister.co.uk/2018/07/05/browsers_pull_stylish_but_invasive_browser_extension/)), vous permet de charger latéralement des feuilles de style CSS personnalisées sur les sites web. Avec Stylus, vous pouvez facilement personnaliser et modifier l'apparence des sites web. Il peut s'agir de supprimer une barre latérale, de changer la couleur d'arrière-plan ou même la taille du texte ou le choix de la police. C'est un outil fantastique pour rendre plus lisibles les sites que vous visitez fréquemment. De plus, Stylus peut trouver des styles écrits par d'autres utilisateurs et publiés sur [userstyles.org](https://userstyles.org/). La plupart des sites web courants disposent d'une ou plusieurs feuilles de style pour les thèmes sombres, par exemple.
- Full Page Screen Capture - [Intégrée à Firefox](https://screenshots.firefox.com/) et à [l'extension Chrome](https://chrome.google.com/webstore/detail/full-page-screen-capture/fdpohaocaechififmbbbbbknoalclacl?hl=en). Permet de faire une capture d'écran d'un site web complet, ce qui est souvent bien mieux qu'une impression à des fins de référence.
- [Multi Account Containers](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/) - vous permet de séparer les cookies dans des "conteneurs", ce qui vous permet de naviguer sur le web avec différentes identités et/ou de vous assurer que les sites web ne sont pas en mesure de partager des informations entre eux.
- Password Manager Integration - La plupart des gestionnaires de mots de passe disposent d'extensions de navigateur qui rendent la saisie de vos informations d'identification sur les sites web non seulement plus pratique, mais aussi plus sûre. Au lieu de simplement copier-coller votre nom d'utilisateur et votre mot de passe, ces outils vérifient d'abord que le domaine du site web correspond à celui indiqué pour l'entrée, empêchant ainsi les attaques par hameçonnage qui usurpent l'identité de sites web populaires pour voler des informations d'identification.
- [Vimium](https://github.com/philc/vimium) - Une extension de navigateur qui permet de naviguer et de contrôler le web au clavier, dans l'esprit de l'éditeur Vim.

## Quels sont les autres outils d'analyse de données utiles ?

Parmi les outils d'analyse de données que nous n'avons pas eu le temps d'aborder pendant le cours, on peut citer `jq` ou `pup`, qui sont des analyseurs spécialisés pour les données JSON et HTML respectivement. Le langage de programmation Perl est un autre bon outil pour les pipelines d'analyses de données plus avancés. Une autre astuce est la commande `column -t` qui peut être utilisée pour convertir un texte avec espaces (pas nécessairement aligné) en un texte correctement aligné en colonnes.

Plus généralement, vim et Python sont des outils de traitement de données moins conventionnels. Pour certaines transformations complexes sur plusieurs lignes, les macros de vim peuvent être un outil inestimable. Vous pouvez simplement enregistrer une série d'actions et les répéter autant de fois que vous le souhaitez, par exemple dans les [notes de cours](/2020/editors/#macros) sur les éditeurs (et la [vidéo](/2019/editors/) de l'année dernière), il y a un exemple de conversion d'un fichier formaté en XML en JSON en utilisant simplement des macros vim.

Pour les données tabulaires, souvent présentées sous forme de CSV, la librarie Python [pandas](https://pandas.pydata.org/) est un outil formidable. Non seulement parce qu'elle facilite la définition d'opérations complexes telles que le group by, le join ou les filters, mais aussi parce qu'elle permet de représenter graphiquement facilement les différentes propriétés de vos données. Elle permet également d'exporter vers de nombreux formats de tableaux, notamment XLS, HTML ou LaTeX. Par ailleurs, le langage de programmation R (qui est sans doute un [mauvais](http://arrgh.tim-smith.us/) langage de programmation) offre de nombreuses fonctionnalités pour le calcul de statistiques sur les données et peut être très utile en tant que dernière étape de votre pipeline. [ggplot2](https://ggplot2.tidyverse.org/) est une excellente librairie de génération de graphiques dans R.

## Quelle est la différence entre Docker et une machine virtuelle ?

Docker est basé sur un concept plus général appelé conteneurs. La principale différence entre les conteneurs et les machines virtuelles est que les machines virtuelles exécutent une pile complète de systèmes d'exploitation, y compris le noyau, même si le noyau est le même que celui de la machine hôte. Contrairement aux machines virtuelles, les conteneurs évitent d'exécuter une autre instance du noyau et partagent plutôt le noyau avec l'hôte. Dans Linux, cela est possible grâce à un mécanisme appelé LXC, qui utilise une série de mécanismes d'isolation pour lancer un programme qui pense s'exécuter sur son propre matériel, mais qui partage en fait le matériel et le noyau avec l'hôte. Ainsi, les conteneurs ont un coût de fonctionnement inférieur à celui d'une machine virtuelle complète. En revanche, les conteneurs ont une isolation plus faible et ne fonctionnent que si l'hôte utilise le même noyau. Par exemple, si vous exécutez Docker sur macOS, Docker doit démarrer une machine virtuelle Linux pour obtenir un noyau Linux initial, et l'overhead reste donc important. Enfin, Docker est une implémentation spécifique des conteneurs et est conçu pour le déploiement de logiciels. Pour cette raison, il présente quelques particularités : par exemple, les conteneurs Docker ne conservent aucune forme de stockage entre les redémarrages par défaut.

## Quels sont les avantages et les inconvénients de chaque système d'exploitation et comment en choisir un (par exemple, choisir la meilleure distribution Linux pour nos besoins) ?

En ce qui concerne les distributions Linux, même s'il en existe un très grand nombre, la plupart d'entre elles se comportent de manière assez identique dans la plupart des cas d'utilisation. La plupart des fonctionnalités et du fonctionnement interne de Linux et d'UNIX peuvent être appris dans n'importe quelle distribution. Une différence fondamentale entre les distros est la manière dont elles gèrent les mises à jour des paquets. Certaines distros, comme Arch Linux, utilisent une politique de mise à jour en continu où les choses sont à la pointe de la technologie mais où il peut y avoir des pannes de temps en temps. D'un autre côté, certaines distributions comme Debian, CentOS ou Ubuntu LTS sont beaucoup plus conservatrices en ce qui concerne la publication des mises à jour dans leurs repositories, de sorte que les choses sont généralement plus stables au détriment des nouvelles fonctionnalités. Nous recommandons d'utiliser Debian ou Ubuntu pour une expérience facile et stable, tant pour les ordinateurs de bureau que pour les serveurs.

Mac OS est un bon compromis entre Windows et Linux, avec une interface agréablement soignée. Cependant, Mac OS est basé sur BSD plutôt que sur Linux, de sorte que certaines parties du système et certaines commandes sont différentes. FreeBSD est une alternative qui vaut la peine d'être examinée. Même si certains programmes ne fonctionnent pas sous FreeBSD, l'écosystème BSD est beaucoup moins fragmenté et mieux documenté que Linux. Nous déconseillons l'utilisation de Windows, sauf pour le développement d'applications Windows ou si vous avez besoin d'une fonctionnalité essentielle, comme un bon support des drivers pour les jeux vidéos.


Pour les systèmes dual boot, nous pensons que l'implémentation la plus efficace est le bootcamp de macOS et que toute autre combinaison peut être problématique à long terme, en particulier si vous la combinez avec d'autres fonctionnalités telles que le cryptage des disques.

## Vim ou Emacs ?

Nous utilisons tous les trois vim comme éditeur principal, mais Emacs est également une bonne alternative et cela vaut la peine d'essayer les deux pour voir ce qui vous convient le mieux. Emacs n'utilise pas l'édition modale de vim, mais celle-ci peut être activée grâce à des plugins Emacs comme [Evil](https://github.com/emacs-evil/evil) ou [Doom Emacs](https://github.com/hlissner/doom-emacs). Un avantage d'Emacs est que les extensions peuvent être implémentées en Lisp, un meilleur langage de script que vimscript, le langage de script par défaut de Vim.

## Des conseils ou des astuces pour les applications de machine learning ?

Certaines des leçons et des acquis de ce cours peuvent être directement appliquées aux applications de machine learning. Comme c'est le cas dans de nombreuses disciplines scientifiques, en ML vous réalisez souvent une série d'expériences et vous voulez vérifier ce qui a fonctionné et ce qui n'a pas fonctionné. Vous pouvez utiliser des outils shell pour rechercher facilement et rapidement ces expériences et agréger les résultats d'une manière raisonnable. Il peut s'agir de sous-sélectionner toutes les expériences réalisées dans un laps de temps donné ou qui utilisent un ensemble de données spécifique. En utilisant un simple fichier JSON pour enregistrer tous les paramètres pertinents des expériences, cela peut être incroyablement simple avec les outils que nous avons abordés dans ce cours. Enfin, si vous ne travaillez pas avec une sorte de cluster où vous soumettez vos jobs GPU, vous devriez chercher à automatiser ce processus car il peut s'agir d'une tâche assez fastidieuse qui consomme également votre énergie mentale.

## D'autres conseils pour Vim ?

Quelques conseils supplémentaires :

- Plugins - Prenez votre temps et explorez les différents plugins. Il y a beaucoup d'excellents plugins qui comblent certaines lacunes de Vim ou qui ajoutent de nouvelles fonctionnalités qui s'intègrent bien dans les flux de travail existants de Vim. Pour cela, les bonnes ressources sont [VimAwesome](https://vimawesome.com/) et les dotfiles d'autres programmeurs.
- Marques - Dans vim, vous pouvez définir une marque en faisant `m<X>` pour une lettre `X`. Vous pouvez ensuite revenir à cette marque en faisant `'<X>`. Cela vous permet de naviguer rapidement vers des endroits spécifiques d'un fichier ou même d'un fichier à l'autre.
- Navigation - `Ctrl+O` et `Ctrl+I` vous permettent respectivement de revenir en arrière et d'aller aux endroits que vous avez visités récemment.
- Arbre d'annulation - Vim dispose d'un mécanisme assez sophistiqué pour garder une trace des modifications. Contrairement à d'autres éditeurs, Vim stocke une arborescence des modifications, de sorte que même si vous annulez puis effectuez une modification différente, vous pouvez toujours revenir à l'état d'origine en naviguant dans l'arborescence d'annulation. Certains plugins comme [gundo.vim](https://github.com/sjl/gundo.vim) et [undotree](https://github.com/mbbill/undotree) affichent cet arbre de manière graphique.
- Annuler avec le temps - Les commandes `:earlier` et `:later` vous permettent de naviguer dans les fichiers en utilisant des références temporelles au lieu d'une modification à la fois.
- [L'annulation persistante](https://vim.fandom.com/wiki/Using_undo_branches#Persistent_undo) est une fonctionnalité intégrée étonnante de vim qui est désactivée par défaut. Elle persiste l'historique d'annulation entre les invocations de vim. En définissant `undofile` et `undodir` dans votre `.vimrc`, vim stockera un historique des modifications par fichier.
- Leader key - La leader key est une touche spéciale qui est souvent laissée à l'utilisateur pour être configurée pour des commandes personnalisées. Il s'agit généralement d'appuyer et de relâcher cette touche (souvent la touche espace), puis une autre touche pour exécuter une certaine commande. Souvent, les plugins utilisent cette touche pour ajouter leur propre fonctionnalité, par exemple le plugin UndoTree utilise `<Leader> U` pour ouvrir l'arbre d'annulation.
- Objets textuels avancés - Les objets textuels tels que les recherches peuvent également être composés à l'aide de commandes vim. Par exemple, `d/<pattern>` supprimera la prochaine occurrence du pattern ou `cgn` modifiera la prochaine occurrence de la dernière chaîne de caractères recherchée.

## Qu'est-ce que l'authentification à deux facteurs et pourquoi devrais-je l'utiliser ?

L'authentification à deux facteurs (2FA) ajoute une couche de protection supplémentaire à vos comptes, en plus des mots de passe. Pour vous connecter, vous devez non seulement connaître un mot de passe, mais aussi "prouver" d'une manière ou d'une autre que vous avez accès à un dispositif matériel. Dans le cas le plus simple, cela peut être réalisé en recevant un SMS sur votre téléphone, bien qu'il y ait des [problèmes connus](https://www.kaspersky.com/blog/2fa-practical-guide/24219/) avec le 2FA par SMS. Une meilleure alternative que nous recommandons est d'utiliser une solution [U2F](https://en.wikipedia.org/wiki/Universal_2nd_Factor) comme [YubiKey](https://www.yubico.com/).

## Des commentaires sur les différences entre les navigateurs web ?

Le paysage actuel des navigateurs à partir de 2020 est que la plupart d'entre eux sont comme Chrome parce qu'ils utilisent le même moteur (Blink). Cela signifie que Microsoft Edge, qui est également basé sur Blink, et Safari, qui est basé sur WebKit, un moteur similaire à Blink, ne sont que des versions plus mauvaises de Chrome. Chrome est un navigateur raisonnablement bon, tant en termes de performances que de facilité d'utilisation. Si vous souhaitez une alternative, nous vous recommandons Firefox. Il est comparable à Chrome à presque tous les égards et excelle en matière de protection de la vie privée. Un autre navigateur appelé [Flow](https://www.ekioh.com/flow-browser/) n'est pas encore finalisé pour les utilisateurs, mais il met en oeuvre un nouveau moteur de rendu qui promet d'être plus rapide que les moteurs actuels.