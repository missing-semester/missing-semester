---
layout: lecture
title: "Otomasi"
presenter: Jose
date: 2019-01-24
order: 3
video:
  aspect: 56.25
  id: BaLlAaHz-1k
special: true
---

Terkadang Anda menulis skrip yang melakukan sesuatu tetapi Anda ingin skrip tersebut berjalan secara berkala, misalnya tugas pencadangan. Anda selalu dapat menulis solusi *ad hoc* yang berjalan di latar belakang dan aktif secara berkala. Namun, sebagian besar sistem UNIX dilengkapi dengan daemon cron yang dapat menjalankan tugas dengan frekuensi hingga satu menit berdasarkan aturan sederhana.

Pada sebagian besar sistem UNIX, daemon cron, `crond` akan berjalan secara default tetapi Anda selalu dapat memeriksanya menggunakan `ps aux | grep crond`.

## Crontab

Berkas konfigurasi untuk cron dapat ditampilkan dengan menjalankan `crontab -l` dan diedit dengan menjalankan `crontab -e`. Format waktu yang digunakan cron terdiri dari lima kolom yang dipisahkan spasi beserta pengguna dan perintah

- **minute** -  Menit berapa dalam satu jam perintah akan dijalankan,
     dan nilainya antara '0' hingga '59'
- **hour** -    Mengontrol jam berapa perintah akan dijalankan, dan ditentukan dalam
          format 24 jam, nilai harus antara 0 hingga 23 (0 adalah tengah malam)
- **dom** - Ini adalah Day of Month (Hari dalam Bulan), yang Anda inginkan perintah dijalankan, misalnya
      untuk menjalankan perintah pada tanggal 19 setiap bulan, dom-nya adalah 19.
- **month** -   Ini adalah bulan berapa perintah yang ditentukan akan dijalankan, dapat ditentukan
      secara numerik (0-12), atau sebagai nama bulan (mis. May)
- **dow** - Ini adalah Day of Week (Hari dalam Minggu) yang Anda inginkan perintah dijalankan, dapat
      juga berupa numerik (0-7) atau sebagai nama hari (mis. sun).
- **user** -    Ini adalah pengguna yang menjalankan perintah.
- **command** - Ini adalah perintah yang ingin Anda jalankan. Kolom ini dapat berisi
      beberapa kata atau spasi.

Perhatikan bahwa menggunakan tanda bintang `*` berarti semua dan menggunakan tanda bintang diikuti garis miring dan angka berarti setiap nilai ke-n. Jadi `*/5` berarti setiap lima. Beberapa contohnya adalah

```shell
*/5   *    *   *   *       # Every five minutes
  0   *    *   *   *       # Every hour at o'clock
  0   9    *   *   *       # Every day at 9:00 am
  0   9-17 *   *   *       # Every hour between 9:00am and 5:00pm
  0   0    *   *   5       # Every Friday at 12:00 am
  0   0    1   */2 *       # Every other month, the first day, 12:00am
```
Anda dapat menemukan banyak contoh jadwal crontab umum lainnya di [crontab.guru](https://crontab.guru/examples.html)

## Lingkungan shell dan pencatatan log

Kesalahan umum saat menggunakan cron adalah cron tidak memuat skrip lingkungan yang sama dengan shell biasa seperti `.bashrc`, `.zshrc`, &c dan tidak mencatat output ke mana pun secara default. Dikombinasikan dengan frekuensi maksimum satu menit, bisa menjadi cukup merepotkan untuk men-debug skrip cron pada awalnya.

Untuk mengatasi masalah lingkungan, pastikan Anda menggunakan path absolut di semua skrip Anda dan ubah variabel lingkungan Anda seperti `PATH` agar skrip dapat berjalan dengan sukses. Untuk menyederhanakan pencatatan log, rekomendasi yang baik adalah menulis crontab Anda dalam format seperti ini


```shell
* * * * *   user  /path/to/cronscripts/every_minute.sh >> /tmp/cron_every_minute.log 2>&1
```

Dan tulis skrip dalam berkas terpisah. Ingatlah bahwa `>>` menambahkan ke berkas dan `2>&1` mengalihkan `stderr` ke `stdout` (meskipun Anda mungkin ingin memisahkannya).

## Anacron

Salah satu keterbatasan menggunakan cron adalah jika komputer mati atau tidur ketika skrip cron seharusnya dijalankan maka skrip tersebut tidak dieksekusi. Untuk tugas yang sering, ini mungkin tidak masalah, tetapi jika tugas berjalan lebih jarang, Anda mungkin ingin memastikan tugas tersebut tetap dijalankan. [anacron](https://linux.die.net/man/8/anacron) bekerja mirip dengan `cron` kecuali frekuensi ditentukan dalam hari. Berbeda dengan cron, anacron tidak mengasumsikan bahwa mesin berjalan terus-menerus. Oleh karena itu, anacron dapat digunakan pada mesin yang tidak berjalan 24 jam sehari, untuk mengontrol tugas-tugas reguler seperti tugas harian, mingguan, dan bulanan.


## Latihan

1. Buatlah skrip yang setiap menit memeriksa folder downloads Anda untuk mencari berkas yang berupa gambar (Anda dapat melihat [MIME types](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) atau menggunakan ekspresi reguler untuk mencocokkan ekstensi umum) dan memindahkannya ke folder Pictures Anda.

1. Tulislah skrip cron untuk memeriksa paket yang kedaluwarsa di sistem Anda setiap minggu dan meminta Anda untuk memperbaruinya atau memperbaruinya secara otomatis.



{% comment %}

- [fswatch](https://github.com/emcrisostomo/fswatch)
- GUI automation (pyautogui) [Automating the boring stuff Chapter 18](https://automatetheboringstuff.com/chapter18/)
- Ansible/puppet/chef

- https://xkcd.com/1205/
- https://xkcd.com/1319/

{% endcomment %}
