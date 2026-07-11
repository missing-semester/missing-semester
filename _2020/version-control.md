---
layout: lecture
title: "Version Control (Git)"
description: >
  Pelajari model data Git dan cara menggunakan Git untuk version control dan kolaborasi.
thumbnail: /static/assets/thumbnails/2020/lec6.png
date: 2020-01-22
ready: true
video:
  aspect: 56.25
  id: 2sjqTHE0zok
---

Sistem version control (VCS) adalah alat yang digunakan untuk melacak perubahan pada kode sumber
(atau koleksi file dan folder lainnya). Sesuai namanya, alat-alat ini
membantu mempertahankan riwayat perubahan; selain itu, mereka memfasilitasi kolaborasi.
VCS melacak perubahan pada sebuah folder dan isinya dalam serangkaian snapshot, di mana
setiap snapshot mencakup seluruh keadaan file/folder dalam sebuah direktori
tingkat atas. VCS juga mempertahankan metadata seperti siapa yang membuat setiap snapshot, pesan
yang terkait dengan setiap snapshot, dan sebagainya.

Mengapa version control berguna? Bahkan ketika Anda bekerja sendiri, version control memungkinkan Anda
melihat snapshot lama dari sebuah proyek, menyimpan log mengapa perubahan tertentu dibuat,
bekerja pada cabang pengembangan yang paralel, dan banyak lagi. Ketika bekerja
dengan orang lain, ini adalah alat yang sangat berharga untuk melihat apa yang telah diubah orang lain,
serta menyelesaikan konflik dalam pengembangan yang bersamaan.

VCS modern juga memungkinkan Anda untuk dengan mudah (dan sering kali secara otomatis) menjawab pertanyaan
seperti:

- Siapa yang menulis modul ini?
- Kapan baris tertentu dari file tertentu ini diedit? Oleh siapa? Mengapa
  diedit?
- Dalam 1000 revisi terakhir, kapan/mengapa unit test tertentu berhenti
  berfungsi?

Meskipun ada VCS lain, **Git** adalah standar de facto untuk version control.
[Komik XKCD](https://xkcd.com/1597/) ini menggambarkan reputasi Git:

![xkcd 1597](https://imgs.xkcd.com/comics/git.png)

Karena antarmuka Git adalah abstraksi yang bocor, mempelajari Git dari atas ke bawah (dimulai
dari antarmuka / command-line interface) dapat menyebabkan banyak kebingungan.
Anda mungkin bisa menghafal beberapa perintah dan menganggapnya sebagai mantra sihir,
dan mengikuti pendekatan dalam komik di atas setiap kali ada yang salah.

Meskipun antarmuka Git memang memiliki antarmuka yang kurang menarik, desain dan ide di baliknya
sangat indah. Meskipun antarmuka yang kurang menarik harus _dihafal_, desain yang indah
dapat _dipahami_. Karena alasan ini, kami memberikan penjelasan Git dari bawah ke atas,
dimulai dari model datanya dan kemudian membahas command-line interface.
Setelah model data dipahami, perintah-perintah dapat dipahami dengan lebih baik dalam
hal bagaimana mereka memanipulasi model data yang mendasarinya.

# Model data Git

Ada banyak pendekatan ad-hoc yang bisa Anda ambil untuk version control. Git memiliki
model yang dirancang dengan baik yang memungkinkan semua fitur bagus dari version control,
seperti mempertahankan riwayat, mendukung cabang, dan memfasilitasi kolaborasi.

## Snapshot

Git memodelkan riwayat koleksi file dan folder dalam sebuah
direktori tingkat atas sebagai serangkaian snapshot. Dalam terminologi Git, sebuah file disebut
"blob", dan isinya hanyalah sekumpulan byte. Sebuah direktori disebut
"tree", dan ia memetakan nama ke blob atau tree (sehingga direktori dapat berisi direktori
lain). Sebuah snapshot adalah tree tingkat atas yang sedang dilacak. Sebagai
contoh, kita mungkin memiliki tree sebagai berikut:

```
<root> (tree)
|
+- foo (tree)
|  |
|  + bar.txt (blob, contents = "hello world")
|
+- baz.txt (blob, contents = "git is wonderful")
```

Tree tingkat atas berisi dua elemen, sebuah tree "foo" (yang berisi
satu elemen, sebuah blob "bar.txt"), dan sebuah blob "baz.txt".

## Memodelkan riwayat: menghubungkan snapshot

Bagaimana seharusnya sistem version control menghubungkan snapshot? Satu model sederhana adalah
memiliki riwayat linear. Sebuah riwayat akan menjadi daftar snapshot dalam urutan waktu.
Karena banyak alasan, Git tidak menggunakan model sederhana seperti ini.

Dalam Git, sebuah riwayat adalah directed acyclic graph (DAG) dari snapshot. Itu mungkin
terdengar seperti istilah matematika yang rumit, tetapi jangan terintimidasi. Yang dimaksud adalah
setiap snapshot dalam Git merujuk pada sekumpulan "parent", yaitu snapshot yang mendahuluinya.
Ini adalah sekumpulan parent daripada satu parent (seperti yang terjadi dalam
riwayat linear) karena sebuah snapshot mungkin berasal dari beberapa parent, misalnya,
karena penggabungan (merge) dua cabang pengembangan yang paralel.

Git menyebut snapshot ini sebagai "commit". Memvisualisasikan riwayat commit mungkin terlihat
seperti ini:

```
o <-- o <-- o <-- o
            ^
             \
              --- o <-- o
```

Dalam gambar ASCII di atas, `o` mewakili commit individual (snapshot).
Panah menunjuk ke parent dari setiap commit (ini adalah relasi "mendahului",
bukan "mengikuti"). Setelah commit ketiga, riwayat bercabang menjadi dua
cabang yang terpisah. Ini mungkin sesuai dengan, misalnya, dua fitur terpisah
yang dikembangkan secara paralel, secara independen satu sama lain. Di masa depan,
cabang-cabang ini dapat digabungkan untuk membuat snapshot baru yang menggabungkan kedua
fitur tersebut, menghasilkan riwayat baru yang terlihat seperti ini, dengan commit merge
yang baru dibuat ditampilkan dalam huruf tebal:

<pre class="highlight">
<code>
o <-- o <-- o <-- o <---- <strong>o</strong>
            ^            /
             \          v
              --- o <-- o
</code>
</pre>

Commit dalam Git bersifat immutable. Ini bukan berarti kesalahan tidak bisa
diperbaiki; hanya saja "edit" pada riwayat commit sebenarnya
membuat commit yang sepenuhnya baru, dan referensi (lihat di bawah) diperbarui untuk menunjuk
ke yang baru.

## Model data, sebagai pseudocode

Mungkin berguna untuk melihat model data Git dituliskan dalam pseudocode:

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

Ini adalah model riwayat yang bersih dan sederhana.

## Object dan content-addressing

Sebuah "object" adalah blob, tree, atau commit:

```
type object = blob | tree | commit
```

Dalam penyimpanan data Git, semua object di-address berdasarkan [hash SHA-1](https://en.wikipedia.org/wiki/SHA-1) mereka.

```
objects = map<string, object>

def store(object):
    id = sha1(object)
    objects[id] = object

def load(id):
    return objects[id]
```

Blob, tree, dan commit disatukan dengan cara ini: semuanya adalah object. Ketika
mereka merujuk ke object lain, mereka sebenarnya tidak _berisi_ object tersebut dalam
representasi di disk mereka, tetapi memiliki referensi ke object tersebut berdasarkan hash-nya.

Sebagai contoh, tree untuk struktur direktori contoh [di atas](#snapshots)
(divisualisasikan menggunakan `git cat-file -p 698281bc680d1995c5f4caaf3359721a5a58d48d`),
terlihat seperti ini:

```
100644 blob 4448adbf7ecd394f42ae135bbeed9676e894af85    baz.txt
040000 tree c68d233a33c5c06e0340e4c224f0afca87c8ce87    foo
```

Tree itu sendiri berisi pointer ke isinya, `baz.txt` (sebuah blob) dan `foo`
(sebuah tree). Jika kita melihat isi yang di-address oleh hash yang sesuai dengan
baz.txt menggunakan `git cat-file -p 4448adbf7ecd394f42ae135bbeed9676e894af85`, kita mendapatkan
hasil berikut:

```
git is wonderful
```

## References

Sekarang, semua snapshot dapat diidentifikasi berdasarkan hash SHA-1 mereka. Itu tidak praktis,
karena manusia tidak pandai mengingat string yang terdiri dari 40 karakter heksadesimal.

Solusi Git untuk masalah ini adalah nama yang mudah dibaca manusia untuk hash SHA-1, yang disebut
"references". References adalah pointer ke commit. Berbeda dengan object yang bersifat
immutable, references bersifat mutable (dapat diperbarui untuk menunjuk ke commit baru).
Sebagai contoh, reference `master` biasanya menunjuk ke commit terbaru di
cabang pengembangan utama.

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

Dengan ini, Git dapat menggunakan nama yang mudah dibaca manusia seperti "master" untuk merujuk ke
snapshot tertentu dalam riwayat, alih-alih string heksadesimal yang panjang.

Satu detail adalah bahwa kita sering kali membutuhkan konsep "di mana kita saat ini" dalam
riwayat, sehingga ketika kita mengambil snapshot baru, kita tahu snapshot itu relatif terhadap apa
(bagaimana kita mengatur field `parents` dari commit). Dalam Git, "di mana kita
saat ini" adalah reference khusus yang disebut "HEAD".

## Repositories

Terakhir, kita dapat mendefinisikan apa (secara kasar) sebuah _repository_ Git: yaitu data
`objects` dan `references`.

Di disk, semua penyimpanan Git adalah object dan referensi: hanya itu yang ada dalam
model data Git. Semua perintah `git` memetakan ke beberapa manipulasi pada DAG commit dengan
menambahkan object dan menambahkan/memperbarui references.

Setiap kali Anda mengetik perintah apa pun, pikirkan manipulasi apa yang
dibuat perintah tersebut pada struktur data graf yang mendasarinya. Sebaliknya, jika Anda
mencoba membuat jenis perubahan tertentu pada DAG commit, misalnya "buang
perubahan yang belum di-commit dan buat ref 'master' menunjuk ke commit `5d83f9e`", ada
kemungkinan ada perintah untuk melakukannya (misalnya dalam kasus ini, `git checkout master; git reset
--hard 5d83f9e`).

# Staging area

Ini adalah konsep lain yang ortogonal terhadap model data, tetapi ini adalah bagian dari
antarmuka untuk membuat commit.

Salah satu cara yang bisa Anda bayangkan untuk mengimplementasikan snapshot seperti yang dijelaskan di atas adalah
dengan memiliki perintah "create snapshot" yang membuat snapshot baru berdasarkan _keadaan
saat ini_ dari direktori kerja. Beberapa alat version control bekerja seperti ini, tetapi
bukan Git. Kita menginginkan snapshot yang bersih, dan mungkin tidak selalu ideal untuk membuat
snapshot dari keadaan saat ini. Misalnya, bayangkan skenario di mana Anda telah
mengimplementasikan dua fitur terpisah, dan Anda ingin membuat dua commit terpisah,
di mana yang pertama memperkenalkan fitur pertama, dan yang berikutnya memperkenalkan
fitur kedua. Atau bayangkan skenario di mana Anda memiliki pernyataan print debugging
yang ditambahkan di seluruh kode Anda, bersama dengan perbaikan bug; Anda ingin meng-commit perbaikan bug
tersebut sambil membuang semua pernyataan print.

Git mengakomodasi skenario seperti ini dengan memungkinkan Anda menentukan modifikasi mana
yang harus disertakan dalam snapshot berikutnya melalui mekanisme yang disebut "staging
area".

# Command-line interface Git

Untuk menghindari duplikasi informasi, kami tidak akan menjelaskan perintah-perintah di bawah ini
secara detail. Lihat [Pro Git](https://git-scm.com/book/en/v2) yang sangat direkomendasikan
untuk informasi lebih lanjut, atau tonton video kuliah.

## Dasar-dasar

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

- `git help <command>`: mendapatkan bantuan untuk perintah git
- `git init`: membuat repo git baru, dengan data disimpan di direktori `.git`
- `git status`: memberi tahu Anda apa yang sedang terjadi
- `git add <filename>`: menambahkan file ke staging area
- `git commit`: membuat commit baru
    - Tulis [pesan commit yang baik](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)!
    - Lebih banyak alasan untuk menulis [pesan commit yang baik](https://chris.beams.io/posts/git-commit/)!
- `git log`: menampilkan log riwayat yang diratakan
- `git log --all --graph --decorate`: memvisualisasikan riwayat sebagai DAG
- `git diff <filename>`: menampilkan perubahan yang Anda buat relatif terhadap staging area
- `git diff <revision> <filename>`: menampilkan perbedaan dalam sebuah file antar snapshot
- `git checkout <revision>`: memperbarui HEAD (dan cabang saat ini jika melakukan checkout sebuah cabang)

## Branching dan merging

{% comment %}

Branching allows you to "fork" version history. It can be helpful for working
on independent features or bug fixes in parallel. The `git branch` command can
be used to create new branches; `git checkout -b <branch name>` creates and
branch and checks it out.

Merging is the opposite of branching: it allows you to combine forked version
histories, e.g. merging a feature branch back into master. The `git merge`
command is used for merging.

{% endcomment %}

- `git branch`: menampilkan cabang-cabang
- `git branch <name>`: membuat sebuah cabang
- `git checkout -b <name>`: membuat sebuah cabang dan beralih ke cabang tersebut
    - sama dengan `git branch <name>; git checkout <name>`
- `git merge <revision>`: menggabungkan ke cabang saat ini
- `git mergetool`: menggunakan alat yang canggih untuk membantu menyelesaikan konflik merge
- `git rebase`: memindahkan sekumpulan patch ke basis baru

## Remotes

- `git remote`: daftar remotes
- `git remote add <name> <url>`: menambahkan sebuah remote
- `git push <remote> <local branch>:<remote branch>`: mengirim object ke remote, dan memperbarui referensi remote
- `git branch --set-upstream-to=<remote>/<remote branch>`: mengatur korespondensi antara cabang lokal dan remote
- `git fetch`: mengambil object/referensi dari sebuah remote
- `git pull`: sama dengan `git fetch; git merge`
- `git clone`: mengunduh repository dari remote

## Undo

- `git commit --amend`: mengedit isi/pesan sebuah commit
- `git reset HEAD <file>`: menghapus file dari staging area
- `git checkout -- <file>`: membatalkan perubahan

# Git Lanjutan

- `git config`: Git [sangat dapat dikustomisasi](https://git-scm.com/docs/git-config)
- `git clone --depth=1`: clone dangkal, tanpa seluruh riwayat versi
- `git add -p`: staging interaktif
- `git rebase -i`: rebasing interaktif
- `git blame`: menampilkan siapa yang terakhir mengedit baris mana
- `git stash`: sementara menghapus modifikasi pada direktori kerja
- `git bisect`: pencarian biner pada riwayat (misalnya untuk regresi)
- `.gitignore`: [menentukan](https://git-scm.com/docs/gitignore) file yang tidak terlacak yang sengaja diabaikan

# Lain-lain

- **GUI**: ada banyak [klien GUI](https://git-scm.com/downloads/guis)
  untuk Git. Kami secara pribadi tidak menggunakannya dan lebih memilih menggunakan
  command-line interface.
- **Integrasi shell**: sangat berguna memiliki status Git sebagai bagian dari
  prompt shell Anda ([zsh](https://github.com/olivierverdier/zsh-git-prompt),
  [bash](https://github.com/magicmonty/bash-git-prompt)). Sering kali sudah termasuk dalam
  framework seperti [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh).
- **Integrasi editor**: serupa dengan di atas, integrasi yang berguna dengan banyak
  fitur. [fugitive.vim](https://github.com/tpope/vim-fugitive) adalah standar
  untuk Vim.
- **Workflow**: kami telah mengajari Anda model data, ditambah beberapa perintah dasar; kami
  tidak memberitahu Anda praktik apa yang harus diikuti ketika bekerja pada proyek besar (dan
  ada [banyak](https://nvie.com/posts/a-successful-git-branching-model/)
  [berbeda](https://www.endoflineblog.com/gitflow-considered-harmful)
  [pendekatan](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)).
- **GitHub**: Git bukan GitHub. GitHub memiliki cara khusus untuk berkontribusi kode
  ke proyek lain, yang disebut [pull
  requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests).
- **Penyedia Git lainnya**: GitHub bukan satu-satunya: ada banyak host repository Git,
  seperti [GitLab](https://about.gitlab.com/) dan
  [BitBucket](https://bitbucket.org/).

# Sumber Daya

- [Pro Git](https://git-scm.com/book/en/v2) adalah **bacaan yang sangat direkomendasikan**.
  Membaca Bab 1--5 seharusnya mengajari Anda sebagian besar yang perlu Anda ketahui untuk menggunakan Git
  dengan mahir, sekarang Anda sudah memahami model datanya. Bab-bab selanjutnya memiliki
  beberapa materi lanjutan yang menarik.
- [Oh Shit, Git!?!](https://ohshitgit.com/) adalah panduan singkat tentang cara memulihkan
  dari beberapa kesalahan umum Git.
- [Git for Computer
  Scientists](https://eagain.net/articles/git-for-computer-scientists/) adalah
  penjelasan singkat tentang model data Git, dengan lebih sedikit pseudocode dan lebih banyak diagram
  yang menarik daripada catatan kuliah ini.
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/)
  adalah penjelasan detail tentang detail implementasi Git di luar hanya model
  data, untuk yang penasaran.
- [How to explain git in simple
  words](https://smusamashah.github.io/blog/2017/10/14/explain-git-in-simple-words)
- [Learn Git Branching](https://learngitbranching.js.org/) adalah permainan
  berbasis browser yang mengajari Anda Git.

# Latihan

1. Jika Anda tidak memiliki pengalaman sebelumnya dengan Git, cobalah membaca beberapa
   bab pertama [Pro Git](https://git-scm.com/book/en/v2) atau ikuti
   tutorial seperti [Learn Git Branching](https://learngitbranching.js.org/). Saat
   Anda mengerjakannya, hubungkan perintah Git dengan model data.
1. Clone [repository untuk
   situs web kelas](https://github.com/missing-semester/missing-semester).
    1. Jelajahi riwayat versi dengan memvisualisasikannya sebagai graf.
    1. Siapa orang terakhir yang memodifikasi `README.md`? (Petunjuk: gunakan `git log` dengan
       sebuah argumen).
    1. Apa pesan commit yang terkait dengan modifikasi terakhir pada
       baris `collections:` di `_config.yml`? (Petunjuk: gunakan `git blame` dan `git
       show`).
1. Kesalahan umum saat belajar Git adalah meng-commit file besar yang seharusnya
   tidak dikelola oleh Git atau menambahkan informasi sensitif. Cobalah menambahkan sebuah file ke
   repository, membuat beberapa commit dan kemudian menghapus file tersebut dari riwayat
   (Anda mungkin ingin melihat
   [ini](https://help.github.com/articles/removing-sensitive-data-from-a-repository/)).
1. Clone beberapa repository dari GitHub, dan modifikasi salah satu file yang ada.
   Apa yang terjadi ketika Anda melakukan `git stash`? Apa yang Anda lihat ketika menjalankan `git log
   --all --oneline`? Jalankan `git stash pop` untuk membatalkan apa yang Anda lakukan dengan `git stash`.
   Dalam skenario apa ini mungkin berguna?
1. Seperti banyak alat command line, Git menyediakan file konfigurasi (atau dotfile)
   yang disebut `~/.gitconfig`. Buat sebuah alias di `~/.gitconfig` sehingga ketika Anda
   menjalankan `git graph`, Anda mendapatkan output dari `git log --all --graph --decorate
   --oneline`. Anda dapat melakukannya dengan secara langsung
   [mengedit](https://git-scm.com/docs/git-config#Documentation/git-config.txt-alias)
   file `~/.gitconfig`, atau Anda dapat menggunakan perintah `git config` untuk menambahkan
   alias. Informasi tentang alias git dapat ditemukan
   [di sini](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases).
1. Anda dapat mendefinisikan pola ignore global di `~/.gitignore_global` setelah menjalankan
   `git config --global core.excludesfile ~/.gitignore_global`. Ini mengatur
   lokasi file ignore global yang akan digunakan Git, tetapi Anda masih perlu
   membuat file tersebut secara manual di path tersebut. Siapkan file gitignore global Anda untuk
   mengabaikan file sementara yang spesifik untuk OS atau editor, seperti `.DS_Store`.
1. Fork [repository untuk situs web
   kelas](https://github.com/missing-semester/missing-semester), temukan typo
   atau beberapa perbaikan lain yang dapat Anda buat, dan ajukan pull request di GitHub
   (Anda mungkin ingin melihat [ini](https://github.com/firstcontributions/first-contributions)).
   Harap hanya mengajukan PR yang berguna (tolong jangan spam kami!). Jika Anda
   tidak dapat menemukan perbaikan yang dapat dibuat, Anda dapat melewati latihan ini.
