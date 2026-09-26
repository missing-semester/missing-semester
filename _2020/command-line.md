---
layout: lecture
title: "Command-line Environment"
description: >
  Job control၊ terminal multiplexers၊ dotfiles နှင့် SSH အသုံးပြု၍ remote machines များ လုပ်ဆောင်ပုံ အကြောင်း လေ့လာပါ။
thumbnail: /static/assets/thumbnails/2020/lec5.png
date: 2020-01-21
ready: true
video:
  aspect: 56.25
  id: e8BO_dYxk5c
---

ဤသင်ခန်းစာတွင် Shell ကို အသုံးပြုရာ၌ သင်၏ လုပ်ငန်းစဉ် (workflow) ကို ပိုမိုကောင်းမွန် လျင်မြန်စေမည့် နည်းလမ်းများစွာကို အသေးစိတ် လေ့လာသွားပါမည်။ ကျွန်ုပ်တို့သည် Shell ကို အသုံးပြုလာခဲ့သည်မှာ အတော်အတန် ကြာမြင့်ပြီ ဖြစ်သော်လည်း အဓိကအားဖြင့် Command များကို တစ်ခုပြီးတစ်ခု စတင် 실행 (execute) ခြင်းအပေါ်၌သာ အာရုံစိုက်ခဲ့ကြပါသည်။ ယခုအခါတွင် Process အများအပြားကို တစ်ပြိုင်နက်တည်း မည်သို့ စောင့်ကြည့် စီမံမလဲ၊ သီးခြား Process တစ်ခုခုကို မည်သို့ ခေတ္တရပ်ဆိုင်း သို့မဟုတ် ပိတ်ပစ်မလဲ နှင့် Process များကို နောက်ကွယ် (background) တွင် မည်သို့ ရန်း (run) ထားမလဲ ဆိုသည်များကို လေ့လာသွားမည် ဖြစ်ပါသည်။

ထို့ပြင် Aliases များကို သတ်မှတ်ခြင်းနှင့် Dotfiles များကို အသုံးပြု၍ ပြင်ဆင်သတ်မှတ်ခြင်း (configuration) ဖြင့် သင်၏ Shell နှင့် အခြား Tool များကို မည်သို့ ပိုမိုကောင်းမွန်အောင် ပြုလုပ်နိုင်သည်ကိုလည်း လေ့လာပါမည်။ ဤနည်းလမ်းနှစ်ခုစလုံးသည် သင်၏ စက်အားလုံးတွင် တူညီသော Configuration များကို အသုံးပြုနိုင်စေပြီး ရှည်လျားသော Command များကို ထပ်ခါတလဲလဲ ရိုက်နှိပ်စရာ မလိုဘဲ အချိန်ကုန် သက်သာစေပါသည်။ ထို့အပြင် SSH ကို အသုံးပြု၍ အဝေးရှိ စက်များ (remote machines) နှင့် မည်သို့ ချိတ်ဆက် အလုပ်လုပ်ရမည်ကိုပါ လေ့လာသွားမည် ဖြစ်ပါသည်။


# Job Control

အချို့သော အခြေအနေများတွင် Command တစ်ခု ရန်းနေစဉ်အတွင်း ယင်း၏ လုပ်ဆောင်ချက်ကို ခေတ္တရပ်ရန် သို့မဟုတ် ဖြတ်တောက်ရန် လိုအပ်တတ်ပါသည်။ အထူးသဖြင့် ဖိုင်လမ်းကြောင်း အမြောက်အမြားကို ရှာဖွေနေသည့် `find` ကဲ့သို့သော Command များသည် အချိန်အလွန် ကြာမြင့်နေသည့် အခါမျိုး ဖြစ်ပါသည်။
များသောအားဖြင့် `Ctrl-C` ကို နှိပ်လိုက်ပါက Command ၏ လုပ်ဆောင်ချက် ရပ်တန့်သွားမည် ဖြစ်သည်။
သို့သော် ဤလုပ်ဆောင်ချက်သည် နောက်ကွယ်တွင် မည်သို့ အလုပ်လုပ်သနည်း၊ အဘယ်ကြောင့် အချို့သော Process များသည် ရပ်တန့်မသွားဘဲ ဖြစ်နေရသနည်း။

## Killing a process

သင်၏ Shell သည် Process များထံ အချက်အလက်များ ပေးပို့ဆက်သွယ်ရန်အတွက် UNIX Communication Mechanism တစ်ခုဖြစ်သည့် _Signal_ ကို အသုံးပြုပါသည်။ Process တစ်ခုသည် Signal တစ်ခုကို လက်ခံရရှိသောအခါ ယင်း၏ လုပ်ဆောင်နေမှုကို ခေတ္တရပ်ဆိုင်းပြီး လက်ခံရရှိသည့် Signal ၏ ညွှန်ကြားချက်အတိုင်း ဆက်လက် လုပ်ဆောင်ပါသည်။ ထို့ကြောင့် Signal များကို _Software Interrupts_ ဟု ခေါ်ဆိုကြပါသည်။

ကျွန်ုပ်တို့၏ ကိစ္စတွင် `Ctrl-C` ကို နှိပ်လိုက်သောအခါ Shell သည် Process ထံသို့ `SIGINT` ဆိုသည့် Signal ကို ပေးပို့လိုက်ခြင်း ဖြစ်သည်။

အောက်တွင် `SIGINT` Signal ကို ဖမ်းယူပြီး ပစ်ပယ်ထားကာ (ignore) ဆက်လက် ရန်းနေမည့် မူလ Python ပရိုဂရမ် အသေးစားလေးကို ဖော်ပြထားပါသည်။ ဤပရိုဂရမ်ကို ပိတ်ပစ်ရန်အတွက် `Ctrl-C` အစား `Ctrl-\` ကို နှိပ်၍ `SIGQUIT` Signal ကို အသုံးပြုရမည် ဖြစ်သည်။

```python
#!/usr/bin/env python
import signal, time

def handler(signum, time):
    print("\nI got a SIGINT, but I am not stopping")

signal.signal(signal.SIGINT, handler)
i = 0
while True:
    time.sleep(.1)
    print("\r{}".format(i), end="")
    i += 1
```

ဤပရိုဂရမ်သို့ `SIGINT` ကို နှစ်ကြိမ်တိုင်တိုင် ပေးပို့ပြီးနောက် `SIGQUIT` ပေးပို့လိုက်သည့်အခါ မည်သို့ ဖြစ်ပျက်သွားသည်ကို အောက်တွင် ကြည့်နိုင်ပါသည်။ Terminal တွင် `^` သင်္ကေတသည် `Ctrl` ခလုတ်ကို နှိပ်ထားခြင်းကို ကိုယ်စားပြုပါသည်။

```
$ python sigint.py
24^C
I got a SIGINT, but I am not stopping
26^C
I got a SIGINT, but I am not stopping
30^\[1]    39913 quit       python sigint.py
```

`SIGINT` နှင့် `SIGQUIT` နှစ်ခုစလုံးသည် Terminal နှင့် ပတ်သက်သော တောင်းဆိုချက်များအတွက် အသုံးပြုလေ့ရှိသော်လည်း၊ Process တစ်ခုကို စနစ်တကျ ပိတ်ပစ်ရန် (exit gracefully) အတွက် ပိုမို ယေဘုယျကျသော Signal မှာ `SIGTERM` Signal ဖြစ်ပါသည်။
ဤ Signal ကို ပေးပို့ရန်အတွက် [`kill`](https://www.man7.org/linux/man-pages/man1/kill.1.html) Command ကို `kill -TERM <PID>` ဟူသော Syntax ဖြင့် အသုံးပြုနိုင်ပါသည်။

## Pausing and backgrounding processes

Signal များသည် Process တစ်ခုကို ပိတ်ပစ်ရုံသာမက အခြားသော လုပ်ဆောင်ချက်များကိုလည်း ပြုလုပ်နိုင်ပါသည်။ ဥပမာအားဖြင့် `SIGSTOP` သည် Process တစ်ခုကို ခေတ္တရပ်ဆိုင်း (pause) စေပါသည်။ Terminal တွင် `Ctrl-Z` ကို နှိပ်လိုက်ပါက Shell သည် Terminal Stop ကို ကိုယ်စားပြုသော `SIGTSTP` Signal ကို ပေးပို့မည် ဖြစ်သည်။

ထို့နောက် ခေတ္တရပ်ဆိုင်းထားသော Job ကို ရှေ့ကွယ် (foreground) တွင် ဆက်လက် ရန်းလိုပါက [`fg`](https://www.man7.org/linux/man-pages/man1/fg.1p.html) ကိုလည်းကောင်း၊ နောက်ကွယ် (background) တွင် ရန်းလိုပါက [`bg`](https://man7.org/linux/man-pages/man1/bg.1p.html) ကိုလည်းကောင်း အသီးသီး အသုံးပြုနိုင်ပါသည်။

[`jobs`](https://www.man7.org/linux/man-pages/man1/jobs.1p.html) Command သည် လက်ရှိ Terminal Session တွင် မပြီးသေးဘဲ ရှိနေသော Job များ၏ စာရင်းကို ပြသပေးပါသည်။
ထို Job များကို ယင်းတို့၏ PID ဖြင့် ညွှန်းဆိုနိုင်ပါသည် (PID ကို ရှာရန် [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) ကို အသုံးပြုနိုင်သည်)။
ပိုမို လွယ်ကူသော နည်းလမ်းမှာ ရာခိုင်နှုန်းသင်္ကေတ `%` နောက်တွင် Job နံပါတ် ( `jobs` က ပြသပေးသော နံပါတ်) ကို တွဲဖက်၍ ညွှန်းဆိုခြင်း ဖြစ်သည်။ နောက်ဆုံး Background လုပ်ထားသော Job ကို ညွှန်းဆိုလိုပါက `$!` ဟူသော Special Parameter ကို အသုံးပြုနိုင်ပါသည်။

အခြား သိရှိထားသင့်သည့် အချက်တစ်ခုမှာ Command ၏ နောက်တွင် `&` သင်္ကေတ ထည့်သွင်းလိုက်ပါက ထို Command သည် Background တွင် စတင် ရန်းမည်ဖြစ်ပြီး Prompt ထံသို့ ချက်ချင်း ပြန်ရောက်သွားမည် ဖြစ်သည်။ (သို့သော် output များသည် Terminal ၏ STDOUT သို့ ထွက်ပေါ်လာနိုင်သဖြင့် လိုအပ်ပါက Shell Redirections များကို အသုံးပြုပါ)။

စတင် ရန်းနေပြီးသား ပရိုဂရမ်တစ်ခုကို Background သို့ ပို့လိုပါက `Ctrl-Z` နှိပ်ပြီးနောက် `bg` ဟု ရိုက်နှိပ်နိုင်ပါသည်။
သတိပြုရန်မှာ Background ရောက်သွားသော Process များသည် သင်၏ Terminal ၏ Child Process များအဖြစ် ရှိနေဆဲ ဖြစ်သဖြင့် Terminal ကို ပိတ်လိုက်ပါက ထို Process များပါ ပိတ်သွားမည် ဖြစ်သည် (`SIGHUP` Signal ပေးပို့သွားမည် ဖြစ်သည်)။
ထိုသို့ မဖြစ်စေရန်အတွက် ပရိုဂရမ်ကို [`nohup`](https://www.man7.org/linux/man-pages/man1/nohup.1.html) (`SIGHUP` ကို ပစ်ပယ်ရန် အသုံးပြုသည့် wrapper) ဖြင့် စတင် ရန်းနိုင်သည်၊ သို့မဟုတ် Process စတင်ပြီးသွားပါက `disown` Command ကို အသုံးပြုနိုင်ပါသည်။
နောက်တစ်နည်းမှာ နောက်လာမည့် အပိုင်းတွင် ဖော်ပြမည့် Terminal Multiplexer ကို အသုံးပြုခြင်း ဖြစ်ပါသည်။

အောက်တွင် ဤအယူအဆများကို လက်တွေ့ ပြသထားသည့် Sample Session တစ်ခု ဖြစ်ပါသည်။

```
$ sleep 1000
^Z
[1]  + 18653 suspended  sleep 1000

$ nohup sleep 2000 &
[2] 18745
appending output to nohup.out

$ jobs
[1]  + suspended  sleep 1000
[2]  - running    nohup sleep 2000

$ bg %1
[1]  - 18653 continued  sleep 1000

$ jobs
[1]  - running    sleep 1000
[2]  + running    nohup sleep 2000

$ kill -STOP %1
[1]  + 18653 suspended (signal)  sleep 1000

$ jobs
[1]  + suspended (signal)  sleep 1000
[2]  - running    nohup sleep 2000

$ kill -SIGHUP %1
[1]  + 18653 hangup     sleep 1000

$ jobs
[2]  + running    nohup sleep 2000

$ kill -SIGHUP %2

$ jobs
[2]  + running    nohup sleep 2000

$ kill %2
[2]  + 18745 terminated  nohup sleep 2000

$ jobs

```

အထူး Signal တစ်ခုမှာ `SIGKILL` ဖြစ်ပါသည်။ အကြောင်းမှာ ယင်း Signal ကို Process များက ဖမ်းယူ သို့မဟုတ် ပစ်ပယ်ထား၍ မရဘဲ ချက်ချင်း ပိတ်ပစ်မည် ဖြစ်သည်။ သို့သော် မိဘမဲ့ မိခင်မဲ့ Child Process များ ကျန်ရစ်ခဲ့ခြင်းကဲ့သို့သော ဆိုးကျိုးများ ရှိနိုင်ပါသည်။

ဤ Signal များ အကြောင်းကို [ဒီမှာ](https://en.wikipedia.org/wiki/Signal_(IPC)) ပိုမို လေ့လာနိုင်သည်၊ သို့မဟုတ် Terminal တွင် [`man signal`](https://www.man7.org/linux/man-pages/man7/signal.7.html) သို့မဟုတ် `kill -l` ဟု ရိုက်နှိပ်၍ ကြည့်ရှုနိုင်ပါသည်။


# Terminal Multiplexers

Command Line Interface ကို အသုံးပြုသည့်အခါ တစ်ချိန်တည်းတွင် အလုပ်တစ်ခုထက်မက ပြိုင်တူ လုပ်ဆောင်ချင်သည့် အခြေအနေမျိုး မကြာခဏ ကြုံတွေ့ရတတ်ပါသည်။
ဥပမာအားဖြင့် သင်၏ Editor နှင့် Program ကို ဘေးချင်းယှဉ်၍ ရန်းလိုသည့် အခါမျိုး ဖြစ်သည်။
Terminal Window အသစ်များကို ဖွင့်ခြင်းဖြင့်လည်း ဤသို့ ပြုလုပ်နိုင်သော်လည်း Terminal Multiplexer ကို အသုံးပြုခြင်းသည် ပိုမို စုံလင်ဆန်းသစ်သော ဖြေရှင်းနည်း ဖြစ်ပါသည်။

[`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) ကဲ့သို့သော Terminal Multiplexer များသည် Terminal Window များကို Panes များနှင့် Tabs များအဖြစ် ခွဲခြားပေးနိုင်သောကြောင့် Shell Session အမြောက်အမြားနှင့် ပြိုင်တူ ချိတ်ဆက် ဆောင်ရွက်နိုင်စေပါသည်။
ထို့အပြင် Terminal Multiplexer များသည် လက်ရှိ Terminal Session ကို ခေတ္တ ဖြုတ်ထားခဲ့ပြီး (detach) နောက်ပိုင်းမှ ပြန်လည် ချိတ်ဆက် (reattach) စေနိုင်ပါသည်။
ဤသည်မှာ အဝေးရှိ Remote Machine များနှင့် အလုပ်လုပ်ရာတွင် `nohup` ကဲ့သို့သော လှည့်ကွက်များကို အသုံးပြုစရာ မလိုဘဲ သင်၏ လုပ်ငန်းစဉ်ကို ပိုမို ချောမွေ့ စနစ်ကျစေပါသည်။

ယနေ့ခေတ်တွင် ရေပန်းအစားဆုံး Terminal Multiplexer မှာ [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) ဖြစ်ပါသည်။ `tmux` သည် စိတ်ကြိုက် ပြင်ဆင်ဖန်တီးနိုင်စွမ်း မြင့်မားပြီး ၎င်း၏ Keybindings များကို အသုံးပြု၍ Tabs များနှင့် Panes များကို ဖန်တီးကာ လျင်မြန်စွာ ကူးပြောင်း အသုံးပြုနိုင်ပါသည်။

`tmux` ကို အသုံးပြုရန် ၎င်း၏ Keybinding များကို သိရှိထားရန် လိုအပ်ပါသည်။ Keybinding အားလုံးသည် `<C-b> x` ဟူသော ပုံစံမျိုး ရှိပြီး ယင်း၏ အဓိပ္ပာယ်မှာ (၁) `Ctrl+b` ကို နှိပ်ပါ၊ (၂) `Ctrl+b` ကို ပြန်လွှတ်ပါ၊ ထို့နောက် (၃) `x` ကို နှိပ်ပါ ဟု ဖြစ်ပါသည်။ `tmux` တွင် အောက်ပါ Object အဆင့်ဆင့် ရှိပါသည် -

- **Sessions** - Session ဆိုသည်မှာ Window တစ်ခု သို့မဟုတ် တစ်ခုထက်မက ပါဝင်သော သီးခြား စာပွဲပြင် (workspace) ဖြစ်သည်။
    + `tmux` ဟု ရိုက်နှိပ်ပါက Session အသစ်တစ်ခု စတင်မည်။
    + `tmux new -s NAME` ဟု ရိုက်နှိပ်ပါက အမည်သတ်မှတ်၍ Session စတင်မည်။
    + `tmux ls` သည် လက်ရှိ Session များကို စာရင်းပြပေးမည်။
    + `tmux` အတွင်း၌ `<C-b> d` ကို နှိပ်ပါက လက်ရှိ Session မှ ခေတ္တ ထွက်မည် (detach)။
    + `tmux a` သည် နောက်ဆုံး Session သို့ ပြန်လည် ချိတ်ဆက်မည် (attach)။ သီးခြား Session ကို ညွှန်းလိုပါက `-t` flag ကို အသုံးပြုနိုင်သည်။

- **Windows** - Browser သို့မဟုတ် Editor များမှ Tabs များနှင့် တူညီပြီး၊ Session တစ်ခုတည်း၏ သီးခြား မြင်ကွင်း အပိုင်းအစများ ဖြစ်ကြသည်။
    + `<C-b> c` သည် Window အသစ်တစ်ခု ဖန်တီးမည်။ Window ကို ပိတ်လိုပါက `<C-d>` နှိပ်၍ Shell ကို ပိတ်လိုက်ရုံ ဖြစ်သည်။
    + `<C-b> N` သည် _N_ မြောက် Window သို့ သွားမည်။ (Window များကို နံပါတ်စဉ် တပ်ထားသည်)
    + `<C-b> p` သည် ယခင် Window သို့ သွားမည်။
    + `<C-b> n` သည် နောက် Window သို့ သွားမည်။
    + `<C-b> ,` သည် လက်ရှိ Window ၏ အမည်ကို ပြောင်းလဲမည်။
    + `<C-b> w` သည် လက်ရှိ Window များကို စာရင်းပြပေးမည်။

- **Panes** - Vim splits များနှင့် တူညီပြီး Screen တစ်ခုတည်းတွင် Shell အများအပြားကို ဘေးချင်းယှဉ်၍ ကြည့်ရှုနိုင်စေသည်။
    + `<C-b> "` သည် လက်ရှိ Pane ကို အလျားလိုက် (horizontal) ခွဲခြားမည်။
    + `<C-b> %` သည် လက်ရှိ Pane ကို ဒေါင်လိုက် (vertical) ခွဲခြားမည်။
    + `<C-b> <direction>` သည် သတ်မှတ်ထားသော _direction_ (မြားခလုတ်များ) အတိုင်း အခြား Pane သို့ ရွှေ့ပြောင်းမည်။
    + `<C-b> z` သည် လက်ရှိ Pane ကို မျက်နှာပြင်ပြည့် (zoom) ချဲ့မည် သို့မဟုတ် မူလအတိုင်း ပြန်လုပ်မည်။
    + `<C-b> [` သည် Scrollback mode သို့ ဝင်မည်။ ထို့နောက် `<space>` နှိပ်၍ highlight လုပ်ပြီး `<enter>` နှိပ်၍ copy ကူးနိုင်သည်။
    + `<C-b> <space>` သည် Pane ၏ အခင်းအကျင်း ပုံစံများကို အစဉ်လိုက် ပြောင်းလဲပေးမည်။

ပိုမို လေ့လာလိုပါက၊ [`tmux` အကြောင်း အတိုချုပ် သင်ခန်းစာ](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) နှင့် မူလ `screen` command အကြောင်းပါ အသေးစိတ် ရှင်းပြထားသည့် [ဤသင်ခန်းစာ](https://linuxcommand.org/lc3_adv_termmux.php) တို့ကို ဖတ်ရှုနိုင်ပါသည်။ ထို့အပြင် UNIX စနစ်အများစုတွင် မူလပါဝင်လေ့ရှိသည့် [`screen`](https://www.man7.org/linux/man-pages/man1/screen.1.html) အကြောင်းကိုလည်း လေ့လာထားသင့်ပါသည်။


# Aliases

အလွန်ရှည်လျားသော Command များ သို့မဟုတ် Flag များစွာ ပါဝင်သော Command များကို မကြာခဏ ရိုက်နှိပ်ရခြင်းသည် စိတ်ပျက်ဖွယ် ကောင်းလှပါသည်။
ထို့ကြောင့် Shell အများစုသည် _Aliasing_ (အမည်တို သတ်မှတ်ခြင်း) ကို ထောက်ပံ့ပေးထားကြပါသည်။
Shell Alias ဆိုသည်မှာ ရှည်လျားသော Command တစ်ခုအတွက် သင်၏ Shell က အလိုအလျောက် အစားထိုးပေးမည့် အမည်တို (shorthand) တစ်ခု ဖြစ်ပါသည်။
ဥပမာအားဖြင့် Bash တွင် Alias တစ်ခု၏ ပုံစံမှာ အောက်ပါအတိုင်း ဖြစ်ပါသည် -

```bash
alias alias_name="command_to_alias arg1 arg2"
```

သတိပြုရန်မှာ ညီမျှခြင်း `=` ဘေးတွင် Space မပါရပါ၊ အကြောင်းမှာ [`alias`](https://www.man7.org/linux/man-pages/man1/alias.1p.html) သည် Argument တစ်ခုတည်းသာ လက်ခံသည့် Shell Command တစ်ခုဖြစ်သော ကြောင့် ဖြစ်ပါသည်။

Alias များတွင် အသုံးဝင်သော အင်္ဂါရပ်များစွာ ရှိပါသည် -

```bash
# အသုံးများသော Flag များအတွက် အမည်တို သတ်မှတ်ခြင်း
alias ll="ls -lh"

# မကြာခဏ ရိုက်ရသော Command များအတွက် အချိန်ကုန် သက်သာစေခြင်း
alias gs="git status"
alias gc="git commit"
alias v="vim"

# စာလုံးမှား ရိုက်မိခြင်းကို ကာကွယ်ပေးခြင်း
alias sl=ls

# မူလ Command များကို ပိုမိုကောင်းမွန်သော အမူအကျင့်များဖြင့် အစားထိုးခြင်း
alias mv="mv -i"           # -i သည် ထပ်ရေးမည်လားဟု မေးမြန်းမည်
alias mkdir="mkdir -p"     # -p သည် လိုအပ်သော parent directory များကို ဖန်တီးပေးမည်
alias df="df -h"           # -h သည် လူနားလည်လွယ်သော ဖိုင်ဆိုဒ် ပုံစံဖြင့် ပြပေးမည်

# Alias များကို တွဲဖက် အသုံးပြုခြင်း
alias la="ls -A"
alias lla="la -l"

# Alias ကို ကျော်လွန်၍ မူလ Command ကို ရန်းလိုပါက ရှေ့တွင် \ ထည့်ပါ
\ls
# သို့မဟုတ် unalias ဖြင့် Alias ကို လုံးဝ ပယ်ဖျက်ပါ
unalias la

# Alias ၏ အဓိပ္ပာယ်သတ်မှတ်ချက်ကို ကြည့်လိုပါက alias command ဖြင့် ခေါ်ပါ
alias ll
# ll='ls -lh' ဟု ထွက်ပေါ်လာမည်
```

သတိပြုရန်မှာ Alias များသည် မူလအားဖြင့် Session ပိတ်လိုက်ပါက ပျောက်ပျက်သွားမည် ဖြစ်သည်။
Alias များကို အမြဲတမ်း တည်တံ့စေရန်အတွက် `.bashrc` သို့မဟုတ် `.zshrc` ကဲ့သို့သော Shell Startup Files များတွင် ထည့်သွင်းထားရမည် ဖြစ်ပါသည်။


# Dotfiles

ပရိုဂရမ် အမြောက်အမြားကို _Dotfiles_ ဟု ခေါ်ဆိုကြသည့် Plain-text ဖိုင်များဖြင့် Configuration ပြုလုပ်ကြပါသည် (ဖိုင်အမည်များသည် `.` ဖြင့် စတင်လေ့ရှိသောကြောင့် ဖြစ်သည်၊ ဥပမာ `~/.vimrc`၊ ထို့ကြောင့် ယင်းတို့သည် `ls` ရိုက်သည့်အခါ မူလအားဖြင့် ပုန်းကွယ်နေကြသည်)။

Shell များသည် ထိုကဲ့သို့သော ဖိုင်များဖြင့် Configuration ပြုလုပ်ရသည့် ပရိုဂရမ်များ၏ ဥပမာတစ်ခု ဖြစ်ပါသည်။ Shell စတင်ချိန်တွင် ယင်း၏ Configuration များကို ရယူရန် ဖိုင်များစွာကို ဖတ်ရှုပါသည်။
Shell အမျိုးအစားပေါ် မူတည်၍၊ Login မုဒ် သို့မဟုတ် Interactive မုဒ် အပေါ် မူတည်၍ ဤ လုပ်ငန်းစဉ်တစ်ခုလုံးသည် အတော်အတန် ရှုပ်ထွေးနိုင်ပါသည်။
ဤခေါင်းစဉ်နှင့် ပတ်သက်၍ အလွန်ကောင်းမွန်သော ဆောင်းပါးကို [ဒီမှာ](https://web.archive.org/web/20260329133158/https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) ဖတ်ရှုနိုင်ပါသည်။

`bash` အတွက်ဆိုလျှင် သင်၏ `.bashrc` သို့မဟုတ် `.bash_profile` ကို ပြင်ဆင်ခြင်းသည် စနစ်အများစုတွင် အဆင်ပြေပါသည်။
ဤနေရာတွင် ခုနက ဖော်ပြခဲ့သော Alias များ သို့မဟုတ် သင်၏ `PATH` Environment Variable ကို ပြင်ဆင်ခြင်းကဲ့သို့သော Shell စတင်ချိန်တွင် ရန်းလိုသည့် Command များကို ထည့်သွင်းနိုင်ပါသည်။
အမှန်စင်စစ် ပရိုဂရမ်များစွာသည် ယင်းတို့၏ Binary ဖိုင်များကို ရှာဖွေတွေ့ရှိနိုင်စေရန်အတွက် `export PATH="$PATH:/path/to/program/bin"` ကဲ့သို့သော လိုင်းတစ်ခုကို သင်၏ Shell Configuration ဖိုင်တွင် ထည့်သွင်းခိုင်းလေ့ ရှိကြပါသည်။

Dotfile များဖြင့် ပြင်ဆင်သတ်မှတ်နိုင်သော အခြား Tool အချို့၏ ဥပမာများမှာ -

- `bash` - `~/.bashrc`, `~/.bash_profile`
- `git` - `~/.gitconfig`
- `vim` - `~/.vimrc` နှင့် `~/.vim` folder
- `ssh` - `~/.ssh/config`
- `tmux` - `~/.tmux.conf`

သင်၏ Dotfile များကို မည်သို့ စနစ်တကျ စီမံခန့်ခွဲသင့်သနည်း။ ယင်းတို့ကို သီးခြား Folder တစ်ခုထဲတွင် ထားရှိပြီး Version Control (Git) ဖြင့် ထိန်းသိမ်းကာ Script များကို အသုံးပြု၍ **Symlink** ချိတ်ဆက် ထားသင့်ပါသည်။ ဤသို့ ပြုလုပ်ခြင်းဖြင့် အောက်ပါ အကျိုးကျေးဇူးများ ရရှိနိုင်ပါသည်။

- **တပ်ဆင်ရ လွယ်ကူခြင်း**: စက်အသစ်တစ်လုံးသို့ ဝင်ရောက်သည့်အခါ သင်၏ စိတ်ကြိုက် Setting များကို တပ်ဆင်ရန် မိနစ်ပိုင်းမျှသာ ကြာမြင့်မည်။
- **သယ်ဆောင်ရ လွယ်ကူခြင်း**: သင်၏ Tool များသည် မည်သည့်နေရာတွင်မဆို တူညီစွာ အလုပ်လုပ်မည်။
- **ဟန်ချက်ညီ တူညီစေခြင်း**: မည်သည့်နေရာမှမဆို Dotfile များကို အပ်ဒိတ်လုပ်နိုင်ပြီး အားလုံးကို တူညီအောင် ထိန်းသိမ်းနိုင်မည်။
- **အပြောင်းအလဲများကို အမှတ်အသားပြုနိုင်ခြင်း**: Dotfile များကို သင်၏ ကွန်ပျူတာ သက်တမ်းတစ်လျှောက် ထိန်းသိမ်းသွားရမည် ဖြစ်ရာ Version History ရှိနေခြင်းသည် ရေရှည်အတွက် အလွန်ကောင်းမွန်ပါသည်။

Dotfile များထဲတွင် ဘာတွေ ထည့်သွင်းသင့်သနည်း။
အွန်လိုင်း Documentation များ သို့မဟုတ် [man pages](https://en.wikipedia.org/wiki/Man_page) များကို ဖတ်ရှုခြင်းဖြင့် သင်၏ Tool Setting များကို လေ့လာနိုင်ပါသည်။ အခြား နည်းလမ်းတစ်ခုမှာ ပရိုဂရမ်တစ်ခုစီအတွက် ရေးသားထားသော Blog Post များကို ရှာဖွေဖတ်ရှုခြင်း ဖြစ်သည်။ ထို့အပြင် အခြားသူများ၏ Dotfile များကို ဝင်ရောက်ကြည့်ရှုခြင်းဖြင့်လည်း သင်ယူနိုင်ပါသည် - GitHub တွင် [Dotfiles Repositories](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories) ပေါင်းများစွာကို ရှာဖွေတွေ့ရှိနိုင်ပါသည် --- အသုံးအများဆုံး ရေပန်းစားလှသော repo ကို [ဒီမှာ](https://github.com/mathiasbynens/dotfiles) ကြည့်ရှုနိုင်ပါသည် (သို့သော် ကူးယူဖတ်ရှုရာတွင် မစိစစ်ဘဲ ကူးယူခြင်းမပြုရန် အကြံပြုပါသည်)။
[ဤနေရာတွင်လည်း](https://dotfiles.github.io/) အသုံးဝင်သော အချက်အလက်များကို လေ့လာနိုင်ပါသည်။

ဤသင်ခန်းစာ၏ ဆရာများ အားလုံးသည် ယင်းတို့၏ Dotfile များကို GitHub တွင် အများပြည်သူ ကြည့်ရှုနိုင်ရန် တင်ပေးထားကြပါသည် - [Anish](https://github.com/anishathalye/dotfiles), [Jon](https://github.com/jonhoo/configs), [Jose](https://github.com/jjgo/dotfiles)။


## Portability

Dotfile များ အသုံးပြုရာတွင် ကြုံတွေ့ရလေ့ရှိသော အခက်အခဲတစ်ခုမှာ စက်အများအပြားတွင် အလုပ်လုပ်သည့်အခါ (ဥပမာ- Operating System သို့မဟုတ် Shell ကွဲပြားနေခြင်း) Setting များ အဆင်မပြေဖြစ်ခြင်း ဖြစ်သည်။ အချို့သော Setting များကို သီးခြား စက်တစ်ခုထဲတွင်သာ အသုံးပြုချင်သည့် အခါမျိုးလည်း ရှိတတ်ပါသည်။

ဤကိစ္စအတွက် လွယ်ကူစေမည့် လှည့်ကွက်အချို့ ရှိပါသည်။
Configuration ဖိုင်က ထောက်ပံ့ပေးပါက သီးခြား စက်များအတွက် if-statement များနှင့် တူညီသော Logic များကို အသုံးပြုနိုင်ပါသည်။ ဥပမာအားဖြင့် သင်၏ Shell တွင် အောက်ပါအတိုင်း ရေးသားနိုင်ပါသည်။

```bash
if [[ "$(uname)" == "Linux" ]]; then {do_something}; fi

# Shell သီးခြား အင်္ဂါရပ်များကို မသုံးမီ စစ်ဆေးခြင်း
if [[ "$SHELL" == "zsh" ]]; then {do_something}; fi

# သီးခြား စက်အမည် (hostname) အတွက် စစ်ဆေးခြင်း
if [[ "$(hostname)" == "myServer" ]]; then {do_something}; fi
```

Configuration ဖိုင်က ထောက်ပံ့ပေးပါက include များကို အသုံးပြုပါ။ ဥပမာအားဖြင့် `~/.gitconfig` တွင် အောက်ပါ Setting ကို ထည့်သွင်းနိုင်ပါသည်။

```
[include]
    path = ~/.gitconfig_local
```

ထို့နောက် စက်တစ်ခုစီတွင် `~/.gitconfig_local` ဖိုင်ထဲ၌ ထိုစက်အတွက် သီးသန့် Setting များကို ထည့်သွင်းထားနိုင်ပါသည်။ ထို သီးသန့် Setting များကို Repository သီးခြား တစ်ခုဖြင့်ပင် ထိန်းသိမ်းထားနိုင်ပါသည်။

ဤအယူအဆသည် ပရိုဂရမ် ကွဲပြားသော်လည်း Setting အချို့ကို မျှဝေသုံးစွဲလိုသည့် အခါတွင်လည်း အသုံးဝင်ပါသည်။ ဥပမာအားဖြင့် `bash` နှင့် `zsh` နှစ်ခုစလုံးတွင် Alias စာရင်း တစ်ခုတည်းကို မျှဝေသုံးလိုပါက ယင်းတို့ကို `.aliases` ဖိုင်ထဲတွင် ရေးသားပြီး ဖိုင်နှစ်ခုစလုံး၌ အောက်ပါ Block ကို ထည့်သွင်းထားနိုင်ပါသည်။

```bash
# ~/.aliases ဖိုင် ရှိမရှိ စစ်ဆေးပြီး ရှိပါက လုဒ်ဆွဲယူပါ
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi
```


# Remote Machines

Programmer များအနေဖြင့် နေ့စဉ် အလုပ်ခွင်တွင် Remote Server များကို အသုံးပြုလာကြသည်မှာ ပိုမို များပြားလာခဲ့ပါသည်။ Backend Software များကို တပ်ဆင်ရန် သို့မဟုတ် ပိုမို မြင့်မားသော တွက်ချက်မှု စွမ်းရည် (computation capacity) လိုအပ်သည့်အခါမျိုးတွင် Remote Server များကို အသုံးပြုရန် Secure Shell (SSH) ကို အသုံးပြုရမည် ဖြစ်ပါသည်။ အခြားသော Tool များကဲ့သို့ပင် SSH သည် စိတ်ကြိုက် ပြင်ဆင်နိုင်စွမ်း မြင့်မားသဖြင့် လေ့လာထားရန် အလွန် တန်ဖိုးရှိပါသည်။

Server တစ်ခုသို့ `ssh` ဝင်ရောက်ရန်အတွက် အောက်ပါအတိုင်း Command ကို ရန်းရပါမည် -

```bash
ssh foo@bar.mit.edu
```

ဤနေရာတွင် ကျွန်ုပ်တို့သည် `bar.mit.edu` ဟူသော Server အောက်ရှိ User `foo` အဖြစ် ssh ဝင်ရန် ကြိုးစားနေခြင်း ဖြစ်သည်။
Server အမည်ကို URL (ဥပမာ `bar.mit.edu`) သို့မဟုတ် IP address (ဥပမာ `foobar@192.168.1.42`) ဖြင့် သတ်မှတ်နိုင်ပါသည်။ နောက်ပိုင်းတွင် SSH Config ဖိုင်ကို ပြင်ဆင်လိုက်ပါက `ssh bar` ဟု ရိုက်ရုံဖြင့် ဝင်ရောက်နိုင်သည်ကို တွေ့မြင်ရပါမည်။

## Executing commands

မကြာခဏ သတိမမူမိကြသည့် SSH ၏ အင်္ဂါရပ်တစ်ခုမှာ Command များကို တိုက်ရိုက် ရန်းနိုင်သည့် စွမ်းရည် ဖြစ်ပါသည်။
`ssh foobar@server ls` ဟု ရိုက်ပါက foobar ၏ home folder အတွင်း၌ `ls` ကို ရန်းသွားမည် ဖြစ်သည်။
၎င်းသည် Pipe များနှင့်လည်း အလုပ်လုပ်နိုင်ပါသည်၊ ထို့ကြောင့် `ssh foobar@server ls | grep PATTERN` သည် Remote ဘက်မှ `ls` output ကို Local ဘက်တွင် `grep` စစ်ပေးမည် ဖြစ်ပြီး `ls | ssh foobar@server grep PATTERN` သည် Local ဘက်မှ output ကို Remote ဘက်သို့ ပေးပို့၍ `grep` စစ်ပေးမည် ဖြစ်သည်။


## SSH Keys

Key ကို အခြေခံသော Authentication သည် Public-key Cryptography ကို အသုံးပြု၍ Server သို့ ဝင်ရောက်ရာတွင် Private Key ကို အပြင်သို့ ထုတ်မပြဘဲ Client ၌ သီးသန့် Private Key ရှိကြောင်း သက်သေပြပါသည်။ ဤနည်းဖြင့် လော့ဂ်အင် ဝင်တိုင်း စကားဝှက် (password) ကို ထပ်ခါတလဲလဲ ရိုက်နှိပ်စရာ မလိုတော့ပါ။ သို့သော် Private Key (အများအားဖြင့် `~/.ssh/id_rsa` သို့မဟုတ် နောက်ပိုင်းတွင် `~/.ssh/id_ed25519`) သည် သင်၏ Password ကဲ့သို့ပင် အရေးကြီးသဖြင့် သေချာစွာ ထိန်းသိမ်းပါ။

### Key generation

Key အစုံ (pair) ကို ထုတ်ယူရန် [`ssh-keygen`](https://www.man7.org/linux/man-pages/man1/ssh-keygen.1.html) ကို ရန်းနိုင်ပါသည်။
```bash
ssh-keygen -a 100 -t ed25519 -f ~/.ssh/id_ed25519
```
Private Key ကို အခြားသူများ ရရှိသွားပါက Server များကို မသမာဝင်ရောက်ခြင်းမှ ကာကွယ်ရန် Passphrase တစ်ခု သတ်မှတ်ထားသင့်ပါသည်။ Passphrase ကို အကြိမ်ကြိမ် ရိုက်မနေစေရန် [`ssh-agent`](https://www.man7.org/linux/man-pages/man1/ssh-agent.1.html) သို့မဟုတ် [`gpg-agent`](https://linux.die.net/man/1/gpg-agent) ကို အသုံးပြုနိုင်ပါသည်။

GitHub သို့ SSH Key အသုံးပြု၍ Push လုပ်ရန် ပြင်ဆင်ဖူးပါက [ဒီနေရာတွင်](https://help.github.com/articles/connecting-to-github-with-ssh/) ဖော်ပြထားသော အဆင့်များကို လုပ်ဆောင်ဖူးမည် ဖြစ်ပြီး Key pair ရှိပြီးသား ဖြစ်နိုင်ပါသည်။ Passphrase ပါမပါ စစ်ဆေးရန်နှင့် စိစစ်ရန်အတွက် `ssh-keygen -y -f /path/to/key` ကို ရန်းနိုင်ပါသည်။

### Key based authentication

`ssh` သည် မည်သည့် Client များကို ဝင်ရောက်ခွင့်ပြုရမည်ကို ဆုံးဖြတ်ရန် `.ssh/authorized_keys` ဖိုင်ကို စစ်ဆေးပါသည်။ Public Key ကို Remote စက်သို့ ကူးယူရန် အောက်ပါ Command ကို အသုံးပြုနိုင်ပါသည် -

```bash
ssh-copy-id -i .ssh/id_ed25519 foobar@remote
```

သို့မဟုတ် အခြေခံ နည်းလမ်းအားဖြင့် -

```bash
cat .ssh/id_ed25519.pub | ssh foobar@remote 'cat >> ~/.ssh/authorized_keys'
```

## Copying files over SSH

SSH မှတဆင့် ဖိုင်များကို ကူးယူနိုင်သည့် နည်းလမ်းများစွာ ရှိပါသည် -

- `ssh+tee` - အလွယ်ကူဆုံးမှာ SSH command execution နှင့် STDIN input တို့ကို တွဲဖက်၍ `cat localfile | ssh remote_server tee serverfile` ဟု ပြုလုပ်ခြင်း ဖြစ်သည်။ [`tee`](https://www.man7.org/linux/man-pages/man1/tee.1.html) သည် STDIN မှ လာသော Output များကို ဖိုင်ထဲသို့ ရေးသားပေးကြောင်း သတိရပါ။
- [`scp`](https://www.man7.org/linux/man-pages/man1/scp.1.html) - ဖိုင် သို့မဟုတ် Directory အမြောက်အမြားကို ကူးယူသည့်အခါ Secure Copy `scp` Command သည် လမ်းကြောင်း အဆင့်ဆင့်ကို လွယ်ကူစွာ ကူးယူနိုင်သဖြင့် ပိုမို အဆင်ပြေပါသည်။ Syntax မှာ `scp path/to/local_file remote_host:path/to/remote_file` ဖြစ်ပါသည်။
- [`rsync`](https://www.man7.org/linux/man-pages/man1/rsync.1.html) - `rsync` သည် Local နှင့် Remote ကြား တူညီသော ဖိုင်များကို စစ်ဆေးတွေ့ရှိနိုင်ပြီး ထပ်မံ ကူးယူခြင်းကို တားဆီးပေးသဖြင့် `scp` ထက် ပိုမို ကောင်းမွန်ပါသည်။ ထို့အပြင် Symlinks၊ Permissions များကို ပိုမို အသေးစိတ် စီမံနိုင်ပြီး မပြီးသေးသော ကူးယူမှုများကို ပြန်လည် စတင်နိုင်သည့် `--partial` flag ကဲ့သို့သော အင်္ဂါရပ်များ ပါဝင်သည်။ `rsync` ၏ Syntax မှာ `scp` နှင့် ဆင်တူပါသည်။

## Port Forwarding

အခြေအနေများစွာတွင် စက်၏ သီးခြား Port များကို နားထောင်နေသော (listening) Software များနှင့် ကြုံတွေ့ရတတ်ပါသည်။ Local စက်တွင်ဆိုလျှင် `localhost:PORT` သို့မဟုတ် `127.0.0.1:PORT` ဟု ရိုက်နှိပ်နိုင်သော်လည်း Port များကို Network/Internet မှ တိုက်ရိုက် ဝင်ရောက်၍ မရသော Remote Server တွင် မည်သို့ ပြုလုပ်မည်နည်း။

ဤသည်ကို _Port Forwarding_ ဟု ခေါ်ဆိုပြီး မုဒ်နှစ်မျိုး ရှိပါသည် - Local Port Forwarding နှင့် Remote Port Forwarding (အသေးစိတ်ကို ပုံများတွင် ကြည့်ပါ၊ ပုံများ၏ မူပိုင်ခွင့်မှာ [ဤ StackOverflow Post](https://unix.stackexchange.com/questions/115897/whats-ssh-port-forwarding-and-whats-the-difference-between-ssh-local-and-remot) မှ ဖြစ်ပါသည်)။

**Local Port Forwarding**
![Local Port Forwarding](/static/media/images/local-port-forwarding.png)

**Remote Port Forwarding**
![Remote Port Forwarding](/static/media/images/remote-port-forwarding.png)

အတွေ့ရဆုံး အခြေအနေမှာ Remote စက်ရှိ Service ၏ Port ကို Local စက်ရှိ Port နှင့် ချိတ်ဆက်ပေးသော Local Port Forwarding ဖြစ်ပါသည်။ ဥပမာ Remote Server တွင် Port `8888` ကို နားထောင်နေသည့် `jupyter notebook` ကို ရန်းထားသည် ဆိုပါစို့။ ထို Port ကို Local Port `9999` သို့ Forward လုပ်ရန်အတွက် `ssh -L 9999:localhost:8888 foobar@remote_server` ဟု ရန်းပြီး Local စက် Browser တွင် `localhost:9999` သို့ ဝင်ရောက် ကြည့်ရှုနိုင်ပါသည်။


## SSH Configuration

ကျွန်ုပ်တို့သည် ထည့်သွင်းနိုင်သော Argument များစွာကို လေ့လာခဲ့ပြီး ဖြစ်သည်။ ၎င်းအတွက် အလွယ်လမ်းမှာ အောက်ပါအတိုင်း Shell Alias များ ဖန်တီးခြင်း ဖြစ်နိုင်သည် -
```bash
alias my_server="ssh -i ~/.ssh/id_ed25519 --port 2222 -L 9999:localhost:8888 foobar@remote_server"
```

သို့သော် `~/.ssh/config` ဖိုင်ကို အသုံးပြုသည့် ပိုမို ကောင်းမွန်သော နည်းလမ်း ရှိပါသည်။

```bash
Host vm
    User foobar
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
    LocalForward 9999 localhost:8888

# Config များတွင် wildcard များကိုလည်း အသုံးပြုနိုင်သည်
Host *.mit.edu
    User foobaz
```

Alias များထက် `~/.ssh/config` ဖိုင်ကို အသုံးပြုခြင်း၏ အဓိက အားသာချက်မှာ `scp`, `rsync`, `mosh` အစရှိသော အခြား ပရိုဂရမ်များသည်လည်း ဤ Config ကို ဖတ်ရှုနိုင်ပြီး သက်ဆိုင်ရာ Flag များအဖြစ် အလိုအလျောက် ပြောင်းလဲပေးနိုင်ခြင်း ဖြစ်ပါသည်။


သတိပြုရန်မှာ `~/.ssh/config` ဖိုင်ကို Dotfile တစ်ခုအဖြစ် သတ်မှတ်နိုင်ပြီး သင်၏ အခြား Dotfile များနှင့်အတူ သိမ်းဆည်းနိုင်ပါသည်။ သို့သော် ယင်းကို အများပြည်သူသို့ ချပြလိုက်ပါက အင်တာနက်ပေါ်မှ အခြားသူများအား သင်၏ Server လိပ်စာများ၊ User အမည်များ၊ ဖွင့်ထားသော Port များ အစရှိသည်တို့ ပါဝင်သွားနိုင်ပါသည်။ ဤသည်မှာ တိုက်ခိုက်မှုအချို့ကို လွယ်ကူစေနိုင်သဖြင့် SSH Configuration များကို မျှဝေရာတွင် သတိထားပါ။

Server ဘက်ခြမ်း Configuration များကို အများအားဖြင့် `/etc/ssh/sshd_config` တွင် သတ်မှတ်လေ့ရှိသည်။ ဤနေရာတွင် Password authentication ကို ပိတ်ခြင်း၊ SSH Port များကို ပြောင်းလဲခြင်း၊ X11 forwarding ကို ဖွင့်ခြင်း အစရှိသည်တို့ကို ပြုလုပ်နိုင်ပါသည်။

## Miscellaneous

Remote Server သို့ ချိတ်ဆက်ရာတွင် ကြုံတွေ့ရလေ့ရှိသော အခက်အခဲမှာ ကွန်ပျူတာ ပိတ်သွားခြင်း၊ Sleep ဝင်သွားခြင်း သို့မဟုတ် Network ပြောင်းသွားခြင်းတို့ကြောင့် ချိတ်ဆက်မှု ကျသွားခြင်း ဖြစ်သည်။ ထို့အပြင် Lag များသော လိုင်းဖြင့် SSH သုံးရခြင်းမှာ အလွန် စိတ်ပျက်ဖွယ် ကောင်းပါသည်။ [Mosh](https://mosh.org/) (mobile shell) သည် SSH ကို ပိုမို ကောင်းမွန်အောင် ပြုလုပ်ထားပြီး Roaming ချိတ်ဆက်မှုများ၊ လိုင်းခေတ္တ ကျသွားမှုများကို ကြံ့ကြံ့ခံနိုင်ကာ လျင်မြန်သော Local Echo ကို ပေးစွမ်းနိုင်ပါသည်။

အချို့သော အခြေအနေများတွင် Remote Folder ကို Local တွင် Mount လုပ်ထားခြင်းက အဆင်ပြေပါသည်။ [sshfs](https://github.com/libfuse/sshfs) သည် Remote Server ရှိ Folder ကို Local တွင် Mount လုပ်ပေးနိုင်ပြီး Local Editor ဖြင့် တိုက်ရိုက် ပြင်ဆင်နိုင်စေပါသည်။


# Shells & Frameworks

Shell Tool နှင့် Scripting အပိုင်းတွင် အကျယ်ပြန့်ဆုံး သုံးစွဲကြသော `bash` shell အကြောင်းကို လေ့လာခဲ့ကြပါသည်။ သို့သော် ၎င်းတစ်ခုတည်းသာ ရွေးချယ်စရာ ရှိသည် မဟုတ်ပါ။

ဥပမာအားဖြင့် `zsh` shell သည် `bash` ၏ Superset ဖြစ်ပြီး မူလပါဝင်သော အဆင်ပြေသည့် အင်္ဂါရပ်များစွာ ရှိပါသည် -

- ပိုမို စမတ်ကျသော Globbing, `**`
- Inline globbing/wildcard expansion
- စာလုံးပေါင်း အမှား ပြင်ဆင်ပေးခြင်း
- ပိုမိုကောင်းမွန်သော Tab completion/selection
- Path expansion (`cd /u/lo/b` သည် `/usr/local/bin` သို့ တိုးချဲ့သွားမည်)

**Frameworks** များသည်လည်း သင်၏ Shell ကို ပိုမိုကောင်းမွန်စေပါသည်။ ရေပန်းစားသော Framework အချို့မှာ [prezto](https://github.com/sorin-ionescu/prezto) သို့မဟုတ် [oh-my-zsh](https://ohmyz.sh/) တို့ ဖြစ်ကြပြီး၊ သီးခြား အင်္ဂါရပ်များကို အာရုံစိုက်ထားသော [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) သို့မဟုတ် [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) တို့လည်း ရှိကြသည်။ [fish](https://fishshell.com/) ကဲ့သို့သော Shell များတွင် ဤအင်္ဂါရပ် အများအပြား မူလကတည်းက ပါဝင်ပြီးသား ဖြစ်သည်။

- Right prompt
- Command syntax highlighting
- History substring search
- manpage ကို အခြေခံသော flag completion များ
- စမတ်ကျသော autocompletion
- Prompt themes

ဤ Framework များကို အသုံးပြုရာတွင် သတိထားရန်မှာ ယင်းတို့သည် Shell ကို နှေးကွေးသွားစေနိုင်သည်ဟူသော အချက် ဖြစ်သည်။ လိုအပ်ပါက Profile လုပ်ကြည့်ပြီး မကြာခဏ မသုံးသော အင်္ဂါရပ်များကို ပိတ်ထားနိုင်ပါသည်။

# Terminal Emulators

သင်၏ Shell ကို ပြင်ဆင်သတ်မှတ်ခြင်းနှင့်အတူ သင်အသုံးပြုမည့် **Terminal Emulator** နှင့် ယင်း၏ Setting များကို ရွေးချယ်ရန် အချိန်ပေးသင့်ပါသည်။ Terminal Emulator အမျိုးအစားများစွာ ရှိပါသည် ([ဒီမှာ](https://anarc.at/blog/2018-04-12-terminal-emulators-1/) နှိုင်းယှဉ်ချက်ကို ကြည့်နိုင်ပါသည်)။

Terminal တွင် နာရီပေါင်း ရာနှင့်ချီ၍ အချိန်ကုန်ဆုံးရမည် ဖြစ်ရာ Setting များကို လေ့လာ ပြင်ဆင်ခြင်းသည် အလွန် ထိရောက်သော ရင်းနှီးမြှုပ်နှံမှု ဖြစ်ပါသည်။ ပြင်ဆင်နိုင်သော အချက်အချို့မှာ -

- Font ရွေးချယ်မှု
- Color Scheme
- Keyboard shortcuts
- Tab/Pane ထောက်ပံ့မှု
- Scrollback configuration
- Performance ([Alacritty](https://github.com/jwilm/alacritty) သို့မဟုတ် [kitty](https://sw.kovidgoyal.net/kitty/) ကဲ့သို့သော Terminal သစ်များသည် GPU Acceleration ကို ထောက်ပံ့ပေးသည်)

# Exercises

## Job control

1. `ps aux | grep` command များကို အသုံးပြု၍ Job PID များကို ရယူပြီး ပိတ်ပစ်နိုင်သော်လည်း ပိုမို ကောင်းမွန်သော နည်းလမ်းများ ရှိပါသည်။ Terminal တွင် `sleep 10000` ကို စတင် ရန်းပါ၊ `Ctrl-Z` ဖြင့် Background သို့ ပို့ပြီး `bg` ဖြင့် ဆက်လက် ရန်းပါ။ ယခု [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) ကို အသုံးပြု၍ PID ကို ရှာပါ၊ ထို့နောက် PID ကို ကိုယ်တိုင် မရိုက်ရဘဲ [`pkill`](https://man7.org/linux/man-pages/man1/pgrep.1.html) ဖြင့် ပိတ်ပစ်ပါ။ (အချက်အလက်- `-af` flag များကို အသုံးပြုပါ)။

1. Process တစ်ခု မပြီးမချင်း နောက် Process တစ်ခုကို မစတင်ချင်ဟု ဆိုပါစို့။ မည်သို့ ပြုလုပ်မည်နည်း။ ဤ လေ့ကျင့်ခန်းတွင် `sleep 60 &` ကို စောင့်ဆိုင်းမည့် Process အဖြစ် အသုံးပြုပါမည်။
အသုံးပြုနိုင်သော နည်းလမ်းတစ်ခုမှာ [`wait`](https://www.man7.org/linux/man-pages/man1/wait.1p.html) Command ကို အသုံးပြုခြင်း ဖြစ်သည်။ sleep command ကို ရန်းပြီး background process မပြီးမချင်း `ls` က စောင့်ဆိုင်းနေအောင် ပြုလုပ်ပါ။

    သို့သော် ဤနည်းလမ်းသည် အခြား bash session မှ စတင်ပါက အဆင်မပြေပါ၊ အကြောင်းမှာ `wait` သည် child process များအတွက်သာ အလုပ်လုပ်သောကြောင့် ဖြစ်သည်။ `kill` command ၏ exit status သည် အောင်မြင်ပါက zero ဖြစ်ပြီး မအောင်မြင်ပါက nonzero ဖြစ်ပါသည်။ `kill -0` သည် signal မပို့သော်လည်း process မရှိပါက nonzero exit status ပေးမည် ဖြစ်သည်။
    PID တစ်ခုကို လက်ခံပြီး ထို process မပြီးမချင်း စောင့်ဆိုင်းပေးမည့် `pidwait` ဟုခေါ်သော bash function တစ်ခု ရေးပါ။ CPU အလဟဿ မဖြစ်စေရန် `sleep` ကို အသုံးပြုပါ။

## Terminal multiplexer

1. ဤ `tmux` [သင်ခန်းစာ](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) ကို လေ့လာပြီး [ဤအဆင့်များ](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/) အတိုင်း စိတ်ကြိုက် ပြင်ဆင်နည်းကို လေ့လာပါ။

## Aliases

1. စာလုံးပေါင်း မှားရိုက်မိသည့်အခါ `cd` သို့ ရောက်ရှိသွားစေရန် `dc` ဟူသော Alias တစ်ခု ဖန်တီးပါ။

1. `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10` ကို ရန်း၍ အသုံးအများဆုံး Command ၁၀ ခုကို ရယူပြီး ယင်းတို့အတွက် အမည်တို Alias များ ရေးသားပါ။ (သတိပြုရန်- ဤသည်မှာ Bash အတွက် ဖြစ်သည်၊ ZSH သုံးပါက `history` အစား `history 1` ဟု သုံးပါ)။


## Dotfiles

Dotfiles များ ပြင်ဆင်ကြပါစို့။
1. သင်၏ Dotfiles အတွက် Folder တစ်ခု ဖန်တီးပြီး Version Control (Git) ပြုလုပ်ပါ။
1. ပရိုဂရမ် အနည်းဆုံး တစ်ခု (ဥပမာ- သင်၏ Shell) အတွက် Customization ဖိုင် ထည့်သွင်းပါ (စတင်ရန်အတွက် `$PS1` ကို သတ်မှတ်၍ Prompt ပြင်ဆင်ခြင်းကဲ့သို့ လွယ်ကူသော အရာ ဖြစ်နိုင်ပါသည်။)
1. စက်အသစ်တွင် Dotfiles များကို မြန်ဆန်စွာ တပ်ဆင်နိုင်မည့် နည်းလမ်းကို ပြင်ဆင်ပါ။ (ဖိုင်တစ်ခုစီအတွက် `ln -s` ခေါ်ပေးသည့် Shell script သို့မဟုတ် [အထူးပြု Utility](https://dotfiles.github.io/utilities/) ကို အသုံးပြုနိုင်သည်)။
1. သင်၏ တပ်ဆင်မှု Script ကို Virtual Machine အသစ်တစ်ခုတွင် စမ်းသပ်ပါ။
1. လက်ရှိ Tool Configuration အားလုံးကို သင်၏ Dotfiles repository သို့ ပြောင်းရွှေ့ပါ။
1. သင်၏ Dotfiles များကို GitHub တွင် လွှင့်တင်ပါ။

## Remote Machines

ဤလေ့ကျင့်ခန်းအတွက် Linux Virtual Machine တစ်ခု တပ်ဆင်ပါ (သို့မဟုတ် ရှိပြီးသားကို သုံးပါ)။ VM များ အကြောင်း မသိပါက [ဤသင်ခန်းစာ](https://hibbard.eu/install-ubuntu-virtual-box/) ကို ကြည့်ပါ။

1. `~/.ssh/` သို့ သွားပြီး SSH key pair ရှိမရှိ စစ်ဆေးပါ။ မရှိပါက `ssh-keygen -a 100 -t ed25519` ဖြင့် ထုတ်ယူပါ။ Password နှင့် `ssh-agent` အသုံးပြုရန် အကြံပြုပါသည် ([ဒီမှာ](https://www.ssh.com/ssh/agent) ပိုမို ကြည့်နိုင်ပါသည်)။
1. `.ssh/config` တွင် အောက်ပါအတိုင်း ထည့်သွင်းပါ -

    ```bash
    Host vm
        User username_goes_here
        HostName ip_goes_here
        IdentityFile ~/.ssh/id_ed25519
        LocalForward 9999 localhost:8888
    ```
1. `ssh-copy-id vm` ကို အသုံးပြု၍ Server သို့ SSH key ကူးယူပါ။
1. VM တွင် `python -m http.server 8888` ကို ရန်း၍ Web server စတင်ပါ။ မိမိစက်မှ `http://localhost:9999` သို့ ဝင်ရောက်၍ VM Web server ကို ကြည့်ပါ။
1. `sudo vim /etc/ssh/sshd_config` ကို ပြုလုပ်၍ `PasswordAuthentication` တန်ဖိုးကို ပြောင်းလဲကာ Password Authentication ကို ပိတ်ပါ။ `PermitRootLogin` တန်ဖိုးကို ပြောင်း၍ Root Login ကို ပိတ်ပါ။ `sudo service sshd restart` ဖြင့် SSH Service ကို ပြန်စပါ။ SSH ပြန်ဝင်ကြည့်ပါ။
1. (စိန်ခေါ်မှု) VM တွင် [`mosh`](https://mosh.org/) တပ်ဆင်ပြီး ချိတ်ဆက်ပါ။ ထို့နောက် Server/VM ၏ Network adapter ကို ဖြုတ်လိုက်ပါ။ Mosh သည် ယင်းမှ အဆင်ပြေစွာ ပြန်လည် ချိတ်ဆက်နိုင်ပါသလား။
1. (စိန်ခေါ်မှု) SSH တွင် `-N` နှင့် `-f` flag များ အလုပ်လုပ်ပုံကို လေ့လာပြီး Background Port Forwarding ပြုလုပ်နိုင်သော Command ကို ရှာဖွေပါ။
