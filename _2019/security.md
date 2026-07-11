---
layout: lecture
title: "Keamanan dan Privasi"
presenter: Jon
date: 2019-01-31
order: 2
video:
  aspect: 56.25
  id: OBx_c-i-M8s
special: true
---

Dunia ini tempat yang menyeramkan, dan semua orang mengincar Anda.

Oke, mungkin tidak juga, tetapi itu bukan berarti Anda ingin memamerkan semua
rahasia Anda. Keamanan (dan privasi) pada dasarnya adalah tentang meningkatkan
standar bagi para penyerang. Cari tahu apa model ancaman Anda, lalu rancang
mekanisme keamanan Anda berdasarkan model tersebut! Jika model ancamannya adalah
NSA atau Mossad, Anda _mungkin_ akan mengalami kesulitan.

Ada _banyak_ cara untuk membuat persona teknis Anda lebih aman. Kami akan
menyentuh banyak hal tingkat tinggi di sini, tetapi ini adalah sebuah proses, dan
mendidik diri sendiri adalah salah satu hal terbaik yang dapat Anda lakukan. Jadi:

## Ikuti Orang-orang yang Tepat

Salah satu cara terbaik untuk meningkatkan pengetahuan keamanan Anda adalah dengan mengikuti
orang-orang lain yang vokal tentang keamanan. Beberapa saran:

 - [@TroyHunt](https://twitter.com/TroyHunt)
 - [@SwiftOnSecurity](https://twitter.com/SwiftOnSecurity)
 - [@taviso](https://twitter.com/taviso)
 - [@thegrugq](https://twitter.com/thegrugq)
 - [@tqbf](https://twitter.com/tqbf)
 - [@mattblaze](https://twitter.com/mattblaze)
 - [@moxie](https://twitter.com/moxie)

Lihat juga [daftar
ini](https://heimdalsecurity.com/blog/best-twitter-cybersec-accounts/)
untuk saran lebih lanjut.

## Saran Keamanan Umum

Tech Solidarity memiliki daftar [hal yang boleh dan tidak boleh dilakukan untuk
jurnalis](https://web.archive.org/web/20221123204419/https://techsolidarity.org/resources/basic_security.htm)
yang cukup bagus dan memiliki banyak saran yang masuk akal, serta cukup terkini. [@thegrugq](https://medium.com/@thegrugq)
juga memiliki postingan blog yang bagus tentang [saran keamanan
perjalanan](https://medium.com/@thegrugq/stop-fabricating-travel-security-advice-35259bf0e869)
yang layak dibaca. Kami akan mengulang banyak saran dari sumber-sumber tersebut
di sini, ditambah beberapa lainnya. Selain itu, dapatkan [pemblokir data
USB](https://www.amazon.com/dp/B00QRRZ2QM/), karena [USB itu
menyeramkan](https://www.bleepingcomputer.com/news/security/heres-a-list-of-29-different-types-of-usb-attacks/).

## Autentikasi

Hal pertama yang harus Anda lakukan, jika belum melakukannya, adalah mengunduh
manajer kata sandi. Beberapa yang bagus adalah:

 - [1password](https://1password.com/)
 - [KeePass](https://keepass.info/)
 - [BitWarden](https://bitwarden.com/)
 - [`pass`](https://git.zx2c4.com/password-store/about/)

Jika Anda sangat paranoid, gunakan yang mengenkripsi kata sandi
secara lokal di komputer Anda, bukan menyimpannya dalam teks biasa di
server. Gunakan untuk menghasilkan kata sandi
bagi semua situs web yang Anda pedulikan sekarang. Kemudian, aktifkan
autentikasi dua faktor, idealnya dengan
dongle [FIDO/U2F](https://fidoalliance.org/) (misalnya
[YubiKey](https://www.yubico.com/quiz/), yang memiliki [diskon 20%
untuk pelajar](https://www.yubico.com/why-yubico/for-education/)). TOTP
(seperti Google Authenticator atau Duo) juga bisa digunakan dalam keadaan darurat, tetapi
[tidak melindungi dari
phishing](https://twitter.com/taviso/status/1082015009348104192). SMS pada
dasarnya tidak berguna kecuali model ancaman Anda hanya mencakup orang asing acak
yang mengambil kata sandi Anda dalam perjalanan.

Juga, catatan tentang kunci kertas. Seringkali, layanan akan memberikan Anda "kunci
cadangan" yang dapat Anda gunakan sebagai faktor kedua jika Anda kehilangan faktor kedua
Anda yang asli (ngomong-ngomong, selalu simpan dongle cadangan di tempat yang aman!). Meskipun Anda
_bisa_ menyimpannya di manajer kata sandi Anda, itu berarti jika
seseorang mendapatkan akses ke manajer kata sandi Anda, Anda benar-benar rugi (tetapi
mungkin Anda baik-baik saja dengan model ancaman tersebut). Jika Anda benar-benar paranoid,
cetak kunci-kunci kertas ini, jangan pernah menyimpannya secara digital, dan simpan
di brankas di dunia nyata.

## Komunikasi Pribadi

Gunakan [Signal](https://www.signal.org/) ([petunjuk
penyiapan](https://medium.com/@mshelton/signal-for-beginners-c6b44f76a1f0).
[Wire](https://wire.com/en/) juga [baik-baik
saja](https://www.securemessagingapps.com/); WhatsApp cukup oke; [jangan gunakan
Telegram](https://twitter.com/bascule/status/897187286554628096)). Messenger desktop
cukup bermasalah (sebagian karena biasanya bergantung pada
Electron, yang merupakan tumpukan kepercayaan yang sangat besar).

Email sangat bermasalah, bahkan jika ditandatangani PGP. Email secara umum
tidak forward-secure, dan masalah distribusi kunci cukup
parah. [keybase.io](https://keybase.io/) membantu, dan berguna untuk
banyak alasan lainnya. Juga, kunci PGP umumnya ditangani di komputer
desktop, yang merupakan salah satu lingkungan komputasi paling tidak aman. Terkait dengan itu, pertimbangkan untuk mendapatkan Chromebook, atau cukup bekerja di tablet dengan
papan ketik.

## Keamanan Berkas

Keamanan berkas itu sulit, dan beroperasi pada banyak tingkat. Apa yang ingin
Anda amankan?

[![$5 wrench](https://imgs.xkcd.com/comics/security.png)](https://xkcd.com/538/)

 - Serangan offline (seseorang mencuri laptop Anda saat sedang mati): aktifkan
   enkripsi disk penuh. ([cryptsetup +
   LUKS](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_a_non-root_file_system)
   di Linux,
   [BitLocker](https://fossbytes.com/enable-full-disk-encryption-windows-10/)
   di Windows, [FileVault](https://support.apple.com/en-us/HT204837) di
   macOS. Perhatikan bahwa ini tidak akan membantu jika penyerang _juga_ memiliki Anda dan
   benar-benar menginginkan rahasia Anda.
 - Serangan online (seseorang memiliki laptop Anda dan sedang menyala): gunakan
   enkripsi berkas. Ada dua mekanisme utama untuk melakukannya
    - Sistem berkas terenkripsi: perangkat lunak enkripsi sistem berkas bertumpuk mengenkripsi berkas secara individual daripada memiliki perangkat blok terenkripsi. Anda dapat "me-mount" sistem berkas ini dengan menyediakan kunci dekripsi, lalu menelusuri berkas di dalamnya dengan bebas. Ketika Anda unmount, semua berkas tersebut tidak tersedia. Solusi modern termasuk [gocryptfs](https://github.com/rfjakob/gocryptfs) dan [eCryptFS](https://www.ecryptfs.org/). Perbandingan yang lebih detail dapat ditemukan [di sini](https://nuetzlich.net/gocryptfs/comparison/) dan [di sini](https://wiki.archlinux.org/index.php/disk_encryption#Comparison_table)
    - Berkas terenkripsi: enkripsi berkas individual dengan enkripsi
      simetris (lihat `gpg -c`) dan kunci rahasia. Atau, seperti `pass`, juga
      enkripsi kunci tersebut dengan kunci publik Anda sehingga hanya Anda yang dapat membacanya kembali
      nanti dengan kunci pribadi Anda. Pengaturan enkripsi yang tepat sangat
      penting!
 - [Penyangkalan yang
   masuk akal](https://en.wikipedia.org/wiki/Plausible_deniability)
   (sepertinya ada masalah apa, Pak?): biasanya kinerja lebih rendah,
   dan lebih mudah kehilangan data. Sulit untuk benar-benar membuktikan bahwa ini menyediakan
   [enkripsi yang dapat
   disangkal](https://en.wikipedia.org/wiki/Deniable_encryption)! Lihat
   [diskusi
   di sini](https://security.stackexchange.com/questions/135846/is-plausible-deniability-actually-feasible-for-encrypted-volumes-disks),
   lalu pertimbangkan apakah Anda mungkin ingin mencoba
   [VeraCrypt](https://www.veracrypt.fr/en/Home.html) (fork yang terus
   dikembangkan dari TrueCrypt legendaris).
 - Cadangan terenkripsi: gunakan [Tarsnap](https://www.tarsnap.com/) atau [Borgbase](https://www.borgbase.com/)
    - Pikirkan apakah seorang penyerang dapat menghapus cadangan Anda jika mereka
      mendapatkan akses ke laptop Anda!

## Keamanan & Privasi Internet

Internet adalah tempat yang _sangat_ menyeramkan. Jaringan WiFi terbuka
[itu](https://www.troyhunt.com/the-beginners-guide-to-breaking-website/)
[menyeramkan](https://www.troyhunt.com/talking-with-scott-hanselman-on/). Pastikan
Anda menghapusnya setelahnya, jika tidak, ponsel Anda akan dengan senang hati
mengumumkan dan menyambungkan kembali ke sesuatu dengan nama yang sama nanti!

Jika Anda sedang berada di jaringan yang tidak Anda percayai, VPN _mungkin_ bermanfaat,
tetapi ingat bahwa Anda mempercayai penyedia VPN _sangat banyak_. Apakah
Anda benar-benar mempercayai mereka lebih dari ISP Anda? Jika Anda benar-benar ingin VPN, gunakan
penyedia yang Anda yakin dapat dipercaya, dan Anda sebaiknya membayarnya. Atau
siapkan [WireGuard](https://www.wireguard.com/) untuk diri sendiri -- ini
[sangat
bagus](https://web.archive.org/web/20210526211307/https://latacora.micro.blog/there-will-be/)!

Ada juga pengaturan konfigurasi yang aman untuk banyak aplikasi yang terhubung internet
di [cipherlist.eu](https://cipherlist.eu/). Jika Anda sangat berorientasi pada privasi,
[privacytools.io](https://privacytools.io) juga merupakan sumber daya yang bagus.

Beberapa dari Anda mungkin bertanya-tanya tentang [Tor](https://www.torproject.org/). Perlu diingat
bahwa Tor _tidak_ sangat tahan terhadap penyerang global yang kuat,
dan lemah terhadap serangan analisis lalu lintas. Ini mungkin
berguna untuk menyembunyikan lalu lintas dalam skala kecil, tetapi tidak akan benar-benar memberi Anda
banyak hal dalam hal privasi. Anda lebih baik menggunakan layanan yang lebih aman
dari awal (Signal, TLS + certificate pinning, dll.).

## Keamanan Web

Jadi, Anda juga ingin menjelajahi Web?
Astaga, Anda benar-benar menguji keberuntungan Anda di sini.

Pasang [HTTPS Everywhere](https://www.eff.org/https-everywhere).
SSL/TLS itu
[penting](https://www.troyhunt.com/ssl-is-not-about-encryption/), dan
ini _bukan_ hanya tentang enkripsi, tetapi juga tentang kemampuan untuk memverifikasi
bahwa Anda berbicara dengan layanan yang tepat sejak awal! Jika Anda menjalankan
server web sendiri, [ujilah](https://www.ssllabs.com/ssltest/index.html). Konfigurasi TLS
[bisa menjadi rumit](https://wiki.mozilla.org/Security/Server_Side_TLS).
HTTPS Everywhere akan melakukan yang terbaik untuk tidak pernah mengarahkan Anda ke situs HTTP
ketika ada alternatif. Itu tidak menyelamatkan Anda sepenuhnya, tetapi membantu.
Jika Anda benar-benar paranoid, daftar-hitamkan CA SSL/TLS mana pun yang tidak
benar-benar Anda butuhkan.

Pasang [uBlock Origin](https://github.com/gorhill/uBlock). Ini adalah
[pemblokir spektrum
luas](https://github.com/gorhill/uBlock/wiki/Blocking-mode) yang
tidak hanya menghentikan iklan, tetapi juga semua jenis komunikasi pihak ketiga yang mungkin
dicoba oleh sebuah halaman. Dan skrip inline dan sejenisnya. Jika Anda bersedia meluangkan
waktu untuk konfigurasi agar mọi sesuatu berfungsi, pergi ke [mode
sedang](https://github.com/gorhill/uBlock/wiki/Blocking-mode:-medium-mode)
atau bahkan [mode
sulit](https://github.com/gorhill/uBlock/wiki/Blocking-mode:-hard-mode).
Itu _akan_ membuat beberapa situs tidak berfungsi sampai Anda cukup lama mengotak-atik
pengaturannya, tetapi juga akan secara signifikan meningkatkan keamanan online
Anda.

Jika Anda menggunakan Firefox, aktifkan [Multi-Account
Containers](https://support.mozilla.org/en-US/kb/containers). Buat
container terpisah untuk jejaring sosial, perbankan, belanja, dll. Firefox
akan menyimpan cookie dan status lainnya untuk masing-masing container secara
terpisah, sehingga situs yang Anda kunjungi di satu container tidak dapat mengintai data sensitif
dari container lainnya. Di Google Chrome, Anda dapat menggunakan [Chrome
Profiles](https://support.google.com/chrome/answer/2364824) untuk mencapai
hasil yang serupa.

## Latihan

1. Enkripsi sebuah berkas menggunakan PGP
1. Gunakan veracrypt untuk membuat volume terenkripsi sederhana
1. Aktifkan 2FA untuk akun Anda yang paling sensitif terhadap data, yaitu GMail, Dropbox, Github, &c
