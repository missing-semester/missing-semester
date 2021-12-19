---
layout: lecture
title: "Trình quản lý phiên bản (Git)"
date: 2020-01-22
ready: true
video:
  aspect: 56.25
  id: 2sjqTHE0zok
---
Hệ thống quản lý phiên bản (Version Control Systems - VCS) là các công cụ để theo dõi những thay đổi trong mã nguồn (hay các thư mục và tập tin). Đúng như tên gọi của chúng, các công cụ này giúp ta lưu giữ lịch sử thay đổi và thậm chí là tạo điều kiện cho việc hợp tác với người khác. Các VCS theo dõi sự thay đổi của các tập và thư mục con bằng cách lưu giữ toàn bộ trạng thái của chúng qua các "snapshot" (cơ sở dữ liệu "ảnh chụp"). Những snapshot này được lưu trong một tập trên cùng hay tập gốc của dự án ta muốn quản lý phiên bản. Ngoài ra các VCS cũng chứa đựng các metadata (thông tin phụ) như tác giả của "snapshot", tin nhắn và giải thích bởi tác giả cho "snapshot" đó, v.v.

Vì sao ta cần các trình quản lý phiên bản? Thập chí ngay khi bạn lập trình cho một dư án cá nhân, VCS có thể cho phép ta xem lại sự thay đổi, mốc thời gian của chúng, lí do cho các thay đổi đó và các tiến trình trên các branch (nhánh) khác nhau của cây lịch sử . Khi làm việc nhóm, đây lại là một công cụ vô cùng hiệu quả để theo dõi thay đổi từ các đồng sự và giải quyết các conflicts (mâu thuẫn) từ thay đổi mã nguồn của ta và họ.

Các VCS hiện đại cũng có thể trả lời các câu hỏi sau một cách dễ dàng và đa phần tự động:

- Ai viết module (mô đun) này
- Dòng mã nguồn này của tập tin này được thay đổi khi nào? Bời ai? Và tại sao nó lại bị thay đổi?
- Trong vòng 1000 thay đổi trở lại đây, khi nào và tại sao một unit test (bài kiểm thử đơn vị) lại không đạt (dù trước đó nó hoạt động).

Mặc dù có nhiều trình VCS, nhưng **Git** là công cụ thông dụng nhất cho việc quản lý phiên bản. Hình ảnh truyện tranh sau từ [XKCD comic](https://xkcd.com/1597/) phần nào cho ta thấy danh tiếng của Git:

![xkcd 1597](https://imgs.xkcd.com/comics/git.png)

(dịch: A - Đây là Git, nó theo dõi việc hợp tác trong các dự án có mã nguồn bằng mộc biểu đồ cây xinh xắn. B - Ngon, thế dùng nó thế nào? A - Tôi không biết. Cứ nhớ các câu lệnh shell này và gõ chúng để cập nhật giữa mã của chúng ta. Nếu có lỗi thì lưu giữ thay đổi của bạn ở chỗ khác, rồi xóa nguyên dự án đó đi và tải về một bản lưu giữ mới toanh...)

Vì giao diện của Git là một dạng leaky abstraction (trừu tượng có rò rĩ), tìm hiểu về cách sử dụng Git theo phương pháp top-down (từ cao xuống thấp, bắt đầu từ giao điện câu lệnh của nó) có thể gây ra vô vàn sự mất phương hướng (đặc biệt cho người mới học). Bạn hoàn toàn có thể học thuộc một loạt các câu lệnh, coi chúng như thần chú và làm theo bức hình trên nếu có gì đó sai.

Mặc dù Git có một giao diện thật sự là tệ hại, triết lý thiệt kế  và hoạt động của nó vô cùng ấn tượng. Trong khi một giao diện tệ hại này cần phải được _học thuộc lòng_, một thiết kế  ấn tượng có thể  được _hiểu tận_. Vì lí do này, chúng ta sẽ học Git theo cách bottom-up (từ dưới lên trên), bắt đầu từ data model (mô hình dữ liệu) rồi sau đó mới đến các câu lệnh. Khi ta đã hiểu mô hình dữ liệu của nó, ta hoàn toàn có thể giải thích cách các câu lênh Git hoạt động (bằng việc thay đổi mô hình dữ liệu trên).

# Mô hình dữ liệu của Git

Có vô vàn cách để thiết kế một VCS. Tuy nhiên Git có một mô hình dữ liệu được thiết kế kỹ càng để tạo nên các tính năng tuyệt vời của một VCS như lưu giữ lịch sử, hỗ trợ các branch và cho phép hợp tác giữa người dùng.
There are many ad-hoc approaches you could take to version control. Git has a
well-thought-out model that enables all the nice features of version control,
like maintaining history, supporting branches, and enabling collaboration.

## Snapshots ("Ảnh chụp")

Git mô phỏng lịch sử của các tập tin và thư mục  nó theo dõi dưới dạng chuỗi các snapshot trong một thư mục top-level (thư mục gốc của dự án). Theo ngôn ngữ của Git, một tập tin được gọi là "blob", và nó chỉ là một đống bytes dự liệu. Thư mục thì lại gọi là "tree" (cây), và nó lưu giữ tên đến các tree hay blob khác (thư mục có thể chứa thư mục con). Một snapshot là cây gốc trên cùng mà ta đang theo dõi. Ví dụ như ta có một cây thư mục như sau:

```
<root> (tree)
|
+- foo (tree)
|  |
|  + bar.txt (blob, nội dung = "hello world")
|
+- baz.txt (blob, nội dung = "git is wonderful")
```

Cây thư mục gốc gồm hai thành phần, một tree (cây con) tên "foo" (và nó chứa một thành phần là blob "bar.txt"), và blob "baz.txt".

## Mô phỏng lịch sử: cách kết nối các snapshot

Các VCS nên kết nối các snapshot như thế nào để có nghĩa? Một mô hình đơn giản đó là linear history (lịch sử tuyến tính). Mô hình lịch sử này cấu thành từ các snapshot theo thứ tự thời gian mà chúng được tạo. Tuy nhiên, vì vô vàn lí do, Git không dùng một mô hình đơn giản như vậy.

Trong Git, lịch sử  được mô phỏng bằng một Directed Acyclic Graph (Đồ thị định hướng không tuần hoàn - DAG). Đấy là một từ phức tạp và đầy toán học, nhưng đừng sợ. Điều này có nghĩa là mỗi snapshot trong Git thì được kết nối, chỉ hướng về một set (tập) các "bố mẹ", những snapshot đi trước nó trong chuỗi thời gian. Gọi là một tập các bố mẹ thay cho một bố hoặc mẹ (như mô hình linear history nói trên) vì một snapshot có thể  có nhiều tổ tiên khác nhau, như trong việc merging (hợp nhất) nhiều branch phát triển song song chẳng hạn.
In Git, a history is a directed acyclic graph (DAG) of snapshots. That may
sound like a fancy math word, but don't be intimidated. All this means is that
each snapshot in Git refers to a set of "parents", the snapshots that preceded
it. It's a set of parents rather than a single parent (as would be the case in
a linear history) because a snapshot might descend from multiple parents, for
example, due to combining (merging) two parallel branches of development.

Các snapshot này được gọi là commit (cam kết). Việc hình dung một history có thể cho ta một thứ như sau:

```
o <-- o <-- o <-- o
            ^
             \
              --- o <-- o
```

Trong bức hình ASCII ở trên, kí tự `o` tượng trưng cho commit (hay snapshot). Các mũi tên chỉ đến bố mẹ của mỗi commit (đó là mối quan hệ "có trước nó", không phải là "có sau nó"). Đến cái commit thứ 3 thì biểu đồ lịch sử được chia làm hai nhánh riêng. Điều này có thể tương ứng với hai chức năng đang được phát triển song song, độc lập với nhau. Trong tương lai, các branch này có thể được hợp nhất tạo nên một snapshot có cả hai chức năng này. Điều này tạo ra một đồ thị lịch sử như sau:

<pre class="highlight">
<code>
o <-- o <-- o <-- o <---- <strong>o</strong>
            ^            /
             \          v
              --- o <-- o
</code>
</pre>

Commit trong Git là bất biến, nghĩa là các lỗi trong commit không thể nào sữa được. Rất may những lỗi này chỉ có nghĩa là các thay đổi đến dòng lịch sử (nội dung của blob hay cấu trúc của tree được theo dõi chẳng hạn) sẽ tạo ra các commit hoàn toàn mới và các references (xem ở phần dưới đây) được cập nhật để chỉ đến các commit vừa tạo (để sửa lỗi sai trong thư mục hay tập tin chẳng hạn).

## Mô hình dữ liệu viết theo pseudocode (mã giả)

Mã giả cho mô hình dữ liệu của git có thể có hình thái như sau:

```
// Một blob hay tập tin là một đống byte
type blob = array<byte>

// Một tree hay thư mục chứa các tập tin và thư mục con
type tree = map<string, tree | blob>

// Một commit có bố mẹ, các thông tin phụ và cây thư mục gốc nó theo dõi 
type commit = struct {
    parents: array<commit>
    author: string
    message: string
    snapshot: tree
}
```

Đây là một mô hình đơn giản và sạch cho lưu giữ lịch sử thay đổi.

## Vật thể  và content-addressing (truy cập địa chỉ từ nội dung)

Một "vật thể" là một blob, tree hay là commit:

```
type object = blob | tree | commit
```

Trong kho lưu trữ dữ liệu của Git, các vật thể đều có thể được xác định và truy cập từ nội dụng của chúng (đúng hơn là kết quả của hàm băm [SHA-1
hash](https://en.wikipedia.org/wiki/SHA-1) trên nội dung của chúng )

```
objects = map<string, object>

def store(object):
    id = sha1(object)
    objects[id] = object

def load(id):
    return objects[id]
```

Các blob, tree và commit giống nhau theo hướng này: chúng là các vật thể. Khi chúng chỉ đến hay tham khảo các vật thể khác, chúng không trực tiếp _lưu trữ_ hay _chứa đựng_ chúng trên đĩa cứng, mà chỉ đến bằng kết quả của hàm băm trên nội dung của các vật thể này.

Ví dụ như, tree gốc của thư mục [trong phần trên](#snapshots) (được hình dung bằng câu lệnh `git cat-file -p 698281bc680d1995c5f4caaf3359721a5a58d48d`) sẽ có dạng nội dung như sau:

```
100644 blob 4448adbf7ecd394f42ae135bbeed9676e894af85    baz.txt
040000 tree c68d233a33c5c06e0340e4c224f0afca87c8ce87    foo
```
Tree gốc này có nội dung là các con trỏ đến nội dung của nó (như trên), rồi `baz.txt` (một blob) và `foo` (một tree). Nếu ta dùng kết quả hàm băm tương ứng với con trỏ tới baz.txt bằng câu lệnh `git cat-file -p 4448adbf7ecd394f42ae135bbeed9676e894af85`, nội dung có được (văn bản trong baz.txt) là như sau:

```
git is wonderful
```

## References - Các con trỏ tham khảo

Các snapshot đều có thể được xác định bằng kết quả hàm băm SHA-1 lên nội dung của chúng. Thật là bất tiện vì loài người không hề giỏi ghi nhớ các chuỗi 40 kí tự thập lục phân.
Now, all snapshots can be identified by their SHA-1 hashes. That's inconvenient,
because humans aren't good at remembering strings of 40 hexadecimal characters.

Cách giải quyết của Git cho vấn nạn này các tên dễ đọc cho các kết quả của hàm băm trên, gọi là "reference". Reference là con trỏ đến commit. Khác với các objects (vật thể), bị bất biến, các reference là các biến số (được thay đổi để chỉ đến một commit khác trong chuỗi lịch sử). Ví dụ như `master` là một reference thường chỉ đến commit mới nhất của branch chính của dự án ta đang phát triển.

```
references = map<string, string>

def update_reference(name, id):
    references[name] = id

def read_reference(name):
    return references[name]

def load_reference(name_or_id):
    if name_or_id in references:
        return load(references[name_or_id])
    else:
        return load(name_or_id)
```
Với cơ sở dữ liệu này, Git có thể dùng những cái tên dễ nhớ hơn như "master" để chỉ đến các snapshot (hay commit) nhất định trong lịch sử, thay vì chuỗi thập nhị phân nói trên.

Mội chi tiết thú vị là chúng ta thường cần một khái niệm cho việc "ta đang ở đâu trong hiện tại" của chuỗi lịch sử. Việc này rất cần thiết để ta biết khi ta tạo một snapshot hay commit mới, vị trí tương đối của chúng dựa trên bố mẹ nào. Trong Git, khái niệm "ta đang ở đâu hiện tại" là một reference đặc biệt gọi là "HEAD".

## Repository

Cuối cùng ta có thể định nghĩa (tương đối) _repository_ (kho chứa): đó là các dữ liệu của các `objects` và `references`.

Trên đĩa cứng, tất cả những gì Git lưu trữ là các object và reference: đó là những thứ quan trọng trong mô hình dữ liệu của Git. Tất cả câu lệnh bắt đầu bằng `git` tương ứng với việc thay đổi đồ thị DAG bằng các thêm object hay thêm và cập nhật các reference

Mỗi khi nhập một câu lệnh, hãy thử nghĩ về những thay đổi mà câu lệnh đang làm lên mô hình dữ liệu bên dưới. Ngược lại, nếu bạn đang nghĩ đến việc thay đổi đồ thị DAG, ví dụ như "bỏ đi những thay đổi chưa được commit (cam kết) và đưa con trỏ "master" đến commit `5d83f9e`, thì chắc chắn rằng có một câu lệnh tương ứng với hành đông đó (trong trường hợp này là `git checkout master; git reset --hard 5d83f9e`)

# Staging area - khu vực trung gian

Đây lại là một khái niệm riêng biệt với mô hình dữ liệu nêu trên, nhưng nó lại là một phần của giao diện để ta tạo các commit.

Hình dung thế này, để tạo nên một phương thức để "chụp lại" các snapshot như ở phần trên, ta có thể tạo một câu lệnh tên là "create snapshot". Nó sẽ tạo nên snapshot từ trạng thái hiện tại của working directory (thư mục làm việc của ta) mà các VCS đang theo dõi. Nhiều VCS thì chỉ đơn giản như vậy, nhưng với Git thì không. Ta cần các snapshot "sạch" và không phải lúc nào bưng nguyên trạng thái hiện tại của working directory vào lịch sử cũng cần thiết cả. 

Giả dụ như bạn đang viết hai chức năng riêng biệt và cần tạo hai commit riêng biệt, cái thứ nhất giới thiệu chức năng một và cái thứ hai thì giới thiệu chức năng thứ hai. Hay trường hợp khác khi bạn có vô vàn câu print (in) để phát hiện lỗi và logic để sửa lỗi; bạn chắc chắn chỉ muốn commit phần sửa lỗi và bỏ qua phần print.

Git có thể cho phép ta thực hiện các trường hợp trên bằng cách cho phép ta nêu ra phần thay đổi nào nên được đưa vào snapshot tiếp theo qua một khu vực trung gian (cách biệt giữa tất cả các thay đổi (unstaged) và các thay đổi đã được lưu trữ vào lịch sử (commit))

# Giao diện dòng lệnh của Git

Để tránh việc lặp thông tin, chúng tôi sẽ không giải thích các câu lệnh ở dưới một cách chi tiết. Hãy đọc [Pro Git](https://git-scm.com/book/en/v2) hay xem video bài giảng nếu cần thiết.

## Cơ bản

{% comment %}

Câu lệnh `git init` tạo một Git repository mới, với các thông tin phụ được lưu trong thư mục `.git`:

```console
$ mkdir myproject
$ cd myproject
$ git init
Initialized empty Git repository in /home/missing-semester/myproject/.git/
$ git status
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

Ta nên hiểu kết quả đầu ra trên như thế nào? "No commits yet" (Chưa có commit nào cả) có nghĩa là version history (lịch sử phiên bản) của 
ta đang bị trống. Hãy xem ta có thể thay đổi điều này bằng cách nào.

```console
$ echo "hello, git" > hello.txt
$ git add hello.txt
$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   hello.txt

$ git commit -m 'Initial commit'
[master (root-commit) 4515d17] Initial commit
 1 file changed, 1 insertion(+)
 create mode 100644 hello.txt
```
Với phần câu lệnh trên, ta đã dùng `git add` để thêm một file vào staging area và sau đó dùng `git commit` để chấp thuận thay đổi đó với một tin nhắn "Initial commit". Nếu ta không thêm lựu chọn `-m` thì Git sẽ mở một trình biên tập mã nguồn để ta có thể gõ vào một commit message (tin nhắn chấp thuận).

Khi ta đã có một version history không bị trống, chúng ta có thể trực quan hóa cái history này. Việc trực quan quá history dưới dạng DAG rất hữu dụng trong việc tìm hiểu hiện trạng của repository của chúng ta và giúp ta liên hệ đến data model của Git.

Câu lệnh `git log` sẽ làm trực quan history, và mặc định là một phiên bản đã bị làm phẳng, giấu đi cấu trúc của đồ thị. Nếu bạn dùng câu lệnh như `git log --all --graph --decorate`, phiên bản đầy đủ của version history theo dạng đồ thị sẽ được hiển thị.

```console
$ git log --all --graph --decorate
* commit 4515d17a167bdef0a91ee7d50d75b12c9c2652aa (HEAD -> master)
  Author: Missing Semester <missing-semester@mit.edu>
  Date:   Tue Jan 21 22:18:36 2020 -0500

      Initial commit
```

Tuy nhiên kết quả trên chả giống đồ thị chút nào. Điều này là do đồ thị của ta chỉ có một node (nút). Do đó, hãy tạo thêm một số thay đổi, xác nhận thêm commit và hiển thị history một lần nữa.

```console
$ echo "another line" >> hello.txt
$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   hello.txt

no changes added to commit (use "git add" and/or "git commit -a")
$ git add hello.txt
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   hello.txt

$ git commit -m 'Add a line'
[master 35f60a8] Add a line
 1 file changed, 1 insertion(+)
```

Bây giờ, khi ta hiển thị history một lần nữa, ta sẽ thấy cấu trúc đồ thị sau:

```
* commit 35f60a825be0106036dd2fbc7657598eb7b04c67 (HEAD -> master)
| Author: Missing Semester <missing-semester@mit.edu>
| Date:   Tue Jan 21 22:26:20 2020 -0500
|
|     Add a line
|
* commit 4515d17a167bdef0a91ee7d50d75b12c9c2652aa
  Author: Anish Athalye <me@anishathalye.com>
  Date:   Tue Jan 21 22:18:36 2020 -0500

      Initial commit
```

Hãy chú ý đến con trỏ HEAD cùng với branh - nhánh hiện tại (master).

Ta có thể xem lại các phiên bản cũ của mã nguồn bằng `git checkout`.

```console
$ git checkout 4515d17  # previous commit hash; yours will be different
Note: checking out '4515d17'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 4515d17 Initial commit
$ cat hello.txt
hello, git
$ git checkout master
Previous HEAD position was 4515d17 Initial commit
Switched to branch 'master'
$ cat hello.txt
hello, git
another line
```

Git còn có thể cho ta biết các tập tin đã thay đổi thế nào (sự khác biệt) bằng `git diff`:

```console
$ git diff 4515d17 hello.txt
diff --git c/hello.txt w/hello.txt
index 94bab17..f0013b2 100644
--- c/hello.txt
+++ w/hello.txt
@@ -1 +1,2 @@
 hello, git
 +another line
```

{% endcomment %}

- `git help <command>`: cho ta gợi ý cách dùng một câu lệnh <command> trong git
- `git init`: tạo một git repo với các thông tin chứa trong thư mục `.git` 
- `git status`: cho ta biết hiện trạng, những gì đang xảy ra trong repo
- `git add <filename>`: thêm tập <filename> vào stagin area
- `git commit`: thêm một commit mới
    - Cách nên viết [tin nhắn commit](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)!
    - Vô vàn lí do để viết [tin nhắn commit tốt](https://chris.beams.io/posts/git-commit/)!
- `git log`: Hiển thị lịch sử làm phẳng
- `git log --all --graph --decorate`: hiển thị lịch sử dưới dạng DAG
- `git diff <filename>`: hiển thị thay đổi của tập tin so với trong staging area
- `git diff <revision> <filename>`: hiển thị thay đổi của tập tin giữa các snapshot của history
- `git checkout <revision>`: cập nhật con trỏ HEAD và branch hiện tại

## Chia nhánh (branching) và hợp nhánh (merging)

{% comment %}

Việc chia nhánh cho phép bạn "fork - sao chép" lịch sử sang nhánh khác. Nó rất hữu dụng khi ta đang phát triển một tính năng riêng biệt hay đang sửa lỗi một cách song song với nhánh chính. Câu lệnh `git branch` dùng để tạo cành mới; câu lệnh `git checkout -b <branch name>` tạo một nhánh mới và di chuyển con trỏ hiện tại của lịch sử qua nhánh ấy.

Hợp nhánh là quá trình ngược lại với chia nhánh: nó cho phép ta hợp nhất các bản fork của lịch sử, ví dụ như hợp nhất tính năng phát triển ở trên lại nhánh master. Câu lệnh `git merge` dùng để hợp nhánh.

{% endcomment %}

- `git branch`: liệt kê cách nhánh trong repository của ta
- `git branch <name>`: tạo nhánh tên là name
- `git checkout -b <name>`: tạo nhánh mới tên là name và di chuyển trỏ HEAD sang nhánh đó
    - Tương tự như nhập hai câu lệnh sau `git branch <name>; git checkout <name>`
- `git merge <revision>`: hợp nhất một nhánh hay commit revision vào lại nhánh hiện tại (con trỏ HEAD)
- `git mergetool`: Dùng một trình nào đó để giải quyết conflict - mâu thuẫn khi hợp nhánh
- `git rebase`: Rebase - di chuyển một nhánh nào đó vào một gốc khác (giống như chiết cành trong nông nghiệp)

## Remotes - Dịch vụ luư trữ mã nguồn từ xa

- `git remote`: liệt kê nơi lưu trữ mã nguồn của ta từ xa (github, gitlab, etc)
- `git remote add <name> <url>`: Thêm một nơi lưu trữ mã nguồn từ xa
- `git push <remote> <local branch>:<remote branch>`: Cập nhật mã nguồn từ git lên remote và cập nhật con trỏ hiện tại trên remote
- `git branch --set-upstream-to=<remote>/<remote branch>`: Liên kết một nhánh hiện tại của git repository của ta và một nhánh trên remote
- `git fetch`: Cập nhật dữ liệu (history và objects) từ remote
- `git pull`: cập nhật và hợp nhất những thay đổi từ remote vào repository của ta `git fetch; git merge`
- `git clone`: download repository từ remote vào một thư mục mới.

## Undo - Quay lại, Hủy hành động

- `git commit --amend`: Thêm hoặc đổi nội dung và tin nhắn của commit gần nhất.
- `git reset HEAD <file>`: loại thay đổi của file ra khỏi staging area
- `git checkout -- <file>`: loại thay đổi của ta lên file hoàn toàn, file sẽ có nội dung giống như commit gần nhất, trước khi ta thêm vào những thay đổi đã bị loại đi.

# Nâng cao

- `git config`: Git có thể tùy chỉnh [vô cùng dễ dàng](https://git-scm.com/docs/git-config)
- `git clone --depth=1`: chỉ download một phần nào đó của repo trên remote thay vì toàn bộ lịch sử phiên bản
- `git add -p`: thêm thay đổi vào staging are một cách tương tác (lựa phần nào trong một file để thêm vào và chừa phần nào cho lần commit sau).
- `git rebase -i`: rebase một cách tương tác
- `git blame`: Xem ai đã thay đổi dòng nào
- `git stash`: Tạm thời đưa các thay đổi của working directory vào một cấu trúc stack (có thể phục hồi lại sau)
- `git bisect`: binary search - tìm kiếm nhị phân trong history (ví dụ cho việc regression - hồi quy)
- `.gitignore`: [Đề ra](https://git-scm.com/docs/gitignore) những file nào mà ta không muốn lưu giữ vào history.

# Khác

- **Giao diện đồ họa người dùng**: Có rất nhiều trình [giao diện đồ họa](https://git-scm.com/downloads/guis)
cho Git. Tuy nhiên cá nhân chúng tôi không dùng chúng mà chỉ sử dụng giao diên câu lệnh
- **Tích hợp vào Sheel**: rất hữu dụng khi hiện trạng của git có thể được hiển thị trên shell prompt của bạn ([zsh](https://github.com/olivierverdier/zsh-git-prompt),
[bash](https://github.com/magicmonty/bash-git-prompt)). Thuờng thì chúng được tích hợp sẵn vào các framework như [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh).
- **Tích hợp với trình biên tập**: Như trên, có rất cách tích hợp git vào các text editor. [fugitive.vim](https://github.com/tpope/vim-fugitive) là một ví dụ cơ bản cho trình Vim.
- **Workflows**: Chúng tôi đã dạy bạn về data model và một số câu lệnh cơ bản của git, nhưng hướng dẫn bạn các luồng làm việc và điều cần làm khi tham gia các dự án lớn (và có rất [nhiều](https://nvie.com/posts/a-successful-git-branching-model/)
[cách làm việc](https://www.endoflineblog.com/gitflow-considered-harmful)
[khác nhau](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)).
- **GitHub**: Git không phải là Github. Github có cách đặc biệt để ta đóng góp vào các dữ án mã nguồn khác, đó là [pull
requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests).
- **Nhà cung cấp lưu trữ Git khác**: GitHub không phải là duy nhất: có rất nhiều dịch vụ lưu trữ git repository khác như [GitLab](https://about.gitlab.com/) and
[BitBucket](https://bitbucket.org/).

# Các tài liệu khác

- [Pro Git](https://git-scm.com/book/en/v2) là **tài liệu bạn cần phải đọc**. Chương 1--5 là đủ để dùng Git một cách thông thạo khi bạn đã hiểu về data model của nó. Những chương sau có các chủ đề thú vị và nâng cao.

- [Oh Shit, Git!?!](https://ohshitgit.com/) là huớng dẫn xử lý các tình huống ất ơ thường gặp khi dùng Git.
- [Git for Computer
Scientists](https://eagain.net/articles/git-for-computer-scientists/) là một phần giải thích ngắn gọn về data model của git, ít mã giả và các hình vẽ hơn trong bài giảng này.
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/) là một bài giải thích chuyên sâu về cách Git được xây dựng, hơn cả việc dừng lại ở mô hình dữ liệu.
- [Giải thích Git bằng ngôn ngữ dễ hiểu](https://smusamashah.github.io/blog/2017/10/14/explain-git-in-simple-words)
- [Learn Git Branching](https://learngitbranching.js.org/) là một web-game dạy bạn về Git

# Bài tập

1. Nếu bạn không có kinh nghiệm dùng Git, hãy thử đọc vài chương đầu của  
[Pro Git](https://git-scm.com/book/en/v2) hoặc học theo một bài hướng dẫn như  [Learn Git Branching](https://learngitbranching.js.org/). Khi bạn làm chúng, hãy thử liên hệ các câu lệnh Git với data model của nó.
1. Clone [repository cho trang web khóa học này](https://github.com/missing-semester/missing-semester).
    1. Tìm hiểu về version history của nó bằng cách hiển thị theo dạng biểu đồ.
    1. Ai là người cuối cùng thay đổi file `README.md`? (Gợi ý: dùng `git log` với một đối số)
    1. Lời nhắn liên quan đến lần thay đổi cuối cùng trong dòng `collections:` của file `_config.yml` là gì? (Gợi ý: dùng `git blame` và `git show`)

1. Một trong những sai lầm khi sử dụng Git là khi commit một số lượng lớn file không nên được quản lý bởi Git, hay các thông tin nhạy cảm (passwords, mã Auth API, etc). Thử add một file vào repo, rồi tạo một vài commit rồi sau đó xóa chúng đi trong lịch sử. (Bạn có thể tham khảo thêm ở [đây](https://help.github.com/articles/removing-sensitive-data-from-a-repository/)).


1. Thử clone một vài repo từ trang Github, rồi thay đổi một ít files trong đó. Điều gì sẽ xảy ra khi ta dùng `git stash`? Bạn quan sát được gì khi chạy câu lệnh `git log --all --oneline`? Chạy `git stash pop` để xóa đi những tác vụ bạn vừa làm khi chạy `git stash`. Khi nào thì câu lệnh `git stash` sẽ có ít cho ta? 

1. Như các trình câu lệnh khác, Git có một file tùy chỉnh ( hay dotfile ) tên là `~/.gitconfig`. Hãy tạo một alias (biệt hiệu) `git graph` trong file trên để thực hiện câu lệnh `git log --all --graph --decorate --oneline` một cách ngắn gọn.

1. Bạn có thể tùy chỉnh các file hoặc thư mục mà git bỏ qua (ignore) trong dotfile `~/.gitignore_global` sau khi chạy `git config --global core.excludesfile ~/.gitignore_global`. Hãy làm vậy và tạo một file ignore trên toàn hệ thống để bỏ qua việc theo dõi các file phụ liên quan đến hệ điều hành hay các file tạm của trình biên tập mã nguồn, như `.DS_Store`. 

1. Fork repo của khóa học này từ [website](https://github.com/missing-semester/missing-semester), rồi tìm lỗi chính tả hay một điểm gì đó bạn có thể làm tốt hơn, rồi tạo một pull request trên Github.
Scientists](https://eagain.net/articles/git-for-computer-scientists/) is a
short explanation of Git's data model, with less pseudocode and more fancy
diagrams than these lecture notes.
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/)
is a detailed explanation of Git's implementation details beyond just the data
model, for the curious.
- [How to explain git in simple
words](https://smusamashah.github.io/blog/2017/10/14/explain-git-in-simple-words)
- [Learn Git Branching](https://learngitbranching.js.org/) is a browser-based
game that teaches you Git.

# Exercises

1. If you don't have any past experience with Git, either try reading the first
   couple chapters of [Pro Git](https://git-scm.com/book/en/v2) or go through a
   tutorial like [Learn Git Branching](https://learngitbranching.js.org/). As
   you're working through it, relate Git commands to the data model.
1. Clone the [repository for the
class website](https://github.com/missing-semester/missing-semester).
    1. Explore the version history by visualizing it as a graph.
    1. Who was the last person to modify `README.md`? (Hint: use `git log` with
       an argument).
    1. What was the commit message associated with the last modification to the
       `collections:` line of `_config.yml`? (Hint: use `git blame` and `git
       show`).
1. One common mistake when learning Git is to commit large files that should
   not be managed by Git or adding sensitive information. Try adding a file to
   a repository, making some commits and then deleting that file from history
   (you may want to look at
   [this](https://help.github.com/articles/removing-sensitive-data-from-a-repository/)).
1. Clone some repository from GitHub, and modify one of its existing files.
   What happens when you do `git stash`? What do you see when running `git log
   --all --oneline`? Run `git stash pop` to undo what you did with `git stash`.
   In what scenario might this be useful?
1. Like many command line tools, Git provides a configuration file (or dotfile)
   called `~/.gitconfig`. Create an alias in `~/.gitconfig` so that when you
   run `git graph`, you get the output of `git log --all --graph --decorate
   --oneline`. Information about git aliases can be found [here](https://git-scm.com/docs/git-config#Documentation/git-config.txt-alias).
1. You can define global ignore patterns in `~/.gitignore_global` after running
   `git config --global core.excludesfile ~/.gitignore_global`. Do this, and
   set up your global gitignore file to ignore OS-specific or editor-specific
   temporary files, like `.DS_Store`.
1. Fork the [repository for the class
   website](https://github.com/missing-semester/missing-semester), find a typo
   or some other improvement you can make, and submit a pull request on GitHub
   (you may want to look at [this](https://github.com/firstcontributions/first-contributions)).
