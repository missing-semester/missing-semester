---
layout: lecture
title: "Version Control dan Git"
description: >
  Pelajari model data Git dan cara menggunakan Git untuk version control dan kolaborasi.
thumbnail: /static/assets/thumbnails/2026/lec5.png
date: 2026-01-16
ready: true
video:
  aspect: 56.25
  id: 9K8lB61dl3Y
---

Sistem version control (VCS) adalah alat yang digunakan untuk melacak perubahan pada source code
(atau koleksi file dan folder lainnya). Sesuai namanya, alat ini
membantu mempertahankan riwayat perubahan; selain itu, alat ini juga memfasilitasi kolaborasi.
Secara logika, VCS melacak perubahan pada sebuah folder dan isinya dalam serangkaian
_snapshot_, di mana setiap snapshot mencakup keseluruhan state file/folder
dalam direktori tingkat atas. VCS juga menyimpan metadata seperti siapa yang membuat setiap
snapshot, pesan yang terkait dengan setiap snapshot, dan sebagainya.

Mengapa version control berguna? Bahkan ketika Anda bekerja sendiri, version control memungkinkan Anda
melihat snapshot lama dari sebuah proyek, menyimpan log alasan mengapa perubahan tertentu
dibuat, bekerja pada branch pengembangan secara paralel, dan masih banyak lagi. Ketika bekerja
dengan orang lain, ini adalah alat yang sangat berharga untuk melihat apa yang telah diubah oleh orang lain,
serta menyelesaikan konflik dalam pengembangan secara bersamaan.

VCS modern juga memungkinkan Anda untuk dengan mudah (dan sering kali secara otomatis) menjawab pertanyaan
seperti:

- Siapa yang menulis modul ini?
- Kapan baris tertentu dari file tertentu ini diedit? Oleh siapa? Mengapa
  baris ini diedit?
- Dalam 1000 revisi terakhir, kapan/mengapa unit test tertentu berhenti
bekerja?

Meskipun ada VCS lain, **Git** adalah standar de facto untuk version control.
[Komik XKCD](https://xkcd.com/1597/) ini menggambarkan reputasi Git:

![xkcd 1597](https://imgs.xkcd.com/comics/git.png)

Karena antarmuka Git merupakan abstraksi yang bocor, mempelajari Git dari atas ke bawah
(dimulai dari antarmuka / command-line interface) dapat menyebabkan banyak kebingungan.
Anda mungkin bisa menghafal beberapa perintah dan menganggapnya sebagai mantra ajaib,
serta mengikuti pendekatan dalam komik di atas setiap kali ada yang salah.

Meskipun Git memang memiliki antarmuka yang kurang menarik, desain dan ide di baliknya
sangat indah. Meskipun antarmuka yang kurang menarik harus _dihafal_, desain yang indah
dapat _dipahami_. Oleh karena itu, kami memberikan penjelasan Git dari bawah ke atas,
dimulai dari model datanya dan kemudian membahas command-line interface.
Setelah model data dipahami, perintah-perintah dapat lebih dipahami dalam
hal bagaimana mereka memanipulasi model data yang mendasarinya.

# Model data Git

Kejeniusan Git terletak pada model datanya yang dirancang dengan baik yang memungkinkan semua fitur
bagus dari version control, seperti mempertahankan riwayat history, mendukung branch, dan
memungkinkan kolaborasi.

## Snapshot

Git memodelkan riwayat koleksi file dan folder dalam suatu
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
terdengar seperti istilah matematika yang rumit, tetapi jangan terintimidasi. Artinya adalah
setiap snapshot di Git merujuk pada sekumpulan "parent", yaitu snapshot-snapshot yang mendahuluinya.
Ini adalah sekumpulan parent, bukan satu parent (seperti yang terjadi pada
riwayat linear), karena sebuah snapshot bisa berasal dari beberapa parent, misalnya
karena penggabungan (merge) dua branch pengembangan yang paralel.

Git menyebut snapshot-snapshot ini sebagai "commit". Memvisualisasikan riwayat commit mungkin terlihat
seperti ini:

```
o <-- o <-- o <-- o
            ^
             \
              --- o <-- o
```

Dalam ASCII art di atas, `o` mewakili commit individual (snapshot).
Panah menunjuk ke parent dari setiap commit (ini adalah relasi "datang sebelum",
bukan "datang setelah"). Setelah commit ketiga, riwayat bercabang menjadi dua
branch terpisah. Ini mungkin sesuai dengan, misalnya, dua fitur terpisah
yang dikembangkan secara paralel, secara independen satu sama lain. Di masa depan,
branch-branch ini mungkin digabungkan untuk membuat snapshot baru yang mencakup kedua
fitur tersebut, menghasilkan riwayat baru yang terlihat seperti ini, dengan commit merge
yang baru dibuat ditunjukkan dalam huruf tebal:

<pre class="highlight">
<code>
o <-- o <-- o <-- o <---- <strong>o</strong>
            ^            /
             \          v
              --- o <-- o
</code>
</pre>

Commit di Git bersifat immutable. Ini bukan berarti kesalahan tidak bisa
diperbaiki; hanya saja "suntingan" pada riwayat commit sebenarnya
membuat commit yang sama sekali baru, dan referensi (lihat di bawah) diperbarui untuk menunjuk
ke yang baru.

## Model data, dalam pseudocode

Mungkin bermanfaat untuk melihat model data Git dituliskan dalam pseudocode:

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

Dalam penyimpanan data Git, semua object di-address berdasarkan [hash
SHA-1](https://en.wikipedia.org/wiki/SHA-1) mereka.

```
objects = map<string, object>

def store(object):
    id = sha1(object)
    objects[id] = object

def load(id):
    return objects[id]
```

Blob, tree, dan commit disatukan dengan cara ini: mereka semua adalah object. Ketika
mereka mereferensikan object lain, mereka sebenarnya tidak _berisi_ object tersebut dalam
representasi on-disk mereka, tetapi memiliki referensi ke object tersebut melalui hash-nya.

Sebagai contoh, tree untuk struktur direktori contoh [di atas](#snapshots)
(divisualisasikan menggunakan `git cat-file -p 698281bc680d1995c5f4caaf3359721a5a58d48d`),
terlihat seperti ini:

```
100644 blob 4448adbf7ecd394f42ae135bbeed9676e894af85    baz.txt
040000 tree c68d233a33c5c06e0340e4c224f0afca87c8ce87    foo
```

Tree itu sendiri berisi pointer ke isinya, `baz.txt` (sebuah blob) dan `foo`
(sebuah tree). Jika kita melihat isi yang di-address oleh hash yang sesuai dengan
baz.txt menggunakan `git cat-file -p 4448adbf7ecd394f42ae135bbeed9676e894af85`, kita mendapatkan:

```
git is wonderful
```

## Reference

Sekarang, semua snapshot dapat diidentifikasi oleh hash SHA-1 mereka. Itu tidak praktis,
karena manusia tidak pandai mengingat string yang terdiri dari 40 karakter heksadesimal.

Solusi Git untuk masalah ini adalah nama yang mudah dibaca manusia untuk hash SHA-1, yang disebut
"reference". Reference adalah pointer ke commit. Berbeda dengan object yang bersifat
immutable, reference bersifat mutable (dapat diperbarui untuk menunjuk ke commit yang baru).
Sebagai contoh, reference `master` biasanya menunjuk ke commit terbaru di
branch utama pengembangan.

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

Satu detail adalah kita sering kali membutuhkan konsep "di mana kita saat ini" dalam
riwayat, sehingga ketika kita mengambil snapshot baru, kita tahu snapshot itu relatif terhadap apa
(bagaimana kita mengatur field `parents` dari commit). Di Git, "di mana kita
saat ini" adalah reference khusus yang disebut "HEAD".

## Repository

Terakhir, kita dapat mendefinisikan apa yang (kira-kira) merupakan _repository_ Git: yaitu data
`objects` dan `references`.

Di disk, semua penyimpanan Git adalah object dan reference: hanya itu model data Git.
Semua perintah `git` memetakan ke beberapa manipulasi pada DAG commit dengan
menambahkan object dan menambahkan/memperbarui reference.

Setiap kali Anda mengetik perintah apa pun, pikirkanlah manipulasi apa yang
dibuat perintah tersebut pada struktur data graph yang mendasarinya. Sebaliknya, jika Anda
mencoba membuat perubahan tertentu pada DAG commit, misalnya "buang perubahan yang belum
di-commit dan buat ref 'master' menunjuk ke commit `5d83f9e`", kemungkinan ada
perintah untuk melakukannya (misalnya dalam kasus ini, `git checkout master; git reset
--hard 5d83f9e`).

# Staging area

Ini adalah konsep lain yang ortogonal terhadap model data, tetapi merupakan bagian dari
antarmuka untuk membuat commit.

Salah satu cara yang mungkin Anda bayangkan untuk mengimplementasikan snapshot seperti yang dijelaskan di atas adalah
dengan memiliki perintah "create snapshot" yang membuat snapshot baru berdasarkan _state
saat ini_ dari working directory. Beberapa alat version control bekerja seperti ini, tetapi
bukan Git. Kita menginginkan snapshot yang bersih, dan mungkin tidak selalu ideal untuk membuat
snapshot dari state saat ini. Sebagai contoh, bayangkan skenario di mana Anda telah
mengimplementasikan dua fitur terpisah, dan Anda ingin membuat dua commit terpisah,
di mana yang pertama memperkenalkan fitur pertama, dan yang berikutnya memperkenalkan
fitur kedua. Atau bayangkan skenario di mana Anda memiliki print statement untuk debugging
yang ditambahkan di seluruh kode Anda, bersama dengan sebuah bugfix; Anda ingin meng-commit bugfix
tersebut sambil membuang semua print statement.

Git mengakomodasi skenario seperti ini dengan memungkinkan Anda menentukan modifikasi mana
yang harus disertakan dalam snapshot berikutnya melalui mekanisme yang disebut "staging
area".

# Command-line interface Git

Untuk menghindari duplikasi informasi, kami tidak akan menjelaskan perintah-perintah di bawah ini
secara detail dalam catatan kuliah ini. Lihat [Pro
Git](https://git-scm.com/book/en/v2) yang sangat direkomendasikan untuk informasi lebih lanjut, atau tonton video
kuliah.

## Dasar-dasar

- `git help <command>`: mendapatkan bantuan untuk perintah git
- `git init`: membuat repo git baru, dengan data disimpan di direktori `.git`
- `git status`: memberi tahu Anda apa yang sedang terjadi
- `git add <filename>`: menambahkan file ke staging area
- `git commit`: membuat commit baru
    - Tulis [pesan commit yang baik](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)!
    - Alasan tambahan untuk menulis [pesan commit yang baik](https://chris.beams.io/posts/git-commit/)!
- `git log`: menampilkan log riwayat yang diratakan
- `git log --all --graph --decorate`: memvisualisasikan riwayat sebagai DAG
- `git diff <filename>`: menampilkan perubahan yang Anda buat relatif terhadap staging area
- `git diff <revision> <filename>`: menampilkan perbedaan dalam file antar snapshot
- `git checkout <revision>`: memperbarui HEAD (dan branch saat ini jika melakukan checkout sebuah branch)

## Branching dan merging

- `git branch`: menampilkan branch
- `git branch <name>`: membuat branch
- `git switch <name>`: berpindah ke branch
- `git checkout -b <name>`: membuat branch dan berpindah ke branch tersebut
    - sama dengan `git branch <name>; git switch <name>`
- `git merge <revision>`: menggabungkan ke branch saat ini
- `git mergetool`: menggunakan alat bantu untuk membantu menyelesaikan konflik merge
- `git rebase`: rebase sekumpulan patch ke base yang baru

## Remote

- `git remote`: daftar remote
- `git remote add <name> <url>`: menambahkan remote
- `git push <remote> <local branch>:<remote branch>`: mengirim object ke remote, dan memperbarui reference remote
- `git branch --set-upstream-to=<remote>/<remote branch>`: mengatur korespondensi antara branch lokal dan remote
- `git fetch`: mengambil object/reference dari remote
- `git pull`: sama dengan `git fetch; git merge`
- `git clone`: mengunduh repository dari remote

## Undo

- `git commit --amend`: mengedit isi/pesan commit
- `git reset <file>`: menghapus file dari staging area
- `git restore`: membuang perubahan

# Git Lanjutan

- `git config`: Git [sangat dapat dikustomisasi](https://git-scm.com/docs/git-config)
- `git clone --depth=1`: shallow clone, tanpa seluruh riwayat versi
- `git add -p`: staging interaktif
- `git rebase -i`: rebasing interaktif
- `git blame`: menampilkan siapa yang terakhir mengedit baris tertentu
- `git stash`: menghapus sementara modifikasi pada working directory
- `git bisect`: pencarian biner pada riwayat (misalnya untuk regresi)
- `git revert`: membuat commit baru yang membalik efek dari commit sebelumnya
- `git worktree`: checkout beberapa branch secara bersamaan
- `.gitignore`: [menentukan](https://git-scm.com/docs/gitignore) file yang sengaja tidak dilacak untuk diabaikan

# Lain-lain

- **GUI**: ada banyak [klien GUI](https://git-scm.com/downloads/guis)
untuk Git. Kami pribadi tidak menggunakannya dan lebih memilih menggunakan
command-line interface.
- **Integrasi shell**: sangat berguna untuk memiliki status Git sebagai bagian dari
prompt shell Anda ([zsh](https://github.com/olivierverdier/zsh-git-prompt),
[bash](https://github.com/magicmonty/bash-git-prompt)). Seringkali sudah termasuk dalam
framework seperti [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh).
- **Integrasi editor**: serupa dengan di atas, integrasi yang berguna dengan banyak
fitur. [fugitive.vim](https://github.com/tpope/vim-fugitive) adalah standar
untuk Vim.
- **Workflow**: kami mengajarkan Anda model data, ditambah beberapa perintah dasar; kami
tidak memberitahu Anda praktik apa yang harus diikuti ketika mengerjakan proyek besar (dan
ada [banyak](https://nvie.com/posts/a-successful-git-branching-model/)
[berbeda](https://www.endoflineblog.com/gitflow-considered-harmful)
[pendekatan](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)).
- **GitHub**: Git bukan GitHub. GitHub memiliki cara khusus untuk berkontribusi kode
ke proyek lain, yang disebut [pull
request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests).
- **Penyedia Git lainnya**: GitHub bukanlah yang istimewa: ada banyak penyedia
repository Git, seperti [GitLab](https://about.gitlab.com/) dan
[BitBucket](https://bitbucket.org/).

# Sumber Daya

- [Pro Git](https://git-scm.com/book/en/v2) adalah **bacaan yang sangat direkomendasikan**.
Membaca Bab 1--5 seharusnya mengajarkan Anda sebagian besar yang perlu Anda ketahui untuk menggunakan Git
dengan mahir, sekarang Anda sudah memahami model datanya. Bab-bab selanjutnya memiliki
beberapa materi menarik dan lanjutan.
- [Oh Shit, Git!?!](https://ohshitgit.com/) adalah panduan singkat tentang cara memulihkan
dari beberapa kesalahan umum Git.
- [Git for Computer
Scientists](https://eagain.net/articles/git-for-computer-scientists/) adalah
penjelasan singkat tentang model data Git, dengan lebih sedikit pseudocode dan lebih banyak diagram
yang bagus daripada catatan kuliah ini.
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/)
adalah penjelasan detail tentang detail implementasi Git di luar hanya model
data, bagi yang penasaran.
- [How to explain git in simple
words](https://smusamashah.github.io/blog/2017/10/14/explain-git-in-simple-words)
- [Learn Git Branching](https://learngitbranching.js.org/) adalah game
berbasis browser yang mengajari Anda Git.

# Latihan

1. Jika Anda belum memiliki pengalaman dengan Git, cobalah membaca beberapa
   bab pertama [Pro Git](https://git-scm.com/book/en/v2) atau ikuti
   tutorial seperti [Learn Git Branching](https://learngitbranching.js.org/). Saat
   Anda mengerjakannya, hubungkan perintah-perintah Git dengan model data.
1. Clone [repository untuk
   website kelas](https://github.com/missing-semester/missing-semester).
    1. Jelajahi riwayat versi dengan memvisualisasikannya sebagai graph.
    1. Siapa orang terakhir yang memodifikasi `README.md`? (Petunjuk: gunakan `git log` dengan
       sebuah argumen).
    1. Apa pesan commit yang terkait dengan modifikasi terakhir pada
       baris `collections:` di `_config.yml`? (Petunjuk: gunakan `git blame` dan `git
       show`).
1. Kesalahan umum saat belajar Git adalah meng-commit file besar yang seharusnya
   tidak dikelola oleh Git atau menambahkan informasi sensitif. Cobalah menambahkan file ke
   repository, membuat beberapa commit, kemudian menghapus file tersebut dari _riwayat_
   (bukan hanya dari commit terbaru). Anda mungkin ingin melihat
   [ini](https://help.github.com/articles/removing-sensitive-data-from-a-repository/).
1. Clone beberapa repository dari GitHub, dan modifikasi salah satu file yang ada.
   Apa yang terjadi ketika Anda melakukan `git stash`? Apa yang Anda lihat ketika menjalankan `git log
   --all --oneline`? Jalankan `git stash pop` untuk membatalkan apa yang Anda lakukan dengan `git stash`.
   Dalam skenario apa ini mungkin berguna?
1. Seperti banyak alat command line, Git menyediakan file konfigurasi (atau dotfile)
   yang disebut `~/.gitconfig`. Buat sebuah alias di `~/.gitconfig` sehingga ketika Anda
   menjalankan `git graph`, Anda mendapatkan output dari `git log --all --graph --decorate
   --oneline`. Anda dapat melakukannya dengan langsung
   [mengedit](https://git-scm.com/docs/git-config#Documentation/git-config.txt-alias)
   file `~/.gitconfig`, atau Anda dapat menggunakan perintah `git config` untuk menambahkan
   alias. Informasi tentang alias git dapat ditemukan
   [di sini](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases).
1. Anda dapat mendefinisikan pola ignore global di `~/.gitignore_global` setelah menjalankan
   `git config --global core.excludesfile ~/.gitignore_global`. Ini mengatur
   lokasi file ignore global yang akan digunakan Git, tetapi Anda masih perlu
   membuat file tersebut secara manual di path itu. Siapkan file gitignore global Anda untuk
   mengabaikan file sementara khusus OS atau editor, seperti `.DS_Store`.
1. Fork [repository untuk
   website kelas](https://github.com/missing-semester/missing-semester), temukan typo
   atau perbaikan lain yang dapat Anda buat, dan ajukan pull request di GitHub
   (Anda mungkin ingin melihat [ini](https://github.com/firstcontributions/first-contributions)).
   Harap hanya ajukan PR yang berguna (jangan spam kami!). Jika Anda
   tidak dapat menemukan perbaikan untuk dibuat, Anda dapat melewati latihan ini.
1. Latih menyelesaikan konflik merge dengan mensimulasikan skenario kolaboratif:
    1. Buat repository baru dengan `git init` dan buat file bernama
       `recipe.txt` dengan beberapa baris (misalnya, resep sederhana).
    1. Commit, lalu buat dua branch: `git branch salty` dan `git branch
       sweet`.
    1. Di branch `salty`, modifikasi sebuah baris (misalnya, ubah "1 cup sugar" menjadi "1
       cup salt") dan commit.
    1. Di branch `sweet`, modifikasi baris yang sama secara berbeda (misalnya, ubah "1
       cup sugar" menjadi "2 cups sugar") dan commit.
    1. Sekarang pindah ke `master` dan coba `git merge salty`, lalu `git merge
       sweet`. Apa yang terjadi? Lihat isi dari `recipe.txt` - apa arti
       marker `<<<<<<<`, `=======`, dan `>>>>>>>`?
    1. Selesaikan konflik dengan mengedit file untuk menyimpan konten yang Anda inginkan,
       menghapus marker konflik, dan menyelesaikan merge dengan `git add`
       dan `git commit` (atau `git merge --continue`). Atau, coba gunakan
       `git mergetool` untuk menyelesaikan konflik dengan alat merge grafis atau
       berbasis terminal.
    1. Gunakan `git log --graph --oneline` untuk memvisualisasikan riwayat merge yang baru
       saja Anda buat.
