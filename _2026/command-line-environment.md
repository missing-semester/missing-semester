---
layout: lecture
title: "Lingkungan Command-line"
description: >
  Pelajari cara kerja program command-line, termasuk input/output streams, environment variables, dan mesin remote dengan SSH.
thumbnail: /static/assets/thumbnails/2026/lec2.png
date: 2026-01-13
ready: true
video:
  aspect: 56.25
  id: ccBGsPedE9Q
---

Seperti yang telah kita bahas di kuliah sebelumnya, sebagian besar shell bukan sekadar launcher untuk menjalankan program lain,
melainkan dalam praktiknya mereka menyediakan seluruh bahasa pemrograman yang penuh dengan pola-pola umum dan abstraksi.
Namun, berbeda dengan mayoritas bahasa pemrograman, dalam shell scripting semuanya dirancang untuk menjalankan program dan membuat mereka berkomunikasi satu sama lain secara sederhana dan efisien.

Secara khusus, shell scripting sangat terikat oleh _konvensi_. Agar sebuah program command-line interface (CLI) dapat bekerja dengan baik dalam lingkungan shell yang lebih luas, ada beberapa pola umum yang perlu diikuti.
Sekarang kita akan membahas banyak konsep yang diperlukan untuk memahami cara kerja program command-line serta konvensi yang ada di mana-mana tentang cara menggunakan dan mengonfigurasinya.

# Command-line Interface

Menulis sebuah fungsi dalam sebagian besar bahasa pemrograman terlihat seperti:

```
def add(x: int, y: int) -> int:
    return x + y
```

Di sini kita dapat melihat secara eksplisit input dan output dari program.
Sebaliknya, shell script bisa terlihat sangat berbeda pada pandangan pertama.

```shell
#!/usr/bin/env bash

if [[ -f $1 ]]; then
    echo "Target file already exists"
    exit 1
else
    if $DEBUG; then
        grep 'error' - | tee $1
    else
        grep 'error' - > $1
    fi
    exit 0
fi
```

Untuk memahami secara benar apa yang terjadi dalam script seperti ini, pertama-tama kita perlu memperkenalkan beberapa konsep yang sering muncul ketika program shell berkomunikasi satu sama lain atau dengan lingkungan shell:

- Arguments
- Streams
- Environment variables
- Return codes
- Signals

## Arguments

Program shell menerima daftar arguments ketika dijalankan.
Arguments adalah string biasa dalam shell, dan terserah program bagaimana menafsirkannya.
Misalnya ketika kita melakukan `ls -l folder/`, kita menjalankan program `/bin/ls` dengan arguments `['-l', 'folder/']`.

Dari dalam shell script, kita mengaksesnya melalui sintaks shell khusus.
Untuk mengakses argument pertama kita mengakses variabel `$1`, argument kedua `$2` dan seterusnya hingga `$9`. Untuk mengakses semua arguments sebagai daftar kita gunakan `$@` dan untuk mendapatkan jumlah arguments kita gunakan `$#`. Selain itu, kita juga dapat mengakses nama program dengan `$0`.

Untuk sebagian besar program, arguments akan terdiri dari campuran _flags_ dan string biasa.
Flags dapat diidentifikasi karena didahului oleh dash (`-`) atau double-dash (`--`).
Flags biasanya bersifat opsional dan perannya adalah untuk memodifikasi perilaku program.
Sebagai contoh, `ls -l` mengubah cara `ls` memformat outputnya.

Anda akan melihat flags double-dash dengan nama panjang seperti `--all`, dan flags single-dash seperti `-a`, yang paling sering diikuti oleh satu huruf.
Opsi yang sama dapat ditentukan dalam kedua format, `ls -a` dan `ls --all` adalah setara.
Flags single-dash sering digabungkan, sehingga `ls -l -a` dan `ls -la` juga setara.
Urutan flags biasanya juga tidak masalah, `ls -la` dan `ls -al` menghasilkan output yang sama.
Beberapa flags cukup umum digunakan dan seiring Anda semakin familiar dengan lingkungan shell, Anda akan secara intuitif menggunakannya, misalnya (`--help`, `--verbose`, `--version`).

> Flags adalah contoh pertama yang baik dari konvensi shell. Bahasa shell tidak mengharuskan program Anda menggunakan `-` atau `--` dengan cara tertentu ini.
Tidak ada yang mencegah kita menulis program dengan sintaks `myprogram +myoption myfile`, tetapi hal itu akan menyebabkan kebingungan karena ekspektasinya adalah kita menggunakan dashes.
> Dalam praktiknya, sebagian besar bahasa pemrograman menyediakan library parsing flag CLI (misalnya `argparse` di python untuk mengurai arguments dengan sintaks dash).

Konvensi umum lainnya dalam program CLI adalah program menerima sejumlah arguments variabel dengan tipe yang sama. Ketika diberikan arguments dengan cara ini, perintah melakukan operasi yang sama pada masing-masing argument.

```shell
mkdir src
mkdir docs
# is equivalent to
mkdir src docs
```

Syntax sugar ini mungkin tampak tidak perlu pada awalnya, tetapi menjadi sangat kuat ketika dikombinasikan dengan _globbing_.
Globbing atau globs adalah pola-pola khusus yang akan diekspansi oleh shell sebelum memanggil program.

Misalnya kita ingin menghapus semua file .py di folder saat ini secara non-rekursif. Dari apa yang kita pelajari di kuliah sebelumnya, kita dapat mencapainya dengan menjalankan

```shell
for file in $(ls | grep -P '\.py$'); do
    rm "$file"
done
```

Tapi kita bisa menggantinya dengan hanya `rm *.py`!

Ketika kita mengetik `rm *.py` ke terminal, shell tidak akan memanggil program `/bin/rm` dengan arguments `['*.py']`.
Sebaliknya, shell akan mencari file di folder saat ini yang cocok dengan pola `*.py` di mana `*` dapat mencocokkan string apa pun dengan nol atau lebih karakter tipe apa pun.
Jadi jika folder kita memiliki `main.py` dan `utils.py` maka program `rm` akan menerima arguments `['main.py', 'utils.py']`.

Globs yang paling umum Anda temukan adalah wildcard `*` (nol atau lebih dari apa pun), `?` (tepat satu dari apa pun) dan curly braces.
Curly braces `{}` mengekspansi daftar pola yang dipisahkan koma menjadi beberapa arguments.

Dalam praktiknya, globs paling baik dipahami dengan contoh-contoh yang motivatif.

```shell
touch folder/{a,b,c}.py
# Will expand to
touch folder/a.py folder/b.py folder/c.py

convert image.{png,jpg}
# Will expand to
convert image.png image.jpg

cp /path/to/project/{setup,build,deploy}.sh /newpath
# Will expand to
cp /path/to/project/setup.sh /path/to/project/build.sh /path/to/project/deploy.sh /newpath

# Globbing techniques can also be combined
mv *{.py,.sh} folder
# Will move all *.py and *.sh files
```

> Beberapa shell (misalnya zsh) mendukung bentuk globbing yang bahkan lebih canggih seperti `**` yang akan diekspansi untuk menyertakan path rekursif. Jadi `rm **/*.py` akan menghapus semua file .py secara rekursif.


## Streams

Setiap kali kita menjalankan pipeline program seperti

```shell
cat myfile | grep -P '\d+' | uniq -c
```

kita melihat bahwa program `grep` berkomunikasi dengan kedua program `cat` dan `uniq`.

Pengamatan penting di sini adalah bahwa ketiga program tersebut dijalankan secara bersamaan.
Artinya, shell tidak pertama-tama memanggil cat, lalu grep, lalu uniq.
Sebaliknya, ketiga program dijalankan dan shell menghubungkan output cat ke input grep dan output grep ke input uniq.
Ketika menggunakan operator pipe `|`, shell beroperasi pada stream data yang mengalir dari satu program ke program berikutnya dalam rantai.

Kita dapat mendemonstrasikan konkurensi ini, semua perintah dalam pipeline dimulai secara langsung:

```console
$ (sleep 15 && cat numbers.txt) | grep -P '^\d$' | sort | uniq  &
[1] 12345
$ ps | grep -P '(sleep|cat|grep|sort|uniq)'
  32930 pts/1    00:00:00 sleep
  32931 pts/1    00:00:00 grep
  32932 pts/1    00:00:00 sort
  32933 pts/1    00:00:00 uniq
  32948 pts/1    00:00:00 grep
```

Kita dapat melihat bahwa semua proses kecuali `cat` berjalan langsung. Shell menjalankan semua proses dan menghubungkan stream mereka sebelum ada yang selesai. `cat` baru akan dimulai setelah sleep selesai, dan output dari `cat` akan dikirim ke grep dan seterusnya.

Setiap program memiliki input stream, yang diberi label stdin (untuk standard input). Ketika melakukan piping, stdin terhubung secara otomatis. Dalam script, banyak program menerima `-` sebagai nama file yang berarti "baca dari stdin":

```shell
# These are equivalent when data comes from a pipe
echo "hello" | grep "hello"
echo "hello" | grep "hello" -
```

Demikian pula, setiap program memiliki dua output stream: stdout dan stderr.
Standard output adalah yang paling umum ditemui dan merupakan yang digunakan untuk piping output program ke perintah berikutnya dalam pipeline.
Standard error adalah stream alternatif yang ditujukan bagi program untuk melaporkan peringatan dan jenis masalah lainnya, tanpa output tersebut diurai oleh perintah berikutnya dalam rantai.

```console
$ ls /nonexistent
ls: cannot access '/nonexistent': No such file or directory
$ ls /nonexistent | grep "pattern"
ls: cannot access '/nonexistent': No such file or directory
# The error message still appears because stderr is not piped
$ ls /nonexistent 2>/dev/null
# No output - stderr was redirected to /dev/null
```

Shell menyediakan sintaks untuk me-redirect stream ini. Berikut beberapa contoh ilustratif.

```shell
# Redirect stdout to a file (overwrite)
echo "hello" > output.txt

# Redirect stdout to a file (append)
echo "world" >> output.txt

# Redirect stderr to a file
ls foobar 2> errors.txt

# Redirect both stdout and stderr to the same file
ls foobar &> all_output.txt

# Redirect stdin from a file
grep "pattern" < input.txt

# Discard output by redirecting to /dev/null
cmd > /dev/null 2>&1
```

Alat lain yang kuat yang mencerminkan filosofi Unix adalah [`fzf`](https://github.com/junegunn/fzf), sebuah fuzzy finder. Alat ini membaca baris dari stdin dan menyediakan antarmuka interaktif untuk memfilter dan memilih:

```console
$ ls | fzf
$ cat ~/.bash_history | fzf
```

`fzf` dapat diintegrasikan dengan banyak operasi shell. Kita akan melihat lebih banyak penggunaannya ketika kita membahas kustomisasi shell.


## Environment variables

Untuk menetapkan variabel dalam bash kita menggunakan sintaks `foo=bar`, dan kemudian mengakses nilai variabel tersebut dengan sintaks `$foo`.
Perhatikan bahwa `foo = bar` adalah sintaks yang tidak valid karena shell akan mengurainya sebagai memanggil program `foo` dengan arguments `['=', 'bar']`.
Dalam shell scripting, peran karakter spasi adalah untuk melakukan pemisahan arguments.
Perilaku ini bisa membingungkan dan butuh waktu untuk membiasakan diri, jadi ingatlah hal ini.

Variabel shell tidak memiliki tipe, semuanya adalah string.
Perhatikan bahwa ketika menulis ekspresi string dalam shell, tanda kutip tunggal dan tanda kutip ganda tidak dapat dipertukarkan.
String yang dibatasi dengan `'` adalah string literal dan tidak akan mengekspansi variabel, melakukan substitusi perintah, atau memproses escape sequence, sedangkan string yang dibatasi dengan `"` akan melakukannya.

```shell
foo=bar
echo "$foo"
# prints bar
echo '$foo'
# prints $foo
```

Untuk menangkap output dari sebuah perintah ke dalam variabel kita menggunakan _command substitution_.
Ketika kita menjalankan
```shell
files=$(ls)
echo "$files" | grep README
echo "$files" | grep ".py"
```
output (secara konkret stdout) dari ls ditempatkan ke dalam variabel `$files` yang dapat kita akses nanti.
Isi dari variabel `$files` memang menyertakan newline dari output ls, yang merupakan cara program seperti `grep` mengetahui untuk beroperasi pada setiap item secara independen.

Fitur serupa yang kurang dikenal adalah _process substitution_, `<( CMD )` akan menjalankan `CMD` dan menempatkan output dalam file sementara dan mensubstitusi `<()` dengan nama file tersebut.
Ini berguna ketika perintah mengharapkan nilai diberikan melalui file bukan melalui STDIN.
Sebagai contoh, `diff <(ls src) <(ls docs)` akan menunjukkan perbedaan antara file-file di direktori `src` dan `docs`.

Setiap kali program shell memanggil program lain, ia mengirimkan seperangkat variabel yang sering disebut sebagai _environment variables_.
Dari dalam shell kita dapat menemukan environment variables saat ini dengan menjalankan `printenv`.
Untuk memberikan environment variable secara eksplisit kita dapat mendahului perintah dengan penetapan variabel

> Environment variables secara konvensi ditulis dalam ALL_CAPS (misalnya, `HOME`, `PATH`, `DEBUG`). Ini adalah konvensi, bukan persyaratan teknis, tetapi mengikutinya membantu membedakan environment variables dari variabel shell lokal yang biasanya menggunakan huruf kecil.

```shell
TZ=Asia/Tokyo date  # prints the current time in Tokyo
echo $TZ  # this will be empty, since TZ was only set for the child command
```

Sebagai alternatif, kita dapat menggunakan fungsi built-in `export` yang akan memodifikasi environment saat ini sehingga semua child process akan mewarisi variabel tersebut:

```shell
export DEBUG=1
# All programs from this point onwards will have DEBUG=1 in their environment
bash -c 'echo $DEBUG'
# prints 1
```

Untuk menghapus variabel gunakan perintah built-in `unset`, misalnya `unset DEBUG`.

> Environment variables adalah konvensi shell lainnya. Mereka dapat digunakan untuk memodifikasi perilaku banyak program secara implisit daripada eksplisit. Sebagai contoh, shell menetapkan environment variable `$HOME` dengan path folder home pengguna saat ini. Kemudian program dapat mengakses variabel ini untuk mendapatkan informasi tersebut daripada memerlukan `--home /home/alice` secara eksplisit. Contoh umum lainnya adalah `$TZ`, yang digunakan banyak program untuk memformat tanggal dan waktu sesuai zona waktu yang ditentukan.

## Return codes

Seperti yang kita lihat sebelumnya, output utama dari program shell disampaikan melalui stream stdout/stderr dan efek samping filesystem.

Secara default, shell script akan mengembalikan exit code nol.
Konvensinya adalah nol berarti semuanya berjalan dengan baik sedangkan bukan-nol berarti ada beberapa masalah yang ditemui.
Untuk mengembalikan exit code bukan-nol kita harus menggunakan built-in shell `exit NUM`.
Kita dapat mengakses return code dari perintah terakhir yang dijalankan dengan mengakses variabel khusus `$?`.

Shell memiliki operator boolean `&&` dan `||` untuk melakukan operasi AND dan OR masing-masing.
Berbeda dengan yang ditemui dalam bahasa pemrograman biasa, yang di shell beroperasi pada return code program.
Keduanya adalah operator [short-circuiting](https://en.wikipedia.org/wiki/Short-circuit_evaluation).
Ini berarti keduanya dapat digunakan untuk menjalankan perintah secara kondisional berdasarkan keberhasilan atau kegagalan perintah sebelumnya, di mana keberhasilan ditentukan berdasarkan apakah return code-nya nol atau bukan. Beberapa contoh:

```shell
# echo will only run if grep succeeds (finds a match)
grep -q "pattern" file.txt && echo "Pattern found"

# echo will only run if grep fails (no match)
grep -q "pattern" file.txt || echo "Pattern not found"

# true is a shell program that always succeeds
true && echo "This will always print"

# and false is a shell program that always fails
false || echo "This will always print"
```

Prinsip yang sama berlaku untuk pernyataan `if` dan `while`, keduanya menggunakan return code untuk membuat keputusan:

```shell
# if uses the return code of the condition command (0 = true, nonzero = false)
if grep -q "pattern" file.txt; then
    echo "Found"
fi

# while loops continue as long as the command returns 0
while read line; do
    echo "$line"
done < file.txt
```

## Signals

Dalam beberapa kasus Anda perlu menginterupsi program saat sedang berjalan, misalnya jika sebuah perintah memakan waktu terlalu lama untuk selesai.
Cara termudah untuk menginterupsi program adalah dengan menekan `Ctrl-C` dan perintah tersebut mungkin akan berhenti.
Tetapi bagaimana cara kerja sebenarnya dan mengapa terkadang gagal menghentikan proses?

```console
$ sleep 100
^C
$
```

> Perhatikan, di sini `^C` adalah cara `Ctrl-C` ditampilkan ketika diketik di terminal.

Di balik layar, yang terjadi adalah sebagai berikut:

1. Kita menekan `Ctrl-C`
2. Shell mengidentifikasi kombinasi karakter khusus
3. Proses shell mengirimkan sinyal SIGINT ke proses `sleep`
4. Sinyal tersebut menginterupsi eksekusi proses `sleep`

Signals adalah mekanisme komunikasi khusus.
Ketika sebuah proses menerima sinyal, ia menghentikan eksekusinya, menangani sinyal tersebut dan mungkin mengubah alur eksekusi berdasarkan informasi yang disampaikan oleh sinyal tersebut. Karena alasan ini, signals adalah _software interrupts_.


Dalam kasus kita, ketika mengetik `Ctrl-C` ini memicu shell untuk mengirimkan sinyal `SIGINT` ke proses.
Berikut adalah contoh minimal program Python yang menangkap `SIGINT` dan mengabaikannya, sehingga tidak lagi berhenti. Untuk menghentikan program ini sekarang kita dapat menggunakan sinyal `SIGQUIT` sebagai gantinya, dengan mengetik `Ctrl-\`.

```python
#!/usr/bin/env python
import signal, time

def handler(signum, time):
    print("\nI got a SIGINT, but I am not stopping")

signal.signal(signal.SIGINT, handler)
i = 0
while True:
    time.sleep(.1)
    print("\r{}".format(i), end="")
    i += 1
```

Berikut yang terjadi jika kita mengirimkan `SIGINT` dua kali ke program ini, diikuti oleh `SIGQUIT`. Perhatikan bahwa `^` adalah cara `Ctrl` ditampilkan ketika diketik di terminal.

```console
$ python sigint.py
24^C
I got a SIGINT, but I am not stopping
26^C
I got a SIGINT, but I am not stopping
30^\[1]    39913 quit       python sigint.py
```

Meskipun `SIGINT` dan `SIGQUIT` keduanya biasanya terkait dengan permintaan terminal, sinyal yang lebih umum untuk meminta proses keluar dengan baik adalah sinyal `SIGTERM`.
Untuk mengirimkan sinyal ini kita dapat menggunakan perintah [`kill`](https://www.man7.org/linux/man-pages/man1/kill.1.html), dengan sintaks `kill -TERM <PID>`.

Signals dapat melakukan hal lain selain menghentikan proses. Misalnya, `SIGSTOP` menjeda proses. Di terminal, mengetik `Ctrl-Z` akan memicu shell untuk mengirimkan sinyal `SIGTSTP`, singkatan dari Terminal Stop (yaitu versi `SIGSTOP` dari terminal).

Kita kemudian dapat melanjutkan pekerjaan yang dijeda di foreground atau di background menggunakan [`fg`](https://www.man7.org/linux/man-pages/man1/fg.1p.html) atau [`bg`](https://man7.org/linux/man-pages/man1/bg.1p.html), masing-masing.

Perintah [`jobs`](https://www.man7.org/linux/man-pages/man1/jobs.1p.html) mencantumkan pekerjaan yang belum selesai yang terkait dengan sesi terminal saat ini.
Anda dapat merujuk ke pekerjaan tersebut menggunakan pid mereka (Anda dapat menggunakan [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) untuk mengetahuinya).
Secara lebih intuitif, Anda juga dapat merujuk ke proses menggunakan simbol persen diikuti dengan nomor pekerjaan mereka (ditampilkan oleh `jobs`). Untuk merujuk ke pekerjaan terakhir yang di-background Anda dapat menggunakan parameter khusus `$!`.

Satu hal lagi yang perlu diketahui adalah bahwa suffix `&` dalam perintah akan menjalankan perintah di background, memberikan Anda prompt kembali, meskipun tetap menggunakan STDOUT shell yang bisa mengganggu (gunakan shell redirections dalam kasus tersebut). Setara dengan itu, untuk mem-background program yang sedang berjalan Anda dapat melakukan `Ctrl-Z` diikuti dengan `bg`.


Perhatikan bahwa proses yang di-background masih merupakan child process dari terminal Anda dan akan mati jika Anda menutup terminal (ini akan mengirimkan sinyal lain, `SIGHUP`).
Untuk mencegah hal itu terjadi Anda dapat menjalankan program dengan [`nohup`](https://www.man7.org/linux/man-pages/man1/nohup.1.html) (wrapper untuk mengabaikan `SIGHUP`), atau gunakan `disown` jika proses sudah dimulai.
Sebagai alternatif, Anda dapat menggunakan terminal multiplexer seperti yang akan kita lihat di bagian berikutnya.

Berikut adalah contoh sesi untuk memperlihatkan beberapa konsep ini.

```
$ sleep 1000
^Z
[1]  + 18653 suspended  sleep 1000

$ nohup sleep 2000 &
[2] 18745
appending output to nohup.out

$ jobs
[1]  + suspended  sleep 1000
[2]  - running    nohup sleep 2000

$ kill -SIGHUP %1
[1]  + 18653 hangup     sleep 1000

$ kill -SIGHUP %2   # nohup protects from SIGHUP

$ jobs
[2]  + running    nohup sleep 2000

$ kill %2
[2]  + 18745 terminated  nohup sleep 2000
```

Sinyal khusus adalah `SIGKILL` karena tidak dapat ditangkap oleh proses dan akan selalu menghentikannya secara langsung. Namun, ini bisa memiliki efek samping yang buruk seperti meninggalkan child process yatim piatu.

Anda dapat mempelajari lebih lanjut tentang sinyal-sinyal ini dan sinyal lainnya [di sini](https://en.wikipedia.org/wiki/Signal_(IPC)) atau dengan mengetik [`man signal`](https://www.man7.org/linux/man-pages/man7/signal.7.html) atau `kill -l`.

Dalam shell script, Anda dapat menggunakan built-in `trap` untuk menjalankan perintah ketika sinyal diterima. Ini berguna untuk operasi pembersihan:

```shell
#!/usr/bin/env bash
cleanup() {
    echo "Cleaning up temporary files..."
    rm -f /tmp/mytemp.*
}
trap cleanup EXIT  # Run cleanup when script exits
trap cleanup SIGINT SIGTERM  # Also on Ctrl-C or kill
```
{% comment %}
### Users, Files and Permissions

Lastly, another way programs have to indirectly communicate with each other is using files.
For a program to be able to correctly read/write/delete files and folders, the file permissions must allow the operation.

Listing a specific file will give the following output

```console
$ ls -l notes.txt
-rw-r--r--  1 alice  users  12693 Jan 11 23:05 notes.txt
```

Here `ls` is listing what is the owner of the file, user `alice`, and the group `users`. Then the `rw-r--r--` are a shorthand notation for the permissions.
In this case, the file `notes.txt` has read/write permissions for the user alice `rw-`, and only read permissions for the group and the rest of users in the file system.

```console
$ ./script.sh
# permission denied
$ chmod +x script.sh
$ ls -l script.sh
-rwxr-xr-x  1 alice  users  3125 Jan 11 23:07 script.sh
$ ./script.sh
```

For a script to be executable, the executable rights must be set, hence why we had to use the `chmod` (change mode) program.
`chmod` syntax, while intuitive, is not obvious when first encountered.
If you, like me, prefer to learn by example, this is a good usecase of the `tldr` tool (note that you need to install it first).

```console
❯ tldr chmod
  Change the access permissions of a file or directory.
  More information: <https://www.gnu.org/software/coreutils/chmod>.

  Give the [u]ser who owns a file the right to e[x]ecute it:

      chmod u+x path/to/file

  Give the [u]ser rights to [r]ead and [w]rite to a file/directory:

      chmod u+rw path/to/file_or_directory

  Give [a]ll users rights to [r]ead and e[x]ecute:

      chmod a+rx path/to/file
```

Run `tldr chmod` to see more examples, including recursive operations and group permissions.

> Your shell might show you something like `command not found: tldr`. That is because it is a more modern tool and it is not pre-installed in most systems. A good reference for how to install tools is the [https://command-not-found.com](https://command-not-found.com) website. It contains instructions for a huge collection of CLI tools for popular OS distributions.

Each program is run as a specific user in the system. We can use the `whoami` command to find our user name and `id -u` to find our UID (user id) which is the integer value that the OS associates with the user.

When running `sudo command`, the `command` is run as the root user which can bypass most permissions in the system.
Try running `sudo whoami` and `sudo id -u` to see how the output changes (you might be prompted for your password).
To change the owner of a file or folder, we use the `chown` command.

You can learn more about UNIX file permissions [here](https://en.wikipedia.org/wiki/File-system_permissions#Traditional_Unix_permissions)

So far we've focused on your local machine, but many of these skills become even more valuable when working with remote servers.

{% endcomment %}

# Mesin Remote

Semakin umum bagi programmer untuk bekerja dengan server remote dalam pekerjaan sehari-hari mereka. Alat yang paling umum untuk tugas ini adalah SSH (Secure Shell) yang akan membantu kita terhubung ke server remote dan menyediakan antarmuka shell yang sekarang sudah familiar. Kita terhubung ke server dengan perintah seperti:

```bash
ssh alice@server.mit.edu
```

Di sini kita mencoba ssh sebagai user `alice` di server `server.mit.edu`.

Fitur `ssh` yang sering terlewatkan adalah kemampuan untuk menjalankan perintah secara non-interaktif. `ssh` menangani pengiriman stdin dan penerimaan stdout dari perintah dengan benar, sehingga kita dapat menggabungkannya dengan perintah lain

```shell
# here ls runs in the remote, and wc runs locally
ssh alice@server ls | wc -l

# here both ls and wc run in the server
ssh alice@server 'ls | wc -l'

```

> Cobalah menginstal [Mosh](https://mosh.org/) sebagai pengganti SSH yang dapat menangani diskoneksi, masuk/keluar sleep, berpindah jaringan dan menangani link dengan latensi tinggi.

Agar `ssh` mengizinkan kita menjalankan perintah di server remote, kita perlu membuktikan bahwa kita berwenang untuk melakukannya.
Kita dapat melakukannya melalui password atau ssh key.
Autentikasi berbasis key menggunakan public-key cryptography untuk membuktikan kepada server bahwa klien memiliki secret private key tanpa mengungkapkan key tersebut.
Autentikasi berbasis key lebih nyaman dan lebih aman, jadi Anda sebaiknya lebih memilihnya.
Perhatikan bahwa private key (sering `~/.ssh/id_rsa` dan yang lebih baru `~/.ssh/id_ed25519`) secara efektif adalah password Anda, jadi perlakukan seperti itu dan jangan pernah membagikan isinya.

Untuk menghasilkan pair Anda dapat menjalankan [`ssh-keygen`](https://www.man7.org/linux/man-pages/man1/ssh-keygen.1.html).
```bash
ssh-keygen -a 100 -t ed25519 -f ~/.ssh/id_ed25519
```

Jika Anda pernah mengonfigurasi push ke GitHub menggunakan SSH key, maka Anda mungkin sudah melakukan langkah-langkah yang diuraikan [di sini](https://help.github.com/articles/connecting-to-github-with-ssh/) dan sudah memiliki pasangan key yang valid. Untuk memeriksa apakah Anda memiliki passphrase dan memvalidasinya Anda dapat menjalankan `ssh-keygen -y -f /path/to/key`.

Di sisi server `ssh` akan melihat `.ssh/authorized_keys` untuk menentukan klien mana yang seharusnya diizinkan masuk. Untuk menyalin public key Anda dapat menggunakan:

```bash
cat .ssh/id_ed25519.pub | ssh alice@remote 'cat >> ~/.ssh/authorized_keys'

# or more simply (if ssh-copy-id is available)

ssh-copy-id -i .ssh/id_ed25519 alice@remote
```

Selain menjalankan perintah, koneksi yang dibentuk ssh dapat digunakan untuk mentransfer file dari dan ke server secara aman. [`scp`](https://www.man7.org/linux/man-pages/man1/scp.1.html) adalah alat yang paling tradisional dan sintaksnya adalah `scp path/to/local_file remote_host:path/to/remote_file`. [`rsync`](https://www.man7.org/linux/man-pages/man1/rsync.1.html) meningkatkan `scp` dengan mendeteksi file yang identik di lokal dan remote, dan mencegah penyalinan ulang. Ini juga menyediakan kontrol yang lebih terperinci atas symlink, permission, dan memiliki fitur tambahan seperti flag `--partial` yang dapat melanjutkan salinan yang sebelumnya terinterupsi. `rsync` memiliki sintaks yang mirip dengan `scp`.

Konfigurasi klien SSH terletak di `~/.ssh/config` dan memungkinkan kita mendeklarasikan host dan menetapkan pengaturan default untuk mereka. File konfigurasi ini tidak hanya dibaca oleh `ssh` tetapi juga program lain seperti `scp`, `rsync`, `mosh`, &c.

```bash
Host vm
    User alice
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519

# Configs can also take wildcards
Host *.mit.edu
    User alice
```




# Terminal Multiplexer

Ketika menggunakan command-line interface Anda sering ingin menjalankan lebih dari satu hal sekaligus.
Misalnya, Anda mungkin ingin menjalankan editor dan program Anda secara berdampingan.
Meskipun ini dapat dicapai dengan membuka jendela terminal baru, menggunakan terminal multiplexer adalah solusi yang lebih fleksibel.

Terminal multiplexer seperti [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) memungkinkan Anda melakukan multiplex jendela terminal menggunakan pane dan tab sehingga Anda dapat berinteraksi dengan beberapa sesi shell secara efisien.
Selain itu, terminal multiplexer memungkinkan Anda melepas sesi terminal saat ini dan menghubungkannya kembali di kemudian waktu.
Karena ini, terminal multiplexer sangat nyaman ketika bekerja dengan mesin remote, karena menghindari kebutuhan untuk menggunakan `nohup` dan trik-trik serupa.

Terminal multiplexer yang paling populer saat ini adalah [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html). `tmux` sangat dapat dikonfigurasi dan dengan menggunakan keybinding yang terkait Anda dapat membuat beberapa tab dan pane serta menavigasi dengan cepat.

`tmux` mengharapkan Anda mengetahui keybinding-nya, dan semuanya memiliki bentuk `<C-b> x` yang berarti (1) tekan `Ctrl+b`, (2) lepaskan `Ctrl+b`, lalu (3) tekan `x`. `tmux` memiliki hierarki objek berikut:
- **Sessions** - sebuah session adalah workspace independen dengan satu atau lebih window
    + `tmux` memulai session baru.
    + `tmux new -s NAME` memulainya dengan nama tersebut.
    + `tmux ls` mencantumkan session saat ini
    + Dalam `tmux` mengetik `<C-b> d`  melepas session saat ini
    + `tmux a` menghubungkan session terakhir. Anda dapat menggunakan flag `-t` untuk menentukan yang mana

- **Windows** - Setara dengan tab di editor atau browser, mereka adalah bagian visual yang terpisah dari session yang sama
    + `<C-b> c` Membuat window baru. Untuk menutupnya Anda cukup menghentikan shell dengan `<C-d>`
    + `<C-b> N` Pergi ke window ke-_N_. Perhatikan mereka diberi nomor
    + `<C-b> p` Pergi ke window sebelumnya
    + `<C-b> n` Pergi ke window berikutnya
    + `<C-b> ,` Mengubah nama window saat ini
    + `<C-b> w` Mencantumkan window saat ini

- **Panes** - Seperti vim splits, pane memungkinkan Anda memiliki beberapa shell dalam tampilan visual yang sama.
    + `<C-b> "` Membelah pane saat ini secara horizontal
    + `<C-b> %` Membelah pane saat ini secara vertikal
    + `<C-b> <direction>` Pindah ke pane di _arah_ yang ditentukan. Direction di sini berarti tombol panah.
    + `<C-b> z` Toggle zoom untuk pane saat ini
    + `<C-b> [` Memulai scrollback. Anda kemudian dapat menekan `<space>` untuk memulai seleksi dan `<enter>` untuk menyalin seleksi tersebut.
    + `<C-b> <space>` Berpindah melalui susunan pane.

> Untuk mempelajari lebih lanjut tentang tmux, pertimbangkan untuk membaca tutorial singkat [ini](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) dan penjelasan yang lebih detail [ini](https://linuxcommand.org/lc3_adv_termmux.php).

Dengan tmux dan SSH dalam toolkit Anda, Anda ingin membuat lingkungan Anda terasa seperti di rumah di mesin mana pun. Di situlah kustomisasi shell berperan.

# Kustomisasi Shell

Berbagai macam program command-line dikonfigurasi menggunakan file teks biasa yang dikenal sebagai _dotfiles_
(karena nama file dimulai dengan `.`, misalnya `~/.vimrc`, sehingga mereka
tersembunyi dalam daftar direktori `ls` secara default).

> Dotfiles adalah konvensi shell lainnya. Titik di depan adalah untuk "menyembunyikan" mereka saat melakukan daftar (ya, konvensi lainnya).

Shell adalah salah satu contoh program yang dikonfigurasi dengan file seperti ini. Saat startup, shell Anda akan membaca banyak file untuk memuat konfigurasinya.
Tergantung pada shell dan apakah Anda memulai sesi login dan/atau interaktif, keseluruhan proses bisa cukup kompleks.
[Di sini](https://web.archive.org/web/20260329133158/https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) adalah sumber daya yang sangat baik tentang topik ini.

Untuk `bash`, mengedit `.bashrc` atau `.bash_profile` Anda akan berfungsi di sebagian besar sistem.
Beberapa contoh lain alat yang dapat dikonfigurasi melalui dotfiles adalah:

- `bash` - `~/.bashrc`, `~/.bash_profile`
- `git` - `~/.gitconfig`
- `vim` - `~/.vimrc` dan folder `~/.vim`
- `ssh` - `~/.ssh/config`
- `tmux` - `~/.tmux.conf`

Perubahan konfigurasi yang umum adalah menambahkan lokasi baru untuk shell menemukan program. Anda akan menemui pola ini saat menginstal perangkat lunak:

```shell
export PATH="$PATH:path/to/append"
```

Di sini, kita memberitahu shell untuk menetapkan nilai variabel $PATH ke nilai saat ini ditambah path baru, dan membuat semua child process mewarisi nilai baru untuk PATH ini.
Ini akan memungkinkan child process untuk menemukan program yang terletak di bawah `path/to/append`.


Kustomisasi shell sering berarti menginstal alat command-line baru. Package manager memudahkan hal ini. Mereka menangani pengunduhan, pemasangan, dan pembaruan perangkat lunak. Sistem operasi yang berbeda memiliki package manager yang berbeda: macOS menggunakan [Homebrew](https://brew.sh/), Ubuntu/Debian menggunakan `apt`, Fedora menggunakan `dnf`, dan Arch menggunakan `pacman`. Kita akan membahas package manager lebih mendalam di kuliah shipping code.

Berikut cara menginstal dua alat yang berguna menggunakan Homebrew di macOS:

```shell
# ripgrep: a faster grep with better defaults
brew install ripgrep

# fd: a faster, user-friendly find
brew install fd
```

Dengan ini terinstal, Anda dapat menggunakan `rg` sebagai pengganti `grep` dan `fd` sebagai pengganti `find`.

> **Peringatan tentang `curl | bash`**: Anda sering akan melihat instruksi instalasi seperti `curl -fsSL https://example.com/install.sh | bash`. Pola ini mengunduh script dan segera mengeksekusinya, yang nyaman tetapi berisiko; Anda menjalankan kode yang belum Anda periksa. Pendekatan yang lebih aman adalah mengunduh terlebih dahulu, meninjau, lalu mengeksekusi:
> ```shell
> curl -fsSL https://example.com/install.sh -o install.sh
> less install.sh  # review the script
> bash install.sh
> ```
> Beberapa installer menggunakan varian yang sedikit lebih aman: `/bin/bash -c "$(curl -fsSL https://url)"` yang setidaknya memastikan bash menafsirkan script tersebut daripada shell Anda saat ini.

Ketika Anda mencoba menjalankan perintah yang belum terinstal, shell Anda akan menampilkan `command not found`. Situs web [command-not-found.com](https://command-not-found.com) adalah sumber daya bermanfaat yang dapat Anda gunakan untuk mencari perintah apa pun dan mengetahui cara menginstalnya di berbagai package manager dan distribusi.

Alat lain yang berguna adalah [`tldr`](https://tldr.sh/), yang menyediakan halaman man yang disederhanakan dan berfokus pada contoh. Alih-alih membaca dokumentasi yang panjang, Anda dapat dengan cepat melihat pola penggunaan umum:

```console
$ tldr fd
  An alternative to find.
  Aims to be faster and easier to use than find.

  Recursively find files matching a pattern in the current directory:
      fd "pattern"

  Find files that begin with "foo":
      fd "^foo"

  Find files with a specific extension:
      fd --extension txt
```

Terkadang Anda tidak membutuhkan program baru sepenuhnya, melainkan hanya pintasan untuk perintah yang sudah ada dengan flag tertentu. Di situlah alias berperan.

Kita juga dapat membuat alias perintah kita sendiri menggunakan built-in shell `alias`.
Alias shell adalah bentuk pendek untuk perintah lain yang akan diganti oleh shell secara otomatis sebelum mengevaluasi ekspresi.
Misalnya, alias dalam bash memiliki struktur berikut:

```bash
alias alias_name="command_to_alias arg1 arg2"
```

> Perhatikan bahwa tidak ada spasi di sekitar tanda sama dengan `=`, karena [`alias`](https://www.man7.org/linux/man-pages/man1/alias.1p.html) adalah perintah shell yang menerima satu argument.

Alias memiliki banyak fitur yang nyaman:

```bash
# Make shorthands for common flags
alias ll="ls -lh"

# Save a lot of typing for common commands
alias gs="git status"
alias gc="git commit"

# Save you from mistyping
alias sl=ls

# Overwrite existing commands for better defaults
alias mv="mv -i"           # -i prompts before overwrite
alias mkdir="mkdir -p"     # -p make parent dirs as needed
alias df="df -h"           # -h prints human readable format

# Alias can be composed
alias la="ls -A"
alias lla="la -l"

# To ignore an alias run it prepended with \
\ls
# Or disable an alias altogether with unalias
unalias la

# To get an alias definition just call it with alias
alias ll
# Will print ll='ls -lh'
```

Alias memiliki keterbatasan: mereka tidak dapat mengambil arguments di tengah perintah. Untuk perilaku yang lebih kompleks, Anda sebaiknya menggunakan fungsi shell.

Sebagian besar shell mendukung `Ctrl-R` untuk pencarian history terbalik. Ketik `Ctrl-R` dan mulai mengetik untuk mencari melalui perintah sebelumnya. Sebelumnya kita memperkenalkan `fzf` sebagai fuzzy finder; dengan integrasi shell fzf yang dikonfigurasi, `Ctrl-R` menjadi pencarian fuzzy interaktif melalui seluruh history Anda, jauh lebih kuat dari default.

Bagaimana sebaiknya Anda mengatur dotfiles Anda? Mereka harus berada di folder mereka sendiri,
di bawah version control, dan **di-symlink** ke tempatnya menggunakan script. Ini memiliki
keuntungan:

- **Instalasi mudah**: jika Anda login ke mesin baru, menerapkan
kustomisasi Anda hanya akan memakan waktu satu menit.
- **Portabilitas**: alat Anda akan bekerja dengan cara yang sama di mana saja.
- **Sinkronisasi**: Anda dapat memperbarui dotfiles Anda di mana saja dan menjaga semuanya
tetap sinkron.
- **Pelacakan perubahan**: Anda mungkin akan memelihara dotfiles Anda
selama seluruh karir pemrograman Anda, dan riwayat versi berguna untuk
proyek jangka panjang.

Apa yang harus Anda masukkan ke dotfiles Anda?
Anda dapat mempelajari tentang pengaturan alat Anda dengan membaca dokumentasi online atau
[man pages](https://en.wikipedia.org/wiki/Man_page). Cara hebat lainnya adalah
mencari di internet untuk posting blog tentang program tertentu, di mana penulis akan
memberitahu Anda tentang kustomisasi pilihan mereka. Cara lain untuk mempelajari
kustomisasi adalah dengan melihat dotfiles orang lain: Anda dapat menemukan banyak
[repository
dotfiles](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories)
di GitHub --- lihat yang paling populer
[di sini](https://github.com/mathiasbynens/dotfiles) (kami menyarankan Anda untuk tidak
menyalin konfigurasi secara membabi buta).
[Di sini](https://dotfiles.github.io/) adalah sumber daya bagus lainnya tentang topik ini.

Semua instruktur kelas memiliki dotfiles mereka yang dapat diakses secara publik di GitHub: [Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/jjgo/dotfiles).

**Framework dan plugin** juga dapat meningkatkan shell Anda. Beberapa framework umum yang populer adalah [prezto](https://github.com/sorin-ionescu/prezto) atau [oh-my-zsh](https://ohmyz.sh/), dan plugin yang lebih kecil yang berfokus pada fitur tertentu:

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - mewarnai perintah valid/invalid saat Anda mengetik
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - menyarankan perintah dari history saat Anda mengetik
- [zsh-completions](https://github.com/zsh-users/zsh-completions) - definisi completion tambahan
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) - pencarian history seperti fish
- [powerlevel10k](https://github.com/romkatv/powerlevel10k) - tema prompt yang cepat dan dapat dikustomisasi

Shell seperti [fish](https://fishshell.com/) menyertakan banyak fitur ini secara default.

> Anda tidak memerlukan framework besar seperti oh-my-zsh untuk mendapatkan fitur-fitur ini. Menginstal plugin individual sering kali lebih cepat dan memberi Anda lebih banyak kontrol. Framework besar dapat secara signifikan memperlambat waktu startup shell, jadi pertimbangkan untuk menginstal hanya yang benar-benar Anda gunakan.


# AI di Shell

Ada banyak cara untuk mengintegrasikan alat AI di shell. Berikut beberapa contoh pada tingkat integrasi yang berbeda:

**Pembuatan perintah**: Alat seperti [`simonw/llm`](https://github.com/simonw/llm) dapat membantu menghasilkan perintah shell dari deskripsi bahasa alami:

```console
$ llm cmd "find all python files modified in the last week"
find . -name "*.py" -mtime -7
```

**Integrasi pipeline**: LLM dapat diintegrasikan ke dalam pipeline shell untuk memproses dan mengubah data. Mereka sangat berguna ketika Anda perlu mengekstrak informasi dari format yang tidak konsisten di mana regex akan menyakitkan:

```console
$ cat users.txt
Contact: john.doe@example.com
User 'alice_smith' logged in at 3pm
Posted by: @bob_jones on Twitter
Author: Jane Doe (jdoe)
Message from mike_wilson yesterday
Submitted by user: sarah.connor
$ INSTRUCTIONS="Extract just the username from each line, one per line, nothing else"
$ llm "$INSTRUCTIONS" < users.txt
john.doe
alice_smith
bob_jones
jdoe
mike_wilson
sarah.connor
```

Perhatikan bagaimana kita menggunakan `"$INSTRUCTIONS"` (dengan tanda kutip) karena variabel berisi spasi, dan `< users.txt` untuk me-redirect konten file ke stdin.

**Shell AI**: Alat seperti [Claude Code](https://docs.anthropic.com/en/docs/claude-code) bertindak sebagai meta-shell yang menerima perintah bahasa Inggris dan menerjemahkannya menjadi operasi shell, edit file, dan tugas multi-langkah yang lebih kompleks.

# Terminal Emulator

Bersamaan dengan mengkustomisasi shell Anda, ada baiknya meluangkan waktu untuk memilih **terminal emulator** dan pengaturannya.
Terminal emulator adalah program GUI yang menyediakan antarmuka berbasis teks tempat shell Anda berjalan.
Ada banyak terminal emulator di luar sana.

Karena Anda mungkin menghabiskan ratusan hingga ribuan jam di terminal Anda, ada baiknya untuk menyelidiki pengaturannya. Beberapa aspek yang mungkin ingin Anda modifikasi di terminal Anda meliputi:

- Pilihan font
- Skema warna
- Pintasan keyboard
- Dukungan tab/pane
- Konfigurasi scrollback
- Performa (beberapa terminal yang lebih baru seperti [Alacritty](https://github.com/alacritty/alacritty) atau [Ghostty](https://ghostty.org/) menawarkan akselerasi GPU).



# Latihan

## Arguments dan Globs

1. Anda mungkin melihat perintah seperti `cmd --flag -- --notaflag`. `--` adalah argument khusus yang memberitahu program untuk berhenti mem-parsing flag. Semua yang setelah `--` diperlakukan sebagai argument posisional. Mengapa ini berguna? Cobalah menjalankan `touch -- -myfile` dan kemudian menghapusnya tanpa `--`.

1. Baca [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) dan tulis perintah `ls` yang mencantumkan file dengan cara berikut:
    - Menyertakan semua file, termasuk file tersembunyi
    - Ukuran ditampilkan dalam format yang mudah dibaca (misalnya 454M bukan 454279954)
    - File diurutkan berdasarkan yang paling baru
    - Output diberi warna

    Contoh output akan terlihat seperti ini:

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

1. Process substitution `<(command)` memungkinkan Anda menggunakan output perintah seolah-olah itu adalah file. Gunakan `diff` dengan process substitution untuk membandingkan output `printenv` dan `export`. Mengapa mereka berbeda? (Petunjuk: coba `diff <(printenv | sort) <(export | sort)`).

## Variabel Lingkungan

1. Tulis fungsi bash `marco` dan `polo` yang melakukan hal berikut: setiap kali Anda menjalankan `marco` direktori kerja saat ini harus disimpan dengan cara tertentu, kemudian ketika Anda menjalankan `polo`, tidak peduli di direktori mana Anda berada, `polo` harus melakukan `cd` mengembalikan Anda ke direktori tempat Anda menjalankan `marco`. Untuk memudahkan debugging Anda dapat menulis kode dalam file `marco.sh` dan (re)load definisi ke shell Anda dengan menjalankan `source marco.sh`.

{% comment %}
marco() {
    export MARCO=$(pwd)
}

polo() {
    cd "$MARCO"
}
{% endcomment %}

## Return Codes

1. Katakan Anda memiliki perintah yang jarang gagal. Untuk men-debug-nya Anda perlu menangkap outputnya tetapi bisa memakan waktu lama untuk mendapatkan hasil yang gagal. Tulis script bash yang menjalankan script berikut sampai gagal dan menangkap standard output dan error stream ke file dan mencetak semuanya di akhir. Nilai tambah jika Anda juga dapat melaporkan berapa kali percobaan yang diperlukan sampai script gagal.

    ```bash
    #!/usr/bin/env bash

    n=$(( RANDOM % 100 ))

    if [[ $n -eq 42 ]]; then
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

## Signals dan Job Control

1. Jalankan pekerjaan `sleep 10000` di terminal, background-kan dengan `Ctrl-Z` dan lanjutkan eksekusinya dengan `bg`. Sekarang gunakan [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) untuk menemukan pid-nya dan [`pkill`](https://man7.org/linux/man-pages/man1/pgrep.1.html) untuk menghentikannya tanpa pernah mengetik pid itu sendiri. (Petunjuk: gunakan flag `-lf`).

1. Katakan Anda tidak ingin memulai sebuah proses sampai proses lain selesai. Bagaimana cara Anda melakukannya? Dalam latihan ini, proses pembatas kita akan selalu menjadi `sleep 60 &`. Salah satu cara untuk mencapainya adalah dengan menggunakan perintah [`wait`](https://www.man7.org/linux/man-pages/man1/wait.1p.html). Cobalah meluncurkan perintah sleep dan membuat `ls` menunggu sampai proses background selesai.

    Namun, strategi ini akan gagal jika kita memulai di sesi bash yang berbeda, karena `wait` hanya berfungsi untuk child process. Satu fitur yang tidak kita bahas dalam catatan adalah bahwa exit status perintah `kill` akan nol jika berhasil dan bukan-nol jika gagal. `kill -0` tidak mengirimkan sinyal tetapi akan memberikan exit status bukan-nol jika proses tidak ada. Tulis fungsi bash yang disebut `pidwait` yang menerima pid dan menunggu sampai proses yang diberikan selesai. Anda sebaiknya menggunakan `sleep` untuk menghindari pemborosan CPU secara tidak perlu.

## File dan Permissions

1. (Lanjutan) Tulis perintah atau script untuk menemukan file yang paling baru dimodifikasi secara rekursif di dalam direktori. Lebih umumnya, dapatkah Anda mencantumkan semua file berdasarkan kebaruannya?

## Terminal Multiplexer

1. Ikuti [tutorial](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) `tmux` ini dan kemudian pelajari cara melakukan beberapa kustomisasi dasar dengan mengikuti [langkah-langkah ini](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/).

## Alias dan Dotfiles

1. Buat alias `dc` yang mengarah ke `cd` untuk ketika Anda salah mengetiknya.

1. Jalankan `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10` untuk mendapatkan 10 perintah yang paling sering Anda gunakan dan pertimbangkan untuk menulis alias yang lebih pendek untuk mereka. Catatan: ini berfungsi untuk Bash; jika Anda menggunakan ZSH, gunakan `history 1` bukan hanya `history`.

1. Buat folder untuk dotfiles Anda dan atur version control.

1. Tambahkan konfigurasi untuk setidaknya satu program, misalnya shell Anda, dengan beberapa kustomisasi (untuk memulai, bisa sesederhana mengkustomisasi prompt shell Anda dengan menetapkan `$PS1`).

1. Siapkan metode untuk menginstal dotfiles Anda dengan cepat (dan tanpa usaha manual) di mesin baru. Ini bisa sesederhana script shell yang memanggil `ln -s` untuk setiap file, atau Anda bisa menggunakan [utilitas khusus](https://dotfiles.github.io/utilities/).

1. Uji script instalasi Anda di virtual machine yang masih segar.

1. Migrasikan semua konfigurasi alat Anda saat ini ke repository dotfiles Anda.

1. Publikasikan dotfiles Anda di GitHub.

## Mesin Remote (SSH)

Instal virtual machine Linux (atau gunakan yang sudah ada) untuk latihan ini. Jika Anda tidak familiar dengan virtual machine, lihat [tutorial](https://hibbard.eu/install-ubuntu-virtual-box/) ini untuk menginstal satu.

1. Pergi ke `~/.ssh/` dan periksa apakah Anda memiliki pasangan SSH key di sana. Jika tidak, buat dengan `ssh-keygen -a 100 -t ed25519`. Disarankan bahwa Anda menggunakan password dan menggunakan `ssh-agent`, info lebih lanjut [di sini](https://www.ssh.com/ssh/agent).

1. Edit `.ssh/config` untuk memiliki entri seperti berikut:

    ```bash
    Host vm
        User username_goes_here
        HostName ip_goes_here
        IdentityFile ~/.ssh/id_ed25519
        LocalForward 9999 localhost:8888
    ```

1. Gunakan `ssh-copy-id vm` untuk menyalin SSH key Anda ke server.

1. Jalankan webserver di VM Anda dengan menjalankan `python -m http.server 8888`. Akses webserver VM dengan menavigasi ke `http://localhost:9999` di mesin Anda.

1. Edit konfigurasi server SSH Anda dengan melakukan `sudo vim /etc/ssh/sshd_config` dan nonaktifkan autentikasi password dengan mengedit nilai `PasswordAuthentication`. Nonaktifkan login root dengan mengedit nilai `PermitRootLogin`. Restart layanan `ssh` dengan `sudo service sshd restart`. Cobalah ssh lagi.

1. (Tantangan) Instal [`mosh`](https://mosh.org/) di VM dan buat koneksi. Kemudian putuskan adapter jaringan server/VM. Dapatkah mosh pulih dengan baik dari hal tersebut?

1. (Tantangan) Cari tahu apa yang dilakukan flag `-N` dan `-f` di `ssh` dan temukan perintah untuk melakukan background port forwarding.
