---
layout: lecture
title: "Coding dengan Agen AI"
description: >
  Pelajari cara menggunakan agen coding AI secara efektif untuk tugas-tugas pengembangan perangkat lunak.
thumbnail: /static/assets/thumbnails/2026/lec7.png
date: 2026-01-21
ready: true
video:
  aspect: 56.25
  id: sTdz6PZoAnw
---

Agen coding adalah model AI konversasional yang memiliki akses ke berbagai alat seperti membaca/menulis file, pencarian web, dan menjalankan perintah shell. Agen ini tersedia baik di dalam IDE maupun sebagai alat command-line atau GUI terpisah. Agen coding sangat otonom dan powerful, sehingga mendukung berbagai macam kasus penggunaan.

Kuliah ini melanjutkan materi pengembangan berbasis AI dari kuliah [Development Environment and Tools](/2026/development-environment/). Sebagai demo singkat, mari kita lanjutkan contoh dari bagian [AI-powered development](/2026/development-environment/#ai-powered-development):

```python
from urllib.request import urlopen

def download_contents(url: str) -> str:
    with urlopen(url) as response:
        return response.read().decode('utf-8')

def extract(content: str) -> list[str]:
    import re
    pattern = r'\[.*?\]\((.*?)\)'
    return re.findall(pattern, content)

print(extract(download_contents("https://raw.githubusercontent.com/missing-semester/missing-semester/refs/heads/master/_2026/development-environment.md")))
```

Kita bisa mencoba memberikan tugas berikut kepada agen coding:

```
Turn this into a proper command-line program, with argparse for argument parsing. Add type annotations, and make sure the program passes type checking.
```

Agen akan membaca file tersebut untuk memahaminya, kemudian melakukan beberapa perubahan, dan akhirnya menjalankan type checker untuk memastikan anotasi tipe sudah benar. Jika terjadi kesalahan sehingga gagal type checking, agen kemungkinan akan melakukan iterasi, meskipun ini adalah tugas sederhana sehingga kecil kemungkinannya terjadi kesalahan. Karena agen coding memiliki akses ke alat-alat yang berpotensi berbahaya, secara default, harness agen akan meminta pengguna untuk mengonfirmasi pemanggilan alat.

> Jika agen coding membuat kesalahan --- misalnya, jika binary `mypy` tersedia langsung di `$PATH` tetapi agen mencoba memanggil `python -m mypy` --- Anda dapat memberikan umpan balik berupa teks untuk membantu agen mengoreksi arahnya.

Agen coding mendukung interaksi multi-turn, sehingga Anda dapat melakukan iterasi pekerjaan melalui percakapan bolak-balik dengan agen. Anda bahkan dapat menginterupsi agen jika arahnya salah. Satu model mental yang berguna adalah seperti seorang manajer yang mengelola seorang intern: intern akan mengerjakan detail-detail teknis, tetapi membutuhkan bimbingan, dan sesekali melakukan hal yang salah sehingga perlu dikoreksi.

> Untuk demo yang lebih ilustratif, coba minta agen untuk menjalankan script hasilnya sebagai tindak lanjut. Amati outputnya, dan coba minta agen untuk melakukan perubahan (misalnya, minta agar hanya menyertakan URL absolut).

# Cara kerja model dan agen AI

Menjelaskan secara lengkap cara kerja [large language models (LLMs)](https://en.wikipedia.org/wiki/Large_language_model) modern dan infrastruktur seperti harness agen berada di luar cakupan kuliah ini. Namun, memahami beberapa ide kunci secara garis besar akan sangat membantu untuk _menggunakan_ teknologi mutakhir ini secara efektif dan memahami keterbatasannya.

LLM dapat dipandang sebagai pemodelan distribusi probabilitas dari string kompleksi (output) berdasarkan string prompt (input). Inferensi LLM (yang terjadi ketika Anda, misalnya, memberikan query ke aplikasi chat konversasional) _melakukan sampling_ dari distribusi probabilitas ini. LLM memiliki _context window_ yang tetap, yaitu panjang maksimum dari string input dan output.

{% comment %}
> In mathematical notation, the LLM models the probability distribution $\pi_\theta$ of completions $y$ conditioned on prompts $x$, and we sample from this distribution: $\hat{y} \sim \pi_\theta(\cdot \mid x)$.
{% endcomment %}

Alat-alat AI seperti chat konversasional dan agen coding dibangun di atas primitif ini. Untuk interaksi multi-turn, aplikasi chat dan agen menggunakan penanda giliran dan menyediakan seluruh riwayat percakapan sebagai string prompt setiap kali ada prompt baru dari pengguna, sehingga menjalankan inferensi LLM sekali per prompt pengguna. Untuk agen yang mendukung pemanggilan alat, harness menginterpretasikan output LLM tertentu sebagai permintaan untuk memanggil sebuah alat, dan harness menyediakan hasil pemanggilan alat tersebut kembali ke model sebagai bagian dari string prompt (sehingga inferensi LLM dijalankan lagi setiap kali ada pemanggilan/respons alat). Konsep-konsep inti dalam agen pemanggilan alat dapat [diimplementasikan dalam 200 baris kode](https://www.mihaileric.com/The-Emperor-Has-No-Clothes/).

## Privasi

Sebagian besar alat coding AI dalam konfigurasi standar mengirimkan banyak data Anda ke cloud. Terkadang harness berjalan secara lokal sementara inferensi LLM berjalan di cloud, dan terkadang lebih banyak lagi perangkat lunak yang berjalan di cloud (dan, misalnya, penyedia layanan mungkin secara efektif mendapatkan salinan seluruh repositori Anda serta semua interaksi Anda dengan alat AI).

Terdapat alat coding AI open-source dan LLM open-source yang cukup bagus (meskipun tidak sebaik model proprietary), namun saat ini, bagi sebagian besar pengguna, menjalankan LLM open mutakhir secara lokal tidak akan memungkinkan karena keterbatasan perangkat keras.

# Kasus penggunaan

Agen coding dapat membantu untuk berbagai macam tugas. Beberapa contoh:

- **Mengimplementasikan fitur baru.** Seperti pada contoh di atas, Anda dapat meminta agen coding untuk mengimplementasikan sebuah fitur. Memberikan spesifikasi yang baik lebih merupakan seni daripada sains saat ini; Anda ingin input ke agen cukup deskriptif sehingga agen melakukan apa yang Anda inginkan (setidaknya mengarah ke arah yang benar sehingga Anda dapat melakukan iterasi), tetapi tidak terlalu deskriptif sampai-sampai Anda yang melakukan terlalu banyak pekerjaan. Test-driven development bisa sangat efektif: tulis test (atau gunakan agen coding untuk membantu Anda menulis test), audit test tersebut untuk memastikan mereka menangkap apa yang Anda inginkan, lalu minta agen coding untuk mengimplementasikan fiturnya. Model terus-menerus mengalami peningkatan, jadi Anda harus menjaga intuisi Anda tetap terkini tentang kemampuan model-model tersebut.
    > Kami menggunakan Claude Code untuk [mengimplementasikan](https://github.com/missing-semester/missing-semester/pull/345) sidenotes bergaya Tufte ini.
{%- comment %}
No need to demo this, since the intro of a lecture was a small demo of adding a new feature.
{% endcomment %}
- **Memperbaiki error.** Jika Anda memiliki error dari compiler, linter, type checker, atau test, Anda dapat meminta agen untuk memperbaikinya, misalnya dengan prompt seperti "fix the issues with mypy". Model coding sangat efektif ketika Anda dapat memasukkannya ke dalam loop umpan balik, jadi cobalah mengatur agar model dapat menjalankan check yang gagal secara langsung, sehingga model dapat melakukan iterasi secara otonom. Jika hal ini tidak praktis, Anda dapat memberikan umpan balik ke model secara manual.
    > Pada commit [f552b55](https://github.com/missing-semester/missing-semester/commit/f552b5523462b22b8893a8404d2110c4e59613dd) di repositori missing-semester, kami memberikan prompt kepada Claude Code yaitu "Review the agentic coding lecture for typos and grammatical issues" dan kemudian memintanya untuk memperbaiki masalah yang ditemukannya, yang di-commit pada [f1e1c41](https://github.com/missing-semester/missing-semester/commit/f1e1c417adba6b4149f7eef91ff5624de40dc637).
{%- comment %}
Demo a coding agent fixing the bug in https://github.com/anishathalye/dotbot/commit/cef40c902ef0f52f484153413142b5154bbc5e99.

Write the failing tests to demo the bug, and then ask the agent to fix. Prepped in branch demo-bugfix.

Can run the failing test with:

    hatch test tests/test_cli.py::test_issue_357

Can prompt coding agent with:

    There is a bug I wrote a failing test for, you can repro it with `hatch test tests/test_cli.py::test_issue_357`. Fix the bug.

Get it to commit the changes.
{% endcomment %}
- **Refactoring.** Anda dapat menggunakan agen coding untuk melakukan refactoring kode dalam berbagai cara, mulai dari tugas sederhana seperti mengubah nama method (refactoring semacam ini juga didukung oleh [code intelligence](/2026/development-environment/#code-intelligence-and-language-servers)) hingga tugas yang lebih kompleks seperti memecah fungsionalitas ke dalam modul terpisah.
    > Kami menggunakan Claude Code untuk [memisahkan](https://github.com/missing-semester/missing-semester/pull/344) coding dengan agen AI menjadi kuliah tersendiri.
{%- comment %}
Show usage in Missing Semester, point out that the agent did make some mistakes.
{% endcomment %}
- **Code review.** Anda dapat meminta agen coding untuk melakukan review kode. Anda dapat memberikan panduan dasar, seperti "review my latest changes that are not yet committed". Jika Anda ingin me-review sebuah pull request dan agen coding Anda mendukung web fetch, atau Anda memiliki alat command-line seperti [GitHub CLI](https://cli.github.com/) yang terinstal, Anda bahkan mungkin bisa meminta agen coding "Review the pull request {link}" dan agen akan menanganinya dari sana.
{%- comment %}
In Porcupine repo, prompt agent with:

    Review this PR: https://github.com/anishathalye/porcupine/pull/39
{% endcomment %}
- **Memahami kode.** Anda dapat mengajukan pertanyaan kepada agen coding tentang sebuah codebase, yang bisa sangat membantu untuk onboarding.
{%- comment %}
Some prompts to try in the missing-semester repo:

    How do I run this site locally?

    How are the social preview cards implemented?
{% endcomment %}
- **Sebagai shell.** Anda dapat meminta agen coding untuk menggunakan alat tertentu guna menyelesaikan suatu tugas, sehingga Anda dapat menjalankan perintah shell menggunakan bahasa alami, seperti "use the find command to find all files older than 30 days" atau "use mogrify to resize all the jpgs to 50% of their original size".
{%- comment %}
In Dotbot repo, prompt agent with:

    Use the ag command to find all Python renaming imports
{% endcomment %}
- **Vibe coding.** Agen-agen cukup powerful sehingga Anda dapat mengimplementasikan beberapa aplikasi tanpa menulis satu baris kode pun.
    > [Berikut adalah contoh](https://github.com/cleanlab/office-presence-dashboard) proyek dunia nyata yang di-vibe-code oleh salah satu instruktur.
{%- comment %}
In missing-semester repo, prompt agent with:

    Make this site look retro.
{% endcomment %}

# Agen lanjutan

Di sini, kami memberikan ringkasan singkat tentang beberapa pola penggunaan dan kemampuan agen coding yang lebih lanjutan.

- **Prompt yang dapat digunakan kembali.** Buat prompt atau template yang dapat digunakan kembali. Misalnya, Anda dapat menulis prompt detail untuk melakukan code review dengan cara tertentu, dan menyimpannya sebagai prompt yang dapat digunakan kembali.
    > Perkakas agen berkembang dengan cepat. Di beberapa alat, prompt yang dapat digunakan kembali sebagai fitur mandiri sudah di-deprecated. Misalnya, di Codex dan Claude Code, mereka [digantikan](https://developers.openai.com/codex/custom-prompts) oleh [skills](https://code.claude.com/docs/en/skills).
- **Agen paralel.** Agen coding bisa lambat: Anda dapat memberikan prompt, dan agen bisa mengerjakan suatu masalah selama puluhan menit. Anda dapat menjalankan beberapa salinan agen secara bersamaan, baik mengerjakan tugas yang sama (LLM bersifat stokastik, jadi bisa membantu menjalankan hal yang sama beberapa kali dan mengambil solusi terbaik) maupun tugas yang berbeda (misalnya, mengimplementasikan dua fitur yang tidak tumpang tindih secara bersamaan). Untuk mencegah perubahan dari agen-agen yang berbeda saling mengganggu, Anda dapat menggunakan [git worktrees](https://git-scm.com/docs/git-worktree), yang kami bahas dalam kuliah tentang [version control](/2026/version-control/).
- **MCP.** MCP, kepanjangan dari _Model Context Protocol_, adalah protokol terbuka yang dapat Anda gunakan untuk menghubungkan agen coding Anda dengan berbagai alat. Misalnya, [Notion MCP server](https://github.com/makenotion/notion-mcp-server) ini dapat membiarkan agen Anda membaca/menulis dokumen Notion, sehingga memungkinkan kasus penggunaan seperti "baca spesifikasi yang tertaut di {Notion doc}, buat rancangan implementasi sebagai halaman baru di Notion, lalu implementasikan prototipenya". Untuk menemukan MCP, Anda dapat menggunakan direktori seperti [Pulse](https://www.pulsemcp.com/servers) dan [Glama](https://glama.ai/mcp/servers).
- **Manajemen konteks.** Seperti yang kami [sebutkan di atas](#cara-kerja-model-dan-agen-ai), LLM yang menjadi dasar agen coding memiliki _context window_ yang terbatas. Penggunaan agen coding secara efektif memerlukan pemanfaatan konteks yang baik. Anda ingin memastikan agen memiliki akses ke informasi yang dibutuhkan, tetapi menghindari konteks yang tidak perlu untuk mencegah overflow context window atau penurunan performa model (yang cenderung terjadi seiring bertambahnya ukuran konteks, meskipun tidak overflow context window). Harness agen secara otomatis menyediakan, dan sampai tingkat tertentu, mengelola konteks, tetapi banyak kontrol yang diserahkan kepada pengguna.
    - **Mengosongkan context window.** Kontrol paling dasar, agen coding mendukung pengosongan context window (memulai percakapan baru), yang sebaiknya Anda lakukan untuk query yang tidak berkaitan.
    - **Membatalkan langkah percakapan.** Beberapa agen coding mendukung pembatalan langkah-langkah dalam riwayat percakapan. Daripada memberikan pesan tindak lanjut yang mengarahkan agen ke arah yang berbeda, dalam situasi di mana "undo" lebih masuk akal, cara ini lebih efektif dalam mengelola konteks.
{%- comment %}
Make up a quick demo.
{% endcomment %}
    - **Kompaksi.** Untuk memungkinkan percakapan dengan panjang tak terbatas, agen coding mendukung _kompaksi_ konteks: jika riwayat percakapan menjadi terlalu panjang, mereka akan secara otomatis memanggil LLM untuk merangkum bagian awal percakapan, dan mengganti riwayat percakapan dengan rangkuman tersebut. Beberapa agen memberikan kontrol kepada pengguna untuk menjalankan kompaksi saat diinginkan.
{%- comment %}
Show `/compact` in Claude Code, show full summary.
{% endcomment %}
    - **llms.txt.** File `/llms.txt` adalah lokasi [standar](https://llmstxt.org/) yang diusulkan untuk dokumen yang dimaksudkan untuk digunakan oleh LLM saat inferensi. Produk (misalnya, [cursor.com/llms.txt](https://cursor.com/llms.txt)), pustaka perangkat lunak (misalnya, [ai.pydantic.dev/llms.txt](https://ai.pydantic.dev/llms.txt)), dan API (misalnya, [apify.com/llms.txt](https://apify.com/llms.txt)) mungkin memiliki file `llms.txt` yang berguna untuk pengembangan. Dokumen-dokumen ini lebih padat informasi per token, sehingga lebih efisien dalam penggunaan konteks dibandingkan meminta agen coding Anda untuk mengambil dan membaca halaman HTML. Dokumentasi eksternal sangat berguna ketika agen coding tidak memiliki pengetahuan bawaan tentang dependensi yang ingin Anda gunakan (misalnya, karena dependensi tersebut dipublikasikan setelah knowledge cutoff LLM).
{%- comment %}
Side-by-side comparison in an empty repo (on Desktop or some other self-contained place, with `git init` run in it):

    Write a single-file Python program example in demo.py using semlib to sort "Ilya Sutskever", "Soumith Chintala", and "Donald Knuth" in terms of their fame as AI researchers.

    Write a single-file Python program example in demo.py using semlib to sort "Ilya Sutskever", "Soumith Chintala", and "Donald Knuth" in terms of their fame as AI researchers. See https://semlib.anish.io/llms.txt. Follow links to Markdown versions of any pages linked in llms.txt files.

Not sure why the agent doesn't do this by default. You'd probably put that last sentence in a CLAUDE.md file.
{% endcomment %}
    - **AGENTS.md.** Sebagian besar agen coding mendukung [AGENTS.md](https://agents.md/) atau sejenisnya (misalnya, Claude Code mencari `CLAUDE.md`) sebagai README untuk agen coding. Ketika agen dimulai, ia mengisi konteks dengan seluruh isi `AGENTS.md`. Anda dapat menggunakan ini untuk memberikan saran kepada agen yang berlaku di semua sesi (misalnya, menginstruksikan agen untuk selalu menjalankan type-checker setelah melakukan perubahan kode, menjelaskan cara menjalankan unit test, atau memberikan tautan ke dokumentasi pihak ketiga yang dapat ditelusuri agen). Beberapa agen coding dapat menghasilkan file ini secara otomatis (misalnya, perintah `/init` di Claude Code). Lihat [di sini](https://github.com/pydantic/pydantic-ai/blob/main/CLAUDE.md) untuk contoh `AGENTS.md` di dunia nyata.
{%- comment %}
Dotbot example, CLAUDE.md that includes @DEVELOPMENT.md and says to always run the type checker and code formatter after making any changes to Python code.

Example prompt, off of master:

    Remove the "--version" command-line flag.

This is something that'll be fast, for demonstration purposes.
{% endcomment %}
    - **Skills.** Konten dalam `AGENTS.md` selalu dimuat secara keseluruhan ke dalam context window agen. _Skills_ menambahkan satu tingkat indireksi untuk menghindari pembengkakan konteks: Anda dapat menyediakan agen dengan daftar skills beserta deskripsinya, dan agen dapat "membuka" skill tersebut (memuatnya ke dalam context window) sesuai kebutuhan.
    - **Subagent.** Beberapa agen coding memungkinkan Anda mendefinisikan subagent, yaitu agen untuk alur kerja spesifik suatu tugas. Agen coding tingkat atas dapat memanggil sub-agent untuk menyelesaikan tugas tertentu, yang memungkinkan agen tingkat atas maupun subagent mengelola konteks secara lebih efektif. Konteks agen tingkat atas tidak membengkak dengan semua yang dilihat subagent, dan subagent hanya mendapatkan konteks yang dibutuhkan untuk tugasnya. Sebagai salah satu contoh, beberapa agen coding mengimplementasikan riset web sebagai subagent: agen tingkat atas akan mengajukan query ke subagent, yang akan menjalankan pencarian web, mengambil halaman-halaman web individual, menganalisisnya, dan memberikan jawaban atas query tersebut kepada agen tingkat atas. Dengan cara ini, konteks agen tingkat atas tidak membengkak oleh konten lengkap dari semua halaman web yang diambil, dan subagent tidak memiliki riwayat percakapan agen tingkat atas dalam konteksnya.

Untuk banyak fitur lanjutan yang memerlukan penulisan prompt (misalnya, skills atau subagent), Anda dapat menggunakan LLM untuk membantu Anda memulai. Beberapa agen coding bahkan memiliki dukungan bawaan untuk melakukan ini. Misalnya, Claude Code dapat menghasilkan subagent dari prompt singkat (panggil `/agents` dan buat agen baru). Cobalah membuat subagent dengan prompt berikut:

```
A Python code checking agent that uses `mypy` and `ruff` to type-check, lint, and format *check* any files that have been modified from the last git commit.
```

Kemudian, Anda dapat menggunakan agen tingkat atas untuk secara eksplisit memanggil subagent dengan pesan seperti "use the code checker subagent". Anda juga mungkin bisa membuat agen tingkat atas secara otomatis memanggil subagent ketika sesuai, misalnya setelah memodifikasi file Python manapun.

# Hal yang perlu diwaspadai

Alat AI dapat membuat kesalahan. Mereka dibangun di atas LLM, yang pada dasarnya hanyalah model probabilistik untuk memprediksi token berikutnya. Mereka tidak "cerdas" dengan cara yang sama seperti manusia. Tinjau output AI untuk kebenaran dan bug keamanan. Terkadang memverifikasi kode bisa lebih sulit daripada menulis kode itu sendiri; untuk kode yang kritis, pertimbangkan untuk menulisnya secara manual. AI bisa terjebak dalam lubang kelinci dan mencoba membuat Anda bingung; waspadai spiral debugging yang berlarut-larut. Jangan menggunakan AI sebagai tumpuan, dan waspadai ketergantungan berlebihan atau pemahaman yang dangkal. Masih ada banyak sekali tugas pemrograman yang belum bisa diselesaikan oleh AI. Computational thinking tetap berharga.

# Perangkat lunak yang direkomendasikan

Banyak IDE / ekstensi coding AI menyertakan agen coding (lihat rekomendasi dari [kuliah development environment](/2026/development-environment/)). Agen coding populer lainnya termasuk [Claude Code](https://www.claude.com/product/claude-code) dari Anthropic, [Codex](https://openai.com/codex/) dari OpenAI, dan agen open-source seperti [opencode](https://github.com/anomalyco/opencode).

# Latihan

1. Bandingkan pengalaman coding secara manual, menggunakan AI autocomplete, inline chat, dan agen dengan melakukan tugas pemrograman yang sama sebanyak empat kali. Kandidat terbaik adalah fitur berskala kecil dari proyek yang sedang Anda kerjakan. Jika Anda mencari ide lain, Anda bisa mempertimbangkan untuk menyelesaikan tugas bergaya "good first issue" di proyek-proyek open-source di GitHub, atau soal-soal [Advent of Code](https://adventofcode.com/) atau [LeetCode](https://leetcode.com/).
1. Gunakan agen coding AI untuk menelusuri codebase yang tidak familiar. Hal ini paling baik dilakukan dalam konteks ketika Anda ingin men-debug atau menambahkan fitur baru ke proyek yang benar-benar Anda pedulikan. Jika tidak ada yang terlintas, cobalah menggunakan agen AI untuk memahami cara kerja fitur-fitur terkait keamanan di agen [opencode](https://github.com/anomalyco/opencode).
1. Vibe-code sebuah aplikasi kecil dari nol. Jangan menulis satu baris kode pun secara manual.
1. Untuk agen coding pilihan Anda, buat dan uji sebuah `AGENTS.md` (atau analognya untuk agen pilihan Anda, seperti `CLAUDE.md`), sebuah skill (misalnya, [skill di Claude Code](https://code.claude.com/docs/en/skills) atau [skill di Codex](https://developers.openai.com/codex/skills/)), dan sebuah subagent (misalnya, [subagent di Claude Code](https://code.claude.com/docs/en/sub-agents)). Pikirkan kapan Anda ingin menggunakan salah satu dari ini dibandingkan yang lain. Perhatikan bahwa agen coding pilihan Anda mungkin tidak mendukung beberapa fungsionalitas ini; Anda dapat melewatinya, atau mencoba agen coding lain yang memiliki dukungan tersebut.
1. Gunakan agen coding untuk mencapai tujuan yang sama seperti pada latihan regex bullet points Markdown dari [Kuliah Code Quality](/2026/code-quality/). Apakah agen menyelesaikan tugas tersebut melalui pengeditan file secara langsung? Apa kekurangan dan keterbatasan dari agen yang mengedit file secara langsung untuk menyelesaikan tugas semacam ini? Cari cara untuk memberikan prompt kepada agen sehingga tidak menyelesaikan tugas melalui pengeditan file secara langsung. Petunjuk: minta agen untuk menggunakan salah satu alat command-line yang disebutkan dalam [kuliah pertama](/2026/course-shell/).
1. Sebagian besar agen coding mendukung bentuk "yolo mode" (misalnya, di Claude Code, `--dangerously-skip-permissions`). Tidak aman menggunakan mode ini secara langsung, tetapi mungkin dapat diterima untuk menjalankan agen coding di lingkungan terisolasi seperti mesin virtual atau container dan kemudian mengaktifkan operasi otonom. Jalankan setup ini di mesin Anda. Dokumentasi seperti [Claude Code devcontainers](https://code.claude.com/docs/en/devcontainer) atau [Docker Sandboxes / Claude Code](https://docs.docker.com/ai/sandboxes/agents/claude-code/) mungkin berguna. Ada lebih dari satu cara untuk mengatur ini.
