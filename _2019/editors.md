---
layout: lecture
title: "Editor"
presenter: Anish
date: 2019-01-22
order: 1
video:
  aspect: 62.5
  id: 1vLcusYSrI4
---

# Pentingnya Editor

Sebagai programmer, kita menghabiskan sebagian besar waktu untuk mengedit berkas teks biasa. Penting untuk meluangkan waktu mempelajari editor yang sesuai dengan kebutuhan Anda.

Bagaimana cara mempelajari editor baru? Anda memaksa diri untuk menggunakan editor tersebut selama beberapa waktu, meskipun produktivitas Anda menurun untuk sementara. Ini akan segera terbayar (dua minggu cukup untuk mempelajari dasar-dasarnya).

Kami akan mengajarkan Anda Vim, tetapi kami mendorong Anda untuk bereksperimen dengan editor lain. Ini adalah pilihan yang sangat pribadi, dan orang-orang memiliki [pendapat yang kuat](https://en.wikipedia.org/wiki/Editor_war).

Kami tidak bisa mengajarkan Anda cara menggunakan editor yang canggih dalam 50 menit, jadi kami akan fokus mengajarkan dasar-dasarnya, menunjukkan beberapa fungsi yang lebih lanjut, dan memberikan sumber daya untuk menguasai alat ini. Kami akan mengajarkan pelajaran dalam konteks Vim, tetapi sebagian besar konsep akan berlaku untuk editor canggih lainnya yang Anda gunakan (dan jika tidak, maka Anda mungkin seharusnya tidak menggunakan editor tersebut!).

![Kurva Pembelajaran Editor](/2019/files/editor-learning-curves.jpg)

<!-- source: https://blogs.msdn.microsoft.com/steverowe/2004/11/17/code-editor-learning-curves/ -->

Grafik kurva pembelajaran editor adalah mitos. Mempelajari dasar-dasar editor yang canggih cukup mudah (meskipun mungkin butuh bertahun-tahun untuk menguasainya).

Editor mana yang populer saat ini? Lihat [survei Stack Overflow ini](https://insights.stackoverflow.com/survey/2018/#development-environments-and-tools) (mungkin ada beberapa bias karena pengguna Stack Overflow mungkin tidak mewakili programmer secara keseluruhan).

## Editor Baris Perintah

Meskipun Anda akhirnya memutuskan untuk menggunakan editor GUI, ada baiknya mempelajari editor baris perintah untuk mengedit berkas di mesin remote dengan mudah.

# Nano

Nano adalah editor baris perintah yang sederhana.

- Pindah dengan tombol panah
- Semua pintasan lainnya (simpan, keluar) ditampilkan di bagian bawah

# Vim

Vi/Vim adalah editor teks yang canggih. Ini adalah program baris perintah yang biasanya terinstal di mana-mana, sehingga nyaman untuk mengedit berkas di mesin remote.

Vim juga memiliki versi grafis, seperti GVim dan [MacVim](https://macvim-dev.github.io/macvim/). Ini menyediakan fitur tambahan seperti warna 24-bit, menu, dan popup.

## Filosofi Vim

- Saat pemrograman, Anda menghabiskan sebagian besar waktu membaca/mengedit, bukan menulis
    - Vim adalah editor **modal**: mode berbeda untuk menyisipkan teks vs memanipulasi teks
- Vim dapat diprogram (dengan Vimscript dan juga bahasa lain seperti Python)
- Antarmuka Vim itu sendiri seperti bahasa pemrograman
    - Penekanan tombol (dengan nama mnemonik) adalah perintah
    - Perintah-perintah dapat dikomposisikan
- Jangan gunakan mouse: terlalu lambat
- Editor harus bekerja secepat Anda berpikir

## Vim Dasar

### Mode

Vim menampilkan mode saat ini di pojok kiri bawah.

- Mode Normal: untuk berpindah-pindah dalam berkas dan melakukan pengeditan
    - Habiskan sebagian besar waktu Anda di sini
- Mode Insert: untuk menyisipkan teks
- Mode Visual (visual, line, atau block): untuk memilih blok teks

Anda berpindah mode dengan menekan `<ESC>` untuk beralih dari mode mana pun kembali ke mode normal. Dari mode normal, masuk ke mode insert dengan `i`, mode visual dengan `v`, mode visual line dengan `V`, dan mode visual block dengan `<C-v>`.

Anda menggunakan tombol `<ESC>` sangat sering saat menggunakan Vim: pertimbangkan untuk memetakan ulang Caps Lock ke Escape.

### Dasar-dasar

Perintah ex Vim dijalankan melalui `:{command}` dalam mode normal.

- `:q` keluar (tutup jendela)
- `:w` simpan
- `:wq` simpan dan keluar
- `:e {name of file}` buka berkas untuk diedit
- `:ls` tampilkan buffer yang terbuka
- `:help {topic}` buka bantuan
    - `:help :w` membuka bantuan untuk perintah ex `:w`
    - `:help w` membuka bantuan untuk pergerakan `w`

### Pergerakan

Vim semuanya tentang pergerakan yang efisien. Navigasi berkas dalam mode Normal.

- Nonaktifkan tombol panah untuk menghindari kebiasaan buruk
```vim
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
```
- Pergerakan dasar: `hjkl` (kiri, bawah, atas, kanan)
- Kata: `w` (kata berikutnya), `b` (awal kata), `e` (akhir kata)
- Baris: `0` (awal baris), `^` (karakter bukan spasi pertama), `$` (akhir baris)
- Layar: `H` (atas layar), `M` (tengah layar), `L` (bawah layar)
- Berkas: `gg` (awal berkas), `G` (akhir berkas)
- Nomor baris: `:{number}<CR>` atau `{number}G` (baris ke-{number})
- Lainnya: `%` (item yang sesuai)
- Cari: `f{character}`, `t{character}`, `F{character}`, `T{character}`
    - cari/menuju maju/mundur {character} pada baris saat ini
- Mengulangi N kali: `{number}{movement}`, misalnya `10j` pindah ke bawah 10 baris
- Pencarian: `/{regex}`, `n` / `N` untuk berpindah antar kecocokan

### Seleksi

Mode Visual:

- Visual
- Visual Line
- Visual Block

Dapat menggunakan tombol pergerakan untuk membuat seleksi.

### Memanipulasi teks

Semua yang biasa Anda lakukan dengan mouse, sekarang Anda lakukan dengan keyboard (dan perintah yang canggih dan dapat dikomposisikan).

- `i` masuk mode insert
    - tetapi untuk memanipulasi/menghapus teks, Anda ingin menggunakan sesuatu selain backspace
- `o` / `O` sisipkan baris di bawah / di atas
- `d{motion}` hapus {motion}
    - misalnya `dw` adalah hapus kata, `d$` adalah hapus sampai akhir baris, `d0` adalah hapus sampai awal baris
- `c{motion}` ubah {motion}
    - misalnya `cw` adalah ubah kata
    - seperti `d{motion}` diikuti oleh `i`
- `x` hapus karakter (sama dengan `dl`)
- `s` substitusi karakter (sama dengan `xi`)
- mode visual + manipulasi
    - pilih teks, `d` untuk menghapusnya atau `c` untuk mengubahnya
- `u` untuk membatalkan, `<C-r>` untuk mengulangi
- Masih banyak yang harus dipelajari: misalnya `~` membalik huruf besar/kecil karakter

### Sumber Daya

- `vimtutor` program baris perintah untuk mengajari Anda vim
- [Vim Adventures](https://vim-adventures.com/) permainan untuk belajar Vim

## Menyesuaikan Vim

Vim disesuaikan melalui berkas konfigurasi teks biasa di `~/.vimrc` (berisi perintah Vimscript). Mungkin ada banyak pengaturan dasar yang ingin Anda aktifkan.

Lihat dotfiles orang-orang di GitHub untuk inspirasi, tetapi cobalah untuk tidak menyalin-tempel konfigurasi lengkap orang lain. Bacalah, pahami, dan ambil yang Anda butuhkan.

Beberapa penyesuaian yang bisa dipertimbangkan:

- Penyorotan sintaks: `syntax on`
- Skema warna
- Nomor baris: `set nu` / `set rnu`
- Backspace melalui semua: `set backspace=indent,eol,start`

## Vim Lanjutan

Berikut beberapa contoh untuk menunjukkan kekuatan editor ini. Kami tidak bisa mengajarkan semua hal ini, tetapi Anda akan mempelajarinya seiring berjalannya waktu. Heuristik yang baik: kapan pun Anda menggunakan editor dan berpikir "pasti ada cara yang lebih baik untuk melakukan ini", kemungkinan besar ada: cari di internet.

### Cari dan ganti

Perintah `:s` (substitute) ([dokumentasi](https://vim.fandom.com/wiki/Search_and_replace)).

- `%s/foo/bar/g`
    - ganti foo dengan bar secara global di berkas
- `%s/\[.*\](\(.*\))/\1/g`
    - ganti tautan Markdown bernama dengan URL biasa

### Beberapa jendela

- `sp` / `vsp` untuk membagi jendela
- Dapat memiliki beberapa tampilan dari buffer yang sama.

### Dukungan mouse

- `set mouse+=a`
    - bisa klik, gulir, pilih

### Makro

- `q{character}` untuk mulai merekam makro di register `{character}`
- `q` untuk berhenti merekam
- `@{character}` memutar ulang makro
- Eksekusi makro berhenti saat ada kesalahan
- `{number}@{character}` mengeksekusi makro {number} kali
- Makro bisa bersifat rekursif
    - pertama bersihkan makro dengan `q{character}q`
    - rekam makro, dengan `@{character}` untuk memanggil makro secara rekursif
    (akan menjadi no-op sampai perekaman selesai)
- Contoh: konversi xml ke json ([file](/2019/files/example-data.xml))
    - Array objek dengan kunci "name" / "email"
    - Gunakan program Python?
    - Gunakan sed / regex
        - `g/people/d`
        - `%s/<person>/{/g`
        - `%s/<name>\(.*\)<\/name>/"name": "\1",/g`
        - ...
    - Perintah / makro Vim
        - `Gdd`, `ggdd` hapus baris pertama dan terakhir
        - Makro untuk memformat satu elemen (register `e`)
            - Pindah ke baris dengan `<name>`
            - `qe^r"f>s": "<ESC>f<C"<ESC>q`
        - Makro untuk memformat satu orang
            - Pindah ke baris dengan `<person>`
            - `qpS{<ESC>j@eA,<ESC>j@ejS},<ESC>q`
        - Makro untuk memformat satu orang dan pindah ke orang berikutnya
            - Pindah ke baris dengan `<person>`
            - `qq@pjq`
        - Eksekusi makro sampai akhir berkas
            - `999@q`
        - Hapus `,` terakhir secara manual dan tambahkan pembatas `[` dan `]`

## Memperluas Vim

Ada banyak plugin untuk memperluas vim.

Pertama, siapkan plugin manager seperti [vim-plug](https://github.com/junegunn/vim-plug), [Vundle](https://github.com/VundleVim/Vundle.vim), atau [pathogen.vim](https://github.com/tpope/vim-pathogen).

Beberapa plugin yang bisa dipertimbangkan:

- [ctrlp.vim](https://github.com/kien/ctrlp.vim): pencarian berkas fuzzy
- [vim-fugitive](https://github.com/tpope/vim-fugitive): integrasi git
- [vim-surround](https://github.com/tpope/vim-surround): memanipulasi "lingkungan"
- [gundo.vim](https://github.com/sjl/gundo.vim): navigasi pohon undo
- [nerdtree](https://github.com/scrooloose/nerdtree): penjelajah berkas
- [syntastic](https://github.com/vim-syntastic/syntastic): pemeriksaan sintaks
- [vim-easymotion](https://github.com/easymotion/vim-easymotion): pergerakan ajaib
- [vim-over](https://github.com/osyo-manga/vim-over): pratinjau substitusi

Daftar plugin:

- [Vim Awesome](https://vimawesome.com/)

## Mode Vim di Program Lain

Untuk banyak editor populer (misalnya vim dan emacs), banyak alat lain mendukung emulasi editor.

- Shell
    - bash: `set -o vi`
    - zsh: `bindkey -v`
    - `export EDITOR=vim` (variabel lingkungan yang digunakan oleh program seperti `git`)
- `~/.inputrc`
    - `set editing-mode vi`

Terdapat juga ekstensi keybinding vim untuk [browser](https://vim.fandom.com/wiki/Vim_key_bindings_for_web_browsers) web, beberapa yang populer adalah [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en) untuk Google Chrome dan [Tridactyl](https://github.com/tridactyl/tridactyl) untuk Firefox.


## Sumber Daya

- [Vim Tips Wiki](https://vim.fandom.com/wiki/Vim_Tips_Wiki)
- [Vim Advent Calendar](https://vimways.org/2018/): berbagai tips Vim
- [Neovim](https://neovim.io/) adalah implementasi ulang vim modern dengan pengembangan yang lebih aktif.
- [Vim Golf](https://www.vimgolf.com/): Berbagai tantangan Vim

{% comment %}
# Resources

TODO resources for other editors?
{% endcomment %}

# Latihan

1. Bereksperimenlah dengan beberapa editor. Cobalah setidaknya satu editor baris perintah (misalnya Vim) dan setidaknya satu editor GUI (misalnya Atom). Belajarlah melalui tutorial seperti `vimtutor` (atau yang setara untuk editor lain). Untuk mendapatkan kesan nyata terhadap editor baru, berkomitmenlah untuk menggunakannya secara eksklusif selama beberapa hari saat mengerjakan pekerjaan Anda.

1. Sesuaikan editor Anda. Lihat tips dan trik di internet, dan lihat konfigurasi orang lain (seringkali, konfigurasinya terdokumentasi dengan baik).

1. Bereksperimenlah dengan plugin untuk editor Anda.

1. Berkomitmenlah untuk menggunakan editor yang canggih selama setidaknya beberapa minggu: Anda seharusnya mulai melihat manfaatnya pada saat itu. Pada titik tertentu, Anda seharusnya bisa membuat editor Anda bekerja secepat Anda berpikir.

1. Instal linter (misalnya pyflakes untuk python), hubungkan ke editor Anda, dan uji apakah berfungsi.
