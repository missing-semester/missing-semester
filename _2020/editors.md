---
layout: lecture
title: "Editor (Vim)"
description: >
  Pelajari cara menggunakan Vim, editor teks yang dirancang untuk pengeditan kode yang efisien.
thumbnail: /static/assets/thumbnails/2020/lec3.png
date: 2020-01-15
ready: true
video:
  aspect: 56.25
  id: a6Q8Na575qc
---

Menulis kata-kata bahasa Inggris dan menulis kode adalah aktivitas yang sangat berbeda. Saat
pemrograman, Anda menghabiskan lebih banyak waktu untuk berpindah file, membaca, navigasi, dan
mengedit kode dibandingkan menulis aliran teks yang panjang. Masuk akal jika ada
jenis program yang berbeda untuk menulis kata-kata bahasa Inggris versus kode (misalnya
Microsoft Word versus Visual Studio Code).

Sebagai programmer, kita menghabiskan sebagian besar waktu untuk mengedit kode, jadi ada baiknya menginvestasikan
waktu untuk menguasai editor yang sesuai dengan kebutuhan Anda. Berikut cara mempelajari editor baru:

- Mulailah dengan tutorial (yaitu kuliah ini, plus sumber daya yang kami tunjukkan)
- Tetap gunakan editor untuk semua kebutuhan pengeditan teks Anda (meskipun pada awalnya memperlambat
Anda)
- Cari tahu saat Anda menggunakannya: jika tampaknya ada cara yang lebih baik untuk melakukan
sesuatu, kemungkinan besar ada

Jika Anda mengikuti metode di atas, sepenuhnya berkomitmen menggunakan program baru untuk
semua tujuan pengeditan teks, timeline untuk mempelajari editor teks yang canggih
terlihat seperti ini. Dalam satu atau dua jam, Anda akan mempelajari fungsi-fungsi dasar editor
seperti membuka dan mengedit file, menyimpan/keluar, dan menavigasi buffer. Setelah
20 jam, Anda seharusnya sudah secepat saat menggunakan editor lama Anda.
Setelah itu, manfaatnya mulai terasa: Anda akan memiliki pengetahuan dan memori otot
yang cukup sehingga menggunakan editor baru menghemat waktu Anda. Editor teks modern adalah alat
yang canggih dan powerful, sehingga proses belajar tidak pernah berhenti: Anda akan menjadi lebih cepat seiring
Anda mempelajari lebih banyak hal.

# Editor mana yang harus dipelajari?

Para programmer memiliki [opini yang kuat](https://en.wikipedia.org/wiki/Editor_war)
tentang editor teks mereka.

Editor mana yang populer saat ini? Lihat [survei Stack Overflow
ini](https://insights.stackoverflow.com/survey/2019/#development-environments-and-tools)
(mungkin ada beberapa bias karena pengguna Stack Overflow mungkin tidak mewakili
seluruh programmer). [Visual Studio
Code](https://code.visualstudio.com/) adalah editor yang paling populer.
[Vim](https://www.vim.org/) adalah editor berbasis command-line yang paling populer.

## Vim

Semua instruktur kelas ini menggunakan Vim sebagai editor mereka. Vim memiliki sejarah yang kaya;
berasal dari editor Vi (1976), dan masih terus dikembangkan hingga saat ini. Vim memiliki
beberapa ide yang sangat menarik di baliknya, dan karena alasan ini,
banyak alat yang mendukung mode emulasi Vim (misalnya, 1,4 juta orang
telah menginstal [emulasi Vim untuk VS code](https://github.com/VSCodeVim/Vim)). Vim mungkin layak dipelajari meskipun pada akhirnya Anda beralih ke editor teks lain.

Tidak mungkin mengajarkan semua fungsionalitas Vim dalam 50 menit, jadi kami
akan fokus menjelaskan filosofi Vim, mengajarkan dasar-dasarnya,
menunjukkan beberapa fungsionalitas yang lebih advanced, dan memberi Anda
sumber daya untuk menguasai alat ini.

# Filosofi Vim

Saat pemrograman, Anda menghabiskan sebagian besar waktu untuk membaca/mengedit, bukan menulis. Karena
alasan ini, Vim adalah editor _modal_: ia memiliki mode yang berbeda untuk menyisipkan teks
vs memanipulasi teks. Vim dapat diprogram (dengan Vimscript dan juga bahasa
lain seperti Python), dan antarmuka Vim itu sendiri adalah bahasa pemrograman:
tekanan tombol (dengan nama mnemonik) adalah perintah, dan perintah-perintah ini
dapat dikomposisikan. Vim menghindari penggunaan mouse, karena terlalu lambat; Vim bahkan
menghindari penggunaan tombol panah karena membutuhkan terlalu banyak pergerakan.

Hasil akhirnya adalah editor yang dapat menyamai kecepatan berpikir Anda.

# Pengeditan modal

Desain Vim didasarkan pada ide bahwa banyak waktu programmer dihabiskan
untuk membaca, navigasi, dan membuat editan kecil, bukan menulis aliran teks yang panjang. Karena alasan ini, Vim memiliki beberapa mode operasi.

- **Normal**: untuk berpindah dalam file dan membuat editan
- **Insert**: untuk menyisipkan teks
- **Replace**: untuk mengganti teks
- **Visual** (plain, line, atau block): untuk memilih blok teks
- **Command-line**: untuk menjalankan perintah

Tekanan tombol memiliki arti yang berbeda dalam mode operasi yang berbeda. Misalnya,
huruf `x` dalam mode Insert hanya akan menyisipkan karakter literal 'x', tetapi dalam
mode Normal, ia akan menghapus karakter di bawah kursor, dan dalam mode Visual,
ia akan menghapus seleksi.

Dalam konfigurasi default-nya, Vim menampilkan mode saat ini di pojok kiri bawah.
Mode awal/default adalah mode Normal. Anda umumnya akan menghabiskan sebagian besar waktu
antara mode Normal dan mode Insert.

Anda mengubah mode dengan menekan `<ESC>` (tombol escape) untuk beralih dari mode apa pun
kembali ke mode Normal. Dari mode Normal, masuk ke mode Insert dengan `i`, mode Replace
dengan `R`, mode Visual dengan `v`, mode Visual Line dengan `V`, mode Visual Block
dengan `<C-v>` (Ctrl-V, terkadang juga ditulis `^V`), dan mode Command-line dengan
`:`.

Anda banyak menggunakan tombol `<ESC>` saat menggunakan Vim: pertimbangkan untuk memetakan ulang Caps Lock ke
Escape ([instruksi
macOS](https://vim.fandom.com/wiki/Map_caps_lock_to_escape_in_macOS))
atau buat [pemetaan
alternatif](https://vim.fandom.com/wiki/Avoid_the_escape_key#Mappings) untuk `<ESC>`
dengan urutan tombol sederhana.

# Dasar-dasar

## Menyisipkan teks

Dari mode Normal, tekan `i` untuk masuk ke mode Insert. Sekarang, Vim berperilaku seperti
editor teks lainnya, sampai Anda menekan `<ESC>` untuk kembali ke mode Normal. Ini,
bersama dengan dasar-dasar yang dijelaskan di atas, adalah semua yang Anda butuhkan untuk mulai mengedit file
menggunakan Vim (meskipun tidak terlalu efisien, jika Anda menghabiskan seluruh waktu Anda
mengedit dari mode Insert).

## Buffer, tab, dan window

Vim mempertahankan sekumpulan file yang terbuka, yang disebut "buffer". Sesi Vim memiliki sejumlah
tab, yang masing-masing memiliki sejumlah window (split pane). Setiap window menampilkan
satu buffer. Berbeda dengan program lain yang sudah Anda kenal, seperti browser
web, tidak ada korespondensi 1-band-1 antara buffer dan window;
window hanyalah tampilan. Suatu buffer dapat terbuka di _beberapa_ window,
bahkan dalam tab yang sama. Ini bisa sangat berguna, misalnya, untuk melihat dua
bagian berbeda dari suatu file secara bersamaan.

Secara default, Vim terbuka dengan satu tab, yang berisi satu window.

## Command-line

Mode command dapat dimasuki dengan mengetik `:` dalam mode Normal. Kursor Anda akan pindah
ke baris perintah di bagian bawah layar setelah menekan `:`. Mode ini
memiliki banyak fungsionalitas, termasuk membuka, menyimpan, dan menutup file, serta
[keluar dari Vim](https://twitter.com/iamdevloper/status/435555976687923200).

- `:q` quit (menutup window)
- `:w` save ("write")
- `:wq` save dan quit
- `:e {name of file}` membuka file untuk diedit
- `:ls` menampilkan buffer yang terbuka
- `:help {topic}` membuka bantuan
    - `:help :w` membuka bantuan untuk perintah `:w`
    - `:help w` membuka bantuan untuk gerakan `w`

# Antarmuka Vim adalah bahasa pemrograman

Ide terpenting dalam Vim adalah antarmuka Vim itu sendiri adalah bahasa pemrograman. Tekanan tombol (dengan nama mnemonik) adalah perintah, dan perintah-perintah ini
_dapat dikomposisikan_. Ini memungkinkan pergerakan dan pengeditan yang efisien, terutama setelah
perintah-perintah menjadi memori otot.

## Pergerakan

Anda seharusnya menghabiskan sebagian besar waktu dalam mode Normal, menggunakan perintah pergerakan untuk
menavigasi buffer. Pergerakan dalam Vim juga disebut "kata benda", karena merujuk pada
bagian-bagian teks.

- Pergerakan dasar: `hjkl` (kiri, bawah, atas, kanan)
- Kata: `w` (kata berikutnya), `b` (awal kata), `e` (akhir kata)
- Baris: `0` (awal baris), `^` (karakter non-kosong pertama), `$` (akhir baris)
- Layar: `H` (atas layar), `M` (tengah layar), `L` (bawah layar)
- Scroll: `Ctrl-u` (atas), `Ctrl-d` (bawah)
- File: `gg` (awal file), `G` (akhir file)
- Nomor baris: `:{number}<CR>` atau `{number}G` (baris ke-{number})
- Lain-lain: `%` (item yang sesuai)
- Cari: `f{character}`, `t{character}`, `F{character}`, `T{character}`
    - cari/menuju maju/mundur {character} pada baris saat ini
    - `,` / `;` untuk menavigasi hasil yang cocok
- Pencarian: `/{regex}`, `n` / `N` untuk menavigasi hasil yang cocok

## Seleksi

Mode Visual:

- Visual: `v`
- Visual Line: `V`
- Visual Block: `Ctrl-v`

Dapat menggunakan tombol pergerakan untuk membuat seleksi.

## Editan

Semua yang biasa Anda lakukan dengan mouse, sekarang Anda lakukan dengan keyboard
menggunakan perintah pengeditan yang dikomposisikan dengan perintah pergerakan. Di sinilah
antarmuka Vim mulai terlihat seperti bahasa pemrograman. Perintah pengeditan Vim
juga disebut "kata kerja", karena kata kerja bekerja pada kata benda.

- `i` masuk mode Insert
    - tetapi untuk memanipulasi/menghapus teks, ingin menggunakan sesuatu selain
    backspace
- `o` / `O` sisipkan baris di bawah / di atas
- `d{motion}` hapus {motion}
    - mis. `dw` adalah hapus kata, `d$` adalah hapus sampai akhir baris, `d0` adalah hapus
    sampai awal baris
- `c{motion}` ubah {motion}
    - mis. `cw` adalah ubah kata
    - seperti `d{motion}` diikuti oleh `i`
- `x` hapus karakter (sama dengan `dl`)
- `s` ganti karakter (sama dengan `cl`)
- Mode Visual + manipulasi
    - pilih teks, `d` untuk menghapusnya atau `c` untuk mengubahnya
- `u` untuk undo, `<C-r>` untuk redo
- `y` untuk menyalin / "yank" (beberapa perintah lain seperti `d` juga menyalin)
- `p` untuk menempel
- Masih banyak lagi yang perlu dipelajari: mis. `~` membalik huruf besar/kecil suatu karakter

## Jumlah

Anda dapat menggabungkan kata benda dan kata kerja dengan jumlah, yang akan melakukan tindakan tertentu
seberapa kali.

- `3w` pindah 3 kata ke depan
- `5j` pindah 5 baris ke bawah
- `7dw` hapus 7 kata

## Modifier

Anda dapat menggunakan modifier untuk mengubah arti kata benda. Beberapa modifier adalah `i`,
yang berarti "inner" atau "inside", dan `a`, yang berarti "around".

- `ci(` ubah konten di dalam tanda kurung saat ini
- `ci[` ubah konten di dalam tanda kurung siku saat ini
- `da'` hapus string kutip tunggal, termasuk tanda kutip tunggal di sekitarnya

# Demo

Berikut adalah implementasi [fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz) yang rusak:

```python
def fizz_buzz(limit):
    for i in range(limit):
        if i % 3 == 0:
            print('fizz')
        if i % 5 == 0:
            print('fizz')
        if i % 3 and i % 5:
            print(i)

def main():
    fizz_buzz(10)
```

Kita akan memperbaiki masalah-masalah berikut:

- Main tidak pernah dipanggil
- Dimulai dari 0, bukan 1
- Mencetak "fizz" dan "buzz" pada baris terpisah untuk kelipatan 15
- Mencetak "fizz" untuk kelipatan 5
- Menggunakan argumen hard-coded 10 alih-alih menerima argumen command-line

{% comment %}
- main is never called
  - `G` end of file
  - `o` open new line below
  - type in "if __name__ ..." thing
- starts at 0 instead of 1
  - search for `/range`
  - `ww` to move forward 2 words
  - `i` to insert text, "1, "
  - `ea` to insert after limit, "+1"
- newline for "fizzbuzz"
  - `jj$i` to insert text at end of line
  - add ", end=''"
  - `jj.` to repeat for second print
  - `jjo` to open line below if
  - add "else: print()"
- fizz fizz
  - `ci'` to change fizz
- command-line argument
  - `ggO` to open above
  - "import sys"
  - `/10`
  - `ci(` to "int(sys.argv[1])"
{% endcomment %}

Lihat video kuliah untuk demonya. Bandingkan bagaimana perubahan di atas
dibuat menggunakan Vim dengan bagaimana Anda mungkin membuat editan yang sama menggunakan program lain.
Perhatikan betapa sedikitnya tekanan tombol yang diperlukan di Vim, memungkinkan Anda mengedit dengan
kecepatan berpikir Anda.

# Kustomisasi Vim

Vim dikustomisasi melalui file konfigurasi teks biasa di `~/.vimrc`
(berisi perintah Vimscript). Mungkin ada banyak pengaturan dasar yang
ingin Anda aktifkan.

Kami menyediakan konfigurasi dasar yang terdokumentasi dengan baik yang dapat Anda gunakan sebagai titik awal. Kami merekomendasikan untuk menggunakan ini karena memperbaiki beberapa perilaku default Vim yang aneh. **Unduh konfigurasi kami [di sini](/2020/files/vimrc) dan simpan ke
`~/.vimrc`.**

Vim sangat dapat dikustomisasi, dan ada baiknya menghabiskan waktu menjelajahi
opsi kustomisasi. Anda dapat melihat dotfiles orang-orang di GitHub untuk
inspirasi, misalnya, konfigurasi Vim instruktur kami
([Anish](https://github.com/anishathalye/dotfiles/blob/master/vimrc),
[Jon](https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.lua) (menggunakan [neovim](https://neovim.io/)),
[Jose](https://github.com/JJGO/dotfiles/blob/master/vim/.vimrc)). Ada
banyak postingan blog yang bagus tentang topik ini juga. Cobalah untuk tidak menyalin-tempel
konfigurasi lengkap orang lain, tetapi bacalah, pahami, dan ambil yang Anda butuhkan.

# Memperluas Vim

Ada banyak plugin untuk memperluas Vim. Bertentangan dengan saran usang yang
mungkin Anda temukan di internet, Anda _tidak_ perlu menggunakan plugin manager untuk
Vim (sejak Vim 8.0). Sebaliknya, Anda dapat menggunakan sistem manajemen paket bawaan. Cukup buat direktori `~/.vim/pack/vendor/start/`, dan letakkan
plugin di sana (misalnya melalui `git clone`).

Berikut beberapa plugin favorit kami:

- [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim): fuzzy file finder
- [ack.vim](https://github.com/mileszs/ack.vim): pencarian kode
- [nerdtree](https://github.com/scrooloose/nerdtree): file explorer
- [vim-easymotion](https://github.com/easymotion/vim-easymotion): magic motions

Kami mencoba menghindari memberikan daftar plugin yang terlalu panjang di sini. Anda
dapat memeriksa dotfiles instruktur
([Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/JJGO/dotfiles)) untuk melihat plugin lain apa yang kami gunakan.
Lihat [Vim Awesome](https://vimawesome.com/) untuk lebih banyak plugin Vim yang luar biasa.
Ada juga banyak postingan blog tentang topik ini: cukup cari "best Vim
plugins".

# Mode Vim di program lain

Banyak alat yang mendukung emulasi Vim. Kualitasnya bervariasi dari baik hingga sangat baik;
tergantung pada alatnya, mungkin tidak mendukung fitur Vim yang lebih canggih, tetapi sebagian besar
mencakup dasar-dasar dengan cukup baik.

## Shell

Jika Anda pengguna Bash, gunakan `set -o vi`. Jika Anda menggunakan Zsh, `bindkey -v`. Untuk Fish,
`fish_vi_key_bindings`. Selain itu, tidak peduli shell apa yang Anda gunakan, Anda dapat
`export EDITOR=vim`. Ini adalah variabel lingkungan yang digunakan untuk memutuskan editor
mana yang diluncurkan ketika suatu program ingin memulai editor. Misalnya, `git`
akan menggunakan editor ini untuk pesan commit.

## Readline

Banyak program menggunakan pustaka [GNU
Readline](https://tiswww.case.edu/php/chet/readline/rltop.html) untuk
antarmuka command-line mereka. Readline juga mendukung emulasi Vim (dasar),
yang dapat diaktifkan dengan menambahkan baris berikut ke file `~/.inputrc`:

```
set editing-mode vi
```

Dengan pengaturan ini, misalnya, Python REPL akan mendukung binding Vim.

## Lainnya

Ada bahkan ekstensi keybinding vim untuk
[browser](https://vim.fandom.com/wiki/Vim_key_bindings_for_web_browsers) web - beberapa
yang populer adalah
[Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en)
untuk Google Chrome dan [Tridactyl](https://github.com/tridactyl/tridactyl) untuk
Firefox. Anda bahkan bisa mendapatkan binding Vim di [Jupyter
notebooks](https://github.com/jupyterlab-contrib/jupyterlab-vim).
Berikut adalah [daftar panjang](https://reversed.top/2016-08-13/big-list-of-vim-like-software) perangkat lunak dengan keybinding mirip vim.

# Vim Lanjutan

Berikut beberapa contoh untuk menunjukkan kekuatan editor ini. Kami tidak dapat mengajarkan
semua hal seperti ini, tetapi Anda akan mempelajarinya seiring berjalannya waktu. Heuristik yang baik: setiap kali Anda menggunakan editor dan berpikir "pasti ada
cara yang lebih baik untuk melakukan ini", kemungkinan besar ada: cari tahu secara online.

## Cari dan ganti

Perintah `:s` (substitute) ([dokumentasi](https://vim.fandom.com/wiki/Search_and_replace)).

- `%s/foo/bar/g`
    - ganti foo dengan bar secara global di file
- `%s/\[.*\](\(.*\))/\1/g`
    - ganti tautan Markdown bernama dengan URL polos

## Beberapa window

- `:sp` / `:vsp` untuk membagi window
- Dapat memiliki beberapa tampilan dari buffer yang sama.

## Macro

- `q{character}` untuk mulai merekam macro di register `{character}`
- `q` untuk berhenti merekam
- `@{character}` memutar ulang macro
- Eksekusi macro berhenti saat terjadi error
- `{number}@{character}` mengeksekusi macro sebanyak {number} kali
- Macro dapat bersifat rekursif
    - pertama bersihkan macro dengan `q{character}q`
    - rekam macro, dengan `@{character}` untuk memanggil macro secara rekursif
    (akan menjadi no-op sampai perekaman selesai)
- Contoh: konversi xml ke json ([file](/2020/files/example-data.xml))
    - Array of objects with keys "name" / "email"
    - Use a Python program?
    - Use sed / regexes
        - `g/people/d`
        - `%s/<person>/{/g`
        - `%s/<name>\(.*\)<\/name>/"name": "\1",/g`
        - ...
    - Vim commands / macros
        - `Gdd`, `ggdd` delete first and last lines
        - Macro to format a single element (register `e`)
            - Go to line with `<name>`
            - `qe^r"f>s": "<ESC>f<C"<ESC>q`
        - Macro to format a person
            - Go to line with `<person>`
            - `qpS{<ESC>j@eA,<ESC>j@ejS},<ESC>q`
        - Macro to format a person and go to the next person
            - Go to line with `<person>`
            - `qq@pjq`
        - Execute macro until end of file
            - `999@q`
        - Manually remove last `,` and add `[` and `]` delimiters

# Sumber Daya

- `vimtutor` adalah tutorial yang disertakan bersama Vim - jika Vim terinstal, Anda seharusnya dapat menjalankan `vimtutor` dari shell Anda
- [Vim Adventures](https://vim-adventures.com/) adalah permainan untuk mempelajari Vim
- [Vim Tips Wiki](https://vim.fandom.com/wiki/Vim_Tips_Wiki)
- [Vim Advent Calendar](https://vimways.org/2019/) memiliki berbagai tips Vim
- [Vim Golf](https://www.vimgolf.com/) adalah [code golf](https://en.wikipedia.org/wiki/Code_golf), tetapi di mana bahasa pemrogramannya adalah UI Vim
- [Vi/Vim Stack Exchange](https://vi.stackexchange.com/)
- [Vim Screencasts](http://vimcasts.org/)
- [Practical Vim](https://pragprog.com/titles/dnvim2/) (buku)

# Latihan

1. Selesaikan `vimtutor`. Catatan: tampilannya paling baik di
   jendela terminal [80x24](https://en.wikipedia.org/wiki/VT100) (80 kolom kali 24 baris).
1. Unduh [vimrc dasar](/2020/files/vimrc) kami dan simpan ke `~/.vimrc`. Baca
   file yang terdokumentasi dengan baik (menggunakan Vim!), dan amati bagaimana Vim terlihat dan
   berperilaku sedikit berbeda dengan konfigurasi baru.
1. Instal dan konfigurasikan plugin:
   [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim).
    1. Buat direktori plugin dengan `mkdir -p ~/.vim/pack/vendor/start`
    1. Unduh plugin: `cd ~/.vim/pack/vendor/start; git clone
       https://github.com/ctrlpvim/ctrlp.vim`
    1. Baca
       [dokumentasi](https://github.com/ctrlpvim/ctrlp.vim/blob/master/readme.md)
       untuk plugin tersebut. Coba gunakan CtrlP untuk menemukan file dengan menavigasi ke
       direktori proyek, membuka Vim, dan menggunakan command-line Vim untuk memulai
       `:CtrlP`.
    1. Kustomisasi CtrlP dengan menambahkan
       [konfigurasi](https://github.com/ctrlpvim/ctrlp.vim/blob/master/readme.md#basic-options)
       ke `~/.vimrc` Anda untuk membuka CtrlP dengan menekan Ctrl-P.
1. Untuk berlatih menggunakan Vim, ulangi [Demo](#demo) dari kuliah di mesin Anda sendiri.
1. Gunakan Vim untuk _semua_ pengeditan teks Anda selama sebulan ke depan. Setiap kali sesuatu
   terasa tidak efisien, atau ketika Anda berpikir "pasti ada cara yang lebih baik", coba
   Googling, kemungkinan besar ada. Jika Anda terjebak, datang ke office hours atau
   kirimkan email kepada kami.
1. Konfigurasikan alat-alat lain Anda untuk menggunakan binding Vim (lihat instruksi di atas).
1. Kustomisasi lebih lanjut `~/.vimrc` Anda dan instal lebih banyak plugin.
1. (Lanjutan) Konversi XML ke JSON ([file contoh](/2020/files/example-data.xml))
   menggunakan macro Vim. Cobalah lakukan ini sendiri, tetapi Anda dapat melihat bagian
   [macro](#macros) di atas jika Anda terjebak.
