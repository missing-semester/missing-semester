---
layout: lecture
title: "Web dan Browser"
presenter: Jose
date: 2019-01-31
order: 1
video:
  aspect: 62.5
  id: XpZO3S8odec
special: true
description: "Belajar menggunakan browser web secara efisien, termasuk pintasan, operator pencarian, ekstensi privasi, kustomisasi gaya, dan otomasi web."
---

Selain terminal, browser web adalah alat yang akan sering Anda gunakan dalam waktu yang cukup lama. Maka dari itu, penting untuk belajar cara menggunakannya secara efisien dan

## Pintasan

Mengklik di browser Anda seringkali bukan cara tercepat. Membiasakan diri dengan pintasan umum akan sangat bermanfaat dalam jangka panjang.

- `Middle Button Click` pada tautan akan membukanya di tab baru
- `Ctrl+T` Membuka tab baru
- `Ctrl+Shift+T` Membuka kembali tab yang baru saja ditutup
- `Ctrl+L` Memilih isi bilah pencarian
- `Ctrl+F` untuk mencari di dalam halaman web. Jika Anda sering melakukan ini, Anda mungkin akan terbantu dengan ekstensi yang mendukung ekspresi reguler dalam pencarian.


## Operator Pencarian

Mesin pencari web seperti Google atau DuckDuckGo menyediakan operator pencarian untuk memungkinkan pencarian web yang lebih rinci:

- `"bar foo"` memaksa pencocokan persis dari bar foo
- `foo site:bar.com` mencari foo di dalam bar.com
- `foo -bar ` mengecualikan istilah yang mengandung bar dari pencarian
- `foobar filetype:pdf` Mencari file dengan ekstensi tersebut
- `(foo|bar)` mencari kecocokan yang memiliki foo ATAU bar

Daftar yang lebih lengkap tersedia untuk mesin pencari populer seperti [Google](https://ahrefs.com/blog/google-advanced-search-operators/) dan [DuckDuckGo](https://duck.co/help/results/syntax)


## Bilah Pencarian

Bilah pencarian juga merupakan alat yang kuat. Sebagian besar browser dapat mengenali mesin pencari dari situs web dan akan menyimpannya. Dengan mengedit argumen kata kunci

- Di Google Chrome, mereka ada di [chrome://settings/searchEngines](chrome://settings/searchEngines)
- Di Firefox, mereka ada di [about:preferences#search](about:preferences#search)

Sebagai contoh, Anda bisa mengatur agar `y SOME SEARCH TERMS` langsung mencari di YouTube.

Selain itu, jika Anda memiliki domain, Anda dapat mengatur penerusan subdomain melalui registrar Anda. Sebagai contoh, saya telah memetakan `https://ht.josejg.com` ke situs web kursus ini. Dengan begitu saya cukup mengetik `ht.` dan bilah pencarian akan melakukan autocomplete. Keunggulan lain dari pengaturan ini adalah tidak seperti bookmark, pengaturan ini akan berfungsi di setiap browser.

## Ekstensi Privasi

Saat ini menjelajahi web bisa sangat mengganggu karena iklan dan invasif karena pelacak. Selain itu, pemblokir iklan yang baik tidak hanya memblokir sebagian besar konten iklan tetapi juga akan memblokir situs web yang mencurigakan dan berbahaya karena mereka akan dimasukkan dalam daftar hitam umum. Mereka juga akan mengurangi waktu muat halaman terkadang dengan mengurangi jumlah permintaan yang dilakukan. Beberapa rekomendasi adalah:

- **uBlock origin** ([Chrome](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm), [Firefox](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)): memblokir iklan dan pelacak berdasarkan aturan yang telah ditentukan. Anda juga harus mempertimbangkan untuk melihat daftar hitam yang diaktifkan di pengaturan karena Anda dapat mengaktifkan lebih banyak berdasarkan wilayah atau kebiasaan penjelajahan Anda. Anda bahkan dapat menginstal filter dari [seluruh web](https://github.com/gorhill/uBlock/wiki/Filter-lists-from-around-the-web)

- **[Privacy Badger](https://privacybadger.org/)**: mendeteksi dan memblokir pelacak secara otomatis. Sebagai contoh, ketika Anda berpindah dari satu situs web ke situs web lain, perusahaan iklan melacak situs mana yang Anda kunjungi dan membangun profil tentang Anda

- **[HTTPS everywhere](https://www.eff.org/https-everywhere)** adalah ekstensi yang luar biasa yang mengarahkan ulang ke versi HTTPS dari sebuah situs web secara otomatis, jika tersedia.

Anda dapat menemukan lebih banyak addon semacam ini [di sini](https://www.privacytools.io/privacy-browser-addons/)

## Kustomisasi Gaya

Browser web hanyalah perangkat lunak lain yang berjalan di _mesin Anda_ dan karenanya Anda biasanya memiliki keputusan terakhir tentang apa yang harus mereka tampilkan atau bagaimana mereka harus berperilaku. Contoh dari ini adalah gaya kustom. Browser menentukan bagaimana merender gaya halaman web menggunakan Cascading Style Sheets yang sering disingkat sebagai CSS.

Anda dapat mengakses kode sumber sebuah situs web dengan cara menginspeksinya dan mengubah isi serta gayanya sementara waktu (ini juga alasan mengapa Anda tidak boleh percaya tangkapan layar halaman web).

Jika Anda ingin memberi tahu browser Anda secara permanen untuk mengesampingkan pengaturan gaya untuk sebuah halaman web, Anda perlu menggunakan ekstensi. Rekomendasi kami adalah **[Stylus](https://github.com/openstyles/stylus)** ([Firefox](https://addons.mozilla.org/en-US/firefox/addon/styl-us/), [Chrome](https://chrome.google.com/webstore/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne?hl=en)).


Sebagai contoh, kita dapat menulis gaya berikut untuk situs web kelas


```css

body {
    background-color: #2d2d2d;
    color: #eee;
    font-family: Fira Code;
    font-size: 16pt;
}

a:link {
    text-decoration: none;
    color: #0a0;
}
```

Selain itu, Stylus dapat menemukan gaya yang ditulis oleh pengguna lain dan dipublikasikan di [userstyles.org](https://userstyles.org/). Sebagian besar situs web umum memiliki satu atau beberapa stylesheet tema gelap misalnya. Sebagai informasi, Anda tidak boleh menggunakan Stylish karena terbukti membocorkan data pengguna, lebih lanjut [di sini](https://arstechnica.com/information-technology/2018/07/stylish-extension-with-2m-downloads-banished-for-tracking-every-site-visit/)


## Kustomisasi Fungsionalitas

Sama seperti Anda dapat mengubah gaya, Anda juga dapat mengubah perilaku sebuah situs web dengan menulis javascript kustom dan memuatnya menggunakan ekstensi browser web seperti [Tampermonkey](https://tampermonkey.net/)

Sebagai contoh, skrip berikut mengaktifkan navigasi mirip vim menggunakan tombol J dan K.

```js
// ==UserScript==
// @name         VIM HT
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Vim JK for our website
// @author       You
// @match        https://hacker-tools.github.io/*
// @grant        none
// ==/UserScript==


(function() {
    'use strict';

    window.onkeyup = function(e) {
        var key = e.keyCode ? e.keyCode : e.which;

        if (key == 74) { // J is key 74
            window.scrollBy(0,500);;
        }else if (key == 75) { // K is key 75
            window.scrollBy(0,-500);;
        }
    }
})();
```

Terdapat juga repositori skrip seperti [OpenUserJS](https://openuserjs.org/) dan [Greasy Fork](https://greasyfork.org/en). Namun, perlu diingat, menginstal skrip pengguna dari orang lain bisa sangat berbahaya karena mereka bisa melakukan hampir semua hal seperti mencuri nomor kartu kredit Anda. Jangan pernah menginstal skrip kecuali Anda membaca seluruh isinya sendiri, memahami apa yang dilakukannya, dan benar-benar yakin bahwa skrip tersebut tidak melakukan sesuatu yang mencurigakan. Jangan pernah menginstal skrip yang berisi kode minified atau obfuscated yang tidak dapat Anda baca!

## Web API

Semakin umum bagi layanan web untuk menawarkan application interface alias web API sehingga Anda dapat berinteraksi dengan layanan tersebut melalui permintaan web.
Pengantar yang lebih mendalam tentang topik ini dapat ditemukan [di sini](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Client-side_web_APIs/Introduction). Terdapat [banyak API publik](https://github.com/toddmotto/public-apis). Web API dapat berguna karena banyak alasan:

- **Pengambilan Data**. Web API dapat dengan mudah menyediakan informasi seperti peta, cuaca, atau alamat IP publik Anda. Sebagai contoh, `curl ipinfo.io` akan mengembalikan objek JSON dengan beberapa detail tentang IP publik, wilayah, lokasi, dll. Dengan parsing yang tepat, alat-alat ini dapat diintegrasikan bahkan dengan alat baris perintah. Fungsi bash berikut berkomunikasi dengan API autocompletion Google dan mengembalikan sepuluh kecocokan pertama.

```bash
function c() {
    url='https://www.google.com/complete/search?client=hp&hl=en&xhr=t'
    # NB: user-agent must be specified to get back UTF-8 data!
    curl -H 'user-agent: Mozilla/5.0' -sSG --data-urlencode "q=$*" "$url" |
        jq -r ".[1][][0]" |
        sed 's,</\?b>,,g'
}
```

- **Interaksi**. Endpoint Web API juga dapat digunakan untuk memicu tindakan. Ini biasanya memerlukan semacam token autentikasi yang dapat Anda peroleh melalui layanan tersebut. Sebagai contoh, menjalankan perintah berikut
`curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' "https://hooks.slack.com/services/$SLACK_TOKEN"` akan mengirim pesan `Hello, World!` di sebuah channel.

- **Piping**. Karena beberapa layanan dengan Web API cukup populer, "penyambungan" Web API umum telah diimplementasikan dan disediakan bersama dengan server. Ini berlaku untuk layanan seperti [If This Then That](https://ifttt.com/) dan [Zapier](https://zapier.com/)


## Otomasi Web

Terkadang Web API tidak cukup. Jika hanya diperlukan pembacaan, Anda dapat menggunakan parser html seperti `pup` atau menggunakan pustaka, misalnya python memiliki BeautifulSoup. Namun jika diperlukan interaktivitas atau eksekusi javascript, solusi tersebut tidak memadai. WebDriver


Sebagai contoh, skrip berikut akan menyimpan url yang ditentukan menggunakan wayback machine dengan mensimulasikan interaksi pengetikan situs web.

```python
from selenium.webdriver import Firefox
from selenium.webdriver.common.keys import Keys


def snapshot_wayback(driver, url):

    driver.get("https://web.archive.org/")
    elem = driver.find_element_by_class_name('web-save-url-input')
    elem.clear()
    elem.send_keys(url)
    elem.send_keys(Keys.RETURN)
    driver.close()


driver = Firefox()
url = 'https://hacker-tools.github.io'
snapshot_wayback(driver, url)
```


## Latihan

1. Edit mesin pencari kata kunci yang sering Anda gunakan di browser web Anda
1. Instal ekstensi yang disebutkan. Pelajari bagaimana uBlock Origin/Privacy Badger dapat dinonaktifkan untuk sebuah situs web. Perbedaan apa yang Anda lihat? Cobalah melakukannya di situs web dengan banyak iklan seperti YouTube.
1. Instal Stylus dan tulis gaya kustom untuk situs web kelas menggunakan CSS yang disediakan. Berikut adalah beberapa karakter pemrograman umum `=   ==   ===   >=   =>   ++   /=   ~=`. Apa yang terjadi pada mereka ketika mengubah font ke Fira Code? Jika Anda ingin tahu lebih lanjut, cari tentang programming font ligatures.
1. Temukan web API untuk mendapatkan cuaca di kota/wilayah Anda.
1. Gunakan perangkat lunak WebDriver seperti [Selenium](https://www.selenium.dev/documentation/) untuk mengotomatiskan tugas manual berulang yang sering Anda lakukan dengan browser Anda.
