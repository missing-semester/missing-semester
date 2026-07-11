---
layout: lecture
title: "Kontrol Versi"
presenter: Jon
date: 2019-01-22
order: 2
video:
  aspect: 56.25
  id: 3fig2Vz8QXs
---

Setiap kali Anda mengerjakan sesuatu yang berubah seiring waktu, sangat
bermanfaat untuk dapat _melacak_ perubahan-perubahan tersebut. Hal ini bisa
disebabkan oleh sejumlah alasan: Anda mendapatkan catatan tentang apa yang
berubah, bagaimana cara membatalkannya, siapa yang mengubahnya, dan bahkan
mungkin alasannya. Sistem kontrol versi (VCS) memberikan Anda kemampuan
tersebut. Sistem ini memungkinkan Anda untuk _commit_ perubahan pada
sekumpulan file, beserta pesan yang mendeskripsikan perubahan tersebut,
serta melihat dan membatalkan perubahan yang telah Anda buat di masa lalu.

Sebagian besar VCS mendukung berbagi riwayat commit antar beberapa pengguna.
Hal ini memungkinkan kolaborasi yang nyaman: Anda dapat melihat perubahan
yang telah saya buat, dan saya dapat melihat perubahan yang telah Anda buat.
Dan karena VCS melacak _perubahan_, sistem ini sering kali (meskipun tidak
selalu) dapat mengetahui cara menggabungkan perubahan-perubahan kita selama
perubahan tersebut menyentuh hal-hal yang relatif tidak tumpang tindih.

Ada [_sangat
banyak_](https://en.wikipedia.org/wiki/Comparison_of_version-control_software)
VCS di luar sana yang sangat berbeda dalam hal apa yang mereka dukung,
bagaimana cara kerjanya, dan bagaimana Anda berinteraksi dengan mereka. Di
sini, kita akan fokus pada [git](https://git-scm.com/), salah satu yang
paling umum digunakan, tetapi saya juga menyarankan Anda untuk melihat
[Mercurial](https://www.mercurial-scm.org/).

Dengan semua itu -- mari langsung ke intinya!

## Apakah git itu sihir gelap?

tidak juga.. Anda perlu memahami model datanya.
kita akan melewati beberapa detail, tetapi secara garis besar,
"sesuatu" _inti_ dalam git adalah commit.

 - setiap commit memiliki nama unik, "revision hash"
   hash panjang seperti `998622294a6c520db718867354bf98348ae3c7e2`
   sering disingkat menjadi prefiks (yang cukup) unik: `9986222`
 - commit memiliki penulis + pesan commit
 - juga memiliki hash dari _commit ancestor_ (nenek moyang)
   biasanya hanya hash dari commit sebelumnya
 - commit juga mewakili _diff_, representasi dari bagaimana Anda bisa sampai
   dari ancestor commit ke commit tersebut (misalnya, hapus baris ini di
   file ini, tambahkan baris-baris ini di file ini, ganti nama file itu,
   dll.)
   - pada kenyataannya, git menyimpan keadaan penuh sebelum dan sesudah
   - mungkin tidak ingin menyimpan file besar yang berubah!

pada awalnya, _repository_ (kurang lebih: folder yang dikelola git) tidak
memiliki konten, dan tidak ada commit. mari kita siapkan:

```console
$ git init hackers
$ cd hackers
$ git status
```

output di sini sebenarnya memberikan kita titik awal yang baik. mari kita
gali lebih dalam dan pastikan kita memahami semuanya.

pertama, "On branch master".

 - tidak ingin menggunakan hash setiap saat.
 - branch adalah nama yang menunjuk ke hash.
 - master secara tradisional adalah nama untuk commit "terbaru".
   setiap kali commit baru dibuat, nama master akan dibuat untuk
   menunjuk ke hash commit baru tersebut.
 - nama khusus `HEAD` merujuk ke nama "saat ini"
 - Anda juga dapat membuat nama sendiri dengan `git branch` (atau `git tag`)
   kita akan kembali ke hal itu

mari kita lewati "No commits yet" karena memang hanya itu isinya.

kemudian, "nothing to commit".

 - setiap commit berisi diff dengan semua perubahan yang Anda buat.
   tetapi bagaimana diff tersebut dibuat pada awalnya?
 - _bisa saja_ selalu commit _semua_ perubahan yang telah Anda buat sejak
   commit terakhir
   - terkadang Anda hanya ingin commit sebagian saja (misalnya, bukan `TODO`)
   - terkadang Anda ingin memecah satu perubahan menjadi beberapa commit
     untuk memberikan pesan commit yang terpisah untuk masing-masing
 - git memungkinkan Anda untuk _stage_ perubahan untuk menyusun sebuah commit
   - tambahkan perubahan ke file atau beberapa file ke staged changes dengan
     `git add`
     - tambahkan hanya beberapa perubahan dalam satu file dengan `git add -p`
     - tanpa argumen `git add` beroperasi pada "semua file yang diketahui"
   - hapus file dan stage penghapusannya dengan `git rm`
   - kosongkan kumpulan staged changes dengan `git reset`
     - perhatikan bahwa ini *tidak* mengubah file Anda sama sekali!
       ini *hanya* berarti tidak ada perubahan yang akan dimasukkan ke commit
     - untuk menghapus hanya beberapa staged changes:
       `git reset FILE` atau `git reset -p`
   - periksa staged changes dengan `git diff --staged`
   - lihat sisa perubahan dengan `git diff`
   - ketika Anda puas dengan stage, buat commit dengan `git commit`
     - jika Anda hanya ingin commit *semua* perubahan: `git commit -a`
     - `git help add` memiliki banyak informasi berguna lainnya

saat Anda mencoba perintah-perintah di atas, cobalah menjalankan `git status`
untuk melihat apa yang git pikirkan sedang Anda lakukan -- ternyata sangat
membantu!

## Sebuah commit, kata Anda...

oke, kita punya commit, lalu apa?

 - kita bisa melihat perubahan terbaru: `git log` (atau `git log --oneline`)
 - kita bisa melihat perubahan lengkap: `git log -p`
 - kita bisa menampilkan commit tertentu: `git show master`
   - atau dengan `-p` untuk diff/patch lengkap
 - kita bisa kembali ke keadaan pada suatu commit menggunakan
   `git checkout NAME`
   - jika `NAME` adalah hash commit, git mengatakan kita "detached". ini
     hanya berarti tidak ada `NAME` yang merujuk ke commit ini, jadi jika
     kita membuat commit, tidak ada yang akan mengetahuinya.
 - kita bisa membatalkan perubahan dengan `git revert NAME`
   - menerapkan diff di commit pada `NAME` secara terbalik.
 - kita bisa membandingkan versi lama dengan yang ini menggunakan
   `git diff NAME..`
   - `a..b` adalah _range_ commit. jika salah satu dikosongkan, itu berarti
     `HEAD`.
 - kita bisa menampilkan semua commit di antaranya dengan `git log NAME..`
   - `-p` juga berfungsi di sini
 - kita bisa mengubah `master` untuk menunjuk ke commit tertentu (secara
   efektif membatalkan semuanya sejak saat itu) dengan `git reset NAME`:
   - loh, kenapa? bukannya `reset` untuk mengubah staged changes?
     reset memiliki bentuk "kedua" (lihat `git help reset`) yang mengatur
     `HEAD` ke commit yang ditunjuk oleh nama yang diberikan.
   - perhatikan bahwa ini tidak mengubah file apapun -- `git diff` sekarang
     secara efektif menunjukkan `git diff NAME..`.

## Apa arti sebuah nama?

jelas, nama-nama penting dalam git. dan nama-nama tersebut adalah kunci untuk
memahami *banyak* hal yang terjadi di git. sejauh ini, kita telah membahas
tentang hash commit, master, dan `HEAD`. tetapi masih ada lagi!

 - Anda dapat membuat branch sendiri (seperti master) dengan `git branch b`
   - membuat nama baru, `b`, yang menunjuk ke commit di `HEAD`
   - Anda masih "berada di" master, jadi jika Anda membuat commit baru,
     master akan menunjuk ke commit baru tersebut, `b` tidak.
   - beralih ke branch dengan `git checkout b`
     - setiap commit yang Anda buat sekarang akan memperbarui nama `b`
     - beralih kembali ke master dengan `git checkout master`
       - semua perubahan Anda di `b` tersembunyi
     - cara yang sangat berguna untuk dapat menguji perubahan dengan mudah
 - tag adalah nama-nama lain yang tidak pernah berubah, dan memiliki pesan
   tersendiri. sering digunakan untuk menandai rilis + changelog.
 - `NAME^` berarti "commit sebelum `NAME`"
   - dapat diterapkan secara rekursif: `NAME^^^`
   - Anda _kemungkinan besar_ menggunakan `~` ketika Anda menggunakan `~`
     - `~` bersifat "temporal", sedangkan `^` mengikuti ancestor
     - `~~` sama dengan `^^`
     - dengan `~` Anda juga bisa menulis `X~3` untuk "3 commit lebih lama
       dari `X`"
     - Anda tidak menginginkan `^3`
   - `git diff HEAD^`
 - `-` berarti "nama sebelumnya"
 - sebagian besar perintah beroperasi pada `HEAD` kecuali Anda memberikan
   argumen lain

## Bersihkan kekacauan Anda

riwayat commit Anda akan _sangat_ sering berakhir seperti:

 - `add feature x` -- mungkin bahkan dengan pesan commit tentang `x`!
 - `forgot to add file`
 - `fix bug`
 - `typo`
 - `typo2`
 - `actually fix`
 - `actually actually fix`
 - `tests pass`
 - `fix example code`
 - `typo`
 - `x`
 - `x`
 - `x`
 - `x`

itu _tidak masalah_ bagi git, tetapi tidak sangat membantu untuk diri Anda
di masa depan, atau untuk orang lain yang ingin tahu apa yang telah berubah.
git memungkinkan Anda untuk membersihkan hal-hal ini:

 - `git commit --amend`: gabungkan staged changes ke commit sebelumnya
   - perhatikan bahwa ini _mengubah_ commit sebelumnya, memberinya hash baru!
 - `git rebase -i HEAD~13` itu _ajaib_.
   untuk setiap commit dari 13 terakhir, pilih apa yang harus dilakukan:
   - default adalah `pick`; tidak melakukan apa-apa
   - `r`: ubah pesan commit
   - `e`: ubah commit (tambah atau hapus file)
   - `s`: gabungkan commit dengan yang sebelumnya dan edit pesan commit
   - `f`: "fixup" -- gabungkan commit dengan yang sebelumnya; buang pesan
     commit
   - pada akhirnya, `HEAD` dibuat untuk menunjuk ke apa yang sekarang menjadi
     commit terakhir
   - sering disebut sebagai _squashing_ commit
   - yang sebenarnya dilakukan: memundurkan `HEAD` ke titik awal rebase,
     kemudian menerapkan kembali commit-commit secara berurutan sesuai
     arahan.
 - `git reset --hard NAME`: reset keadaan semua file ke keadaan pada `NAME`
   (atau `HEAD` jika tidak ada nama yang diberikan). berguna untuk membatalkan
   perubahan.

## Bermain dengan orang lain

kasus penggunaan umum dari kontrol versi adalah memungkinkan beberapa orang
untuk membuat perubahan pada sekumpulan file tanpa saling mengganggu. atau
lebih tepatnya, untuk memastikan bahwa _jika_ mereka saling mengganggu,
mereka tidak akan secara diam-diam menimpa perubahan satu sama lain.

git adalah VCS _terdistribusi_: setiap orang memiliki salinan lokal dari
seluruh repository (yah, dari semua yang orang lain pilih untuk dipublikasikan).
beberapa VCS bersifat _tersentralisasi_ (misalnya, subversion): sebuah server
memiliki semua commit, klien hanya memiliki file yang telah mereka "checkout".
pada dasarnya, mereka hanya memiliki file _saat ini_, dan perlu bertanya ke
server jika mereka menginginkan hal lain.

setiap salinan repository git dapat didaftarkan sebagai "remote". Anda dapat
menyalin repository git yang sudah ada menggunakan `git clone ADDRESS`
(bukan `git init`). ini membuat remote bernama _origin_ yang menunjuk ke
`ADDRESS`. Anda dapat mengambil nama-nama dan commit yang mereka tunjukkan
dari remote dengan `git fetch REMOTE`. semua nama di remote tersedia untuk
Anda sebagai `REMOTE/NAME`, dan Anda dapat menggunakannya seperti nama lokal.

jika Anda memiliki akses tulis ke remote, Anda dapat mengubah nama-nama di
remote untuk menunjuk ke commit yang telah Anda buat menggunakan `git push`.
misalnya, mari kita buat nama master (branch) di remote `origin` menunjuk ke
commit yang saat ini ditunjuk oleh branch master kita:

   - `git push origin master:master`
   - untuk kemudahan, Anda dapat mengatur `origin/master` sebagai target
     default ketika Anda `git push` dari branch saat ini dengan `-u`
   - pertimbangkan: apa yang dilakukan ini? `git push origin master:HEAD^`

sering kali Anda akan menggunakan GitHub, GitLab, BitBucket, atau yang lainnya
sebagai remote. tidak ada yang "spesial" tentang hal itu sejauh yang git
khawatirkan. semuanya hanya nama dan commit. jika seseorang membuat perubahan
pada master dan memperbarui `github/master` untuk menunjuk ke commit mereka
(kita akan kembali ke hal itu sebentar lagi), maka ketika Anda
`git fetch github`, Anda akan dapat melihat perubahan mereka dengan
`git log github/master`.

## Bekerja dengan orang lain

sejauh ini, branch tampaknya tidak berguna: Anda dapat membuatnya, melakukan
pekerjaan di atasnya, tetapi lalu apa? pada akhirnya, Anda hanya akan membuat
master menunjuk ke mereka, bukan?

 - bagaimana jika Anda harus memperbaiki sesuatu saat mengerjakan fitur besar?
 - bagaimana jika orang lain membuat perubahan pada master sementara itu?

pada akhirnya, Anda harus _merge_ perubahan di satu branch dengan perubahan di
branch lain, apakah perubahan tersebut dibuat oleh Anda atau orang lain. git
memungkinkan Anda melakukan ini dengan, tidak mengherankan, `git merge NAME`.
`merge` akan:

 - mencari titik terbaru di mana `HEAD` dan `NAME` berbagi commit ancestor
   (yaitu, di mana mereka bercabang)
 - (mencoba) menerapkan semua perubahan tersebut ke `HEAD` saat ini
 - menghasilkan commit yang berisi semua perubahan tersebut, dan mencantumkan
   `HEAD` dan `NAME` sebagai ancestor-nya
 - mengatur `HEAD` ke hash commit tersebut

setelah fitur besar Anda selesai, Anda dapat menggabungkan branch-nya ke
master, dan git akan memastikan Anda tidak kehilangan perubahan dari branch
manapun!

jika Anda pernah menggunakan git di masa lalu, Anda mungkin mengenali `merge`
dengan nama yang berbeda: `pull`. ketika Anda melakukan `git pull REMOTE BRANCH`,
itu adalah:

 - `git fetch REMOTE`
 - `git merge REMOTE/BRANCH`
 - di mana, seperti `push`, `REMOTE` dan `BRANCH` sering dihilangkan dan
   menggunakan remote branch "tracking" (ingat `-u`?)

ini biasanya bekerja dengan _sangat baik_. selama perubahan pada branch yang
digabungkan tidak tumpang tindih. jika tumpang tindih, Anda mendapatkan _merge
conflict_. terdengar menakutkan...

 - merge conflict hanyalah git yang memberi tahu Anda bahwa git tidak tahu
   seperti apa diff akhirnya
 - git berhenti sejenak dan meminta Anda untuk menyelesaikan staging "merge
   commit"
 - buka file yang konflik di editor Anda dan cari banyak tanda kurung siku
   (`<<<<<<<`). bagian di atas `=======` adalah perubahan yang dibuat di
   `HEAD` sejak commit ancestor bersama. bagian di bawah adalah perubahan
   yang dibuat di `NAME` sejak commit bersama.
 - `git mergetool` cukup berguna -- membuka editor diff
 - setelah Anda _menyelesaikan_ konflik dengan mengetahui seperti apa file
   yang seharusnya, stage perubahan tersebut dengan `git add`.
 - ketika semua konflik telah diselesaikan, selesaikan dengan `git commit`
   - Anda bisa menyerah dengan `git merge --abort`

Anda baru saja menyelesaikan merge conflict git pertama Anda! \o/
sekarang Anda dapat mempublikasikan perubahan yang telah selesai dengan
`git push`

## Ketika dunia bertabrakan

ketika Anda `push`, git memeriksa bahwa tidak ada pekerjaan orang lain yang
hilang jika Anda memperbarui nama remote yang Anda push. git melakukan ini
dengan memeriksa bahwa commit saat ini dari nama remote adalah ancestor dari
commit yang Anda push. jika ya, git dapat dengan aman hanya memperbarui nama
tersebut; ini disebut _fast-forwarding_. jika tidak, git akan menolak untuk
memperbarui nama remote, dan memberi tahu Anda bahwa ada perubahan.

jika push Anda ditolak, apa yang Anda lakukan?

 - gabungkan perubahan remote dengan `git pull` (yaitu, `fetch` + `merge`)
 - paksa push dengan `--force`: ini akan menghilangkan perubahan orang lain!
   - ada juga `--force-with-lease`, yang hanya akan memaksa perubahan jika
     nama remote belum berubah sejak terakhir kali Anda mengambil dari remote
     tersebut. jauh lebih aman!
   - jika Anda telah melakukan rebase commit lokal yang sebelumnya Anda push
     ("menulis ulang riwayat"; sebaiknya jangan lakukan ini), Anda harus
     force push. pikirkan kenapa!
 - coba terapkan kembali perubahan Anda "di atas" perubahan yang dibuat di
   remote
   - ini adalah `rebase`!
     - mundurkan semua commit lokal sejak ancestor bersama
     - fast-forward `HEAD` ke commit di nama remote
     - terapkan commit lokal secara berurutan
       - mungkin ada konflik yang harus Anda selesaikan secara manual
       - `git rebase --continue` atau `--abort`
     - lebih banyak [di sini](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)
   - `git pull --rebase` akan memulai proses ini untuk Anda
   - apakah Anda harus merge atau rebase adalah topik yang panas! beberapa
     bacaan bagus:
     - [ini](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)
     - [ini](https://web.archive.org/web/20210106220723/https://derekgourlay.com/blog/git-when-to-merge-vs-when-to-rebase/)
     - [ini](https://stackoverflow.com/questions/804115/when-do-you-use-git-rebase-instead-of-git-merge)

# Bacaan lebih lanjut

[![XKCD tentang git](https://imgs.xkcd.com/comics/git.png)](https://xkcd.com/1597/)

 - [Learn git branching](https://learngitbranching.js.org/)
 - [How to explain git in simple words](https://smusamashah.github.io/blog/2017/10/14/explain-git-in-simple-words)
 - [Git from the bottom up](https://jwiegley.github.io/git-from-the-bottom-up/)
 - [Git for computer scientists](https://eagain.net/articles/git-for-computer-scientists/)
 - [Oh shit, git!](https://ohshitgit.com/)
 - [The Pro Git book](https://git-scm.com/book/en/v2)

# Latihan

1. Pada sebuah repo, cobalah memodifikasi file yang sudah ada. Apa yang terjadi ketika Anda menjalankan `git stash`? Apa yang Anda lihat ketika menjalankan `git log --all --oneline`? Jalankan `git stash pop` untuk membatalkan apa yang Anda lakukan dengan `git stash`. Dalam skenario apa hal ini mungkin berguna?

1. Kesalahan umum saat belajar git adalah melakukan commit file besar yang seharusnya tidak dikelola oleh git atau menambahkan informasi sensitif. Cobalah menambahkan file ke repository, membuat beberapa commit, lalu menghapus file tersebut dari riwayat (Anda mungkin ingin melihat [ini](https://help.github.com/articles/removing-sensitive-data-from-a-repository/)). Juga jika Anda ingin git mengelola file besar untuk Anda, pelajari tentang [Git-LFS](https://git-lfs.github.com/)

1. Git sangat nyaman untuk membatalkan perubahan, tetapi seseorang harus terbiasa bahkan dengan perubahan yang paling tidak mungkin
   1. Jika sebuah file secara tidak sengaja dimodifikasi dalam suatu commit, file tersebut dapat dikembalikan dengan `git revert`. Namun jika sebuah commit melibatkan beberapa perubahan, `revert` mungkin bukan pilihan terbaik. Bagaimana kita bisa menggunakan `git checkout` untuk memulihkan versi file dari commit tertentu?
   1. Buat branch, buat commit di branch tersebut, lalu hapus branch-nya. Bisakah Anda masih memulihkan commit tersebut? Cobalah melihat `git reflog`. (Catatan: Pulihkan hal-hal yang mengambang dengan cepat, git akan secara berkala membersihkan commit yang tidak ditunjuk oleh apapun secara otomatis.)
   1. Jika seseorang terlalu cepat menggunakan `git reset --hard` alih-alih `git reset`, perubahan bisa dengan mudah hilang. Namun karena perubahan tersebut sudah di-stage, kita bisa memulihkannya. (lihat `git fsck --lost-found` dan `.git/lost-found`)

1. Di repo git manapun, lihat di dalam folder `.git/hooks` Anda akan menemukan banyak skrip yang diakhiri dengan `.sample`. Jika Anda mengganti namanya tanpa `.sample`, mereka akan berjalan berdasarkan namanya. Misalnya `pre-commit` akan dieksekusi sebelum melakukan commit. Bereksperimenlah dengan mereka

1. Seperti banyak alat baris perintah, `git` menyediakan file konfigurasi (atau dotfile) yang disebut `~/.gitconfig`. Buat alias menggunakan `~/.gitconfig` sehingga ketika Anda menjalankan `git graph`, Anda mendapatkan output dari `git log --oneline --decorate --all --graph` (ini adalah perintah yang bagus untuk memvisualisasikan grafik commit dengan cepat)

1. Git juga memungkinkan Anda mendefinisikan pola ignore global di `~/.gitignore_global`, ini berguna untuk mencegah kesalahan umum seperti menambahkan kunci RSA. Buat file `~/.gitignore_global` dan tambahkan pola `*rsa`, lalu uji apakah itu berfungsi di sebuah repo.

1. Setelah Anda mulai lebih familiar dengan `git`, Anda akan menemukan diri Anda mengerjakan tugas-tugas umum, seperti mengedit `.gitignore` Anda. [git extras](https://github.com/tj/git-extras/blob/master/Commands.md) menyediakan banyak utilitas kecil yang terintegrasi dengan `git`. Misalnya `git ignore PATTERN` akan menambahkan pola yang ditentukan ke file `.gitignore` di repo Anda dan `git ignore-io LANGUAGE` akan mengambil pola ignore umum untuk bahasa tersebut dari [gitignore.io](https://www.gitignore.io). Instal `git extras` dan cobalah menggunakan beberapa alat seperti `git alias` atau `git ignore`.

1. Program GUI git terkadang bisa menjadi sumber daya yang hebat. Cobalah menjalankan [gitk](https://git-scm.com/docs/gitk) di repo git dan jelajahi berbagai bagian antarmukanya. Lalu jalankan `gitk --all` apa perbedaannya?

1. Setelah Anda terbiasa dengan aplikasi baris perintah, alat GUI bisa terasa merepotkan/boros. Kompromi yang bagus di antara keduanya adalah alat berbasis ncurses yang dapat dinavigasi dari baris perintah dan tetap menyediakan antarmuka interaktif. Git memiliki [tig](https://github.com/jonas/tig), cobalah menginstal dan menjalankannya di sebuah repo. Anda dapat menemukan beberapa contoh penggunaan [di sini](https://www.atlassian.com/blog/git/git-tig).


{% comment %}

 - forced push + `--force-with-lease`
 - git merge/rebase --abort
 - git blame
 - exercise about why rebasing public commits is bad

{% endcomment %}