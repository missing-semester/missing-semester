---
layout: page
title: Penawaran Sebelumnya
description: >
  Temukan semua penawaran sebelumnya dari Missing Semester.
---

{% comment %} pop to remove default "posts" collection {% endcomment %}
{% assign sorted_collections = site.collections | sort: 'label' | pop | reverse %}
<ul>
{% for collection in sorted_collections %}
    <li><a href="/{{ collection.label }}/">{{ collection.label }}</a></li>
{% endfor %}
</ul>

Kuliah setiap tahun sepenuhnya mandiri. Kami merekomendasikan untuk memulai dengan versi materi terbaru. Ada variasi dalam topik yang dibahas dari tahun ke tahun, jadi kami terus menyediakan catatan dan video untuk versi kursus sebelumnya.
