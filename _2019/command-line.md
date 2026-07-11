---
layout: lecture
title: "Lingkungan command-line"
presenter: Jose
date: 2019-01-17
order: 1
video:
  aspect: 62.5
  id: i0rf1gpKL1E
---

## Alias & Fungsi

Seperti yang dapat Anda bayangkan, mengetik perintah panjang yang melibatkan banyak flag atau opsi verbose bisa menjadi melelahkan. Meskipun demikian, sebagian besar shell mendukung **aliasing**. Sebagai contoh, alias dalam bash memiliki struktur berikut (perhatikan tidak ada spasi di sekitar tanda `=`):

```bash
alias alias_name="command_to_alias"
```

<!-- We can alias common flags for our commands like `alias ll=ls -ltAh`. Alias can be composed  -->

Alias memiliki banyak fitur yang berguna

```bash
# Alias dapat merangkum flag default yang baik
alias ll="ls -lh"

# Menghemat banyak pengetikan untuk perintah umum
alias gc="git commit"

# Alias dapat menimpa perintah yang sudah ada
alias mv="mv -i"
alias mkdir="mkdir -p"

# Alias dapat digabungkan
alias la="ls -A"
alias lla="la -l"

# Untuk mengabaikan alias, jalankan dengan awalan \
\ls
# Atau dapat dinonaktifkan menggunakan unalias
unalias la

```
<!--
To get rid of an alias you can run `unalias alias_name` or to ignore alias when running a command you can prepend the command with a backward slash `\alias_name`. This is convenient when an alias is overwriting an existing name. -->


Namun dalam banyak skenario, alias bisa terbatas, terutama ketika Anda mencoba menulis rangkaian perintah yang mengambil argumen yang sama. Ada alternatif yaitu **fungsi** yang merupakan titik tengah antara alias dan skrip shell khusus.

Berikut adalah contoh fungsi yang membuat direktori dan pindah ke dalamnya.

```bash
mcd () {
    mkdir -p $1
    cd $1
}
```

Alias dan fungsi tidak akan bertahan dalam sesi shell secara default. Untuk membuat alias tetap persisten, Anda perlu memasukkannya ke dalam salah satu file skrip startup shell seperti `.bashrc` atau `.zshrc`. Saran saya adalah menulisnya secara terpisah di `.alias` dan melakukan `source` pada file tersebut dari file konfigurasi shell Anda yang berbeda.

<!-- Lastly, if you decide to alias any of these tools with the "improved" version, e.g. `alias bat=cat` it is useful to know that you can tell bash to ignore aliases by doing `\cat` and ignore both aliases and functions by doing `command cat` -->

## Shell & Framework

Selama pembahasan shell dan scripting, kita membahas shell `bash` karena ini adalah shell yang paling banyak digunakan dan sebagian besar sistem memilikinya sebagai opsi default. Meskipun demikian, ini bukan satu-satunya opsi.

Sebagai contoh, shell `zsh` adalah superset dari `bash` dan menyediakan banyak fitur berguna secara langsung seperti:

- Globbing yang lebih cerdas, `**`
- Ekspansi globbing/wildcard inline
- Koreksi ejaan
- Tab completion/selection yang lebih baik
- Ekspansi path (`cd /u/lo/b` akan diperluas menjadi `/usr/local/bin`)

Selain itu, banyak shell dapat ditingkatkan dengan **framework**, beberapa framework umum populer seperti [prezto](https://github.com/sorin-ionescu/prezto) atau [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), dan yang lebih kecil yang berfokus pada fitur tertentu seperti misalnya [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) atau [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search). Shell lain seperti [fish](https://fishshell.com/) menyertakan banyak fitur ramah pengguna ini secara default. Beberapa fitur ini meliputi:

- Right prompt
- Syntax highlighting perintah
- Pencarian substring riwayat
- Completion flag berdasarkan manpage
- Autocompletion yang lebih cerdas
- Tema prompt

Satu hal yang perlu diperhatikan saat menggunakan framework ini adalah jika kode yang mereka jalankan tidak dioptimalkan dengan baik atau terlalu banyak kode, shell Anda bisa mulai melambat. Anda selalu dapat melakukan profiling dan menonaktifkan fitur yang tidak sering Anda gunakan atau mengutamakan kecepatan.

## Terminal Emulator & Multiplexer

Selain mengkustomisasi shell Anda, ada baiknya meluangkan waktu untuk mencari pilihan **terminal emulator** Anda dan pengaturannya. Ada banyak terminal emulator di luar sana (berikut adalah [perbandingannya](https://anarc.at/blog/2018-04-12-terminal-emulators-1/)).

Karena Anda mungkin menghabiskan ratusan hingga ribuan jam di terminal Anda, ada baiknya Anda menyelidiki pengaturannya. Beberapa aspek yang mungkin ingin Anda ubah di terminal Anda meliputi:

- Pilihan font
- Skema Warna
- Pintasan keyboard
- Dukungan Tab/Pane
- Konfigurasi scrollback
- Performa (beberapa terminal baru seperti [Alacritty](https://github.com/jwilm/alacritty) menawarkan akselerasi GPU)

Perlu juga disebutkan **terminal multiplexer** seperti [tmux](https://github.com/tmux/tmux). `tmux` memungkinkan Anda melakukan pane dan tab pada beberapa sesi shell. Ini juga mendukung attaching dan detaching yang merupakan kasus penggunaan yang sangat umum ketika Anda bekerja di server remote dan ingin menjaga shell Anda tetap berjalan tanpa perlu khawatir tentang proses Anda yang dihentikan (secara default ketika Anda logout, proses Anda dihentikan). Dengan cara ini, dengan `tmux` Anda dapat masuk dan keluar dari tata letak terminal yang kompleks. Sama seperti terminal emulator, `tmux` mendukung kustomisasi berat dengan mengedit file `~/.tmux.conf`.


## Utilitas command-line

Utilitas command-line yang dimiliki sebagian besar sistem operasi berbasis UNIX secara default lebih dari cukup untuk melakukan 99% hal yang biasanya perlu Anda lakukan.


Dalam beberapa subbagian berikutnya, saya akan membahas alat alternatif untuk operasi shell yang sangat umum yang lebih nyaman digunakan. Beberapa alat ini menambahkan fungsionalitas baru yang ditingkatkan pada perintah sedangkan yang lain hanya berfokus pada penyediaan antarmuka yang lebih sederhana dan lebih intuitif dengan default yang lebih baik.

### `fasd` vs `cd`

Bahkan dengan ekspansi path yang ditingkatkan dan tab autocomplete, mengubah direktori bisa menjadi cukup repetitif. [Fasd](https://github.com/clvv/fasd) (atau [autojump](https://github.com/wting/autojump)) menyelesaikan masalah ini dengan melacak folder baru-baru ini dan yang sering Anda kunjungi serta melakukan pencocokan fuzzy.

Jadi jika Anda telah mengunjungi path `/home/user/awesome_project/code`, menjalankan `z code` akan melakukan `cd` ke sana. Jika Anda memiliki beberapa folder bernama code, Anda dapat menghilangkan ambiguitas dengan menjalankan `z awe code` yang akan menjadi pencocokan yang lebih dekat. Berbeda dengan autojump, fasd juga menyediakan perintah yang alih-alih melakukan `cd`, hanya memperluas file/folder yang sering dan/atau baru-baru ini atau keduanya.


### `bat` vs `cat`

Meskipun `cat` melakukan tugasnya dengan sempurna, [bat](https://github.com/sharkdp/bat) meningkatkannya dengan menyediakan syntax highlighting, paging, nomor baris, dan integrasi git.


### `exa`/`ranger` vs `ls`

`ls` adalah perintah yang hebat tetapi beberapa defaultnya bisa mengganggu seperti menampilkan ukuran dalam byte mentah. [exa](https://github.com/ogham/exa) menyediakan default yang lebih baik

Jika Anda perlu menavigasi banyak folder dan/atau melihat pratinjau banyak file, [ranger](https://github.com/ranger/ranger) bisa jauh lebih efisien daripada `cd` dan `cat` karena antarmukanya yang luar biasa. Ini cukup dapat dikustomisasi dan dengan pengaturan yang benar Anda bahkan dapat [melihat pratinjau gambar](https://github.com/ranger/ranger/wiki/Image-Previews) di terminal Anda

### `fd` vs `find`

[fd](https://github.com/sharkdp/fd) adalah alternatif `find` yang sederhana, cepat, dan ramah pengguna. Default `find` seperti harus menggunakan flag `--name` (yang adalah apa yang ingin Anda lakukan 99% dari waktu) membuatnya lebih mudah digunakan sehari-hari. Ini juga `git` aware dan akan melewatkan file di `.gitignore` dan folder `.git` Anda secara default. Ini juga memiliki pewarnaan yang bagus secara default.

### `rg/fzf` vs `grep`

`grep` adalah alat yang hebat tetapi jika Anda ingin melakukan grep melalui banyak file sekaligus, ada alat yang lebih baik untuk tujuan tersebut. [ack](https://github.com/beyondgrep/ack3), [ag](https://github.com/ggreer/the_silver_searcher) & [rg](https://github.com/BurntSushi/ripgrep) mencari secara rekursif di direktori Anda saat ini untuk pola regex sambil mematuhi aturan gitignore Anda. Semuanya bekerja cukup mirip tetapi saya lebih memilih `rg` karena seberapa cepat ia dapat mencari seluruh direktori home saya.

Demikian pula, bisa jadi Anda sering melakukan `CMD | grep PATTERN` berulang-ulang. [fzf](https://github.com/junegunn/fzf) adalah command line fuzzy finder yang memungkinkan Anda memfilter output dari hampir semua perintah secara interaktif.

### `rsync` vs `cp/scp`

Meskipun `mv` dan `scp` sempurna untuk sebagian besar skenario, ketika menyalin/memindahkan sejumlah besar file, file besar, atau ketika beberapa data sudah ada di tujuan, `rsync` adalah peningkatan yang besar. `rsync` akan melewatkan file yang sudah ditransfer dan dengan flag `--partial` ia dapat melanjutkan dari salinan yang sebelumnya terganggu.

### `trash` vs `rm`

`rm` adalah perintah yang berbahaya dalam arti bahwa setelah Anda menghapus file, tidak ada jalan kembali. Namun, OS modern tidak berperilaku seperti itu ketika Anda menghapus sesuatu di file explorer, mereka hanya memindahkannya ke folder Trash yang dikosongkan secara berkala.

Karena cara trash dikelola berbeda dari satu OS ke OS lainnya, tidak ada utilitas CLI tunggal. Di macOS ada [trash](https://hasseg.org/trash/) dan di linux ada [trash-cli](https://github.com/andreafrancia/trash-cli/) dan lain-lain.

### `mosh` vs `ssh`

`ssh` adalah alat yang sangat berguna tetapi jika Anda memiliki koneksi lambat, lag bisa menjadi menjengkelkan dan jika koneksi terputus Anda harus terhubung kembali. [mosh](https://mosh.org/) adalah alat berguna yang bekerja memungkinkan roaming, mendukung konektivitas intermiten, dan menyediakan local echo yang cerdas.

### `tldr` vs `man`

Anda dapat mengetahui apa yang dilakukan perintah dan opsi apa yang dimilikinya menggunakan `man` dan flag `-h`/'--help' sebagian besar waktu. Namun, dalam beberapa kasus bisa agak menakutkan menavigasi ini jika mereka detail

Perintah [tldr](https://github.com/tldr-pages/tldr) adalah sistem dokumentasi berbasis komunitas yang tersedia dari command line dan memberikan beberapa contoh ilustratif sederhana tentang apa yang dilakukan perintah dan opsi argumen yang paling umum.


### `aunpack` vs `tar/unzip/unrar`

Seperti yang direferensikan [xkcd ini](https://xkcd.com/1168/), bisa cukup rumit untuk mengingat opsi untuk `tar` dan terkadang Anda memerlukan alat yang sama sekali berbeda seperti `unrar` untuk file .rar.
Paket [atool](https://www.nongnu.org/atool/) menyediakan perintah `aunpack` yang akan mencari tahu opsi yang benar dan selalu menempatkan arsip yang diekstrak dalam folder baru.


## Latihan

1. Jalankan `cat .bash_history | sort | uniq -c | sort -rn | head -n 10` (atau `cat .zhistory | sort | uniq -c | sort -rn | head -n 10` untuk zsh) untuk mendapatkan 10 perintah yang paling sering digunakan dan pertimbangkan untuk menulis alias yang lebih pendek untuk mereka
1. Pilih terminal emulator dan cari tahu cara mengubah properti berikut:
    - Pilihan font
    - Skema warna. Berapa banyak warna yang dimiliki skema standar? mengapa?
    - Ukuran riwayat scrollback

1. Instal `fasd` atau perangkat lunak serupa dan tulis fungsi bash/zsh bernama `v` yang melakukan pencocokan fuzzy pada argumen yang diberikan dan membuka hasil teratas di editor pilihan Anda. Kemudian, modifikasi sehingga jika ada beberapa kecocokan Anda dapat memilihnya dengan `fzf`.
1. Karena `fzf` sangat nyaman untuk melakukan pencarian fuzzy dan riwayat shell cukup rentan terhadap jenis pencarian tersebut, selidiki cara mengikat `fzf` ke `^R`. Anda dapat menemukan beberapa info [di sini](https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings)
1. Apa yang dilakukan opsi `--bar` di `ack`?
