---
layout: lecture
title: "Kualitas Kode"
description: >
  Pelajari tentang formatting, linting, pengujian, continuous integration, dan lainnya.
thumbnail: /static/assets/thumbnails/2026/lec9.png
date: 2026-01-23
ready: true
video:
  aspect: 56.25
  id: XBiLUNx84CQ
---

Terdapat berbagai alat dan teknik yang mendukung developer dalam menulis kode berkualitas tinggi. Dalam kuliah ini, kita akan membahas:

- [Formatting](#formatting)
- [Linting](#linting)
- [Testing](#testing)
- [Pre-commit hooks](#pre-commit-hooks)
- [Continuous integration](#continuous-integration)
- [Command runners](#command-runners)

Sebagai topik bonus, kita juga akan membahas [regular expressions](#regular-expressions), topik lintas bidang yang memiliki aplikasi dalam kualitas kode (misalnya, untuk menjalankan subset tes yang cocok dengan pola) maupun domain lain seperti IDE (misalnya, untuk search and replace).

Banyak dari alat-alat ini bersifat spesifik untuk bahasa pemrograman tertentu (misalnya, [Ruff](https://docs.astral.sh/ruff/) linter/formatter untuk Python). Dalam beberapa kasus, alat akan mendukung beberapa bahasa (misalnya, [Prettier](https://prettier.io/) code formatter). Namun, konsep-konsepnya hampir universal --- Anda dapat menemukan code formatter, linter, testing library, dan sebagainya untuk bahasa pemrograman apa pun.

# Pemformatan

Code auto-formatter secara otomatis mempercantik sintaks permukaan. Dengan cara ini, Anda dapat fokus pada masalah yang lebih dalam dan menantang, sementara alat auto-formatting menangani detail-detail sepele seperti konsistensi sintaks `'` versus `"` untuk string, memiliki spasi di sekitar operator biner (`x + y` alih-alih `x+y`), memiliki pernyataan `import` dalam urutan terurut, dan menghindari baris yang melebihi panjang tertentu. Salah satu manfaat utama code formatter adalah mereka menstandarisasi gaya kode di semua developer yang bekerja pada sebuah codebase.

Beberapa alat seperti Prettier [sangat dapat dikonfigurasi](https://prettier.io/docs/configuration); Anda harus menyimpan file konfigurasi dalam [version control](/2026/version-control/) untuk proyek Anda. Alat lain, seperti [Black](https://github.com/psf/black) dan [gofmt](https://pkg.go.dev/cmd/gofmt) memiliki konfigurasi yang terbatas atau tidak ada, untuk mengurangi [bikeshedding](https://en.wikipedia.org/wiki/Law_of_triviality).

Anda dapat mengatur [integrasi IDE](/2026/development-environment/#code-intelligence-and-language-servers) dengan code formatter Anda, sehingga kode Anda akan secara otomatis di-format saat Anda mengetik atau ketika Anda menyimpan file. Anda juga dapat menambahkan file [EditorConfig](https://editorconfig.org/) ke proyek Anda, yang mengkomunikasikan pengaturan tingkat proyek tertentu ke IDE Anda seperti ukuran indentasi untuk setiap jenis file.

# Linting

Linter menjalankan analisis statis (menganalisis kode Anda tanpa menjalankannya) untuk menemukan antipola dan masalah potensial dalam kode Anda. Alat-alat ini lebih mendalam daripada autoformatter, melihat melampaui sintaks permukaan. Kedalaman analisis bervariasi tergantung alat.

Linter dilengkapi dengan daftar _aturan_, dengan preset yang dapat dikonfigurasi pada tingkat proyek. Beberapa aturan linter menghasilkan positif palsu, sehingga Anda dapat menonaktifkannya per file atau per baris.

Linter yang baik akan memiliki bantuan bawaan atau dokumentasi yang menjelaskan setiap aturan linter --- apa yang dicari oleh aturan tersebut, mengapa itu buruk, dan apa alternatif yang lebih baik untuk pola kode tersebut. Misalnya, lihat dokumentasi untuk aturan [SIM102](https://docs.astral.sh/ruff/rules/collapsible-if/) di [Ruff](https://docs.astral.sh/ruff/) yang menangkap pernyataan `if` bersarang yang tidak perlu dalam kode Python.

Beberapa linter tidak hanya menandai masalah tetapi juga secara otomatis memperbaiki masalah tertentu untuk Anda.

Selain linter spesifik bahasa, alat lain yang mungkin berguna adalah [semgrep](https://github.com/semgrep/semgrep), alat "semantic grep" yang bekerja pada tingkat AST (bukan tingkat karakter, seperti grep) dan mendukung banyak bahasa. Anda dapat menggunakan semgrep untuk menulis aturan linter kustom dengan mudah untuk proyek Anda. Misalnya, jika Anda ingin mencegah `subprocess.Popen(..., shell=True)` yang berbahaya dalam Python, Anda dapat menemukan pola kode tersebut dengan:

```bash
semgrep -l python -e "subprocess.Popen(..., shell=True, ...)"
```

# Pengujian

Pengujian perangkat lunak adalah teknik standar untuk meningkatkan kepercayaan Anda pada kebenaran kode Anda. Anda menulis kode, dan kemudian Anda menulis kode yang menjalankan kode yang Anda tulis dan memunculkan error jika kode tidak bekerja sesuai yang diharapkan.

Anda dapat menulis tes untuk bagian-bagian kode pada berbagai tingkat granularitas: _unit test_ untuk fungsi individual, _integration test_ untuk interaksi antar modul atau layanan, dan _functional test_ untuk skenario end-to-end. Anda dapat melakukan _test-driven development_, di mana Anda menulis tes sebelum menulis kode implementasi. Ketika Anda menemukan bug dalam kode Anda, Anda dapat menulis _regression test_, sehingga Anda akan menangkap jika fungsionalitas tersebut rusak di masa depan. Anda dapat menulis _property-based test_, yang dipelopori oleh [QuickCheck](https://hackage.haskell.org/package/QuickCheck) di Haskell, dan diimplementasikan dalam banyak library, seperti [Hypothesis](https://hypothesis.readthedocs.io/) untuk Python. Pendekatan pengujian mana yang tepat tergantung pada proyek Anda; kemungkinan, Anda akan mengadopsi beberapa kombinasi.

Jika program Anda memiliki dependensi eksternal seperti database atau web API, mungkin berguna untuk melakukan _mock_ terhadap dependensi tersebut dalam tes Anda, daripada membiarkan kode Anda berinteraksi dengan dependensi pihak ketiga pada saat pengujian.

## Code coverage

Code coverage adalah metrik yang dapat Anda gunakan untuk mengukur seberapa baik tes Anda. Code coverage melihat baris kode mana yang dijalankan ketika tes Anda dijalankan, sehingga Anda dapat memastikan Anda mencakup semua jalur kode. Alat code coverage dapat menampilkan coverage baris per baris untuk memandu Anda dalam menulis tes. Layanan seperti [Codecov](https://app.codecov.io) menyediakan antarmuka web untuk melacak dan melihat code coverage sepanjang riwayat proyek.

Seperti metrik lainnya, code coverage tidak sempurna; jangan terlalu berfokus pada coverage, fokuslah pada menulis tes berkualitas tinggi.

# Hook pre-commit

Git pre-commit [hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks), yang dipermudah oleh framework [pre-commit](https://pre-commit.com/), secara otomatis menjalankan kode yang ditentukan pengguna sebelum setiap Git commit. Proyek-proyek umumnya menggunakan pre-commit hooks untuk menjalankan formatter dan linter, dan terkadang tes, secara otomatis sebelum setiap commit, untuk memastikan bahwa kode yang di-commit sesuai dengan gaya kode proyek dan bebas dari masalah tertentu.

# Integrasi berkelanjutan

Layanan continuous integration (CI) seperti [GitHub Actions](https://github.com/features/actions) dapat menjalankan skrip untuk Anda setiap kali Anda mendorong kode (atau pada setiap pull request, atau sesuai jadwal). Developer umumnya menggunakan layanan CI untuk menjalankan alat kualitas kode termasuk formatter, linter, dan tes. Untuk bahasa yang dikompilasi, Anda dapat memastikan kode dapat dikompilasi; untuk bahasa yang secara statis di-type, Anda dapat memastikan type checking berhasil. Menjalankan CI pada setiap push commit baru dapat menangkap error yang dimasukkan ke dalam versi utama kode; menjalankan pada pull request dapat menangkap masalah pada kontribusi dari kontributor; menjalankan sesuai jadwal dapat menangkap masalah dengan dependensi eksternal (misalnya, seorang developer secara tidak sengaja merilis breaking change sebagai [semver-compatible](/2026/shipping-code/#releases--versioning)).

Karena skrip CI berjalan secara terpisah dari mesin developer, Anda dapat dengan mudah menjalankan pekerjaan yang memakan waktu lama di sana. Ini dapat dimanfaatkan, misalnya, untuk menjalankan _matrix_ tes di berbagai sistem operasi dan versi bahasa pemrograman untuk memastikan bahwa perangkat lunak bekerja dengan baik di semua lingkungan tersebut.

Secara umum, skrip yang berjalan di CI tidak akan langsung membuat perubahan pada kode Anda: ia akan menjalankan alat dalam mode "check-only" alih-alih mode "fix", sehingga misalnya, auto-formatter akan memunculkan error ketika kode tidak sesuai dengan format.

Repositori sering menyertakan [status badge](https://docs.github.com/en/actions/how-tos/monitor-workflows/add-a-status-badge) di README mereka, menampilkan status CI dan informasi lainnya seperti code coverage. Sebagai contoh, di bawah ini adalah status build Missing Semester saat ini.

[![Build Status](https://github.com/missing-semester/missing-semester/actions/workflows/build.yml/badge.svg)](https://github.com/missing-semester/missing-semester/actions/workflows/build.yml) [![Links Status](https://github.com/missing-semester/missing-semester/actions/workflows/links.yml/badge.svg)](https://github.com/missing-semester/missing-semester/actions/workflows/links.yml)

> [Links checker](https://github.com/missing-semester/missing-semester/blob/master/.github/workflows/links.yml) kami, yang menggunakan GitHub Action [proof-html](https://github.com/anishathalye/proof-html) sering gagal, biasanya karena masalah dengan situs web pihak ketiga. Namun, ini telah membantu kami menangkap dan memperbaiki banyak tautan yang rusak (terkadang karena kesalahan ketik, sebagian besar karena situs web memindahkan konten tanpa menambahkan redirect atau situs web yang menghilang).

Cara yang baik untuk mempelajari detail layanan CI, formatter, linter, dan testing library adalah melalui contoh. Temukan proyek open-source berkualitas tinggi di GitHub --- semakin mirip dengan proyek Anda dalam bahasa pemrograman, domain, ukuran dan cakupan, dan sebagainya, semakin baik --- dan pelajari file `pyproject.toml`, `.github/workflows/`, `DEVELOPMENT.md`, dan file relevan lainnya.

## Deployment berkelanjutan

Continuous deployment memanfaatkan infrastruktur CI untuk benar-benar melakukan _deploy_ perubahan. Misalnya, repositori Missing Semester menggunakan continuous deployment ke GitHub pages sehingga setiap kali kita melakukan `git push` catatan kuliah yang diperbarui, situs secara otomatis di-build dan di-deploy. Anda dapat membangun [artifacts](/2026/shipping-code/) lain di CI, seperti biner untuk aplikasi atau Docker image untuk layanan.

# Command runner

Command runner seperti [just](https://github.com/casey/just) menyederhanakan tugas menjalankan perintah dalam konteks proyek. Saat Anda membangun infrastruktur kualitas kode untuk proyek Anda, Anda tidak ingin membuat developer Anda menghafal perintah seperti `uv run ruff check --fix`. Dengan command runner, ini bisa berubah menjadi `just lint`, dan Anda dapat memiliki pemanggilan analog seperti `just format`, `just typecheck`, dll., untuk semua alat berbeda yang mungkin ingin dijalankan oleh developer untuk proyek Anda.

Beberapa manajer proyek atau paket spesifik bahasa memiliki dukungan bawaan untuk fungsionalitas semacam ini, yang berarti Anda tidak perlu menggunakan alat yang tidak spesifik bahasa seperti `just`. Misalnya, bagian `scripts` dari `package.json` untuk [npm](https://nodejs.org/en/learn/getting-started/an-introduction-to-the-npm-package-manager) (Node.js) dan bagian `tool.hatch.envs.*.scripts` dari `pyproject.toml` untuk [Hatch](https://hatch.pypa.io/) (Python) mendukung fungsionalitas ini.

# Ekspresi reguler

_Regular expressions_, yang umum disingkat sebagai "regex", adalah bahasa yang digunakan untuk merepresentasikan kumpulan string. Pola regex umumnya digunakan untuk pencocokan pola dalam berbagai konteks seperti alat command-line dan IDE. Misalnya, [ag](https://github.com/ggreer/the_silver_searcher) mendukung pola regex untuk pencarian di seluruh codebase (misalnya, `ag "import .* as .*"` akan menemukan semua import yang di-rename dalam Python), dan [go test](https://pkg.go.dev/cmd/go#hdr-Test_packages) mendukung opsi `-run [regexp]` untuk memilih subset tes. Lebih lanjut, bahasa pemrograman memiliki dukungan bawaan atau library pihak ketiga untuk pencocokan regular expression, sehingga Anda dapat menggunakan regex untuk fungsionalitas seperti pencocokan pola, validasi, dan parsing.

Untuk membantu membangun intuisi, berikut adalah beberapa contoh pola regex. Dalam kuliah ini, kita menggunakan [sintaks regex Python](https://docs.python.org/3/library/re.html). Terdapat banyak varian regex, dengan sedikit perbedaan di antaranya, terutama dalam fungsionalitas yang lebih canggih. Anda dapat menggunakan penguji regex online seperti [regex101](https://regex101.com/) untuk mengembangkan dan men-debug regular expression.

- `abc` --- mencocokkan string literal "abc".
- `missing|semester` --- mencocokkan string "missing" atau string "semester".
- `\d{4}-\d{2}-\d{2}` --- mencocokkan tanggal dalam format YYYY-MM-DD, seperti "2026-01-14". Selain memastikan string terdiri dari empat digit, tanda hubung, dua digit, tanda hubung, dan dua digit, ini tidak memvalidasi tanggal, sehingga "2026-01-99" juga cocok dengan pola regex ini.
- `.+@.+` --- mencocokkan alamat email, string yang berisi beberapa teks, kemudian "@", dan kemudian beberapa teks lagi. Ini hanya melakukan validasi paling dasar dan mencocokkan string seperti "nonsense@@@email". Regex yang mencocokkan alamat email tanpa positif atau negatif palsu [ada](https://pdw.ex-parrot.com/Mail-RFC822-Address.html) tetapi tidak praktis.

## Sintaks Regex

Anda dapat menemukan panduan lengkap sintaks regex di [dokumentasi ini](https://docs.python.org/3/library/re.html#regular-expression-syntax) (atau salah satu dari banyak sumber lain yang tersedia online). Berikut adalah beberapa blok bangunan dasar:

- `abc` mencocokkan string literal, ketika karakter tidak memiliki makna khusus (dalam contoh ini, "abc")
- `.` mencocokkan karakter apa pun
- `[abc]` mencocokkan satu karakter yang ada dalam kurung (dalam contoh ini, "a", "b", atau "c")
- `[^abc]` mencocokkan satu karakter kecuali yang ada dalam kurung (misalnya, "d")
- `[a-f]` mencocokkan satu karakter yang ada dalam rentang yang ditunjukkan dalam kurung (misalnya, "c", tetapi bukan "q")
- `a|b` mencocokkan salah satu pola (misalnya, "a" atau "b")
- `\d` mencocokkan karakter digit apa pun (misalnya, "3")
- `\w` mencocokkan karakter kata apa pun (misalnya, "x")
- `\b` mencocokkan _batas_ kata apa pun (misalnya, dalam string "missing semester", mencocokkan tepat sebelum "m", tepat setelah "g", tepat sebelum "s", dan tepat setelah "r")
- `(...)` mencocokkan grup dari sebuah pola
- `...?` mencocokkan nol atau satu dari sebuah pola, seperti `words?` untuk mencocokkan "word" atau "words"
- `...*` mencocokkan berapa pun dari sebuah pola, seperti `.*` untuk mencocokkan berapa pun dari karakter apa pun
- `...+` mencocokkan satu atau lebih dari sebuah pola, seperti `\d+` untuk mencocokkan digit dalam jumlah tidak nol
- `...{N}` mencocokkan tepat N dari sebuah pola, seperti `\d{4}` untuk 4 digit
- `\.` mencocokkan "." literal
- `\\` mencocokkan "\\" literal
- `^` mencocokkan awal baris
- `$` mencocokkan akhir baris

## Capture group dan referensi

Jika Anda menggunakan grup regex `(...)`, Anda dapat merujuk ke bagian-bagian dari pencocokan untuk tujuan ekstraksi atau search-and-replace. Misalnya, untuk mengekstrak hanya bulan dari tanggal gaya YYYY-MM-DD, Anda dapat menggunakan kode Python berikut:

```python
>>> import re
>>> re.match(r"\d{4}-(\d{2})-\d{2}", "2026-01-14").group(1)
'01'
```

Di editor teks Anda, Anda dapat menggunakan referensi capture group dalam pola replace. Sintaksnya mungkin berbeda antar IDE. Misalnya, di VS Code, Anda dapat menggunakan variabel seperti `$1`, `$2`, dll., dan di Vim, Anda dapat menggunakan `\1`, `\2`, dll., untuk mereferensikan grup.

## Keterbatasan

[Bahasa reguler](https://en.wikipedia.org/wiki/Regular_language) sangat kuat tetapi terbatas; ada kelas string yang tidak dapat diekspresikan sebagai regex standar (misalnya, [tidak mungkin](https://en.wikipedia.org/wiki/Pumping_lemma_for_regular_languages) untuk menulis regular expression yang mencocokkan kumpulan string {a^n b^n \| n &ge; 0}, kumpulan string sejumlah "a" diikuti oleh jumlah "b" yang sama; lebih praktis, bahasa seperti HTML bukan bahasa reguler). Dalam praktiknya, mesin regex modern mendukung fitur seperti lookahead dan backreference yang memperluas dukungan di luar bahasa reguler, dan mereka sangat berguna secara praktis, tetapi penting untuk mengetahui bahwa mereka masih terbatas dalam kekuatan ekspresifnya. Untuk bahasa yang lebih canggih, Anda mungkin perlu menggunakan jenis parser yang lebih mampu (salah satu contohnya, lihat [pyparsing](https://github.com/pyparsing/pyparsing), parser [PEG](https://en.wikipedia.org/wiki/Parsing_expression_grammar)).

## Belajar regex

Kami merekomendasikan untuk mempelajari dasar-dasarnya (apa yang telah kita bahas dalam kuliah ini), dan kemudian melihat referensi regex saat Anda membutuhkannya, daripada menghafal keseluruhan bahasa.

Alat AI percakapan dapat efektif dalam membantu Anda menghasilkan pola regex. Misalnya, coba berikan prompt ke LLM favorit Anda dengan query berikut:

```
Write a Python-style regex pattern that matches the requested path from log lines from Nginx. Here is an example log line:

169.254.1.1 - - [09/Jan/2026:21:28:51 +0000] "GET /feed.xml HTTP/2.0" 200 2995 "-" "python-requests/2.32.3"
```

# Latihan

1. Konfigurasikan formatter, linter, dan pre-commit hooks untuk proyek yang sedang Anda kerjakan. Jika Anda memiliki banyak error: autoformatting akan menangani error format. Untuk error linter, coba gunakan [AI agent](/2026/agentic-coding/) untuk memperbaiki semua error linter. Pastikan AI agent dapat menjalankan linter dan mengamati hasilnya, sehingga dapat berjalan dalam loop iteratif untuk memperbaiki semua masalah. Periksa hasilnya dengan hati-hati untuk memastikan AI tidak merusak kode Anda!
1. Pelajari testing library untuk bahasa yang Anda kuasai dan tulis unit test untuk proyek yang sedang Anda kerjakan. Jalankan alat code coverage, buat laporan coverage dalam format HTML, dan amati hasilnya. Dapatkah Anda menemukan baris-baris yang ter-cover? Code coverage Anda kemungkinan akan sangat rendah. Coba tulis beberapa tes secara manual untuk meningkatkannya. Coba gunakan [AI agent](/2026/agentic-coding/) untuk meningkatkan coverage; pastikan coding agent dapat menjalankan tes dengan coverage dan menghasilkan laporan coverage baris per baris, sehingga ia tahu di mana harus fokus. Apakah tes yang dihasilkan AI benar-benar bagus?
1. Atur continuous integration untuk berjalan pada setiap push untuk proyek yang sedang Anda kerjakan. Buat CI menjalankan formatting, linting, dan tes. Rusak kode Anda dengan sengaja (misalnya, perkenalkan pelanggaran linter), dan pastikan CI menangkapnya.
1. Coba tulis [pola regex](#regular-expressions) dan gunakan [alat command-line](/2026/course-shell/) `grep` untuk menemukan kemunculan `subprocess.Popen(..., shell=True)` dalam kode Anda. Sekarang, coba "rusak" pola regex tersebut. Apakah [semgrep](#linting) masih berhasil mencocokkan kode berbahaya yang membingungkan pemanggilan grep Anda?
1. Latih search-and-replace regex di IDE atau editor teks Anda dengan mengganti [penanda bullet Markdown](https://spec.commonmark.org/0.31.2/#bullet-list-marker) `-` dengan penanda bullet `*` di [catatan kuliah ini](https://raw.githubusercontent.com/missing-semester/missing-semester/refs/heads/master/_2026/code-quality.md). Perhatikan bahwa mengganti semua karakter "-" dalam file akan salah, karena ada banyak penggunaan karakter tersebut yang bukan penanda bullet.
1. Tulis regex untuk menangkap dari struktur JSON berbentuk `{"name": "Alyssa P. Hacker", "college": "MIT"}` nama tersebut (misalnya, `Alyssa P. Hacker`, dalam contoh ini). Petunjuk: dalam percobaan pertama Anda, Anda mungkin berakhir menulis regex yang mengekstrak `Alyssa P. Hacker", "college": "MIT`; baca tentang greedy quantifier di [dokumentasi regex Python](https://docs.python.org/3/library/re.html) untuk mengetahui cara memperbaikinya.
    1. Buat pola regex bekerja bahkan dalam situasi di mana nama memiliki karakter `"` di dalamnya (tanda kutip ganda dapat di-escape dalam JSON dengan `\"`).
    1. Kami **tidak** merekomendasikan menggunakan regular expression untuk masalah parsing yang canggih dalam praktiknya. Cari tahu cara menggunakan JSON parser bahasa pemrograman Anda untuk tugas ini. Tulis program command-line yang menerima sebagai input, pada stdin, struktur JSON berbentuk seperti yang dijelaskan di atas, dan mengeluarkan, pada stdout, nama tersebut. Anda hanya perlu beberapa baris kode untuk melakukan ini. Dalam Python, Anda dapat melakukannya dengan mudah dalam satu baris kode di luar `import json`.
