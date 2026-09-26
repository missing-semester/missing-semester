---
layout: lecture
title: "Q&A"
description: >
  Operating systems, shell scripting, tool အကြံပြုချက်များ နှင့် အခြား ခေါင်းစဉ်များအပေါ် ကျောင်းသားများ၏ မေးခွန်းများအတွက် အဖြေများ။
thumbnail: /static/assets/thumbnails/2020/lec11.png
date: 2020-01-30
ready: true
video:
  aspect: 56.25
  id: Wz50FvGG6xU
special: true
---

နောက်ဆုံး သင်ခန်းစာအဖြစ် ကျောင်းသားများ ပေးပို့ထားသော မေးခွန်းများကို ဖြေကြားခဲ့ပါသည် -

- [Any recommendations on learning Operating Systems related topics like processes, virtual memory, interrupts, memory management, etc ](#any-recommendations-on-learning-operating-systems-related-topics-like-processes-virtual-memory-interrupts-memory-management-etc)
- [What are some of the tools you'd prioritize learning first?](#what-are-some-of-the-tools-youd-prioritize-learning-first)
- [When do I use Python versus a Bash scripts versus some other language?](#when-do-i-use-python-versus-a-bash-scripts-versus-some-other-language)
- [What is the difference between `source script.sh` and `./script.sh`](#what-is-the-difference-between-source-scriptsh-and-scriptsh)
- [What are the places where various packages and tools are stored and how does referencing them work? What even is `/bin` or `/lib`?](#what-are-the-places-where-various-packages-and-tools-are-stored-and-how-does-referencing-them-work-what-even-is-bin-or-lib)
- [Should I `apt-get install` a python-whatever, or `pip install` whatever package?](#should-i-apt-get-install-a-python-whatever-or-pip-install-whatever-package)
- [What's the easiest and best profiling tools to use to improve performance of my code?](#whats-the-easiest-and-best-profiling-tools-to-use-to-improve-performance-of-my-code)
- [What browser plugins do you use?](#what-browser-plugins-do-you-use)
- [What are other useful data wrangling tools?](#what-are-other-useful-data-wrangling-tools)
- [What is the difference between Docker and a Virtual Machine?](#what-is-the-difference-between-docker-and-a-virtual-machine)
- [What are the advantages and disadvantages of each OS and how can we choose between them (e.g. choosing the best Linux distribution for our purposes)?](#what-are-the-advantages-and-disadvantages-of-each-os-and-how-can-we-choose-between-them-eg-choosing-the-best-linux-distribution-for-our-purposes)
- [Vim vs Emacs?](#vim-vs-emacs)
- [Any tips or tricks for Machine Learning applications?](#any-tips-or-tricks-for-machine-learning-applications)
- [Any more Vim tips?](#any-more-vim-tips)
- [What is 2FA and why should I use it?](#what-is-2fa-and-why-should-i-use-it)
- [Any comments on differences between web browsers?](#any-comments-on-differences-between-web-browsers)

## Any recommendations on learning Operating Systems related topics like processes, virtual memory, interrupts, memory management, etc

ပထမဦးစွာ ဤခေါင်းစဉ်များသည် အလွန် Low-level ကျသောကြောင့် အားလုံးကို ကျွမ်းကျင်ရန် လိုမလိုမှာ မသေချာပါ။ Kernel ကို ရေးသားခြင်း သို့မဟုတ် ပြင်ဆင်ခြင်း ကဲ့သို့သော Low-level code များ ရေးသားချိန်တွင်မှ သက်ရောက်မည် ဖြစ်သည်။

သင်ယူရန် ကောင်းမွန်သော သင်ခန်းစာများ -
- [MIT ၏ 6.828 အတန်း](https://pdos.csail.mit.edu/6.828/) - Graduate level Operating System Engineering အတန်း ဖြစ်သည်။
- Modern Operating Systems (4th ed) - Andrew S. Tanenbaum ရေးသားသည်။
- The Design and Implementation of the FreeBSD Operating System
- [Writing an OS in Rust](https://os.phil-opp.com/) 

## What are some of the tools you'd prioritize learning first?

ဦးစားပေးသင့်သော ခေါင်းစဉ်အချို့ -
- Keyboard ကို ပိုမို အသုံးပြုပြီး Mouse ကို နည်းပါးစွာ သုံးတတ်အောင် လေ့ကျင့်ပါ။
- မိမိ အသုံးပြုသော Editor ကို ကျွမ်းကျင်စွာ သုံးတတ်အောင် လေ့ကျင့်ပါ။
- တူညီသော အလုပ်များကို အလိုအလျောက် ပြုလုပ်နိုင်ရန် လေ့လာပါ...
- Git ကဲ့သို့သော Version control tool များကို လေ့လာပါ။

## When do I use Python versus a Bash scripts versus some other language?

ယေဘုယျအားဖြင့် Bash script သည် Command အနည်းငယ် ရန်းမည့် ရိုးရှင်းသော အလုပ်များအတွက် အသုံးဝင်ပါသည်။ ကြီးမားသော ပရိုဂရမ်များအတွက် Bash တွင် အားနည်းချက်များ ရှိပါသည် -
- အခရာ စာလုံးများ (spaces) ပါပါက Bug ဖြစ်ပေါ်နိုင်ခြင်း။
- Code များကို ပြန်လည် အသုံးပြုရန် ခက်ခဲခြင်း (Library အယူအဆ မရှိခြင်း)။
- `$?` သို့မဟုတ် `$@` ကဲ့သို့သော Magic string များကို သုံးရခြင်း။

ထို့ကြောင့် ကြီးမားသော Script များအတွက် Python သို့မဟုတ် Ruby ကို အကြံပြုပါသည်။

## What is the difference between `source script.sh` and `./script.sh`

`source` သည် လက်ရှိ Bash session တွင် Command များကို ရန်းပေးသဖြင့် Directory ပြောင်းခြင်း၊ Function သတ်မှတ်ခြင်းတို့သည် လက်ရှိ Session တွင် ကျန်ရစ်မည် ဖြစ်သည်။ `./script.sh` မူ Bash session အသစ်တစ်ခု ဖွင့်၍ ရန်းသဖြင့် Session ပြီးပါက မူလနေရာသို့ ပြန်ရောက်မည် ဖြစ်သည်။

## What are the places where various packages and tools are stored and how does referencing them work? What even is `/bin` or `/lib`?

- `/bin` - Essential command binaries
- `/sbin` - Root မှ ရန်းမည့် Essential system binaries
- `/dev` - Device files
- `/etc` - System-wide configuration files
- `/home` - User များ၏ Home directories
- `/lib` - System program များအတွက် Common libraries
- `/opt` - Optional application software
- `/sys` - System configuration (ပထမ သင်ခန်းစာတွင် ပါဝင်ခဲ့သည်)
- `/tmp` - Temporary files (Reboot လုပ်ပါက ပျက်စီးမည်)
- `/usr/` - Read only user data
  + `/usr/bin` - Non-essential command binaries
  + `/usr/sbin` - Non-essential system binaries
  + `/usr/local/bin` - User compiled binaries
- `/var` - Variable files (logs, caches)

## Should I `apt-get install` a python-whatever, or `pip install` whatever package?

ပရိုဂရမ်မင်း ဘာသာစကား သီးသန့် Package manager (ဥပမာ `pip`) ကို အသုံးပြုရန်နှင့် မူလ စနစ်ကို မထိခိုက်စေရန် Virtual environment (`virtualenv`) များကို အသုံးပြုရန် အကြံပြုပါသည်။

## What's the easiest and best profiling tools to use to improve performance of my code?

အလွယ်ကူဆုံးမှာ [print timing](/2020/debugging-profiling/#timing) ဖြစ်ပါသည်။
အဆင့်မြင့် Tool များအတွက် Valgrind ၏ [Callgrind](https://valgrind.org/docs/manual/cl-manual.html)၊ [`perf`](https://www.brendangregg.com/perf.html) နှင့် [Flamegraphs](https://www.brendangregg.com/flamegraphs.html) တို့ကို အသုံးပြုနိုင်ပါသည်။

## What browser plugins do you use?

- [uBlock Origin](https://github.com/gorhill/uBlock) - Ad blocker
- [Stylus](https://github.com/openstyles/stylus/) - Custom CSS
- Full Page Screen Capture
- [Multi Account Containers](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/)
- Password Manager Integration
- [Vimium](https://github.com/philc/vimium)

## What are other useful data wrangling tools?

`jq`, `pup`, Perl, `column -t` တို့ ဖြစ်ကြပါသည်။ Python တွင် [pandas](https://pandas.pydata.org/) library သည် CSV များနှင့် အခြား Tabular data များအတွက် အလွန် ကောင်းမွန်ပါသည်။

## What is the difference between Docker and a Virtual Machine?

Virtual machine သည် Kernel အပါအဝင် OS တစ်ခုလုံးကို ရန်းပေးသည်။ Docker (Containers) မူ Host စနစ်၏ Kernel ကို မျှဝေ သုံးစွဲသဖြင့် Overhead နည်းပါးသည်။

## What are the advantages and disadvantages of each OS and how can we choose between them (e.g. choosing the best Linux distribution for our purposes)?

Linux distro အများစုသည် လုပ်ဆောင်ချက် ဆင်တူကြသည်။ အဓိက ကွာခြားချက်မှာ Package update ပေါ် မူတည်သည် (Arch Linux တွင် Rolling update ဖြစ်ပြီး၊ Debian/Ubuntu တွင် Conservative ဖြစ်သည်)။ Desktop နှင့် Server အတွက် Debian သို့မဟုတ် Ubuntu ကို အကြံပြုပါသည်။

## Vim vs Emacs?

ဆရာများ အားလုံး Vim ကို အဓိက သုံးကြသော်လည်း Emacs သည်လည်း ကောင်းမွန်သော Alternative ဖြစ်သည်။

## Any tips or tricks for Machine Learning applications?

ML တွင် စမ်းသပ်မှုများကို ခြေရာခံရန် JSON file များ၊ Shell tool များနှင့် Automation များကို သုံးနိုင်သည်။

## Any more Vim tips?

- Plugins (VimAwesome)
- Marks (`m<X>` နှင့် `'<X>`)
- Navigation (`Ctrl+O` နှင့် `Ctrl+I`)
- Undo Tree ([undotree](https://github.com/mbbill/undotree))
- Persistent undo (`undofile` နှင့် `undodir`)
- Leader Key

## What is 2FA and why should I use it?

2FA သည် စကားဝှက်အပြင် Hardware device ကို သုံးစေ၍ လုံခြုံရေး အလွှာတစ်ခု ထပ်မံ ပေါင်းထည့်ပေးခြင်း ဖြစ်သည်။ [YubiKey](https://www.yubico.com/) (U2F) ကို အကြံပြုပါသည်။

## Any comments on differences between web browsers?

2FA နှင့် လုံခြုံရေး အပြင် Firefox ကို အဓိက အကြံပြုပါသည်။
