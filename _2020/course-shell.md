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

## Navigating in the shell

A path on the shell is a delimited list of directories; separated by `/`
on Linux and macOS and `\` on Windows. On Linux and macOS, the path `/`
is the "root" of the file system, under which all directories and files
lie, whereas on Windows there is one root for each disk partition (e.g.,
`C:\`). We will generally assume that you are using a Linux filesystem
in this class. A path that starts with `/` is called an _absolute_ path.
Any other path is a _relative_ path. Relative paths are relative to the
current working directory, which we can see with the `pwd` command and
change with the `cd` command. In a path, `.` refers to the current
directory, and `..` to its parent directory:

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

Notice that our shell prompt kept us informed about what our current
working directory was. You can configure your prompt to show you all
sorts of useful information, which we will cover in a later lecture.

In general, when we run a program, it will operate in the current
directory unless we tell it otherwise. For example, it will usually
search for files there, and create new files there if it needs to.

To see what lives in a given directory, we use the `ls` command:

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

Unless a directory is given as its first argument, `ls` will print the
contents of the current directory. Most commands accept flags and
options (flags with values) that start with `-` to modify their
behavior. Usually, running a program with the `-h` or `--help` flag
(`/?` on Windows) will print some help text that tells you what flags
and options are available. For example, `ls --help` tells us:

```
  -l                         use a long listing format
```

```console
missing:~$ ls -l /home
drwxr-xr-x 1 missing  users  4096 Jun 15  2019 missing
```

This gives us a bunch more information about each file or directory
present. First, the `d` at the beginning of the line tells us that
`missing` is a directory. Then follow three groups of three characters
(`rwx`). These indicate what permissions the owner of the file
(`missing`), the owning group (`users`), and everyone else respectively
have on the relevant item. A `-` indicates that the given principal does
not have the given permission. Above, only the owner is allowed to
modify (`w`) the `missing` directory (i.e., add/remove files in it). To
enter a directory, a user must have "search" (represented by "execute":
`x`) permissions on that directory (and its parents). To list its
contents, a user must have read (`r`) permissions on that directory. For
files, the permissions are as you would expect. Notice that nearly all
the files in `/bin` have the `x` permission set for the last group,
"everyone else", so that anyone can execute those programs.

Some other handy programs to know about at this point are `mv` (to
rename/move a file), `cp` (to copy a file), and `mkdir` (to make a new
directory).

If you ever want _more_ information about a program's arguments, inputs,
outputs, or how it works in general, give the `man` program a try. It
takes as an argument the name of a program, and shows you its _manual
page_. Press `q` to exit.

```console
missing:~$ man ls
```

## Connecting programs

In the shell, programs have two primary "streams" associated with them:
their input stream and their output stream. When the program tries to
read input, it reads from the input stream, and when it prints
something, it prints to its output stream. Normally, a program's input
and output are both your terminal. That is, your keyboard as input and
your screen as output. However, we can also rewire those streams!

The simplest form of redirection is `< file` and `> file`. These let you
rewire the input and output streams of a program to a file respectively:

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

You can also use `>>` to append to a file. Where this kind of
input/output redirection really shines is in the use of _pipes_. The `|`
operator lets you "chain" programs such that the output of one is the
input of another:

```console
missing:~$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2019 var
missing:~$ curl --head --silent google.com | grep --ignore-case content-length | cut --delimiter=' ' -f2
219
```

We will go into a lot more detail about how to take advantage of pipes
in the lecture on data wrangling.

## A versatile and powerful tool

On most Unix-like systems, one user is special: the "root" user. You may
have seen it in the file listings above. The root user is above (almost)
all access restrictions, and can create, read, update, and delete any
file in the system. You will not usually log into your system as the
root user though, since it's too easy to accidentally break something.
Instead, you will be using the `sudo` command. As its name implies, it
lets you "do" something "as su" (short for "super user", or "root").
When you get permission denied errors, it is usually because you need to
do something as root. Though make sure you first double-check that you
really wanted to do it that way!

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
