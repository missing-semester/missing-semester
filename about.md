---
layout: lecture
title: "Pourquoi ce cours ?"
---

Au cours d'une formation traditionnelle en informatique, il y a de fortes chances que vous suiviez de nombreux cours sur des sujets avancés, allant des systèmes d'exploitation aux langages de programmation en passant par le machine learning. Mais dans de nombreuses institutions, il y a un sujet essentiel qui est rarement abordé et qui est laissé à l'initiative des étudiants : la connaissance de l'écosystème informatique.

Au fil des ans, nous avons participé à l'enseignement de plusieurs cours au MIT, et nous avons constaté à maintes reprises que de nombreux étudiants ont une connaissance limitée des outils mis à leur disposition. Les ordinateurs ont été conçus pour automatiser les tâches manuelles, mais les étudiants effectuent souvent des tâches répétitives à la main ou ne parviennent pas à tirer pleinement parti d'outils puissants tels que le contrôle de version et les éditeurs de texte. Dans le meilleur des cas, il en résulte un manque d'efficacité et une perte de temps ; dans le pire des cas, il en résulte des problèmes tels que la perte de données ou l'impossibilité d'accomplir certaines tâches.

Ces sujets ne sont pas enseignés dans le cadre du programme universitaire : les étudiants n'apprennent jamais à utiliser ces outils, ou du moins pas à les utiliser efficacement, et perdent donc du temps et des efforts pour des tâches qui _devraient_ être simples. Le programme d'études standard en sciences informatiques ne comprend pas de sujets essentiels sur l'écosystème informatique qui pourraient rendre la vie des étudiants beaucoup plus facile.

# Le semestre manquant de votre formation en informatique

Pour remédier à cela, nous organisons un cours qui couvre tous les sujets que nous considérons comme essentiels pour devenir un informaticien et un programmeur efficace. Le cours est pragmatique et pratique, et il fournit une introduction pratique aux outils et techniques que vous pouvez immédiatement appliquer dans une grande variété de situations que vous rencontrerez. Le cours est dispensé pendant la "période d'activités indépendantes" du MIT en janvier 2020 - un semestre d'un mois qui propose des cours plus courts gérés par les étudiants. Bien que les conférences elles-mêmes ne soient accessibles qu'aux étudiants du MIT, nous mettrons à la disposition du public tous les supports de cours ainsi que les enregistrements vidéo des conférences.

Si cela semble vous être pour vous, voici quelques exemples concrets de ce que le cours enseignera :


## Le shell

Comment automatiser les tâches courantes et répétitives avec des alias, des scripts et des systèmes de compilation. Plus besoin de copier-coller des commandes à partir d'un document texte. Plus besoin de "lancer ces 15 commandes l'une après l'autre". Plus de "vous avez oublié d'exécuter cette chose" ou "vous avez oublié de passer cet argument".

Par exemple, une recherche rapide dans votre historique peut vous faire gagner énormément de temps. Dans l'exemple ci-dessous, nous montrons plusieurs astuces liées à la navigation dans l'historique de votre shell pour les commandes de conversion `convert`.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/history.mp4" type="video/mp4">
</video>

## Contrôle des versions

Comment utiliser _correctement_ le contrôle de version et en tirer parti pour éviter les catastrophes, collaborer avec d'autres personnes et trouver et isoler rapidement les modifications problématiques. Plus de `rm -rf ; git clone`. Plus de conflits de merge (ou du moins, moins de conflits). Plus d'énormes blocs de code commenté. Plus d'inquiétude sur la façon de trouver ce qui a cassé votre code. Plus de "oh non, avons-nous supprimé le code qui fonctionnait ?!". Nous vous apprendrons même à contribuer aux projets d'autres personnes par le biais de demandes de modification (pull requests) !

Dans l'exemple ci-dessous, nous utilisons `git bisect` pour trouver quel commit a fait échouer un test unitaire, puis nous le corrigeons avec `git revert`.
<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/git.mp4" type="video/mp4">
</video>

## Édition de texte

Comment éditer efficacement des fichiers à partir de la ligne de commande, à la fois localement et à distance, et profiter des fonctionnalités avancées de l'éditeur. Plus besoin de copier des fichiers dans les deux sens. Fini l'édition répétitive de fichiers.

Les macros de Vim sont l'une de ses meilleures fonctionnalités. Dans l'exemple ci-dessous, nous convertissons rapidement un tableau html au format csv à l'aide d'une macro imbriquée de Vim.
<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/vim.mp4" type="video/mp4">
</video>

## Machines distantes

Comment rester sain d'esprit lorsque l'on travaille avec des machines distantes en utilisant des clés SSH et le multiplexage de terminaux. Plus besoin de garder plusieurs terminaux ouverts juste pour exécuter deux commandes à la fois. Plus besoin de taper son mot de passe à chaque fois que l'on se connecte. Plus besoin de tout perdre parce que votre connexion Internet s'est déconnecté ou que vous avez dû redémarrer votre ordinateur portable.

Dans l'exemple ci-dessous, nous utilisons `tmux` pour maintenir les sessions actives sur les serveurs distants et `mosh` pour prendre en charge l'itinérance et la déconnexion du réseau.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/ssh.mp4" type="video/mp4">
</video>


## Recherche de fichiers

Comment trouver rapidement les fichiers que vous recherchez. Plus besoin de cliquer sur les fichiers de votre projet jusqu'à ce que vous trouviez celui qui contient le code que vous voulez.

Dans l'exemple ci-dessous, nous recherchons rapidement des fichiers avec `fd` et des extraits de code avec `rg`. Nous avons aussi rapidement `cd` et `vim` les fichiers/dossiers récents/fréquents en utilisant `fasd`.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/find.mp4" type="video/mp4">
</video>


## La manipulation des données

Comment modifier, visualiser, analyser, tracer et calculer rapidement et facilement des données et des fichiers directement depuis la ligne de commande. Fini le copier-coller des fichiers de log. Fini le calcul manuel des statistiques sur les données. Fini les tracés de graphiques dans les feuilles de calcul.

## Machines virtuelles

Comment utiliser des machines virtuelles pour tester de nouveaux systèmes d'exploitation, isoler des projets non liés et garder votre machine principale propre et bien rangée. Plus besoin de corrompre accidentellement votre ordinateur lors d'un exercice en cybersécurité. Fini les millions de packages installés au hasard avec des versions différentes.


## Sécurité

Comment être sur Internet sans révéler immédiatement tous ses secrets au monde entier. Plus besoin de trouver soi-même des mots de passe correspondant à des critères insensés. Fini les réseaux WiFi ouverts et non sécurisés. Fini les messageries non cryptées.


## Conclusion

Tout cela, et bien d'autres choses encore, sera abordé lors des 12 cours magistraux, chacun comprenant un exercice qui vous permettra de vous familiariser avec les outils par vous-même. Si vous ne pouvez pas attendre le mois de janvier, vous pouvez également jeter un coup d'œil aux cours de [Hacker
Tools](https://hacker-tools.github.io/lectures/), que nous avons organisés pendant l'IAP l'année dernière. C'est le précurseur de ce cours, et il couvre la plupart des mêmes sujets.

Nous espérons vous voir en janvier, que ce soit virtuellement ou en personne !

Joyeux hacking,<br>
Anish, Jose et Jon