---
layout: lecture
title: "Keamanan dan Kriptografi"
description: >
  Pelajari primitif kriptografi seperti hash dan key derivation functions, serta pahami bagaimana tools seperti Git dan SSH menggunakannya.
thumbnail: /static/assets/thumbnails/2020/lec9.png
date: 2020-01-28
ready: true
video:
  aspect: 56.25
  id: tjwobAmnKTo
special: true
---

[Ceramah keamanan dan privasi tahun lalu](/2019/security/) berfokus pada bagaimana Anda bisa lebih aman sebagai _pengguna_ komputer. Tahun ini, kita akan berfokus pada konsep keamanan dan kriptografi yang relevan untuk memahami tools yang telah dibahas sebelumnya di kelas ini, seperti penggunaan hash functions di Git atau key derivation functions dan symmetric/asymmetric cryptosystems di SSH.

Ceramah ini bukan pengganti untuk kursus yang lebih ketat dan lengkap tentang keamanan sistem komputer ([6.858](https://css.csail.mit.edu/6.858/)) atau kriptografi ([6.857](https://courses.csail.mit.edu/6.857/) dan 6.875). Jangan melakukan pekerjaan keamanan tanpa pelatihan formal di bidang keamanan. Kecuali Anda seorang ahli, jangan [membuat kriptografi sendiri](https://www.schneier.com/blog/archives/2015/05/amateurs_produc.html). Prinsip yang sama berlaku untuk keamanan sistem.

Ceramah ini memberikan perlakuan yang sangat informal (tetapi menurut kami praktis) terhadap konsep-konsep dasar kriptografi. Ceramah ini tidak akan cukup untuk mengajari Anda cara _merancang_ sistem yang aman atau protokol kriptografi, tetapi kami harap ini akan cukup untuk memberi Anda pemahaman umum tentang program dan protokol yang sudah Anda gunakan.

# Entropy

[Entropy](https://en.wikipedia.org/wiki/Entropy_(information_theory)) adalah ukuran keacakan. Ini berguna, misalnya, saat menentukan kekuatan sebuah password.

![XKCD 936: Password Strength](https://imgs.xkcd.com/comics/password_strength.png)

Seperti yang diilustrasikan oleh [komik XKCD](https://xkcd.com/936/) di atas, password seperti "correcthorsebatterystaple" lebih aman daripada yang seperti "Tr0ub4dor&3". Tetapi bagaimana Anda mengukur sesuatu seperti ini?

Entropy diukur dalam _bit_, dan saat memilih secara seragam dan acak dari sekumpulan kemungkinan hasil, entropy sama dengan `log_2(# of possibilities)`. Lemparan koin yang adil menghasilkan 1 bit entropy. Lemparan dadu (dadu 6 sisi) memiliki \~2.58 bit entropy.

Anda harus menganggap bahwa penyerang mengetahui _model_ dari password tersebut, tetapi bukan keacakannya (misalnya dari [lemparan dadu](https://en.wikipedia.org/wiki/Diceware)) yang digunakan untuk memilih password tertentu.

Berapa banyak bit entropy yang cukup? Tergantung pada model ancaman Anda. Untuk penebakan online, seperti yang ditunjukkan oleh komik XKCD, \~40 bit entropy sudah cukup bagus. Untuk tahan terhadap penebakan offline, password yang lebih kuat akan diperlukan (misalnya 80 bit, atau lebih).

# Hash functions

Sebuah [cryptographic hash function](https://en.wikipedia.org/wiki/Cryptographic_hash_function) memetakan data berukuran sembarang ke ukuran yang tetap, dan memiliki beberapa properti khusus. Spesifikasi kasar dari sebuah hash function adalah sebagai berikut:

```
hash(value: array<byte>) -> vector<byte, N>  (for some fixed N)
```

Contoh dari hash function adalah [SHA1](https://en.wikipedia.org/wiki/SHA-1), yang digunakan di Git. Ia memetakan input berukuran sembarang ke output 160-bit (yang dapat direpresentasikan sebagai 40 karakter heksadesimal). Kita bisa mencoba hash SHA1 pada sebuah input menggunakan perintah `sha1sum`:

```console
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'Hello' | sha1sum
f7ff9e8b7bb2e09b70935a5d785e0cc5d9d0abf0
```

Pada tingkat tinggi, sebuah hash function dapat dianggap sebagai fungsi yang sulit dibalik, terlihat acak (tetapi deterministik) (dan ini adalah [model ideal dari hash function](https://en.wikipedia.org/wiki/Random_oracle)). Sebuah hash function memiliki properti-properti berikut:

- Deterministik: input yang sama selalu menghasilkan output yang sama.
- Non-invertible: sulit untuk menemukan sebuah input `m` sedemikian sehingga `hash(m) = h` untuk output yang diinginkan `h`.
- Target collision resistant: diberikan sebuah input `m_1`, sulit untuk menemukan input yang berbeda `m_2` sedemikian sehingga `hash(m_1) = hash(m_2)`.
- Collision resistant: sulit untuk menemukan dua input `m_1` dan `m_2` sedemikian sehingga `hash(m_1) = hash(m_2)` (perhatikan bahwa ini adalah properti yang secara ketat lebih kuat daripada target collision resistance).

Catatan: meskipun mungkin berfungsi untuk tujuan tertentu, SHA-1 [tidak lagi](https://web.archive.org/web/20260207211148/https://shattered.io/) dianggap sebagai cryptographic hash function yang kuat. Anda mungkin menemukan tabel [umur dari cryptographic hash functions](https://valerieaurora.org/hash.html) ini menarik. Namun, perhatikan bahwa merekomendasikan hash function tertentu berada di luar cakupan ceramah ini. Jika Anda melakukan pekerjaan di mana hal ini penting, Anda memerlukan pelatihan formal di bidang keamanan/kriptografi.

## Aplikasi

- Git, untuk penyimpanan yang di-address oleh konten. Gagasan dari sebuah [hash function](https://en.wikipedia.org/wiki/Hash_function) adalah konsep yang lebih umum (ada hash functions yang non-kriptografis). Mengapa Git menggunakan cryptographic hash function?
- Ringkasan singkat dari isi sebuah file. Perangkat lunak sering kali dapat diunduh dari mirror (yang mungkin kurang tepercaya), misalnya ISO Linux, dan akan sangat bagus jika tidak perlu mempercayai mereka. Situs-situs resmi biasanya memposting hash di samping tautan unduhan (yang menunjuk ke mirror pihak ketiga), sehingga hash dapat diperiksa setelah mengunduh sebuah file.
- [Commitment schemes](https://en.wikipedia.org/wiki/Commitment_scheme). Misalkan Anda ingin melakukan commitment pada nilai tertentu, tetapi mengungkapkan nilai itu sendiri nanti. Misalnya, saya ingin melakukan lemparan koin yang adil "di kepala saya", tanpa koin bersama yang tepercaya yang dapat dilihat oleh dua pihak. Saya bisa memilih sebuah nilai `r = random()`, dan kemudian membagikan `h = sha256(r)`. Kemudian, Anda bisa memilih heads atau tails (kita sepakat bahwa `r` genap berarti heads, dan `r` ganjil berarti tails). Setelah Anda memilih, saya bisa mengungkapkan nilai saya `r`, dan Anda bisa memastikan bahwa saya tidak curang dengan memeriksa `sha256(r)` cocok dengan hash yang saya bagikan sebelumnya.

# Key derivation functions

Konsep yang terkait dengan cryptographic hashes, [key derivation functions](https://en.wikipedia.org/wiki/Key_derivation_function) (KDFs) digunakan untuk sejumlah aplikasi, termasuk menghasilkan output dengan panjang tetap untuk digunakan sebagai key di algoritma kriptografi lainnya. Biasanya, KDFs sengaja dibuat lambat, untuk memperlambat serangan brute-force secara offline.

## Aplikasi

- Menghasilkan key dari passphrase untuk digunakan di algoritma kriptografi lainnya (misalnya symmetric cryptography, lihat di bawah).
- Menyimpan kredensial login. Menyimpan password dalam plaintext sangat buruk; pendekatan yang benar adalah menghasilkan dan menyimpan [salt](https://en.wikipedia.org/wiki/Salt_(cryptography)) acak `salt = random()` untuk setiap pengguna, menyimpan `KDF(password + salt)`, dan memverifikasi upaya login dengan menghitung ulang KDF berdasarkan password yang dimasukkan dan salt yang disimpan.

# Symmetric cryptography

Menyembunyikan isi pesan mungkin adalah konsep pertama yang Anda pikirkan ketika memikirkan kriptografi. Symmetric cryptography mencapai ini dengan kumpulan fungsionalitas berikut:

```
keygen() -> key  (this function is randomized)

encrypt(plaintext: array<byte>, key) -> array<byte>  (the ciphertext)
decrypt(ciphertext: array<byte>, key) -> array<byte>  (the plaintext)
```

Fungsi encrypt memiliki properti bahwa diberikan output (ciphertext), sulit untuk menentukan input (plaintext) tanpa key. Fungsi decrypt memiliki properti kebenaran yang jelas, yaitu `decrypt(encrypt(m, k), k) = m`.

Contoh dari symmetric cryptosystem yang banyak digunakan saat ini adalah [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard).

## Aplikasi

- Mengenkripsi file untuk penyimpanan di layanan cloud yang tidak tepercaya. Ini dapat dikombinasikan dengan KDFs, sehingga Anda dapat mengenkripsi file dengan passphrase. Hasilkan `key = KDF(passphrase)`, dan kemudian simpan `encrypt(file, key)`.

# Asymmetric cryptography

Istilah "asymmetric" mengacu pada adanya dua key, dengan dua peran yang berbeda. Private key, sesuai namanya, dimaksudkan untuk dijaga kerahasiaannya, sedangkan public key dapat dibagikan secara publik dan tidak akan memengaruhi keamanan (berbeda dengan berbagi key dalam symmetric cryptosystem). Asymmetric cryptosystems menyediakan kumpulan fungsionalitas berikut, untuk mengenkripsi/dekripsi dan menandatangani/memverifikasi:

```
keygen() -> (public key, private key)  (this function is randomized)

encrypt(plaintext: array<byte>, public key) -> array<byte>  (the ciphertext)
decrypt(ciphertext: array<byte>, private key) -> array<byte>  (the plaintext)

sign(message: array<byte>, private key) -> array<byte>  (the signature)
verify(message: array<byte>, signature: array<byte>, public key) -> bool  (whether or not the signature is valid)
```

Fungsi encrypt/decrypt memiliki properti yang mirip dengan analognya dari symmetric cryptosystems. Sebuah pesan dapat dienkripsi menggunakan _public_ key. Diberikan output (ciphertext), sulit untuk menentukan input (plaintext) tanpa _private_ key. Fungsi decrypt memiliki properti kebenaran yang jelas, yaitu `decrypt(encrypt(m, public key), private key) = m`.

Symmetric dan asymmetric encryption dapat dibandingkan dengan kunci fisik. Sebuah symmetric cryptosystem seperti kunci pintu: siapa pun yang memiliki key dapat mengunci dan membukanya. Asymmetric encryption seperti gembok dengan kunci. Anda bisa memberikan gembok yang tidak terkunci kepada seseorang (public key), mereka bisa menaruh pesan di dalam kotak dan kemudian memasang gemboknya, dan setelah itu, hanya Anda yang bisa membuka gembok tersebut karena Anda menyimpan kuncinya (private key).

Fungsi sign/verify memiliki properti yang sama yang Anda harapkan dari tanda tangan fisik, yaitu sulit untuk memalsukan tanda tangan. Tidak peduli pesannya, tanpa _private_ key, sulit untuk menghasilkan tanda tangan sedemikian sehingga `verify(message, signature, public key)` mengembalikan true. Dan tentu saja, fungsi verify memiliki properti kebenaran yang jelas yaitu `verify(message, sign(message, private key), public key) = true`.

## Aplikasi

- [Enkripsi email PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy). Orang-orang dapat memposting public key mereka secara online (misalnya di PGP keyserver, atau di [Keybase](https://keybase.io/)). Siapa pun dapat mengirimi mereka email terenkripsi.
- Pesan pribadi. Aplikasi seperti [Signal](https://signal.org/) dan [Keybase](https://keybase.io/) menggunakan asymmetric keys untuk mendirikan saluran komunikasi pribadi.
- Menandatangani perangkat lunak. Git dapat memiliki commit dan tag yang ditandatangani GPG. Dengan public key yang diposting, siapa pun dapat memverifikasi keaslian perangkat lunak yang diunduh.

## Distribusi key

Asymmetric-key cryptography sangat luar biasa, tetapi memiliki tantangan besar dalam mendistribusikan public key / memetakan public key ke identitas dunia nyata. Ada banyak solusi untuk masalah ini. Signal memiliki satu solusi sederhana: trust on first use, dan mendukung pertukaran public key secara out-of-band (Anda memverifikasi "safety numbers" teman-teman Anda secara langsung). PGP memiliki solusi yang berbeda, yaitu [web of trust](https://en.wikipedia.org/wiki/Web_of_trust). Keybase memiliki solusi lain lagi yaitu [social proof](https://keybase.io/blog/chat-apps-softer-than-tofu) (bersama dengan ide-ide menarik lainnya). Setiap model memiliki kelebihannya masing-masing; kami (para instruktur) menyukai model Keybase.

# Studi kasus

## Password manager

Ini adalah tool esensial yang seharusnya dicoba digunakan oleh semua orang (misalnya [KeePassXC](https://keepassxc.org/), [pass](https://git.zx2c4.com/password-store/about/), dan [1Password](https://1password.com)). Password manager memudahkan penggunaan password yang unik, dihasilkan secara acak dengan entropy tinggi untuk semua login Anda, dan mereka menyimpan semua password Anda di satu tempat, dienkripsi dengan symmetric cipher dengan key yang dihasilkan dari passphrase menggunakan KDF.

Menggunakan password manager memungkinkan Anda menghindari penggunaan ulang password (sehingga Anda lebih tidak terdampak ketika situs web diretas), menggunakan password dengan entropy tinggi (sehingga Anda lebih kecil kemungkinannya untuk diretas), dan hanya perlu mengingat satu password dengan entropy tinggi.

## Autentikasi dua faktor

[Two-factor authentication](https://en.wikipedia.org/wiki/Multi-factor_authentication) (2FA) mengharuskan Anda menggunakan passphrase ("something you know") bersama dengan authenticator 2FA (seperti [YubiKey](https://www.yubico.com/), "something you have") untuk melindungi dari pencurian password dan serangan [phishing](https://en.wikipedia.org/wiki/Phishing).

## Enkripsi disk penuh

Menjaga seluruh disk laptop Anda terenkripsi adalah cara mudah untuk melindungi data Anda jika laptop Anda dicuri. Anda dapat menggunakan [cryptsetup + LUKS](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_a_non-root_file_system) di Linux, [BitLocker](https://fossbytes.com/enable-full-disk-encryption-windows-10/) di Windows, atau [FileVault](https://support.apple.com/en-us/HT204837) di macOS. Ini mengenkripsi seluruh disk dengan symmetric cipher, dengan key yang dilindungi oleh passphrase.

## Pesan pribadi

Gunakan [Signal](https://signal.org/) atau [Keybase](https://keybase.io/). Keamanan end-to-end dimulai dari asymmetric-key encryption. Mendapatkan public key kontak Anda adalah langkah kritis di sini. Jika Anda menginginkan keamanan yang baik, Anda perlu mengautentikasi public key secara out-of-band (dengan Signal atau Keybase), atau mempercayai social proofs (dengan Keybase).

## SSH

Kita telah membahas penggunaan SSH dan SSH keys di [ceramah sebelumnya](/2020/command-line/#remote-machines). Mari kita lihat aspek kriptografi dari hal ini.

Ketika Anda menjalankan `ssh-keygen`, ia menghasilkan asymmetric key pair, `public_key, private_key`. Ini dihasilkan secara acak, menggunakan entropy yang disediakan oleh sistem operasi (dikumpulkan dari event hardware, dll.). Public key disimpan apa adanya (ini publik, jadi menjaganya tetap rahasia tidak penting), tetapi saat disimpan, private key harus dienkripsi di disk. Program `ssh-keygen` meminta passphrase kepada pengguna, dan ini dimasukkan melalui key derivation function untuk menghasilkan key, yang kemudian digunakan untuk mengenkripsi private key dengan symmetric cipher.

Dalam penggunaan, setelah server mengetahui public key klien (disimpan di file `.ssh/authorized_keys`), klien yang terhubung dapat membuktikan identitasnya menggunakan asymmetric signatures. Ini dilakukan melalui [challenge-response](https://en.wikipedia.org/wiki/Challenge%E2%80%93response_authentication). Pada tingkat tinggi, server memilih angka acak dan mengirimkannya ke klien. Klien kemudian menandatangani pesan ini dan mengirim tanda tangan kembali ke server, yang memeriksa tanda tangan terhadap public key yang tercatat. Ini secara efektif membuktikan bahwa klien memiliki private key yang sesuai dengan public key yang ada di file `.ssh/authorized_keys` server, sehingga server dapat mengizinkan klien untuk login.

{% comment %}
extra topics, if there's time

security concepts, tips
- biometrics
- HTTPS
{% endcomment %}

# Sumber daya

- [Catatan tahun lalu](/2019/security/): dari ketika ceramah ini lebih berfokus pada keamanan dan privasi sebagai pengguna komputer
- [Cryptographic Right Answers](https://latacora.micro.blog/2018/04/03/cryptographic-right-answers.html): menjawab "kriptografi apa yang harus saya gunakan untuk X?" untuk banyak X yang umum.

# Latihan

1. **Entropy.**
    1. Misalkan sebuah password dipilih sebagai gabungan dari empat kata kamus huruf kecil, di mana setiap kata dipilih secara seragam dan acak dari kamus berukuran 100.000. Contoh password seperti ini adalah `correcthorsebatterystaple`. Berapa banyak bit entropy yang dimilikinya?
    1. Pertimbangkan skema alternatif di mana password dipilih sebagai urutan 8 karakter alfanumerik acak (termasuk huruf kecil dan huruf besar). Contohnya adalah `rg8Ql34g`. Berapa banyak bit entropy yang dimilikinya?
    1. Mana yang merupakan password lebih kuat?
    1. Misalkan seorang penyerang dapat mencoba menebak 10.000 password per detik. Secara rata-rata, berapa lama waktu yang dibutuhkan untuk memecahkan masing-masing password?
1. **Cryptographic hash functions.** Unduh sebuah image Debian dari [mirror](https://www.debian.org/CD/http-ftp/) (misalnya [dari mirror Argentina ini](http://debian.xfree.com.ar/debian-cd/current/amd64/iso-cd/)). Periksa silang hash-nya (misalnya menggunakan perintah `sha256sum`) dengan hash yang diambil dari situs resmi Debian (misalnya [file ini](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS) yang di-host di `debian.org`, jika Anda telah mengunduh file yang ditautkan dari mirror Argentina).
1. **Symmetric cryptography.** Enkripsi sebuah file dengan enkripsi AES, menggunakan [OpenSSL](https://www.openssl.org/): `openssl aes-256-cbc -salt -in {input filename} -out {output filename}`. Lihat isinya menggunakan `cat` atau `hexdump`. Dekripsi dengan `openssl aes-256-cbc -d -in {input filename} -out {output filename}` dan konfirmasi bahwa isinya cocok dengan yang asli menggunakan `cmp`.
1. **Asymmetric cryptography.**
    1. Siapkan [SSH keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2) pada komputer yang Anda miliki aksesnya (bukan Athena, karena Kerberos berinteraksi secara aneh dengan SSH keys). Pastikan private key Anda dienkripsi dengan passphrase, sehingga terlindungi saat disimpan.
    1. [Siapkan GPG](https://www.digitalocean.com/community/tutorials/how-to-use-gpg-to-encrypt-and-sign-messages)
    1. Kirim email terenkripsi ke Anish ([public key](https://keybase.io/anish)).
    1. Tandatangani sebuah Git commit dengan `git commit -S` atau buat Git tag yang ditandatangani dengan `git tag -s`. Verifikasi tanda tangan pada commit dengan `git show --show-signature` atau pada tag dengan `git tag -v`.
