---
layout: page
title: "2020 Lectures"
description: >
  Missing Semester, MIT IAP 2020 ၏ သင်ခန်းစာ မှတ်တမ်းများနှင့် ဗီဒီယိုများ။
permalink: /2020/
phony: true
---

<ul class="double-spaced">
  {% assign lectures = site['2020'] | sort: 'date' %}
  {% for lecture in lectures %}
    {% if lecture.phony != true %}
      <li>
        <strong>{{ lecture.date | date: '%-m/%-d' }}</strong>:
        {% if lecture.ready %}
          <a href="{{ lecture.url }}">{{ lecture.title }}</a>
        {% elsif lecture.noclass %}
          {{ lecture.title }} [no class]
        {% else %}
          {{ lecture.title }} [coming soon]
        {% endif %}
        {% if lecture.details %}
          <br>
          ({{ lecture.details }})
        {% endif %}
      </li>
    {% endif %}
  {% endfor %}
</ul>

သင်ခန်းစာ ဗီဒီယို မှတ်တမ်းများကို [YouTube တွင်](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J) ကြည့်ရှုနိုင်ပါသည်။

# Beyond MIT

အခြားသူများလည်း ဤ အရင်းအမြစ်များမှ အကျိုးကျေးဇူး ရရှိနိုင်စေရန် ဤအတန်းကို MIT ၏ အပြင်ဘက်သို့လည်း မျှဝေထားပါသည်။ အောက်ပါ နေရာများတွင် ဆွေးနွေးချက်များကို ရှာဖွေနိုင်ပါသည် -

 - [Hacker News](https://news.ycombinator.com/item?id=22226380)
 - [Lobsters](https://lobste.rs/s/ti1k98/missing_semester_your_cs_education_mit)
 - [r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/eyagda/the_missing_semester_of_your_cs_education_mit/)
 - [r/programming](https://www.reddit.com/r/programming/comments/eyagcd/the_missing_semester_of_your_cs_education_mit/)
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

# Acknowledgments

သင်ခန်းစာ ဗီဒီယိုများ ရိုက်ကူးနိုင်ရန် ကူညီပေးခဲ့ကြသော Elaine Mello, Jim Cain နှင့် [MIT Open Learning](https://openlearning.mit.edu/)၊ A/V စက်ပစ္စည်းများ ကူညီပေးသော Anthony Zolnik နှင့် [MIT AeroAstro](https://aeroastro.mit.edu/)၊ ဤအတန်းကို ပံ့ပိုးပေးသော Brandi Adams နှင့် [MIT EECS](https://www.eecs.mit.edu/) တို့အား ကျေးဇူးတင်ရှိပါသည်။
