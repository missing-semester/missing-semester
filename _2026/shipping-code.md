---
layout: lecture
title: "Packaging and Shipping Code"
description: >
  ပရောဂျက် ထုပ်ပိုးခြင်း (packaging)၊ ပတ်ဝန်းကျင်များ (environments)၊ ဗားရှင်းသတ်မှတ်ခြင်း (versioning)၊ နှင့် လိုင်ဘရီများ၊ အပလီကေးရှင်းများ၊ ဝန်ဆောင်မှုများကို တပ်ဆင်ဖြန့်ဖြူးခြင်း (deploying) တို့အကြောင်း လေ့လာပါ။
thumbnail: /static/assets/thumbnails/2026/lec6.png
date: 2026-01-20
ready: true
video:
  aspect: 56.25
  id: KBMiB-8P4Ns
---

ကုဒ်တစ်ခုကို ရည်ရွယ်ချက်အတိုင်း အလုပ်လုပ်အောင် ရေးသားရန် ခက်ခဲပါသည်፤ ထိုကုဒ်ကိုပင် မိမိစက်နှင့် မတူသော အခြားစက်တစ်ခုပေါ်တွင် အလုပ်လုပ်အောင် ပြုလုပ်ရန်မှာ ပို၍ပင် ခက်ခဲလေ့ရှိပါသည်။

ကုဒ်များကို Shipping ပြုလုပ်ခြင်း (ဖြန့်ဖြူးထုတ်လုပ်ခြင်း) ဆိုသည်မှာ သင်ရေးသားထားသော ကုဒ်ကို မိမိကွန်ပျူတာ၏ တိကျသော Setup မလိုဘဲ အခြားသူတစ်ဦးဦးက အလွယ်တကူ Run နိုင်သော အသုံးပြုနိုင်သည့် ပုံစံသို့ ပြောင်းလဲပေးခြင်း ဖြစ်ပါသည်။
ကုဒ်များကို Shipping ပြုလုပ်ရာတွင် ပုံစံအမျိုးမျိုး ရှိနိုင်ပြီး Programming language၊ System library များ၊ Operating system စသည့် အချက်အလက်များစွာပေါ်တွင် မူတည်ပါသည်။
၎င်းသည် သင်တည်ဆောက်နေသည့် အရာပေါ်တွင်လည်း မူတည်ပါသည်—Software library တစ်ခု၊ Command line tool တစ်ခု၊ သို့မဟုတ် Web service တစ်ခု စသည်တို့တွင် လိုအပ်ချက်များနှင့် Deployment အဆင့်များ အသီးသီး ကွဲပြားကြပါသည်။
မည်သို့ပင်ဖြစ်စေ၊ ဤအခြေအနေအားလုံးတွင် ဘုံတူညီသော ပုံစံတစ်ခု ရှိပါသည်—၎င်းမှာ ပေးအပ်ရမည့် အရာ (deliverable) သို့မဟုတ် _artifact_ ဆိုသည်မှာ ဘာလဲဆိုသည်ကို သတ်မှတ်ရန်နှင့် ၎င်းသည် ၎င်း၏ ပတ်ဝန်းကျင် (environment) ပေါ်တွင် မည်သည့် ယူဆချက်များ ထားရှိသည်ဆိုသည်ကို သတ်မှတ်ပေးရန် လိုအပ်ခြင်း ဖြစ်ပါသည်။

ဤသင်ခန်းစာတွင် အောက်ပါတို့အကြောင်း လွှမ်းခြုံဆွေးနွေးသွားပါမည်-

- [မှီခိုမှုများနှင့် ပတ်ဝန်းကျင်များ (Dependencies & Environments)](#dependencies--environments)
- [Artifact များနှင့် ထုပ်ပိုးခြင်း (Artifacts & Packaging)](#artifacts--packaging)
- [ထုတ်လုပ်မှုများနှင့် ဗားရှင်းသတ်မှတ်ခြင်း (Releases & Versioning)](#releases--versioning)
- [ထပ်မံဖန်တီးနိုင်စွမ်း (Reproducibility)](#reproducibility)
- [VM များနှင့် Containers များ (VMs & Containers)](#vms--containers)
- [စနစ်ပြင်ဆင်မှု (Configuration)](#configuration)
- [ဝန်ဆောင်မှုများနှင့် စီမံခန့်ခွဲမှု (Services & Orchestration)](#services--orchestration)
- [ထုတ်ဝေခြင်း (Publishing)](#publishing)

ပိုမိုနားလည်လွယ်ကူစေရန်အတွက် လက်တွေ့ကျသော ဥပမာများဖြစ်သည့် Python ecosystem ထဲမှ ဥပမာများဖြင့် ဤသဘောတရားများကို ရှင်းပြသွားပါမည်။ အခြား programming language ecosystem များအတွက် tool များ ကွဲပြားနိုင်သော်လည်း သဘောတရားအများစုမှာ အတူတူပင် ဖြစ်ပါသည်။

# Dependencies & Environments

ခေတ်သစ် ဆော့ဖ်ဝဲလ် ဖွံ့ဖြိုးတိုးတက်မှုတွင် အဆင့်ဆင့် သီးခြားခွဲထုတ်ထားသော အလွှာများ (layers of abstraction) သည် နေရာတိုင်းတွင် ရှိနေပါသည်။
ပရိုဂရမ်များသည် အခြားလိုင်ဘရီများ သို့မဟုတ် ဝန်ဆောင်မှုများထံသို့ လုပ်ဆောင်ချက်များကို သဘာဝအတိုင်း လွှဲပြောင်းလုပ်ဆောင်လေ့ ရှိကြပါသည်။
သို့သော် ၎င်းသည် သင်၏ ပရိုဂရမ်နှင့် အလုပ်လုပ်ရန် လိုအပ်သော လိုင်ဘရီများအကြား _မှီခိုမှု (dependency)_ ဆက်ဆံရေးတစ်ခုကို ပေါ်ပေါက်စေပါသည်။
ဥပမာအားဖြင့် Python တွင် ဝဘ်ဆိုက်တစ်ခု၏ အကြောင်းအရာကို ဆွဲယူရန်အတွက် ကျွန်ုပ်တို့သည် အောက်ပါအတိုင်း ပြုလုပ်လေ့ရှိကြသည်-

```python
import requests

response = requests.get("https://missing.csail.mit.edu")
```

သို့သော် `requests` လိုင်ဘရီသည် Python runtime နှင့်အတူ တစ်ပါတည်း ပါဝင်မလာပါ၊ ထို့ကြောင့် `requests` ကို Install မလုပ်ဘဲ ဤကုဒ်ကို Run ရန် ကြိုးပမ်းပါက Python သည် Error ပြသပါလိမ့်မည်-

```console
$ python fetch.py
Traceback (most recent call last):
  File "fetch.py", line 1, in <module>
    import requests
ModuleNotFoundError: No module named 'requests'
```

ဤလိုင်ဘရီကို အသုံးပြုနိုင်ရန်အတွက် ကျွန်ုပ်တို့သည် ၎င်းကို install ပြုလုပ်ရန် ပထမဦးစွာ `pip install requests` ကို Run ရန် လိုအပ်ပါသည်။
`pip` ဆိုသည်မှာ Package များကို install ပြုလုပ်ရန်အတွက် Python programming language က ပံ့ပိုးပေးထားသော command line tool ဖြစ်ပါသည်။
`pip install requests` ကို စတင်ပတ်မောင်းလိုက်ပါက အောက်ပါ အဆင့်အတန်းအတိုင်း ဆက်တိုက် လုပ်ဆောင်သွားပါသည်-

1. Python Package Index ([PyPI](https://pypi.org/)) တွင် requests ကို ရှာဖွေခြင်း
1. ကျွန်ုပ်တို့ အသုံးပြုနေသော platform အတွက် သင့်လျော်သော artifact ကို ရှာဖွေခြင်း
1. မှီခိုမှုများကို ဖြေရှင်းခြင်း (Resolve dependencies) --- `requests` လိုင်ဘရီကိုယ်တိုင်ကလည်း အခြား package များကို မှီခိုနေသဖြင့် installer သည် ဆက်စပ်မှီခိုနေသော (transitive dependencies) package များ၏ ကိုက်ညီသော ဗားရှင်းအားလုံးကို ရှာဖွေပြီး မတိုင်မီ ကြိုတင် install လုပ်ပေးရပါမည်
1. Artifact များကို Download ပြုလုပ်ပြီးနောက် ဖိုင်များကို ကျွန်ုပ်တို့၏ filesystem အတွင်းရှိ မှန်ကန်သော နေရာများသို့ ဖြေညှိ၍ ကူးယူထည့်သွင်းခြင်း

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

ဤနေရာတွင် `requests` ၌ `certifi` သို့မဟုတ် `charset-normalizer` ကဲ့သို့သော မိမိကိုယ်ပိုင် dependency များ ရှိနေပြီး `requests` ကို install မပြုလုပ်မီ ၎င်းတို့ကို အရင် install လုပ်ရမည်ကို တွေ့မြင်နိုင်ပါသည်။
Install လုပ်ပြီးသွားပါက Python runtime သည် import ပြုလုပ်သည့်အခါ ဤလိုင်ဘရီကို ရှာဖွေတွေ့ရှိနိုင်ပြီ ဖြစ်ပါသည်။

```console
$ python -c 'import requests; print(requests.__path__)'
['/usr/local/lib/python3.11/dist-packages/requests']

$ pip list | grep requests
requests        2.32.3
```

Programming languages များတွင် လိုင်ဘရီများကို install ပြုလုပ်ခြင်းနှင့် ထုတ်ဝေခြင်း (publishing) တို့အတွက် မတူညီသော tool များ၊ စံနှုန်းများနှင့် အလေ့အထများ ရှိကြပါသည်။
Rust ကဲ့သို့သော အချို့ language များတွင် toolchain ကို တစ်ခုတည်းအဖြစ် ပေါင်းစည်းထားပါသည်—`cargo` က ထုတ်လုပ်ခြင်း (building)၊ စမ်းသပ်ခြင်း (testing)၊ dependency စီမံခန့်ခွဲခြင်း နှင့် ထုတ်ဝေခြင်းတို့အားလုံးကို ကိုင်တွယ်ပေးပါသည်။
Python ကဲ့သို့သော အခြား language များတွင်မူ ပေါင်းစည်းမှုသည် စံသတ်မှတ်ချက်အဆင့် (specification level) တွင် ဖြစ်ပေါ်ပါသည်—tool တစ်ခုတည်း မဟုတ်ဘဲ packaging မည်သို့ အလုပ်လုပ်သည်ကို သတ်မှတ်ပေးသည့် စံသတ်မှတ်ချက်များ ရှိနေသဖြင့် အလုပ်တစ်ခုစီအတွက် ယှဉ်ပြိုင်နေသော tool အများအပြားကို အသုံးပြုနိုင်စေပါသည် (`pip` သို့မဟုတ် [`uv`](https://docs.astral.sh/uv/)၊ `setuptools` သို့မဟုတ် [`hatch`](https://hatch.pypa.io/) သို့မဟုတ် [`poetry`](https://python-poetry.org/) စသည်ဖြင့်)။
LaTeX ကဲ့သို့သော အချို့ ecosystem များတွင်မူ TeX Live သို့မဟုတ် MacTeX ကဲ့သို့သော distribution များတွင် package ထောင်ပေါင်းများစွာကို ကြိုတင် install ပြုလုပ်၍ တစ်ပါတည်း ထည့်သွင်းပေးထားပါသည်။

Dependency များကို စတင်အသုံးပြုလာသည်နှင့်အမျှ Dependency ပဋိပက္ခများ (dependency conflicts) လည်း ပေါ်ပေါက်လာပါသည်။
ပရိုဂရမ်များသည် တူညီသော dependency ၏ ကိုက်ညီမှုမရှိသော ဗားရှင်းများကို တောင်းဆိုသည့်အခါ ပဋိပက္ခများ ဖြစ်ပေါ်တတ်ပါသည်။
ဥပမာအားဖြင့် `tensorflow==2.3.0` က `numpy>=1.16.0,<1.19.0` ကို လိုအပ်ပြီး `pandas==1.2.0` က `numpy>=1.16.5` ကို လိုအပ်ပါက `numpy>=1.16.5,<1.19.0` ကို ပြည့်မီသော မည်သည့်ဗားရှင်းမဆို ကိုက်ညီမည် ဖြစ်ပါသည်။
သို့သော် သင့်ပရောဂျက်ရှိ အခြား package တစ်ခုက `numpy>=1.19` ကို လိုအပ်နေပါက ကန့်သတ်ချက်အားလုံးကို ပြည့်မီသည့် ကိုက်ညီသော ဗားရှင်းမရှိတော့သဖြင့် ပဋိပက္ခ ဖြစ်ပေါ်လာမည် ဖြစ်ပါသည်။

package အများအပြားက မျှဝေသုံးစွဲထားသော dependency များ၏ အပြန်အလှန် ကိုက်ညီမှုမရှိသော ဗားရှင်းများကို တောင်းဆိုနေသည့် ဤအခြေအနေကို လေ့ရှိသောအားဖြင့် _dependency hell_ ဟု ခေါ်ဆိုကြပါသည်။
ပဋိပက္ခများကို ကိုင်တွယ်ဖြေရှင်းနည်း တစ်ခုမှာ ပရိုဂရမ်တစ်ခုစီ၏ dependency များကို ၎င်းတို့၏ သီးခြား _environment_ အတွင်းသို့ ခွဲထုတ်ထားခြင်း (isolate) ဖြစ်ပါသည်။
Python တွင် ကျွန်ုပ်တို့သည် အောက်ပါအတိုင်း Run ခြင်းဖြင့် virtual environment တစ်ခုကို ဖန်တီးပါသည်-

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

Environment တစ်ခုကို မိမိကိုယ်ပိုင် install လုပ်ထားသော package များ ပါဝင်သည့် သီးခြား ရပ်တည်နေသော language runtime တစ်ခုလုံးအဖြစ် တွေးတောနိုင်ပါသည်။
ဤ virtual environment သို့မဟုတ် venv သည် install လုပ်ထားသော dependency များကို မူလ global Python installation မှ ခွဲထုတ်ပေးပါသည်။
ပရောဂျက်တစ်ခုစီအတွက် လိုအပ်သော dependency များကို သီးခြားထည့်သွင်းထားသည့် virtual environment တစ်ခု စီထားရှိခြင်းသည် ကောင်းမွန်သော အလေ့အထတစ်ခု ဖြစ်ပါသည်။

> ခေတ်သစ် operating system အများအပြားတွင် Python ကဲ့သို့သော programming language runtime များကို တစ်ပါတည်း ထည့်သွင်းပေးထားသော်လည်း OS ကိုယ်တိုင်က ယင်းတို့၏ လုပ်ဆောင်ချက်များအတွက် ၎င်းတို့ကို အားကိုးနေရနိုင်သဖြင့် ထို မူလ installation များကို ပြင်ဆင်ခြင်း မပြုသင့်ပါ။ ထို့အစား သီးခြား environment များကို အသုံးပြုခြင်းကို ပိုမို ဦးစားပေးပါ။

အချို့သော language များတွင် installation protocol ကို tool တစ်ခုဖြင့် သတ်မှတ်ထားခြင်း မဟုတ်ဘဲ စံသတ်မှတ်ချက် (specification) အဖြစ် သတ်မှတ်ထားပါသည်။
Python တွင် [PEP 517](https://peps.python.org/pep-0517/) က build system interface ကို သတ်မှတ်ပေးပြီး [PEP 621](https://peps.python.org/pep-0621/) က ပရောဂျက်၏ metadata များကို `pyproject.toml` တွင် မည်သို့ သိမ်းဆည်းရမည်ကို ဖော်ပြထားပါသည်။
၎င်းသည် developer များအား `pip` ထက် ပိုမို ကောင်းမွန်လာစေရန်နှင့် `uv` ကဲ့သို့ ပိုမို ပေါ့ပါးမြန်ဆန်သော tool များကို ဖန်တီးနိုင်စေရန် အထောက်အကူပြုခဲ့ပါသည်။ `uv` ကို install လုပ်ရန်အတွက် `pip install uv` ဟု လုပ်ဆောင်ရုံမျှဖြင့် လုံလောက်ပါသည်။

`pip` အစား `uv` ကို အသုံးပြုခြင်းသည် interface တူညီသော်လည်း သိသိသာသာ ပိုမို မြန်ဆန်ပါသည်-

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

> Install လုပ်သည့် အချိန်ကို အလွန်အမင်း လျှော့ချပေးနိုင်သောကြောင့် ဖြစ်နိုင်ပါက `pip` အစား `uv pip` ကို အသုံးပြုရန် အလွန် အကြံပြုအပ်ပါသည်။

Dependency များကို ခွဲထုတ်ပေးသည့်အပြင် Environment များသည် သင်၏ programming language runtime ၏ မတူညီသော ဗားရှင်းများကို သုံးနိုင်စေရန်လည်း ဆောင်ရွက်ပေးနိုင်ပါသည်။

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

မိမိ၏ ကုဒ်ကို Python ဗားရှင်း အများအပြားတွင် စမ်းသပ်ရန် လိုအပ်သည့်အခါ သို့မဟုတ် ပရောဂျက်တစ်ခုက တိကျသော ဗားရှင်းတစ်ခု လိုအပ်သည့်အခါ ဤအရာက အကူအညီဖြစ်စေပါသည်။

> အချို့သော programming language များတွင် ပရောဂျက်တစ်ခုစီသည် မိမိကိုယ်တိုင် ကိုယ်တိုင်ကိုယ်ကျ ဖန်တီးစရာ မလိုဘဲ ၎င်း၏ dependency များအတွက် environment တစ်ခုကို အလိုအလျောက် ရရှိကြသော်လည်း မူဝါဒမှာ အတူတူပင် ဖြစ်ပါသည်။ ယနေ့ခေတ် language အများစုတွင် စနစ်တစ်ခုတည်း၌ language ဗားရှင်း အများအပြားကို စီမံခန့်ခွဲနိုင်သည့် စနစ် ပါရှိကြပြီး ပရောဂျက်တစ်ခုစီအတွက် မည်သည့် ဗားရှင်းကို အသုံးပြုရမည်ဆိုသည်ကို သတ်မှတ်ပေးနိုင်ပါသည်။

# Artifacts & Packaging

ဆော့ဖ်ဝဲလ် ဖွံ့ဖြိုးတိုးတက်မှုတွင် ကျွန်ုပ်တို့သည် မူရင်းကုဒ် (source code) နှင့် artifact များကို ခြားနားစွာ သတ်မှတ်ကြပါသည်။ Developer များသည် source code များကို ရေးသားကြပြီး ဖတ်ရှုကြသည်၊ artifact များမှာမူ ထို source code မှ ထုတ်လုပ်ထားသော၊ ထုပ်ပိုးထားသည့်၊ ဖြန့်ဖြူးနိုင်သော ရလဒ်များဖြစ်ပြီး install လုပ်ရန် သို့မဟုတ် deploy လုပ်ရန် အသင့်ဖြစ်နေသော အရာများ ဖြစ်ကြပါသည်။
Artifact တစ်ခုသည် ကျွန်ုပ်တို့ Run သော ကုဒ်ဖိုင်တစ်ခုကဲ့သို့ ရိုးရှင်းနိုင်သကဲ့သို့ အပလီကေးရှင်းတစ်ခု၏ လိုအပ်သော အစိတ်အပိုင်းအားလုံး ပါဝင်သည့် Virtual Machine တစ်ခုလုံးကဲ့သို့ ရှုပ်ထွေးနိုင်ပါသည်။
ကျွန်ုပ်တို့၏ လက်ရှိ directory တွင် Python ဖိုင် `greet.py` ရှိသည့် ဤဥပမာကို ကြည့်ပါ-

```console
$ cat greet.py
def greet(name):
    print(f"Hello, {name}!")

$ python -c "from greet import greet; greet('World')"
Hello, World!

$ cd /tmp
$ python -c "from greet import greet; greet('World')"
ModuleNotFoundError: No module named 'greet'
```

အခြား directory တစ်ခုသို့ ပြောင်းရွှေ့လိုက်သည်နှင့် import လုပ်ခြင်း မအောင်မြင်တော့ပါ၊ အကြောင်းမှာ Python သည် သတ်မှတ်ထားသော နေရာများတွင်သာ module များကို ရှာဖွေသောကြောင့် ဖြစ်ပါသည် (လက်ရှိ directory၊ install လုပ်ထားသော package များ၊ နှင့် `PYTHONPATH` တွင် ပါဝင်သည့် လမ်းကြောင်းများ)။ Packaging သည် ကုဒ်ကို သိရှိပြီးသား နေရာတစ်ခုသို့ install ပြုလုပ်ပေးခြင်းဖြင့် ဤပြဿနာကို ဖြေရှင်းပေးပါသည်။

Python တွင် လိုင်ဘရီတစ်ခုကို packaging ပြုလုပ်ရာ၌ `pip` သို့မဟုတ် `uv` ကဲ့သို့သော package installer များက သက်ဆိုင်ရာ ဖိုင်များကို install လုပ်ရာတွင် အသုံးပြုနိုင်သည့် artifact တစ်ခုကို ထုတ်လုပ်ပေးခြင်း ပါဝင်ပါသည်။
Python artifact များကို _wheels_ ဟု ခေါ်ဆိုပြီး package တစ်ခုကို install ရန် လိုအပ်သော အချက်အလက်များ အားလုံး ပါဝင်ပါသည်- ကုဒ်ဖိုင်များ၊ package ဆိုင်ရာ metadata များ (အမည်၊ ဗားရှင်း၊ dependency များ)၊ နှင့် environment ထဲရှိ မည်သည့်နေရာတွင် ဖိုင်များ ထည့်သွင်းရမည်ဆိုသည့် ညွှန်ကြားချက်များ။
Artifact တစ်ခုကို Build ပြုလုပ်ရန်အတွက် ပရောဂျက်၏ အသေးစိတ်အချက်အလက်များ၊ လိုအပ်သော dependency များ၊ package ၏ ဗားရှင်း နှင့် အခြား အချက်အလက်များကို ဖော်ပြထားသည့် project file တစ်ခု (manifest ဟုလည်း ခေါ်လေ့ရှိသည်) ရေးသားရန် လိုအပ်ပါသည်။ Python တွင် ဤရည်ရွယ်ချက်အတွက် `pyproject.toml` ကို အသုံးပြုကြပါသည်။

> `pyproject.toml` သည် ခေတ်သစ် နည်းလမ်းဖြစ်ပြီး အကြံပြုထားသော နည်းလမ်းဖြစ်ပါသည်။ `requirements.txt` သို့မဟုတ် `setup.py` ကဲ့သို့သော ယခင် packaging နည်းလမ်းများကို ထောက်ပံ့ပေးနေဆဲ ဖြစ်သော်လည်း ဖြစ်နိုင်လျှင် `pyproject.toml` ကို ဦးစားပေး အသုံးပြုသင့်ပါသည်။

အောက်တွင် Command-line tool တစ်ခုကိုလည်း ပံ့ပိုးပေးထားသည့် လိုင်ဘရီတစ်ခုအတွက် အနည်းဆုံး လိုအပ်သော `pyproject.toml` ဖိုင် ဥပမာ ဖြစ်ပါသည်-

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

`typer` လိုင်ဘရီသည် သာမန် boilerplate များစွာ ရေးစရာ မလိုဘဲ command-line interface များကို ဖန်တီးရန်အတွက် လူကြိုက်များသော Python package တစ်ခု ဖြစ်ပါသည်။

၎င်းနှင့် သက်ဆိုင်သည့် `greeting.py` ဖိုင်မှာ အောက်ပါအတိုင်း ဖြစ်ပါသည်-

```python
import typer


def greet(name: str) -> None:
    print(f"Hello, {name}!")


def cli() -> None:
    typer.run(greet)


if __name__ == "__main__":
    cli()
```

ဤဖိုင်ဖြင့် ယခုအခါ ကျွန်ုပ်တို့သည် wheel ကို build ပြုလုပ်နိုင်ပြီ ဖြစ်ပါသည်-

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

`.whl` ဖိုင်သည် wheel (သတ်မှတ်ထားသော တည်ဆောက်ပုံပါရှိသည့် zip archive) ဖြစ်ပြီး၊ `.tar.gz` မှာမူ မူရင်း source ထံမှ build ပြုလုပ်ရန် လိုအပ်သည့် စနစ်များအတွက် source distribution ဖိုင် ဖြစ်ပါသည်။

မည်သည့်အရာများ ထုပ်ပိုးသွားသည်ကို ကြည့်ရှုရန် wheel ၏ အကြောင်းအရာများကို စစ်ဆေးနိုင်ပါသည်။

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

ယခုအခါ ဤ wheel ကို အခြားသူတစ်ဦးထံ ပေးလိုက်ပါက ၎င်းတို့သည် အောက်ပါအတိုင်း Run ၍ install ပြုလုပ်နိုင်ပါသည်-

```console
$ uv pip install ./greeting-0.1.0-py3-none-any.whl
$ greet Alice
Hello, Alice!
```

၎င်းသည် အစောပိုင်းက ကျွန်ုပ်တို့ build ပြုလုပ်ခဲ့သော လိုင်ဘရီနှင့် `greet` cli tool အပါအဝင် ၎င်းတို့၏ environment ထဲသို့ install ပြုလုပ်ပေးမည် ဖြစ်ပါသည်။

ဤနည်းလမ်းတွင် ကန့်သတ်ချက်များ ရှိပါသည်။ အထူးသဖြင့် ကျွန်ုပ်တို့၏ လိုင်ဘရီသည် GPU အရှိန်မြှင့်တင်ရန်အတွက် CUDA ကဲ့သို့သော platform အလိုက် သီးခြားဖြစ်သော လိုင်ဘရီများကို မှီခိုနေပါက ကျွန်ုပ်တို့၏ artifact သည် ထိုသီးခြားလိုင်ဘရီများ install လုပ်ထားသည့် စနစ်များတွင်သာ အလုပ်လုပ်မည်ဖြစ်ပြီး၊ မတူညီသော platform များ (Linux, macOS, Windows) နှင့် architecture များ (x86, ARM) အတွက် သီးခြား wheel များကို build ပြုလုပ်ရန် လိုအပ်နိုင်ပါသည်။

ဆော့ဖ်ဝဲလ်များကို install ပြုလုပ်ရာတွင် source မှ install ပြုလုပ်ခြင်းနှင့် ကြိုတင် build လုပ်ထားသော binary (prebuilt binary) မှ install ပြုလုပ်ခြင်းတို့အကြား အရေးကြီးသော ခြားနားချက် ရှိပါသည်။ Source မှ install ပြုလုပ်ခြင်း ဆိုသည်မှာ မူရင်းကုဒ်ကို Download ပြုလုပ်ပြီး မိမိစက်ပေါ်တွင် compile ပြုလုပ်ခြင်းကို ဆိုလိုပါသည်—၎င်းသည် မိမိစက်တွင် compiler နှင့် build tool များ ရှိနေရန် လိုအပ်ပြီး၊ ပရောဂျက်ကြီးများအတွက် အချိန်အတော်အတန် ယူရနိုင်ပါသည်။

Prebuilt binary ကို install ပြုလုပ်ခြင်းဆိုသည်မှာ အခြားသူတစ်ဦးက compile လုပ်ပြီးသား artifact ကို Download ပြုလုပ်ခြင်း ဖြစ်ပါသည်—ပိုမို မြန်ဆန်ပြီး ရိုးရှင်းသော်လည်း binary သည် သင့်စက်၏ platform နှင့် architecture တို့နှင့် ကိုက်ညီရပါမည်။
ဥပမာအားဖြင့် [ripgrep ၏ releases စာမျက်နှာ](https://github.com/BurntSushi/ripgrep/releases) တွင် Linux (x86_64, ARM)၊ macOS (Intel, Apple Silicon)၊ နှင့် Windows တို့အတွက် prebuilt binary များကို ပြသထားပါသည်။

# Releases & Versioning

ကုဒ်များကို အစဉ်အမြဲ ဆက်တိုက် တည်ဆောက်နေကြသော်လည်း ရလဒ်များ (releases) ကိုမူ သီးခြား အချိန်ကာလအလိုက် ထုတ်ဝေကြပါသည်။
ဆော့ဖ်ဝဲလ် ဖွံ့ဖြိုးတိုးတက်မှုတွင် ဖွံ့ဖြိုးတိုးတက်ရေး environment (development environment) နှင့် ထုတ်လုပ်ရေး environment (production environment) တို့အကြား ရှင်းလင်းသော ခြားနားချက် ရှိပါသည်။
ကုဒ်ကို prod စက်များထံသို့ _shipped_ မပြုလုပ်မီ dev environment တွင် အလုပ်လုပ်ကြောင်း သက်သေပြရန် လိုအပ်ပါသည်။
Release ပြုလုပ်သည့် လုပ်ငန်းစဉ်တွင် စမ်းသပ်ခြင်း၊ dependency စီမံခန့်ခွဲခြင်း၊ ဗားရှင်းသတ်မှတ်ခြင်း၊ configuration စနစ်ပြင်ဆင်ခြင်း၊ deployment ပြုလုပ်ခြင်း နှင့် ထုတ်ဝေခြင်း အပါအဝင် အဆင့်များစွာ ပါဝင်ပါသည်။

Software library များသည် တည်ငြိမ်၍ ရပ်တန့်မနေဘဲ အမှားပြင်ဆင်ချက်များနှင့် လုပ်ဆောင်ချက်အသစ်များ ရရှိလာသည်နှင့်အမျှ အချိန်နှင့်အမျှ တိုးတက်ပြောင်းလဲလာကြပါသည်။
အချိန်ကာလတစ်ခုရှိ လိုင်ဘရီ၏ အခြေအနေနှင့် ကိုက်ညီသော သီးခြား ဗားရှင်း အမှတ်အသားများဖြင့် ဤတိုးတက်ပြောင်းလဲမှုကို ကျွန်ုပ်တို့ စောင့်ကြည့်မှတ်တမ်းတင်ကြပါသည်။
လိုင်ဘရီတစ်ခု၏ မူလလုပ်ဆောင်ချက် ပြောင်းလဲမှုများသည် အရေးမကြီးသော လုပ်ဆောင်ချက်များကို ပြင်ဆင်သည့် patch များ၊ လုပ်ဆောင်ချက်များကို တိုးချဲ့ပေးသည့် feature အသစ်များ မှသည် နောက်ပြန်ဆုတ်မရသော ပြောင်းလဲမှုများ (breaking backwards compatibility) အထိ ရှိနိုင်ပါသည်။
Changelog များသည် ဗားရှင်းတစ်ခုက မည်သည့် ပြောင်းလဲမှုများကို မိတ်ဆက်ပေးသည်ဆိုသည်ကို မှတ်တမ်းတင်ထားပါသည်—ဤသည်မှာ သတင်းလွှာပုံစံဖြင့် ထုတ်ဝေမှုအသစ်နှင့် သက်ဆိုင်သည့် ပြောင်းလဲမှုများကို ဆက်သွယ်အကြောင်းကြားရန် ဆော့ဖ်ဝဲလ် developer များ အသုံးပြုသည့် Documentation များ ဖြစ်ကြပါသည်။

သို့သော် dependency တိုင်းရှိ ပြောင်းလဲမှုများကို အမြဲမပြတ် စောင့်ကြည့်မှတ်တမ်းတင်နေရန်မှာ လက်တွေ့မကျပါ၊ ကျွန်ုပ်တို့၏ dependency များ၏ dependency များဖြစ်သည့် transitive dependency များကို ထည့်သွင်းစဉ်းစားသည့်အခါ ပို၍ပင် ခက်ခဲပါလိမ့်မည်။

> သင့်ပရောဂျက်၏ dependency သစ်ပင်တစ်ခုလုံးကို package အားလုံးနှင့် ၎င်းတို့၏ transitive dependency များကို သစ်ပင်ပုံစံဖြင့် ပြသပေးသည့် `uv tree` ဖြင့် မြင်တွေ့နိုင်ပါသည်။

ဤပြဿနာကို ရိုးရှင်းစေရန်အတွက် ဆော့ဖ်ဝဲလ် ဗားရှင်း သတ်မှတ်နည်းဆိုင်ရာ စံနှုန်းများ ရှိကြပြီး၊ အထင်ရှားဆုံး တစ်ခုမှာ [Semantic Versioning](https://semver.org/) သို့မဟုတ် SemVer ဖြစ်ပါသည်။
Semantic Versioning အောက်တွင် ဗားရှင်းတစ်ခု၌ အကိန်းပြည့် တန်ဖိုးတစ်ခုစီ ယူသော MAJOR.MINOR.PATCH ပုံစံပါရှိသည့် အမှတ်အသားတစ်ခု ရှိပါသည်။ အတိုချုပ်အားဖြင့် အဆင့်မြှင့်တင်ရာတွင်-

- PATCH (ဥပမာ- 1.2.3 → 1.2.4) တွင် အမှားပြင်ဆင်ချက်များ (bug fixes) သာ ပါဝင်သင့်ပြီး နောက်ကြောင်းပြန် သဟဇာတ ဖြစ်မှု (backwards compatible) အပြည့်အဝ ရှိရပါမည်
- MINOR (ဥပမာ- 1.2.3 → 1.3.0) သည် နောက်ကြောင်းပြန် သဟဇာတဖြစ်သော နည်းလမ်းဖြင့် လုပ်ဆောင်ချက်အသစ်များကို ထည့်သွင်းပေးပါသည်
- MAJOR (ဥပမာ- 1.2.3 → 2.0.0) သည် ကုဒ်ပြင်ဆင်မှုများ လိုအပ်နိုင်သည့် ဘက်ပေါင်းစုံ ပြောင်းလဲမှုများ (breaking changes) ကို ညွှန်ပြပါသည်

> ဤသည်မှာ အတိုချုပ် ရှင်းပြချက်ဖြစ်ပြီး ဥပမာအားဖြင့် 0.1.3 မှ 0.2.0 သို့ ပြောင်းလဲခြင်းက အဘယ်ကြောင့် breaking change များ ဖြစ်ပေါ်စေနိုင်သည် သို့မဟုတ် 1.0.0-rc.1 က မည်သည့်အဓိပ္ပာယ်ဆောင်သည်ဆိုသည်ကို နားလည်ရန်အတွက် SemVer Specification အပြည့်အစုံကို ဖတ်ရှုရန် တိုက်တွန်းပါသည်။
Python packaging သည် semantic versioning ကို မူလကတည်းက ထောက်ပံ့ပေးထားသဖြင့် ကျွန်ုပ်တို့၏ dependency ဗားရှင်းများကို သတ်မှတ်သည့်အခါ သတ်မှတ်ကန့်သတ်ချက် အမျိုးမျိုးကို အသုံးပြုနိုင်ပါသည်။

`pyproject.toml` ဖိုင်တွင် ကျွန်ုပ်တို့၏ dependency များ၏ ကိုက်ညီသော ဗားရှင်းအပိုင်းအခြားများကို ကန့်သတ်ရန် မတူညီသော နည်းလမ်းများ ရှိကြပါသည်-

```toml
[project]
dependencies = [
    "requests==2.32.3",  # Exact version - ဤသီးခြားဗားရှင်းတစ်ခုတည်းသာ
    "click>=8.0",        # Minimum version - 8.0 သို့မဟုတ် ပိုသစ်သောဗားရှင်း
    "numpy>=1.24,<2.0",  # Range - အနည်းဆုံး 1.24 သို့သော် 2.0 ထက်ငယ်ရမည်
    "pandas~=2.1.0",     # Compatible release - >=2.1.0 နှင့် <2.2.0
]
```

ဗားရှင်း သတ်မှတ်ချက်ကန့်သတ်မှုများ (Version specifiers) သည် မတူညီသော သီးခြားအဓိပ္ပာယ်များဖြင့် package manager အများအပြား (npm, cargo စသည်) တွင် တည်ရှိကြပါသည်။ `~=` operator သည် Python ၏ "compatible release" operator ဖြစ်ပါသည်—`~=2.1.0` ဆိုသည်မှာ "2.1.0 နှင့် ကိုက်ညီမှုရှိသော မည်သည့် ဗားရှင်းမဆို" ဟု အဓိပ္ပာယ်ရပြီး `>=2.1.0` နှင့် `<2.2.0` သို့ ပြောင်းလဲအဓိပ္ပာယ်ထွက်ပါသည်။ ၎င်းသည် npm နှင့် cargo တို့ရှိ SemVer ၏ သဟဇာတဖြစ်မှုဆိုင်ရာ သဘောတရားကို လိုက်နာသည့် caret (`^`) operator နှင့် ကြမ်းဖျင်းအားဖြင့် တူညီပါသည်။

ဆော့ဖ်ဝဲလ် အားလုံးသည် semantic versioning ကို အသုံးပြုကြသည် မဟုတ်ပါ။ အခြား အသုံးများသော နည်းလမ်းတစ်ခုမှာ Calendar Versioning (CalVer) ဖြစ်ပြီး ဗားရှင်းများကို semantic အဓိပ္ပာယ်ထက် ထုတ်ဝေသည့် ရက်စွဲများပေါ်တွင် အခြေခံထားပါသည်။ ဥပမာအားဖြင့် Ubuntu သည် `24.04` (၂၀၂၄ ခုနှစ် ဧပြီလ) နှင့် `24.10` (၂၀၂၄ ခုနှစ် အောက်တိုဘာလ) ကဲ့သို့သော ဗားရှင်းများကို အသုံးပြုပါသည်။ CalVer သည် ကိုက်ညီမှုဆိုင်ရာ အချက်အလက်များကို အသိပေးခြင်း မရှိသော်လည်း ထုတ်ဝေမှုတစ်ခု မည်မျှ ပုံရိပ်ဟောင်းနေပြီဆိုသည်ကို အလွယ်တကူ သိရှိစေပါသည်။ နောက်ဆုံးအနေဖြင့် semantic versioning သည်လည်း အမှားကင်းစင်သည်တော့ မဟုတ်ပါ၊ တစ်ခါတစ်ရံ ပြုပြင်ထိန်းသိမ်းသူများသည် မတော်တဆ minor သို့မဟုတ် patch release များတွင် breaking change များကို မိတ်ဆက်မိတတ်ကြပါသည်။

# ထပ်မံဖန်တီးနိုင်စွမ်း (Reproducibility)

ခေတ်သစ် ဆော့ဖ်ဝဲလ် ဖွံ့ဖြိုးတိုးတက်မှုတွင် သင်ရေးသားသော ကုဒ်သည် သိသာထင်ရှားလှသော အလွှာများစွာ (layers of abstraction) ပေါ်တွင် တည်ရှိနေပါသည်။
၎င်းတို့တွင် သင်၏ programming language runtime၊ ပြင်ပလိုင်ဘရီများ (third party libraries)၊ operating system သို့မဟုတ် hardware ကိုယ်တိုင် ပါဝင်ပါသည်။
ဤအလွှာများအနက် မည်သည့်အလွှာတွင်မဆို ကွဲပြားမှုရှိပါက သင့်ကုဒ်၏ မူလလုပ်ဆောင်ချက်ကို ပြောင်းလဲသွားစေနိုင်သည် သို့မဟုတ် ရည်ရွယ်ထားသည့်အတိုင်း အလုပ်မလုပ်အောင် တားဆီးနိုင်ပါသည်။
ထို့အပြင် အောက်ခံ hardware တွင် ကွဲပြားမှုများ ရှိနေခြင်းကပင် ဆော့ဖ်ဝဲလ်ကို Shipping ပြုလုပ်နိုင်သည့် သင့်စွမ်းရည်ကို သက်ရောက်မှု ရှိစေပါသည်။

လိုင်ဘရီတစ်ခုကို Pinning ပြုလုပ်ခြင်းဆိုသည်မှာ အပိုင်းအခြားတစ်ခု သတ်မှတ်ခြင်း (ဥပမာ `requests>=2.0`) မဟုတ်ဘဲ တိကျသော ဗားရှင်းတစ်ခုကို သတ်မှတ်ပေးခြင်း ဖြစ်ပါသည် (ဥပမာ `requests==2.32.3`)။

Package manager ၏ အလုပ်တစ်ခုမှာ dependency များ နှင့် transitive dependency များက ထောက်ပံ့ပေးထားသော ကန့်သတ်ချက်များအားလုံးကို ထည့်သွင်းစဉ်းစားပြီး ထိုကန့်သတ်ချက်များအားလုံးကို ပြည့်မီစေမည့် ကိုက်ညီသော ဗားရှင်းစာရင်းတစ်ခုကို ထုတ်လုပ်ပေးရန် ဖြစ်ပါသည်။
ထို တိကျသော ဗားရှင်းစာရင်းကို ထပ်မံဖန်တီးနိုင်စွမ်း (reproducibility) ရည်ရွယ်ချက်များအတွက် ဖိုင်တစ်ခုအဖြစ် သိမ်းဆည်းထားနိုင်သည်—ဤဖိုင်များကို _lock files_ ဟု ခေါ်ဆိုကြပါသည်။

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

Dependency ဗားရှင်း သတ်မှတ်ခြင်းနှင့် reproducibility တို့ကို ကိုင်တွယ်ရာတွင် အဓိကကျသော ခြားနားချက်တစ်ခုမှာ လိုင်ဘရီများ နှင့် အပလီကေးရှင်းများ/ဝန်ဆောင်မှုများ (applications/services) အကြား ခြားနားချက် ဖြစ်ပါသည်။
လိုင်ဘရီတစ်ခုကို မိမိကိုယ်ပိုင် dependency များ ရှိကောင်းရှိနိုင်သည့် အခြားကုဒ်များက import ပြုလုပ်၍ အသုံးပြုရန် ရည်ရွယ်ထားသဖြင့် အလွန်အမင်း တင်းကျပ်သော ဗားရှင်းကန့်သတ်ချက်များ သတ်မှတ်ခြင်းသည် သုံးစွဲသူ၏ အခြား dependency များနှင့် ပဋိပက္ခများ ဖြစ်ပေါ်စေနိုင်ပါသည်။
ဆန့်ကျင်ဘက်အားဖြင့် အပလီကေးရှင်းများ သို့မဟုတ် ဝန်ဆောင်မှုများသည် ဆော့ဖ်ဝဲလ်၏ နောက်ဆုံး သုံးစွဲသူများ ဖြစ်ကြပြီး မကြာခဏဆိုသလို ၎င်းတို့၏ လုပ်ဆောင်ချက်များကို programming interface ထက် user interface သို့မဟုတ် API မှတစ်ဆင့် ထုတ်ဖော် ပြသလေ့ရှိကြပါသည်။
လိုင်ဘရီများအတွက် ကျယ်ပြန့်သော package ecosystem နှင့် ကိုက်ညီမှု အများဆုံး ရရှိစေရန် ဗားရှင်း အပိုင်းအခြားများ (version ranges) ကို သတ်မှတ်ခြင်းသည် ကောင်းမွန်သော အလေ့အထ ဖြစ်ပါသည်။ အပလီကေးရှင်းများအတွက်မူ တိကျသော ဗားရှင်းများကို Pinning ပြုလုပ်ခြင်းက reproducibility ကို သေချာစေပါသည်—အပလီကေးရှင်းကို မောင်းနှင်နေသူ တိုင်းသည် တူညီသော တိကျသော dependency များကို အသုံးပြုကြမည် ဖြစ်ပါသည်။

အမြင့်ဆုံး reproducibility လိုအပ်သော ပရောဂျက်များအတွက် [Nix](https://nixos.org/) နှင့် [Bazel](https://bazel.build/) ကဲ့သို့သော tool များသည် _hermetic_ build များကို ပံ့ပိုးပေးပါသည်—ထိုတွင် compiler များ၊ system library များ၊ နှင့် build environment ကိုယ်တိုင်အပါအဝင် input တိုင်းကို pinning ပြုလုပ်ထားပြီး content-addressed ပြုလုပ်ထားပါသည်။ ၎င်းသည် build ကို မည်သည့်အချိန် သို့မဟုတ် မည်သည့်နေရာတွင်မဆို မောင်းနှင်သည်ဖြစ်စေ bit-for-bit အတူတူပင်ဖြစ်သော ရလဒ်များကို အာမခံပေးပါသည်။

> သင့်ကွန်ပျူတာ setup ၏ မိတ္တူအသစ်များကို လွယ်ကူစွာ စတင်နိုင်ရန်နှင့် ၎င်းတို့၏ စနစ်တစ်ခုလုံး ပြင်ဆင်ချက်များကို version-controlled ပြုလုပ်ထားသော configuration ဖိုင်များမှတစ်ဆင့် စီမံခန့်ခွဲနိုင်ရန် သင်၏ ကွန်ပျူတာ installation တစ်ခုလုံးကို စီမံရန်အတွက် NixOS ကိုပင် အသုံးပြုနိုင်ပါသည်။

ဆော့ဖ်ဝဲလ် ဖွံ့ဖြိုးတိုးတက်ရေးတွင် မပြီးဆုံးနိုင်သော တင်းမာမှုတစ်ခုမှာ ဆော့ဖ်ဝဲလ် ဗားရှင်းအသစ်များသည် ရည်ရွယ်ချက်ရှိရှိဖြစ်စေ မရည်ရွယ်ဘဲဖြစ်စေ ပျက်စီးမှုများကို မိတ်ဆက်ပေးလေ့ရှိပြီး၊ အခြားတစ်ဖက်တွင်မူ ဆော့ဖ်ဝဲလ် ဗားရှင်းအဟောင်းများသည် အချိန်နှင့်အမျှ လုံခြုံရေးဆိုင်ရာ အားနည်းချက်များ (security vulnerabilities) ကြုံတွေ့ရလေ့ရှိခြင်း ဖြစ်ပါသည်။
ကျွန်ုပ်တို့သည် ဤအရာကို ဆော့ဖ်ဝဲလ် ဗားရှင်းအသစ်များနှင့် ယှဉ်၍ အပလီကေးရှင်းကို စမ်းသပ်သည့် continuous integration pipeline များ အသုံးပြုခြင်းဖြင့်လည်းကောင်း ([Code Quality and CI](/2026/code-quality/) သင်ခန်းစာတွင် ပိုမို ကြည့်ရှုပါမည်)၊ [Dependabot](https://github.com/dependabot) ကဲ့သို့သော ကျွန်ုပ်တို့၏ dependency များ၏ ဗားရှင်းအသစ်များ ထွက်ရှိလာသည့်အခါ သိရှိနိုင်သည့် အလိုအလျောက် စနစ်များကို ထားရှိခြင်းဖြင့်လည်းကောင်း ဖြေရှင်းနိုင်ပါသည်။

CI စမ်းသပ်မှုများ ထားရှိသော်လည်း ဆော့ဖ်ဝဲလ် ဗားရှင်းများကို အဆင့်မြှင့်တင်သည့်အခါ dev နှင့် prod environment များအကြား ရှောင်လွှဲမရနိုင်သော ကွဲလွဲမှုများကြောင့် ပြဿနာများ ဖြစ်ပေါ်နေဆဲ ဖြစ်ပါသည်။
ထိုသို့သော အခြေအနေများတွင် အကောင်းဆုံး လုပ်ဆောင်ချက်မှာ ဗားရှင်း အဆင့်မြှင့်တင်မှုကို ပြန်လည် ရုပ်သိမ်းပြီး ၎င်းအစား သိရှိပြီးသား ကောင်းမွန်သော ဗားရှင်းကို ပြန်လည် deploy ပြုလုပ်သည့် _rollback_ အစီအစဉ်တစ်ခု ထားရှိခြင်း ဖြစ်ပါသည်။

# VM များနှင့် Containers များ (VMs & Containers)

ပိုမို ရှုပ်ထွေးသော dependency များကို အားကိုးလာသည်နှင့်အမျှ သင့်ကုဒ်၏ dependency များသည် package manager ကိုင်တွယ်နိုင်သည့် နယ်နိမိတ်ထက် ကျော်လွန်သွားနိုင်ခြေ ရှိပါသည်။
အသုံးများသော အကြောင်းအရင်းတစ်ခုမှာ သီးခြား system library များ သို့မဟုတ် hardware driver များနှင့် ချိတ်ဆက် လုပ်ဆောင်ရခြင်း ဖြစ်ပါသည်။
ဥပမာအားဖြင့် သိပ္ပံနည်းကျ တွက်ချက်မှုနှင့် AI တို့တွင် ပရိုဂရမ်များသည် GPU hardware ကို အသုံးပြုနိုင်ရန်အတွက် သီးသန့် လိုင်ဘရီများနှင့် driver များကို မကြာခဏ လိုအပ်ကြပါသည်။
System အဆင့် dependency အများအပြား (GPU driver များ၊ တိကျသော compiler ဗားရှင်းများ၊ OpenSSL ကဲ့သို့သော မျှဝေသုံးစွဲသည့် လိုင်ဘရီများ) သည် စနစ်တစ်ခုလုံးအလိုက် (system-wide) install လုပ်ရန် လိုအပ်နေဆဲ ဖြစ်ပါသည်။

ရှေးယခင်က ဤပိုမိုကျယ်ပြန့်သော dependency ပြဿနာကို Virtual Machines (VMs) များဖြင့် ဖြေရှင်းခဲ့ကြပါသည်။
VM များသည် ကွန်ပျူတာတစ်လုံးလုံးကို abstraction ပြုလုပ်ပြီး မိမိကိုယ်ပိုင် သီးသန့် operating system ပါရှိသော လုံးဝ ခွဲထုတ်ထားသည့် environment တစ်ခုကို ပံ့ပိုးပေးပါသည်။
ပိုမို ခေတ်မီသော နည်းလမ်းမှာ container များ ဖြစ်ကြပြီး၊ ၎င်းတို့သည် ကွန်ပျူတာတစ်လုံးလုံးကို virtualize ပြုလုပ်ခြင်းထက် အပလီကေးရှင်းတစ်ခုကို ၎င်း၏ dependency များ၊ လိုင်ဘရီများ၊ နှင့် filesystem တို့နှင့်အတူ ထုပ်ပိုးထားသော်လည်း host ၏ operating system kernel ကို မျှဝေသုံးစွဲကြပါသည်။
Container များသည် kernel ကို မျှဝေသုံးစွဲသောကြောင့် VM များထက် ပေါ့ပါးပြီး စတင်ရလွယ်ကူကာ မောင်းနှင်ရာတွင် ပိုမို အလုပ်တွင် စွမ်းဆောင်ရည် ကောင်းမွန်ပါသည်။

လူကြိုက်အများဆုံး container platform မှာ [Docker](https://www.docker.com/) ဖြစ်ပါသည်။ Docker သည် container များကို build ပြုလုပ်ခြင်း၊ ဖြန့်ဖြူးခြင်း နှင့် run ခြင်းတို့အတွက် စံသတ်မှတ်ထားသော နည်းလမ်းတစ်ခုကို မိတ်ဆက်ခဲ့ပါသည်။ အတွင်းပိုင်းတွင် Docker သည် containerd ကို ၎င်း၏ container runtime အဖြစ် အသုံးပြုပါသည်—၎င်းသည် Kubernetes ကဲ့သို့သော အခြား tool များပါ အသုံးပြုကြသည့် စက်မှုလုပ်ငန်းဆိုင်ရာ စံနှုန်းတစ်ခု ဖြစ်ပါသည်။

Container တစ်ခုကို run ခြင်းသည် ရိုးရှင်းပါသည်။ ဥပမာအားဖြင့် container တစ်ခုအတွင်း Python interpreter တစ်ခုကို မောင်းနှင်ရန် `docker run` ကို အသုံးပြုကြပါသည် (`-it` flag များသည် container ကို terminal ဖြင့် အပြန်အလှန် တုံ့ပြန်နိုင်စေရန် ပြုလုပ်ပေးပါသည်။ သင်ထွက်လိုက်သည့်အခါ container ရပ်တန့်သွားပါမည်။)။

```console
$ docker run -it python:3.12 python
Python 3.12.7 (main, Nov  5 2024, 02:53:25) [GCC 12.2.0] on linux
>>> print("Hello from inside a container!")
Hello from inside a container!
```

လက်တွေ့တွင် သင့်ပရိုဂရမ်သည် filesystem တစ်ခုလုံးပေါ်တွင် မူတည်နေနိုင်ပါသည်။
ဤအရာကို ကျော်လွှားရန်အတွက် ကျွန်ုပ်တို့သည် အပလီကေးရှင်း၏ filesystem တစ်ခုလုံးကို artifact အဖြစ် Shipping ပြုလုပ်ပေးသည့် container image များကို အသုံးပြုနိုင်ပါသည်။
Container image များကို ပရိုဂရမ်နည်းလမ်းဖြင့် ဖန်တီးကြပါသည်။ Docker ဖြင့် ကျွန်ုပ်တို့သည် Dockerfile syntax ကို အသုံးပြု၍ image ၏ dependency များ၊ system library များ၊ နှင့် configuration များကို တိကျစွာ သတ်မှတ်ပေးကြပါသည်-

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

အရေးကြီးသော ခြားနားချက်တစ်ခုမှာ- Docker **image** ဆိုသည်မှာ ထုပ်ပိုးထားသော artifact (template တစ်ခုကဲ့သို့) ဖြစ်ပြီး၊ **container** မှာမူ ထို image ၏ မောင်းနှင်နေသော instance တစ်ခု ဖြစ်ပါသည်။ Image တစ်ခုတည်းမှ container အများအပြားကို မောင်းနှင်နိုင်ပါသည်။ Image များကို layer များဖြင့် တည်ဆောက်ထားပြီး Dockerfile ထဲရှိ instruction တိုင်း (`FROM`, `RUN`, `COPY` စသည်) က layer အသစ်တစ်ခုကို ဖန်တီးပါသည်။ Docker သည် ဤ layer များကို cache လုပ်ထားသဖြင့် သင့် Dockerfile ထဲရှိ လိုင်းတစ်ခုကို ပြောင်းလဲပါက ထို layer နှင့် နောက်ဆက်တွဲ layer များကိုသာ ပြန်လည် build လုပ်ရန် လိုအပ်ပါလိမ့်မည်။

ယခင် Dockerfile တွင် ပြဿနာအချို့ ရှိပါသည်- ၎င်းသည် slim variant အစား full Python image ကို အသုံးပြုထားသည်၊ လိုအပ်ချက်ထက် ပိုသော layer များကို ဖန်တီးသည့် သီးခြား `RUN` command များကို မောင်းနှင်ထားသည်၊ ဗားရှင်းများကို pinning ပြုလုပ်ထားခြင်း မရှိပါ၊ ထို့အပြင် မလိုအပ်သော ဖိုင်များကို Shipping ပြုလုပ်ပြီး package manager cache များကို ရှင်းလင်းထားခြင်း မရှိပါ။ အခြား ခဏခဏ မှားတတ်သော အမှားများတွင် container များကို root အဖြစ် မလုံမခြုံ မောင်းနှင်ခြင်း နှင့် မတော်တဆ လျှို့ဝှက်ချက်များ (secrets) ကို layer များအတွင်း မြှုပ်နှံမိခြင်းတို့ ပါဝင်ပါသည်။

အောက်တွင် ပိုမိုကောင်းမွန်အောင် ပြုပြင်ထားသော ဗားရှင်းဖြစ်ပါသည်-

```dockerfile
FROM python:3.12-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libpq-dev && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
ENV PATH="/app/.venv/bin:$PATH"
COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-dev --no-install-project
COPY . .
RUN uv sync --locked --no-dev
```

ယခင်ဥပမာတွင် `uv` ကို source မှ install ပြုလုပ်ခြင်းထက် prebuilt binary ကို `ghcr.io/astral-sh/uv:latest` image ထံမှ ကူးယူထားသည်ကို တွေ့ရပါမည်။ ဤအရာကို _builder_ pattern ဟု ခေါ်ဆိုကြပါသည်။ ဤ pattern ဖြင့် ကျွန်ုပ်တို့သည် ကုဒ်ကို compile လုပ်ရန် လိုအပ်သည့် tool များအားလုံးကို Shipping ပြုလုပ်ရန် မလိုဘဲ အပလီကေးရှင်းကို မောင်းနှင်ရန် လိုအပ်သည့် နောက်ဆုံး binary ကိုသာ Shipping ပြုလုပ်ရန် လိုအပ်ပါသည် (ဤနေရာတွင် `uv` ဖြစ်ပါသည်)။

Docker တွင် သတိပြုရမည့် အရေးကြီးသော ကန့်သတ်ချက်များ ရှိပါသည်။ ပထမချက်မှာ container image များသည် မကြာခဏ platform-specific ဖြစ်လေ့ရှိပါသည်—`linux/amd64` အတွက် build ပြုလုပ်ထားသော image သည် နှေးကွေးသော emulation မပါဘဲ `linux/arm64` (Apple Silicon Mac များ) ပေါ်တွင် မူလအတိုင်း အလုပ်လုပ်မည် မဟုတ်ပါ။ ဒုတိယချက်မှာ Docker container များသည် Linux kernel ကို လိုအပ်သဖြင့် macOS နှင့် Windows ပေါ်တွင် Docker သည် နောက်ကွယ်၌ ပေါ့ပါးသော Linux VM တစ်ခုကို မောင်းနှင်ရပြီး overhead ကို တိုးပွားစေပါသည်။ တတိယချက်မှာ Docker ၏ isolation သည် VM များထက် ပိုမို အားနည်းပါသည်—container များသည် host kernel ကို မျှဝေသုံးစွဲကြသဖြင့် multi-tenant environment များတွင် လုံခြုံရေးဆိုင်ရာ စိုးရိမ်စရာ ဖြစ်လာစေပါသည်။

> ယနေ့ခေတ်တွင် ပရောဂျက်အများအပြားသည် [nix flakes](https://serokell.io/blog/practical-nix-flakes) မှတစ်ဆင့် ပရောဂျက်တစ်ခုစီအလိုက် "system-wide" လိုင်ဘရီများနှင့် အပလီကေးရှင်းများကို စီမံခန့်ခွဲရန် nix ကို အသုံးပြုလာကြပါသည်။

# စနစ်ပြင်ဆင်မှု (Configuration)

ဆော့ဖ်ဝဲလ်သည် မူလကတည်းက စနစ်ပြင်ဆင်နိုင်စွမ်း (configurable) ရှိပါသည်။ [Command line environment](/2026/command-line-environment/) သင်ခန်းစာတွင် ပရိုဂရမ်များသည် flag များ၊ environment variable များ သို့မဟုတ် dotfiles ဟုခေါ်သော configuration ဖိုင်များမှတစ်ဆင့် option များကို လက်ခံရရှိသည်ကို ကျွန်ုပ်တို့ တွေ့မြင်ခဲ့ရပါသည်။ ဤသည်မှာ ပိုမို ရှုပ်ထွေးသော အပလီကေးရှင်းများအတွက်ပါ မှန်ကန်ပြီး အတိုင်းအတာကြီးမားသော configuration ကို စီမံခန့်ခွဲရန် ခိုင်မာသော pattern များ ရှိကြပါသည်။
ဆော့ဖ်ဝဲလ် configuration ကို ကုဒ်အတွင်း၌ မြှုပ်နှံမထားသင့်ဘဲ runtime တွင် ပံ့ပိုးပေးသင့်ပါသည်။
အသုံးများသော နည်းလမ်းအချို့မှာ environment variable များနှင့် config ဖိုင်များ ဖြစ်ကြပါသည်။

အောက်ပါတို့မှာ Environment variable များမှတစ်ဆင့် စနစ်ပြင်ဆင်ထားသော အပလီကေးရှင်းတစ်ခု၏ ဥပမာ ဖြစ်ပါသည်-

```python
import os

DATABASE_URL = os.environ.get("DATABASE_URL", "sqlite:///local.db")
DEBUG = os.environ.get("DEBUG", "false").lower() == "true"
API_KEY = os.environ["API_KEY"]  # လိုအပ်သည် - သတ်မှတ်မထားပါက Error တက်မည်
```

အပလီကေးရှင်းတစ်ခုကို စနစ်ပြင်ဆင်မှု ဖိုင်တစ်ဆင့်လည်း စနစ်ပြင်ဆင်နိုင်ပါသည် (ဥပမာ- `yaml.load` မှတစ်ဆင့် config ကို load လုပ်သည့် Python ပရိုဂရမ်)၊ `config.yaml`-

```yaml
database:
  url: "postgresql://localhost/myapp"
  pool_size: 5
server:
  host: "0.0.0.0"
  port: 8080
  debug: false
```

Configuration စနစ်ပြင်ဆင်မှုအကြောင်း စဉ်းစားရာတွင် လက်စွဲလမ်းညွှန်ကောင်းတစ်ခုမှာ ကုဒ်ပြောင်းလဲမှု လုံးဝမပါဘဲ configuration ပြောင်းလဲမှုများဖြင့်သာ တူညီသော codebase ကို မတူညီသော environment များသို့ (development, staging, production) deploy ပြုလုပ်နိုင်ရမည် ဖြစ်ပါသည်။

Configuration စနစ်ပြင်ဆင်မှုများစွာအနက် API key များကဲ့သို့သော အရေးကြီးဒေတာများ (sensitive data) မကြာခဏ ပါဝင်လေ့ရှိပါသည်။
လျှို့ဝှက်ချက်များကို (Secrets) မတော်တဆ ထုတ်ဖော်ပြသမိခြင်းမှ ရှောင်ရှားရန် ဂရုတစိုက် ကိုင်တွယ်ရန် လိုအပ်ပြီး၊ version control အတွင်း၌ ထည့်သွင်းခြင်း မပြုရပါ။

# ဝန်ဆောင်မှုများနှင့် စီမံခန့်ခွဲမှု (Services & Orchestration)

ခေတ်သစ် အပလီကေးရှင်းများသည် သီးခြားခွဲထွက်၍ တည်ရှိလေ့ မရှိကြပါ။ သာမန် web application တစ်ခုသည် ဒေတာများ ရေရှည်သိမ်းဆည်းရန်အတွက် database တစ်ခု၊ စွမ်းဆောင်ရည်အတွက် cache တစ်ခု၊ နောက်ကွယ်မှ task များအတွက် message queue တစ်ခု၊ နှင့် အခြား ထောက်ပံ့ပေးသော ဝန်ဆောင်မှုအမျိုးမျိုးကို လိုအပ်နိုင်ပါသည်။ အရာအားလုံးကို monolithic application တစ်ခုတည်းအဖြစ် စုစည်းထားခြင်းထက် ခေတ်သစ် တည်ဆောက်ပုံများသည် လုပ်ဆောင်ချက်များကို သီးခြားစီ ဖွံ့ဖြိုးတိုးတက်စေနိုင်၊ deploy လုပ်နိုင်၊ နှင့် တိုးချဲ့နိုင်သည့် သီးခြား ဝန်ဆောင်မှုများအဖြစ် မကြာခဏ ခွဲထုတ်လေ့ရှိကြပါသည်။

ဥပမာအားဖြင့် ကျွန်ုပ်တို့၏ အပလီကေးရှင်းသည် cache တစ်ခုကို အသုံးပြုခြင်းဖြင့် အကျိုးကျေးဇူး ရရှိနိုင်သည်ဟု ဆုံးဖြတ်ပါက ကိုယ်ပိုင် ဖန်တီးမည့်အစား [Redis](https://redis.io/) သို့မဟုတ် [Memcached](https://memcached.org/) ကဲ့သို့သော စမ်းသပ်စစ်ဆေးပြီးသား ခိုင်မာသည့် နည်းလမ်းများကို အသုံးပြုနိုင်ပါသည်။
ကျွန်ုပ်တို့သည် Redis ကို container ၏ အစိတ်အပိုင်းအဖြစ် build ပြုလုပ်၍ အပလီကေးရှင်း၏ dependency များအတွင်း မြှုပ်နှံထားနိုင်သော်လည်း၊ ထိုသို့ပြုလုပ်ပါက Redis နှင့် ကျွန်ုပ်တို့၏ အပလီကေးရှင်းအကြား dependency အားလုံးကို ညှိနှိုင်းရမည်ဖြစ်ရာ ခက်ခဲနိုင်သလို မဖြစ်နိုင်သည်အထိ ဖြစ်သွားနိုင်ပါသည်။
ထို့အစား ကျွန်ုပ်တို့ ပြုလုပ်နိုင်သည်မှာ အပလီကေးရှင်းတစ်ခုစီကို ၎င်း၏ သီးခြား container အတွင်း၌ သီးခြားစီ deploy လုပ်ခြင်း ဖြစ်ပါသည်။
ဤအရာကို လေ့ရှိသောအားဖြင့် မူလပါဝင်သည့် အစိတ်အပိုင်းတစ်ခုစီသည် ကွန်ရက်မှတစ်ဆင့် (ပုံမှန်အားဖြင့် HTTP API များမှတစ်ဆင့်) ဆက်သွယ်ပေးသည့် သီးခြား ဝန်ဆောင်မှုအဖြစ် မောင်းနှင်သော microservice architecture ဟု ခေါ်ဆိုကြပါသည်။

[Docker Compose](https://docs.docker.com/compose/) သည် container အများအပြားပါဝင်သော အပလီကေးရှင်းများကို သတ်မှတ်ရန်နှင့် မောင်းနှင်ရန်အတွက် tool တစ်ခု ဖြစ်ပါသည်။ Container များကို သီးခြားစီ စီမံခန့်ခွဲခြင်းထက် ဝန်ဆောင်မှုအားလုံးကို YAML ဖိုင်တစ်ခုတည်းတွင် ကြေညာပြီး ၎င်းတို့ကို အတူတကွ စီမံခန့်ခွဲမောင်းနှင် (orchestrate) နိုင်ပါသည်။ ယခုအခါ ကျွန်ုပ်တို့၏ အပလီကေးရှင်းတစ်ခုလုံးတွင် container တစ်ခုထက်မက ပါဝင်လာပြီ ဖြစ်ပါသည်-

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

`docker compose up` ဖြင့် ဝန်ဆောင်မှု နှစ်ခုစလုံး အတူတကွ စတင်မည်ဖြစ်ပြီး web application သည် hostname `cache` ကို အသုံးပြု၍ Redis ထံသို့ ချိတ်ဆက်နိုင်ပါသည် (Docker ၏ internal DNS က service အမည်များကို အလိုအလျောက် ဖြေရှင်းပေးပါသည်)။
Docker Compose သည် ဝန်ဆောင်မှုတစ်ခု သို့မဟုတ် တစ်ခုထက်မက မည်သို့ deploy ပြုလုပ်လိုသည်ကို ကြေညာစေပြီး၊ ၎င်းတို့ကို အတူတကွ စတင်ခြင်း၊ ၎င်းတို့အကြား networking ပြုလုပ်ပေးခြင်း၊ နှင့် ဒေတာ ရေရှည်တည်တံ့ရေးအတွက် shared volume များကို စီမံခန့်ခွဲခြင်းဆိုင်ရာ orchestration ကို ကိုင်တွယ်ပေးပါသည်။

Production တွင် deploy ပြုလုပ်ရန်အတွက် သင်သည် သင့် docker compose ဝန်ဆောင်မှုများကို စနစ်စတင်သည့်အခါ (boot) အလိုအလျောက် စတင်စေချင်ပြီး ပျက်စီးသွားပါက ပြန်လည် စတင်စေချင်ပါလိမ့်မည်။ အသုံးများသော နည်းလမ်းတစ်ခုမှာ docker compose deployment ကို စီမံခန့်ခွဲရန် systemd ကို အသုံးပြုခြင်း ဖြစ်ပါသည်-

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

ဤ systemd unit ဖိုင်သည် သင့်အပလီကေးရှင်းကို စနစ်စတင်ချိန်တွင် (Docker အသင့်ဖြစ်ပြီးနောက်) စတင်ကြောင်း သေချာစေပြီး `systemctl start myapp`၊ `systemctl stop myapp`၊ နှင့် `systemctl status myapp` ကဲ့သို့သော စံမိုဘိုင်း/စနစ်ထိန်းချုပ်မှုများကို ပံ့ပိုးပေးပါသည်။

Deployment လိုအပ်ချက်များ ပိုမို ရှုပ်ထွေးလာသည်နှင့်အမျှ—စက်အများအပြားတွင် တိုးချဲ့နိုင်စွမ်း (scalability) လိုအပ်ခြင်း၊ ဝန်ဆောင်မှုများ ပျက်စီးသွားသည့်အခါ fault tolerance ရှိခြင်း၊ နှင့် ရရှိနိုင်မှုမြင့်မားသော (high availability) အာမခံချက်များ လိုအပ်ခြင်း—အဖွဲ့အစည်းများသည် စက်စုစည်းမှုများ (clusters) ပေါ်ရှိ container ထောင်ပေါင်းများစွာကို စီမံခန့်ခွဲနိုင်သည့် Kubernetes (k8s) ကဲ့သို့သော ဆန်းသစ်သော container orchestration platform များကို အသုံးပြုလာကြပါသည်။ သို့သော်လည်း Kubernetes တွင် လေ့လာရန် ခက်ခဲသော သင်ယူမှုမျဉ်းဆွဲနှင့် သုံးစွဲရသည့် စက်လည်ပတ်မှု ကုန်ကျစရိတ် သိသာထင်ရှားစွာ ရှိနေသဖြင့် ပရောဂျက်ငယ်များအတွက် လိုအပ်သည်ထက် ပိုလွန်နေတတ်ပါသည်။

ဤ container အများအပြား ပါဝင်သည့် setup သည် ခေတ်သစ် ဝန်ဆောင်မှုများသည် စံသတ်မှတ်ထားသော API များ (HTTP REST API များ) မှတစ်ဆင့် အပြန်အလှန် ဆက်သွယ်ကြသောကြောင့် အတိုင်းအတာတစ်ခုအထိ ဖြစ်နိုင်ခြင်း ဖြစ်ပါသည်။ ဥပမာအားဖြင့် ပရိုဂရမ်တစ်ခုသည် OpenAI သို့မဟုတ် Anthropic ကဲ့သို့သော LLM provider များနှင့် ဆက်သွယ်တိုင်း၊ နောက်ကွယ်တွင် ၎င်းတို့၏ server များထံ HTTP request ပို့ဆောင်ပြီး ရလဒ်ကို တုံ့ပြန်ချက်စစ်ဆေးခြင်း (parsing) ပြုလုပ်နေခြင်း ဖြစ်ပါသည်။

```console
$ curl https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "content-type: application/json" \
    -H "anthropic-version: 2023-06-01" \
    -d '{"model": "claude-sonnet-4-20250514", "max_tokens": 256,
         "messages": [{"role": "user", "content": "Explain containers vs VMs in one sentence."}]}'
```

# ထုတ်ဝေခြင်း (Publishing)

သင်၏ ကုဒ်အလုပ်လုပ်ကြောင်း ပြသပြီးသည်နှင့် အခြားသူများ Download ပြုလုပ်၍ install လုပ်နိုင်ရန်အတွက် ၎င်းကို ဖြန့်ဝေပေးရန် စိတ်ဝင်စားပေလိမ့်မည်။
ဖြန့်ဝေခြင်း (Distribution) တွင် ပုံစံအမျိုးမျိုး ရှိပြီး သင်အသုံးပြုသော programming language နှင့် environment တို့နှင့် အစဉ်အမြဲ ဆက်စပ်နေပါသည်။

ဖြန့်ဝေခြင်း၏ အရိုးရှင်းဆုံး ပုံစံမှာ အခြားသူများ မိမိတို့စက်များတွင် Download ပြုလုပ်၍ install ပြုလုပ်နိုင်ရန် artifact များကို တင်ပေးခြင်း (upload ပြုလုပ်ခြင်း) ဖြစ်ပါသည်။
ဤသည်မှာ ယခုထက်ထိ ခေတ်စားနေဆဲ ဖြစ်ပြီး `.deb` ဖိုင်များပါဝင်သည့် HTTP directory listing တစ်ခုဖြစ်သော [Ubuntu ၏ package archive](http://archive.ubuntu.com/ubuntu/pool/main/) ကဲ့သို့သော နေရာများတွင် တွေ့ရှိနိုင်ပါသည်။

ယနေ့ခေတ်တွင် GitHub သည် source code နှင့် artifact များကို ထုတ်ဝေရန်အတွက် de facto platform တစ်ခု ဖြစ်လာခဲ့ပါသည်။
Source code ကို မကြာခဏ အများပြည်သူ လွတ်လပ်စွာ ရယူနိုင်သော်လည်း GitHub Releases သည် ပြုပြင်ထိန်းသိမ်းသူများအား tag တပ်ထားသော ဗားရှင်းများတွင် prebuilt binary များနှင့် အခြား artifact များကို တွဲဆက်ပေးနိုင်စေပါသည်။

Package manager မျာသည် အချို့အချိန်များတွင် source မှဖြစ်စေ သို့မဟုတ် ကြိုတင် build လုပ်ထားသော wheel မှဖြစ်စေ GitHub မှ တိုက်ရိုက် install ပြုလုပ်ခြင်းကို ထောက်ပံ့ပေးကြပါသည်-

```console
# Source မှ install ပြုလုပ်ခြင်း (clone ပြုလုပ်၍ build လုပ်မည်)
$ pip install git+https://github.com/psf/requests.git

# သီးခြား tag/branch မှ install ပြုလုပ်ခြင်း
$ pip install git+https://github.com/psf/requests.git@v2.32.3

# GitHub release မှ wheel ကို တိုက်ရိုက် install ပြုလုပ်ခြင်း
$ pip install https://github.com/user/repo/releases/download/v1.0/package-1.0-py3-none-any.whl
```

အမှန်စင်စစ် Go ကဲ့သို့သော အချို့ language များသည် ဗဟိုချုပ်ကိုင်မှုမရှိသော ဖြန့်ဝေရေး မော်ဒယ်ကို အသုံးပြုကြပါသည်—ဗဟို package repository တစ်ခုအဖြစ် မဟုတ်ဘဲ Go module များကို ၎င်းတို့၏ source code repository များထံမှ တိုက်ရိုက် ဖြန့်ဝေကြပါသည်။
`github.com/gorilla/mux` ကဲ့သို့သော Module လမ်းကြောင်းများသည် ကုဒ်ရှိရာနေရာကို ညွှန်ပြပြီး `go get` က ထိုနေရာထံမှ တိုက်ရိုက် ဆွဲယူပေးပါသည်။ သို့သော်လည်း `pip`၊ `cargo`၊ သို့မဟုတ် `brew` ကဲ့သို့သော package manager အများစုတွင် ဖြန့်ဝေရလွယ်ကူစေရန်နှင့် install ပြုလုပ်ရလွယ်ကူစေရန်အတွက် ကြိုတင်ထုပ်ပိုးထားသော ပရောဂျက်များ၏ ဗဟို index များ ရှိကြပါသည်။ အကယ်၍ ကျွန်ုပ်တို့သည် အောက်ပါအတိုင်း Run လိုက်ပါက-

```console
$ uv pip install requests --verbose --no-cache 2>&1 | grep -F '.whl'
DEBUG Selecting: requests==2.32.5 [compatible] (requests-2.32.5-py3-none-any.whl)
DEBUG No cache entry for: https://files.pythonhosted.org/packages/1e/db/4254e3eabe8020b458f1a747140d32277ec7a271daf1d235b70dc0b4e6e3/requests-2.32.5-py3-none-any.whl.metadata
DEBUG No cache entry for: https://files.pythonhosted.org/packages/1e/db/4254e3eabe8020b458f1a747140d32277ec7a271daf1d235b70dc0b4e6e3/requests-2.32.5-py3-none-any.whl
```

ကျွန်ုပ်တို့သည် `requests` wheel ကို မည်သည့်နေရာမှ ဆွဲယူနေသည်ဆိုသည်ကို မြင်တွေ့နိုင်ပါသည်။ ဖိုင်အမည်ရှိ `py3-none-any` ကို သတိပြုပါ—၎င်း၏ အဓိပ္ပာယ်မှာ ဤ wheel သည် မည်သည့် OS၊ မည်သည့် architecture ပေါ်တွင်မဆို မည်သည့် Python 3 ဗားရှင်းဖြင့်မဆို အလုပ်လုပ်သည်ဟု ဆိုလိုခြင်း ဖြစ်ပါသည်။ Compile လုပ်ထားသော ကုဒ်ပါဝင်သည့် package များအတွက် wheel သည် platform အလိုက် သီးခြား ဖြစ်ပါသည်-

```console
$ uv pip install numpy --verbose --no-cache 2>&1 | grep -F '.whl'
DEBUG Selecting: numpy==2.2.1 [compatible] (numpy-2.2.1-cp312-cp312-macosx_14_0_arm64.whl)
```

ဤနေရာတွင် `cp312-cp312-macosx_14_0_arm64` က ဤ wheel သည် ARM64 (Apple Silicon) အတွက် macOS 14+ ပေါ်ရှိ CPython 3.12 အတွက် သီးသန့် ဖြစ်ကြောင်း ညွှန်ပြနေပါသည်။ အကယ်၍ သင်သည် အခြား platform တစ်ခုပေါ်တွင် ရောက်ရှိနေပါက `pip` သည် မတူညီသော wheel တစ်ခုကို Download ပြုလုပ်မည် သို့မဟုတ် source မှ build ပြုလုပ်ပါလိမ့်မည်။

ဆန့်ကျင်ဘက်အားဖြင့် ကျွန်ုပ်တို့ ဖန်တီးခဲ့သော package ကို အခြားသူများ ရှာဖွေတွေ့ရှိနိုင်ရန်အတွက် ကျွန်ုပ်တို့သည် ၎င်းကို ဤ registry များအနက် တစ်ခုခုထံ ထုတ်ဝေ (publish) ရန် လိုအပ်ပါသည်။
Python တွင် ပင်မ registry မှာ [Python Package Index (PyPI)](https://pypi.org) ဖြစ်ပါသည်။
Install ပြုလုပ်ခြင်းကဲ့သို့ပင် package များကို ထုတ်ဝေရန် နည်းလမ်းများစွာ ရှိပါသည်။ `uv publish` command သည် package များကို PyPI ထံ upload လုပ်ရန်အတွက် ခေတ်မီသော interface တစ်ခုကို ပံ့ပိုးပေးပါသည်-

```console
$ uv publish --publish-url https://test.pypi.org/legacy/
Publishing greeting-0.1.0.tar.gz
Publishing greeting-0.1.0-py3-none-any.whl
```

ဤနေရာတွင် ကျွန်ုပ်တို့သည် တကယ့် PyPI ကို မညစ်ညမ်းစေဘဲ သင်၏ ထုတ်ဝေရေး workflow ကို စမ်းသပ်ရန် ရည်ရွယ်ထားသော သီးခြား package registry တစ်ခု ဖြစ်သည့် [TestPyPI](https://test.pypi.org) ကို အသုံးပြုနေကြပါသည်။ Upload လုပ်ပြီးပါက TestPyPI ထံမှ install ပြုလုပ်နိုင်ပြီ ဖြစ်ပါသည်-

```console
$ uv pip install --index-url https://test.pypi.org/simple/ greeting
```

ဆော့ဖ်ဝဲလ် ထုတ်ဝေရာတွင် အဓိက စဉ်းစားရမည့် အချက်မှာ ယုံကြည်စိတ်ချရမှု (trust) ဖြစ်ပါသည်။ သုံးစွဲသူများသည် ၎င်းတို့ Download ပြုလုပ်သော package သည် သင့်ထံမှ အမှန်တကယ် လာခြင်းဖြစ်ကြောင်းနှင့် ပြုပြင်မွမ်းမံထားခြင်း မရှိကြောင်း မည်သို့ အတည်ပြုကြမည်နည်း။ Package registry များသည် တည်ငြိမ်မှန်ကန်မှုကို အတည်ပြုရန် checksum များကို အသုံးပြုကြပြီး အချို့သော ecosystem များသည် မူပိုင်ခွင့်ဆိုင်ရာ သင်္ကေတပြ အထောက်အထား ပံ့ပိုးရန် package လက်မှတ်ရေးထိုးခြင်း (package signing) ကို ထောက်ပံ့ပေးကြပါသည်။

မတူညီသော language များတွင် မိမိတို့၏ ကိုယ်ပိုင် package registry များ ရှိကြပါသည်- Rust အတွက် [crates.io](https://crates.io)၊ JavaScript အတွက် [npm](https://www.npmjs.com)၊ Ruby အတွက် [RubyGems](https://rubygems.org)၊ နှင့် container image များအတွက် [Docker Hub](https://hub.docker.com) ဖြစ်ကြပါသည်။ ထိုအတောအတွင်း သီးသန့် သို့မဟုတ် အတွင်းပိုင်း package များအတွက် အဖွဲ့အစည်းများသည် မိမိတို့၏ ကိုယ်ပိုင် package repository များကို မကြာခဏ deploy လုပ်လေ့ ရှိကြပါသည် (သီးသန့် PyPI server သို့မဟုတ် သီးသန့် Docker registry ကဲ့သို့သော) သို့မဟုတ် cloud provider များထံမှ စီမံခန့်ခွဲပေးထားသော နည်းလမ်းများကို အသုံးပြုကြပါသည်။

ဝဘ်ဝန်ဆောင်မှုတစ်ခုကို အင်တာနက်ထံ deploy ပြုလုပ်ခြင်းတွင် အပိုဆောင်း အဆောက်အအုံများ ပါဝင်ပါသည်- domain name မှတ်ပုံတင်ခြင်း၊ သင့် domain ကို သင့် server ထံ ညွှန်းဆိုရန် DNS စနစ်ပြင်ဆင်ခြင်း၊ နှင့် မကြာခဏဆိုသလို HTTPS ကို ကိုင်တွယ်ရန်နှင့် traffic လမ်းကြောင်းပေးရန် nginx ကဲ့သို့သော reverse proxy တစ်ခု သုံးစွဲခြင်း။ Documentation များ သို့မဟုတ် static site များကဲ့သို့ ပိုမို ရိုးရှင်းသော အသုံးပြုမှုများအတွက် [GitHub Pages](https://pages.github.com/) သည် repository ထံမှ တိုက်ရိုက် အခမဲ့ hosting ကို ပံ့ပိုးပေးပါသည်။

<!--
## Documentation

ယခုအချိန်အထိ ကျွန်ုပ်တို့သည် ကုဒ်များကို packaging နှင့် shipping ပြုလုပ်ခြင်း၏ အဓိက ရလဒ်အဖြစ် ပေးအပ်ရမည့် _artifact_ ကို အလေးပေးဖော်ပြခဲ့ပါသည်။
Artifact အပြင် ကျွန်ုပ်တို့သည် သုံးစွဲသူများအတွက် ကုဒ်၏ လုပ်ဆောင်ချက်၊ install ပြုလုပ်နည်း ညွှန်ကြားချက်များ၊ နှင့် အသုံးပြုပုံ ဥပမာများကို မှတ်တမ်းတင်ပေးရန် လိုအပ်ပါသည်။

[Sphinx](https://www.sphinx-doc.org/) (Python) နှင့် [MkDocs](https://www.mkdocs.org/) ကဲ့သို့သော tool များသည် docstring များနှင့် markdown ဖိုင်များထံမှ ဖတ်ရှုနိုင်သော Documentation များကို အလိုအလျောက် ထုတ်လုပ်ပေးနိုင်ပြီး [Read the Docs](https://readthedocs.org/) ကဲ့သို့သော ဝန်ဆောင်မှုများတွင် မကြာခဏ host လုပ်လေ့ရှိကြပါသည်။
HTTP အခြေခံ API များအတွက် [OpenAPI specification](https://www.openapis.org/) (ယခင် Swagger) သည် API endpoint များကို ဖော်ပြရန်အတွက် စံသတ်မှတ်ထားသော ပုံစံတစ်ခုကို ပံ့ပိုးပေးထားပြီး tool များက အပြန်အလှန် တုံ့ပြန်နိုင်သော Documentation များနှင့် client library များကို အလိုအလျောက် ထုတ်လုပ်ရန် အသုံးပြုနိုင်ပါသည်။ -->

# လေ့ကျင့်ခန်းများ (Exercises)

1. သင့် environment ကို `printenv` ဖြင့် ဖိုင်တစ်ခုထဲသို့ သိမ်းဆည်းပါ၊ venv တစ်ခု ဖန်တီးပါ၊ ၎င်းကို activate ပြုလုပ်ပါ၊ အခြားဖိုင်တစ်ခုထဲသို့ `printenv` လုပ်ပြီး `diff before.txt after.txt` ပြုလုပ်ပါ။ Environment တွင် မည်သည့်အရာများ ပြောင်းလဲသွားသနည်း။ Shell က venv ကို အဘယ်ကြောင့် ဦးစားပေးသနည်း။ (အချက်အလက်- activation ပြုလုပ်မီနှင့် ပြုလုပ်ပြီးနောက် `$PATH` ကို ကြည့်ပါ။) `which deactivate` ကို မောင်းနှင်ပြီး deactivate bash function သည် မည်သည့်အရာ ပြုလုပ်နေသည်ကို အကြောင်းပြချက် ဖော်ထုတ်ပါ။
1. `pyproject.toml` ပါရှိသော Python package တစ်ခုကို ဖန်တီးပြီး ၎င်းကို virtual environment တစ်ခုတွင် install ပြုလုပ်ပါ။ Lockfile တစ်ခု ဖန်တီးပြီး စစ်ဆေးပါ။
1. Docker ကို install ပြုလုပ်ပြီး docker compose ကို အသုံးပြု၍ Missing Semester သင်တန်း ဝဘ်ဆိုက်ကို မိမိစက်တွင် build ပြုလုပ်ရန် ၎င်းကို အသုံးပြုပါ။
1. ရိုးရှင်းသော Python application တစ်ခုအတွက် Dockerfile တစ်ခု ရေးသားပါ။ ထို့နောက် Redis cache နှင့်အတူ သင့် application ကို မောင်းနှင်သည့် `docker-compose.yml` တစ်ခု ရေးသားပါ။
1. Python package တစ်ခုကို TestPyPI ထံ ထုတ်ဝေပါ (ဝေမျှထိုက်ပါမှလွဲ၍ တကယ့် PyPI ထံ ထုတ်ဝေခြင်း မပြုပါနှင့်!)။ ထို့နောက် ထို package ဖြင့် Docker image တစ်ခုကို build ပြုလုပ်ပြီး ၎င်းကို `ghcr.io` ထံ push ပြုလုပ်ပါ။
1. [GitHub Pages](https://docs.github.com/en/pages/quickstart) ကို အသုံးပြု၍ ဝဘ်ဆိုက်တစ်ခု ပြုလုပ်ပါ။ Extra (non-)credit- ၎င်းကို custom domain တစ်ခုဖြင့် စနစ်ပြင်ဆင်ပါ။
