---
layout: lecture
title: "Tại sao lại là khóa học này"
---

Trong suốt thời gian ngồi ở giảng đường đại học sắp tới, chắc hẳn bạn sẽ được 
trao dồi vô vàn kiến thức nâng cao của môn Khoa Học Máy Tính như Hệ Điều Hành 
(Operating Systems), Các Ngôn Ngữ Lập Trình và thậm chí là cả Học Máy (Machine
Learning). Thế nhưng nhiều trường đại học lại thường bỏ qua một môn đại cương 
quan trọng và để sinh viên của mình tự mình mày mò. Môn học ấy chính là hệ sinh 
thái tính toán đa dạng của máy tính của bạn.

Trong suốt nhiều năm đứng lớp tại MIT, chúng tôi đã bắt gặp vô vàn sinh viên với
vốn kiến thức hạn chế về các công cụ mà hệ sinh thái này có. Máy tính được phát 
minh ra với mục đích để tự động hóa các quy trình bằng tay chán ngắt. Vậy mà sinh
viên lại luôn thực hiện chúng bằng tay, hay không thể sử dụng máy tính một cách hiệu 
quả nhất, với những công cụ như trình quản lý phiên bản (version control system)
và trình biên tập mã nguồn (text editor). Nhẹ thì điều này dẫn đến sự thiếu hiệu quả 
và mất thời gian. Còn nặng nhất thì có thể là nhiều vấn đề như đánh mất thông tin 
hay không thể thực hiện được nhiều tác vụ chuyên ngành.

Có đi thì phải có lại, những kiến thức này không hề được đưa vào giáo trình
của sinh viên đại học. Sinh viên không được giới thiệu về cách sử dụng các công
cụ nói trên, hay ít nhất là sử dụng chúng hiệu quả, và như vậy các bạn đang tốn 
thời gian cho các tác vụ _"đơn giản"_. Giáo trình Khoa Học Máy Tính truyền thống 
đang thiếu mảnh ghép quan trọng về hệ sinh thái tính toán này, thứ có thể làm 
cuộc sống sinh viên nhẹ nhàng hơn.

# Kì học bị thiếu của giáo trình khoa học máy tính

Để phần nào hạn chế thiếu sót trên, chúng tôi cung cấp khóa học này với những 
kiến thức cần thiết cho một nhà khoa học máy tính, nhà lập trình. Khóa học này 
vừa thực tế lại vừa cho phép bạn thực hành các công cụ, kỹ thuật mà bạn có thể
áp dụng ngay lập tức vào rất nhiễu trường họp bạn sẽ gặp trong tương lai. Khóa
học được tổ chức trong "Thời Gian Của Các Hoạt Động Độc Lập" (IAP) của MIT trong năm 
2020 - một kì học dài một tháng với các lớp học do sinh viên đứng lớp. Tin tốt là, 
mặc dù lớp học chỉ dành cho sinh viên MIT hiện tại, chúng tôi sẽ cung cấp các văn
bản ghi chép kiến thức và video cho toàn cộng đồng.

Nếu bạn nghĩ khóa học này có vẻ thú vị cho bạn, sau đây là một số kiến thức
sẽ được đề cập đến:

## Command shell (Dòng Lệnh Shell)

Làm cách nào để tự động hóa các tác vụ cơ bản, lập đi lập lại với aliases, scripts 
và hệ thống dựng (build systems). Không phải copy và paste các câu lệnh từ một văn bản
nữa. Bạn cũng sẽ không cần "chạy câu lệnh, tác vụ này thêm 15 lần nữa, lần này xong
đến lần khác". Và bạn cũng không phải thốt lên " Bạn quên chạy trình này" hay "Bạn quên 
pass this argument".

Chẳng hạn, việc xem lại lịch sử các câu lệnh có thể sẽ tiết kiệm rất nhiều thời gian. 
Trong ví dụ dưới đây, chúng tôi sẽ giới thiệu vài cách tra cứu lịch sử của shell cho câu lệnh 
`convert`.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/history.mp4" type="video/mp4">
</video>

## Version control (Trình Quản Lý Phiên Bản)

Cách xử dụng trình quản lý phiên bản hợp lí là như thế nào? Tận dụng nó
để giải quyết các vấn đề tệ hại, hay làm việc nhóm và thậm chí là tìm ra các
vấn đề nhức nhối trong code. Không cần phải `rm -rf; git clone`. Không còn 
merge conflicts (hoặc ít nhất là ít hơn). Không còn một khối code bị 
commented-out. Không còn lo lắng tìm kiếm thứ đã phá code của bạn. Và không 
còn phải thốt lên "Ôi không, hình như chúng ta xóa cái code đang chạy tốt đi 
rối". Chúng tôi sẽ còn hướng dẫn cách đóng góp cho các dự án mã nguồn mở khác 
với pull requests!

Trong ví dụ dưới đây, chúng ta sẽ dùng 'git bisect' để tìm kiếm commit nào đã phá hỏng unit test của chúng ta, và sửa nó với `git revert`.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/git.mp4" type="video/mp4">
</video>

## Text editing (Biên tập mã nguồn)

Làm thế nào để biên tập từ command-line, trên máy tính của bạn và thậm chí là 
khi đang đăng nhập từ xa, và sử dụng hết khả năng nâng cao của một trình biên
tập. Không cần copy từ đây qua kia, và không cần phải biên tập file liên tục.

Trình biên tập Vim có macros là một trong những chức năng tốt nhất, trong ví dụ dưới đây, ta sẽ chuyển đổi một bảng html sang format csv chỉ bằng nested vim macro.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/vim.mp4" type="video/mp4">
</video>

## Remote machines (Máy Remote)

Làm cách nào để không phát điên khi sử dụng máy remote với SSH keys và terminal multiplexing.
Không phải mở vài terminals cùng lúc để chạy hai câu lệnh cùng lúc. Không cần phải nhập mật khẩu 
mỗi khi bạn kết nối. Không còn mất hết tất cả chỉ vì internet bị đứt hay bạn phải khởi độnt lại laptop.

Trong ví dụ dưới đây, chúng ta sẽ dùng `tmux` để giữ sessions alive trong máy remote và `mosh` để đáp ứng network roaming và disconnection.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/ssh.mp4" type="video/mp4">
</video>

## Finding files

Làm sao để tìm tệp tinh một cách nhanh chóng. Không còn phải nhấn chuột vào đủ loại tệp 
trong thư mục của project của bạn đến khi tìm được mảnh code bạn cần nữa.

Trong ví dụ dưới đây, chúng ta sẽ tìm tệp với `fd` và các mảnh code với `rg`. Chúng ta cũng sẽ dùng `fasd` để `cd` và `vim` các tệp, tập tin gần đây/hay dùng.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/find.mp4" type="video/mp4">
</video>

## Data wrangling

Làm sao để nhanh chóng và dễ dàng thay đổi, xem, parse, vẽ và tính toán với các dữ liệu và tệp từ command-line? 
Không cần phải copy và paste từ các tệp log. Không cần phải tự tay tính toán thống kê từ dữ liệu. Không cần phải vẽ bằng Excel nữa.

## Virtual machines (Máy Ảo)

Làm sao để sử dụng máy ảo để khám phá các hệ điều hành máy, cách ly các
dự án không liên quan và giữ cho máy chính của bạn sạch và gọn gàng. Không còn 
"tự nhiên" corrupting your computer trong một lớp thực hành bảo mật nữa. Và không còn
vài triệu packages được cài đặt với vô vàn các phiên bản khác nhau.

## Security (Bảo mật)

Làm sao để tham gia Internet mà không làm lọ bí mật của bạn cho cả thế giới?
Không cần phải tự mình tạo ra các passwords hóc búa. Không còn những mạng Wifi mở
thiếu bảo mật. Và không còn nhắn tin thiếu an toàn nữa

# Kết

Những thứ ở trên và còn hơn thế nữa, sẽ được giới thiệu trong seri 12 lớp, với các 
bài tập để bạn có thể tự làm quen với những công cụ. Nếu bạn không thể đợi đến tháng 1, hãy tham khảo
các kiến thức từ [Hacker Tools](https://hacker-tools.github.io/lectures/), một sê ri chúng tôi tổ chức trong kì IAP năm ngoái

Hẹn gặp vào tháng Một, dù là trực tiếp hay gián tiếp!

Hack vui vẻ nhé!<br>
Anish, Jose, and Jon
