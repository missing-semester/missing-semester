---
layout: page
title: "2026 ಉಪನ್ಯಾಸಗಳು"
description: >
  Missing Semester, MIT IAP 2026 ಗಾಗಿ ಉಪನ್ಯಾಸ ಟಿಪ್ಪಣಿಗಳು ಮತ್ತು ವೀಡಿಯೊಗಳು.
permalink: /2026/
phony: true
---

<ul class="double-spaced">
  {% assign lectures = site['2026'] | sort: 'date' %}
  {% for lecture in lectures %}
    {% if lecture.phony != true %}
      <li>
        <strong>{{ lecture.date | date: '%-m/%d' }}</strong>:
        {% if lecture.ready %}
          <a href="{{ lecture.url }}">{{ lecture.title }}</a>
        {% elsif lecture.noclass %}
          {{ lecture.title }} [ತರಗತಿ ಇಲ್ಲ]
        {% else %}
          {{ lecture.title }} [ಶೀಘ್ರದಲ್ಲೇ]
        {% endif %}
        {% if lecture.details %}
          <br>
          ({{ lecture.details }})
        {% endif %}
      </li>
    {% endif %}
  {% endfor %}
</ul>
