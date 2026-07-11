---
layout: lecture
title: "Cadangan"
presenter: Jose
date: 2019-01-24
order: 2
video:
  aspect: 56.25
  id: lrpqYF8tcYQ
special: true
---

Ada dua jenis orang:

- Mereka yang melakukan cadangan
- Mereka yang akan melakukan cadangan

Semua data yang Anda miliki yang belum Anda cadangkan adalah data yang bisa hilang kapan saja, selamanya. Di sini kita akan membahas dasar-dasar cadangan yang baik dan jebakan dari beberapa pendekatan.

## Aturan 3-2-1

[Aturan 3-2-1](https://www.us-cert.gov/sites/default/files/publications/data_backup_options.pdf) adalah strategi umum yang direkomendasikan untuk mencadangkan data Anda. Aturan ini menyatakan bahwa Anda harus memiliki:

- setidaknya **3 salinan** data Anda
- **2** salinan dalam **media berbeda**
- **1** salinan berada di **lokasi terpisah (offsite)**

Ide utama di balik rekomendasi ini adalah jangan menaruh semua telur dalam satu keranjang. Memiliki 2 perangkat/disk yang berbeda memastikan bahwa satu kegagalan perangkat keras tidak menghapus semua data Anda. Demikian pula, jika Anda hanya menyimpan cadangan di rumah dan rumah Anda terbakar atau dirampok, Anda akan kehilangan semuanya! Itulah mengapa salinan offsite diperlukan. Cadangan onsite memberikan ketersediaan dan kecepatan, sedangkan offsite memberikan ketahanan jika terjadi bencana.

## Menguji cadangan Anda

Jebakan umum saat melakukan cadangan adalah mempercayai begitu saja apa yang dikatakan sistem dan tidak memverifikasi bahwa data dapat dipulihkan dengan benar. Toy Story 2 hampir hilang dan cadangan mereka tidak berfungsi, [keberuntungan](https://www.youtube.com/watch?v=8dhp_20j0Ys) akhirnya menyelamatkan mereka.

## Versioning

Anda harus memahami bahwa [RAID](https://en.wikipedia.org/wiki/RAID) bukanlah cadangan, dan secara umum **mirroring bukanlah solusi cadangan**. Hanya menyinkronkan file Anda ke suatu tempat tidak akan membantu dalam beberapa skenario, seperti:

- Kerusakan data
- Perangkat lunak berbahaya
- Menghapus file secara tidak sengaja

Jika perubahan pada data Anda menyebar ke cadangan, maka Anda tidak akan bisa memulihkannya dalam skenario-skenario tersebut. Perhatikan bahwa ini adalah kasus untuk banyak solusi penyimpanan cloud seperti Dropbox, Google Drive, One Drive, &c. Beberapa di antaranya menyimpan data yang dihapus dalam waktu singkat, tetapi biasanya antarmuka untuk memulihkan bukanlah sesuatu yang ingin Anda gunakan untuk memulihkan file dalam jumlah besar.

Sistem cadangan yang seharusnya memiliki versioning untuk mencegah mode kegagalan ini. Dengan menyediakan berbagai snapshot dalam waktu, seseorang dapat dengan mudah menavigasinya untuk memulihkan apa pun yang hilang. Perangkat lunak yang paling dikenal untuk jenis ini adalah macOS Time Machine.

## Deduplikasi

Namun, membuat beberapa salinan data Anda bisa sangat mahal dalam hal ruang disk. Meskipun demikian, dari satu versi ke versi berikutnya, sebagian besar data akan identik dan tidak perlu ditransfer lagi. Di sinilah [deduplikasi data](https://en.wikipedia.org/wiki/Data_deduplication) berperan, dengan melacak apa yang sudah disimpan, seseorang dapat melakukan **cadangan inkremental** di mana hanya perubahan dari satu versi ke versi berikutnya yang perlu disimpan. Ini secara signifikan mengurangi jumlah ruang yang dibutuhkan untuk cadangan di luar salinan pertama.

## Enkripsi

Karena kita mungkin mencadangkan ke pihak ketiga yang tidak tepercaya seperti penyedia cloud, perlu dipertimbangkan bahwa jika data cadangan Anda disalin *apa adanya*, maka data tersebut berpotensi dilihat oleh pihak yang tidak diinginkan. Dokumen seperti pajak Anda adalah informasi sensitif yang tidak boleh dicadangkan dalam format biasa. Untuk mencegah hal ini, banyak solusi cadangan menawarkan **enkripsi sisi klien** di mana data dienkripsi sebelum dikirim ke server. Dengan begitu server tidak dapat membaca data yang disimpannya, tetapi Anda dapat mendekripsinya dengan kunci rahasia Anda.

Sebagai catatan tambahan, jika disk Anda (atau partisi home) tidak dienkripsi, maka siapa pun yang mendapatkan akses ke komputer Anda dapat melewati kontrol akses pengguna dan membaca data Anda. Perangkat keras modern mendukung pembacaan dan penulisan data terenkripsi yang cepat dan efisien, jadi Anda mungkin ingin mempertimbangkan untuk mengaktifkan **enkripsi disk penuh**.


## Append only

Properti yang telah ditinjau sejauh ini berfokus pada kegagalan perangkat keras atau kesalahan pengguna, tetapi gagal mengatasi apa yang terjadi jika agen berbahaya ingin menghapus data Anda. Misalnya, jika seseorang meretas sistem Anda, apakah mereka mampu menghapus semua salinan data yang Anda pedulikan? Jika Anda khawatir dengan skenario tersebut, maka Anda memerlukan solusi cadangan yang bersifat append only. Secara umum, ini berarti memiliki server yang mengizinkan Anda mengirim data baru tetapi akan menolak untuk menghapus data yang sudah ada. Biasanya pengguna memiliki dua kunci, kunci append only yang mendukung pembuatan cadangan baru dan kunci akses penuh yang juga memungkinkan penghapusan cadangan lama yang tidak diperlukan lagi. Kunci latter disimpan secara offline.

Perhatikan bahwa ini adalah skenario yang cukup menantang karena Anda memerlukan kemampuan untuk membuat perubahan sambil tetap mencegah pengguna berbahaya menghapus data Anda. Solusi komersial yang ada termasuk [Tarsnap](https://www.tarsnap.com/) dan [Borgbase](https://www.borgbase.com/).


## Pertimbangan tambahan

Beberapa hal lain yang mungkin ingin Anda telusuri:

- **Cadangan berkala**: cadangan yang usang bisa menjadi sangat tidak berguna. Membuat cadangan secara berkala harus menjadi pertimbangan untuk sistem Anda
- **Cadangan yang dapat di-boot**: beberapa program memungkinkan Anda mengkloning seluruh disk Anda. Dengan begitu Anda memiliki image yang berisi salinan lengkap sistem Anda yang dapat langsung di-boot.
- **Strategi cadangan diferensial**, Anda mungkin tidak perlu memperlakukan semua data dengan tingkat kepentingan yang sama. Anda dapat menentukan kebijakan cadangan berbeda untuk berbagai jenis data.
- **Cadangan append only** - pertimbangan tambahan adalah memberlakukan operasi append only pada repositori cadangan Anda untuk mencegah agen berbahaya menghapusnya jika mereka mendapatkan akses ke mesin Anda.


## Layanan Web

Tidak semua data yang Anda gunakan berada di hard disk Anda. Jika Anda menggunakan **layanan web**, maka mungkin ada beberapa data yang Anda pedulikan, seperti presentasi Google Docs atau playlist Spotify, yang disimpan secara online. Contoh lain yang mudah dilupakan adalah akun email dengan akses web, seperti Gmail. Menemukan solusi cadangan untuk kasus-kasus ini agak lebih rumit. Namun, ada banyak layanan yang memungkinkan Anda mengunduh data Anda, baik secara langsung maupun melalui API. Alat seperti [gmvault](https://github.com/gaubert/gmvault) untuk Gmail tersedia untuk mengunduh file email ke komputer Anda.


## Halaman Web

Demikian pula, beberapa konten berkualitas tinggi dapat ditemukan secara online dalam bentuk halaman web. Jika konten tersebut bersifat statis, seseorang dapat dengan mudah mencadangkannya hanya dengan menyimpan website dan semua lampirannya. Alternatif lain adalah [Wayback Machine](https://archive.org/web/), arsip digital besar dari World Wide Web yang dikelola oleh [Internet Archive](https://archive.org/), organisasi nirlaba yang fokus pada pelestarian berbagai jenis media. Wayback Machine memungkinkan Anda menangkap dan mengarsipkan halaman web, sehingga nanti Anda dapat mengambil semua snapshot yang telah diarsipkan untuk website tersebut. Jika Anda merasa berguna, pertimbangkan untuk [berdonasi](https://archive.org/donate/) ke proyek ini.


## Sumber Daya

Beberapa program dan layanan cadangan bagus yang telah kami gunakan dan dapat kami rekomendasikan dengan jujur:

- [Tarsnap](https://www.tarsnap.com/) - layanan cadangan online terdeduplikasi dan terenkripsi untuk yang benar-benar paranoid.
- [Borg Backup](https://borgbackup.readthedocs.io) - program cadangan terdeduplikasi yang mendukung kompresi dan enkripsi terautentikasi. Jika Anda memerlukan penyedia cloud, [BorgBase](https://www.borgbase.com/) adalah salah satu opsi populer.
- [rsync](https://rsync.samba.org/) adalah utilitas yang menyediakan transfer file inkremental yang cepat. Ini bukan solusi cadangan lengkap.
- [rclone](https://rclone.org/) seperti rsync tetapi untuk penyedia penyimpanan cloud seperti Amazon S3, Dropbox, Google Drive, rsync.net, &c. Mendukung enkripsi sisi klien untuk folder remote.

## Latihan

1. Pertimbangkan bagaimana Anda (tidak) mencadangkan data Anda dan telusuri untuk memperbaiki/meningkatkannya.

1. Cari tahu cara mencadangkan akun email Anda

1. Pilih layanan web yang sering Anda gunakan (Spotify, Google Music, dll.) dan cari tahu opsi apa yang tersedia untuk mencadangkan data Anda. Seringkali orang telah membuat alat (seperti [youtube-dl](https://ytdl-org.github.io/youtube-dl/)) solusi berdasarkan API yang tersedia.

1. Pikirkan sebuah website yang telah Anda kunjungi berulang kali selama bertahun-tahun dan cari di [archive.org](https://archive.org/web/), berapa banyak versi yang dimilikinya?

1. Salah satu cara untuk mengimplementasikan deduplikasi secara efisien adalah dengan menggunakan hardlink. Berbeda dengan symbolic link (juga disebut soft link atau symlink) yang merupakan file yang menunjuk ke file atau folder lain, hardlink adalah salinan persis dari pointer tersebut (menggunakan inode yang sama dan menunjuk ke tempat yang sama di disk). Jadi jika file asli dihapus, symlink akan berhenti berfungsi sedangkan hardlink tidak. Namun, hardlink hanya bekerja untuk file. Cobalah menggunakan perintah `ln` untuk membuat hard link dan bandingkan dengan symlink yang dibuat dengan `ln -s`. (Di macOS Anda perlu menginstal gnu coreutils atau paket hln).
