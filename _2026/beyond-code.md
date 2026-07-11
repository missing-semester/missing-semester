---
layout: lecture
title: "Lebih dari Sekadar Kode"
description: >
  Pelajari keterampilan lunak penting termasuk dokumentasi, norma komunitas open-source, dan etika AI.
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
maintainer yang mewarisi kode Anda, atau diri Anda sendiri enam bulan dari
sekarang ketika Anda sudah lupa mengapa Anda membuat keputusan tertentu.
Saran utama untuk semua jenis penulisan ini adalah tujuan Anda adalah
menangkap dan menyampaikan *mengapa* (*why*), bukan hanya *apa* (*what*).
Bagian *apa* cenderung dapat dijelaskan dengan sendirinya, sementara *mengapa*
adalah pengetahuan yang diperoleh dengan susah payah dan mudah hilang
tergerus waktu.

Mungkin bentuk komunikasi paling umum antar-engineer (selain kode itu
sendiri) adalah komentar kode. Saya pribadi menemukan bahwa banyak komentar
kode tidak berguna. Tapi tidak harus demikian! Komentar yang baik menjelaskan
hal-hal yang tidak bisa dijelaskan oleh kode itu sendiri: *mengapa* sesuatu
dilakukan dengan cara tertentu, bukan *bagaimana* cara kerjanya (yang
ditunjukkan oleh kode). Komentar yang baik bisa menghemat waktu berjam-jam
dari kebingungan, sementara komentar yang buruk menambah noise atau, lebih
buruk lagi, menyesatkan.

Jenis komentar yang hampir selalu bermanfaat:

- **TODOs**: Tandai kode yang belum selesai atau belum dipoles, tetapi
  berikan konteks yang cukup agar orang lain dapat memahami apa yang masih
  harus diselesaikan dan mengapa ditunda. "TODO: optimize" tidak berguna;
  "TODO: this O(n²) loop is fine for `n<100`, but will need indexing if we
  scale" lebih dapat ditindaklanjuti.
- **References**: Tautkan ke sumber eksternal ketika kode mengimplementasikan
  algoritma dari sebuah paper, mengadaptasi kode dari tempat lain, atau
  mengencode perilaku yang ditentukan dalam dokumentasi. Gunakan permalink.
  Catat setiap penyimpangan dari referensi.
- **Correctness arguments**: Jelaskan *mengapa* kode yang tidak trivial
  menghasilkan hasil yang benar. Kode menunjukkan langkah-langkahnya;
  komentar menjelaskan mengapa langkah-langkah tersebut berhasil.
- **Hard-learned lessons**: Jika Anda menghabiskan 30+ menit untuk
  men-debug sesuatu dan solusinya adalah sebuah incantation yang tidak
  jelas, dokumentasikanlah. Diri Anda di masa lalu tidak menyadari bahwa
  itu diperlukan; pembaca di masa depan juga tidak.
- **Rationale for constants**: Angka-angka magic pantas dijelaskan. Mengapa
  1492? Mengapa 16 bit? Apakah dipilih secara acak, diturunkan dari
  pengujian, atau diperlukan untuk correctness? Bahkan "chosen arbitrarily"
  adalah informasi yang berguna.
- **Load-bearing choices**: Jika correctness bergantung pada detail
  implementasi yang tampaknya tidak berbahaya (misalnya, "must be a BTreeSet
  because iteration order matters below"), sebutkan secara eksplisit.
- **"Why not"s**: Ketika Anda dengan sengaja menghindari pendekatan yang
  jelas, jelaskan alasannya. Jika tidak, seseorang akan "memperbaikinya"
  nanti dan merusak segalanya.

README (Anda punya satu, kan?) juga merupakan titik sentuhan pertama yang
umum dengan developer lain. README yang baik menjawab empat pertanyaan
segera: Apa fungsi proyek ini? Mengapa saya harus peduli? Bagaimana cara
menggunakannya? Bagaimana cara menginstalnya? Dalam urutan tersebut.
Strukturkannya seperti corong: satu baris penjelasan dan mungkin demo
visual di bagian atas agar seseorang dapat memutuskan dalam hitungan detik
apakah ini menyelesaikan masalah mereka, kemudian tambahkan kedalaman secara
bertahap. Tunjukkan penggunaan sebelum instalasi — orang ingin melihat apa
yang mereka dapatkan sebelum melakukan langkah-langkah setup.

Commit message adalah jenis lain dari "menulis untuk orang lain" yang sering
diabaikan. Commit message sering ditulis sebagai "fixed blah" atau "added
foo", dan meskipun itu mungkin cukup dalam beberapa kasus, mudah lupa bahwa
mereka membentuk catatan historis tentang *mengapa* codebase berkembang
seperti sekarang. Ketika seseorang (termasuk Anda!) menjalankan `git blame`
untuk mencoba memahami perubahan yang membingungkan, commit message yang
baik seharusnya memberikan jawaban.

Secara umum, bagian body harus menjawab:
- Masalah apa yang memaksa perubahan ini?
- Alternatif apa saja yang Anda pertimbangkan?
- Apa trade-off atau implikasinya?
- Apa yang mungkin mengejutkan tentang pendekatan ini?

> Tentu saja Anda harus menyesuaikan tingkat detail dengan kompleksitas.
> Perbaikan typo satu baris hanya membutuhkan subject. Perbaikan race
> condition yang subtil yang memakan waktu berjam-jam untuk di-debug
> pantas mendapatkan paragraf yang menjelaskan masalah dan solusinya.

Untuk perubahan yang kompleks, bisa berguna mengikuti struktur Problem →
Solution → Implications: Mulai dengan pemicu atau limitasi, kemudian
jelaskan apa yang berubah dan keputusan desain utama, lalu daftar
konsekuensi yang patut diperhatikan (positif dan negatif). Bagian terakhir
sangat penting; rekayasa nyata melibatkan menyeimbangkan berbagai
pertimbangan, dan mendokumentasikan bahwa sebuah trade-off memang disengaja
mencegah developer di masa depan mengira Anda melewatkan masalah tersebut.

LLM _bisa_ membantu dalam menulis commit message. Namun, jika Anda hanya
menunjuk ke perubahan Anda dan memintanya menulis commit message untuk
perubahan tersebut, LLM hanya akan memiliki akses ke _apa_, bukan _mengapa_.
Dan commit message yang dihasilkan karenanya akan sebagian besar bersifat
deskriptif (kebalikan dari yang kita inginkan!). Jika Anda menggunakan LLM
untuk membantu Anda membuat perubahan sejak awal, meminta LLM menulis commit
message di sesi yang sama bisa menjadi opsi yang jauh lebih baik karena
percakapan Anda dengan LLM secara inheren merupakan sumber konteks yang kaya
tentang perubahan tersebut! Jika tidak, atau sebagai tambahan, trik yang
berguna adalah secara khusus memberi tahu LLM bahwa Anda ingin commit
message yang berfokus pada "mengapa" (dan nuansa lainnya dari catatan di
atas), kemudian _minta LLM untuk menanyakan konteks yang hilang kepada
Anda_. Pada dasarnya, Anda bertindak seperti "tool" MCP yang bisa digunakan
oleh coding agent untuk "membaca" konteks.

Seiring perubahan Anda menjadi semakin kompleks, pastikan untuk juga
memecah commit secara logis (`git add -p` adalah teman Anda). Setiap commit
harus mewakili satu perubahan yang koheren yang dapat dipahami dan
di-review secara independen. Jangan mencampur refactoring dengan fitur baru
atau menggabungkan perbaikan bug yang tidak terkait, karena ini mengaburkan
cerita tentang perubahan mana yang memperbaiki masalah apa, dan hampir
pasti akan memperlambat review perubahan Anda pada akhirnya. Ini juga
memberi Anda kekuatan super melalui `git bisect`, tapi itu cerita untuk
waktu lain.

> Satu catatan saat Anda mulai lebih rajin dalam menulis teknis, dan
> menggunakannya secara lebih ekstensif, pastikan Anda menghormati pembaca.
> Mudah terjebak dalam penjelasan berlebihan setelah Anda mulai, tetapi
> Anda harus menahan dorongan itu agar pembaca tidak mengabaikan _semua_
> yang telah Anda tulis. Jelaskan "mengapa" dan percayai mereka untuk
> mencari tahu "bagaimana" untuk situasi mereka.

# Kolaborasi

Sebagai engineer, kita mungkin menghabiskan sebagian besar pekerjaan kita
untuk coding di depan keyboard, tetapi sebagian waktu kita juga dihabiskan
untuk berkomunikasi dengan orang lain. Waktu tersebut biasanya terbagi
menjadi kolaborasi dan edukasi, dan manfaat dari berinvestasi untuk menjadi
lebih baik di keduanya sangat signifikan.

## Berkontribusi

Baik Anda mengirimkan bug report, berkontribusi perbaikan bug sederhana,
atau mengimplementasikan fitur besar, perlu diingat bahwa biasanya terdapat
beberapa orde magnitudo lebih banyak pengguna daripada kontributor, dan
satu orde magnitudo lebih banyak kontributor daripada maintainer. Akibatnya,
waktu maintainer sangat terbatas. Jika Anda ingin meningkatkan kemungkinan
kontribusi Anda membuahkan hasil yang produktif, Anda harus memastikan bahwa
kontribusi Anda membawa rasio signal-to-noise yang tinggi dan sepadan dengan
waktu para maintainer.

Sebagai contoh, bug report yang baik menghormati waktu maintainer dengan
menyediakan semua yang diperlukan untuk memahami dan mereproduksi masalah:

- **Environment**: OS, nomor versi, konfigurasi yang relevan
- **Apa yang Anda harapkan** vs **apa yang sebenarnya terjadi**
- **Langkah-langkah untuk mereproduksi**: Spesifik. "Click the button"
  kurang berguna daripada "Click the Submit button on the /settings page
  while logged in as an admin."
- **Apa yang sudah Anda coba**: Ini mencegah saran yang duplikat dan
  menunjukkan bahwa Anda sudah melakukan investigasi

> Jika Anda menemukan kerentanan keamanan, jangan mempublikasikannya secara
> terbuka. Hubungi maintainer secara pribadi terlebih dahulu dan beri mereka
> waktu yang memadai untuk memperbaikinya sebelum disclosure. Banyak proyek
> memiliki file SECURITY.md atau sejenisnya untuk tujuan ini.

**Pastikan Anda mencari issue yang sudah ada.** Bug atau feature request
Anda mungkin sudah dilaporkan, dan jauh lebih baik menambahkan informasi
ke diskusi yang sudah ada daripada membuat duplikat. Belum lagi, ini
mengurangi noise bagi para maintainer.

Minimal reproducible examples sangat berharga, jika Anda bisa
menghasilkannya. Ini menghemat banyak waktu dan usaha maintainer, dan
mereproduksi bug secara konsisten seringkali merupakan bagian tersulit
dalam memperbaikinya. Belum lagi, usaha yang Anda lakukan untuk mengisolasi
masalah seringkali membantu Anda memahaminya dengan lebih baik juga, dan
kadang-kadang mengarahkan Anda untuk menemukan solusi sendiri.

Jika Anda tidak segera mendapat balasan, ingatlah bahwa maintainer seringkali
adalah relawan dengan waktu terbatas. Jika Anda menunggu balasan dari mereka,
follow-up yang sopan setelah beberapa minggu masih wajar; ping setiap hari
tidak. Demikian pula, komentar "me too", atau bug report yang hanya berisi
copy-paste output terminal cenderung bersifat net-negatif dalam hal
mendapatkan perhatian untuk issue Anda.

Jika Anda ingin membuat kontribusi kode, Anda juga perlu membiasakan diri
dengan panduan kontribusi. Banyak proyek memiliki `CONTRIBUTING.md` —
ikutilah. Anda juga biasanya ingin mulai dari yang kecil; perbaikan typo
atau perbaikan dokumentasi adalah kontribusi pertama yang bagus karena
membantu Anda mempelajari proses proyek tanpa harus melalui banyak bolak-balik
tentang kontennya.

> Periksa lisensi apa yang digunakan proyek, karena kode apa pun yang Anda
> kontribusikan akan berada di bawah lisensi yang sama. Khususnya, perhatikan
> lisensi copyleft (seperti GPL), yang mengharuskan karya turunan juga
> bersifat open source dan mungkin memiliki implikasi bagi pemberi kerja
> Anda jika Anda menyentuhnya! [choosealicense.com](https://choosealicense.com/)
> memiliki informasi yang lebih berguna.

Ketika Anda memutuskan untuk membuka pull request ("PR"), pertama-tama
pastikan Anda mengisolasi perubahan yang sebenarnya ingin Anda terima. Jika
PR Anda mengubah banyak hal lain yang tidak terkait pada saat yang sama,
kemungkinan reviewer akan mengembalikannya kepada Anda dan meminta Anda
membersihkannya. Ini mirip dengan bagaimana Anda harus memecah git commit
Anda menjadi bagian-bagian yang terkait secara semantis.

Dalam beberapa kasus, jika Anda memiliki banyak perubahan yang tampaknya
berbeda-beda tetapi semuanya diperlukan untuk mengaktifkan satu fitur,
mungkin boleh membuka PR yang lebih besar yang mencakup semua perubahan
tersebut. Namun, dalam kasus ini, kebersihan commit sangat penting agar
maintainer memiliki opsi untuk me-review perubahan tersebut "commit demi
commit".

Selanjutnya, pastikan Anda menjelaskan "mengapa" di balik perubahan dengan
baik. Jangan hanya mendeskripsikan _apa_ yang berubah — jelaskan _mengapa_
perubahan tersebut diperlukan dan _mengapa_ ini adalah cara yang baik untuk
mengatasi masalah tersebut. Anda juga harus secara proaktif menyebut bagian-bagian
perubahan yang memerlukan perhatian khusus dalam review, jika ada. Tergantung
pada `CONTRIBUTING.md` dan sifat perubahan Anda, reviewer mungkin juga
mengharapkan informasi tambahan seperti trade-off yang Anda buat atau cara
menguji perubahan tersebut.

> Kami merekomendasikan untuk berkontribusi kembali ke proyek upstream
> daripada "mem-fork" proyek, setidaknya sebagai pendekatan pertama.
> Forking (jika lisensi mengizinkan) sebaiknya dicadangkan untuk ketika
> kontribusi yang ingin Anda buat berada di luar lingkup proyek asli.
> Jika Anda melakukan fork, pastikan Anda mengakui proyek aslinya!

AI membuat sangat mudah untuk menghasilkan kode dan PR yang terlihat
masuk akal dengan cepat, tetapi ini tidak membebaskan Anda dari kewajiban
untuk memahami apa yang Anda kontribusikan. Mengirimkan kode hasil
generate AI yang tidak dapat Anda jelaskan membebani maintainer dengan
review dan potensi pemeliharaan kode yang bahkan pembuatnya sendiri tidak
paham. Tidak masalah menggunakan AI untuk membantu mengidentifikasi masalah
dan menghasilkan perbaikan/fitur, **selama Anda tetap melakukan due
diligence** untuk memolesnya menjadi kontribusi yang berharga, daripada
meneruskan pekerjaan tersebut kepada maintainer (yang sudah kelebihan beban).

Ingat bahwa bagi maintainer, menerima PR berarti menerima tanggung jawab
jangka panjang. Mereka akan memelihara kode ini jauh setelah kontributor
beralih ke hal lain, dan mungkin menolak perubahan yang bermaksud baik
tetapi tidak sesuai dengan arah proyek, menambah kompleksitas yang tidak
ingin mereka pelihara, atau di mana kebutuhannya simplemente tidak
terdokumentasi dengan cukup baik. Ini menjadi tanggung jawab _Anda_ sebagai
kontributor untuk memberikan argumen mengapa menerima kontribusi tersebut
sepadan dengan beban pemeliharaannya.

> Saat menerima umpan balik pada PR, ingatlah bahwa kode Anda bukanlah
> diri Anda! Reviewer berusaha membuat kode menjadi lebih baik, bukan
> mengkritik Anda secara pribadi. Ajukan pertanyaan klarifikasi jika Anda
> tidak setuju — Anda mungkin belajar sesuatu, atau mungkin mereka yang
> akan belajar.

## Me-review

Anda mungkin berpikir code review adalah sesuatu yang dilakukan developer
senior, tetapi Anda mungkin akan diminta untuk me-review kode jauh lebih
awal dari yang Anda duga, dan perspektif Anda berharga. Mata yang segar
dapat menangkap hal-hal yang dilewatkan oleh developer berpengalaman, dan
pertanyaan dari seseorang yang kurang familiar dengan kode seringkali
mengungkap asumsi yang seharusnya didokumentasikan atau disederhanakan.

Review juga merupakan salah satu cara tercepat untuk belajar. Anda akan
melihat bagaimana orang lain mendekati masalah, mempelajari pola dan idiom,
dan mengembangkan intuisi tentang apa yang membuat kode mudah dibaca. Di
luar pertumbuhan pribadi, review menangkap bug sebelum mencapai production,
menyebarkan pengetahuan di seluruh tim, dan meningkatkan kualitas kode
melalui kolaborasi. Review bukan sekadar overhead birokrasi.

Code review yang baik adalah keterampilan yang perlu Anda asah seiring
waktu, tetapi ada beberapa tips yang bisa membuatnya jauh lebih baik
dengan lebih cepat:

- **Review kodenya, bukan orangnya**:
  "This function is confusing" vs "You wrote confusing code."
- **Utamakan komentar yang dapat ditindaklanjuti**:
  "Can you replace these globals with a config dataclass" adalah komentar
  yang lebih mudah ditangani daripada "Don't use globals here"
- **Ajukan pertanyaan daripada membuat tuntutan**:
  "What happens if X is null here?" lebih mengundang diskusi daripada
  "Handle the null case."
- **Jelaskan "mengapa"**:
  "Consider using a constant here" kurang berguna daripada "Consider using
  a constant here so we can easily adjust the timeout based on environment."
- **Bedakan antara masalah blocking dan saran**:
  Jelaskan dengan jelas apa yang harus diubah versus apa yang hanya masalah
  preferensi.
- **Akui apa yang baik**:
  Menunjukkan solusi yang cerdas atau implementasi yang bersih sangat
  mendorong dan membantu penulis mengetahui apa yang harus dilanjutkan.
- **Tahu kapan harus berhenti**:
  Kontributor hanya punya waktu dan kesabaran terbatas, dan tidak selalu
  terbaik dihabiskan untuk menangani semua hal-hal kecil. Fokus pada hal-hal
  besar, dan pertimbangkan untuk merapikan hal-hal kecil sendiri setelahnya.

> Tool AI dapat menangkap masalah tertentu, tetapi bukan pengganti untuk
> review manusia. Mereka melewatkan konteks, tidak memahami persyaratan
> produk, dan dapat dengan percaya diri menyarankan hal-hal yang salah.
> Mereka layak digunakan sebagai first pass, tetapi bukan pengganti untuk
> review manusia yang penuh pertimbangan.

# Edukasi

Banyak waktu non-coding kita sebagai engineer dihabiskan untuk mengajukan
atau menjawab pertanyaan, mungkin campuran keduanya; selama kolaborasi,
dalam dialog dengan rekan, atau saat mencoba belajar. Mengajukan pertanyaan
yang baik adalah keterampilan yang membuat Anda lebih baik dalam belajar
dari siapa pun, bukan hanya dari penjelas yang sempurna. Julia Evans
memiliki beberapa posting blog yang sangat bagus tentang "[How to ask good
questions](https://jvns.ca/blog/good-questions/)" dan "[How to get useful
answers to your
questions](https://jvns.ca/blog/2021/10/21/how-to-get-useful-answers-to-your-questions/)"
yang layak dibaca.

Beberapa saran yang sangat berharga adalah:

- **Nyatakan pemahaman Anda terlebih dahulu**: Katakan apa yang Anda pikir
  Anda ketahui dan tanyakan "is that right?" Ini membantu pemberi jawaban
  mengidentifikasi celah pengetahuan Anda yang sebenarnya.
- **Ajukan pertanyaan ya/tidak**: "Is X true?" mencegah penjelasan yang
  melebar dan biasanya tetap mendorong elaborasi yang berguna.
- **Spesifik**: "How do SQL joins work?" terlalu umum. "Does a LEFT JOIN
  include rows where the right table has no match?" dapat dijawab.
- **Akui ketika Anda tidak paham**: Potong pembicaraan untuk bertanya
  tentang istilah yang tidak familiar. Ini mencerminkan kepercayaan diri,
  bukan kelemahan. Demikian pula, jika mereka mengajukan pertanyaan kepada
  Anda yang tidak Anda ketahui jawabannya, yang terbaik adalah mengatakan
  "I don't know", dan mungkin melanjutkan dengan "but I think ..." atau
  bahkan "but I can find out".
- **Jangan menerima jawaban yang tidak lengkap**: Terus ajukan pertanyaan
  lanjutan sampai Anda benar-benar paham.
- **Lakukan riset terlebih dahulu**: Investigasi dasar membantu Anda
  mengajukan pertanyaan yang lebih tertarget (meskipun pertanyaan kasual
  antar rekan kerja tidak masalah).

Ingat: pertanyaan yang dirancang dengan baik bermanfaat bagi seluruh
komunitas. Mereka mengungkap asumsi tersembunyi yang juga perlu dipahami
oleh orang lain.

> Perhatikan bahwa saran ini juga berlaku saat berkomunikasi dengan LLM!

# Etika AI

Dengan meningkatnya penggunaan LLM dan AI dalam software engineering,
norma sosial dan profesional di sekitarnya masih dalam perubahan. Kami
sudah membahas banyak pertimbangan taktis di [agentic coding
lecture](/2026/agentic-coding/), tetapi ada juga bagian "lebih lunak" dari
penggunaannya yang patut dibahas.

Yang pertama adalah ketika AI berkontribusi secara signifikan terhadap
pekerjaan Anda, **ungkapkan hal tersebut**. Ini bukan tentang rasa malu —
ini tentang kejujuran, menetapkan ekspektasi yang sesuai, dan memastikan
karya yang dihasilkan mendapatkan tingkat review yang tepat. Juga berguna
untuk mengungkapkan _bagian mana_ yang Anda gunakan AI — ada perbedaan
yang bermakna antara "this whole thing is vibecoded" dan "I wrote this
backup tool and used an LLM to style the web frontend". Sebagai contoh,
kami telah menggunakan LLM untuk membantu menulis beberapa catatan kuliah
ini, termasuk proofreading, brainstorming, dan menghasilkan draf pertama
dari cuplikan kode dan latihan.

Anda juga perlu mengikuti norma-norma tim dan proyek yang Anda kontribusikan.
Beberapa tim memiliki kebijakan yang lebih ketat tentang penggunaan AI
daripada yang lain (misalnya, karena alasan kepatuhan atau residensi data),
dan Anda tidak ingin secara tidak sengaja melanggarnya. Terbuka tentang
penggunaan Anda membantu mencegah kesalahan yang berpotensi mahal.

> Jika Anda bertujuan untuk belajar sebagai bagian dari pekerjaan yang Anda
> lakukan, ingatlah bahwa jika Anda membiarkan AI melakukan semua atau
> sebagian besar pekerjaan untuk Anda bisa menjadi bumerang; Anda mungkin
> lebih banyak belajar tentang prompting (dan mungkin me-review output AI)
> daripada tugas itu sendiri. Terutama ketika Anda sedang belajar, tujuannya
> mungkin perjalanannya, bukan destinasinya, jadi menggunakan AI untuk
> "mendapatkan solusi dengan cepat" adalah anti-goal.

Keprihatinan yang terkait muncul dalam wawancara dan situasi penilaian
lainnya. Ini seringkali dimaksudkan untuk secara khusus mengevaluasi
keterampilan dan kemampuan _Anda_, bukan kemampuan LLM. Semakin banyak
perusahaan yang kini mengizinkan Anda menggunakan LLM dan tool bantuan AI
lainnya dalam wawancara selama Anda membiarkan mereka mengamati interaksi
tersebut sebagai bagian dari wawancara (yaitu, mereka juga mengevaluasi
keterampilan Anda dalam menggunakan tool-tool tersebut!), tetapi mereka
masih dalam minoritas. Jika Anda tidak yakin apakah bantuan AI diizinkan
untuk tugas tertentu, tanyakanlah!

> Sudah seharusnya jika situasi penilaian secara eksplisit melarang tool
> eksternal, LLM, dll., Anda tidak boleh menggunakannya. Mencoba melakukannya
> secara diam-diam tanpa ketahuan **pasti** akan berbalik merugikan Anda.

# Latihan

1. Telusuri source code dari proyek yang terkenal (misalnya,
   [Redis](https://github.com/redis/redis) atau
   [curl](https://github.com/curl/curl)). Temukan contoh beberapa jenis
   komentar yang disebutkan dalam kuliah: TODO yang berguna, referensi ke
   dokumentasi eksternal, komentar "why not" yang menjelaskan pendekatan
   yang dihindari, atau hard-learned lesson. Apa yang akan hilang jika
   komentar tersebut tidak ada?

1. Pilih proyek open-source yang Anda minati dan lihat riwayat commit
   terbarunya (`git log`). Temukan satu commit dengan pesan yang baik yang
   menjelaskan *mengapa* perubahan tersebut dibuat, dan satu dengan pesan
   yang lemah yang hanya mendeskripsikan *apa* yang berubah. Untuk yang
   lemah, lihat diff-nya (`git show <hash>`) dan coba tulis commit message
   yang lebih baik mengikuti struktur Problem → Solution → Implications.
   Perhatikan betapa banyak usaha yang diperlukan untuk menyusun kembali
   konteks yang diperlukan setelah fakta!

1. Bandingkan README dari tiga proyek GitHub dengan 1000+ bintang. Apakah
   semuanya sama-sama berguna? Carilah hal-hal yang menurut Anda lebih
   merupakan noise sebagai pelajaran untuk README yang Anda tulis sendiri
   di masa depan.

1. Temukan issue terbuka pada proyek yang Anda gunakan (periksa label "good
   first issue" atau "help wanted" jika ada). Evaluasi issue tersebut
   berdasarkan kriteria dari kuliah: apakah sepertinya menghargai waktu
   maintainer dan berisi semua informasi yang diperlukan untuk men-debug,
   atau Anda berharap maintainer mungkin perlu melalui beberapa putaran
   pertanyaan dengan pengirim untuk sampai ke masalah inti?

1. Pikirkan bug yang pernah Anda temui di perangkat lunak yang Anda gunakan
   (atau temukan satu di issue tracker). Berlatihlah membuat minimal
   reproducible example: hapus semua yang tidak terkait dengan bug sampai
   Anda memiliki kasus terkecil yang masih mendemonstrasikan masalah
   tersebut. Tuliskan apa yang Anda hapus dan alasannya.

1. Temukan pull request yang sudah di-merge pada proyek yang Anda kenal
   yang memiliki komentar review yang substantif (bukan hanya "LGTM").
   Baca review-nya. Apakah semua komentar sama-sama produktif? Jika Anda
   adalah penulis PR, bagaimana pengalaman Anda menerima semua komentar
   tersebut?

1. Buka Stack Overflow dan temukan pertanyaan dalam teknologi yang Anda
   ketahui yang memiliki jawaban dengan vote tinggi. Kemudian temukan satu
   yang ditutup atau banyak downvote. Bandingkan dengan saran dari kuliah;
   apakah bisa diprediksi pertanyaan mana yang akan mendapatkan jawaban
   lebih baik?
