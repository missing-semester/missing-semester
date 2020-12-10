---
layout: lecture
title: "Trình quản lý phiên bản (Git)"
date: 2019-01-22
ready: true
video:
  aspect: 56.25
  id: 2sjqTHE0zok
---
Hệ thống quản lý phiên bản (Version Control Systems - VCS) là các công cụ để theo dõi những thay đổi trong mã nguồn (hay các thư mục và tập tin). Đúng như tên gọi của chúng, các công cụ này giúp ta lưu giữ lịch sử thay đổi và thậm chí là tạo điều kiện cho việc hợp tác với người khác. Các VCS theo dõi sự thay đổi của các tập và thư mục con bằng cách lưu giữ toàn bộ trạng thái của chúng qua các "snapshot" (cơ sở dữ liệu "ảnh chụp"). Những snapshot này được lưu trong một tập trên cùng hay tập gốc của dự án ta muốn quản lý phiên bản. Ngoài ra các VCS cũng chứa đựng các metadata (thông tin phụ) như tác giả của "snapshot", tin nhắn và giải thích bởi tác giả cho "snapshot" đó, v.v.

Vì sao ta cần các trình quản lý phiên bản? Thập chí ngay khi bạn lập trình cho một dư án cá nhân, VCS có thể cho phép ta xem lại sự thay đổi, mốc thời gian của chúng, lí do cho các thay đổi đó và các tiến trình trên các branch (cành) khác nhau của cây lịch sử . Khi làm việc nhóm, đây lại là một công cụ vô cùng hiệu quả để theo dõi thay đổi từ các đồng sự và giải quyết các conflicts (mâu thuẫn) từ thay đổi mã nguồn của ta và họ.

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

Các snapshot này được gọi là commit (cam kết). Việc hình dung một history có thể cho ta một thứ như sau:

```
o <-- o <-- o <-- o
            ^
             \
              --- o <-- o
```

Trong bức hình ASCII ở trên, kí tự `o` tượng trưng cho commit (hay snapshot). Các mũi tên chỉ đến bố mẹ của mỗi commit (đó là mối quan hệ "có trước nó", không phải là "có sau nó"). Đến cái commit thứ 3 thì biểu đồ lịch sử được chia làm hai cành riêng. Điều này có thể tương ứng với hai chức năng đang được phát triển song song, độc lập với nhau. Trong tương lai, các branch này có thể được hợp nhất tạo nên một snapshot có cả hai chức năng này. Điều này tạo ra một đồ thị lịch sử như sau:

<pre>
o <-- o <-- o <-- o <---- <strong>o</strong>
            ^            /
             \          v
              --- o <-- o
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
    parent: array<commit>
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

# Git command-line interface

To avoid duplicating information, we're not going to explain the commands below
in detail. See the highly recommended [Pro Git](https://git-scm.com/book/en/v2)
for more information, or watch the lecture video.

## Basics

{% comment %}

The `git init` command initializes a new Git repository, with repository
metadata being stored in the `.git` directory:

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

How do we interpret this output? "No commits yet" basically means our version
history is empty. Let's fix that.

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
repository, visualized in graph form.

```console
$ git log --all --graph --decorate
* commit 4515d17a167bdef0a91ee7d50d75b12c9c2652aa (HEAD -> master)
  Author: Missing Semester <missing-semester@mit.edu>
  Date:   Tue Jan 21 22:18:36 2020 -0500

      Initial commit
```

This doesn't look all that graph-like, because it only contains a single node.
Let's make some more changes, author a new commit, and visualize the history
once more.

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

Now, if we visualize the history again, we'll see some of the graph structure:

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

Also, note that it shows the current HEAD, along with the current branch
(master).

We can look at old versions using the `git checkout` command.

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

Git can show you how files have evolved (differences, or diffs) using the `git
diff` command:

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

## Remotes

- `git remote`: list remotes
- `git remote add <name> <url>`: add a remote
- `git push <remote> <local branch>:<remote branch>`: send objects to remote, and update remote reference
- `git branch --set-upstream-to=<remote>/<remote branch>`: set up correspondence between local and remote branch
- `git fetch`: retrieve objects/references from a remote
- `git pull`: same as `git fetch; git merge`
- `git clone`: download repository from remote

## Undo

- `git commit --amend`: edit a commit's contents/message
- `git reset HEAD <file>`: unstage a file
- `git checkout -- <file>`: discard changes

# Advanced Git

- `git config`: Git is [highly customizable](https://git-scm.com/docs/git-config)
- `git clone --depth=1`: shallow clone, without entire version history
- `git add -p`: interactive staging
- `git rebase -i`: interactive rebasing
- `git blame`: show who last edited which line
- `git stash`: temporarily remove modifications to working directory
- `git bisect`: binary search history (e.g. for regressions)
- `.gitignore`: [specify](https://git-scm.com/docs/gitignore) intentionally untracked files to ignore

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

# Exercises

1. If you don't have any past experience with Git, either try reading the first
   couple chapters of [Pro Git](https://git-scm.com/book/en/v2) or go through a
   tutorial like [Learn Git Branching](https://learngitbranching.js.org/). As
   you're working through it, relate Git commands to the data model.
1. Clone the [repository for the
class website](https://github.com/missing-semester/missing-semester).
    1. Explore the version history by visualizing it as a graph.
    1. Who was the last person to modify `README.md`? (Hint: use `git log` with
       an argument)
    1. What was the commit message associated with the last modification to the
       `collections:` line of `_config.yml`? (Hint: use `git blame` and `git
       show`)
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
   --oneline`.
1. You can define global ignore patterns in `~/.gitignore_global` after running
   `git config --global core.excludesfile ~/.gitignore_global`. Do this, and
   set up your global gitignore file to ignore OS-specific or editor-specific
   temporary files, like `.DS_Store`.
1. Fork the [repository for the class
   website](https://github.com/missing-semester/missing-semester), find a typo
   or some other improvement you can make, and submit a pull request on GitHub.
