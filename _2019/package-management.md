---
layout: lecture
title: "Manajemen Paket dan Manajemen Dependensi"
presenter: Anish
date: 2019-01-29
order: 2
video:
  aspect: 56.25
  id: tgvt473T8xA
---

Perangkat lunak biasanya dibangun dari (kumpulan) perangkat lunak lain, yang membuat manajemen dependensi menjadi diperlukan.

Program manajemen paket/dependensi bersifat spesifik per bahasa, tetapi banyak yang memiliki gagasan yang sama.

# Repositori paket

Paket di-host di _repositori paket_. Terdapat repositori yang berbeda untuk bahasa yang berbeda (dan terkadang ada beberapa untuk bahasa tertentu), seperti [PyPI](https://pypi.org/) untuk Python, [RubyGems](https://rubygems.org/) untuk Ruby, dan [crates.io](https://crates.io/) untuk Rust. Repositori-repositori ini umumnya menyimpan perangkat lunak (kode sumber dan terkadang biner pra-kompilasi untuk platform tertentu) untuk semua versi suatu paket.

# Versi semantik

Perangkat lunak berkembang seiring waktu, dan kita membutuhkan cara untuk merujuk pada versi perangkat lunak. Beberapa cara sederhana adalah merujuk perangkat lunak berdasarkan nomor urutan atau hash commit, tetapi kita bisa melakukan lebih baik dalam hal menyampaikan lebih banyak informasi: menggunakan nomor versi.

Ada banyak pendekatan; salah satu yang populer adalah [Semantic Versioning](https://semver.org/):

```
x.y.z
^ ^ ^
| | +- patch
| +--- minor
+----- major
```

Naikkan versi **major** ketika Anda membuat perubahan API yang tidak kompatibel.

Naikkan versi **minor** ketika Anda menambahkan fungsionalitas yang kompatibel ke belakang.

Naikkan **patch** ketika Anda memperbaiki bug yang kompatibel ke belakang.

Sebagai contoh, jika Anda bergantung pada fitur yang diperkenalkan di `v1.2.0` dari suatu perangkat lunak, maka Anda dapat menginstal `v1.x.y` untuk versi minor `x >= 2` dan versi patch `y` berapa pun. Anda perlu menginstal versi major `1` (karena `2` dapat memperkenalkan perubahan yang tidak kompatibel ke belakang), dan Anda perlu menginstal versi minor `>= 2` (karena Anda bergantung pada fitur yang diperkenalkan di versi minor tersebut). Anda dapat menggunakan versi minor atau versi patch yang lebih baru karena seharusnya tidak memperkenalkan perubahan yang tidak kompatibel ke belakang.

# File kunci

Selain menentukan versi, akan sangat berguna untuk memastikan bahwa _isi_ dependensi tidak berubah untuk mencegah perubahan yang tidak sah. Beberapa alat menggunakan _lock files_ untuk menentukan hash kriptografis dari dependensi (bersama dengan versi) yang diperiksa saat instalasi paket.

# Menentukan versi

Alat-alat sering kali memungkinkan Anda menentukan versi dalam beberapa cara, seperti:

- versi tepat, misalnya `2.3.12`
- versi major minimum, misalnya `>= 2`
- versi major tertentu dan versi patch minimum, misalnya `>= 2.3, <3.0`

Menentukan versi yang tepat bisa menguntungkan untuk menghindari perilaku yang berbeda tergantung pada dependensi yang terinstal (ini seharusnya tidak terjadi jika semua dependensi mengikuti semver dengan setia, tetapi terkadang orang melakukan kesalahan). Menentukan persyaratan minimum memiliki keuntungan karena memungkinkan perbaikan bug untuk diinstal (misalnya pembaruan patch).

# Resolusi dependensi

Manajer paket menggunakan berbagai algoritma resolusi dependensi untuk memenuhi persyaratan dependensi. Hal ini sering kali menjadi menantang dengan dependensi yang kompleks (misalnya sebuah paket dapat secara tidak langsung dibutuhkan oleh beberapa dependensi tingkat atas, dan versi yang berbeda mungkin diperlukan). Manajer paket yang berbeda memiliki tingkat kecanggihan yang berbeda dalam resolusi dependensi mereka, tetapi ini perlu diperhatikan: Anda mungkin perlu memahaminya jika Anda melakukan debug dependensi.

# Lingkungan virtual

Jika Anda mengembangkan beberapa proyek perangkat lunak, mereka mungkin bergantung pada versi yang berbeda dari suatu perangkat lunak. Terkadang, alat build Anda akan menangani hal ini secara alami (misalnya dengan membangun biner statis).

Untuk alat build dan bahasa pemrograman lain, salah satu pendekatan adalah menangani ini dengan lingkungan virtual (misalnya dengan alat [virtualenv](https://docs.python-guide.org/dev/virtualenvs/) untuk Python). Alih-alih menginstal dependensi secara sistem-wide, Anda dapat menginstal dependensi per-proyek di dalam lingkungan virtual, dan _mengaktifkan_ lingkungan virtual yang ingin Anda gunakan saat mengerjakan proyek tertentu.

# Vendoring

Pendekatan lain yang sangat berbeda untuk manajemen dependensi adalah _vendoring_. Alih-alih menggunakan manajer dependensi atau alat build untuk mengambil perangkat lunak, Anda menyalin seluruh kode sumber dependensi ke repositori perangkat lunak Anda. Ini memiliki keuntungan karena Anda selalu membangun terhadap versi dependensi yang sama dan Anda tidak perlu mengandalkan repositori paket, tetapi memerlukan lebih banyak usaha untuk meningkatkan dependensi.
