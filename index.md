---
layout: page
title: The Missing Semester of Your CS Education
description: >
  Kuasai alat-alat canggih yang akan membuat Anda menjadi ilmuwan komputer dan programmer yang lebih produktif.
# subtitle: IAP 2026
subtitle: "2026"
nositetitle: true
---

Kuliah mengajarkan Anda semua tentang topik-topik lanjutan dalam ilmu komputer, dari sistem operasi
hingga machine learning, tetapi ada satu subjek penting yang jarang dibahas,
dan dibiarkan untuk dipelajari sendiri oleh para mahasiswa: kemahiran menggunakan
alat-alat mereka. Kami akan mengajarkan Anda cara menguasai command-line, menggunakan
text editor yang canggih, menggunakan fitur-fitur menarik dari sistem version control,
dan masih banyak lagi!

Mahasiswa menghabiskan ratusan jam menggunakan alat-alat ini selama
pendidikan mereka (dan ribuan jam selama karier mereka), jadi masuk akal untuk membuat
pengalaman tersebut selancar dan seefisien mungkin. Menguasai alat-alat ini tidak
hanya memungkinkan Anda menghabiskan lebih sedikit waktu untuk mencari cara menggunakan alat sesuai
keinginan Anda, tetapi juga memungkinkan Anda menyelesaikan masalah yang sebelumnya tampak
sangat kompleks.

Saat ini, banyak aspek software engineering juga mengalami perubahan
dengan diperkenalkannya alat dan workflow berbasis AI.
Ketika digunakan dengan tepat dan dengan kesadaran akan
keterbatasannya, alat-alat ini sering kali dapat memberikan manfaat signifikan bagi
praktisi ilmu komputer dan karenanya layak untuk dipelajari.
Karena AI adalah teknologi yang bersifat lintas fungsi, tidak ada
kuliah khusus AI; sebaliknya, kami telah mengintegrasikan penggunaan
alat dan teknik AI terkini ke dalam setiap kuliah secara langsung.

Baca tentang [motivasi di balik kelas ini](/about/).

{% comment %}
# Registration

Sign up for the IAP 2026 class by filling out this [registration form](https://forms.gle/j2wMzi7qeiZmzEWy9).
{% endcomment %}

# Silabus

{% comment %}
**Lecture**: [35-225](https://whereis.mit.edu/?go=35), 1:30--2:30pm (_exception_: 3--4pm on Friday 1/16)<br>
**Discussion**: [OSSU Discord](https://ossu.dev/#community) (use `#missing-semester-forum` like you would use Piazza, and `#missing-semester` to chat with the class/instructors)
{% endcomment %}

<ul>
{% assign lectures = site['2026'] | sort: 'date' %}
{% for lecture in lectures %}
    {% if lecture.phony != true %}
        <li>
        <strong>{{ lecture.date | date: '%-m/%-d/%y' }}</strong>:
        {% if lecture.ready %}
            <a href="{{ lecture.url }}">{{ lecture.title }}</a>
        {% else %}
            {{ lecture.title }} {% if lecture.noclass %}[no class]{% endif %}
        {% endif %}
        </li>
    {% endif %}
{% endfor %}
</ul>

## Topik khusus dari tahun-tahun sebelumnya

Topik yang kami bahas bervariasi dari tahun ke tahun. Untuk mahasiswa yang tertarik pada kumpulan topik lengkap yang telah kami bahas selama bertahun-tahun, kami menyoroti topik-topik yang dibahas pada tahun-tahun sebelumnya yang tidak kami bahas di tahun 2026.

{% comment %} pop to remove default "posts" collection {% endcomment %}
{% assign sorted_collections = site.collections | sort: 'label' | pop | reverse %}
<ul>
{% for collection in sorted_collections %}
    {% assign grouped_lectures = site[collection.label] | group_by: 'date' | sort: 'name' %}
    {% for group in grouped_lectures %}
        {% assign sorted_lectures = group.items | sort: 'order' %}
        {% for lecture in sorted_lectures %}
            {% if lecture.special == true %}
                <li>
                    <strong>{{ lecture.date | date: '%-m/%-d/%y' }}</strong>:
                    <a href="{{ lecture.url }}">{{ lecture.title }}</a>
                </li>
            {% endif %}
        {% endfor %}
    {% endfor %}
{% endfor %}
</ul>

{% comment %}
Lecture videos will be made available to MIT students immediately after lecture (via Panopto). The system has a limitation that only those with an MIT Kerberos can access the raw lecture videos. We are working on editing lecture videos and uploading them to YouTube. A couple have been uploaded already; we expect the rest to be uploaded by mid-February.

If you can't wait until January 2026, you can also take a look at the lectures
from the [previous offering of the course](/2020/), which covers many of the
same topics.
{% endcomment %}

# Informasi Umum

**Pengajar**: Kelas ini diajarkan bersama oleh [Anish](https://anish.io/), [Jon](https://thesquareplanet.com/), dan [Jose](https://josejg.com/).<br>
**Pertanyaan**: Email kami di [missing-semester@mit.edu](mailto:missing-semester@mit.edu).<br>
**Diskusi**: [OSSU Discord](https://ossu.dev/#community) (gunakan `#missing-semester-forum` seperti Anda menggunakan Piazza, dan `#missing-semester` untuk mengobrol dengan kelas/pengajar).

# Di Luar MIT

Kami juga telah membagikan kelas ini di luar MIT dengan harapan orang lain dapat
memanfaat dari sumber daya ini. Anda dapat menemukan posting dan diskusi di

 - Hacker News ([2026](https://news.ycombinator.com/item?id=47124171), [2020](https://news.ycombinator.com/item?id=22226380), [2019](https://news.ycombinator.com/item?id=19078281))
 - Lobsters ([2026](https://lobste.rs/s/q4ykw7/missing_semester_your_cs_education_2026), [2020](https://lobste.rs/s/ti1k98/missing_semester_your_cs_education_mit), [2019](https://lobste.rs/s/h6157x/mit_hacker_tools_lecture_series_on))
 - r/learnprogramming ([2026](https://www.reddit.com/r/learnprogramming/comments/1r93yk6/the_missing_semester_of_your_cs_education_2026/), [2020](https://www.reddit.com/r/learnprogramming/comments/eyagda/the_missing_semester_of_your_cs_education_mit/), [2019](https://www.reddit.com/r/learnprogramming/comments/an42uu/mit_hacker_tools_a_lecture_series_on_programmer/))
 - r/programming ([2020](https://www.reddit.com/r/programming/comments/eyagcd/the_missing_semester_of_your_cs_education_mit/), [2019](https://www.reddit.com/r/programming/comments/an3xki/mit_hacker_tools_a_lecture_series_on_programmer/))
 - X ([2026](https://x.com/anishathalye/status/2024521145777848588), [2020](https://twitter.com/jonhoo/status/1224383452591509507), [2019](https://x.com/jonhoo/status/1090323977766137858))
 - Bluesky ([2026](https://bsky.app/profile/jonhoo.eu/post/3mfa2bhyuj22i))
 - Mastodon ([2026](https://fosstodon.org/@jonhoo/116098318361854057))
 - LinkedIn ([2026](https://www.linkedin.com/posts/anishathalye_i-returned-to-mit-during-iap-january-term-activity-7430285026933522433-Ehr9))
 - YouTube ([2026](https://www.youtube.com/playlist?list=PLyzOVJj3bHQunmnnTXrNbZnBaCA-ieK4L), [2020](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J), [2019](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuiujH1lpn8cA9dsyulbYRv))

# Terjemahan

{% comment %} keep these in alphabetical order {% endcomment %}

- [Arab](https://missing-semester-ar.github.io/)
- [Bengali](https://missing-semester-bn.github.io/)
- [Cina (Sederhana)](https://missing-semester-cn.github.io/)
- [Cina (Tradisional, Taiwan)](https://missing-semester-tw.github.io/)
- [Jerman](https://missing-semester-de.github.io/)
- [Italia](https://missing-semester-it.github.io/)
- [Jepang](https://missing-semester-jp.github.io/)
- [Kannada](https://missing-semester-kn.github.io/)
- [Korea](https://missing-semester-kr.github.io/)
- [Mongolia](https://missing-semester-mn.github.io)
- [Persia](https://missing-semester-fa.github.io/)
- [Portugis](https://missing-semester-pt.github.io/)
- [Rusia](https://missing-semester-rus.github.io/)
- [Serbia](https://netboxify.com/missing-semester/)
- [Spanyol](https://missing-semester-esp.github.io/)
- [Swedia](https://den-saknade-terminen.l10n.se/)
- [Thailand](https://missing-semester-th.github.io/)
- [Turki](https://missing-semester-tr.github.io/)
- [Vietnam](https://missing-semester-vn.github.io/)

Catatan: ini adalah tautan eksternal ke terjemahan komunitas. Kami belum memverifikasi
isinya.

Apakah Anda telah membuat terjemahan catatan kuliah dari kelas ini? Kirimkan
[pull request](https://github.com/missing-semester/missing-semester/pulls) agar
kami dapat menambahkannya ke daftar!

## Ucapan Terima Kasih

{% comment %}
2026 acks; previous years' acks are on their respective pages
{% endcomment %}

Kami mengucapkan terima kasih kepada Elaine Mello dan [MIT Open Learning](https://openlearning.mit.edu/) yang telah memungkinkan kami merekam video kuliah. Kami juga berterima kasih kepada Luis Turino / [SIPB](https://sipb.mit.edu/) yang telah mendukung kelas ini sebagai bagian dari [SIPB IAP 2026](https://sipb.mit.edu/iap/).

---

<div class="small center">
<p><a href="https://github.com/missing-semester/missing-semester">Kode sumber</a>.</p>
<p>Dilisensikan di bawah CC BY-NC-SA.</p>
<p>Lihat <a href="/license/">di sini</a> untuk panduan kontribusi &amp; terjemahan.</p>
</div>
