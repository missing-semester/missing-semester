---
layout: lecture
title: "Shell dan Scripting"
presenter: Jon
date: 2019-01-15
order: 3
video:
  aspect: 56.25
  id: dbDRfmH5uSI
---

Shell adalah antarmuka tekstual yang efisien untuk komputer Anda.

Prompt shell: apa yang menyambut Anda ketika Anda membuka terminal.
Memungkinkan Anda menjalankan program dan perintah; yang umum adalah:

 - `cd` untuk berpindah direktori
 - `ls` untuk menampilkan daftar file dan direktori
 - `mv` dan `cp` untuk memindahkan dan menyalin file

Namun shell memungkinkan Anda melakukan _jauh_ lebih banyak; Anda dapat menjalankan program apa pun di
komputer Anda, dan alat baris perintah tersedia untuk melakukan hampir semua
yang mungkin ingin Anda lakukan. Dan mereka sering kali lebih efisien daripada
padanan grafisnya. Kita akan membahas beberapa di antaranya di kelas ini.

Shell menyediakan bahasa pemrograman interaktif ("scripting").
Ada banyak shell:

 - Anda mungkin sudah menggunakan `sh` atau `bash`.
 - Ada juga shell yang sesuai dengan bahasa: `csh`.
 - Atau shell yang "lebih baik": `fish`, `zsh`, `ksh`.

Di kelas ini kita akan fokus pada `sh` dan `bash` yang ada di mana-mana, tetapi jangan
ragu untuk bereksperimen dengan yang lain. Saya suka `fish`.

Pemrograman shell adalah alat yang *sangat* berguna dalam kotak peralatan Anda.
Anda dapat menulis program langsung di prompt, atau ke dalam file.
`#!/bin/sh` + `chmod +x` untuk membuat shell dapat dieksekusi.

## Bekerja dengan shell

Jalankan perintah berulang kali:

```bash
for i in $(seq 1 5); do echo hello; done
```

Ada banyak yang harus diurai:

 - `for x in list; do BODY; done`
    - `;` mengakhiri perintah -- setara dengan baris baru
    - pisahkan `list`, tetapkan masing-masing ke `x`, dan jalankan body
    - pemisahan adalah "whitespace splitting", yang akan kita bahas kembali
    - tidak ada kurung kurawal di shell, jadi `do` + `done`
 - `$(seq 1 5)`
    - jalankan program `seq` dengan argumen `1` dan `5`
    - ganti seluruh `$()` dengan output dari program tersebut
    - setara dengan
      ```bash
      for i in 1 2 3 4 5
      ```
 - `echo hello`
    - semua hal dalam script shell adalah perintah
    - dalam hal ini, jalankan perintah `echo`, yang mencetak argumennya
      dengan argumen `hello`.
    - semua perintah dicari di `$PATH` (dipisahkan dengan tanda titik dua)

Kita memiliki variabel:
```bash
for f in $(ls); do echo $f; done
```

Akan mencetak nama setiap file di direktori saat ini.
Anda juga dapat mengatur variabel menggunakan `=` (tanpa spasi!):

```bash
foo=bar
echo $foo
```

Ada juga sejumlah variabel "khusus":

 - `$1` hingga `$9`: argumen untuk script
 - `$0` nama script itu sendiri
 - `$#` jumlah argumen
 - `$$` process ID dari shell saat ini

Untuk hanya mencetak direktori

```bash
for f in $(ls); do if test -d $f; then echo dir $f; fi; done
```

Lebih banyak yang harus diurai di sini:

 - `if CONDITION; then BODY; fi`
    - `CONDITION` adalah perintah; jika mengembalikan status keluar 0
      (sukses), maka `BODY` dijalankan.
    - juga dapat menambahkan `else` atau `elif`
    - sekali lagi, tidak ada kurung kurawal, jadi `then` + `fi`
 - `test` adalah program lain yang menyediakan berbagai pemeriksaan dan
    perbandingan, dan keluar dengan 0 jika benar (`$?`)
    - `man COMMAND` adalah teman Anda: `man test`
    - juga dapat dipanggil dengan `[` + `]`: `[ -d $f ]`
      - lihat `man test` dan `which "["`

Tapi tunggu! Ini salah! Bagaimana jika sebuah file bernama "My Documents"?

 - `for f in $(ls)` menjadi `for f in My Documents`
 - pertama lakukan pengujian pada `My`, kemudian pada `Documents`
 - bukan itu yang kita inginkan!
 - sumber bug terbesar dalam script shell

## Pemisahan argumen

Bash memisahkan argumen berdasarkan spasi; tidak selalu sesuai yang Anda inginkan!

 - perlu menggunakan tanda kutip untuk menangani spasi dalam argumen
    `for f in "My Documents"` akan bekerja dengan benar
 - masalah yang sama di tempat lain -- apakah Anda melihat di mana?
    `test -d $f`: jika `$f` mengandung spasi, `test` akan error!
 - `echo` kebetulan aman, karena pisahkan + gabungkan dengan spasi
    tapi bagaimana jika nama file mengandung baris baru?! berubah menjadi spasi!
 - kutip semua penggunaan variabel yang tidak ingin Anda pisahkan
 - tapi bagaimana kita memperbaiki script di atas?
    menurut Anda apa yang dilakukan `for f in "$(ls)"`?

Globbing adalah jawabannya!

 - bash tahu cara mencari file menggunakan pola:
    - `*` string karakter apa pun
    - `?` satu karakter apa pun
    - `{a,b,c}` salah satu dari karakter-karakter ini
 - `for f in *`: semua file di direktori ini
 - saat globbing, setiap file yang cocok menjadi argumen tersendiri
    - tetap perlu memastikan untuk mengutip saat _menggunakan_: `test -d "$f"`
 - dapat membuat pola tingkat lanjut:
    - `for f in a*`: semua file yang dimulai dengan `a` di direktori saat ini
    - `for f in foo/*.txt`: semua file `.txt` di `foo`
    - `for f in foo/*/p??.txt`
      semua file teks tiga huruf yang dimulai dengan p di subdirektori `foo`

Masalah spasi tidak berhenti di situ:

 - `if [ $foo = "bar" ]; then` -- melihat masalahnya?
 - bagaimana jika `$foo` kosong? argumen untuk `[` adalah `=` dan `bar`...
 - _bisa_ mengatasinya dengan `[ x$foo = "xbar" ]`, tapi tidak elegan
 - sebaliknya, gunakan `[[`: comparator bawaan bash yang memiliki parsing khusus
    - juga mengizinkan `&&` sebagai ganti `-a`, `||` sebagai ganti `-o`, dll.

<!-- TODO: arrays? $@. ${array[@]} vs "${array[@]}". -->

## Komposabilitas

Shell sangat kuat sebagian karena komposabilitasnya. Anda dapat merantai beberapa
program bersama-sama daripada memiliki satu program yang melakukan semuanya.

Karakter kuncinya adalah `|` (pipe).

 - `a | b` berarti jalankan `a` dan `b`
    kirim semua output `a` sebagai input ke `b`
    cetak output `b`

Semua program yang Anda jalankan ("proses") memiliki tiga "stream":

 - `STDIN`: ketika program membaca input, input berasal dari sini
 - `STDOUT`: ketika program mencetak sesuatu, hasilnya pergi ke sini
 - `STDERR`: output kedua yang dapat digunakan oleh program
 - secara default, `STDIN` adalah keyboard Anda, `STDOUT` dan `STDERR` keduanya
    adalah terminal Anda. tetapi Anda dapat mengubahnya!
    - `a | b` membuat `STDOUT` dari `a` menjadi `STDIN` dari `b`.
    - juga ada:
      - `a > foo` (`STDOUT` dari `a` pergi ke file `foo`)
      - `a 2> foo` (`STDERR` dari `a` pergi ke file `foo`)
      - `a < foo` (`STDIN` dari `a` dibaca dari file `foo`)
      - petunjuk: `tail -f` akan mencetak file saat file tersebut ditulis
 - mengapa ini berguna? memungkinkan Anda memanipulasi output dari sebuah program!
    - `ls | grep foo`: semua file yang mengandung kata `foo`
    - `ps | grep foo`: semua proses yang mengandung kata `foo`
    - `journalctl | grep -i intel | tail -n5`:
      5 pesan log sistem terakhir dengan kata intel (tidak membedakan huruf besar/kecil)
    - `who | sendmail -t me@example.com`
      kirim daftar pengguna yang login ke `me@example.com`
    - membentuk dasar untuk banyak pengolahan data, seperti yang akan kita bahas nanti

Bash juga menyediakan sejumlah cara lain untuk menggabungkan program.

Anda dapat mengelompokkan perintah dengan `(a; b) | tac`: jalankan `a`, lalu `b`, dan kirim
semua output mereka ke `tac`, yang mencetak inputnya dalam urutan terbalik.

Yang kurang dikenal, tetapi sangat berguna adalah _process substitution_.
`b <(a)` akan menjalankan `a`, menghasilkan nama file sementara untuk stream
outputnya, dan meneruskan nama file tersebut ke `b`. Sebagai contoh:

```bash
diff <(journalctl -b -1 | head -n20) <(journalctl -b -2 | head -n20)
```
akan menunjukkan perbedaan antara 20 baris pertama dari log boot terakhir
dan satu sebelumnya.

<!-- TODO: exit codes? -->

## Kontrol job dan proses

Bagaimana jika Anda ingin menjalankan hal-hal jangka panjang di latar belakang?

 - sufiks `&` menjalankan program "di latar belakang"
    - akan segera memberikan Anda prompt kembali
    - berguna jika Anda ingin menjalankan dua program secara bersamaan
      seperti server dan client: `server & client`
    - perhatikan bahwa program yang berjalan masih memiliki terminal Anda sebagai `STDOUT`!
      coba: `server > server.log & client`
 - lihat semua proses tersebut dengan `jobs`
    - perhatikan bahwa ia menampilkan "Running"
 - bawa ke foreground dengan `fg %JOB` (tanpa argumen adalah yang terbaru)
 - jika Anda ingin memindahkan program saat ini ke latar belakang: `^Z` + `bg` (Di sini `^Z` berarti menekan `Ctrl+Z`)
    - `^Z` menghentikan proses saat ini dan menjadikannya "job"
    - `bg` menjalankan job terakhir di latar belakang (seolah-olah Anda melakukan `&`)
 - job latar belakang masih terikat ke sesi Anda saat ini, dan keluar jika
    Anda logout. `disown` memungkinkan Anda memutus koneksi tersebut. atau gunakan `nohup`.
 - `$!` adalah pid dari proses latar belakang terakhir

<!-- TODO: process output control (^S and ^Q)? -->

Bagaimana dengan hal lain yang berjalan di komputer Anda?

 - `ps` adalah teman Anda: menampilkan daftar proses yang berjalan
    - `ps -A`: cetak proses dari semua pengguna (juga `ps ax`)
    - `ps` memiliki *banyak* argumen: lihat `man ps`
 - `pgrep`: cari proses dengan pencarian (seperti `ps -A | grep`)
    - `pgrep -af`: cari dan tampilkan dengan argumen
 - `kill`: kirim _signal_ ke proses berdasarkan ID (`pkill` berdasarkan pencarian + `-f`)
    - signal memberi tahu proses untuk "melakukan sesuatu"
    - yang paling umum: `SIGKILL` (`-9` atau `-KILL`): menyuruhnya keluar *sekarang*
      setara dengan `^\`
    - juga `SIGTERM` (`-15` atau `-TERM`): menyuruhnya keluar dengan baik-baik
      setara dengan `^C`


## Flag

Sebagian besar utilitas baris perintah menerima parameter menggunakan **flag**. Flag biasanya tersedia dalam bentuk pendek (`-h`) dan bentuk panjang (`--help`). Biasanya menjalankan `CMD -h` atau `man CMD` akan memberikan daftar flag yang diterima program.
Flag pendek biasanya dapat digabungkan, menjalankan `rm -r -f` setara dengan menjalankan `rm -rf` atau `rm -fr`.
Beberapa flag umum adalah standar de facto dan Anda akan menemukannya di banyak aplikasi:

* `-a` umumnya merujuk pada semua file (yaitu juga termasuk yang dimulai dengan titik)
* `-f` biasanya merujuk pada memaksa sesuatu, seperti `rm -f`
* `-h` menampilkan bantuan untuk sebagian besar perintah
* `-v` biasanya mengaktifkan output verbose
* `-V` biasanya mencetak versi dari perintah

Juga, double dash `--` digunakan dalam perintah bawaan dan banyak perintah lainnya untuk menandakan akhir dari opsi perintah, yang setelahnya hanya parameter posisional yang diterima. Jadi jika Anda memiliki file bernama `-v` (yang memang bisa) dan ingin melakukan grep pada file tersebut `grep pattern -- -v` akan berhasil sedangkan `grep pattern -v` tidak. Bahkan, salah satu cara untuk membuat file tersebut adalah dengan melakukan `touch -- -v`.

## Latihan

1. Jika Anda sama sekali baru menggunakan shell, Anda mungkin ingin membaca panduan yang lebih komprehensif seperti [BashGuide](https://mywiki.wooledge.org/BashGuide). Jika Anda ingin pendahuluan yang lebih mendalam [The Linux Command Line](https://linuxcommand.org/tlcl.php) adalah sumber daya yang bagus.

1. **PATH, which, type**

    Kita telah membahas secara singkat bahwa variabel lingkungan `PATH` digunakan untuk menemukan program yang Anda jalankan melalui baris perintah. Mari kita eksplorasi lebih lanjut
    - Jalankan `echo $PATH` (atau `echo $PATH | tr -s ':' '\n'` untuk tampilan yang lebih rapi) dan periksa isinya, lokasi apa saja yang tercantum?
    - Perintah `which` menemukan program di PATH pengguna. Cobalah jalankan `which` untuk perintah umum seperti `echo`, `ls` atau `mv`. Perhatikan bahwa `which` agak terbatas karena tidak memahami alias shell. Cobalah jalankan `type` dan `command -v` untuk perintah-perintah yang sama. Bagaimana outputnya berbeda?
    - Jalankan `PATH=` dan cobalah jalankan perintah-perintah sebelumnya lagi, beberapa berhasil dan beberapa tidak, bisakah Anda mengetahui alasannya?

1. **Variabel Khusus**
    - Variabel `~` diekspansi menjadi apa? Bagaimana dengan `.`? Dan `..`?
    - Apa fungsi variabel `$?`?
    - Apa fungsi variabel `$_`?
    - `!!` diekspansi menjadi apa? Bagaimana dengan `!!*`? Dan `!l`?
    - Carilah dokumentasi untuk opsi-opsi ini dan biasakan diri Anda dengan mereka

1. **xargs**

    Terkadang piping tidak cukup berhasil karena perintah yang menjadi tujuan pipe tidak mengharapkan format yang dipisahkan baris baru. Sebagai contoh, perintah `file` memberi tahu Anda properti dari file.

    Cobalah jalankan `ls | file` dan `ls | xargs file`. Apa yang dilakukan `xargs`?


1. **Shebang**

    Ketika Anda menulis script, Anda dapat menentukan ke shell Anda interpreter apa yang harus digunakan untuk menginterpretasikan script dengan menggunakan baris [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)). Tulis script bernama `hello` dengan isi berikut dan jadikan dapat dieksekusi dengan `chmod +x hello`. Kemudian eksekusi dengan `./hello`. Kemudian hapus baris pertama dan eksekusi lagi? Bagaimana shell menggunakan baris pertama tersebut?


    ```bash
      #! /usr/bin/python

      print("Hello World!")
    ```

    Anda akan sering melihat program yang memiliki shebang seperti `#! usr/bin/env bash`. Ini adalah solusi yang lebih portabel dengan [keuntungan dan kerugiannya](https://unix.stackexchange.com/questions/29608/why-is-it-better-to-use-usr-bin-env-name-instead-of-path-to-name-as-my) sendiri. Bagaimana `env` berbeda dari `which`? Variabel lingkungan apa yang digunakan `env` untuk memutuskan program apa yang akan dijalankan?


1. **Pipe, process substitution, subshell**

    Buat script bernama `slow_seq.sh` dengan isi berikut dan lakukan `chmod +x slow_seq.sh` untuk menjadikannya dapat dieksekusi.

    ```bash
      #! /usr/bin/env bash

      for i in $(seq 1 10); do
              echo $i;
              sleep 1;
      done
    ```

    Ada cara di mana pipe (dan process substitution) berbeda dari penggunaan eksekusi subshell, yaitu `$()`. Jalankan perintah-perintah berikut dan amati perbedaannya:

    - `./slow_seq.sh | grep -P "[3-6]"`
    - `grep -P "[3-6]" <(./slow_seq.sh)`
    - `echo $(./slow_seq.sh) | grep -P "[3-6]"`


1. **Lain-lain**
    - Cobalah jalankan `touch {a,b}{a,b}` kemudian `ls` apa yang muncul?
    - Terkadang Anda ingin menyimpan STDIN dan tetap mem-pipe-nya ke file. Cobalah jalankan `echo HELLO | tee hello.txt`
    - Cobalah jalankan `cat hello.txt > hello.txt` apa yang Anda perkirakan terjadi? Apa yang sebenarnya terjadi?
    - Jalankan `echo HELLO > hello.txt` dan kemudian jalankan `echo WORLD >> hello.txt`. Apa isi dari `hello.txt`? Bagaimana `>` berbeda dari `>>`?
    - Jalankan `printf "\e[38;5;81mfoo\e[0m\n"`. Bagaimana outputnya berbeda? Jika Anda ingin tahu lebih lanjut, carilah tentang ANSI color escape sequences.
    - Jalankan `touch a.txt` kemudian jalankan `^txt^log` apa yang dilakukan bash untuk Anda? Dengan cara yang sama, jalankan `fc`. Apa yang dilakukannya?

{% comment %}

TODO

1. **parallel**
- set -e, set -x
- traps

{% endcomment %}

1. **Pintasan keyboard**

    Seperti halnya aplikasi apa pun yang sering Anda gunakan, ada baiknya membiasakan diri dengan pintasan keyboardnya. Ketik yang berikut ini dan cobalah figures out apa yang mereka lakukan dan dalam skenario apa mungkin berguna untuk mengetahuinya. Untuk beberapa di antaranya mungkin lebih mudah mencari secara online tentang apa yang mereka lakukan. (ingat bahwa `^X` berarti menekan `Ctrl+X`)

    - `^A`, `^E`
    - `^R`
    - `^L`
    - `^C`, `^\` dan  `^D`
    - `^U` and `^Y`
