---
layout: lecture
title: "Mengemas dan Mendistribusikan Kode"
description: >
  Pelajari tentang packaging proyek, environment, versioning, dan deployment library, aplikasi, dan layanan.
thumbnail: /static/assets/thumbnails/2026/lec6.png
date: 2026-01-20
ready: true
video:
  aspect: 56.25
  id: KBMiB-8P4Ns
---

Membuat kode bekerja sesuai yang diharapkan itu sulit; membuat kode yang sama berjalan di mesin yang berbeda dari mesin Anda seringkali lebih sulit.

Mendistribusikan kode berarti mengambil kode yang Anda tulis dan mengubahnya menjadi bentuk yang dapat digunakan oleh orang lain tanpa memerlukan setup komputer Anda.
Mendistribusikan kode memiliki banyak bentuk dan bergantung pada pilihan bahasa pemrograman, library sistem, dan sistem operasi, di antara banyak faktor lainnya.
Hal ini juga bergantung pada apa yang Anda bangun: sebuah library perangkat lunak, alat baris perintah, dan layanan web semuanya memiliki kebutuhan dan langkah deployment yang berbeda.
Meskipun demikian, terdapat pola umum di antara semua skenario ini: kita perlu mendefinisikan apa deliverable tersebut --- alias _artifact_ --- dan asumsi apa yang dibuatnya tentang lingkungan di sekitarnya.

Dalam kuliah ini, kita akan membahas:

- [Dependencies & Environments](#dependencies--environments)
- [Artifacts & Packaging](#artifacts--packaging)
- [Releases & Versioning](#releases--versioning)
- [Reproducibility](#reproducibility)
- [VMs & Containers](#vms--containers)
- [Configuration](#configuration)
- [Services & Orchestration](#services--orchestration)
- [Publishing](#publishing)

Kita akan menjelaskan konsep-konsep ini melalui contoh dari ekosistem Python, karena contoh konkret sangat membantu untuk pemahaman. Meskipun tool-nya berbeda untuk ekosistem bahasa pemrograman lain, konsepnya sebagian besar akan sama.

# Dependencies & Environments

Dalam pengembangan perangkat lunak modern, lapisan abstraksi ada di mana-mana.
Program secara alami membebankan logika ke library atau layanan lain.
Namun, ini memperkenalkan hubungan _dependency_ antara program Anda dan library yang dibutuhkannya untuk berfungsi.
Sebagai contoh, di Python, untuk mengambil konten sebuah website kita sering melakukan:

```python
import requests

response = requests.get("https://missing.csail.mit.edu")
```

Namun library `requests` tidak disertakan bersama runtime Python, jadi jika kita mencoba menjalankan kode ini tanpa menginstal `requests`, Python akan memunculkan error:

```console
$ python fetch.py
Traceback (most recent call last):
  File "fetch.py", line 1, in <module>
    import requests
ModuleNotFoundError: No module named 'requests'
```

Untuk membuat library ini tersedia, kita perlu menjalankan `pip install requests` terlebih dahulu untuk menginstalnya.
`pip` adalah alat baris perintah yang disediakan oleh bahasa pemrograman Python untuk menginstal package.
Menjalankan `pip install requests` menghasilkan urutan tindakan berikut:

1. Mencari requests di Python Package Index ([PyPI](https://pypi.org/))
1. Mencari artifact yang sesuai untuk platform yang kita gunakan
1. Menyelesaikan dependency --- library `requests` sendiri bergantung pada package lain, sehingga installer harus menemukan versi yang kompatibel dari semua dependency transitif dan menginstalnya terlebih dahulu
1. Mengunduh artifact, lalu mengekstrak dan menyalin file ke lokasi yang tepat di filesystem kita

```console
$ pip install requests
Collecting requests
  Downloading requests-2.32.3-py3-none-any.whl (64 kB)
Collecting charset-normalizer<4,>=2
  Downloading charset_normalizer-3.4.0-cp311-cp311-manylinux_x86_64.whl (142 kB)
Collecting idna<4,>=2.5
  Downloading idna-3.10-py3-none-any.whl (70 kB)
Collecting urllib3<3,>=1.21.1
  Downloading urllib3-2.2.3-py3-none-any.whl (126 kB)
Collecting certifi>=2017.4.17
  Downloading certifi-2024.8.30-py3-none-any.whl (167 kB)
Installing collected packages: urllib3, idna, charset-normalizer, certifi, requests
Successfully installed certifi-2024.8.30 charset-normalizer-3.4.0 idna-3.10 requests-2.32.3 urllib3-2.2.3
```

Di sini kita dapat melihat bahwa `requests` memiliki dependency-nya sendiri seperti `certifi` atau `charset-normalizer` dan bahwa mereka harus diinstal sebelum `requests` dapat diinstal.
Setelah diinstal, runtime Python dapat menemukan library ini saat mengimpornya.

```console
$ python -c 'import requests; print(requests.__path__)'
['/usr/local/lib/python3.11/dist-packages/requests']

$ pip list | grep requests
requests        2.32.3
```

Bahasa pemrograman memiliki tool, konvensi, dan praktik yang berbeda untuk menginstal dan mempublikasikan library.
Dalam beberapa bahasa seperti Rust, toolchain-nya terpadu --- `cargo` menangani building, testing, dependency management, dan publishing.
Dalam bahasa lain seperti Python, penyatuan terjadi pada tingkat spesifikasi --- daripada satu tool tunggal, terdapat spesifikasi standar yang mendefinisikan cara kerja packaging, memungkinkan beberapa tool yang bersaing untuk setiap tugas (`pip` vs [`uv`](https://docs.astral.sh/uv/), `setuptools` vs [`hatch`](https://hatch.pypa.io/) vs [`poetry`](https://python-poetry.org/)).
Dan dalam beberapa ekosistem seperti LaTeX, distribusi seperti TeX Live atau MacTeX disertakan dengan ribuan package yang telah terinstal.

Memperkenalkan dependency juga memperkenalkan konflik dependency.
Konflik terjadi ketika program membutuhkan versi yang tidak kompatibel dari dependency yang sama.
Sebagai contoh, jika `tensorflow==2.3.0` membutuhkan `numpy>=1.16.0,<1.19.0` dan `pandas==1.2.0` membutuhkan `numpy>=1.16.5`, maka versi apa pun yang memenuhi `numpy>=1.16.5,<1.19.0` akan valid.
Tetapi jika package lain dalam proyek Anda membutuhkan `numpy>=1.19`, Anda memiliki konflik tanpa versi valid yang memenuhi semua batasan.

Situasi ini --- di mana beberapa package membutuhkan versi yang saling tidak kompatibel dari dependency bersama --- sering disebut sebagai _dependency hell_.
Salah satu cara untuk mengatasi konflik adalah dengan mengisolasi dependency setiap program ke dalam _environment_-nya sendiri.
Di Python kita membuat virtual environment dengan menjalankan:

```console
$ which python
/usr/bin/python
$ pwd
/home/missingsemester
$ python -m venv venv
$ source venv/bin/activate
$ which python
/home/missingsemester/venv/bin/python
$ which pip
/home/missingsemester/venv/bin/pip
$ python -c 'import requests; print(requests.__path__)'
['/home/missingsemester/venv/lib/python3.11/site-packages/requests']

$ pip list
Package Version
------- -------
pip     24.0
```

Anda dapat menganggap environment sebagai versi runtime bahasa yang berdiri sendiri dengan kumpulan package terinstal-nya sendiri.
Virtual environment atau venv ini mengisolasi dependency yang terinstal dari instalasi Python global.
Merupakan praktik yang baik untuk memiliki virtual environment untuk setiap proyek, yang berisi dependency yang dibutuhkannya.

> Meskipun banyak sistem operasi modern dilengkapi dengan instalasi runtime bahasa pemrograman seperti Python, tidak bijaksana untuk memodifikasi instalasi ini karena OS mungkin mengandalkannya untuk fungsionalitasnya sendiri. Lebih baik gunakan environment terpisah.

Dalam beberapa bahasa, protokol instalasi tidak didefinisikan oleh sebuah tool tetapi sebagai spesifikasi.
Di Python [PEP 517](https://peps.python.org/pep-0517/) mendefinisikan antarmuka build system dan [PEP 621](https://peps.python.org/pep-0621/) menentukan bagaimana metadata proyek disimpan di `pyproject.toml`.
Hal ini telah memungkinkan pengembang untuk meningkatkan `pip` dan menghasilkan tool yang lebih optimal seperti `uv`. Untuk menginstal `uv` cukup dengan melakukan `pip install uv`.

Menggunakan `uv` alih-alih `pip` mengikuti antarmuka yang sama tetapi secara signifikan lebih cepat:

```console
$ uv pip install requests
Resolved 5 packages in 12ms
Prepared 5 packages in 0.45ms
Installed 5 packages in 8ms
 + certifi==2024.8.30
 + charset-normalizer==3.4.0
 + idna==3.10
 + requests==2.32.3
 + urllib3==2.2.3
```

> Kami sangat menyarankan menggunakan `uv pip` alih-alih `pip` kapan pun memungkinkan karena ini secara dramatis mengurangi waktu instalasi.

Selain isolasi dependency, environment juga memungkinkan Anda memiliki berbagai versi runtime bahasa pemrograman.

```console
$ uv venv --python 3.12 venv312
Using CPython 3.12.7
Creating virtual environment at: venv312

$ source venv312/bin/activate && python --version
Python 3.12.7

$ uv venv --python 3.11 venv311
Using CPython 3.11.10
Creating virtual environment at: venv311

$ source venv311/bin/activate && python --version
Python 3.11.10
```

Ini membantu ketika Anda perlu menguji kode Anda di berbagai versi Python atau ketika sebuah proyek membutuhkan versi tertentu.

> Dalam beberapa bahasa pemrograman, setiap proyek secara otomatis mendapatkan environment-nya sendiri untuk dependency-nya daripada Anda membuatnya secara manual, tetapi prinsipnya sama. Sebagian besar bahasa saat ini juga memiliki mekanisme untuk mengelola beberapa versi bahasa pada satu sistem, dan kemudian menentukan versi mana yang akan digunakan untuk proyek individual.

# Artifacts & Packaging

Dalam pengembangan perangkat lunak, kita membedakan antara source code dan artifact. Pengembang menulis dan membaca source code, sementara artifact adalah output yang dikemas dan dapat didistribusikan yang dihasilkan dari source code tersebut --- siap untuk diinstal atau di-deploy.
Sebuah artifact bisa sesederhana file kode yang kita jalankan, dan serumit seluruh Virtual Machine yang berisi semua bagian yang diperlukan dari sebuah aplikasi.
Perhatikan contoh ini di mana kita memiliki file Python `greet.py` di direktori saat ini:

```console
$ cat greet.py
def greet(name):
    return f"Hello, {name}!"

$ python -c "from greet import greet; print(greet('World'))"
Hello, World!

$ cd /tmp
$ python -c "from greet import greet; print(greet('World'))"
ModuleNotFoundError: No module named 'greet'
```

Import gagal setelah kita berpindah ke direktori lain karena Python hanya mencari modul di lokasi tertentu (direktori saat ini, package yang terinstal, dan path di `PYTHONPATH`). Packaging menyelesaikan masalah ini dengan menginstal kode ke lokasi yang diketahui.

Di Python, memaketkan sebuah library melibatkan pembuatan artifact yang dapat digunakan oleh installer package seperti `pip` atau `uv` untuk menginstal file yang relevan.
Artifact Python disebut _wheel_ dan berisi semua informasi yang diperlukan untuk menginstal sebuah package: file kode, metadata tentang package (nama, versi, dependency), dan instruksi untuk menempatkan file di environment.
Membangun sebuah artifact mengharuskan kita menulis file proyek (juga sering dikenal sebagai manifest) yang merinci spesifikasi proyek, dependency yang diperlukan, versi package, dan informasi lainnya. Di Python, kita menggunakan `pyproject.toml` untuk tujuan ini.

> `pyproject.toml` adalah cara modern dan yang direkomendasikan. Meskipun metode packaging sebelumnya seperti `requirements.txt` atau `setup.py` masih didukung, Anda sebaiknya lebih memilih `pyproject.toml` kapan pun memungkinkan.

Berikut adalah `pyproject.toml` minimal untuk sebuah library yang juga menyediakan alat baris perintah:

```toml
[project]
name = "greeting"
version = "0.1.0"
description = "A simple greeting library"
dependencies = ["typer>=0.9"]

[project.scripts]
greet = "greeting:cli"

[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"
```

Library `typer` adalah package Python populer untuk membuat antarmuka baris perintah dengan boilerplate minimal.

Dan `greeting.py` yang sesuai:

```python
import typer


def greet(name: str) -> str:
    return f"Hello, {name}!"


def cli():
    typer.run(greet)


if __name__ == "__main__":
    cli()
```

Dengan file ini, kita sekarang dapat membangun wheel:

```console
$ uv build
Building source distribution...
Building wheel from source distribution...
Successfully built dist/greeting-0.1.0.tar.gz
Successfully built dist/greeting-0.1.0-py3-none-any.whl

$ ls dist/
greeting-0.1.0-py3-none-any.whl
greeting-0.1.0.tar.gz
```

File `.whl` adalah wheel (arsip zip dengan struktur tertentu), dan `.tar.gz` adalah source distribution untuk sistem yang perlu membangun dari source.

Anda dapat memeriksa isi sebuah wheel untuk melihat apa yang dikemas:

```console
$ unzip -l dist/greeting-0.1.0-py3-none-any.whl
Archive:  dist/greeting-0.1.0-py3-none-any.whl
  Length      Date    Time    Name
---------  ---------- -----   ----
      150  2024-01-15 10:30   greeting.py
      312  2024-01-15 10:30   greeting-0.1.0.dist-info/METADATA
       92  2024-01-15 10:30   greeting-0.1.0.dist-info/WHEEL
        9  2024-01-15 10:30   greeting-0.1.0.dist-info/top_level.txt
      435  2024-01-15 10:30   greeting-0.1.0.dist-info/RECORD
---------                     -------
      998                     5 files
```

Sekarang jika kita memberikan wheel ini kepada orang lain, mereka dapat menginstalnya dengan menjalankan:

```console
$ uv pip install ./greeting-0.1.0-py3-none-any.whl
$ greet Alice
Hello, Alice!
```

Ini akan menginstal library yang kita bangun sebelumnya ke environment mereka, termasuk tool cli `greet`.

Ada batasan pada pendekatan ini. Khususnya jika library kita bergantung pada library spesifik platform, misalnya CUDA untuk akselerasi GPU, maka artifact kita hanya berfungsi di sistem dengan library spesifik tersebut yang terinstal, dan kita mungkin perlu membangun wheel terpisah untuk platform yang berbeda (Linux, macOS, Windows) dan arsitektur yang berbeda (x86, ARM).


Saat menginstal perangkat lunak, terdapat perbedaan penting antara menginstal dari source dan menginstal biner yang sudah dibangun. Menginstal dari source berarti mengunduh kode asli dan mengompilasinya di mesin Anda --- ini memerlukan compiler dan tool build yang terinstal, dan bisa memakan waktu yang signifikan untuk proyek-proyek besar.

Menginstal biner yang sudah dibangun berarti mengunduh artifact yang sudah dikompilasi oleh orang lain --- lebih cepat dan lebih sederhana, tetapi biner tersebut harus cocok dengan platform dan arsitektur Anda.
Sebagai contoh, [halaman rilis ripgrep](https://github.com/BurntSushi/ripgrep/releases) menampilkan biner yang sudah dibangun untuk Linux (x86_64, ARM), macOS (Intel, Apple Silicon), dan Windows.


# Releases & Versioning

Kode dibangun dalam proses yang berkelanjutan tetapi dirilis secara diskrit.
Dalam pengembangan perangkat lunak terdapat perbedaan yang jelas antara environment development dan production.
Kode perlu terbukti berfungsi di environment dev sebelum _didistribusikan_ ke prod.
Proses rilis melibatkan banyak langkah, termasuk testing, dependency management, versioning, configuration, deployment, dan publishing.


Library perangkat lunak tidak statis dan berkembang seiring waktu dengan perbaikan dan fitur baru.
Kita melacak evolusi ini dengan pengenal versi diskrit yang sesuai dengan keadaan library pada titik waktu tertentu.
Perubahan perilaku library dapat berkisar dari patch yang memperbaiki fungsionalitas tidak kritis, fitur baru yang memperluas fungsionalitasnya, hingga perubahan yang memecah kompatibilitas ke belakang.
Changelog mendokumentasikan perubahan apa yang diperkenalkan oleh sebuah versi --- ini adalah dokumen yang digunakan pengembang perangkat lunak untuk mengkomunikasikan perubahan yang terkait dengan rilis baru.

Namun, melacak perubahan yang sedang berlangsung di setiap dependency tidak praktis, terlebih lagi ketika kita mempertimbangkan dependency transitif --- yaitu dependency dari dependency kita.

> Anda dapat memvisualisasikan seluruh dependency tree proyek Anda dengan `uv tree`, yang menampilkan semua package dan dependency transitifnya dalam format tree.

Untuk menyederhanakan masalah ini, terdapat konvensi tentang cara memberi versi pada perangkat lunak, dan salah satu yang paling umum adalah [Semantic Versioning](https://semver.org/) atau SemVer.
Dalam Semantic Versioning, sebuah versi memiliki pengenal dalam bentuk MAJOR.MINOR.PATCH di mana masing-masing nilai mengambil nilai integer. Versi singkatnya adalah, melakukan upgrade:

- PATCH (misalnya, 1.2.3 → 1.2.4) hanya boleh berisi perbaikan bug dan sepenuhnya kompatibel ke belakang
- MINOR (misalnya, 1.2.3 → 1.3.0) menambahkan fungsionalitas baru dengan cara yang kompatibel ke belakang
- MAJOR (misalnya, 1.2.3 → 2.0.0) menunjukkan perubahan yang memecah kompatibilitas yang mungkin memerlukan modifikasi kode

> Ini adalah penyederhanaan dan kami mendorong Anda untuk membaca spesifikasi SemVer lengkap untuk memahami misalnya mengapa berpindah dari 0.1.3 ke 0.2.0 dapat menyebabkan perubahan yang memecah kompatibilitas atau apa arti 1.0.0-rc.1.
Python packaging mendukung semantic versioning secara native, jadi ketika kita menentukan versi dependency kita, kita dapat menggunakan berbagai specifier:

Di `pyproject.toml` kita memiliki berbagai cara untuk membatasi rentang versi yang kompatibel dari dependency kita:

```toml
[project]
dependencies = [
    "requests==2.32.3",  # Exact Version - only this specific version
    "click>=8.0",        # Minimum version - 8.0 or newer
    "numpy>=1.24,<2.0",  # Range - at least 1.24 but less than 2.0
    "pandas~=2.1.0",     # Compatible release - >=2.1.0 and <2.2.0
]
```

Version specifier ada di banyak package manager (npm, cargo, dll.) dengan semantik yang bervariasi. Operator `~=` adalah operator "compatible release" Python --- `~=2.1.0` berarti "versi apa pun yang kompatibel dengan 2.1.0", yang diterjemahkan menjadi `>=2.1.0` dan `<2.2.0`. Ini kira-kira setara dengan operator caret (`^`) di npm dan cargo, yang mengikuti konsep kompatibilitas SemVer.

Tidak semua perangkat lunak menggunakan semantic versioning. Alternatif yang umum adalah Calendar Versioning (CalVer), di mana versi didasarkan pada tanggal rilis daripada makna semantik. Sebagai contoh, Ubuntu menggunakan versi seperti `24.04` (April 2024) dan `24.10` (Oktober 2024). CalVer memudahkan untuk melihat seberapa lama sebuah rilis, meskipun tidak mengkomunikasikan apa pun tentang kompatibilitas. Terakhir, semantic versioning tidak sempurna, dan terkadang maintainer secara tidak sengaja memperkenalkan perubahan yang memecah kompatibilitas di rilis minor atau patch.


# Reproducibility

Dalam pengembangan perangkat lunak modern, kode yang Anda tulis berada di atas sejumlah lapisan abstraksi yang signifikan.
Ini mencakup hal-hal seperti runtime bahasa pemrograman Anda, library pihak ketiga, sistem operasi, atau bahkan hardware itu sendiri.
Perbedaan apa pun di salah satu lapisan ini dapat mengubah perilaku kode Anda atau bahkan mencegahnya berfungsi sebagaimana mestinya.
Selain itu, bahkan perbedaan pada hardware yang mendasarinya memengaruhi kemampuan Anda untuk mendistribusikan perangkat lunak.

Pinning sebuah library merujuk pada menentukan versi yang tepat daripada sebuah rentang, misalnya `requests==2.32.3` alih-alih `requests>=2.0`.

Sebagian dari tugas package manager adalah mempertimbangkan semua batasan yang diberikan oleh dependency --- dan dependency transitif --- dan kemudian menghasilkan daftar versi yang valid yang akan memenuhi semua batasan.
Daftar versi spesifik kemudian dapat disimpan ke file untuk tujuan reproducibility; file-file ini disebut sebagai _lock file_.

```console
$ uv lock
Resolved 12 packages in 45ms

$ cat uv.lock | head -20
version = 1
requires-python = ">=3.11"

[[package]]
name = "certifi"
version = "2024.8.30"
source = { registry = "https://pypi.org/simple" }
sdist = { url = "https://files.pythonhosted.org/...", hash = "sha256:..." }
wheels = [
    { url = "https://files.pythonhosted.org/...", hash = "sha256:..." },
]
...
```

Perbedaan penting saat menangani versioning dependency dan reproducibility adalah perbedaan antara library dan aplikasi/layanan.
Sebuah library dimaksudkan untuk diimpor dan digunakan oleh kode lain yang mungkin memiliki dependency-nya sendiri, jadi menentukan batasan versi yang terlalu ketat dapat menyebabkan konflik dengan dependency lain milik pengguna.
Sebaliknya, aplikasi atau layanan adalah konsumen akhir perangkat lunak dan biasanya mengekspos fungsionalitasnya melalui antarmuka pengguna atau API, bukan melalui antarmuka pemrograman.
Untuk library, merupakan praktik yang baik untuk menentukan rentang versi guna memaksimalkan kompatibilitas dengan ekosistem package yang lebih luas. Untuk aplikasi, pinning versi yang tepat memastikan reproducibility --- semua orang yang menjalankan aplikasi menggunakan dependency yang persis sama.


Untuk proyek yang membutuhkan reproducibility maksimal, tool seperti [Nix](https://nixos.org/) dan [Bazel](https://bazel.build/) menyediakan build _hermetic_ --- di mana setiap input termasuk compiler, library sistem, dan bahkan environment build itu sendiri di-pin dan di-address berdasarkan konten. Ini menjamin output yang identik bit-demi-bit terlepas dari kapan atau di mana build dijalankan.

> Anda bahkan dapat menggunakan NixOS untuk mengelola seluruh instalasi komputer Anda sehingga Anda dapat dengan mudah membuat salinan baru dari setup komputer Anda dan mengelola konfigurasi lengkapnya melalui file konfigurasi yang terkontrol versi.

Ketegangan yang tidak pernah berakhir dalam pengembangan perangkat lunak adalah bahwa versi perangkat lunak baru memperkenalkan kerusakan baik secara sengaja maupun tidak sengaja, sementara di sisi lain, versi perangkat lunak lama menjadi rentan terhadap kerentanan keamanan seiring berjalannya waktu.
Kita dapat mengatasi hal ini dengan menggunakan pipeline continuous integration (kita akan melihat lebih lanjut di kuliah [Code Quality and CI](/2026/code-quality/)) yang menguji aplikasi kita terhadap versi perangkat lunak baru dan memiliki otomatisasi untuk mendeteksi ketika versi baru dari dependency kita dirilis, seperti [Dependabot](https://github.com/dependabot).

Meskipun dengan pengujian CI, masalah masih terjadi saat mengupgrade versi perangkat lunak, sering kali karena ketidakcocokan yang tak terelakkan antara environment dev dan prod.
Dalam situasi tersebut, langkah terbaik adalah memiliki rencana _rollback_, di mana upgrade versi dibatalkan dan versi yang sudah terbukti baik di-deploy ulang.

# VMs & Containers

Saat Anda mulai bergantung pada dependency yang lebih kompleks, kemungkinan dependency kode Anda akan melampaui batas apa yang dapat ditangani oleh package manager.
Salah satu alasan umum adalah harus berinteraksi dengan library sistem tertentu atau driver hardware.
Sebagai contoh, dalam komputasi ilmiah dan AI, program sering membutuhkan library dan driver khusus untuk memanfaatkan hardware GPU.
Banyak dependency tingkat sistem (driver GPU, versi compiler tertentu, shared library seperti OpenSSL) masih memerlukan instalasi di seluruh sistem.

Secara tradisional, masalah dependency yang lebih luas ini diselesaikan dengan Virtual Machine (VM).
VM mengabstraksikan seluruh komputer dan menyediakan environment yang sepenuhnya terisolasi dengan sistem operasi tersendiri.
Pendekatan yang lebih modern adalah container, yang mengemas sebuah aplikasi beserta dependency, library, dan filesystem-nya, tetapi berbagi kernel sistem operasi host daripada memvirtualisasi seluruh komputer.
Container lebih ringan daripada VM karena mereka berbagi kernel, sehingga lebih cepat untuk dijalankan dan lebih efisien.

Platform container yang paling populer adalah [Docker](https://www.docker.com/). Docker memperkenalkan cara standar untuk membangun, mendistribusikan, dan menjalankan container. Di balik layar, Docker menggunakan containerd sebagai container runtime-nya --- standar industri yang juga digunakan oleh tool lain seperti Kubernetes.

Menjalankan container cukup mudah. Sebagai contoh, untuk menjalankan interpreter Python di dalam container kita menggunakan `docker run` (Flag `-it` membuat container interaktif dengan terminal. Ketika Anda keluar, container berhenti.).

```console
$ docker run -it python:3.12 python
Python 3.12.7 (main, Nov  5 2024, 02:53:25) [GCC 12.2.0] on linux
>>> print("Hello from inside a container!")
Hello from inside a container!
```

Dalam praktiknya, program Anda mungkin bergantung pada keseluruhan filesystem.
Untuk mengatasinya, kita dapat menggunakan container image yang mengemas seluruh filesystem aplikasi sebagai artifact.
Container image dibuat secara terprogram. Dengan docker kita menentukan secara tepat dependency, library sistem, dan konfigurasi image menggunakan sintaks Dockerfile:

```dockerfile
FROM python:3.12
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install -y libpq-dev
RUN pip install numpy
RUN pip install pandas
COPY . /app
WORKDIR /app
RUN pip install .
```

Perbedaan penting: Docker **image** adalah artifact yang dikemas (seperti template), sementara **container** adalah instance yang berjalan dari image tersebut. Anda dapat menjalankan beberapa container dari image yang sama. Image dibangun dalam lapisan, di mana setiap instruksi (`FROM`, `RUN`, `COPY`, dll.) di Dockerfile membuat lapisan baru. Docker melakukan cache pada lapisan-lapisan ini, jadi jika Anda mengubah satu baris di Dockerfile, hanya lapisan tersebut dan lapisan setelahnya yang perlu dibangun ulang.

Dockerfile sebelumnya memiliki beberapa masalah: menggunakan image Python penuh alih-alih varian slim, menjalankan perintah `RUN` terpisah yang membuat lapisan yang tidak perlu, versi tidak di-pin, dan tidak membersihkan cache package manager, sehingga mengemas file yang tidak perlu. Kesalahan umum lainnya termasuk menjalankan container secara tidak aman sebagai root dan secara tidak sengaja menyematkan secret di lapisan.

Berikut adalah versi yang lebih baik

```dockerfile
FROM python:3.12-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libpq-dev && \
    rm -rf /var/lib/apt/lists/*
COPY pyproject.toml uv.lock ./
RUN uv pip install --system -r uv.lock
COPY . /app
```

Pada contoh sebelumnya kita melihat bahwa alih-alih menginstal `uv` dari source, kita menyalin biner yang sudah dibangun dari image `ghcr.io/astral-sh/uv:latest`. Ini dikenal sebagai pola _builder_. Dengan pola ini kita tidak perlu mengirimkan semua tool yang diperlukan untuk mengompilasi kode kita, hanya biner akhir yang diperlukan untuk menjalankan aplikasi (`uv` dalam kasus ini).

Docker memiliki batasan penting yang perlu diperhatikan. Pertama, container image seringkali spesifik platform --- image yang dibangun untuk `linux/amd64` tidak akan berjalan secara native di `linux/arm64` (Mac Apple Silicon) tanpa emulasi, yang lambat. Kedua, container Docker memerlukan kernel Linux, jadi di macOS dan Windows, Docker sebenarnya menjalankan VM Linux ringan di balik layar, yang menambah overhead. Ketiga, isolasi Docker lebih lemah daripada VM --- container berbagi kernel host, yang menjadi masalah keamanan di environment multi-tenant.

> Saat ini, lebih banyak proyek juga menggunakan nix untuk mengelola bahkan library "seluruh sistem" dan aplikasi per proyek melalui [nix flakes](https://serokell.io/blog/practical-nix-flakes).

# Configuration

Perangkat lunak pada dasarnya dapat dikonfigurasi. Dalam kuliah [command line environment](/2026/command-line-environment/) kita melihat program yang menerima opsi melalui flag, environment variable, atau bahkan file konfigurasi alias dotfiles. Hal ini berlaku bahkan untuk aplikasi yang lebih kompleks, dan terdapat pola yang sudah mapan untuk mengelola konfigurasi dalam skala besar.
Konfigurasi perangkat lunak tidak boleh disematkan dalam kode tetapi disediakan saat runtime.
Beberapa yang umum adalah environment variable dan file konfigurasi.

Berikut adalah contoh aplikasi yang dikonfigurasi melalui environment variable:

```python
import os

DATABASE_URL = os.environ.get("DATABASE_URL", "sqlite:///local.db")
DEBUG = os.environ.get("DEBUG", "false").lower() == "true"
API_KEY = os.environ["API_KEY"]  # Required - will raise if not set
```

Sebuah aplikasi juga dapat dikonfigurasi melalui file konfigurasi (misalnya, program Python yang memuat konfigurasi melalui `yaml.load`), `config.yaml`:

```yaml
database:
  url: "postgresql://localhost/myapp"
  pool_size: 5
server:
  host: "0.0.0.0"
  port: 8080
  debug: false
```

Aturan praktis yang baik untuk memikirkan konfigurasi adalah bahwa codebase yang sama harus dapat di-deploy ke environment yang berbeda (development, staging, production) hanya dengan perubahan konfigurasi, bukan perubahan kode.

Di antara banyak opsi konfigurasi sering terdapat data sensitif seperti API key.
Secret perlu ditangani dengan hati-hati untuk menghindari eksposur yang tidak disengaja, dan tidak boleh disertakan dalam version control.


# Services & Orchestration

Aplikasi modern jarang ada dalam isolasi. Sebuah aplikasi web tipikal mungkin membutuhkan database untuk penyimpanan persisten, cache untuk performa, message queue untuk tugas latar belakang, dan berbagai layanan pendukung lainnya. Daripada menggabungkan semuanya menjadi satu aplikasi monolitik, arsitektur modern sering menguraikan fungsionalitas menjadi layanan terpisah yang dapat dikembangkan, di-deploy, dan diskalakan secara independen.

Sebagai contoh, jika kita menentukan aplikasi kita mungkin mendapat manfaat dari penggunaan cache, alih-alih membuatnya sendiri kita dapat memanfaatkan solusi yang sudah teruji seperti [Redis](https://redis.io/) atau [Memcached](https://memcached.org/).
Kita bisa menyematkan Redis di dependency aplikasi kita dengan membangunnya sebagai bagian dari container, tetapi itu berarti menyelaraskan semua dependency antara Redis dan aplikasi kita yang bisa menantang atau bahkan tidak layak.
Sebaliknya, yang dapat kita lakukan adalah men-deploy setiap aplikasi secara terpisah di container-nya sendiri.
Ini sering disebut sebagai arsitektur microservice di mana setiap komponen berjalan sebagai layanan independen yang berkomunikasi melalui jaringan, biasanya melalui API HTTP.

[Docker Compose](https://docs.docker.com/compose/) adalah tool untuk mendefinisikan dan menjalankan aplikasi multi-container. Daripada mengelola container secara individual, Anda mendeklarasikan semua layanan dalam satu file YAML dan mengorkestrasinya bersama. Sekarang aplikasi lengkap kita mencakup lebih dari satu container:

```yaml
# docker-compose.yml
services:
  web:
    build: .
    ports:
      - "8080:8080"
    environment:
      - REDIS_URL=redis://cache:6379
    depends_on:
      - cache

  cache:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  redis_data:
```

Dengan `docker compose up`, kedua layanan dimulai bersama, dan aplikasi web dapat terhubung ke Redis menggunakan hostname `cache` (DNS internal Docker menyelesaikan nama layanan secara otomatis).
Docker Compose memungkinkan kita mendeklarasikan bagaimana kita ingin men-deploy satu atau lebih layanan, dan menangani orkestrasi untuk memulai mereka bersama, menyiapkan jaringan di antara mereka, dan mengelola volume bersama untuk persistensi data.

Untuk deployment production, Anda sering ingin layanan docker compose Anda dimulai secara otomatis saat boot dan dimulai ulang saat gagal. Pendekatan umum adalah menggunakan systemd untuk mengelola deployment docker compose:

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Application
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/myapp
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down

[Install]
WantedBy=multi-user.target
```

File unit systemd ini memastikan aplikasi Anda dimulai ketika sistem boot (setelah Docker siap), dan menyediakan kontrol standar seperti `systemctl start myapp`, `systemctl stop myapp`, dan `systemctl status myapp`.

Seiring kebutuhan deployment yang semakin kompleks --- membutuhkan skalabilitas di beberapa mesin, toleransi kesalahan saat layanan crash, dan jaminan ketersediaan tinggi --- organisasi beralih ke platform orkestrasi container yang canggih seperti Kubernetes (k8s), yang dapat mengelola ribuan container di seluruh kluster mesin. Meskipun demikian, Kubernetes memiliki kurva pembelajaran yang curam dan overhead operasional yang signifikan, sehingga sering berlebihan untuk proyek yang lebih kecil.

Setup multi-container ini sebagian memungkinkan karena layanan modern berkomunikasi satu sama lain melalui API standar, dengan API HTTP REST. Sebagai contoh, setiap kali sebuah program berinteraksi dengan penyedia LLM seperti OpenAI atau Anthropic, di balik layar ia mengirim permintaan HTTP ke server mereka dan mengurai responsnya:

```console
$ curl https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "content-type: application/json" \
    -H "anthropic-version: 2023-06-01" \
    -d '{"model": "claude-sonnet-4-20250514", "max_tokens": 256,
         "messages": [{"role": "user", "content": "Explain containers vs VMs in one sentence."}]}'
```

# Publishing

Setelah Anda menunjukkan kode Anda berfungsi, Anda mungkin tertarik untuk mendistribusikannya agar orang lain dapat mengunduh dan menginstalnya.
Distribusi memiliki banyak bentuk dan secara intrinsik terkait dengan bahasa pemrograman dan environment yang Anda gunakan.

Bentuk distribusi paling sederhana adalah mengunggah artifact untuk orang unduh dan instal secara lokal.
Ini masih umum dan Anda dapat menemukannya di tempat-tempat seperti [arsip package Ubuntu](http://archive.ubuntu.com/ubuntu/pool/main/), yang pada dasarnya adalah daftar direktori HTTP dari file `.deb`.

Saat ini, GitHub telah menjadi platform de facto untuk mempublikasikan source code dan artifact.
Meskipun source code sering tersedia secara publik, GitHub Releases memungkinkan maintainer untuk melampirkan biner yang sudah dibangun dan artifact lainnya ke versi yang di-tag.


Package manager terkadang mendukung penginstalan langsung dari GitHub, baik dari source maupun dari wheel yang sudah dibangun:

```console
# Install from source (will clone and build)
$ pip install git+https://github.com/psf/requests.git

# Install from a specific tag/branch
$ pip install git+https://github.com/psf/requests.git@v2.32.3

# Install a wheel directly from a GitHub release
$ pip install https://github.com/user/repo/releases/download/v1.0/package-1.0-py3-none-any.whl
```

Faktanya, beberapa bahasa seperti Go menggunakan model distribusi terdesentralisasi --- alih-alih repositori package terpusat, modul Go didistribusikan langsung dari repositori source code mereka.
Path modul seperti `github.com/gorilla/mux` menunjukkan di mana kode berada, dan `go get` mengambil langsung dari sana. Namun, sebagian besar package manager seperti `pip`, `cargo`, atau `brew` memiliki indeks terpusat dari proyek yang sudah dikemas untuk kemudahan distribusi dan instalasi. Jika kita menjalankan

```console
$ uv pip install requests --verbose --no-cache 2>&1 | grep -F '.whl'
DEBUG Selecting: requests==2.32.5 [compatible] (requests-2.32.5-py3-none-any.whl)
DEBUG No cache entry for: https://files.pythonhosted.org/packages/1e/db/4254e3eabe8020b458f1a747140d32277ec7a271daf1d235b70dc0b4e6e3/requests-2.32.5-py3-none-any.whl.metadata
DEBUG No cache entry for: https://files.pythonhosted.org/packages/1e/db/4254e3eabe8020b458f1a747140d32277ec7a271daf1d235b70dc0b4e6e3/requests-2.32.5-py3-none-any.whl
```

kita melihat dari mana kita mengambil wheel `requests`. Perhatikan `py3-none-any` di nama file --- ini berarti wheel berfungsi dengan versi Python 3 apa pun, di OS apa pun, di arsitektur apa pun. Untuk package dengan kode yang dikompilasi, wheel-nya spesifik platform:

```console
$ uv pip install numpy --verbose --no-cache 2>&1 | grep -F '.whl'
DEBUG Selecting: numpy==2.2.1 [compatible] (numpy-2.2.1-cp312-cp312-macosx_14_0_arm64.whl)
```

Di sini `cp312-cp312-macosx_14_0_arm64` menunjukkan bahwa wheel ini khusus untuk CPython 3.12 di macOS 14+ untuk ARM64 (Apple Silicon). Jika Anda berada di platform yang berbeda, `pip` akan mengunduh wheel yang berbeda atau membangun dari source.

Sebaliknya, agar orang dapat menemukan package yang telah kita buat, kita perlu mempublikasikannya ke salah satu registri ini.
Di Python, registri utamanya adalah [Python Package Index (PyPI)](https://pypi.org).
Seperti halnya menginstal, terdapat beberapa cara untuk mempublikasikan package. Perintah `uv publish` menyediakan antarmuka modern untuk mengunggah package ke PyPI:

```console
$ uv publish --publish-url https://test.pypi.org/legacy/
Publishing greeting-0.1.0.tar.gz
Publishing greeting-0.1.0-py3-none-any.whl
```

Di sini kita menggunakan [TestPyPI](https://test.pypi.org) --- registri package terpisah yang ditujukan untuk menguji workflow publishing Anda tanpa mengotori PyPI yang sebenarnya. Setelah diunggah, Anda dapat menginstal dari TestPyPI:

```console
$ uv pip install --index-url https://test.pypi.org/simple/ greeting
```

Pertimbangan penting saat mempublikasikan perangkat lunak adalah kepercayaan. Bagaimana pengguna memverifikasi bahwa package yang mereka unduh benar-benar berasal dari Anda dan belum diubah? Registri package menggunakan checksum untuk memverifikasi integritas, dan beberapa ekosistem mendukung penandatanganan package untuk memberikan bukti kriptografis kepengarangan.

Bahasa yang berbeda memiliki registri package mereka sendiri: [crates.io](https://crates.io) untuk Rust, [npm](https://www.npmjs.com) untuk JavaScript, [RubyGems](https://rubygems.org) untuk Ruby, dan [Docker Hub](https://hub.docker.com) untuk container image. Sementara itu, untuk package privat atau internal, organisasi sering men-deploy repositori package mereka sendiri (seperti server PyPI privat atau registri Docker privat) atau menggunakan solusi terkelola dari penyedia cloud.

Men-deploy layanan web ke internet melibatkan infrastruktur tambahan: pendaftaran nama domain, konfigurasi DNS untuk mengarahkan domain Anda ke server Anda, dan seringkali reverse proxy seperti nginx untuk menangani HTTPS dan merutekan traffic. Untuk kasus penggunaan yang lebih sederhana seperti dokumentasi atau situs statis, [GitHub Pages](https://pages.github.com/) menyediakan hosting gratis langsung dari repositori.

<!--
## Documentation

Sejauh ini kita telah menekankan _artifact_ deliverable sebagai output utama dari packaging dan distribusi kode.
Selain artifact, kita perlu mendokumentasikan untuk pengguna fungsionalitas kode, instruksi instalasi, dan contoh penggunaan.

Tool seperti [Sphinx](https://www.sphinx-doc.org/) (Python) dan [MkDocs](https://www.mkdocs.org/) dapat secara otomatis menghasilkan dokumentasi yang dapat ditelusuri dari docstring dan file markdown, sering di-host di layanan seperti [Read the Docs](https://readthedocs.org/).
Untuk API berbasis HTTP, [spesifikasi OpenAPI](https://www.openapis.org/) (sebelumnya Swagger) menyediakan format standar untuk mendeskripsikan endpoint API, yang dapat digunakan tool untuk menghasilkan dokumentasi interaktif dan library klien secara otomatis. -->


# Latihan

1. Simpan environment Anda dengan `printenv` ke sebuah file, buat venv, aktifkan, `printenv` ke file lain dan `diff before.txt after.txt`. Apa yang berubah di environment? Mengapa shell lebih memilih venv? (Petunjuk: lihat `$PATH` sebelum dan setelah aktivasi.) Jalankan `which deactivate` dan pikirkan apa yang dilakukan fungsi bash deactivate.
1. Buat sebuah package Python dengan `pyproject.toml` dan instal di virtual environment. Buat lockfile dan periksa isinya.
1. Instal Docker dan gunakan untuk membangun website kelas Missing Semester secara lokal menggunakan docker compose.
1. Tulis Dockerfile untuk aplikasi Python sederhana. Kemudian tulis `docker-compose.yml` yang menjalankan aplikasi Anda bersama dengan cache Redis.
1. Publikasikan package Python ke TestPyPI (jangan mempublikasikan ke PyPI yang sebenarnya kecuali memang layak untuk dibagikan!). Kemudian bangun Docker image dengan package tersebut dan push ke `ghcr.io`.
1. Buat website menggunakan [GitHub Pages](https://docs.github.com/en/pages/quickstart). Nilai tambahan (non-): konfigurasikan dengan domain kustom.
