---
layout: lecture
title: "Lingkungan Command-line"
description: >
  Pelajari tentang job control, terminal multiplexer, dotfiles, dan mesin remote dengan SSH.
thumbnail: /static/assets/thumbnails/2020/lec5.png
date: 2020-01-21
ready: true
video:
  aspect: 56.25
  id: e8BO_dYxk5c
---

Dalam kuliah ini kita akan membahas beberapa cara untuk meningkatkan alur kerja Anda saat menggunakan shell. Kita telah bekerja dengan shell selama beberapa waktu, tetapi kita terutama fokus pada menjalankan berbagai perintah. Sekarang kita akan melihat bagaimana menjalankan beberapa proses secara bersamaan sambil melacaknya, bagaimana menghentikan atau menjeda proses tertentu, dan bagaimana membuat proses berjalan di latar belakang.

Kita juga akan mempelajari berbagai cara untuk meningkatkan shell dan alat-alat lainnya, dengan mendefinisikan alias dan mengonfigurasinya menggunakan dotfiles. Keduanya dapat membantu Anda menghemat waktu, misalnya dengan menggunakan konfigurasi yang sama di semua mesin Anda tanpa harus mengetik perintah panjang. Kita akan melihat cara bekerja dengan mesin remote menggunakan SSH.


# Job Control

Dalam beberapa kasus Anda perlu menghentikan pekerjaan saat sedang berjalan, misalnya jika suatu perintah membutuhkan waktu terlalu lama untuk selesai (seperti `find` dengan struktur direktori yang sangat besar untuk dicari).
Sebagian besar waktu, Anda bisa melakukan `Ctrl-C` dan perintah akan berhenti.
Tetapi bagaimana sebenarnya ini bekerja dan mengapa terkadang gagal menghentikan proses?

## Membunuh sebuah proses

Shell Anda menggunakan mekanisme komunikasi UNIX yang disebut _signal_ untuk menyampaikan informasi ke proses. Ketika sebuah proses menerima sinyal, ia menghentikan eksekusinya, menangani sinyal tersebut, dan mungkin mengubah alur eksekusi berdasarkan informasi yang disampaikan sinyal tersebut. Oleh karena itu, sinyal adalah _software interrupt_.

Dalam kasus kita, ketika mengetik `Ctrl-C` ini menyebabkan shell mengirimkan sinyal `SIGINT` ke proses.

Berikut adalah contoh minimal program Python yang menangkap `SIGINT` dan mengabaikannya, sehingga tidak berhenti. Untuk mematikan program ini kita bisa menggunakan sinyal `SIGQUIT` sebagai gantinya, dengan mengetik `Ctrl-\`.

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

Berikut yang terjadi jika kita mengirim `SIGINT` dua kali ke program ini, diikuti oleh `SIGQUIT`. Perhatikan bahwa `^` adalah cara `Ctrl` ditampilkan saat diketik di terminal.

```
$ python sigint.py
24^C
I got a SIGINT, but I am not stopping
26^C
I got a SIGINT, but I am not stopping
30^\[1]    39913 quit       python sigint.py
```

Meskipun `SIGINT` dan `SIGQUIT` keduanya biasanya terkait dengan permintaan terminal, sinyal yang lebih umum untuk meminta proses keluar dengan baik adalah sinyal `SIGTERM`.
Untuk mengirim sinyal ini kita bisa menggunakan perintah [`kill`](https://www.man7.org/linux/man-pages/man1/kill.1.html), dengan sintaks `kill -TERM <PID>`.

## Menjeda dan memproses di latar belakang proses

Sinyal dapat melakukan hal lain selain membunuh proses. Misalnya, `SIGSTOP` menjeda sebuah proses. Di terminal, mengetik `Ctrl-Z` akan menyebabkan shell mengirimkan sinyal `SIGTSTP`, singkatan dari Terminal Stop (yaitu versi terminal dari `SIGSTOP`).

Kita kemudian dapat melanjutkan pekerjaan yang dijeda di latar depan atau latar belakang menggunakan [`fg`](https://www.man7.org/linux/man-pages/man1/fg.1p.html) atau [`bg`](https://man7.org/linux/man-pages/man1/bg.1p.html), masing-masing.

Perintah [`jobs`](https://www.man7.org/linux/man-pages/man1/jobs.1p.html) menampilkan daftar pekerjaan yang belum selesai yang terkait dengan sesi terminal saat ini.
Anda dapat merujuk ke pekerjaan tersebut menggunakan pid mereka (Anda bisa menggunakan [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) untuk mengetahuinya).
Secara lebih intuitif, Anda juga dapat merujuk ke proses menggunakan simbol persen diikuti dengan nomor pekerjaannya (ditampilkan oleh `jobs`). Untuk merujuk ke pekerjaan terakhir yang dijalankan di latar belakang, Anda dapat menggunakan parameter khusus `$!`.

Satu hal lagi yang perlu diketahui adalah bahwa sufiks `&` dalam perintah akan menjalankan perintah di latar belakang, mengembalikan prompt kepada Anda, meskipun masih akan menggunakan STDOUT shell yang bisa mengganggu (gunakan shell redirections dalam kasus tersebut).

Untuk memindahkan program yang sudah berjalan ke latar belakang, Anda bisa melakukan `Ctrl-Z` diikuti oleh `bg`.
Perhatikan bahwa proses di latar belakang masih merupakan proses anak dari terminal Anda dan akan mati jika Anda menutup terminal (ini akan mengirimkan sinyal lain, `SIGHUP`).
Untuk mencegah hal itu terjadi, Anda bisa menjalankan program dengan [`nohup`](https://www.man7.org/linux/man-pages/man1/nohup.1.html) (wrapper untuk mengabaikan `SIGHUP`), atau menggunakan `disown` jika proses sudah dimulai.
Sebagai alternatif, Anda bisa menggunakan terminal multiplexer seperti yang akan kita lihat di bagian berikutnya.

Berikut adalah sesi contoh untuk menunjukkan beberapa konsep ini.

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

$ bg %1
[1]  - 18653 continued  sleep 1000

$ jobs
[1]  - running    sleep 1000
[2]  + running    nohup sleep 2000

$ kill -STOP %1
[1]  + 18653 suspended (signal)  sleep 1000

$ jobs
[1]  + suspended (signal)  sleep 1000
[2]  - running    nohup sleep 2000

$ kill -SIGHUP %1
[1]  + 18653 hangup     sleep 1000

$ jobs
[2]  + running    nohup sleep 2000

$ kill -SIGHUP %2

$ jobs
[2]  + running    nohup sleep 2000

$ kill %2
[2]  + 18745 terminated  nohup sleep 2000

$ jobs

```

Sinyal khusus adalah `SIGKILL` karena tidak dapat ditangkap oleh proses dan akan selalu menghentikannya segera. Namun, ini bisa memiliki efek samping yang buruk seperti meninggalkan proses anak yang yatim.

Anda dapat mempelajari lebih lanjut tentang sinyal-sinyal ini dan sinyal lainnya [di sini](https://en.wikipedia.org/wiki/Signal_(IPC)) atau dengan mengetik [`man signal`](https://www.man7.org/linux/man-pages/man7/signal.7.html) atau `kill -l`.


# Terminal Multiplexer

Saat menggunakan command-line interface, Anda sering kali ingin menjalankan lebih dari satu hal sekaligus.
Misalnya, Anda mungkin ingin menjalankan editor dan program Anda secara berdampingan.
Meskipun ini dapat dicapai dengan membuka jendela terminal baru, menggunakan terminal multiplexer adalah solusi yang lebih serbaguna.

Terminal multiplexer seperti [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) memungkinkan Anda melakukan multiplex jendela terminal menggunakan panel dan tab sehingga Anda dapat berinteraksi dengan beberapa sesi shell.
Selain itu, terminal multiplexer memungkinkan Anda melepaskan sesi terminal saat ini dan menghubungkannya kembali di kemudian hari.
Ini dapat membuat alur kerja Anda jauh lebih baik saat bekerja dengan mesin remote karena menghindari kebutuhan menggunakan `nohup` dan trik serupa.

Terminal multiplexer yang paling populer saat ini adalah [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html). `tmux` sangat dapat dikonfigurasi dan dengan menggunakan keybinding yang terkait, Anda dapat membuat beberapa tab dan panel serta menavigasinya dengan cepat.

`tmux` mengharuskan Anda mengetahui keybinding-nya, dan semuanya memiliki bentuk `<C-b> x` yang berarti (1) tekan `Ctrl+b`, (2) lepaskan `Ctrl+b`, lalu (3) tekan `x`. `tmux` memiliki hierarki objek berikut:
- **Sessions** - sebuah sesi adalah ruang kerja independen dengan satu atau lebih jendela
    + `tmux` memulai sesi baru.
    + `tmux new -s NAME` memulainya dengan nama tersebut.
    + `tmux ls` menampilkan sesi saat ini
    + Di dalam `tmux` mengetik `<C-b> d`  melepaskan sesi saat ini
    + `tmux a` menghubungkan sesi terakhir. Anda dapat menggunakan flag `-t` untuk menentukan yang mana

- **Windows** - Setara dengan tab di editor atau browser, mereka adalah bagian yang secara visual terpisah dari sesi yang sama
    + `<C-b> c` Membuat jendela baru. Untuk menutupnya Anda cukup menghentikan shell dengan `<C-d>`
    + `<C-b> N` Pergi ke jendela ke-_N_. Perhatikan mereka diberi nomor
    + `<C-b> p` Pergi ke jendela sebelumnya
    + `<C-b> n` Pergi ke jendela berikutnya
    + `<C-b> ,` Mengganti nama jendela saat ini
    + `<C-b> w` Daftar jendela saat ini

- **Panes** - Seperti split di vim, panel memungkinkan Anda memiliki beberapa shell dalam tampilan visual yang sama.
    + `<C-b> "` Membagi panel saat ini secara horizontal
    + `<C-b> %` Membagi panel saat ini secara vertikal
    + `<C-b> <direction>` Pindah ke panel di _arah_ yang ditentukan. Arah di sini berarti tombol panah.
    + `<C-b> z` Toggle zoom untuk panel saat ini
    + `<C-b> [` Memulai scrollback. Anda kemudian dapat menekan `<space>` untuk memulai seleksi dan `<enter>` untuk menyalin seleksi tersebut.
    + `<C-b> <space>` Berputar melalui susunan panel.

Untuk bacaan lebih lanjut,
[di sini](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) adalah tutorial singkat tentang `tmux` dan [ini](https://linuxcommand.org/lc3_adv_termmux.php) memiliki penjelasan lebih detail yang mencakup perintah `screen` asli. Anda mungkin juga ingin membiasakan diri dengan [`screen`](https://www.man7.org/linux/man-pages/man1/screen.1.html), karena sudah terinstal di sebagian besar sistem UNIX.

# Alias

Bisa menjadi melelahkan mengetik perintah panjang yang melibatkan banyak flag atau opsi verbose.
Untuk alasan ini, sebagian besar shell mendukung _alias_.
Alias shell adalah bentuk pendek dari perintah lain yang akan diganti secara otomatis oleh shell Anda.
Misalnya, alias di bash memiliki struktur berikut:

```bash
alias alias_name="command_to_alias arg1 arg2"
```

Perhatikan bahwa tidak ada spasi di sekitar tanda sama dengan `=`, karena [`alias`](https://www.man7.org/linux/man-pages/man1/alias.1p.html) adalah perintah shell yang mengambil satu argumen.

Alias memiliki banyak fitur yang nyaman:

```bash
# Membuat singkatan untuk flag umum
alias ll="ls -lh"

# Menghemat banyak pengetikan untuk perintah umum
alias gs="git status"
alias gc="git commit"
alias v="vim"

# Menghindari salah ketik
alias sl=ls

# Menimpa perintah yang ada untuk default yang lebih baik
alias mv="mv -i"           # -i meminta konfirmasi sebelum menimpa
alias mkdir="mkdir -p"     # -p membuat direktori induk sesuai kebutuhan
alias df="df -h"           # -h mencetak format yang mudah dibaca manusia

# Alias dapat disusun
alias la="ls -A"
alias lla="la -l"

# Untuk mengabaikan alias, jalankan dengan awalan \
\ls
# Atau nonaktifkan alias sepenuhnya dengan unalias
unalias la

# Untuk mendapatkan definisi alias cukup panggil dengan alias
alias ll
# Akan mencetak ll='ls -lh'
```

Perhatikan bahwa alias tidak bertahan secara default di sesi shell.
Untuk membuat alias tetap ada, Anda perlu memasukkannya ke dalam file startup shell, seperti `.bashrc` atau `.zshrc`, yang akan kita bahas di bagian berikutnya.


# Dotfiles

Banyak program dikonfigurasi menggunakan file teks biasa yang dikenal sebagai _dotfiles_
(karena nama file dimulai dengan `.`, misalnya `~/.vimrc`, sehingga mereka
tersembunyi di daftar direktori `ls` secara default).

Shell adalah salah satu contoh program yang dikonfigurasi dengan file seperti ini. Saat startup, shell Anda akan membaca banyak file untuk memuat konfigurasinya.
Tergantung pada shell, apakah Anda memulai login dan/atau interaktif, seluruh prosesnya bisa cukup kompleks.
[Di sini](https://web.archive.org/web/20260329133158/https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) adalah sumber daya yang sangat baik tentang topik ini.

Untuk `bash`, mengedit `.bashrc` atau `.bash_profile` akan berfungsi di sebagian besar sistem.
Di sini Anda dapat menyertakan perintah yang ingin Anda jalankan saat startup, seperti alias yang baru saja kita deskripsikan atau modifikasi pada variabel lingkungan `PATH` Anda.
Faktanya, banyak program akan meminta Anda untuk menyertakan baris seperti `export PATH="$PATH:/path/to/program/bin"` di file konfigurasi shell Anda sehingga biner mereka dapat ditemukan.

Beberapa contoh lain alat yang dapat dikonfigurasi melalui dotfiles adalah:

- `bash` - `~/.bashrc`, `~/.bash_profile`
- `git` - `~/.gitconfig`
- `vim` - `~/.vimrc` dan folder `~/.vim`
- `ssh` - `~/.ssh/config`
- `tmux` - `~/.tmux.conf`

Bagaimana sebaiknya Anda mengatur dotfiles Anda? Mereka harus berada di folder tersendiri,
di bawah version control, dan **di-symlink** ke tempatnya menggunakan skrip. Ini memiliki
keuntungan:

- **Instalasi mudah**: jika Anda login ke mesin baru, menerapkan
  kustomisasi Anda hanya akan memakan waktu satu menit.
- **Portabilitas**: alat-alat Anda akan bekerja dengan cara yang sama di mana saja.
- **Sinkronisasi**: Anda dapat memperbarui dotfiles Anda di mana saja dan menjaga semuanya
  tetap sinkron.
- **Pelacakan perubahan**: Anda mungkin akan memelihara dotfiles Anda
  sepanjang karier pemrograman Anda, dan riwayat versi berguna untuk
  proyek jangka panjang.

Apa yang harus Anda masukkan ke dotfiles Anda?
Anda dapat mempelajari tentang pengaturan alat Anda dengan membaca dokumentasi online atau
[man page](https://en.wikipedia.org/wiki/Man_page). Cara hebat lainnya adalah
mencari di internet postingan blog tentang program tertentu, di mana penulis akan
memberi tahu Anda tentang kustomisasi pilihan mereka. Cara lain untuk mempelajari tentang
kustomisasi adalah dengan melihat dotfiles orang lain: Anda dapat menemukan banyak
[repositori
dotfiles](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories)
di GitHub --- lihat yang paling populer
[di sini](https://github.com/mathiasbynens/dotfiles) (kami menyarankan Anda untuk tidak menyalin
konfigurasi secara membabi buta).
[Di sini](https://dotfiles.github.io/) adalah sumber daya bagus lainnya tentang topik ini.

Semua instruktur kelas memiliki dotfiles mereka yang dapat diakses secara publik di GitHub: [Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/jjgo/dotfiles).


## Portabilitas

Masalah umum dengan dotfiles adalah bahwa konfigurasi mungkin tidak berfungsi saat bekerja dengan beberapa mesin, misalnya jika mereka memiliki sistem operasi atau shell yang berbeda. Terkadang Anda juga ingin beberapa konfigurasi hanya diterapkan pada mesin tertentu.

Ada beberapa trik untuk memudahkan hal ini.
Jika file konfigurasi mendukungnya, gunakan setara if-statement untuk
menerapkan kustomisasi spesifik mesin. Misalnya, shell Anda bisa memiliki sesuatu
seperti:

```bash
if [[ "$(uname)" == "Linux" ]]; then {do_something}; fi

# Periksa sebelum menggunakan fitur spesifik shell
if [[ "$SHELL" == "zsh" ]]; then {do_something}; fi

# Anda juga bisa membuatnya spesifik mesin
if [[ "$(hostname)" == "myServer" ]]; then {do_something}; fi
```

Jika file konfigurasi mendukungnya, manfaatkan includes. Misalnya,
`~/.gitconfig` bisa memiliki pengaturan:

```
[include]
    path = ~/.gitconfig_local
```

Dan kemudian di setiap mesin, `~/.gitconfig_local` dapat berisi pengaturan
spesifik mesin. Anda bahkan bisa melacak ini di repositori terpisah untuk
pengaturan spesifik mesin.

Ide ini juga berguna jika Anda ingin program berbeda berbagi beberapa konfigurasi. Misalnya, jika Anda ingin `bash` dan `zsh` berbagi set alias yang sama, Anda dapat menulisnya di `.aliases` dan memiliki blok berikut di keduanya:

```bash
# Uji apakah ~/.aliases ada dan source itu
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi
```

# Mesin Remote

Sudah semakin umum bagi programmer untuk menggunakan server remote dalam pekerjaan sehari-hari mereka. Jika Anda perlu menggunakan server remote untuk mendeploy perangkat lunak backend atau Anda membutuhkan server dengan kemampuan komputasi yang lebih tinggi, Anda akan menggunakan Secure Shell (SSH). Seperti kebanyakan alat yang dibahas, SSH sangat dapat dikonfigurasi sehingga layak untuk dipelajari.

Untuk melakukan `ssh` ke server, Anda menjalankan perintah sebagai berikut

```bash
ssh foo@bar.mit.edu
```

Di sini kita mencoba ssh sebagai user `foo` di server `bar.mit.edu`.
Server dapat ditentukan dengan URL (seperti `bar.mit.edu`) atau IP (sesuatu seperti `foobar@192.168.1.42`). Nanti kita akan melihat bahwa jika kita memodifikasi file konfigurasi ssh, Anda dapat mengakses hanya dengan menggunakan sesuatu seperti `ssh bar`.

## Menjalankan perintah

Fitur `ssh` yang sering diabaikan adalah kemampuan untuk menjalankan perintah secara langsung.
`ssh foobar@server ls` akan menjalankan `ls` di folder home foobar.
Ini berfungsi dengan pipe, jadi `ssh foobar@server ls | grep PATTERN` akan melakukan grep secara lokal pada output remote dari `ls` dan `ls | ssh foobar@server grep PATTERN` akan melakukan grep secara remote pada output lokal dari `ls`.


## SSH Keys

Autentikasi berbasis key memanfaatkan kriptografi public-key untuk membuktikan kepada server bahwa klien memiliki private key rahasia tanpa mengungkapkan key tersebut. Dengan cara ini Anda tidak perlu memasukkan ulang password setiap saat. Namun demikian, private key (seringkali `~/.ssh/id_rsa` dan baru-baru ini `~/.ssh/id_ed25519`) secara efektif adalah password Anda, jadi perlakukan seperti itu.

### Pembuatan key

Untuk membuat pasangan key, Anda dapat menjalankan [`ssh-keygen`](https://www.man7.org/linux/man-pages/man1/ssh-keygen.1.html).
```bash
ssh-keygen -a 100 -t ed25519 -f ~/.ssh/id_ed25519
```
Anda harus memilih passphrase, untuk menghindari seseorang yang mendapatkan private key Anda untuk mengakses server yang diotorisasi. Gunakan [`ssh-agent`](https://www.man7.org/linux/man-pages/man1/ssh-agent.1.html) atau [`gpg-agent`](https://linux.die.net/man/1/gpg-agent) sehingga Anda tidak perlu mengetik passphrase setiap saat.

Jika Anda pernah mengkonfigurasi push ke GitHub menggunakan SSH keys, maka Anda mungkin telah melakukan langkah-langkah yang diuraikan [di sini](https://help.github.com/articles/connecting-to-github-with-ssh/) dan sudah memiliki pasangan key yang valid. Untuk memeriksa apakah Anda memiliki passphrase dan memvalidasinya, Anda dapat menjalankan `ssh-keygen -y -f /path/to/key`.

### Autentikasi berbasis key

`ssh` akan melihat ke `.ssh/authorized_keys` untuk menentukan klien mana yang harus diizinkan masuk. Untuk menyalin public key, Anda dapat menggunakan:

```bash
cat .ssh/id_ed25519.pub | ssh foobar@remote 'cat >> ~/.ssh/authorized_keys'
```

Solusi yang lebih sederhana dapat dicapai dengan `ssh-copy-id` jika tersedia:

```bash
ssh-copy-id -i .ssh/id_ed25519 foobar@remote
```

## Menyalin file melalui SSH

Ada banyak cara untuk menyalin file melalui ssh:

- `ssh+tee`, yang paling sederhana adalah menggunakan eksekusi perintah `ssh` dan input STDIN dengan melakukan `cat localfile | ssh remote_server tee serverfile`. Ingat bahwa [`tee`](https://www.man7.org/linux/man-pages/man1/tee.1.html) menulis output dari STDIN ke sebuah file.
- [`scp`](https://www.man7.org/linux/man-pages/man1/scp.1.html) saat menyalin banyak file/direktori, perintah secure copy `scp` lebih nyaman karena dapat dengan mudah melakukan rekursi melalui path. Sintaksnya adalah `scp path/to/local_file remote_host:path/to/remote_file`
- [`rsync`](https://www.man7.org/linux/man-pages/man1/rsync.1.html) meningkatkan `scp` dengan mendeteksi file identik di lokal dan remote, dan mencegah penyalinan ulang. Ini juga memberikan kontrol yang lebih halus atas symlink, permission, dan memiliki fitur tambahan seperti flag `--partial` yang dapat melanjutkan salinan yang sebelumnya terganggu. `rsync` memiliki sintaks yang mirip dengan `scp`.

## Port Forwarding

Dalam banyak skenario, Anda akan menemukan perangkat lunak yang mendengarkan port tertentu di mesin. Ketika ini terjadi di mesin lokal Anda, Anda dapat mengetik `localhost:PORT` atau `127.0.0.1:PORT`, tetapi apa yang Anda lakukan dengan server remote yang port-nya tidak tersedia secara langsung melalui jaringan/internet?

Ini disebut _port forwarding_ dan memiliki
dua jenis: Local Port Forwarding dan Remote Port Forwarding (lihat gambar untuk detail lebih lanjut, kredit gambar dari [postingan StackOverflow ini](https://unix.stackexchange.com/questions/115897/whats-ssh-port-forwarding-and-whats-the-difference-between-ssh-local-and-remot)).

**Local Port Forwarding**
![Local Port Forwarding](/static/media/images/local-port-forwarding.png)

**Remote Port Forwarding**
![Remote Port Forwarding](/static/media/images/remote-port-forwarding.png)

Skenario yang paling umum adalah local port forwarding, di mana layanan di mesin remote mendengarkan di port tertentu dan Anda ingin menghubungkan port di mesin lokal Anda untuk meneruskan ke port remote. Misalnya, jika kita menjalankan `jupyter notebook` di server remote yang mendengarkan port `8888`. Maka, untuk meneruskan itu ke port lokal `9999`, kita akan melakukan `ssh -L 9999:localhost:8888 foobar@remote_server` dan kemudian navigasi ke `localhost:9999` di mesin lokal kita.


## Konfigurasi SSH

Kita telah membahas banyak argumen yang dapat kita berikan. Alternatif yang menggoda adalah membuat alias shell yang terlihat seperti
```bash
alias my_server="ssh -i ~/.id_ed25519 --port 2222 -L 9999:localhost:8888 foobar@remote_server"
```

Namun, ada alternatif yang lebih baik menggunakan `~/.ssh/config`.

```bash
Host vm
    User foobar
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
    LocalForward 9999 localhost:8888

# Configs can also take wildcards
Host *.mit.edu
    User foobaz
```

Keuntungan tambahan menggunakan file `~/.ssh/config` dibandingkan alias adalah bahwa program lain seperti `scp`, `rsync`, `mosh`, dll. juga dapat membacanya dan mengonversi pengaturan menjadi flag yang sesuai.


Perhatikan bahwa file `~/.ssh/config` dapat dianggap sebagai dotfile, dan secara umum tidak masalah untuk disertakan bersama dotfiles Anda lainnya. Namun, jika Anda membuatnya publik, pikirkan tentang informasi yang mungkin Anda berikan kepada orang asing di internet: alamat server Anda, user, port yang terbuka, dll. Ini dapat memfasilitasi beberapa jenis serangan jadi berhati-hatilah dalam membagikan konfigurasi SSH Anda.

Konfigurasi sisi server biasanya ditentukan di `/etc/ssh/sshd_config`. Di sini Anda dapat membuat perubahan seperti menonaktifkan autentikasi password, mengubah port ssh, mengaktifkan X11 forwarding, dll. Anda dapat menentukan pengaturan konfigurasi per user.

## Lain-lain

Masalah umum saat menghubungkan ke server remote adalah pemutusan karena komputer Anda mati, tidur, atau berpindah jaringan. Selain itu, jika seseorang memiliki koneksi dengan lag yang signifikan, menggunakan ssh bisa menjadi sangat frustrasi. [Mosh](https://mosh.org/), the mobile shell, meningkatkan ssh, memungkinkan koneksi roaming, konektivitas terputus-putus, dan menyediakan echo lokal yang cerdas.

Terkadang nyaman untuk me-mount folder remote. [sshfs](https://github.com/libfuse/sshfs) dapat me-mount folder di server remote
secara lokal, dan kemudian Anda dapat menggunakan editor lokal.


# Shell & Framework

Selama alat shell dan scripting, kita telah membahas shell `bash` karena ini adalah shell yang paling umum dan sebagian besar sistem memilikinya sebagai opsi default. Namun demikian, ini bukan satu-satunya opsi.

Sebagai contoh, shell `zsh` adalah superset dari `bash` dan menyediakan banyak fitur nyaman out of the box seperti:

- Globbing yang lebih cerdas, `**`
- Inline globbing/wildcard expansion
- Koreksi ejaan
- Tab completion/seleksi yang lebih baik
- Ekspansi path (`cd /u/lo/b` akan diekspansi sebagai `/usr/local/bin`)

**Framework** dapat meningkatkan shell Anda juga. Beberapa framework umum yang populer adalah [prezto](https://github.com/sorin-ionescu/prezto) atau [oh-my-zsh](https://ohmyz.sh/), dan yang lebih kecil yang berfokus pada fitur tertentu seperti [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) atau [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search). Shell seperti [fish](https://fishshell.com/) menyertakan banyak fitur ramah pengguna ini secara default. Beberapa fitur ini termasuk:

- Right prompt
- Command syntax highlighting
- History substring search
- manpage based flag completions
- Autocompletion yang lebih cerdas
- Tema prompt

Satu hal yang perlu diperhatikan saat menggunakan framework ini adalah mereka mungkin memperlambat shell Anda, terutama jika kode yang mereka jalankan tidak dioptimalkan dengan baik atau terlalu banyak kode. Anda selalu dapat melakukan profiling dan menonaktifkan fitur yang tidak sering Anda gunakan atau mengutamakan kecepatan.

# Terminal Emulator

Selain mengkustomisasi shell Anda, ada baiknya meluangkan waktu untuk mencari tahu pilihan **terminal emulator** Anda dan pengaturannya. Ada banyak terminal emulator di luar sana (berikut adalah [perbandingan](https://anarc.at/blog/2018-04-12-terminal-emulators-1/)).

Karena Anda mungkin menghabiskan ratusan hingga ribuan jam di terminal Anda, ada baiknya memeriksa pengaturannya. Beberapa aspek yang mungkin ingin Anda modifikasi di terminal Anda termasuk:

- Pilihan font
- Skema warna
- Pintasan keyboard
- Dukungan Tab/Pane
- Konfigurasi scrollback
- Performa (beberapa terminal baru seperti [Alacritty](https://github.com/jwilm/alacritty) atau [kitty](https://sw.kovidgoyal.net/kitty/) menawarkan akselerasi GPU).

# Latihan

## Job control

1. Dari apa yang telah kita lihat, kita dapat menggunakan beberapa perintah `ps aux | grep` untuk mendapatkan pid pekerjaan kita dan kemudian membunuhnya, tetapi ada cara yang lebih baik. Mulai pekerjaan `sleep 10000` di terminal, pindahkan ke latar belakang dengan `Ctrl-Z` dan lanjutkan eksekusinya dengan `bg`. Sekarang gunakan [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) untuk menemukan pid-nya dan [`pkill`](https://man7.org/linux/man-pages/man1/pgrep.1.html) untuk membunuhnya tanpa pernah mengetik pid itu sendiri. (Petunjuk: gunakan flag `-af`).

1. Katakanlah Anda tidak ingin memulai proses sampai proses lain selesai. Bagaimana cara Anda melakukannya? Dalam latihan ini, proses pembatas kita akan selalu menjadi `sleep 60 &`.
Salah satu cara untuk mencapainya adalah dengan menggunakan perintah [`wait`](https://www.man7.org/linux/man-pages/man1/wait.1p.html). Coba luncurkan perintah sleep dan buat `ls` menunggu sampai proses latar belakang selesai.

    Namun, strategi ini akan gagal jika kita mulai di sesi bash yang berbeda, karena `wait` hanya bekerja untuk proses anak. Satu fitur yang tidak kita bahas dalam catatan adalah bahwa status keluar perintah `kill` akan bernilai nol jika berhasil dan bukan nol jika gagal. `kill -0` tidak mengirim sinyal tetapi akan memberikan status keluar bukan nol jika proses tidak ada.
    Tulis fungsi bash yang disebut `pidwait` yang mengambil pid dan menunggu sampai proses yang diberikan selesai. Anda harus menggunakan `sleep` untuk menghindari penggunaan CPU secara tidak perlu.

## Terminal multiplexer

1. Ikuti [tutorial](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) `tmux` ini dan kemudian pelajari cara melakukan beberapa kustomisasi dasar dengan mengikuti [langkah-langkah ini](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/).

## Alias

1. Buat alias `dc` yang mengarah ke `cd` untuk saat Anda salah mengetiknya.

1. Jalankan `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10` untuk mendapatkan 10 perintah yang paling sering Anda gunakan dan pertimbangkan untuk menulis alias yang lebih pendek untuk mereka. Catatan: ini berfungsi untuk Bash; jika Anda menggunakan ZSH, gunakan `history 1` bukan hanya `history`.


## Dotfiles

Mari kita mulai dengan dotfiles.
1. Buat folder untuk dotfiles Anda dan atur version
   control.
1. Tambahkan konfigurasi untuk setidaknya satu program, misalnya shell Anda, dengan beberapa
   kustomisasi (untuk memulai, ini bisa sesederhana mengkustomisasi prompt shell Anda dengan mengatur `$PS1`).
1. Siapkan metode untuk menginstal dotfiles Anda dengan cepat (dan tanpa usaha manual) di mesin baru. Ini bisa sesederhana skrip shell yang memanggil `ln -s` untuk setiap file, atau Anda bisa menggunakan [utilitas
   khusus](https://dotfiles.github.io/utilities/).
1. Uji skrip instalasi Anda di mesin virtual baru.
1. Pindahkan semua konfigurasi alat Anda saat ini ke repositori dotfiles Anda.
1. Publikasikan dotfiles Anda di GitHub.

## Mesin Remote

Instal mesin virtual Linux (atau gunakan yang sudah ada) untuk latihan ini. Jika Anda tidak familiar dengan mesin virtual, lihat [tutorial](https://hibbard.eu/install-ubuntu-virtual-box/) ini untuk menginstalnya.

1. Pergi ke `~/.ssh/` dan periksa apakah Anda memiliki pasangan SSH keys di sana. Jika tidak, buat dengan `ssh-keygen -a 100 -t ed25519`. Disarankan bahwa Anda menggunakan password dan menggunakan `ssh-agent`, info lebih lanjut [di sini](https://www.ssh.com/ssh/agent).
1. Edit `.ssh/config` untuk memiliki entri sebagai berikut

    ```bash
    Host vm
        User username_goes_here
        HostName ip_goes_here
        IdentityFile ~/.ssh/id_ed25519
        LocalForward 9999 localhost:8888
    ```
1. Gunakan `ssh-copy-id vm` untuk menyalin ssh key Anda ke server.
1. Mulai webserver di VM Anda dengan menjalankan `python -m http.server 8888`. Akses webserver VM dengan navigasi ke `http://localhost:9999` di mesin Anda.
1. Edit konfigurasi server SSH Anda dengan melakukan `sudo vim /etc/ssh/sshd_config` dan nonaktifkan autentikasi password dengan mengedit nilai `PasswordAuthentication`. Nonaktifkan root login dengan mengedit nilai `PermitRootLogin`. Restart layanan `ssh` dengan `sudo service sshd restart`. Coba ssh lagi.
1. (Tantangan) Instal [`mosh`](https://mosh.org/) di VM dan buat koneksi. Kemudian putuskan adaptor jaringan server/VM. Dapatkah mosh pulih dengan baik?
1. (Tantangan) Cari tahu apa yang dilakukan flag `-N` dan `-f` di `ssh` dan cari tahu perintah untuk mencapai port forwarding di latar belakang.
