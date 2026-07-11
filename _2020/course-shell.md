---
layout: lecture
title: "Ikhtisar Kursus + Shell"
description: >
  Pelajari motivasi kelas ini, dan mulai menggunakan shell.
thumbnail: /static/assets/thumbnails/2020/lec1.png
date: 2020-01-13
ready: true
video:
  aspect: 56.25
  id: Z56Jmr9Z34Q
---

# Motivasi

Sebagai ilmuwan komputer, kita tahu bahwa komputer sangat handal dalam membantu
tugas-tugas berulang. Namun, terlalu sering kita lupa bahwa hal ini juga berlaku
untuk _penggunaan_ komputer kita, bukan hanya komputasi yang ingin program kita
lakukan. Kita memiliki berbagai macam alat yang siap di ujung jari yang
memungkinkan kita untuk lebih produktif dan menyelesaikan masalah yang lebih
kompleks ketika mengerjakan masalah terkait komputer apa pun. Namun banyak dari
kita hanya menggunakan sebagian kecil dari alat-alat tersebut; kita hanya
menghafal beberapa mantra ajaib secukupnya untuk bertahan, dan membabi-buta
menyalin-tempel perintah dari internet ketika kita mengalami kebuntuan.

Kelas ini adalah upaya untuk mengatasi hal tersebut.

Kami ingin mengajarkan Anda cara memaksimalkan alat yang Anda ketahui,
memperkenalkan alat-alat baru untuk ditambahkan ke kotak perkakas Anda, dan
mudah-mudahan menanamkan antusiasme bagi Anda untuk menjelajahi (dan mungkin
membangun) lebih banyak alat sendiri. Inilah yang kami yakini sebagai semester
yang hilang dari sebagian besar kurikulum Ilmu Komputer.

# Struktur kelas

Kelas ini terdiri dari 11 kuliah masing-masing 1 jam, setiap kuliah berpusat
pada [topik tertentu](/2020/). Kuliah-kuliah ini sebagian besar saling bebas,
namun seiring berjalannya semester kami akan berasumsi bahwa Anda sudah terbiasa
dengan materi dari kuliah-kuliah sebelumnya. Kami memiliki catatan kuliah secara
online, tetapi akan ada banyak materi yang dibahas di kelas (misalnya dalam
bentuk demo) yang mungkin tidak ada di catatan. Kami akan merekam kuliah dan
mengunggah rekamannya secara online.

Kami berusaha mencakup banyak hal dalam 11 kuliah masing-masing 1 jam, sehingga
kuliah-kuliah ini cukup padat. Untuk memberi Anda waktu mengenal materi
dengan kecepatan Anda sendiri, setiap kuliah dilengkapi serangkaian latihan yang
membimbing Anda melalui poin-poin kunci kuliah tersebut. Setelah setiap kuliah,
kami mengadakan jam kantor di mana kami akan hadir untuk membantu menjawab
pertanyaan apa pun yang mungkin Anda miliki. Jika Anda mengikuti kelas ini
secara online, Anda dapat mengirimkan pertanyaan kepada kami di
[missing-semester@mit.edu](mailto:missing-semester@mit.edu).

Karena waktu yang terbatas, kami tidak akan dapat mencakup semua alat dengan
tingkat detail yang sama seperti kelas skala penuh. Jika memungkinkan, kami
akan mencoba mengarahkan Anda ke sumber daya untuk menggali lebih dalam tentang
suatu alat atau topik, tetapi jika ada yang menarik perhatian Anda, jangan ragu
untuk menghubungi kami dan meminta petunjuk!

# Topik 1: Shell

## Apa itu shell?

Komputer saat ini memiliki berbagai macam antarmuka untuk memberi mereka
perintah; antarmuka grafis yang mewah, antarmuka suara, dan bahkan AR/VR ada di
mana-mana. Ini sangat bagus untuk 80% kasus penggunaan, tetapi seringkali
secara mendasar terbatas dalam apa yang mereka izinkan untuk Anda lakukan — Anda
tidak dapat menekan tombol yang tidak ada atau memberi perintah suara yang belum
diprogram. Untuk memanfaatkan sepenuhnya alat-alat yang disediakan komputer
Anda, kita harus kembali ke cara lama dan beralih ke antarmuka tekstual: Shell.

Hampir semua platform yang bisa Anda gunakan memiliki shell dalam satu bentuk
atau lainnya, dan banyak di antaranya memiliki beberapa shell untuk Anda pilih.
Meskipun mungkin berbeda dalam detailnya, pada intinya semuanya kurang lebih
sama: mereka memungkinkan Anda menjalankan program, memberi mereka masukan, dan
memeriksa keluaran mereka secara semi-terstruktur.

Dalam kuliah ini, kita akan fokus pada Bourne Again SHell, atau singkatnya
"bash". Ini adalah salah satu shell yang paling banyak digunakan, dan sintaksnya
mirip dengan apa yang akan Anda temui di banyak shell lainnya. Untuk membuka
_prompt_ shell (tempat Anda bisa mengetik perintah), Anda pertama-tama
membutuhkan sebuah _terminal_. Perangkat Anda mungkin sudah terpasang satu, atau
Anda bisa memasangnya dengan cukup mudah.

## Menggunakan shell

Ketika Anda meluncurkan terminal, Anda akan melihat sebuah _prompt_ yang
seringkali terlihat seperti ini:

```console
missing:~$
```

Ini adalah antarmuka tekstual utama ke shell. Ini memberi tahu Anda bahwa Anda
berada di mesin `missing` dan "current working directory" Anda, atau di mana
Anda berada saat ini, adalah `~` (singkatan dari "home"). Tanda `$` memberi
tahu bahwa Anda bukan pengguna root (lebih lanjut tentang itu nanti). Pada
prompt ini Anda bisa mengetik sebuah _perintah_, yang kemudian akan
diterjemahkan oleh shell. Perintah paling dasar adalah menjalankan sebuah
program:

```console
missing:~$ date
Fri 10 Jan 2020 11:49:31 AM EST
missing:~$
```

Di sini, kita menjalankan program `date`, yang (mungkin tidak mengejutkan)
mencetak tanggal dan waktu saat ini. Shell kemudian meminta kita perintah lain
untuk dijalankan. Kita juga bisa menjalankan perintah dengan _argumen_:

```console
missing:~$ echo hello
hello
```

Dalam kasus ini, kita menyuruh shell untuk menjalankan program `echo` dengan
argumen `hello`. Program `echo` cukup mencetak keluaran argumen-argumennya.
Shell mengurai perintah dengan memisahnya berdasarkan spasi, kemudian
menjalankan program yang ditunjukkan oleh kata pertama, menyediakan setiap kata
selanjutnya sebagai argumen yang bisa diakses oleh program. Jika Anda ingin
memberikan argumen yang mengandung spasi atau karakter spesial lainnya
(misalnya, direktori bernama "My Photos"), Anda bisa mengutip argumen tersebut
dengan `'` atau `"` (`"My Photos"`), atau meng-escape hanya karakter yang relevan
dengan `\` (`My\ Photos`).

## Menavigasi shell

Sebuah path pada shell adalah daftar direktori yang dipisahkan; dengan `/` pada
Linux dan macOS dan `\` pada Windows. Pada Linux dan macOS, path `/` adalah
"root" dari sistem file, di mana semua direktori dan file berada, sedangkan pada
Windows terdapat satu root untuk setiap partisi disk (misalnya, `C:\`). Kita
secara umum akan berasumsi bahwa Anda menggunakan sistem file Linux di kelas
ini. Path yang dimulai dengan `/` disebut path _absolut_. Path lainnya adalah
path _relatif_. Path relatif terhadap current working directory, yang bisa kita
lihat dengan perintah `pwd` dan ubah dengan perintah `cd`. Dalam sebuah path,
`.` merujuk ke direktori saat ini, dan `..` ke direktori induknya:

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

Perhatikan bahwa prompt shell kita terus memberi informasi tentang direktori
kerja kita saat ini. Anda bisa mengonfigurasi prompt Anda untuk menampilkan
semua sorts informasi berguna, yang akan kita bahas di kuliah berikutnya.

Secara umum, ketika kita menjalankan sebuah program, program tersebut akan
beroperasi di direktori saat ini kecuali kita menyuruhnya sebaliknya. Misalnya,
program biasanya akan mencari file di sana, dan membuat file baru di sana jika
diperlukan.

Untuk melihat apa yang ada di direktori tertentu, kita gunakan perintah `ls`:

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

Kecuali direktori diberikan sebagai argumen pertamanya, `ls` akan mencetak isi
dari direktori saat ini. Sebagian besar perintah menerima flag dan opsi (flag
dengan nilai) yang diawali dengan `-` untuk mengubah perilakunya. Biasanya,
menjalankan program dengan flag `-h` atau `--help` akan mencetak teks bantuan
yang memberi tahu Anda flag dan opsi apa saja yang tersedia. Misalnya,
`ls --help` memberi tahu kita:

```
  -l                         use a long listing format
```

```console
missing:~$ ls -l /home
drwxr-xr-x 1 missing  users  4096 Jun 15  2019 missing
```

Ini memberi kita banyak informasi tambahan tentang setiap file atau direktori
yang ada. Pertama, `d` di awal baris memberi tahu kita bahwa `missing` adalah
sebuah direktori. Kemudian diikuti tiga kelompok berisi tiga karakter (`rwx`).
Ini menunjukkan hak akses pemilik file (`missing`), grup pemilik (`users`), dan
semua orang lainnya secara berturut-turut pada item yang relevan. Tanda `-`
menunjukkan bahwa prinsipal yang diberikan tidak memiliki izin yang diberikan.
Di atas, hanya pemilik yang diizinkan untuk memodifikasi (`w`) direktori
`missing` (yaitu, menambah/menghapus file di dalamnya). Untuk memasuki sebuah
direktori, pengguna harus memiliki izin "search" (direpresentasikan oleh
"execute": `x`) pada direktori tersebut (dan induknya). Untuk menampilkan
isinya, pengguna harus memiliki izin baca (`r`) pada direktori tersebut. Untuk
file, izin-izin tersebut sesuai dengan yang Anda harapkan. Perhatikan bahwa
hampir semua file di `/bin` memiliki izin `x` yang disetel untuk grup terakhir,
"semua orang lainnya", sehingga siapa pun bisa menjalankan program-program
tersebut.

Beberapa program berguna lainnya yang perlu diketahui pada titik ini adalah
`mv` (untuk mengubah nama/memindahkan file), `cp` (untuk menyalin file), dan
`mkdir` (untuk membuat direktori baru).

Jika Anda membutuhkan informasi _lebih lanjut_ tentang argumen, masukan,
keluaran, atau cara kerja suatu program secara umum, cobalah program `man`.
Program ini menerima argumen berupa nama program, dan menampilkan _halaman
manual_-nya. Tekan `q` untuk keluar.

```console
missing:~$ man ls
```

## Menghubungkan program

Di shell, program memiliki dua "aliran" utama yang terkait dengannya: aliran
masukan dan aliran keluaran. Ketika program mencoba membaca masukan, ia membaca
dari aliran masukan, dan ketika mencetak sesuatu, ia mencetak ke aliran
keluarannya. Biasanya, masukan dan keluaran program keduanya adalah terminal
Anda. Artinya, keyboard Anda sebagai masukan dan layar Anda sebagai keluaran.
Namun, kita juga bisa mengalihkan aliran-aliran tersebut!

Bentuk paling sederhana dari pengalihan adalah `< file` dan `> file`. Ini
memungkinkan Anda mengalihkan aliran masukan dan keluaran program ke sebuah
file masing-masingnya:

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

Seperti yang ditunjukkan dalam contoh di atas, `cat` adalah program yang
menyambung`kan` file. Ketika diberi nama file sebagai argumen, ia mencetak isi
masing-masing file secara berurutan ke aliran keluarannya. Tetapi ketika `cat`
tidak diberi argumen apa pun, ia mencetak isi dari aliran masukannya ke aliran
keluarannya (seperti pada contoh ketiga di atas).

Anda juga bisa menggunakan `>>` untuk menambahkan ke file. Di mana pengalihan
masukan/keluaran ini benar-benar bersinar adalah dalam penggunaan _pipe_.
Operator `|` memungkinkan Anda "merantai" program sedemikian rupa sehingga
keluaran satu program menjadi masukan program lainnya:

```console
missing:~$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2019 var
missing:~$ curl --head --silent google.com | grep --ignore-case content-length | cut --delimiter=' ' -f2
219
```

Kita akan membahas lebih detail tentang cara memanfaatkan pipe di kuliah tentang
data wrangling.

## Alat yang serbaguna dan kuat

Pada sebagian besar sistem mirip-Unix, satu pengguna bersifat spesial: pengguna
"root". Anda mungkin telah melihatnya dalam daftar file di atas. Pengguna root
berada di atas (hampir) semua batasan akses, dan bisa membuat, membaca,
memperbarui, dan menghapus file apa pun di sistem. Namun Anda biasanya tidak
akan masuk ke sistem Anda sebagai pengguna root, karena terlalu mudah untuk
secara tidak sengaja merusak sesuatu. Sebagai gantinya, Anda akan menggunakan
perintah `sudo`. Seperti namanya, ini memungkinkan Anda "melakukan" sesuatu
"sebagai su" (singkatan dari "super user", atau "root"). Ketika Anda
mendapatkan error izin ditolak, biasanya karena Anda perlu melakukan sesuatu
sebagai root. Meskipun pastikan Anda pertama-tama memeriksa ulang bahwa Anda
benar-benar ingin melakukannya dengan cara itu!

Salah satu hal yang mengharuskan Anda menjadi root adalah menulis ke sistem file
`sysfs` yang di-mount di bawah `/sys`. `sysfs` menampilkan sejumlah parameter
kernel sebagai file, sehingga Anda bisa dengan mudah mengonfigurasi ulang kernel
secara langsung tanpa alat khusus. **Perhatikan bahwa sysfs tidak ada di Windows
atau macOS.**

Misalnya, kecerahan layar laptop Anda ditampilkan melalui sebuah file bernama
`brightness` di bawah

```
/sys/class/backlight
```

Dengan menulis nilai ke file tersebut, kita bisa mengubah kecerahan layar.
Firasat pertama Anda mungkin melakukan sesuatu seperti:

```console
$ sudo find -L /sys/class/backlight -maxdepth 2 -name '*brightness*'
/sys/class/backlight/thinkpad_screen/brightness
$ cd /sys/class/backlight/thinkpad_screen
$ sudo echo 3 > brightness
An error occurred while redirecting file 'brightness'
open: Permission denied
```

Error ini mungkin mengejutkan. Lagipula, kita menjalankan perintah dengan
`sudo`! Ini adalah hal penting yang perlu diketahui tentang shell. Operasi
seperti `|`, `>`, dan `<` dilakukan _oleh shell_, bukan oleh program individual.
`echo` dan teman-temannya tidak "tahu" tentang `|`. Mereka hanya membaca dari
masukan dan menulis ke keluaran mereka, apa pun itu. Dalam kasus di atas,
_shell_ (yang diautentikasi sebagai pengguna Anda) mencoba membuka file
brightness untuk ditulis, sebelum menjadikannya sebagai keluaran `sudo echo`,
tetapi dicegah karena shell tidak berjalan sebagai root. Dengan pengetahuan ini,
kita bisa mengatasinya:

```console
$ echo 3 | sudo tee brightness
```

Karena program `tee` adalah yang membuka file `/sys` untuk ditulis, dan _ia_
berjalan sebagai `root`, semua izin berfungsi dengan benar. Anda bisa
mengendalikan berbagai hal yang menarik dan berguna melalui `/sys`, seperti
status berbagai LED sistem (path Anda mungkin berbeda):

```console
$ echo 1 | sudo tee /sys/class/leds/input6::scrolllock/brightness
```

# Langkah selanjutnya

Pada titik ini Anda sudah cukup mengenal shell untuk menyelesaikan tugas-tugas
dasar. Anda seharusnya bisa menavigasi untuk menemukan file yang menarik dan
menggunakan fungsionalitas dasar sebagian besar program. Di kuliah berikutnya,
kita akan membahas tentang cara melakukan dan mengotomatisasi tugas-tugas yang
lebih kompleks menggunakan shell dan banyak program baris perintah yang berguna.

# Latihan

Semua kelas dalam kursus ini disertai serangkaian latihan. Beberapa memberi Anda
tugas spesifik untuk dilakukan, sementara lainnya bersifat terbuka, seperti
"coba gunakan program X dan Y". Kami sangat mendorong Anda untuk mencobanya.

Kami belum menulis solusi untuk latihan-latihan ini. Jika Anda mengalami
kebuntuan pada hal tertentu, jangan ragu untuk mengirimkan email kepada kami
yang menjelaskan apa yang sudah Anda coba sejauh ini, dan kami akan mencoba
membantu Anda.

 1. Untuk kursus ini, Anda perlu menggunakan shell Unix seperti Bash atau ZSH.
    Jika Anda menggunakan Linux atau macOS, Anda tidak perlu melakukan apa-apa
    yang khusus. Jika Anda menggunakan Windows, Anda perlu memastikan Anda tidak
    menjalankan cmd.exe atau PowerShell; Anda bisa menggunakan [Windows
    Subsystem for
    Linux](https://docs.microsoft.com/en-us/windows/wsl/) atau mesin virtual
    Linux untuk menggunakan alat baris perintah bergaya Unix. Untuk memastikan
    Anda menjalankan shell yang sesuai, Anda bisa mencoba perintah `echo
    $SHELL`. Jika hasilnya sesuatu seperti `/bin/bash` atau `/usr/bin/zsh`, itu
    berarti Anda menjalankan program yang benar.
 1. Buat direktori baru bernama `missing` di bawah `/tmp`.
 1. Cari tahu tentang program `touch`. Program `man` adalah teman Anda.
 1. Gunakan `touch` untuk membuat file baru bernama `semester` di `missing`.
 1. Tulis yang berikut ke dalam file tersebut, satu baris pada satu waktu:
    ```
    #!/bin/sh
    curl --head --silent https://missing.csail.mit.edu
    ```
    Baris pertama mungkin agak rumit untuk dibuat berfungsi. Membantu untuk
    diketahui bahwa `#` memulai komentar di Bash, dan `!` memiliki arti khusus
    bahkan di dalam string bertanda kutip ganda (`"`). Bash memperlakukan string
    bertanda kutip tunggal (`'`) secara berbeda: mereka akan berhasil dalam
    kasus ini. Lihat halaman manual [quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html) Bash untuk informasi lebih lanjut.
 1. Coba jalankan file tersebut, yaitu ketik path ke skrip (`./semester`) ke
    dalam shell Anda dan tekan enter. Pahami mengapa tidak berhasil dengan
    melihat keluaran `ls` (petunjuk: perhatikan bit izin file tersebut).
 1. Jalankan perintah dengan secara eksplisit memulai interpreter `sh`, dan
    memberinya file `semester` sebagai argumen pertama, yaitu `sh semester`.
    Mengapa ini berhasil, sedangkan `./semester` tidak?
 1. Cari tahu tentang program `chmod` (misalnya gunakan `man chmod`).
 1. Gunakan `chmod` untuk memungkinkan menjalankan perintah `./semester` tanpa
    harus mengetik `sh semester`. Bagaimana shell Anda tahu bahwa file tersebut
    seharusnya diinterpretasikan menggunakan `sh`? Lihat halaman ini tentang
    baris [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) untuk
    informasi lebih lanjut.
 1. Gunakan `|` dan `>` untuk menulis keluaran tanggal "terakhir diubah" oleh
    `semester` ke dalam file bernama `last-modified.txt` di direktori home Anda.
 1. Tulis perintah yang membaca level daya baterai laptop Anda atau suhu CPU
    mesin desktop Anda dari `/sys`. Catatan: jika Anda pengguna macOS, OS Anda
    tidak memiliki sysfs, jadi Anda bisa melewati latihan ini.
