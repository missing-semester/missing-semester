---
layout: lecture
title: "Debugging dan Profiling"
description: >
  Pelajari cara men-debug program menggunakan logging, debugger, dan analisis statis, serta cara melakukan profiling kode untuk performa.
thumbnail: /static/assets/thumbnails/2020/lec7.png
date: 2020-01-23
ready: true
video:
  aspect: 56.25
  id: l812pUnKxME
---

Aturan emas dalam pemrograman adalah kode tidak melakukan apa yang Anda harapkan, melainkan apa yang Anda perintahkan.
Menjembatani kesenjangan tersebut terkadang bisa menjadi hal yang cukup sulit.
Dalam kuliah ini kita akan membahas teknik-teknik berguna untuk menangani kode yang bermasalah dan boros sumber daya: debugging dan profiling.

# Debugging

## Printf debugging dan Logging

"Alat debugging yang paling efektif tetaplah pemikiran yang cermat, dipasangkan dengan pernyataan print yang ditempatkan secara bijaksana" — Brian Kernighan, _Unix for Beginners_.

Pendekatan pertama untuk men-debug program adalah dengan menambahkan pernyataan print di sekitar tempat Anda mendeteksi masalah, dan terus melakukan iterasi hingga Anda mengekstrak cukup informasi untuk memahami apa yang menyebabkan masalah tersebut.

Pendekatan kedua adalah menggunakan logging dalam program Anda, alih-alih pernyataan print ad hoc. Logging lebih baik daripada pernyataan print biasa karena beberapa alasan:

- Anda dapat mencatat log ke file, socket, atau bahkan server jarak jauh alih-alih output standar.
- Logging mendukung level tingkat keparahan (seperti INFO, DEBUG, WARN, ERROR, &c), yang memungkinkan Anda memfilter output sesuai kebutuhan.
- Untuk masalah baru, ada kemungkinan besar log Anda akan berisi cukup informasi untuk mendeteksi apa yang salah.

[Berikut](/static/files/logger.py) contoh kode yang mencatat pesan log:

```bash
$ python logger.py
# Raw output as with just prints
$ python logger.py log
# Log formatted output
$ python logger.py log ERROR
# Print only ERROR levels and above
$ python logger.py color
# Color formatted output
```

Salah satu tips favorit saya untuk membuat log lebih mudah dibaca adalah memberikan kode warna.
Mungkin Anda sudah menyadari bahwa terminal Anda menggunakan warna untuk membuat mọi hal lebih mudah dibaca. Tapi bagaimana caranya?
Program seperti `ls` atau `grep` menggunakan [ANSI escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code), yaitu urutan karakter khusus untuk menginstruksikan shell Anda mengubah warna output. Sebagai contoh, menjalankan `echo -e "\e[38;2;255;0;0mThis is red\e[0m"` akan mencetak pesan `This is red` berwarna merah di terminal Anda, selama terminal mendukung [true color](https://github.com/termstandard/colors#truecolor-support-in-output-devices). Jika terminal Anda tidak mendukungnya (misalnya Terminal.app di macOS), Anda dapat menggunakan escape codes yang lebih universal untuk 16 pilihan warna, misalnya `echo -e "\e[31;1mThis is red\e[0m"`.

Script berikut menunjukkan cara mencetak banyak warna RGB ke terminal Anda (sekali lagi, selama mendukung true color).

```bash
#!/usr/bin/env bash
for R in $(seq 0 20 255); do
    for G in $(seq 0 20 255); do
        for B in $(seq 0 20 255); do
            printf "\e[38;2;${R};${G};${B}m█\e[0m";
        done
    done
done
```

## Log pihak ketiga

Saat Anda mulai membangun sistem perangkat lunak yang lebih besar, Anda kemungkinan besar akan menemukan dependensi yang berjalan sebagai program terpisah.
Web server, database, atau message broker adalah contoh umum dari jenis dependensi ini.
Saat berinteraksi dengan sistem-sistem ini, seringkali perlu membaca log mereka, karena pesan error dari sisi klien mungkin tidak cukup.

Untungnya, sebagian besar program menulis log mereka sendiri di suatu tempat di sistem Anda.
Di sistem UNIX, umumnya program menulis log mereka di bawah `/var/log`.
Sebagai contoh, web server [NGINX](https://www.nginx.com/) menempatkan log-nya di `/var/log/nginx`.
Belakangan ini, sistem telah mulai menggunakan **system log**, yang semakin menjadi tempat semua pesan log Anda masuk.
Sebagian besar (tetapi tidak semua) sistem Linux menggunakan `systemd`, sebuah system daemon yang mengontrol banyak hal di sistem Anda seperti layanan mana yang diaktifkan dan berjalan.
`systemd` menempatkan log di bawah `/var/log/journal` dalam format khusus dan Anda dapat menggunakan perintah [`journalctl`](https://www.man7.org/linux/man-pages/man1/journalctl.1.html) untuk menampilkan pesan.
Demikian pula, di macOS masih ada `/var/log/system.log` tetapi semakin banyak alat yang menggunakan system log, yang dapat ditampilkan dengan [`log show`](https://www.manpagez.com/man/1/log/).
Pada sebagian besar sistem UNIX Anda juga dapat menggunakan perintah [`dmesg`](https://www.man7.org/linux/man-pages/man1/dmesg.1.html) untuk mengakses log kernel.

Untuk mencatat log ke system log, Anda dapat menggunakan program shell [`logger`](https://www.man7.org/linux/man-pages/man1/logger.1.html).
Berikut contoh penggunaan `logger` dan cara memeriksa bahwa entri tersebut masuk ke system log.
Selain itu, sebagian besar bahasa pemrograman memiliki binding untuk mencatat log ke system log.

```bash
logger "Hello Logs"
# On macOS
log show --last 1m | grep Hello
# On Linux
journalctl --since "1m ago" | grep Hello
```

Seperti yang kita lihat di kuliah data wrangling, log bisa sangat panjang dan memerlukan beberapa tingkat pemrosesan dan penyaringan untuk mendapatkan informasi yang Anda inginkan.
Jika Anda sering melakukan penyaringan melalui `journalctl` dan `log show`, Anda dapat mempertimbangkan menggunakan flag mereka, yang dapat melakukan penyaringan awal output mereka.
Ada juga beberapa alat seperti [`lnav`](https://lnav.org/), yang menyediakan presentasi dan navigasi yang lebih baik untuk file log.

## Debugger

Ketika printf debugging tidak cukup, Anda harus menggunakan debugger.
Debugger adalah program yang memungkinkan Anda berinteraksi dengan eksekusi suatu program, memungkinkan hal-hal berikut:

- Menghentikan eksekusi program saat mencapai baris tertentu.
- Menelusuri program satu instruksi pada satu waktu.
- Memeriksa nilai variabel setelah program crash.
- Menghentikan eksekusi secara kondisional ketika kondisi tertentu terpenuhi.
- Dan banyak fitur canggih lainnya

Banyak bahasa pemrograman dilengkapi dengan semacam debugger.
Di Python, ini adalah Python Debugger [`pdb`](https://docs.python.org/3/library/pdb.html).

Berikut deskripsi singkat beberapa perintah yang didukung `pdb`:

- **l**(ist) - Menampilkan 11 baris di sekitar baris saat ini atau melanjutkan listing sebelumnya.
- **s**(tep) - Mengeksekusi baris saat ini, berhenti pada kesempatan pertama yang memungkinkan.
- **n**(ext) - Melanjutkan eksekusi hingga baris berikutnya dalam fungsi saat ini tercapai atau fungsi tersebut return.
- **b**(reak) - Menetapkan breakpoint (tergantung pada argumen yang diberikan).
- **p**(rint) - Mengevaluasi ekspresi dalam konteks saat ini dan mencetak nilainya. Ada juga **pp** untuk menampilkan menggunakan [`pprint`](https://docs.python.org/3/library/pprint.html) sebagai gantinya.
- **r**(eturn) - Melanjutkan eksekusi hingga fungsi saat ini return.
- **q**(uit) - Keluar dari debugger.

Mari kita lihat contoh penggunaan `pdb` untuk memperbaiki kode python buggy berikut. (Lihat video kuliah).

```python
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n):
            if arr[j] > arr[j+1]:
                arr[j] = arr[j+1]
                arr[j+1] = arr[j]
    return arr

print(bubble_sort([4, 2, 1, 8, 7, 6]))
```


Perhatikan bahwa karena Python adalah bahasa interpreted, kita dapat menggunakan shell `pdb` untuk mengeksekusi perintah dan menjalankan instruksi.
[`ipdb`](https://pypi.org/project/ipdb/) adalah `pdb` yang lebih canggih yang menggunakan REPL [`IPython`](https://ipython.org) yang memungkinkan tab completion, syntax highlighting, traceback yang lebih baik, dan introspeksi yang lebih baik sambil tetap mempertahankan antarmuka yang sama dengan modul `pdb`.

Untuk pemrograman yang lebih low level, Anda mungkin ingin melihat [`gdb`](https://www.gnu.org/software/gdb/) (dan modifikasi quality of life-nya [`pwndbg`](https://github.com/pwndbg/pwndbg)) dan [`lldb`](https://lldb.llvm.org/).
Mereka dioptimalkan untuk debugging bahasa mirip C tetapi memungkinkan Anda memeriksa hampir semua proses dan mendapatkan status mesin saat ini: register, stack, program counter, &c.


## Alat Khusus

Meskipun apa yang Anda coba debug adalah biner black box, ada alat yang dapat membantu Anda.
Setiap kali program perlu melakukan tindakan yang hanya bisa dilakukan kernel, mereka menggunakan [System Calls](https://en.wikipedia.org/wiki/System_call).
Ada perintah yang memungkinkan Anda menelusuri syscall yang dibuat program Anda. Di Linux ada [`strace`](https://www.man7.org/linux/man-pages/man1/strace.1.html) dan macOS serta BSD memiliki [`dtrace`](https://dtrace.org/about/). `dtrace` bisa sulit digunakan karena menggunakan bahasa `D`-nya sendiri, tetapi ada wrapper bernama [`dtruss`](https://www.manpagez.com/man/1/dtruss/) yang menyediakan antarmuka yang lebih mirip dengan `strace` (detail lebih lanjut [di sini](https://8thlight.com/blog/colin-jones/2015/11/06/dtrace-even-better-than-strace-for-osx.html)).

Berikut beberapa contoh penggunaan `strace` atau `dtruss` untuk menampilkan trace syscall [`stat`](https://www.man7.org/linux/man-pages/man2/stat.2.html) dari eksekusi `ls`. Untuk pembahasan lebih dalam tentang `strace`, [artikel ini](https://blogs.oracle.com/linux/strace-the-sysadmins-microscope-v2) dan [zine ini](https://jvns.ca/strace-zine-unfolded.pdf) adalah bacaan yang bagus.

```bash
# On Linux
sudo strace -e lstat ls -l > /dev/null
# On macOS
sudo dtruss -t lstat64_extended ls -l > /dev/null
```

Dalam beberapa situasi, Anda mungkin perlu melihat paket jaringan untuk mengetahui masalah dalam program Anda.
Alat seperti [`tcpdump`](https://www.man7.org/linux/man-pages/man1/tcpdump.1.html) dan [Wireshark](https://www.wireshark.org/) adalah network packet analyzer yang memungkinkan Anda membaca isi paket jaringan dan memfilternya berdasarkan berbagai kriteria.

Untuk pengembangan web, developer tools Chrome/Firefox sangat berguna. Mereka memiliki sejumlah besar alat, termasuk:
- Source code - Memeriksa kode sumber HTML/CSS/JS dari situs web mana pun.
- Live HTML, CSS, JS modification - Mengubah konten, gaya, dan perilaku situs web untuk pengujian (Anda bisa melihat sendiri bahwa screenshot situs web bukan bukti yang valid).
- Javascript shell - Menjalankan perintah di JS REPL.
- Network - Menganalisis timeline request.
- Storage - Melihat Cookie dan penyimpanan aplikasi lokal.

## Analisis Statis

Untuk beberapa masalah, Anda tidak perlu menjalankan kode sama sekali.
Sebagai contoh, hanya dengan melihat potongan kode secara cermat, Anda bisa menyadari bahwa variabel loop Anda shadowing variabel atau nama fungsi yang sudah ada sebelumnya; atau bahwa sebuah program membaca variabel sebelum mendefinisikannya.
Di sinilah alat [analisis statis](https://en.wikipedia.org/wiki/Static_program_analysis) berperan.
Program analisis statis menerima kode sumber sebagai input dan menganalisisnya menggunakan aturan pengkodean untuk menilai kebenarannya.

Pada potongan Python berikut terdapat beberapa kesalahan.
Pertama, variabel loop kita `foo` shadowing definisi sebelumnya dari fungsi `foo`. Kita juga menulis `baz` alih-alih `bar` di baris terakhir, sehingga program akan crash setelah menyelesaikan pemanggilan `sleep` (yang akan memakan waktu satu menit).

```python
import time

def foo():
    return 42

for foo in range(5):
    print(foo)
bar = 1
bar *= 0.2
time.sleep(60)
print(baz)
```

Alat analisis statis dapat mengidentifikasi masalah-masalah ini. Ketika kita menjalankan [`pyflakes`](https://pypi.org/project/pyflakes) pada kode tersebut, kita mendapatkan error terkait kedua bug. [`mypy`](https://mypy-lang.org/) adalah alat lain yang dapat mendeteksi masalah type checking. Di sini, `mypy` akan memperingatkan kita bahwa `bar` awalnya adalah `int` dan kemudian di-cast ke `float`.
Sekali lagi, perhatikan bahwa semua masalah ini terdeteksi tanpa harus menjalankan kode.

```bash
$ pyflakes foobar.py
foobar.py:6: redefinition of unused 'foo' from line 3
foobar.py:11: undefined name 'baz'

$ mypy foobar.py
foobar.py:6: error: Incompatible types in assignment (expression has type "int", variable has type "Callable[[], Any]")
foobar.py:9: error: Incompatible types in assignment (expression has type "float", variable has type "int")
foobar.py:11: error: Name 'baz' is not defined
Found 3 errors in 1 file (checked 1 source file)
```

Di kuliah shell tools kita telah membahas [`shellcheck`](https://www.shellcheck.net/), yang merupakan alat serupa untuk shell script.

Sebagian besar editor dan IDE mendukung menampilkan output dari alat-alat ini di dalam editor itu sendiri, menyoroti lokasi peringatan dan error.
Ini sering disebut **code linting** dan juga dapat digunakan untuk menampilkan jenis masalah lain seperti pelanggaran gaya atau konstruksi yang tidak aman.

Di vim, plugin [`ale`](https://vimawesome.com/plugin/ale) atau [`syntastic`](https://vimawesome.com/plugin/syntastic) akan memungkinkan Anda melakukan hal itu.
Untuk Python, [`pylint`](https://github.com/PyCQA/pylint) dan [`pep8`](https://pypi.org/project/pep8/) adalah contoh linter gaya dan [`bandit`](https://pypi.org/project/bandit/) adalah alat yang dirancang untuk menemukan masalah keamanan umum.
Untuk bahasa lain, orang-orang telah menyusun daftar komprehensif alat analisis statis yang berguna, seperti [Awesome Static Analysis](https://github.com/mre/awesome-static-analysis) (Anda mungkin ingin melihat bagian _Writing_) dan untuk linter ada [Awesome Linters](https://github.com/caramelomartins/awesome-linters).

Alat pelengkap untuk stylistic linting adalah code formatter seperti [`black`](https://github.com/psf/black) untuk Python, `gofmt` untuk Go, `rustfmt` untuk Rust, atau [`prettier`](https://prettier.io/) untuk JavaScript, HTML, dan CSS.
Alat-alat ini memformat kode Anda secara otomatis sehingga konsisten dengan pola gaya umum untuk bahasa pemrograman tertentu.
Meskipun Anda mungkin enggan menyerahkan kendali gaya tentang kode Anda, menstandarisasi format kode akan membantu orang lain membaca kode Anda dan akan membuat Anda lebih baik dalam membaca kode orang lain (yang telah distandarisasi secara gaya).

# Profiling

Meskipun kode Anda berperilaku fungsional seperti yang Anda harapkan, itu mungkin tidak cukup baik jika memakan semua CPU atau memori Anda dalam prosesnya.
Kelas algoritma sering mengajarkan notasi big _O_ tetapi tidak bagaimana menemukan hot spot dalam program Anda.
Karena [premature optimization is the root of all evil](https://wiki.c2.com/?PrematureOptimization), Anda harus mempelajari profiler dan alat monitoring. Mereka akan membantu Anda memahami bagian mana dari program Anda yang memakan waktu dan/atau sumber daya paling banyak sehingga Anda dapat fokus mengoptimalkan bagian-bagian tersebut.

## Timing

Sama seperti kasus debugging, dalam banyak skenario, cukup dengan mencetak waktu yang dibutuhkan kode Anda antara dua titik.
Berikut contoh di Python menggunakan modul [`time`](https://docs.python.org/3/library/time.html).

```python
import time, random
n = random.randint(1, 10) * 100

# Get current time
start = time.time()

# Do some work
print("Sleeping for {} ms".format(n))
time.sleep(n/1000)

# Compute time between start and now
print(time.time() - start)

# Output
# Sleeping for 500 ms
# 0.5713930130004883
```

Namun, wall clock time bisa menyesatkan karena komputer Anda mungkin menjalankan proses lain pada saat yang sama atau menunggu kejadian tertentu. Alat-alat umumnya membuat perbedaan antara waktu _Real_, _User_, dan _Sys_. Secara umum, _User_ + _Sys_ memberi tahu Anda berapa banyak waktu proses Anda sebenarnya dihabiskan di CPU (penjelasan lebih detail [di sini](https://stackoverflow.com/questions/556405/what-do-real-user-and-sys-mean-in-the-output-of-time1)).

- _Real_ - Waktu wall clock yang berlalu dari awal hingga akhir program, termasuk waktu yang dihabiskan oleh proses lain dan waktu saat blocked (misalnya menunggu I/O atau jaringan)
- _User_ - Jumlah waktu yang dihabiskan di CPU untuk menjalankan kode user
- _Sys_ - Jumlah waktu yang dihabiskan di CPU untuk menjalankan kode kernel

Sebagai contoh, coba jalankan perintah yang melakukan HTTP request dan awali dengan [`time`](https://www.man7.org/linux/man-pages/man1/time.1.html). Pada koneksi lambat Anda mungkin mendapatkan output seperti di bawah ini. Di sini dibutuhkan lebih dari 2 detik untuk request selesai tetapi proses hanya memakan 15ms waktu CPU user dan 12ms waktu CPU kernel.

```bash
$ time curl https://missing.csail.mit.edu &> /dev/null
real    0m2.561s
user    0m0.015s
sys     0m0.012s
```

## Profiler

### CPU

Sebagian besar waktu ketika orang merujuk ke _profiler_, mereka sebenarnya berarti _CPU profiler_, yang merupakan yang paling umum.
Ada dua jenis utama CPU profiler: profiler _tracing_ dan _sampling_.
Tracing profiler mencatat setiap pemanggilan fungsi yang dibuat program Anda, sedangkan sampling profiler memeriksa program Anda secara berkala (biasanya setiap milidetik) dan mencatat stack program.
Mereka menggunakan catatan ini untuk menyajikan statistik agregat tentang apa yang paling banyak dilakukan program Anda.
[Berikut](https://jvns.ca/blog/2017/12/17/how-do-ruby---python-profilers-work-) artikel pengantar yang bagus jika Anda ingin detail lebih lanjut tentang topik ini.

Sebagian besar bahasa pemrograman memiliki semacam profiler baris perintah yang dapat Anda gunakan untuk menganalisis kode Anda.
Mereka sering terintegrasi dengan IDE lengkap tetapi untuk kuliah ini kita akan fokus pada alat baris perintah itu sendiri.

Di Python kita dapat menggunakan modul `cProfile` untuk memprofilkan waktu per pemanggilan fungsi. Berikut contoh sederhana yang mengimplementasikan grep dasar di Python:

```python
#!/usr/bin/env python

import sys, re

def grep(pattern, file):
    with open(file, 'r') as f:
        print(file)
        for i, line in enumerate(f.readlines()):
            pattern = re.compile(pattern)
            match = pattern.search(line)
            if match is not None:
                print("{}: {}".format(i, line), end="")

if __name__ == '__main__':
    times = int(sys.argv[1])
    pattern = sys.argv[2]
    for i in range(times):
        for file in sys.argv[3:]:
            grep(pattern, file)
```

Kita dapat memprofilkan kode ini menggunakan perintah berikut. Dengan menganalisis output, kita dapat melihat bahwa IO memakan waktu paling banyak dan bahwa kompilasi regex juga memakan waktu yang cukup. Karena regex hanya perlu dikompilasi sekali, kita dapat memfaktorkannya keluar dari for.

```
$ python -m cProfile -s tottime grep.py 1000 '^(import|\s*def)[^,]*$' *.py

[omitted program output]

 ncalls  tottime  percall  cumtime  percall filename:lineno(function)
     8000    0.266    0.000    0.292    0.000 {built-in method io.open}
     8000    0.153    0.000    0.894    0.000 grep.py:5(grep)
    17000    0.101    0.000    0.101    0.000 {built-in method builtins.print}
     8000    0.100    0.000    0.129    0.000 {method 'readlines' of '_io._IOBase' objects}
    93000    0.097    0.000    0.111    0.000 re.py:286(_compile)
    93000    0.069    0.000    0.069    0.000 {method 'search' of '_sre.SRE_Pattern' objects}
    93000    0.030    0.000    0.141    0.000 re.py:231(compile)
    17000    0.019    0.000    0.029    0.000 codecs.py:318(decode)
        1    0.017    0.017    0.911    0.911 grep.py:3(<module>)

[omitted lines]
```


Catatan tentang profiler `cProfile` Python (dan banyak profiler pada umumnya) adalah mereka menampilkan waktu per pemanggilan fungsi. Hal ini bisa menjadi sangat tidak intuitif, terutama jika Anda menggunakan pustaka pihak ketiga dalam kode Anda karena pemanggilan fungsi internal juga diperhitungkan.
Cara yang lebih intuitif untuk menampilkan informasi profiling adalah dengan menyertakan waktu yang dihabiskan per baris kode, yang merupakan apa yang dilakukan _line profiler_.

Sebagai contoh, potongan kode Python berikut melakukan request ke situs web kelas dan mengurai respons untuk mendapatkan semua URL di halaman:

```python
#!/usr/bin/env python
import requests
from bs4 import BeautifulSoup

# This is a decorator that tells line_profiler
# that we want to analyze this function
@profile
def get_urls():
    response = requests.get('https://missing.csail.mit.edu')
    s = BeautifulSoup(response.content, 'lxml')
    urls = []
    for url in s.find_all('a'):
        urls.append(url['href'])

if __name__ == '__main__':
    get_urls()
```

Jika kita menggunakan profiler `cProfile` Python, kita akan mendapatkan lebih dari 2500 baris output, dan bahkan dengan pengurutan, akan sulit memahami di mana waktu dihabiskan. Jalankan cepat dengan [`line_profiler`](https://github.com/pyutils/line_profiler) menunjukkan waktu yang dihabiskan per baris:

```bash
$ kernprof -l -v a.py
Wrote profile results to urls.py.lprof
Timer unit: 1e-06 s

Total time: 0.636188 s
File: a.py
Function: get_urls at line 5

Line #  Hits         Time  Per Hit   % Time  Line Contents
==============================================================
 5                                           @profile
 6                                           def get_urls():
 7         1     613909.0 613909.0     96.5      response = requests.get('https://missing.csail.mit.edu')
 8         1      21559.0  21559.0      3.4      s = BeautifulSoup(response.content, 'lxml')
 9         1          2.0      2.0      0.0      urls = []
10        25        685.0     27.4      0.1      for url in s.find_all('a'):
11        24         33.0      1.4      0.0          urls.append(url['href'])
```

### Memori

Dalam bahasa seperti C atau C++, memory leak dapat menyebabkan program Anda tidak pernah melepaskan memori yang tidak lagi dibutuhkan.
Untuk membantu dalam proses debugging memori, Anda dapat menggunakan alat seperti [Valgrind](https://valgrind.org/) yang akan membantu Anda mengidentifikasi memory leak.

Dalam bahasa dengan garbage collector seperti Python, tetap berguna menggunakan memory profiler karena selama Anda memiliki pointer ke objek di memori, mereka tidak akan di-garbage collect.
Berikut contoh program dan output terkait saat menjalankannya dengan [memory-profiler](https://pypi.org/project/memory-profiler/) (perhatikan decorator seperti pada `line-profiler`).

```python
@profile
def my_func():
    a = [1] * (10 ** 6)
    b = [2] * (2 * 10 ** 7)
    del b
    return a

if __name__ == '__main__':
    my_func()
```

```bash
$ python -m memory_profiler example.py
Line #    Mem usage  Increment   Line Contents
==============================================
     3                           @profile
     4      5.97 MB    0.00 MB   def my_func():
     5     13.61 MB    7.64 MB       a = [1] * (10 ** 6)
     6    166.20 MB  152.59 MB       b = [2] * (2 * 10 ** 7)
     7     13.61 MB -152.59 MB       del b
     8     13.61 MB    0.00 MB       return a
```

### Event Profiling

Seperti halnya `strace` untuk debugging, Anda mungkin ingin mengabaikan detail kode yang Anda jalankan dan memperlakukannya seperti black box saat melakukan profiling.
Perintah [`perf`](https://www.man7.org/linux/man-pages/man1/perf.1.html) mengabstraksi perbedaan CPU dan tidak melaporkan waktu atau memori, melainkan melaporkan event sistem yang terkait dengan program Anda.
Sebagai contoh, `perf` dapat dengan mudah melaporkan poor cache locality, page faults dalam jumlah besar, atau livelocks. Berikut ikhtisar perintahnya:

- `perf list` - Mencantumkan event yang dapat ditelusuri dengan perf
- `perf stat COMMAND ARG1 ARG2` - Mendapatkan hitungan dari berbagai event yang terkait dengan proses atau perintah
- `perf record COMMAND ARG1 ARG2` - Merekam eksekusi perintah dan menyimpan data statistik ke file bernama `perf.data`
- `perf report` - Memformat dan mencetak data yang dikumpulkan di `perf.data`


### Visualisasi

Output profiler untuk program dunia nyata akan berisi sejumlah besar informasi karena kompleksitas inheren dari proyek perangkat lunak.
Manusia adalah makhluk visual dan cukup buruk dalam membaca sejumlah besar angka dan memahaminya.
Oleh karena itu, ada banyak alat untuk menampilkan output profiler dengan cara yang lebih mudah dipahami.

Salah satu cara umum untuk menampilkan informasi profiling CPU untuk sampling profiler adalah menggunakan [Flame Graph](https://www.brendangregg.com/flamegraphs.html), yang akan menampilkan hierarki pemanggilan fungsi pada sumbu Y dan waktu yang dihabiskan proporsional terhadap sumbu X. Mereka juga interaktif, memungkinkan Anda zoom ke bagian tertentu dari program dan mendapatkan stack trace-nya (coba klik gambar di bawah).

[![FlameGraph](https://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)](https://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)

Call graph atau control flow graph menampilkan hubungan antar subroutine dalam suatu program dengan menyertakan fungsi sebagai node dan pemanggilan fungsi di antara mereka sebagai edge berarah. Ketika dipasangkan dengan informasi profiling seperti jumlah pemanggilan dan waktu yang dihabiskan, call graph bisa sangat berguna untuk menginterpretasikan alur program.
Di Python Anda dapat menggunakan pustaka [`pycallgraph`](https://pycallgraph.readthedocs.io/) untuk membuatnya.

![Call Graph](https://upload.wikimedia.org/wikipedia/commons/2/2f/A_Call_Graph_generated_by_pycallgraph.png)


## Monitoring Sumber Daya

Terkadang, langkah pertama menuju analisis performa program Anda adalah memahami konsumsi sumber daya aktualnya.
Program sering berjalan lambat ketika sumber dayanya terbatas, misalnya tanpa memori yang cukup atau pada koneksi jaringan yang lambat.
Ada banyak sekali alat baris perintah untuk memeriksa dan menampilkan berbagai sumber daya sistem seperti penggunaan CPU, penggunaan memori, jaringan, penggunaan disk, dan sebagainya.

- **Monitoring Umum** - Mungkin yang paling populer adalah [`htop`](https://htop.dev/), yang merupakan versi perbaikan dari [`top`](https://www.man7.org/linux/man-pages/man1/top.1.html).
`htop` menyajikan berbagai statistik untuk proses yang sedang berjalan di sistem. `htop` memiliki banyak opsi dan keybind, beberapa yang berguna adalah: `<F6>` untuk mengurutkan proses, `t` untuk menampilkan hierarki tree, dan `h` untuk toggle thread.
Lihat juga [`glances`](https://nicolargo.github.io/glances/) untuk implementasi serupa dengan UI yang hebat. Untuk mendapatkan pengukuran agregat di semua proses, [`dool`](https://github.com/scottchiefbaker/dool) adalah alat lain yang berguna yang menghitung metrik sumber daya real-time untuk banyak subsistem berbeda seperti I/O, jaringan, utilisasi CPU, context switch, &c.
- **Operasi I/O** - [`iotop`](https://www.man7.org/linux/man-pages/man8/iotop.8.html) menampilkan informasi penggunaan I/O secara langsung dan berguna untuk memeriksa apakah suatu proses melakukan operasi disk I/O yang berat
- **Penggunaan Disk** - [`df`](https://www.man7.org/linux/man-pages/man1/df.1.html) menampilkan metrik per partisi dan [`du`](https://man7.org/linux/man-pages/man1/du.1.html) menampilkan penggunaan **d**isk per file untuk direktori saat ini. Pada alat-alat ini, flag `-h` memberi tahu program untuk mencetak dalam format yang mudah dibaca manusia (**h**uman readable).
Versi yang lebih interaktif dari `du` adalah [`ncdu`](https://dev.yorhel.nl/ncdu) yang memungkinkan Anda menavigasi folder dan menghapus file serta folder saat Anda menavigasi.
- **Penggunaan Memori** - [`free`](https://www.man7.org/linux/man-pages/man1/free.1.html) menampilkan jumlah total memori bebas dan yang digunakan dalam sistem. Memori juga ditampilkan di alat seperti `htop`.
- **File Terbuka** - [`lsof`](https://www.man7.org/linux/man-pages/man8/lsof.8.html) mencantumkan informasi file tentang file yang dibuka oleh proses. Ini bisa sangat berguna untuk memeriksa proses mana yang telah membuka file tertentu.
- **Konfigurasi dan Koneksi Jaringan** - [`ss`](https://www.man7.org/linux/man-pages/man8/ss.8.html) memungkinkan Anda memantau statistik paket jaringan masuk dan keluar serta statistik antarmuka. Kasus penggunaan umum `ss` adalah mengetahui proses mana yang menggunakan port tertentu di suatu mesin. Untuk menampilkan routing, perangkat jaringan, dan antarmuka Anda dapat menggunakan [`ip`](https://man7.org/linux/man-pages/man8/ip.8.html). Perhatikan bahwa `netstat` dan `ifconfig` telah didepresiasi masing-masing demi alat-alat sebelumnya.
- **Penggunaan Jaringan** - [`nethogs`](https://github.com/raboof/nethogs) dan [`iftop`](https://pdw.ex-parrot.com/iftop/) adalah alat CLI interaktif yang bagus untuk memantau penggunaan jaringan.

Jika Anda ingin menguji alat-alat ini, Anda juga dapat secara buatan membebankan beban pada mesin menggunakan perintah [`stress`](https://linux.die.net/man/1/stress).


### Alat khusus

Terkadang, benchmarking black box adalah semua yang Anda butuhkan untuk menentukan perangkat lunak mana yang akan digunakan.
Alat seperti [`hyperfine`](https://github.com/sharkdp/hyperfine) memungkinkan Anda dengan cepat melakukan benchmark program baris perintah.
Sebagai contoh, di kuliah shell tools dan scripting kami merekomendasikan `fd` daripada `find`. Kita dapat menggunakan `hyperfine` untuk membandingkan mereka dalam tugas yang sering kita jalankan.
Misalnya, pada contoh di bawah `fd` 20x lebih cepat daripada `find` di mesin saya.

```bash
$ hyperfine --warmup 3 'fd -e jpg' 'find . -iname "*.jpg"'
Benchmark #1: fd -e jpg
  Time (mean ± σ):      51.4 ms ±   2.9 ms    [User: 121.0 ms, System: 160.5 ms]
  Range (min … max):    44.2 ms …  60.1 ms    56 runs

Benchmark #2: find . -iname "*.jpg"
  Time (mean ± σ):      1.126 s ±  0.101 s    [User: 141.1 ms, System: 956.1 ms]
  Range (min … max):    0.975 s …  1.287 s    10 runs

Summary
  'fd -e jpg' ran
   21.89 ± 2.33 times faster than 'find . -iname "*.jpg"'
```

Seperti halnya debugging, browser juga dilengkapi dengan seperangkat alat fantastis untuk memprofilkan pemuatan halaman web, memungkinkan Anda mengetahui di mana waktu dihabiskan (memuat, rendering, scripting, &c).
Info lebih lanjut untuk [Firefox](https://profiler.firefox.com/docs/) dan [Chrome](https://developers.google.com/web/tools/chrome-devtools/rendering-tools).

# Latihan

## Debugging
1. Gunakan `journalctl` di Linux atau `log show` di macOS untuk mendapatkan akses super user dan perintah di hari terakhir.
Jika tidak ada, Anda dapat menjalankan beberapa perintah yang tidak berbahaya seperti `sudo ls` dan periksa lagi.

1. Ikuti tutorial hands-on `pdb` [ini](https://github.com/spiside/pdb-tutorial) untuk membiasakan diri dengan perintah-perintahnya. Untuk tutorial yang lebih mendalam, baca [ini](https://realpython.com/python-debugging-pdb).

1. Instal [`shellcheck`](https://www.shellcheck.net/) dan coba periksa script berikut. Apa yang salah dengan kode tersebut? Perbaiki. Instal plugin linter di editor Anda sehingga Anda bisa mendapatkan peringatan secara otomatis.

   ```bash
   #!/bin/sh
   ## Example: a typical script with several problems
   for f in $(ls *.m3u)
   do
     grep -qi hq.*mp3 $f \
       && echo -e 'Playlist $f contains a HQ file in mp3 format'
   done
   ```

1. (Lanjutan) Baca tentang [reversible debugging](https://undo.io/resources/reverse-debugging-whitepaper/) dan buat contoh sederhana yang berfungsi menggunakan [`rr`](https://rr-project.org/) atau [`RevPDB`](https://morepypy.blogspot.com/2016/07/reverse-debugging-for-python.html).
## Profiling

1. [Berikut](/static/files/sorts.py) beberapa implementasi algoritma pengurutan. Gunakan [`cProfile`](https://docs.python.org/3/library/profile.html) dan [`line_profiler`](https://github.com/pyutils/line_profiler) untuk membandingkan runtime insertion sort dan quicksort. Apa bottleneck masing-masing algoritma? Kemudian gunakan `memory_profiler` untuk memeriksa konsumsi memori, mengapa insertion sort lebih baik? Sekarang periksa versi inplace dari quicksort. Tantangan: Gunakan `perf` untuk melihat cycle count dan cache hits serta misses masing-masing algoritma.

1. Berikut kode Python (yang mungkin agak berbelit-belit) untuk menghitung bilangan Fibonacci menggunakan fungsi untuk setiap bilangan.

   ```python
   #!/usr/bin/env python
   def fib0(): return 0

   def fib1(): return 1

   s = """def fib{}(): return fib{}() + fib{}()"""

   if __name__ == '__main__':

       for n in range(2, 10):
           exec(s.format(n, n-1, n-2))
       # from functools import lru_cache
       # for n in range(10):
       #     exec("fib{} = lru_cache(1)(fib{})".format(n, n))
       print(eval("fib9()"))
   ```

   Letakkan kode ke dalam file dan jadikan dapat dieksekusi. Instal prasyarat: [`pycallgraph`](https://lewiscowles1986.github.io/py-call-graph/) dan [`graphviz`](https://graphviz.org/). (Jika Anda bisa menjalankan `dot`, Anda sudah punya GraphViz.) Jalankan kode apa adanya dengan `pycallgraph graphviz -- ./fib.py` dan periksa file `pycallgraph.png`. Berapa kali `fib0` dipanggil?. Kita bisa melakukan lebih baik dari itu dengan memoizing fungsi-fungsi tersebut. Hapus komentar pada baris yang dikomentari dan generate ulang gambar. Berapa kali kita memanggil setiap fungsi `fibN` sekarang?

1. Masalah umum adalah port yang ingin Anda gunakan untuk listen sudah diambil oleh proses lain. Mari kita pelajari cara menemukan pid proses tersebut. Pertama jalankan `python -m http.server 4444` untuk memulai server web minimal yang listen di port `4444`. Di terminal terpisah jalankan `lsof | grep LISTEN` untuk mencetak semua proses dan port yang sedang listen. Temukan pid proses tersebut dan hentikan dengan menjalankan `kill <PID>`.

1. Membatasi sumber daya proses bisa menjadi alat berguna lainnya dalam kotak peralatan Anda.
Coba jalankan `stress -c 3` dan visualisasikan konsumsi CPU dengan `htop`. Sekarang, jalankan `taskset --cpu-list 0,2 stress -c 3` dan visualisasikan. Apakah `stress` menggunakan tiga CPU? Mengapa tidak? Baca [`man taskset`](https://www.man7.org/linux/man-pages/man1/taskset.1.html).
Tantangan: capai hal yang sama menggunakan [`cgroups`](https://www.man7.org/linux/man-pages/man7/cgroups.7.html). Coba batasi konsumsi memori `stress -m`.

1. (Lanjutan) Perintah `curl ipinfo.io` melakukan HTTP request dan mengambil informasi tentang IP publik Anda. Buka [Wireshark](https://www.wireshark.org/) dan coba sniff paket request dan reply yang dikirim dan diterima `curl`. (Petunjuk: Gunakan filter `http` untuk hanya melihat paket HTTP).
