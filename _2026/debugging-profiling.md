---
layout: lecture
title: "Debugging dan Profiling"
description: >
  Pelajari cara men-debug program menggunakan logging dan debugger, serta cara melakukan profiling kode untuk performa.
thumbnail: /static/assets/thumbnails/2026/lec4.png
date: 2026-01-15
ready: true
panopto: "https://mit.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=a72c48e3-5eb2-46fa-aa03-b3b700e1ca8d"
video:
  aspect: 56.25
  id: 8VYT9TcUmKs
---

Sebuah aturan emas dalam pemrograman adalah bahwa kode tidak melakukan apa yang Anda harapkan, melainkan apa yang Anda perintahkan. Menjembatani kesenjangan tersebut terkadang bisa menjadi hal yang cukup sulit. Dalam kuliah ini kita akan membahas teknik-teknik berguna untuk menangani kode yang bermasalah dan rakus sumber daya: debugging dan profiling.

# Debugging

## Printf Debugging dan Logging

> "Alat debugging yang paling efektif tetaplah pemikiran yang hati-hati, dipadukan dengan pernyataan print yang ditempatkan secara bijaksana" — Brian Kernighan, _Unix for Beginners_.

Pendekatan pertama untuk men-debug sebuah program adalah dengan menambahkan pernyataan print di sekitar area yang terdeteksi bermasalah, lalu terus beriterasi hingga Anda berhasil mengekstrak cukup informasi untuk memahami apa yang menyebabkan masalah tersebut.

Pendekatan kedua adalah menggunakan logging dalam program Anda, alih-alih pernyataan print yang bersifat ad hoc. Logging pada dasarnya adalah "mencetak dengan lebih terarah", dan biasanya dilakukan melalui framework logging yang memiliki dukungan bawaan untuk hal-hal seperti:

- kemampuan untuk mengarahkan log (atau subset dari log) ke lokasi output lain;
- pengaturan level keparahan (seperti INFO, DEBUG, WARN, ERROR, dll.) dan memungkinkan Anda memfilter output berdasarkan level tersebut; dan
- dukungan untuk logging terstruktur dari data yang terkait dengan entri log, yang kemudian dapat diekstrak lebih mudah setelahnya.

Pernyataan logging juga biasanya akan Anda proaktif tambahkan saat
pemrograman sehingga data yang Anda butuhkan untuk debugging mungkin sudah tersedia! Dan memang, setelah Anda menemukan dan memperbaiki masalah menggunakan pernyataan
print, seringkali bermanfaat untuk mengonversi print tersebut menjadi
pernyataan log yang proper sebelum menghapusnya. Dengan cara ini, jika bug serupa terjadi
di masa depan, Anda sudah memiliki informasi diagnostik yang Anda butuhkan
tanpa perlu memodifikasi kode.

> **Log pihak ketiga**: Banyak program mendukung flag `-v` atau `--verbose` untuk mencetak lebih banyak informasi saat dijalankan. Ini bisa berguna untuk mengetahui mengapa suatu perintah gagal. Beberapa bahkan memungkinkan pengulangan flag untuk detail lebih lanjut. Saat men-debug masalah dengan layanan (database, web server, dll.), periksa log mereka—seringkali di `/var/log/` pada Linux. Gunakan `journalctl -u <service>` untuk melihat log layanan systemd. Untuk pustaka pihak ketiga, periksa apakah mereka mendukung debug logging melalui variabel lingkungan atau konfigurasi.

## Debugger

Print debugging bekerja dengan baik ketika Anda tahu apa yang harus dicetak dan dapat dengan mudah memodifikasi serta menjalankan ulang kode Anda. Debugger menjadi berharga ketika Anda tidak yakin informasi apa yang Anda butuhkan, ketika bug hanya muncul dalam kondisi yang sulit direproduksi, atau ketika memodifikasi dan memulai ulang program membutuhkan biaya tinggi (waktu startup yang lama, state yang kompleks untuk dibuat ulang, dll.).

Debugger adalah program yang memungkinkan Anda berinteraksi dengan eksekusi suatu program saat terjadi, memungkinkan Anda untuk:

- Menghentikan eksekusi ketika mencapai baris tertentu.
- Melangkah melalui satu instruksi pada satu waktu.
- Memeriksa nilai variabel setelah crash.
- Menghentikan eksekusi secara kondisional ketika suatu kondisi terpenuhi.
- Dan banyak fitur lanjutan lainnya.

Sebagian besar bahasa pemrograman mendukung (atau menyediakan) beberapa bentuk debugger. Yang paling serbaguna adalah **debugger serbaguna** seperti [`gdb`](https://www.gnu.org/software/gdb/) (GNU Debugger) dan [`lldb`](https://lldb.llvm.org/) (LLVM Debugger), yang dapat men-debug binary native apa pun. Banyak bahasa juga memiliki **debugger khusus bahasa** yang terintegrasi lebih erat dengan runtime (seperti pdb milik Python atau jdb milik Java).

`gdb` adalah debugger standar de-facto untuk C, C++, Rust, dan bahasa terkompilasi lainnya. Debugger ini memungkinkan Anda memeriksa hampir semua proses dan mendapatkan state mesin saat ini: register, stack, program counter, dan lainnya.

Beberapa perintah GDB yang berguna:

- `run` - Memulai program
- `b {function}` atau `b {file}:{line}` - Mengatur breakpoint
- `c` - Melanjutkan eksekusi
- `step` / `next` / `finish` - Step in / step over / step out
- `p {variable}` - Mencetak nilai variabel
- `bt` - Menampilkan backtrace (call stack)
- `watch {expression}` - Break ketika nilai berubah

> Pertimbangkan untuk menggunakan mode TUI GDB (`gdb -tui` atau tekan `Ctrl-x a` di dalam GDB) untuk tampilan split-screen yang menampilkan source code di samping command prompt.

### Record-Replay Debugging

Beberapa bug yang paling membuat frustrasi adalah _Heisenbug_: bug yang sepertinya menghilang atau berubah perilaku ketika Anda mencoba mengamatinya. Race condition, bug yang bergantung pada timing, dan masalah yang hanya muncul di bawah kondisi sistem tertentu termasuk dalam kategori ini. Debugging tradisional seringkali tidak berguna di sini karena menjalankan program lagi menghasilkan perilaku yang berbeda (misalnya, pernyataan print mungkin memperlambat kode cukup sehingga race tidak lagi terjadi).

**Record-replay debugging** menyelesaikan ini dengan merekam eksekusi program dan memungkinkan Anda memutar ulangnya secara deterministik sebanyak yang Anda butuhkan. Lebih baik lagi, Anda dapat _mundur_ melalui eksekusi untuk menemukan secara tepat di mana segala sesuatunya menjadi salah.

[rr](https://rr-project.org/) adalah alat yang powerful untuk Linux yang merekam eksekusi program dan memungkinkan replay deterministik dengan kemampuan debugging penuh. Alat ini bekerja dengan GDB, jadi Anda sudah familiar dengan antarmukanya.

Penggunaan dasar:

```bash
# Record a program execution
rr record ./my_program

# Replay the recording (opens GDB)
rr replay
```

Keajaiban terjadi saat replay. Karena eksekusinya deterministik, Anda dapat menggunakan perintah **reverse debugging**:

- `reverse-continue` (`rc`) - Jalankan mundur hingga mencapai breakpoint
- `reverse-step` (`rs`) - Mundur satu baris
- `reverse-next` (`rn`) - Mundur, melewati function call
- `reverse-finish` - Jalankan mundur hingga memasuki fungsi saat ini

Ini sangat powerful untuk debugging. Misalkan Anda memiliki crash—alih-alih menebak di mana bug berada dan mengatur breakpoint, Anda dapat:

1. Jalankan hingga crash
2. Periksa state yang rusak
3. Atur watchpoint pada variabel yang rusak
4. `reverse-continue` untuk menemukan secara tepat di mana kerusakan terjadi

**Kapan menggunakan rr:**
- Test yang flaky yang gagal secara intermiten
- Race condition dan bug threading
- Crash yang sulit direproduksi
- Bug apa pun di mana Anda berharap bisa "mundur ke masa lalu"

> Catatan: rr hanya bekerja di Linux dan memerlukan hardware performance counter. Tidak bekerja di VM yang tidak mengekspos counter ini, seperti pada sebagian besar instance AWS EC2, dan tidak mendukung akses GPU. Untuk macOS, lihat [Warpspeed](https://warpspeed.dev/).

> **rr dan konkurensi**: Karena rr merekam eksekusi secara deterministik, rr menserialisasi penjadwalan thread. Ini berarti beberapa race condition mungkin tidak muncul di bawah rr jika mereka bergantung pada timing tertentu. rr tetap berguna untuk men-debug race—setelah Anda menangkap run yang gagal, Anda dapat memutar ulangnya secara andal—tetapi Anda mungkin memerlukan beberapa kali percobaan perekaman untuk menangkap bug intermiten. Untuk bug yang tidak melibatkan konkurensi, rr bersinar paling terang: Anda selalu dapat mereproduksi eksekusi yang persis sama dan menggunakan reverse debugging untuk melacak kerusakan.

## System Call Tracing

Terkadang Anda perlu memahami bagaimana program Anda berinteraksi dengan sistem operasi. Program membuat [system call](https://en.wikipedia.org/wiki/System_call) untuk meminta layanan dari kernel—membuka file, mengalokasikan memori, membuat proses, dan lainnya. Melacak panggilan ini dapat mengungkap mengapa program hang, file apa yang coba diakses, atau di mana program menghabiskan waktu menunggu.

### strace (Linux) dan dtruss (macOS)

[`strace`](https://www.man7.org/linux/man-pages/man1/strace.1.html) memungkinkan Anda mengamati setiap system call yang dibuat oleh sebuah program:

```bash
# Trace all system calls
strace ./my_program

# Trace only file-related calls
strace -e trace=file ./my_program

# Follow child processes (important for programs that start other programs)
strace -f ./my_program

# Trace a running process
strace -p <PID>

# Show timing information
strace -T ./my_program
```

> Di macOS dan BSD, gunakan [`dtruss`](https://www.manpagez.com/man/1/dtruss/) (yang membungkus `dtrace`) untuk fungsionalitas serupa:

> Untuk pembahasan lebih mendalam tentang `strace`, lihat [strace zine](https://jvns.ca/strace-zine-unfolded.pdf) yang luar biasa dari Julia Evans.

### bpftrace dan eBPF

[eBPF](https://ebpf.io/) (extended Berkeley Packet Filter) adalah teknologi Linux yang powerful yang memungkinkan menjalankan program yang di-sandbox di dalam kernel. [`bpftrace`](https://github.com/iovisor/bpftrace) menyediakan sintaks tingkat tinggi untuk menulis program eBPF. Ini adalah program arbitrer yang berjalan di kernel, dan dengan demikian memiliki kekuatan ekspresif yang besar (meskipun juga memiliki sintaks yang agak canggung mirip awk). Kasus penggunaan yang paling umum adalah untuk menyelidiki system call apa yang dipanggil, termasuk agregasi (seperti hitungan atau statistik latensi) atau introspeksi (atau bahkan memfilter) argumen system call.

```bash
# Trace file opens system-wide (prints immediately)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_openat { printf("%s %s\n", comm, str(args->filename)); }'

# Count system calls by name (prints summary on Ctrl-C)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_* { @[probe] = count(); }'
```

Namun, Anda juga dapat menulis program eBPF langsung dalam C menggunakan toolchain seperti [`bcc`](https://github.com/iovisor/bcc), yang juga dilengkapi dengan [banyak alat yang berguna](https://www.brendangregg.com/blog/2015-09-22/bcc-linux-4.3-tracing.html) seperti `biosnoop` untuk mencetak distribusi latensi untuk operasi disk atau `opensnoop` untuk mencetak semua file yang dibuka.

Jika `strace` berguna karena mudah untuk "langsung dijalankan", `bpftrace` adalah yang harus Anda gunakan ketika Anda membutuhkan overhead yang lebih rendah, ingin men-trace melalui fungsi kernel, perlu melakukan agregasi, dll. Perhatikan bahwa `bpftrace` harus dijalankan sebagai `root`, dan secara umum memonitor seluruh kernel, bukan hanya proses tertentu. Untuk menargetkan program spesifik, Anda dapat memfilter berdasarkan nama perintah atau PID:

```bash
# Filter by command name (prints summary on Ctrl-C)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_* /comm == "bash"/ { @[probe] = count(); }'

# Trace a specific command from startup using -c (cpid = child PID)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_* /pid == cpid/ { @[probe] = count(); }' -c 'ls -la'
```

Flag `-c` menjalankan perintah yang ditentukan dan mengatur `cpid` ke PID-nya, yang berguna untuk men-trace program sejak awal dimulai. Ketika perintah yang di-trace keluar, bpftrace mencetak hasil agregat.

### Network Debugging

Untuk masalah jaringan, [`tcpdump`](https://www.man7.org/linux/man-pages/man1/tcpdump.1.html) dan [Wireshark](https://www.wireshark.org/) memungkinkan Anda menangkap dan menganalisis paket jaringan:

```bash
# Capture packets on port 80
sudo tcpdump -i any port 80

# Capture and save to file for Wireshark analysis
sudo tcpdump -i any -w capture.pcap
```

Untuk traffic HTTPS, enkripsi membuat tcpdump kurang berguna. Alat seperti [mitmproxy](https://mitmproxy.org/) dapat bertindak sebagai intercepting proxy untuk memeriksa traffic terenkripsi. Browser developer tools (tab Network) seringkali merupakan cara termudah untuk men-debug permintaan HTTPS dari aplikasi web—mereka menampilkan data request/response yang didekripsi, header, dan timing.

## Memory Debugging

Bug memori—buffer overflow, use-after-free, memory leak—termasuk yang paling berbahaya dan sulit untuk di-debug. Seringkali mereka tidak langsung crash tetapi merusak memori dengan cara yang menyebabkan masalah jauh di kemudian hari.

### Sanitizer

Salah satu pendekatan untuk menemukan bug memori adalah menggunakan **sanitizer**, yang merupakan fitur compiler yang menginstrumen kode Anda untuk mendeteksi error saat runtime. Misalnya, **AddressSanitizer (ASan)** yang banyak digunakan mendeteksi:
- Buffer overflow (stack, heap, dan global)
- Use-after-free
- Use-after-return
- Memory leak

```bash
# Compile with AddressSanitizer
gcc -fsanitize=address -g program.c -o program
./program
```

Terdapat berbagai sanitizer yang berguna:

- **ThreadSanitizer (TSan)**: Mendeteksi data race di kode multithreaded (`-fsanitize=thread`)
- **MemorySanitizer (MSan)**: Mendeteksi pembacaan memori yang belum diinisialisasi (`-fsanitize=memory`)
- **UndefinedBehaviorSanitizer (UBSan)**: Mendeteksi perilaku undefined seperti integer overflow (`-fsanitize=undefined`)

Sanitizer memerlukan kompilasi ulang tetapi cukup cepat untuk digunakan di pipeline CI dan selama pengembangan reguler.

### Valgrind: Ketika Anda Tidak Bisa Mengkompilasi Ulang

[Valgrind](https://valgrind.org/) sebaliknya menjalankan program Anda di semacam mesin virtual untuk mendeteksi error memori. Lebih lambat daripada sanitizer tetapi tidak memerlukan kompilasi ulang:

```bash
valgrind --leak-check=full ./my_program
```

Gunakan Valgrind ketika:
- Anda tidak memiliki source code
- Anda tidak bisa mengkompilasi ulang (pustaka pihak ketiga)
- Anda membutuhkan alat spesifik yang tidak tersedia sebagai sanitizer

Valgrind sebenarnya adalah lingkungan eksekusi terkontrol yang sangat powerful, dan kita akan melihat lebih banyak tentang ini nanti saat masuk ke profiling!

## AI untuk Debugging

Model bahasa besar telah menjadi asisten debugging yang secara mengejutkan berguna. Mereka unggul dalam tugas-tugas debugging tertentu yang melengkapi alat tradisional.

**Di mana LLM bersinar:**

- **Menjelaskan pesan error yang misterius**: Error compiler, terutama dari template C++ atau borrow checker Rust, bisa sangat misterius. LLM dapat menerjemahkannya ke bahasa Inggris yang sederhana dan menyarankan perbaikan.

- **Menelusuri batas bahasa dan abstraksi**: Jika Anda men-debug masalah yang mencakup beberapa bahasa (misalnya, bug di pustaka C yang muncul melalui binding Python), LLM dapat membantu menavigasi lapisan-lapisan yang berbeda. Mereka sangat baik dalam memahami batas FFI, masalah build system, dan debugging lintas bahasa (misalnya, program saya error, tetapi saya percaya itu karena bug di salah satu dependensi saya).

- **Mengorelasikan gejala dengan akar penyebab**: "Program saya berjalan baik tetapi menggunakan memori 10x lebih banyak dari yang diharapkan" adalah jenis gejala samar yang dapat dibantu investigasi oleh LLM, dengan menyarankan penyebab yang mungkin dan apa yang harus dicari.

- **Menganalisis crash dump dan stack trace**: Tempelkan stack trace dan tanyakan apa yang mungkin menyebabkannya.

> **Catatan tentang debug symbol**: Untuk stack trace dan debugging yang bermakna, pastikan binary Anda (dan pustaka yang ditautkan) dikompilasi dengan debug symbol (flag `-g`). Informasi debug biasanya disimpan dalam format DWARF. Selain itu, kompilasi dengan frame pointer (`-fno-omit-frame-pointer`) membuat stack trace lebih andal, terutama untuk alat profiling. Tanpa ini, stack trace mungkin hanya menampilkan alamat memori atau tidak lengkap. Ini lebih penting untuk program yang dikompilasi secara native (C++, Rust) daripada Python atau Java.

**Keterbatasan yang perlu diingat:**
- LLM dapat berhalusinasi dengan penjelasan yang terdengar masuk akal tetapi salah
- Mereka mungkin menyarankan perbaikan yang menutupi bug alih-alih memperbaikinya
- Selalu verifikasi saran dengan alat debugging yang sebenarnya
- Mereka bekerja paling baik sebagai pelengkap, bukan pengganti, untuk memahami kode Anda

> Ini berbeda dari [kemampuan coding AI umum](/2026/development-environment/#ai-powered-development) yang dibahas dalam kuliah Development Environment. Di sini kita secara khusus berbicara tentang menggunakan LLM sebagai bantuan debugging.

# Profiling

Bahkan jika kode Anda secara fungsional berperilaku seperti yang Anda harapkan, itu mungkin tidak cukup baik jika membutuhkan semua CPU atau memori Anda dalam prosesnya. Kelas algoritma sering mengajarkan notasi big _O_ tetapi tidak cara menemukan titik panas dalam program Anda. Karena [optimasi prematur adalah akar dari segala kejahatan](https://wiki.c2.com/?PrematureOptimization), Anda harus mempelajari profiler dan alat monitoring. Mereka akan membantu Anda memahami bagian mana dari program Anda yang menghabiskan sebagian besar waktu dan/atau sumber daya sehingga Anda dapat fokus mengoptimalkan bagian-bagian tersebut.

## Timing

Cara paling sederhana untuk mengukur performa adalah dengan mengukur waktu. Dalam banyak skenario, cukup dengan mencetak waktu yang dibutuhkan kode Anda antara dua titik.

Namun, waktu wall clock bisa menyesatkan karena komputer Anda mungkin menjalankan proses lain pada saat yang sama atau menunggu peristiwa terjadi. Perintah `time` membedakan antara waktu _Real_, _User_, dan _Sys_:

- **Real** - Waktu wall clock dari awal hingga akhir, termasuk waktu yang dihabiskan untuk menunggu
- **User** - Waktu yang dihabiskan di CPU untuk menjalankan kode user
- **Sys** - Waktu yang dihabiskan di CPU untuk menjalankan kode kernel

```bash
$ time curl https://missing.csail.mit.edu &> /dev/null
real	0m0.272s
user	0m0.079s
sys	    0m0.028s
```

Di sini permintaan membutuhkan hampir 300 milidetik (waktu real) tetapi hanya 107ms waktu CPU (user + sys). Sisanya adalah menunggu jaringan.

## Resource Monitoring

Terkadang langkah pertama menuju menganalisis performa program Anda adalah memahami konsumsi sumber daya aktualnya. Program sering berjalan lambat ketika mereka dibatasi sumber dayanya.

- **Monitoring Umum**: [`htop`](https://htop.dev/) adalah versi peningkatan dari `top` yang menyajikan berbagai statistik untuk proses yang sedang berjalan. Keybind yang berguna: `<F6>` untuk mengurutkan proses, `t` untuk menampilkan hierarki tree, `h` untuk menampilkan thread. Ada juga [`btop`](https://github.com/aristocratos/btop) yang memonitor _jauh_ lebih banyak hal.

- **Operasi I/O**: [`iotop`](https://www.man7.org/linux/man-pages/man8/iotop.8.html) menampilkan informasi penggunaan I/O secara langsung.

- **Penggunaan Memori**: [`free`](https://www.man7.org/linux/man-pages/man1/free.1.html) menampilkan total memori yang bebas dan yang digunakan.

- **File Terbuka**: [`lsof`](https://www.man7.org/linux/man-pages/man8/lsof.8.html) mencantumkan informasi tentang file yang dibuka oleh proses. Berguna untuk memeriksa proses mana yang telah membuka file tertentu.

- **Koneksi Jaringan**: [`ss`](https://www.man7.org/linux/man-pages/man8/ss.8.html) memungkinkan Anda memonitor koneksi jaringan. Kasus penggunaan yang umum adalah mencari tahu proses mana yang menggunakan port tertentu: `ss -tlnp | grep :8080`.

- **Penggunaan Jaringan**: [`nethogs`](https://github.com/raboof/nethogs) dan [`iftop`](https://pdw.ex-parrot.com/iftop/) adalah alat CLI interaktif yang baik untuk memonitor penggunaan jaringan per proses.

## Visualisasi Data Performa

Manusia lebih cepat menemukan pola dalam grafik daripada dalam tabel angka. Saat menganalisis performa, memplot data Anda sering mengungkap tren, lonjakan, dan anomali yang tidak terlihat dalam angka mentah.

**Membuat data dapat diplot**: Saat menambahkan pernyataan print atau log untuk debugging, pertimbangkan untuk memformat output sehingga dapat dengan mudah dibuat grafiknya nanti. Timestamp dan nilai sederhana dalam format CSV (`1705012345,42.5`) jauh lebih mudah diplot daripada kalimat prosa. Log terstruktur JSON juga dapat diurai dan diplot dengan usaha minimal. Dengan kata lain, log data Anda [dengan cara yang rapi](https://vita.had.co.nz/papers/tidy-data.pdf).

**Plot cepat dengan gnuplot**: Untuk plotting command-line sederhana, [`gnuplot`](http://www.gnuplot.info/) dapat menghasilkan grafik langsung dari file data:

```bash
# Plot a simple CSV with timestamp,value
gnuplot -e "set datafile separator ','; plot 'latency.csv' using 1:2 with lines"
```

**Eksplorasi iteratif dengan matplotlib dan ggplot2**: Untuk analisis yang lebih mendalam, [`matplotlib`](https://matplotlib.org/) milik Python dan [`ggplot2`](https://ggplot2.tidyverse.org/) milik R memungkinkan eksplorasi iteratif. Berbeda dengan plotting sekali pakai, alat ini memungkinkan Anda dengan cepat memotong dan mentransformasi data untuk menyelidiki hipotesis. Facet plot ggplot2 sangat powerful—Anda dapat membagi satu dataset menjadi beberapa subplot berdasarkan kategori (misalnya, memfaset latensi permintaan berdasarkan endpoint atau waktu dalam sehari) untuk mengungkap pola yang jika tidak akan tersembunyi.

**Contoh kasus penggunaan:**
- Memplot latensi permintaan dari waktu ke waktu mengungkap perlambatan periodik (garbage collection, cron job, pola traffic) yang disembunyikan oleh persentil mentah
- Memvisualisasikan waktu insert untuk struktur data yang berkembang dapat mengungkap masalah kompleksitas algoritmik—plot insert vektor akan menunjukkan lonjakan khas ketika array pendukungnya bertambah dua kali lipat ukurannya
- Memfaset metrik berdasarkan dimensi berbeda (jenis permintaan, kohort pengguna, server) sering mengungkap bahwa masalah "seluruh sistem" sebenarnya terisolasi pada satu kategori

## CPU Profiler

Sebagian besar waktu ketika orang merujuk ke _profiler_ mereka berarti _CPU profiler_. Ada dua jenis utama:

- **Tracing profiler** menyimpan catatan dari setiap pemanggilan fungsi yang dibuat program Anda
- **Sampling profiler** memeriksa program Anda secara berkala (biasanya setiap milidetik) dan merekam stack program

Sampling profiler memiliki overhead yang lebih rendah dan umumnya lebih disukai untuk penggunaan produksi.

### perf: sampling profiler

[`perf`](https://www.man7.org/linux/man-pages/man1/perf.1.html) adalah profiler Linux standar. Dapat memprofilkan program apa pun tanpa kompilasi ulang:

`perf stat` memberi Anda gambaran singkat tentang di mana waktu dihabiskan:

```bash
$ perf stat ./slow_program

 Performance counter stats for './slow_program':

         3,210.45 msec task-clock                #    0.998 CPUs utilized
               12      context-switches          #    3.738 /sec
                0      cpu-migrations            #    0.000 /sec
              156      page-faults               #   48.587 /sec
   12,345,678,901      cycles                    #    3.845 GHz
    9,876,543,210      instructions              #    0.80  insn per cycle
    1,234,567,890      branches                  #  384.532 M/sec
       12,345,678      branch-misses             #    1.00% of all branches
```

Output profiler untuk program dunia nyata akan berisi sejumlah besar informasi. Manusia adalah makhluk visual dan cukup buruk dalam membaca sejumlah besar angka. [Flame graph](https://www.brendangregg.com/flamegraphs.html) adalah visualisasi yang membuat data profiling jauh lebih mudah dipahami.

Flame graph menampilkan hierarki pemanggilan fungsi pada sumbu Y dan waktu yang dihabiskan sebanding dengan sumbu X. Mereka interaktif—Anda dapat mengklik untuk memperbesar bagian tertentu dari program.

[![FlameGraph](https://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)](https://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)

Untuk menghasilkan flame graph dari data `perf`:

```bash
# Record profile
perf record -g ./my_program

# Generate flame graph (requires flamegraph scripts)
perf script | stackcollapse-perf.pl | flamegraph.pl > flamegraph.svg
```

> Pertimbangkan untuk menggunakan [Speedscope](https://www.speedscope.app/) untuk penampil flame graph berbasis web interaktif, atau [Perfetto](https://perfetto.dev/) untuk analisis komprehensif tingkat sistem.

### Callgrind milik Valgrind: tracing profiler

[`callgrind`](https://valgrind.org/docs/manual/cl-manual.html) adalah alat profiling yang merekam riwayat panggilan dan hitungan instruksi program Anda. Berbeda dengan sampling profiler, alat ini memberikan hitungan panggilan yang tepat dan dapat menunjukkan hubungan antara pemanggil dan yang dipanggil:

```bash
# Run with callgrind
valgrind --tool=callgrind ./my_program

# Analyze with callgrind_annotate (text) or kcachegrind (GUI)
callgrind_annotate callgrind.out.<pid>
kcachegrind callgrind.out.<pid>
```

Callgrind lebih lambat daripada sampling profiler tetapi memberikan hitungan panggilan yang tepat dan secara opsional dapat mensimulasikan perilaku cache (dengan `--cache-sim=yes`) jika Anda membutuhkan informasi tersebut.

> Jika Anda menggunakan bahasa tertentu, mungkin ada profiler yang lebih khusus. Misalnya, Python memiliki [`cProfile`](https://docs.python.org/3/library/profile.html) dan [`py-spy`](https://github.com/benfred/py-spy), Go memiliki [`go tool pprof`](https://pkg.go.dev/cmd/pprof), dan Rust memiliki [`cargo-flamegraph`](https://github.com/flamegraph-rs/flamegraph) (yang sebenarnya bekerja untuk program terkompilasi apa pun!).

## Memory Profiler

Memory profiler membantu Anda memahami bagaimana program Anda menggunakan memori dari waktu ke waktu dan menemukan memory leak.

### Massif milik Valgrind

[`massif`](https://valgrind.org/docs/manual/ms-manual.html) memprofilkan penggunaan heap memory:

```bash
valgrind --tool=massif ./my_program
ms_print massif.out.<pid>
```

Ini menampilkan penggunaan heap dari waktu ke waktu, membantu mengidentifikasi memory leak dan alokasi yang berlebihan.

> Untuk Python, [`memory-profiler`](https://pypi.org/project/memory-profiler/) menyediakan informasi penggunaan memori baris per baris.

## Benchmarking

Ketika Anda perlu membandingkan performa dari implementasi atau alat yang berbeda, [`hyperfine`](https://github.com/sharkdp/hyperfine) sangat baik untuk benchmarking program command-line:

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

> Untuk pengembangan web, browser developer tools menyertakan profiler yang sangat baik. Lihat dokumentasi [Firefox Profiler](https://profiler.firefox.com/docs/) dan [Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools/rendering-tools).

# Latihan

## Debugging

1. **Debug algoritma sorting**: Pseudocode berikut mengimplementasikan merge sort tetapi mengandung bug. Implementasikan dalam bahasa pilihan Anda, lalu gunakan debugger (gdb, lldb, pdb, atau debugger IDE Anda) untuk menemukan dan memperbaiki bug tersebut.

   ```
   function merge_sort(arr):
       if length(arr) <= 1:
           return arr
       mid = length(arr) / 2
       left = merge_sort(arr[0..mid])
       right = merge_sort(arr[mid..end])
       return merge(left, right)

   function merge(left, right):
       result = []
       i = 0, j = 0
       while i < length(left) AND j < length(right):
           if left[i] <= right[j]:
               append result, left[i]
               i = i + 1
           else:
               append result, right[i]
               j = j + 1
       append remaining elements from left and right
       return result
   ```

   Test vector: `merge_sort([3, 1, 4, 1, 5, 9, 2, 6])` seharusnya mengembalikan `[1, 1, 2, 3, 4, 5, 6, 9]`. Gunakan breakpoint dan telusuri fungsi merge untuk menemukan di mana elemen yang salah dipilih.

1. Install [`rr`](https://rr-project.org/) dan gunakan reverse debugging untuk menemukan bug korupsi. Simpan program ini sebagai `corruption.c`:

   ```c
   #include <stdio.h>

   typedef struct {
       int id;
       int scores[3];
   } Student;

   Student students[2];

   void init() {
       students[0].id = 1001;
       students[0].scores[0] = 85;
       students[0].scores[1] = 92;
       students[0].scores[2] = 78;

       students[1].id = 1002;
       students[1].scores[0] = 90;
       students[1].scores[1] = 88;
       students[1].scores[2] = 95;
   }

   void curve_scores(int student_idx, int curve) {
       for (int i = 0; i < 4; i++) {
           students[student_idx].scores[i] += curve;
       }
   }

   int main() {
       init();
       printf("=== Initial state ===\n");
       printf("Student 0: id=%d\n", students[0].id);
       printf("Student 1: id=%d\n", students[1].id);

       curve_scores(0, 5);

       printf("\n=== After curving ===\n");
       printf("Student 0: id=%d\n", students[0].id);
       printf("Student 1: id=%d\n", students[1].id);

       if (students[1].id != 1002) {
           printf("\nERROR: Student 1's ID was corrupted! Expected 1002, got %d\n",
                  students[1].id);
           return 1;
       }
       return 0;
   }
   ```

   Kompilasi dengan `gcc -g corruption.c -o corruption` dan jalankan. ID Student 1 menjadi rusak, tetapi korupsi terjadi di fungsi yang hanya menyentuh student 0. Gunakan `rr record ./corruption` dan `rr replay` untuk menemukan pelakunya. Atur watchpoint pada `students[1].id` dan gunakan `reverse-continue` setelah korupsi untuk menemukan secara tepat baris kode mana yang menimpanya.

1. Debug error memori dengan AddressSanitizer. Simpan ini sebagai `uaf.c`:

   ```c
   #include <stdlib.h>
   #include <string.h>
   #include <stdio.h>

   int main() {
       char *greeting = malloc(32);
       strcpy(greeting, "Hello, world!");
       printf("%s\n", greeting);

       free(greeting);

       greeting[0] = 'J';
       printf("%s\n", greeting);

       return 0;
   }
   ```

   Pertama kompilasi dan jalankan tanpa sanitizer: `gcc uaf.c -o uaf && ./uaf`. Mungkin terlihat berfungsi. Sekarang kompilasi dengan AddressSanitizer: `gcc -fsanitize=address -g uaf.c -o uaf && ./uaf`. Baca laporan error. Bug apa yang ditemukan ASan? Perbaiki masalah yang diidentifikasinya.

1. Gunakan `strace` (Linux) atau `dtruss` (macOS) untuk men-trace system call yang dibuat oleh perintah seperti `ls -l`. System call apa saja yang dibuatnya? Coba trace program yang lebih kompleks dan lihat file apa yang dibukanya.

1. Gunakan LLM untuk membantu men-debug pesan error yang misterius. Coba salin error compiler (terutama dari template C++ atau Rust) dan minta penjelasan serta perbaikan. Coba masukkan beberapa output dari `strace` atau address sanitizer ke dalamnya.

## Profiling

1. Gunakan `perf stat` untuk mendapatkan statistik performa dasar untuk program pilihan Anda. Apa arti dari masing-masing counter?

1. Profil dengan `perf record`. Simpan ini sebagai `slow.c`:

   ```c
   #include <math.h>
   #include <stdio.h>

   double slow_computation(int n) {
       double result = 0;
       for (int i = 0; i < n; i++) {
           for (int j = 0; j < 1000; j++) {
               result += sin(i * j) * cos(i + j);
           }
       }
       return result;
   }

   int main() {
       double r = 0;
       for (int i = 0; i < 100; i++) {
           r += slow_computation(1000);
       }
       printf("Result: %f\n", r);
       return 0;
   }
   ```

   Kompilasi dengan debug symbol: `gcc -g -O2 slow.c -o slow -lm`. Jalankan `perf record -g ./slow`, lalu `perf report` untuk melihat di mana waktu dihabiskan. Coba hasilkan flame graph menggunakan skrip flamegraph.

1. Gunakan `hyperfine` untuk membenchmark dua implementasi berbeda dari tugas yang sama (misalnya, `find` vs `fd`, `grep` vs `ripgrep`, atau dua versi kode Anda sendiri).

1. Gunakan `htop` untuk memonitor sistem Anda saat menjalankan program yang intensif sumber daya. Coba gunakan `taskset` untuk membatasi CPU mana yang dapat digunakan oleh suatu proses: `taskset --cpu-list 0,2 stress -c 3`. Mengapa `stress` tidak menggunakan tiga CPU?

1. Masalah umum adalah port yang ingin Anda gunakan untuk mendengarkan sudah diambil oleh proses lain. Pelajari cara menemukan proses tersebut: Pertama jalankan `python -m http.server 4444` untuk memulai web server minimal di port 4444. Di terminal terpisah jalankan `ss -tlnp | grep 4444` untuk menemukan prosesnya. Hentikan dengan `kill <PID>`.