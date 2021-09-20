---
layout: lecture
title: "Các công cụ của shell và viết ngôn ngữ kịch bản"
date: 2020-01-14
ready: true
video:
  aspect: 56.25
  id: kgII-YWo3Zw
---

Ở trong buổi học này, chúng tôi sẽ trình bày một điều cơ bản trong việc sử dụng bash như một ngôn ngữ kịch và giới thiệu một số công cụ của shell được sử dụng thường xuyên trên môi trường dòng trong các công việc hằng ngày của bạn.
<!-- 
In this lecture, we will present some of the basics of using bash as a scripting language along with a number of shell tools that cover several of the most common tasks that you will be constantly performing in the command line.
 -->

# Shell Scripting - Ngôn ngữ kịch bản Shell 

Chúng ta đã làm quen với việc thực hiện các lệnh bằng shell (vỏ) và pipe (liên kết) chúng lại với nhau thành một quy trình
Tuy nhiên, trong một vài trường hợp, bạn sẽ cần phải thực thi hàng loạt câu lệnh và sử dụng các cấu trúc điều khiển như câu điền kiện hoặc vòng lặp

<!-- So far we have seen how to execute commands in the shell and pipe them together.
However, in many scenarios you will want to perform a series of commands and make use of control flow expressions like conditionals or loops. -->

Ngôn ngữ shell là bước tiếp theo để có thể sử dụng những thứ phức tạp hơn
Hầu hết các shell đều có một ngôn ngữ kịch bản riêng với những cú pháp riêng biệt để tương tác với biến, cấu trúc điều khiển.
Điều đặc biệt khiến ngôn ngữ shell khác biệt khi so sánh chúng với các ngôn ngữ kịch bản khác chính là ngôn ngữ shell đã được tối ưu cho việc thực thi các tác vụ liên quan tới shell (ở môi trường dòng lệnh)
Do đó, việc tạo quy trình cho lệnh, lưu kết quả vào file, đọc dữ liệu từ thiết bị nhập chuẩn là những thứ nguyên thuỷ trong khi viết shell, điều này khiến shell script dễ dàng để sử dụng hơn là những ngôn ngũ kịch bản tổng quát
Ở trong phần này chúng ta sẽ sử dụng bash để lập trình shell vì bash rất phổ biến

_Ghi chú (người dịch):
- pipeline: Đối với ngành khoa học máy tính, một pipeline là một sự liên kết các tác vụ được sắp xếp sao cho đầu ra của một tác vụ trong quy trình sẽ là đầu vào của tác vụ tiếp theo. Các bạn có thể hiểu pipeline là quy trình. pipe là cách kết nối các tác vụ để tạo nên một pipeline. Trong ngữ cảnh của shell, các tác vụ này có thể hiểu đơn giản là các command (lệnh)
_

<!-- Shell scripts are the next step in complexity.
Most shells have their own scripting language with variables, control flow and its own syntax.
What makes shell scripting different from other scripting programming language is that it is optimized for performing shell-related tasks.
Thus, creating command pipelines, saving results into files, and reading from standard input are primitives in shell scripting, which makes it easier to use than general purpose scripting languages.
For this section we will focus on bash scripting since it is the most common. -->

Để gán giá trị cho biến bằng bash, sử dụng cú pháp `foo=bar` và truy cập giá trị của biến bằng cú pháp `$foo`
Lưu ý `foo = bar` sẽ không chạy bởi vì câu lệnh sẽ được biên dịch thành việc gọi chương trình `foo` với đối số là `=` và `bar`
Tóm lại, dấu khoảng cách đóng vai trò phân cách các đối số trong các ngôn ngữ shell. Việc này có thể sẽ hơi khó hiểu và gây nhầm lẫn ở giai đoạn đầu, nên hãy luôn kiểm tra việc này.

Chuỗi có thể được khai báo bằng dấu ngăn cách `'` và `"` trong bash, nhưng chúng không bằng nhau
Chuỗi được khai báo bằng `'` là chuỗi theo nghĩa đen (giá trị cụ thể) và sẽ không được thay thế bằng các giá trị của biến, trong khi chuỗi được khai báo bằng `"` thì có. 

<!-- To assign variables in bash, use the syntax `foo=bar` and access the value of the variable with `$foo`.
Note that `foo = bar` will not work since it is interpreted as calling the `foo` program with arguments `=` and `bar`.
In general, in shell scripts the space character will perform argument splitting. This behavior can be confusing to use at first, so always check for that.

Strings in bash can be defined with `'` and `"` delimiters, but they are not equivalent.
Strings delimited with `'` are literal strings and will not substitute variable values whereas `"` delimited strings will. -->

```bash
foo=bar
echo "$foo"
# prints bar
echo '$foo'
# prints $foo
```

Như hầu hết các ngôn ngữ lập trình khác, bash cũng hỗ trợ các cấu trúc điều khiển như `if`, `case`, `while` và `for`
Và tất nhiên, `bash` hỗ trợ các hàm nhận vào các đối số và thực hiện các tác vụ. Đây là một ví dụ về hàm có chức năng là tạo một thư mục và `cd` vào no`

<!-- As with most programming languages, bash supports control flow techniques including `if`, `case`, `while` and `for`.
Similarly, `bash` has functions that take arguments and can operate with them. Here is an example of a function that creates a directory and `cd`s into it. -->


```bash
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```

Ở đây `$1` mang ý nghĩa là đối số được truyền vào đầu tiên cho hàm
Không như các ngôn ngữ khác, `bash` sử dụng một tập hợp các biến đặc biệt để chỉ đến các đối số, mã lỗi và các biến liên quan. Ở dưới là một danh sách của chúng. Các bạn có thể tìm một danh sách đầy đủ và chi tiết hơn ở [đây](https://www.tldp.org/LDP/abs/html/special-chars.html)

- `$0` - Tên của shell hoặc tên của shell script
- `$1` tới `$9` - Các đối số của lệnh `$1` is the first argument and so on.
- `$@` - Tất cả đối số
- `$#` - Số lượng đối số
- `$?` - Mã kết quả của lệnh trước (thành công hay thất bại)
- `$$` - PID (Process identification number ) của lệnh
- `!!` - Chỉ đến lệnh phía trước, tính cả tham số. Một cách sử dụng cơ bản của nó là thực hiện lệnh nếu lệnh trước đó thất bại bởi vì thiếu quyền truy cập(permission denied). Bạn có thể tái thực hiện lệnh với quyền sudo bằng cách `sudo !!`
- `$_` - Đối số cuối cùng của lệnh phía trước. nếu bạn đang sử dụng shell bằng chế độ tương tác trực tiếp, bạn có thể lấy giá trị này bằng việc gõ `Esc` và `.`

Các lệnh thường sẽ trả về kết quả ở `STDOUT`, lỗi ở `STDERR`, và một mã kết quả phục vụ cho mục đích lập trình
Mã kết quả hoặc mã kết thúc (return code or exit status) là cách để các đoạn mã/lệnh tương tác với nhau nhằm xác định việc thực thi như thế nào
Giá trị của mã kết thúc là 0 biểu hiện mọi thứ vẫn bình thường; mọi thức khác 0 nghĩa là có lỗi xảy ra.

Mã kết thúc có thể được sử dụng để xử lý điều kiện thực hiện các lệnh tiếp theo bằng việc sử dụng toán tử `&&` và `||` (toán tử `and` và `or` ), cả 2 điều là toán tử  [short-circuiting](https://en.wikipedia.org/wiki/Short-circuit_evaluation). Các lệnh có thể được ngăn cách với nhau trên cùng một dòng sử dụng dấu `;` (semicolon-chấm phẩy). Lệnh `true` sẽ luôn trả về mã kết thúc là 0 và lệnh `false` sẽ luôn trả về mã kết thúc là 1 
Xem một vài ví dụ sau:


_PID:
short-circuiting
STDIN
STDOUT_

<!-- 
Here `$1` is the first argument to the script/function.
Unlike other scripting languages, bash uses a variety of special variables to refer to arguments, error codes, and other relevant variables. Below is a list of some of them. A more comprehensive list can be found [here](https://www.tldp.org/LDP/abs/html/special-chars.html).
- `$0` - Name of the script
- `$1` to `$9` - Arguments to the script. `$1` is the first argument and so on.
- `$@` - All the arguments
- `$#` - Number of arguments
- `$?` - Return code of the previous command
- `$$` - Process identification number (PID) for the current script
- `!!` - Entire last command, including arguments. A common pattern is to execute a command only for it to fail due to missing permissions; you can quickly re-execute the command with sudo by doing `sudo !!`
- `$_` - Last argument from the last command. If you are in an interactive shell, you can also quickly get this value by typing `Esc` followed by `.`

Commands will often return output using `STDOUT`, errors through `STDERR`, and a Return Code to report errors in a more script-friendly manner.
The return code or exit status is the way scripts/commands have to communicate how execution went.
A value of 0 usually means everything went OK; anything different from 0 means an error occurred.

Exit codes can be used to conditionally execute commands using `&&` (and operator) and `||` (or operator), both of which are [short-circuiting](https://en.wikipedia.org/wiki/Short-circuit_evaluation) operators. Commands can also be separated within the same line using a semicolon `;`.
The `true` program will always have a 0 return code and the `false` command will always have a 1 return code.
Let's see some examples -->

```bash
false || echo "Oops, fail"
# Oops, fail

true || echo "Will not be printed"
#

true && echo "Things went well"
# Things went well

false && echo "Will not be printed"
#

true ; echo "This will always run"
# This will always run

false ; echo "This will always run"
# This will always run
```

Một ứng dụngng khác là lưu trữ giá trị đầu ra của một lệnh vào một biến. Việc này có thể thực hiện bằng việc sử dụng _command substitution_. 
Bất cứ khi nào bạn sử dụng cú pháp `$( CMD )`, shell sẽ thực thi lệnh `CMD` và sau đó lấy kết quả được trả về và thay thế tại chỗ.
Ví dụ, đối với lệnh sau `for file in $(ls)`, shell thưc thi lện `$(ls)` trước và sau đó mới thực hiện lặp qua từng giá trị.
Một ứng dụng tương đương nhưng ít phổ biến hơn là _process substitution_, `<( CMD )` sẽ thực thi lệnh `CMD` và lưu trữ giá trị của kết quả vào một file tạm thời và thay thế bằng tên file tạm thời đó. Điều này rất hữu dụng khi những lệnh đọc dữ liệu từ file thay vì thiết bị nhập chuẩn STDIN. 
Ví dụ `diff <(ls foo) <(ls bar)` sẽ chỉ ra những files khác nhau trong 2 thư mục `foo` và `bar`

Bỏi vì có quá nhiều kiến thức, hãy xem các trường hợp cụ thể của các trường hợp trên. Đoạn mã sẽ lặp qua các đối số được cung cấp, thực thi lệnh `grep` để so sánh đối số với chuỗi `foobar`, và thêm chuỗi `foobar` này vào file như là 1 dòng comment nếu trong file không có từ bất kỳ chuỗi `foobar`.

<!-- Another common pattern is wanting to get the output of a command as a variable. This can be done with _command substitution_.
Whenever you place `$( CMD )` it will execute `CMD`, get the output of the command and substitute it in place.
For example, if you do `for file in $(ls)`, the shell will first call `ls` and then iterate over those values.
A lesser known similar feature is _process substitution_, `<( CMD )` will execute `CMD` and place the output in a temporary file and substitute the `<()` with that file's name. This is useful when commands expect values to be passed by file instead of by STDIN. For example, `diff <(ls foo) <(ls bar)` will show differences between files in dirs  `foo` and `bar`.


Since that was a huge information dump, let's see an example that showcases some of these features. It will iterate through the arguments we provide, `grep` for the string `foobar`, and append it to the file as a comment if it's not found. -->

```bash
#!/bin/bash

echo "Starting program at $(date)" # Date will be substituted

echo "Running program $0 with $# arguments with pid $$"

for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    # When pattern is not found, grep has exit status 1
    # We redirect STDOUT and STDERR to a null register since we do not care about them
    if [[ $? -ne 0 ]]; then
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
done
```

Câu lệnh điều kiện kiểm tra giá trị của biến `$?` khác 0.
Bash đã cài đặt rất nhiều lệnh so sánh - chi tiết có thể tham khảo ở danh sách đầy đủ ở trang web manpage dành cho việc kiểm tra ở [đây](https://www.man7.org/linux/man-pages/man1/test.1.html)
Khi thực hiện lệnh so sánh, cố gắng sử dụng 2 cặp dấu ngoặc vuông `[[ ]]` thay vì chỉ 1 `[ ]`.Điều này sẽ giảm tỉ lệ lỗi xuống mặc dù điều này không tương thcih1 với `sh`. Giải thích chi tiết có thể tìm ở [đây](http://mywiki.wooledge.org/BashFAQ/031)
Khi mã nguồn được thực thi, việc truyền nhiều đối số tương tự nhau khá phổ biến. Bash cung cấp cách để làm cho mọi chuyện đơn giản hơn, khả năng expanding expressions (mở rộng biểu thức) bằng việc gom nhóm các filename expansion (định dạng mở rộng của file). Kỹ thuật này được gọi là _shell globbing_ 
- Wildcards - Khi nào cần sử dụng các loại wildcard matching, `?` và `*` được sử dụng tìm kiểm 1 hoặc bất kỳ số lượng các ký tự, theo thư tự. Ví dụ, có các file sau `foo`, `foo1`, `foo2`, `foo10` và `bar`, lệnh `rm foo?` sẽ xoá  `foo1` and `foo2` trong khi đó `rm foo*` sẽ xoá tất cả ngoại trừ file `bar`.
- Cặp dấu ngoặc nhọn `{}` - Khi có các chuỗi tương tự nhau làm tham số cho nhiều lệnh, bạn có thể sử dụng cặp dấu ngoặc nhọn để mở rộng tự động. Điều này rất phổ biến khi di chuyển, chuyển đổi các files

_wildcard_

<!-- 
In the comparison we tested whether `$?` was not equal to 0.
Bash implements many comparisons of this sort - you can find a detailed list in the manpage for [`test`](https://www.man7.org/linux/man-pages/man1/test.1.html).
When performing comparisons in bash, try to use double brackets `[[ ]]` in favor of simple brackets `[ ]`. Chances of making mistakes are lower although it won't be portable to `sh`. A more detailed explanation can be found [here](http://mywiki.wooledge.org/BashFAQ/031).

When launching scripts, you will often want to provide arguments that are similar. Bash has ways of making this easier, expanding expressions by carrying out filename expansion. These techniques are often referred to as shell _globbing_.
- Wildcards - Whenever you want to perform some sort of wildcard matching, you can use `?` and `*` to match one or any amount of characters respectively. For instance, given files `foo`, `foo1`, `foo2`, `foo10` and `bar`, the command `rm foo?` will delete `foo1` and `foo2` whereas `rm foo*` will delete all but `bar`.
- Curly braces `{}` - Whenever you have a common substring in a series of commands, you can use curly braces for bash to expand this automatically. This comes in very handy when moving or converting files. -->


```bash
convert image.{png,jpg}
# Will expand to
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# Will expand to
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# Globbing techniques can also be combined
mv *{.py,.sh} folder
# Will move all *.py and *.sh files


mkdir foo bar
# This creates files foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h
touch {foo,bar}/{a..h}
touch foo/x bar/y
# Show differences between files in foo and bar
diff <(ls foo) <(ls bar)
# Outputs
# < x
# ---
# > y
```

Viết mã `bash` đôi khi khó khăn và không trực quan. Có một vài công cụ như [shellcheck](https://github.com/koalaman/shellcheck) giúp chúng ta tìm lỗi ở trong mã sh/bash của bạn.

Lưu ý rằng mã không nhất thiết phải được viết ở bằng bash thì mới có thể chạy được ở giao diện dòng lệnh. Đây là một đoạn mã Python sẽ trả về kết quả là các tham số được truyền vào với thứ tự nghịch đảo 

<!-- Câu này được comment trong bản gốc => không dịch-->
<!-- Lastly, pipes `|` are a core feature of scripting. Pipes connect one program's output to the next program's input. We will cover them more in detail in the data wrangling lecture. -->
<!-- 
Writing `bash` scripts can be tricky and unintuitive. There are tools like [shellcheck](https://github.com/koalaman/shellcheck) that will help you find errors in your sh/bash scripts.

Note that scripts need not necessarily be written in bash to be called from the terminal. For instance, here's a simple Python script that outputs its arguments in reversed order: -->

```python
#!/usr/local/bin/python
import sys
for arg in reversed(sys.argv[1:]):
    print(arg)
```
Kernel biết cách làm thế nào để có thể thực thi một đoạn mã sử dụng trình biên dịch của python thay vì shell bởi vì chúng ta đã đính kèm dấu [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) ở đầu file script
Đây là một ví dụ tốt để viết `shebang` bằng lệnh [`env`](https://www.man7.org/linux/man-pages/man1/env.1.html) để có thể giải quyết trường hợp nơi lưu trữ cách lệnh trong hệ thống, tằng cường khả năng di động của mã. Để xử lý vị trí, `env` sẽ sử dụng biến môi trường `PATH` đã được giới thiệu ở bài đầu tiên.
Ví dụ, dòng `shebang` sẽ trông như thế này `#!/usr/bin/env python`.

Một vài điều khác biệt giữa function (hàm) và script (mã) của shell cần ghi nhớ:
- Hàm phải được viết bằng ngôn ngữ của shell, còn script thì có thể viết bằng bất cứ ngôn ngữ nào. Đây là lý do lại sao shebang lại quan trọng trong các script 
- Hàm sẽ được tải khi định nghĩa của nó được đọc. Script thì được tải mỗi khi nó được thực thi. Điều này khiến cho việc tải function nhanh hơn một chút, tuy nhiên nếu có sự thay đổi trong hàm thì cần phải tải lại định nghĩa hàm
- Hàm được thực thi trong tại môi trường shell đang chạy, còn script thì được được chạy ở một tiến trình (process) riêng. Cho nên, functions có thể thay đổi các biến môi trường của shell, ví dụ như là thư mục hiện hành, trong khi script thì không thể. Các script có thể truy cập tới các biến môi đã được export bằng việc sử dụng [`export`](https://www.man7.org/linux/man-pages/man1/export.1p.html)
- Giống như các ngôn ngữ lập trình khác, hàm là phương pháp mạnh mẽ để đạt được khả năng mô-đun, tái sử dụng, minh bạch của mã shell. Thông thường thì các script sẽ có bao gồm các định nghĩa hàm 

<!-- 
The kernel knows to execute this script with a python interpreter instead of a shell command because we included a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) line at the top of the script.
It is good practice to write shebang lines using the [`env`](https://www.man7.org/linux/man-pages/man1/env.1.html) command that will resolve to wherever the command lives in the system, increasing the portability of your scripts. To resolve the location, `env` will make use of the `PATH` environment variable we introduced in the first lecture.
For this example the shebang line would look like `#!/usr/bin/env python`.

Some differences between shell functions and scripts that you should keep in mind are:
- Functions have to be in the same language as the shell, while scripts can be written in any language. This is why including a shebang for scripts is important.
- Functions are loaded once when their definition is read. Scripts are loaded every time they are executed. This makes functions slightly faster to load, but whenever you change them you will have to reload their definition.
- Functions are executed in the current shell environment whereas scripts execute in their own process. Thus, functions can modify environment variables, e.g. change your current directory, whereas scripts can't. Scripts will be passed by value environment variables that have been exported using [`export`](https://www.man7.org/linux/man-pages/man1/export.1p.html)
- As with any programming language, functions are a powerful construct to achieve modularity, code reuse, and clarity of shell code. Often shell scripts will include their own function definitions. -->

# Công cụ của shell 

## Cách sử dụng lệnh

Tại thời điểm này, bạn có thể đang tự hỏi rằng làm thế nào để tìm các tuỳ chọn (flags) dành cho các lệnh giống như `ls -l`, `mv -i` and `mkdir -p`.
Tổng quát hơn, đối với một lệnh, làm sao ta có thể tìm ra các chức năng của chúng và cái tuỳ chọn tương ứng?
Chúng ta có thể bắt đầu tìm google cho câu hỏi này, tuy nhiên UNIX thì có trước cả StackOverflow, và có 1 cách truyền thống để lấy các thông tin này.

Như chúng ta đã biết ở trong bài đầu tiên, cách tiếp cận đầu tiên là gọi lệnh với với tuỳ chọn `-h` hoặc `--help`. Cách tiếp cận chi tiết hơn là sử dũng lệnh `man`
Viết ngắn gọn của từ `manual`,  [`man`](https://www.man7.org/linux/man-pages/man1/man.1.html) cung cấp 1 trang hướng dẫn sử dụng (gọi là manpage) cho một lệnh bất kỳ. 
Ví dụ `man rm` sẽ trả về tất cả các tác vụ của lệnh `rm` cùng với các tuỳ chọn mà lệnh cung cấp, cùng với tuỳ chọn `-i` đã được giới thiệu trước đó
Thực tế, thứ mà tôi đã kết nối từ trước đây cho tất cả các lệnh là một phiên bản trực tuyến của Linux manpage cho nhiều lệnh. 
Thậm chí những lệnh không có sẵn mà bạn cần phải cài đặt cũng có một trang manpage nếu lập trình viên có viết chùng và đóng gói chúng cùng quá trình cài đặt.
Đối với những công cụ tương tác trực tiếp ví dụ như những thứ dựa trên `ncurses`, hướng dẫn sử dụng của các lệnh thường được truy cập ngay trong chương trình bằng việc viết `:help` hoặc `?`

Đôi khi các trang manpages có thể cung cấp rất nhiều thông tin chi tiết mô tả về lệnh, khiến nó trở lên khó để xác định xem những tuỳ chọn/ cú pháp nào để sử dụng trong các trường hợp cơ bản.[TLDR pages](https://tldr.sh/) là một giải pháp đơn giản, tập trung vào việc đưa ra các ví dụ cụ thể và trường hợp của từng lệnh khiến cho bạn nhanh chóng nhận ra các tuỳ chọn nào cần thiết 
Cụ thể hơn, tôi thường hay sử dụng trang `tldr` cho các lệnh [`tar`](https://tldr.ostera.io/tar) và [`ffmpeg`](https://tldr.ostera.io/ffmpeg) hơn là manpages

<!-- 
At this point, you might be wondering how to find the flags for the commands in the aliasing section such as `ls -l`, `mv -i` and `mkdir -p`.
More generally, given a command, how do you go about finding out what it does and its different options?
You could always start googling, but since UNIX predates StackOverflow, there are built-in ways of getting this information.

As we saw in the shell lecture, the first-order approach is to call said command with the `-h` or `--help` flags. A more detailed approach is to use the `man` command.
Short for manual, [`man`](https://www.man7.org/linux/man-pages/man1/man.1.html) provides a manual page (called manpage) for a command you specify.
For example, `man rm` will output the behavior of the `rm` command along with the flags that it takes, including the `-i` flag we showed earlier.
In fact, what I have been linking so far for every command is the online version of the Linux manpages for the commands.
Even non-native commands that you install will have manpage entries if the developer wrote them and included them as part of the installation process.
For interactive tools such as the ones based on ncurses, help for the commands can often be accessed within the program using the `:help` command or typing `?`.

Sometimes manpages can provide overly detailed descriptions of the commands, making it hard to decipher what flags/syntax to use for common use cases.
[TLDR pages](https://tldr.sh/) are a nifty complementary solution that focuses on giving example use cases of a command so you can quickly figure out which options to use.
For instance, I find myself referring back to the tldr pages for [`tar`](https://tldr.ostera.io/tar) and [`ffmpeg`](https://tldr.ostera.io/ffmpeg) way more often than the manpages. -->


## Finding files

Một trong các công việc thường xuyên lặp đi lặp lại đối với lập trình viên là tìm files hoặc thư mục
Các hệ thông dựa trên UNIX thường có sẵn lệnh [`find`](https://www.man7.org/linux/man-pages/man1/find.1.html), một công cụ tuyệt vời của shell để tìm kiếm file. `find` sẽ tìm kiếm đệ quy các file có tên khớp với một vài tiêu chuẩn nào đó  

<!-- One of the most common repetitive tasks that every programmer faces is finding files or directories.
All UNIX-like systems come packaged with [`find`](https://www.man7.org/linux/man-pages/man1/find.1.html), a great shell tool to find files. `find` will recursively search for files matching some criteria. Some examples: -->

```bash
# Find all directories named src
find . -name src -type d
# Find all python files that have a folder named test in their path
find . -path '*/test/*.py' -type f
# Find all files modified in the last day
find . -mtime -1
# Find all zip files with size in range 500k to 10M
find . -size +500k -size -10M -name '*.tar.gz'
```
Beyond listing files, find can also perform actions over files that match your query.
This property can be incredibly helpful to simplify what could be fairly monotonous tasks.
```bash
# Delete all files with .tmp extension
find . -name '*.tmp' -exec rm {} \;
# Find all PNG files and convert them to JPG
find . -name '*.png' -exec convert {} {}.jpg \;
```
Mặc dù sự phổ biến của `find`, cú pháp của nó thực sự khó để ghi nhớ.
Ví dụ, để thực thiện công việc đợn giản như là tìm kiếm các file có tên trùng với mẫu `PATTERN`, bạn phải viết câu lệnh như thế này `find -name '*PATTERN*'` (hoặc `-iname` nếu bạn muốn mẫu không phân biệt chữ hoa, chữ thường)
Bạn có thể bắt đầu viết một vài bí danh (alias) cho những trường hợp trên, nhưng tư tưởng của shell khuyến khích tìm kiếm những thứ thay thế
Luôn nhớ rằng, một trong những thuộc tính thú vị nhất của shell là bạn chỉ đang gọi những chương trình mà thôi, cho nên bạn có thể tìm (hoặc thậm chí là viết mới) những thứ thay thế cho cùng 1 công việc
Điển hình, [`fd`](https://github.com/sharkdp/fd) là một chương trình đơn giản, nhanh và dễ sử dụng thay thế cho `find`.
Chương trình này hỗ trợ một vài thứ mặc định xịn xò như tô màu kết quả, sử dụng biểu thức chính quy (regex - regular expression), và hỗ trợ unicode. Và tất nhiên, theo quan điểm cá nhân của tôi (tác giả), một cú pháp tốt hơn.
Một trường hợp cụ thể, cú pháp để tìm một mẫu như `PATTERN` là `fd PATTERN`

Hầu hết các ý kiến đều đồng ý rằng `find` và `fd` rất tốt, nhưng chắc một vài người sẽ tự hỏi rằng về độ hiệu quả của việc tìm kiếm so với việc đánh chỉ mục hoặc sử dụng cơ sở dữ liệu cho việc tìm kiếm nhanh.
Và đây là điều mà [`locate`](https://www.man7.org/linux/man-pages/man1/locate.1.html) phát triển.
`locate` sử dụng cơ sở dữ liệu được cập nhật sử dụng [`updatedb`](https://www.man7.org/linux/man-pages/man1/updatedb.1.html).
Trong hầu hết hệ thông, `updatedb` được cập nhật hàng ngày thông qua [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html).
Bởi vì lý do này nên có một sử đánh đổi giữa tốc độ và độ trực tuyến (fresness)
Một điều nữa là `find` và các công cụ tương tự thì có thể tìm kiếm file dựa trên nhiều thuộc tính khác như kích cỡ, ngày chỉnh sửa, quyền hạn, trong khi `locate` chỉ sử dụng tên file
So sánh chi tiết có thể tìm ở [đây](https://unix.stackexchange.com/questions/60205/locate-vs-find-usage-pros-and-cons-of-each-other).

_freshness_

<!-- Despite `find`'s ubiquitousness, its syntax can sometimes be tricky to remember.
For instance, to simply find files that match some pattern `PATTERN` you have to execute `find -name '*PATTERN*'` (or `-iname` if you want the pattern matching to be case insensitive).
You could start building aliases for those scenarios, but part of the shell philosophy is that it is good to explore alternatives.
Remember, one of the best properties of the shell is that you are just calling programs, so you can find (or even write yourself) replacements for some.
For instance, [`fd`](https://github.com/sharkdp/fd) is a simple, fast, and user-friendly alternative to `find`.
It offers some nice defaults like colorized output, default regex matching, and Unicode support. It also has, in my opinion, a more intuitive syntax.
For example, the syntax to find a pattern `PATTERN` is `fd PATTERN`.

Most would agree that `find` and `fd` are good, but some of you might be wondering about the efficiency of looking for files every time versus compiling some sort of index or database for quickly searching.
That is what [`locate`](https://www.man7.org/linux/man-pages/man1/locate.1.html) is for.
`locate` uses a database that is updated using [`updatedb`](https://www.man7.org/linux/man-pages/man1/updatedb.1.html).
In most systems, `updatedb` is updated daily via [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html).
Therefore one trade-off between the two is speed vs freshness.
Moreover `find` and similar tools can also find files using attributes such as file size, modification time, or file permissions, while `locate` just uses the file name.
A more in-depth comparison can be found [here](https://unix.stackexchange.com/questions/60205/locate-vs-find-usage-pros-and-cons-of-each-other). -->

## Finding code
Tìm kiếm file bằng tên khá hữu ích, tuy nhiên thao tác tìm kiếm dựa trên nội dung file cũng cần thiết không kém.
Một trường hợp phổ biến là tìm tất cả các file chứa nhiều hơn một mẫu, cùng với nơi mà kết quả xuất hiện (số dòng)
Để làm việc này, hầu hết hệ thống lõi UNIX đều cung cấp [`grep`](https://www.man7.org/linux/man-pages/man1/grep.1.html), một công cụ giúp tìm kiếm các mẫu dựa trên văn bản đầu vào
`grep` là một công cụ cực kỳ mạnh mà chúng ta sẽ tìm hiểu thêm, chi tiết về nó ở bài sau (data wrangling)

Ở hiện tại, `grep` cung cấp rất nhiều tuỳ chọn (flags) khiến nó trở nên linh hoat
Một vài tuỳ chọn tôi hay dùng là `-C` để lấy ngữ cảnh kết quả và `-v` để nghịch đảo kết quá, ví dụ, tìm những đoạn không khớp với mẫu. Ví dụ `grep -C 5` sẽ in ra 5 dòng trước và sau kết quả. Khi cần thực hiện việc tìm kiếm nhiều files, bạn có thể sử dụng `-R` bởi vì tuỳ chọn này sẽ đi vào từng file ở trong thư mục và tìm kiếm kết quả 

Nhưng `grep -R` có thể được cải tiến bằng nhiều cách, ví dụ như bỏ qua `.git` folded, sử dụng CPU đa nhân để hỗ trợ, et cetera
Có nhiều công cụ thay thế `grep` dã được phát triển, bao gồm [ack](https://beyondgrep.com/), [ag](https://github.com/ggreer/the_silver_searcher) và [rg](https://github.com/BurntSushi/ripgrep).
Tất cả những công cụ trên rất tuyệt vời và cung cấp cùng chức năng.
Hiện tại tôi đang sử dụng ripgrep `rg`, bởi vì nó rất nhanh và dễ. 
Ví dụ:

<!-- Finding files by name is useful, but quite often you want to search based on file *content*. 
A common scenario is wanting to search for all files that contain some pattern, along with where in those files said pattern occurs.
To achieve this, most UNIX-like systems provide [`grep`](https://www.man7.org/linux/man-pages/man1/grep.1.html), a generic tool for matching patterns from the input text.
`grep` is an incredibly valuable shell tool that we will cover in greater detail during the data wrangling lecture.

For now, know that `grep` has many flags that make it a very versatile tool.
Some I frequently use are `-C` for getting **C**ontext around the matching line and `-v` for in**v**erting the match, i.e. print all lines that do **not** match the pattern. For example, `grep -C 5` will print 5 lines before and after the match.
When it comes to quickly searching through many files, you want to use `-R` since it will **R**ecursively go into directories and look for files for the matching string.

But `grep -R` can be improved in many ways, such as ignoring `.git` folders, using multi CPU support, &c.
Many `grep` alternatives have been developed, including [ack](https://beyondgrep.com/), [ag](https://github.com/ggreer/the_silver_searcher) and [rg](https://github.com/BurntSushi/ripgrep).
All of them are fantastic and pretty much provide the same functionality.
For now I am sticking with ripgrep (`rg`), given how fast and intuitive it is. Some examples: -->

```bash
# Find all python files where I used the requests library
rg -t py 'import requests'
# Find all files (including hidden files) without a shebang line
rg -u --files-without-match "^#!"
# Find all matches of foo and print the following 5 lines
rg foo -A 5
# Print statistics of matches (# of matched lines and files )
rg --stats PATTERN
```

Lưu ý rằng với `find`/`fd`, điều quan trọng là các vấn đề này có thể giải quyết rất là dễ dàng, còn việc sử dụng công cụ nào thì không quan trọng. 

<!-- Note that as with `find`/`fd`, it is important that you know that these problems can be quickly solved using one of these tools, while the specific tools you use are not as important.
 -->

## Finding shell commands
Chúng ta tìm hiểu việc tìm kiếm các files và code, khi bắt đầu sử dụng shell nhiều hơn, bạn có thể muốn tìm các lệnh mà đã gõ ở vài thời điểm.
Điều đầu tiên cần phải biết đó là mũi tên lên sẽ trả về bạn lệnh cuối cùng, và nếu bạn giữ nó thì nó sẽ từ từ duyệt qua lịch sử shell của bạn

Lệnh `history` sẽ giúp bạn truy cập tới lịch sử của shell .
Nó sẽ in ra thiết bị xuất chuẩn lịch sử của shell
Nếu bạn muốn tìm kiếm lịch sử, ta có thể nối đầu ra với `grep` để thực hiện việc tìm kiếm
`history | grep find` sẽ in ra các lệnh có chứa chuỗi "find" 

Trong hầu hết các shell, bạn có thể sử dụng `Ctrl+R` để thực hiện việc tìm kiếm lịch sử
Sau khi nhấn phím `Ctrl+R`, bạn có thể nhập một chuổi mà bạn muốn tìm kiếm ở trong lịch sử
Và nếu bạn tiếp tục giữ phím, bạn sẽ đi vào vòng lặp các kết quả
Điều này cũng có làm được bằng việc nhấn phím UP/DOWN (mũi tên lên/xuống) đối với [zsh](https://github.com/zsh-users/zsh-history-substring-search)

Một điều thú vị là `Ctrl+R` là sử dụng [fzf](https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#ctrl-r).
`fzf` là một công cụ tìm kiếm tổng quát có thể được sử dụng với rất nhiều lệnh khác.
Do đó, nó được sử dụng để tìm kiếm nhanh chóng dựa trên lịch sử của bạn và hiển thị kết quả một cách tiện lợi và dễ nhìn.

Một thứ hay ho về lịch sử shell nữa mà tôi rất thích đó là  **gợi ý tự động dựa trên lịch sử** (**history-based autosuggestion**)
Lần đàu được giới thiệu bởi [fish](https://fishshell.com/), tính năng này sẽ giúp bạn hoàn thành lệnh shell hiện tại dựa trên lịch sử các lệnh gần nhất có các điểm chung.
Tính năng này có thể được kích hoạt ở [zsh](https://github.com/zsh-users/zsh-autosuggestions) và nó sẽ giúp cuộc đời bạn dễ dàng hơn khi làm việc với shell.

Bạn cũng có thể tuỳ chỉnh các hành vi của lịch sử, ví dụ chặn các lệnh có các dấu khoảng trắng dư thừa. Điều này sẽ có ích khi nhập mật khẩu hoặc các thông tin nhạy cảm khác. Để kích hoạt chức năng này, thêm `HISTCONTROL=ignorespace` vào file `.bashrc` hoặc `setopt HIST_IGNORE_SPACE` vào file `.zshrc` 
Nếu có sai sót không thêm khoảng cách thừa, bạn có thể xoá thủ công các chúng ở trong `.bash_history` hoặc `.zhistory`


<!-- So far we have seen how to find files and code, but as you start spending more time in the shell, you may want to find specific commands you typed at some point.
The first thing to know is that typing the up arrow will give you back your last command, and if you keep pressing it you will slowly go through your shell history.

The `history` command will let you access your shell history programmatically.
It will print your shell history to the standard output.
If we want to search there we can pipe that output to `grep` and search for patterns.
`history | grep find` will print commands that contain the substring "find".

In most shells, you can make use of `Ctrl+R` to perform backwards search through your history.
After pressing `Ctrl+R`, you can type a substring you want to match for commands in your history.
As you keep pressing it, you will cycle through the matches in your history.
This can also be enabled with the UP/DOWN arrows in [zsh](https://github.com/zsh-users/zsh-history-substring-search).
A nice addition on top of `Ctrl+R` comes with using [fzf](https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#ctrl-r) bindings.
`fzf` is a general-purpose fuzzy finder that can be used with many commands.
Here it is used to fuzzily match through your history and present results in a convenient and visually pleasing manner.

Another cool history-related trick I really enjoy is **history-based autosuggestions**.
First introduced by the [fish](https://fishshell.com/) shell, this feature dynamically autocompletes your current shell command with the most recent command that you typed that shares a common prefix with it.
It can be enabled in [zsh](https://github.com/zsh-users/zsh-autosuggestions) and it is a great quality of life trick for your shell.

You can modify your shell's history behavior, like preventing commands with a leading space from being included. This comes in handy when you are typing commands with passwords or other bits of sensitive information.
To do this, add `HISTCONTROL=ignorespace` to your `.bashrc` or `setopt HIST_IGNORE_SPACE` to your `.zshrc`.
If you make the mistake of not adding the leading space, you can always manually remove the entry by editing your `.bash_history` or `.zhistory`. -->

## Directory Navigation
Ở đoạn trước, chúng ta đã mạc định rằng chúng ta đang ở đúng nơi cần thực hiện các tác vụ đó. Tuy nhiên làm thể để nào để di chuyển nhanh chóng giữa các thư mục
Có rất nhiều cách đơn giản cho bạn thử, ví dụ như viết một alias hoặc tạo symlink sử dụng [ln -s](https://www.man7.org/linux/man-pages/man1/ln.1.html), nhưng thực tế rằng là các lập trình viên tìm ra cách thông minh và đầy chất xám hơn tại thời điểm hiện tại.

Với phương châm của khoá học này, bạn sẽ đối mặt với những tình huống phổ biến nhất.
Tìm những file và/hoặc thư mục thường xuyên được sử dụng có thể được được xử lý bằng [`fasd`](https://github.com/clvv/fasd) và[`autojump`](https://github.com/wting/autojump).
Fasd xếp hạng các files và thư mục dựa trên [_frecency_](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/Places/Frecency_algorithm), nghĩa là , cả 2 _tần số_ và _gần đây_
Mặc định, `fasd` thêm một lệnh `z` mà bạn có thể dủng để có thể nhanh chóng `cd` chỉ với một chuỗi của thự mục _frecent_. Ví dụ Nếu bạn thường xuyên di chuyển tới `/home/user/files/cool_project` thì bạn chỉ đơn giản là sử dụng `z cool` để di chuyển tới đó. Sử dụng `autojump` thì cú pháp tương tự sẽ là `j cool`

Một vài công cụ giúp bạn nhanh chóng nắm bắt được cấu trúc thư mục : [`tree`](https://linux.die.net/man/1/tree), [`broot`](https://github.com/Canop/broot) thậm chí là một trình quản lý file toàn diện như [`nnn`](https://github.com/jarun/nnn) hoặc [`ranger`](https://github.com/ranger/ranger)

So far, we have assumed that you are already where you need to be to perform these actions. But how do you go about quickly navigating directories?
There are many simple ways that you could do this, such as writing shell aliases or creating symlinks with [ln -s](https://www.man7.org/linux/man-pages/man1/ln.1.html), but the truth is that developers have figured out quite clever and sophisticated solutions by now.

As with the theme of this course, you often want to optimize for the common case.
Finding frequent and/or recent files and directories can be done through tools like [`fasd`](https://github.com/clvv/fasd) and [`autojump`](https://github.com/wting/autojump).
Fasd ranks files and directories by [_frecency_](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/Places/Frecency_algorithm), that is, by both _frequency_ and _recency_.
By default, `fasd` adds a `z` command that you can use to quickly `cd` using a substring of a _frecent_ directory. For example, if you often go to `/home/user/files/cool_project` you can simply use `z cool` to jump there. Using autojump, this same change of directory could be accomplished using `j cool`.

More complex tools exist to quickly get an overview of a directory structure: [`tree`](https://linux.die.net/man/1/tree), [`broot`](https://github.com/Canop/broot) or even full fledged file managers like [`nnn`](https://github.com/jarun/nnn) or [`ranger`](https://github.com/ranger/ranger).

# Exercises

1. Read [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) and write an `ls` command that lists files in the following manner

    - Includes all files, including hidden files
    - Sizes are listed in human readable format (e.g. 454M instead of 454279954)
    - Files are ordered by recency
    - Output is colorized

    A sample output would look like this

    ```
    -rw-r--r--   1 user group 1.1M Jan 14 09:53 baz
    drwxr-xr-x   5 user group  160 Jan 14 09:53 .
    -rw-r--r--   1 user group  514 Jan 14 06:42 bar
    -rw-r--r--   1 user group 106M Jan 13 12:12 foo
    drwx------+ 47 user group 1.5K Jan 12 18:08 ..
    ```

{% comment %}
ls -lath --color=auto
{% endcomment %}

1. Write bash functions  `marco` and `polo` that do the following.
Whenever you execute `marco` the current working directory should be saved in some manner, then when you execute `polo`, no matter what directory you are in, `polo` should `cd` you back to the directory where you executed `marco`.
For ease of debugging you can write the code in a file `marco.sh` and (re)load the definitions to your shell by executing `source marco.sh`.

{% comment %}
marco() {
    export MARCO=$(pwd)
}

polo() {
    cd "$MARCO"
}
{% endcomment %}

1. Say you have a command that fails rarely. In order to debug it you need to capture its output but it can be time consuming to get a failure run.
Write a bash script that runs the following script until it fails and captures its standard output and error streams to files and prints everything at the end.
Bonus points if you can also report how many runs it took for the script to fail.

    ```bash
    #!/usr/bin/env bash

    n=$(( RANDOM % 100 ))

    if [[ n -eq 42 ]]; then
       echo "Something went wrong"
       >&2 echo "The error was using magic numbers"
       exit 1
    fi

    echo "Everything went according to plan"
    ```

{% comment %}
#!/usr/bin/env bash

count=0
until [[ "$?" -ne 0 ]];
do
  count=$((count+1))
  ./random.sh &> out.txt
done

echo "found error after $count runs"
cat out.txt
{% endcomment %}

1. As we covered in the lecture `find`'s `-exec` can be very powerful for performing operations over the files we are searching for.
However, what if we want to do something with **all** the files, like creating a zip file?
As you have seen so far commands will take input from both arguments and STDIN.
When piping commands, we are connecting STDOUT to STDIN, but some commands like `tar` take inputs from arguments.
To bridge this disconnect there's the [`xargs`](https://www.man7.org/linux/man-pages/man1/xargs.1.html) command which will execute a command using STDIN as arguments.
For example `ls | xargs rm` will delete the files in the current directory.

    Your task is to write a command that recursively finds all HTML files in the folder and makes a zip with them. Note that your command should work even if the files have spaces (hint: check `-d` flag for `xargs`).
    {% comment %}
    find . -type f -name "*.html" | xargs -d '\n'  tar -cvzf archive.tar.gz
    {% endcomment %}

    If you're on macOS, note that the default BSD `find` is different from the one included in [GNU coreutils](https://en.wikipedia.org/wiki/List_of_GNU_Core_Utilities_commands). You can use `-print0` on `find` and the `-0` flag on `xargs`. As a macOS user, you should be aware that command-line utilities shipped with macOS may differ from the GNU counterparts; you can install the GNU versions if you like by [using brew](https://formulae.brew.sh/formula/coreutils).

1. (Advanced) Write a command or script to recursively find the most recently modified file in a directory. More generally, can you list all files by recency?
