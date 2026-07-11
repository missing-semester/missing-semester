---
layout: lecture
title: "Agentic Coding"
description: >
  Pelajari cara menggunakan AI coding agents secara efektif untuk tugas pengembangan perangkat lunak.
thumbnail: /static/assets/thumbnails/2026/lec7.png
date: 2026-01-21
ready: true
video:
  aspect: 56.25
  id: sTdz6PZoAnw
---

Coding agents adalah model AI konversasional yang memiliki akses ke berbagai alat seperti membaca/menulis file, pencarian web, dan menjalankan perintah shell. Mereka berada di dalam IDE atau dalam alat command-line atau GUI mandiri. Coding agents adalah alat yang sangat otonom dan kuat, memungkinkan berbagai macam kasus penggunaan.

Kuliah ini dibangun dari materi pengembangan berbasis AI dari kuliah [Development Environment and Tools](/2026/development-environment/). Sebagai demo singkat, mari kita lanjutkan dengan contoh dari bagian [AI-powered development](/2026/development-environment/#ai-powered-development):

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

Kita bisa mencoba memberikan prompt kepada coding agent dengan tugas berikut:

```
Turn this into a proper command-line program, with argparse for argument parsing. Add type annotations, and make sure the program passes type checking.
```

Agent akan membaca file untuk memahaminya, kemudian melakukan beberapa perubahan, dan akhirnya menjalankan type checker untuk memastikan anotasi tipe sudah benar. Jika terjadi kesalahan sehingga gagal dalam type checking, agent kemungkinan akan melakukan iterasi, meskipun ini adalah tugas sederhana sehingga kecil kemungkinannya terjadi. Karena coding agents memiliki akses ke alat yang mungkin berbahaya, secara default, agent harness meminta pengguna untuk mengonfirmasi pemanggilan alat.

> Jika coding agent membuat kesalahan --- misalnya, jika Anda memiliki binary `mypy` yang tersedia langsung di `$PATH` tetapi agent mencoba memanggil `python -m mypy` --- Anda dapat memberikan umpan balik teks untuk membantunya memperbaiki arah.

Coding agents mendukung interaksi multi-turn, sehingga Anda dapat melakukan iterasi pekerjaan melalui percakapan bolak-balik dengan agent. Anda bahkan dapat menginterupsi agent jika ia mengambil arah yang salah. Satu model mental yang membantu mungkin adalah seperti seorang manajer dari seorang intern: intern akan melakukan pekerjaan detail, tetapi akan membutuhkan bimbingan, dan sesekali melakukan kesalahan dan perlu dikoreksi.

> Untuk demo yang lebih ilustratif, coba minta agent sebagai tindak lanjut untuk menjalankan script yang dihasilkan. Amati outputnya, dan coba minta untuk melakukan perubahan (misalnya, minta untuk hanya menyertakan URL absolut).

# Cara kerja model dan agent AI

Menjelaskan secara lengkap cara kerja [large language models (LLMs)](https://en.wikipedia.org/wiki/Large_language_model) modern dan infrastruktur seperti agent harness berada di luar cakupan kursus ini. Namun, memiliki pemahaman tingkat tinggi tentang beberapa ide kunci sangat membantu untuk _menggunakan_ teknologi mutakhir ini secara efektif dan memahami keterbatasannya.

LLM dapat dipandang sebagai pemodelan distribusi probabilitas dari string penyelesaian (output) berdasarkan string prompt (input). Inferensi LLM (apa yang terjadi ketika Anda, misalnya, memberikan query ke aplikasi chat konversasional) _mengambil sampel_ dari distribusi probabilitas ini. LLM memiliki _context window_ yang tetap, yaitu panjang maksimum dari string input dan output.

{% comment %}
> In mathematical notation, the LLM models the probability distribution $\pi_\theta$ of completions $y$ conditioned on prompts $x$, and we sample from this distribution: $\hat{y} \sim \pi_\theta(\cdot \mid x)$.
{% endcomment %}

Alat AI seperti chat konversasional dan coding agent dibangun di atas primitif ini. Untuk interaksi multi-turn, aplikasi chat dan agent menggunakan penanda giliran dan menyediakan seluruh riwayat percakapan sebagai string prompt setiap kali ada prompt pengguna baru, menjalankan inferensi LLM sekali per prompt pengguna. Untuk agent pemanggil alat, harness menafsirkan output LLM tertentu sebagai permintaan untuk memanggil alat, dan harness menyediakan hasil pemanggilan alat kembali ke model sebagai bagian dari string prompt (sehingga inferensi LLM berjalan lagi setiap kali ada pemanggilan/respons alat). Konsep inti dalam agent pemanggil alat dapat [diimplementasikan dalam 200 baris kode](https://www.mihaileric.com/The-Emperor-Has-No-Clothes/).

## Privasi

Sebagian besar alat coding AI dalam konfigurasi standar mereka mengirim banyak data Anda ke cloud. Terkadang harness berjalan secara lokal sementara inferensi LLM berjalan di cloud, di lain waktu bahkan lebih banyak perangkat lunak yang berjalan di cloud (dan, misalnya, penyedia layanan mungkin secara efektif mendapatkan salinan seluruh repositori Anda serta semua interaksi yang Anda lakukan dengan alat AI).

Ada alat coding AI open-source dan LLM open-source yang cukup baik (meskipun tidak sebaik model proprietary), tetapi saat ini, bagi sebagian besar pengguna, menjalankan LLM open mutakhir secara lokal tidak akan memungkinkan karena keterbatasan perangkat keras.

# Kasus penggunaan

Coding agent dapat membantu untuk berbagai macam tugas. Beberapa contoh:

- **Mengimplementasikan fitur baru.** Seperti pada contoh di atas, Anda dapat meminta coding agent untuk mengimplementasikan sebuah fitur. Memberikan spesifikasi yang baik lebih merupakan seni daripada ilmu pada titik ini; Anda ingin input ke agent cukup deskriptif sehingga agent melakukan apa yang Anda inginkan (setidaknya mengarah ke arah yang benar sehingga Anda dapat melakukan iterasi), tetapi tidak terlalu deskriptif sampai pada titik di mana Anda melakukan terlalu banyak pekerjaan sendiri. Test-driven development bisa sangat efektif: tulis tes (atau gunakan coding agent untuk membantu Anda menulis tes), audit untuk memastikan mereka menangkap apa yang Anda inginkan, dan kemudian minta coding agent untuk mengimplementasikan fitur tersebut. Model terus berkembang, jadi Anda harus menjaga intuisi Anda tetap terbaru tentang kemampuan model.
    > Kami menggunakan Claude Code untuk [mengimplementasikan](https://github.com/missing-semester/missing-semester/pull/345) sidenotes gaya Tufte ini.
{%- comment %}
No need to demo this, since the intro of a lecture was a small demo of adding a new feature.
{% endcomment %}
- **Memperbaiki kesalahan.** Jika Anda memiliki kesalahan dari compiler, linter, type checker, atau tes, Anda dapat meminta agent Anda untuk memperbaikinya, misalnya dengan prompt seperti "fix the issues with mypy". Model coding sangat efektif ketika Anda dapat memasukkannya ke dalam loop umpan balik, jadi cobalah mengatur segala sesuatu sehingga model dapat menjalankan pemeriksaan yang gagal secara langsung, yang akan memungkinkannya melakukan iterasi secara otonom. Jika ini tidak praktis, Anda dapat memberikan umpan balik ke model secara manual.
    > Pada commit [f552b55](https://github.com/missing-semester/missing-semester/commit/f552b5523462b22b8893a8404d2110c4e59613dd) dari repo missing-semester, kami memberikan prompt kepada Claude Code dengan "Review the agentic coding lecture for typos and grammatical issues" dan kemudian memintanya untuk memperbaiki masalah yang ditemukannya, yang di-commit dalam [f1e1c41](https://github.com/missing-semester/missing-semester/commit/f1e1c417adba6b4149f7eef91ff5624de40dc637).
{%- comment %}
Demo a coding agent fixing the bug in https://github.com/anishathalye/dotbot/commit/cef40c902ef0f52f484153413142b5154bbc5e99.

Write the failing tests to demo the bug, and then ask the agent to fix. Prepped in branch demo-bugfix.

Can run the failing test with:

    hatch test tests/test_cli.py::test_issue_357

Can prompt coding agent with:

    There is a bug I wrote a failing test for, you can repro it with `hatch test tests/test_cli.py::test_issue_357`. Fix the bug.

Get it to commit the changes.
{% endcomment %}
- **Refactoring.** Anda dapat menggunakan coding agent untuk melakukan refactoring kode dalam berbagai cara, dari tugas sederhana seperti mengganti nama method (jenis refactoring ini juga didukung oleh [code intelligence](/2026/development-environment/#code-intelligence-and-language-servers)) hingga tugas yang lebih kompleks seperti memisahkan fungsionalitas ke dalam modul terpisah.
    > Kami menggunakan Claude Code untuk [memisahkan](https://github.com/missing-semester/missing-semester/pull/344) agentic coding menjadi kuliah tersendiri.
{%- comment %}
Show usage in Missing Semester, point out that the agent did make some mistakes.
{% endcomment %}
- **Code review.** Anda dapat meminta coding agent untuk me-review kode. Anda dapat memberikan mereka panduan dasar, seperti "review my latest changes that are not yet committed". Jika Anda ingin me-review pull request dan coding agent Anda mendukung web fetch, atau Anda memiliki alat command-line seperti [GitHub CLI](https://cli.github.com/) yang terinstal, Anda bahkan mungkin dapat meminta coding agent "Review the pull request {link}" dan ia akan menanganinya dari sana.
{%- comment %}
In Porcupine repo, prompt agent with:

    Review this PR: https://github.com/anishathalye/porcupine/pull/39
{% endcomment %}
- **Pemahaman kode.** Anda dapat mengajukan pertanyaan kepada coding agent tentang codebase, yang bisa sangat membantu untuk onboarding.
{%- comment %}
Some prompts to try in the missing-semester repo:

    How do I run this site locally?

    How are the social preview cards implemented?
{% endcomment %}
- **Sebagai shell.** Anda dapat meminta coding agent untuk menggunakan alat tertentu untuk menyelesaikan tugas, sehingga Anda dapat menjalankan perintah shell menggunakan bahasa alami, seperti "use the find command to find all files older than 30 days" atau "use mogrify to resize all the jpgs to 50% of their original size".
{%- comment %}
In Dotbot repo, prompt agent with:

    Use the ag command to find all Python renaming imports
{% endcomment %}
- **Vibe coding.** Agent cukup kuat sehingga Anda dapat mengimplementasikan beberapa aplikasi tanpa menulis satu baris kode pun sendiri.
    > [Berikut adalah contoh](https://github.com/cleanlab/office-presence-dashboard) dari proyek dunia nyata yang di-vibe-code oleh salah satu instruktur.
{%- comment %}
In missing-semester repo, prompt agent with:

    Make this site look retro.
{% endcomment %}

# Agent lanjutan

Di sini, kami memberikan tinjauan singkat tentang beberapa pola penggunaan dan kemampuan coding agent yang lebih lanjut.

- **Prompt yang dapat digunakan kembali.** Buat prompt atau template yang dapat digunakan kembali. Misalnya, Anda dapat menulis prompt terperinci untuk melakukan code review dengan cara tertentu, dan menyimpannya sebagai prompt yang dapat digunakan kembali.
    > Tooling agent berkembang dengan cepat. Di beberapa alat, prompt yang dapat digunakan kembali sebagai fitur mandiri sudah didepresiasi. Misalnya, di Codex dan Claude Code, mereka [digantikan](https://developers.openai.com/codex/custom-prompts) oleh [skills](https://code.claude.com/docs/en/skills).
- **Agent paralel.** Coding agent bisa lambat: Anda dapat memberikan prompt kepada agent, dan ia dapat mengerjakan suatu masalah selama puluhan menit. Anda dapat menjalankan beberapa salinan agent secara bersamaan, baik mengerjakan tugas yang sama (LLM bersifat stokastik, jadi bisa membantu untuk menjalankan hal yang sama beberapa kali dan mengambil solusi terbaik) atau tugas yang berbeda (misalnya, mengimplementasikan dua fitur yang tidak tumpang tindih secara bersamaan). Untuk mencegah perubahan dari agent yang berbeda saling mengganggu, Anda dapat menggunakan [git worktrees](https://git-scm.com/docs/git-worktree), yang kami bahas dalam kuliah tentang [version control](/2026/version-control/).
- **MCP.** MCP, yang merupakan singkatan dari _Model Context Protocol_, adalah protokol terbuka yang dapat Anda gunakan untuk menghubungkan coding agent Anda dengan berbagai alat. Misalnya, [Notion MCP server](https://github.com/makenotion/notion-mcp-server) ini dapat membiarkan agent Anda membaca/menulis dokumen Notion, memungkinkan kasus penggunaan seperti "read the spec linked in {Notion doc}, draft an implementation plan as a new page in Notion, and then implement a prototype". Untuk menemukan MCP, Anda dapat menggunakan direktori seperti [Pulse](https://www.pulsemcp.com/servers) dan [Glama](https://glama.ai/mcp/servers).
- **Manajemen konteks.** Seperti yang kami [sebutkan di atas](#how-ai-models-and-agents-work), LLM yang mendasari coding agent memiliki _context window_ yang terbatas. Penggunaan coding agent yang efektif mengharuskan pemanfaatan konteks yang baik. Anda ingin memastikan agent memiliki akses ke informasi yang dibutuhkan, tetapi menghindari konteks yang tidak perlu untuk mencegah overflow context window atau penurunan performa model (yang cenderung terjadi seiring bertambahnya ukuran konteks, bahkan jika tidak overflow context window). Agent harness secara otomatis menyediakan, dan sampai taraf tertentu, mengelola konteks, tetapi banyak kontrol yang diserahkan kepada pengguna.
    - **Membersihkan context window.** Kontrol paling dasar, coding agent mendukung pembersihan context window (memulai percakapan baru), yang harus Anda lakukan untuk query yang tidak terkait.
    - **Mundur percakapan.** Beberapa coding agent mendukung pembatalan langkah dalam riwayat percakapan. Daripada memberikan pesan tindak lanjut yang mengarahkan agent ke arah yang berbeda, dalam situasi di mana "undo" lebih masuk akal, ini mengelola konteks dengan lebih efektif.
{%- comment %}
Make up a quick demo.
{% endcomment %}
    - **Kompaksi.** Untuk memungkinkan percakapan dengan panjang yang tidak terbatas, coding agent mendukung _kompaksi_ konteks: jika riwayat percakapan menjadi terlalu panjang, mereka akan secara otomatis memanggil LLM untuk meringkas awalan percakapan, dan mengganti riwayat percakapan dengan ringkasan. Beberapa agent memberikan kontrol kepada pengguna untuk memanggil kompaksi saat diinginkan.
{%- comment %}
Show `/compact` in Claude Code, show full summary.
{% endcomment %}
    - **llms.txt.** File `/llms.txt` adalah [standar](https://llmstxt.org/) yang diusulkan untuk lokasi dokumen yang dimaksudkan untuk digunakan oleh LLM pada waktu inferensi. Produk (misalnya, [cursor.com/llms.txt](https://cursor.com/llms.txt)), pustaka perangkat lunak (misalnya, [ai.pydantic.dev/llms.txt](https://ai.pydantic.dev/llms.txt)), dan API (misalnya, [apify.com/llms.txt](https://apify.com/llms.txt)) mungkin memiliki file `llms.txt` yang berguna untuk pengembangan. Dokumen seperti ini lebih padat informasi per token, sehingga lebih efisien konteks daripada meminta coding agent Anda untuk mengambil dan membaca halaman HTML. Dokumentasi eksternal berguna ketika coding agent tidak memiliki pengetahuan bawaan tentang dependensi yang coba Anda gunakan (misalnya, karena dipublikasikan setelah batas pengetahuan LLM).
{%- comment %}
Side-by-side comparison in an empty repo (on Desktop or some other self-contained place, with `git init` run in it):

    Write a single-file Python program example in demo.py using semlib to sort "Ilya Sutskever", "Soumith Chintala", and "Donald Knuth" in terms of their fame as AI researchers.

    Write a single-file Python program example in demo.py using semlib to sort "Ilya Sutskever", "Soumith Chintala", and "Donald Knuth" in terms of their fame as AI researchers. See https://semlib.anish.io/llms.txt. Follow links to Markdown versions of any pages linked in llms.txt files.

Not sure why the agent doesn't do this by default. You'd probably put that last sentence in a CLAUDE.md file.
{% endcomment %}
    - **AGENTS.md.** Sebagian besar coding agent mendukung [AGENTS.md](https://agents.md/) atau yang serupa (misalnya, Claude Code mencari `CLAUDE.md`) sebagai README untuk coding agent. Ketika agent dimulai, ia mengisi konteks dengan seluruh isi `AGENTS.md`. Anda dapat menggunakan ini untuk memberikan saran kepada agent yang umum di seluruh sesi (misalnya, instruksikan untuk selalu menjalankan type-checker setelah melakukan perubahan kode, jelaskan cara menjalankan unit test, atau berikan tautan ke dokumentasi pihak ketiga yang dapat ditelusuri agent). Beberapa coding agent dapat menghasilkan file ini secara otomatis (misalnya, perintah `/init` di Claude Code). Lihat [di sini](https://github.com/pydantic/pydantic-ai/blob/main/CLAUDE.md) untuk contoh dunia nyata dari `AGENTS.md`.
{%- comment %}
Dotbot example, CLAUDE.md that includes @DEVELOPMENT.md and says to always run the type checker and code formatter after making any changes to Python code.

Example prompt, off of master:

    Remove the "--version" command-line flag.

This is something that'll be fast, for demonstration purposes.
{% endcomment %}
    - **Skills.** Konten dalam `AGENTS.md` selalu dimuat, secara keseluruhan, ke dalam context window agent. _Skills_ menambahkan satu tingkat tidak langsung untuk menghindari context bloat: Anda dapat menyediakan agent dengan daftar skills beserta deskripsinya, dan agent dapat "membuka" skill tersebut (memuatnya ke dalam context window) sesuai keinginan.
    - **Subagent.** Beberapa coding agent membiarkan Anda mendefinisikan subagent, yang merupakan agent untuk alur kerja spesifik tugas. Coding agent tingkat atas dapat memanggil sub-agent untuk menyelesaikan tugas tertentu, yang memungkinkan baik agent tingkat atas maupun subagent untuk mengelola konteks dengan lebih efektif. Konteks agent tingkat atas tidak membengkak dengan semua yang dilihat subagent, dan subagent dapat mendapatkan hanya konteks yang dibutuhkan untuk tugasnya. Sebagai satu contoh, beberapa coding agent mengimplementasikan penelitian web sebagai subagent: agent tingkat atas akan mengajukan query ke subagent, yang akan menjalankan pencarian web, mengambil halaman web individual, menganalisisnya, dan memberikan jawaban atas query ke agent tingkat atas. Dengan cara ini, konteks agent tingkat atas tidak membengkak oleh konten lengkap dari semua halaman web yang diambil, dan subagent tidak memiliki dalam konteksnya sisa riwayat percakapan agent tingkat atas.

Untuk banyak fitur lanjutan yang memerlukan penulisan prompt (misalnya, skills atau subagent), Anda dapat menggunakan LLM untuk membantu Anda memulai. Beberapa coding agent bahkan memiliki dukungan bawaan untuk melakukan ini. Misalnya, Claude Code dapat menghasilkan subagent dari prompt singkat (panggil `/agents` dan buat agent baru). Cobalah membuat subagent dengan prompt ini:

```
A Python code checking agent that uses `mypy` and `ruff` to type-check, lint, and format *check* any files that have been modified from the last git commit.
```

Kemudian, Anda dapat menggunakan agent tingkat atas untuk secara eksplisit memanggil subagent dengan pesan seperti "use the code checker subagent". Anda juga mungkin dapat membuat agent tingkat atas secara otomatis memanggil subagent ketika sesuai, misalnya, setelah memodifikasi file Python apa pun.

# Hal yang perlu diwaspadai

Alat AI dapat membuat kesalahan. Mereka dibangun di atas LLM, yang hanyalah model prediksi token berikutnya yang probabilistik. Mereka tidak "cerdas" dengan cara yang sama seperti manusia. Tinjau output AI untuk kebenaran dan bug keamanan. Terkadang memverifikasi kode bisa lebih sulit daripada menulis kode sendiri; untuk kode yang kritis, pertimbangkan untuk menulisnya secara manual. AI dapat masuk ke lubang kelinci dan mencoba membuat Anda bingung; waspadai spiral debugging. Jangan gunakan AI sebagai alat bantu, dan waspadai ketergantungan berlebihan atau memiliki pemahaman yang dangkal. Masih ada kelas besar tugas pemrograman yang masih tidak dapat dilakukan AI. Pemikiran komputasional tetap berharga.

# Perangkat lunak yang direkomendasikan

Banyak IDE / ekstensi coding AI menyertakan coding agent (lihat rekomendasi dari [kuliah development environment](/2026/development-environment/)). Coding agent populer lainnya termasuk [Claude Code](https://www.claude.com/product/claude-code) dari Anthropic, [Codex](https://openai.com/codex/) dari OpenAI, dan agent open-source seperti [opencode](https://github.com/anomalyco/opencode).

# Latihan

1. Bandingkan pengalaman coding secara manual, menggunakan AI autocomplete, inline chat, dan agent dengan melakukan tugas pemrograman yang sama empat kali. Kandidat terbaik adalah fitur berukuran kecil dari proyek yang sedang Anda kerjakan. Jika Anda mencari ide lain, Anda dapat mempertimbangkan untuk menyelesaikan tugas bergaya "good first issue" di proyek open-source di GitHub, atau masalah [Advent of Code](https://adventofcode.com/) atau [LeetCode](https://leetcode.com/).
1. Gunakan coding agent AI untuk menavigasi codebase yang tidak dikenal. Ini paling baik dilakukan dalam konteks ingin melakukan debugging atau menambahkan fitur baru ke proyek yang benar-benar Anda pedulikan. Jika Anda tidak memiliki ide, cobalah menggunakan agent AI untuk memahami bagaimana fitur terkait keamanan bekerja di agent [opencode](https://github.com/anomalyco/opencode).
1. Vibe-code aplikasi kecil dari awal. Jangan menulis satu baris kode pun secara manual.
1. Untuk coding agent pilihan Anda, buat dan uji `AGENTS.md` (atau analog untuk agent pilihan Anda, seperti `CLAUDE.md`), sebuah skill (misalnya, [skill di Claude Code](https://code.claude.com/docs/en/skills) atau [skill di Codex](https://developers.openai.com/codex/skills/)), dan sebuah subagent (misalnya, [subagent di Claude Code](https://code.claude.com/docs/en/sub-agents)). Pikirkan kapan Anda ingin menggunakan salah satu dari ini versus yang lain. Perhatikan bahwa coding agent pilihan Anda mungkin tidak mendukung beberapa fungsionalitas ini; Anda dapat melewatinya, atau mencoba coding agent lain yang memiliki dukungan.
1. Gunakan coding agent untuk mencapai tujuan yang sama seperti dalam latihan regex bullet point Markdown dari [kuliah Code Quality](/2026/code-quality/). Apakah ia menyelesaikan tugas melalui pengeditan file langsung? Apa kekurangan dan keterbatasan agent yang mengedit file secara langsung untuk menyelesaikan tugas seperti ini? Cari tahu cara memberikan prompt kepada agent sehingga tidak menyelesaikan tugas melalui pengeditan file langsung. Petunjuk: minta agent untuk menggunakan salah satu alat command-line yang disebutkan dalam [kuliah pertama](/2026/course-shell/).
1. Sebagian besar coding agent mendukung bentuk "yolo mode" (misalnya, di Claude Code, `--dangerously-skip-permissions`). Tidak aman untuk menggunakan mode ini secara langsung, tetapi mungkin dapat diterima untuk menjalankan coding agent di lingkungan terisolasi seperti mesin virtual atau container dan kemudian mengaktifkan operasi otonom. Jalankan setup ini di mesin Anda. Dokumentasi seperti [Claude Code devcontainers](https://code.claude.com/docs/en/devcontainer) atau [Docker Sandboxes / Claude Code](https://docs.docker.com/ai/sandboxes/agents/claude-code/) mungkin berguna. Ada lebih dari satu cara untuk mengatur ini.
