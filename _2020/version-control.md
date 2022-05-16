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

<!--
Version control systems (VCSs) are tools used to track changes to source code (or other collections of files and folders). As the name implies, these tools help maintain a history of changes; furthermore, they facilitate collaboration. VCSs track changes to a folder and its contents in a series of snapshots, where each snapshot encapsulates the entire state of files/folders within a top-level directory. VCSs also maintain metadata like who created each snapshot, messages associated with each snapshot, and so on.

Why is version control useful? Even when you're working by yourself, it can let you look at old snapshots of a project, keep a log of why certain changes were made, work on parallel branches of development, and much more. When working with others, it's an invaluable tool for seeing what other people have changed, as well as resolving conflicts in concurrent development.
-->

Các VCS hiện đại cũng có thể trả lời các câu hỏi sau một cách dễ dàng và đa phần tự động:

- Ai viết module (mô đun) này
- Dòng mã nguồn này của tập tin này được thay đổi khi nào? Bời ai? Và tại sao nó lại bị thay đổi?
- Trong vòng 1000 thay đổi trở lại đây, khi nào và tại sao một unit test (bài kiểm thử đơn vị) lại không đạt (dù trước đó nó hoạt động).

Mặc dù có nhiều trình VCS, nhưng **Git** là công cụ thông dụng nhất cho việc quản lý phiên bản. Hình ảnh truyện tranh sau từ [XKCD comic](https://xkcd.com/1597/) phần nào cho ta thấy danh tiếng của Git:

<!--
Modern VCSs also let you easily (and often automatically) answer questions
like:

- Who wrote this module?
- When was this particular line of this particular file edited? By whom? Why
  was it edited?
- Over the last 1000 revisions, when/why did a particular unit test stop
working?

While other VCSs exist, **Git** is the de facto standard for version control.
This [XKCD comic](https://xkcd.com/1597/) captures Git's reputation:
-->

![xkcd 1597](https://imgs.xkcd.com/comics/git.png)

*(dịch: A - Đây là Git, nó theo dõi việc hợp tác trong các dự án có mã nguồn bằng mộc biểu đồ cây xinh xắn. B - Ngon, thế dùng nó thế nào? A - Tôi không biết. Cứ nhớ các câu lệnh shell này và gõ chúng để cập nhật giữa mã của chúng ta. Nếu có lỗi thì lưu giữ thay đổi của bạn ở chỗ khác, rồi xóa nguyên dự án đó đi và tải về một bản lưu giữ mới toanh...)*

Vì giao diện của Git là một dạng leaky abstraction (trừu tượng có rò rĩ), tìm hiểu về cách sử dụng Git theo phương pháp top-down (từ cao xuống thấp, bắt đầu từ giao điện câu lệnh của nó) có thể gây ra vô vàn sự mất phương hướng (đặc biệt cho người mới học). Bạn hoàn toàn có thể học thuộc một loạt các câu lệnh, coi chúng như thần chú và làm theo bức hình trên nếu có gì đó sai.

Mặc dù Git có một giao diện thật sự là tệ hại, triết lý thiệt kế  và hoạt động của nó vô cùng ấn tượng. Trong khi một giao diện tệ hại này cần phải được _học thuộc lòng_, một thiết kế  ấn tượng có thể  được _hiểu tận_. Vì lí do này, chúng ta sẽ học Git theo cách bottom-up (từ dưới lên trên), bắt đầu từ data model (mô hình dữ liệu) rồi sau đó mới đến các câu lệnh. Khi ta đã hiểu mô hình dữ liệu của nó, ta hoàn toàn có thể giải thích cách các câu lênh Git hoạt động (bằng việc thay đổi mô hình dữ liệu trên).

<!--
Because Git's interface is a leaky abstraction, learning Git top-down (starting
with its interface / command-line interface) can lead to a lot of confusion.
It's possible to memorize a handful of commands and think of them as magic
incantations, and follow the approach in the comic above whenever anything goes
wrong.

While Git admittedly has an ugly interface, its underlying design and ideas are
beautiful. While an ugly interface has to be _memorized_, a beautiful design
can be _understood_. For this reason, we give a bottom-up explanation of Git,
starting with its data model and later covering the command-line interface.
Once the data model is understood, the commands can be better understood in
terms of how they manipulate the underlying data model.
-->

# Mô hình dữ liệu của Git

Có vô vàn cách để thiết kế một VCS. Tuy nhiên Git có một mô hình dữ liệu được thiết kế kỹ càng để tạo nên các tính năng tuyệt vời của một VCS như lưu giữ lịch sử, hỗ trợ các branch và cho phép hợp tác giữa người dùng.

<!--
# Git's data model

There are many ad-hoc approaches you could take to version control. Git has a
well-thought-out model that enables all the nice features of version control,
like maintaining history, supporting branches, and enabling collaboration.
-->

## Snapshots ("Ảnh chụp")

Git mô phỏng lịch sử của các tập tin và thư mục  nó theo dõi dưới dạng chuỗi các snapshot trong một thư mục top-level (thư mục gốc của dự án). Theo ngôn ngữ của Git, một tập tin được gọi là "blob", và nó chỉ là một đống bytes dự liệu. Thư mục thì lại gọi là "tree" (cây), và nó lưu giữ tên đến các tree hay blob khác (thư mục có thể chứa thư mục con). Một snapshot là cây gốc trên cùng mà ta đang theo dõi. Ví dụ như ta có một cây thư mục như sau:

<!--
## Snapshots

Git models the history of a collection of files and folders within some
top-level directory as a series of snapshots. In Git terminology, a file is
called a "blob", and it's just a bunch of bytes. A directory is called a
"tree", and it maps names to blobs or trees (so directories can contain other
directories). A snapshot is the top-level tree that is being tracked. For
example, we might have a tree as follows:
-->

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
<!--
The top-level tree contains two elements, a tree "foo" (that itself contains
one element, a blob "bar.txt"), and a blob "baz.txt".
-->

## Mô phỏng lịch sử: cách kết nối các snapshot

Các VCS nên kết nối các snapshot như thế nào để có nghĩa? Một mô hình đơn giản đó là linear history (lịch sử tuyến tính). Mô hình lịch sử này cấu thành từ các snapshot theo thứ tự thời gian mà chúng được tạo. Tuy nhiên, vì vô vàn lí do, Git không dùng một mô hình đơn giản như vậy.

Trong Git, lịch sử  được mô phỏng bằng một Directed Acyclic Graph (Đồ thị định hướng không tuần hoàn - DAG). Đấy là một từ phức tạp và đầy toán học, nhưng đừng sợ. Điều này có nghĩa là mỗi snapshot trong Git thì được kết nối, chỉ hướng về một set (tập) các "bố mẹ", những snapshot đi trước nó trong chuỗi thời gian. Gọi là một tập các bố mẹ thay cho một bố hoặc mẹ (như mô hình linear history nói trên) vì một snapshot có thể  có nhiều tổ tiên khác nhau, như trong việc merging (hợp nhất) nhiều branch phát triển song song chẳng hạn.

Các snapshot này được gọi là commit (cam kết). Việc hình dung một history có thể cho ta một thứ như sau:

<!--
## Modeling history: relating snapshots

How should a version control system relate snapshots? One simple model would be
to have a linear history. A history would be a list of snapshots in time-order.
For many reasons, Git doesn't use a simple model like this.

In Git, a history is a directed acyclic graph (DAG) of snapshots. That may
sound like a fancy math word, but don't be intimidated. All this means is that
each snapshot in Git refers to a set of "parents", the snapshots that preceded
it. It's a set of parents rather than a single parent (as would be the case in
a linear history) because a snapshot might descend from multiple parents, for
example, due to combining (merging) two parallel branches of development.

Git calls these snapshots "commit"s. Visualizing a commit history might look
something like this:
-->

```
o <-- o <-- o <-- o
            ^
             \
              --- o <-- o
```

Trong bức hình ASCII ở trên, kí tự `o` tượng trưng cho commit (hay snapshot). Các mũi tên chỉ đến bố mẹ của mỗi commit (đó là mối quan hệ "có trước nó", không phải là "có sau nó"). Đến cái commit thứ 3 thì biểu đồ lịch sử được chia làm hai nhánh riêng. Điều này có thể tương ứng với hai chức năng đang được phát triển song song, độc lập với nhau. Trong tương lai, các branch này có thể được hợp nhất tạo nên một snapshot có cả hai chức năng này. Điều này tạo ra một đồ thị lịch sử như sau:

<!--
In the ASCII art above, the `o`s correspond to individual commits (snapshots).
The arrows point to the parent of each commit (it's a "comes before" relation,
not "comes after"). After the third commit, the history branches into two
separate branches. This might correspond to, for example, two separate features
being developed in parallel, independently from each other. In the future,
these branches may be merged to create a new snapshot that incorporates both of
the features, producing a new history that looks like this, with the newly
created merge commit shown in bold:
-->

<pre class="highlight">
<code>
o <-- o <-- o <-- o <---- <strong>o</strong>
            ^            /
             \          v
              --- o <-- o
</code>
</pre>

Commit trong Git là bất biến, nghĩa là các lỗi trong commit không thể nào sữa được. Rất may những lỗi này chỉ có nghĩa là các thay đổi đến dòng lịch sử (nội dung của blob hay cấu trúc của tree được theo dõi chẳng hạn) sẽ tạo ra các commit hoàn toàn mới và các references (xem ở phần dưới đây) được cập nhật để chỉ đến các commit vừa tạo (để sửa lỗi sai trong thư mục hay tập tin chẳng hạn).

<!--
Commits in Git are immutable. This doesn't mean that mistakes can't be
corrected, however; it's just that "edits" to the commit history are actually
creating entirely new commits, and references (see below) are updated to point
to the new ones.
-->

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

<!--
## Data model, as pseudocode

It may be instructive to see Git's data model written down in pseudocode:

```
// a file is a bunch of bytes
type blob = array<byte>

// a directory contains named files and directories
type tree = map<string, tree | blob>

// a commit has parents, metadata, and the top-level tree
type commit = struct {
    parents: array<commit>
    author: string
    message: string
    snapshot: tree
}
```

It's a clean, simple model of history.
-->

## Vật thể  và content-addressing (truy cập địa chỉ từ nội dung)

Một "vật thể" là một blob, tree hay là commit:

<!--
## Objects and content-addressing

An "object" is a blob, tree, or commit:
-->

```
type object = blob | tree | commit
```

Trong kho lưu trữ dữ liệu của Git, các vật thể đều có thể được xác định và truy cập từ nội dụng của chúng (đúng hơn là kết quả của hàm băm [SHA-1
hash](https://en.wikipedia.org/wiki/SHA-1) trên nội dung của chúng )
<!--
In Git data store, all objects are content-addressed by their [SHA-1
hash](https://en.wikipedia.org/wiki/SHA-1).
-->

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

<!--
Blobs, trees, and commits are unified in this way: they are all objects. When
they reference other objects, they don't actually _contain_ them in their
on-disk representation, but have a reference to them by their hash.

For example, the tree for the example directory structure [above](#snapshots)
(visualized using `git cat-file -p 698281bc680d1995c5f4caaf3359721a5a58d48d`),
looks like this:
-->

```
100644 blob 4448adbf7ecd394f42ae135bbeed9676e894af85    baz.txt
040000 tree c68d233a33c5c06e0340e4c224f0afca87c8ce87    foo
```
Tree gốc này có nội dung là các con trỏ đến nội dung của nó (như trên), rồi `baz.txt` (một blob) và `foo` (một tree). Nếu ta dùng kết quả hàm băm tương ứng với con trỏ tới baz.txt bằng câu lệnh `git cat-file -p 4448adbf7ecd394f42ae135bbeed9676e894af85`, nội dung có được (văn bản trong baz.txt) là như sau:
<!--
The tree itself contains pointers to its contents, `baz.txt` (a blob) and `foo`
(a tree). If we look at the contents addressed by the hash corresponding to
baz.txt with `git cat-file -p 4448adbf7ecd394f42ae135bbeed9676e894af85`, we get
the following:
-->

```
git is wonderful
```

## References - Các con trỏ tham khảo

Các snapshot đều có thể được xác định bằng kết quả hàm băm SHA-1 lên nội dung của chúng. Thật là bất tiện vì loài người không hề giỏi ghi nhớ các chuỗi 40 kí tự thập lục phân.

Cách giải quyết của Git cho vấn nạn này các tên dễ đọc cho các kết quả của hàm băm trên, gọi là "reference". Reference là con trỏ đến commit. Khác với các objects (vật thể), bị bất biến, các reference là các biến số (được thay đổi để chỉ đến một commit khác trong chuỗi lịch sử). Ví dụ như `master` là một reference thường chỉ đến commit mới nhất của branch chính của dự án ta đang phát triển.
<!--
## References

Now, all snapshots can be identified by their SHA-1 hashes. That's inconvenient,
because humans aren't good at remembering strings of 40 hexadecimal characters.

Git's solution to this problem is human-readable names for SHA-1 hashes, called
"references". References are pointers to commits. Unlike objects, which are
immutable, references are mutable (can be updated to point to a new commit).
For example, the `master` reference usually points to the latest commit in the
main branch of development.
-->

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
<!--
With this, Git can use human-readable names like "master" to refer to a
particular snapshot in the history, instead of a long hexadecimal string.

One detail is that we often want a notion of "where we currently are" in the
history, so that when we take a new snapshot, we know what it is relative to
(how we set the `parents` field of the commit). In Git, that "where we
currently are" is a special reference called "HEAD".
-->

## Repository

Cuối cùng ta có thể định nghĩa (tương đối) _repository_ (kho chứa): đó là các dữ liệu của các `objects` và `references`.

Trên đĩa cứng, tất cả những gì Git lưu trữ là các object và reference: đó là những thứ quan trọng trong mô hình dữ liệu của Git. Tất cả câu lệnh bắt đầu bằng `git` tương ứng với việc thay đổi đồ thị DAG bằng các thêm object hay thêm và cập nhật các reference

Mỗi khi nhập một câu lệnh, hãy thử nghĩ về những thay đổi mà câu lệnh đang làm lên mô hình dữ liệu bên dưới. Ngược lại, nếu bạn đang nghĩ đến việc thay đổi đồ thị DAG, ví dụ như "bỏ đi những thay đổi chưa được commit (cam kết) và đưa con trỏ "master" đến commit `5d83f9e`, thì chắc chắn rằng có một câu lệnh tương ứng với hành đông đó (trong trường hợp này là `git checkout master; git reset --hard 5d83f9e`)
<!--
## Repositories

Finally, we can define what (roughly) is a Git _repository_: it is the data
`objects` and `references`.

On disk, all Git stores are objects and references: that's all there is to Git's
data model. All `git` commands map to some manipulation of the commit DAG by
adding objects and adding/updating references.

Whenever you're typing in any command, think about what manipulation the
command is making to the underlying graph data structure. Conversely, if you're
trying to make a particular kind of change to the commit DAG, e.g. "discard
uncommitted changes and make the 'master' ref point to commit `5d83f9e`", there's
probably a command to do it (e.g. in this case, `git checkout master; git reset
--hard 5d83f9e`).
-->

# Staging area - khu vực trung gian

Đây lại là một khái niệm riêng biệt với mô hình dữ liệu nêu trên, nhưng nó lại là một phần của giao diện để ta tạo các commit.

Hình dung thế này, để tạo nên một phương thức để "chụp lại" các snapshot như ở phần trên, ta có thể tạo một câu lệnh tên là "create snapshot". Nó sẽ tạo nên snapshot từ trạng thái hiện tại của working directory (thư mục làm việc của ta) mà các VCS đang theo dõi. Nhiều VCS thì chỉ đơn giản như vậy, nhưng với Git thì không. Ta cần các snapshot "sạch" và không phải lúc nào bưng nguyên trạng thái hiện tại của working directory vào lịch sử cũng cần thiết cả. 

Giả dụ như bạn đang viết hai chức năng riêng biệt và cần tạo hai commit riêng biệt, cái thứ nhất giới thiệu chức năng một và cái thứ hai thì giới thiệu chức năng thứ hai. Hay trường hợp khác khi bạn có vô vàn câu print (in) để phát hiện lỗi và logic để sửa lỗi; bạn chắc chắn chỉ muốn commit phần sửa lỗi và bỏ qua phần print.

Git có thể cho phép ta thực hiện các trường hợp trên bằng cách cho phép ta nêu ra phần thay đổi nào nên được đưa vào snapshot tiếp theo qua một khu vực trung gian (cách biệt giữa tất cả các thay đổi (unstaged) và các thay đổi đã được lưu trữ vào lịch sử (commit))
<!--
# Staging area

This is another concept that's orthogonal to the data model, but it's a part of
the interface to create commits.

One way you might imagine implementing snapshotting as described above is to have
a "create snapshot" command that creates a new snapshot based on the _current
state_ of the working directory. Some version control tools work like this, but
not Git. We want clean snapshots, and it might not always be ideal to make a
snapshot from the current state. For example, imagine a scenario where you've
implemented two separate features, and you want to create two separate commits,
where the first introduces the first feature, and the next introduces the
second feature. Or imagine a scenario where you have debugging print statements
added all over your code, along with a bugfix; you want to commit the bugfix
while discarding all the print statements.

Git accommodates such scenarios by allowing you to specify which modifications
should be included in the next snapshot through a mechanism called the "staging
area".
-->

# Giao diện dòng lệnh của Git

Để tránh việc lặp thông tin, chúng tôi sẽ không giải thích các câu lệnh ở dưới một cách chi tiết. Hãy đọc [Pro Git](https://git-scm.com/book/en/v2) hay xem video bài giảng nếu cần thiết.
<!--
# Git command-line interface

To avoid duplicating information, we're not going to explain the commands below
in detail. See the highly recommended [Pro Git](https://git-scm.com/book/en/v2)
for more information, or watch the lecture video.
-->

## Cơ bản

{% comment %}

Câu lệnh `git init` tạo một Git repository mới, với các thông tin phụ được lưu trong thư mục `.git`:
<!--
## Basics

{% comment %}

The `git init` command initializes a new Git repository, with repository
metadata being stored in the `.git` directory:
-->

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
<!--
How do we interpret this output? "No commits yet" basically means our version
history is empty. Let's fix that.
-->

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
<!--
With this, we've `git add`ed a file to the staging area, and then `git
commit`ed that change, adding a simple commit message "Initial commit". If we
didn't specify a `-m` option, Git would open our text editor to allow us type a
commit message.

Now that we have a non-empty version history, we can visualize the history.
Visualizing the history as a DAG can be especially helpful in understanding the
current status of the repo and connecting it with your understanding of the Git
data model.

The `git log` command visualizes history. By default, it shows a flattened
version, which hides the graph structure. If you use a command like `git log
--all --graph --decorate`, it will show you the full version history of the
repository, visualized in graph form
-->

```console
$ git log --all --graph --decorate
* commit 4515d17a167bdef0a91ee7d50d75b12c9c2652aa (HEAD -> master)
  Author: Missing Semester <missing-semester@mit.edu>
  Date:   Tue Jan 21 22:18:36 2020 -0500

      Initial commit
```

Tuy nhiên kết quả trên chả giống đồ thị chút nào. Điều này là do đồ thị của ta chỉ có một node (nút). Do đó, hãy tạo thêm một số thay đổi, xác nhận thêm commit và hiển thị history một lần nữa.
<!--
This doesn't look all that graph-like, because it only contains a single node.
Let's make some more changes, author a new commit, and visualize the history
once more.
-->

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
<!--
Now, if we visualize the history again, we'll see some of the graph structure:
-->

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
<!--
Also, note that it shows the current HEAD, along with the current branch
(master).

We can look at old versions using the `git checkout` command.
-->

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
<!--
Git can show you how files have evolved (differences, or diffs) using the `git
diff` command:
-->

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

<!--
{% endcomment %}

- `git help <command>`: get help for a git command
- `git init`: creates a new git repo, with data stored in the `.git` directory
- `git status`: tells you what's going on
- `git add <filename>`: adds files to staging area
- `git commit`: creates a new commit
    - Write [good commit messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)!
    - Even more reasons to write [good commit messages](https://chris.beams.io/posts/git-commit/)!
- `git log`: shows a flattened log of history
- `git log --all --graph --decorate`: visualizes history as a DAG
- `git diff <filename>`: show changes you made relative to the staging area
- `git diff <revision> <filename>`: shows differences in a file between snapshots
- `git checkout <revision>`: updates HEAD and current branch
-->

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

<!--
## Branching and merging

{% comment %}

Branching allows you to "fork" version history. It can be helpful for working
on independent features or bug fixes in parallel. The `git branch` command can
be used to create new branches; `git checkout -b <branch name>` creates and
branch and checks it out.

Merging is the opposite of branching: it allows you to combine forked version
histories, e.g. merging a feature branch back into master. The `git merge`
command is used for merging.

{% endcomment %}

- `git branch`: shows branches
- `git branch <name>`: creates a branch
- `git checkout -b <name>`: creates a branch and switches to it
    - same as `git branch <name>; git checkout <name>`
- `git merge <revision>`: merges into current branch
- `git mergetool`: use a fancy tool to help resolve merge conflicts
- `git rebase`: rebase set of patches onto a new base
-->

## Remotes - Dịch vụ luư trữ mã nguồn từ xa

- `git remote`: liệt kê nơi lưu trữ mã nguồn của ta từ xa (github, gitlab, etc)
- `git remote add <name> <url>`: Thêm một nơi lưu trữ mã nguồn từ xa
- `git push <remote> <local branch>:<remote branch>`: Cập nhật mã nguồn từ git lên remote và cập nhật con trỏ hiện tại trên remote
- `git branch --set-upstream-to=<remote>/<remote branch>`: Liên kết một nhánh hiện tại của git repository của ta và một nhánh trên remote
- `git fetch`: Cập nhật dữ liệu (history và objects) từ remote
- `git pull`: cập nhật và hợp nhất những thay đổi từ remote vào repository của ta `git fetch; git merge`
- `git clone`: download repository từ remote vào một thư mục mới.
<!--
## Remotes

- `git remote`: list remotes
- `git remote add <name> <url>`: add a remote
- `git push <remote> <local branch>:<remote branch>`: send objects to remote, and update remote reference
- `git branch --set-upstream-to=<remote>/<remote branch>`: set up correspondence between local and remote branch
- `git fetch`: retrieve objects/references from a remote
- `git pull`: same as `git fetch; git merge`
- `git clone`: download repository from remote
-->

## Undo - Quay lại, Hủy hành động

- `git commit --amend`: Thêm hoặc đổi nội dung và tin nhắn của commit gần nhất.
- `git reset HEAD <file>`: loại thay đổi của file ra khỏi staging area
- `git checkout -- <file>`: loại thay đổi của ta lên file hoàn toàn, file sẽ có nội dung giống như commit gần nhất, trước khi ta thêm vào những thay đổi đã bị loại đi.

<!--
## Undo

- `git commit --amend`: edit a commit's contents/message
- `git reset HEAD <file>`: unstage a file
- `git checkout -- <file>`: discard changes
-->

# Nâng cao

- `git config`: Git có thể tùy chỉnh [vô cùng dễ dàng](https://git-scm.com/docs/git-config)
- `git clone --depth=1`: chỉ download một phần nào đó của repo trên remote thay vì toàn bộ lịch sử phiên bản
- `git add -p`: thêm thay đổi vào staging are một cách tương tác (lựa phần nào trong một file để thêm vào và chừa phần nào cho lần commit sau).
- `git rebase -i`: rebase một cách tương tác
- `git blame`: Xem ai đã thay đổi dòng nào
- `git stash`: Tạm thời đưa các thay đổi của working directory vào một cấu trúc stack (có thể phục hồi lại sau)
- `git bisect`: binary search - tìm kiếm nhị phân trong history (ví dụ cho việc regression - hồi quy)
- `.gitignore`: [Đề ra](https://git-scm.com/docs/gitignore) những file nào mà ta không muốn lưu giữ vào history.

<!--
# Advanced Git

- `git config`: Git is [highly customizable](https://git-scm.com/docs/git-config)
- `git clone --depth=1`: shallow clone, without entire version history
- `git add -p`: interactive staging
- `git rebase -i`: interactive rebasing
- `git blame`: show who last edited which line
- `git stash`: temporarily remove modifications to working directory
- `git bisect`: binary search history (e.g. for regressions)
- `.gitignore`: [specify](https://git-scm.com/docs/gitignore) intentionally untracked files to ignore
-->

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

<!--
# Miscellaneous

- **GUIs**: there are many [GUI clients](https://git-scm.com/downloads/guis)
out there for Git. We personally don't use them and use the command-line
interface instead.
- **Shell integration**: it's super handy to have a Git status as part of your
shell prompt ([zsh](https://github.com/olivierverdier/zsh-git-prompt),
[bash](https://github.com/magicmonty/bash-git-prompt)). Often included in
frameworks like [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh).
- **Editor integration**: similarly to the above, handy integrations with many
features. [fugitive.vim](https://github.com/tpope/vim-fugitive) is the standard
one for Vim.
- **Workflows**: we taught you the data model, plus some basic commands; we
didn't tell you what practices to follow when working on big projects (and
there are [many](https://nvie.com/posts/a-successful-git-branching-model/)
[different](https://www.endoflineblog.com/gitflow-considered-harmful)
[approaches](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)).
- **GitHub**: Git is not GitHub. GitHub has a specific way of contributing code
to other projects, called [pull
requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests).
- **Other Git providers**: GitHub is not special: there are many Git repository
hosts, like [GitLab](https://about.gitlab.com/) and
[BitBucket](https://bitbucket.org/).
-->

# Các tài liệu khác

- [Pro Git](https://git-scm.com/book/en/v2) là **tài liệu bạn cần phải đọc**. Chương 1--5 là đủ để dùng Git một cách thông thạo khi bạn đã hiểu về data model của nó. Những chương sau có các chủ đề thú vị và nâng cao.

- [Oh Shit, Git!?!](https://ohshitgit.com/) là huớng dẫn xử lý các tình huống ất ơ thường gặp khi dùng Git.
- [Git for Computer
Scientists](https://eagain.net/articles/git-for-computer-scientists/) là một phần giải thích ngắn gọn về data model của git, ít mã giả và các hình vẽ hơn trong bài giảng này.
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/) là một bài giải thích chuyên sâu về cách Git được xây dựng, hơn cả việc dừng lại ở mô hình dữ liệu.
- [Giải thích Git bằng ngôn ngữ dễ hiểu](https://smusamashah.github.io/blog/2017/10/14/explain-git-in-simple-words)
- [Learn Git Branching](https://learngitbranching.js.org/) là một web-game dạy bạn về Git
<!--
# Resources

- [Pro Git](https://git-scm.com/book/en/v2) is **highly recommended reading**.
Going through Chapters 1--5 should teach you most of what you need to use Git
proficiently, now that you understand the data model. The later chapters have
some interesting, advanced material.
- [Oh Shit, Git!?!](https://ohshitgit.com/) is a short guide on how to recover
from some common Git mistakes.
- [Git for Computer
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
-->

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

<!--
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
-->
