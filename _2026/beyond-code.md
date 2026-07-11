---
layout: lecture
title: "Di Balik Kode"
description: >
  Pelajari soft skills penting termasuk dokumentasi, norma komunitas open-source, dan etika AI.
thumbnail: /static/assets/thumbnails/2026/lec8.png
date: 2026-01-22
ready: true
video:
  aspect: 56.25
  id: 2DOEATfXT8k
---

Menjadi software engineer yang baik bukan hanya tentang menulis kode yang
berfungsi. Ini tentang menulis kode yang dapat dipahami, dipelihara, dan
dikembangkan oleh orang lain (termasuk Anda di masa depan). Ini tentang
berkomunikasi dengan jelas, berkontribusi dengan penuh pertimbangan, dan
menjadi warga yang baik dalam ekosistem yang Anda ikuti—baik itu open source
maupun proprietary.

# Komunikasi satu arah

Sebagian besar pekerjaan software engineering melibatkan menulis untuk orang
yang tidak memiliki konteks Anda saat ini: rekan tim yang bergabung nanti,
maintainer yang mewarisi kode Anda, atau Anda sendiri enam bulan dari sekarang
ketika Anda sudah lupa mengapa Anda membuat pilihan tertentu. Saran utama untuk
semua jenis penulisan ini adalah tujuan Anda adalah menangkap dan menyampaikan
*mengapa*, bukan hanya *apa*. Apa yang dilakukan cenderung dapat dijelaskan
dengan sendirinya, sedangkan *mengapa* adalah pengetahuan yang diperoleh dengan
sulit dan mudah hilang seiring waktu.

Mungkin bentuk komunikasi yang paling umum dari engineer ke engineer
(terlepas dari kode itu sendiri) adalah komentar kode. Saya pribadi menemukan
bahwa banyak komentar kode tidak berguna. Tapi tidak harus demikian! Komentar
yang baik menjelaskan hal-hal yang tidak dapat dijelaskan oleh kode itu
sendiri: *mengapa* sesuatu dilakukan dengan cara tertentu, bukan *bagaimana*
cara kerjanya (yang sudah ditunjukkan oleh kode). Komentar yang baik dapat
menghemat waktu berjam-jam dari kebingungan, sementara komentar yang buruk
menambah kebisingan atau, lebih buruk lagi, menyesatkan.

Jenis komentar yang hampir selalu bermanfaat:

- **TODO**: Tandai kode yang belum selesai atau belum dipoles, tetapi berikan
  konteks yang cukup agar orang lain dapat memahami apa yang masih tertunda dan
  mengapa ditunda. "TODO: optimasi" tidak berguna; "TODO: loop O(n²) ini cukup
  untuk `n<100`, tetapi akan memerlukan indexing jika kita scale" lebih dapat
  ditindaklanjuti.
- **Referensi**: Tautkan ke sumber eksternal ketika kode mengimplementasikan
  algoritma dari sebuah paper, mengadaptasi kode dari tempat lain, atau
  mengkodekan perilaku yang ditentukan dalam dokumentasi. Gunakan permalink.
  Catat setiap penyimpangan dari referensi.
- **Argumen kebenaran**: Jelaskan *mengapa* kode yang tidak trivial menghasilkan
  hasil yang benar. Kode menunjukkan langkah-langkahnya; komentar menjelaskan
  mengapa langkah-langkah tersebut bekerja.
- **Pelajaran yang didapat dengan susah payah**: Jika Anda menghabiskan 30+
  menit untuk men-debug sesuatu dan solusinya adalah sebuah incantation yang
  tidak jelas, dokumentasikan. Diri Anda di masa lalu tidak menyadari itu
  diperlukan; pembaca di masa depan juga tidak akan menyadarinya.
- **Rasionalisasi konstanta**: Angka-angka ajaib layak diberi penjelasan. Mengapa
  1492? Mengapa 16 bit? Apakah dipilih secara acak, diturunkan dari pengujian,
  atau diperlukan untuk kebenaran? Bahkan "dipilih secara arbitrer" adalah
  informasi yang berguna.
- **Pilihan yang menopang kebenaran**: Jika kebenaran bergantung pada detail
  implementasi yang tampaknya tidak berbahaya (misalnya, "harus berupa BTreeSet
  karena urutan iterasi penting di bawah"), sebutkan secara eksplisit.
- **"Mengapa tidak"**: Ketika Anda dengan sengaja menghindari pendekatan yang
  jelas, jelaskan mengapa. Jika tidak, seseorang akan "memperbaikinya" nanti
  dan merusak sesuatu.

README (Anda punya satu, kan?) juga merupakan titik sentuhan pertama yang umum
dengan developer lain. README yang baik menjawab empat pertanyaan segera: Apa
yang dilakukan ini? Mengapa saya harus peduli? Bagaimana cara menggunakannya?
Bagaimana cara menginstalnya? Dalam urutan tersebut. Struktur seperti corong:
satu baris dan mungkin demo visual di atas agar seseorang dapat memutuskan dalam
hitungan detik apakah ini memecahkan masalah mereka, kemudian tambahkan
kedalaman secara bertahap. Tunjukkan penggunaan sebelum instalasi — orang ingin
melihat apa yang mereka dapatkan sebelum berkomitmen pada langkah-langkah
setup.

Pesan commit adalah jenis lain dari "menulis untuk orang lain" yang sering
diabaikan. Pesan commit sering ditulis sebagai "fixed blah" atau "added foo",
dan meskipun itu mungkin cukup dalam beberapa kasus, mudah untuk lupa bahwa
pesan commit membentuk catatan historis tentang *mengapa* codebase berkembang
seperti itu. Ketika seseorang (termasuk Anda!) menjalankan `git blame` untuk
mencoba memahami perubahan yang membingungkan, pesan commit yang baik harus
memberi mereka jawaban.

Secara umum, isi pesan commit harus menjawab:
- Masalah apa yang memaksa perubahan ini?
- Alternatif apa yang Anda pertimbangkan?
- Apa trade-off atau implikasinya?
- Apa yang mungkin mengejutkan tentang pendekatan ini?

> Jelas Anda harus menyesuaikan detail dengan kompleksitas. Perbaikan typo
> satu baris hanya memerlukan subject. Perbaikan race condition yang halus
> yang memakan waktu berjam-jam untuk di-debug layak mendapatkan paragraf yang
> menjelaskan masalah dan solusinya.

Untuk perubahan yang kompleks, bisa berguna mengikuti struktur Masalah → Solusi
→ Implikasi: Mulai dengan pemicu atau keterbatasan, kemudian jelaskan apa yang
berubah dan keputusan desain utama, lalu daftar konsekuensi yang penting
(positif dan negatif). Bagian terakhir sangat penting; rekayasa nyata melibatkan
keseimbangan kepentingan, dan mendokumentasikan bahwa sebuah trade-off
disengaja mencegah developer di masa depan berpikir Anda melewatkan masalah
tersebut.

LLM _dapat_ membantu dalam menulis pesan commit. Namun, jika Anda hanya
mengarahkannya ke perubahan Anda dan memintanya menulis pesan commit untuk
perubahan tersebut, LLM hanya akan memiliki akses ke _apa_, bukan _mengapa_.
Dan pesan commit yang dihasilkan akan sebagian besar bersifat deskriptif
(kebalikan dari yang kita inginkan!). Jika Anda menggunakan LLM untuk membantu
Anda membuat perubahan sejak awal, meminta LLM menulis commit dalam sesi yang
sama bisa menjadi pilihan yang jauh lebih baik karena percakapan Anda dengan
LLM secara inheren merupakan sumber konteks yang kaya tentang perubahan
tersebut! Jika tidak, atau sebagai tambahan, trik yang berguna adalah secara
khusus memberi tahu LLM bahwa Anda ingin pesan commit yang berfokus pada
"mengapa" (dan nuansa lainnya dari catatan di atas), dan kemudian _suruh LLM
untuk bertanya kepada Anda tentang konteks yang hilang_. Pada dasarnya, Anda
bertindak seperti "tool" MCP yang dapat digunakan oleh coding agent untuk
"membaca" konteks.

Seiring perubahan Anda menjadi lebih kompleks, pastikan untuk juga memecah
commit secara logis (`git add -p` adalah teman Anda). Setiap commit harus
mewakili satu perubahan yang koheren yang dapat dipahami dan direview secara
independen. Jangan mencampur refactoring dengan fitur baru atau menggabungkan
perbaikan bug yang tidak terkait, karena ini mengaburkan cerita tentang
perubahan mana yang memperbaiki masalah apa, dan hampir pasti akan memperlambat
review perubahan Anda pada akhirnya. Ini juga memberi Anda kekuatan super
melalui `git bisect`, tapi itu cerita untuk waktu lain.

> Satu catatan saat Anda mulai lebih rajin dalam penulisan teknis, dan
> menggunakannya secara lebih luas, pastikan Anda menghormati pembaca. Mudah
> untuk berakhir dengan penjelasan berlebihan setelah Anda mulai, tetapi Anda
> harus menahan dorongan itu agar pembaca tidak membaca _tidak satupun_ dari
> apa yang telah Anda tulis. Jelaskan "mengapa" dan percayai mereka untuk
> mencari tahu "bagaimana" untuk situasi mereka.

# Kolaborasi

Sebagai engineer, kita mungkin menghabiskan sebagian besar pekerjaan kita
dengan coding di keyboard sendiri, tetapi sebagian besar waktu kita juga
dihabiskan untuk berkomunikasi dengan orang lain. Waktu tersebut biasanya
terbagi antara kolaborasi dan edukasi, dan hasil dari berinvestasi untuk
menjadi lebih baik di keduanya sangat signifikan.

## Berkontribusi

Baik Anda mengirimkan laporan bug, berkontribusi perbaikan bug sederhana, atau
mengimplementasikan fitur besar, perlu diingat bahwa biasanya ada urutan
besaran lebih banyak pengguna daripada kontributor, dan satu urutan besaran
lebih banyak kontributor daripada maintainer. Akibatnya, waktu maintainer
sangat terbatas. Jika Anda ingin meningkatkan kemungkinan bahwa kontribusi
Anda menghasilkan sesuatu yang produktif, Anda harus memastikan bahwa
kontribusi Anda membawa rasio signal-to-noise yang tinggi dan layak mendapat
waktu maintainer.

Sebagai contoh, laporan bug yang baik menghormati waktu maintainer dengan
menyediakan semua yang diperlukan untuk memahami dan mereproduksi masalah:

- **Environment**: OS, nomor versi, konfigurasi yang relevan
- **Apa yang Anda harapkan** vs **apa yang sebenarnya terjadi**
- **Langkah-langkah untuk mereproduksi**: Jadilah spesifik. "Klik tombolnya"
  kurang berguna daripada "Klik tombol Submit di halaman /settings saat login
  sebagai admin."
- **Apa yang sudah Anda coba**: Ini mencegah saran duplikat dan menunjukkan
  Anda telah melakukan penyelidikan

> Jika Anda menemukan kerentanan keamanan, jangan mempostingnya secara publik.
> Hubungi maintainer secara pribadi terlebih dahulu dan beri mereka waktu yang
> wajar untuk memperbaikinya sebelum disclosure. Banyak proyek memiliki file
> SECURITY.md atau sejenisnya untuk tujuan ini.

**Pastikan Anda mencari issue yang sudah ada.** Bug atau permintaan fitur Anda
mungkin sudah dilaporkan, dan jauh lebih baik menambahkan informasi ke
diskusi yang sudah ada daripada membuat duplikat. Belum lagi, ini mengurangi
kebisingan bagi maintainer.

Contoh reproduksi minimal adalah emas, jika Anda bisa membuatnya. Contoh ini
menghemat banyak waktu dan usaha maintainer, dan mereproduksi bug secara
andal sering kali merupakan bagian tersulit dari memperbaikinya. Belum lagi,
usaha yang Anda lakukan untuk mengisolasi masalah sering kali membantu Anda
memahaminya dengan lebih baik juga, dan terkadang menuntun Anda untuk
menemukan solusi sendiri.

Jika Anda tidak segera mendapat tanggapan, ingatlah bahwa maintainer sering
kali adalah relawan dengan waktu terbatas. Jika Anda menunggu balasan dari
mereka, follow-up yang sopan setelah beberapa minggu tidak masalah; ping
setiap hari tidak. Demikian pula, komentar "me too", atau laporan bug yang
hanya berupa copy-paste output terminal cenderung menjadi beban netto dalam
hal mendapatkan perhatian untuk issue Anda.

Jika Anda ingin membuat kontribusi kode, Anda juga perlu membiasakan diri
dengan panduan kontribusi. Banyak proyek memiliki `CONTRIBUTING.md` — ikuti
panduan tersebut. Anda juga biasanya ingin memulai dari yang kecil; perbaikan
typo atau perbaikan dokumentasi adalah kontribusi pertama yang bagus karena
membantu Anda mempelajari proses proyek tanpa harus melalui banyak bolak-balik
tentang konten.

> Periksa lisensi apa yang digunakan proyek, karena setiap kode yang Anda
> kontribusikan akan berada di bawah lisensi yang sama. Khususnya, perhatikan
> lisensi copyleft (seperti GPL), yang mengharuskan karya turunan juga bersifat
> open source dan mungkin memiliki implikasi bagi pemberi kerja Anda jika Anda
> menyentuhnya! [choosealicense.com](https://choosealicense.com/) memiliki
> informasi yang lebih berguna.

Ketika Anda memutuskan untuk membuka pull request ("PR"), pertama-tama pastikan
Anda mengisolasi perubahan yang sebenarnya ingin Anda diterima. Jika PR Anda
mengubah banyak hal lain yang tidak terkait pada saat yang sama, kemungkinan
besar reviewer akan mengembalikannya kepada Anda dan meminta Anda untuk
membersihkannya. Ini mirip dengan bagaimana Anda harus memecah commit git Anda
menjadi bagian-bagian yang terkait secara semantis.

Dalam beberapa kasus, jika Anda memiliki banyak perubahan yang tampaknya
berbeda-beda tetapi semuanya diperlukan untuk mengaktifkan satu fitur, mungkin
tidak masalah membuka PR yang lebih besar yang mencakup semua perubahan.
Namun, dalam kasus ini, kebersihan commit sangat penting agar maintainer
memiliki opsi untuk mereview perubahan "commit demi commit".

Selanjutnya, pastikan Anda menjelaskan "mengapa" di balik perubahan dengan
baik. Jangan hanya mendeskripsikan _apa_ yang berubah — jelaskan _mengapa_
perubahan diperlukan dan _mengapa_ ini adalah cara yang baik untuk mengatasi
masalah. Anda juga harus secara proaktif menyebutkan bagian-bagian perubahan
yang memerlukan perhatian khusus dalam review, jika ada. Tergantung pada
`CONTRIBUTING.md` dan sifat perubahan Anda, reviewer mungkin juga mengharapkan
informasi tambahan seperti trade-off yang Anda buat atau cara menguji
perubahan.

> Kami merekomendasikan untuk berkontribusi kembali ke proyek upstream daripada
> "fork" proyek, setidaknya sebagai pendekatan pertama. Forking (dengan
> memperhatikan lisensi) sebaiknya dicadangkan untuk ketika kontribusi yang
> ingin Anda buat berada di luar ruang lingkup proyek asli. Jika Anda melakukan
> fork, pastikan Anda mengakui proyek asli!

AI membuat sangat mudah untuk menghasilkan kode dan PR yang terlihat masuk
akal dengan cepat, tetapi ini tidak membebaskan Anda dari tanggung jawab untuk
memahami apa yang Anda kontribusikan. Mengirimkan kode yang dihasilkan AI yang
tidak dapat Anda jelaskan membebani maintainer dengan me-review dan mungkin
memelihara kode yang bahkan pembuatnya tidak pahami. Tidak apa-apa menggunakan
AI untuk membantu mengidentifikasi masalah dan menghasilkan perbaikan/fitur,
**asalkan Anda tetap melakukan due diligence** untuk memolesnya menjadi
kontribusi yang berharga, daripada menyerahkan pekerjaan itu kepada maintainer
(yang sudah kelebihan beban).

Ingat bahwa bagi maintainer, menerima PR berarti menerima tanggung jawab
jangka panjang. Mereka akan memelihara kode ini jauh setelah kontributor
beralih ke hal lain, dan mungkin menolak perubahan yang berniat baik tetapi
tidak sesuai dengan arah proyek, menambah kompleksitas yang tidak ingin mereka
pelihara, atau di mana kebutuhannya tidak terdokumentasi dengan cukup baik.
Tugas _Anda_ sebagai kontributor untuk membuat argumen mengapa menerima
kontribusi tersebut sepadan dengan beban pemeliharaan.

> Saat menerima umpan balik pada PR, ingatlah bahwa kode Anda bukanlah Anda!
> Reviewer berusaha membuat kode menjadi lebih baik, bukan mengkritik Anda
> secara pribadi. Ajukan pertanyaan klarifikasi jika Anda tidak setuju — Anda
> mungkin belajar sesuatu, atau mungkin mereka yang akan belajar.

## Me-review

Anda mungkin berpikir code review adalah sesuatu yang dilakukan developer
senior, tetapi Anda mungkin akan diminta untuk me-review kode lebih awal dari
yang Anda kira, dan perspektif Anda berharga. Mata segar menangkap hal-hal
yang diabaikan developer berpengalaman, dan pertanyaan dari seseorang yang
kurang familiar dengan kode sering kali mengungkap asumsi yang seharusnya
didokumentasikan atau disederhanakan.

Review juga merupakan salah satu cara tercepat untuk belajar. Anda akan melihat
bagaimana orang lain mendekati masalah, mengambil pola dan idiom, dan
mengembangkan intuisi tentang apa yang membuat kode mudah dibaca. Di luar
pertumbuhan pribadi, review menangkap bug sebelum mencapai produksi, menyebarkan
pengetahuan ke seluruh tim, dan meningkatkan kualitas kode melalui kolaborasi.
Review bukan sekadar overhead birokrasi.

Code review yang baik adalah keterampilan yang perlu Anda asah seiring waktu,
tetapi ada beberapa tips yang dapat membuatnya jauh lebih baik dengan lebih
cepat:

- **Review kodenya, bukan orangnya**:
  "Fungsi ini membingungkan" vs "Anda menulis kode yang membingungkan."
- **Utamakan komentar yang dapat ditindaklanjuti**:
  "Bisa ganti globals ini dengan config dataclass?" adalah komentar yang lebih
  mudah ditangani daripada "Jangan gunakan globals di sini"
- **Ajukan pertanyaan daripada membuat tuntutan**:
  "Apa yang terjadi jika X null di sini?" mengundang diskusi lebih baik
  daripada "Tangani kasus null."
- **Jelaskan "mengapa"**:
  "Pertimbangkan menggunakan konstanta di sini" kurang berguna daripada
  "Pertimbangkan menggunakan konstanta di sini agar kita dapat dengan mudah
  menyesuaikan timeout berdasarkan environment."
- **Bedakan antara masalah yang memblokir dan saran**:
  Jelaskan dengan jelas apa yang harus diubah versus apa yang merupakan masalah
  preferensi.
- **Akui apa yang baik**:
  Menunjukkan solusi cerdas atau implementasi yang bersih sangat mendorong dan
  membantu penulis mengetahui apa yang harus terus dilakukan.
- **Tahu kapan harus berhenti**:
  Kontributor hanya punya waktu dan kesabaran terbatas, dan tidak selalu
  terbaik dihabiskan untuk menangani semua hal-hal kecil. Fokus pada hal-hal
  besar, dan pertimbangkan untuk merapikan hal-hal kecil sendiri setelahnya.

> Tool AI dapat menangkap masalah tertentu, tetapi bukan pengganti untuk review
> manusia. Mereka melewatkan konteks, tidak memahami kebutuhan produk, dan
> dapat dengan percaya diri menyarankan hal-hal yang salah. Mereka layak
> digunakan sebagai pass pertama, tetapi bukan pengganti untuk review manusia
> yang penuh pertimbangan.

# Edukasi

Banyak waktu non-coding kita sebagai engineer dihabiskan untuk bertanya atau
menjawab pertanyaan, mungkin campuran keduanya; selama kolaborasi, dalam
dialog dengan rekan, atau saat mencoba belajar. Bertanya dengan baik adalah
keterampilan yang membuat Anda lebih baik dalam belajar dari siapa pun, bukan
hanya dari penjelas yang sempurna. Julia Evans memiliki beberapa posting blog
yang sangat baik tentang "[How to ask good
questions](https://jvns.ca/blog/good-questions/)" dan "[How to get useful
answers to your
questions](https://jvns.ca/blog/2021/10/21/how-to-get-useful-answers-to-your-questions/)"
yang layak dibaca.

Beberapa saran yang sangat berharga adalah:

- **Nyatakan pemahaman Anda terlebih dahulu**: Katakan apa yang Anda pikir Anda
  ketahui dan tanyakan "apakah itu benar?" Ini membantu pemberi jawaban
  mengidentifikasi celah pengetahuan Anda yang sebenarnya.
- **Ajukan pertanyaan ya/tidak**: "Apakah X benar?" mencegah penjelasan yang
  melebar dan biasanya tetap memicu elaborasi yang berguna.
- **Jadilah spesifik**: "Bagaimana cara kerja SQL join?" terlalu kabur.
  "Apakah LEFT JOIN menyertakan baris di mana tabel kanan tidak memiliki
  kecocokan?" dapat dijawab.
- **Akui ketika Anda tidak paham**: Sela untuk bertanya tentang istilah yang
  tidak familiar. Ini mencerminkan kepercayaan diri, bukan kelemahan. Demikian
  pula, jika mereka menanyakan sesuatu kepada Anda yang tidak Anda ketahui
  jawabannya, yang terbaik adalah mengatakan "Saya tidak tahu", dan mungkin
  melanjutkan dengan "tetapi saya pikir ..." atau bahkan "tetapi saya bisa
  mencari tahu".
- **Jangan terima jawaban yang tidak lengkap**: Terus ajukan pertanyaan lanjutan
  sampai Anda benar-benar paham.
- **Lakukan riset terlebih dahulu**: Investigasi dasar membantu Anda mengajukan
  pertanyaan yang lebih tertarget (meskipun pertanyaan santai di antara rekan
  kerja tidak masalah).

Ingat: pertanyaan yang dirancang dengan baik bermanfaat bagi seluruh komunitas.
Pertanyaan tersebut mengungkap asumsi tersembunyi yang juga perlu dipahami
orang lain.

> Perhatikan bahwa saran ini berlaku sama saat berkomunikasi dengan LLM!

# Etika AI

Dengan semakin meluasnya penggunaan LLM dan AI dalam software engineering,
norma sosial dan profesional di sekitarnya masih dalam perubahan. Kami sudah
membahas banyak pertimbangan taktis di [lecture agentic
coding](/2026/agentic-coding/), tetapi ada juga bagian "lebih lunak" dari
penggunaannya yang layak dibahas.

Yang pertama adalah ketika AI berkontribusi secara signifikan terhadap pekerjaan
Anda, **ungkapkan hal tersebut**. Ini bukan tentang rasa malu — ini tentang
kejujuran, menetapkan ekspektasi yang tepat, dan memastikan pekerjaan yang
dihasilkan mendapatkan tingkat review yang sesuai. Juga bermanfaat untuk
mengungkapkan _bagian mana_ yang Anda gunakan AI — ada perbedaan yang bermakna
antara "semua ini adalah vibecoded" dan "saya menulis tool backup ini dan
menggunakan LLM untuk men-style frontend web". Sebagai contoh, kami telah
menggunakan LLM untuk membantu menulis beberapa catatan lecture ini, termasuk
proofreading, brainstorming, dan menghasilkan draft awal cuplikan kode dan
latihan.

Anda juga perlu mengikuti norma-norma tim dan proyek yang Anda kontribusikan.
Beberapa tim memiliki kebijakan yang lebih ketat tentang penggunaan AI
dibandingkan yang lain (misalnya, untuk alasan kepatuhan atau residensi data),
dan Anda tidak ingin secara tidak sengaja melanggarnya. Terbuka tentang
penggunaan Anda membantu mencegah kesalahan yang berpotensi mahal.

> Jika Anda bertujuan untuk belajar sebagai bagian dari pekerjaan yang Anda
> lakukan, ingatlah bahwa jika Anda membiarkan AI melakukan semua atau sebagian
> besar pekerjaan untuk Anda, itu bisa menjadi kontraproduktif; Anda mungkin
> lebih banyak belajar tentang prompting (dan mungkin me-review output AI)
> daripada tugas itu sendiri. Terutama ketika Anda sedang belajar, tujuannya
> mungkin perjalanannya, bukan tujuannya, jadi menggunakan AI untuk
> "mendapatkan solusi dengan cepat" adalah anti-tujuan.

Keprihatinan terkait muncul dalam wawancara dan situasi penilaian lainnya.
Situasi-situasi ini sering kali dimaksudkan secara khusus untuk mengevaluasi
keterampilan dan kemampuan _Anda_, bukan LLM. Lebih banyak perusahaan sekarang
mengizinkan Anda menggunakan LLM dan tool bantuan AI lainnya dalam wawancara
selama Anda membiarkan mereka mengamati interaksi tersebut sebagai bagian dari
wawancara (yaitu, mereka juga mengevaluasi keterampilan Anda dalam menggunakan
tool-tool tersebut!), tetapi mereka masih merupakan minoritas. Jika Anda tidak
yakin apakah bantuan AI diizinkan untuk tugas tertentu, tanyakan!

> Seharusnya tidak perlu dikatakan lagi bahwa jika situasi penilaian secara
> eksplisit melarang tool eksternal, LLM, dll., Anda tidak boleh menggunakannya.
> Mencoba melakukannya secara diam-diam tanpa ketahuan **akan** kembali
> merugikan Anda.

# Latihan

1. Jelajahi source code dari proyek yang terkenal (misalnya,
   [Redis](https://github.com/redis/redis) atau
   [curl](https://github.com/curl/curl)). Temukan contoh beberapa jenis
   komentar yang disebutkan dalam lecture: TODO yang berguna, referensi ke
   dokumentasi eksternal, komentar "mengapa tidak" yang menjelaskan pendekatan
   yang dihindari, atau pelajaran yang didapat dengan susah payah. Apa yang
   akan hilang jika komentar tersebut tidak ada?

1. Pilih proyek open-source yang Anda minati dan lihat riwayat commit terbarunya
   (`git log`). Temukan satu commit dengan pesan yang baik yang menjelaskan
   *mengapa* perubahan dilakukan, dan satu dengan pesan yang lemah yang hanya
   mendeskripsikan *apa* yang berubah. Untuk yang lemah, lihat diff (`git show
   <hash>`) dan coba tulis pesan commit yang lebih baik mengikuti struktur
   Masalah → Solusi → Implikasi. Perhatikan berapa banyak usaha yang diperlukan
   untuk menyusun kembali konteks yang diperlukan setelah fakta!

1. Bandingkan README dari tiga proyek GitHub dengan 1000+ bintang. Apakah
   semuanya sama-sama berguna? Carilah hal-hal yang menurut Anda sebagian besar
   hanya kebisingan sebagai pelajaran untuk README yang Anda tulis sendiri di
   masa depan.

1. Temukan issue terbuka pada proyek yang Anda gunakan (periksa label "good
   first issue" atau "help wanted" jika ada). Evaluasi issue tersebut terhadap
   kriteria dari lecture: apakah sepertinya menghargai waktu maintainer dan
   berisi semua informasi yang diperlukan untuk men-debug-nya, atau Anda
   memperkirakan maintainer mungkin perlu melalui beberapa putaran pertanyaan
   dengan pengirim untuk sampai ke masalah inti?

1. Pikirkan bug yang pernah Anda temui di software yang Anda gunakan (atau
   temukan satu di issue tracker). Berlatihlah membuat contoh reproduksi
   minimal: hilangkan semua yang tidak terkait dengan bug sampai Anda memiliki
   kasus terkecil yang masih mendemonstrasikan masalah. Tuliskan apa yang Anda
   hapus dan mengapa.

1. Temukan pull request yang sudah di-merge pada proyek yang Anda kenal yang
   memiliki komentar review yang substantif (bukan hanya "LGTM"). Baca
   review-nya. Apakah semua komentar sama-sama produktif? Jika Anda adalah
   penulis PR, bagaimana pengalaman Anda menerima semua komentar tersebut?

1. Pergi ke Stack Overflow dan temukan pertanyaan dalam teknologi yang Anda
   ketahui yang memiliki jawaban dengan voting tinggi. Kemudian temukan satu
   yang ditutup atau banyak downvote. Bandingkan mereka dengan saran dari
   lecture; apakah dapat diprediksi pertanyaan mana yang akan mendapatkan
   jawaban lebih baik?
