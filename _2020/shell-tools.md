---
layout: lecture
title: "Alat dan Scripting Shell"
description: >
  Pelajari cara menulis skrip shell dan menggunakan alat baris perintah yang powerful.
thumbnail: /static/assets/thumbnails/2020/lec2.png
date: 2020-01-14
ready: true
video:
  aspect: 56.25
  id: kgII-YWo3Zw
---

Pada kuliah ini, kami akan menyajikan beberapa dasar penggunaan bash sebagai bahasa scripting beserta sejumlah alat shell yang mencakup beberapa tugas paling umum yang akan terus-menerus Anda lakukan di baris perintah.

# Shell Scripting

Sejauh ini kita telah melihat cara menjalankan perintah di shell dan menggabungkannya dengan pipe.
Namun, dalam banyak skenario Anda ingin melakukan serangkaian perintah dan menggunakan ekspresi control flow seperti kondisional atau perulangan.

Shell script adalah langkah berikutnya dalam hal kompleksitas.
Sebagian besar shell memiliki bahasa scripting sendiri dengan variabel, control flow, dan sintaksisnya sendiri.
Yang membedakan shell scripting dari bahasa scripting lainnya adalah bahwa ia dioptimalkan untuk melakukan tugas-tugas terkait shell.
Dengan demikian, membuat pipeline perintah, menyimpan hasil ke dalam file, dan membaca dari standard input adalah primitif dalam shell scripting, sehingga lebih mudah digunakan dibandingkan bahasa scripting umum.
Untuk bagian ini kita akan fokus pada bash scripting karena merupakan yang paling umum.

Untuk menetapkan variabel dalam bash, gunakan sintaks `foo=bar` dan akses nilai variabel dengan `$foo`.
Perhatikan bahwa `foo = bar` tidak akan berhasil karena diinterpretasikan sebagai pemanggilan program `foo` dengan argumen `=` dan `bar`.
Secara umum, dalam shell script karakter spasi akan melakukan pemisahan argumen. Perilaku ini bisa membingungkan pada awalnya, jadi selalu periksa hal tersebut.

String dalam bash dapat didefinisikan dengan delimiter `'` dan `"`, tetapi keduanya tidak ekuivalen.
String yang dibatasi dengan `'` adalah string literal dan tidak akan mensubstitusi nilai variabel, sedangkan string yang dibatasi dengan `"` akan mensubstitusi nilai variabel.

```bash
foo=bar
echo "$foo"
# prints bar
echo '$foo'
# prints $foo
```

Seperti kebanyakan bahasa pemrograman, bash mendukung teknik control flow termasuk `if`, `case`, `while`, dan `for`.
Demikian pula, `bash` memiliki fungsi yang menerima argumen dan dapat beroperasi dengannya. Berikut adalah contoh fungsi yang membuat direktori dan melakukan `cd` ke dalamnya.


```bash
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```

Di sini `$1` adalah argumen pertama untuk skrip/fungsi.
Berbeda dengan bahasa scripting lainnya, bash menggunakan berbagai variabel khusus untuk merujuk pada argumen, kode error, dan variabel relevan lainnya. Berikut adalah daftar beberapa di antaranya. Daftar yang lebih lengkap dapat ditemukan [di sini](https://tldp.org/LDP/abs/html/special-chars.html).
- `$0` - Nama skrip
- `$1` hingga `$9` - Argumen untuk skrip. `$1` adalah argumen pertama dan seterusnya.
- `$@` - Semua argumen
- `$#` - Jumlah argumen
- `$?` - Return code dari perintah sebelumnya
- `$$` - Nomor identifikasi proses (PID) untuk skrip saat ini
- `!!` - Seluruh perintah terakhir, termasuk argumen. Pola yang umum adalah menjalankan perintah yang kemudian gagal karena izin yang kurang; Anda dapat dengan cepat menjalankan ulang perintah tersebut dengan sudo menggunakan `sudo !!`
- `$_` - Argumen terakhir dari perintah terakhir. Jika Anda berada di shell interaktif, Anda juga dapat dengan cepat mendapatkan nilai ini dengan mengetik `Esc` diikuti oleh `.` atau `Alt+.`

Perintah sering kali mengembalikan output menggunakan `STDOUT`, error melalui `STDERR`, dan Return Code untuk melaporkan error dengan cara yang lebih ramah skrip.
Return code atau exit status adalah cara skrip/perintah untuk mengkomunikasikan bagaimana eksekusi berjalan.
Nilai 0 biasanya berarti semuanya berjalan dengan baik; nilai selain 0 berarti ada error yang terjadi.

Exit code dapat digunakan untuk mengeksekusi perintah secara kondisional menggunakan `&&` (operator and) dan `||` (operator or), yang keduanya merupakan operator [short-circuiting](https://en.wikipedia.org/wiki/Short-circuit_evaluation). Perintah juga dapat dipisahkan dalam satu baris menggunakan titik koma `;`.
Program `true` akan selalu memiliki return code 0 dan perintah `false` akan selalu memiliki return code 1.
Mari kita lihat beberapa contoh.

```bash
false || echo "Oops, fail"
# Oops, fail

true || echo "Will not be printed"
#

true && echo "Things went well"
# Things went well

false && echo "Will not be printed"
#

true ; echo "This will always run"
# This will always run

false ; echo "This will always run"
# This will always run
```

Pola umum lainnya adalah ingin mendapatkan output dari sebuah perintah sebagai variabel. Ini dapat dilakukan dengan _command substitution_.
Setiap kali Anda menempatkan `$( CMD )`, ini akan mengeksekusi `CMD`, mendapatkan output dari perintah tersebut dan menggantikannya di tempat.
Sebagai contoh, jika Anda melakukan `for file in $(ls)`, shell akan memanggil `ls` terlebih dahulu dan kemudian melakukan iterasi atas nilai-nilai tersebut.
Fitur serupa yang kurang dikenal adalah _process substitution_, `<( CMD )` akan mengeksekusi `CMD` dan menempatkan output dalam file sementara serta mengganti `<()` dengan nama file tersebut. Ini berguna ketika perintah mengharapkan nilai diberikan melalui file daripada melalui STDIN. Sebagai contoh, `diff <(ls foo) <(ls bar)` akan menunjukkan perbedaan antara file-file dalam direktori `foo` dan `bar`.


Karena itu adalah banyak sekali informasi, mari kita lihat contoh yang memperlihatkan beberapa fitur ini. Contoh ini akan melakukan iterasi melalui argumen yang kita berikan, melakukan `grep` untuk string `foobar`, dan menambahkannya ke file sebagai komentar jika tidak ditemukan.

```bash
#!/bin/bash

echo "Starting program at $(date)" # Date will be substituted

echo "Running program $0 with $# arguments with pid $$"

for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    # When pattern is not found, grep has exit status 1
    # We redirect STDOUT and STDERR to a null register since we do not care about them
    if [[ $? -ne 0 ]]; then
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
done
```

Dalam perbandingan tersebut kita menguji apakah `$?` tidak sama dengan 0.
Bash mengimplementasikan banyak perbandingan semacam ini - Anda dapat menemukan daftar lengkapnya di manpage untuk [`test`](https://www.man7.org/linux/man-pages/man1/test.1.html).
Saat melakukan perbandingan dalam bash, cobalah gunakan double bracket `[[ ]]` daripada single bracket `[ ]`. Kemungkinan kesalahan lebih rendah meskipun tidak akan portable ke `sh`. Penjelasan lebih lengkap dapat ditemukan [di sini](https://mywiki.wooledge.org/BashFAQ/031).

Saat menjalankan skrip, Anda sering kali ingin memberikan argumen yang serupa. Bash memiliki cara untuk mempermudah hal ini, yaitu dengan melakukan ekspansi nama file. Teknik-teknik ini sering disebut sebagai shell _globbing_.
- Wildcard - Setiap kali Anda ingin melakukan pencocokan wildcard, Anda dapat menggunakan `?` dan `*` untuk mencocokkan satu karakter atau sejumlah karakter. Misalnya, dengan file `foo`, `foo1`, `foo2`, `foo10` dan `bar`, perintah `rm foo?` akan menghapus `foo1` dan `foo2` sedangkan `rm foo*` akan menghapus semua kecuali `bar`.
- Curly braces `{}` - Setiap kali Anda memiliki substring yang sama dalam serangkaian perintah, Anda dapat menggunakan curly braces agar bash mengekspansinya secara otomatis. Ini sangat berguna saat memindahkan atau mengonversi file.

```bash
convert image.{png,jpg}
# Will expand to
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# Will expand to
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# Globbing techniques can also be combined
mv *{.py,.sh} folder
# Will move all *.py and *.sh files


mkdir foo bar
# This creates files foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h
touch {foo,bar}/{a..h}
touch foo/x bar/y
# Show differences between files in foo and bar
diff <(ls foo) <(ls bar)
# Outputs
# < x
# ---
# > y
```

<!-- Lastly, pipes `|` are a core feature of scripting. Pipes connect one program's output to the next program's input. We will cover them more in detail in the data wrangling lecture. -->

Menulis skrip `bash` bisa jadi rumit dan tidak intuitif. Ada alat seperti [shellcheck](https://github.com/koalaman/shellcheck) yang akan membantu Anda menemukan error dalam skrip sh/bash Anda.

Perhatikan bahwa skrip tidak harus ditulis dalam bash untuk dipanggil dari terminal. Misalnya, berikut adalah skrip Python sederhana yang menghasilkan argumennya dalam urutan terbalik:

```python
#!/usr/local/bin/python
import sys
for arg in reversed(sys.argv[1:]):
    print(arg)
```

Kernel mengetahui cara mengeksekusi skrip ini dengan interpreter python alih-alih perintah shell karena kita menyertakan baris [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) di bagian atas skrip.
Merupakan praktik yang baik untuk menulis baris shebang menggunakan perintah [`env`](https://www.man7.org/linux/man-pages/man1/env.1.html) yang akan menemukan di mana perintah tersebut berada di sistem, sehingga meningkatkan portabilitas skrip Anda. Untuk menemukan lokasi tersebut, `env` akan menggunakan variabel lingkungan `PATH` yang telah kita bahas di kuliah pertama.
Untuk contoh ini, baris shebang akan terlihat seperti `#!/usr/bin/env python`.

Beberapa perbedaan antara fungsi shell dan skrip yang perlu Anda ingat adalah:
- Fungsi harus ditulis dalam bahasa yang sama dengan shell, sedangkan skrip dapat ditulis dalam bahasa apa pun. Inilah mengapa menyertakan shebang untuk skrip itu penting.
- Fungsi dimuat sekali saat definisinya dibaca. Skrip dimuat setiap kali dieksekusi. Ini membuat fungsi sedikit lebih cepat untuk dimuat, tetapi setiap kali Anda mengubahnya, Anda harus memuat ulang definisinya.
- Fungsi dijalankan di environment shell saat ini sedangkan skrip dijalankan di prosesnya sendiri. Dengan demikian, fungsi dapat memodifikasi variabel lingkungan, misalnya mengubah direktori kerja Anda saat ini, sedangkan skrip tidak bisa. Variabel lingkungan yang telah diekspor menggunakan [`export`](https://www.man7.org/linux/man-pages/man1/export.1p.html) diteruskan sebagai nilai ke skrip.
- Seperti dalam bahasa pemrograman apa pun, fungsi adalah konstruksi yang powerful untuk mencapai modularitas, penggunaan ulang kode, dan kejelasan kode shell. Seringkali skrip shell akan menyertakan definisi fungsinya sendiri.

# Alat Shell

## Menemukan cara menggunakan perintah

Pada titik ini, Anda mungkin bertanya-tanya bagaimana cara menemukan flag untuk perintah-perintah di bagian alias seperti `ls -l`, `mv -i`, dan `mkdir -p`.
Secara lebih umum, diberikan sebuah perintah, bagaimana Anda mencari tahu apa yang dilakukannya dan opsi-opsi yang berbeda?
Anda bisa saja mulai mencari di Google, tetapi karena UNIX lebih tua dari StackOverflow, ada cara bawaan untuk mendapatkan informasi ini.

Seperti yang kita lihat di kuliah shell, pendekatan pertama adalah memanggil perintah tersebut dengan flag `-h` atau `--help`. Pendekatan yang lebih detail adalah menggunakan perintah `man`.
Singkatan dari manual, [`man`](https://www.man7.org/linux/man-pages/man1/man.1.html) menyediakan halaman manual (disebut manpage) untuk perintah yang Anda tentukan.
Sebagai contoh, `man rm` akan menampilkan perilaku perintah `rm` beserta flag-flag yang diterimanya, termasuk flag `-i` yang kita tunjukkan sebelumnya.
Sebenarnya, apa yang telah saya tautkan sejauh ini untuk setiap perintah adalah versi online dari manpage Linux untuk perintah-perintah tersebut.
Bahkan perintah non-bawaan yang Anda instal akan memiliki entri manpage jika pengembang menulisnya dan menyertakannya sebagai bagian dari proses instalasi.
Untuk alat interaktif seperti yang berbasis ncurses, bantuan untuk perintah sering kali dapat diakses di dalam program menggunakan perintah `:help` atau mengetik `?`.

Terkadang manpage dapat memberikan deskripsi yang terlalu detail tentang perintah, sehingga sulit untuk memahami flag/sintaks apa yang harus digunakan untuk kasus penggunaan umum.
[Halaman TLDR](https://tldr.sh/) adalah solusi pelengkap yang berguna yang berfokus pada memberikan contoh penggunaan perintah sehingga Anda dapat dengan cepat mengetahui opsi mana yang harus digunakan.
Sebagai contoh, saya sering merujuk ke halaman tldr untuk [`tar`](https://tldr.inbrowser.app/pages/common/tar) dan [`ffmpeg`](https://tldr.inbrowser.app/pages/common/ffmpeg) lebih sering daripada manpage.


## Mencari file

Salah satu tugas repetitif paling umum yang dihadapi setiap programmer adalah mencari file atau direktori.
Semua sistem berbasis UNIX dilengkapi dengan [`find`](https://www.man7.org/linux/man-pages/man1/find.1.html), alat shell yang hebat untuk mencari file. `find` akan mencari file secara rekursif berdasarkan kriteria tertentu. Beberapa contoh:

```bash
# Find all directories named src
find . -name src -type d
# Find all python files that have a folder named test in their path
find . -path '*/test/*.py' -type f
# Find all files modified in the last day
find . -mtime -1
# Find all zip files with size in range 500k to 10M
find . -size +500k -size -10M -name '*.tar.gz'
```
Selain menampilkan daftar file, find juga dapat melakukan aksi terhadap file yang cocok dengan pencarian Anda.
Properti ini bisa sangat membantu untuk menyederhanakan tugas yang bisa jadi cukup monoton.
```bash
# Delete all files with .tmp extension
find . -name '*.tmp' -exec rm {} \;

# Find all PNG files and convert them to JPG
find . -name '*.png' -exec magick {} {}.jpg \;
```

Meskipun `find` sangat umum digunakan, sintaksnya terkadang sulit diingat.
Misalnya, untuk mencari file yang cocok dengan pola `PATTERN`, Anda harus menjalankan `find -name '*PATTERN*'` (atau `-iname` jika Anda ingin pencocokan pola yang tidak case-sensitive).
Anda bisa mulai membuat alias untuk skenario-skenario tersebut, tetapi bagian dari filosofi shell adalah bahwa baik untuk menjelajahi alternatif.
Ingat, salah satu properti terbaik dari shell adalah Anda hanya memanggil program, sehingga Anda dapat menemukan (atau bahkan menulis sendiri) pengganti untuk beberapa di antaranya.
Misalnya, [`fd`](https://github.com/sharkdp/fd) adalah alternatif yang sederhana, cepat, dan user-friendly untuk `find`.
Alat ini menawarkan beberapa default yang bagus seperti output berwarna, pencocokan regex default, dan dukungan Unicode. Alat ini juga memiliki, menurut saya, sintaks yang lebih intuitif.
Sebagai contoh, sintaks untuk mencari pola `PATTERN` adalah `fd PATTERN`.

Sebagian besar akan setuju bahwa `find` dan `fd` adalah alat yang bagus, tetapi beberapa dari Anda mungkin bertanya-tanya tentang efisiensi mencari file setiap kali versus mengompilasi semacam indeks atau database untuk pencarian cepat.
Itulah fungsi dari [`locate`](https://www.man7.org/linux/man-pages/man1/locate.1.html).
`locate` menggunakan database yang diperbarui menggunakan [`updatedb`](https://www.man7.org/linux/man-pages/man1/updatedb.1.html).
Di sebagian besar sistem, `updatedb` diperbarui setiap hari melalui [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html).
Oleh karena itu, trade-off antara keduanya adalah kecepatan vs kesegaran data.
Selain itu, `find` dan alat serupa juga dapat mencari file menggunakan atribut seperti ukuran file, waktu modifikasi, atau izin file, sedangkan `locate` hanya menggunakan nama file.
Perbandingan yang lebih mendalam dapat ditemukan [di sini](https://unix.stackexchange.com/questions/60205/locate-vs-find-usage-pros-and-cons-of-each-other).

## Mencari kode

Mencari file berdasarkan nama memang berguna, tetapi cukup sering Anda ingin mencari berdasarkan *konten* file.
Skenario yang umum adalah ingin mencari semua file yang mengandung pola tertentu, beserta lokasi pola tersebut dalam file-file itu.
Untuk mencapai ini, sebagian besar sistem berbasis UNIX menyediakan [`grep`](https://www.man7.org/linux/man-pages/man1/grep.1.html), alat generik untuk mencocokkan pola dari teks input.
`grep` adalah alat shell yang sangat berharga yang akan kita bahas lebih detail selama kuliah data wrangling.

Untuk saat ini, ketahuilah bahwa `grep` memiliki banyak flag yang membuatnya menjadi alat yang sangat serbaguna.
Beberapa yang sering saya gunakan adalah `-C` untuk mendapatkan **C**ontext di sekitar baris yang cocok dan `-v` untuk in**v**erting pencocokan, yaitu mencetak semua baris yang **tidak** cocok dengan pola. Misalnya, `grep -C 5` akan mencetak 5 baris sebelum dan setelah pencocokan.
Saat mencari dengan cepat di banyak file, Anda ingin menggunakan `-R` karena akan secara **R**ekursif masuk ke direktori dan mencari file untuk string yang cocok.

Tetapi `grep -R` dapat ditingkatkan dalam banyak hal, seperti mengabaikan folder `.git`, menggunakan dukungan multi CPU, dll.
Banyak alternatif `grep` telah dikembangkan, termasuk [ack](https://github.com/beyondgrep/ack3), [ag](https://github.com/ggreer/the_silver_searcher), dan [rg](https://github.com/BurntSushi/ripgrep).
Semuanya fantastis dan kurang lebih menyediakan fungsionalitas yang sama.
Untuk saat ini saya tetap menggunakan ripgrep (`rg`), mengingat kecepatannya yang tinggi dan intuitif. Beberapa contoh:
```bash
# Find all python files where I used the requests library
rg -t py 'import requests'
# Find all files (including hidden files) without a shebang line
rg -u --files-without-match "^#\!"
# Find all matches of foo and print the following 5 lines
rg foo -A 5
# Print statistics of matches (# of matched lines and files )
rg --stats PATTERN
```

Perhatikan bahwa seperti `find`/`fd`, penting bagi Anda untuk mengetahui bahwa masalah ini dapat dengan cepat dipecahkan menggunakan salah satu dari alat-alat ini, sedangkan alat spesifik yang Anda gunakan tidak terlalu penting.

## Mencari perintah shell

Sejauh ini kita telah melihat cara mencari file dan kode, tetapi seiring Anda menghabiskan lebih banyak waktu di shell, Anda mungkin ingin mencari perintah tertentu yang pernah Anda ketik.
Hal pertama yang perlu diketahui adalah menekan tombol panah atas akan menampilkan perintah terakhir Anda, dan jika Anda terus menekannya, Anda akan menelusuri riwayat shell Anda secara perlahan.

Perintah `history` akan memberi Anda akses ke riwayat shell secara terprogram.
Perintah ini akan mencetak riwayat shell Anda ke standard output.
Jika kita ingin mencari di sana, kita dapat mem-pipe output tersebut ke `grep` dan mencari pola.
`history | grep find` akan mencetak perintah yang mengandung substring "find".

Di sebagian besar shell, Anda dapat menggunakan `Ctrl+R` untuk melakukan pencarian mundur melalui riwayat Anda.
Setelah menekan `Ctrl+R`, Anda dapat mengetik substring yang ingin dicocokkan dengan perintah dalam riwayat Anda.
Saat Anda terus menekannya, Anda akan berpindah melalui pencocokan dalam riwayat Anda.
Ini juga dapat diaktifkan dengan tombol panah ATAS/BAWAH di [zsh](https://github.com/zsh-users/zsh-history-substring-search).
Tambahan yang bagus untuk `Ctrl+R` datang dengan menggunakan binding [fzf](https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#ctrl-r).
`fzf` adalah fuzzy finder serbaguna yang dapat digunakan dengan banyak perintah.
Di sini ia digunakan untuk mencocokkan secara fuzzy melalui riwayat Anda dan menyajikan hasil dengan cara yang nyaman dan menarik secara visual.

Trik menarik lainnya terkait riwayat yang sangat saya nikmati adalah **autosuggestions berbasis riwayat**.
Pertama kali diperkenalkan oleh shell [fish](https://fishshell.com/), fitur ini secara dinamis melengkapi perintah shell Anda saat ini dengan perintah terbaru yang Anda ketik yang memiliki prefix yang sama.
Fitur ini dapat diaktifkan di [zsh](https://github.com/zsh-users/zsh-autosuggestions) dan merupakan trik quality of life yang hebat untuk shell Anda.

Anda dapat memodifikasi perilaku riwayat shell Anda, seperti mencegah perintah dengan spasi di awal agar tidak disertakan. Ini berguna saat Anda mengetik perintah dengan password atau informasi sensitif lainnya.
Untuk melakukan ini, tambahkan `HISTCONTROL=ignorespace` ke `.bashrc` Anda atau `setopt HIST_IGNORE_SPACE` ke `.zshrc` Anda.
Jika Anda tidak sengaja tidak menambahkan spasi di awal, Anda selalu dapat menghapus entri tersebut secara manual dengan mengedit `.bash_history` atau `.zsh_history` Anda.

## Navigasi Direktori

Sejauh ini, kita berasumsi bahwa Anda sudah berada di tempat yang Anda butuhkan untuk melakukan tindakan-tindakan ini. Tetapi bagaimana cara Anda menavigasi direktori dengan cepat?
Ada banyak cara sederhana yang bisa Anda lakukan, seperti menulis alias shell atau membuat symlink dengan [ln -s](https://www.man7.org/linux/man-pages/man1/ln.1.html), tetapi kenyataannya adalah para pengembang telah menemukan solusi yang cukup cerdas dan canggih sampai saat ini.

Seperti tema kursus ini, Anda sering ingin mengoptimalkan untuk kasus yang paling umum.
Mencari file dan direktori yang sering atau baru-baru ini diakses dapat dilakukan melalui alat seperti [`fasd`](https://github.com/clvv/fasd) dan [`autojump`](https://github.com/wting/autojump).
Fasd memberi peringkat pada file dan direktori berdasarkan [_frecency_](https://web.archive.org/web/20210421120120/https://developer.mozilla.org/en-US/docs/Mozilla/Tech/Places/Frecency_algorithm), yaitu berdasarkan _frekuensi_ dan _recency_.
Secara default, `fasd` menambahkan perintah `z` yang dapat Anda gunakan untuk `cd` dengan cepat menggunakan substring dari direktori yang _frecent_. Misalnya, jika Anda sering pergi ke `/home/user/files/cool_project`, Anda cukup menggunakan `z cool` untuk melompat ke sana. Menggunakan autojump, perubahan direktori yang sama dapat dilakukan dengan `j cool`.

Alat yang lebih kompleks tersedia untuk mendapatkan gambaran cepat tentang struktur direktori: [`tree`](https://linux.die.net/man/1/tree), [`broot`](https://github.com/Canop/broot), atau bahkan file manager lengkap seperti [`nnn`](https://github.com/jarun/nnn) atau [`ranger`](https://github.com/ranger/ranger).

# Latihan

1. Baca [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) dan tulis perintah `ls` yang menampilkan daftar file dengan cara berikut

    - Mencakup semua file, termasuk file tersembunyi
    - Ukuran ditampilkan dalam format yang mudah dibaca manusia (misalnya 454M alih-alih 454279954)
    - File diurutkan berdasarkan recency
    - Output diberi warna

    Contoh output akan terlihat seperti ini

    ```
    -rw-r--r--   1 user group 1.1M Jan 14 09:53 baz
    drwxr-xr-x   5 user group  160 Jan 14 09:53 .
    -rw-r--r--   1 user group  514 Jan 14 06:42 bar
    -rw-r--r--   1 user group 106M Jan 13 12:12 foo
    drwx------+ 47 user group 1.5K Jan 12 18:08 ..
    ```

{% comment %}
ls -lath --color=auto
{% endcomment %}

1. Tulis fungsi bash `marco` dan `polo` yang melakukan hal berikut.
Setiap kali Anda menjalankan `marco`, direktori kerja saat ini harus disimpan dengan cara tertentu, kemudian ketika Anda menjalankan `polo`, tidak peduli di direktori mana Anda berada, `polo` harus melakukan `cd` kembali ke direktori tempat Anda menjalankan `marco`.
Untuk kemudahan debugging, Anda dapat menulis kode dalam file `marco.sh` dan memuat ulang definisi ke shell Anda dengan menjalankan `source marco.sh`.

{% comment %}
marco() {
    export MARCO=$(pwd)
}

polo() {
    cd "$MARCO"
}
{% endcomment %}

1. Katakan Anda memiliki perintah yang jarang gagal. Untuk melakukan debugging, Anda perlu menangkap outputnya tetapi bisa memakan waktu lama untuk mendapatkan hasil yang gagal.
Tulis skrip bash yang menjalankan skrip berikut sampai ia gagal dan menangkap standard output serta error stream ke file dan mencetak semuanya di akhir.
Poin bonus jika Anda juga dapat melaporkan berapa kali percobaan yang diperlukan hingga skrip gagal.

    ```bash
    #!/usr/bin/env bash

    n=$(( RANDOM % 100 ))

    if [[ n -eq 42 ]]; then
       echo "Something went wrong"
       >&2 echo "The error was using magic numbers"
       exit 1
    fi

    echo "Everything went according to plan"
    ```

{% comment %}
#!/usr/bin/env bash

count=0
until [[ "$?" -ne 0 ]];
do
  count=$((count+1))
  ./random.sh &> out.txt
done

echo "found error after $count runs"
cat out.txt
{% endcomment %}

1. Seperti yang kita bahas di kuliah, `-exec` milik `find` bisa sangat powerful untuk melakukan operasi pada file yang kita cari.
Namun, bagaimana jika kita ingin melakukan sesuatu dengan **semua** file, seperti membuat file zip?
Seperti yang telah Anda lihat sejauh ini, perintah menerima input baik dari argumen maupun STDIN.
Saat mem-pipe perintah, kita menghubungkan STDOUT ke STDIN, tetapi beberapa perintah seperti `tar` menerima input dari argumen.
Untuk menjembatani ketidaksesuaian ini, ada perintah [`xargs`](https://www.man7.org/linux/man-pages/man1/xargs.1.html) yang akan menjalankan perintah menggunakan STDIN sebagai argumen.
Misalnya `ls | xargs rm` akan menghapus file-file di direktori saat ini.

    Tugas Anda adalah menulis perintah yang secara rekursif mencari semua file HTML dalam folder dan membuat zip dari file-file tersebut. Perhatikan bahwa perintah Anda harus berfungsi meskipun file memiliki spasi (petunjuk: periksa flag `-d` untuk `xargs`).
    {% comment %}
    find . -type f -name "*.html" | xargs -d '\n'  tar -cvzf archive.tar.gz
    {% endcomment %}

    Jika Anda menggunakan macOS, perhatikan bahwa `find` BSD default berbeda dari yang disertakan dalam [GNU coreutils](https://en.wikipedia.org/wiki/List_of_GNU_Core_Utilities_commands). Anda dapat menggunakan `-print0` pada `find` dan flag `-0` pada `xargs`. Sebagai pengguna macOS, Anda harus menyadari bahwa utilitas baris perintah yang disertakan dengan macOS mungkin berbeda dari versi GNU; Anda dapat menginstal versi GNU jika Anda mau dengan [menggunakan brew](https://formulae.brew.sh/formula/coreutils).

1. (Lanjutan) Tulis perintah atau skrip untuk secara rekursif menemukan file yang paling baru diubah dalam sebuah direktori. Secara lebih umum, dapatkah Anda menampilkan semua file berdasarkan recency?