---
layout: page
title: Kì Học Bị Thiếu Của Giáo Trình Khoa Học Máy Tính
---

Giảng đường truyền thống dạy mọi người về các vấn đề chuyên nghành Khoa Học 
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

{% comment %}
# Registration

Sign up for the IAP 2020 class by filling out this [registration form](https://forms.gle/TD1KnwCSV52qexVt9).
{% endcomment %}

# Schedule

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

Video cho các bài giảng đã được upload lên [Youtube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J).

# Thông tin khóa học

**Người Đứng Lớp**: Khóa học này được truyền đạt bởi [Anish](https://www.anishathalye.com/), [Jon](https://thesquareplanet.com/), and [Jose](http://josejg.com/).
**Thắc mắc**: Email chúng tôi tại [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

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
- [Chinese (Traditional)](https://missing-semester-zh-hant.github.io/)
- [Korean](https://missing-semester-kr.github.io/)
- [Portuguese](https://missing-semester-pt.github.io/)
- [Serbian](https://netboxify.com/missing-semester/)
- [Spanish](https://missing-semester-esp.github.io/)
- [Turkish](https://missing-semester-tr.github.io/)
- [Vietnamese](https://missing-semester-vn.github.io/)

Lưu Ý: Những bản dịch này được đóng góp bởi cộng đồng mã nguồn mở.

Nếu bạn muốn tham gia dịch thuật, hãy submit một [pull request](https://github.com/missing-semester-vn/missing-semester-vn.github.io/pulls) cho mình nhé.

## Cảm Ơn

Chúng tôi cảm ơn Elaine Mello, Jim Cain, và [MIT Open
Learning](https://openlearning.mit.edu/) đã giúp chúng tôi thu viedo về lớp học này; Anthony Zolnik và [MIT
AeroAstro](https://aeroastro.mit.edu/) cho các phương tiện thu phát; và Brandi Adams và
[MIT EECS](https://www.eecs.mit.edu/) vì đã hỗ trợ khóa học này.

---

<div class="small center">
<p><a href="https://github.com/missing-semester/missing-semester">Mã Nguồn</a>.</p>
<p>Licensed under CC BY-NC-SA.</p>
<p>Xem hướng dẫn <a href="/license/">này</a> cho việc đóng góp &amp; dịch thuật.</p>
</div>
