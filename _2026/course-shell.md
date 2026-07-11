---
layout: lecture
title: "Ikhtisar Kursus + Pengantar Shell"
description: >
  Pelajari motivasi kelas ini, dan mulai menggunakan shell.
thumbnail: /static/assets/thumbnails/2026/lec1.png
date: 2026-01-12
ready: true
video:
  aspect: 56.25
  id: MSgoeuMqUmU
---

# Siapa kami?

Kelas ini diajarkan bersama oleh [Anish](https://anish.io/),
[Jon](https://thesquareplanet.com/), dan [Jose](http://josejg.com/). Kami
semuanya mantan mahasiswa MIT yang memulai kelas MIT IAP ini sejak kami masih
menjadi mahasiswa. Anda dapat menghubungi kami secara kolektif di
[missing-semester@mit.edu](mailto:missing-semester@mit.edu).

Kami tidak dibayar untuk mengajar kelas ini, dan tidak memonetisasi kelas ini
dengan cara apa pun. Kami menyediakan semua [materi
kuliah](https://missing.csail.mit.edu/) dan [rekaman
kuliah](https://www.youtube.com/@MissingSemester) secara gratis
di internet. Jika Anda ingin mendukung pekerjaan kami, cara terbaik adalah
dengan menyebarkan informasi tentang kelas ini. Jika Anda adalah perusahaan,
universitas, atau organisasi lain yang menjalankan konten ini untuk kelompok
yang lebih besar, silakan kirimkan laporan pengalaman/testimoni melalui email
agar kami bisa mendengarnya :)

# Motivasi

Sebagai ilmuwan komputer, kita tahu bahwa komputer sangat handal dalam membantu
tugas-tugas berulang. Namun, terlalu sering kita lupa bahwa hal ini juga berlaku
untuk _penggunaan_ komputer kita, bukan hanya komputasi yang ingin kita lakukan
melalui program. Kita memiliki berbagai macam alat yang tersedia di ujung jari
yang memungkinkan kita untuk lebih produktif dan menyelesaikan masalah yang lebih
kompleks saat mengerjakan tugas apa pun yang berkaitan dengan komputer. Namun
banyak dari kita hanya menggunakan sebagian kecil dari alat-alat tersebut; kita
hanya tahu beberapa perintah ajaib secara hafalan untuk bertahan, dan
copy-paste perintah dari internet secara membabi-buta ketika kita terjebak.

Kelas ini adalah upaya untuk [mengatasi hal ini](/about/).

Kami ingin mengajarkan Anda cara memaksimalkan alat-alat yang Anda ketahui,
memperkenalkan alat-alat baru untuk ditambahkan ke kotak peralatan Anda, dan
semoga menanamkan semangat untuk menjelajahi (dan mungkin membangun) lebih
banyak alat sendiri. Inilah yang kami yakini sebagai semester yang hilang dari
sebagian besar kurikulum Ilmu Komputer.

# Struktur kelas

Kelas tanpa kredit ini terdiri dari sembilan kuliah masing-masing 1 jam, setiap
kuliah berfokus pada [topik tertentu](/2026/). Kuliah-kuliah ini sebagian besar
berdiri sendiri, meskipun seiring berjalannya semester kami akan berasumsi bahwa
Anda sudah familiar dengan materi dari kuliah-kuliah sebelumnya. Kami memiliki
catatan kuliah di internet, tetapi mungkin ada konten yang dibahas di kelas
(misalnya dalam bentuk demo) yang mungkin tidak ada di catatan. Seperti tahun-tahun
sebelumnya, kami akan merekam kuliah dan mengunggah rekamannya
[di internet](https://www.youtube.com/@MissingSemester).

Kami berusaha membahas banyak hal dalam waktu hanya beberapa kuliah 1 jam,
sehingga kuliah-kuliah ini cukup padat. Untuk memberi Anda waktu mengenal
kontennya dengan kecepatan Anda sendiri, setiap kuliah dilengkapi serangkaian
latihan yang memandu Anda melalui poin-poin kunci kuliah. Kami tidak akan
menjalankan jam kantor khusus, tetapi kami mendorong Anda untuk bertanya di
[OSSU Discord](https://ossu.dev/#community),
di `#missing-semester-forum`, atau kirim email kepada kami di
[missing-semester@mit.edu](mailto:missing-semester@mit.edu).

Karena waktu yang terbatas, kami tidak akan bisa membahas semua alat dengan
tingkat detail yang sama seperti kelas berskala penuh. Jika memungkinkan, kami
akan mengarahkan Anda ke sumber daya untuk menggali lebih dalam tentang suatu
alat atau topik, tetapi jika ada yang menarik perhatian Anda, jangan ragu untuk
menghubungi kami dan meminta petunjuk!

Terakhir, jika Anda memiliki umpan balik tentang kelas ini, silakan kirimkan
kepada kami melalui email di [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

# Topik 1: Shell

{% comment %}
lecturer: Jon
{% endcomment %}

## Apa itu shell?

Komputer saat ini memiliki berbagai macam antarmuka untuk memberikan perintah;
antarmuka grafis yang mewah, antarmuka suara, AR/VR, dan baru-baru ini: LLM.
Semua ini bagus untuk 80% kasus penggunaan, tetapi seringkali memiliki batasan
mendasar dalam hal yang mereka izinkan — Anda tidak dapat menekan tombol yang
tidak ada atau memberikan perintah suara yang belum diprogram. Untuk memanfaatkan
secara penuh alat-alat yang disediakan komputer Anda, kita harus kembali ke cara
lama dan beralih ke antarmuka tekstual: Shell.

Hampir semua platform yang bisa Anda gunakan memiliki shell dalam satu bentuk
atau lainnya, dan banyak di antaranya memiliki beberapa shell untuk Anda pilih.
Meskipun mungkin berbeda dalam detailnya, pada intinya semuanya kurang lebih
sama: mereka memungkinkan Anda menjalankan program, memberikan input, dan
memeriksa output mereka secara semi-terstruktur.

Untuk membuka _prompt_ shell (tempat Anda bisa mengetik perintah), Anda
membutuhkan _terminal_, yaitu antarmuka visual ke shell. Perangkat Anda
kemungkinan sudah terinstal salah satunya, atau Anda bisa menginstal dengan
mudah:

- **Linux:**
  Tekan `Ctrl + Alt + T` (berfungsi di sebagian besar distribusi). Atau cari
  "Terminal" di menu aplikasi Anda.
- **Windows:**
  Tekan `Win + R`, ketik `cmd` atau `powershell`, lalu tekan Enter.
  Atau cari "Terminal" atau "Command Prompt" di menu Start.
- **macOS:**
  Tekan `Cmd + Space` untuk membuka Spotlight, ketik "Terminal", lalu tekan Enter.
  Atau temukan di Applications → Utilities → Terminal.

Pada Linux dan macOS, ini biasanya akan membuka Bourne Again SHell, atau
"bash" singkatnya. Ini adalah salah satu shell yang paling banyak digunakan,
dan sintaksnya mirip dengan yang akan Anda lihat di banyak shell lainnya.
Di Windows, Anda akan disambut oleh shell "batch" atau "powershell", tergantung
pada perintah yang Anda jalankan. Keduanya spesifik untuk Windows, dan bukan
yang akan kita fokuskan di kelas ini, meskipun keduanya memiliki analogi untuk
sebagian besar yang akan kita ajarkan. Anda sebaiknya menggunakan [Windows
Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/) atau
mesin virtual Linux.

Shell lain juga ada, seringkali dengan banyak peningkatan ergonomis dibanding
bash (fish dan zsh adalah yang paling umum). Meskipun sangat populer (semua
instruktur menggunakannya), mereka tidak sebanyak bash, dan mengandalkan banyak
konsep yang sama, jadi kita tidak akan fokus pada mereka di kuliah ini.

## Mengapa Anda perlu mempedulikannya?

Shell bukan hanya (biasanya) jauh lebih cepat daripada "mengklik-klik", shell
juga hadir dengan kekuatan ekspresif yang tidak mudah ditemukan di satu program
grafis mana pun. Seperti yang akan kita lihat, shell memberi Anda kemampuan untuk
_menggabungkan_ program secara kreatif untuk mengotomatisasi hampir semua tugas.

Mengetahui cara menggunakan shell juga sangat berguna untuk menavigasi dunia
perangkat lunak open-source (yang seringkali datang dengan instruksi instalasi
yang membutuhkan shell), membangun integrasi berkelanjutan untuk proyek
perangkat lunak Anda (seperti dijelaskan di [kuliah Code
Quality](/2026/code-quality/)), dan men-debug kesalahan ketika program lain
gagal.

## Navigasi di shell

Ketika Anda membuka terminal, Anda akan melihat _prompt_ yang biasanya terlihat
seperti ini:

```console
missing:~$
```

Ini adalah antarmuka tekstual utama ke shell. Ini memberi tahu Anda bahwa Anda
berada di mesin `missing` dan "direktori kerja saat ini" Anda, atau tempat Anda
berada sekarang, adalah `~` (singkatan dari "home"). Tanda `$` memberi tahu Anda
bahwa Anda bukan pengguna root (lebih lanjut tentang itu nanti). Di prompt ini
Anda bisa mengetik _perintah_, yang kemudian akan diinterpretasikan oleh shell.
Perintah paling dasar adalah menjalankan sebuah program:

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
argumen `hello`. Program `echo` cukup mencetak argumennya. Shell mengurai
perintah dengan memisahkannya berdasarkan spasi, lalu menjalankan program yang
ditunjukkan oleh kata pertama, menyediakan setiap kata berikutnya sebagai
argumen yang bisa diakses oleh program. Jika Anda ingin memberikan argumen yang
mengandung spasi atau karakter khusus lainnya (misalnya, direktori bernama
"My Photos"), Anda bisa mengutip argumen dengan `'` atau `"` (`"My Photos"`),
atau meng-escape hanya karakter yang relevan dengan `\` (`My\ Photos`).

Mungkin perintah paling penting ketika Anda baru memulai adalah `man`,
singkatan dari "manual". Program `man`, antara lain, memungkinkan Anda mencari
informasi lebih lanjut tentang perintah apa pun di sistem Anda. Misalnya, jika
Anda menjalankan `man date`, ini akan menjelaskan apa itu `date`, dan semua
berbagai argumen yang bisa Anda berikan untuk mengubah perilakunya. Anda juga
biasanya bisa mendapatkan versi singkat bantuan dengan memberikan `--help`
sebagai argumen ke sebagian besar perintah.

> Pertimbangkan untuk menginstal dan menggunakan [`tldr`](https://tldr.sh/)
> selain `man`, karena ini menampilkan contoh penggunaan umum langsung di
> terminal. LLM juga biasanya sangat baik dalam menjelaskan cara kerja perintah
> dan bagaimana Anda bisa menggunakannya untuk mencapai apa yang ingin Anda
> lakukan.

Setelah `man`, perintah paling penting untuk dipelajari adalah `cd`, atau "change
directory". Perintah ini sebenarnya sudah tertanam di dalam shell, dan bukan
program terpisah (yaitu, `which cd` akan menampilkan "no cd found"). Anda
memberikannya sebuah path, dan path tersebut menjadi direktori kerja saat ini
Anda. Anda juga akan melihat direktori kerja tercermin di prompt shell:

```console
missing:~$ cd /bin
missing:/bin$ cd /
missing:/$ cd ~
missing:~$
```

> Perhatikan bahwa shell dilengkapi dengan auto-completion, sehingga Anda sering
> bisa melengkapi path lebih cepat dengan menekan `<TAB>`!

Banyak perintah beroperasi pada direktori kerja saat ini jika tidak ada yang
dispesifikasikan. Jika Anda tidak yakin di mana Anda berada, Anda bisa
menjalankan `pwd` atau mencetak variabel lingkungan `$PWD` (dengan `echo $PWD`),
keduanya menghasilkan direktori kerja saat ini.

Direktori kerja saat ini juga berguna karena memungkinkan kita menggunakan path
_relatif_. Semua path yang telah kita lihat sejauh ini adalah _absolut_ ---
mereka dimulai dengan `/` dan memberikan seluruh kumpulan direktori yang
dibutuhkan untuk menavigasi ke suatu lokasi dari root sistem file (`/`). Dalam
praktiknya, Anda lebih sering bekerja dengan path relatif; disebut demikian
karena relatif terhadap direktori kerja saat ini. Dalam path relatif (apa pun
yang _tidak_ dimulai dengan `/`), komponen path pertama dicari di direktori
kerja saat ini, dan komponen berikutnya menelusuri seperti biasa. Misalnya:

```console
missing:~$ cd /
missing:/$ cd bin
missing:/bin$
```

Ada juga dua komponen "khusus" yang ada di setiap direktori: `.` dan `..`. `.`
adalah "direktori ini", dan `..` adalah "direktori induk". Jadi:

```console
missing:~$ cd /
missing:/$ cd bin/../bin/../bin/././../bin/..
missing:/$
```

Anda biasanya bisa menggunakan path absolut dan relatif secara bergantian untuk
argumen perintah apa pun, cukup ingat apa direktori kerja saat ini Anda saat
menggunakan path relatif!

> Pertimbangkan untuk menginstal dan menggunakan
> [`zoxide`](https://github.com/ajeetdsouza/zoxide) untuk mempercepat `cd`
> Anda --- `z` akan mengingat path yang sering Anda kunjungi dan memungkinkan
> Anda mengaksesnya dengan lebih sedikit pengetikan.

## Apa yang tersedia di shell?

Tapi bagaimana shell tahu cara menemukan program seperti `date` atau `echo`?
Jika shell diminta menjalankan perintah, ia melihat _variabel lingkungan_
bernama `$PATH` yang mencantumkan direktori mana yang harus dicari shell untuk
program ketika diberikan perintah:

```console
missing:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
missing:~$ which echo
/bin/echo
missing:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Ketika kita menjalankan perintah `echo`, shell melihat bahwa ia harus
menjalankan program `echo`, lalu mencari melalui daftar direktori yang dipisahkan
`:` di `$PATH` untuk file dengan nama tersebut. Ketika menemukannya, ia
menjalankannya (dengan asumsi file tersebut _dapat dieksekusi_; lebih lanjut
tentang itu nanti). Kita bisa mengetahui file mana yang dijalankan untuk nama
program tertentu menggunakan program `which`. Kita juga bisa melewati `$PATH`
sepenuhnya dengan memberikan _path_ ke file yang ingin kita eksekusi.

Ini juga memberikan petunjuk tentang bagaimana kita bisa menentukan _semua_
program yang bisa kita jalankan di shell: dengan mendaftar isi dari semua
direktori di `$PATH`. Kita bisa melakukan ini dengan memberikan path direktori
tertentu ke program `ls`, yang mendaftar file:

```console
missing:~$ ls /bin
```

> Pertimbangkan untuk menginstal dan menggunakan [`eza`](https://eza.rocks/)
> sebagai pengganti `ls` yang lebih ramah pengguna.

Ini akan, di sebagian besar komputer, mencetak _sangat banyak_ program, tetapi
kita hanya akan fokus pada beberapa yang paling penting di sini. Pertama,
beberapa yang sederhana:

- `cat file`, yang mencetak isi dari `file`.
- `sort file`, yang mencetak baris-baris `file` dalam urutan terurut.
- `uniq file`, yang menghilangkan baris duplikat yang berurutan dari `file`.
- `head file` dan `tail file`, yang masing-masing mencetak beberapa baris
  pertama dan terakhir dari `file`.

> Pertimbangkan untuk menginstal dan menggunakan
> [`bat`](https://github.com/sharkdp/bat) sebagai pengganti `cat` untuk
> syntax highlighting dan scrolling.

Ada juga `grep pattern file`, yang mencari baris yang cocok dengan `pattern`
di `file`. Yang satu ini patut mendapat perhatian lebih karena _sangat_ berguna
dan memiliki berbagai fitur yang lebih luas dari yang mungkin diharapkan.
`pattern` sebenarnya adalah _regular expression_ yang bisa mengekspresikan pola
yang sangat kompleks --- kita akan [membahasnya](/2026/code-quality/#regular-expressions)
di kuliah code quality. Anda juga bisa menentukan direktori sebagai ganti file
(atau membiarkannya kosong untuk `.`) dan memberikan `-r` untuk mencari secara
rekursif di semua file dalam direktori.

> Pertimbangkan untuk menginstal dan menggunakan
> [`ripgrep`](https://github.com/BurntSushi/ripgrep) sebagai pengganti `grep`
> untuk alternatif yang lebih cepat dan lebih ramah pengguna (tetapi kurang
> portabel). `ripgrep` juga akan mencari secara rekursif di direktori kerja
> saat ini secara default!

Ada juga beberapa alat yang sangat berguna dengan antarmuka yang sedikit lebih
kompleks. Yang pertama adalah `sed`, yang merupakan editor file terprogram. Ia
memiliki bahasa pemrograman sendiri untuk melakukan pengeditan otomatis pada
file, tetapi penggunaan yang paling umum adalah:

```console
missing:~$ sed -i 's/pattern/replacement/g' file
```

Ini mengganti semua kemunculan `pattern` dengan `replacement` di `file`.
`-i` menunjukkan bahwa kita ingin substitusi terjadi secara inline (bukan
membiarkan `file` tidak termodifikasi dan mencetak isi yang telah disubstitusi).
`s/` adalah cara mengekspresikan dalam bahasa pemrograman sed bahwa kita ingin
melakukan substitusi. `/` memisahkan pattern dari replacement. Dan `/g` di akhir
menunjukkan bahwa kita ingin mengganti _semua_ kemunculan di setiap baris, bukan
hanya yang pertama. Seperti `grep`, `pattern` di sini adalah regular expression,
yang memberi Anda kekuatan ekspresif yang signifikan. Substitusi regular
expression juga memungkinkan `replacement` merujuk kembali ke bagian-bagian dari
pola yang dicocokkan; kita akan melihat contohnya sebentar lagi.

Selanjutnya, kita punya `find`, yang memungkinkan Anda mencari file (secara
rekursif) yang cocok dengan kondisi tertentu. Misalnya:

```console
missing:~$ find ~/Downloads -type f -name "*.zip" -mtime +30
```

Mencari file ZIP di direktori unduhan yang lebih lama dari 30 hari.

```console
missing:~$ find ~ -type f -size +100M -exec ls -lh {} \;
```

Mencari file yang lebih besar dari 100M di direktori home Anda dan mendaftarkannya.
Perhatikan bahwa `-exec` menerima _perintah_ yang diakhiri dengan `;` yang berdiri
sendiri (yang perlu kita escape seperti spasi) di mana `{}` diganti dengan setiap
path file yang cocok oleh `find`.

```console
missing:~$ find . -name "*.py" -exec grep -l "TODO" {} \;
```

Mencari file `.py` apa pun yang memiliki item TODO di dalamnya.

Sintaks `find` bisa sedikit menakutkan, tetapi semoga ini memberi Anda gambaran
tentang betapa bergunanya alat ini!

> Pertimbangkan untuk menginstal dan menggunakan [`fd`](https://github.com/sharkdp/fd)
> sebagai pengganti `find` untuk pengalaman yang lebih ramah pengguna (tetapi
> kurang portabel!).

Selanjutnya adalah `awk`, yang, seperti `sed`, memiliki bahasa pemrograman
sendiri. Jika `sed` dibangun untuk mengedit file, `awk` dibangun untuk mengurai
file. Penggunaan `awk` yang paling umum adalah untuk file data dengan sintaks
reguler (seperti file CSV) di mana Anda hanya ingin mengekstrak bagian tertentu
dari setiap record (yaitu, baris):

```console
missing:~$ awk '{print $2}' file
```

Mencetak kolom kedua yang dipisahkan spasi dari setiap baris `file`. Jika Anda
menambahkan `-F,`, ini akan mencetak kolom kedua yang dipisahkan koma dari setiap
baris. `awk` bisa melakukan banyak hal --- memfilter baris, menghitung agregat,
dan lainnya --- lihat latihan untuk contohnya.

Dengan menggabungkan alat-alat ini, kita bisa melakukan hal-hal canggih seperti:

```console
missing:~$ ssh myserver 'journalctl -u sshd -b-1 | grep "Disconnected from"' \
  | sed -E 's/.*Disconnected from .* user (.*) [^ ]+ port.*/\1/' \
  | sort | uniq -c \
  | sort -nk1,1 | tail -n10 \
  | awk '{print $2}' | paste -sd,
postgres,mysql,oracle,dell,ubuntu,inspur,test,admin,user,root
```

Ini mengambil log SSH dari server remote (kita akan membahas lebih lanjut tentang
`ssh` di kuliah berikutnya), mencari pesan disconnect, mengekstrak nama pengguna
dari setiap pesan tersebut, dan mencetak 10 nama pengguna teratas yang dipisahkan
koma. Semua dalam satu perintah! Kita serahkan penguraian setiap langkah sebagai
latihan.

## Bahasa shell (bash)

Contoh sebelumnya memperkenalkan konsep baru: pipe (`|`). Ini memungkinkan Anda
menghubungkan output dari satu program dengan input program lainnya. Ini berfungsi
karena sebagian besar program baris perintah akan beroperasi pada "standard input"
mereka (tempat ketukan keyboard Anda biasanya masuk) jika tidak ada argumen `file`
yang diberikan. `|` mengambil "standard output" (yang biasanya dicetak ke terminal
Anda) dari program sebelum `|` dan menjadikannya standard input dari program setelah
`|`. Ini memungkinkan Anda _menggabungkan_ program shell, dan ini adalah bagian dari
apa yang membuat shell menjadi lingkungan yang sangat produktif untuk bekerja!

Faktanya, sebagian besar shell mengimplementasikan bahasa pemrograman lengkap
(sperti bash), seperti Python atau Ruby. Ia memiliki variabel, kondisional, loop,
dan fungsi. Ketika Anda menjalankan perintah di shell, Anda sebenarnya menulis
sedikit kode yang diinterpretasikan oleh shell Anda. Kami tidak akan mengajari
Anda semua tentang bash hari ini, tetapi ada beberapa bagian yang akan Anda
anggap sangat berguna:

Pertama, redirect: `>file` memungkinkan Anda mengambil standard output dari
sebuah program dan menulisnya ke `file` alih-alih ke terminal Anda. Ini
memudahkan analisis setelahnya. `>>file` akan menambahkan ke `file` alih-alih
menimpanya. Ada juga `<file` yang menyuruh shell untuk membaca dari `file`
alih-alih dari keyboard Anda sebagai standard input ke sebuah program.

> Ini saat yang tepat untuk menyebutkan program `tee`. `tee` akan mencetak
> standard input ke standard output (seperti `cat`!), tetapi _juga_ akan
> menulisnya ke file. Jadi `verbose cmd | tee verbose.log | grep CRITICAL`
> akan menyimpan log verbose lengkap ke file sambil menjaga terminal Anda tetap
> bersih!

Selanjutnya, kondisional: `if command1; then command2; command3; fi` akan
menjalankan `command1`, dan jika tidak menghasilkan error, akan menjalankan
`command2` dan `command3`. Anda juga bisa memiliki cabang `else` jika Anda
menginginkannya. Perintah yang paling umum digunakan sebagai `command1` adalah
perintah `test`, sering disingkat hanya sebagai `[`, yang memungkinkan Anda
mengevaluasi kondisi seperti "apakah file ada" (`test -f file` / `[ -f file ]`)
atau "apakah string sama dengan yang lain" (`[ "$var" = "string" ]`). Dalam
bash, ada juga `[[ ]]`, yang merupakan versi built-in `test` yang "lebih aman"
dan memiliki lebih sedikit perilaku aneh seputar quoting.

Bash juga memiliki dua bentuk loop, `while` dan `for`. `while command1; do
command2; command3; done` berfungsi persis seperti perintah `if` yang setara,
kecuali ia akan mengeksekusi semuanya berulang-ulang selama `command1` tidak
menghasilkan error. `for varname in a b c d; do command; done` menjalankan
`command` empat kali, setiap kali dengan `$varname` diatur ke salah satu dari
`a`, `b`, `c`, dan `d`. Alih-alih mendaftar item secara eksplisit, Anda sering
akan menggunakan "command substitution", seperti:

```bash
for i in $(seq 1 10); do
```

Ini menjalankan perintah `seq 1 10` (yang mencetak angka dari 1 sampai 10
inklusif) dan kemudian mengganti seluruh `$()` dengan output perintah tersebut,
memberikan Anda loop for 10 iterasi. Di kode lama Anda terkadang akan melihat
backtick literal (seperti ``for i in `seq 1 10`; do``) alih-alih `$()`, tetapi
Anda sebaiknya lebih memilih bentuk `$()` karena bisa di-nest.

Meskipun Anda _bisa_ menulis skrip shell panjang langsung di prompt Anda, Anda
biasanya akan ingin menulisnya ke file `.sh` sebagai gantinya. Misalnya, berikut
adalah skrip yang akan menjalankan program dalam loop sampai gagal, mencetak
output hanya dari run yang gagal, sambil membebani CPU di latar belakang
(berguna misalnya untuk mereproduksi tes yang tidak stabil):

```bash
#!/bin/bash
set -euo pipefail

# Start CPU stress in background
stress --cpu 8 &
STRESS_PID=$!

# Setup log file
LOGFILE="test_runs_$(date +%s).log"
echo "Logging to $LOGFILE"

# Run tests until one fails
RUN=1
while cargo test my_test > "$LOGFILE" 2>&1; do
    echo "Run $RUN passed"
    ((RUN++))
done

# Cleanup and report
kill $STRESS_PID
echo "Test failed on run $RUN"
echo "Last 20 lines of output:"
tail -n 20 "$LOGFILE"
echo "Full log: $LOGFILE"
```

Ini memiliki beberapa hal baru yang saya sarankan Anda luangkan waktu untuk
mempelajarinya, karena mereka sangat berguna dalam membuat pemanggilan shell
yang berguna seperti background job (`&`) untuk menjalankan program secara
bersamaan, [shell
redirection](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)
yang lebih rumit, dan [arithmetic
expansion](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html).

Perlu diperhatikan dua baris pertama program. Yang pertama adalah "shebang" --
Anda akan melihat ini di bagian atas file selain skrip shell juga. Ketika file
yang dimulai dengan mantra ajaib `#!/path` dieksekusi, shell akan memulai
program di `/path`, dan memberikan isi file sebagai input. Dalam kasus skrip
shell, ini berarti memberikan isi skrip shell ke `/bin/bash`, tetapi Anda juga
bisa menulis skrip Python dengan baris shebang `/usr/bin/python`!

Baris kedua adalah cara membuat bash "lebih ketat", dan mengurangi sejumlah
masalah umum saat menulis skrip shell. `set` bisa menerima banyak argumen,
tetapi secara singkat: `-e` membuatnya sehingga jika perintah mana pun gagal,
skrip keluar lebih awal; `-u` membuatnya sehingga penggunaan variabel yang tidak
terdefinisi membuat skrip crash alih-alih hanya menggunakan string kosong; dan
`-o pipefail` membuatnya sehingga jika program dalam urutan `|` gagal, skrip
shell secara keseluruhan juga keluar lebih awal.

> Pemrograman shell adalah topik yang dalam, seperti bahasa pemrograman apa pun,
> tetapi perlu diingat: bash memiliki jumlah gotcha yang tidak biasa, sampai-sampai
> ada [beberapa](https://tldp.org/LDP/abs/html/gotchas.html) situs web yang
> didedikasikan untuk [mendaftarkannya](https://mywiki.wooledge.org/BashPitfalls).
> Saya sangat menyarankan untuk banyak menggunakan
> [shellcheck](https://www.shellcheck.net/) saat menulisnya. LLM juga sangat
> bagus dalam menulis dan men-debug skrip shell, serta menerjemahkannya ke bahasa
> pemrograman "nyata" (seperti Python) ketika sudah terlalu rumit untuk bash
> (100+ baris).

# Langkah selanjutnya

Pada titik ini Anda sudah cukup mengenal shell untuk menyelesaikan tugas-tugas
dasar. Anda seharusnya bisa menavigasi untuk menemukan file yang menarik dan
menggunakan fungsionalitas dasar sebagian besar program. Di kuliah berikutnya,
kita akan membahas cara melakukan dan mengotomatisasi tugas yang lebih kompleks
menggunakan shell dan banyak program baris perintah yang berguna.

# Latihan

Semua kelas dalam kursus ini disertai serangkaian latihan. Beberapa memberi Anda
tugas spesifik untuk dilakukan, sementara yang lain bersifat terbuka, seperti
"coba gunakan program X dan Y". Kami sangat mendorong Anda untuk mencobanya.

Kami belum menulis solusi untuk latihan. Jika Anda terjebak pada sesuatu, jangan
ragu untuk posting di `#missing-semester-forum` di
[Discord](https://ossu.dev/#community) atau kirim email kepada kami yang
menjelaskan apa yang sudah Anda coba, dan kami akan mencoba membantu Anda.
Latihan ini juga kemungkinan besar akan berfungsi dengan baik sebagai prompt
awal dalam percakapan dengan LLM di mana Anda bisa secara interaktif mendalami
topiknya. Nilai nyata dari latihan ini adalah perjalanan menemukan jawaban,
bukan jawabannya itu sendiri. Kami mendorong Anda untuk mengikuti alur yang
berbeda dan bertanya "mengapa" saat Anda mengerjakannya, alih-alih hanya
mencari jalan terpendek ke solusi.

1. Untuk kursus ini, Anda perlu menggunakan shell Unix seperti Bash atau ZSH. Jika
   Anda berada di Linux atau macOS, Anda tidak perlu melakukan apa-apa. Jika Anda
   berada di Windows, Anda perlu memastikan Anda tidak menjalankan cmd.exe atau
   PowerShell; Anda bisa menggunakan [Windows Subsystem for
   Linux](https://docs.microsoft.com/en-us/windows/wsl/) atau mesin virtual Linux
   untuk menggunakan alat baris perintah bergaya Unix. Untuk memastikan Anda
   menjalankan shell yang sesuai, Anda bisa mencoba perintah `echo $SHELL`. Jika
   menampilkan sesuatu seperti `/bin/bash` atau `/usr/bin/zsh`, itu berarti Anda
   menjalankan program yang benar.

1. Apa yang dilakukan flag `-l` pada `ls`? Jalankan `ls -l /` dan periksa
   outputnya. Apa arti 10 karakter pertama dari setiap baris? (Petunjuk: `man ls`)

1. Dalam perintah `find ~/Downloads -type f -name "*.zip" -mtime +30`,
   `*.zip` adalah "glob". Apa itu glob? Buat direktori uji dengan beberapa file
   dan bereksperimenlah dengan pola seperti `ls *.txt`, `ls file?.txt`, dan
   `ls {a,b,c}.txt`. Lihat [Pattern
   Matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html)
   di manual Bash.

1. Apa perbedaan antara `'single quotes'`, `"double quotes"`, dan
   `$'ANSI quotes'`? Tulis perintah yang meng-echo string yang mengandung
   literal `$`, `!`, dan karakter newline. Lihat
   [Quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html).

1. Shell memiliki tiga stream standar: stdin (0), stdout (1), dan stderr
   (2). Jalankan `ls /nonexistent /tmp` dan redirect stdout ke satu file dan
   stderr ke file lainnya. Bagaimana Anda akan redirect keduanya ke file yang
   sama? Lihat
   [Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html).

1. `$?` menyimpan status exit dari perintah terakhir (0 = sukses). `&&` menjalankan
   perintah berikutnya hanya jika yang sebelumnya sukses; `||` menjalankannya hanya
   jika yang sebelumnya gagal. Tulis satu baris perintah yang membuat `/tmp/mydir`
   hanya jika belum ada. Lihat [Exit
   Status](https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html).

1. Mengapa `cd` harus tertanam di dalam shell itu sendiri alih-alih menjadi program
   terpisah? (Petunjuk: pikirkan apa yang bisa dan tidak bisa dipengaruhi oleh
   proses anak pada induknya.)

1. Tulis skrip yang menerima nama file sebagai argumen (`$1`) dan memeriksa
   apakah file tersebut ada menggunakan `test -f` atau `[ -f ... ]`. Skrip harus
   mencetak pesan berbeda tergantung pada apakah file tersebut ada. Lihat [Bash
   Conditional
   Expressions](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html).

1. Simpan skrip dari latihan sebelumnya ke file (misalnya, `check.sh`).
   Coba jalankan dengan `./check.sh somefile`. Apa yang terjadi? Sekarang jalankan
   `chmod +x check.sh` dan coba lagi. Mengapa langkah ini diperlukan? (Petunjuk:
   lihat `ls -l check.sh` sebelum dan sesudah `chmod`.)

1. Apa yang terjadi jika Anda menambahkan `-x` ke flag `set` dalam skrip? Cobalah
    dengan skrip sederhana dan amati outputnya. Lihat [The Set
    Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html).

1. Tulis perintah yang menyalin file ke cadangan dengan tanggal hari ini di nama
    file (misalnya, `notes.txt` → `notes_2026-01-12.txt`). (Petunjuk: `$(date
    +%Y-%m-%d)`). Lihat [Command
    Substitution](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html).

1. Modifikasi skrip tes tidak stabil dari kuliah untuk menerima perintah tes
    sebagai argumen alih-alih menggunakan `cargo test my_test` secara langsung.
    (Petunjuk: `$1` atau `$@`). Lihat [Special
    Parameters](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html).

1. Gunakan pipe untuk menemukan 5 ekstensi file paling umum di direktori home
    Anda. (Petunjuk: gabungkan `find`, `grep` atau `sed` atau `awk`, `sort`,
    `uniq -c`, dan `head`.)

1. `xargs` mengubah baris dari stdin menjadi argumen perintah. Gunakan `find` dan
    `xargs` bersama-sama (bukan `find -exec`) untuk mencari semua file `.sh` dalam
    direktori dan hitung baris di masing-masing dengan `wc -l`. Bonus: buat agar
    bisa menangani nama file dengan spasi. (Petunjuk: `-print0` dan `-0`). Lihat `man
    xargs`.

1. Gunakan `curl` untuk mengambil HTML dari situs web kursus
    (`https://missing.csail.mit.edu/`) dan pipe ke `grep` untuk menghitung berapa
    banyak kuliah yang terdaftar. (Petunjuk: cari pola yang muncul sekali per
    kuliah; gunakan `curl -s` untuk menghilangkan output progress.)

1. [`jq`](https://jqlang.github.io/jq/) adalah alat yang kuat untuk memproses
    data JSON. Ambil data contoh di
    `https://microsoftedge.github.io/Demos/json-dummy-data/64KB.json` dengan
    `curl` dan gunakan `jq` untuk mengekstrak hanya nama-nama orang yang
    versinya lebih besar dari 6. (Petunjuk: pipe ke `jq .` terlebih dahulu untuk
    melihat strukturnya; lalu coba `jq '.[] | select(...) | .name'`)

1. `awk` bisa memfilter baris berdasarkan nilai kolom dan memanipulasi output.
    Misalnya, `awk '$3 ~ /pattern/ {$4=""; print}'` mencetak hanya baris di mana
    kolom ketiga cocok dengan `pattern`, sambil menghilangkan kolom keempat. Tulis
    perintah `awk` yang mencetak hanya baris di mana kolom kedua lebih besar dari
    100, dan menukar kolom pertama dan ketiga. Uji dengan: `printf 'a 50 x\nb 150 y\nc 200 z\n'`

1. Bedah pipeline log SSH dari kuliah: apa yang dilakukan setiap langkah?
    Kemudian buat sesuatu yang serupa untuk menemukan perintah shell yang paling
    sering Anda gunakan dari `~/.bash_history` (atau `~/.zsh_history`).
