---
layout: lecture
title: "Mengapa kami mengajarkan kelas ini"
---

Dalam pendidikan Ilmu Komputer tradisional, kemungkinan besar Anda akan mengambil
banyak kelas yang mengajarkan topik-topik lanjutan dalam ilmu komputer, mulai dari
Sistem Operasi hingga Bahasa Pemrograman hingga Machine Learning. Namun di banyak
institusi, ada satu topik penting yang jarang dibahas dan justru
dibiarkan untuk dipelajari sendiri oleh para mahasiswa: literasi ekosistem komputasi.

Selama bertahun-tahun, kami telah membantu mengajar beberapa kelas di MIT, dan berulang kali
kami melihat bahwa banyak mahasiswa memiliki pengetahuan terbatas tentang alat-alat yang tersedia
untuk mereka. Komputer diciptakan untuk mengotomatisasi tugas-tugas manual, namun mahasiswa sering
melakukan tugas-tugas berulang secara manual atau gagal memanfaatkan sepenuhnya alat-alat canggih
seperti version control dan text editor. Dalam kasus terbaik, ini mengakibatkan
inefisiensi dan waktu yang terbuang; dalam kasus terburuk, ini mengakibatkan masalah seperti
kehilangan data atau ketidakmampuan menyelesaikan tugas tertentu.

Topik-topik ini tidak diajarkan sebagai bagian dari kurikulum universitas: mahasiswa
tidak pernah ditunjukkan cara menggunakan alat-alat ini, atau setidaknya tidak cara menggunakannya
secara efisien, sehingga membuang waktu dan usaha untuk tugas-tugas yang _seharusnya_ sederhana.
Kurikulum ilmu komputer standar tidak mencakup topik-topik penting tentang ekosistem komputasi
yang dapat membuat kehidupan mahasiswa jauh lebih mudah.

# Semester yang hilang dari pendidikan ilmu komputer Anda

Untuk membantu mengatasi hal ini, kami membuat kelas yang mencakup semua topik yang kami
anggap penting untuk menjadi ilmuwan komputer dan programmer yang efektif. Kelas ini
bersifat pragmatis dan praktis, dan memberikan pengenalan langsung terhadap
alat-alat dan teknik yang dapat langsung Anda terapkan dalam berbagai situasi
yang akan Anda hadapi. Iterasi terbaru kelas ini, dengan
materi yang telah direvisi secara substansial, diadakan selama "Independent
Activities Period" MIT pada Januari 2026 — semester satu bulan yang menampilkan kelas-kelas
lebih pendek yang dijalankan oleh mahasiswa. Meskipun kuliah itu sendiri hanya tersedia untuk komunitas MIT,
kami akan menyediakan semua materi kuliah beserta rekaman video
kuliah untuk publik.

Jika ini terdengar menarik untuk Anda, berikut adalah beberapa contoh konkret
tentang apa yang akan diajarkan di kelas ini:

## Command shell

Cara mengotomatisasi tugas-tugas umum dan berulang dengan alias, script,
dan build system. Tidak perlu lagi copy-paste perintah dari dokumen
teks. Tidak perlu lagi "jalankan 15 perintah ini satu per satu". Tidak
perlu lagi "Anda lupa menjalankan ini" atau "Anda lupa memasukkan argumen ini".

Sebagai contoh, mencari melalui history Anda dengan cepat dapat menghemat banyak waktu. Dalam contoh di bawah kami menunjukkan beberapa trik terkait navigasi history shell Anda untuk perintah `convert`.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/history.mp4" type="video/mp4">
</video>

## Version control

Cara menggunakan version control _dengan benar_, dan memanfaatkannya untuk
menyelamatkan Anda dari bencana, berkolaborasi dengan orang lain, dan dengan cepat menemukan serta
mengisolasi perubahan yang bermasalah. Tidak perlu lagi `rm -rf; git clone`. Tidak perlu lagi
merge conflict (setidaknya lebih sedikit). Tidak perlu lagi blok kode besar
yang dikomentari. Tidak perlu lagi pusing mencari apa yang merusak
kode Anda. Tidak perlu lagi "oh tidak, apakah kita menghapus kode yang berfungsi?!". Kami bahkan
akan mengajarkan Anda cara berkontribusi pada proyek orang lain dengan pull
request!

Dalam contoh di bawah kami menggunakan `git bisect` untuk menemukan commit mana yang merusak unit test dan kemudian kami memperbaikinya dengan `git revert`.
<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/git.mp4" type="video/mp4">
</video>

## Text editing

Cara mengedit file secara efisien dari command-line, baik secara lokal maupun
remote, dan memanfaatkan fitur-fitur editor yang canggih. Tidak perlu lagi
menyalin file bolak-balik. Tidak perlu lagi mengedit file secara berulang.

Vim macros adalah salah satu fitur terbaiknya, dalam contoh di bawah kami dengan cepat mengkonversi tabel html ke format csv menggunakan nested vim macro.
<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/vim.mp4" type="video/mp4">
</video>

## Remote machines

Cara tetap waras ketika bekerja dengan mesin remote menggunakan SSH keys dan
terminal multiplexing. Tidak perlu lagi membuka banyak terminal hanya untuk
menjalankan dua perintah sekaligus. Tidak perlu lagi mengetik password setiap kali Anda
terhubung. Tidak perlu lagi kehilangan semuanya hanya karena Internet
Anda terputus atau Anda harus me-reboot laptop Anda.

Dalam contoh di bawah kami menggunakan `tmux` untuk menjaga sesi tetap hidup di server remote dan `mosh` untuk mendukung roaming jaringan dan diskoneksi.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/ssh.mp4" type="video/mp4">
</video>

## Mencari file

Cara dengan cepat menemukan file yang Anda cari. Tidak
perlu lagi mengklik melalui file-file di proyek Anda sampai Anda menemukan yang
memiliki kode yang Anda inginkan.

Dalam contoh di bawah kami dengan cepat mencari file dengan `fd` dan mencari cuplikan kode dengan `rg`. Kami juga dengan cepat `cd` dan `vim` file/folder terbaru/sering digunakan menggunakan `fasd`.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/find.mp4" type="video/mp4">
</video>

## Data wrangling

Cara dengan cepat dan mudah memodifikasi, melihat, parse, memplot, dan menghitung
data dan file langsung dari command-line. Tidak perlu lagi copy paste
dari file log. Tidak perlu lagi menghitung statistik data secara manual. Tidak
perlu lagi plotting spreadsheet.

## Kualitas kode dan continuous integration

Cara menggunakan autoformatting, linting, testing, dan code coverage tools untuk meningkatkan
kualitas kode. Tidak perlu lagi kode yang berantakan. Tidak perlu lagi regresi. Tidak perlu lagi kode yang berfungsi
di komputer Anda tetapi crash di komputer orang lain.

## Di luar kode

Cara menulis dokumentasi yang hebat, berkomunikasi dengan jelas dengan
maintainer open-source, mengirimkan issue yang dapat ditindaklanjuti, dan berkontribusi pull request yang di-merge. Tidak perlu lagi pengguna yang bingung yang tidak bisa memulai menggunakan software Anda. Tidak
perlu lagi maintainer yang menghilang.

# Kesimpulan

Ini, dan lebih banyak lagi, akan dibahas dalam 9 kuliah, masing-masing termasuk
latihan untuk Anda agar lebih familiar dengan alat-alat secara mandiri. Jika Anda tidak
sabar menunggu hingga Januari 2026, Anda juga dapat melihat kuliah dari
[penawaran kursus sebelumnya](/2020/), yang mencakup banyak topik yang sama.

Kami berharap dapat melihat Anda pada bulan Januari, baik secara virtual maupun langsung!

Happy hacking,<br>
[Anish](https://anish.io/), [Jon](https://thesquareplanet.com/), dan [Jose](https://josejg.com/)
