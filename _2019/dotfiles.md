---
layout: lecture
title: "Dotfiles"
presenter: Anish
date: 2019-01-24
order: 1
video:
  aspect: 62.5
  id: YSZBWWJw3mI
---

Banyak program dikonfigurasi menggunakan berkas teks biasa yang dikenal sebagai "dotfiles"
(karena nama berkas diawali dengan `.`, misalnya `~/.gitconfig`, sehingga berkas tersebut
tersembunyi di daftar direktori `ls` secara default).

Banyak alat yang Anda gunakan mungkin memiliki banyak pengaturan yang dapat disetel
dengan cukup detail. Seringkali, alat disesuaikan dengan bahasa khusus,
misalnya Vimscript untuk Vim atau bahasa shell itu sendiri untuk shell.

Menyesuaikan dan mengadaptasi alat-alat Anda ke alur kerja yang Anda inginkan akan membuat Anda
lebih produktif. Kami menyarankan Anda untuk menginvestasikan waktu dalam menyesuaikan alat Anda sendiri
daripada meng-clone dotfiles orang lain dari GitHub.

Anda mungkin sudah memiliki beberapa dotfiles yang disiapkan. Beberapa tempat untuk melihat:

- `~/.bashrc`
- `~/.emacs`
- `~/.vim`
- `~/.gitconfig`

Beberapa program tidak meletakkan berkas langsung di folder home Anda, melainkan meletakkannya di folder di bawah `~/.config`.

Dotfiles tidak eksklusif untuk aplikasi baris perintah, misalnya pemutar video [MPV](https://mpv.io/) dapat dikonfigurasi dengan mengedit berkas di bawah `~/.config/mpv`

# Belajar menyesuaikan alat

Anda dapat mempelajari pengaturan alat Anda dengan membaca dokumentasi daring atau
[man pages](https://en.wikipedia.org/wiki/Man_page). Cara hebat lainnya adalah
mencari di internet untuk postingan blog tentang program tertentu, di mana penulis akan
memberitahu Anda tentang kustomisasi pilihan mereka. Cara lain untuk mempelajari
kustomisasi adalah dengan melihat dotfiles milik orang lain: Anda dapat menemukan banyak
[repositori
dotfiles](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories)
di GitHub --- lihat yang paling populer
[di sini](https://github.com/mathiasbynens/dotfiles) (kami menyarankan Anda untuk tidak menyalin
konfigurasi secara membabi buta).

# Organisasi

Bagaimana sebaiknya Anda mengatur dotfiles Anda? Dotfiles harus berada di folder tersendiri,
di bawah version control, dan **di-symlink** ke tempatnya menggunakan script. Ini memiliki
keuntungan:

- **Instalasi mudah**: jika Anda login ke mesin baru, menerapkan kustomisasi Anda
hanya akan memakan waktu satu menit
- **Portabilitas**: alat Anda akan bekerja dengan cara yang sama di mana pun
- **Sinkronisasi**: Anda dapat memperbarui dotfiles Anda di mana saja dan menjaganya tetap
sinkron
- **Pelacakan perubahan**: Anda mungkin akan memelihara dotfiles Anda
sepanjang karier pemrograman Anda, dan riwayat versi sangat berguna untuk
proyek jangka panjang

```shell
cd ~/src
mkdir dotfiles
cd dotfiles
git init
touch bashrc
# create a bashrc with some settings, e.g.:
#     PS1='\w > '
touch install
chmod +x install
# insert the following into the install script:
#     #!/usr/bin/env bash
#     BASEDIR=$(dirname $0)
#     cd $BASEDIR
#
#     ln -s ${PWD}/bashrc ~/.bashrc
git add bashrc install
git commit -m 'Initial commit'
```

# Topik lanjutan

## Kustomisasi khusus mesin

Sebagian besar waktu, Anda akan menginginkan konfigurasi yang sama di semua mesin, tetapi
terkadang, Anda akan menginginkan sedikit perbedaan di mesin tertentu. Berikut adalah beberapa
cara yang dapat Anda gunakan untuk menangani situasi ini:

### Branch per mesin

Gunakan version control untuk mempertahankan branch per mesin. Pendekatan ini
secara logis mudah dipahami tetapi bisa cukup berat.

### Pernyataan if

Jika berkas konfigurasi mendukungnya, gunakan setara pernyataan if untuk
menerapkan kustomisasi khusus mesin. Misalnya, shell Anda dapat memiliki sesuatu
seperti:

```shell
if [[ "$(uname)" == "Linux" ]]; then {do_something else}; fi

# Darwin is the architecture name for macOS systems
if [[ "$(uname)" == "Darwin" ]]; then {do_something}; fi

# You can also make it machine specific
if [[ "$(hostname)" == "myServer" ]]; then {do_something}; fi
```

### Includes

Jika berkas konfigurasi mendukungnya, gunakan includes. Misalnya,
`~/.gitconfig` dapat memiliki pengaturan:

```
[include]
    path = ~/.gitconfig_local
```

Kemudian di setiap mesin, `~/.gitconfig_local` dapat berisi pengaturan khusus mesin.
Anda bahkan dapat melacak ini di repositori terpisah untuk
pengaturan khusus mesin.

Ide ini juga berguna jika Anda ingin program berbeda berbagi beberapa konfigurasi. Misalnya jika Anda ingin `bash` dan `zsh` berbagi set alias yang sama, Anda dapat menulisnya di `.aliases` dan memiliki blok berikut di keduanya.

```bash
# Test if ~/.aliases exists and source it
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi
```

# Sumber daya

- Dotfiles para instruktur Anda:
  [Anish](https://github.com/anishathalye/dotfiles),
  [Jon](https://github.com/jonhoo/configs),
  [Jose](https://github.com/jjgo/dotfiles)
- [GitHub does dotfiles](https://dotfiles.github.io/): framework,
  utilitas, contoh, dan tutorial dotfile
- [Shell startup
  scripts](https://web.archive.org/web/20260329133158/https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html):
  penjelasan tentang berkas konfigurasi berbeda yang digunakan untuk shell Anda

# Latihan

1. Buat folder untuk dotfiles Anda dan siapkan [version
   control](/2019/version-control/).

1. Tambahkan konfigurasi untuk setidaknya satu program, misalnya shell Anda, dengan beberapa
   kustomisasi (untuk memulai, ini bisa sesederhana menyesuaikan
   prompt shell Anda dengan menyetel `$PS1`).

1. Siapkan metode untuk menginstal dotfiles Anda dengan cepat (dan tanpa usaha manual)
   di mesin baru. Ini bisa sesederhana script shell yang memanggil `ln -s`
   untuk setiap berkas, atau Anda dapat menggunakan [utilitas
   khusus](https://dotfiles.github.io/utilities/).

1. Uji script instalasi Anda di virtual machine yang masih segar.

1. Pindahkan semua konfigurasi alat Anda saat ini ke repositori dotfiles Anda.

1. Publikasikan dotfiles Anda di GitHub.
