---
layout: page
title: "2019 Lectures"
description: >
  Lecture notes and videos for Missing Semester, MIT IAP 2019.
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

We've also shared this class beyond MIT in the hopes that others may benefit from these resources. You can find posts and discussion on

- [Hacker News](https://news.ycombinator.com/item?id=19078281)
- [Lobsters](https://lobste.rs/s/h6157x/mit_hacker_tools_lecture_series_on)
- [r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/an42uu/mit_hacker_tools_a_lecture_series_on_programmer/)
- [r/programming](https://www.reddit.com/r/programming/comments/an3xki/mit_hacker_tools_a_lecture_series_on_programmer/)
- [Twitter](https://twitter.com/Jonhoo/status/1091896192332693504)
- [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuiujH1lpn8cA9dsyulbYRv)

# Acknowledgments

This class was taught as part of [SIPB IAP 2019](https://sipb.mit.edu/iap/2019/) and co-sponsored by [SIPB](https://sipb.mit.edu/) and [MIT EECS](https://www.eecs.mit.edu/).
