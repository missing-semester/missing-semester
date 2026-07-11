---
layout: lecture
title: "Gambaran Kursus + Pengantar Shell"
description: >
  Pelajari motivasi kelas ini, dan mulai gunakan shell.
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
menjadi mahasiswa. Anda dapat menghubungi kami di
[missing-semester@mit.edu](mailto:missing-semester@mit.edu).

Kami tidak dibayar untuk mengajar kelas ini, dan tidak
memperdagangkan kelas ini dengan cara apa pun. Kami menyediakan semua
[materi kursus](https://missing.csail.mit.edu/) dan [rekaman
kuliah](https://www.youtube.com/@MissingSemester) secara gratis
daring. Jika Anda ingin mendukung pekerjaan kami, cara terbaik adalah
dengan menyebarkan informasi tentang kelas ini. Jika Anda adalah perusahaan,
universitas, atau organisasi lain yang menjalankan konten ini untuk kelompok
yang lebih besar, silakan kirimkan laporan pengalaman/testimoni melalui email
agar kami dapat mengetahuinya :)

# Motivasi

Sebagai ilmuwan komputer, kita tahu bahwa komputer sangat hebat dalam
membantu tugas-tugas berulang. Namun, terlalu sering kita lupa bahwa hal ini
juga berlaku untuk _penggunaan_ komputer kita, bukan hanya perhitungan yang
ingin kita lakukan oleh program kita. Kita memiliki berbagai macam alat yang
siap di ujung jari yang memungkinkan kita lebih produktif dan menyelesaikan
masalah yang lebih kompleks saat mengerjakan masalah terkait komputer apa pun.
Namun banyak dari kita hanya menggunakan sebagian kecil dari alat-alat
tersebut; kita hanya tahu cukup banyak mantra ajaib secara hafalan untuk
bertahan, dan membabi-buta menyalin-tempel perintah dari internet saat kita
macet.

Kelas ini adalah upaya untuk [mengatasi hal ini](/about/).

Kami ingin mengajarkan Anda cara memaksimalkan alat yang Anda tahu,
memperkenalkan alat-alat baru untuk ditambahkan ke kotak peralatan Anda, dan
mudah-mudahan menanamkan semangat untuk menjelajahi (dan mungkin membangun)
lebih banyak alat sendiri. Inilah yang kami yakini sebagai semester yang
hilang dari sebagian besar kurikulum Ilmu Komputer.

# Struktur kelas

Kelas tanpa kredit ini terdiri dari sembilan kuliah 1 jam, masing-masing
berpusat pada [topik tertentu](/2026/). Kuliah-kuliah ini sebagian besar
independen, meskipun seiring berjalannya semester kami akan berasumsi bahwa
Anda sudah terbiasa dengan materi dari kuliah-kuliah sebelumnya. Kami
memiliki catatan kuliah daring, tetapi mungkin ada konten yang dibahas di
kelas (misalnya dalam bentuk demo) yang tidak ada dalam catatan. Seperti tahun-tahun
sebelumnya, kami akan merekam kuliah dan mengunggah rekamannya
[secara daring](https://www.youtube.com/@MissingSemester).

Kami berusaha mencakup banyak hal hanya dalam beberapa kuliah 1 jam, jadi
kuliah-kuliahnya cukup padat. Untuk memberi Anda waktu membiasakan diri
dengan materi sesuai kecepatan Anda sendiri, setiap kuliah mencakup
serangkaian latihan yang memandu Anda melalui poin-poin kunci kuliah. Kami
tidak menjalankan jam kantor khusus, tetapi kami mendorong Anda untuk
bertanya di [OSSU Discord](https://ossu.dev/#community),
di `#missing-semester-forum`, atau kirimkan email kepada kami di
[missing-semester@mit.edu](mailto:missing-semester@mit.edu).

Karena waktu yang terbatas, kami tidak akan dapat mencakup semua alat
dengan tingkat detail yang sama seperti kelas skala penuh. Jika memungkinkan,
kami akan mencoba mengarahkan Anda ke sumber daya untuk menggali lebih dalam
tentang alat atau topik tertentu, tetapi jika ada yang menarik perhatian Anda,
jangan ragu untuk menghubungi kami dan meminta petunjuk!

Terakhir, jika Anda memiliki umpan balik tentang kelas ini, silakan kirimkan
kepada kami melalui email di [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

# Topik 1: Shell

{% comment %}
lecturer: Jon
{% endcomment %}

## Apa itu shell?

Komputer saat ini memiliki berbagai antarmuka untuk memberikan perintah;
antarmuka grafis yang mewah, antarmuka suara, AR/VR, dan baru-baru ini: LLM.
Ini sangat bagus untuk 80% kasus penggunaan, tetapi sering kali mereka
secara mendasar terbatas dalam apa yang mereka izinkan untuk Anda lakukan —
Anda tidak dapat menekan tombol yang tidak ada atau memberikan perintah suara
yang belum diprogram. Untuk memanfaatkan sepenuhnya alat yang disediakan
komputer Anda, kita harus kembali ke cara lama dan beralih ke antarmuka
tekstual: Shell.

Hampir semua platform yang bisa Anda dapatkan memiliki shell dalam satu bentuk
atau lainnya, dan banyak dari mereka memiliki beberapa shell yang bisa Anda
pilih. Meskipun mereka mungkin berbeda dalam detail, pada intinya mereka semua
kurang lebih sama: mereka memungkinkan Anda menjalankan program, memberikan
input, dan memeriksa output mereka secara semi-terstruktur.

Untuk membuka _prompt_ shell (tempat Anda dapat mengetik perintah), Anda
terlebih dahulu membutuhkan _terminal_, yang merupakan antarmuka visual ke
shell. Perangkat Anda mungkin sudah terinstal satu, atau Anda dapat
menginstalnya dengan cukup mudah:

- **Linux:**
  Tekan `Ctrl + Alt + T` (berlaku di sebagian besar distribusi). Atau cari
  "Terminal" di menu aplikasi Anda.
- **Windows:**
  Tekan `Win + R`, ketik `cmd` atau `powershell`, dan tekan Enter.
  Alternatifnya, cari "Terminal" atau "Command Prompt" di menu Start.
- **macOS:**
  Tekan `Cmd + Space` untuk membuka Spotlight, ketik "Terminal", dan tekan Enter.
  Atau temukan di Applications → Utilities → Terminal.

Di Linux dan macOS, ini biasanya akan membuka Bourne Again SHell, atau
"bash" singkatnya. Ini adalah salah satu shell yang paling banyak digunakan, dan
sintaksisnya mirip dengan apa yang akan Anda lihat di banyak shell lainnya. Di
Windows, Anda akan disambut oleh shell "batch" atau "powershell", tergantung
pada perintah mana yang Anda jalankan. Ini khusus untuk Windows, dan bukan yang
akan kami fokuskan di kelas ini, meskipun mereka memiliki analog untuk
sebagian besar yang akan kami ajarkan. Anda sebaiknya menggunakan [Windows
Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/) atau
mesin virtual Linux.

Shell lain juga ada, sering kali dengan banyak peningkatan ergonomis
dibandingkan bash (fish dan zsh adalah yang paling umum). Meskipun ini sangat
populer (semua instruktur menggunakannya), mereka tidak tersebar luas seperti
bash, dan bergantung pada banyak konsep yang sama, jadi kami tidak akan
memfokuskan pada mereka dalam kuliah ini.

## Mengapa Anda harus peduli?

Shell bukan hanya (biasanya) jauh lebih cepat daripada "mengklik-klik",
tetapi juga dilengkapi dengan kekuatan ekspresif yang tidak dapat Anda temukan
dengan mudah di satu program grafis. Seperti yang akan kita lihat, shell
memberi Anda kemampuan untuk _menggabungkan_ program secara kreatif untuk
mengotomatiskan hampir semua tugas.

Mengetahui cara menggunakan shell juga sangat berguna untuk menavigasi
dunia perangkat lunak sumber terbuka (yang sering kali dilengkapi dengan
petunjuk instalasi yang membutuhkan shell), membangun integrasi berkelanjutan
untuk proyek perangkat lunak Anda (seperti dijelaskan dalam [kuliah Code
Quality](/2026/code-quality/)), dan men-debug kesalahan saat program lain
gagal.

## Navigasi di shell

Saat Anda membuka terminal, Anda akan melihat _prompt_ yang sering terlihat
seperti ini:

```console
missing:~$
```

Ini adalah antarmuka tekstual utama ke shell. Ini memberi tahu Anda bahwa
Anda berada di mesin `missing` dan bahwa "direktori kerja Anda saat ini",
atau tempat Anda berada saat ini, adalah `~` (singkatan dari "home"). `$`
memberi tahu Anda bahwa Anda bukan pengguna root (lebih lanjut tentang itu
nanti). Pada prompt ini Anda dapat mengetik _perintah_, yang kemudian akan
diterjemahkan oleh shell. Perintah paling dasar adalah menjalankan program:

```console
missing:~$ date
Fri 10 Jan 2020 11:49:31 AM EST
missing:~$
```

Di sini, kita menjalankan program `date`, yang (mungkin tidak mengejutkan)
mencetak tanggal dan waktu saat ini. Shell kemudian meminta kita perintah lain
untuk dijalankan. Kita juga dapat menjalankan perintah dengan _argumen_:

```console
missing:~$ echo hello
hello
```

Dalam kasus ini, kita memberi tahu shell untuk menjalankan program `echo`
dengan argumen `hello`. Program `echo` cukup mencetak argumennya. Shell
mengurai perintah dengan memisahnya berdasarkan spasi, dan kemudian menjalankan
program yang ditunjukkan oleh kata pertama, menyediakan setiap kata berikutnya
sebagai argumen yang dapat diakses oleh program. Jika Anda ingin memberikan
argumen yang mengandung spasi atau karakter khusus lainnya (misalnya, direktori
bernama "My Photos"), Anda dapat mengutip argumen dengan `'` atau `"` (`"My
Photos"`), atau melepaskan karakter yang relevan dengan `\` (`My\ Photos`).

Mungkin perintah paling penting saat Anda baru memulai adalah `man`,
singkatan dari "manual". Program `man`, antara lain, memungkinkan Anda mencari
informasi lebih lanjut tentang perintah apa pun di sistem Anda. Misalnya, jika
Anda menjalankan `man date`, ini akan menjelaskan apa itu `date`, dan semua
berbagai argumen yang dapat Anda berikan untuk mengubah perilakunya. Anda juga
biasanya bisa mendapatkan versi singkat bantuan dengan memberikan `--help`
sebagai argumen ke sebagian besar perintah.

> Pertimbangkan untuk menginstal dan menggunakan [`tldr`](https://tldr.sh/)
> selain `man`, karena ini menunjukkan contoh penggunaan umum langsung di
> terminal. LLM juga biasanya sangat baik dalam menjelaskan cara kerja perintah
> dan bagaimana Anda dapat memanggilnya untuk mencapai apa yang ingin Anda
> lakukan.

Setelah `man`, perintah paling penting untuk dipelajari adalah `cd`, atau
"change directory". Perintah ini sebenarnya dibangun ke dalam shell, dan bukan
program terpisah (yaitu, `which cd` akan mengatakan "no cd found"). Anda
memberikannya jalur, dan jalur itu menjadi direktori kerja Anda saat ini. Anda
juga akan melihat direktori kerja tercermin di prompt shell:

```console
missing:~$ cd /bin
missing:/bin$ cd /
missing:/$ cd ~
missing:~$
```

> Perhatikan bahwa shell dilengkapi dengan pelengkapan otomatis, jadi Anda
> sering dapat melengkapi jalur lebih cepat dengan menekan `<TAB>`!

Banyak perintah beroperasi pada direktori kerja saat ini jika tidak ada
yang ditentukan. Jika Anda tidak yakin di mana Anda berada, Anda dapat
menjalankan `pwd` atau mencetak variabel lingkungan `$PWD` (dengan `echo
$PWD`), keduanya menghasilkan direktori kerja saat ini.

Direktori kerja saat ini juga berguna karena memungkinkan kita menggunakan
jalur _relatif_. Semua jalur yang telah kita lihat sejauh ini adalah
_absolut_ --- mereka dimulai dengan `/` dan memberikan kumpulan direktori
lengkap yang diperlukan untuk menavigasi ke suatu lokasi dari root sistem file
(`/`). Dalam praktiknya, Anda akan lebih sering bekerja dengan jalur relatif;
disebut demikian karena relatif terhadap direktori kerja saat ini. Dalam jalur
relatif (apa pun yang _tidak_ dimulai dengan `/`), komponen jalur pertama
dicari di direktori kerja saat ini, dan komponen berikutnya melintasi seperti
biasa. Misalnya:

```console
missing:~$ cd /
missing:/$ cd bin
missing:/bin$
```

Ada juga dua komponen "khusus" yang ada di setiap direktori: `.` dan `..`.
`.` adalah "direktori ini", dan `..` adalah "direktori induk". Jadi:

```console
missing:~$ cd /
missing:/$ cd bin/../bin/../bin/././../bin/..
missing:/$
```

Anda biasanya dapat menggunakan jalur absolut dan relatif secara bergantian
untuk argumen perintah apa pun, ingat saja apa direktori kerja Anda saat ini
saat menggunakan jalur relatif!

> Pertimbangkan untuk menginstal dan menggunakan
> [`zoxide`](https://github.com/ajeetdsouza/zoxide) untuk mempercepat `cd`
> Anda --- `z` akan mengingat jalur yang sering Anda kunjungi dan membiarkan
> Anda mengaksesnya dengan lebih sedikit pengetikan.

## Apa yang tersedia di shell?

Tetapi bagaimana shell tahu cara menemukan program seperti `date` atau
`echo`? Jika shell diminta untuk menjalankan perintah, ia berkonsultasi dengan
_variabel lingkungan_ yang disebut `$PATH` yang mencantumkan direktori mana
yang harus dicari shell untuk program saat diberikan perintah:

```console
missing:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
missing:~$ which echo
/bin/echo
missing:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Saat kita menjalankan perintah `echo`, shell melihat bahwa ia harus
menjalankan program `echo`, dan kemudian mencari melalui daftar direktori yang
dipisahkan oleh `:` di `$PATH` untuk file dengan nama tersebut. Ketika
menemukannya, ia menjalankannya (dengan asumsi file tersebut _dapat
dieksekusi_; lebih lanjut tentang itu nanti). Kita dapat mengetahui file mana
yang dijalankan untuk nama program tertentu menggunakan program `which`. Kita
juga dapat mengabaikan `$PATH` sepenuhnya dengan memberikan _jalur_ ke file
yang ingin kita eksekusi.

Ini juga memberikan petunjuk tentang bagaimana kita dapat menentukan _semua_
program yang dapat kita jalankan di shell: dengan mendaftar isi semua
direktori di `$PATH`. Kita dapat melakukan ini dengan memberikan jalur
direktori tertentu ke program `ls`, yang mendaftarkan file:

```console
missing:~$ ls /bin
```

> Pertimbangkan untuk menginstal dan menggunakan [`eza`](https://eza.rocks/)
> untuk `ls` yang lebih ramah manusia.

Ini akan, di sebagian besar komputer, mencetak _banyak_ program, tetapi kita
hanya akan fokus pada beberapa yang paling penting di sini. Pertama, beberapa
yang sederhana:

- `cat file`, yang mencetak isi `file`.
- `sort file`, yang mencetak baris-baris `file` dalam urutan yang diurutkan.
- `uniq file`, yang menghilangkan baris duplikat yang berurutan dari `file`.
- `head file` dan `tail file`, yang masing-masing mencetak beberapa baris
  pertama dan terakhir dari `file`.

> Pertimbangkan untuk menginstal dan menggunakan
> [`bat`](https://github.com/sharkdp/bat) daripada `cat` untuk penyorotan
> sintaksis dan pengguliran.

Ada juga `grep pattern file`, yang menemukan baris yang cocok dengan
`pattern` di `file`. Yang satu ini patut mendapat perhatian lebih karena
sangat _berguna_ dan memiliki rangkaian fitur yang lebih luas dari yang
diharapkan. `pattern` sebenarnya adalah _ekspresi reguler_ yang dapat
menyatakan pola yang sangat kompleks --- kita akan [membahasnya](/2026/code-quality/#regular-expressions)
dalam kuliah code quality. Anda juga dapat menentukan direktori alih-alih file
(atau membiarkannya untuk `.`) dan memberikan `-r` untuk mencari secara rekursif
semua file di direktori.

> Pertimbangkan untuk menginstal dan menggunakan
> [`ripgrep`](https://github.com/BurntSushi/ripgrep) daripada `grep` untuk
> alternatif yang lebih cepat dan lebih ramah manusia (tetapi kurang portabel).
> `ripgrep` juga akan mencari secara rekursif di direktori kerja saat ini
> secara default!

Ada juga beberapa alat yang sangat berguna dengan antarmuka yang sedikit
lebih rumit. Yang pertama di antaranya adalah `sed`, yang merupakan editor
file terprogram. Ia memiliki bahasa pemrograman sendiri untuk membuat edit
otomatis ke file, tetapi penggunaan yang paling umum adalah:

```console
missing:~$ sed -i 's/pattern/replacement/g' file
```

Ini menggantikan semua instance `pattern` dengan `replacement` di `file`.
`-i` menunjukkan bahwa kita ingin substitusi terjadi secara inline (sebaliknya
dari membiarkan `file` tidak dimodifikasi dan mencetak isi yang telah
disubstitusi). `s/` adalah cara untuk menyatakan dalam bahasa pemrograman sed
bahwa kita ingin melakukan substitusi. `/` memisahkan pola dari pengganti. Dan
`/g` di akhir menunjukkan bahwa kita ingin menggantikan _semua_ kemunculan
pada setiap baris, bukan hanya yang pertama. Seperti `grep`, `pattern` di sini
adalah ekspresi reguler, yang memberi Anda kekuatan ekspresif yang signifikan.
Substitusi ekspresi reguler juga mengizinkan `replacement` untuk merujuk
kembali ke bagian dari pola yang cocok; kita akan melihat contohnya sebentar
lagi.

Selanjutnya, kita memiliki `find`, yang memungkinkan Anda mencari file
(secara rekursif) yang memenuhi kondisi tertentu. Misalnya:

```console
missing:~$ find ~/Downloads -type f -name "*.zip" -mtime +30
```

Mencari file ZIP di direktori unduhan yang lebih tua dari 30 hari.

```console
missing:~$ find ~ -type f -size +100M -exec ls -lh {} \;
```

Mencari file yang lebih besar dari 100M di direktori home Anda dan
mendaftarkannya. Perhatikan bahwa `-exec` mengambil _perintah_ yang diakhiri
dengan `;` yang berdiri sendiri (yang perlu kita lepaskan seperti spasi) di
mana `{}` diganti dengan setiap jalur file yang cocok oleh `find`.

```console
missing:~$ find . -name "*.py" -exec grep -l "TODO" {} \;
```

Mencari file `.py` apa pun yang memiliki item TODO di dalamnya.

Sintaksis `find` bisa sedikit menakutkan, tetapi semoga ini memberi Anda
gambaran tentang betapa bergunanya alat ini!

> Pertimbangkan untuk menginstal dan menggunakan [`fd`](https://github.com/sharkdp/fd)
> daripada `find` untuk pengalaman yang lebih ramah manusia (tetapi kurang
> portabel!).

Selanjutnya adalah `awk`, yang, seperti `sed`, memiliki bahasa pemrograman
sendiri. Jika `sed` dibangun untuk mengedit file, `awk` dibangun untuk
menguraikannya. Penggunaan `awk` yang paling umum adalah untuk file data
dengan sintaksis reguler (seperti file CSV) di mana Anda hanya ingin
mengekstrak bagian tertentu dari setiap catatan (yaitu, baris):

```console
missing:~$ awk '{print $2}' file
```

Mencetak kolom kedua yang dipisahkan spasi dari setiap baris `file`. Jika
Anda menambahkan `-F,`, ini akan mencetak kolom kedua yang dipisahkan koma
dari setiap baris. `awk` dapat melakukan lebih banyak --- memfilter baris,
menghitung agregat, dan lainnya --- lihat latihan untuk rasanya.

Menggabungkan alat-alat ini, kita dapat melakukan hal-hal mewah seperti:

```console
missing:~$ ssh myserver 'journalctl -u sshd -b-1 | grep "Disconnected from"' \
  | sed -E 's/.*Disconnected from .* user (.*) [^ ]+ port.*/\1/' \
  | sort | uniq -c \
  | sort -nk1,1 | tail -n10 \
  | awk '{print $2}' | paste -sd,
postgres,mysql,oracle,dell,ubuntu,inspur,test,admin,user,root
```

Ini mengambil log SSH dari server jarak jauh (kita akan membahas lebih
lanjut tentang `ssh` di kuliah berikutnya), mencari pesan pemutusan, mengekstrak
nama pengguna dari setiap pesan tersebut, dan mencetak 10 nama pengguna
teratas yang dipisahkan koma. Semua dalam satu perintah! Kita akan meninggalkan
pembedahan setiap langkah sebagai latihan.

## Bahasa shell (bash)

Contoh sebelumnya memperkenalkan konsep baru: pipe (`|`). Ini memungkinkan
Anda merangkai output satu program dengan input program lain. Ini berfungsi
karena sebagian besar program baris perintah akan beroperasi pada "standard
input" mereka (tempat ketukan tombol Anda biasanya pergi) jika tidak ada
argumen `file` yang diberikan. `|` mengambil "standard output" (yang biasanya
dicetak ke terminal Anda) dari program sebelum `|` dan menjadikannya input
standar dari program setelah `|`. Ini memungkinkan Anda untuk
_mengkomposisikan_ program shell, dan ini adalah bagian dari apa yang membuat
shell menjadi lingkungan yang produktif untuk bekerja!

Faktanya, sebagian besar shell mengimplementasikan bahasa pemrograman
lengkap (seperti bash), seperti Python atau Ruby. Ia memiliki variabel,
kondisional, loop, dan fungsi. Saat Anda menjalankan perintah di shell Anda,
Anda sebenarnya menulis sedikit kode yang diterjemahkan oleh shell Anda. Kami
tidak akan mengajarkan semua bash hari ini, tetapi ada beberapa bagian yang
akan Anda temukan sangat berguna:

Pertama, redirect: `>file` memungkinkan Anda mengambil output standar
program dan menulisnya ke `file` alih-alih ke terminal Anda. Ini memudahkan
untuk dianalisis setelahnya. `>>file` akan menambahkan ke `file` alih-alih
menimpanya. Ada juga `<file` yang memberi tahu shell untuk membaca dari `file`
alih-alih dari keyboard Anda sebagai input standar ke program.

> Ini adalah waktu yang baik untuk menyebutkan program `tee`. `tee` akan
> mencetak input standar ke output standar (seperti `cat`!), tetapi juga akan
> menulisnya ke file. Jadi `verbose cmd | tee verbose.log | grep CRITICAL`
> akan menyimpan log verbose lengkap ke file sambil menjaga terminal Anda
> tetap bersih!

Selanjutnya, kondisional: `if command1; then command2; command3; fi` akan
menjalankan `command1`, dan jika tidak menghasilkan kesalahan, akan menjalankan
`command2` dan `command3`. Anda juga dapat memiliki cabang `else` jika Anda
inginkan. Perintah yang paling umum untuk digunakan sebagai `command1` adalah
perintah `test`, sering disingkat hanya sebagai `[`, yang memungkinkan Anda
mengevaluasi kondisi seperti "apakah file ada" (`test -f file` / `[ -f file ]`)
atau "apakah string sama dengan yang lain" (`[ "$var" = "string" ]`). Dalam
bash, ada juga `[[ ]]`, yang merupakan versi built-in `test` yang "lebih aman"
yang memiliki lebih sedikit perilaku aneh di sekitar pengutipan.

Bash juga memiliki dua bentuk loop, `while` dan `for`. `while command1; do
command2; command3; done` berfungsi persis seperti perintah `if` yang setara,
kecuali bahwa ia akan menjalankan ulang semuanya berulang-ulang selama
`command1` tidak error. `for varname in a b c d; do command; done` menjalankan
`command` empat kali, setiap kali dengan `$varname` diatur ke salah satu dari
`a`, `b`, `c`, dan `d`. Alih-alih mendaftar item secara eksplisit, Anda akan
sering menggunakan "command substitution", seperti:

```bash
for i in $(seq 1 10); do
```

Ini menjalankan perintah `seq 1 10` (yang mencetak angka dari 1 hingga 10
inklusif) dan kemudian mengganti seluruh `$()` dengan output perintah tersebut,
memberi Anda loop for 10 iterasi. Dalam kode lama Anda terkadang akan melihat
backtick literal (seperti ``for i in `seq 1 10`; do``) alih-alih `$()`, tetapi
Anda sebaiknya lebih memilih bentuk `$()` karena dapat disarangkan.

Meskipun Anda _bisa_ menulis skrip shell panjang langsung di prompt Anda,
Anda biasanya akan ingin menulisnya ke file `.sh` sebagai gantinya. Misalnya,
berikut adalah skrip yang akan menjalankan program dalam loop sampai gagal,
mencetak hanya output dari jalanan yang gagal, sambil membebani CPU Anda di
latar belakang (berguna untuk mereproduksi tes yang tidak stabil misalnya):

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

Ini memiliki sejumlah hal baru yang saya sarankan Anda luangkan waktu untuk
mendalaminya, karena mereka sangat berguna dalam menyusun pemanggilan shell
yang berguna seperti pekerjaan latar belakang (`&`) untuk menjalankan program
secara bersamaan, [pengalihan
shell](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)
yang lebih rumit, dan [ekspansi
aritmatika](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html).

Perlu menghabiskan sebentar pada dua baris pertama program. Yang pertama
adalah "shebang" --- Anda akan melihat ini di bagian atas file selain skrip
shell. Ketika file yang dimulai dengan mantra ajaib `#!/path` dijalankan,
shell akan memulai program di `/path`, dan memberikan isi file sebagai input.
Dalam kasus skrip shell, ini berarti memberikan isi skrip shell ke `/bin/bash`,
tetapi Anda juga dapat menulis skrip Python dengan baris shebang
`/usr/bin/python`!

Baris kedua adalah cara untuk membuat bash "lebih ketat", dan mengurangi
sejumlah jebakan saat menulis skrip shell. `set` dapat mengambil banyak
argumen, tetapi secara singkat: `-e` membuatnya sehingga jika perintah apa
pun gagal, skrip keluar lebih awal; `-u` membuatnya sehingga penggunaan
variabel yang tidak terdefinisi membuat skrip crash alih-alih hanya menggunakan
string kosong; dan `-o pipefail` membuatnya sehingga jika program dalam urutan
`|` gagal, skrip shell secara keseluruhan juga keluar lebih awal.

> Pemrograman shell adalah topik yang mendalam, seperti bahasa pemrograman
> apa pun, tetapi perlu diingat: bash memiliki jumlah jebakan yang tidak biasa,
> sampai-sampai ada [beberapa](https://tldp.org/LDP/abs/html/gotchas.html) situs
> web yang didedikasikan untuk [mendaftarkannya](https://mywiki.wooledge.org/BashPitfalls).
> Saya sangat merekomendasikan untuk banyak menggunakan
> [shellcheck](https://www.shellcheck.net/) saat menulisnya. LLM juga bagus
> dalam menulis dan men-debug skrip shell, serta menerjemahkannya ke bahasa
> pemrograman "nyata" (seperti Python) ketika mereka telah tumbuh terlalu rumit
> untuk bash (100+ baris).

# Langkah selanjutnya

Pada titik ini Anda sudah cukup tahu cara menggunakan shell untuk
menyelesaikan tugas-tugas dasar. Anda seharusnya dapat menavigasi untuk
menemukan file yang menarik dan menggunakan fungsionalitas dasar sebagian
besar program. Di kuliah berikutnya, kita akan membahas cara melakukan dan
mengotomatiskan tugas yang lebih kompleks menggunakan shell dan banyak program
baris perintah yang berguna di luar sana.

# Latihan

Semua kelas dalam kursus ini disertai dengan serangkaian latihan. Beberapa
memberi Anda tugas tertentu untuk dilakukan, sementara yang lain terbuka,
seperti "coba gunakan program X dan Y". Kami sangat mendorong Anda untuk
mencobanya.

Kami belum menulis solusi untuk latihan. Jika Anda macet pada sesuatu,
jangan ragu untuk posting di `#missing-semester-forum` di
[Discord](https://ossu.dev/#community) atau kirimkan email kepada kami yang
menjelaskan apa yang telah Anda coba sejauh ini, dan kami akan mencoba membantu
Anda. Latihan ini juga mungkin bekerja dengan baik sebagai prompt awal dalam
percakapan dengan LLM di mana Anda dapat secara interaktif mendalami topik.
Nilai nyata dari latihan ini adalah perjalanan menemukan jawaban, bukan
jawabannya itu sendiri. Kami mendorong Anda untuk mengikuti cabang dan bertanya
"mengapa" saat Anda mengerjakannya, daripada hanya mencari jalur terpendek ke
solusi.

1. Untuk kursus ini, Anda perlu menggunakan shell Unix seperti Bash atau ZSH. Jika
   Anda di Linux atau macOS, Anda tidak perlu melakukan apa-apa yang istimewa. Jika
   Anda di Windows, Anda perlu memastikan Anda tidak menjalankan cmd.exe atau
   PowerShell; Anda dapat menggunakan [Windows Subsystem for
   Linux](https://docs.microsoft.com/en-us/windows/wsl/) atau mesin virtual Linux
   untuk menggunakan alat baris perintah gaya Unix. Untuk memastikan Anda menjalankan
   shell yang sesuai, Anda dapat mencoba perintah `echo $SHELL`. Jika ini mengatakan
   sesuatu seperti `/bin/bash` atau `/usr/bin/zsh`, itu berarti Anda menjalankan
   program yang benar.

1. Apa yang dilakukan flag `-l` pada `ls`? Jalankan `ls -l /` dan periksa outputnya.
   Apa arti 10 karakter pertama dari setiap baris? (Petunjuk: `man ls`)

1. Dalam perintah `find ~/Downloads -type f -name "*.zip" -mtime +30`, `*.zip`
   adalah "glob". Apa itu glob? Buat direktori uji dengan beberapa file dan
   bereksperimenlah dengan pola seperti `ls *.txt`, `ls file?.txt`, dan `ls
   {a,b,c}.txt`. Lihat [Pattern
   Matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html)
   di manual Bash.

1. Apa perbedaan antara `'single quotes'`, `"double quotes"`, dan `$'ANSI
   quotes'`? Tulis perintah yang meng-echo string yang mengandung `$` literal,
   `!`, dan karakter newline. Lihat
   [Quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html).

1. Shell memiliki tiga stream standar: stdin (0), stdout (1), dan stderr (2).
   Jalankan `ls /nonexistent /tmp` dan arahkan stdout ke satu file dan stderr ke
   file lain. Bagaimana Anda akan mengarahkan keduanya ke file yang sama? Lihat
   [Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html).

1. `$?` menyimpan status keluar dari perintah terakhir (0 = sukses). `&&`
   menjalankan perintah berikutnya hanya jika yang sebelumnya berhasil; `||`
   menjalankannya hanya jika yang sebelumnya gagal. Tulis satu baris yang membuat
   `/tmp/mydir` hanya jika belum ada. Lihat [Exit
   Status](https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html).

1. Mengapa `cd` harus dibangun ke dalam shell itu sendiri daripada program
   mandiri? (Petunjuk: pikirkan tentang apa yang dapat dan tidak dapat dipengaruhi
   oleh proses anak di induknya.)

1. Tulis skrip yang mengambil nama file sebagai argumen (`$1`) dan memeriksa
   apakah file ada menggunakan `test -f` atau `[ -f ... ]`. Ini harus mencetak
   pesan yang berbeda tergantung pada apakah file ada. Lihat [Bash Conditional
   Expressions](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html).

1. Simpan skrip dari latihan sebelumnya ke file (misalnya, `check.sh`). Coba
   jalankan dengan `./check.sh somefile`. Apa yang terjadi? Sekarang jalankan
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
    sebagai argumen alih-alih meng-hardcode `cargo test my_test`. (Petunjuk: `$1`
    atau `$@`). Lihat [Special
    Parameters](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html).

1. Gunakan pipe untuk menemukan 5 ekstensi file paling umum di direktori home
    Anda. (Petunjuk: gabungkan `find`, `grep` atau `sed` atau `awk`, `sort`, `uniq
    -c`, dan `head`.)

1. `xargs` mengubah baris dari stdin menjadi argumen perintah. Gunakan `find` dan
    `xargs` bersama-sama (bukan `find -exec`) untuk menemukan semua file `.sh` di
    direktori dan hitung baris di masing-masing dengan `wc -l`. Bonus: buat ini
    menangani nama file dengan spasi. (Petunjuk: `-print0` dan `-0`). Lihat `man
    xargs`.

1. Gunakan `curl` untuk mengambil HTML dari situs web kursus
    (`https://missing.csail.mit.edu/`) dan arahkan ke `grep` untuk menghitung
    berapa banyak kuliah yang terdaftar. (Petunjuk: cari pola yang muncul sekali
    per kuliah; gunakan `curl -s` untuk membisukan output kemajuan.)

1. [`jq`](https://jqlang.github.io/jq/) adalah alat yang kuat untuk memproses
    data JSON. Ambil data sampel di
    `https://microsoftedge.github.io/Demos/json-dummy-data/64KB.json` dengan `curl`
    dan gunakan `jq` untuk mengekstrak hanya nama orang yang versinya lebih besar
    dari 6. (Petunjuk: arahkan ke `jq .` terlebih dahulu untuk melihat strukturnya;
    lalu coba `jq '.[] | select(...) | .name'`)

1. `awk` dapat memfilter baris berdasarkan nilai kolom dan memanipulasi output.
    Misalnya, `awk '$3 ~ /pattern/ {$4=""; print}'` hanya mencetak baris di mana
    kolom ketiga cocok dengan `pattern`, sambil menghilangkan kolom keempat. Tulis
    perintah `awk` yang hanya mencetak baris di mana kolom kedua lebih besar dari
    100, dan menukar kolom pertama dan ketiga. Uji dengan: `printf 'a 50 x\nb 150
    y\nc 200 z\n'`

1. Bedah pipeline log SSH dari kuliah: apa yang dilakukan setiap langkah? Kemudian
    bangun sesuatu yang mirip untuk menemukan perintah shell yang paling sering Anda
    gunakan dari `~/.bash_history` (atau `~/.zsh_history`).
