---
layout: page
title: The Missing Semester - kỳ học bổ sung các kiến thức hữu ích của ngành khoa học máy tính
---

Các lớp học, giảng đường hiện nay  giúp bạn bổ sung kiến thức nâng cao trong ngành khoa học máy tính (CS), từ hệ điều hành đến Machine Learning. 
Tuy nhiên, vẫn tồn tại nhiều chủ đề đóng vai trò rất quan trọng trong ngành này nhưng các giáo trình hiếm khi đề cập đến, thay vào đó, sinh viên vẫn phải tự mày mò một cách không bài bản, đó là
kỹ năng sử dụng tốt các công cụ chuyên ngành. Trong khoá học này, chúng tôi sẽ hướng dẫn các bạn cách sử dụng thành thạo các công cụ như command-line, sử dụng một text editor có chức năng cực kỳ tốt,
dùng các tính năng hay ho của hệ thống quản lý phiên bản mã nguồn (version control systems), và còn nhiều nội dung hữu ích khác!

Sinh viên bỏ ra hàng trăm giờ làm việc sử dụng các công cụ chuyên ngành kể trên trong suốt quá trình học tập tại trường lớp (và hàng ngàn giờ trong quá trình làm việc thực tế). Vì vậy việc giúp họ sự
dụng các công cụ này một cách trơn tru mượt mà nhất có thể là một điều cần thiết. Làm chủ các công cụ này không những giúp bạn giảm thiểu thời gian mày mò cách sử dụng chúng cho đúng với nhu cầu mà còn
giúp bạn giải quyết các vấn đề trước đó tưởng chừng như hóc búa một cách không tưởng.

Đọc thêm về [cảm hứng tạo ra khoá học này] (/about/).

# Thời gian biểu của khoá học

<ul>
{% assign lectures = site['2020'] | sort: 'date' %}
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

Các video bài giảng của khoá học có thể tìm thấy [tại
YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J).

# Thông tin về khoá học

**Giảng viên**: Khoá học này được kết hợp giảng dạy bởi [Anish](https://www.anishathalye.com/), [Jon](https://thesquareplanet.com/), and [Jose](http://josejg.com/).<br>
**Thắc mắc**: Nếu có bất kỳ câu hỏi hay thắc mắc nào về nội dung khoá học, bạn có thể email cho chúng tôi tại địa chỉ [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

# Bên ngoài MIT

Chúng tôi cũng chia sẻ khoá học này đến với các bạn sinh viên bên 
ngoài MIT với mong muốn khoá học này sẽ giúp ích được cho nhiều người.
Bạn có thể tìm thấy các diễn đàn, bài đăng và thảo luận ở:

 - [Hacker News](https://news.ycombinator.com/item?id=22226380)
 - [Lobsters](https://lobste.rs/s/ti1k98/missing_semester_your_cs_education_mit)
 - [/r/learnprogramming](https://www.reddit.com/r/learnprogramming/comments/eyagda/the_missing_semester_of_your_cs_education_mit/)
 - [/r/programming](https://www.reddit.com/r/programming/comments/eyagcd/the_missing_semester_of_your_cs_education_mit/)
 - [Twitter](https://twitter.com/jonhoo/status/1224383452591509507)
 - [YouTube](https://www.youtube.com/playlist?list=PLyzOVJj3bHQuloKGG59rS43e29ro7I57J)

# Các bản dịch

- [Tiếng Trung (Giản thể)](https://missing-semester-cn.github.io/)
- [Tiếng Trung (Phồn thể)](https://missing-semester-zh-hant.github.io/)
- [Tiếng Nhật](https://missing-semester-jp.github.io/)
- [Tiếng Hàn](https://missing-semester-kr.github.io/)
- [Tiếng Bồ Đào Nha](https://missing-semester-pt.github.io/)
- [Tiếng Nga](https://missing-semester-rus.github.io/)
- [Tiếng Serbia](https://netboxify.com/missing-semester/)
- [Tiếng Tây Ban Nha](https://missing-semester-esp.github.io/)
- [Tiếng Thổ Nhĩ Kì](https://missing-semester-tr.github.io/)
- [Tiếng Việt](https://missing-semester-vn.github.io/)

Lưu ý: đây đều là các đường dẫn tới các bản dịch cộng đồng bên ngoài. Chúng tôi
chưa hiệu đính các bản dịch này.

Nếu bạn muốn đóng góp một bản dịch của một bài giảng trong khoá học, hãy gửi một 
[pull request](https://github.com/missing-semester/missing-semester/pulls) cho chúng tôi nhé.

## Lời cảm ơn

Chúng tôi gửi lời cảm ơn chân thành đến Elaine Mello, Jim Cain, và [MIT Open
Learning](https://openlearning.mit.edu/) - những người đã giúp đỡ rất nhiều để 
chúng tôi có cơ hội quay các video bài giảng; Anthony Zolnik và [MIT
AeroAstro](https://aeroastro.mit.edu/) vì đã hỗ trợ các thiết bị A/V; cuối cùng là Brandi Adams và
[MIT EECS](https://www.eecs.mit.edu/) vì đã hỗ trợ khoá học này.
---

<div class="small center">
<p><a href="https://github.com/missing-semester/missing-semester">Source code</a>.</p>
<p>Licensed under CC BY-NC-SA.</p>
<p>Xem hướng dẫn tại <a href="/license/">đây</a> để đóng góp &amp; dịch thuật.</p>
</div>
