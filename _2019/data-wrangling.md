---
layout: lecture
title: "Data Wrangling"
presenter: Jon
date: 2019-01-17
order: 2
video:
  aspect: 56.25
  id: VW2jn9Okjhw
---

Apakah Anda pernah memiliki sekumpulan teks dan ingin melakukan sesuatu dengannya?
Bagus. Itulah inti dari data wrangling!
Secara khusus, mengadaptasi data dari satu format ke format lain, sampai Anda mendapatkan
hasil yang tepat seperti yang Anda inginkan.

Kita sudah pernah melihat data wrangling dasar: `journalctl | grep -i intel`.
 - temukan semua entri log sistem yang menyebutkan Intel (case insensitive)
 - sebenarnya, sebagian besar data wrangling adalah tentang mengetahui alat apa yang Anda miliki,
   dan bagaimana menggabungkannya.

Mari kita mulai dari awal: kita butuh sumber data, dan sesuatu untuk
diolah darinya. Log sering menjadi kasus penggunaan yang baik, karena Anda sering ingin
menyelidiki sesuatu tentang log tersebut, dan membaca keseluruhan log tidaklah
memungkinkan. Mari kita cari tahu siapa yang mencoba masuk ke server saya dengan melihat
log server saya:

```bash
ssh myserver journalctl
```

Itu terlalu banyak datanya. Mari kita batasi hanya untuk ssh:

```bash
ssh myserver journalctl | grep sshd
```

Perhatikan bahwa kita menggunakan pipe untuk mengalirkan file _remote_ melalui `grep`
di komputer lokal kita! `ssh` memang ajaib. Namun ini masih jauh lebih banyak data
dari yang kita inginkan. Dan cukup sulit dibaca. Mari kita lakukan yang lebih baik:

```bash
ssh myserver journalctl | grep sshd | grep "Disconnected from"
```

Masih ada banyak noise di sini. Ada _sangat banyak_ cara untuk menghilangkannya,
tetapi mari kita lihat salah satu alat paling ampuh di kotak peralatan Anda: `sed`.

`sed` adalah "stream editor" yang dibangun di atas editor `ed` lama. Di dalamnya,
Anda pada dasarnya memberikan perintah singkat untuk cara memodifikasi file, alih-alih
memanipulasi isinya secara langsung (meskipun Anda juga bisa melakukan itu).
Ada banyak perintah, tetapi salah satu yang paling umum adalah `s`:
substitusi. Sebagai contoh, kita bisa menulis:

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed 's/.*Disconnected from //'
```

Apa yang baru saja kita tulis adalah _regular expression_ sederhana; sebuah konstruksi
yang ampuh yang memungkinkan Anda mencocokkan teks terhadap pola. Perintah `s`
ditulis dalam bentuk: `s/REGEX/SUBSTITUTION/`, di mana `REGEX` adalah
regular expression yang ingin Anda cari, dan `SUBSTITUTION` adalah
teks yang ingin Anda substitusikan untuk teks yang cocok.

## Regular expressions

Regular expression cukup umum dan berguna sehingga layak untuk
meluangkan waktu memahami cara kerjanya. Mari kita mulai dengan melihat
yang kita gunakan di atas: `/.*Disconnected from /`. Regular expression biasanya
(meskipun tidak selalu) diapit oleh `/`. Sebagian besar karakter ASCII
tetap membawa makna normalnya, tetapi beberapa karakter memiliki perilaku pencocokan
"spesial". Karakter mana yang melakukan apa agak berbeda
antar implementasi regular expression yang berbeda, yang merupakan
sumber frustrasi besar. Pola yang sangat umum adalah:

 - `.` berarti "satu karakter apa pun" kecuali newline
 - `*` nol atau lebih dari pencocokan sebelumnya
 - `+` satu atau lebih dari pencocokan sebelumnya
 - `[abc]` salah satu karakter dari `a`, `b`, dan `c`
 - `(RX1|RX2)` sesuatu yang cocok dengan `RX1` atau `RX2`
 - `^` awal dari baris
 - `$` akhir dari baris

Regular expression `sed` agak aneh, dan akan mengharuskan Anda
menambahkan `\` sebelum sebagian besar karakter ini untuk memberikan makna khususnya. Atau
Anda bisa menggunakan `-E`.

Jadi, melihat kembali `/.*Disconnected from /`, kita lihat bahwa itu cocok
dengan teks apa pun yang dimulai dengan sejumlah karakter, diikuti oleh
string literal "Disconnected from ". Itulah yang kita inginkan. Namun
hati-hati, regular expression itu rumit. Bagaimana jika seseorang mencoba masuk
dengan username "Disconnected from"? Kita akan mendapatkan:

```
Jan 17 03:13:00 thesquareplanet.com sshd[2631]: Disconnected from invalid user Disconnected from 46.97.239.16 port 55920 [preauth]
```

Apa yang akan kita dapatkan? Nah, `*` dan `+` secara default bersifat "greedy".
Mereka akan mencocokkan sebanyak mungkin teks. Jadi, pada contoh di atas, kita akan mendapatkan
hanya

```
46.97.239.16 port 55920 [preauth]
```

Yang mungkin bukan yang kita inginkan. Di beberapa implementasi regular expression,
Anda bisa menambahkan `?` setelah `*` atau `+` untuk membuatnya non-greedy,
tetapi sayangnya `sed` tidak mendukung konstruksi tersebut. Kita _bisa_ beralih ke
mode command-line perl, yang _mendukung_ konstruksi tersebut:

```bash
perl -pe 's/.*?Disconnected from //'
```

Kita akan tetap menggunakan `sed` untuk sisa materi ini, karena itu adalah
alat yang jauh lebih umum untuk pekerjaan semacam ini. `sed` juga bisa melakukan hal-hal
berguna lainnya seperti mencetak baris setelah pencocokan tertentu, melakukan beberapa
substitusi dalam satu pemanggilan, mencari sesuatu, dll. Tetapi kita tidak akan
membahas itu terlalu banyak di sini. `sed` pada dasarnya merupakan topik tersendiri,
tetapi sering kali ada alat yang lebih baik.

Oke, jadi kita juga memiliki sufiks yang ingin kita hilangkan. Bagaimana caranya?
Agak rumit untuk mencocokkan hanya teks yang mengikuti
username, terutama jika username bisa memiliki spasi dan sejenisnya! Yang perlu
kita lakukan adalah mencocokkan _seluruh_ baris:

```bash
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user .* [^ ]+ port [0-9]+( \[preauth\])?$//'
```

Mari kita lihat apa yang terjadi dengan [regex
debugger](https://regex101.com/r/qqbZqh/2). Oke, jadi awalnya masih
sama seperti sebelumnya. Kemudian, kita mencocokkan salah satu varian "user" (ada
dua prefix di log). Kemudian kita mencocokkan string karakter apa pun
di mana username berada. Kemudian kita mencocokkan satu kata apa pun
(`[^ ]+`; urutan non-spasi apa pun yang tidak kosong). Kemudian kata
"port" diikuti oleh urutan digit. Kemudian mungkin sufiks
` [preauth]`, dan kemudian akhir baris.

Perhatikan bahwa dengan teknik ini, username "Disconnected from"
tidak akan membingungkan kita lagi. Bisakah Anda melihat alasannya?

Ada satu masalah dengan ini, yaitu seluruh log
menjadi kosong. Padahal kita ingin _menyimpan_ username. Untuk ini,
kita bisa menggunakan "capture group". Teks apa pun yang dicocokkan oleh regex yang diapit
tanda kurung disimpan di capture group bernomor. Ini tersedia
dalam substitusi (dan di beberapa engine, bahkan di pola itu sendiri!)
sebagai `\1`, `\2`, `\3`, dst. Jadi:

```bash
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

Seperti yang bisa Anda bayangkan, Anda bisa membuat regular expression yang _sangat_
rumit. Sebagai contoh, berikut artikel tentang cara mencocokkan
[alamat email](https://www.regular-expressions.info/email.html). Itu [tidak
mudah](https://web.archive.org/web/20221223174323/http://emailregex.com/). Dan ada [banyak
diskusi](https://stackoverflow.com/questions/201323/how-to-validate-an-email-address-using-a-regular-expression/1917982).
Dan orang-orang telah [menulis
tes](https://fightingforalostcause.net/content/misc/2006/compare-email-regex.php).
Dan [matriks tes](https://mathiasbynens.be/demo/url-regex). Anda bahkan
bisa menulis regex untuk menentukan apakah suatu bilangan [adalah bilangan
prima](https://www.noulakaz.net/2007/03/18/a-regular-expression-to-check-for-prime-numbers/).

Regular expression terkenal sulit untuk dibuat dengan benar, tetapi juga
sangat berguna untuk dimiliki di kotak peralatan Anda!

## Kembali ke data wrangling

Oke, jadi sekarang kita punya

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

Kita bisa melakukannya hanya dengan `sed`, tapi untuk apa? Untuk kesenangan, itulah alasannya.

```bash
ssh myserver journalctl
 | sed -E
   -e '/Disconnected from/!d'
   -e 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

Ini menunjukkan beberapa kemampuan `sed`. `sed` juga bisa menyisipkan teks
(dengan perintah `i`), mencetak baris secara eksplisit (dengan perintah `p`),
memilih baris berdasarkan indeks, dan banyak hal lainnya. Cek `man sed`!

Bagaimanapun. Yang kita punya sekarang memberikan daftar semua username yang telah
mencoba masuk. Tapi ini cukup tidak membantu. Mari kita cari yang paling umum:

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
```

`sort` akan, yah, mengurutkan inputnya. `uniq -c` akan menggabungkan baris-baris
berurutan yang sama menjadi satu baris, diawali dengan hitungan jumlah
kemunculannya. Kita mungkin ingin mengurutkannya juga dan hanya menyimpan
login yang paling umum:

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
```

`sort -n` akan mengurutkan dalam urutan numerik (bukan leksikografik). `-k1,1`
berarti "urutkan hanya berdasarkan kolom pertama yang dipisahkan whitespace". Bagian `,n`
berarti "urutkan sampai bidang ke-`n`, di mana defaultnya adalah akhir
baris. Dalam contoh _khusus_ ini, mengurutkan berdasarkan seluruh baris
tidak akan berpengaruh, tetapi kita di sini untuk belajar!

Jika kita ingin yang _paling jarang_, kita bisa menggunakan `head` alih-alih
`tail`. Ada juga `sort -r`, yang mengurutkan dalam urutan terbalik.

Oke, jadi itu cukup keren, tapi kita ingin hanya menampilkan
username, dan mungkin bukan satu per baris?

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
 | awk '{print $2}' | paste -sd,
```

Mari kita mulai dengan `paste`: alat ini memungkinkan Anda menggabungkan baris (`-s`) dengan
delimiter karakter tunggal (`-d`). Tapi apa urusan `awk` ini?

## awk -- editor lainnya

`awk` adalah bahasa pemrograman yang kebetulan sangat bagus dalam
memproses stream teks. Ada _sangat banyak_ yang bisa dikatakan tentang `awk` jika Anda
mempelajarinya dengan benar, tetapi seperti banyak hal lainnya di sini, kita hanya akan
membahas dasar-dasarnya.

Pertama, apa yang dilakukan `{print $2}`? Nah, program `awk` memiliki bentuk
pola opsional ditambah blok yang menentukan apa yang harus dilakukan jika pola
cocok dengan baris tertentu. Pola default (yang kita gunakan di atas) cocok
dengan semua baris. Di dalam blok, `$0` diisi dengan seluruh isi baris,
dan `$1` sampai `$n` diisi dengan bidang ke-`n` dari baris tersebut, ketika
dipisahkan oleh field separator `awk` (whitespace secara default, bisa diubah
dengan `-F`). Dalam kasus ini, kita mengatakan bahwa, untuk setiap baris, cetak
isi bidang kedua, yang kebetulan adalah username!

Mari kita lihat apakah kita bisa melakukan sesuatu yang lebih canggih. Mari kita hitung jumlah
username sekali pakai yang dimulai dengan `c` dan diakhiri dengan `e`:

```bash
 | awk '$1 == 1 && $2 ~ /^c[^ ]*e$/ { print $2 }' | wc -l
```

Ada banyak yang perlu diurai di sini. Pertama, perhatikan bahwa sekarang kita punya pola
(bagian yang ada sebelum `{...}`). Pola tersebut mengatakan bahwa bidang pertama
baris harus sama dengan 1 (itu adalah hitungan dari `uniq
-c`), dan bidang kedua harus cocok dengan regular expression
yang diberikan. Dan blok tersebut hanya mengatakan untuk mencetak username. Kemudian kita hitung
jumlah baris dalam output dengan `wc -l`.

Namun, `awk` adalah bahasa pemrograman, ingat?

```awk
BEGIN { rows = 0 }
$1 == 1 && $2 ~ /^c[^ ]*e$/ { rows += $1 }
END { print rows }
```

`BEGIN` adalah pola yang cocok dengan awal input (dan `END`
cocok dengan akhir). Sekarang, blok per-baris hanya menambahkan hitungan dari
bidang pertama (meskipun selalu 1 dalam kasus ini), dan kemudian kita mencetaknya
di akhir. Sebenarnya, kita _bisa_ menghilangkan `grep` dan `sed`
sepenuhnya, karena `awk` [bisa melakukan semuanya](https://web.archive.org/web/20251210045942/https://backreference.org/2010/02/10/idiomatic-awk/), tetapi kita
akan menyerahkan itu sebagai latihan bagi pembaca.

## Menganalisis data

Anda bisa berhitung!

```bash
 | paste -sd+ | bc -l
```

```bash
echo "2*($(data | paste -sd+))" | bc -l
```

Anda bisa mendapatkan statistik dengan berbagai cara.
[`st`](https://github.com/nferraz/st) cukup bagus, tetapi jika Anda sudah
punya R:

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | awk '{print $1}' | R --slave -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
```

R adalah bahasa pemrograman lain (yang aneh) yang hebat untuk analisis data
dan [plotting](https://ggplot2.tidyverse.org/). Kita tidak akan membahas terlalu
detail, tetapi cukup dikatakan bahwa `summary` mencetak statistik ringkasan
tentang matriks, dan kita menghitung matriks dari stream input berupa
angka, jadi R memberi kita statistik yang kita inginkan!

Jika Anda hanya ingin plotting sederhana, `gnuplot` adalah teman Anda:

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
 | gnuplot -p -e 'set boxwidth 0.5; plot "-" using 1:xtic(2) with boxes'
```

## Data wrangling untuk membuat argumen

Terkadang Anda ingin melakukan data wrangling untuk menemukan hal-hal yang perlu diinstal atau
dihapus berdasarkan daftar yang lebih panjang. Data wrangling yang telah kita bahas
sejauh ini + `xargs` bisa menjadi kombinasi yang ampuh:

```bash
rustup toolchain list | grep nightly | grep -vE "nightly-x86|01-17" | sed 's/-x86.*//' | xargs rustup toolchain uninstall
```

# Latihan

1. Jika Anda belum familiar dengan Regular Expression,
   [di sini](https://regexone.com/) adalah tutorial interaktif singkat yang
   mencakup sebagian besar dasar-dasarnya
1. Apa perbedaan `sed s/REGEX/SUBSTITUTION/g` dengan sed biasa?
   Bagaimana dengan `/I` atau `/m`?
1. Untuk melakukan substitusi in-place, sangat menggoda untuk melakukan sesuatu seperti
   `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt`. Namun ini adalah
   ide yang buruk, mengapa? Apakah ini khusus untuk `sed`?
1. Implementasikan alat sederhana yang setara dengan grep menggunakan bahasa yang Anda kuasai dengan regex. Jika Anda ingin outputnya diwarnai seperti grep, cari ANSI color escape sequences.
1. Terkadang beberapa operasi seperti mengganti nama file bisa rumit dengan perintah mentah seperti `mv`. `rename` adalah alat yang berguna untuk mencapai hal ini dan memiliki sintaks mirip sed. Cobalah buat sejumlah file dengan spasi di namanya dan gunakan `rename` untuk menggantinya dengan underscore.
1. Cari pesan boot yang _tidak_ sama di antara tiga
   reboot terakhir Anda (lihat flag `-b` dari `journalctl`). Anda mungkin ingin menggabungkan semua
   log boot menjadi satu file, karena itu mungkin mempermudah.
1. Buat beberapa statistik waktu boot sistem Anda selama sepuluh
   boot terakhir menggunakan timestamp log dari pesan
   ```
   Logs begin at ...
   ```
   dan
   ```
   systemd[577]: Startup finished in ...
   ```
1. Temukan jumlah kata (di `/usr/share/dict/words`) yang mengandung setidaknya
   tiga `a` dan tidak berakhiran `'s`. Apa tiga
   huruf terakhir paling umum dari kata-kata tersebut? Perintah `y` dari `sed`, atau
   program `tr`, mungkin membantu Anda untuk case insensitivity. Berapa banyak
   kombinasi dua huruf yang ada? Dan untuk tantangan:
   kombinasi mana yang tidak muncul?
1. Cari dataset online seperti [yang
   ini](https://commons.wikimedia.org/wiki/Data:Wikipedia_statistics/data.tab) atau [yang
   ini](https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/topic-pages/tables/table-1).
   Mungkin yang lain [dari
   sini](https://www.springboard.com/blog/data-science/free-public-data-sets-data-science-project/).
   Ambil menggunakan `curl` dan ekstrak hanya dua kolom data numerik.
   Jika Anda mengambil data HTML,
   [`pup`](https://github.com/EricChiang/pup) mungkin berguna. Untuk data
   JSON, coba [`jq`](https://stedolan.github.io/jq/). Temukan min dan
   max dari satu kolom dalam satu perintah, dan jumlah selisih
   antara dua kolom di perintah lainnya.
