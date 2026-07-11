---
layout: lecture
title: "Data Wrangling"
description: >
  Pelajari cara memanipulasi dan mentransformasi data menggunakan alat baris perintah seperti sed, awk, dan ekspresi reguler.
thumbnail: /static/assets/thumbnails/2020/lec4.png
date: 2020-01-16
ready: true
video:
  aspect: 56.25
  id: sz_dsktIjt4
special: true
---

Pernahkah Anda ingin mengambil data dalam satu format dan mengubahnya
menjadi format yang berbeda? Tentu saja pernah! Secara umum, itulah
yang menjadi pembahasan utama kuliah ini. Secara khusus, mengolah data,
baik dalam format teks maupun biner, hingga Anda mendapatkan apa yang
Anda inginkan.

Kita sudah pernah melihat beberapa dasar data wrangling di kuliah-kuliah
sebelumnya. Hampir setiap kali Anda menggunakan operator `|`, Anda
sedang melakukan semacam data wrangling. Perhatikan perintah seperti
`journalctl | grep -i intel`. Perintah ini mencari semua entri log
sistem yang menyebutkan Intel (tidak membedakan huruf besar/kecil).
Anda mungkin tidak menganggapnya sebagai pengolahan data, tetapi ini
berubah dari satu format (seluruh log sistem Anda) menjadi format yang
lebih berguna bagi Anda (hanya entri log intel). Sebagian besar data
wrangling adalah tentang mengetahui alat apa yang Anda miliki, dan
bagaimana menggabungkannya.

Mari kita mulai dari awal. Untuk mengolah data, kita membutuhkan dua
hal: data untuk diolah, dan sesuatu untuk dilakukan dengannya. Log
seringkali menjadi kasus penggunaan yang baik, karena Anda sering ingin
menyelidiki sesuatu tentang log tersebut, dan membaca seluruhnya tidak
memungkinkan. Mari kita cari tahu siapa yang mencoba masuk ke server
saya dengan melihat log server:

```bash
ssh myserver journalctl
```

Itu terlalu banyak data. Mari kita batasi hanya untuk ssh:

```bash
ssh myserver journalctl | grep sshd
```

Perhatikan bahwa kita menggunakan pipe untuk mengalirkan file _remote_
melalui `grep` di komputer lokal kita! `ssh` sangat luar biasa, dan
kita akan membahas lebih lanjut di kuliah berikutnya tentang command-line
environment. Ini masih jauh lebih banyak data dari yang kita inginkan.
Dan cukup sulit dibaca. Mari kita lakukan yang lebih baik:

```bash
ssh myserver 'journalctl | grep sshd | grep "Disconnected from"' | less
```

Mengapa ada tanda kutip tambahan? Well, log kita bisa sangat besar, dan
boros jika mengalirkan semuanya ke komputer kita baru kemudian melakukan
penyaringan. Sebagai gantinya, kita bisa melakukan penyaringan di server
remote, dan kemudian mengolah data tersebut secara lokal. `less`
memberikan kita "pager" yang memungkinkan kita menggulir ke atas dan ke
bawah melalui output yang panjang. Untuk menghemat lalu lintas tambahan
saat kita men-debug baris perintah, kita bahkan bisa menyimpan log yang
sudah difilter ke dalam file sehingga kita tidak perlu mengakses jaringan
saat mengembangkan:

```console
$ ssh myserver 'journalctl | grep sshd | grep "Disconnected from"' > ssh.log
$ less ssh.log
```

Masih ada banyak noise di sini. Ada _sangat banyak_ cara untuk
menghilangkannya, tetapi mari kita lihat salah satu alat paling kuat
dalam kotak peralatan Anda: `sed`.

`sed` adalah "stream editor" yang dibangun di atas editor `ed` yang lama.
Di dalamnya, Anda pada dasarnya memberikan perintah singkat untuk
mengubah file, daripada memanipulasi isinya secara langsung (meskipun
Anda juga bisa melakukannya). Ada banyak perintah, tetapi salah satu
yang paling umum adalah `s`: substitusi. Sebagai contoh, kita bisa
menulis:

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed 's/.*Disconnected from //'
```

Apa yang baru saja kita tulis adalah _ekspresi reguler_ sederhana; sebuah
konstruksi kuat yang memungkinkan Anda mencocokkan teks terhadap pola.
Perintah `s` ditulis dalam bentuk: `s/REGEX/SUBSTITUTION/`, di mana
`REGEX` adalah ekspresi reguler yang ingin Anda cari, dan `SUBSTITUTION`
adalah teks yang ingin Anda substitusikan untuk teks yang cocok.

(Anda mungkin mengenali sintaks ini dari bagian "Search and replace" di
[catatan kuliah](/2020/editors/#advanced-vim) Vim kita! Memang, Vim
menggunakan sintaks untuk mencari dan mengganti yang mirip dengan
perintah substitusi `sed`. Mempelajari satu alat sering kali membantu
Anda menjadi lebih mahir dengan alat lainnya.)

## Regular expressions

Regular expressions cukup umum dan berguna sehingga layak untuk
meluangkan waktu memahami cara kerjanya. Mari kita mulai dengan melihat
yang kita gunakan di atas: `/.*Disconnected from /`. Regular expressions
biasanya (meskipun tidak selalu) diapit oleh `/`. Sebagian besar
karakter ASCII membawa arti normalnya, tetapi beberapa karakter memiliki
perilaku pencocokan "spesial". Tepatnya karakter mana yang melakukan apa
sangat bervariasi antara implementasi regular expressions yang berbeda,
yang menjadi sumber frustrasi besar. Pola yang sangat umum adalah:

 - `.` berarti "satu karakter apa saja" kecuali newline
 - `*` nol atau lebih dari pencocokan sebelumnya
 - `+` satu atau lebih dari pencocokan sebelumnya
 - `[abc]` salah satu karakter dari `a`, `b`, dan `c`
 - `(RX1|RX2)` sesuatu yang cocok dengan `RX1` atau `RX2`
 - `^` awal dari baris
 - `$` akhir dari baris

Regular expressions `sed` agak aneh, dan akan mengharuskan Anda
menambahkan `\` sebelum sebagian besar karakter ini untuk memberikan
arti spesialnya. Atau Anda bisa menggunakan `-E`.

Jadi, melihat kembali `/.*Disconnected from /`, kita melihat bahwa ini
mencocokkan teks apa pun yang dimulai dengan sejumlah karakter, diikuti
oleh string literal "Disconnected from &rdquo;. Itulah yang kita
inginkan. Tetapi hati-hati, regular expressions bisa rumit. Bagaimana
jika seseorang mencoba masuk dengan nama pengguna "Disconnected from"?
Kita akan mendapatkan:

```
Jan 17 03:13:00 thesquareplanet.com sshd[2631]: Disconnected from invalid user Disconnected from 46.97.239.16 port 55920 [preauth]
```

Apa yang akan kita dapatkan? Well, `*` dan `+` secara default bersifat
"greedy". Mereka akan mencocokkan sebanyak mungkin teks. Jadi, pada
contoh di atas, kita akan mendapatkan

```
46.97.239.16 port 55920 [preauth]
```

Yang mungkin bukan yang kita inginkan. Pada beberapa implementasi regular
expression, Anda bisa menambahkan `?` setelah `*` atau `+` untuk
membuatnya non-greedy, tetapi sayangnya `sed` tidak mendukung konstruk
tersebut. Kita _bisa_ beralih ke mode command-line perl, yang _mendukung_
konstruk tersebut:

```bash
perl -pe 's/.*?Disconnected from //'
```

Kita akan tetap menggunakan `sed` untuk sisa ini, karena ini adalah alat
yang jauh lebih umum untuk pekerjaan semacam ini. `sed` juga bisa
melakukan hal-hal berguna lainnya seperti mencetak baris setelah
pencocokan tertentu, melakukan beberapa substitusi dalam satu pemanggilan,
mencari sesuatu, dll. Tetapi kita tidak akan membahasnya terlalu banyak
di sini. `sed` pada dasarnya merupakan topik tersendiri, tetapi sering
kali ada alat yang lebih baik.

Oke, jadi kita juga memiliki sufiks yang ingin kita hilangkan. Bagaimana
cara melakukannya? Agak rumit untuk mencocokkan hanya teks yang mengikut
nama pengguna, terutama jika nama pengguna bisa memiliki spasi dan
sebagainya! Yang perlu kita lakukan adalah mencocokkan _seluruh_ baris:

```bash
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user .* [^ ]+ port [0-9]+( \[preauth\])?$//'
```

Mari kita lihat apa yang terjadi dengan [regex
debugger](https://regex101.com/r/qqbZqh/2). Oke, jadi awalnya masih
sama seperti sebelumnya. Kemudian, kita mencocokkan salah satu varian
"user" (ada dua prefiks di log). Kemudian kita mencocokkan string apa
pun di mana nama pengguna berada. Kemudian kita mencocokkan satu kata
apa pun (`[^ ]+`; urutan non-kosong dari karakter bukan spasi). Kemudian
kata "port" diikuti oleh urutan angka. Kemudian mungkin sufiks
`[preauth]`, dan kemudian akhir baris.

Perhatikan bahwa dengan teknik ini, nama pengguna "Disconnected from"
tidak akan membingungkan kita lagi. Bisakah Anda melihat mengapa?

Ada satu masalah dengan ini, yaitu seluruh log menjadi kosong. Kita
ingin _mempertahankan_ nama pengguna. Untuk ini, kita bisa menggunakan
"capture groups". Teks apa pun yang dicocokkan oleh regex yang diapit
oleh tanda kurung disimpan dalam capture group bernomor. Ini tersedia
dalam substitusi (dan di beberapa engine, bahkan dalam pola itu sendiri!)
sebagai `\1`, `\2`, `\3`, dst. Jadi:

```bash
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

Seperti yang bisa Anda bayangkan, Anda bisa membuat regular expression
yang _sangat_ rumit. Sebagai contoh, berikut artikel tentang cara
mencocokkan [alamat email](https://www.regular-expressions.info/email.html).
Ini [tidak mudah](https://web.archive.org/web/20221223174323/http://emailregex.com/).
Dan ada [banyak diskusi](https://stackoverflow.com/questions/201323/how-to-validate-an-email-address-using-a-regular-expression/1917982).
Dan orang-orang telah [menulis tes](https://fightingforalostcause.net/content/misc/2006/compare-email-regex.php).
Dan [matriks tes](https://mathiasbynens.be/demo/url-regex). Anda bahkan
bisa menulis regex untuk menentukan apakah suatu bilangan [adalah bilangan
prima](https://www.noulakaz.net/2007/03/18/a-regular-expression-to-check-for-prime-numbers/).

Regular expressions terkenal sulit untuk dibuat benar, tetapi juga sangat
berguna untuk dimiliki di kotak peralatan Anda!

## Kembali ke data wrangling

Oke, jadi sekarang kita punya

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

`sed` bisa melakukan berbagai hal menarik lainnya, seperti menyisipkan
teks (dengan perintah `i`), mencetak baris secara eksplisit (dengan
perintah `p`), memilih baris berdasarkan indeks, dan banyak hal lainnya.
Cek `man sed`!

Bagaimanapun. Apa yang kita miliki sekarang memberi kita daftar semua
nama pengguna yang pernah mencoba masuk. Tetapi ini cukup tidak berguna.
Mari kita cari yang paling umum:

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
```

`sort` akan, well, mengurutkan inputnya. `uniq -c` akan menggabungkan
baris-baris berurutan yang sama menjadi satu baris, diawali dengan jumlah
kemunculan. Kita mungkin ingin mengurutkannya juga dan hanya menyimpan
nama pengguna yang paling umum:

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
```

`sort -n` akan mengurutkan dalam urutan numerik (bukan leksikografis).
`-k1,1` berarti "urutkan hanya berdasarkan kolom pertama yang dipisahkan
oleh whitespace". Bagian `,n` berarti "urutkan hingga bidang ke-`n`,
di mana defaultnya adalah akhir baris. Dalam contoh _khusus_ ini,
mengurutkan berdasarkan seluruh baris tidak akan berpengaruh, tetapi
kita di sini untuk belajar!

Jika kita ingin yang _paling jarang_ muncul, kita bisa menggunakan `head`
alih-alih `tail`. Ada juga `sort -r`, yang mengurutkan dalam urutan
terbalik.

Oke, jadi itu cukup keren, tetapi bagaimana jika kita ingin mengekstrak
hanya nama pengguna sebagai daftar yang dipisahkan koma, bukan satu per
baris, mungkin untuk file konfigurasi?

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
 | awk '{print $2}' | paste -sd,
```

Jika Anda menggunakan macOS: perhatikan bahwa perintah seperti yang
ditunjukkan tidak akan bekerja dengan `paste` BSD yang disertakan dengan
macOS. Lihat [latihan 4 dari kuliah shell
tools](/2020/shell-tools/#exercises) untuk lebih lanjut tentang
perbedaan antara BSD dan GNU coreutils serta petunjuk cara menginstal
GNU coreutils di macOS.

Mari kita mulai dengan `paste`: alat ini memungkinkan Anda menggabungkan
baris (`-s`) dengan delimiter karakter tunggal (`-d`; `,` dalam kasus
ini). Tetapi apa urusan `awk` ini?

## awk -- editor lainnya

`awk` adalah bahasa pemrograman yang kebetulan sangat bagus dalam
memproses stream teks. Ada _sangat banyak_ yang bisa dikatakan tentang
`awk` jika Anda mempelajarinya dengan benar, tetapi seperti banyak hal
lain di sini, kita hanya akan membahas dasar-dasarnya.

Pertama, apa yang dilakukan `{print $2}`? Well, program `awk` memiliki
bentuk pola opsional ditambah blok yang menentukan apa yang harus
dilakukan jika pola cocok dengan baris tertentu. Pola default (yang kita
gunakan di atas) mencocokkan semua baris. Di dalam blok, `$0` diisi
dengan seluruh isi baris, dan `$1` hingga `$n` diisi dengan bidang ke-`n`
dari baris tersebut, ketika dipisahkan oleh field separator `awk`
(whitespace secara default, ubah dengan `-F`). Dalam kasus ini, kita
mengatakan bahwa, untuk setiap baris, cetak isi dari bidang kedua, yang
kebetulan adalah nama pengguna!

Mari kita lihat apakah kita bisa melakukan sesuatu yang lebih menarik.
Mari kita hitung jumlah nama pengguna yang hanya digunakan sekali yang
dimulai dengan `c` dan diakhiri dengan `e`:

```bash
 | awk '$1 == 1 && $2 ~ /^c[^ ]*e$/ { print $2 }' | wc -l
```

Ada banyak yang harus diurai di sini. Pertama, perhatikan bahwa sekarang
kita memiliki pola (sesuatu yang ada sebelum `{...}`). Pola tersebut
mengatakan bahwa bidang pertama baris harus sama dengan 1 (itu adalah
hitungan dari `uniq -c`), dan bidang kedua harus cocok dengan regular
expression yang diberikan. Dan blok tersebut hanya mengatakan untuk
mencetak nama pengguna. Kemudian kita menghitung jumlah baris dalam
output dengan `wc -l`.

Namun, `awk` adalah bahasa pemrograman, ingat?

```awk
BEGIN { rows = 0 }
$1 == 1 && $2 ~ /^c[^ ]*e$/ { rows += $1 }
END { print rows }
```

`BEGIN` adalah pola yang mencocokkan awal input (dan `END` mencocokkan
akhir). Sekarang, blok per-baris hanya menambahkan hitungan dari bidang
pertama (meskipun akan selalu 1 dalam kasus ini), dan kemudian kita
mencetaknya di akhir. Bahkan, kita _bisa_ menghilangkan `grep` dan `sed`
sepenuhnya, karena `awk` [bisa melakukan
semuanya](https://web.archive.org/web/20251210045942/https://backreference.org/2010/02/10/idiomatic-awk/),
tetapi kita serahkan itu sebagai latihan bagi pembaca.

## Menganalisis data

Anda bisa melakukan perhitungan matematika langsung di shell menggunakan
`bc`, kalkulator yang bisa membaca dari STDIN! Sebagai contoh, jumlahkan
angka-angka pada setiap baris dengan menggabungkannya, dipisahkan oleh
`+`:

```bash
 | paste -sd+ | bc -l
```

Atau buat ekspresi yang lebih rumit:

```bash
echo "2*($(data | paste -sd+))" | bc -l
```

Anda bisa mendapatkan statistik dengan berbagai cara.
[`st`](https://github.com/nferraz/st) cukup menarik, tetapi jika Anda
sudah memiliki [R](https://www.r-project.org/):

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | awk '{print $1}' | R --no-echo -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
```

R adalah bahasa pemrograman lain (yang aneh) yang sangat bagus untuk
analisis data dan [plotting](https://ggplot2.tidyverse.org/). Kita tidak
akan membahas terlalu detail, tetapi cukup dikatakan bahwa `summary`
mencetak statistik ringkasan untuk sebuah vektor, dan kita membuat vektor
yang berisi aliran input angka, sehingga R memberikan statistik yang
kita inginkan!

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

Terkadang Anda ingin melakukan data wrangling untuk menemukan hal-hal
yang akan diinstal atau dihapus berdasarkan daftar yang lebih panjang.
Data wrangling yang telah kita bahas sejauh ini + `xargs` bisa menjadi
kombinasi yang kuat.

Sebagai contoh, seperti yang terlihat di kuliah, saya bisa menggunakan
perintah berikut untuk menghapus build nightly lama Rust dari sistem saya
dengan mengekstrak nama build lama menggunakan alat data wrangling dan
kemudian melewatkannya melalui `xargs` ke uninstaller:

```bash
rustup toolchain list | grep nightly | grep -vE "nightly-x86" | sed 's/-x86.*//' | xargs rustup toolchain uninstall
```

## Mengolah data biner

Sejauh ini, kita sebagian besar telah membahas mengolah data tekstual,
tetapi pipe sama bergunanya untuk data biner. Sebagai contoh, kita bisa
menggunakan ffmpeg untuk mengambil gambar dari kamera kita, mengubahnya
menjadi grayscale, mengompresnya, mengirimkannya ke mesin remote melalui
SSH, mendekompresnya di sana, membuat salinan, dan kemudian
menampilkannya.

```bash
ffmpeg -loglevel panic -i /dev/video0 -frames 1 -f image2 -
 | convert - -colorspace gray -
 | gzip
 | ssh mymachine 'gzip -d | tee copy.jpg | env DISPLAY=:0 feh -'
```

# Latihan

1. Ikuti [tutorial interaktif singkat tentang regex](https://regexone.com/) ini.
2. Temukan jumlah kata (dalam `/usr/share/dict/words`) yang mengandung
   setidaknya tiga `a` dan tidak berakhiran `'s`. Apa tiga kombinasi dua
   huruf terakhir yang paling umum dari kata-kata tersebut? Perintah `y`
   dari `sed`, atau program `tr`, mungkin membantu Anda untuk case
   insensitivity. Berapa banyak kombinasi dua huruf yang ada? Dan untuk
   tantangan: kombinasi mana yang tidak muncul?
3. Untuk melakukan substitusi in-place, sangat menggoda untuk melakukan
   sesuatu seperti `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt`.
   Namun ini adalah ide buruk, mengapa? Apakah ini khusus untuk `sed`?
   Gunakan `man sed` untuk mencari tahu cara melakukannya.
4. Temukan rata-rata, median, dan max waktu boot sistem Anda selama
   sepuluh boot terakhir. Gunakan `journalctl` di Linux dan `log show`
   di macOS, dan cari timestamp log dekat awal dan akhir setiap boot.
   Di Linux, mungkin terlihat seperti:
   ```
   Logs begin at ...
   ```
   dan
   ```
   systemd[577]: Startup finished in ...
   ```
   Di macOS, [cari](https://eclecticlight.co/2018/03/21/macos-unified-log-3-finding-your-way/):
   ```
   === system boot:
   ```
   dan
   ```
   Previous shutdown cause: 5
   ```
5. Cari pesan boot yang _tidak_ dibagi antara tiga reboot terakhir Anda
   (lihat flag `-b` dari `journalctl`). Pecah tugas ini menjadi beberapa
   langkah. Pertama, temukan cara untuk mendapatkan hanya log dari tiga
   boot terakhir. Mungkin ada flag yang berlaku pada alat yang Anda
   gunakan untuk mengekstrak log boot, atau Anda bisa menggunakan
   `sed '0,/STRING/d'` untuk menghapus semua baris sebelum baris yang
   cocok dengan `STRING`. Selanjutnya, hapus bagian baris yang _selalu_
   bervariasi (seperti timestamp). Kemudian, hapus duplikasi baris input
   dan simpan hitungan masing-masing (`uniq` adalah teman Anda). Dan
   terakhir, hilangkan baris yang hitungannya 3 (karena _ada_ di semua
   boot).
6. Cari dataset online seperti [yang ini](https://commons.wikimedia.org/wiki/Data:Wikipedia_statistics/data.tab),
   [yang ini](https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/topic-pages/tables/table-1),
   atau mungkin [dari sini](https://www.springboard.com/blog/data-science/free-public-data-sets-data-science-project/).
   Ambil menggunakan `curl` dan ekstrak hanya dua kolom data numerik.
   Jika Anda mengambil data HTML, [`pup`](https://github.com/EricChiang/pup)
   mungkin membantu. Untuk data JSON, coba [`jq`](https://stedolan.github.io/jq/).
   Temukan min dan max dari satu kolom dalam satu perintah, dan selisih
   jumlah dari masing-masing kolom di perintah lain.
