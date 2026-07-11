---
layout: lecture
title: "Ikhtisar Kursus + The Shell"
description: >
  Pelajari motivasi kelas ini, dan mulai dengan shell.
thumbnail: /static/assets/thumbnails/2020/lec1.png
date: 2020-01-13
ready: true
video:
  aspect: 56.25
  id: Z56Jmr9Z34Q
---

# Motivasi

Sebagai ilmuwan komputer, kita tahu bahwa komputer sangat baik dalam membantu tugas-tugas berulang. Namun, terlalu sering kita lupa bahwa ini berlaku sama banyaknya untuk _penggunaan_ komputer kita seperti halnya untuk komputasi yang ingin kita lakukan oleh program kita. Kita memiliki berbagai macam alat yang tersedia di ujung jari kita yang memungkinkan kita untuk lebih produktif dan menyelesaikan masalah yang lebih kompleks ketika bekerja pada masalah terkait komputer apa pun. Namun banyak dari kita hanya menggunakan sebagian kecil dari alat-alat tersebut; kita hanya mengetahui cukup banyak mantra ajaib dengan hafalan untuk bertahan, dan membabi-buti menyalin-tempel perintah dari internet ketika kita terjebak.

Kelas ini adalah upaya untuk mengatasi hal tersebut.

Kami ingin mengajarkan Anda cara memaksimalkan alat-alat yang Anda ketahui, menunjukkan alat-alat baru untuk ditambahkan ke kotak peralatan Anda, dan semoga menanamkan dalam diri Anda beberapa kegembiraan untuk menjelajahi (dan mungkin membangun) lebih banyak alat sendiri. Ini adalah apa yang kami yakini sebagai semester yang hilang dari sebagian besar kurikulum Ilmu Komputer.

# Struktur kelas

Kelas ini terdiri dari 11 kuliah 1 jam, masing-masing berpusat pada [topik tertentu](/2020/). Kuliah-kuliah sebagian besar independen, meskipun seiring berjalannya semester kami akan berasumsi bahwa Anda sudah terbiasa dengan konten dari kuliah-kuliah sebelumnya. Kami memiliki catatan kuliah online, tetapi akan ada banyak konten yang dibahas di kelas (misalnya dalam bentuk demo) yang mungkin tidak ada dalam catatan. Kami akan merekam kuliah dan memposting rekaman secara online.

Kami mencoba mencakup banyak hal dalam kurun waktu hanya 11 kuliah 1 jam, jadi kuliah-kuliah cukup padat. Untuk memberi Anda waktu untuk membiasakan diri dengan konten sesuai kecepatan Anda sendiri, setiap kuliah mencakup serangkaian latihan yang memandu Anda melalui poin-poin kunci kuliah. Setelah setiap kuliah, kami mengadakan jam kantor di mana kami akan hadir untuk membantu menjawab pertanyaan apa pun yang mungkin Anda miliki. Jika Anda mengikuti kelas secara online, Anda dapat mengirim pertanyaan kepada kami di [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

Karena waktu yang terbatas, kami tidak akan dapat mencakup semua alat dengan tingkat detail yang sama seperti kelas skala penuh. Jika memungkinkan, kami akan mencoba mengarahkan Anda ke sumber daya untuk menggali lebih dalam ke alat atau topik, tetapi jika ada sesuatu yang特别 menarik perhatian Anda, jangan ragu untuk menghubungi kami dan meminta petunjuk!

# Topik 1: The Shell

## Apa itu shell?

Komputer saat ini memiliki berbagai antarmuka untuk memberi mereka perintah; antarmuka pengguna grafis yang mewah, antarmuka suara, dan bahkan AR/VR ada di mana-mana. Ini sangat bagus untuk 80% kasus penggunaan, tetapi mereka sering kali terbatas secara mendasar dalam apa yang mereka izinkan Anda lakukan — Anda tidak dapat menekan tombol yang tidak ada atau memberi perintah suara yang belum diprogram. Untuk memanfaatkan sepenuhnya alat-alat yang disediakan komputer Anda, kita harus kembali ke cara lama dan turun ke antarmuka tekstual: The Shell.

Hampir semua platform yang bisa Anda dapatkan memiliki shell dalam satu bentuk atau lainnya, dan banyak dari mereka memiliki beberapa shell untuk Anda pilih. Meskipun mereka mungkin berbeda dalam detail, pada intinya mereka semua kurang lebih sama: mereka memungkinkan Anda menjalankan program, memberi mereka input, dan memeriksa output mereka dengan cara semi-terstruktur.

Dalam kuliah ini, kita akan fokus pada Bourne Again SHell, atau "bash" singkatnya. Ini adalah salah satu shell yang paling banyak digunakan, dan sintaksnya mirip dengan apa yang akan Anda lihat di banyak shell lainnya. Untuk membuka _prompt_ shell (tempat Anda dapat mengetik perintah), Anda pertama-tama membutuhkan _terminal_. Perangkat Anda mungkin sudah dilengkapi dengan yang terinstal, atau Anda dapat menginstalnya dengan cukup mudah.

## Menggunakan shell

Ketika Anda meluncurkan terminal, Anda akan melihat _prompt_ yang sering terlihat seperti ini:

```console
missing:~$
```

Ini adalah antarmuka tekstual utama ke shell. Ini memberi tahu Anda bahwa Anda berada di mesin `missing` dan bahwa "directori kerja saat ini" Anda, atau di mana Anda berada saat ini, adalah `~` (singkatan dari "home"). `$` memberi tahu Anda bahwa Anda bukan pengguna root (lebih lanjut tentang itu nanti). Pada prompt ini Anda dapat mengetik _perintah_, yang kemudian akan diinterpretasikan oleh shell. Perintah paling dasar adalah menjalankan program:

```console
missing:~$ date
Fri 10 Jan 2020 11:49:31 AM EST
missing:~$
```

Di sini, kita menjalankan program `date`, yang (mungkin tidak mengejutkan) mencetak tanggal dan waktu saat ini. Shell kemudian meminta kita untuk perintah lain untuk dijalankan. Kita juga dapat menjalankan perintah dengan _argumen_:

```console
missing:~$ echo hello
hello
```

Dalam kasus ini, kita memberi tahu shell untuk menjalankan program `echo` dengan argumen `hello`. Program `echo` hanya mencetak argumennya. Shell mem-parsing perintah dengan memecahnya berdasarkan spasi, dan kemudian menjalankan program yang ditunjukkan oleh kata pertama, menyediakan setiap kata berikutnya sebagai argumen yang dapat diakses oleh program. Jika Anda ingin menyediakan argumen yang mengandung spasi atau karakter khusus lainnya (misalnya, direktori bernama "My Photos"), Anda dapat mengutip argumen dengan `'` atau `"` (`"My Photos"`), atau escape hanya karakter yang relevan dengan `\` (`My\ Photos`).

Tetapi bagaimana shell tahu cara menemukan program `date` atau `echo`? Yah, shell adalah lingkungan pemrograman, sama seperti Python atau Ruby, dan jadi memiliki variabel, kondisional, loop, dan fungsi (kuliah berikutnya!). Ketika Anda menjalankan perintah di shell Anda, Anda benar-benar menulis sedikit kode yang diinterpretasikan shell Anda. Jika shell diminta untuk menjalankan perintah yang tidak cocok dengan salah satu kata kunci pemrogramannya, ia berkonsultasi dengan _variabel lingkungan_ yang disebut `$PATH` yang mencantumkan direktori mana yang harus dicari shell untuk program ketika diberi perintah:


```console
missing:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
missing:~$ which echo
/bin/echo
missing:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Ketika kita menjalankan perintah `echo`, shell melihat bahwa ia harus menjalankan program `echo`, dan kemudian mencari melalui daftar direktori yang dipisahkan `:` di `$PATH` untuk file dengan nama tersebut. Ketika menemukannya, ia menjalankannya (dengan asumsi file tersebut _dapat dieksekusi_; lebih lanjut tentang itu nanti). Kita dapat mengetahui file mana yang dijalankan untuk nama program tertentu menggunakan program `which`. Kita juga dapat melewati `$PATH` sepenuhnya dengan memberi _path_ ke file yang ingin kita jalankan.

## Navigasi di shell

Path di shell adalah daftar direktori yang dipisahkan; dipisahkan oleh `/` di Linux dan macOS dan `\` di Windows. Di Linux dan macOS, path `/` adalah "root" dari sistem file, di bawah mana semua direktori dan file berada, sedangkan di Windows ada satu root untuk setiap partisi disk (misalnya, `C:\`). Kami umumnya akan berasumsi bahwa Anda menggunakan sistem file Linux di kelas ini. Path yang dimulai dengan `/` disebut path _absolut_. Path lainnya adalah path _relatif_. Path relatif terhadap direktori kerja saat ini, yang dapat kita lihat dengan perintah `pwd` dan ubah dengan perintah `cd`. Dalam path, `.` mengacu pada direktori saat ini, dan `..` ke direktori induknya:

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

Perhatikan bahwa prompt shell kita terus memberi informasi tentang apa direktori kerja saat ini kita. Anda dapat mengonfigurasi prompt Anda untuk menunjukkan semua jenis informasi berguna, yang akan kita bahas dalam kuliah nanti.

Secara umum, ketika kita menjalankan program, ia akan beroperasi di direktori saat ini kecuali kita memberitahunya sebaliknya. Misalnya, ia biasanya akan mencari file di sana, dan membuat file baru di sana jika diperlukan.

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

Kecuali direktori diberikan sebagai argumen pertamanya, `ls` akan mencetak isi direktori saat ini. Sebagian besar perintah menerima flag dan opsi (flag dengan nilai) yang dimulai dengan `-` untuk memodifikasi perilakunya. Biasanya, menjalankan program dengan flag `-h` atau `--help` akan mencetak beberapa teks bantuan yang memberi tahu Anda flag dan opsi mana yang tersedia. Misalnya, `ls --help` memberi tahu kita:

```
  -l                         use a long listing format
```

```console
missing:~$ ls -l /home
drwxr-xr-x 1 missing  users  4096 Jun 15  2019 missing
```

Ini memberi kita banyak informasi tambahan tentang setiap file atau direktori yang ada. Pertama, `d` di awal baris memberi tahu kita bahwa `missing` adalah direktori. Kemudian ikuti tiga kelompok tiga karakter (`rwx`). Ini menunjukkan izin apa yang dimiliki pemilik file (`missing`), grup pemilik (`users`), dan orang lain masing-masing pada item yang relevan. `-` menunjukkan bahwa prinsipal yang diberikan tidak memiliki izin yang diberikan. Di atas, hanya pemilik yang diizinkan untuk memodifikasi (`w`) direktori `missing` (yaitu, menambah/menghapus file di dalamnya). Untuk masuk ke direktori, pengguna harus memiliki izin "search" (diwakili oleh "execute": `x`) pada direktori tersebut (dan induknya). Untuk mendaftarkan isinya, pengguna harus memiliki izin read (`r`) pada direktori tersebut. Untuk file, izinnya seperti yang Anda harapkan. Perhatikan bahwa hampir semua file di `/bin` memiliki izin `x` yang diatur untuk grup terakhir, "orang lain", sehingga siapa pun dapat menjalankan program-program tersebut.

Beberapa program berguna lainnya untuk diketahui pada titik ini adalah `mv` (untuk mengganti nama/memindahkan file), `cp` (untuk menyalin file), dan `mkdir` (untuk membuat direktori baru).

Jika Anda pernah menginginkan informasi _lebih lanjut_ tentang argumen, input, output program, atau cara kerjanya secara umum, coba program `man`. Ini mengambil sebagai argumen nama program, dan menunjukkan halaman _manual_ nya. Tekan `q` untuk keluar.

```console
missing:~$ man ls
```

## Menghubungkan program

Di shell, program memiliki dua "stream" utama yang terkait dengannya: stream input mereka dan stream output mereka. Ketika program mencoba membaca input, ia membaca dari stream input, dan ketika mencetak sesuatu, ia mencetak ke stream outputnya. Biasanya, input dan output program keduanya adalah terminal Anda. Artinya, keyboard Anda sebagai input dan layar Anda sebagai output. Namun, kita juga dapat mengubah aliran stream tersebut!

Bentuk paling sederhana dari redirection adalah `< file` dan `> file`. Ini memungkinkan Anda mengubah stream input dan output program ke file masing-masing:

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

Seperti yang ditunjukkan dalam contoh di atas, `cat` adalah program yang menyam`bung`kan file. Ketika diberi nama file sebagai argumen, ia mencetak isi masing-masing file secara berurutan ke stream outputnya. Tetapi ketika `cat` tidak diberi argumen, ia mencetak isi dari stream inputnya ke stream outputnya (seperti dalam contoh ketiga di atas).

Anda juga dapat menggunakan `>>` untuk menambahkan ke file. Di mana jenis redirection input/output ini benar-benar bersinar adalah dalam penggunaan _pipes_. Operator `|` memungkinkan Anda "merantai" program sedemikian rupa sehingga output satu adalah input yang lain:

```console
missing:~$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2019 var
missing:~$ curl --head --silent google.com | grep --ignore-case content-length | cut --delimiter=' ' -f2
219
```

Kita akan masuk ke lebih banyak detail tentang cara memanfaatkan pipes dalam kuliah tentang data wrangling.

## Alat yang serbaguna dan kuat

Pada kebanyakan sistem mirip Unix, satu pengguna istimewa: pengguna "root". Anda mungkin telah melihatnya dalam daftar file di atas. Pengguna root berada di atas (hampir) semua pembatasan akses, dan dapat membuat, membaca, memperbarui, dan menghapus file apa pun di sistem. Anda biasanya tidak akan masuk ke sistem Anda sebagai pengguna root, karena terlalu mudah untuk secara tidak sengaja merusak sesuatu. Sebaliknya, Anda akan menggunakan perintah `sudo`. Seperti namanya, ini membiarkan Anda "melakukan" sesuatu "sebagai su" (singkatan dari "super user", atau "root"). Ketika Anda mendapat kesalahan izin ditolak, biasanya karena Anda perlu melakukan sesuatu sebagai root. Meskipun pastikan Anda pertama-tama memeriksa ulang bahwa Anda benar-benar ingin melakukannya dengan cara itu!

Satu hal yang perlu Anda menjadi root untuk lakukan adalah menulis ke sistem file `sysfs` yang dipasang di bawah `/sys`. `sysfs` mengekspos sejumlah parameter kernel sebagai file, sehingga Anda dapat dengan mudah mengonfigurasi ulang kernel dengan cepat tanpa alat khusus. **Perhatikan bahwa sysfs tidak ada di Windows atau macOS.**

Misalnya, kecerahan layar laptop Anda diekspos melalui file yang disebut `brightness` di bawah

```
/sys/class/backlight
```

Dengan menulis nilai ke file tersebut, kita dapat mengubah kecerahan layar. Firasat pertama Anda mungkin melakukan sesuatu seperti:

```console
$ sudo find -L /sys/class/backlight -maxdepth 2 -name '*brightness*'
/sys/class/backlight/thinkpad_screen/brightness
$ cd /sys/class/backlight/thinkpad_screen
$ sudo echo 3 > brightness
An error occurred while redirecting file 'brightness'
open: Permission denied
```

Kesalahan ini mungkin datang sebagai kejutan. Lagipula, kita menjalankan perintah dengan `sudo`! Ini adalah hal penting untuk diketahui tentang shell. Operasi seperti `|`, `>`, dan `<` dilakukan _oleh shell_, bukan oleh program individual. `echo` dan teman-temannya tidak "tahu" tentang `|`. Mereka hanya membaca dari input mereka dan menulis ke output mereka, apa pun itu. Dalam kasus di atas, _shell_ (yang diautentikasi sebagai pengguna Anda) mencoba membuka file brightness untuk ditulis, sebelum mengaturnya sebagai output `sudo echo`, tetapi dicegah dari melakukannya karena shell tidak berjalan sebagai root. Menggunakan pengetahuan ini, kita dapat mengatasinya:

```console
$ echo 3 | sudo tee brightness
```

Karena program `tee` adalah yang membuka file `/sys` untuk ditulis, dan _itu_ berjalan sebagai `root`, semua izin berfungsi. Anda dapat mengontrol semua jenis hal yang menyenangkan dan berguna melalui `/sys`, seperti status berbagai LED sistem (path Anda mungkin berbeda):

```console
$ echo 1 | sudo tee /sys/class/leds/input6::scrolllock/brightness
```

# Langkah selanjutnya

Pada titik ini Anda tahu jalan Anda di sekitar shell cukup untuk menyelesaikan tugas-tugas dasar. Anda seharusnya dapat bernavigasi untuk menemukan file yang menarik dan menggunakan fungsi dasar sebagian besar program. Dalam kuliah berikutnya, kita akan berbicara tentang cara melakukan dan mengotomatisasi tugas yang lebih kompleks menggunakan shell dan banyak program baris perintah yang berguna di luar sana.

# Latihan

Semua kelas dalam kursus ini disertai dengan serangkaian latihan. Beberapa memberi Anda tugas spesifik untuk dilakukan, sementara yang lain terbuka, seperti "coba gunakan program X dan Y". Kami sangat mendorong Anda untuk mencobanya.

Kami belum menulis solusi untuk latihan. Jika Anda terjebak pada sesuatu secara khusus, jangan ragu untuk mengirim email kepada kami yang menjelaskan apa yang telah Anda coba sejauh ini, dan kami akan mencoba membantu Anda.

 1. Untuk kursus ini, Anda perlu menggunakan shell Unix seperti Bash atau ZSH. Jika Anda berada di Linux atau macOS, Anda tidak perlu melakukan apa pun yang istimewa. Jika Anda berada di Windows, Anda perlu memastikan Anda tidak menjalankan cmd.exe atau PowerShell; Anda dapat menggunakan [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/) atau mesin virtual Linux untuk menggunakan alat baris perintah gaya Unix. Untuk memastikan Anda menjalankan shell yang sesuai, Anda dapat mencoba perintah `echo $SHELL`. Jika mengatakan sesuatu seperti `/bin/bash` atau `/usr/bin/zsh`, itu berarti Anda menjalankan program yang benar.
 1. Buat direktori baru bernama `missing` di bawah `/tmp`.
 1. Cari program `touch`. Program `man` adalah teman Anda.
 1. Gunakan `touch` untuk membuat file baru bernama `semester` di `missing`.
 1. Tulis yang berikut ke file tersebut, satu baris pada satu waktu:
    ```
    #!/bin/sh
    curl --head --silent https://missing.csail.mit.edu
    ```
    Baris pertama mungkin sulit untuk bekerja. Membantu untuk mengetahui bahwa `#` memulai komentar di Bash, dan `!` memiliki arti khusus bahkan dalam string yang dikutip ganda (`"`). Bash memperlakukan string yang dikutip tunggal (`'`) secara berbeda: mereka akan berhasil dalam kasus ini. Lihat halaman manual [quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html) Bash untuk informasi lebih lanjut.
 1. Coba jalankan file tersebut, yaitu ketik path ke script (`./semester`) ke shell Anda dan tekan enter. Pahami mengapa itu tidak berfungsi dengan berkonsultasi pada output `ls` (petunjuk: lihat bit izin file).
 1. Jalankan perintah dengan secara eksplisit memulai interpreter `sh`, dan memberinya file `semester` sebagai argumen pertama, yaitu `sh semester`. Mengapa ini berfungsi, sementara `./semester` tidak?
 1. Cari program `chmod` (misalnya gunakan `man chmod`).
 1. Gunakan `chmod` untuk membuatnya mungkin menjalankan perintah `./semester` daripada harus mengetik `sh semester`. Bagaimana shell Anda tahu bahwa file tersebut seharusnya diinterpretasikan menggunakan `sh`? Lihat halaman ini tentang baris [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) untuk informasi lebih lanjut.
 1. Gunakan `|` dan `>` untuk menulis output tanggal "terakhir dimodifikasi" oleh `semester` ke file bernama `last-modified.txt` di direktori home Anda.
 1. Tulis perintah yang membaca level daya baterai laptop Anda atau suhu CPU mesin desktop Anda dari `/sys`. Catatan: jika Anda pengguna macOS, OS Anda tidak memiliki sysfs, jadi Anda dapat melewatkan latihan ini.