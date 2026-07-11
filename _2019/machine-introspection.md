---
layout: lecture
title: "Introspeksi Mesin"
presenter: Jon
date: 2019-01-24
order: 4
video:
  aspect: 56.25
  id: eNYT2Oq3PF8
special: true
---

Terkadang, komputer berperilaku tidak semestinya. Dan sangat sering, Anda ingin tahu alasannya.
Mari kita lihat beberapa alat yang membantu Anda melakukannya!

Tapi pertama-tama, mari pastikan Anda mampu melakukan introspeksi. Seringkali,
introspeksi sistem mengharuskan Anda memiliki hak akses tertentu, seperti
menjadi anggota dari sebuah grup (seperti `power` untuk shutdown). User `root`
memiliki hak akses tertinggi; mereka dapat melakukan hampir semuanya. Anda dapat menjalankan
perintah sebagai `root` (tapi berhati-hatilah!) menggunakan `sudo`.

## Apa yang terjadi?

Jika sesuatu berjalan salah, tempat pertama untuk memulai adalah melihat apa
yang terjadi di sekitar waktu ketika masalah terjadi. Untuk ini, kita perlu
melihat log.

Secara tradisional, log disimpan di `/var/log`, dan banyak yang masih demikian.
Biasanya terdapat file atau folder per program. Gunakan `grep` atau `less` untuk
menemukan jalan Anda melaluinya.

Ada juga log kernel yang dapat Anda lihat menggunakan perintah `dmesg`.
Dulu ini tersedia sebagai file teks biasa, tetapi saat ini Anda sering kali
harus melalui `dmesg` untuk mengaksesnya.

Terakhir, ada "system log", yang semakin menjadi tempat semua pesan
log Anda disimpan. Pada _sebagian besar_, meskipun tidak semua, sistem Linux, log tersebut
dikelola oleh `systemd`, "system daemon", yang mengendalikan semua
layanan yang berjalan di latar belakang (dan masih banyak lagi saat ini).
Log tersebut dapat diakses melalui alat `journalctl` yang agak tidak nyaman
jika Anda adalah root, atau bagian dari grup `admin` atau `wheel`.

Untuk `journalctl`, Anda harus mengetahui flag-flag berikut khususnya:

 - `-u UNIT`: tampilkan hanya pesan yang terkait dengan layanan systemd yang diberikan
 - `--full`: jangan potong baris panjang (fitur paling bodoh)
 - `-b`: hanya tampilkan pesan dari boot terbaru (lihat juga `-b -2`)
 - `-n100`: hanya tampilkan 100 entri terakhir

## Apa yang sedang terjadi?

Jika sesuatu _sedang_ salah, atau Anda hanya ingin mendapatkan gambaran tentang apa yang terjadi
pada sistem Anda, Anda memiliki sejumlah alat yang tersedia untuk
memeriksa sistem yang sedang berjalan:

Pertama, ada `top`, dan versi yang lebih baik `htop`, yang menampilkan
berbagai statistik untuk proses yang sedang berjalan pada sistem.
Penggunaan CPU, penggunaan memori, pohon proses, dll. Ada banyak shortcut,
tetapi `t` sangat berguna untuk mengaktifkan tampilan tree. Anda juga dapat
melihat pohon proses dengan `pstree` (+ `-p` untuk menyertakan PID). Jika Anda ingin
tahu apa yang dilakukan program-program tersebut, Anda sering kali ingin melihat
file log mereka. `journalctl -f`, `dmesg -w`, dan `tail -f` adalah teman Anda
di sini.

Terkadang, Anda ingin tahu lebih banyak tentang resource yang digunakan secara keseluruhan
pada sistem Anda. [`dool`](https://github.com/scottchiefbaker/dool) sangat
bagus untuk itu. Alat ini memberikan metrik resource real-time untuk banyak
subsystem yang berbeda seperti I/O, networking, penggunaan CPU, context switch, dan sejenisnya. `man dool` adalah tempat untuk memulai.

Jika Anda kehabisan ruang disk, ada dua utilitas utama
yang perlu Anda ketahui: `df` dan `du`. Yang pertama menampilkan
status semua partisi pada sistem Anda (coba dengan `-h`), sedangkan
yang kedua mengukur ukuran semua folder yang Anda berikan, termasuk
isinya (lihat juga `-h` dan `-s`).

Untuk mengetahui koneksi network apa yang Anda buka, `ss` adalah caranya.
`ss -t` akan menampilkan semua koneksi TCP yang terbuka. `ss -tl` akan menampilkan semua
port yang mendengarkan (yaitu, server) pada sistem Anda. `-p` juga akan menyertakan
proses mana yang menggunakan koneksi tersebut, dan `-n` akan memberi Anda
nomor port mentah.


## Konfigurasi sistem

Ada _banyak_ cara untuk mengonfigurasi sistem Anda, tetapi kita akan membahas
dua yang sangat umum: networking dan layanan. Sebagian besar aplikasi pada sistem Anda
memberitahu Anda cara mengonfigurasinya di manpage mereka, dan biasanya
akan melibatkan mengedit file di `/etc`; direktori konfigurasi
sistem.

Jika Anda ingin mengonfigurasi network Anda, perintah `ip` memungkinkan Anda
melakukannya. Argumennya memiliki bentuk yang agak aneh, tetapi `ip help command`
akan membawa Anda cukup jauh. `ip addr` menampilkan informasi tentang
interface network Anda dan bagaimana mereka dikonfigurasi (alamat IP dan sejenisnya),
dan `ip route` menampilkan bagaimana traffic network di-route ke host
network yang berbeda. Masalah network sering kali dapat diselesaikan sepenuhnya melalui
alat `ip`. Ada juga `iw` untuk mengelola interface network nirkabel.
`ping` adalah alat yang berguna untuk memeriksa seberapa parah kerusakan yang terjadi. Coba
ping sebuah hostname (google.com), alamat IP eksternal (1.1.1.1), dan
alamat IP internal (192.168.1.1 atau default gw). Anda mungkin juga ingin
mengutak-atik `/etc/resolv.conf` untuk memeriksa pengaturan DNS Anda (bagaimana hostname
diresolusi ke alamat IP).

Untuk mengonfigurasi layanan, Anda hampir pasti harus berinteraksi dengan `systemd`
saat ini, mau tidak mau. Sebagian besar layanan pada sistem Anda akan
memiliki file layanan systemd yang mendefinisikan _unit_ systemd. File-file ini
mendefinisikan perintah apa yang dijalankan ketika layanan tersebut dimulai, bagaimana menghentikannya,
di mana mencatat log, dll. Biasanya tidak terlalu sulit untuk dibaca, dan
Anda dapat menemukan sebagian besar dari mereka di `/usr/lib/systemd/system/`. Anda juga dapat
mendefinisikan milik Anda sendiri di `/etc/systemd/system` .

Setelah Anda memiliki layanan systemd dalam pikiran, Anda menggunakan perintah `systemctl`
untuk berinteraksi dengannya. `systemctl enable UNIT` akan mengatur layanan untuk
dimulai saat boot (`disable` akan menghapusnya lagi), dan `start`, `stop`, dan
`restart` akan melakukan apa yang Anda harapkan. Jika sesuatu berjalan salah, systemd akan
memberitahu Anda, dan Anda dapat menggunakan `journalctl -u UNIT` untuk melihat
log aplikasi. Anda juga dapat menggunakan `systemctl status` untuk melihat bagaimana semua
layanan sistem Anda berjalan. Jika boot Anda terasa lambat, itu mungkin
karena beberapa layanan yang lambat, dan Anda dapat menggunakan `systemd-analyze` (coba
dengan `blame`) untuk mengetahui yang mana.
