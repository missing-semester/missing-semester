---
layout: lecture
title: "Keamanan dan Kriptografi"
description: >
  Pelajari primitif kriptografi seperti fungsi hash dan fungsi turunan kunci, serta pahami bagaimana alat-alat seperti Git dan SSH menggunakannya.
thumbnail: /static/assets/thumbnails/2020/lec9.png
date: 2020-01-28
ready: true
video:
  aspect: 56.25
  id: tjwobAmnKTo
special: true
---

[Ceramah keamanan dan privasi](/2019/security/) tahun lalu berfokus pada bagaimana Anda
bisa lebih aman sebagai _pengguna_ komputer. Tahun ini, kita akan fokus pada konsep
keamanan dan kriptografi yang relevan untuk memahami alat-alat yang telah dibahas
sebelumnya di kelas ini, seperti penggunaan fungsi hash di Git atau fungsi turunan
kunci dan sistem kriptografi simetris/asimetris di SSH.

Ceramah ini bukan pengganti untuk kursus yang lebih ketat dan lengkap tentang
keamanan sistem komputer ([6.858](https://css.csail.mit.edu/6.858/)) atau
kriptografi ([6.857](https://courses.csail.mit.edu/6.857/) dan 6.875). Jangan
melakukan pekerjaan keamanan tanpa pelatihan formal di bidang keamanan. Kecuali
Anda seorang ahli, jangan [membuat kriptografi sendiri
](https://www.schneier.com/blog/archives/2015/05/amateurs_produc.html). Prinsip
yang sama berlaku untuk keamanan sistem.

Ceramah ini memberikan perlakuan yang sangat informal (tetapi menurut kami praktis)
terhadap konsep-konsep dasar kriptografi. Ceramah ini tidak akan cukup untuk
mengajari Anda cara _merancang_ sistem yang aman atau protokol kriptografi, tetapi
kami harap ini akan cukup untuk memberi Anda pemahaman umum tentang program dan
protokol yang sudah Anda gunakan.

# Entropi

[Entropi](https://en.wikipedia.org/wiki/Entropy_(information_theory)) adalah
ukuran keacakan. Ini berguna, misalnya, saat menentukan kekuatan sebuah kata sandi.

![XKCD 936: Password Strength](https://imgs.xkcd.com/comics/password_strength.png)

Seperti yang diilustrasikan oleh [komik XKCD](https://xkcd.com/936/) di atas, kata
sandi seperti "correcthorsebatterystaple" lebih aman daripada yang seperti
"Tr0ub4dor&3". Tetapi bagaimana Anda mengukur sesuatu seperti ini?

Entropi diukur dalam _bit_, dan saat memilih secara seragam dan acak dari
sekumpulan kemungkinan hasil, entropi sama dengan `log_2(# of possibilities)`.
Lemparan koin yang adil memberikan 1 bit entropi. Lemparan dadu (dadu 6 sisi)
memiliki entropi ~2.58 bit.

Anda harus mempertimbangkan bahwa penyerang mengetahui _model_ kata sandi, tetapi
tidak mengetahui keacakan (misalnya dari [lemparan
dadu](https://en.wikipedia.org/wiki/Diceware)) yang digunakan untuk memilih kata
sandi tertentu.

Berapa banyak bit entropi yang cukup? Tergantung pada model ancaman Anda. Untuk
penebakan online, seperti yang ditunjukkan oleh komik XKCD, ~40 bit entropi sudah
cukup baik. Untuk tahan terhadap penebakan offline, kata sandi yang lebih kuat
diperlukan (misalnya 80 bit, atau lebih).

# Fungsi hash

[Fungsi hash
kriptografi](https://en.wikipedia.org/wiki/Cryptographic_hash_function) memetakan
data berukuran sewenang-wenang ke ukuran tetap, dan memiliki beberapa properti
khusus. Spesifikasi kasar dari fungsi hash adalah sebagai berikut:

```
hash(value: array<byte>) -> vector<byte, N>  (for some fixed N)
```

Contoh fungsi hash adalah [SHA1](https://en.wikipedia.org/wiki/SHA-1), yang
digunakan di Git. Fungsi ini memetakan input berukuran sewenang-wenang ke output
160-bit (yang dapat direpresentasikan sebagai 40 karakter heksadesimal). Kita bisa
mencoba hash SHA1 pada sebuah input menggunakan perintah `sha1sum`:

```console
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'Hello' | sha1sum
f7ff9e8b7bb2e09b70935a5d785e0cc5d9d0abf0
```

Pada tingkat tinggi, fungsi hash dapat dianggap sebagai fungsi yang sulit
dibalikkan, terlihat acak (tetapi deterministik) (dan ini adalah [model ideal dari
fungsi hash](https://en.wikipedia.org/wiki/Random_oracle)). Fungsi hash memiliki
properti berikut:

- Deterministik: input yang sama selalu menghasilkan output yang sama.
- Tidak dapat dibalik: sulit untuk menemukan input `m` sedemikian rupa sehingga
  `hash(m) = h` untuk output `h` yang diinginkan.
- Tahan terhadap tabrakan target: diberikan input `m_1`, sulit untuk menemukan
  input berbeda `m_2` sedemikian rupa sehingga `hash(m_1) = hash(m_2)`.
- Tahan terhadap tabrakan: sulit untuk menemukan dua input `m_1` dan `m_2`
  sedemikian rupa sehingga `hash(m_1) = hash(m_2)` (perhatikan bahwa ini adalah
  properti yang secara ketat lebih kuat daripada tahan terhadap tabrakan target).

Catatan: meskipun mungkin berfungsi untuk tujuan tertentu, SHA-1 [tidak
lagi](https://web.archive.org/web/20260207211148/https://shattered.io/) dianggap
sebagai fungsi hash kriptografi yang kuat. Anda mungkin tertarik dengan tabel
[masa pakai fungsi hash
kriptografi](https://valerieaurora.org/hash.html) ini. Namun, perhatikan bahwa
merekomendasikan fungsi hash tertentu berada di luar ruang lingkup ceramah ini.
Jika Anda melakukan pekerjaan di mana hal ini penting, Anda memerlukan pelatihan
formal di bidang keamanan/kriptografi.

## Aplikasi

- Git, untuk penyimpanan berbasis konten. Gagasan tentang [fungsi
  hash](https://en.wikipedia.org/wiki/Hash_function) adalah konsep yang lebih umum
  (ada fungsi hash non-kriptografi). Mengapa Git menggunakan fungsi hash
  kriptografi?
- Ringkasan singkat dari isi sebuah file. Perangkat lunak sering dapat diunduh
  dari mirror (yang mungkin kurang tepercaya), misalnya ISO Linux, dan akan sangat
  bagus jika tidak perlu mempercayai mereka. Situs-situs resmi biasanya memposting
  hash di samping tautan unduhan (yang menunjuk ke mirror pihak ketiga), sehingga
  hash dapat diperiksa setelah mengunduh file.
- [Skema komitmen](https://en.wikipedia.org/wiki/Commitment_scheme). Misalkan Anda
  ingin berkomitmen pada nilai tertentu, tetapi mengungkapkan nilai itu sendiri
  nanti. Misalnya, saya ingin melakukan lemparan koin yang adil "di kepala saya",
  tanpa koin bersama yang tepercaya yang dapat dilihat oleh dua pihak. Saya bisa
  memilih nilai `r = random()`, dan kemudian membagikan `h = sha256(r)`. Kemudian,
  Anda bisa memilih heads atau tails (kita akan sepakat bahwa `r` genap berarti
  heads, dan `r` ganjil berarti tails). Setelah Anda memilih, saya bisa
  mengungkapkan nilai `r` saya, dan Anda bisa memastikan bahwa saya tidak curang
  dengan memeriksa `sha256(r)` cocok dengan hash yang saya bagikan sebelumnya.

# Fungsi turunan kunci

Konsep yang terkait dengan fungsi hash kriptografi, [fungsi turunan
key](https://en.wikipedia.org/wiki/Key_derivation_function) (KDF) digunakan untuk
sejumlah aplikasi, termasuk menghasilkan output dengan panjang tetap untuk
digunakan sebagai kunci di algoritma kriptografi lainnya. Biasanya, KDF sengaja
dibuat lambat, untuk memperlambat serangan brute-force offline.

## Aplikasi

- Menghasilkan kunci dari frasa sandi untuk digunakan di algoritma kriptografi
  lainnya (misalnya kriptografi simetris, lihat di bawah).
- Menyimpan kredensial login. Menyimpan kata sandi dalam bentuk teks biasa adalah
  hal yang buruk; pendekatan yang tepat adalah menghasilkan dan menyimpan
  [salt](https://en.wikipedia.org/wiki/Salt_(cryptography)) acak `salt = random()`
  untuk setiap pengguna, menyimpan `KDF(password + salt)`, dan memverifikasi upaya
  login dengan menghitung ulang KDF berdasarkan kata sandi yang dimasukkan dan salt
  yang disimpan.

# Kriptografi simetris

Menyembunyikan isi pesan mungkin adalah konsep pertama yang Anda pikirkan ketika
berpikir tentang kriptografi. Kriptografi simetris mencapai ini dengan
fungsionalitas berikut:

```
keygen() -> key  (this function is randomized)

encrypt(plaintext: array<byte>, key) -> array<byte>  (the ciphertext)
decrypt(ciphertext: array<byte>, key) -> array<byte>  (the plaintext)
```

Fungsi encrypt memiliki properti bahwa diberikan output (ciphertext), sulit untuk
menentukan input (plaintext) tanpa kunci. Fungsi decrypt memiliki properti
kebenaran yang jelas, yaitu `decrypt(encrypt(m, k), k) = m`.

Contoh sistem kriptografi simetris yang banyak digunakan saat ini adalah
[AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard).

## Aplikasi

- Mengenkripsi file untuk disimpan di layanan cloud yang tidak tepercaya. Ini
  dapat dikombinasikan dengan KDF, sehingga Anda dapat mengenkripsi file dengan
  frasa sandi. Hasilkan `key = KDF(passphrase)`, dan kemudian simpan
  `encrypt(file, key)`.

# Kriptografi asimetris

Istilah "asimetris" mengacu pada adanya dua kunci, dengan dua peran berbeda. Kunci
pribadi, sesuai namanya, dimaksudkan untuk dirahasiakan, sementara kunci publik
dapat dibagikan secara publik dan tidak akan memengaruhi keamanan (berbeda dengan
berbagi kunci di sistem kriptografi simetris). Sistem kriptografi asimetris
menyediakan fungsionalitas berikut, untuk mengenkripsi/deskripsi dan
menandatangani/memverifikasi:

```
keygen() -> (public key, private key)  (this function is randomized)

encrypt(plaintext: array<byte>, public key) -> array<byte>  (the ciphertext)
decrypt(ciphertext: array<byte>, private key) -> array<byte>  (the plaintext)

sign(message: array<byte>, private key) -> array<byte>  (the signature)
verify(message: array<byte>, signature: array<byte>, public key) -> bool  (whether or not the signature is valid)
```

Fungsi encrypt/decrypt memiliki properti yang mirip dengan analog mereka dari
sistem kriptografi simetris. Sebuah pesan dapat dienkripsi menggunakan kunci
_publik_. Diberikan output (ciphertext), sulit untuk menentukan input (plaintext)
tanpa kunci _pribadi_. Fungsi decrypt memiliki properti kebenaran yang jelas, yaitu
`decrypt(encrypt(m, public key), private key) = m`.

Enkripsi simetris dan asimetris dapat dibandingkan dengan kunci fisik. Sistem
kriptografi simetris seperti kunci pintu: siapa pun dengan kunci dapat mengunci
dan membukanya. Enkripsi asimetris seperti gembok dengan kunci. Anda bisa
memberikan gembok yang tidak terkunci kepada seseorang (kunci publik), mereka bisa
menaruh pesan di dalam kotak dan kemudian memasang gemboknya, dan setelah itu,
hanya Anda yang bisa membuka gemboknya karena Anda menyimpan kuncinya (kunci
pribadi).

Fungsi sign/verify memiliki properti yang sama dengan yang Anda harapkan dari
tanda tangan fisik, yaitu sulit untuk memalsukan tanda tangan. Tidak peduli
pesannya, tanpa kunci _pribadi_, sulit untuk menghasilkan tanda tangan sedemikian
rupa sehingga `verify(message, signature, public key)` mengembalikan true. Dan
tentu saja, fungsi verify memiliki properti kebenaran yang jelas yaitu
`verify(message, sign(message, private key), public key) = true`.

## Aplikasi

- [Enkripsi email PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy). Orang
  dapat memposting kunci publik mereka secara online (misalnya di PGP keyserver,
  atau di [Keybase](https://keybase.io/)). Siapa pun dapat mengirimi mereka email
  terenkripsi.
- Pesan pribadi. Aplikasi seperti [Signal](https://signal.org/) dan
  [Keybase](https://keybase.io/) menggunakan kunci asimetris untuk membentuk
  saluran komunikasi pribadi.
- Menandatangani perangkat lunak. Git dapat memiliki commit dan tag yang
  ditandatangani GPG. Dengan kunci publik yang diposting, siapa pun dapat
  memverifikasi keaslian perangkat lunak yang diunduh.

## Distribusi kunci

Kriptografi kunci asimetris sangat luar biasa, tetapi memiliki tantangan besar
dalam mendistribusikan kunci publik / memetakan kunci publik ke identitas dunia
nyata. Ada banyak solusi untuk masalah ini. Signal memiliki satu solusi sederhana:
trust on first use, dan mendukung pertukaran kunci publik di luar saluran (Anda
memverifikasi "safety numbers" teman-teman Anda secara langsung). PGP memiliki
solusi berbeda, yaitu [web of
trust](https://en.wikipedia.org/wiki/Web_of_trust). Keybase memiliki solusi lain
lagi yaitu [social
proof](https://keybase.io/blog/chat-apps-softer-than-tofu) (bersama dengan ide-ide
menarik lainnya). Setiap model memiliki kelebihannya masing-masing; kami (para
instruktur) menyukai model Keybase.

# Studi kasus

## Pengelola kata sandi

Ini adalah alat penting yang harus dicoba digunakan oleh semua orang (misalnya
[KeePassXC](https://keepassxc.org/),
[pass](https://git.zx2c4.com/password-store/about/), dan
[1Password](https://1password.com)). Pengelola kata sandi memudahkan penggunaan
kata sandi unik yang dihasilkan secara acak dengan entropi tinggi untuk semua login
Anda, dan mereka menyimpan semua kata sandi Anda di satu tempat, dienkripsi dengan
cipher simetris dengan kunci yang dihasilkan dari frasa sandi menggunakan KDF.

Menggunakan pengelola kata sandi memungkinkan Anda menghindari penggunaan ulang
kata sandi (sehingga Anda lebih tidak terdampak ketika situs web diretas),
menggunakan kata sandi dengan entropi tinggi (sehingga Anda lebih kecil
kemungkinannya untuk diretas), dan hanya perlu mengingat satu kata sandi dengan
entropi tinggi.

## Autentikasi dua faktor

[Autentikasi dua
faktor](https://en.wikipedia.org/wiki/Multi-factor_authentication) (2FA)
mewajibkan Anda menggunakan frasa sandi ("something you know") bersama dengan
autentikator 2FA (seperti [YubiKey](https://www.yubico.com/), "something you have")
untuk melindungi dari kata sandi yang dicuri dan serangan
[phishing](https://en.wikipedia.org/wiki/Phishing).

## Enkripsi disk penuh

Menjaga seluruh disk laptop Anda terenkripsi adalah cara mudah untuk melindungi
data Anda jika laptop Anda dicuri. Anda dapat menggunakan [cryptsetup +
LUKS](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_a_non-root_file_system)
di Linux,
[BitLocker](https://fossbytes.com/enable-full-disk-encryption-windows-10/) di
Windows, atau [FileVault](https://support.apple.com/en-us/HT204837) di macOS. Ini
mengenkripsi seluruh disk dengan cipher simetris, dengan kunci yang dilindungi
oleh frasa sandi.

## Pesan pribadi

Gunakan [Signal](https://signal.org/) atau [Keybase](https://keybase.io/).
Keamanan end-to-end di-bootstrap dari enkripsi kunci asimetris. Mendapatkan kunci
publik kontak Anda adalah langkah kritis di sini. Jika Anda ingin keamanan yang
baik, Anda perlu mengautentikasi kunci publik di luar saluran (dengan Signal atau
Keybase), atau mempercayai social proofs (dengan Keybase).

## SSH

Kita telah membahas penggunaan SSH dan kunci SSH di [ceramah
sebelumnya](/2020/command-line/#remote-machines). Mari kita lihat aspek
kriptografi dari hal ini.

Ketika Anda menjalankan `ssh-keygen`, ini menghasilkan pasangan kunci asimetris,
`public_key, private_key`. Ini dihasilkan secara acak, menggunakan entropi yang
disediakan oleh sistem operasi (dikumpulkan dari event perangkat keras, dll.).
Kunci publik disimpan apa adanya (ini publik, jadi menjaganya tetap rahasia bukan
hal yang penting), tetapi saat diam, kunci pribadi harus dienkripsi di disk.
Program `ssh-keygen` meminta pengguna untuk memasukkan frasa sandi, dan ini
dimasukkan melalui fungsi turunan kunci untuk menghasilkan kunci, yang kemudian
digunakan untuk mengenkripsi kunci pribadi dengan cipher simetris.

Dalam penggunaan, setelah server mengetahui kunci publik klien (disimpan di file
`.ssh/authorized_keys`), klien yang terhubung dapat membuktikan identitasnya
menggunakan tanda tangan asimetris. Ini dilakukan melalui
[challenge-response](https://en.wikipedia.org/wiki/Challenge%E2%80%93response_authentication).
Pada tingkat tinggi, server memilih angka acak dan mengirimkannya ke klien. Klien
kemudian menandatangani pesan ini dan mengirim tanda tangan kembali ke server, yang
memeriksa tanda tangan terhadap kunci publik yang tercatat. Ini secara efektif
membuktikan bahwa klien memiliki kunci pribadi yang sesuai dengan kunci publik yang
ada di file `.ssh/authorized_keys` server, sehingga server dapat mengizinkan klien
untuk login.

{% comment %}
extra topics, if there's time

security concepts, tips
- biometrics
- HTTPS
{% endcomment %}

# Sumber daya

- [Catatan tahun lalu](/2019/security/): dari ketika ceramah ini lebih berfokus
  pada keamanan dan privasi sebagai pengguna komputer
- [Cryptographic Right
  Answers](https://latacora.micro.blog/2018/04/03/cryptographic-right-answers.html):
  menjawab "kriptografi apa yang harus saya gunakan untuk X?" untuk banyak X yang
  umum.

# Latihan

1. **Entropi.**
    1. Misalkan sebuah kata sandi dipilih sebagai gabungan dari empat kata kamus
       huruf kecil, di mana setiap kata dipilih secara seragam dan acak dari kamus
       berukuran 100.000. Contoh kata sandi seperti ini adalah
       `correcthorsebatterystaple`. Berapa banyak bit entropi yang dimilikinya?
    1. Pertimbangkan skema alternatif di mana kata sandi dipilih sebagai urutan 8
       karakter alfanumerik acak (termasuk huruf kecil dan huruf besar). Contoh:
       `rg8Ql34g`. Berapa banyak bit entropi yang dimilikinya?
    1. Mana yang merupakan kata sandi yang lebih kuat?
    1. Misalkan seorang penyerang dapat mencoba menebak 10.000 kata sandi per
       detik. Secara rata-rata, berapa lama waktu yang dibutuhkan untuk memecahkan
       masing-masing kata sandi?
1. **Fungsi hash kriptografi.** Unduh image Debian dari
   [mirror](https://www.debian.org/CD/http-ftp/) (misalnya [dari mirror Argentina
   ini](http://debian.xfree.com.ar/debian-cd/current/amd64/iso-cd/)).
   Periksa silang hash (misalnya menggunakan perintah `sha256sum`) dengan hash
   yang diambil dari situs Debian resmi (misalnya [file
   ini](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS)
   yang di-host di `debian.org`, jika Anda telah mengunduh file yang ditautkan
   dari mirror Argentina).
1. **Kriptografi simetris.** Enkripsi sebuah file dengan enkripsi AES, menggunakan
   [OpenSSL](https://www.openssl.org/): `openssl aes-256-cbc -salt -in {input
   filename} -out {output filename}`. Lihat isinya menggunakan `cat` atau
   `hexdump`. Dekripsi dengan `openssl aes-256-cbc -d -in {input filename} -out
   {output filename}` dan konfirmasi bahwa isinya cocok dengan aslinya menggunakan
   `cmp`.
1. **Kriptografi asimetris.**
    1. Siapkan [kunci
       SSH](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
       di komputer yang Anda miliki aksesnya (bukan Athena, karena Kerberos
       berinteraksi secara aneh dengan kunci SSH). Pastikan kunci pribadi Anda
       dienkripsi dengan frasa sandi, sehingga terlindungi saat diam.
    1. [Siapkan GPG](https://www.digitalocean.com/community/tutorials/how-to-use-gpg-to-encrypt-and-sign-messages)
    1. Kirim email terenkripsi ke Anish ([kunci
       publik](https://keybase.io/anish)).
    1. Tandatangani commit Git dengan `git commit -S` atau buat tag Git yang
       ditandatangani dengan `git tag -s`. Verifikasi tanda tangan pada commit
       dengan `git show --show-signature` atau pada tag dengan `git tag -v`.
