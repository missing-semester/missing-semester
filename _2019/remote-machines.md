---
layout: lecture
title: "Mesin Remote"
presenter: Jose
date: 2019-01-29
order: 4
video:
  aspect: 62.5
  id: X5c2Y8BCowM
---

Semakin umum bagi para programmer untuk menggunakan server remote dalam pekerjaan sehari-hari mereka. Jika Anda perlu menggunakan server remote untuk men-deploy perangkat lunak backend atau Anda membutuhkan server dengan kemampuan komputasi yang lebih tinggi, Anda akan menggunakan Secure Shell (SSH). Seperti kebanyakan alat yang dibahas, SSH sangat dapat dikonfigurasi sehingga patut untuk dipelajari.


## Menjalankan perintah

Fitur `ssh` yang sering terlewatkan adalah kemampuan untuk menjalankan perintah secara langsung.

- `ssh foobar@server ls` akan menjalankan ls di folder home dari foobar
- Ini berfungsi dengan pipe, sehingga `ssh foobar@server ls | grep PATTERN` akan melakukan grep secara lokal pada output remote dari `ls` dan `ls | ssh foobar@server grep PATTERN` akan melakukan grep secara remote pada output lokal dari `ls`.

## Kunci SSH

Autentikasi berbasis kunci memanfaatkan kriptografi kunci publik untuk membuktikan kepada server bahwa klien memiliki kunci privat rahasia tanpa mengungkapkan kunci tersebut. Dengan cara ini Anda tidak perlu memasukkan ulang kata sandi setiap kali. Meskipun demikian, kunci privat (misalnya `~/.ssh/id_rsa`) secara efektif adalah kata sandi Anda, jadi perlakukan seperti itu.

- Pembuatan kunci. Untuk membuat pasangan kunci Anda cukup menjalankan `ssh-keygen -t rsa -b 4096`. Jika Anda tidak memilih passphrase, siapa pun yang mendapatkan kunci privat Anda akan dapat mengakses server yang diotorisasi, sehingga disarankan untuk memilih satu dan menggunakan `ssh-agent` untuk mengelola sesi shell.

Jika Anda telah mengkonfigurasi push ke GitHub menggunakan kunci SSH, Anda mungkin telah melakukan langkah-langkah yang diuraikan [di sini](https://help.github.com/articles/connecting-to-github-with-ssh/) dan sudah memiliki pasangan kunci yang valid. Untuk memeriksa apakah Anda memiliki passphrase dan memvalidasinya, Anda dapat menjalankan `ssh-keygen -y -f /path/to/key`.

- Autentikasi berbasis kunci. `ssh` akan melihat ke `.ssh/authorized_keys` untuk menentukan klien mana yang seharusnya diizinkan. Untuk menyalin kunci publik, kita dapat menggunakan

```bash
cat .ssh/id_dsa.pub | ssh foobar@remote 'cat >> ~/.ssh/authorized_keys'
```

Solusi yang lebih sederhana dapat dicapai dengan `ssh-copy-id` jika tersedia.

```bash
ssh-copy-id -i .ssh/id_dsa.pub foobar@remote
```

## Menyalin file melalui ssh

Ada banyak cara untuk menyalin file melalui ssh

- `ssh+tee`, cara paling sederhana adalah menggunakan eksekusi perintah `ssh` dan input stdin dengan melakukan `cat localfile | ssh remote_server tee serverfile`
- `scp` ketika menyalin sejumlah besar file/direktori, perintah secure copy `scp` lebih nyaman karena dapat melakukan rekursi dengan mudah pada path. Sintaksnya adalah `scp path/to/local_file remote_host:path/to/remote_file`
- `rsync` meningkatkan `scp` dengan mendeteksi file yang identik di lokal dan remote serta mencegah penyalinan ulang. Ini juga menyediakan kontrol yang lebih rinci atas symlink, permission, dan memiliki fitur tambahan seperti flag `--partial` yang dapat melanjutkan salinan yang sebelumnya terinterupsi. `rsync` memiliki sintaks yang mirip dengan `scp`.


## Memproses di latar belakang

Secara default ketika memutus koneksi ssh, proses anak dari shell induk akan dimatikan bersamanya. Ada beberapa alternatif

- `nohup` - alat `nohup` secara efektif memungkinkan sebuah proses tetap hidup ketika terminal dimatikan. Meskipun ini terkadang dapat dicapai dengan `&` dan `disown`, nohup adalah pilihan default yang lebih baik. Detail lebih lanjut dapat ditemukan [di sini](https://unix.stackexchange.com/questions/3886/difference-between-nohup-disown-and).

- `tmux`, `screen` - sedangkan `nohup` secara efektif memindahkan proses ke latar belakang, ini tidak nyaman untuk sesi shell interaktif. Dalam kasus tersebut, menggunakan terminal multiplexer seperti `screen` atau `tmux` adalah pilihan yang nyaman karena seseorang dapat dengan mudah melepaskan dan melampirkan kembali shell yang terkait.

Terakhir, jika Anda melepaskan sebuah program dan ingin melampirkannya kembali ke terminal saat ini, Anda dapat melihat [reptyr](https://github.com/nelhage/reptyr). `reptyr PID` akan mengambil proses dengan id PID dan melampirkannya ke terminal Anda saat ini.

## Port Forwarding

Dalam banyak skenario, Anda akan menemukan perangkat lunak yang bekerja dengan mendengarkan port di mesin. Ketika ini terjadi di mesin lokal Anda, Anda cukup melakukan `localhost:PORT` atau `127.0.0.1:PORT`, tetapi apa yang Anda lakukan dengan server remote yang port-nya tidak tersedia secara langsung melalui jaringan/internet?. Ini disebut port forwarding dan tersedia dalam dua jenis: Local Port Forwarding dan Remote Port Forwarding (lihat gambar untuk detail lebih lanjut, kredit gambar dari [postingan SO ini](https://unix.stackexchange.com/questions/115897/whats-ssh-port-forwarding-and-whats-the-difference-between-ssh-local-and-remot)).


**Local Port Forwarding**
![Local Port Forwarding](https://i.stack.imgur.com/a28N8.png)

**Remote Port Forwarding**
![Remote Port Forwarding](https://i.stack.imgur.com/4iK3b.png)


Skenario yang paling umum adalah local port forwarding di mana sebuah layanan di mesin remote mendengarkan pada sebuah port dan Anda ingin menautkan sebuah port di mesin lokal Anda untuk meneruskan ke port remote. Misalnya jika kita menjalankan `jupyter notebook` di server remote yang mendengarkan port `8888`. Maka untuk meneruskannya ke port lokal `9999` kita akan melakukan `ssh -L 9999:localhost:8888 foobar@remote_server` dan kemudian navigasi ke `localhost:9999` di mesin lokal kita.

## Graphics Forwarding

Terkadang mem-forward port tidak cukup karena kita ingin menjalankan program berbasis GUI di server. Anda selalu dapat menggunakan Perangkat Lunak Remote Desktop yang mengirimkan seluruh Lingkungan Desktop (yaitu opsi seperti RealVNC, Teamviewer, dll). Namun untuk satu alat GUI, SSH menyediakan alternatif yang baik: Graphics Forwarding.

Menggunakan flag `-X` memberitahu SSH untuk mem-forward

 Untuk forwarding X11 yang dipercaya, flag `-Y` dapat digunakan.

Catatan terakhir adalah agar ini berfungsi, `sshd_config` di server harus memiliki opsi berikut

```bash
X11Forwarding yes
X11DisplayOffset 10
```

## Roaming

Masalah umum saat menghubungkan ke server remote adalah pemutusan koneksi karena mematikan/memenidukan komputer Anda atau berpindah jaringan. Selain itu, jika seseorang memiliki koneksi dengan lag yang signifikan, menggunakan ssh bisa menjadi sangat frustrasi. [Mosh](https://mosh.org/), the mobile shell, meningkatkan ssh, memungkinkan koneksi roaming, konektivitas intermiten, dan menyediakan echo lokal yang cerdas.

Mosh tersedia di semua distribusi dan package manager umum. Mosh membutuhkan server ssh yang berjalan di server. Anda tidak perlu menjadi superuser untuk menginstal mosh, tetapi memerlukan port 60000 hingga 60010 untuk dibuka di server (biasanya sudah terbuka karena tidak berada dalam rentang port yang diprivilese).

Kekurangan dari `mosh` adalah tidak mendukung forwarding port/graphics roaming, jadi jika Anda sering menggunakannya, `mosh` tidak akan banyak membantu.

## Konfigurasi SSH

### Klien

Kita telah membahas banyak argumen yang dapat kita berikan. Alternatif yang menggoda adalah membuat alias shell seperti `alias my_serer="ssh -X -i ~/.id_rsa -L 9999:localhost:8888 foobar@remote_server`, namun ada alternatif yang lebih baik, menggunakan `~/.ssh/config`.

```bash
Host vm
    User foobar
    HostName 172.16.174.141
    Port 22
    IdentityFile ~/.ssh/id_rsa
    RemoteForward 9999 localhost:8888

# Configs can also take wildcards
Host *.mit.edu
    User foobaz
```


Keuntungan tambahan menggunakan file `~/.ssh/config` dibandingkan alias adalah program lain seperti `scp`, `rsync`, `mosh`, dll juga dapat membacanya dan mengonversi pengaturan menjadi flag yang sesuai.


Perhatikan bahwa file `~/.ssh/config` dapat dianggap sebagai dotfile, dan secara umum tidak masalah untuk disertakan bersama dotfile Anda lainnya. Namun jika Anda membuatnya publik, pikirkan tentang informasi yang berpotensi Anda berikan kepada orang asing di internet: alamat server Anda, pengguna yang Anda gunakan, port yang terbuka, dll. Ini dapat memfasilitasi beberapa jenis serangan, jadi berhati-hatilah dalam membagikan konfigurasi SSH Anda.

Peringatan: Jangan pernah sertakan kunci RSA Anda (`~/.ssh/id_rsa*`) di repositori publik!

### Sisi server

Konfigurasi sisi server biasanya ditentukan di `/etc/ssh/sshd_config`. Di sini Anda dapat melakukan perubahan seperti menonaktifkan autentikasi kata sandi, mengubah port ssh, mengaktifkan forwarding X11, dll. Anda dapat menentukan pengaturan konfigurasi per pengguna.

## Remote Filesystem

Terkadang lebih mudah untuk me-mount folder remote. [sshfs](https://github.com/libfuse/sshfs) dapat me-mount folder di server remote
secara lokal, dan kemudian Anda dapat menggunakan editor lokal.

## Latihan

1. Agar SSH berfungsi, host perlu menjalankan server SSH. Instal server SSH (seperti OpenSSH) di mesin virtual sehingga Anda dapat melakukan latihan lainnya. Untuk mengetahui ip mesin, jalankan perintah `ip addr` dan cari field inet (abaikan entri `127.0.0.1`, yang sesuai dengan antarmuka loopback).

1. Pergi ke `~/.ssh/` dan periksa apakah Anda memiliki pasangan kunci SSH di sana. Jika tidak, buat dengan `ssh-keygen -t rsa -b 4096`. Disarankan agar Anda menggunakan kata sandi dan menggunakan `ssh-agent`, info lebih lanjut [di sini](https://www.ssh.com/ssh/agent).

1. Gunakan `ssh-copy-id` untuk menyalin kunci ke mesin virtual Anda. Uji bahwa Anda dapat ssh tanpa kata sandi. Kemudian, edit `sshd_config` Anda di server untuk menonaktifkan autentikasi kata sandi dengan mengedit nilai `PasswordAuthentication`. Nonaktifkan login root dengan mengedit nilai `PermitRootLogin`.

1. Edit `sshd_config` di server untuk mengubah port ssh dan periksa bahwa Anda masih dapat ssh. Jika Anda pernah memiliki server yang terbuka untuk publik, port non-default dan login hanya dengan kunci akan memperlambat sejumlah besar serangan berbahaya.

1. Instal mosh di server/VM Anda, buat koneksi, dan kemudian putuskan adaptor jaringan server/VM. Dapatkah mosh pulih dengan baik dari hal tersebut?

1. Kegunaan lain dari local port forwarding adalah untuk menunnel host tertentu ke server. Jika jaringan Anda memfilter beberapa situs web seperti misalnya `reddit.com`, Anda dapat menunnelnya melalui server sebagai berikut:

    - Jalankan `ssh remote_server -L 80:reddit.com:80`
    - Atur `reddit.com` dan `www.reddit.com` ke `127.0.0.1` di `/etc/hosts`
    - Periksa bahwa Anda mengakses situs web tersebut melalui server
    - Jika tidak jelas, gunakan situs web seperti [ipinfo.io](https://ipinfo.io/) yang akan berubah tergantung pada ip publik host Anda.


1. Background port forwarding dapat dengan mudah dicapai dengan beberapa flag tambahan. Pelajari apa yang dilakukan flag `-N` dan `-f` di `ssh` dan cari tahu apa yang dilakukan perintah seperti ini `ssh -N -f -L 9999:localhost:8888 foobar@remote_server`.


## Referensi

- [SSH Hacks](https://matt.might.net/articles/ssh-hacks/)
- [Secure Secure Shell](https://stribika.github.io/2015/01/04/secure-secure-shell.html)

{% comment %}
Lecture notes will be available by the start of lecture.
{% endcomment %}