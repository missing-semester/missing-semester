---
layout: lecture
title: "Automation"
presenter: Jose
video:
  aspect: 56.25
  id: BaLlAaHz-1k
---

Parfois on veut écrire un script qui fait quelque chose périodiquement, disons un backup. On peut toujours écrire une solution *ad hoc* qui roule en arrière-plan et qui revient en-ligne périodiquement. Pourtant, la plupart des systèmes UNIX viennent avec le daemon cron, qui peut exécuter une tâche avec une fréquence qui va jusqu'à une minute en se basant sur quelques règles.

Sur la plupart des systèmes UNIX, le daemon cron, `crond` sera en train d'exécuter par défaut, mais on peut toujours vérifier en utilisant `ps aux | grep crond`.

## La crontab

Le fichier de configuration peut être affiché en exécutant `crontab -l` et modifié en exécutant `crontab -e`. Le format de date que cron utilise est cinq champs séparé par des espaces, ainsi que l'utilisateur et la commande.

- **minute** -  La minute pour laquelle la commande sera exécutée, et est entre '0' et '59'
- **hour** -    Ceci contrôle l'heure à laquelle cette commande sera exécutée et est en format 24 heure. Les valeurs doivent être entre 0 et 23 (0 est miniuit).
- **dom** -     Ceci est le jour du mois. Notez que si vous voulez exécuter la commande le 19ième de chaque mois, par exemple, le dom serait 19.
- **month** -   Ceci est le mois pour lequel cette commande sera exécutée. Il peut être spécifié numériquement (0-12), ou avec le nom du mois (par exemple: May)
- **dow** -     Ceci est le jour de la semaine que vous voulez exécuter cette commande. Il peut aussi être numérique (0-7) our en tant que le nom du jour (par exemple: sun).
- **user** -	Ceci est l'utilisateur qui exécute la commande.
- **command** - Ceci est la commande qui doit être exécutée. Ce champ peut contenir plusieurs mots ou espaces.

Prenez en note qu'utiliser un astérisque `*` signifie 'tous' et utiliser un astérisque suivi d'une barre oblique et un nombre signifie 'chaque nième valeur'. Donc `*/5` signifie chaque 5. Quelques exemples:

```shell
*/5   *    *   *   *       # Chaque 5 minutes
  0   *    *   *   *       # Chaque heure exacte
  0   9    *   *   *       # Chaque jour à 9:00am 
  0   9-17 *   *   *       # Chaque heure entre 9:00am et 5:00pm
  0   0    *   *   5       # Chaque Vendredi à minuit (12:00am)
  0   0    1   */2 *       # Chaque 2 mois, le premier jour, à minuit (12:00am)
```
Vous trouverez plus d'exemples d'horaires crontab récurrents sur [crontab.guru](https://crontab.guru/examples.html)

## L'environnement Shell et l'enregistrement

Une erreur récurrente quand on utilise cron est qu'il ne charge pas les mêmes scripts d'environnement que les shells populaires utilisent comme `.bashrc`, `.zshrc`, &c et il enregistre les résultats nulle part par défaut. De plus, la fréquence maximale étant une minute, les cronscripts peuvent s'avérer très douloureux à débugger en commencant. 

Pour gérer l'environnement, soyer sur d'utiliser des chemins absolus dans tous vos scripts et de modifier vos variables d'envronnement comme `$PATH` pour que le script puisse exécuter correctement. Pour simplifier l'enregistrement, une bonne recommendation est d'écrire votre crontab comme ceci:

```shell
* * * * *   user  /path/to/cronscripts/every_minute.sh >> /tmp/cron_every_minute.log 2>&1
```

Écrivez le script dans un fichier séparément. Rappelez-vous que `>>` annexe au fichier et que `2>&1` détourne `stderr` vers `stdout` (il est pourtant recommandé de les maintenir séparé)

## Anacron

Un désavantage d'utiliser cron est que si l'ordinateur est débranché ou dors lorsque le script cron devrait rouler, il ne sera pas exécuté. Pour les tâches fréquentes, ce problème est moins saillant, mais pour une tâche qui est exécutée moins souvent, on voudrait s'assurer de son exécution. [anacron](https://linux.die.net/man/8/anacron) fonctionne de façon similaire à `cron`, à l'exception de la fréquence, qui est spécifiée en jours. Contrairement à cron, il ne présume pas que la machine roule continuellement. Donc, on peut l'utiliser sur les machines qui ne roulent pas 24 heures par jour, pour contôler des tâches routinières comme des tâches régulières, hebdomadaires et mensuelles. 


## Exercices

1. Écrivez un script qui regarde à chaque minute dans votre fillière de téléchargements pour une photo (vous pouvez vous renseigner sur les [types MIME](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) ou utiliser une expression régulière(?) qui correspond aux extensions familières) et qui les places dans votre fillière de photos.

1. Écrivez un script cron qui vérifie de façon hebdomadaire pour des packages obsolètes dans votre système et qui vous demande de les mettre à jour ou les mets à jour automatiquement.


{% comment %}

- [fswatch](https://github.com/emcrisostomo/fswatch)
- GUI automation (pyautogui) [Automating the boring stuff Chapter 18](https://automatetheboringstuff.com/chapter18/)
- Ansible/puppet/chef

- https://xkcd.com/1205/
- https://xkcd.com/1319/

{% endcomment %}
