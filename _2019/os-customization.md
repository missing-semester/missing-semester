---
layout: lecture
title: "Kustomisasi OS"
presenter: Anish
date: 2019-01-29
order: 3
video:
  aspect: 62.5
  id: epSRVqQzeDo
special: true
---

Ada banyak hal yang bisa Anda lakukan untuk menyesuaikan sistem operasi Anda di luar apa yang tersedia di menu pengaturan.

# Pemetaan ulang keyboard

Keyboard Anda mungkin memiliki tombol-tombol yang jarang Anda gunakan. Alih-alih membiarkan tombol-tombol tersebut tidak berguna, Anda bisa memetakannya ulang untuk melakukan hal-hal yang lebih bermanfaat.

## Memetakan ulang ke tombol lain

Hal paling sederhana adalah memetakan ulang tombol ke tombol lain. Misalnya, jika Anda jarang menggunakan tombol caps lock, Anda bisa memetakannya ulang ke sesuatu yang lebih berguna. Jika Anda adalah pengguna Vim, misalnya, Anda mungkin ingin memetakan caps lock ke escape.

Di macOS, Anda bisa melakukan beberapa pemetaan ulang melalui pengaturan Keyboard di System Preferences; untuk pemetaan yang lebih rumit, Anda memerlukan perangkat lunak khusus.

## Memetakan ulang ke perintah sembarang

Anda tidak hanya bisa memetakan ulang tombol ke tombol lain: ada perangkat lunak yang memungkinkan Anda memetakan ulang tombol (atau kombinasi tombol) ke perintah sembarang. Misalnya, Anda bisa membuat command-shift-t membuka jendela terminal baru.

# Menyesuaikan pengaturan OS yang tersembunyi

## macOS

macOS menyediakan banyak pengaturan berguna melalui perintah `defaults`. Misalnya, Anda bisa membuat ikon Dock dari aplikasi yang tersembunyi menjadi transparan:

```shell
defaults write com.apple.dock showhidden -bool true
```

Tidak ada satu daftar lengkap untuk semua pengaturan yang memungkinkan, tetapi Anda bisa menemukan daftar kustomisasi spesifik secara online, seperti [.macos](https://github.com/mathiasbynens/dotfiles/blob/master/.macos) milik Mathias Bynens.

# Manajemen jendela

## Manajemen jendela tiling

[Manajemen jendela tiling](https://en.wikipedia.org/wiki/Tiling_window_manager) adalah salah satu pendekatan dalam manajemen jendela, di mana Anda mengatur jendela-jendela ke dalam bingkai yang tidak saling tumpang tindih. Jika Anda menggunakan sistem operasi berbasis Unix, Anda bisa menginstal tiling window manager; jika Anda menggunakan sesuatu seperti Windows atau macOS, Anda bisa menginstal aplikasi yang memungkinkan Anda meniru perilaku ini.

## Manajemen layar

Anda bisa mengatur pintasan keyboard untuk membantu Anda memanipulasi jendela di berbagai layar.

## Tata letak

Jika ada cara-cara tertentu Anda menata jendela di layar, alih-alih "menjalankan" tata letak tersebut secara manual, Anda bisa membuatnya sebagai skrip, sehingga membuat pembuatan tata letak menjadi sangat mudah.

# Sumber Daya

- [Hammerspoon](https://www.hammerspoon.org/) - Otomasi desktop macOS
- [Rectangle](https://rectangleapp.com/) - Window manager macOS
- [Karabiner](https://karabiner-elements.pqrs.org/) - Pemetaan ulang keyboard macOS yang canggih
- [r/unixporn](https://www.reddit.com/r/unixporn/) - Tangkapan layar dan dokumentasi konfigurasi mewah milik orang-orang

# Latihan

1. Cari tahu cara memetakan ulang tombol Caps Lock Anda ke sesuatu yang lebih sering Anda gunakan (seperti Escape, Ctrl, atau Backspace).

1. Buat pintasan keyboard global kustom untuk membuka jendela terminal baru atau jendela browser baru.

{% comment %}

TODO

- Bitbar / Polybar
- Clipboard Manager (stack/searchable history)

{% endcomment %}
