---
layout: lecture
title: "Traitement des données"
date: 2020-01-16
ready: true
video:
  aspect: 56.25
  id: sz_dsktIjt4
---

Avez-vous déjà voulu prendre des données dans un format et les transformer dans un autre format ? Bien sûr que oui ! C'est, en termes très généraux, ce dont il est question dans ce cours. Plus précisément, il s'agit de manipuler des données, qu'elles soient au format texte ou binaire, jusqu'à ce que vous obteniez exactement ce que vous vouliez.

Nous avons déjà vu quelques manipulations de données de base dans les cours précédents. Pratiquement chaque fois que vous utilisez l'opérateur `|`, vous effectuez une sorte de manipulation de données. Prenons une commande comme `journalctl | grep -i intel`. Elle trouve toutes les entrées du journal système qui mentionnent Intel (sans tenir compte de la casse). Vous ne pensez peut-être pas qu'il s'agisse d'une manipulation de données, mais vous passez d'un format (l'ensemble de votre journal système) à un format qui vous est plus utile (uniquement les entrées du journal intel). La plupart des manipulations de données consistent à savoir quels outils sont à votre disposition et comment les combiner.

Commençons par le commencement. Pour manipuler des données, nous avons besoin de deux choses : des données à manipuler et quelque chose à faire avec. Les journaux (logs) constituent souvent une bonne base d'étude, parce que nous voulons souvent y tirer certaines informations, et qu'il n'est pas possible de les lire en entier. Essayons de savoir qui essaie de se connecter à mon serveur en regardant les logs de ce dernier :

```bash
ssh myserver journalctl
```

Le résultat est beaucoup trop long. Essayons de limiter la sortie à des trucs ssh :

```bash
ssh myserver journalctl | grep sshd
```

Remarquez que nous utilisons un pipe (`|`) pour passer un fichier _distant_ dans `grep` sur notre ordinateur en local ! `ssh` est magique, et nous en parlerons plus en détail dans le prochain cours sur l'environnement de ligne de commande. Le résultat comprend cependant encore beaucoup plus de choses que ce que nous voulions. Et plutôt difficile à lire. Faisons mieux :

```bash
ssh myserver 'journalctl | grep sshd | grep "Disconnected from"' | less
```

Pourquoi ces guillemets supplémentaires ? Eh bien, nos logs peuvent être assez volumineux, et il est inutile de les envoyer en continu sur notre ordinateur, puis de les filtrer. Au lieu de cela, nous pouvons effectuer le filtrage directement sur le serveur distant, puis affiner les données localement. `less` nous donne un "pager" qui nous permet de faire défiler la longue sortie vers le haut et vers le bas. Pour économiser du trafic supplémentaire pendant que nous déboguons notre ligne de commande, nous pouvons même sauvegarder les logs filtrés actuels dans un fichier afin de ne pas avoir à accéder au réseau pendant le développement :

```console
$ ssh myserver 'journalctl | grep sshd | grep "Disconnected from"' > ssh.log
$ less ssh.log
```

Il y a encore beaucoup de bruit dans les données restantes. Il existe de _nombreuses_ façons de s'en débarrasser, mais regardons l'un des outils les plus puissants de votre boîte à outils : `sed`.

`sed` est un "éditeur de stream" qui s'appuie sur le vieil éditeur `ed`. Dans cet éditeur, vous donnez de courtes commandes pour modifier le fichier, plutôt que de manipuler directement son contenu (bien que vous puissiez le faire aussi). Il existe des tonnes de commandes, mais l'une des plus courantes est `s` : la substitution. Par exemple, nous pouvons écrire :

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed 's/.*Disconnected from //'
```

Ce que nous venons d'écrire était une simple _expression régulière_ (regex) ; une construction puissante qui vous permet de faire correspondre du texte à des "motifs" (patterns). La commande `s` s'écrit sous la forme : `s/REGEX/SUBSTITUTION/`, où `REGEX` est l'expression régulière que vous souhaitez rechercher, et `SUBSTITUTION` est le texte que vous souhaitez substituer au texte correspondant.

(Vous reconnaîtrez peut-être cette syntaxe de la section "Recherche et remplacement" de nos [notes de cours](/2020/editors/#advanced-vim) sur Vim ! En effet, Vim utilise une syntaxe de recherche et de remplacement similaire à la commande de substitution de `sed`. L'apprentissage d'un outil permet souvent d'en maîtriser d'autres).

## Expressions régulières

Les expressions régulières sont suffisamment courantes et utiles pour que l'on prenne le temps de comprendre leur fonctionnement. Commençons par examiner celle que nous avons utilisée ci-dessus : `/.*Disconnected from /`. Les expressions régulières sont généralement (mais pas toujours) entourées de `/`. La plupart des caractères ASCII ont leur signification normale, mais certains ont un comportement "spécial" en matière de correspondance. Le comportement exact des caractères varie quelque peu d'une implémentation à l'autre des expressions régulières, ce qui peut être une source de grande frustration. Les motifs les plus courants sont les suivants :

   - `.` signifie "n'importe quel caractère" à l'exception du caractère représentant une nouvelle ligne
   - `*` zéro ou plus du caractère précédent
   - `+` un ou plusieurs du caractère précédent
   - `[abc]` n'importe quel caractère de `a`, `b` et `c`
   - `(RX1|RX2)` soit quelque chose qui correspond à `RX1` ou `RX2`
   - `^` le début de la ligne
   - `$` la fin de la ligne

Les expressions régulières de `sed` sont quelque peu bizarres, et vous devrez mettre un `\` avant la plupart d'entre elles pour leur donner leur signification spéciale. Vous pouvez aussi passer `-E`.

Ainsi, en regardant `/.*Disconnected from /`, nous voyons qu'il correspond à tout texte commençant par n'importe quel nombre de caractères, suivi de la chaîne de caractères "Disconnected from ". C'est ce que nous voulions. Mais attention, les expressions régulières sont délicates. Que se passerait-il si quelqu'un essayait de se connecter avec le nom d'utilisateur "Disconnected from " ? Nous aurions :

```
Jan 17 03:13:00 thesquareplanet.com sshd[2631]: Disconnected from invalid user Disconnected from 46.97.239.16 port 55920 [preauth]
```

Qu'en résulterait-il ? Eh bien, `*` et `+` sont, par défaut, "gourmands". Ils vont rechercher autant de texte que possible. Ainsi, dans l'exemple ci-dessus, nous obtiendrions juste

```
46.97.239.16 port 55920 [preauth]
```

Ce qui n'est peut-être pas ce que nous voulions. Dans certaines implémentations d'expressions régulières, vous pouvez simplement rallonger `*` ou `+` avec un `?` pour les rendre "non gourmandes", mais malheureusement `sed` ne possède pas cette option. Nous _pourrions_ cependant passer au mode ligne de commande de perl, qui supporte cette construction :

```bash
perl -pe 's/.*?Disconnected from //'
```

Nous nous en tiendrons à `sed` pour la suite, car c'est de loin l'outil le plus courant pour ce genre de tâches. `sed` peut également faire d'autres choses pratiques comme imprimer les lignes qui suivent une correspondance donnée, faire plusieurs substitutions par invocation, rechercher des choses, etc. `sed` est en fait un sujet à part entière, mais il existe souvent de meilleurs outils.

Ok, nous avons aussi un suffixe dont nous aimerions nous débarrasser. Comment faire ? Il est un peu difficile de faire correspondre uniquement le texte qui suit le nom d'utilisateur, surtout si le nom d'utilisateur peut contenir des espaces et autres ! Ce qu'il faut, c'est faire correspondre _toute_ la ligne :

```bash
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user .* [^ ]+ port [0-9]+( \[preauth\])?$//'
```

Regardons ce qui se passe avec un [débogueur de regex](https://regex101.com/r/qqbZqh/2). D'accord, le début est toujours le même. Ensuite, nous recherchons n'importe quelle variante de "user" (il y a deux préfixes dans les logs). Ensuite, nous recherchons n'importe quelle chaîne de caractères contenant le nom d'utilisateur. Ensuite, nous recherchons n'importe quel mot (`[^ ]+`; n'importe quelle séquence non vide de caractères non espace). Puis le mot "port" suivi d'une séquence de chiffres. Puis éventuellement le suffixe `[preauth]`, et enfin la fin de la ligne.

Remarquez qu'avec cette technique, le nom d'utilisateur "Disconnected from" ne nous embêtera plus. Comprenez-vous pourquoi ?

Il y a cependant un problème, et c'est que le log entier devient vide. Après tout, nous voulons _garder_ le nom d'utilisateur. Pour cela, nous pouvons utiliser des "capture groups". Tout texte correspondant à une regex entourée de parenthèses est stocké dans un groupe de capture numéroté. Ceux-ci sont disponibles dans la substitution (et dans certains programmes, même dans le motif lui-même !) comme `\1`, `\2`, `\3`, etc. Ainsi :

```bash
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

Comme vous pouvez l'imaginer, il est possible de créer des expressions régulières _très_ compliquées. Par exemple, voici un article sur la manière de faire correspondre une [addresse mail](https://www.regular-expressions.info/email.html). Ce n'est [pas facile](https://web.archive.org/web/20221223174323/http://emailregex.com/). Et il y a [beaucoup de discussions](https://stackoverflow.com/questions/201323/how-to-validate-an-email-address-using-a-regular-expression/1917982). Et les gens ont [écrits des tests](https://fightingforalostcause.net/content/misc/2006/compare-email-regex.php). Et des [matrices de tests](https://mathiasbynens.be/demo/url-regex). Vous pouvez même écrire une regex pour déterminer si un nombre donné est [un nombre premier](https://www.noulakaz.net/2007/03/18/a-regular-expression-to-check-for-prime-numbers/).

Les expressions régulières sont très difficiles à maîtriser, mais elles sont aussi très pratiques à avoir dans sa boîte à outils !

## Retour à la manipulation des données

Nous avons jusqu'à présent : 

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

`sed` peut faire toutes sortes d'autres choses intéressantes, comme injecter du texte (avec la commande `i`), imprimer explicitement des lignes (avec la commande `p`), sélectionner des lignes par index, et bien d'autres choses encore. Consultez sa page de manuel `man sed` !

Ce que nous avons maintenant nous donne une liste de tous les noms d'utilisateurs qui ont tenté de se connecter. Mais cela n'est pas très utile. Cherchons les plus courants :

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
```

`sort` va, comme son nom l'indique, trier son entrée. `uniq -c` va regrouper les lignes consécutives qui sont les mêmes en une seule ligne, devancée par le compte du nombre d'occurrences. Nous voulons probablement asusi trier cette liste et ne garder que les noms d'utilisateur les plus courants :

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
```

`sort -n` permet de trier dans l'ordre numérique (au lieu de l'ordre lexicographique). `-k1,1` signifie "trier uniquement sur la première colonne séparée par des espaces". La partie `,n` indique "trier jusqu'au `n`ième champ, où la valeur par défaut est la fin de la ligne". Dans cet exemple _particulier_, le tri par ligne entière aurait donné le même résultat, mais nous sommes ici pour apprendre !

Si nous voulions les _moins_ courants, nous pourrions utiliser `head` au lieu de `tail`. Il y a aussi `sort -r`, qui trie dans l'ordre inverse.

Ok, c'est plutôt cool, mais qu'en est-il si nous voulons extraire uniquement les noms d'utilisateurs sous forme de liste séparée par des virgules au lieu d'un par ligne, par exemple pour un fichier de configuration ?

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
 | awk '{print $2}' | paste -sd,
```


Si vous utilisez macOS : notez que la commande telle qu'elle est montrée ne fonctionnera pas avec le `paste` BSD inclus avec macOS. Voir [l'exercice 4 du cours sur les outils de l'interpréteur de commandes](/2020/shell-tools/#exercises) pour plus d'informations sur la différence entre BSD et GNU coreutils et les instructions pour installer GNU coreutils sur macOS.

Commençons par `paste` : il vous permet de combiner des lignes (`-s`) à l'aide d'un délimiteur à un seul caractère (`-d` ; `,` dans ce cas). Mais qu'est-ce que c'est que cette histoire d'`awk` ?

## awk -- un autre éditeur

`awk` est un langage de programmation qui s'avère être très efficace pour traiter les flux de texte. Il y aurait _beaucoup_ à dire sur `awk` si vous deviez l'apprendre correctement, mais comme pour beaucoup d'autres choses ici, nous nous contenterons de passer en revue les bases.

Tout d'abord, que fait `{print $2}` ? Les programmes `awk` se présentent sous la forme d'un pattern optionnel et d'un bloc indiquant ce qu'il faut faire si le pattern correspond à une ligne donnée. Le pattern par défaut (que nous avons utilisé ci-dessus) correspond à toutes les lignes. À l'intérieur du bloc, `$0` est défini comme le contenu entier de la ligne, et `$1` à `$n` sont définis comme le `n`ième _champ_ de cette ligne, lorsqu'ils sont séparés par le séparateur de champ de `awk` (espace par défaut, modifiable avec `-F`). Dans ce cas, nous disons que, pour chaque ligne, nous imprimons le contenu du deuxième champ, qui se trouve être le nom d'utilisateur !

Voyons si nous pouvons faire quelque chose de plus fantaisiste. Calculons le nombre de noms d'utilisateur à usage unique qui commencent par `c` et se terminent par `e` :

```bash
 | awk '$1 == 1 && $2 ~ /^c[^ ]*e$/ { print $2 }' | wc -l
```

Il y a beaucoup de choses à décortiquer ici. Tout d'abord, remarquez que nous avons maintenant un pattern (ce qui se trouve avant `{...}`). Le pattern dit que le premier champ de la ligne doit être égal à 1 (c'est le compte de `uniq -c`), et que le second champ doit correspondre à l'expression régulière donnée. Et le bloc dit simplement d'imprimer le nom d'utilisateur. Nous comptons ensuite le nombre de lignes dans la sortie avec `wc -l`.

Cependant, `awk` est un langage de programmation, vous vous souvenez ?

```awk
BEGIN { rows = 0 }
$1 == 1 && $2 ~ /^c[^ ]*e$/ { rows += $1 }
END { print rows }
```

`BEGIN` est un pattern qui correspond au début de l'entrée (et `END` correspond à la fin). Maintenant, le bloc par ligne ne fait qu'ajouter le compte du premier champ (bien qu'il soit toujours égal à 1 dans ce cas), et nous l'imprimons à la fin. En fait, nous _pourrions_ nous débarrasser complètement de `grep` et de `sed`, car `awk` [peut tout faire](https://backreference.org/2010/02/10/idiomatic-awk/), mais nous laisserons cet exercice au lecteur.

## Analyse des données

Vous pouvez faire des calculs directement dans votre shell en utilisant `bc`, une calculatrice qui peut lire à partir de STDIN ! Par exemple, additionner les nombres de chaque ligne en les concaténant, délimités par + :

```bash
 | paste -sd+ | bc -l
```

Vous pouvez également produire des expressions plus élaborées :

```bash
echo "2*($(data | paste -sd+))" | bc -l
```

Vous pouvez obtenir des statistiques de différentes manières. [`st`](https://github.com/nferraz/st) est très intéressant, mais si vous avez déjà [R](https://www.r-project.org/):

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | awk '{print $1}' | R --no-echo -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
```

R est un autre langage de programmation (étrange) qui permet d'analyser des données et de [tracer des graphiques](https://ggplot2.tidyverse.org/). Nous n'entrerons pas dans les détails, mais il suffit de dire que `summary` imprime un résumé statistique pour un vecteur, et nous avons créé un vecteur contenant le flux de chiffres en entrée, donc R nous donne les statistiques que nous voulions !

Si vous souhaitez simplement tracer des graphiques, `gnuplot` est votre ami :

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
 | gnuplot -p -e 'set boxwidth 0.5; plot "-" using 1:xtic(2) with boxes'
```

## Traiter des données pour créer des arguments

Parfois, vous voulez faire de la manipulation de données pour trouver des choses à installer ou à supprimer sur base d'une liste plus longue. La manipulation de données dont nous avons parlé jusqu'à présent + `xargs` peut être une combinaison puissante.

Par exemple, comme nous l'avons vu dans le cours, je peux utiliser la commande suivante pour désinstaller les anciens builds "nightly" de Rust de mon système en extrayant les noms des anciens builds à l'aide d'outils d'extraction de données, puis en les transmettant via `xargs` au programme de désinstallation :

```bash
rustup toolchain list | grep nightly | grep -vE "nightly-x86" | sed 's/-x86.*//' | xargs rustup toolchain uninstall
```

## Manipuler des données binaires

Jusqu'à présent, nous avons surtout parlé de la manipulation de données textuelles, mais les pipes sont tout aussi utiles pour les données binaires. Par exemple, nous pouvons utiliser `ffmpeg` pour capturer une image depuis notre caméra, la convertir en niveaux de gris, la compresser, l'envoyer à une machine distante via SSH, la décompresser sur place, en faire une copie, puis l'afficher.

```bash
ffmpeg -loglevel panic -i /dev/video0 -frames 1 -f image2 -
 | convert - -colorspace gray -
 | gzip
 | ssh mymachine 'gzip -d | tee copy.jpg | env DISPLAY=:0 feh -'
```

# Exercices

1. Suivez ce [court tutoriel interactif sur les expressions rationnelles](https://regexone.com/).

2. Trouvez le nombre de mots (dans `/usr/share/dict/words`) qui contiennent au moins trois `a` et qui n'ont pas de `'s` à la fin. Quelles sont les trois dernières lettres les plus courantes de ces mots ? La commande `y` de `sed`, ou le programme `tr`, peuvent vous aider à respecter la casse. Combien y a-t-il de ces combinaisons de deux lettres ? Et pour le défi : quelles sont les combinaisons qui n'apparaissent pas ?

3. Pour effectuer une substitution en place, il est tentant de faire quelque chose comme `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt`. Mais c'est une mauvaise idée, pourquoi ? S'agit-il d'une particularité de `sed` ? Utilisez `man sed` pour savoir comment procéder.

4. Trouvez le temps de démarrage moyen, médian et maximal de votre système sur les dix derniers démarrages. Utilisez `journalctl` sous Linux et `log show` sous macOS, et recherchez les timestamps des journaux au début et à la fin de chaque démarrage. Sous Linux, ils peuvent ressembler à quelque chose comme :

    ```
   Logs begin at ...
   ```
   et
   ```
   systemd[577]: Startup finished in ...
   ```
   Sur macOS, [cherchez](https://eclecticlight.co/2018/03/21/macos-unified-log-3-finding-your-way/):
   ```
   === system boot:
   ```
   et
   ```
   Previous shutdown cause: 5
   ```

5. Recherchez les messages de démarrage qui ne sont _pas_ partagés entre vos trois derniers redémarrages (voir le drapeau `-b` de `journalctl`). Divisez cette tâche en plusieurs sous-étapes. Tout d'abord, trouvez un moyen d'obtenir uniquement les logs des trois derniers redémarrages. Il pourrait y avoir un drapeau applicable sur l'outil que vous utilisez pour extraire les journaux de démarrage, ou vous pouvez utiliser `sed '0,/STRING/d'` pour supprimer toutes les lignes précédant celle qui correspond à `STRING`. Ensuite, supprimez toutes les parties de la ligne qui varient _toujours_ (comme les timestamps).  Ensuite, dédupliquez les lignes d'entrée et comptez les occurences de chacune d'entre elles (`uniq` est votre ami). Enfin, éliminez toute ligne dont le nombre est égal à 3 (puisqu'elle _a été_ partagée entre toutes les démarrages).

6. Trouvez un data set en ligne comme [celui-ci](https://stats.wikimedia.org/EN/TablesWikipediaZZ.htm), [celui-ci](https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/topic-pages/tables/table-1), ou peut-être [celui-ci](https://www.springboard.com/blog/data-science/free-public-data-sets-data-science-project/). Récupérez-le à l'aide de `curl` et extrayez seulement deux colonnes de données numériques. Si vous récupérez des données HTML, [`pup`](https://github.com/EricChiang/pup) peut être utile. Pour des données JSON, essayez [`jq`](https://stedolan.github.io/jq/). Trouvez le min et le max d'une colonne en une seule commande, et la différence de la somme de chaque colonne avec une autre.