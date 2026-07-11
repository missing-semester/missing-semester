---
layout: lecture
title: "Potpourri"
description: >
  Pelajari berbagai topik berguna termasuk pemetaan ulang keyboard, daemon, backup, API, dan lainnya.
thumbnail: /static/assets/thumbnails/2020/lec10.png
date: 2020-01-29
ready: true
video:
  aspect: 56.25
  id: JZDt-PRq0uo
special: true
---

## Daftar Isi

- [Pemetaan ulang keyboard](#keyboard-remapping)
- [Daemon](#daemons)
- [FUSE](#fuse)
- [Backup](#backups)
- [API](#apis)
- [Flag/pola command-line umum](#common-command-line-flagspatterns)
- [Window manager](#window-managers)
- [VPN](#vpns)
- [Markdown](#markdown)
- [Hammerspoon (otomasi desktop di macOS)](#hammerspoon-desktop-automation-on-macos)
- [Booting + Live USB](#booting--live-usbs)
- [Docker, Vagrant, VM, Cloud, OpenStack](#docker-vagrant-vms-cloud-openstack)
- [Pemrograman notebook](#notebook-programming)
- [GitHub](#github)

## Pemetaan ulang keyboard

Sebagai seorang programmer, keyboard Anda adalah metode input utama. Seperti hampir semua hal di komputer Anda, keyboard dapat dikonfigurasi (dan layak untuk dikonfigurasi).

Perubahan paling dasar adalah memetakan ulang tombol.
Ini biasanya melibatkan beberapa perangkat lunak yang mendengarkan, dan setiap kali tombol tertentu ditekan, ia mencegat peristiwa tersebut dan menggantinya dengan peristiwa lain yang sesuai dengan tombol berbeda. Beberapa contoh:
- Memetakan ulang Caps Lock ke Ctrl atau Escape. Kami (para instruktur) sangat menyarankan pengaturan ini karena Caps Lock memiliki lokasi yang sangat nyaman tetapi jarang digunakan.
- Memetakan ulang PrtSc ke Play/Pause musik. Sebagian besar OS memiliki tombol play/pause.
- Menukar Ctrl dan tombol Meta (Windows atau Command).

Anda juga dapat memetakan tombol ke perintah arbitrer pilihan Anda. Ini berguna untuk tugas-tugas umum yang Anda lakukan. Di sini, beberapa perangkat lunak mendengarkan kombinasi tombol tertentu dan menjalankan skrip setiap kali peristiwa tersebut terdeteksi.
- Membuka terminal baru atau jendela browser.
- Menyisipkan teks tertentu, misalnya alamat email panjang Anda atau nomor ID MIT Anda.
- Menidurkan komputer atau layar.

Ada juga modifikasi yang lebih kompleks yang dapat Anda konfigurasi:
- Memetakan ulang urutan tombol, misalnya menekan shift lima kali mengaktifkan Caps Lock.
- Memetakan ulang saat ditekan singkat vs ditahan, misalnya tombol Caps Lock dipetakan ulang ke Esc jika Anda menekannya dengan cepat, tetapi dipetakan ulang ke Ctrl jika Anda menahannya dan menggunakannya sebagai modifier.
- Membuat pemetaan spesifik per keyboard atau per perangkat lunak.

Beberapa sumber perangkat lunak untuk memulai topik ini:
- macOS - [karabiner-elements](https://karabiner-elements.pqrs.org/), [skhd](https://github.com/koekeishiya/skhd) atau [BetterTouchTool](https://folivora.ai/)
- Linux - [xmodmap](https://wiki.archlinux.org/index.php/Xmodmap) atau [Autokey](https://github.com/autokey/autokey)
- Windows - Builtin di Control Panel, [AutoHotkey](https://www.autohotkey.com/) atau [SharpKeys](https://www.randyrants.com/category/sharpkeys/)
- QMK - Jika keyboard Anda mendukung firmware kustom, Anda dapat menggunakan [QMK](https://docs.qmk.fm/) untuk mengonfigurasi perangkat keras itu sendiri sehingga pemetaan berlaku untuk mesin mana pun yang Anda gunakan dengan keyboard tersebut.

## Daemon

Anda mungkin sudah familiar dengan konsep daemon, meskipun kata tersebut terdengar baru.
Sebagian besar komputer memiliki serangkaian proses yang selalu berjalan di latar belakang daripada menunggu pengguna untuk meluncurkannya dan berinteraksi dengannya.
Proses-proses ini disebut daemon dan program yang berjalan sebagai daemon sering kali diakhiri dengan huruf `d` untuk menunjukkannya.
Sebagai contoh `sshd`, daemon SSH, adalah program yang bertanggung jawab untuk mendengarkan permintaan SSH yang masuk dan memeriksa apakah pengguna jarak jauh memiliki kredensial yang diperlukan untuk masuk.

Di Linux, `systemd` (system daemon) adalah solusi paling umum untuk menjalankan dan mengatur proses daemon.
Anda dapat menjalankan `systemctl status` untuk melihat daftar daemon yang sedang berjalan. Sebagian besar mungkin terdengar asing tetapi bertanggung jawab atas bagian-bagian inti sistem seperti mengelola jaringan, menyelesaikan kueri DNS, atau menampilkan antarmuka grafis untuk sistem.
Systemd dapat diinteraksi dengan perintah `systemctl` untuk `enable`, `disable`, `start`, `stop`, `restart` atau memeriksa `status` layanan (itu adalah perintah-perintah `systemctl`).

Yang lebih menarik, `systemd` memiliki antarmuka yang cukup mudah diakses untuk mengonfigurasi dan mengaktifkan daemon baru (atau layanan).
Berikut ini adalah contoh daemon untuk menjalankan aplikasi Python sederhana.
Kami tidak akan membahas detailnya tetapi seperti yang Anda lihat, sebagian besar field cukup jelas maknanya.

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Custom App
After=network.target

[Service]
User=foo
Group=foo
WorkingDirectory=/home/foo/projects/mydaemon
ExecStart=/usr/bin/local/python3.7 app.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Juga, jika Anda hanya ingin menjalankan beberapa program dengan frekuensi tertentu, tidak perlu membuat daemon kustom, Anda dapat menggunakan [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html), daemon yang sudah dijalankan sistem Anda untuk melakukan tugas terjadwal.

## FUSE

Sistem perangkat lunak modern biasanya terdiri dari blok-blok bangunan kecil yang disusun bersama.
Sistem operasi Anda mendukung penggunaan berbagai backend filesystem karena ada bahasa umum tentang operasi apa yang didukung oleh sebuah filesystem.
Sebagai contoh, ketika Anda menjalankan `touch` untuk membuat file, `touch` melakukan system call ke kernel untuk membuat file dan kernel melakukan panggilan filesystem yang sesuai untuk membuat file tersebut.
Masalahnya adalah filesystem UNIX secara tradisional diimplementasikan sebagai modul kernel dan hanya kernel yang diizinkan melakukan panggilan filesystem.

[FUSE](https://en.wikipedia.org/wiki/Filesystem_in_Userspace) (Filesystem in User Space) memungkinkan filesystem diimplementasikan oleh program pengguna. FUSE memungkinkan pengguna menjalankan kode user space untuk panggilan filesystem dan kemudian menjembatani panggilan-panggilan yang diperlukan ke antarmuka kernel.
Dalam praktiknya, ini berarti pengguna dapat mengimplementasikan fungsionalitas arbitrer untuk panggilan filesystem.

Sebagai contoh, FUSE dapat digunakan sehingga setiap kali Anda melakukan operasi di filesystem virtual, operasi tersebut diteruskan melalui SSH ke mesin jarak jauh, dilakukan di sana, dan outputnya dikembalikan kepada Anda.
Dengan cara ini, program lokal dapat melihat file seolah-olah ada di komputer Anda padahal sebenarnya ada di server jarak jauh.
Ini secara efektif adalah apa yang dilakukan `sshfs`.

Beberapa contoh menarik filesystem FUSE adalah:
- [sshfs](https://github.com/libfuse/sshfs) - Membuka file/folder jarak jauh secara lokal melalui koneksi SSH.
- [rclone](https://rclone.org/commands/rclone_mount/) - Mount layanan penyimpanan cloud seperti Dropbox, GDrive, Amazon S3 atau Google Cloud Storage dan buka data secara lokal.
- [gocryptfs](https://nuetzlich.net/gocryptfs/) - Sistem overlay terenkripsi. File disimpan secara terenkripsi tetapi setelah FS di-mount, mereka muncul sebagai plaintext di mountpoint.
- [kbfs](https://keybase.io/docs/kbfs) - Filesystem terdistribusi dengan enkripsi end-to-end. Anda dapat memiliki folder pribadi, bersama, dan publik.
- [borgbackup](https://borgbackup.readthedocs.io/en/stable/usage/mount.html) - Mount backup Anda yang telah dideduplikasi, dikompresi, dan dienkripsi untuk kemudahan browsing.

## Backup

Data apa pun yang belum Anda backup adalah data yang bisa hilang kapan saja, selamanya.
Mudah untuk menyalin data, tetapi sulit untuk melakukan backup data secara andal.
Berikut adalah beberapa dasar backup yang baik dan jebakan dari beberapa pendekatan.

Pertama, salinan data di disk yang sama bukanlah backup, karena disk adalah titik kegagalan tunggal untuk semua data. Demikian pula, drive eksternal di rumah Anda juga merupakan solusi backup yang lemah karena bisa hilang dalam kebakaran/pencurian/dll. Sebaliknya, memiliki backup di lokasi terpisah adalah praktik yang direkomendasikan.

Solusi sinkronisasi bukanlah backup. Misalnya, Dropbox/GDrive adalah solusi yang nyaman, tetapi ketika data dihapus atau rusak, mereka menyebarkan perubahan tersebut. Untuk alasan yang sama, solusi disk mirroring seperti RAID bukanlah backup. Mereka tidak membantu jika data dihapus, rusak, atau dienkripsi oleh ransomware.

Beberapa fitur inti dari solusi backup yang baik adalah versioning, deduplication, dan keamanan.
Backup versioning memastikan Anda dapat mengakses riwayat perubahan dan memulihkan file secara efisien.
Solusi backup yang efisien menggunakan deduplication data untuk hanya menyimpan perubahan inkremental dan mengurangi overhead penyimpanan.
Terkait keamanan, Anda harus menanyakan apa yang perlu diketahui/dimiliki seseorang untuk membaca data Anda dan, yang lebih penting, untuk menghapus semua data Anda dan backup terkait.
Terakhir, mempercayai backup secara membabi-buta adalah ide yang buruk dan Anda harus secara teratur memverifikasi bahwa Anda dapat menggunakannya untuk memulihkan data.

Backup tidak hanya berlaku untuk file lokal di komputer Anda.
Mengingat pertumbuhan signifikan aplikasi web, sebagian besar data Anda hanya disimpan di cloud.
Misalnya, webmail Anda, foto media sosial, playlist musik di layanan streaming, atau dokumen online akan hilang jika Anda kehilangan akses ke akun terkait.
Memiliki salinan offline dari informasi ini adalah cara yang tepat, dan Anda dapat menemukan alat online yang telah dibuat orang untuk mengambil data dan menyimpannya.

Untuk penjelasan yang lebih detail, lihat catatan kuliah tahun 2019 tentang [Backups](/2019/backups).


## API

Kita telah banyak berbicara di kelas ini tentang menggunakan komputer Anda secara lebih efisien untuk menyelesaikan tugas _lokal_, tetapi Anda akan menemukan bahwa banyak pelajaran ini juga berlaku untuk internet yang lebih luas. Sebagian besar layanan online memiliki "API" yang memungkinkan Anda mengakses data mereka secara terprogram. Sebagai contoh, pemerintah AS memiliki API yang memungkinkan Anda mendapatkan prakiraan cuaca, yang bisa Anda gunakan untuk dengan mudah mendapatkan prakiraan cuaca di shell Anda.

Sebagian besar API ini memiliki format yang serupa. Mereka adalah URL terstruktur, sering kali berakar di `api.service.com`, di mana path dan parameter query menunjukkan data apa yang ingin Anda baca atau tindakan apa yang ingin Anda lakukan. Untuk data cuaca AS misalnya, untuk mendapatkan prakiraan untuk lokasi tertentu, Anda mengirim permintaan GET (dengan `curl` misalnya) ke https://api.weather.gov/points/42.3604,-71.094. Respons itu sendiri berisi banyak URL lain yang memungkinkan Anda mendapatkan prakiraan spesifik untuk wilayah tersebut. Biasanya, respons diformat sebagai JSON, yang kemudian dapat Anda pipe melalui alat seperti [`jq`](https://stedolan.github.io/jq/) untuk mengolahnya sesuai kebutuhan Anda.

Beberapa API memerlukan autentikasi, dan ini biasanya berupa _token_ rahasia yang perlu Anda sertakan dengan permintaan. Anda harus membaca dokumentasi API untuk melihat apa yang digunakan oleh layanan tertentu yang Anda cari, tetapi "[OAuth](https://www.oauth.com/)" adalah protokol yang sering Anda lihat digunakan. Pada intinya, OAuth adalah cara untuk memberikan token yang dapat "bertindak sebagai Anda" pada layanan tertentu, dan hanya dapat digunakan untuk tujuan tertentu. Ingatlah bahwa token ini _rahasia_, dan siapa pun yang mendapatkan akses ke token Anda dapat melakukan apa pun yang diizinkan token tersebut di bawah akun _Anda_!

[IFTTT](https://ifttt.com/) adalah situs web dan layanan yang berpusat pada ide API — layanan ini menyediakan integrasi dengan banyak layanan, dan memungkinkan Anda merangkai peristiwa dari mereka dengan cara yang hampir arbitrer. Coba lihat!

## Flag/pola command-line umum

Alat command-line sangat bervariasi, dan Anda sering kali ingin memeriksa halaman `man` mereka sebelum menggunakannya. Namun mereka sering berbagi beberapa fitur umum yang baik untuk diketahui:

 - Sebagian besar alat mendukung semacam flag `--help` untuk menampilkan instruksi penggunaan singkat untuk alat tersebut.
 - Banyak alat yang dapat menyebabkan perubahan yang tidak dapat dibatalkan mendukung konsep "dry run" di mana mereka hanya mencetak apa yang _akan mereka lakukan_, tetapi tidak benar-benar melakukan perubahan. Demikian pula, mereka sering memiliki flag "interactive" yang akan meminta konfirmasi Anda untuk setiap tindakan destruktif.
 - Anda biasanya dapat menggunakan `--version` atau `-V` untuk membuat program mencetak versinya (berguna untuk melaporkan bug!).
 - Hampir semua alat memiliki flag `--verbose` atau `-v` untuk menghasilkan output yang lebih detail. Anda biasanya dapat menyertakan flag beberapa kali (`-vvv`) untuk mendapatkan output yang _lebih_ detail, yang dapat berguna untuk debugging. Demikian pula, banyak alat memiliki flag `--quiet` untuk membuatnya hanya mencetak sesuatu saat terjadi error.
 - Di banyak alat, `-` sebagai ganti nama file berarti "standard input" atau "standard output", tergantung pada argumen.
 - Alat yang berpotensi destruktif umumnya tidak rekursif secara default, tetapi mendukung flag "recursive" (sering `-r`) untuk membuatnya rekursif.
 - Terkadang, Anda ingin melewati sesuatu yang _terlihat_ seperti flag sebagai argumen normal. Misalnya, bayangkan Anda ingin menghapus file bernama `-r`. Atau Anda ingin menjalankan satu program "melalui" program lain, seperti `ssh machine foo`, dan Anda ingin melewati flag ke program "dalam" (`foo`). Argumen khusus `--` membuat program _berhenti_ memproses flag dan opsi (hal-hal yang dimulai dengan `-`) dalam apa yang mengikuti, memungkinkan Anda melewati hal-hal yang terlihat seperti flag tanpa ditafsirkan sebagai flag: `rm -- -r` atau `ssh machine --for-ssh -- foo --for-foo`.

## Window manager

Sebagian besar dari Anda terbiasa menggunakan window manager "drag and drop", seperti yang tersedia di Windows, macOS, dan Ubuntu secara default. Ada jendela-jendela yang begitu saja tergantung di layar, dan Anda dapat menyeretnya, mengubah ukurannya, dan membiarkan mereka saling tumpang tindih. Tetapi ini hanyalah satu _jenis_ window manager, sering disebut sebagai window manager "floating". Ada banyak lainnya, terutama di Linux. Alternatif yang sangat umum adalah window manager "tiling". Di window manager tiling, jendela tidak pernah tumpang tindih, dan sebaliknya diatur sebagai ubin di layar Anda, mirip dengan pane di tmux. Dengan window manager tiling, layar selalu diisi oleh jendela apa pun yang terbuka, diatur menurut _layout_ tertentu. Jika Anda hanya memiliki satu jendela, ia memenuhi seluruh layar. Jika Anda kemudian membuka yang lain, jendela asli mengecil untuk memberinya tempat (sering kali sesuatu seperti 2/3 dan 1/3). Jika Anda membuka yang ketiga, jendela-jendela lain akan kembali mengecil untuk mengakomodasi jendela baru. Sama seperti pane tmux, Anda dapat bernavigasi di antara jendela-jendela ubin ini dengan keyboard Anda, dan Anda dapat mengubah ukurannya serta memindahkannya, semuanya tanpa menyentuh mouse. Ini layak untuk ditelusuri!


## VPN

VPN sedang sangat populer akhir-akhir ini, tetapi tidak jelas apakah itu karena [alasan yang baik](https://web.archive.org/web/20230710155258/https://gist.github.com/joepie91/5a9909939e6ce7d09e29). Anda harus menyadari apa yang VPN berikan dan tidak berikan. VPN, dalam kasus terbaik, _sebenarnya_ hanyalah cara bagi Anda untuk mengubah penyedia layanan internet Anda sejauh yang internet perhatikan. Semua lalu lintas Anda akan terlihat berasal dari penyedia VPN daripada lokasi "asli" Anda, dan jaringan yang Anda hubungkan hanya akan melihat lalu lintas terenkripsi.

Meskipun itu mungkin terlihat menarik, perlu diingat bahwa ketika Anda menggunakan VPN, yang sebenarnya Anda lakukan hanyalah menggeser kepercayaan Anda dari ISP saat ini ke perusahaan hosting VPN. Apa pun yang _bisa_ dilihat oleh ISP Anda, sekarang dilihat oleh penyedia VPN _sebagai gantinya_. Jika Anda mempercayai mereka _lebih_ dari ISP Anda, itu adalah kemenangan, tetapi jika tidak, tidak jelas bahwa Anda telah mendapatkan banyak hal. Jika Anda berada di Wi-Fi publik tidak terenkripsi yang mencurigakan di bandara, mungkin Anda tidak terlalu mempercayai koneksi tersebut, tetapi di rumah, pertukarannya tidak terlalu jelas.

Anda juga harus tahu bahwa saat ini, sebagian besar lalu lintas Anda, setidaknya yang bersifat sensitif, _sudah_ terenkripsi melalui HTTPS atau TLS secara umum. Dalam hal ini, biasanya tidak terlalu penting apakah Anda berada di jaringan yang "buruk" atau tidak -- operator jaringan hanya akan mengetahui server apa yang Anda hubungi, tetapi tidak ada informasi tentang data yang dipertukarkan.

Perhatikan bahwa saya mengatakan "dalam kasus terbaik" di atas. Bukan tidak pernah terjadi penyedia VPN secara tidak sengaja salah mengonfigurasi perangkat lunak mereka sehingga enkripsi lemah atau sepenuhnya dinonaktifkan. Beberapa penyedia VPN bersifat jahat (atau setidaknya oportunistik), dan akan mencatat semua lalu lintas Anda, dan mungkin menjual informasi tentangnya kepada pihak ketiga. Memilih penyedia VPN yang buruk sering kali lebih buruk daripada tidak menggunakannya sama sekali.

Dalam keadaan darurat, MIT [mengoperasikan VPN](https://ist.mit.edu/vpn) untuk mahasiswanya, jadi itu mungkin layak untuk dilihat. Juga, jika Anda ingin membuat sendiri, coba lihat [WireGuard](https://www.wireguard.com/).

## Markdown

Ada kemungkinan besar Anda akan menulis beberapa teks selama karier Anda. Dan sering kali, Anda akan ingin menandai teks tersebut dengan cara-cara sederhana. Anda ingin beberapa teks menjadi tebal atau miring, atau Anda ingin menambahkan header, tautan, dan fragmen kode. Alih-alih menggunakan alat berat seperti Word atau LaTeX, Anda mungkin ingin mempertimbangkan menggunakan bahasa markup ringan [Markdown](https://commonmark.org/help/).

Anda mungkin sudah pernah melihat Markdown, atau setidaknya beberapa variannya. Subset dari Markdown digunakan dan didukung hampir di mana-mana, meskipun tidak dengan nama Markdown. Pada intinya, Markdown adalah upaya untuk membakukan cara orang sudah sering menandai teks ketika mereka menulis dokumen teks biasa. Penekanan (*miring*) ditambahkan dengan mengelilingi kata dengan `*`. Penekanan kuat (**tebal**) ditambahkan menggunakan `**`. Baris yang dimulai dengan `#` adalah heading (dan jumlah `#` adalah tingkat subheading). Baris yang dimulai dengan `-` adalah item daftar bullet, dan baris yang dimulai dengan angka + `.` adalah item daftar bernomor. Backtick digunakan untuk menampilkan kata dalam `font kode`, dan blok kode dapat dimasukkan dengan memberi indentasi empat spasi atau mengelilinginya dengan triple-backtick:

    ```
    code goes here
    ```

Untuk menambahkan tautan, tempatkan _teks_ untuk tautan dalam kurung siku, dan URL segera setelahnya dalam kurung: `[name](url)`. Markdown mudah untuk dimulai, dan Anda dapat menggunakannya hampir di mana-mana. Faktanya, catatan kuliah untuk kuliah ini, dan semua kuliah lainnya, ditulis dalam Markdown, dan Anda dapat melihat Markdown mentahnya [di sini](https://raw.githubusercontent.com/missing-semester/missing-semester/master/_2020/potpourri.md).



## Hammerspoon (otomasi desktop di macOS)

[Hammerspoon](https://www.hammerspoon.org/) adalah framework otomasi desktop untuk macOS. Ini memungkinkan Anda menulis skrip Lua yang terhubung ke fungsionalitas sistem operasi, memungkinkan Anda berinteraksi dengan keyboard/mouse, jendela, layar, filesystem, dan banyak lagi.

Beberapa contoh hal yang dapat Anda lakukan dengan Hammerspoon:

- Mengikat hotkey untuk memindahkan jendela ke lokasi tertentu
- Membuat tombol menu bar yang secara otomatis menata jendela dalam layout tertentu
- Membisukan speaker Anda ketika Anda tiba di lab (dengan mendeteksi jaringan Wi-Fi)
- Menampilkan peringatan jika Anda tidak sengaja mengambil power supply teman Anda

Pada tingkat tinggi, Hammerspoon memungkinkan Anda menjalankan kode Lua arbitrer, yang diikat ke tombol menu, tekanan tombol, atau peristiwa, dan Hammerspoon menyediakan pustaka yang luas untuk berinteraksi dengan sistem, sehingga pada dasarnya tidak ada batasan untuk apa yang dapat Anda lakukan. Banyak orang telah membuat konfigurasi Hammerspoon mereka publik, jadi Anda biasanya dapat menemukan apa yang Anda butuhkan dengan mencari di internet, tetapi Anda selalu dapat menulis kode Anda sendiri dari awal.

### Sumber Daya

- [Getting Started with Hammerspoon](https://www.hammerspoon.org/go/)
- [Sample configurations](https://github.com/Hammerspoon/hammerspoon/wiki/Sample-Configurations)
- [Anish's Hammerspoon config](https://github.com/anishathalye/dotfiles-local/tree/mac/hammerspoon)

## Booting + Live USB

Ketika mesin Anda boot, sebelum sistem operasi dimuat, [BIOS](https://en.wikipedia.org/wiki/BIOS)/[UEFI](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) menginisialisasi sistem. Selama proses ini, Anda dapat menekan kombinasi tombol tertentu untuk mengonfigurasi lapisan perangkat lunak ini. Misalnya, komputer Anda mungkin menampilkan sesuatu seperti "Press F9 to configure BIOS. Press F12 to enter boot menu." selama proses boot. Anda dapat mengonfigurasi berbagai pengaturan terkait perangkat keras di menu BIOS. Anda juga dapat masuk ke menu boot untuk boot dari perangkat alternatif selain hard drive Anda.

[Live USB](https://en.wikipedia.org/wiki/Live_USB) adalah USB flash drive yang berisi sistem operasi. Anda dapat membuatnya dengan mengunduh sistem operasi (misalnya distribusi Linux) dan membakarnya ke flash drive. Proses ini sedikit lebih rumit daripada hanya menyalin file `.iso` ke disk. Ada alat seperti [UNetbootin](https://unetbootin.github.io/) untuk membantu Anda membuat live USB.

Live USB berguna untuk berbagai tujuan. Antara lain, jika Anda merusak instalasi sistem operasi yang ada sehingga tidak lagi boot, Anda dapat menggunakan live USB untuk memulihkan data atau memperbaiki sistem operasi.

## Docker, Vagrant, VM, Cloud, OpenStack

[Virtual machine](https://en.wikipedia.org/wiki/Virtual_machine) dan alat serupa seperti container memungkinkan Anda mengemulasi seluruh sistem komputer, termasuk sistem operasi. Ini dapat berguna untuk membuat lingkungan terisolasi untuk pengujian, pengembangan, atau eksplorasi (misalnya menjalankan kode yang berpotensi berbahaya).

[Vagrant](https://www.vagrantup.com/) adalah alat yang memungkinkan Anda mendeskripsikan konfigurasi mesin (sistem operasi, layanan, paket, dll.) dalam kode, dan kemudian menginisialisasi VM dengan `vagrant up` yang sederhana. [Docker](https://www.docker.com/) secara konsep serupa tetapi menggunakan container sebagai gantinya.

Anda juga dapat menyewa virtual machine di cloud, dan itu adalah cara yang bagus untuk mendapatkan akses instan ke:

- Mesin always-on yang murah yang memiliki alamat IP publik, digunakan untuk menghosting layanan
- Mesin dengan banyak CPU, disk, RAM, dan/atau GPU
- Lebih banyak mesin daripada yang Anda miliki secara fisik (penagihan sering per detik, jadi jika Anda ingin banyak komputasi dalam waktu singkat, layak untuk menyewa 1000 komputer selama beberapa menit)

Layanan populer termasuk [Amazon AWS](https://aws.amazon.com/), [Google Cloud](https://cloud.google.com/), [Microsoft Azure](https://azure.microsoft.com/), [DigitalOcean](https://www.digitalocean.com/).

Jika Anda anggota MIT CSAIL, Anda bisa mendapatkan VM gratis untuk tujuan penelitian melalui [CSAIL OpenStack instance](https://tig.csail.mit.edu/shared-computing/open-stack/).

## Pemrograman notebook

[Lingkungan pemrograman notebook](https://en.wikipedia.org/wiki/Notebook_interface) bisa sangat berguna untuk melakukan jenis pengembangan interaktif atau eksploratif tertentu. Mungkin lingkungan pemrograman notebook paling populer saat ini adalah [Jupyter](https://jupyter.org/), untuk Python (dan beberapa bahasa lainnya). [Wolfram Mathematica](https://www.wolfram.com/mathematica/) adalah lingkungan pemrograman notebook lain yang hebat untuk pemrograman berorientasi matematika.

## GitHub

[GitHub](https://github.com/) adalah salah satu platform paling populer untuk pengembangan perangkat lunak open-source. Banyak alat yang kita bahas di kelas ini, dari [vim](https://github.com/vim/vim) hingga [Hammerspoon](https://github.com/Hammerspoon/hammerspoon), dihosting di GitHub. Mudah untuk mulai berkontribusi pada open-source untuk membantu meningkatkan alat yang Anda gunakan setiap hari.

Ada dua cara utama orang berkontribusi pada proyek di GitHub:

- Membuat [issue](https://help.github.com/en/github/managing-your-work-on-github/creating-an-issue). Ini dapat digunakan untuk melaporkan bug atau meminta fitur baru. Keduanya tidak melibatkan membaca atau menulis kode, jadi bisa cukup ringan untuk dilakukan. Laporan bug berkualitas tinggi bisa sangat berharga bagi pengembang. Mengomentari diskusi yang ada juga bisa membantu.
- Berkontribusi kode melalui [pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests). Ini umumnya lebih terlibat daripada membuat issue. Anda dapat [fork](https://help.github.com/en/github/getting-started-with-github/fork-a-repo) sebuah repository di GitHub, clone fork Anda, membuat branch baru, melakukan beberapa perubahan (misalnya memperbaiki bug atau mengimplementasikan fitur), push branch tersebut, dan kemudian [membuat pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request). Setelah itu, biasanya akan ada beberapa diskusi dengan maintainer proyek, yang akan memberikan umpan balik pada patch Anda. Akhirnya, jika semuanya berjalan baik, patch Anda akan digabungkan ke repository upstream. Sering kali, proyek yang lebih besar akan memiliki panduan kontribusi, menandai issue yang ramah pemula, dan beberapa bahkan memiliki program mentorship untuk membantu kontributor pertama kali menjadi familiar dengan proyek.
