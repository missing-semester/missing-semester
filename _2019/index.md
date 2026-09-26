---
layout: page
title: "2019 Lectures"
description: >
  Missing Semester, MIT IAP 2019 ၏ သင်ခန်းစာ မှတ်တမ်းများနှင့် ဗီဒီယိုများ။
permalink: /2019/
phony: true
---

{% assign lecture_date = site['2019'] | group_by: 'date' | sort: 'name' %}
{% for date in lecture_date %}
  {% if date.name == "" %}{% continue %}{% endif %}
  <h2>{{ date.name | date: '%A, %-m/%-d' }}</h2>
  {% assign lectures = date.items | sort: 'order' %}
  <ul>
  {% for lecture in lectures %}
    {% if lecture.phony != true %}
      <li>
        <a href="{{ lecture.url }}">{{ lecture.title }}</a>
      </li>
    {% endif %}
  {% endfor %}
  </ul>
{% endfor %}

# Beyond MIT

အခြားသူများလည်း ဤ အရင်းအမြစ်များမှ အကျိုးကျေးဇူး ရရှိနိုင်စေရန် ဤအတန်းကို MIT ၏ အပြင်ဘက်သို့လည်း မျှဝေထားပါသည်။ အောက်ပါ နေရာများတွင် ဆွေးနွေးချက်များကို ရှာဖွေနိုင်ပါသည် -

- [Hacker News](https://news.ycombinator.com/item?id=19078281)
- [Lobsters](https://lobste.rs/s/h6157x/mit_hacker_tools_lecture_series_on)
- [r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/an42uu/mit_hacker_tools_a_lecture_series_on_programmer/)
- [r/programming](https://www.reddit.com/r/programming/comments/an3xki/mit_hacker_tools_a_lecture_series_on_programmer/)
- [Twitter](https://twitter.com/Jonhoo/status/1091896192332693504)
- [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuiujH1lpn8cA9dsyulbYRv)

# Acknowledgments

ဤအတန်းကို [SIPB IAP 2019](https://sipb.mit.edu/iap/2019/) ၏ အစိတ်အပိုင်းအဖြစ် သင်ကြားခဲ့ပြီး [SIPB](https://sipb.mit.edu/) နှင့် [MIT EECS](https://www.eecs.mit.edu/) တို့မှ ပူးတွဲ ပံ့ပိုးပေးခဲ့ပါသည်။
