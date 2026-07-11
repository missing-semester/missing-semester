---
layout: lecture
title: "Tanya Jawab"
description: >
  Jawaban atas pertanyaan mahasiswa seputar topik seperti sistem operasi, shell scripting, rekomendasi tools, dan lainnya.
thumbnail: /static/assets/thumbnails/2020/lec11.png
date: 2020-01-30
ready: true
video:
  aspect: 56.25
  id: Wz50FvGG6xU
special: true
---

Untuk kuliah terakhir, kami menjawab pertanyaan-pertanyaan yang diajukan oleh para mahasiswa:

- [Ada rekomendasi untuk mempelajari topik terkait Sistem Operasi seperti proses, memori virtual, interrupt, manajemen memori, dll?](#any-recommendations-on-learning-operating-systems-related-topics-like-processes-virtual-memory-interrupts-memory-management-etc)
- [Tools apa saja yang sebaiknya diprioritaskan untuk dipelajari pertama kali?](#what-are-some-of-the-tools-youd-prioritize-learning-first)
- [Kapan saya harus menggunakan Python versus skrip Bash versus bahasa lainnya?](#when-do-i-use-python-versus-a-bash-scripts-versus-some-other-language)
- [Apa perbedaan antara `source script.sh` dan `./script.sh`?](#what-is-the-difference-between-source-scriptsh-and-scriptsh)
- [Di mana berbagai paket dan tools disimpan dan bagaimana cara mereferensikannya? Apa sebenarnya `/bin` atau `/lib`?](#what-are-the-places-where-various-packages-and-tools-are-stored-and-how-does-referencing-them-work-what-even-is-bin-or-lib)
- [Haruskah saya `apt-get install` python-whatever, atau `pip install` whatever package?](#should-i-apt-get-install-a-python-whatever-or-pip-install-whatever-package)
- [Apa tools profiling yang paling mudah dan terbaik untuk meningkatkan performa kode saya?](#whats-the-easiest-and-best-profiling-tools-to-use-to-improve-performance-of-my-code)
- [Plugin browser apa saja yang Anda gunakan?](#what-browser-plugins-do-you-use)
- [Apa saja tools data wrangling lainnya yang berguna?](#what-are-other-useful-data-wrangling-tools)
- [Apa perbedaan antara Docker dan Virtual Machine?](#what-is-the-difference-between-docker-and-a-virtual-machine)
- [Apa kelebihan dan kekurangan masing-masing OS dan bagaimana cara memilih di antaranya (misalnya memilih distribusi Linux terbaik untuk keperluan kita)?](#what-are-the-advantages-and-disadvantages-of-each-os-and-how-can-we-choose-between-them-eg-choosing-the-best-linux-distribution-for-our-purposes)
- [Vim vs Emacs?](#vim-vs-emacs)
- [Ada tips atau trik untuk aplikasi Machine Learning?](#any-tips-or-tricks-for-machine-learning-applications)
- [Ada tips Vim lainnya?](#any-more-vim-tips)
- [Apa itu 2FA dan mengapa saya harus menggunakannya?](#what-is-2fa-and-why-should-i-use-it)
- [Ada komentar tentang perbedaan antar web browser?](#any-comments-on-differences-between-web-browsers)

## Ada rekomendasi untuk mempelajari topik terkait Sistem Operasi seperti proses, memori virtual, interrupt, manajemen memori, dll?

Pertama, belum jelas apakah Anda benar-benar perlu sangat familiar dengan semua topik ini karena semuanya adalah topik tingkat rendah.
Topik-topik ini akan relevan ketika Anda mulai menulis kode tingkat rendah seperti mengimplementasikan atau memodifikasi kernel. Jika tidak, sebagian besar topik tidak akan relevan, kecuali proses dan sinyal yang telah dibahas secara singkat di kuliah-kuliah lainnya.

Beberapa sumber belajar yang bagus tentang topik ini:

- [MIT's 6.828 class](https://pdos.csail.mit.edu/6.828/) - Kelas tingkat pascasarjana tentang Operating System Engineering. Materi kelas tersedia secara publik.
- Modern Operating Systems (4th ed) - oleh Andrew S. Tanenbaum adalah gambaran umum yang bagus tentang banyak konsep yang disebutkan.
- The Design and Implementation of the FreeBSD Operating System - Sumber bagus tentang OS FreeBSD (perhatikan bahwa ini bukan Linux).
- Panduan lain seperti [Writing an OS in Rust](https://os.phil-opp.com/) di mana orang-orang mengimplementasikan kernel langkah demi langkah dalam berbagai bahasa, sebagian besar untuk tujuan pengajaran.


## Tools apa saja yang sebaiknya diprioritaskan untuk dipelajari pertama kali?

Beberapa topik yang sebaiknya diprioritaskan:

- Belajar menggunakan keyboard lebih banyak dan mouse lebih sedikit. Ini bisa melalui shortcut keyboard, mengubah antarmuka, &c.
- Menguasai editor Anda dengan baik. Sebagai programmer, sebagian besar waktu Anda dihabiskan untuk mengedit file jadi sangat bermanfaat untuk mempelajari keterampilan ini dengan baik.
- Belajar cara mengotomatisasi dan/atau menyederhanakan tugas-tugas berulang dalam workflow Anda karena penghematan waktunya akan sangat besar...
- Belajar tentang tools version control seperti Git dan cara menggunakannya bersama GitHub untuk berkolaborasi dalam proyek perangkat lunak modern.

## Kapan saya harus menggunakan Python versus skrip Bash versus bahasa lainnya?

Secara umum, skrip bash berguna untuk skrip singkat dan sederhana yang bersifat sekali pakai ketika Anda hanya ingin menjalankan serangkaian perintah tertentu. bash memiliki sejumlah keanehan yang membuatnya sulit digunakan untuk program atau skrip yang lebih besar:

- bash mudah digunakan untuk kasus sederhana tetapi bisa sangat sulit untuk menangani semua kemungkinan input. Contohnya, spasi pada argumen skrip telah menyebabkan banyak bug dalam skrip bash.
- bash tidak mendukung penggunaan ulang kode sehingga sulit untuk menggunakan kembali komponen dari program yang pernah Anda tulis. Secara lebih umum, tidak ada konsep pustaka perangkat lunak dalam bash.
- bash bergantung pada banyak string ajaib seperti `$?` atau `$@` untuk merujuk pada nilai-nilai tertentu, sedangkan bahasa lain merujuknya secara eksplisit, seperti `exitCode` atau `sys.args`.

Oleh karena itu, untuk skrip yang lebih besar dan/atau lebih kompleks, kami merekomendasikan menggunakan bahasa scripting yang lebih matang seperti Python atau Ruby.
Anda bisa menemukan banyak pustaka online yang telah ditulis orang lain untuk menyelesaikan masalah umum dalam bahasa-bahasa ini.
Jika Anda menemukan pustaka yang mengimplementasikan fungsionalitas spesifik yang Anda butuhkan dalam suatu bahasa, biasanya yang terbaik adalah langsung menggunakan bahasa tersebut.

## Apa perbedaan antara `source script.sh` dan `./script.sh`?

Dalam kedua kasus, `script.sh` akan dibaca dan dieksekusi dalam sesi bash, perbedaannya terletak pada sesi mana yang menjalankan perintah tersebut.
Untuk `source`, perintah dijalankan di sesi bash Anda saat ini sehingga setiap perubahan yang dibuat pada environment saat ini, seperti mengubah direktori atau mendefinisikan fungsi, akan tetap ada di sesi saat ini setelah perintah `source` selesai dieksekusi.
Ketika menjalankan skrip secara mandiri seperti `./script.sh`, sesi bash Anda saat ini memulai instance bash baru yang akan menjalankan perintah di `script.sh`.
Jadi, jika `script.sh` mengubah direktori, instance bash baru akan mengubah direktori, tetapi setelah keluar dan mengembalikan kontrol ke sesi bash induk, sesi induk akan tetap di tempat yang sama.
Demikian pula, jika `script.sh` mendefinisikan fungsi yang ingin Anda akses di terminal, Anda perlu melakukan `source` agar fungsi tersebut terdefinisi di sesi bash Anda saat ini. Jika tidak, saat Anda menjalankannya, proses bash baru yang akan memproses definisi fungsi tersebut, bukan shell Anda saat ini.

## Di mana berbagai paket dan tools disimpan dan bagaimana cara mereferensikannya? Apa sebenarnya `/bin` atau `/lib`?

Terkait program yang Anda jalankan di terminal, semuanya ditemukan di direktori yang terdaftar di variabel environment `PATH` Anda dan Anda bisa menggunakan perintah `which` (atau perintah `type`) untuk mengecek di mana shell Anda menemukan program tertentu.
Secara umum, ada beberapa konvensi tentang di mana jenis file tertentu berada. Berikut beberapa yang telah kita bahas, silakan cek [Filesystem, Hierarchy Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard) untuk daftar yang lebih lengkap.

- `/bin` - Binary perintah esensial
- `/sbin` - Binary sistem esensial, biasanya dijalankan oleh root
- `/dev` - File perangkat, file khusus yang seringkali merupakan antarmuka ke perangkat keras
- `/etc` - File konfigurasi sistem spesifik host untuk seluruh sistem
- `/home` - Direktori home untuk pengguna dalam sistem
- `/lib` - Pustaka umum untuk program sistem
- `/opt` - Perangkat lunak aplikasi opsional
- `/sys` - Berisi informasi dan konfigurasi untuk sistem (dibahas di [kuliah pertama](/2020/course-shell/))
- `/tmp` - File sementara (juga `/var/tmp`). Biasanya dihapus antara reboot.
- `/usr/` - Data pengguna yang hanya bisa dibaca
  + `/usr/bin` - Binary perintah non-esensial
  + `/usr/sbin` - Binary sistem non-esensial, biasanya dijalankan oleh root
  + `/usr/local/bin` - Binary untuk program yang dikompilasi pengguna
- `/var` - File variabel seperti log atau cache

## Haruskah saya `apt-get install` python-whatever, atau `pip install` whatever package?

Tidak ada jawaban universal untuk pertanyaan ini. Ini terkait dengan pertanyaan yang lebih umum apakah Anda harus menggunakan package manager sistem atau package manager spesifik bahasa untuk menginstal perangkat lunak. Beberapa hal yang perlu diperhatikan:

- Paket umum akan tersedia melalui keduanya, tetapi paket yang kurang populer atau yang lebih baru mungkin tidak tersedia di package manager sistem Anda. Dalam kasus ini, menggunakan tools spesifik bahasa adalah pilihan yang lebih baik.
- Demikian pula, package manager spesifik bahasa biasanya memiliki versi paket yang lebih terbaru dibandingkan package manager sistem.
- Saat menggunakan package manager sistem, pustaka akan diinstal secara sistem-wide. Ini berarti jika Anda memerlukan versi pustaka yang berbeda untuk tujuan pengembangan, package manager sistem mungkin tidak memadai. Untuk skenario ini, sebagian besar bahasa pemrograman menyediakan semacam isolated atau virtual environment sehingga Anda bisa menginstal versi pustaka yang berbeda tanpa mengalami konflik. Untuk Python, ada virtualenv, dan untuk Ruby, ada RVM.
- Tergantung pada sistem operasi dan arsitektur perangkat keras, beberapa paket ini mungkin sudah disertai binary atau perlu dikompilasi. Misalnya, pada komputer ARM seperti Raspberry Pi, menggunakan package manager sistem bisa lebih baik daripada yang spesifik bahasa jika yang pertama tersedia dalam bentuk binary dan yang kedua perlu dikompilasi. Ini sangat tergantung pada setup spesifik Anda.

Anda sebaiknya mencoba menggunakan satu solusi atau yang lain, bukan keduanya, karena hal itu dapat menyebabkan konflik yang sulit di-debug. Rekomendasi kami adalah menggunakan package manager spesifik bahasa bila memungkinkan, dan menggunakan isolated environment (seperti virtualenv Python) untuk menghindari polusi pada environment global.

## Apa tools profiling yang paling mudah dan terbaik untuk meningkatkan performa kode saya?

Tools paling mudah yang cukup berguna untuk tujuan profiling adalah [print timing](/2020/debugging-profiling/#timing).
Anda cukup menghitung secara manual waktu yang dibutuhkan antar bagian kode Anda. Dengan melakukan ini berulang kali, Anda secara efektif bisa melakukan binary search pada kode Anda dan menemukan segmen kode yang memakan waktu paling lama.

Untuk tools yang lebih canggih, Valgrind's [Callgrind](https://valgrind.org/docs/manual/cl-manual.html) memungkinkan Anda menjalankan program dan mengukur berapa lama setiap bagian berjalan serta semua call stack, yaitu fungsi mana yang memanggil fungsi lainnya. Kemudian menghasilkan versi anotasi dari source code program Anda dengan waktu yang dibutuhkan per baris. Namun, ini memperlambat program Anda hingga satu orde magnitudo dan tidak mendukung thread. Untuk kasus lain, tool [`perf`](https://www.brendangregg.com/perf.html) dan profiler sampling spesifik bahasa lainnya dapat menghasilkan data yang berguna dengan cukup cepat. [Flamegraphs](https://www.brendangregg.com/flamegraphs.html) adalah tools visualisasi yang bagus untuk output dari profiler sampling tersebut. Anda juga sebaiknya menggunakan tools khusus untuk bahasa pemrograman atau tugas yang sedang Anda kerjakan. Misalnya, untuk pengembangan web, dev tools bawaan Chrome dan Firefox memiliki profiler yang fantastis.

Terkadang bagian kode yang lambat disebabkan karena sistem Anda sedang menunggu event seperti pembacaan disk atau paket jaringan. Dalam kasus tersebut, ada baiknya memeriksa bahwa perhitungan kasar tentang kecepatan teoretis berdasarkan kemampuan perangkat keras tidak menyimpang dari pembacaan aktual. Ada juga tools khusus untuk menganalisis waktu tunggu dalam system call. Ini termasuk tools seperti [eBPF](https://www.brendangregg.com/blog/2019-01-01/learn-ebpf-tracing.html) yang melakukan kernel tracing pada program user. Khususnya [`bpftrace`](https://github.com/iovisor/bpftrace) patut dicoba jika Anda perlu melakukan profiling tingkat rendah semacam ini.


## Plugin browser apa saja yang Anda gunakan?

Beberapa favorit kami, sebagian besar terkait keamanan dan kegunaan:

- [uBlock Origin](https://github.com/gorhill/uBlock) - Ini adalah blocker [wide-spectrum](https://github.com/gorhill/uBlock/wiki/Blocking-mode) yang tidak hanya menghentikan iklan, tetapi juga semua jenis komunikasi pihak ketiga yang mungkin dicoba oleh suatu halaman. Ini juga mencakup skrip inline dan jenis pemuatan sumber daya lainnya. Jika Anda bersedia meluangkan waktu untuk konfigurasi agar mọi sesuatu berfungsi, beralihlah ke [medium mode](https://github.com/gorhill/uBlock/wiki/Blocking-mode:-medium-mode) atau bahkan [hard mode](https://github.com/gorhill/uBlock/wiki/Blocking-mode:-hard-mode). Itu akan membuat beberapa situs tidak berfungsi sampai Anda cukup mengutak-atik pengaturannya, tetapi juga akan secara signifikan meningkatkan keamanan online Anda. Jika tidak, [easy mode](https://github.com/gorhill/uBlock/wiki/Blocking-mode:-easy-mode) sudah menjadi default yang bagus yang memblokir sebagian besar iklan dan pelacakan. Anda juga bisa menentukan aturan Anda sendiri tentang objek situs web mana yang akan diblokir.
- [Stylus](https://github.com/openstyles/stylus/) - fork dari Stylish (jangan gunakan Stylish, terbukti [mencuri riwayat browsing pengguna](https://www.theregister.co.uk/2018/07/05/browsers_pull_stylish_but_invasive_browser_extension/)), memungkinkan Anda memuat stylesheet CSS kustom ke situs web. Dengan Stylus, Anda bisa dengan mudah mengkustomisasi dan mengubah tampilan situs web. Ini bisa berupa menghapus sidebar, mengubah warna latar belakang, atau bahkan ukuran teks atau pilihan font. Ini sangat bagus untuk membuat situs web yang sering Anda kunjungi menjadi lebih mudah dibaca. Selain itu, Stylus bisa menemukan gaya yang ditulis oleh pengguna lain dan dipublikasikan di [userstyles.org](https://userstyles.org/). Sebagian besar situs web umum memiliki satu atau beberapa stylesheet tema gelap, misalnya.
- Full Page Screen Capture - [Built into Firefox](https://screenshots.firefox.com/) dan [Chrome extension](https://chrome.google.com/webstore/detail/full-page-screen-capture/fdpohaocaechififmbbbbbknoalclacl?hl=en). Memungkinkan Anda mengambil screenshot dari seluruh situs web, seringkali jauh lebih baik daripada mencetak untuk tujuan referensi.
- [Multi Account Containers](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/) - memungkinkan Anda memisahkan cookie ke dalam "container", memungkinkan Anda menjelajahi web dengan identitas berbeda dan/atau memastikan bahwa situs web tidak dapat berbagi informasi di antara mereka.
- Password Manager Integration - Sebagian besar password manager memiliki ekstensi browser yang membuat memasukkan kredensial Anda ke situs web tidak hanya lebih nyaman tetapi juga lebih aman. Dibandingkan dengan hanya copy-paste user dan password Anda, tools ini pertama-tama akan memeriksa bahwa domain situs web cocok dengan yang terdaftar untuk entri tersebut, mencegah serangan phishing yang meniru situs web populer untuk mencuri kredensial.
- [Vimium](https://github.com/philc/vimium) - Ekstensi browser yang menyediakan navigasi dan kontrol web berbasis keyboard dalam semangat editor Vim.

## Apa saja tools data wrangling lainnya yang berguna?

Beberapa tools data wrangling yang tidak sempat kita bahas selama kuliah data wrangling meliputi `jq` atau `pup` yang merupakan parser khusus untuk data JSON dan HTML. Bahasa pemrograman Perl juga merupakan tools bagus untuk pipeline data wrangling yang lebih canggih. Trik lainnya adalah perintah `column -t` yang bisa digunakan untuk mengonversi teks whitespace (belum tentu rata) menjadi teks yang rata kolom dengan benar.

Secara lebih umum, beberapa tools data wrangling yang lebih tidak konvensional adalah vim dan Python. Untuk transformasi yang kompleks dan multi-baris, macro vim bisa menjadi tools yang sangat berharga. Anda cukup merekam serangkaian tindakan dan mengulanginya sebanyak yang Anda inginkan, misalnya di [catatan kuliah](/2020/editors/#macros) editor (dan [video](/2019/editors/) tahun lalu) ada contoh mengonversi file berformat XML menjadi JSON hanya menggunakan macro vim.

Untuk data tabular, yang sering disajikan dalam CSV, pustaka Python [pandas](https://pandas.pydata.org/) adalah tools yang hebat. Tidak hanya karena memudahkan untuk mendefinisikan operasi kompleks seperti group by, join, atau filter; tetapi juga memudahkan untuk memplot berbagai properti data Anda. Ini juga mendukung ekspor ke banyak format tabel termasuk XLS, HTML, atau LaTeX. Sebagai alternatif, bahasa pemrograman R (bahasa pemrograman yang bisa dibilang [buruk](https://arrgh.tim-smith.us/)) memiliki banyak fungsionalitas untuk menghitung statistik atas data dan bisa sangat berguna sebagai langkah terakhir dalam pipeline Anda. [ggplot2](https://ggplot2.tidyverse.org/) adalah pustaka plotting yang hebat di R.

## Apa perbedaan antara Docker dan Virtual Machine?

Docker didasarkan pada konsep yang lebih umum yang disebut container. Perbedaan utama antara container dan virtual machine adalah bahwa virtual machine akan menjalankan seluruh stack OS, termasuk kernel, meskipun kernelnya sama dengan mesin host. Berbeda dengan VM, container menghindari menjalankan instance kernel lain dan sebaliknya berbagi kernel dengan host. Di Linux, ini dicapai melalui mekanisme yang disebut LXC, dan memanfaatkan serangkaian mekanisme isolasi untuk menjalankan program yang berpikir berjalan di perangkat kerasnya sendiri tetapi sebenarnya berbagi perangkat keras dan kernel dengan host. Jadi, container memiliki overhead yang lebih rendah daripada VM penuh.
Di sisi lain, container memiliki isolasi yang lebih lemah dan hanya berfungsi jika host menjalankan kernel yang sama. Misalnya jika Anda menjalankan Docker di macOS, Docker perlu menjalankan virtual machine Linux untuk mendapatkan kernel Linux awal sehingga overheadnya tetap signifikan. Terakhir, Docker adalah implementasi spesifik dari container dan disesuaikan untuk deployment perangkat lunak. Karena itu, ada beberapa keanehan: misalnya, container Docker tidak akan menyimpan penyimpanan apapun secara default antara reboot.

## Apa kelebihan dan kekurangan masing-masing OS dan bagaimana cara memilih di antaranya (misalnya memilih distribusi Linux terbaik untuk keperluan kita)?

Terkait distro Linux, meskipun ada banyak sekali distro, sebagian besar akan berperilaku cukup identik untuk sebagian besar kasus penggunaan.
Sebagian besar fitur dan cara kerja internal Linux dan UNIX dapat dipelajari di distro mana pun.
Perbedaan mendasar antar distro adalah bagaimana mereka menangani pembaruan paket.
Beberapa distro, seperti Arch Linux, menggunakan kebijakan rolling update di mana semuanya terbaru tetapi hal-hal bisa rusak setiap saat. Di sisi lain, beberapa distro seperti Debian, CentOS, atau rilis LTS Ubuntu jauh lebih konservatif dalam merilis pembaruan di repositori mereka sehingga semuanya biasanya lebih stabil dengan mengorbankan fitur-fitur baru.
Rekomendasi kami untuk pengalaman yang mudah dan stabil baik untuk desktop maupun server adalah menggunakan Debian atau Ubuntu.

Mac OS adalah titik tengah yang bagus antara Windows dan Linux yang memiliki antarmuka yang dipoles dengan baik. Namun, Mac OS didasarkan pada BSD daripada Linux, sehingga beberapa bagian sistem dan perintahnya berbeda.
Alternatif yang patut dicoba adalah FreeBSD. Meskipun beberapa program tidak akan berjalan di FreeBSD, ekosistem BSD jauh tidak terfragmentasi dan lebih terdokumentasi dengan baik daripada Linux.
Kami tidak merekomendasikan Windows untuk apa pun kecuali untuk mengembangkan aplikasi Windows atau jika ada fitur deal breaker yang Anda butuhkan, seperti dukungan driver yang baik untuk gaming.

Untuk sistem dual boot, kami pikir implementasi yang paling berfungsi adalah bootcamp macOS dan bahwa kombinasi lainnya bisa bermasalah dalam jangka panjang, terutama jika Anda menggabungkannya dengan fitur lain seperti enkripsi disk.

## Vim vs Emacs?

Kami bertiga menggunakan vim sebagai editor utama kami, tetapi Emacs juga merupakan alternatif yang bagus dan patut dicoba keduanya untuk melihat mana yang lebih cocok untuk Anda. Emacs tidak mengikuti pengeditan modal vim, tetapi ini bisa diaktifkan melalui plugin Emacs seperti [Evil](https://github.com/emacs-evil/evil) atau [Doom Emacs](https://github.com/hlissner/doom-emacs).
Keuntungan menggunakan Emacs adalah ekstensi dapat diimplementasikan dalam Lisp, bahasa scripting yang lebih baik daripada vimscript, bahasa scripting default Vim.

## Ada tips atau trik untuk aplikasi Machine Learning?

Beberapa pelajaran dan takeaway dari kelas ini dapat langsung diterapkan ke aplikasi ML.
Seperti halnya banyak disiplin ilmu, di ML Anda sering melakukan serangkaian eksperimen dan ingin memeriksa hal-hal mana yang berhasil dan mana yang tidak.
Anda bisa menggunakan tools shell untuk mencari melalui eksperimen-eksperimen ini dengan mudah dan cepat serta menggabungkan hasilnya dengan cara yang masuk akal. Ini bisa berarti memilih semua eksperimen dalam jangka waktu tertentu atau yang menggunakan dataset tertentu. Dengan menggunakan file JSON sederhana untuk mencatat semua parameter relevan dari eksperimen, ini bisa menjadi sangat sederhana dengan tools yang kita bahas di kelas ini.
Terakhir, jika Anda tidak bekerja dengan semacam cluster tempat Anda mengirim pekerjaan GPU, Anda sebaiknya mencari cara untuk mengotomatisasi proses ini karena ini bisa menjadi tugas yang sangat memakan waktu dan juga menguras energi mental Anda.

## Ada tips Vim lainnya?

Beberapa tips tambahan:

- Plugin - Luangkan waktu Anda dan jelajahi lanskap plugin. Ada banyak plugin hebat yang mengatasi beberapa kekurangan vim atau menambahkan fungsionalitas baru yang berpadu dengan baik dengan workflow vim yang ada. Untuk ini, sumber daya yang bagus adalah [VimAwesome](https://vimawesome.com/) dan dotfiles para programmer lainnya.
- Marks - Di vim, Anda bisa men-set mark dengan melakukan `m<X>` untuk huruf `X` tertentu. Anda kemudian bisa kembali ke mark tersebut dengan melakukan `'<X>`. Ini memungkinkan Anda berpindah dengan cepat ke lokasi spesifik dalam file atau bahkan antar file.
- Navigasi - `Ctrl+O` dan `Ctrl+I` memindahkan Anda mundur dan maju masing-masing melalui lokasi yang baru-baru ini dikunjungi.
- Undo Tree - Vim memiliki mekanisme yang cukup canggih untuk melacak perubahan. Berbeda dengan editor lain, vim menyimpan pohon perubahan sehingga meskipun Anda undo dan kemudian membuat perubahan berbeda, Anda masih bisa kembali ke keadaan semula dengan menavigasi pohon undo. Beberapa plugin seperti [gundo.vim](https://github.com/sjl/gundo.vim) dan [undotree](https://github.com/mbbill/undotree) menampilkan pohon ini secara grafis.
- Undo dengan waktu - Perintah `:earlier` dan `:later` akan memungkinkan Anda menavigasi file menggunakan referensi waktu alih-alih satu perubahan pada satu waktu.
- [Persistent undo](https://vim.fandom.com/wiki/Using_undo_branches#Persistent_undo) adalah fitur bawaan vim yang luar biasa yang dinonaktifkan secara default. Ini mempertahankan riwayat undo antar pemanggilan vim. Dengan men-set `undofile` dan `undodir` di `.vimrc` Anda, vim akan menyimpan riwayat perubahan per file.
- Leader Key - Leader key adalah kunci khusus yang sering dibiarkan untuk dikonfigurasi pengguna untuk perintah kustom. Polanya biasanya adalah menekan dan melepaskan kunci ini (seringkali kunci spasi) lalu menekan kunci lainnya untuk menjalankan perintah tertentu. Seringkali, plugin akan menggunakan kunci ini untuk menambahkan fungsionalitas mereka sendiri, misalnya plugin UndoTree menggunakan `<Leader> U` untuk membuka pohon undo.
- Advanced Text Objects - Text objects seperti pencarian juga bisa dikomposisikan dengan perintah vim. Misalnya `d/<pattern>` akan menghapus hingga ke match berikutnya dari pola tersebut atau `cgn` akan mengubah kemunculan berikutnya dari string yang terakhir dicari.

## Apa itu 2FA dan mengapa saya harus menggunakannya?

Two Factor Authentication (2FA) menambahkan lapisan perlindungan ekstra ke akun Anda di atas password. Untuk login, Anda tidak hanya harus mengetahui password, tetapi Anda juga harus "membuktikan" dengan cara tertentu bahwa Anda memiliki akses ke suatu perangkat perangkat keras. Dalam kasus paling sederhana, ini dapat dicapai dengan menerima SMS di ponsel Anda, meskipun ada [masalah yang diketahui](https://www.kaspersky.com/blog/2fa-practical-guide/24219/) dengan SMS 2FA. Alternatif yang lebih baik yang kami dukung adalah menggunakan solusi [U2F](https://en.wikipedia.org/wiki/Universal_2nd_Factor) seperti [YubiKey](https://www.yubico.com/).

## Ada komentar tentang perbedaan antar web browser?

Lanskap browser saat ini pada tahun 2020 adalah bahwa sebagian besar dari mereka seperti Chrome karena menggunakan engine yang sama (Blink). Ini berarti bahwa Microsoft Edge yang juga berbasis Blink, dan Safari, yang berbasis WebKit, engine yang mirip dengan Blink, hanyalah versi Chrome yang lebih buruk. Chrome adalah browser yang cukup baik baik dari segi performa maupun kegunaan. Jika Anda menginginkan alternatif, Firefox adalah rekomendasi kami. Ini sebanding dengan Chrome dalam hampir segala hal dan unggul dalam hal privasi.
Browser lain bernama [Flow](https://www.ekioh.com/flow-browser/) belum siap untuk pengguna, tetapi sedang mengimplementasikan rendering engine baru yang menjanjikan lebih cepat daripada yang saat ini.
