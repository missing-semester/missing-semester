---
layout: lecture
title: "Tổng quan khóa học + Shell"
date: 2019-01-13
ready: true
video:
  aspect: 56.25
  id: Z56Jmr9Z34Q
---

# Mục đích

Là những nhà khoa học máy tính, chúng ta đều hiểu rõ công dụng bổ ích của máy tính trong việc
thực hiện các tác vụ lặp lại. Thế nhưng, chúng ta lại thường quên cách sử dụng máy tính một cách hiệu quả như
những phép tính mà ta muốn chúng thực hiện. Chúng ta có rất nhiều công cụ giúp nâng cao hiệu năng công việc và 
giúp chúng ta thực hiền nhiều tác vụ phức tạp khi cần phải giải quyết những vấn đề liên quan đến khoa học máy tính. Thế nhưng,
đa phần chúng ta chỉ sử dụng một phần rất nhỏ trong số những công cụ này; chúng ta chỉ biết rất ít, và đa phần là copy paste các câu lệnh từ
internet khi ta gặp vấn đề.

Đây là khóa học được tạo ra để giải quyết vấn đề trên.

Chúng tôi muốn dạy bạn cách tận dụng hết mức các công cụ ấy, giới thiệu cho bạn cách công cụ mới và hy vọng sẽ làm bạn thích thú trong việc tìm hiểu (hay chế tạo) các công cụ của riêng mình. Đây, theo như chúng tôi, là một khóa học luôn luôn bị thiếu cho cách nhà Khoa Học Máy Tính.

# Cấu trúc khóa học

Khóa học gồm 11 bài giảng dài 1 tiếng. Mỗi bài giảng tập trung vào [một chủ đề](/2020/). 
Các bài giảng phần lớn là độc lập với nhau, tuy nhiên chúng tôi sẽ giả dụ rằng bạn luôn theo dõi
các bài giảng một cách đầu đủ trước khi theo dõi một lớp mới. Chúng tôi có nội dung của các bài giảng
được trình bày trên mạng, nhưng vẫn có rất nhiều nội dung chỉ có trong lớp/video (ví dụ như các bài thuyết trình thực tế của
giáo viên đứng lớp) mà có thể không có trong cách ghi chép bài giảng đó. Chúng tôi cũng sẽ thu lại các bài giảng và
trình chiếu các video này trên mạng 

Với chỉ 11 giờ, khóa học này sẽ có rất nhiều thông tin, và các bài giảng cũng sẽ rất dày về kiến thức.
Để có thời gian cho các bạn thực hành và tập luyện, mỗi bài giảng đều đính kèm một số bài tập cho các bạn. Sau mỗi lớp học, chúng tôi sẽ tổ chức 
giờ thăm khảo để giúp đỡ các ban nếu cần thiết. Ngoài ra, các bạn có thể gửi thêm câu hỏi của mình về địa chỉ email
[missing-semester@mit.edu](mailto:missing-semester@mit.edu).

Vì thời gian có hạn, chúng tôi sẽ không thể bao quát hết toàn bộ chi tiết của các công cụ như một khóa học chuyên sâu. Thay vào đó, chúng tôi sẽ đính kèm thêm các nội dung tham khảo khác mà bạn có thể tìm đọc. Tuy nhiên nếu có câu hỏi hõặc thắc mắc nào thêm, xin đừng ngại ngần liên lạc cho chúng tôi nhé!

# Chủ đề 1: Shell (Vỏ)

## Shell (vỏ) là gì?

Ngày nay, máy tính có vô vàn các giao diện khác nhau để người dùng tương tác
với chúng: từ những giao diện đồ họa, đến giao diện âm thanh hay thậm chí là 
giao diện thực tế ảo AR/VR ở kháp nơi. Những giao diện này đáp ứng đủ đến 80% 
các use-cases (trường hợp sử dụng) mà chúng được thiết kế để sữ dụng, tuy nhiên chúng lại vô cùng hạn chế 
về khả năng thật sự mà chúng cho phép ta thao tác với. Một ví dụ điển hình là
bạn không thể bấm nút để thực hiện một thao tác nào đó nếu thao tác ấy không được lập
trình thành nút bấm cho gia diện. Hay là việc ra lệnh bằng giọng nói cho một câu lệnh lạ hoặc mà
máy tính chưa được lập trình để hiểu được. Vì vậy để tận dụng được hoàn toàn sức mạnh
mà máy tính cho phép trong các tác vụ của chúng ta, chúng ta cần đi theo hướng truyền thống và 
vô cùng cơ bản: giao diện câu lệnh bằng chữ - Shell.

Hầu như mọi nền tảng tính toán mà ta có thể đặt tay lên được đều có ít nhất một loại shell mà 
ta có thể chọn để sử dụng. Và dù mỗi loại shell đều có các thiết kế về chức năng khác nhau, 
nhưng chung quy lại: chúng đều cho phép ta chạy các chương trình, nhập dữ liệu và truy xuất dữ liệu đầu ra
theo một quy chuẩn rõ ràng.

Trong bài học này, chúng ta sẽ tập trung vào Shell có tên là Bourne Again SHell, hay "bash".
Đây là một loại shell vô cùng thông dụng và cú pháp câu lệnh của nó rất cơ bản, được sử dụng 
trong nhiều loại shell khác. Để mở một _dòng nhắc shell (prompt)_ - nơi mà bạn có thể ra lệnh, bạn cần trước nhất
một _phần mềm/thiết bị đầu cuối (terminal)_. Phần mềm này thường được cài đặt sẵn trong hệ điều hành của 
bạn, hoặc bạn có thể dễ dàng cài đặt nó một các dễ dàng.

_Ghi chú (của người dịch): Shell là vỏ, còn kernel là lõi. Kernel thường dùng để chỉ phần lõi của hệ điều hành
(Unix, Linux, Windows, etc). Phần lõi có các chức năng như quản lý tài nguyên, sắp xếp lịch trình của các 
task, v.v. Để 'nói chuyện' với phần lõi này, chúng ta có thể dùng shell và vô vàn các cách khác, tuy nhiên shell rất
nhanh gọn và thao tác đơn giản. Vì kernel là lõi và thường được giấu đi khỏi người dùng, trình giao diện shell mà người dùng có thể sử dụng sẻ được gọi là vỏ (shell)._

## Cách dùng Shell (vỏ)

Khi bạn mở một terminal, bạn sẽ thấy được một dòng nhắc _prompt_ như sau:

```console
missing:~$ 
```

Đây là giao diện câu chữ chính của trình shell (vỏ). Nó cho bạn biết ta đang ở trên máy `missing` và thư mục mà ta đang ở hiện tại là `~` (ngắn gọn cho "home" hay trang chủ của tài khỏan người dùng hiện tại). Dấu hiệu `$` lại cho ta biết người dùng hiện tại (ta), không phải là người dùng gốc (root). Trên dòng nhắc prompt này, bạn có thể nhập một _câu lệnh (command)_, thứ mà sau đó sẽ được thông dịch bởi shell. Một câu lệnh vô cùng đơn giản là:

```console
missing:~$ date
Fri 10 Jan 2020 11:49:31 AM EST
missing:~$ 
```

Ở đây, ta đã chạy trình `date`, thứ mà (không có gì bất ngờ) sẽ in ra ngày giờ hiện tại. Trình shell sau đó sẽ lại hỏi ta một câu lệnh khác để chạy. Chúng ta cũng có thể chạy câu lệnh với các _đối số (arguments):_

```console
missing:~$ echo hello
hello
```

Trong trường hợp này ta ra lệnh cho trình shell thực hiện trình `echo` với đối số là `hello`. 
Trình `echo` in ra cửa sổ terminal đối số của nó. Trình shell phân tích từ loại (parsing) của câu
lệnh bằng cách phân câu lệnh ra theo khoảng trắng, và sau đó chạy câu lệnh được nhắc đến trong từ
đầu tiên, nhập các từ tiếp theo thành một đối số của trình/câu lệnh này. Nếu bạn muốn nhập một đối số
có khoảng trống (ví dụ như thư mục có tên là "My Photos"), ta có hai cách. Một là bao đối số đó với dấu `'` 
hoặc `"` (`"My Photos"`), hoặc hai là nhập ký tự đặc biệt với dấu `\` (`My\ Photos`).

Nhưng làm cách nào mà shell có thể tìm được chỗ mà trình `date` và `echo` để chạy?
À thì, Shell là một mội trường lập trình, giống như ngôn ngữ Python hay là Ruby,
và vì thế mà nó có biến số, điều kiện, vòng lặp và hàm. Khi bạn chạy câu lệnh trong shell,
bạn thật ra đang viết một dòng mã mà trình shell thông dịch. Nếu shell được ra lệnh để chạy 
một câu lệnh không có trong từ khóa lập trình, nó sẽ tham vấn một _biến số môi trường (environment variable)_
tên là `$PATH`, nơi mà các thư mục mà trình shell có thể tìm kiếm các trình được ra lệnh để chạy câu lệnh được đính kèm.

```console
missing:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
missing:~$ which echo
/bin/echo
missing:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Khi ta chạy câu lệnh `echo`, shell biết rằng nó cần chạy trình `echo`, và sau đó nó sẽ tìm tệp có cùng tên
trong dãy các thư mục của `$PATH`, được phân lập bằng dấu `:` trình này. Khi vị trí của trình này được 
xác định, shell sẽ chạy nó (với điều kiện là tệp `echo` phải _thực hiện được(executable)_). Chúng ta có thể biết được tệp nào sẽ được chạy khi ra câu lệnh với trình `which`. Chúng ta cũng có thể bỏ qua việc tìm kiếm trong `$PATH` bằng cách nhập câu lệnh bằng đường dẫn đến trình mà ta cần chạy.

## Định hướng và di chuyển trong Shell (vỏ)

Một đường dẫn trong shell là một dãy các thư mục được giới hạn bởi dấu `/` trên hệ điều hành Linux và
macOS và dấu `\` trên Windows. Trên Linux và macOS, đường dẫn `/` là "gốc"(root) của hệ thống tệp (file
system), một loại cây thư mục mà mọi tệp và thư mục khác trực thuộc. Trên Windows thì mỗi ổ đĩa hay phần
đĩa (disk partition) như ổ `C:\` sẽ có một gốc cây thư mục riêng. Khóa học này sẽ giả dụ rằng bạn đang dùng
cây thư mục Linux. Một đường dẫn bắt đầu với dấu `/` được gọi là đường dẫn _tuyệt đối(absolute)_. 
Các đường dẫn khác được gọi là _tương đối(relative)_. Đường dẫn tương đối sẽ dựa trên thư mục hiện tại của bạn làm
gốc, nơi mà bạn có thể dùng `pwd` để kiểm tra và thay đổi, di chuyển với `cd`. Trong một đường dẫn, dấu `.` có nghĩa là thư mục hiện tại còn `..` là thư mục bố mẹ:

```console
missing:~$ pwd
/home/missing
missing:~$ cd /home
missing:/home$ pwd
/home
missing:/home$ cd ..
missing:/$ pwd
/
missing:/$ cd ./home
missing:/home$ pwd
/home
missing:/home$ cd missing
missing:~$ pwd
/home/missing
missing:~$ ../../bin/echo hello
hello
```

Lưu ý rằng câu nhắc của shell sẽ luôn cho ta biết về thư mục hiện tại mà chúng ta đang ở.
Bạn cũng có thể tùy chỉnh câu nhắc để nó in ra mọi loại thông tin hữu dụng. Chúng ta sẽ
tìm hiểu về việc này trong các bài sau.

Thông thường, khi ta chạy một chương trình hay câu lệnh, nó sẽ được thực hiện trong thư
mục mà chúng ta đang ở, trừ khi ta chỉ ra đường dẫn cụ thể. Ví dụ, câu lệnh thường hay tìm
tệp trong thư mục hiện tại và tạo tệp mới nếu cần thiết.

Để xem trong thư mục hiện tại có gì, ta dùng `ls`:

```console
missing:~$ ls
missing:~$ cd ..
missing:/home$ ls
missing
missing:/home$ cd ..
missing:/$ ls
bin
boot
dev
etc
home
...
```

Trừ khi một đường dẫn thư mục cụ thể được gán vào đối số thứ nhất của câu lệnh, `ls` luôn in ra 
nội dung (tệp và thư mục con) của thư mục hiện tại. Đa số các câu lệnh cũng cho phép dùng cờ (flag) và
tùy chỉnh (option - cờ với giá trị ) bắt đầu bằng dấu `-` để thay đổi chức năng. Thông thường, dùng cờ tùy chỉnh 
`-h` hay `--help` (`/?` trên Windows) sẽ chạy chương trình bằng cách in ra thông tin hướng dẫn sử dụng chương trình ấy, 
cũng như những loại cờ tùy chỉnh mà nó hỗ trợ. Ví dụ câu lệnh `ls --help` cho ta biết:

```
  -l                         use a long listing format
```

```console
missing:~$ ls -l /home
drwxr-xr-x 1 missing  users  4096 Jun 15  2019 missing
```

Tùy chỉnh này cho ta biết rất nhiều thông tin về tệp và thư mục con. Đầu tiên, chữ `d` ở đầu dòng
cho ta biết rằng `missing` là một thư mục. Sau đó là các nhóm 3 chữ (`rwx`). Các nhóm này cho ta biết, 
theo thứ tự của nhóm, phân quyền (permissions) của chủ (owner) tập tin (`missing`) , nhóm chủ (owning group) (`users`), và tất
cả người dùng còn lại trên tập tin này. Dấu `-` thể hiện rằng người dùng hoặc nhóm người dùng đó không có phân quyền nhất định
đó. Trong ví dụ trên, chỉ có người chủ tập tin có quyền thay đổi (`w`) tập tin `missing` (tức là tạo và xóa tệp trong nó).
Để di chuyển vào trong thư mục, người dùng cần có quyền "tìm kiếm" (thể hiện bằng quyền "thực hiện":`x`) của thư mục đó (và kéo 
theo là cả thư mục bố mẹ hiện tại). Để liệt kê nội dung của thư mục ấy, người dùng cần có quyền xem, đọc (`r`) trên thư mục đó.
Chú ý rằng các tệp trong tập tin `\bin` đều có phân quyền `x` trong nhóm phân quyền cuối cùng, tức "bất cứ người dùng nào", vì nó
cho phép ai cũng có thể chạy được các trình nằm trong tập tin đó.

Một vài trình hữu dụng khác mà ta cần biết lúc này là `mv` (di chuyển hoặc đổi tên một tệp), `cp` (sao chép một tệp), và `mkdir`
(tạo thư mục).

Để biết _thêm_ thông tin về các đối số, dữ liệu nhập, xuất hay cách dùng câu lệnh nói chúng, ta dùng lệnh `man`. Câu lệnh này
sẽ dùng tên một câu lệnh hay trình khác làm đối số và in ra trang hướng dẫn sử dụng cần có. Lưu ý để thoát ra khỏi trang này,
ta bấm `q`.

```console
missing:~$ man ls
```

## Kết nối các chương trình

Trong shell, các chương trình thường có hai "dòng" (streams): dòng nhập (input stream) và dòng xuất(output stream). Khi chương trinh muốn nhập dữ liệu, nó sẽ đọc hoặc nhập từ dòng nhập, còn khi nó in hay xuất dữ liệu, nó sẽ in hay xuất ra dòng xuất. Thông thường chương trình cửa sổ đầu cuối (terminal) sẽ là nơi chương trình nhập và xuất dữ liệu. Điều đó có nghỉa, mặc định dữ liệu được nhận vào từ bàn phím và xuất ra trên màn hình của máy tính Tuy nhiên, ta có thể thay đổi dòng nhập, xuất của các chương trình và tiếp nối chúng với nhau!

Đơn giản nhất để tiếp nối, thay đổi các dòng này đó là `< file` và `> file`. Chúng cho phép ta có thể thay đổi dòng nhập và xuất từ một tệp nào đó:

```console
missing:~$ echo hello > hello.txt
missing:~$ cat hello.txt
hello
missing:~$ cat < hello.txt
hello
missing:~$ cat < hello.txt > hello2.txt
missing:~$ cat hello2.txt
hello
```

Bạn cũng có thể dùng `>>` để viết thêm vào dòng cuối cùng của tệp. Kiểu thay đổi dòng nhập xuất này thực sự hữu dụng khi ta dựng các _đường ống_(pipes) dữ liệu. Dấu `|` được dùng để nối các chương trình với nhau sao cho dữ liệu xuất ra từ chương trình này lại là dữ liệu nhập của chương trình khác:

```console
missing:~$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2019 var
missing:~$ curl --head --silent google.com | grep --ignore-case content-length | cut --delimiter=' ' -f2
219
```

Chúng ta sẽ tìm hiểu thêm về các đường ống dữ liệu này trong bài giảng về sắp xếp dữ liệu (data wrangling).

## Một công cụ mạnh mẽ và đa dụng.

Trên các hệ thống tiệm Unix, có một loại tài khoản người dùng đặc biệt: người dùng "root". Bạn có thể đã thấy nó trong các ví dụ phía trên. Người dùng root là tài khoản có phân quyền cao nhất, và có thể tạo, xem, thay đổi và xóa bất cứ tệp nào trên hệ thống. Tuy nhiên, khi đăng nhập vào máy tính, chắc chắn ta sẽ không đăng nhập với quyền của root, vì thật đơn giản với phân quyền như vậy để gây ra các lội lầm ngớ ngẩn trên hệ thống của mình. Thay vào đó, ta phải dùng câu lệnh `sudo`. Như tên gọi tiếng Anh của nó, nó cho phép ta thực hiện một tác vụ nào đó (do), với phân quyền của tài khoản "su" (ngắn gọn cho "super user hay là root"). Đa phần khi ta gặp lỗi phân quyền bị từ chối (permission denied errors), đó là vì ta cần chạy chương trình đó với phân quyền của root. Tuy nhiên hãy chắc chắn rằng bạn muốn thực hiện lệnh đó với phân quyền cao như vậy (vì nó có thể ảnh hưởng đến hệ thống của bạn)!

One thing you need to be root in order to do is writing to the `sysfs` file
system mounted under `/sys`. `sysfs` exposes a number of kernel parameters as
files, so that you can easily reconfigure the kernel on the fly without
specialized tools. **Note that sysfs does not exist on Windows or macOS.**

For example, the brightness of your laptop's screen is exposed through a file
called `brightness` under

```
/sys/class/backlight
```

By writing a value into that file, we can change the screen brightness.
Your first instinct might be to do something like:

```console
$ sudo find -L /sys/class/backlight -maxdepth 2 -name '*brightness*'
/sys/class/backlight/thinkpad_screen/brightness
$ cd /sys/class/backlight/thinkpad_screen
$ sudo echo 3 > brightness
An error occurred while redirecting file 'brightness'
open: Permission denied
```

This error may come as a surprise. After all, we ran the command with
`sudo`! This is an important thing to know about the shell. Operations
like `|`, `>`, and `<` are done _by the shell_, not by the individual
program. `echo` and friends do not "know" about `|`. They just read from
their input and write to their output, whatever it may be. In the case
above, the _shell_ (which is authenticated just as your user) tries to
open the brightness file for writing, before setting that as `sudo
echo`'s output, but is prevented from doing so since the shell does not
run as root. Using this knowledge, we can work around this:

```console
$ echo 3 | sudo tee brightness
```

Since the `tee` program is the one to open the `/sys` file for writing,
and _it_ is running as `root`, the permissions all work out. You can
control all sorts of fun and useful things through `/sys`, such as the
state of various system LEDs (your path might be different):

```console
$ echo 1 | sudo tee /sys/class/leds/input6::scrolllock/brightness
```

# Next steps

At this point you know your way around a shell enough to accomplish
basic tasks. You should be able to navigate around to find files of
interest and use the basic functionality of most programs. In the next
lecture, we will talk about how to perform and automate more complex
tasks using the shell and the many handy command-line programs out
there.

# Exercises

 1. Create a new directory called `missing` under `/tmp`.
 1. Look up the `touch` program. The `man` program is your friend.
 1. Use `touch` to create a new file called `semester` in `missing`.
 1. Write the following into that file, one line at a time:
    ```
    #!/bin/sh
    curl --head --silent https://missing.csail.mit.edu
    ```
    The first line might be tricky to get working. It's helpful to know that
    `#` starts a comment in Bash, and `!` has a special meaning even within
    double-quoted (`"`) strings. Bash treats single-quoted strings (`'`)
    differently: they will do the trick in this case. See the Bash
    [quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html)
    manual page for more information.
 1. Try to execute the file, i.e. type the path to the script (`./semester`)
    into your shell and press enter. Understand why it doesn't work by
    consulting the output of `ls` (hint: look at the permission bits of the
    file).
 1. Run the command by explicitly starting the `sh` interpreter, and giving it
    the file `semester` as the first argument, i.e. `sh semester`. Why does
    this work, while `./semester` didn't?
 1. Look up the `chmod` program (e.g. use `man chmod`).
 1. Use `chmod` to make it possible to run the command `./semester` rather than
    having to type `sh semester`. How does your shell know that the file is
    supposed to be interpreted using `sh`? See this page on the
    [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) line for more
    information.
 1. Use `|` and `>` to write the "last modified" date output by
    `semester` into a file called `last-modified.txt` in your home
    directory.
 1. Write a command that reads out your laptop battery's power level or your
    desktop machine's CPU temperature from `/sys`. Note: if you're a macOS
    user, your OS doesn't have sysfs, so you can skip this exercise.
