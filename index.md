---
layout: page
title: Le cours manquant de votre formation en informatique
nositetitle: true
---

Les cours vous enseignent tous les sujets avancés de la science informatique, des systèmes d'exploitation au machine learning, mais il y a un sujet essentiel qui est rarement abordé et qui est plutôt laissé aux étudiants pour qu'ils le découvrent par eux-mêmes : la maîtrise de leurs outils. Nous vous apprendrons à maîtriser la ligne de commande, à utiliser un éditeur de texte puissant, à utiliser les fonctions sophistiquées des systèmes de contrôle de version, et bien plus encore !

Les étudiants passent des centaines d'heures à utiliser ces outils au cours de leurs études (et des milliers au cours de leur carrière), il est donc logique de rendre l'expérience aussi fluide que possible. La maîtrise de ces outils vous permet non seulement de passer moins de temps à comprendre comment plier vos outils à votre volonté, mais elle vous permet également de résoudre des problèmes qui vous semblaient auparavant impossibles.

Découvrez [pourquoi nous enseignons ce cours](/about/).

{% comment %}
# Inscription

Sign up for the IAP 2020 class by filling out this [registration form](https://forms.gle/TD1KnwCSV52qexVt9).
{% endcomment %}

# Programme

{% comment %}
**Lecture**: 35-225, 2pm--3pm<br>
**Office hours**: 32-G9 lounge, 3pm--4pm (every day, right after lecture)
{% endcomment %}

<ul>
{% assign lectures = site['2020'] | sort: 'date' %}
{% for lecture in lectures %}
    {% if lecture.phony != true %}
        <li>
        <strong>{{ lecture.date | date: '%d/%m/%y' }}</strong>:
        {% if lecture.ready %}
            <a href="{{ lecture.url }}">{{ lecture.title }}</a>
        {% else %}
            {{ lecture.title }} {% if lecture.noclass %}[no class]{% endif %}
        {% endif %}
        </li>
    {% endif %}
{% endfor %}
</ul>

Les enregistrements vidéo des cours sont disponibles [sur
YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J).

# A propos du cours

**Staff**: Ce cours est co-enseigné par [Anish](https://www.anishathalye.com/), [Jon](https://thesquareplanet.com/), et [Jose](http://josejg.com/).<br>
**Vous avez des questions ?** Envoyez-nous un mail à [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

# Au-delà du MIT

Nous avons également partagé ce cours au-delà du MIT dans l'espoir que d'autres personnes puissent bénéficier de ces ressources. Vous pouvez trouver des articles et des discussions sur

 - [Hacker News](https://news.ycombinator.com/item?id=22226380)
 - [Lobsters](https://lobste.rs/s/ti1k98/missing_semester_your_cs_education_mit)
 - [/r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/eyagda/the_missing_semester_of_your_cs_education_mit/)
 - [/r/programming](https://www.reddit.com/r/programming/comments/eyagcd/the_missing_semester_of_your_cs_education_mit/)
 - [Twitter](https://twitter.com/jonhoo/status/1224383452591509507)
 - [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J)

{% comment %}
Some more URLs:

- https://news.ycombinator.com/item?id=27154577
- https://news.ycombinator.com/item?id=34934216
- https://www.reddit.com/r/learnprogramming/comments/nca1v3/mit_the_missing_semester_of_your_cs_education/
- https://www.reddit.com/r/compsci/comments/eyywv8/the_missing_semester_of_your_cs_education_from_mit/
- https://www.reddit.com/r/programming/comments/io7nq3/the_missing_semester_of_your_cs_education_mit/
- https://twitter.com/MIT_CSAIL/status/1349766980413263873
- https://twitter.com/MIT_CSAIL/status/1481676163491659780
- https://twitter.com/MIT_CSAIL/status/1581313961093484545
{% endcomment %}

# Traductions

- [Chinois (Simplifié)](https://missing-semester-cn.github.io/)
- [Chinois (Traditionel)](https://missing-semester-zh-hant.github.io/)
- [Japonais](https://missing-semester-jp.github.io/)
- [Coréen](https://missing-semester-kr.github.io/)
- [Portugais](https://missing-semester-pt.github.io/)
- [Russe](https://missing-semester-rus.github.io/)
- [Serbe](https://netboxify.com/missing-semester/)
- [Espagnol](https://missing-semester-esp.github.io/)
- [Turc](https://missing-semester-tr.github.io/)
- [Vietnamien](https://missing-semester-vn.github.io/)
- [Arabe](https://missing-semester-ar.github.io/)
- [Italien](https://missing-semester-it.github.io/)
- [Persan](https://missing-semester-fa.github.io/)

Remarque : il s'agit de liens externes vers des traductions communautaires. Nous ne les avons pas vérifiées.

Avez-vous créé une traduction des notes de cours de cette classe ? Soumettez une [pull request](https://github.com/missing-semester/missing-semester/pulls) pour que nous puissions l'ajouter à la liste !

## Remerciements

Nous remercions Elaine Mello, Jim Cain et [MIT Open
Learning](https://openlearning.mit.edu/) pour nous avoir permis d'enregistrer des vidéos des cours, Anthony Zolnik et [MIT
AeroAstro](https://aeroastro.mit.edu/) pour l'équipement audiovisuel, et Brandi Adams et [MIT EECS](https://www.eecs.mit.edu/) pour leur soutien à ce cours.

---

<div class="small center">
<p><a href="https://github.com/missing-semester/missing-semester">Code source</a>.</p>
<p>Sous licence CC BY-NC-SA.</p>
<p>Voir <a href="/license/">ici</a> pour les directives de contribution &amp; de traduction.</p>
</div>