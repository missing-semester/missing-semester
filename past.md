---
layout: page
title: Past Offerings
description: >
  Find all past offerings of Missing Semester.
---

{% comment %} pop to remove default "posts" collection {% endcomment %}
{% assign sorted_collections = site.collections | sort: 'label' | pop | reverse %}
<ul>
{% for collection in sorted_collections %}
    <li><a href="/{{ collection.label }}/">{{ collection.label }}</a></li>
{% endfor %}
</ul>

Each year's lectures are fully self-contained. We recommend starting with the most recent version of the material. There is variation in the topics covered year to year, so we continue to host notes and videos for earlier versions of this course.
