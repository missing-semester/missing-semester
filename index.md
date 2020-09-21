---
layout: page
title: Le Semestre Manquant de votre Formation en Informatique
---

Les cours peuvent porter sur énormément d'aspects avancés de l'informatique, que
ce soit sur les systèmes d'exploitation ou sur l'apprentissage automatique (dit
_machine learning_). Mais il existe un sujet rarement traité en cours, et dont
les étudiants ont la charge de découvrir par eux-mêmes : la maîtrise de leurs
outils. Dans ce cours, nous allons vous apprendre à maîtriser la ligne de
commande, à utiliser un puissant éditeur de texte, à se servir de
fonctionnalités avancées des systèmes de gestion de versions, et pleins d'autres
choses encore !

Les étudiants passent des centaines d'heures à utiliser ces outils tout au long
de leurs formations (et parfois des milliers d'heures durant leurs carrières).
Il est donc pertinent de rendre cette activité aussi fluide et efficace
possible. La maîtrise de ses outils permet non seulement de ne pas avoir à
passer inutilement des heures à les configurer pour une tâche spécifique, mais
aussi et surtout de pouvoir résoudre des problèmes qui semblaient au préalable
impossible à résoudre.

Plus quant à la [raison d'être de ce cours](/about/).

{% comment %}

# Registration

Sign up for the IAP 2020 class by filling out this [registration form](https://forms.gle/TD1KnwCSV52qexVt9).
{% endcomment %}

# Planification

{% comment %}
**Lecture**: 35-225, 2pm--3pm<br>
**Office hours**: 32-G9 lounge, 3pm--4pm (every day, right after lecture)
{% endcomment %}

<ul>
{% assign lectures = site['2020'] | sort: 'date' %}
{% for lecture in lectures %}
    {% if lecture.phony != true %}
        <li>
        <strong>{{ lecture.date | date: '%-m/%d' }}</strong>:
        {% if lecture.ready %}
            <a href="{{ lecture.url }}">{{ lecture.title }}</a>
        {% else %}
            {{ lecture.title }} {% if lecture.noclass %}[no class]{% endif %}
        {% endif %}
        </li>
    {% endif %}
{% endfor %}
</ul>

Des enregistrements vidéo de ces cours sont disponibles
[sur YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J).

# À propos de ce cours

**Enseignants**: Ce cours est enseigné conjointement par [Anish](https://www.anishathalye.com/), [Jon](https://thesquareplanet.com/), et [Jose](http://josejg.com/).
**Questions**: À envoyer par email à [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

# Au delà du MIT

Nous avons aussi partagé ce cours en dehors du MIT avec pour espoir que d'autres
personnes puissent bénéficier de ces ressources. Vous pourrez trouver des
messages et discussions sur

-   [Hacker News](https://news.ycombinator.com/item?id=22226380)
-   [Lobsters](https://lobste.rs/s/ti1k98/missing_semester_your_cs_education_mit)
-   [/r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/eyagda/the_missing_semester_of_your_cs_education_mit/)
-   [/r/programming](https://www.reddit.com/r/programming/comments/eyagcd/the_missing_semester_of_your_cs_education_mit/)
-   [Twitter](https://twitter.com/jonhoo/status/1224383452591509507)
-   [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J)

# Traductions

-   [Version originale (en Anglais)](https://missing.csail.mit.edu/)
-   [Chinese (Simplified)](https://missing-semester-cn.github.io/)
-   [Chinese (Traditional)](https://missing-semester-zh-hant.github.io/)
-   [Korean](https://missing-semester-kr.github.io/)
-   [Serbian](https://netboxify.com/missing-semester/)
-   [Spanish](https://missing-semester-esp.github.io/)
-   [Turkish](https://missing-semester-tr.github.io/)
-   [Vietnamese](https://missing-semester-vn.github.io/)

Remarque : Ces liens externes résultent du travail de traduction de la
communauté. Aucun travail de vérification n'a été effectué.

Avez-vous créé une traduction de ces notes de cours ? Envoyez une
[pull request](https://github.com/missing-semester/missing-semester/pulls) pour
que nous puissions l'ajouter à la liste !

## Remerciements

Nous remercions Elaine Mello, Jim Cain, et [MIT Open
Learning](https://openlearning.mit.edu/) pour avoir rendu possible
l'enregistrement de ces cours ; Anthony Zolnik et [MIT
AeroAstro](https://aeroastro.mit.edu/) pour l'équipement audiovisuel ; et Brandi
Adams et [MIT EECS](https://www.eecs.mit.edu/) pour soutenir ce cours.

---

<div class="small center">
<p><a href="https://github.com/missing-semester/missing-semester">Source code</a>.</p>
<p>Licence CC BY-NC-SA.</p>
<p>Voir <a href="/license/">ici</a> pour des instructions sur les contributions et les traductions.</p>
</div>
