---
layout: page
title: Le semestre manquant de votre éducation Informatique
---

Les cours vous apprenent toutes sortes de sujets avancés en informatique, des
systèmes d'exploitation au machine learning, mais il y a un sujet critique 
qui est rarement vu, qui est laissé aux élèves à comprendre seul: être 
productif avec ses outils. Nous allons vous enseigner comment maîtriser l'invite
de commande, utiliser un éditeur de texte puissant, utiliser les fonctionalités
avancées d'un système de contrôle de version, et plus encore!

Les étudiants passent des centaines d'heures à utiliser ces outils durant 
leur éducation (et des milliers durant leur carrière), donc il est important
de rendre l'expérience fluide et sans friction le plus possible. Maîtriser ces 
outils vous laisse non seulement passer moins de temps à les faire agir comme
bon vous semble, mais aussi à résoudre des problèmes qui paraîteraient autrement
impossiblement complexes.

Lisez pourquoi [ce cours est important](/about/).

{% comment %}
# Inscription

Incrivez vous à la classe de 2020 IAP en remplissant [ce](https://forms.gle/TD1KnwCSV52qexVt9) formulaire.
{% endcomment %}

# Agenda

{% comment %}
**Cours**: 35-225, 2pm--3pm<br>
**Heures de bureau**: 32-G9 lounge, 3pm--4pm (every day, right after lecture)
{% endcomment %}

<ul>
{% assign lectures = site['2020'] | sort: 'date' %}
{% for lecture in lectures %}
    {% if lecture.phony != true %}
        <li>
        <strong>{{ lecture.date | date: '%-m/%d/%y' }}</strong>:
        {% if lecture.ready %}
            <a href="{{ lecture.url }}">{{ lecture.title }}</a>
        {% else %}
            {{ lecture.title }} {% if lecture.noclass %}[no class]{% endif %}
        {% endif %}
        </li>
    {% endif %}
{% endfor %}
</ul>

Les enregistrements vidéos son disponibles [sur
YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J).

# À propos de ce cours

**Staff**: Ce cours est enseigné par [Anish](https://www.anishathalye.com/), [Jon](https://thesquareplanet.com/), et [Jose](http://josejg.com/).<br>
**Questions**: Envoyer nous un courriel à [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

# Au-delà de MIT

Nous avons aussi partagé ce cours au-delà de MIT en espérant que d'autres
bénéficient de ces ressources. Vous pouver trouver des discussions sur

 - [Hacker News](https://news.ycombinator.com/item?id=22226380)
 - [Lobsters](https://lobste.rs/s/ti1k98/missing_semester_your_cs_education_mit)
 - [/r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/eyagda/the_missing_semester_of_your_cs_education_mit/)
 - [/r/programming](https://www.reddit.com/r/programming/comments/eyagcd/the_missing_semester_of_your_cs_education_mit/)
 - [Twitter](https://twitter.com/jonhoo/status/1224383452591509507)
 - [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J)

# Traductions

- [Chinese (Simplified)](https://missing-semester-cn.github.io/)
- [Chinese (Traditional)](https://missing-semester-zh-hant.github.io/)
- [Japanese](https://missing-semester-jp.github.io/)
- [Korean](https://missing-semester-kr.github.io/)
- [Portuguese](https://missing-semester-pt.github.io/)
- [Russian](https://missing-semester-rus.github.io/)
- [Serbian](https://netboxify.com/missing-semester/)
- [Spanish](https://missing-semester-esp.github.io/)
- [Turkish](https://missing-semester-tr.github.io/)
- [Vietnamese](https://missing-semester-vn.github.io/)
- [French](https://missing-semester-fr.github.io/) 

Note: ces liens sont vers des sites externes traduits par la communauté. Ils n'ont
pas été vérifié.

Avez-vous traduit les notes de cours de cette classe? Soummetez une 
[pull request](https://github.com/missing-semester/missing-semester/pulls) pour qu'on
puisse l'ajouter à la liste.

## Remerciements 

Nous remercions Elaine Mello, Jim Cain, et [MIT Open
Learning](https://openlearning.mit.edu/) pour nous avoir aidé à enregistrer les classes en 
vidéo; Anthony Zolnik et [MIT
AeroAstro](https://aeroastro.mit.edu/) pour l'équipement audiovisuel; et Brandi Adams et
[MIT EECS](https://www.eecs.mit.edu/) pour avoir chapeauté ce cours.

---

<div class="small center">
<p><a href="https://github.com/missing-semester/missing-semester">Code source</a>.</p>
<p>Licensé par CC BY-NC-SA.</p>
<p>Voyez <a href="/license/">ici</a> pour contribuer &amp; les instructions de traduction.</p>
</div>
