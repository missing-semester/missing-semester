---
layout: page
title: Kì Học Bị Thiếu Của Giáo Trình Khoa Học Máy Tính
---

Giảng đường truyền thống dạy mọi người về các vấn đề chuyên ngành Khoa Học 
Máy Tính cao cấp từ hệ điều hành đến học máy. Tuy nhiên có một chủ đề tối quan 
trọng nhưng lại hay bị bỏ rơi để sinh viên tự mày mò, đó là khả năng sử dụng 
công cụ của họ. Chúng tôi sẽ dạy bạn cách làm chủ command-line, sử dụng một trình
biên dịch mã nguồn (text editor) hết khả năng của nó, vô vàn các chức năng "xịn xò" của trình
quản lý phiên bản (version control systems), và hơn thế nữa.

Ước chừng sinh viên sẽ dành ra hàng trăm giờ để sử dụng những công cụ nói trên trong suốt 
thời gian ngồi trên giảng đường (và hàng ngàn giờ khi đi làm). Vì vậy, việc đảm bảo cho họ 
sử dụng các công cụ này "nhanh, gọn, lẹ" là một điều vô cùng hợp lý. Làm chủ hoàn toàn được những
công cụ này không những cho phép bạn tiết kiệm thời gian thao tác theo ý mình, mà còn cho phép bạn
xử lý những vấn đề phức tạp, không tưởng.

Đọc thêm về [cảm hứng](/about/) của chúng tôi cho khóa học này.

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

**Lecture**: [35-225](https://whereis.mit.edu/?go=35), 1:30--2:30pm (_exception_: 3--4pm on Friday 1/16)<br>
**Discussion**: [OSSU Discord](https://ossu.dev/#community) (use `#missing-semester-forum` like you would use Piazza, and `#missing-semester` to chat with the class/instructors)

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

Video cho các bài giảng đã được upload lên [Youtube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J).
Lecture videos will be made available to MIT students immediately after lecture (via Panopto). The system has a limitation that only those with an MIT Kerberos can access the raw lecture videos. We will upload edited lecture videos to YouTube during the week of 1/26.

If you can't wait until January 2026, you can also take a look at the lectures
from the [previous offering of the course](/2020/), which covers many of the
same topics.

{% comment %}
Video recordings of the lectures are available [on
YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J).
{% endcomment %}

# Thông tin khóa học

**Người Đứng Lớp**: Khóa học này được truyền đạt bởi [Anish](https://www.anishathalye.com/), [Jon](https://thesquareplanet.com/), and [Jose](http://josejg.com/).
**Thắc mắc**: Email chúng tôi tại [missing-semester@mit.edu](mailto:missing-semester@mit.edu).
**Staff**: This class is co-taught by [Anish](https://anish.io/), [Jon](https://thesquareplanet.com/), and [Jose](https://josejg.com/).<br>
**Questions**: Email us at [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

# Ngoài MIT

Chúng tôi cũng đã chia sẻ lớp học này cho tất cả mọi người (không nhất thiết là sinh viên MIT) 
với mong ước mọi người sẽ học được gì đó có lợi cho mình. Mọi người cũng có thể đọc thêm các
diễn đàn, trang tin dưới đây.

 - [Hacker News](https://news.ycombinator.com/item?id=22226380)
 - [Lobsters](https://lobste.rs/s/ti1k98/missing_semester_your_cs_education_mit)
 - [/r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/eyagda/the_missing_semester_of_your_cs_education_mit/)
 - [/r/programming](https://www.reddit.com/r/programming/comments/eyagcd/the_missing_semester_of_your_cs_education_mit/)
 - [Twitter](https://twitter.com/jonhoo/status/1224383452591509507)
 - [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J)

# Bản Dịch

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

Lưu Ý: Những bản dịch này được đóng góp bởi cộng đồng mã nguồn mở.

Nếu bạn muốn tham gia dịch thuật, hãy submit một [pull request](https://github.com/missing-semester-vn/missing-semester-vn.github.io/pulls) cho mình nhé.

## Cảm Ơn

Chúng tôi cảm ơn Elaine Mello, Jim Cain, và [MIT Open
Learning](https://openlearning.mit.edu/) đã giúp chúng tôi thu video về lớp học này; Anthony Zolnik và [MIT
AeroAstro](https://aeroastro.mit.edu/) cho các phương tiện thu phát; và Brandi Adams và
[MIT EECS](https://www.eecs.mit.edu/) vì đã hỗ trợ khóa học này.
## Acknowledgments

{% comment %}
2026 acks; previous years' acks are on their respective pages
{% endcomment %}

We thank Elaine Mello and [MIT Open Learning](https://openlearning.mit.edu/) for making it possible for us to record lecture videos. We thank Luis Turino / [SIPB](https://sipb.mit.edu/) for supporting this class as part of [SIPB IAP 2026](https://sipb.mit.edu/iap/).

---

<div class="small center">
<p><a href="https://github.com/missing-semester/missing-semester">Mã Nguồn</a>.</p>
<p>Licensed under CC BY-NC-SA.</p>
<p>Xem hướng dẫn <a href="/license/">này</a> cho việc đóng góp &amp; dịch thuật.</p>
</div>
