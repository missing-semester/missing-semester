---
layout: lecture
title: "Metaprogramming"
description: >
  Pelajari tentang build system, manajemen dependensi, pengujian, dan continuous integration.
thumbnail: /static/assets/thumbnails/2020/lec8.png
details: build system, manajemen dependensi, pengujian, CI
date: 2020-01-27
ready: true
video:
  aspect: 56.25
  id: _Ms1Z4xfqv4
---

Apa yang kami maksud dengan "metaprogramming"? Itu adalah istilah kolektif terbaik
yang bisa kami temukan untuk sekumpulan hal yang lebih berkaitan dengan
_proses_ daripada menulis kode atau bekerja lebih efisien.
Dalam kuliah ini, kita akan melihat sistem untuk membangun dan menguji
kode Anda, serta untuk mengelola dependensi. Hal-hal ini mungkin tampak
tidak terlalu penting dalam keseharian Anda sebagai mahasiswa, tetapi begitu
Anda berinteraksi dengan codebase yang lebih besar melalui magang atau setelah
Anda masuk ke "dunia nyata", Anda akan melihat ini di mana-mana. Perlu kami
catat bahwa "metaprogramming" juga bisa berarti "[program yang menjalankan
program](https://en.wikipedia.org/wiki/Metaprogramming)", sedangkan itu
bukan definisi yang kami gunakan untuk keperluan kuliah ini.

# Build system

Jika Anda menulis makalah dengan LaTeX, perintah apa yang perlu Anda jalankan untuk
menghasilkan makalah Anda? Bagaimana dengan perintah yang digunakan untuk menjalankan benchmark,
membuat plot-nya, lalu menyisipkan plot tersebut ke makalah Anda? Atau untuk mengompilasi
kode yang disediakan di kelas yang Anda ambil dan kemudian menjalankan tesnya?

Untuk sebagian besar proyek, apakah mengandung kode atau tidak, terdapat "proses build".
Suatu urutan operasi yang perlu Anda lakukan untuk pergi dari input ke output.
Seringkali, proses tersebut mungkin memiliki banyak langkah, dan banyak cabang.
Jalankan ini untuk menghasilkan plot ini, itu untuk menghasilkan hasil itu,
dan sesuatu yang lain untuk menghasilkan makalah akhir. Seperti banyak hal yang
telah kita lihat di kelas ini, Anda bukan yang pertama kali mengalami kesulitan ini,
dan untungnya ada banyak alat yang bisa membantu Anda!

Ini biasanya disebut "build system", dan ada _banyak_ di antaranya.
Yang Anda gunakan tergantung pada tugas yang ada, bahasa pemrograman
favorit Anda, dan ukuran proyek. Pada intinya, semuanya sangat mirip.
Anda mendefinisikan sejumlah _dependensi_, sejumlah _target_, dan _aturan_
untuk beralih dari satu ke yang lain. Anda memberi tahu build system bahwa
Anda menginginkan target tertentu, dan tugasnya adalah menemukan semua
dependensi transitif dari target tersebut, lalu menerapkan aturan-aturan
untuk menghasilkan target-target perantara sampai target akhir dihasilkan.
Idealnya, build system melakukan ini tanpa menjalankan aturan secara
tidak perlu untuk target-target yang dependensinya belum berubah dan
hasilnya sudah tersedia dari build sebelumnya.

`make` adalah salah satu build system yang paling umum, dan Anda biasanya
akan menemukannya terinstal di hampir semua komputer berbasis UNIX.
Ada beberapa kekurangannya, tetapi bekerja cukup baik untuk proyek sederhana
hingga menengah. Saat Anda menjalankan `make`, ia membaca file bernama
`Makefile` di direktori saat ini. Semua target, dependensi, dan aturan
didefinisikan di file tersebut. Mari kita lihat salah satunya:

```make
paper.pdf: paper.tex plot-data.png
	pdflatex paper.tex

plot-%.png: %.dat plot.py
	./plot.py -i $*.dat -o $@
```

Setiap direktif dalam file ini adalah aturan untuk menghasilkan sisi kiri
menggunakan sisi kanan. Atau, dengan kata lain, hal-hal yang disebutkan
di sisi kanan adalah dependensi, dan sisi kiri adalah target. Blok yang
diindentasi adalah urutan program untuk menghasilkan target dari
dependensi-dependensi tersebut. Dalam `make`, direktif pertama juga
mendefinisikan goal default. Jika Anda menjalankan `make` tanpa argumen,
ini adalah target yang akan dibangun. Sebagai alternatif, Anda bisa
menjalankan sesuatu seperti `make plot-data.png`, dan ia akan membangun
target tersebut sebagai gantinya.

`%` dalam sebuah aturan adalah "pola", dan akan cocok dengan string yang
sama di kiri dan di kanan. Misalnya, jika target `plot-foo.png` diminta,
`make` akan mencari dependensi `foo.dat` dan `plot.py`. Sekarang mari kita
lihat apa yang terjadi jika kita menjalankan `make` dengan direktori sumber kosong.

```console
$ make
make: *** No rule to make target 'paper.tex', needed by 'paper.pdf'.  Stop.
```

`make` dengan ramah memberi tahu kita bahwa untuk membangun `paper.pdf`,
ia membutuhkan `paper.tex`, dan tidak ada aturan yang memberitahu cara
membuat file tersebut. Mari kita coba membuatnya!

```console
$ touch paper.tex
$ make
make: *** No rule to make target 'plot-data.png', needed by 'paper.pdf'.  Stop.
```

Hmm, menarik, _ada_ aturan untuk membuat `plot-data.png`, tetapi itu
adalah aturan pola. Karena file sumber tidak ada (`data.dat`), `make`
hanya menyatakan bahwa ia tidak bisa membuat file tersebut. Mari kita
coba membuat semua file:

```console
$ cat paper.tex
\documentclass{article}
\usepackage{graphicx}
\begin{document}
\includegraphics[scale=0.65]{plot-data.png}
\end{document}
$ cat plot.py
#!/usr/bin/env python
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-i', type=argparse.FileType('r'))
parser.add_argument('-o')
args = parser.parse_args()

data = np.loadtxt(args.i)
plt.plot(data[:, 0], data[:, 1])
plt.savefig(args.o)
$ cat data.dat
1 1
2 2
3 3
4 4
5 8
```

Sekarang apa yang terjadi jika kita menjalankan `make`?

```console
$ make
./plot.py -i data.dat -o plot-data.png
pdflatex paper.tex
... lots of output ...
```

Dan lihat, ia membuat PDF untuk kita!
Bagaimana jika kita menjalankan `make` lagi?

```console
$ make
make: 'paper.pdf' is up to date.
```

Ia tidak melakukan apa-apa! Mengapa? Karena tidak perlu. Ia memeriksa
bahwa semua target yang sudah dibangun sebelumnya masih terbaru
terhadap dependensi yang terdaftar. Kita bisa menguji ini dengan
mengubah `paper.tex` lalu menjalankan ulang `make`:

```console
$ vim paper.tex
$ make
pdflatex paper.tex
...
```

Perhatikan bahwa `make` _tidak_ menjalankan ulang `plot.py` karena
itu tidak diperlukan; tidak ada dependensi `plot-data.png` yang berubah!

# Manajemen dependensi

Pada tingkat yang lebih makro, proyek perangkat lunak Anda kemungkinan
besar memiliki dependensi yang merupakan proyek-proyek itu sendiri.
Anda mungkin bergantung pada program yang terinstal (seperti `python`),
paket sistem (seperti `openssl`), atau pustaka dalam bahasa pemrograman
Anda (seperti `matplotlib`). Saat ini, sebagian besar dependensi akan
tersedia melalui sebuah _repositori_ yang menampung sejumlah besar
dependensi tersebut di satu tempat, dan menyediakan mekanisme yang
nyaman untuk menginstalnya. Beberapa contoh termasuk repositori paket
Ubuntu untuk paket sistem Ubuntu, yang Anda akses melalui alat `apt`,
RubyGems untuk pustaka Ruby, PyPI untuk pustaka Python, atau Arch User
Repository untuk paket-paket kontributor pengguna Arch Linux.

Karena mekanisme yang tepat untuk berinteraksi dengan repositori-repositori
ini sangat bervariasi dari satu repositori ke repositori lain dan dari
satu alat ke alat lain, kita tidak akan membahas terlalu detail tentang
ada satu alat tertentu dalam kuliah ini. Yang _akan_ kita bahas adalah
beberapa terminologi umum yang semuanya gunakan. Yang pertama adalah
_versioning_. Sebagian besar proyek yang menjadi dependensi proyek lain
menerbitkan _nomor versi_ dengan setiap rilis. Biasanya sesuatu seperti
8.1.3 atau 64.1.20192004. Biasanya numerik, tetapi tidak selalu.
Nomor versi memiliki banyak tujuan, dan salah satu yang paling penting
adalah memastikan perangkat lunak tetap berfungsi. Bayangkan, misalnya,
saya merilis versi baru pustaka saya di mana saya telah mengubah nama
sebuah fungsi. Jika seseorang mencoba membangun perangkat lunak yang
bergantung pada pustaka saya setelah saya merilis pembaruan tersebut,
build-nya mungkin gagal karena memanggil fungsi yang tidak ada lagi!
Versioning berusaha menyelesaikan masalah ini dengan membiarkan sebuah
proyek menyatakan bahwa ia bergantung pada versi tertentu, atau rentang
versi tertentu, dari proyek lain. Dengan begitu, meskipun pustaka dasar
berubah, perangkat lunak yang bergantung tetap bisa dibangun menggunakan
versi lama dari pustaka saya.

Namun itu juga belum ideal! Bagaimana jika saya merilis pembaruan keamanan
yang _tidak_ mengubah antarmuka publik pustaka saya (API-nya), dan
proyek mana pun yang bergantung pada versi lama seharusnya segera
menggunakannya? Di sinilah kelompok angka-angka berbeda dalam nomor
versi berperan. Arti pasti masing-masing bervariasi antar proyek, tetapi
salah satu standar yang cukup umum adalah [_semantic
versioning_](https://semver.org/). Dengan semantic versioning, setiap
nomor versi memiliki format: major.minor.patch. Aturannya adalah:

 - Jika rilis baru tidak mengubah API, naikkan versi patch.
 - Jika Anda _menambahkan_ ke API Anda dengan cara yang kompatibel ke
   belakang, naikkan versi minor.
 - Jika Anda mengubah API dengan cara yang tidak kompatibel ke belakang,
   naikkan versi major.

Ini sudah memberikan beberapa keuntungan besar. Sekarang, jika proyek saya
bergantung pada proyek Anda, seharusnya aman menggunakan rilis terbaru
dengan versi major yang sama dengan yang saya gunakan saat mengembangkannya,
selama versi minor-nya setidaknya sama dengan saat itu. Dengan kata lain,
jika saya bergantung pada pustaka Anda di versi `1.3.7`, maka seharusnya
tidak masalah membangunnya dengan `1.3.8`, `1.6.1`, atau bahkan `1.3.0`.
Versi `2.2.4` mungkin tidak akan cocok, karena versi major-nya naik.
Kita bisa melihat contoh semantic versioning di nomor versi Python.
Banyak dari Anda mungkin sudah tahu bahwa kode Python 2 dan Python 3
tidak bisa dicampur dengan baik, itulah mengapa itu adalah _major_
version bump. Demikian juga, kode yang ditulis untuk Python 3.5 mungkin
berjalan baik di Python 3.7, tetapi mungkin tidak di 3.4.

Saat bekerja dengan sistem manajemen dependensi, Anda mungkin juga
menemui konsep _lock file_. Lock file hanyalah file yang mencantumkan
versi tepat yang saat ini Anda andalkan dari setiap dependensi.
Biasanya, Anda perlu secara eksplisit menjalankan program pembaruan
untuk mengupgrade ke versi dependensi yang lebih baru. Ada banyak
alasan untuk ini, seperti menghindari recompile yang tidak perlu,
memiliki build yang dapat direproduksi, atau tidak secara otomatis
memperbarui ke versi terbaru (yang mungkin rusak). Versi ekstrem dari
penguncian dependensi semacam ini adalah _vendoring_, yaitu di mana
Anda menyalin semua kode dependensi Anda ke proyek Anda sendiri.
Itu memberi Anda kontrol total atas setiap perubahan padanya, dan
memungkinkan Anda memperkenalkan perubahan Anda sendiri, tetapi juga
berarti Anda harus secara eksplisit mengambil pembaruan dari
pemelihara upstream dari waktu ke waktu.

# Sistem continuous integration

Saat Anda mengerjakan proyek yang semakin besar, Anda akan menemukan
bahwa sering ada tugas tambahan yang harus dilakukan setiap kali Anda
mengubahnya. Anda mungkin harus mengunggah versi dokumentasi baru,
mengunggah versi yang sudah dikompilasi ke suatu tempat, merilis kode
ke pypi, menjalankan suite pengujian, dan segala macam hal lainnya.
Mungkin setiap kali seseorang mengirim pull request di GitHub, Anda
ingin kode mereka diperiksa gayanya dan Anda ingin beberapa benchmark
dijalankan? Ketika kebutuhan semacam ini muncul, saatnya untuk melihat
continuous integration.

Continuous integration, atau CI, adalah istilah umum untuk "hal-hal yang
berjalan setiap kali kode Anda berubah", dan ada banyak perusahaan di luar
sana yang menyediakan berbagai jenis CI, seringkali gratis untuk proyek
open-source. Beberapa yang besar adalah Travis CI, Azure Pipelines, dan
GitHub Actions. Semuanya bekerja dengan cara yang kurang lebih sama: Anda
menambahkan file ke repositori Anda yang menjelaskan apa yang harus
terjadi ketika berbagai hal terjadi pada repositori tersebut. Yang paling
umum adalah aturan seperti "ketika seseorang mengirim kode, jalankan
suite pengujian". Ketika event terpicu, penyedia CI membuat virtual
machine (atau lebih), menjalankan perintah dalam "resep" Anda, dan
kemudian biasanya mencatat hasilnya di suatu tempat. Anda bisa
mengaturnya sehingga Anda diberi tahu jika suite pengujian tidak lagi
lulus, atau sehingga sebuah badge kecil muncul di repositori Anda
selama tes-tes lulus.

Sebagai contoh sistem CI, situs web kelas ini diatur menggunakan GitHub
Pages. Pages adalah aksi CI yang menjalankan perangkat lunak blog Jekyll
pada setiap push ke `master` dan membuat situs yang sudah dibangun
tersedia di domain GitHub tertentu. Ini membuat kami sangat mudah
memperbarui situs web! Kami hanya membuat perubahan secara lokal,
commit dengan git, lalu push. CI menangani sisanya.

## Sekilas tentang pengujian

Sebagian besar proyek perangkat lunak besar dilengkapi dengan "test suite".
Anda mungkin sudah familiar dengan konsep umum pengujian, tetapi kami
ingin dengan cepat menyebutkan beberapa pendekatan pengujian dan
terminologi pengujian yang mungkin Anda temui di lapangan:

 - Test suite: istilah kolektif untuk semua tes
 - Unit test: "tes mikro" yang menguji fitur spesifik secara terisolasi
 - Integration test: "tes makro" yang menjalankan bagian yang lebih besar
   dari sistem untuk memeriksa bahwa fitur atau komponen yang berbeda
   bekerja _bersama-sama_.
 - Regression test: tes yang mengimplementasikan pola tertentu yang
   _sebelumnya_ menyebabkan bug untuk memastikan bug tersebut tidak
   muncul kembali.
 - Mocking: mengganti fungsi, modul, atau tipe dengan implementasi palsu
   untuk menghindari pengujian fungsionalitas yang tidak terkait.
   Misalnya, Anda mungkin "mock jaringan" atau "mock disk".

# Latihan

  1. Sebagian besar makefile menyediakan target bernama `clean`. Ini bukan
     dimaksudkan untuk menghasilkan file bernama `clean`, melainkan untuk
     membersihkan file-file yang bisa di-build ulang oleh make. Anggap
     saja sebagai cara untuk "undo" semua langkah build. Implementasikan
     target `clean` untuk `Makefile` `paper.pdf` di atas. Anda harus
     membuat target tersebut
     [phony](https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html).
     Anda mungkin menemukan subcommand [`git
     ls-files`](https://git-scm.com/docs/git-ls-files) berguna. Sejumlah
     target make umum lainnya terdaftar
     [di sini](https://www.gnu.org/software/make/manual/html_node/Standard-Targets.html#Standard-Targets).
  2. Lihat berbagai cara untuk menentukan persyaratan versi untuk
     dependensi di [build system
     Rust](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html).
     Sebagian besar repositori paket mendukung sintaks yang serupa. Untuk
     masing-masing (caret, tilde, wildcard, perbandingan, dan multiple),
     cobalah memikirkan kasus penggunaan di mana persyaratan jenis
     tertentu itu masuk akal.
  3. Git bisa bertindak sebagai sistem CI sederhana secara mandiri. Di
     `.git/hooks` di repositori git mana pun, Anda akan menemukan file
     yang (saat ini tidak aktif) yang dijalankan sebagai skrip ketika
     aksi tertentu terjadi. Tulis hook
     [`pre-commit`](https://git-scm.com/docs/githooks#_pre_commit) yang
     menjalankan `make paper.pdf` dan menolak commit jika perintah `make`
     gagal. Ini seharusnya mencegah commit apa pun memiliki versi makalah
     yang tidak bisa di-build.
  4. Siapkan halaman auto-publish sederhana menggunakan [GitHub
     Pages](https://pages.github.com/).
     Tambahkan [GitHub Action](https://github.com/features/actions) ke
     repositori untuk menjalankan `shellcheck` pada semua file shell di
     repositori tersebut (ini adalah [salah satu cara untuk
     melakukannya](https://github.com/marketplace/actions/shellcheck)).
     Periksa bahwa itu berfungsi!
  5. [Buat sendiri](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/building-actions)
     GitHub action untuk menjalankan [`proselint`](https://github.com/amperser/proselint) atau
     [`write-good`](https://github.com/btford/write-good) pada semua
     file `.md` di repositori. Aktifkan di repositori Anda, dan
     periksa bahwa itu berfungsi dengan mengajukan pull request yang
     mengandung typo.
