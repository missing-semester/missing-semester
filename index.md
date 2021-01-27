---
layout: page
title: The Missing Semester of Your CS Education (日本語版)
---

大学の講義ではオペレーティングシステムから機械学習まで、
コンピュータサイエンスの様々な発展的トピックを学びます。
しかし、重要であるにも関わらず講義で教わることはめったになく、
したがって自分で学ばなければならないことがあります。
それは「コンピュータを操作するツールを習熟すること」です。
本講義では、コマンドライン操作をマスターすること、パワフルなテキストエディタを使いこなすこと、
バージョンコントロールの様々な機能に触れること、などなどを教えます！

学生は大学生活を過ごすうえでそういったツールを使うことに何百時間も費やします
（その後のキャリア全体を考えれば何千時間も使うと言えるでしょう）。
よって、ツールを使う経験を可能な限り流暢で淀みない状態にしておくということは、
非常に有意義であると言えます。
ツールの使い方をマスターすることにより、あなたは望みたい結果を得るために
どのようにツールを用いればいいか即座にわかるようになります。
それだけでなく、以前は解くことができないほど複雑に見えた問題も、
ツールをマスターすることで解くことが出来るようになるでしょう。

[この講義を始めたモチベーション](/about/)も参考にしてください。

{% comment %}
# Registration

Sign up for the IAP 2020 class by filling out this [registration form](https://forms.gle/TD1KnwCSV52qexVt9).
{% endcomment %}

# スケジュール

{% comment %}
**Lecture**: 35-225, 2pm--3pm<br>
**Office hours**: 32-G9 lounge, 3pm--4pm (every day, right after lecture)
{% endcomment %}

<ul>
{% assign lectures = site['2020'] | sort: 'date' %}
{% for lecture in lectures %}
    {% if lecture.phony != true %}
        <li>
        <strong>{{ lecture.date | date: '%y/%-m/%d' }}</strong>:
        {% if lecture.ready %}
            <a href="{{ lecture.url }}">{{ lecture.title }}</a>
        {% else %}
            {{ lecture.title }} {% if lecture.noclass %}[no class]{% endif %}
        {% endif %}
        </li>
    {% endif %}
{% endfor %}
</ul>

[YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J)にて録画した講義ビデオを視聴できます。


# この講義について

**スタッフ**: [Anish](https://www.anishathalye.com/), [Jon](https://thesquareplanet.com/), [Jose](http://josejg.com/) が講義を行います。
**質問**: 以下にメールしてください [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

（訳注：翻訳に関する内容については[こちら](https://github.com/missing-semester-jp/missing-semester-jp.github.io)にて報告してください）



# MITを超えて

MIT以外の人々にとってもこの講義が役立つことを願い、私たちはこの講義内容をMIT外の人々とも共有してきました。ブログポストや議論の情報は以下になります。

 - [Hacker News](https://news.ycombinator.com/item?id=22226380)
 - [Lobsters](https://lobste.rs/s/ti1k98/missing_semester_your_cs_education_mit)
 - [/r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/eyagda/the_missing_semester_of_your_cs_education_mit/)
 - [/r/programming](https://www.reddit.com/r/programming/comments/eyagcd/the_missing_semester_of_your_cs_education_mit/)
 - [Twitter](https://twitter.com/jonhoo/status/1224383452591509507)
 - [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J)

# 翻訳

- [Chinese (Simplified)](https://missing-semester-cn.github.io/)
- [Chinese (Traditional)](https://missing-semester-zh-hant.github.io/)
- [Korean](https://missing-semester-kr.github.io/)
- [Portuguese](https://missing-semester-pt.github.io/)
- [Russian](https://missing-semester-rus.github.io/)
- [Serbian](https://netboxify.com/missing-semester/)
- [Spanish](https://missing-semester-esp.github.io/)
- [Turkish](https://missing-semester-tr.github.io/)
- [Vietnamese](https://missing-semester-vn.github.io/)

注意：これらは外部の有志の方々による翻訳です。内容について吟味したわけではありません。

この講義を翻訳しましたか？[pull request](https://github.com/missing-semester/missing-semester/pulls)にて報告してください。上記のリストに加えます！


## 謝辞

Elaine Mello, Jim Cain, [MIT Open
Learning](https://openlearning.mit.edu/) に対し講義ビデオ録画を可能としていただいたことを、
Anthony Zolnik と [MIT
AeroAstro](https://aeroastro.mit.edu/) にはA/V機器を設定頂いたことを、Brandi Adams と
[MIT EECS](https://www.eecs.mit.edu/) には本講義を支援していただたことを、それぞれ感謝申し上げます。


---

<div class="small center">
<p><a href="https://github.com/missing-semester/missing-semester">Source code (original)</a>, <a href="https://github.com/missing-semester-jp/missing-semester-jp.github.io">Source code (jp)</a>.</p>
<p>Licensed under CC BY-NC-SA.</p>
<p>See <a href="/license/">here</a> for contribution &amp; translation guidelines.</p>
</div>
