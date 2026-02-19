---
layout: page
title: The Missing Semester of Your CS Education
description: >
  Master powerful tools that will make you a more productive computer scientist and programmer.
subtitle: IAP 2026
nositetitle: true
---

Classes teach you all about advanced topics within CS, from operating systems
to machine learning, but there's one critical subject that's rarely covered,
and is instead left to students to figure out on their own: proficiency with
their tools. We'll teach you how to master the command-line, use a powerful
text editor, use fancy features of version control systems, and much more!

Students spend hundreds of hours using these tools over the course of their
education (and thousands over their career), so it makes sense to make the
experience as fluid and frictionless as possible. Mastering these tools not
only enables you to spend less time on figuring out how to bend your tools to
your will, but it also lets you solve problems that would previously seem
impossibly complex.

These days, many aspects of software engineering are also in flux
through the introduction of AI-enabled and AI-enhanced tools and
workflows. When used appropriately and with awareness of their
shortcomings, these can often provide significant benefits to
CS practitioners and are thus worth developing working knowledge of.
Since AI is a cross-functional enabling technology, there is not a
standalone AI lecture; we've instead folded the use of the latest
applicable AI tools and techniques into each lecture directly.

Read about the [motivation behind this class](/about/).

{% comment %}
# Registration

Sign up for the IAP 2026 class by filling out this [registration form](https://forms.gle/j2wMzi7qeiZmzEWy9).
{% endcomment %}

# Schedule

{% comment %}
**Lecture**: [35-225](https://whereis.mit.edu/?go=35), 1:30--2:30pm (_exception_: 3--4pm on Friday 1/16)<br>
**Discussion**: [OSSU Discord](https://ossu.dev/#community) (use `#missing-semester-forum` like you would use Piazza, and `#missing-semester` to chat with the class/instructors)
{% endcomment %}

<ul>
{% assign lectures = site['2026'] | sort: 'date' %}
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

{% comment %}
Lecture videos will be made available to MIT students immediately after lecture (via Panopto). The system has a limitation that only those with an MIT Kerberos can access the raw lecture videos. We are working on editing lecture videos and uploading them to YouTube. A couple have been uploaded already; we expect the rest to be uploaded by mid-February.

If you can't wait until January 2026, you can also take a look at the lectures
from the [previous offering of the course](/2020/), which covers many of the
same topics.
{% endcomment %}

You can view lecture videos on [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQunmnnTXrNbZnBaCA-ieK4L).

You can discuss the course in the [OSSU Discord](https://ossu.dev/#community) (use `#missing-semester-forum` like you would use Piazza, and `#missing-semester` to chat with the class/instructors).

# About the class

**Staff**: This class is co-taught by [Anish](https://anish.io/), [Jon](https://thesquareplanet.com/), and [Jose](https://josejg.com/).<br>
**Questions**: Email us at [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

# Beyond MIT

We've also shared this class beyond MIT in the hopes that others may
benefit from these resources. You can find posts and discussion on

 - Hacker News ([2026](https://news.ycombinator.com/item?id=47075545), [2020](https://news.ycombinator.com/item?id=22226380), [2019](https://news.ycombinator.com/item?id=19078281))
 - Lobsters ([2026](https://lobste.rs/s/q4ykw7/missing_semester_your_cs_education_2026), [2020](https://lobste.rs/s/ti1k98/missing_semester_your_cs_education_mit), [2019](https://lobste.rs/s/h6157x/mit_hacker_tools_lecture_series_on))
 - r/learnprogramming ([2026](https://www.reddit.com/r/learnprogramming/comments/1r93yk6/the_missing_semester_of_your_cs_education_2026/), [2020](https://www.reddit.com/r/learnprogramming/comments/eyagda/the_missing_semester_of_your_cs_education_mit/), [2019](https://www.reddit.com/r/learnprogramming/comments/an42uu/mit_hacker_tools_a_lecture_series_on_programmer/))
 - r/programming ([2026](https://www.reddit.com/r/programming/comments/1r94t1m/the_missing_semester_of_your_cs_education_2026/?share_id=g-7XXjF7fLWwJMDaF89CK), [2020](https://www.reddit.com/r/programming/comments/eyagcd/the_missing_semester_of_your_cs_education_mit/), [2019](https://www.reddit.com/r/programming/comments/an3xki/mit_hacker_tools_a_lecture_series_on_programmer/))
 - X ([2026](https://x.com/anishathalye/status/2024521145777848588), [2020](https://twitter.com/jonhoo/status/1224383452591509507), [2019](https://x.com/jonhoo/status/1090323977766137858))
 - Bluesky ([2026](https://bsky.app/profile/jonhoo.eu/post/3mfa2bhyuj22i))
 - Mastodon ([2026](https://fosstodon.org/@jonhoo/116098318361854057))
 - LinkedIn ([2026](https://www.linkedin.com/posts/anishathalye_i-returned-to-mit-during-iap-january-term-activity-7430285026933522433-Ehr9))
 - YouTube ([2026](https://www.youtube.com/playlist?list=PLyzOVJj3bHQunmnnTXrNbZnBaCA-ieK4L), [2020](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J), [2019](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuiujH1lpn8cA9dsyulbYRv))

# Translations

- [Chinese (Simplified)](https://missing-semester-cn.github.io/)
- [Japanese](https://missing-semester-jp.github.io/)
- [Korean](https://missing-semester-kr.github.io/)
- [Portuguese](https://missing-semester-pt.github.io/)
- [Russian](https://missing-semester-rus.github.io/)
- [Serbian](https://netboxify.com/missing-semester/)
- [Spanish](https://missing-semester-esp.github.io/)
- [Turkish](https://missing-semester-tr.github.io/)
- [Vietnamese](https://missing-semester-vn.github.io/)
- [Arabic](https://missing-semester-ar.github.io/)
- [Italian](https://missing-semester-it.github.io/)
- [Persian](https://missing-semester-fa.github.io/)
- [German](https://missing-semester-de.github.io/)
- [Bengali](https://missing-semester-bn.github.io/)

Note: these are external links to community translations. We have not vetted
them.

Have you created a translation of the course notes from this class? Submit a
[pull request](https://github.com/missing-semester/missing-semester/pulls) so
we can add it to the list!

## Acknowledgments

{% comment %}
2026 acks; previous years' acks are on their respective pages
{% endcomment %}

We thank Elaine Mello and [MIT Open Learning](https://openlearning.mit.edu/) for making it possible for us to record lecture videos. We thank Luis Turino / [SIPB](https://sipb.mit.edu/) for supporting this class as part of [SIPB IAP 2026](https://sipb.mit.edu/iap/).

---

<div class="small center">
<p><a href="https://github.com/missing-semester/missing-semester">Source code</a>.</p>
<p>Licensed under CC BY-NC-SA.</p>
<p>See <a href="/license/">here</a> for contribution &amp; translation guidelines.</p>
</div>
