---
layout: page
title: "Past Offerings"
description: >
  Missing Semester ၏ ယခင် သင်ခန်းစာများ အားလုံးကို ရှာဖွေပါ။
---

{% comment %} pop to remove default "posts" collection {% endcomment %}
{% assign sorted_collections = site.collections | sort: 'label' | pop | reverse %}
<ul>
{% for collection in sorted_collections %}
    <li><a href="/{{ collection.label }}/">{{ collection.label }}</a></li>
{% endfor %}
</ul>

နှစ်စဉ် သင်ခန်းစာများသည် သီးခြားစီ လေ့လာနိုင်သော ခေါင်းစဉ်များ ဖြစ်ကြပါသည်။ အသစ်ဆုံး မူကွဲမှ စတင်ရန် အကြံပြုပါသည်။ နှစ်အလိုက် သင်ခန်းစာ ခေါင်းစဉ်များ ကွဲပြားနိုင်သဖြင့် ယခင် မူကွဲများ၏ မှတ်တမ်းများနှင့် ဗီဒီယိုများကို ဆက်လက် လွှင့်တင်ထားပါသည်။
