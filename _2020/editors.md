---
layout: lecture
title: "Editor (Vim)"
description: >
  Pelajari cara menggunakan Vim, editor teks canggih yang dirancang untuk pengeditan kode yang efisien.
thumbnail: /static/assets/thumbnails/2020/lec3.png
date: 2020-01-15
ready: true
video:
  aspect: 56.25
  id: a6Q8Na575qc
---

Menulis kata-kata dalam bahasa Inggris dan menulis kode adalah aktivitas yang sangat berbeda. Saat
pemrograman, Anda menghabiskan lebih banyak waktu untuk berpindah file, membaca, navigasi, dan
mengedit kode dibandingkan dengan menulis aliran teks yang panjang. Masuk akal jika ada
jenis program yang berbeda untuk menulis kata-kata dalam bahasa Inggris versus kode (misalnya
Microsoft Word versus Visual Studio Code).

Sebagai programmer, kita menghabiskan sebagian besar waktu untuk mengedit kode, jadi layak untuk
menginvestasikan waktu dalam menguasai editor yang sesuai dengan kebutuhan Anda. Berikut cara Anda mempelajari editor baru:

- Mulai dengan tutorial (yaitu kuliah ini, plus sumber daya yang kami tunjukkan)
- Tetap gunakan editor untuk semua kebutuhan pengeditan teks Anda (meskipun pada awalnya memperlambat
Anda)
- Cari tahu seiring berjalannya waktu: jika sepertinya ada cara yang lebih baik untuk melakukan
sesuatu, kemungkinan besar ada

Jika Anda mengikuti metode di atas, dengan sepenuhnya berkomitmen menggunakan program baru untuk
semua tujuan pengeditan teks, linimasa untuk mempelajari editor teks yang canggih
terlihat seperti ini. Dalam satu atau dua jam, Anda akan mempelajari fungsi-fungsi dasar editor
seperti membuka dan mengedit file, menyimpan/keluar, dan menavigasi buffer. Setelah
20 jam, Anda seharusnya secepat saat menggunakan editor lama Anda.
Setelah itu, manfaatnya mulai terasa: Anda akan memiliki pengetahuan dan memori otot
yang cukup sehingga menggunakan editor baru menghemat waktu Anda. Editor teks modern adalah alat
yang canggih dan kuat, sehingga proses belajar tidak pernah berhenti: Anda akan menjadi lebih cepat seiring
Anda mempelajari lebih banyak.

# Editor mana yang harus dipelajari?

Para programmer memiliki [pendapat yang kuat](https://en.wikipedia.org/wiki/Editor_war)
tentang editor teks mereka.

Editor mana yang populer saat ini? Lihat [survei Stack Overflow
ini](https://insights.stackoverflow.com/survey/2019/#development-environments-and-tools)
(mungkin ada beberapa bias karena pengguna Stack Overflow mungkin tidak mewakili
seluruh programmer). [Visual Studio
Code](https://code.visualstudio.com/) adalah editor yang paling populer.
[Vim](https://www.vim.org/) adalah editor berbasis baris perintah yang paling populer.

## Vim

Semua instruktur kelas ini menggunakan Vim sebagai editor mereka. Vim memiliki sejarah yang kaya;
berasal dari editor Vi (1976), dan masih dikembangkan hingga saat ini. Vim memiliki beberapa
ide yang sangat menarik di baliknya, dan karena alasan ini, banyak alat yang mendukung
mode emulasi Vim (misalnya, 1,4 juta orang telah menginstal [emulasi Vim untuk VS code](https://github.com/VSCodeVim/Vim)). Vim mungkin layak dipelajari meskipun pada akhirnya Anda beralih ke editor teks lainnya.

Tidak mungkin mengajarkan semua fungsi Vim dalam 50 menit, jadi kami akan
fokus pada penjelasan filosofi Vim, mengajari Anda dasar-dasarnya,
menunjukkan beberapa fungsi yang lebih canggih, dan memberi Anda
sumber daya untuk menguasai alat ini.

# Filosofi Vim

Saat pemrograman, Anda menghabiskan sebagian besar waktu untuk membaca/mengedit, bukan menulis. Karena
alasan ini, Vim adalah editor _modal_: ia memiliki mode yang berbeda untuk menyisipkan teks
vs memanipulasi teks. Vim dapat diprogram (dengan Vimscript dan juga bahasa
lain seperti Python), dan antarmuka Vim itu sendiri adalah bahasa pemrograman:
tekanan tombol (dengan nama mnemonik) adalah perintah, dan perintah-perintah ini
dapat dikomposisikan. Vim menghindari penggunaan mouse, karena terlalu lambat; Vim bahkan
menghindari penggunaan tombol panah karena memerlukan terlalu banyak pergerakan.

Hasil akhirnya adalah editor yang dapat menyamai kecepatan berpikir Anda.

# Pengeditan modal

Desain Vim didasarkan pada ide bahwa banyak waktu programmer dihabiskan
untuk membaca, menavigasi, dan membuat editan kecil, dibandingkan dengan menulis aliran teks yang panjang. Karena alasan ini, Vim memiliki beberapa mode operasi.

- **Normal**: untuk berpindah-pindah dalam file dan membuat editan
- **Insert**: untuk menyisipkan teks
- **Replace**: untuk mengganti teks
- **Visual** (biasa, baris, atau blok): untuk memilih blok teks
- **Command-line**: untuk menjalankan perintah

Tekanan tombol memiliki arti yang berbeda dalam mode operasi yang berbeda. Misalnya,
huruf `x` dalam mode Insert hanya akan menyisipkan karakter literal 'x', tetapi dalam
mode Normal, ia akan menghapus karakter di bawah kursor, dan dalam mode Visual,
ia akan menghapus seleksi.

Dalam konfigurasi default, Vim menampilkan mode saat ini di kiri bawah.
Mode awal/default adalah mode Normal. Anda umumnya akan menghabiskan sebagian besar waktu
antara mode Normal dan mode Insert.

Anda berpindah mode dengan menekan `<ESC>` (tombol escape) untuk beralih dari mode apa pun
kembali ke mode Normal. Dari mode Normal, masuk ke mode Insert dengan `i`, mode Replace
dengan `R`, mode Visual dengan `v`, mode Visual Line dengan `V`, mode Visual Block
dengan `<C-v>` (Ctrl-V, kadang juga ditulis `^V`), dan mode Command-line dengan
`:`.

Anda banyak menggunakan tombol `<ESC>` saat menggunakan Vim: pertimbangkan untuk memetakan ulang Caps Lock ke
Escape ([instruksi macOS](https://vim.fandom.com/wiki/Map_caps_lock_to_escape_in_macOS))
atau buat [pemetaan alternatif](https://vim.fandom.com/wiki/Avoid_the_escape_key#Mappings) untuk `<ESC>`
dengan urutan tombol sederhana.

# Dasar-dasar

## Menyisipkan teks

Dari mode Normal, tekan `i` untuk masuk ke mode Insert. Sekarang, Vim berperilaku seperti
editor teks lainnya, sampai Anda menekan `<ESC>` untuk kembali ke mode Normal. Ini,
bersama dengan dasar-dasar yang dijelaskan di atas, adalah semua yang Anda butuhkan untuk mulai mengedit file
menggunakan Vim (meskipun tidak terlalu efisien, jika Anda menghabiskan semua waktu
Anda mengedit dari mode Insert).

## Buffer, tab, dan jendela

Vim maintains a set of open files, called "buffers". A Vim session has a number
of tabs, each of which has a number of windows (split panes). Each window shows
a single buffer. Unlike other programs you are familiar with, like web
browsers, there is not a 1-to-1 correspondence between buffers and windows;
windows are merely views. A given buffer may be open in _multiple_ windows,
even within the same tab. This can be quite handy, for example, to view two
different parts of a file at the same time.

Secara default, Vim terbuka dengan satu tab, yang berisi satu jendela.

## Baris perintah

Mode perintah dapat dimasuki dengan mengetik `:` dalam mode Normal. Kursor Anda akan loncat
ke baris perintah di bagian bawah layar setelah menekan `:`. Mode ini
memiliki banyak fungsionalitas, termasuk membuka, menyimpan, dan menutup file, serta
[keluar dari Vim](https://twitter.com/iamdevloper/status/435555976687923200).

- `:q` quit (close window)
- `:w` save ("write")
- `:wq` save and quit
- `:e {name of file}` open file for editing
- `:ls` show open buffers
- `:help {topic}` open help
    - `:help :w` opens help for the `:w` command
    - `:help w` opens help for the `w` movement

# Antarmuka Vim adalah bahasa pemrograman

Ide paling penting dalam Vim adalah antarmuka Vim itu sendiri adalah bahasa
pemrograman. Tekanan tombol (dengan nama mnemonik) adalah perintah, dan perintah-perintah ini
_dapat dikomposisikan_. Ini memungkinkan pergerakan dan editan yang efisien, terutama setelah
perintah-perintah menjadi memori otot.

## Pergerakan

Anda seharusnya menghabiskan sebagian besar waktu dalam mode Normal, menggunakan perintah pergerakan untuk
menavigasi buffer. Pergerakan dalam Vim juga disebut "kata benda", karena merujuk
pada potongan teks.

- Basic movement: `hjkl` (left, down, up, right)
- Words: `w` (next word), `b` (beginning of word), `e` (end of word)
- Lines: `0` (beginning of line), `^` (first non-blank character), `$` (end of line)
- Screen: `H` (top of screen), `M` (middle of screen), `L` (bottom of screen)
- Scroll: `Ctrl-u` (up), `Ctrl-d` (down)
- File: `gg` (beginning of file), `G` (end of file)
- Line numbers: `:{number}<CR>` or `{number}G` (line {number})
- Misc: `%` (corresponding item)
- Find: `f{character}`, `t{character}`, `F{character}`, `T{character}`
    - find/to forward/backward {character} on the current line
    - `,` / `;` for navigating matches
- Search: `/{regex}`, `n` / `N` for navigating matches

## Seleksi

Mode Visual:

- Visual: `v`
- Visual Line: `V`
- Visual Block: `Ctrl-v`

Dapat menggunakan tombol pergerakan untuk membuat seleksi.

## Editan

Semua yang biasa Anda lakukan dengan mouse, sekarang Anda lakukan dengan keyboard
menggunakan perintah editan yang dapat dikomposisikan dengan perintah pergerakan. Di sinilah
antarmuka Vim mulai terlihat seperti bahasa pemrograman. Perintah editan Vim
juga disebut "kata kerja", karena kata kerja bekerja pada kata benda.

- `i` enter Insert mode
    - but for manipulating/deleting text, want to use something more than
    backspace
- `o` / `O` insert line below / above
- `d{motion}` delete {motion}
    - e.g. `dw` is delete word, `d$` is delete to end of line, `d0` is delete
    to beginning of line
- `c{motion}` change {motion}
    - e.g. `cw` is change word
    - like `d{motion}` followed by `i`
- `x` delete character (equal to `dl`)
- `s` substitute character (equal to `cl`)
- Visual mode + manipulation
    - select text, `d` to delete it or `c` to change it
- `u` to undo, `<C-r>` to redo
- `y` to copy / "yank" (some other commands like `d` also copy)
- `p` to paste
- Lots more to learn: e.g. `~` flips the case of a character

## Jumlah

Anda dapat menggabungkan kata benda dan kata kerja dengan jumlah, yang akan melakukan tindakan tertentu
sebanyak beberapa kali.

- `3w` move 3 words forward
- `5j` move 5 lines down
- `7dw` delete 7 words

## Pengubah

Anda dapat menggunakan pengubah untuk mengubah arti dari kata benda. Beberapa pengubah adalah `i`,
yang berarti "dalam" atau "di dalam", dan `a`, yang berarti "sekitar".

- `ci(` change the contents inside the current pair of parentheses
- `ci[` change the contents inside the current pair of square brackets
- `da'` delete a single-quoted string, including the surrounding single quotes

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

Kami akan memperbaiki masalah-masalah berikut:

- Main tidak pernah dipanggil
- Dimulai dari 0 alih-alih 1
- Mencetak "fizz" dan "buzz" pada baris terpisah untuk kelipatan 15
- Mencetak "fizz" untuk kelipatan 5
- Menggunakan argumen hard-coded 10 alih-alih menerima argumen baris perintah

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
Perhatikan betapa sedikitnya tekanan tombol yang diperlukan dalam Vim, memungkinkan Anda mengedit dengan
kecepatan berpikir Anda.

# Menyesuaikan Vim

Vim disesuaikan melalui file konfigurasi teks biasa di `~/.vimrc`
(berisi perintah Vimscript). Mungkin ada banyak pengaturan dasar yang
ingin Anda aktifkan.

Kami menyediakan konfigurasi dasar yang terdokumentasi dengan baik yang dapat Anda gunakan sebagai titik awal. Kami merekomendasikan untuk menggunakan ini karena memperbaiki beberapa perilaku default Vim yang aneh. **Unduh konfigurasi kami [di sini](/2020/files/vimrc) dan simpan ke
`~/.vimrc`.**

Vim sangat dapat disesuaikan, dan layak menghabiskan waktu untuk menjelajahi
opsi penyesuaian. Anda dapat melihat dotfiles orang-orang di GitHub untuk
inspirasi, misalnya, konfigurasi Vim instruktur kami
([Anish](https://github.com/anishathalye/dotfiles/blob/master/vimrc),
[Jon](https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.lua) (uses [neovim](https://neovim.io/)),
[Jose](https://github.com/JJGO/dotfiles/blob/master/vim/.vimrc)). Ada
banyak postingan blog yang bagus tentang topik ini juga. Cobalah untuk tidak menyalin-dan-tempel
konfigurasi lengkap orang lain, tetapi bacalah, pahami, dan ambil yang Anda butuhkan.

# Memperluas Vim

Ada banyak plugin untuk memperluas Vim. Bertentangan dengan saran usang yang
mungkin Anda temukan di internet, Anda _tidak_ perlu menggunakan pengelola plugin untuk
Vim (sejak Vim 8.0). Sebaliknya, Anda dapat menggunakan sistem manajemen paket bawaan. Cukup buat direktori `~/.vim/pack/vendor/start/`, dan letakkan
plugin di sana (misalnya melalui `git clone`).

Berikut adalah beberapa plugin favorit kami:

- [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim): fuzzy file finder
- [ack.vim](https://github.com/mileszs/ack.vim): code search
- [nerdtree](https://github.com/scrooloose/nerdtree): file explorer
- [vim-easymotion](https://github.com/easymotion/vim-easymotion): magic motions

Kami berusaha menghindari memberikan daftar plugin yang sangat panjang di sini. Anda
dapat melihat dotfiles instruktur
([Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/JJGO/dotfiles)) untuk melihat plugin lain apa yang kami gunakan.
Lihat [Vim Awesome](https://vimawesome.com/) untuk lebih banyak plugin Vim yang luar biasa.
Ada juga banyak postingan blog tentang topik ini: cukup cari "best Vim
plugins".

# Mode Vim di program lain

Banyak alat yang mendukung emulasi Vim. Kualitasnya bervariasi dari baik hingga hebat;
tergantung pada alatnya, mungkin tidak mendukung fitur Vim yang lebih mewah, tetapi sebagian besar
mencakup dasar-dasar dengan cukup baik.

## Shell

Jika Anda pengguna Bash, gunakan `set -o vi`. Jika Anda menggunakan Zsh, `bindkey -v`. Untuk Fish,
`fish_vi_key_bindings`. Selain itu, tidak peduli shell apa yang Anda gunakan, Anda dapat
`export EDITOR=vim`. Ini adalah variabel environment yang digunakan untuk memutuskan editor mana yang diluncurkan ketika sebuah program ingin memulai editor. Misalnya, `git`
akan menggunakan editor ini untuk pesan commit.

## Readline

Banyak program menggunakan pustaka [GNU
Readline](https://tiswww.case.edu/php/chet/readline/rltop.html) untuk
antarmuka baris perintah mereka. Readline juga mendukung emulasi Vim (dasar),
yang dapat diaktifkan dengan menambahkan baris berikut ke file `~/.inputrc`:

```
set editing-mode vi
```

Dengan pengaturan ini, misalnya, Python REPL akan mendukung binding Vim.

## Lainnya

Ada bahkan ekstensi keybinding vim untuk web
[browser](https://vim.fandom.com/wiki/Vim_key_bindings_for_web_browsers) - beberapa
yang populer adalah
[Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en)
untuk Google Chrome dan [Tridactyl](https://github.com/tridactyl/tridactyl) untuk
Firefox. Anda bahkan bisa mendapatkan binding Vim di [Jupyter
notebooks](https://github.com/jupyterlab-contrib/jupyterlab-vim).
Berikut adalah [daftar panjang](https://reversed.top/2016-08-13/big-list-of-vim-like-software) perangkat lunak dengan keybinding mirip vim.

# Vim Lanjutan

Berikut adalah beberapa contoh untuk menunjukkan kepada Anda kekuatan editor ini. Kami tidak dapat mengajari Anda
semua hal seperti ini, tetapi Anda akan mempelajarinya seiring berjalannya waktu. Sebuah heuristik yang baik: kapan pun Anda menggunakan editor dan Anda berpikir "pasti ada cara yang lebih baik untuk melakukan ini", kemungkinan besar ada: cari tahu secara online.

## Search and replace

Perintah `:s` (substitute) ([dokumentasi](https://vim.fandom.com/wiki/Search_and_replace)).

- `%s/foo/bar/g`
    - replace foo with bar globally in file
- `%s/\[.*\](\(.*\))/\1/g`
    - replace named Markdown links with plain URLs

## Multiple windows

- `:sp` / `:vsp` to split windows
- Can have multiple views of the same buffer.

## Macros

- `q{character}` to start recording a macro in register `{character}`
- `q` to stop recording
- `@{character}` replays the macro
- Macro execution stops on error
- `{number}@{character}` executes a macro {number} times
- Macros can be recursive
    - first clear the macro with `q{character}q`
    - record the macro, with `@{character}` to invoke the macro recursively
    (will be a no-op until recording is complete)
- Example: convert xml to json ([file](/2020/files/example-data.xml))
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
- [Vim Adventures](https://vim-adventures.com/) adalah game untuk belajar Vim
- [Vim Tips Wiki](https://vim.fandom.com/wiki/Vim_Tips_Wiki)
- [Vim Advent Calendar](https://vimways.org/2019/) memiliki berbagai tips Vim
- [Vim Golf](https://www.vimgolf.com/) adalah [code golf](https://en.wikipedia.org/wiki/Code_golf), tetapi di mana bahasa pemrogramannya adalah UI Vim
- [Vi/Vim Stack Exchange](https://vi.stackexchange.com/)
- [Vim Screencasts](http://vimcasts.org/)
- [Practical Vim](https://pragprog.com/titles/dnvim2/) (book)

# Latihan

1. Selesaikan `vimtutor`. Catatan: terlihat paling baik di jendela
   terminal [80x24](https://en.wikipedia.org/wiki/VT100) (80 kolom x 24 baris).
1. Unduh [vimrc dasar](/2020/files/vimrc) kami dan simpan ke `~/.vimrc`. Baca
   melalui file yang memiliki komentar lengkap (menggunakan Vim!), dan amati bagaimana Vim terlihat dan
   berperilaku sedikit berbeda dengan konfigurasi baru.
1. Instal dan konfigurasikan sebuah plugin:
   [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim).
    1. Buat direktori plugin dengan `mkdir -p ~/.vim/pack/vendor/start`
    1. Unduh plugin: `cd ~/.vim/pack/vendor/start; git clone
       https://github.com/ctrlpvim/ctrlp.vim`
    1. Baca [dokumentasi](https://github.com/ctrlpvim/ctrlp.vim/blob/master/readme.md)
       untuk plugin tersebut. Coba gunakan CtrlP untuk menemukan file dengan menavigasi ke
       direktori proyek, membuka Vim, dan menggunakan baris perintah Vim untuk memulai
       `:CtrlP`.
    1. Sesuaikan CtrlP dengan menambahkan
       [konfigurasi](https://github.com/ctrlpvim/ctrlp.vim/blob/master/readme.md#basic-options)
       ke `~/.vimrc` Anda untuk membuka CtrlP dengan menekan Ctrl-P.
1. Untuk berlatih menggunakan Vim, ulangi [Demo](#demo) dari kuliah di mesin Anda sendiri.
1. Gunakan Vim untuk _semua_ pengeditan teks Anda selama bulan berikutnya. Kapan pun sesuatu
   terasa tidak efisien, atau ketika Anda berpikir "pasti ada cara yang lebih baik", coba
   Googling, kemungkinan besar ada. Jika Anda terjebak, datang ke jam kantor atau
   kirimkan email kepada kami.
1. Konfigurasikan alat-alat lain Anda untuk menggunakan binding Vim (lihat instruksi di atas).
1. Lebih lanjut sesuaikan `~/.vimrc` Anda dan instal lebih banyak plugin.
1. (Lanjutan) Konversi XML ke JSON ([file contoh](/2020/files/example-data.xml))
   menggunakan macro Vim. Cobalah lakukan ini sendiri, tetapi Anda dapat melihat bagian
   [macros](#macros) di atas jika Anda terjebak.
