---
layout: page
title: Hiç almadığınız Bilgisayar Bilimleri Döneminiz
---

Dersler, işletim sistemlerinden makine öğrenmesine kadar bilgisyar bilimlerideki ileri düzey konular hakkında her şeyi size öğretir, ancak nadiren ele alınan ve daha çok öğrencilere kendi başlarına anlamaları için bırakılan kritik bir konu vardır ki bu konu: **elimizdeki araçlara hakimiyettir**. Biz size komut satırında nasıl ustalaşacağınızı, güçlü bir metin düzenleyiciyi nasıl kullanacağınızı, versiyon kontrol sistemlerinin süslü özelliklerini nasıl kullanacağınızı ve çok daha fazlasını öğreteceğiz!

Öğrenciler eğitim hayatları boyunca bu araçları kullanarak yüzlerce saat geçirirler(ve kariyerleri boyunca da binlerce saat)Bu nedenle bu deneyimi olabildiğine akıcı ve partik hale getirmek son derece mantıklıdır. Bu araçlara hakim olmak, elinizdeki aletleri doğru yerde ve doğru şekilde nasıl kullanacağınızı anlamak için tek başınıza sarf edeceğiniz süreyi kısaltmak ile kalmaz, aynı zamanda daha önce imkansız derecede karmaşık görünen sorunları çözmenize de olanak tanır.

Bu sınıfın arkasındakı [motivasyonu oku](/about/).

{% comment %}
# Registration

Sign up for the IAP 2020 class by filling out this [registration form](https://forms.gle/TD1KnwCSV52qexVt9).
{% endcomment %}

# Ders Programı

{% comment %}
**Lecture**: 35-225, 2pm--3pm<br>
**Office hours**: 32-G9 lounge, 3pm--4pm (every day, right after lecture)
{% endcomment %}

<ul>
{% assign lectures = site['2020'] | sort: 'date' %}
{% for lecture in lectures %}
    {% if lecture.phony != true %}
        <li>
        <strong>{{ lecture.date | date: '%-m/%d' }}</strong>:
        {% if lecture.ready %}
            <a href="{{ lecture.url }}">{{ lecture.title }}</a>
        {% else %}
            {{ lecture.title }} {% if lecture.noclass %}[no class]{% endif %}
        {% endif %}
        </li>
    {% endif %}
{% endfor %}
</ul>

Derslerin video kayıtları [Youtube'da](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J) mevcut.

# Sınıf Hakkında

**Staff**:  Dersler [Anish](https://www.anishathalye.com/), [Jon](https://thesquareplanet.com/), ve [Jose](http://josejg.com/) tarafından verildi.  
**Questions**: Bize e-posta gönderin [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

# Beyond MIT

Ayrıca başkalarının da bu kaynaklardan yararlanması ümidiyle bu dersleri MIT dışına da paylaştık. İlgili yayınları ve tartışmaları aşağıdan bulabilirsiniz.

 - [Hacker News](https://news.ycombinator.com/item?id=22226380)
 - [Lobsters](https://lobste.rs/s/ti1k98/missing_semester_your_cs_education_mit)
 - [/r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/eyagda/the_missing_semester_of_your_cs_education_mit/)
 - [/r/programming](https://www.reddit.com/r/programming/comments/eyagcd/the_missing_semester_of_your_cs_education_mit/)
 - [Twitter](https://twitter.com/jonhoo/status/1224383452591509507)
 - [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J)

# Çeviriler

- [Turkish: missing-semester-tr.github.io](https://missing-semester-tr.github.io/)
- [Chinese: missing-semester-cn.github.io](https://missing-semester-cn.github.io/)
  

*Not: Bunlar topluluk çevirileri dışında bağlantılardır. Bunları henüz incelemedik.*

Bu sınıfın ders notlarının bir çevirisini oluşturdun mu? [Pull request](https://github.com/missing-semester/missing-semester/pulls) gönder ve çevirini listeye ekleyelim!

## Teşekkür

Elaine Mello, Jim Cain, ve [MIT OpenLearning](https://openlearning.mit.edu/)'a ders videolarını kaydetmemizi mümkün kıldığı için; Anthony Zolnik ve [MITAeroAstro](https://aeroastro.mit.edu/)'ya A/V ekipmanları için; ve Brandi Adams'a ve [MIT EECS](https://www.eecs.mit.edu/)'e  bu sınıfı destekledikleri için teşekkür ederiz.

---

<div class="small center">
<p><a href="https://github.com/missing-semester/missing-semester">Kaynak kodu</a>.</p>
<p>CC BY-NC-SA lisansı altında.</p>
<p>Katkı yapmak &amp;  çeviri rehberine ulaşmak için <a href="/license/">buraya bak</a>.</p>
</div>
