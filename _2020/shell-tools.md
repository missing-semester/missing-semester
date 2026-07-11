---
layout: lecture
title: "Tools Shell dan Scripting"
description: >
  Pelajari cara menulis shell script dan menggunakan tools command-line yang powerful.
thumbnail: /static/assets/thumbnails/2020/lec2.png
date: 2020-01-14
ready: true
video:
  aspect: 56.25
  id: kgII-YWo3Zw
---

Pada kuliah ini, kita akan membahas beberapa dasar penggunaan bash sebagai bahasa scripting beserta sejumlah tools shell yang mencakup beberapa tugas paling umum yang akan terus Anda lakukan di command line.

# Scripting Shell

Sejauh ini kita telah melihat cara menjalankan perintah di shell dan menggabungkannya dengan pipe.
Namun, dalam banyak skenario Anda ingin melakukan serangkaian perintah dan menggunakan ekspresi control flow seperti kondisional atau perulangan.

Shell script adalah langkah berikutnya dalam hal kompleksitas.
Kebanyakan shell memiliki bahasa scripting sendiri dengan variabel, control flow, dan sintaksisnya sendiri.
Yang membedakan shell scripting dari bahasa scripting lainnya adalah ia dioptimalkan untuk melakukan tugas-tugas terkait shell.
Dengan demikian, membuat pipeline perintah, menyimpan hasil ke file, dan membaca dari standard input adalah primitif dalam shell scripting, sehingga lebih mudah digunakan daripada bahasa scripting serbaguna.
Untuk bagian ini kita akan fokus pada bash scripting karena merupakan yang paling umum.

Untuk menetapkan variabel di bash, gunakan sintaks `foo=bar` dan akses nilai variabel dengan `$foo`.
Perhatikan bahwa `foo = bar` tidak akan berhasil karena diinterpretasikan sebagai pemanggilan program `foo` dengan argumen `=` dan `bar`.
Secara umum, di shell script karakter spasi akan melakukan pemisahan argumen. Perilaku ini bisa membingungkan pada awalnya, jadi selalu periksa hal tersebut.

String di bash dapat didefinisikan dengan delimiter `'` dan `"`, tetapi keduanya tidak ekuivalen.
String yang dibatasi dengan `'` adalah string literal dan tidak akan mensubstitusi nilai variabel, sedangkan string yang dibatasi dengan `"` akan melakukannya.

```bash
foo=bar
echo "$foo"
# prints bar
echo '$foo'
# prints $foo
```

Seperti kebanyakan bahasa pemrograman, bash mendukung teknik-teknik control flow termasuk `if`, `case`, `while`, dan `for`.
Demikian pula, `bash` memiliki fungsi yang menerima argumen dan dapat beroperasi dengan argumen tersebut. Berikut adalah contoh fungsi yang membuat direktori dan melakukan `cd` ke dalamnya.


```bash
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```

Di sini `$1` adalah argumen pertama untuk script/fungsi.
Berbeda dengan bahasa scripting lainnya, bash menggunakan berbagai variabel khusus untuk merujuk pada argumen, kode error, dan variabel relevan lainnya. Berikut adalah daftar beberapa di antaranya. Daftar yang lebih lengkap dapat ditemukan [di sini](https://tldp.org/LDP/abs/html/special-chars.html).
- `$0` - Nama script
- `$1` hingga `$9` - Argumen untuk script. `$1` adalah argumen pertama dan seterusnya.
- `$@` - Semua argumen
- `$#` - Jumlah argumen
- `$?` - Return code dari perintah sebelumnya
- `$$` - Nomor identifikasi proses (PID) untuk script saat ini
- `!!` - Seluruh perintah terakhir, termasuk argumen. Pola yang umum adalah menjalankan perintah yang kemudian gagal karena izin yang kurang; Anda dapat dengan cepat menjalankan ulang perintah tersebut dengan sudo menggunakan `sudo !!`
- `$_` - Argumen terakhir dari perintah terakhir. Jika Anda berada di shell interaktif, Anda juga dapat dengan cepat mendapatkan nilai ini dengan mengetik `Esc` diikuti oleh `.` atau `Alt+.`

Perintah sering kali mengembalikan output menggunakan `STDOUT`, error melalui `STDERR`, dan Return Code untuk melaporkan error dengan cara yang lebih ramah terhadap script.
Return code atau exit status adalah cara script/perintah melaporkan bagaimana eksekusi berjalan.
Nilai 0 biasanya berarti semuanya berjalan dengan baik; nilai selain 0 berarti terjadi error.

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

Pola umum lainnya adalah ingin mendapatkan output dari sebuah perintah sebagai variabel. Hal ini dapat dilakukan dengan _command substitution_.
Kapan pun Anda menempatkan `$( CMD )`, ia akan mengeksekusi `CMD`, mendapatkan output perintah tersebut, dan mensubstitusikannya di tempat.
Sebagai contoh, jika Anda melakukan `for file in $(ls)`, shell pertama-tama akan memanggil `ls` dan kemudian mengiterasi nilai-nilai tersebut.
Fitur serupa yang kurang dikenal adalah _process substitution_, `<( CMD )` akan mengeksekusi `CMD` dan menempatkan outputnya di file sementara serta mensubstitusi `<()` dengan nama file tersebut. Ini berguna ketika perintah mengharapkan nilai dikirim melalui file, bukan melalui STDIN. Sebagai contoh, `diff <(ls foo) <(ls bar)` akan menunjukkan perbedaan antara file-file di direktori `foo` dan `bar`.


Karena tadi sudah banyak sekali informasi yang disampaikan, mari kita lihat sebuah contoh yang memperlihatkan beberapa fitur tersebut. Contoh ini akan mengiterasi argumen yang kita berikan, melakukan `grep` untuk string `foobar`, dan menambahkannya ke file sebagai komentar jika tidak ditemukan.

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
Saat melakukan perbandingan di bash, usahakan menggunakan kurung siku ganda `[[ ]]` daripada kurung siku tunggal `[ ]`. Kemungkinan kesalahan lebih kecil meskipun tidak akan portabel ke `sh`. Penjelasan lebih lengkap dapat ditemukan [di sini](https://mywiki.wooledge.org/BashFAQ/031).

Saat menjalankan script, Anda sering kali ingin memberikan argumen yang serupa. Bash memiliki cara untuk mempermudah hal ini, yaitu dengan memperluas ekspresi melalui filename expansion. Teknik-teknik ini sering disebut sebagai shell _globbing_.
- Wildcard - Kapan pun Anda ingin melakukan pencocokan wildcard, Anda dapat menggunakan `?` dan `*` untuk mencocokkan satu karakter atau sejumlah karakter. Sebagai contoh, dengan file `foo`, `foo1`, `foo2`, `foo10`, dan `bar`, perintah `rm foo?` akan menghapus `foo1` dan `foo2` sedangkan `rm foo*` akan menghapus semuanya kecuali `bar`.
- Kurung kurawal `{}` - Kapan pun Anda memiliki substring yang sama dalam serangkaian perintah, Anda dapat menggunakan kurung kurawal agar bash mengembangkannya secara otomatis. Ini sangat berguna saat memindahkan atau mengonversi file.

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

Menulis script `bash` bisa jadi rumit dan tidak intuitif. Ada tools seperti [shellcheck](https://github.com/koalaman/shellcheck) yang dapat membantu Anda menemukan error di script sh/bash Anda.

Perhatikan bahwa script tidak harus selalu ditulis dalam bash untuk dapat dipanggil dari terminal. Sebagai contoh, berikut adalah script Python sederhana yang mengeluarkan argumennya dalam urutan terbalik:

```python
#!/usr/local/bin/python
import sys
for arg in reversed(sys.argv[1:]):
    print(arg)
```

Kernel tahu bahwa script ini harus dieksekusi dengan interpreter Python, bukan perintah shell, karena kita menyertakan baris [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) di bagian atas script.
Merupakan praktik yang baik untuk menulis baris shebang menggunakan perintah [`env`](https://www.man7.org/linux/man-pages/man1/env.1.html) yang akan meresolve ke lokasi perintah tersebut di sistem, sehingga meningkatkan portabilitas script Anda. Untuk meresolve lokasi, `env` akan menggunakan variabel lingkungan `PATH` yang telah kita bahas di kuliah pertama.
Untuk contoh ini, baris shebang-nya akan terlihat seperti `#!/usr/bin/env python`.

Beberapa perbedaan antara fungsi shell dan script yang perlu Anda ingat adalah:
- Fungsi harus ditulis dalam bahasa yang sama dengan shell, sedangkan script dapat ditulis dalam bahasa apa pun. Itulah mengapa menyertakan shebang untuk script itu penting.
- Fungsi dimuat sekali saat definisinya dibaca. Script dimuat setiap kali dieksekusi. Ini membuat fungsi sedikit lebih cepat untuk dimuat, tetapi setiap kali Anda mengubahnya, Anda harus memuat ulang definisinya.
- Fungsi dijalankan di environment shell saat ini, sedangkan script dijalankan di prosesnya sendiri. Oleh karena itu, fungsi dapat memodifikasi variabel lingkungan, misalnya mengubah direktori kerja Anda saat ini, sedangkan script tidak bisa. Variabel lingkungan yang telah diekspor menggunakan [`export`](https://www.man7.org/linux/man-pages/man1/export.1p.html) diteruskan secara nilai ke script.
- Seperti bahasa pemrograman lainnya, fungsi adalah konstruksi yang powerful untuk mencapai modularitas, penggunaan ulang kode, dan kejelasan kode shell. Script shell sering kali akan menyertakan definisi fungsi mereka sendiri.

# Shell Tools

## Mencari cara menggunakan perintah

Pada titik ini, Anda mungkin bertanya-tanya bagaimana cara mencari flag untuk perintah-perintah di bagian aliasing seperti `ls -l`, `mv -i`, dan `mkdir -p`.
Secara lebih umum, diberikan sebuah perintah, bagaimana cara Anda mengetahui apa yang dilakukannya dan opsi-opsi yang tersedia?
Anda selalu bisa mulai mencari di Google, tetapi karena UNIX lebih tua dari StackOverflow, ada cara bawaan untuk mendapatkan informasi ini.

Seperti yang kita lihat di kuliah shell, pendekatan pertama adalah memanggil perintah tersebut dengan flag `-h` atau `--help`. Pendekatan yang lebih detail adalah menggunakan perintah `man`.
Singkatan dari manual, [`man`](https://www.man7.org/linux/man-pages/man1/man.1.html) menyediakan halaman manual (disebut manpage) untuk perintah yang Anda tentukan.
Sebagai contoh, `man rm` akan menampilkan perilaku perintah `rm` beserta flag-flag yang diterimanya, termasuk flag `-i` yang kita tunjukkan sebelumnya.
Sebenarnya, yang telah saya tautkan sejauh ini untuk setiap perintah adalah versi online dari manpage Linux untuk perintah-perintah tersebut.
Bahkan perintah non-bawaan yang Anda instal akan memiliki entri manpage jika developernya menulisnya dan menyertakannya sebagai bagian dari proses instalasi.
Untuk tool interaktif seperti yang berbasis ncurses, bantuan untuk perintah sering kali dapat diakses di dalam program menggunakan perintah `:help` atau mengetik `?`.

Terkadang manpage dapat memberikan deskripsi yang terlalu detail tentang perintah, sehingga sulit untuk menentukan flag/sintaks yang digunakan untuk kasus umum.
[Halaman TLDR](https://tldr.sh/) adalah solusi pelengkap yang berguna yang berfokus pada memberikan contoh penggunaan perintah sehingga Anda dapat dengan cepat mengetahui opsi mana yang harus digunakan.
Sebagai contoh, saya sering merujuk ke halaman tldr untuk [`tar`](https://tldr.inbrowser.app/pages/common/tar) dan [`ffmpeg`](https://tldr.inbrowser.app/pages/common/ffmpeg) jauh lebih sering daripada manpage-nya.


## Mencari file

Salah satu tugas repetitif paling umum yang dihadapi setiap programmer adalah mencari file atau direktori.
Semua sistem berbasis UNIX dilengkapi dengan [`find`](https://www.man7.org/linux/man-pages/man1/find.1.html), tool shell yang hebat untuk mencari file. `find` akan mencari file secara rekursif berdasarkan kriteria tertentu. Beberapa contoh:

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
Selain mendaftar file, find juga dapat melakukan aksi terhadap file yang cocok dengan pencarian Anda.
Sifat ini bisa sangat membantu untuk menyederhanakan tugas yang bisa jadi cukup monoton.
```bash
# Delete all files with .tmp extension
find . -name '*.tmp' -exec rm {} \;

# Find all PNG files and convert them to JPG
find . -name '*.png' -exec magick {} {}.jpg \;
```

Meskipun `find` sangat umum digunakan, sintaksnya terkadang sulit diingat.
Sebagai contoh, untuk mencari file yang cocok dengan pola `PATTERN`, Anda harus menjalankan `find -name '*PATTERN*'` (atau `-iname` jika Anda ingin pencocokan pola yang tidak case-sensitive).
Anda bisa mulai membuat alias untuk skenario-skenario tersebut, tetapi bagian dari filosofi shell adalah baik untuk menjelajahi alternatif.
Ingat, salah satu keunggulan terbaik dari shell adalah Anda hanya memanggil program, sehingga Anda dapat mencari (atau bahkan menulis sendiri) pengganti untuk beberapa di antaranya.
Sebagai contoh, [`fd`](https://github.com/sharkdp/fd) adalah alternatif `find` yang sederhana, cepat, dan mudah digunakan.
Ia menawarkan beberapa fitur default yang bagus seperti output berwarna, pencocokan regex default, dan dukungan Unicode. Selain itu, menurut saya, sintaksnya lebih intuitif.
Sebagai contoh, sintaks untuk mencari pola `PATTERN` adalah `fd PATTERN`.

Kebanyakan orang akan setuju bahwa `find` dan `fd` sudah bagus, tetapi beberapa dari Anda mungkin bertanya-tanya tentang efisiensi mencari file setiap saat dibandingkan dengan mengompilasi semacam indeks atau database untuk pencarian cepat.
Itulah fungsi dari [`locate`](https://www.man7.org/linux/man-pages/man1/locate.1.html).
`locate` menggunakan database yang diperbarui menggunakan [`updatedb`](https://www.man7.org/linux/man-pages/man1/updatedb.1.html).
Di sebagian besar sistem, `updatedb` diperbarui setiap hari melalui [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html).
Oleh karena itu, trade-off antara keduanya adalah kecepatan vs kesegaran data.
Selain itu, `find` dan tool sejenis juga dapat mencari file menggunakan atribut seperti ukuran file, waktu modifikasi, atau izin file, sedangkan `locate` hanya menggunakan nama file.
Perbandingan yang lebih mendalam dapat ditemukan [di sini](https://unix.stackexchange.com/questions/60205/locate-vs-find-usage-pros-and-cons-of-each-other).

## Mencari kode

Mencari file berdasarkan nama memang berguna, tetapi cukup sering Anda ingin mencari berdasarkan *konten* file.
Skenario umum adalah ingin mencari semua file yang mengandung pola tertentu, beserta lokasi pola tersebut dalam file-file itu.
Untuk mencapai hal ini, sebagian besar sistem berbasis UNIX menyediakan [`grep`](https://www.man7.org/linux/man-pages/man1/grep.1.html), tool umum untuk mencocokkan pola dari teks input.
`grep` adalah tool shell yang sangat berharga yang akan kita bahas lebih detail pada kuliah data wrangling.

Untuk saat ini, ketahuilah bahwa `grep` memiliki banyak flag yang membuatnya sangat serbaguna.
Beberapa yang sering saya gunakan adalah `-C` untuk mendapatkan **C**ontext di sekitar baris yang cocok dan `-v` untuk in**v**ersi pencocokan, yaitu mencetak semua baris yang **tidak** cocok dengan pola. Sebagai contoh, `grep -C 5` akan mencetak 5 baris sebelum dan sesudah pencocokan.
Untuk pencarian cepat di banyak file, Anda ingin menggunakan `-R` karena akan secara **R**ekursif masuk ke direktori dan mencari file untuk string yang cocok.

Tetapi `grep -R` dapat ditingkatkan dalam banyak hal, seperti mengabaikan folder `.git`, menggunakan dukungan multi-CPU, dan lain-lain.
Banyak alternatif `grep` telah dikembangkan, termasuk [ack](https://github.com/beyondgrep/ack3), [ag](https://github.com/ggreer/the_silver_searcher), dan [rg](https://github.com/BurntSushi/ripgrep).
Semuanya fantastis dan kurang lebih menyediakan fungsionalitas yang sama.
Untuk saat ini saya tetap menggunakan ripgrep (`rg`), mengingat kecepatannya dan intuitifnya. Beberapa contoh:
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

Perhatikan bahwa seperti `find`/`fd`, penting bagi Anda untuk mengetahui bahwa masalah ini dapat diselesaikan dengan cepat menggunakan salah satu tool ini, sedangkan tool spesifik yang Anda gunakan tidak terlalu penting.

## Mencari perintah shell

Sejauh ini kita telah melihat cara mencari file dan kode, tetapi seiring Anda semakin banyak menghabiskan waktu di shell, Anda mungkin ingin mencari perintah tertentu yang pernah Anda ketik.
Hal pertama yang perlu diketahui adalah menekan tombol panah atas akan menampilkan perintah terakhir Anda, dan jika Anda terus menekannya, Anda akan menelusuri riwayat shell Anda secara perlahan.

Perintah `history` akan memungkinkan Anda mengakses riwayat shell Anda secara terprogram.
Ia akan mencetak riwayat shell Anda ke standard output.
Jika kita ingin mencari di sana, kita dapat mem-pipe output tersebut ke `grep` dan mencari pola.
`history | grep find` akan mencetak perintah yang mengandung substring "find".

Di sebagian besar shell, Anda dapat menggunakan `Ctrl+R` untuk melakukan pencarian mundur melalui riwayat Anda.
Setelah menekan `Ctrl+R`, Anda dapat mengetik substring yang ingin dicocokkan dengan perintah di riwayat Anda.
Saat Anda terus menekannya, Anda akan berpindah dari satu pencocokan ke pencocokan berikutnya di riwayat Anda.
Ini juga dapat diaktifkan dengan tombol panah ATAS/BAWAH di [zsh](https://github.com/zsh-users/zsh-history-substring-search).
Tambahan yang bagus untuk `Ctrl+R` adalah dengan menggunakan binding [fzf](https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#ctrl-r).
`fzf` adalah fuzzy finder serbaguna yang dapat digunakan dengan banyak perintah.
Di sini ia digunakan untuk mencocokkan riwayat Anda secara fuzzy dan menampilkan hasil dengan cara yang nyaman dan menarik secara visual.

Trik lain terkait riwayat yang sangat saya nikmati adalah **autosuggestions berbasis riwayat**.
Pertama kali diperkenalkan oleh shell [fish](https://fishshell.com/), fitur ini secara dinamis melengkapi perintah shell Anda saat ini dengan perintah terbaru yang Anda ketik yang memiliki awalan yang sama.
Fitur ini dapat diaktifkan di [zsh](https://github.com/zsh-users/zsh-autosuggestions) dan merupakan trik kualitas hidup yang hebat untuk shell Anda.

Anda dapat memodifikasi perilaku riwayat shell Anda, seperti mencegah perintah dengan spasi di awal agar tidak disertakan. Ini berguna saat Anda mengetik perintah dengan password atau informasi sensitif lainnya.
Untuk melakukannya, tambahkan `HISTCONTROL=ignorespace` ke `.bashrc` Anda atau `setopt HIST_IGNORE_SPACE` ke `.zshrc` Anda.
Jika Anda terlanjur tidak menambahkan spasi di awal, Anda selalu dapat menghapus entri tersebut secara manual dengan mengedit `.bash_history` atau `.zsh_history` Anda.

## Navigasi Direktori

Sejauh ini, kita berasumsi bahwa Anda sudah berada di tempat yang tepat untuk melakukan tindakan-tindakan tersebut. Tetapi bagaimana cara Anda dengan cepat berpindah antar direktori?
Ada banyak cara sederhana yang bisa Anda lakukan, seperti menulis alias shell atau membuat symlink dengan [ln -s](https://www.man7.org/linux/man-pages/man1/ln.1.html), tetapi kenyataannya para developer telah menemukan solusi yang cukup cerdas dan canggih.

Seperti tema kursus ini, Anda sering kali ingin mengoptimalkan untuk kasus yang paling umum.
Mencari file dan direktori yang sering atau baru-baru ini diakses dapat dilakukan melalui tool seperti [`fasd`](https://github.com/clvv/fasd) dan [`autojump`](https://github.com/wting/autojump).
Fasd memberi peringkat pada file dan direktori berdasarkan [_frecency_](https://web.archive.org/web/20210421120120/https://developer.mozilla.org/en-US/docs/Mozilla/Tech/Places/Frecency_algorithm), yaitu berdasarkan _frekuensi_ dan _recency_ (kedekatan waktu).
Secara default, `fasd` menambahkan perintah `z` yang dapat Anda gunakan untuk melakukan `cd` dengan cepat menggunakan substring dari direktori yang _frecent_. Sebagai contoh, jika Anda sering pergi ke `/home/user/files/cool_project`, Anda cukup menggunakan `z cool` untuk langsung ke sana. Menggunakan autojump, perubahan direktori yang sama dapat dilakukan dengan `j cool`.

Tool yang lebih kompleks tersedia untuk mendapatkan gambaran cepat tentang struktur direktori: [`tree`](https://linux.die.net/man/1/tree), [`broot`](https://github.com/Canop/broot), atau bahkan file manager lengkap seperti [`nnn`](https://github.com/jarun/nnn) atau [`ranger`](https://github.com/ranger/ranger).

# Latihan

1. Baca [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) dan tulis perintah `ls` yang menampilkan file dengan cara berikut

    - Mencakup semua file, termasuk file tersembunyi
    - Ukuran ditampilkan dalam format yang mudah dibaca manusia (misalnya 454M, bukan 454279954)
    - File diurutkan berdasarkan recency (terbaru)
    - Output diberi warna

    Contoh outputnya akan terlihat seperti ini

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
Untuk kemudahan debugging, Anda dapat menulis kode dalam file `marco.sh` dan memuat ulang definisinya ke shell dengan menjalankan `source marco.sh`.

{% comment %}
marco() {
    export MARCO=$(pwd)
}

polo() {
    cd "$MARCO"
}
{% endcomment %}

1. Misalkan Anda memiliki perintah yang jarang gagal. Untuk melakukan debugging, Anda perlu menangkap outputnya tetapi bisa memakan waktu lama untuk mendapatkan run yang gagal.
Tulis script bash yang menjalankan script berikut hingga gagal dan menangkap standard output serta error stream-nya ke file, lalu mencetak semuanya di akhir.
Poin bonus jika Anda juga dapat melaporkan berapa kali run yang diperlukan hingga script tersebut gagal.

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
Seperti yang telah Anda lihat sejauh ini, perintah akan menerima input baik dari argumen maupun STDIN.
Saat mem-pipe perintah, kita menghubungkan STDOUT ke STDIN, tetapi beberapa perintah seperti `tar` menerima input dari argumen.
Untuk menjembatani kesenjangan ini, ada perintah [`xargs`](https://www.man7.org/linux/man-pages/man1/xargs.1.html) yang akan mengeksekusi perintah menggunakan STDIN sebagai argumen.
Sebagai contoh, `ls | xargs rm` akan menghapus file-file di direktori saat ini.

    Tugas Anda adalah menulis perintah yang secara rekursif mencari semua file HTML di folder dan membuat zip dari file-file tersebut. Perhatikan bahwa perintah Anda harus bekerja meskipun file memiliki spasi (petunjuk: periksa flag `-d` untuk `xargs`).
    {% comment %}
    find . -type f -name "*.html" | xargs -d '\n'  tar -cvzf archive.tar.gz
    {% endcomment %}

    Jika Anda menggunakan macOS, perhatikan bahwa `find` BSD default berbeda dari yang disertakan dalam [GNU coreutils](https://en.wikipedia.org/wiki/List_of_GNU_Core_Utilities_commands). Anda dapat menggunakan `-print0` pada `find` dan flag `-0` pada `xargs`. Sebagai pengguna macOS, Anda perlu menyadari bahwa utilitas command-line yang disertakan dengan macOS mungkin berbeda dari versi GNU; Anda dapat menginstal versi GNU jika mau dengan [menggunakan brew](https://formulae.brew.sh/formula/coreutils).

1. (Lanjutan) Tulis perintah atau script untuk secara rekursif menemukan file yang paling baru diubah di sebuah direktori. Secara lebih umum, dapatkah Anda menampilkan semua file berdasarkan recency?
