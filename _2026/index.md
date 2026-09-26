---
layout: page
title: "2026 Lectures"
description: >
  Missing Semester, MIT IAP 2026 ၏ သင်ခန်းစာ မှတ်တမ်းများနှင့် ဗီဒီယိုများ။
permalink: /2026/
phony: true
---

<ul class="double-spaced">
  {% assign lectures = site['2026'] | sort: 'date' %}
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

သင်ခန်းစာ ဗီဒီယို မှတ်တမ်းများကို [YouTube တွင်](https://www.youtube.com/playlist?list=PLyzOVJj3bHQunmnnTXrNbZnBaCA-ieK4L) ကြည့်ရှုနိုင်ပါသည်။

# Beyond MIT

အခြားသူများလည်း ဤ အရင်းအမြစ်များမှ အကျိုးကျေးဇူး ရရှိနိုင်စေရန် ဤအတန်းကို MIT ၏ အပြင်ဘက်သို့လည်း မျှဝေထားပါသည်။ အောက်ပါ နေရာများတွင် ဆွေးနွေးချက်များကို ရှာဖွေနိုင်ပါသည် -

- [Hacker News](https://news.ycombinator.com/item?id=47124171)
- [Lobsters](https://lobste.rs/s/q4ykw7/missing_semester_your_cs_education_2026)
- [r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/1r93yk6/the_missing_semester_of_your_cs_education_2026/)
- [X](https://x.com/anishathalye/status/2024521145777848588)
- [Bluesky](https://bsky.app/profile/jonhoo.eu/post/3mfa2bhyuj22i)
- [Mastodon](https://fosstodon.org/@jonhoo/116098318361854057)
- [LinkedIn](https://www.linkedin.com/posts/anishathalye_i-returned-to-mit-during-iap-january-term-activity-7430285026933522433-Ehr9)
- [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQunmnnTXrNbZnBaCA-ieK4L)

# Acknowledgments

သင်ခန်းစာ ဗီဒီယိုများ ရိုက်ကူးနိုင်ရန် ကူညီပေးခဲ့ကြသော Elaine Mello နှင့် [MIT Open Learning](https://openlearning.mit.edu/) တို့အား ကျေးဇူးတင်ရှိပါသည်။ ဤအတန်းကို [SIPB IAP 2026](https://sipb.mit.edu/iap/) ၏ အစိတ်အပိုင်းအဖြစ် ပံ့ပိုးပေးခဲ့သော Luis Turino / [SIPB](https://sipb.mit.edu/) အား ကျေးဇူးတင်ရှိပါသည်။
