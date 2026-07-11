---
layout: lecture
title: "Environment dan Tools Pengembangan"
description: >
  Pelajari tentang IDE, Vim, language server, dan tools pengembangan berbasis AI.
thumbnail: /static/assets/thumbnails/2026/lec3.png
date: 2026-01-14
ready: true
video:
  aspect: 56.25
  id: QnM1nVzrkx8
---

_Environment pengembangan_ (_development environment_) adalah sekumpulan tools untuk mengembangkan perangkat lunak. Di inti dari environment pengembangan terdapat fungsionalitas editing teks, beserta fitur-fitur pendukung seperti syntax highlighting, type checking, code formatting, dan autocomplete. _Integrated development environment_ (IDE) seperti [VS Code][vs-code] menggabungkan semua fungsionalitas ini ke dalam satu aplikasi. Workflow pengembangan berbasis terminal menggabungkan tools-tools seperti [tmux](https://github.com/tmux/tmux) (terminal multiplexer), [Vim](https://www.vim.org/) (text editor), [Zsh](https://www.zsh.org/) (shell), dan tools command-line spesifik bahasa pemrograman, seperti [Ruff](https://docs.astral.sh/ruff/) (linter dan code formatter Python) dan [Mypy](https://mypy-lang.org/) (type checker Python).

IDE dan workflow berbasis terminal masing-masing memiliki kelebihan dan kekurangan. Sebagai contoh, IDE grafis mungkin lebih mudah dipelajari, dan IDE saat ini umumnya memiliki integrasi AI bawaan yang lebih baik seperti AI autocomplete; di sisi lain, workflow berbasis terminal bersifat ringan, dan mungkin menjadi satu-satunya pilihan Anda di environment di mana Anda tidak memiliki GUI atau tidak bisa menginstal perangkat lunak. Kami merekomendasikan Anda untuk mengembangkan keterampilan dasar di keduanya dan menguasai setidaknya salah satunya. Jika Anda belum memiliki IDE pilihan, kami merekomendasikan untuk memulai dengan [VS Code][vs-code].

Dalam kuliah ini, kita akan membahas:

- [Editing teks dan Vim](#text-editing-and-vim)
- [Code intelligence dan language server](#code-intelligence-and-language-servers)
- [Pengembangan berbasis AI](#ai-powered-development)
- [Ekstensi dan fungsionalitas IDE lainnya](#extensions-and-other-ide-functionality)

[vs-code]: https://code.visualstudio.com/

# Text editing and Vim

Saat pemrograman, Anda menghabiskan sebagian besar waktu untuk menavigasi kode, membaca potongan kode, dan melakukan edit pada kode, daripada menulis aliran kode yang panjang atau membaca file dari awal sampai akhir. [Vim] adalah text editor yang dioptimalkan untuk distribusi tugas ini.

**Filosofi Vim.** Vim memiliki gagasan indah sebagai fondasinya: antarmukanya itu sendiri adalah sebuah bahasa pemrograman, yang dirancang untuk menavigasi dan mengedit teks. Penekanan tombol (dengan nama mnemonik) adalah perintah-perintah, dan perintah-perintah ini dapat dikomposisikan. Vim menghindari penggunaan mouse, karena terlalu lambat; Vim bahkan menghindari penggunaan tombol panah karena membutuhkan terlalu banyak pergerakan. Hasilnya: sebuah editor yang terasa seperti antarmuka otak-komputer dan mengikuti kecepatan berpikir Anda.

**Dukungan Vim di perangkat lunak lain.** Anda tidak harus menggunakan [Vim] itu sendiri untuk mendapatkan manfaat dari gagasan-gagasan intinya. Banyak program yang melibatkan editing teks mendukung "mode Vim", baik sebagai fungsionalitas bawaan maupun sebagai plugin. Sebagai contoh, VS Code memiliki plugin [VSCodeVim](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim), Zsh memiliki [dukungan bawaan](https://zsh.sourceforge.io/Guide/zshguide04.html) untuk emulasi Vim, dan bahkan Claude Code memiliki [dukungan bawaan](https://code.claude.com/docs/en/interactive-mode#vim-editor-mode) untuk mode editor Vim. Kemungkinan besar, tool apa pun yang Anda gunakan yang melibatkan editing teks mendukung mode Vim dengan satu cara atau lainnya.

## Modal editing

Vim adalah _editor modal_: ia memiliki mode operasi yang berbeda untuk kelas tugas yang berbeda.

- **Normal**: untuk berpindah-pindah dalam file dan melakukan edit
- **Insert**: untuk menyisipkan teks
- **Replace**: untuk mengganti teks
- **Visual** (plain, line, atau block): untuk memblok teks
- **Command-line**: untuk menjalankan perintah

Penekanan tombol memiliki arti yang berbeda di mode operasi yang berbeda. Sebagai contoh, huruf `x` di mode Insert hanya akan menyisipkan karakter literal "x", tetapi di mode Normal, ia akan menghapus karakter di bawah kursor, dan di mode Visual, ia akan menghapus seleksi.

Pada konfigurasi default, Vim menampilkan mode saat ini di pojok kiri bawah. Mode awal/default adalah mode Normal. Anda umumnya akan menghabiskan sebagian besar waktu antara mode Normal dan mode Insert.

Anda berpindah mode dengan menekan `<ESC>` (tombol escape) untuk beralih dari mode apa pun kembali ke mode Normal. Dari mode Normal, masuk ke mode Insert dengan `i`, mode Replace dengan `R`, mode Visual dengan `v`, mode Visual Line dengan `V`, mode Visual Block dengan `<C-v>` (Ctrl-V, terkadang juga ditulis `^V`), dan mode Command-line dengan `:`.

Anda banyak menggunakan tombol `<ESC>` saat menggunakan Vim: pertimbangkan untuk memetakan ulang Caps Lock ke Escape ([instruksi macOS](https://vim.fandom.com/wiki/Map_caps_lock_to_escape_in_macOS)) atau buat [pemetaan alternatif](https://vim.fandom.com/wiki/Avoid_the_escape_key#Mappings) untuk `<ESC>` dengan urutan tombol sederhana.

## Basics: inserting text

Dari mode Normal, tekan `i` untuk masuk ke mode Insert. Sekarang, Vim berperilaku seperti text editor lainnya, sampai Anda menekan `<ESC>` untuk kembali ke mode Normal. Ini, beserta dasar-dasar yang dijelaskan di atas, adalah semua yang Anda butuhkan untuk mulai mengedit file menggunakan Vim (meskipun tidak terlalu efisien, jika Anda menghabiskan seluruh waktu mengedit dari mode Insert).

## Antarmuka Vim adalah bahasa pemrograman

Antarmuka Vim adalah bahasa pemrograman. Penekanan tombol (dengan nama mnemonik) adalah perintah-perintah, dan perintah-perintah ini dapat _dikomposisikan_. Ini memungkinkan pergerakan dan edit yang efisien, terutama setelah perintah-perintah tersebut menjadi memori otot, sama seperti mengetik menjadi sangat efisien setelah Anda menguasai layout keyboard Anda.

### Movement

Anda seharusnya menghabiskan sebagian besar waktu di mode Normal, menggunakan perintah pergerakan untuk menavigasi file. Pergerakan di Vim juga disebut "kata benda" (_nouns_), karena merujuk pada potongan teks.

- Pergerakan dasar: `hjkl` (kiri, bawah, atas, kanan)
- Kata: `w` (kata berikutnya), `b` (awal kata), `e` (akhir kata)
- Baris: `0` (awal baris), `^` (karakter non-kosong pertama), `$` (akhir baris)
- Layar: `H` (atas layar), `M` (tengah layar), `L` (bawah layar)
- Scroll: `Ctrl-u` (atas), `Ctrl-d` (bawah)
- File: `gg` (awal file), `G` (akhir file)
- Nomor baris: `:{number}<CR>` atau `{number}G` (baris ke-{number})
    - `<CR>` merujuk pada carriage return / tombol enter
- Lainnya: `%` (item yang cocok, seperti tanda kurung atau kurung kurawal)
- Cari: `f{character}`, `t{character}`, `F{character}`, `T{character}`
    - cari/menuju maju/mundur {character} pada baris saat ini
    - `,` / `;` untuk menavigasi hasil pencarian
- Pencarian: `/{regex}`, `n` / `N` untuk menavigasi hasil pencarian

### Selection

Mode Visual:

- Visual: `v`
- Visual Line: `V`
- Visual Block: `Ctrl-v`

Dapat menggunakan tombol pergerakan untuk membuat seleksi.

### Edits

Semua yang biasa Anda lakukan dengan mouse, sekarang Anda lakukan dengan keyboard menggunakan perintah editing yang dikomposisikan dengan perintah pergerakan. Di sinilah antarmuka Vim mulai terlihat seperti bahasa pemrograman. Perintah editing Vim juga disebut "kata kerja" (_verbs_), karena kata kerja bekerja pada kata benda.

- `i` masuk mode Insert
    - tetapi untuk memanipulasi/menghapus teks, Anda ingin menggunakan sesuatu yang lebih dari sekadar backspace
- `o` / `O` sisipkan baris di bawah / di atas
- `d{motion}` hapus {motion}
    - contoh: `dw` adalah hapus kata, `d$` adalah hapus sampai akhir baris, `d0` adalah hapus sampai awal baris
- `c{motion}` ubah {motion}
    - contoh: `cw` adalah ubah kata
    - seperti `d{motion}` diikuti oleh `i`
- `x` hapus karakter (setara dengan `dl`)
- `s` substitusi karakter (setara dengan `cl`)
- Mode Visual + manipulasi
    - seleksi teks, `d` untuk menghapusnya atau `c` untuk mengubahnya
- `u` untuk undo, `<C-r>` untuk redo
- `y` untuk copy / "yank" (beberapa perintah lain seperti `d` juga menyalin)
- `p` untuk paste
- Masih banyak yang bisa dipelajari: sebagai contoh, `~` membalikkan huruf besar/kecil sebuah karakter, dan `J` menggabungkan baris-baris

### Counts

Anda dapat menggabungkan kata benda dan kata kerja dengan jumlah (_count_), yang akan melakukan tindakan tertentu sebanyak beberapa kali.

- `3w` pindah 3 kata ke depan
- `5j` pindah 5 baris ke bawah
- `7dw` hapus 7 kata

### Modifiers

Anda dapat menggunakan modifier untuk mengubah arti dari kata benda. Beberapa modifier adalah `i`, yang berarti "inner" atau "inside", dan `a`, yang berarti "around".

- `ci(` ubah konten di dalam tanda kurung saat ini
- `ci[` ubah konten di dalam tanda kurung siku saat ini
- `da'` hapus string bertanda kutip tunggal, termasuk tanda kutip tunggal di sekitarnya

## Putting it all together

Berikut adalah implementasi [fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz) yang salah:

```python
def fizz_buzz(limit):
    for i in range(limit):
        if i % 3 == 0:
            print("fizz", end="")
        if i % 5 == 0:
            print("fizz", end="")
        if i % 3 and i % 5:
            print(i, end="")
        print()

def main():
    fizz_buzz(20)
```

Kita menggunakan urutan perintah berikut untuk memperbaiki masalah-masalah tersebut, dimulai dari mode Normal:

- Main tidak pernah dipanggil
    - `G` untuk melompat ke akhir file
    - `o` untuk memb**o**ka baris baru di bawah
    - Ketik `if __name__ == "__main__": main()`
        - Jika editor Anda memiliki dukungan bahasa Python, mungkin akan melakukan auto-indentation untuk Anda di mode Insert
    - `<ESC>` untuk kembali ke mode Normal
- Dimulai dari 0, bukan 1
    - `/` diikuti oleh `range` dan `<CR>` untuk mencari "range"
    - `ww` untuk maju dua **w**ord (Anda juga bisa menggunakan `2w`, tetapi dalam praktiknya, untuk jumlah kecil, umum untuk mengulang tombol daripada menggunakan fungsionalitas count)
    - `i` untuk beralih ke mode **i**nsert, dan tambahkan `1,`
    - `<ESC>` untuk kembali ke mode Normal
    - `e` untuk melompat ke **e**nd (akhir) kata berikutnya
    - `a` untuk mulai **a**ppending teks, dan tambahkan `+ 1`
    - `<ESC>` untuk kembali ke mode Normal
- Mencetak "fizz" untuk kelipatan 5
    - `:6<CR>` untuk pergi ke baris 6
    - `ci"` untuk **c**hange **i**nside '**"**', ubah menjadi `"buzz"`
    - `<ESC>` untuk kembali ke mode Normal

## Learning Vim

Cara terbaik untuk belajar Vim adalah mempelajari dasar-dasarnya (yang telah kita bahas sejauh ini) dan kemudian mengaktifkan mode Vim di semua perangkat lunak Anda dan mulai menggunakannya dalam praktik. Hindari godaan untuk menggunakan mouse atau tombol panah; di beberapa editor, Anda dapat melepas pemetaan tombol panah untuk memaksa diri Anda membangun kebiasaan yang baik.

### Additional resources

- [Kuliah Vim](/2020/editors/) dari iterasi sebelumnya kelas ini --- kita telah membahas Vim lebih mendalam di sana
- `vimtutor` adalah tutorial yang terinstal bersama Vim --- jika Vim terinstal, Anda seharusnya bisa menjalankan `vimtutor` dari shell Anda
- [Vim Adventures](https://vim-adventures.com/) adalah permainan untuk belajar Vim
- [Vim Tips Wiki](https://vim.fandom.com/wiki/Vim_Tips_Wiki)
- [Vim Advent Calendar](https://vimways.org/2019/) memiliki berbagai tips Vim
- [VimGolf](https://www.vimgolf.com/) adalah [code golf](https://en.wikipedia.org/wiki/Code_golf), tetapi di mana bahasa pemrogramannya adalah UI Vim
- [Vi/Vim Stack Exchange](https://vi.stackexchange.com/)
- [Vim Screencasts](http://vimcasts.org/)
- [Practical Vim](https://pragprog.com/titles/dnvim2/) (buku)

[Vim]: https://www.vim.org/

# Code intelligence dan language server

IDE umumnya menawarkan dukungan spesifik bahasa yang membutuhkan pemahaman semantik dari kode melalui ekstensi IDE yang terhubung ke _language server_ yang mengimplementasikan [Language Server Protocol](https://microsoft.github.io/language-server-protocol/). Sebagai contoh, [ekstensi Python untuk VS Code](https://marketplace.visualstudio.com/items?itemName=ms-python.python) bergantung pada [Pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance), dan [ekstensi Go untuk VS Code](https://marketplace.visualstudio.com/items?itemName=golang.go) bergantung pada [gopls](https://go.dev/gopls/) dari pihak pertama. Dengan menginstal ekstensi dan language server untuk bahasa yang Anda gunakan, Anda dapat mengaktifkan banyak fitur spesifik bahasa di IDE Anda, seperti:

- **Code completion.** Autocomplete dan autosuggest yang lebih baik, seperti kemampuan untuk melihat field dan method sebuah objek setelah mengetik `object.`.
- **Inline documentation.** Melihat dokumentasi saat hover dan autosuggest.
- **Jump-to-definition.** Melompat dari tempat penggunaan ke definisi, seperti bisa pergi dari referensi field `object.field` ke definisi field tersebut.
- **Find references.** Kebalikan dari di atas, menemukan semua tempat di mana item tertentu seperti field atau tipe direferensikan.
- **Bantuan dengan import.** Mengorganisir import, menghapus import yang tidak terpakai, menandai import yang hilang.
- **Code quality.** Tool-tool ini dapat digunakan secara mandiri, tetapi fungsionalitas ini sering juga disediakan oleh language server. Code formatting melakukan auto-indent dan auto-format kode, dan type checker serta linter menemukan kesalahan dalam kode Anda, saat Anda mengetik. Kita akan membahas kelas fungsionalitas ini lebih mendalam di [kuliah tentang code quality](/2026/code-quality/).

## Mengonfigurasi language server

Untuk beberapa bahasa, yang perlu Anda lakukan hanyalah menginstal ekstensi dan language server, dan Anda siap menggunakannya. Untuk bahasa lain, untuk mendapatkan manfaat maksimal dari language server, Anda perlu memberi tahu IDE tentang environment Anda. Sebagai contoh, menunjuk VS Code ke [environment Python](https://code.visualstudio.com/docs/python/environments) Anda akan memungkinkan language server untuk melihat package yang telah Anda instal. Environment dibahas lebih mendalam di [kuliah tentang packaging dan shipping kode](/2026/shipping-code/).

Tergantung pada bahasanya, mungkin ada beberapa pengaturan yang dapat Anda konfigurasikan untuk language server Anda. Sebagai contoh, menggunakan dukungan Python di VS Code, Anda dapat menonaktifkan static type checking untuk proyek yang tidak menggunakan type annotation opsional Python.

# Pengembangan berbasis AI

Sejak diperkenalkannya [GitHub Copilot][github-copilot] menggunakan [model Codex](https://openai.com/index/openai-codex/) dari OpenAI pada pertengahan 2021, [LLM](https://en.wikipedia.org/wiki/Large_language_model) telah menjadi banyak digunakan dalam rekayasa perangkat lunak. Ada tiga bentuk utama yang digunakan saat ini: autocomplete, inline chat, dan coding agent.

[github-copilot]: https://github.com/features/copilot/ai-code-editor

## Autocomplete

Autocomplete berbasis AI memiliki bentuk yang sama dengan autocomplete tradisional di IDE Anda, menyarankan pelengkapan di posisi kursor Anda saat Anda mengetik. Terkadang, ini digunakan sebagai fitur pasif yang "berjalan dengan sendirinya". Selain itu, autocomplete AI umumnya di-[prompt](https://en.wikipedia.org/wiki/Prompt_engineering) menggunakan komentar kode.

Sebagai contoh, mari tulis script untuk mengunduh isi catatan kuliah ini dan mengekstrak semua link. Kita bisa mulai dengan:

```python
import requests

def download_contents(url: str) -> str:
```

Model akan melengkapi body fungsi:

```python
    response = requests.get(url)
    return response.text
```

Kita dapat lebih lanjut mengarahkan pelengkapan menggunakan komentar. Sebagai contoh, jika kita mulai menulis fungsi untuk mengekstrak semua link Markdown, tetapi namanya tidak terlalu deskriptif:

```python
def extract(contents: str) -> list[str]:
```

Model akan melengkapi sesuatu seperti ini:

```python
    lines = contents.splitlines()
    return [line for line in lines if line.strip()]
```

Kita dapat mengarahkan pelengkapan melalui komentar kode:

```python
def extract(content: str) -> list[str]:
    # extract all Markdown links from the content
```

Kali ini, model memberikan pelengkapan yang lebih baik:

```python
    import re
    pattern = r'\[.*?\]\((.*?)\)'
    return re.findall(pattern, content)
```

Di sini, kita melihat salah satu kekurangan dari tool coding AI ini: ia hanya dapat memberikan pelengkapan di kursor. Dalam kasus ini, akan lebih baik jika meletakkan `import re` di level modul, daripada di dalam fungsi.

Contoh di atas menggunakan fungsi dengan nama yang buruk untuk mendemonstrasikan bagaimana code completion dapat diarahkan menggunakan komentar; dalam praktik, Anda ingin menulis kode dengan fungsi yang dinamai lebih deskriptif, seperti `extract_links`, dan Anda ingin menulis docstring (dan berdasarkan ini, model seharusnya menghasilkan pelengkapan yang analog dengan yang di atas).

Untuk tujuan demonstrasi, kita dapat melengkapi script:

```python
print(extract(download_contents("https://raw.githubusercontent.com/missing-semester/missing-semester/refs/heads/master/_2026/development-environment.md")))
```

## Inline chat

Inline chat memungkinkan Anda memilih satu baris atau blok dan kemudian langsung memberikan prompt ke model AI untuk mengusulkan edit. Dalam mode interaksi ini, model dapat membuat perubahan pada kode yang sudah ada (berbeda dengan autocomplete, yang hanya melengkapi kode di luar kursor).

Melanjutkan contoh dari atas, misalkan kita memutuskan untuk tidak menggunakan library `requests` dari pihak ketiga. Kita bisa memilih tiga baris kode yang relevan, memanggil inline chat, dan mengatakan sesuatu seperti:

```
use built-in libraries instead
```

Model mengusulkan:

```python
from urllib.request import urlopen

def download_contents(url: str) -> str:
    with urlopen(url) as response:
        return response.read().decode('utf-8')
```

## Coding agent

Coding agent dibahas secara mendalam di kuliah [Agentic Coding](/2026/agentic-coding/).

## Perangkat lunak yang direkomendasikan

Beberapa IDE AI yang populer adalah [VS Code][vs-code] dengan ekstensi [GitHub Copilot][github-copilot] dan [Cursor](https://cursor.com/). GitHub Copilot saat ini tersedia [gratis untuk mahasiswa](https://github.com/education/students), pengajar, dan maintainer proyek open source populer. Ini adalah ruang yang berkembang pesat. Banyak produk terkemuka memiliki fungsionalitas yang kurang lebih setara.

# Extensions and other IDE functionality

IDE adalah tool yang powerful, yang menjadi bahkan lebih powerful dengan _ekstensi_. Kita tidak bisa membahas semua fitur ini dalam satu kuliah, tetapi di sini kami memberikan beberapa petunjuk ke beberapa ekstensi populer. Kami mendorong Anda untuk menjelajahi ruang ini sendiri; ada banyak daftar ekstensi IDE populer yang tersedia online, seperti [Vim Awesome](https://vimawesome.com/) untuk plugin Vim dan [ekstensi VS Code diurutkan berdasarkan popularitas](https://marketplace.visualstudio.com/search?target=VSCode&category=All%20categories&sortBy=Installs).

- [Development containers](https://containers.dev/): didukung oleh IDE populer (misalnya, [didukung oleh VS Code](https://code.visualstudio.com/docs/devcontainers/containers)), dev container memungkinkan Anda menggunakan container untuk menjalankan tools pengembangan. Ini bisa berguna untuk portabilitas atau isolasi. [Kuliah tentang packaging dan shipping kode](/2026/shipping-code/) membahas container lebih mendalam.
- Remote development: melakukan pengembangan di mesin remote menggunakan SSH (misalnya, dengan [plugin Remote SSH untuk VS Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)). Ini bisa berguna, misalnya, jika Anda ingin mengembangkan dan menjalankan kode di mesin GPU yang kuat di cloud.
- Collaborative editing: mengedit file yang sama, seperti Google Docs (misalnya, dengan [plugin Live Share untuk VS Code](https://marketplace.visualstudio.com/items?itemName=MS-vsliveshare.vsliveshare)).

# Latihan

1. Aktifkan mode Vim di semua perangkat lunak yang Anda gunakan yang mendukungnya, seperti editor dan shell Anda, dan gunakan mode Vim untuk semua editing teks Anda selama sebulan ke depan. Setiap kali sesuatu terasa tidak efisien, atau ketika Anda berpikir "pasti ada cara yang lebih baik", cobalah mencari di Google, kemungkinan besar ada cara yang lebih baik.
1. Selesaikan satu tantangan dari [VimGolf](https://www.vimgolf.com/).
1. Konfigurasikan ekstensi IDE dan language server untuk proyek yang sedang Anda kerjakan. Pastikan semua fungsionalitas yang diharapkan, seperti jump-to-definition untuk dependensi library, berjalan sesuai harapan. Jika Anda tidak memiliki kode yang bisa digunakan untuk latihan ini, Anda bisa menggunakan beberapa proyek open-source dari GitHub (seperti [yang ini](https://github.com/spf13/cobra)).
1. Jelajahi daftar ekstensi IDE dan instal satu yang tampaknya berguna bagi Anda.
