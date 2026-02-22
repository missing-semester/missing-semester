---
layout: lecture
title: "ಕೋಡ್ ಪ್ಯಾಕೇಜಿಂಗ್ ಮತ್ತು ಶಿಪ್ಪಿಂಗ್"
description: >
  ಪ್ರಾಜೆಕ್ಟ್ ಪ್ಯಾಕೇಜಿಂಗ್, environments, versioning, ಮತ್ತು libraries, applications, ಹಾಗೂ services ಗಳ deployment ಬಗ್ಗೆ ತಿಳಿಯಿರಿ.
thumbnail: /static/assets/thumbnails/2026/lec6.png
date: 2026-01-20
ready: true
video:
  aspect: 56.25
  id: KBMiB-8P4Ns
---

ಕೋಡ್ ಅನ್ನು ಉದ್ದೇಶಿತ ರೀತಿಯಲ್ಲಿ ಕಾರ್ಯನಿರ್ವಹಿಸುವಂತೆ 만드는ುದು ಕಷ್ಟಕರ - ಅದೇ ಕೋಡ್ ಅನ್ನು ನಿಮ್ಮ ಯಂತ್ರಕ್ಕಿಂತ ಭಿನ್ನವಾದ ಯಂತ್ರದಲ್ಲಿ ಓಡಿಸುವುದು ಬಹುಪಾಲು ಇನ್ನಷ್ಟು ಕಷ್ಟಕರ.

ಕೋಡ್ ಶಿಪ್ಪಿಂಗ್ ಎಂದರೆ ನೀವು ಬರೆದ ಕೋಡ್ ಅನ್ನು, ನಿಮ್ಮ ಕಂಪ್ಯೂಟರ್‌ನ ನಿಖರ setup ಇಲ್ಲದೆ ಮತ್ತೊಬ್ಬರು ನಡೆಸಬಹುದಾದ ಬಳಸಬಹುದಾದ ರೂಪಕ್ಕೆ ಪರಿವರ್ತಿಸುವುದಾಗಿದೆ.
ಕೋಡ್ ಶಿಪ್ಪಿಂಗ್ ಹಲವು ರೂಪಗಳನ್ನು ಹೊಂದಿದ್ದು, programming language, system libraries, ಮತ್ತು operating system ಸೇರಿದಂತೆ ಅನೇಕ ಅಂಶಗಳ ಆಯ್ಕೆಗಳ ಮೇಲೆ ಅವಲಂಬಿತವಾಗಿರುತ್ತದೆ.
ಇದು ನೀವು ನಿರ್ಮಿಸುತ್ತಿರುವದನ್ನು ಕೂಡ ಅವಲಂಬಿಸುತ್ತದೆ: software library, command line tool, ಮತ್ತು web service - ಇವು ಪ್ರತಿಯೊಂದಕ್ಕೂ ವಿಭಿನ್ನ ಅವಶ್ಯಕತೆಗಳು ಮತ್ತು deployment ಹಂತಗಳು ಇವೆ.
ಆದಾಗ್ಯೂ, ಈ ಎಲ್ಲಾ ಸಂದರ್ಭಗಳಲ್ಲಿ ಒಂದು ಸಾಮಾನ್ಯ ಮಾದರಿ ಇದೆ: deliverable ಏನು - ಅಂದರೆ _artifact_ ಏನು - ಮತ್ತು ಅದರ ಸುತ್ತಲಿನ environment ಬಗ್ಗೆ ಅದು ಯಾವ assumptions ಮಾಡುತ್ತದೆ ಎಂಬುದನ್ನು ನಿರ್ದಿಷ್ಟಗೊಳಿಸಬೇಕು.

ಈ ಉಪನ್ಯಾಸದಲ್ಲಿ ನಾವು ಈ ಕೆಳಗಿನ ವಿಷಯಗಳನ್ನು ಆವರಿಸುತ್ತೇವೆ:

- [Dependencies ಮತ್ತು Environments](#dependencies--environments)
- [Artifacts ಮತ್ತು Packaging](#artifacts--packaging)
- [Releases ಮತ್ತು Versioning](#releases--versioning)
- [Reproducibility](#reproducibility)
- [VMs ಮತ್ತು Containers](#vms--containers)
- [Configuration](#configuration)
- [Services ಮತ್ತು Orchestration](#services--orchestration)
- [Publishing](#publishing)

ಈ ಪರಿಕಲ್ಪನೆಗಳನ್ನು ನಾವು Python ecosystem ನ ಉದಾಹರಣೆಗಳ ಮೂಲಕ ವಿವರಿಸುತ್ತೇವೆ, ಏಕೆಂದರೆ ಸ್ಪಷ್ಟ ಉದಾಹರಣೆಗಳು ಅರ್ಥಗರ್ಭಿತ ತಿಳುವಳಿಕೆಗೆ ಸಹಾಯಕ. ಇತರೆ programming language ecosystems ಗಳಲ್ಲಿ tools ಬೇರೆಯಾಗಿದ್ದರೂ, ಪರಿಕಲ್ಪನೆಗಳ ಮೂಲಭೂತ ಅಂಶಗಳು ಬಹುತೇಕ ಒಂದೇ ಆಗಿರುತ್ತವೆ.

# Dependencies & Environments

ಆಧುನಿಕ software development ನಲ್ಲಿ abstraction ಪದರಗಳು ಎಲ್ಲೆಡೆ ಕಂಡುಬರುತ್ತವೆ.
ಪ್ರೋಗ್ರಾಂಗಳು ಸ್ವಾಭಾವಿಕವಾಗಿ ಕೆಲವು logic ಅನ್ನು ಇತರೆ libraries ಅಥವಾ services ಗಳಿಗೆ ಒಪ್ಪಿಸುತ್ತವೆ.
ಆದರೆ ಇದರಿಂದ ನಿಮ್ಮ program ಮತ್ತು ಅದು ಕಾರ್ಯನಿರ್ವಹಿಸಲು ಅಗತ್ಯವಿರುವ libraries ಗಳ ನಡುವೆ _dependency_ ಸಂಬಂಧ ನಿರ್ಮಾಣವಾಗುತ್ತದೆ.
ಉದಾಹರಣೆಗೆ, Python ನಲ್ಲಿ website ನ content ಪಡೆಯಲು ನಾವು ಸಾಮಾನ್ಯವಾಗಿ ಹೀಗೆ ಮಾಡುತ್ತೇವೆ:

```python
import requests

response = requests.get("https://missing.csail.mit.edu")
```

ಆದರೆ `requests` library Python runtime ಜೊತೆಗೆ bundled ಆಗಿ ಬರುವುದಿಲ್ಲ; ಆದ್ದರಿಂದ `requests` install ಮಾಡದೆ ಈ ಕೋಡ್ ಅನ್ನು ಓಡಿಸಲು ಯತ್ನಿಸಿದರೆ Python error ನೀಡುತ್ತದೆ:

```console
$ python fetch.py
Traceback (most recent call last):
  File "fetch.py", line 1, in <module>
    import requests
ModuleNotFoundError: No module named 'requests'
```

ಈ library ಲಭ್ಯವಾಗಲು ಮೊದಲು `pip install requests` ಅನ್ನು ಚಾಲನೆ ಮಾಡಿ install ಮಾಡಬೇಕು.
`pip` ಎಂದರೆ Python programming language ಒದಗಿಸುವ package install ಮಾಡುವ command line tool ಆಗಿದೆ.
`pip install requests` ಕಾರ್ಯಗತಗೊಳಿಸಿದಾಗ ಕೆಳಗಿನ ಕ್ರಮದಲ್ಲಿ ಹಂತಗಳು ನಡೆಯುತ್ತವೆ:

1. Python Package Index ([PyPI](https://pypi.org/)) ನಲ್ಲಿ requests ಹುಡುಕುವುದು
1. ನಾವು ಬಳಸುತ್ತಿರುವ platform ಗೆ ಸರಿಯಾದ artifact ಹುಡುಕುವುದು
1. Dependencies resolve ಮಾಡುವುದು - `requests` library ಗೆ ತಾನೇ ಇತರೆ packages ಮೇಲೂ ಅವಲಂಬನೆ ಇದೆ; ಆದ್ದರಿಂದ installer ಎಲ್ಲಾ transitive dependencies ಗಳಿಗೂ ಹೊಂದಿಕೊಳ್ಳುವ versions ಕಂಡುಹಿಡಿದು ಮೊದಲು install ಮಾಡಬೇಕು
1. Artifacts download ಮಾಡಿ, ನಂತರ files ಅನ್ನು unpack ಮಾಡಿ filesystem ನಲ್ಲಿ ಸರಿಯಾದ ಸ್ಥಳಗಳಿಗೆ ನಕಲಿಸುವುದು

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

ಇಲ್ಲಿ `requests` ಗೆ `certifi` ಅಥವಾ `charset-normalizer` ನಂತಹ ತನ್ನದೇ dependencies ಇರುವುದನ್ನು ನೋಡಬಹುದು; ಹಾಗಾಗಿ `requests` install ಮಾಡುವ ಮೊದಲು ಅವು install ಆಗಬೇಕು.
ಒಮ್ಮೆ install ಆದ ನಂತರ, import ಮಾಡುವಾಗ Python runtime ಈ library ಅನ್ನು ಹುಡುಕಿ ಬಳಸಲು ಸಾಧ್ಯವಾಗುತ್ತದೆ.

```console
$ python -c 'import requests; print(requests.__path__)'
['/usr/local/lib/python3.11/dist-packages/requests']

$ pip list | grep requests
requests        2.32.3
```

Programming languages ಗಳಲ್ಲಿ libraries install ಮತ್ತು publish ಮಾಡಲು ಬೇರೆ ಬೇರೆ tools, conventions ಮತ್ತು practices ಇರುತ್ತವೆ.
Rust ನಂತಹ ಕೆಲವು languages ಗಳಲ್ಲಿ toolchain ಏಕೀಕೃತವಾಗಿದೆ - `cargo` build, test, dependency management, ಮತ್ತು publishing ಎಲ್ಲವನ್ನೂ ನೋಡಿಕೊಳ್ಳುತ್ತದೆ.
Python ನಂತಹ ecosystems ಗಳಲ್ಲಿ ಈ ಏಕೀಕರಣವು specification ಮಟ್ಟದಲ್ಲಿ ನಡೆದಿದೆ - ಒಂದೇ tool ಬದಲಾಗಿ packaging ಹೇಗೆ ಕೆಲಸ ಮಾಡಬೇಕು ಎಂಬುದನ್ನು standardized specifications ನಿರ್ಧರಿಸುತ್ತವೆ; ಇದರ ಮೂಲಕ ಪ್ರತಿ ಕಾರ್ಯಕ್ಕೂ ಹಲವಾರು ಸ್ಪರ್ಧಾತ್ಮಕ tools ಇರಲು ಅವಕಾಶವಿದೆ (`pip` vs [`uv`](https://docs.astral.sh/uv/), `setuptools` vs [`hatch`](https://hatch.pypa.io/) vs [`poetry`](https://python-poetry.org/)).
ಮತ್ತೆ LaTeX ನಂತಹ ಕೆಲ ecosystems ಗಳಲ್ಲಿ TeX Live ಅಥವಾ MacTeX distributions ಗಳೊಂದಿಗೆ ಸಾವಿರಾರು packages ಪೂರ್ವಸ್ಥಾಪಿತವಾಗಿ bundled ಆಗಿ ಬರುತ್ತವೆ.

Dependencies ಪರಿಚಯಿಸುವುದರಿಂದ dependency conflicts ಕೂಡ ಉಂಟಾಗುತ್ತವೆ.
ಒಂದೇ dependency ಗೆ programs ಪರಸ್ಪರ ಹೊಂದಿಕೆಯಾಗದ versions ಅಗತ್ಯವಿದ್ದಾಗ conflicts ಉಂಟಾಗುತ್ತವೆ.
ಉದಾಹರಣೆಗೆ, `tensorflow==2.3.0` ಗೆ `numpy>=1.16.0,<1.19.0` ಅಗತ್ಯವಿದ್ದು, `pandas==1.2.0` ಗೆ `numpy>=1.16.5` ಅಗತ್ಯವಿದ್ದರೆ `numpy>=1.16.5,<1.19.0` ತೃಪ್ತಿಪಡಿಸುವ ಯಾವ version ಆದರೂ ಮಾನ್ಯ.
ಆದರೆ ನಿಮ್ಮ project ನ ಇನ್ನೊಂದು package ಗೆ `numpy>=1.19` ಅಗತ್ಯವಿದ್ದರೆ, ಎಲ್ಲ constraints ಗಳನ್ನೂ ತೃಪ್ತಿಪಡಿಸುವ ಮಾನ್ಯ version ಇಲ್ಲದ conflict ಉಂಟಾಗುತ್ತದೆ.

ಈ ಪರಿಸ್ಥಿತಿ - ಹಲವಾರು packages ಗಳು shared dependencies ಗಳಿಗೆ ಪರಸ್ಪರ ಅಸಂಗತ versions ಬೇಡುವುದು - ಸಾಮಾನ್ಯವಾಗಿ _dependency hell_ ಎಂದು ಕರೆಯಲಾಗುತ್ತದೆ.
ಈ conflicts ನನ್ನು ನಿಭಾಯಿಸುವ ಒಂದು ವಿಧಾನವೆಂದರೆ ಪ್ರತಿ program ನ dependencies ಗಳನ್ನು ಪ್ರತ್ಯೇಕ _environment_ ಗಳಲ್ಲಿ ಪ್ರತ್ಯೇಕಿಸುವುದು.
Python ನಲ್ಲಿ virtual environment ರಚಿಸಲು ಹೀಗೆ ಮಾಡುತ್ತೇವೆ:

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

Environment ಅನ್ನು language runtime ನ ಸಂಪೂರ್ಣ standalone ರೂಪವಾಗಿ, ಅದಕ್ಕೇ ಸೇರಿದ packages ಗಳ ಸಮೂಹದೊಂದಿಗೆ ಕಲ್ಪಿಸಬಹುದು.
ಈ virtual environment ಅಥವಾ venv, install ಆಗಿರುವ dependencies ಗಳನ್ನು global Python installation ನಿಂದ ಪ್ರತ್ಯೇಕಿಸುತ್ತದೆ.
ಪ್ರತಿ project ಗೆ ಅದಕ್ಕೆ ಬೇಕಾದ dependencies ಒಳಗೊಂಡ ಪ್ರತ್ಯೇಕ virtual environment ಇರುವುದು ಉತ್ತಮ ಅಭ್ಯಾಸ.

> ಅನೇಕ ಆಧುನಿಕ operating systems ಗಳು Python ಮುಂತಾದ programming language runtimes ಗಳ installations ಜೊತೆ ಬರುತ್ತವೆ; ಆದರೆ OS ತನ್ನ ಸ್ವಂತ ಕಾರ್ಯಚಟುವಟಿಕೆಗಾಗಿ ಅವುಗಳ ಮೇಲೆ ಅವಲಂಬಿತವಾಗಿರಬಹುದಾದ್ದರಿಂದ ಅವನ್ನು ತಿದ್ದುಪಡಿ ಮಾಡುವುದು ಸಮಂಜಸವಲ್ಲ. ಬದಲಾಗಿ ಪ್ರತ್ಯೇಕ environments ಬಳಸುವುದನ್ನು ಆದ್ಯತೆ ನೀಡಿ.

ಕೆಲ languages ಗಳಲ್ಲಿ installation protocol ಒಂದು tool ಮೂಲಕವಲ್ಲ, specification ರೂಪದಲ್ಲೇ ವ್ಯಾಖ್ಯಾನಗೊಂಡಿರುತ್ತದೆ.
Python ನಲ್ಲಿ [PEP 517](https://peps.python.org/pep-0517/) build system interface ಅನ್ನು ವ್ಯಾಖ್ಯಾನಿಸುತ್ತದೆ ಮತ್ತು [PEP 621](https://peps.python.org/pep-0621/) project metadata ಅನ್ನು `pyproject.toml` ನಲ್ಲಿ ಹೇಗೆ ಸಂಗ್ರಹಿಸಬೇಕು ಎಂದು ಸೂಚಿಸುತ್ತದೆ.
ಇದರ ಫಲವಾಗಿ ಅಭಿವೃದ್ಧಿಪರರು `pip` ಅನ್ನು ಸುಧಾರಿಸಿ `uv` ನಂತಹ ಹೆಚ್ಚು optimized tools ರೂಪಿಸಿದ್ದಾರೆ. `uv` install ಮಾಡಲು `pip install uv` ಸಾಕಾಗುತ್ತದೆ.

`pip` ಬದಲಿಗೆ `uv` ಬಳಸಿದರೂ interface ಅದೇ ಇರುತ್ತದೆ; ಆದರೆ ವೇಗ ಗಣನೀಯವಾಗಿ ಹೆಚ್ಚಿರುತ್ತದೆ:

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

> ಸಾಧ್ಯವಾದಾಗಲೆಲ್ಲ `pip` ಬದಲು `uv pip` ಬಳಸಿ ಎಂದು ನಾವು ಬಲವಾಗಿ ಶಿಫಾರಸು ಮಾಡುತ್ತೇವೆ, ಏಕೆಂದರೆ ಇದು installation ಸಮಯವನ್ನು ಗಣನೀಯವಾಗಿ ಕಡಿತಗೊಳಿಸುತ್ತದೆ.

Dependency isolation ಗಿಂತಲೂ ಹೊರತು, environments ನಿಮ್ಮ programming language runtime ನ ವಿಭಿನ್ನ versions ಇಟ್ಟುಕೊಳ್ಳಲು ಸಹ ನೆರವಾಗುತ್ತವೆ.

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

ಇದು ಹಲವು Python versions ಗಳಲ್ಲಿ ನಿಮ್ಮ code test ಮಾಡಲು ಅಥವಾ project ಒಂದು ನಿರ್ದಿಷ್ಟ version ಬೇಡುವಾಗ ಬಹಳ ಉಪಯುಕ್ತ.

> ಕೆಲವು programming languages ಗಳಲ್ಲಿ ಪ್ರತಿ project ಗೆ dependencies ಗಾಗಿ environment ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಸಿಗುತ್ತದೆ; ನೀವು ಕೈಯಾರೆ ರಚಿಸುವ ಅಗತ್ಯವಿಲ್ಲ. ಆದರೂ ತತ್ವ ಒಂದೇ. ಇಂದಿನ ಬಹುತೇಕ languages ಒಂದೇ system ನಲ್ಲಿ ಭಾಷೆಯ ಹಲವು versions ನಿರ್ವಹಿಸಲು ಹಾಗೂ ಪ್ರತಿ project ಗೆ ಯಾವ version ಬಳಸಬೇಕು ಎಂದು ಸೂಚಿಸಲು ವ್ಯವಸ್ಥೆ ಹೊಂದಿವೆ.

# Artifacts & Packaging

Software development ನಲ್ಲಿ source code ಮತ್ತು artifacts ಮಧ್ಯೆ ನಾವು ವ್ಯತ್ಯಾಸ ಮಾಡುತ್ತೇವೆ. ಅಭಿವೃದ್ಧಿಪರರು source code ಓದುತ್ತಾರೆ ಮತ್ತು ಬರೆಯುತ್ತಾರೆ; artifacts ಎಂದರೆ ಆ source code ನಿಂದ ಉತ್ಪತ್ತಿಯಾಗುವ packaged, distributable outputs - install ಅಥವಾ deploy ಮಾಡಲು ಸಿದ್ಧವಾಗಿರುವವು.
Artifact ಒಂದು ನಾವು ಓಡಿಸುವ ಸರಳ code file ಆಗಿರಬಹುದು; ಅಥವಾ application ನ ಎಲ್ಲಾ ಅಗತ್ಯ ಅಂಶಗಳನ್ನು ಹೊಂದಿರುವ ಸಂಪೂರ್ಣ Virtual Machine ಆಗಿರಬಹುದು.
ಉದಾಹರಣೆಗೆ, ನಮ್ಮ ಪ್ರಸ್ತುತ directory ಯಲ್ಲಿ `greet.py` ಎಂಬ Python file ಇದೆ ಎಂದು ಪರಿಗಣಿಸಿ:

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

ಬೇರೆ directory ಗೆ ಹೋದ ಕೂಡಲೇ import ವಿಫಲವಾಗುತ್ತದೆ, ಏಕೆಂದರೆ Python modules ಅನ್ನು ನಿರ್ದಿಷ್ಟ ಸ್ಥಳಗಳಲ್ಲಿ ಮಾತ್ರ ಹುಡುಕುತ್ತದೆ (current directory, installed packages, ಮತ್ತು `PYTHONPATH` ನಲ್ಲಿರುವ paths). Packaging ಈ ಸಮಸ್ಯೆಯನ್ನು ಕೋಡ್ ಅನ್ನು ತಿಳಿದಿರುವ ಸ್ಥಳಕ್ಕೆ install ಮಾಡುವ ಮೂಲಕ ಪರಿಹರಿಸುತ್ತದೆ.

Python ನಲ್ಲಿ library ಪ್ಯಾಕೇಜ್ ಮಾಡುವುದೆಂದರೆ `pip` ಅಥವಾ `uv` ಮುಂತಾದ package installers ಗೆ ಸಂಬಂಧಿತ files install ಮಾಡಲು ಸಾಧ್ಯವಾಗುವ artifact ನಿರ್ಮಿಸುವುದು.
Python artifacts ಗಳನ್ನು _wheels_ ಎಂದು ಕರೆಯುತ್ತಾರೆ; package install ಮಾಡಲು ಬೇಕಾದ ಎಲ್ಲಾ ಮಾಹಿತಿಯನ್ನು ಅವು ಹೊಂದಿರುತ್ತವೆ: code files, package metadata (name, version, dependencies), ಮತ್ತು files ಅನ್ನು environment ನಲ್ಲಿ ಯಾವ ಸ್ಥಳಕ್ಕೆ ಇಡಬೇಕು ಎಂಬ ಸೂಚನೆಗಳು.
Artifact ನಿರ್ಮಿಸಲು project file (manifest ಎಂದೂ ಕರೆಯಲಾಗುತ್ತದೆ) ಬರೆಯಬೇಕು; ಅದರಲ್ಲಿ project ವಿವರಗಳು, ಅಗತ್ಯ dependencies, package version, ಮತ್ತು ಇತರ ಮಾಹಿತಿ ಇರಬೇಕು. Python ನಲ್ಲಿ ಈ ಉದ್ದೇಶಕ್ಕಾಗಿ `pyproject.toml` ಬಳಸುತ್ತೇವೆ.

> `pyproject.toml` ಆಧುನಿಕ ಮತ್ತು ಶಿಫಾರಸುಗೊಂಡ ವಿಧಾನವಾಗಿದೆ. `requirements.txt` ಅಥವಾ `setup.py` ನಂತಹ ಹಿಂದಿನ packaging ವಿಧಾನಗಳಿಗೆ ಇನ್ನೂ support ಇದ್ದರೂ, ಸಾಧ್ಯವಾದರೆ `pyproject.toml` ಗೆ ಆದ್ಯತೆ ನೀಡಿ.

Command-line tool ಕೂಡ ಒದಗಿಸುವ library ಗಾಗಿ ಕನಿಷ್ಠ `pyproject.toml` ಉದಾಹರಣೆ ಇಲ್ಲಿದೆ:

```toml
[project]
name = "greeting"
version = "0.1.0"
description = "A simple greeting library"
dependencies = ["typer>=0.9"]

[project.scripts]
greet = "greeting:main"

[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"
```

`typer` library ಎಂದರೆ ಅತಿ ಕಡಿಮೆ boilerplate ನೊಂದಿಗೆ command-line interfaces ರಚಿಸಲು ಪ್ರಸಿದ್ಧ Python package ಆಗಿದೆ.

ಇದಕ್ಕೆ ಹೊಂದುವ `greeting.py`:

```python
import typer


def greet(name: str) -> str:
    return f"Hello, {name}!"


def main(name: str):
    print(greet(name))


if __name__ == "__main__":
    typer.run(main)
```

ಈ file ನೊಂದಿಗೆ ಈಗ ನಾವು wheel build ಮಾಡಬಹುದು:

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

`.whl` file ಎಂದರೆ wheel (ನಿರ್ದಿಷ್ಟ ರಚನೆಯ zip archive), ಮತ್ತು `.tar.gz` ಎಂದರೆ source ನಿಂದ build ಮಾಡಬೇಕಾದ systems ಗಾಗಿ source distribution.

Package ಆಗುವ ವಿಷಯವನ್ನು ನೋಡಲು wheel ನ ಒಳಗಿನ ವಿಷಯವನ್ನು ಪರಿಶೀಲಿಸಬಹುದು:

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

ಈ wheel ಅನ್ನು ಇನ್ನೊಬ್ಬರಿಗೆ ಕೊಟ್ಟರೆ, ಅವರು ಹೀಗೆ install ಮಾಡಬಹುದು:

```console
$ uv pip install ./greeting-0.1.0-py3-none-any.whl
$ greet Alice
Hello, Alice!
```

ಇದರಿಂದ ನಾವು ಮೊದಲು build ಮಾಡಿದ್ದ library ಅನ್ನು, `greet` cli tool ಸೇರಿ, ಅವರ environment ನಲ್ಲಿ install ಮಾಡಬಹುದು.

ಈ ವಿಧಾನಕ್ಕೆ ಕೆಲವು ಮಿತಿಗಳಿವೆ. ವಿಶೇಷವಾಗಿ, ನಮ್ಮ library platform-specific libraries ಮೇಲೆ ಅವಲಂಬಿತವಾಗಿದ್ದರೆ (ಉದಾ., GPU acceleration ಗಾಗಿ CUDA), artifact ಆ ವಿಶೇಷ libraries install ಆಗಿರುವ systems ಗಳಲ್ಲಿ ಮಾತ್ರ ಕೆಲಸ ಮಾಡುತ್ತದೆ; ಜೊತೆಗೆ ವಿಭಿನ್ನ platforms (Linux, macOS, Windows) ಮತ್ತು architectures (x86, ARM) ಗಾಗಿ ಬೇರೆ ಬೇರೆ wheels build ಮಾಡಬೇಕಾಗಬಹುದು.


Software install ಮಾಡುವಾಗ source ನಿಂದ install ಮಾಡುವುದೂ prebuilt binary ನಿಂದ install ಮಾಡುವುದೂ ಬೇರೆ ಎಂಬ ಮುಖ್ಯ ವ್ಯತ್ಯಾಸವಿದೆ. Source ನಿಂದ install ಮಾಡುವುದೆಂದರೆ ಮೂಲ code download ಮಾಡಿ ನಿಮ್ಮ ಯಂತ್ರದಲ್ಲೇ compile ಮಾಡುವುದು - ಇದಕ್ಕಾಗಿ compiler ಮತ್ತು build tools install ಆಗಿರಬೇಕು; ದೊಡ್ಡ projects ಗಳಿಗೆ ಇದು ಹೆಚ್ಚಿನ ಸಮಯ ತೆಗೆದುಕೊಳ್ಳಬಹುದು.

Prebuilt binary install ಮಾಡುವುದೆಂದರೆ ಇತರೆ ಯಾರಾದರೂ ಈಗಾಗಲೇ compile ಮಾಡಿದ artifact download ಮಾಡುವುದು - ವೇಗವಾಗಿ ಹಾಗೂ ಸರಳವಾಗಿ ನಡೆಯುತ್ತದೆ; ಆದರೆ binary ನಿಮ್ಮ platform ಮತ್ತು architecture ಗೆ ಹೊಂದಿರಬೇಕು.
ಉದಾಹರಣೆಗೆ, [ripgrep ನ releases page](https://github.com/BurntSushi/ripgrep/releases) ನಲ್ಲಿ Linux (x86_64, ARM), macOS (Intel, Apple Silicon), ಮತ್ತು Windows ಗಾಗಿ prebuilt binaries ಕಾಣಬಹುದು.


# Releases & Versioning

ಕೋಡ್ ನಿರಂತರ ಪ್ರಕ್ರಿಯೆಯಲ್ಲಿ ನಿರ್ಮಾಣವಾಗುತ್ತದೆ, ಆದರೆ release ಗಳು discrete ಆಧಾರದ ಮೇಲೆ ನಡೆಯುತ್ತವೆ.
Software development ನಲ್ಲಿ development ಮತ್ತು production environments ಗಳ ನಡುವೆ ಸ್ಪಷ್ಟ ವ್ಯತ್ಯಾಸವಿದೆ.
ಕೋಡ್ ಅನ್ನು prod ಗೆ _shipped_ ಮಾಡುವ ಮೊದಲು dev environment ನಲ್ಲಿ ಅದು ಸರಿಯಾಗಿ ಕೆಲಸ ಮಾಡುತ್ತದೆ ಎಂಬುದು ದೃಢವಾಗಬೇಕು.
Release ಪ್ರಕ್ರಿಯೆಯಲ್ಲಿ testing, dependency management, versioning, configuration, deployment, ಮತ್ತು publishing ಸೇರಿದಂತೆ ಅನೇಕ ಹಂತಗಳು ಸೇರಿರುತ್ತವೆ.


Software libraries ಸ್ಥಿರವಾಗಿರುವುದಿಲ್ಲ; ಅವು ಕಾಲಕ್ರಮದಲ್ಲಿ fixes ಹಾಗೂ ಹೊಸ features ಗಳೊಂದಿಗೆ ವಿಕಸಿಸುತ್ತವೆ.
ಈ ವಿಕಾಸವನ್ನು ನಾವು discrete version identifiers ಮೂಲಕ ಹತ್ತಿರದಿಂದ ಅನುಸರಿಸುತ್ತೇವೆ; ಅವು ನಿರ್ದಿಷ್ಟ ಸಮಯದ library ಸ್ಥಿತಿಯನ್ನು ಸೂಚಿಸುತ್ತವೆ.
Library ವರ್ತನೆಯಲ್ಲಿ ಬರುವ ಬದಲಾವಣೆಗಳು noncritical ಕಾರ್ಯಕ್ಷಮತೆಯನ್ನು ಸರಿಪಡಿಸುವ patches ಇಂದ, ಕಾರ್ಯಕ್ಷಮತೆಯನ್ನು ವಿಸ್ತರಿಸುವ ಹೊಸ features ಗಳವರೆಗೆ, ಹಾಗೂ backwards compatibility ಮುರಿಯುವ ಬದಲಾವಣೆಗಳವರೆಗೆ ಇರಬಹುದು.
Changelogs ಒಂದು version ಪರಿಚಯಿಸುವ ಬದಲಾವಣೆಗಳನ್ನು ದಾಖಲಿಸುತ್ತವೆ - ಹೊಸ release ಗೆ ಸಂಬಂಧಿಸಿದ ಬದಲಾವಣೆಗಳನ್ನು software developers ಪರಸ್ಪರ ಸಂವಹನ ಮಾಡಲು ಬಳಸುವ ದಾಖಲೆಗಳು ಅವು.

ಆದಾಗ್ಯೂ, ಪ್ರತಿ dependency ಯ ನಡೆಯುತ್ತಿರುವ ಬದಲಾವಣೆಗಳನ್ನು ಎಲ್ಲವನ್ನೂ ಟ್ರ್ಯಾಕ್ ಮಾಡುವುದು ಪ್ರಾಯೋಗಿಕವಲ್ಲ; transitive dependencies - ಅಂದರೆ ನಮ್ಮ dependencies ಗಳ dependencies - ಪರಿಗಣಿಸಿದರೆ ಇದು ಇನ್ನೂ ಕಷ್ಟಕರ.

> ನಿಮ್ಮ project ನ ಸಂಪೂರ್ಣ dependency tree ಅನ್ನು `uv tree` ಮೂಲಕ ದೃಶ್ಯೀಕರಿಸಬಹುದು; ಇದು ಎಲ್ಲಾ packages ಮತ್ತು ಅವುಗಳ transitive dependencies ಅನ್ನು tree ರೂಪದಲ್ಲಿ ತೋರಿಸುತ್ತದೆ.

ಈ ಸಮಸ್ಯೆಯನ್ನು ಸರಳಗೊಳಿಸಲು software versioning ಕುರಿತು conventions ಇವೆ; ಅವುಗಳಲ್ಲಿ ಹೆಚ್ಚು ವ್ಯಾಪಕವಾದುದು [Semantic Versioning](https://semver.org/) ಅಥವಾ SemVer.
Semantic Versioning ಅಡಿಯಲ್ಲಿ version ರೂಪ MAJOR.MINOR.PATCH ಆಗಿರುತ್ತದೆ; ಪ್ರತಿಯೊಂದು ಮೌಲ್ಯವೂ ಪೂರ್ಣಾಂಕ. ಸಂಕ್ಷಿಪ್ತವಾಗಿ, upgrade ಮಾಡುವಾಗ:

- PATCH (ಉದಾ., 1.2.3 → 1.2.4) ನಲ್ಲಿ bug fixes ಮಾತ್ರ ಇರಬೇಕು ಮತ್ತು ಸಂಪೂರ್ಣ backwards compatible ಆಗಿರಬೇಕು
- MINOR (ಉದಾ., 1.2.3 → 1.3.0) backwards-compatible ರೀತಿಯಲ್ಲಿ ಹೊಸ functionality ಸೇರಿಸುತ್ತದೆ
- MAJOR (ಉದಾ., 1.2.3 → 2.0.0) breaking changes ಸೂಚಿಸುತ್ತದೆ; code ಬದಲಾವಣೆಗಳು ಅಗತ್ಯವಾಗಬಹುದು

> ಇದು ಸರಳೀಕೃತ ವಿವರಣೆ ಮಾತ್ರ. ಉದಾಹರಣೆಗೆ 0.1.3 ಇಂದ 0.2.0 ಗೆ ಹೋಗುವಾಗ ಏಕೆ breaking changes ಆಗಬಹುದು ಅಥವಾ 1.0.0-rc.1 ಎಂದರೇನು ಎಂಬುದನ್ನು ತಿಳಿಯಲು ಪೂರ್ಣ SemVer specification ಓದಲು ನಾವು ಪ್ರೋತ್ಸಾಹಿಸುತ್ತೇವೆ.
Python packaging semantic versioning ಗೆ ಸ್ಥಳೀಯ support ನೀಡುತ್ತದೆ; ಆದ್ದರಿಂದ dependencies versions ಸೂಚಿಸುವಾಗ ವಿವಿಧ specifiers ಬಳಸಬಹುದು:

`pyproject.toml` ನಲ್ಲಿ dependencies ಗಳ compatible versions ಶ್ರೇಣಿಯನ್ನು constrain ಮಾಡಲು ಬೇರೆ ಬೇರೆ ವಿಧಾನಗಳಿವೆ:

```toml
[project]
dependencies = [
    "requests==2.32.3",  # Exact version - only this specific version
    "click>=8.0",        # Minimum version - 8.0 or newer
    "numpy>=1.24,<2.0",  # Range - at least 1.24 but less than 2.0
    "pandas~=2.1.0",     # Compatible release - >=2.1.0 and <2.2.0
]
```

Version specifiers ಅನೇಕ package managers (npm, cargo, ಇತ್ಯಾದಿ) ಗಳಲ್ಲಿ ಕಂಡುಬರುತ್ತವೆ; ಆದರೆ ನಿಖರ semantics ಬೇರೆ ಇರಬಹುದು. `~=` operator Python ನ "compatible release" operator - `~=2.1.0` ಎಂದರೆ "2.1.0 ಗೆ ಹೊಂದಿಕೊಳ್ಳುವ ಯಾವುದೇ version", ಅಂದರೆ `>=2.1.0` ಮತ್ತು `<2.2.0`. ಇದು npm ಮತ್ತು cargo ಯ caret (`^`) operator ಗೆ ಸುಮಾರು ಸಮಾನ, ಅದು SemVer compatibility ಪರಿಕಲ್ಪನೆ ಅನುಸರಿಸುತ್ತದೆ.

ಎಲ್ಲ software ಗಳು semantic versioning ಬಳಸುವುದಿಲ್ಲ. ಸಾಮಾನ್ಯ ಪರ್ಯಾಯವೆಂದರೆ Calendar Versioning (CalVer), ಇದರಲ್ಲಿ versions semantic ಅರ್ಥದ ಬದಲಾಗಿ release ದಿನಾಂಕಗಳ ಆಧಾರವಾಗಿರುತ್ತವೆ. ಉದಾಹರಣೆಗೆ, Ubuntu `24.04` (April 2024) ಮತ್ತು `24.10` (October 2024) ಮಾದರಿಯ versions ಬಳಸುತ್ತದೆ. CalVer release ಎಷ್ಟು ಹಳೆಯದು ಎನ್ನುವುದನ್ನು ಸುಲಭವಾಗಿ ತೋರಿಸುತ್ತದೆ; ಆದರೆ compatibility ಬಗ್ಗೆ ಮಾಹಿತಿ ನೀಡುವುದಿಲ್ಲ. ಕೊನೆಗೆ, semantic versioning ಅಚ್ಯುತವಲ್ಲ; ಕೆಲವೊಮ್ಮೆ maintainers minor ಅಥವಾ patch releases ಗಳಲ್ಲಿಯೂ ಅಜಾಗರೂಕತೆಯಿಂದ breaking changes ಪರಿಚಯಿಸುತ್ತಾರೆ.


# Reproducibility

ಆಧುನಿಕ software development ನಲ್ಲಿ ನೀವು ಬರೆಯುವ code ಬಹಳ ಪ್ರಮಾಣದ abstraction ಪದರಗಳ ಮೇಲೆ ನಿಂತಿರುತ್ತದೆ.
ಇದರಲ್ಲಿ ನಿಮ್ಮ programming language runtime, third party libraries, operating system, ಅಥವಾ hardware ಕೂಡ ಸೇರಿರಬಹುದು.
ಈ ಪದರಗಳಲ್ಲಿ ಯಾವುದಾದರೂ ವ್ಯತ್ಯಾಸವು ನಿಮ್ಮ code ವರ್ತನೆಯನ್ನು ಬದಲಿಸಬಹುದು ಅಥವಾ ಅದು ಉದ್ದೇಶಿತಂತೆ ಕೆಲಸ ಮಾಡುವುದನ್ನೇ ತಡೆಯಬಹುದು.
ಮತ್ತಷ್ಟು, ಅಡಿಗಟ್ಟಿನ hardware ವ್ಯತ್ಯಾಸಗಳೂ software ship ಮಾಡುವ ನಿಮ್ಮ ಸಾಮರ್ಥ್ಯವನ್ನು ಪ್ರಭಾವಿಸುತ್ತವೆ.

Library pinning ಎಂದರೆ range ಬದಲಿಗೆ exact version ಸೂಚಿಸುವುದು; ಉದಾ., `requests>=2.0` ಬದಲಿಗೆ `requests==2.32.3`.

Package manager ನ ಪ್ರಮುಖ ಕೆಲಸಗಳಲ್ಲಿ ಒಂದು ಎಂದರೆ dependencies - ಹಾಗೂ transitive dependencies - ನೀಡುವ ಎಲ್ಲಾ constraints ಗಳನ್ನು ಪರಿಗಣಿಸಿ, ಅವನ್ನೆಲ್ಲ ತೃಪ್ತಿಪಡಿಸುವ ಮಾನ್ಯ versions ಪಟ್ಟಿಯನ್ನು ಉತ್ಪಾದಿಸುವುದು.
ಆ ನಿರ್ದಿಷ್ಟ versions ಪಟ್ಟಿಯನ್ನು reproducibility ಗಾಗಿ file ಗೆ ಉಳಿಸಬಹುದು; ಇವುಗಳನ್ನು _lock files_ ಎಂದು ಕರೆಯಲಾಗುತ್ತದೆ.

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

Dependency versioning ಮತ್ತು reproducibility ನೋಡಿಕೊಳ್ಳುವಾಗ ಒಂದು ಪ್ರಮುಖ ವ್ಯತ್ಯಾಸವೆಂದರೆ libraries ಮತ್ತು applications/services ನಡುವಿನ ಭೇದ.
Library ಅನ್ನು ಇತರೆ code import ಮಾಡಿ ಬಳಸಲು ಉದ್ದೇಶಿಸಿರುವುದರಿಂದ, ಆ ಇತರೆ code ಗೆ ತನ್ನದೇ dependencies ಇರಬಹುದು; ಆದ್ದರಿಂದ ಅತಿಯಾಗಿ ಕಠಿಣ version constraints ನೀಡುವುದು ಬಳಕೆದಾರರ ಇತರೆ dependencies ಗಳೊಂದಿಗೆ conflicts ಉಂಟುಮಾಡಬಹುದು.
ಇದಕ್ಕೆ ವಿರುದ್ಧವಾಗಿ, applications ಅಥವಾ services software ನ ಅಂತಿಮ ಗ್ರಾಹಕರು; ಅವು ಸಾಮಾನ್ಯವಾಗಿ programming interface ಮೂಲಕವಲ್ಲ, user interface ಅಥವಾ API ಮೂಲಕ ತಮ್ಮ functionality ಒದಗಿಸುತ್ತವೆ.
Libraries ಗಾಗಿ, package ecosystem ನಲ್ಲಿ ಹೆಚ್ಚಿನ compatibility ಪಡೆಯಲು version ranges ಸೂಚಿಸುವುದು ಉತ್ತಮ ಅಭ್ಯಾಸ. Applications ಗಾಗಿ, exact versions pin ಮಾಡುವುದರಿಂದ reproducibility ಖಚಿತವಾಗುತ್ತದೆ - application ಓಡಿಸುವ ಎಲ್ಲರೂ ಅದೇ dependencies ಬಳಸುತ್ತಾರೆ.


ಗರಿಷ್ಠ reproducibility ಅಗತ್ಯವಿರುವ projects ಗಾಗಿ [Nix](https://nixos.org/) ಮತ್ತು [Bazel](https://bazel.build/) ನಂತಹ tools _hermetic_ builds ಒದಗಿಸುತ್ತವೆ - ಇಲ್ಲಿ compilers, system libraries, ಹಾಗೂ build environment ಕೂಡ ಸೇರಿ ಪ್ರತಿಯೊಂದು input pin ಆಗಿ content-addressed ಆಗಿರುತ್ತದೆ. ಇದರಿಂದ build ಯಾವಾಗ, ಎಲ್ಲಲ್ಲಿ ನಡೆದರೂ bit-for-bit ಒಂದೇ output ದೊರೆಯುತ್ತದೆ.

> ನೀವು NixOS ಬಳಸಿ ಸಂಪೂರ್ಣ ಕಂಪ್ಯೂಟರ್ install ನ್ನೇ ನಿರ್ವಹಿಸಬಹುದು; ಹೀಗಾಗಿ ನಿಮ್ಮ setup ನ ಹೊಸ ಪ್ರತಿಗಳನ್ನು ಸುಲಭವಾಗಿ ನಿರ್ಮಿಸಿ, ಅವುಗಳ ಸಂಪೂರ್ಣ configuration ಅನ್ನು version-controlled configuration files ಮೂಲಕ ನಿರ್ವಹಿಸಬಹುದು.

Software development ನಲ್ಲಿ ಅಂತ್ಯವಿಲ್ಲದ ಒತ್ತಡವೊಂದಿದೆ: ಹೊಸ software versions ಉದ್ದೇಶಪೂರ್ವಕವಾಗಿಯೂ ಅಥವಾ ಅನಾಯಾಸವಾಗಿಯೂ breakage ತರಬಹುದು; ಮತ್ತೊಂದೆಡೆ ಹಳೆಯ software versions ಕಾಲಕ್ರಮದಲ್ಲಿ security vulnerabilities ಗೆ ಒಳಗಾಗುತ್ತವೆ.
ಇದನ್ನು continuous integration pipelines (ಇದರ ಬಗ್ಗೆ [Code Quality and CI](/2026/code-quality/) ಉಪನ್ಯಾಸದಲ್ಲಿ ಇನ್ನಷ್ಟು ನೋಡುತ್ತೇವೆ) ಬಳಸಿ, ಹೊಸ software versions ವಿರುದ್ಧ application ಅನ್ನು test ಮಾಡುವ ಮೂಲಕ ಮತ್ತು dependencies ಗಳ ಹೊಸ versions ಬಿಡುಗಡೆಯಾಗುವಾಗ ಪತ್ತೆಹಚ್ಚುವ automation (ಉದಾ., [Dependabot](https://github.com/dependabot)) ಇಟ್ಟುಕೊಳ್ಳುವ ಮೂಲಕ ಎದುರಿಸಬಹುದು.

CI testing ಇದ್ದರೂ software versions upgrade ಮಾಡುವಾಗ ಸಮಸ್ಯೆಗಳು ಉಂಟಾಗುತ್ತವೆ; ಬಹುಪಾಲು dev ಮತ್ತು prod environments ನಡುವಿನ ಅನಿವಾರ್ಯ ವ್ಯತ್ಯಾಸ ಇದಕ್ಕೆ ಕಾರಣ.
ಅಂತಹ ಸಂದರ್ಭಗಳಲ್ಲಿ ಉತ್ತಮ ವಿಧಾನವೆಂದರೆ _rollback_ ಯೋಜನೆ ಹೊಂದಿರುವುದು - version upgrade ಹಿಂತೆಗೆದು, ಹಿಂದಿನ known-good version ಮರು-deploy ಮಾಡುವುದು.

# VMs & Containers

ನೀವು ಹೆಚ್ಚು ಸಂಕೀರ್ಣ dependencies ಗಳ ಮೇಲೆ ಅವಲಂಬಿಸತೊಡಗಿದಂತೆ, ನಿಮ್ಮ code dependencies package manager ನ ವ್ಯಾಪ್ತಿಯನ್ನು ಮೀರಿ ಹೋಗುವ ಸಾಧ್ಯತೆ ಹೆಚ್ಚಾಗುತ್ತದೆ.
ಇದಕ್ಕೆ ಸಾಮಾನ್ಯ ಕಾರಣಗಳಲ್ಲಿ ಒಂದು ನಿರ್ದಿಷ್ಟ system libraries ಅಥವಾ hardware drivers ಜೊತೆ ಸಂವಹನ ಮಾಡುವ ಅಗತ್ಯ.
ಉದಾಹರಣೆಗೆ, scientific computing ಮತ್ತು AI ನಲ್ಲಿ programs ಗಳು GPU hardware ಬಳಸಲು ವಿಶೇಷ libraries ಮತ್ತು drivers ಅಗತ್ಯಪಡುತ್ತವೆ.
ಅನೇಕ system-level dependencies (GPU drivers, ನಿರ್ದಿಷ್ಟ compiler versions, OpenSSL ನಂತಹ shared libraries) ಇನ್ನೂ system-wide installation ಅಗತ್ಯಪಡಿಸುತ್ತವೆ.

ಪಾರಂಪರಿಕವಾಗಿ ಈ ವಿಶಾಲ dependency ಸಮಸ್ಯೆಯನ್ನು Virtual Machines (VMs) ಮೂಲಕ ಪರಿಹರಿಸಲಾಗುತ್ತಿತ್ತು.
VM ಗಳು ಸಂಪೂರ್ಣ ಕಂಪ್ಯೂಟರ್ ಅನ್ನು abstract ಮಾಡಿ, ತನ್ನದೇ dedicated operating system ಹೊಂದಿರುವ ಸಂಪೂರ್ಣ isolated environment ಒದಗಿಸುತ್ತವೆ.
ಹೆಚ್ಚು ಆಧುನಿಕ ವಿಧಾನವೆಂದರೆ containers, ಇವು application ಜೊತೆಗೆ ಅದರ dependencies, libraries, ಮತ್ತು filesystem ಅನ್ನು package ಮಾಡುತ್ತವೆ; ಆದರೆ ಸಂಪೂರ್ಣ ಕಂಪ್ಯೂಟರ್ virtualize ಮಾಡುವ ಬದಲು host ನ operating system kernel ಹಂಚಿಕೊಳ್ಳುತ್ತವೆ.
Containers, kernel ಹಂಚಿಕೊಳ್ಳುವುದರಿಂದ, VMs ಗಿಂತ lightweight ಆಗಿದ್ದು ಆರಂಭಿಸಲು ವೇಗವಾಗಿಯೂ ಚಲಾಯಿಸಲು ಪರಿಣಾಮಕಾರಿಯಾಗಿಯೂ ಇರುತ್ತವೆ.

ಅತ್ಯಂತ ಜನಪ್ರಿಯ container platform ಎಂದರೆ [Docker](https://www.docker.com/). Docker containers build, distribute, ಮತ್ತು run ಮಾಡಲು standardized ವಿಧಾನವನ್ನು ಪರಿಚಯಿಸಿತು. ಒಳಭಾಗದಲ್ಲಿ Docker ತನ್ನ container runtime ಆಗಿ containerd ಬಳಸುತ್ತದೆ - Kubernetes ನಂತಹ ಇತರೆ tools ಕೂಡ ಬಳಸುವ industry standard ಇದು.

Container ಓಡಿಸುವುದು ಸರಳ. ಉದಾಹರಣೆಗೆ container ಒಳಗೆ Python interpreter ಓಡಿಸಲು `docker run` ಬಳಸುತ್ತೇವೆ (ಇಲ್ಲಿನ `-it` flags container ಅನ್ನು terminal ಜೊತೆ interactive ಆಗಿ ಮಾಡುತ್ತವೆ. ನೀವು ಹೊರಬಂದಾಗ container ನಿಲ್ಲುತ್ತದೆ.).

```console
$ docker run -it python:3.12 python
Python 3.12.7 (main, Nov  5 2024, 02:53:25) [GCC 12.2.0] on linux
>>> print("Hello from inside a container!")
Hello from inside a container!
```

ಪ್ರಾಯೋಗಿಕವಾಗಿ ನಿಮ್ಮ program ಸಂಪೂರ್ಣ filesystem ಮೇಲೇ ಅವಲಂಬಿತವಾಗಿರಬಹುದು.
ಇದನ್ನು ನಿಭಾಯಿಸಲು, application ನ ಸಂಪೂರ್ಣ filesystem ಅನ್ನು artifact ಆಗಿ ಶಿಪ್ ಮಾಡುವ container images ಬಳಸಬಹುದು.
Container images ಅನ್ನು programmatically ರಚಿಸಲಾಗುತ್ತದೆ. Docker ನಲ್ಲಿ image ಗೆ ಬೇಕಾದ dependencies, system libraries, ಮತ್ತು configuration ಅನ್ನು Dockerfile syntax ಮೂಲಕ ನಿಖರವಾಗಿ ಸೂಚಿಸುತ್ತೇವೆ:

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

ಒಂದು ಪ್ರಮುಖ ವ್ಯತ್ಯಾಸ: Docker **image** packaged artifact (template ನಂತಹುದು), ಆದರೆ **container** ಆ image ನ running instance. ಒಂದೇ image ನಿಂದ ಅನೇಕ containers ಓಡಿಸಬಹುದು. Images ಪದರಗಳಲ್ಲಿ build ಆಗುತ್ತವೆ; Dockerfile ನ ಪ್ರತಿಯೊಂದು instruction (`FROM`, `RUN`, `COPY`, ಇತ್ಯಾದಿ) ಹೊಸ layer ರಚಿಸುತ್ತದೆ. Docker ಈ layers ಅನ್ನು cache ಮಾಡುತ್ತದೆ; ಆದ್ದರಿಂದ Dockerfile ನಲ್ಲಿ ಒಂದು line ಬದಲಾದರೆ, ಆ layer ಮತ್ತು ಅದರ ನಂತರದ layers ಮಾತ್ರ rebuild ಆಗಬೇಕು.

ಹಿಂದಿನ Dockerfile ನಲ್ಲಿ ಹಲವು ದೋಷಗಳಿವೆ: ಇದು slim variant ಬದಲಿಗೆ full Python image ಬಳಸುತ್ತದೆ, ಅನಗತ್ಯ layers ಉಂಟುಮಾಡುವಂತೆ ಪ್ರತ್ಯೇಕ `RUN` commands ಬಳಸುತ್ತದೆ, versions pin ಆಗಿಲ್ಲ, package manager caches ಶುದ್ಧೀಕರಿಸಲಾಗಿಲ್ಲ, ಹೀಗಾಗಿ ಅನಗತ್ಯ files ship ಆಗುತ್ತವೆ. ಸಾಮಾನ್ಯವಾಗಿ ಕಾಣುವ ಇತರೆ ತಪ್ಪುಗಳಲ್ಲಿ containers ಅನ್ನು ಅಸುರಕ್ಷಿತವಾಗಿ root ಆಗಿ ಓಡಿಸುವುದು ಮತ್ತು layers ನಲ್ಲಿ ಅನಾಹುತವಾಗಿ secrets ಸೇರಿಸುವುದೂ ಸೇರಿವೆ.

ಇಲ್ಲಿ ಸುಧಾರಿತ version ಇದೆ

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

ಹಿಂದಿನ ಉದಾಹರಣೆಯಲ್ಲಿ `uv` ಅನ್ನು source ನಿಂದ install ಮಾಡುವ ಬದಲಾಗಿ `ghcr.io/astral-sh/uv:latest` image ನಿಂದ prebuilt binary ನಕಲಿಸುತ್ತಿದ್ದೇವೆ. ಇದನ್ನು _builder_ pattern ಎನ್ನುತ್ತಾರೆ. ಈ pattern ಮೂಲಕ code compile ಮಾಡಲು ಬೇಕಾದ tools ಎಲ್ಲವನ್ನೂ ship ಮಾಡುವ ಅಗತ್ಯವಿಲ್ಲ; application ಓಡಿಸಲು ಬೇಕಾದ ಅಂತಿಮ binary (`uv` ಈ ಸಂದರ್ಭದಲ್ಲ) ಮಾತ್ರ ಸಾಕಾಗುತ್ತದೆ.

Docker ಗೆ ಗಮನಿಸಬೇಕಾದ ಕೆಲವು ಮುಖ್ಯ ಮಿತಿಗಳು ಇವೆ. ಮೊದಲನೆಯದಾಗಿ, container images ಬಹಳ ಬಾರಿ platform-specific ಆಗಿರುತ್ತವೆ - `linux/amd64` ಗಾಗಿ build ಮಾಡಿದ image, emulation ಇಲ್ಲದೆ `linux/arm64` (Apple Silicon Macs) ನಲ್ಲಿ native ಆಗಿ ಓಡುವುದಿಲ್ಲ; emulation ನಿಧಾನ. ಎರಡನೆಯದಾಗಿ, Docker containers ಗೆ Linux kernel ಅಗತ್ಯವಿರುವುದರಿಂದ macOS ಮತ್ತು Windows ನಲ್ಲಿ Docker ವಾಸ್ತವವಾಗಿ ಒಳಗೆ lightweight Linux VM ಓಡಿಸುತ್ತದೆ, ಇದರಿಂದ overhead ಸೇರುತ್ತದೆ. ಮೂರನೆಯದಾಗಿ, Docker isolation VMs ಗಿಂತ ದುರ್ಬಲ - containers host kernel ಹಂಚಿಕೊಳ್ಳುತ್ತವೆ; multi-tenant environments ಗಳಲ್ಲಿ ಇದು security ಚಿಂತೆ.

> ಇತ್ತೀಚೆಗೆ, ಇನ್ನೂ ಹೆಚ್ಚು projects [nix flakes](https://serokell.io/blog/practical-nix-flakes) ಮೂಲಕ project-ಪ್ರತಿ "system-wide" libraries ಮತ್ತು applications ಗಳನ್ನೂ ನಿರ್ವಹಿಸಲು nix ಬಳಸುತ್ತಿವೆ.

# Configuration

Software ಸ್ವಭಾವತಃ configurable ಆಗಿದೆ. [command line environment](/2026/command-line-environment/) ಉಪನ್ಯಾಸದಲ್ಲಿ flags, environment variables ಅಥವಾ configuration files (a.k.a. dotfiles) ಮೂಲಕ programs options ಸ್ವೀಕರಿಸುವುದನ್ನು ನೋಡಿದ್ದೇವೆ. ಇದೇ ತತ್ವ ಹೆಚ್ಚು ಸಂಕೀರ್ಣ applications ಗಳಿಗೂ ಅನ್ವಯಿಸುತ್ತದೆ, ಮತ್ತು scale ನಲ್ಲಿ configuration ನಿರ್ವಹಣೆಗೆ ಸ್ಥಿರವಾದ patterns ಇವೆ.
Software configuration code ನಲ್ಲಿ hardcode ಆಗಿರಬಾರದು; runtime ನಲ್ಲಿ ಒದಗಿಸಬೇಕು.
ಸಾಮಾನ್ಯ ವಿಧಾನಗಳಲ್ಲಿ environment variables ಮತ್ತು config files ಪ್ರಮುಖ.

Environment variables ಮೂಲಕ configure ಆಗುವ application ಉದಾಹರಣೆ ಇಲ್ಲಿದೆ:

```python
import os

DATABASE_URL = os.environ.get("DATABASE_URL", "sqlite:///local.db")
DEBUG = os.environ.get("DEBUG", "false").lower() == "true"
API_KEY = os.environ["API_KEY"]  # Required - will raise if not set
```

Configuration file ಮೂಲಕವೂ application configure ಮಾಡಬಹುದು (ಉದಾ., `yaml.load` ಮೂಲಕ config load ಮಾಡುವ Python program), `config.yaml`:

```yaml
database:
  url: "postgresql://localhost/myapp"
  pool_size: 5
server:
  host: "0.0.0.0"
  port: 8080
  debug: false
```

Configuration ಬಗ್ಗೆ ಯೋಚಿಸಲು ಉತ್ತಮ right-hand rule ಎಂದರೆ: ಒಂದೇ codebase ಅನ್ನು ವಿಭಿನ್ನ environments (development, staging, production) ಗೆ deploy ಮಾಡಬಹುದಾಗಿರಬೇಕು; ಬದಲಾಗುವುದು configuration ಮಾತ್ರ, code ಎಂದಿಗೂ ಅಲ್ಲ.

ಬಹು configuration ಆಯ್ಕೆಗಳಲ್ಲಿ API keys ಮುಂತಾದ sensitive data ಸಾಮಾನ್ಯವಾಗಿ ಇರುತ್ತವೆ.
Secrets ಅನ್ನು ಅಪರಾಧಪ್ರಾಯವಾಗಿ ಬಯಲಾಗದಂತೆ ಜಾಗ್ರತೆಯಿಂದ ನಿರ್ವಹಿಸಬೇಕು; ಮತ್ತು ಅವನ್ನು version control ನಲ್ಲಿ ಎಂದಿಗೂ ಸೇರಿಸಬಾರದು.


# Services & Orchestration

ಆಧುನಿಕ applications ಅಪರೂಪವಾಗಿ ಒಂಟಿಯಾಗಿಯೇ ಇರುತ್ತವೆ. ಒಂದು ಸಾಮಾನ್ಯ web application ಗೆ persistent storage ಗಾಗಿ database, performance ಗಾಗಿ cache, background tasks ಗಾಗಿ message queue, ಮತ್ತು ಇತರ supporting services ಅಗತ್ಯವಿರಬಹುದು. ಎಲ್ಲವನ್ನೂ ಒಂದೇ monolithic application ನಲ್ಲಿ ಬಂಧಿಸುವ ಬದಲು, ಆಧುನಿಕ architectures ಸಾಮಾನ್ಯವಾಗಿ functionality ಅನ್ನು ಪ್ರತ್ಯೇಕ services ಗಳಾಗಿ ವಿಭಜಿಸುತ್ತವೆ; ಇವುಗಳನ್ನು ಪ್ರತ್ಯೇಕವಾಗಿ ಅಭಿವೃದ್ಧಿಪಡಿಸಿ, deploy ಮಾಡಿ, scale ಮಾಡಬಹುದು.

ಉದಾಹರಣೆಗೆ, ನಮ್ಮ application ಗೆ cache ಉಪಯುಕ್ತ ಎಂದು ನಿರ್ಧರಿಸಿದರೆ, ನಮ್ಮದೇ ಪರಿಹಾರ ನಿರ್ಮಿಸುವ ಬದಲು [Redis](https://redis.io/) ಅಥವಾ [Memcached](https://memcached.org/) ನಂತಹ battle tested ಪರಿಹಾರಗಳನ್ನು ಬಳಸಬಹುದು.
Redis ಅನ್ನು container ಭಾಗವಾಗಿ build ಮಾಡಿ ನಮ್ಮ application dependencies ಒಳಗೆ ಸೇರಿಸಬಹುದಾದರೂ, Redis ಮತ್ತು application ನಡುವಿನ ಎಲ್ಲಾ dependencies harmonize ಮಾಡಬೇಕಾಗುತ್ತದೆ; ಅದು ಸವಾಲಾಗಬಹುದು ಅಥವಾ ಅಸಾಧ್ಯವೂ ಆಗಬಹುದು.
ಬದಲಾಗಿ, ಪ್ರತಿ application ಅನ್ನು ಅದರದೇ container ನಲ್ಲಿ ಪ್ರತ್ಯೇಕವಾಗಿ deploy ಮಾಡಬಹುದು.
ಇದನ್ನು ಸಾಮಾನ್ಯವಾಗಿ microservice architecture ಎಂದು ಕರೆಯುತ್ತಾರೆ; ಇಲ್ಲಿ ಪ್ರತಿ component ಒಂದು ಸ್ವತಂತ್ರ service ಆಗಿ ಓಡಿ, ಸಾಮಾನ್ಯವಾಗಿ HTTP APIs ಮೂಲಕ network ಮೇಲೆ ಸಂವಹನ ಮಾಡುತ್ತದೆ.

[Docker Compose](https://docs.docker.com/compose/) multi-container applications ನಿರ್ಧರಿಸಿ ಓಡಿಸಲು ಉಪಯುಕ್ತ tool ಆಗಿದೆ. Containers ಅನ್ನು ಪ್ರತ್ಯೇಕವಾಗಿ ನಿರ್ವಹಿಸುವ ಬದಲಾಗಿ, ನೀವು ಎಲ್ಲ services ಗಳನ್ನು ಒಂದೇ YAML file ನಲ್ಲಿ ಘೋಷಿಸಿ ಅವನ್ನು ಒಟ್ಟಿಗೆ orchestrate ಮಾಡುತ್ತೀರಿ. ಈಗ ನಮ್ಮ ಸಂಪೂರ್ಣ application ಒಂದಕ್ಕಿಂತ ಹೆಚ್ಚು container ಒಳಗೊಂಡಿದೆ:

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

`docker compose up` ಮೂಲಕ ಎರಡೂ services ಒಟ್ಟಿಗೆ ಪ್ರಾರಂಭಗೊಳ್ಳುತ್ತವೆ; web application `cache` hostname ಬಳಸಿ Redis ಗೆ ಸಂಪರ್ಕಿಸಬಹುದು (Docker ನ internal DNS service names ಅನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ resolve ಮಾಡುತ್ತದೆ).
Docker Compose ಮೂಲಕ ಒಂದು ಅಥವಾ ಹೆಚ್ಚು services ಅನ್ನು ಹೇಗೆ deploy ಮಾಡಬೇಕು ಎಂದು ಘೋಷಿಸಬಹುದು; ಜೊತೆಗೆ ಅವನ್ನು ಒಟ್ಟಿಗೆ ಆರಂಭಿಸುವುದು, networking ಹೊಂದಿಸುವುದು, ಮತ್ತು data persistence ಗಾಗಿ shared volumes ನಿರ್ವಹಿಸುವ orchestration ನ್ನೂ ಇದು ನೋಡಿಕೊಳ್ಳುತ್ತದೆ.

Production deployments ಗಾಗಿ, docker compose services boot ಸಮಯದಲ್ಲೇ ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಆರಂಭವಾಗಿ failure ಆಗಿದರೆ ಮರುಪ್ರಾರಂಭಗೊಳ್ಳಬೇಕು ಎಂದು ನೀವು ಬಯಸಬಹುದು. ಸಾಮಾನ್ಯ ವಿಧಾನವೆಂದರೆ docker compose deployment ಅನ್ನು systemd ಮೂಲಕ ನಿರ್ವಹಿಸುವುದು:

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

ಈ systemd unit file ನಿಮ್ಮ application ಅನ್ನು system boot ಆಗುವಾಗ (Docker ಸಿದ್ಧವಾದ ನಂತರ) ಪ್ರಾರಂಭವಾಗುವಂತೆ ಖಚಿತಪಡಿಸುತ್ತದೆ; ಜೊತೆಗೆ `systemctl start myapp`, `systemctl stop myapp`, ಮತ್ತು `systemctl status myapp` ನಂತಹ standard controls ಒದಗಿಸುತ್ತದೆ.

Deployment ಅಗತ್ಯಗಳು ಇನ್ನಷ್ಟು ಸಂಕೀರ್ಣವಾದಂತೆ - ಅನೇಕ ಯಂತ್ರಗಳಾಚೆ scalability, services crash ಆದಾಗ fault tolerance, ಮತ್ತು high availability guarantees ಅಗತ್ಯವಿರುವ ಸಂದರ್ಭಗಳಲ್ಲಿ - ಸಂಸ್ಥೆಗಳು Kubernetes (k8s) ನಂತಹ ಉನ್ನತ ಮಟ್ಟದ container orchestration platforms ಕಡೆ ತಿರುಗುತ್ತವೆ; ಇವು machines ಗಳ clusters ಅಳೆಯಲ್ಲೂ ಸಾವಿರಾರು containers ನಿರ್ವಹಿಸಬಲ್ಲವು. ಆದಾಗ್ಯೂ Kubernetes ಗೆ ಕಲಿಕೆಯ ತೀವ್ರ ವಕ್ರತೆ ಹಾಗೂ ಗಮನಾರ್ಹ operational overhead ಇರುವುದರಿಂದ, ಸಣ್ಣ projects ಗಾಗಿ ಇದು ಅನೇಕ ಬಾರಿ ಅತಿಯಾಗುತ್ತದೆ.

ಈ multi-container setup ಭಾಗಶಃ ಸಾಧ್ಯವಾಗಿರುವುದು, ಆಧುನಿಕ services ಪರಸ್ಪರ standardized APIs ಮೂಲಕ - ಮುಖ್ಯವಾಗಿ HTTP REST APIs ಮೂಲಕ - ಸಂವಹನ ಮಾಡುವುದರಿಂದ. ಉದಾಹರಣೆಗೆ, program ಒಂದು OpenAI ಅಥವಾ Anthropic ನಂತಹ LLM provider ಜೊತೆ ಸಂವಹನಿಸಿದಾಗ, ಒಳಗೆ ಅದು ಅವರ servers ಗೆ HTTP request ಕಳುಹಿಸಿ response parse ಮಾಡುತ್ತದೆ:

```console
$ curl https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "content-type: application/json" \
    -H "anthropic-version: 2023-06-01" \
    -d '{"model": "claude-sonnet-4-20250514", "max_tokens": 256,
         "messages": [{"role": "user", "content": "Explain containers vs VMs in one sentence."}]}'
```

# Publishing

ನಿಮ್ಮ code ಸರಿಯಾಗಿ ಕಾರ್ಯನಿರ್ವಹಿಸುತ್ತದೆ ಎಂದು ತೋರಿಸಿದ ನಂತರ, ಅದನ್ನು ಇತರರು download ಮಾಡಿ install ಮಾಡಲು ಹಂಚಬೇಕೆಂಬ ಆಸಕ್ತಿ ಮೂಡಬಹುದು.
Distribution ಹಲವು ರೂಪಗಳನ್ನು ಹೊಂದಿದ್ದು, ಅದು ನಿಮ್ಮ programming language ಹಾಗೂ ನೀವು ಕಾರ್ಯನಿರ್ವಹಿಸುವ environments ಜೊತೆಗೆ ಆಂತರಿಕವಾಗಿ ಸಂಬಂಧಿಸಿದೆ.

Distribution ನ ಸರಳ ರೂಪವೆಂದರೆ ಜನರು download ಮಾಡಿ ಸ್ಥಳೀಯವಾಗಿ install ಮಾಡಲು artifacts ಅಪ್‌ಲೋಡ್ ಮಾಡುವುದು.
ಇದು ಇನ್ನೂ ಸಾಮಾನ್ಯವಾಗಿದೆ; ಉದಾಹರಣೆಗೆ [Ubuntu's package archive](http://archive.ubuntu.com/ubuntu/pool/main/) ನಲ್ಲಿ ಕಾಣಬಹುದು, ಅದು ಮೂಲತಃ `.deb` files ಗಳ HTTP directory listing ಆಗಿದೆ.

ಇತ್ತೀಚಿನ ದಿನಗಳಲ್ಲಿ source code ಮತ್ತು artifacts publish ಮಾಡಲು GitHub de facto platform ಆಗಿದೆ.
Source code ಬಹುಶಃ ಸಾರ್ವಜನಿಕವಾಗಿದ್ದರೂ, GitHub Releases maintainers ಗೆ tagged versions ಗೆ prebuilt binaries ಮತ್ತು ಇತರೆ artifacts ಸೇರಿಸಲು ಅವಕಾಶ ನೀಡುತ್ತದೆ.


Package managers ಕೆಲವೊಮ್ಮೆ GitHub ನಿಂದ ನೇರವಾಗಿ install ಮಾಡಲು support ಮಾಡುತ್ತವೆ - source ನಿಂದಲೂ, pre-built wheel ನಿಂದಲೂ:

```console
# Install from source (will clone and build)
$ pip install git+https://github.com/psf/requests.git

# Install from a specific tag/branch
$ pip install git+https://github.com/psf/requests.git@v2.32.3

# Install a wheel directly from a GitHub release
$ pip install https://github.com/user/repo/releases/download/v1.0/package-1.0-py3-none-any.whl
```

ವಾಸ್ತವವಾಗಿ Go ನಂತಹ ಕೆಲವು languages decentralized distribution model ಬಳಸುತ್ತವೆ - central package repository ಬದಲಿಗೆ, Go modules ನೇರವಾಗಿ source code repositories ಗಳಿಂದ ಹಂಚಲಾಗುತ್ತವೆ.
`github.com/gorilla/mux` ನಂತಹ module paths code ಎಲ್ಲಿದೆ ಎಂಬುದನ್ನು ಸೂಚಿಸುತ್ತವೆ; `go get` ಅಲ್ಲಿಂದಲೇ fetch ಮಾಡುತ್ತದೆ. ಆದರೆ `pip`, `cargo`, ಅಥವಾ `brew` ಮುಂತಾದ ಬಹುತೇಕ package managers distribution ಮತ್ತು installation ಸುಗಮಗೊಳಿಸಲು pre-packaged projects ಗಳ central indexes ಹೊಂದಿವೆ. ನಾವು ಹೀಗೆ ಚಾಲನೆ ಮಾಡಿದರೆ

```console
$ uv pip install requests --verbose --no-cache 2>&1 | grep -F '.whl'
DEBUG Selecting: requests==2.32.5 [compatible] (requests-2.32.5-py3-none-any.whl)
DEBUG No cache entry for: https://files.pythonhosted.org/packages/1e/db/4254e3eabe8020b458f1a747140d32277ec7a271daf1d235b70dc0b4e6e3/requests-2.32.5-py3-none-any.whl.metadata
DEBUG No cache entry for: https://files.pythonhosted.org/packages/1e/db/4254e3eabe8020b458f1a747140d32277ec7a271daf1d235b70dc0b4e6e3/requests-2.32.5-py3-none-any.whl
```

`requests` wheel ಅನ್ನು ನಾವು ಎಲ್ಲಿಂದ fetch ಮಾಡುತ್ತಿದ್ದೇವೆ ಎಂಬುದು ಗೋಚರಿಸುತ್ತದೆ. filename ನಲ್ಲಿರುವ `py3-none-any` ಗಮನಿಸಿ - ಇದರ ಅರ್ಥ ಆ wheel ಯಾವುದೇ Python 3 version, ಯಾವುದೇ OS, ಯಾವುದೇ architecture ನಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತದೆ. Compiled code ಇರುವ packages ಗಾಗಿ wheel platform-specific ಆಗಿರುತ್ತದೆ:

```console
$ uv pip install numpy --verbose --no-cache 2>&1 | grep -F '.whl'
DEBUG Selecting: numpy==2.2.1 [compatible] (numpy-2.2.1-cp312-cp312-macosx_14_0_arm64.whl)
```

ಇಲ್ಲಿ `cp312-cp312-macosx_14_0_arm64` ಎಂದರೆ ಈ wheel CPython 3.12, macOS 14+, ARM64 (Apple Silicon) ಗಾಗಿ ವಿಶೇಷವಾಗಿ ಸಿದ್ಧಪಡಿಸಲಾಗಿದೆ. ನೀವು ಬೇರೆ platform ನಲ್ಲಿ ಇದ್ದರೆ `pip` ಬೇರೆ wheel download ಮಾಡುತ್ತದೆ ಅಥವಾ source ನಿಂದ build ಮಾಡುತ್ತದೆ.

ಇನ್ನೊಂದೆಡೆ, ನಾವು ಸೃಷ್ಟಿಸಿದ package ಇತರರಿಗೆ ದೊರೆಯಲು ಅದನ್ನು ಈ registries ಗಳಲ್ಲಿ ಒಂದಕ್ಕೆ publish ಮಾಡಬೇಕು.
Python ನಲ್ಲಿ ಮುಖ್ಯ registry [Python Package Index (PyPI)](https://pypi.org) ಆಗಿದೆ.
Install ಮಾಡುವಂತೆಯೇ, packages publish ಮಾಡಲು ಅನೇಕ ವಿಧಾನಗಳಿವೆ. `uv publish` command, packages ಅನ್ನು PyPI ಗೆ upload ಮಾಡಲು ಆಧುನಿಕ interface ಒದಗಿಸುತ್ತದೆ:

```console
$ uv publish --publish-url https://test.pypi.org/legacy/
Publishing greeting-0.1.0.tar.gz
Publishing greeting-0.1.0-py3-none-any.whl
```

ಇಲ್ಲಿ ನಾವು [TestPyPI](https://test.pypi.org) ಬಳಸುತ್ತಿದ್ದೇವೆ - ಇದು ನಿಜವಾದ PyPI ಯನ್ನು ಅಶುದ್ಧಗೊಳಿಸದೆ ನಿಮ್ಮ publishing workflow ಪರೀಕ್ಷಿಸಲು ಉದ್ದೇಶಿತ ಪ್ರತ್ಯೇಕ package registry. Upload ಆದ ನಂತರ, ನೀವು TestPyPI ಯಿಂದ install ಮಾಡಬಹುದು:

```console
$ uv pip install --index-url https://test.pypi.org/simple/ greeting
```

Software publish ಮಾಡುವಾಗ trust ಪ್ರಮುಖ ಪ್ರಶ್ನೆಯಾಗುತ್ತದೆ. ಬಳಕೆದಾರರು download ಮಾಡುವ package ನಿಜವಾಗಿ ನಿಮ್ಮಿಂದ ಬಂದಿದೆಯೇ ಮತ್ತು tamper ಆಗಿಲ್ಲವೇ ಎಂಬುದನ್ನು ಹೇಗೆ ಖಚಿತಪಡಿಸಿಕೊಳ್ಳುವುದು? Package registries integrity ಪರಿಶೀಲಿಸಲು checksums ಬಳಸುತ್ತವೆ; ಕೆಲವು ecosystems authorship ಗೆ cryptographic proof ಒದಗಿಸಲು package signing support ಮಾಡುತ್ತವೆ.

ವಿಭಿನ್ನ languages ಗಳಿಗೆ ಸ್ವಂತ package registries ಇವೆ: Rust ಗಾಗಿ [crates.io](https://crates.io), JavaScript ಗಾಗಿ [npm](https://www.npmjs.com), Ruby ಗಾಗಿ [RubyGems](https://rubygems.org), ಮತ್ತು container images ಗಾಗಿ [Docker Hub](https://hub.docker.com). ಮತ್ತೊಂದೆಡೆ private ಅಥವಾ internal packages ಗಾಗಿ ಸಂಸ್ಥೆಗಳು ತಮ್ಮದೇ package repositories (ಉದಾ., private PyPI server ಅಥವಾ private Docker registry) deploy ಮಾಡಬಹುದು, ಅಥವಾ cloud providers ನ managed solutions ಬಳಸಬಹುದು.

Web service ಅನ್ನು internet ಗೆ deploy ಮಾಡಲು ಹೆಚ್ಚುವರಿ infrastructure ಅಗತ್ಯ: domain name registration, ನಿಮ್ಮ domain ಅನ್ನು server ಕಡೆ point ಮಾಡಲು DNS configuration, ಮತ್ತು ಬಹಳ ಬಾರಿ HTTPS ನಿರ್ವಹಿಸಿ traffic route ಮಾಡಲು nginx ನಂತಹ reverse proxy. documentation ಅಥವಾ static sites ನಂತಹ ಸರಳ ಬಳಕೆ ಸಂದರ್ಭಗಳಿಗೆ [GitHub Pages](https://pages.github.com/) repository ನಿಂದ ನೇರವಾಗಿ ಉಚಿತ hosting ಒದಗಿಸುತ್ತದೆ.

<!--
## Documentation

ಇಲ್ಲಿಯವರೆಗೆ ನಾವು packaging ಮತ್ತು shipping code ನ ಮುಖ್ಯ output ಆಗಿ deliverable _artifact_ ಮೇಲೆ ಒತ್ತಡ ನೀಡಿದ್ದೇವೆ.
Artifact ಜೊತೆಗೆ, code ನ functionality, installation ಸೂಚನೆಗಳು, ಮತ್ತು usage ಉದಾಹರಣೆಗಳನ್ನು ಬಳಕೆದಾರರಿಗೆ documentation ರೂಪದಲ್ಲಿ ನೀಡಬೇಕಾಗುತ್ತದೆ.

[Sphinx](https://www.sphinx-doc.org/) (Python) ಮತ್ತು [MkDocs](https://www.mkdocs.org/) ನಂತಹ tools docstrings ಮತ್ತು markdown files ನಿಂದ browsable documentation ಅನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ರಚಿಸಬಹುದು; ಇದನ್ನು ಸಾಮಾನ್ಯವಾಗಿ [Read the Docs](https://readthedocs.org/) ನಂತಹ ಸೇವೆಗಳಲ್ಲಿ host ಮಾಡಲಾಗುತ್ತದೆ.
HTTP ಆಧಾರಿತ APIs ಗಾಗಿ [OpenAPI specification](https://www.openapis.org/) (ಹಿಂದೆ Swagger) API endpoints ವಿವರಿಸಲು ಒಂದು ಮಾನದಂಡಿತ ರೂಪ ಒದಗಿಸುತ್ತದೆ; ಇದನ್ನು tools ಬಳಸಿ interactive documentation ಮತ್ತು client libraries ಅನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ರಚಿಸಬಹುದು. -->


# Exercises

1. `printenv` ಬಳಸಿ ನಿಮ್ಮ environment ಅನ್ನು file ಗೆ ಉಳಿಸಿ, venv ರಚಿಸಿ, activate ಮಾಡಿ, ಮತ್ತೊಂದು file ಗೆ `printenv` ಉಳಿಸಿ, ಮತ್ತು `diff before.txt after.txt` ಚಾಲನೆ ಮಾಡಿ. Environment ನಲ್ಲಿ ಏನು ಬದಲಾಯಿತು? shell ಯಾಕೆ venv ಗೆ ಆದ್ಯತೆ ನೀಡುತ್ತದೆ? (ಸುಳಿವು: activation ಮೊದಲು ಮತ್ತು ನಂತರ `$PATH` ನೋಡಿ.) `which deactivate` ಚಾಲನೆ ಮಾಡಿ, deactivate bash function ಏನು ಮಾಡುತ್ತಿದೆ ಎಂದು ವಿಶ್ಲೇಷಿಸಿ.
1. `pyproject.toml` ಹೊಂದಿರುವ Python package ರಚಿಸಿ, ಅದನ್ನು virtual environment ನಲ್ಲಿ install ಮಾಡಿ. lockfile ರಚಿಸಿ ಮತ್ತು ಅದನ್ನು ಪರಿಶೀಲಿಸಿ.
1. Docker install ಮಾಡಿ ಮತ್ತು docker compose ಬಳಸಿ Missing Semester class website ಅನ್ನು ಸ್ಥಳೀಯವಾಗಿ build ಮಾಡಿ.
1. ಸರಳ Python application ಗಾಗಿ Dockerfile ಬರೆಯಿರಿ. ನಂತರ ನಿಮ್ಮ application ಜೊತೆಗೆ Redis cache ಓಡಿಸುವ `docker-compose.yml` ಬರೆಯಿರಿ.
1. Python package ಅನ್ನು TestPyPI ಗೆ publish ಮಾಡಿ (ಹಂಚಿಕೊಳ್ಳುವ ಮೌಲ್ಯವಿದ್ದಾಗ ಮಾತ್ರ ನಿಜವಾದ PyPI ಗೆ publish ಮಾಡಿ). ನಂತರ ಆ package ಒಳಗೊಂಡ Docker image build ಮಾಡಿ ಮತ್ತು ಅದನ್ನು `ghcr.io` ಗೆ push ಮಾಡಿ.
1. [GitHub Pages](https://docs.github.com/en/pages/quickstart) ಬಳಸಿ website ನಿರ್ಮಿಸಿ. Extra (non-)credit: ಅದನ್ನು custom domain ಜೊತೆಗೆ configure ಮಾಡಿ.
