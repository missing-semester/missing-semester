---
layout: page
title: Пропущенный семестр курса по компьютерным наукам (Computer Science)
---

Другие курсы затрагивают продвинутые темы в рамках компьютерных наук (CS): от операционных систем до машинного обучения. Но есть один
важный вопрос, который редко освещается – изучение необходимых утилит. Его обычно оставляют студентам для
самостоятельного изучения. Но на этом курсе вы научитесь работать с командной строкой, использовать мощный текстовый редактор,
необычные функции систем контроля версий и многое другое!
Студенты тратят сотни часов на работу с утилитами в процессе обучения (и тысячи часов в течение всей карьеры), поэтому
имеет смысл сделать курс максимально плавным и комфортным. Его освоение позволит не только тратить меньше времени на настройку в
соответствии с вашими потребностями и задачами, но также даст возможность решать проблемы, которые до этого казались невероятно
сложными.
[О причинах создания, целях и назначении этого курса](/about/).

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

Плейлист с лекциями доступен 
[на YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J).

# О курсе

**Преподаватели**: [Anish](https://www.anishathalye.com/), [Jon](https://thesquareplanet.com/) и [Jose](http://josejg.com/).

# Кроме MIT

В надежде, что эти материалы будут полезны не только студентам MIT, авторы поделились курсом на следующих площадках:

 - [Hacker News](https://news.ycombinator.com/item?id=22226380)
 - [Lobsters](https://lobste.rs/s/ti1k98/missing_semester_your_cs_education_mit)
 - [/r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/eyagda/the_missing_semester_of_your_cs_education_mit/)
 - [/r/programming](https://www.reddit.com/r/programming/comments/eyagcd/the_missing_semester_of_your_cs_education_mit/)
 - [Twitter](https://twitter.com/jonhoo/status/1224383452591509507)
 - [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J)

# Переводы курса 

- [Chinese (Simplified)](https://missing-semester-cn.github.io/)
- [Chinese (Traditional)](https://missing-semester-zh-hant.github.io/)
- [Korean](https://missing-semester-kr.github.io/)
- [Portuguese](https://missing-semester-pt.github.io/)
- [Serbian](https://netboxify.com/missing-semester/)
- [Spanish](https://missing-semester-esp.github.io/)
- [Turkish](https://missing-semester-tr.github.io/)
- [Vietnamese](https://missing-semester-vn.github.io/)

*Примечание: это неавторизованные переводы.

Можете предлагать переводы других материалов курса на русский, а также исправления и корректировки существующих переводов, [гитхаб](https://github.com/missing-semester-ru/missing-semester-ru.github.io/pulls). Спасибо за помощь!

## Благодарности

Авторы выражают благодарность Elaine Mello, Jim Cain и 
[MIT Open Learning](https://openlearning.mit.edu/) за предоставленную возможность записывать видео с лекциями; 
Anthony Zolnik и [MIT AeroAstro](https://aeroastro.mit.edu/) за аудио- и видео оборудование; 
и Brandi Adams и [MIT EECS](https://www.eecs.mit.edu/).

---

<div class="small center">
<p><a href="https://github.com/missing-semester-ru/missing-semester-ru.github.io">Курс на русском</a>.</p>
<p>Лицензия CC BY-NC-SA.</p>
<p>Ознакомиться <a href="/license/">по ссылке</a>.</p>
</div>