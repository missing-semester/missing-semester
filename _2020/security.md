---
layout: lecture
title: "Sécurité et cryptographie"
date: 2020-01-28
ready: true
video:
  aspect: 56.25
  id: tjwobAmnKTo
---

Le cours sur [la sécurité et la vie privée](/2019/security/) de l'année dernière s'est concentré sur la façon dont vous pouvez être plus en sécurité en tant qu'utilisateur d'ordinateur. Cette année, nous nous concentrerons sur les concepts de sécurité et de cryptographie qui sont pertinents pour comprendre les outils couverts précédemment dans ce cours, tels que l'utilisation des fonctions de hachage dans Git ou les fonctions de dérivation de clé et les cryptosystèmes symétriques/asymétriques dans SSH.

Ce cours ne remplace pas un cours plus rigoureux et plus complet sur la sécurité des systèmes informatiques ([6.858](https://css.csail.mit.edu/6.858/)) ou la cryptographie ([6.857](https://courses.csail.mit.edu/6.857/) et 6.875). Ne travaillez pas dans le domaine de la sécurité sans avoir reçu une formation formelle en la matière. À moins d'être un expert, n'élaborez pas votre propre cryptographie. Le même principe s'applique à la sécurité des systèmes.

Ce cours traite de manière très informelle (mais nous pensons qu'il est pratique) des concepts de base de la cryptographie. Ce cours ne sera pas suffisant pour vous apprendre à _concevoir_ des systèmes sécurisés ou des protocoles cryptographiques, mais nous espérons qu'il sera suffisant pour vous donner une compréhension générale des programmes et des protocoles que vous utilisez déjà.

# Entropie

[L'entropie](https://en.wikipedia.org/wiki/Entropy_(information_theory)) est une mesure du caractère aléatoire. Elle est utile, par exemple, pour déterminer la force d'un mot de passe.

![XKCD 936: Password Strength](https://imgs.xkcd.com/comics/password_strength.png)

Comme l'illustre la bande [dessinée XKCD](https://xkcd.com/936/) ci-dessus, un mot de passe tel que "correcthorsebatterystaple" est plus sûr qu'un mot de passe tel que "Tr0ub4dor&3". Mais comment quantifier une telle chose ?

L'entropie est mesurée en _bits_, et lorsque l'on choisit uniformément au hasard parmi un ensemble de résultats possibles, l'entropie est égale à `log_2(nombre de possibilités)`. Un pile ou face équitable donne 1 bit d'entropie. Un lancer de dés (d'un dé à 6 faces) a \~2,58 bits d'entropie.

Vous devez considérer que l'attaquant connaît le modèle du mot de passe, mais pas le caractère aléatoire (par exemple, [les dés](https://en.wikipedia.org/wiki/Diceware)) utilisé pour sélectionner un mot de passe particulier.

Combien de bits d'entropie sont suffisants ? Cela dépend de votre modèle de menace. Comme le souligne la bande dessinée XKCD, environ \~40 bits d'entropie sont suffisants pour une tentative de devinette en ligne. Pour résister aux devinettes hors ligne, un mot de passe plus fort serait nécessaire (par exemple, 80 bits ou plus).

# Fonctions de hachage

Une [fonction de hachage](https://en.wikipedia.org/wiki/Cryptographic_hash_function) cryptographique fait correspondre des données de taille arbitraire à une taille fixe et possède certaines propriétés particulières. Une spécification approximative d'une fonction de hachage est la suivante :

```
hash(value: array<byte>) -> vector<byte, N>  (pour un certain nombre de N)
```
Un exemple de fonction de hachage est [SHA1](https://en.wikipedia.org/wiki/SHA-1), utilisée dans Git. Elle associe des entrées de taille arbitraire à des sorties de 160 bits (qui peuvent être représentées par 40 caractères hexadécimaux). Nous pouvons tester le hachage SHA1 sur une entrée à l'aide de la commande sha1sum :

```console
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'Hello' | sha1sum 
f7ff9e8b7bb2e09b70935a5d785e0cc5d9d0abf0
```

À un niveau élevé, une fonction de hachage peut être considérée comme une fonction aléatoire (mais déterministe) difficile à inverser (et c'est le [modèle idéal d'une fonction de hachage](https://en.wikipedia.org/wiki/Random_oracle)). Une fonction de hachage possède les propriétés suivantes

- Déterministe : la même entrée génère toujours la même sortie.
- Non inversible : il est difficile de trouver une entrée `m` telle que `hash(m) = h` pour une sortie souhaitée `h`.
- Résistant aux collisions de cibles : étant donné une entrée `m_1`, il est difficile de trouver une entrée différente `m_2`telle que `hash(m_1) = hash(m_2)`.
- Résistance aux collisions : il est difficile de trouver deux entrées `m_1` et `m_2` telles que `hash(m_1) = hash(m_2)` (notez qu'il s'agit d'une propriété strictement plus forte que la résistance aux collisions de cibles).

Remarque : bien qu'il puisse fonctionner à certaines fins, SHA-1 n'est [plus considéré](https://shattered.io/) comme une fonction de hachage cryptographique solide. Ce tableau [des durées de vie des fonctions de hachage cryptographique](https://valerieaurora.org/hash.html) pourrait vous intéresser. Notez toutefois que la recommandation de fonctions de hachage spécifiques dépasse le cadre de cet exposé. Si vous travaillez dans un domaine où cette question est importante, vous devez suivre une formation formelle en sécurité/cryptographie.

## Applications

- Git, pour le stockage avec adresse de contenu. L'idée d'une [fonction de hachage](https://en.wikipedia.org/wiki/Hash_function) est un concept plus général (il existe des fonctions de hachage non cryptographiques). Pourquoi Git utilise-t-il une fonction de hachage cryptographique ?
- Un bref résumé du contenu d'un fichier. Les logiciels peuvent souvent être téléchargés à partir de miroirs (potentiellement moins fiables), par exemple les ISO Linux, et il serait agréable de ne pas avoir à leur faire confiance. Les sites officiels affichent généralement des hachages à côté des liens de téléchargement (qui pointent vers des miroirs tiers), de sorte que le hachage peut être vérifié après le téléchargement d'un fichier.
- [Schémas d'engagement](https://en.wikipedia.org/wiki/Commitment_scheme). Supposons que vous souhaitiez vous engager sur une valeur particulière, mais que vous révéliez la valeur elle-même plus tard. Par exemple, je veux lancer une pièce de monnaie équitable "dans ma tête", sans avoir recours à une pièce de monnaie partagée et fiable que les deux parties peuvent voir. Je pourrais choisir une valeur `r = random()`, puis partager `h = sha256(r)`. Ensuite, vous pourriez annoncer pile ou face (nous conviendrons que `r` pair signifie pile, et `r` impair signifie pile). Après votre appel, je peux révéler ma valeur `r`, et vous pouvez confirmer que je n'ai pas triché en vérifiant que `sha256(r)` correspond au hachage que j'ai partagé plus tôt.

# Fonctions de dérivation de clé

Concept apparenté aux hachages cryptographiques, [les fonctions de dérivation de clé](https://en.wikipedia.org/wiki/Key_derivation_function) (KDF) sont utilisées pour un certain nombre d'applications, notamment pour produire des résultats de longueur fixe à utiliser comme clés dans d'autres algorithmes cryptographiques. En général, les KDF sont délibérément lentes, afin de ralentir les attaques par force brute hors ligne.

## Applications

- Producing keys from passphrases for use in other cryptographic algorithms
(e.g. symmetric cryptography, see below).
- Storing login credentials. Storing plaintext passwords is bad; the right
approach is to generate and store a random
[salt](https://en.wikipedia.org/wiki/Salt_(cryptography)) `salt = random()` for
each user, store `KDF(password + salt)`, and verify login attempts by
re-computing the KDF given the entered password and the stored salt.

- Production de clés à partir de phrases de passe en vue de leur utilisation dans d'autres algorithmes cryptographiques (par exemple, la cryptographie symétrique, voir ci-dessous).
- Stockage des identifiants de connexion. Stocker des mots de passe en clair est une mauvaise chose ; la bonne approche consiste à générer et à stocker un [sel](https://en.wikipedia.org/wiki/Salt_(cryptography)) aléatoire `salt = random()` pour chaque utilisateur, à stocker `KDF(mot de passe + salt)`, et à vérifier les tentatives de connexion en recalculant le KDF à partir du mot de passe saisi et du sel stocké.

# La cryptographie symétrique

La dissimulation du contenu d'un message est probablement le premier concept qui vous vient à l'esprit lorsque vous pensez à la cryptographie. La cryptographie symétrique permet d'atteindre cet objectif grâce à l'ensemble des fonctionnalités suivantes :

```
keygen() -> key  (cette fonction est aléatoire)

encrypt(plaintext: array<byte>, key) -> array<byte>  (the ciphertext)
decrypt(ciphertext: array<byte>, key) -> array<byte>  (the plaintext)
```

La fonction de chiffrement a la propriété qu'étant donné la sortie (texte chiffré), il est difficile de déterminer l'entrée (texte en clair) sans la clé. La fonction de décryptage possède la propriété évidente de correction, à savoir que `decrypt(encrypt(m, k), k) = m`.

[L'AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) est un exemple de cryptosystème symétrique largement utilisé aujourd'hui.

## Applications

Chiffrement de fichiers destinés à être stockés dans un service en nuage non fiable. Ce système peut être combiné avec les KDF, ce qui permet de chiffrer un fichier à l'aide d'une phrase de passe. Générer une `cle = KDF(phrase de passe)`, puis stocker `encrypt(fichier, clé)`.

# Cryptographie asymétrique

Cryptographie asymétriqueLe terme "asymétrique" fait référence à l'existence de deux clés, avec deux rôles différents. Une clé privée, comme son nom l'indique, est destinée à rester privée, tandis que la clé publique peut être partagée publiquement sans que cela n'affecte la sécurité (contrairement au partage de la clé dans un système de cryptographie symétrique). Les cryptosystèmes asymétriques offrent les fonctionnalités suivantes : chiffrer/déchiffrer et signer/vérifier :

```
keygen() -> (public key, private key)  (cette fonction est aléatoire)

encrypt(plaintext: array<byte>, public key) -> array<byte>  (le texte crypté)
decrypt(ciphertext: array<byte>, private key) -> array<byte>  (le texte en clair)

sign(message: array<byte>, private key) -> array<byte>  (la signature)
verify(message: array<byte>, signature: array<byte>, public key) -> bool  (si la signature est valide ou non)
```

Les fonctions de cryptage/décryptage ont des propriétés similaires à celles de leurs analogues dans les systèmes cryptographiques symétriques. Un message peut être crypté à l'aide de la clé _publique_. Étant donné la sortie (texte chiffré), il est difficile de déterminer l'entrée (texte en clair) sans la clé _privée_. La fonction decrypt possède la propriété évidente de correction, à savoir `decrypt(encrypt(m, public key), private key) = m`.

Les cryptages symétrique et asymétrique peuvent être comparés à des serrures physiques. Un système de cryptage symétrique est comme une serrure de porte : toute personne possédant la clé peut la verrouiller et la déverrouiller. Le cryptage asymétrique est comme un cadenas avec une clé. Vous pouvez donner le cadenas déverrouillé à quelqu'un (la clé publique), cette personne peut mettre un message dans une boîte et ensuite mettre le cadenas, et après cela, vous seul pouvez ouvrir le cadenas parce que vous avez gardé la clé (la clé privée).

Les fonctions de signature/vérification ont les mêmes propriétés que les signatures physiques, à savoir qu'il est difficile de falsifier une signature. Quel que soit le message, sans la clé _privée_, il est difficile de produire une signature telle que `verify(message, signature, clé publique)` renvoie true. Et bien sûr, la fonction de vérification possède la propriété de correction évidente suivante : `verify(message, sign(message, clé privée), clé publique) = true`.

## Applications

- [Cryptage des courriels par PDP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy). Les personnes peuvent publier leurs clés publiques en ligne (par exemple, dans un serveur de clés PGP ou sur [Keybase](https://keybase.io/)). N'importe qui peut leur envoyer un courrier électronique crypté.
- Messagerie privée. Des applications comme [Signal](https://signal.org/) ou
[Keybase](https://keybase.io/) utilisent des clés asymétriques pour établir des canaux de communication privés.
- Logiciel de signature. Git peut avoir des commits et des tags signés GPG. Avec une clé publique affichée, n'importe qui peut vérifier l'authenticité d'un logiciel téléchargé.

## Partage des clés

Asymmetric-key cryptography is wonderful, but it has a big challenge of
distributing public keys / mapping public keys to real-world identities. There
are many solutions to this problem. Signal has one simple solution: trust on
first use, and support out-of-band public key exchange (you verify your
friends' "safety numbers" in person). PGP has a different solution, which is
[web of trust](https://en.wikipedia.org/wiki/Web_of_trust). Keybase has yet
another solution of [social
proof](https://keybase.io/blog/chat-apps-softer-than-tofu) (along with other
neat ideas). Each model has its merits; we (the instructors) like Keybase's
model.

La cryptographie à clé asymétrique est merveilleuse, mais elle présente un défi de taille : la distribution des clés publiques et la mise en correspondance des clés publiques avec les identités du monde réel. Il existe de nombreuses solutions à ce problème. Signal a une solution simple : faire confiance dès la première utilisation et prendre en charge l'échange de clés publiques hors bande (vous vérifiez les "numéros de sécurité" de vos amis en personne). PGP propose une solution différente, à savoir un [réseau de confiance][web of trust](https://en.wikipedia.org/wiki/Web_of_trust). Keybase propose une autre solution, la [preuve sociale](https://keybase.io/blog/chat-apps-softer-than-tofu) (ainsi que d'autres idées intéressantes). Chaque modèle a ses mérites ; nous (les instructeurs) aimons le modèle de Keybase.

# Études de cas

## Gestionnaires de mots de passe

Il s'agit d'un outil essentiel que tout le monde devrait essayer d'utiliser (par exemple [KeePassXC](https://keepassxc.org/), [pass](https://www.passwordstore.org/) et [1Password](https://1password.com)). Les gestionnaires de mots de passe permettent d'utiliser des mots de passe uniques, générés de manière aléatoire et à forte entropie pour toutes les connexions, et ils sauvegardent tous les mots de passe en un seul endroit, cryptés avec un chiffrement symétrique et une clé produite à partir d'une phrase de passe à l'aide d'un KDF.

L'utilisation d'un gestionnaire de mots de passe vous permet d'éviter la réutilisation des mots de passe (vous êtes donc moins touché lorsque des sites web sont compromis), d'utiliser des mots de passe à haute entropie (vous êtes donc moins susceptible d'être compromis) et de ne devoir vous souvenir que d'un seul mot de passe à haute entropie.

## L'authentification à deux facteurs

[Two-factor
authentication](https://en.wikipedia.org/wiki/Multi-factor_authentication)
(2FA) requires you to use a passphrase ("something you know") along with a 2FA
authenticator (like a [YubiKey](https://www.yubico.com/), "something you have")
in order to protect against stolen passwords and
[phishing](https://en.wikipedia.org/wiki/Phishing) attacks.

L'authentification à deux facteurs ([2FA](https://en.wikipedia.org/wiki/Multi-factor_authentication)) nécessite l'utilisation d'une phrase de passe ("quelque chose que vous connaissez") et d'un authentificateur 2FA (comme une [YubiKey](https://www.yubico.com/), "quelque chose que vous avez") afin de vous protéger contre les mots de passe volés et les attaques par hameçonnage.

## Cryptage intégral du disque

Le fait de crypter l'intégralité du disque de votre ordinateur portable est un moyen simple de protéger vos données en cas de vol. Vous pouvez utiliser [cryptsetup + LUKS sous Linux](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_a_non-root_file_system), [BitLocker](https://fossbytes.com/enable-full-disk-encryption-windows-10/) sous Windows ou [FileVault][FileVault] sous macOS. Cette méthode permet de chiffrer l'ensemble du disque à l'aide d'un algorithme de chiffrement symétrique, avec une clé protégée par une phrase d'authentification.
## Messagerie privée

Utilisez [Signal](https://signal.org/) ou [Keybase](https://keybase.io/). La sécurité de bout en bout repose sur le chiffrement à clé asymétrique. L'obtention des clés publiques de vos contacts est l'étape critique. Si vous voulez une bonne sécurité, vous devez authentifier les clés publiques hors bande (avec Signal ou Keybase) ou faire confiance aux preuves sociales (avec Keybase).

## SSH

Nous avons abordé l'utilisation de SSH et des clés SSH dans un [cours précédent](/2020/command-line/#remote-machines). Examinons maintenant les aspects cryptographiques.

Lorsque vous exécutez `ssh-keygen`, il génère une paire de clés asymétriques, `public_key`, `private_key`. Celle-ci est générée aléatoirement, en utilisant l'entropie fournie par le système d'exploitation (collectée à partir d'événements matériels, etc.). La clé publique est stockée telle quelle (elle est publique, il n'est donc pas important de la garder secrète), mais au repos, la clé privée doit être chiffrée sur le disque. Le programme `ssh-keygen` demande à l'utilisateur de saisir une phrase de passe, qui est transmise à une fonction de dérivation de clé pour produire une clé, qui est ensuite utilisée pour chiffrer la clé privée à l'aide d'un algorithme de chiffrement symétrique.

En pratique, une fois que le serveur connaît la clé publique du client (stockée dans le fichier `.ssh/authorized_keys`), un client qui se connecte peut prouver son identité à l'aide de signatures asymétriques. Cela se fait par le biais d'un [défi-réponse](https://en.wikipedia.org/wiki/Challenge%E2%80%93response_authentication). À un niveau élevé, le serveur choisit un nombre aléatoire et l'envoie au client. Le client signe ensuite ce message et renvoie la signature au serveur, qui la compare à la clé publique enregistrée. Cela prouve effectivement que le client est en possession de la clé privée correspondant à la clé publique qui se trouve dans le fichier `.ssh/authorized_keys` du serveur, de sorte que le serveur peut autoriser le client à se connecter.

{% comment %}
extra topics, if there's time

security concepts, tips
- biometrics
- HTTPS
{% endcomment %}

# Ressources

- [Notes de 2019](/2019/security/): où cette conférence était plus axée sur la sécurité et la protection de la vie privée en tant qu'utilisateur d'ordinateur
- [Réponses correctes en matière de cryptographie](https://latacora.micro.blog/2018/04/03/cryptographic-right-answers.html): permet de répondre à la question "quelle cryptographie dois-je utiliser pour X ?" pour de X choses.

# Exercises

1. **Entropie.**
    1. Supposons qu'un mot de passe soit choisi comme une concaténation de quatre mots du dictionnaire en minuscules, où chaque mot est choisi uniformément au hasard dans un dictionnaire de taille 100 000. Un exemple d'un tel mot de passe est `correcthorsebatterystaple`. Combien de bits d'entropie ce mot de passe possède-t-il ?
    1. Envisagez un autre système dans lequel le mot de passe est choisi comme une séquence de 8 caractères alphanumériques aléatoires (comprenant à la fois des lettres minuscules et majuscules). Un exemple est `rg8Ql34g`. Combien de bits d'entropie cela représente-t-il ?
    1. Quel est le mot de passe le plus puissant ?
    1. Supposons qu'un attaquant puisse essayer de deviner 10 000 mots de passe par seconde. En moyenne, combien de temps faudra-t-il pour déchiffrer chacun des mots de passe ?
1. **Fonctions de hachage cryptographiques.** Download a Debian image from a
   Téléchargez une image Debian à partir d'un [mirror](https://www.debian.org/CD/http-ftp/) (par exemple à partir de ce [mirror argentin](http://debian.xfree.com.ar/debian-cd/current/amd64/iso-cd/)). Vérifiez le hachage (par exemple en utilisant la commande `sha256sum`) avec le hachage récupéré sur le site officiel de Debian (par exemple [ce fichier](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS) hébergé sur `debian.org`, si vous avez téléchargé le fichier lié depuis le mirror argentin).
1. **Cryptographie symétrique.**  Chiffrer un fichier avec le chiffrement AES, en utilisant [OpenSSL](https://www.openssl.org/) : `openssl aes-256-cbc -salt -in {nom du fichier d'entrée} -out {nom du fichier de sortie}`. Regardez le contenu en utilisant `cat` ou `hexdump`. Décryptez-le avec `openssl aes-256-cbc -d -in {input filename} -out {output filename}` et confirmez que le contenu correspond à l'original en utilisant `cmp`.
1. **Cryptographie asymétrique.**
    1. Configurez les [clés SSH](https://www.digitalocean.com/community/tutorialshow-to-set-up-ssh-keys--2) sur un ordinateur auquel vous avez accès (pas Athena, car Kerberos interagit bizarrement avec les clés SSH). Assurez-vous que votre clé privée est cryptée avec une phrase de passe, afin qu'elle soit protégée au repos.
    1. [Configurer GPG](https://www.digitalocean.com/community/tutorials/how-to-use-gpg-to-encrypt-and-sign-messages)
    1. Envoyez à Anish un courriel crypté ([clé publique](https://keybase.io/anish)).
    1. Signer un commit Git avec `git commit -S` ou créer un tag Git signé avec `git tag -s`. Vérifiez la signature sur le commit avec `git show --show-signature` ou sur le tag avec `git tag -v`.
