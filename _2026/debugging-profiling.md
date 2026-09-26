---
layout: lecture
title: "Debugging နှင့် Profiling"
description: >
  Logging နှင့် Debugger များကို အသုံးပြု၍ ပရိုဂရမ်များရှိ အမှားများကို ရှာဖွေပြင်ဆင်နည်း (debug လုပ်နည်း) နှင့် စွမ်းဆောင်ရည်မြှင့်တင်ရန်အတွက် ကုတ်များ၏ အလုပ်လုပ်ပုံကို တိုင်းတာစစ်ဆေးနည်း (profile လုပ်နည်း) တို့ကို လေ့လာသွားရမည် ဖြစ်သည်။
thumbnail: /static/assets/thumbnails/2026/lec4.png
date: 2026-01-15
ready: true
panopto: "https://mit.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=a72c48e3-5eb2-46fa-aa03-b3b700e1ca8d"
video:
  aspect: 56.25
  id: 8VYT9TcUmKs
---

ပရိုဂရမ်းမင်းတွင် ရွှေရောင်စည်းမျဉ်းတစ်ခု ရှိသည် - ကုတ်သည် သင်ဖြစ်စေချင်သည့်အတိုင်း အလုပ်လုပ်သည် မဟုတ်ဘဲ သင်ခိုင်းသည့်အတိုင်းသာ အလုပ်လုပ်သည်။ ထိုကွာဟချက်ကို ပေါင်းကူးပေးရန်မှာ အချို့အခါများတွင် တော်တော်ပင် ခက်ခဲသော စိန်ခေါ်မှုတစ်ခု ဖြစ်နိုင်သည်။ ဤပို့ချချက်တွင် အမှားပါနေသော ကုတ်များ (buggy code) နှင့် အရင်းအမြစ်များကို အလွန်အမင်း သုံးစွဲနေသော ကုတ်များ (resource-hungry code) ကို ဖြေရှင်းရာတွင် အသုံးဝင်သည့် နည်းလမ်းများဖြစ်ကြသော Debugging နှင့် Profiling တို့ကို လေ့လာသွားကြမည် ဖြစ်သည်။

# Debugging

## Printf Debugging နှင့် Logging

> "အထိရောက်ဆုံး Debugging Tool မှာ စေ့စပ်သေချာစွာ တွေးတောခြင်းနှင့် သင့်တော်သော နေရာများတွင် သတိထားထည့်သွင်းထားသည့် Print Statement များပင် ဖြစ်သည်" — Brian Kernighan, _Unix for Beginners_။

ပရိုဂရမ်တစ်ခုကို debug လုပ်ရန် ပထမဆုံး နည်းလမ်းမှာ သင်ပြဿနာတွေ့ရှိထားသော နေရာဝန်းကျင်တွင် print statement များကို ထည့်သွင်းပြီး ပြဿနာ၏ အဓိကအကြောင်းအရင်းကို နားလည်နိုင်ရန် လုံလောက်သော အချက်အလက်များ မရမချင်း အကြိမ်ကြိမ် စမ်းသပ်စစ်ဆေးသွားခြင်း ဖြစ်သည်။

ဒုတိယမြောက် နည်းလမ်းမှာ လိုအပ်မှ ချက်ချင်းထည့်ရေးသည့် ad hoc print statement များအစား သင့်ပရိုဂရမ်တွင် logging ကို အသုံးပြုခြင်း ဖြစ်သည်။ Logging ဆိုသည်မှာ အခြေခံအားဖြင့် "ပိုမိုသတိထား၍ print ထုတ်ခြင်း" ဖြစ်ပြီး အောက်ပါတို့ကဲ့သို့သော built-in ပါဝင်မှုများရှိသည့် logging framework တစ်ခုမှတစ်ဆင့် ပြုလုပ်လေ့ရှိသည် -

- log များကို (သို့မဟုတ် log များ၏ အစိတ်အပိုင်းများကို) အခြား output နေရာများသို့ လမ်းကြောင်းပြောင်း ပေးပို့နိုင်ခြင်း၊
- ပြင်းထန်မှုအဆင့်များ (severity levels - INFO, DEBUG, WARN, ERROR စသည်တို့) သတ်မှတ်နိုင်ပြီး ထိုအဆင့်များအတိုင်း output များကို စစ်ထုတ် (filter) နိုင်ခြင်း၊ နှင့်
- log entry များနှင့် သက်ဆိုင်သည့် ဒေတာများကို စနစ်တကျ ရေးသားနိုင်သော structured logging ကို ထောက်ပံ့ပေးခြင်းဖြစ်ပြီး ၎င်းတို့အား နောက်ပိုင်းတွင် ပိုမိုလွယ်ကူစွာ ထုတ်ယူစစ်ဆေးနိုင်ခြင်း။

Logging statement များကို ပရိုဂရမ် ရေးသားနေစဉ် ကတည်းက ကြိုတင်၍ ထည့်သွင်းထားလေ့ရှိသဖြင့် debug လုပ်ရန် လိုအပ်သော ဒေတာများသည် အဆင်သင့် ရှိနှင့်ပြီးသား ဖြစ်နေနိုင်ပေသည်! ထို့အပြင် print statement များကို သုံး၍ ပြဿနာကို ရှာဖွေဖြေရှင်းပြီးသည့်အခါ ထို print များကို ပြန်မဖျက်မီ သင့်တော်သော log statement များအဖြစ် ပြောင်းလဲပေးထားခြင်းသည် ပိုမို ထိရောက်မှု ရှိသည်။ ဤသို့ပြုလုပ်ခြင်းဖြင့် အနာဂတ်တွင် ဆင်တူသော bug များ ထပ်မံပေါ်ပေါက်လာပါက ကုတ်ကို ထပ်မံပြင်ဆင်စရာ မလိုဘဲ လိုအပ်သော ရောဂါရှာဖွေရေး အချက်အလက်များ (diagnostic information) ကို အဆင်သင့် ရရှိနေမည် ဖြစ်သည်။

> **Third-party log များ**- ပရိုဂရမ်အများအပြားသည် ၎င်းတို့ run ချိန်တွင် အချက်အလက်များကို ပိုမိုဖော်ပြရန် `-v` သို့မဟုတ် `--verbose` flag ကို ထောက်ပံ့ပေးထားကြသည်။ ၎င်းသည် ပေးထားသော command တစ်ခု အဘယ်ကြောင့် မအောင်မြင်ရသည်ကို ရှာဖွေရာတွင် အသုံးဝင်သည်။ အချို့ပရိုဂရမ်များတွင် အသေးစိတ်အချက်အလက်များကို ပိုမိုရရှိရန် အဆိုပါ flag ကို အကြိမ်ကြိမ် ထပ်မံထည့်သွင်းခွင့်ပြုသည်။ Service များ (database များ၊ web server များ စသည်) ၏ ပြဿနာများကို debug လုပ်သည့်အခါ ၎င်းတို့၏ log များကို စစ်ဆေးပါ — Linux တွင် လော့ဂ်များကို `/var/log/` ၌ တွေ့ရလေ့ရှိသည်။ systemd service များ၏ log များကို ကြည့်ရှုရန် `journalctl -u <service>` ကို အသုံးပြုပါ။ Third-party library များအတွက် ၎င်းတို့သည် environment variable များ သို့မဟုတ် configuration များမှတစ်ဆင့် debug logging ကို ထောက်ပံ့ပေးခြင်း ရှိမရှိ စစ်ဆေးပါ။

## Debugger များ

Print debugging သည် မည်သည့်အရာကို print ထုတ်ရမည်ကို သင်သိရှိပြီး သင့်ကုတ်ကို လွယ်ကူစွာ ပြင်ဆင်၍ ပြန်လည် run နိုင်သည့်အခါများတွင် ကောင်းစွာ အလုပ်လုပ်သည်။ မည်သည့် အချက်အလက် လိုအပ်သည်ကို သေချာ မသိသေးသည့်အခါ၊ bug သည် ပြန်လည် ဖန်တီးရခက်ခဲသော အခြေအနေများတွင်မှ ပေါ်ပေါက်လာသည့်အခါ သို့မဟုတ် ပရိုဂရမ်ကို ပြင်ဆင်၍ ပြန်လည်စတင်ရန် ကုန်ကျစရိတ် များပြားသည့်အခါများတွင် (စတင်ချိန် ကြာမြင့်ခြင်း၊ ပြန်လည်ဖန်တီးရမည့် ရှုပ်ထွေးသော state များရှိခြင်း စသည်ဖြင့်) Debugger များသည် အလွန်တန်ဖိုးရှိလာသည်။

Debugger ဆိုသည်မှာ ပရိုဂရမ်တစ်ခု အလုပ်လုပ်နေစဉ် ၎င်း၏ လုပ်ဆောင်ချက်များနှင့် တိုက်ရိုက် ထိတွေ့ဆောင်ရွက်နိုင်စေသည့် ပရိုဂရမ်များ ဖြစ်ကြပြီး အောက်ပါတို့အား ပြုလုပ်နိုင်စေသည် -

- သတ်မှတ်ထားသော လိုင်းတစ်ခုသို့ ရောက်ရှိသောအခါ ပရိုဂရမ် လုပ်ဆောင်ချက်ကို ခေတ္တရပ်တန့် (halt) ရန်။
- Instruction တစ်ခုချင်းစီအလိုက် တစ်ဆင့်ပြီးတစ်ဆင့် (step through) လုပ်ဆောင်သွားရန်။
- ပရိုဂရမ် crash ဖြစ်သွားပြီးနောက် variable များ၏ တန်ဖိုးများကို စစ်ဆေးရန်။
- ပေးထားသော အခြေအနေတစ်ခု ကိုက်ညီသည့်အခါ လုပ်ဆောင်ချက်ကို အခြေအနေပေါ်မူတည်၍ ခေတ္တရပ်တန့်ရန်။
- ထို့အပြင် အခြားသော အဆင့်မြင့် feature အများအပြားလည်း ပါဝင်သည်။

ပရိုဂရမ်းမင်း ဘာသာစကား အများစုသည် debugger ပုံစံတစ်မျိုးမျိုးကို ထောက်ပံ့ပေးထားကြသည် (သို့မဟုတ် အဆင်သင့် ပါဝင်လာကြသည်)။ အသုံးအဝင်ဆုံးများမှာ Native binary မည်သည့်အရာမဆို debug လုပ်နိုင်သည့် [`gdb`](https://www.gnu.org/software/gdb/) (GNU Debugger) နှင့် [`lldb`](https://lldb.llvm.org/) (LLVM Debugger) ကဲ့သို့သော **General-purpose debugger များ** ဖြစ်ကြသည်။ ဘာသာစကား အများအပြားတွင်လည်း runtime နှင့် ပိုမိုနီးကပ်စွာ ပေါင်းစပ်ထားသည့် **Language-specific debugger များ** ရှိကြသည် (Python ၏ pdb သို့မဟုတ် Java ၏ jdb ကဲ့သို့)။

`gdb` သည် C, C++, Rust နှင့် အခြားသော compiled ဘာသာစကားများအတွက် စံဖြစ်သော (de-facto standard) debugger တစ်ခုဖြစ်သည်။ ၎င်းသည် မည်သည့် process ကိုမဆို စစ်ဆေးနိုင်စေပြီး ၎င်း၏ လက်ရှိ machine state များဖြစ်သော register များ၊ stack၊ program counter နှင့် အခြားအရာများကို ရယူနိုင်စေသည်။

အသုံးဝင်သော GDB command အချို့ -

- `run` - ပရိုဂရမ်ကို စတင်ရန်
- `b {function}` သို့မဟုတ် `b {file}:{line}` - Breakpoint တစ်ခု သတ်မှတ်ရန်
- `c` - ပရိုဂရမ် လုပ်ဆောင်ချက်ကို ဆက်လက်လုပ်ဆောင်ရန်
- `step` / `next` / `finish` - Step in / step over / step out (ထဲသို့ဝင်ရန် / အပေါ်မှကျော်ရန် / အပြင်သို့ထွက်ရန်)
- `p {variable}` - variable ၏ တန်ဖိုးကို print ထုတ်ရန်
- `bt` - Backtrace (call stack) ကို ဖော်ပြရန်
- `watch {expression}` - တန်ဖိုး ပြောင်းလဲသွားသည့်အခါ ရပ်တန့်ရန်

> Command prompt နှင့်အတူ source code ကို မျက်နှာပြင် ခွဲ၍ ကြည့်ရှုနိုင်ရန် GDB ၏ TUI mode (`gdb -tui` သို့မဟုတ် GDB အတွင်း၌ `Ctrl-x a` ကို နှိပ်ပါ) ကို အသုံးပြုရန် စဉ်းစားပါ။

### Record-Replay Debugging

စိတ်ပျက်စရာ အကောင်းဆုံး bug အချို့မှာ _Heisenbug_ များ ဖြစ်ကြသည် - ၎င်းတို့သည် သင့်အနေဖြင့် စောင့်ကြည့်လေ့လာရန် ကြိုးစားသောအခါ ပျောက်ကွယ်သွားသကဲ့သို့ ဖြစ်လေ့ရှိသော သို့မဟုတ် မူလမူပိုင် ပြုမူဆောင်ရွက်ပုံများ ပြောင်းလဲသွားလေ့ရှိသော bug များ ဖြစ်ကြသည်။ Race condition များ၊ အချိန်အပေါ် မူတည်နေသော bug များ နှင့် စနစ်၏ အချို့သော အခြေအနေများတွင်မှ ပေါ်ပေါက်လာတတ်သော ပြဿနာများသည် ဤအမျိုးအစားတွင် ပါဝင်သည်။ ပရိုဂရမ်ကို ပြန်လည် run သောအခါ ကွဲပြားသော ပြုမူဆောင်ရွက်ချက်များကို ဖြစ်ပေါ်စေသောကြောင့် (ဥပမာ- print statement များသည် ကုတ်ကို နှေးကွေးသွားစေနိုင်သဖြင့် race condition ထပ်မံမဖြစ်ပွားတော့ခြင်းမျိုး) ထုံးတမ်းစဉ်လာ debugging နည်းလမ်းများသည် ဤနေရာတွင် အသုံးမဝင်လှပါ။

**Record-replay debugging** သည် ပရိုဂရမ်တစ်ခု၏ လုပ်ဆောင်ချက်ကို မှတ်တမ်းတင်ထားပြီး သင်လိုအပ်သလောက် အကြိမ်ကြိမ် မူလအတိုင်း အတိအကျ ပြန်လည်ပြသ (replay) နိုင်စေခြင်းဖြင့် ဤပြဿနာကို ဖြေရှင်းပေးသည်။ ထို့ထက်ပို၍ ကောင်းမွန်သည်မှာ သင်သည် မည်သည့်နေရာတွင် မှားယွင်းသွားခဲ့သည်ကို အတိအကျ ရှာဖွေနိုင်ရန် ပရိုဂရမ် လုပ်ဆောင်ချက်အား နောက်ပြန်လှည့် (_reverse_) ၍ စစ်ဆေးနိုင်သည်။

[rr](https://rr-project.org/) သည် ပရိုဂရမ် လုပ်ဆောင်ချက်ကို မှတ်တမ်းတင်ပြီး အပြည့်အဝ debug လုပ်နိုင်သော စွမ်းရည်များဖြင့် မူလအတိုင်း အတိအကျ ပြန်လည်ပြသနိုင်စေသည့် Linux အတွက် စွမ်းဆောင်ရည်မြင့် tool တစ်ခုဖြစ်သည်။ ၎င်းသည် GDB နှင့် တွဲဖက် အလုပ်လုပ်သဖြင့် အင်တာဖေးစ်ကို သင်ရင်းနှီးပြီးသား ဖြစ်ပေလိမ့်မည်။

အခြေခံ အသုံးပြုပုံ -

```bash
# Record a program execution
rr record ./my_program

# Replay the recording (opens GDB)
rr replay
```

အံ့ဩဖွယ်ရာ လုပ်ဆောင်ချက်များသည် replay ပြုလုပ်ချိန်တွင် ဖြစ်ပေါ်လာသည်။ ပရိုဂရမ်၏ လုပ်ဆောင်ချက်သည် မူလအတိုင်း အတိအကျ ဖြစ်သောကြောင့် **Reverse debugging** command များကို အသုံးပြုနိုင်သည် -

- `reverse-continue` (`rc`) - Breakpoint တစ်ခုသို့ မရောက်မချင်း နောက်ပြန် run ရန်
- `reverse-step` (`rs`) - နောက်သို့ တစ်လိုင်းချင်းစီ နောက်ပြန်သွားရန်
- `reverse-next` (`rn`) - Function call များကို ကျော်လွန်၍ နောက်သို့ နောက်ပြန်သွားရန်
- `reverse-finish` - လက်ရှိ function အတွင်းသို့ မဝင်ရောက်မီအချိန်အထိ နောက်ပြန် run ရန်

၎င်းသည် debugging ပြုလုပ်ရန်အတွက် အလွန်ပင် စွမ်းအားထက်မြက်လှသည်။ ဥပမာ ပရိုဂရမ် crash ဖြစ်သွားသည်ဆိုပါစို့ — bug ၏ နေရာကို ခန့်မှန်း၍ breakpoint များ သတ်မှတ်နေမည့်အစား အောက်ပါအတိုင်း ပြုလုပ်နိုင်သည် -

1. Crash ဖြစ်သည့်နေရာအထိ Run ရန်
2. ပျက်စီးသွားသော state (corrupted state) ကို စစ်ဆေးရန်
3. ပျက်စီးသွားသော variable ပေါ်တွင် watchpoint တစ်ခု သတ်မှတ်ရန်
4. မည်သည့်နေရာတွင် အတိအကျ ပျက်စီးသွားခဲ့သည်ကို ရှာဖွေရန် `reverse-continue` ပြုလုပ်ရန်

**rr ကို မည်သည့်အခါတွင် အသုံးပြုရမည်နည်း -**
- တစ်ခါတစ်ရံမှ ကျရှုံးတတ်သော Flaky test များအတွက်
- Race condition များ နှင့် threading bug များအတွက်
- ပြန်လည် ဖန်တီးရခက်ခဲသော crash များအတွက်
- "အချိန်ကို နောက်ပြန်လှည့်နိုင်လျှင် ကောင်းမည်" ဟု သင်ဆုတောင်းမိစေသော bug မည်သည့်အရာမဆိုအတွက်

> မှတ်ချက်- rr သည် Linux တွင်သာ အလုပ်လုပ်ပြီး hardware performance counter များ လိုအပ်ပါသည်။ အဆိုပါ counter များကို ထုတ်ဖော်ပြသထားခြင်းမရှိသော AWS EC2 instance အများစုကဲ့သို့သော VM များတွင် အလုပ်မလုပ်ပါ၊ ထို့အပြင် GPU access ကိုလည်း ထောက်ပံ့မပေးပါ။ macOS အတွက်မူ [Warpspeed](https://warpspeed.dev/) ကို စစ်ဆေးကြည့်ပါ။

> **rr နှင့် Concurrency**- rr သည် လုပ်ဆောင်ချက်ကို အတိအကျ မှတ်တမ်းတင်ထားသောကြောင့် thread scheduling ကို စီရီယယ်လိုက် (serialize) ပြုလုပ်လိုက်သည်။ ဆိုလိုသည်မှာ အချို့သော race condition များသည် သီးခြား timing ပေါ်တွင် မူတည်ပါက rr အောက်တွင် ပေါ်ပေါက်လာမည် မဟုတ်ပါ။ သို့သော်လည်း race condition များကို debug လုပ်ရန် rr သည် အသုံးဝင်နေဆဲ ဖြစ်သည် — ကျရှုံးသွားသော run တစ်ခုကို ရယူလိုက်သည်နှင့် ၎င်းကို စိတ်ချယုံကြည်စွာ ပြန်လည်ပြသနိုင်သည် — သို့သော် အခါအားလျော်စွာ ပေါ်ပေါက်တတ်သော bug ကို ဖမ်းဆီးရန်အတွက် မှတ်တမ်းတင်ခြင်းကို အကြိမ်ကြိမ် ကြိုးစားရန် လိုအပ်နိုင်သည်။ Concurrency မပါဝင်သော bug များအတွက်မူ rr သည် အတောက်ပဆုံး စွမ်းဆောင်နိုင်သည် — အတိအကျ လုပ်ဆောင်ချက်ကို အမြဲတမ်း ပြန်လည် ဖန်တီးနိုင်ပြီး ပျက်စီးသွားသော နေရာကို လိုက်လံရှာဖွေရန် reverse debugging ကို အသုံးပြုနိုင်သည်။

## System Call Tracing

အချို့အခါများတွင် သင့်ပရိုဂရမ်သည် operating system နှင့် မည်သို့ ချိတ်ဆက် ဆောင်ရွက်နေသည်ကို နားလည်ရန် လိုအပ်သည်။ ပရိုဂရမ်များသည် kernel ထံမှ ဝန်ဆောင်မှုများ (ဖိုင်များဖွင့်ခြင်း၊ memory သတ်မှတ်ပေးခြင်း၊ process များ ဖန်တီးခြင်း နှင့် အခြားအရာများ) ကို တောင်းဆိုရန်အတွက် [system call များ](https://en.wikipedia.org/wiki/System_call) ကို ပြုလုပ်ကြသည်။ ဤ call များကို စောင့်ကြည့်ဆွဲထုတ်ခြင်း (tracing) ပြုလုပ်ခြင်းဖြင့် ပရိုဂရမ်တစ်ခု အဘယ်ကြောင့် ရပ်တန့် (hang) နေရသနည်း၊ မည်သည့်ဖိုင်များကို ဝင်ရောက်ကြည့်ရှုရန် ကြိုးစားနေသနည်း သို့မဟုတ် မည်သည့်နေရာတွင် စောင့်ဆိုင်းရင်း အချိန်ကုန်လွန်နေသနည်း စသည်တို့ကို ဖော်ထုတ်ပေးနိုင်သည်။

### strace (Linux) နှင့် dtruss (macOS)

[`strace`](https://www.man7.org/linux/man-pages/man1/strace.1.html) သည် ပရိုဂရမ်တစ်ခု ပြုလုပ်သော system call တိုင်းကို စောင့်ကြည့်နိုင်စေသည် -

```bash
# Trace all system calls
strace ./my_program

# Trace only file-related calls
strace -e trace=file ./my_program

# Follow child processes (important for programs that start other programs)
strace -f ./my_program

# Trace a running process
strace -p <PID>

# Show timing information
strace -T ./my_program
```

> macOS နှင့် BSD တို့တွင် ဆင်တူသော လုပ်ဆောင်ချက်များအတွက် [`dtruss`](https://www.manpagez.com/man/1/dtruss/) (`dtrace`) ကို အသုံးပြုပါ -

> `strace` အကြောင်း ပိုမိုနက်ရှိုင်းစွာ လေ့လာရန် Julia Evans ၏ ကောင်းမွန်လှသော [strace zine](https://jvns.ca/strace-zine-unfolded.pdf) ကို စစ်ဆေးကြည့်ပါ။

### bpftrace နှင့် eBPF

[eBPF](https://ebpf.io/) (extended Berkeley Packet Filter) သည် kernel အတွင်း၌ စံသတ်မှတ်ထားသော သီးခြားပတ်ဝန်းကျင် (sandboxed) ဖြင့် ပရိုဂရမ်များ run နိုင်စေသည့် စွမ်းအားထက်မြက်သော Linux နည်းပညာတစ်ခု ဖြစ်သည်။ [`bpftrace`](https://github.com/iovisor/bpftrace) သည် eBPF ပရိုဂရမ်များ ရေးသားရန်အတွက် အဆင့်မြင့် syntax တစ်ခုကို ပံ့ပိုးပေးသည်။ ၎င်းတို့သည် kernel အတွင်း run နေသော ပရိုဂရမ်များ ဖြစ်ကြသဖြင့် ကြီးမားသော လုပ်ဆောင်နိုင်စွမ်း (awk နှင့် ဆင်တူသော အနည်းငယ် ရှုပ်ထွေးသည့် syntax ရှိသော်လည်း) ရှိကြသည်။ ၎င်းတို့အတွက် အတွေ့ရများဆုံး အသုံးပြုပုံမှာ စုစည်းချက်များ (အရည်အတွက် သို့မဟုတ် latency စာရင်းအင်းများကဲ့သို့) သို့မဟုတ် system call argument များကို စစ်ဆေးခြင်း (သို့မဟုတ် filter လုပ်ခြင်း) အပါအဝင် မည်သည့် system call များ ခေါ်ယူသုံးစွဲနေသည်ကို စုံစမ်းစစ်ဆေးခြင်း ဖြစ်သည်။

```bash
# Trace file opens system-wide (prints immediately)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_openat { printf("%s %s\n", comm, str(args->filename)); }'

# Count system calls by name (prints summary on Ctrl-C)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_* { @[probe] = count(); }'
```

သို့သော်လည်း disk စနစ် လုပ်ဆောင်ချက်များ၏ latency ပျံ့နှံ့မှုကို print ထုတ်ပေးသော `biosnoop` သို့မဟုတ် ပွင့်နေသော ဖိုင်အားလုံးကို print ထုတ်ပေးသော `opensnoop` ကဲ့သို့သော [အသုံးဝင်သော tool အများအပြား](https://www.brendangregg.com/blog/2015-09-22/bcc-linux-4.3-tracing.html) ပါဝင်သည့် [`bcc`](https://github.com/iovisor/bcc) ကဲ့သို့သော toolchain တစ်ခုကို အသုံးပြု၍ eBPF ပရိုဂရမ်များကို C ဖြင့် တိုက်ရိုက် ရေးသားနိုင်သည်။

`strace` သည် "ချက်ချင်း စတင်၍ run ရုံသာ" ဖြစ်သဖြင့် အသုံးဝင်သော်လည်း `bpftrace` မှာမူ ပိုမိုနည်းပါးသော overhead လိုအပ်သည့်အခါ၊ kernel function များကို စောင့်ကြည့်ဆွဲထုတ်လိုသည့်အခါ သို့မဟုတ် မည်သည့် စုစည်းချက်မျိုးမဆို ပြုလုပ်ရန် လိုအပ်သည့်အခါများတွင် သုံးစွဲရမည့် tool ဖြစ်သည်။ သို့သော် `bpftrace` ကို `root` အဖြစ် run ရမည်ဖြစ်ပြီး သီးခြား process တစ်ခုတည်းကိုသာမက တစ်ခုလုံးသော kernel တစ်ခုလုံးကို စောင့်ကြည့်စစ်ဆေးလေ့ရှိသည်ကို သတိပြုပါ။ သီးခြား ပရိုဂရမ်တစ်ခုကို ပစ်မှတ်ထားရန် command အမည် သို့မဟုတ် PID အလိုက် စစ်ထုတ် (filter) နိုင်သည် -

```bash
# Filter by command name (prints summary on Ctrl-C)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_* /comm == "bash"/ { @[probe] = count(); }'

# Trace a specific command from startup using -c (cpid = child PID)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_* /pid == cpid/ { @[probe] = count(); }' -c 'ls -la'
```

`-c` flag သည် သတ်မှတ်ထားသော command ကို run ပြီး `cpid` ကို ၎င်း၏ PID အဖြစ် သတ်မှတ်ပေးသည်၊ ၎င်းသည် ပရိုဂရမ် စတင်သည့် အချိန်မှစ၍ စောင့်ကြည့်ဆွဲထုတ်ရန်အတွက် အသုံးဝင်သည်။ စောင့်ကြည့်ထားသော command ထွက်သွားသောအခါ bpftrace သည် စုစည်းထားသော ရလဒ်များကို print ထုတ်ပေးသည်။

### Network Debugging

ကွန်ရက် ပြဿနာများအတွက် [`tcpdump`](https://www.man7.org/linux/man-pages/man1/tcpdump.1.html) နှင့် [Wireshark](https://www.wireshark.org/) တို့သည် ကွန်ရက် packet များကို ဖမ်းယူ၍ ဓါတ်ခွဲစစ်ဆေးနိုင်စေသည် -

```bash
# Capture packets on port 80
sudo tcpdump -i any port 80

# Capture and save to file for Wireshark analysis
sudo tcpdump -i any -w capture.pcap
```

HTTPS traffic များအတွက်မူ encryption ကြောင့် tcpdump သည် အသုံးဝင်မှု နည်းပါးသွားသည်။ [mitmproxy](https://mitmproxy.org/) ကဲ့သို့သော tool များသည် encrypt လုပ်ထားသော traffic များကို စစ်ဆေးရန် intercepting proxy တစ်ခုအဖြစ် ဆောင်ရွက်နိုင်သည်။ Browser developer tool များ (Network tab) သည် web application များမှ HTTPS request များကို debug လုပ်ရန်အတွက် အလွယ်ကူဆုံး နည်းလမ်း ဖြစ်လေ့ရှိသည် — ၎င်းတို့သည် decrypt လုပ်ထားသော request/response ဒေတာများ၊ header များနှင့် ကြာမြင့်ချိန် (timing) များကို ဖော်ပြပေးသည်။

## Memory Debugging

Memory bug များ — buffer overflow များ၊ use-after-free၊ memory leak များ — သည် အန္တရာယ် အများဆုံးနှင့် debug လုပ်ရန် အခက်ခဲဆုံး အရာများထဲတွင် ပါဝင်သည်။ ၎င်းတို့သည် ချက်ချင်း crash ဖြစ်လေ့မရှိဘဲ နောက်ပိုင်းတွင်မှ ပြဿနာများ ဖြစ်ပေါ်စေသည့် နည်းလမ်းများဖြင့် memory ကို ပျက်စီးစေလေ့ရှိသည်။

### Sanitizer များ

Memory bug များကို ရှာဖွေနိုင်သည့် နည်းလမ်းတစ်ခုမှာ runtime ၌ အမှားများကို စမ်းသပ်ရှာဖွေနိုင်ရန် သင့်ကုတ်တွင် စစ်ဆေးချက်များ ထည့်သွင်းပေးသည့် compiler ၏ feature များ ဖြစ်ကြသော **Sanitizer များ** ကို အသုံးပြုခြင်း ဖြစ်သည်။ ဥပမာအားဖြင့် ကျယ်ပြန့်စွာ အသုံးပြုကြသော **AddressSanitizer (ASan)** သည် အောက်ပါတို့ကို ရှာဖွေပေးသည် -
- Buffer overflow များ (stack၊ heap နှင့် global)
- Use-after-free
- Use-after-return
- Memory leak များ

```bash
# Compile with AddressSanitizer
gcc -fsanitize=address -g program.c -o program
./program
```

အသုံးဝင်သော sanitizer အမျိုးမျိုး ရှိကြသည် -

- **ThreadSanitizer (TSan)**- Multithreaded ကုတ်များတွင် data race များကို ရှာဖွေပေးသည် (`-fsanitize=thread`)
- **MemorySanitizer (MSan)**- Initialized မလုပ်ရသေးသော memory များကို ဖတ်ရှုခြင်းကို ရှာဖွေပေးသည် (`-fsanitize=memory`)
- **UndefinedBehaviorSanitizer (UBSan)**- Integer overflow ကဲ့သို့သော undefined behavior များကို ရှာဖွေပေးသည် (`-fsanitize=undefined`)

Sanitizer များသည် ပြန်လည် compile လုပ်ရန် လိုအပ်သော်လည်း CI pipeline များနှင့် ပုံမှန် ရေးသားပြင်ဆင်ချိန်များတွင် အသုံးပြုနိုင်လောက်အောင် မြန်ဆန်ကြသည်။

### Valgrind- ပြန်လည် compile မလုပ်နိုင်သည့်အခါ

[Valgrind](https://valgrind.org/) မှာမူ memory အမှားများကို ရှာဖွေရန် သင့်ပရိုဂရမ်ကို virtual machine ကဲ့သို့သော အရာတစ်ခုတွင် run ပေးသည်။ ၎င်းသည် sanitizer များထက် ပိုမိုနှေးကွေးသော်လည်း ပြန်လည် compile လုပ်ရန် မလိုပါ -

```bash
valgrind --leak-check=full ./my_program
```

အောက်ပါ အခြေအနေများတွင် Valgrind ကို အသုံးပြုပါ -
- သင့်ထံတွင် source code မရှိသည့်အခါ
- ပြန်လည် compile မလုပ်နိုင်သည့်အခါ (third-party library များ)
- Sanitizer အဖြစ် မရရှိနိုင်သော သီးခြား tool များကို လိုအပ်သည့်အခါ

Valgrind သည် အမှန်တကယ်ပင် စွမ်းအားထက်မြက်သည့် ထိန်းချုပ်ထားသော လုပ်ဆောင်ချက် ပတ်ဝန်းကျင်တစ်ခု ဖြစ်ပြီး Profiling အပိုင်းသို့ ရောက်ရှိသည့်အခါ ၎င်းအကြောင်းကို ထပ်မံတွေ့ရှိရမည် ဖြစ်သည်!

## Debugging အတွက် AI

Large language model (LLM) များသည် အံ့အားသင့်ဖွယ် အသုံးဝင်သော debugging အကူအညီပေးသူများ ဖြစ်လာကြသည်။ ၎င်းတို့သည် ထုံးတမ်းစဉ်လာ tool များကို အထောက်အကူပြုနိုင်သည့် သီးခြား debugging လုပ်ဆောင်ချက်များတွင် အထူးပင် ကျွမ်းကျင်ကြသည်။

**LLM များ ပိုမို အသုံးဝင်သော နေရာများ -**

- **နားလည်ရခက်သော Error Message များကို ရှင်းပြခြင်း**- Compiler error များ၊ အထူးသဖြင့် C++ template များ သို့မဟုတ် Rust ၏ borrow checker မှ လာသော error များသည် နားလည်ရခက်ခဲလှသည်။ LLM များသည် ၎င်းတို့အား ရိုးရှင်းသော အင်္ဂလိပ်ဘာသာစကားဖြင့် ပြန်ဆိုပေးနိုင်ပြီး ပြင်ဆင်ချက်များကို အကြံပြုပေးနိုင်သည်။

- **ဘာသာစကားနှင့် Abstraction နယ်နိမိတ်များကို ကျော်လွန် စေခိုင်းခြင်း**- အကယ်၍ သင်သည် ဘာသာစကား အများအပြား ပါဝင်နေသော ပြဿနာတစ်ခုကို debug လုပ်နေရပါက (ဥပမာ- Python binding မှတစ်ဆင့် ပေါ်ပေါက်လာသော C library တစ်ခုအတွင်းရှိ bug မျိုး) LLM များသည် မတူညီသော အလွှာများကို ချိတ်ဆက် စစ်ဆေးပေးနိုင်သည်။ ၎င်းတို့သည် FFI boundary များ၊ build system ပြဿနာများနှင့် ဘာသာစကားချင်း ချိတ်ဆက်ထားသော debugging များကို နားလည်ရာတွင် အထူးပင် ကောင်းမွန်ကြသည် (ဥပမာ- "ကျွန်ုပ်၏ ပရိုဂရမ်တွင် error တက်နေသည်၊ သို့သော် ၎င်းမှာ ကျွန်ုပ် သုံးထားသော dependency တစ်ခု၏ bug ကြောင့်ဖြစ်သည်ဟု ထင်ပါသည်")။

- **ရောဂါလက္ခဏာများနှင့် အဓိက အကြောင်းအရင်းများကို ချိတ်ဆက်စစ်ဆေးခြင်း**- "ကျွန်ုပ်၏ ပရိုဂရမ်သည် ပုံမှန် အလုပ်လုပ်သော်လည်း မျှော်မှန်းထားသည်ထက် memory ၁၀ ဆမက ပိုမိုသုံးစွဲနေသည်" ဆိုသည်မှာ LLM များ စုံစမ်းစစ်ဆေးကူညီပေးနိုင်သော ဝေဝါးသည့် လက္ခဏာမျိုး ဖြစ်ပြီး ဖြစ်နိုင်ဖွယ် အကြောင်းအရင်းများနှင့် မည်သည်ကို ရှာဖွေရမည်ကို အကြံပြုပေးနိုင်သည်။

- **Crash dump များနှင့် Stack trace များကို ဓါတ်ခွဲစစ်ဆေးခြင်း**- Stack trace တစ်ခုကို paste လုပ်၍ မည်သည့်အရာကြောင့် ဖြစ်နိုင်သည်ကို မေးမြန်းနိုင်သည်။

> **Debug symbol များအကြောင်း မှတ်ချက်**- အဓိပ္ပာယ်ရှိသော stack trace များနှင့် debugging များအတွက် သင့် binary များ (နှင့် ချိတ်ဆက်ထားသော library မည်သည့်အရာမဆို) ကို debug symbol များ (`-g` flag) ဖြင့် compile လုပ်ထားကြောင်း သေချာပါစေ။ Debug အချက်အလက်များကို ပုံမှန်အားဖြင့် DWARF format ဖြင့် သိမ်းဆည်းလေ့ရှိသည်။ ထို့အပြင် frame pointer များ (`-fno-omit-frame-pointer`) ဖြင့် compile ပြုလုပ်ခြင်းသည် အထူးသဖြင့် profiling tool များအတွက် stack trace များကို ပိုမို စိတ်ချယုံကြည်ရစေသည်။ ၎င်းတို့ မပါရှိပါက stack trace များသည် memory address များကိုသာ ပြသနိုင်သည် သို့မဟုတ် မပြည့်စုံဘဲ ဖြစ်နေနိုင်သည်။ ၎င်းသည် Python သို့မဟုတ် Java ထက် Native compile ပြုလုပ်ထားသော ပရိုဂရမ်များ (C++, Rust) အတွက် ပိုမို အရေးပါသည်။

**သတိပြုရမည့် အကန့်အသတ်များ -**
- LLM များသည် ဖြစ်နိုင်ဖွယ်ရှိပုံရသော်လည်း မှားယွင်းသော ရှင်းလင်းချက်များကို hallucinate လုပ်၍ ပေးတတ်သည်
- ၎င်းတို့သည် bug ကို အမှန်တကယ် ပြင်ဆင်ပေးခြင်းထက် ဖုံးကွယ်သွားစေမည့် ပြင်ဆင်ချက်များကို အကြံပြုနိုင်သည်
- အကြံပြုချက်များကို အမှန်တကယ် debugging tool များဖြင့် အမြဲမပြတ် စစ်ဆေးပါ
- ၎င်းတို့သည် သင့်ကုတ်အား နားလည်မှုကို အစားထိုးရန် မဟုတ်ဘဲ ဖြည့်စွက်ကူညီပေးသူအဖြစ် သုံးစွဲသည့်အခါ အကောင်းဆုံး အလုပ်လုပ်သည်

> ၎င်းသည် Development Environment ပို့ချချက်တွင် ဆွေးနွေးခဲ့သည့် [ယေဘုယျ AI ကုတ်ရေးသားနိုင်စွမ်းများ](/2026/development-environment/#ai-powered-development) နှင့် ကွဲပြားပါသည်။ ဤနေရာတွင် ကျွန်ုပ်တို့သည် LLM များကို debugging အထောက်အကူအဖြစ် သီးခြား အသုံးပြုခြင်းအကြောင်းကို ပြောဆိုနေခြင်း ဖြစ်သည်။

# Profiling

သင့်ကုတ်သည် လုပ်ဆောင်ချက်ဆိုင်ရာ အရ သင်မျှော်မှန်းထားသည့်အတိုင်း အလုပ်လုပ်နေသည့်တိုင် လုပ်ဆောင်နေစဉ်အတွင်း သင့် CPU သို့မဟုတ် memory အားလုံးကို ကုန်ဆုံးစေပါက ထိုသို့ဖြစ်ခြင်းမှာ ကောင်းမွန်လှမည် မဟုတ်ပေ။ Algorithm သင်ခန်းစာများတွင် Big _O_ notation ကို သင်ကြားပေးလေ့ရှိသော်လည်း သင့်ပရိုဂရမ်များရှိ အလုပ်အများဆုံးလုပ်ရသော Hot spot များကို မည်သို့ရှာဖွေရမည်ကို သင်ကြားမပေးကြပါ။ [အချိန်မတန်မီ အလျင်စလို Optimization ပြုလုပ်ခြင်းသည် ဒုက္ခအားလုံး၏ အမြစ်တွယ်ရာဖြစ်သောကြောင့်](https://wiki.c2.com/?PrematureOptimization) Profiler များနှင့် Monitoring tool များကို လေ့လာသင့်သည်။ ၎င်းတို့သည် သင့်ပရိုဂရမ်၏ မည်သည့်အပိုင်းများက အချိန်နှင့်/သို့မဟုတ် အရင်းအမြစ် အများဆုံး သုံးစွဲနေသည်ကို နားလည်စေရန် ကူညီပေးမည်ဖြစ်ပြီး ထိုအပိုင်းများကို ဇောက်ထိုးစိုက်၍ အကောင်းဆုံးဖြစ်အောင် ပြင်ဆင် (optimize) နိုင်မည် ဖြစ်သည်။

## Timing (အချိန်တိုင်းတာခြင်း)

စွမ်းဆောင်ရည်ကို တိုင်းတာရန် အလွယ်ကူဆုံး နည်းလမ်းမှာ ကြာမြင့်ချိန်ကို တိုင်းတာခြင်း ဖြစ်သည်။ အခြေအနေ အများအပြားတွင် သင့်ကုတ်၏ အမှတ်နှစ်ခုကြား ကြာမြင့်ခဲ့သော အချိန်ကို print ထုတ်လိုက်ရုံဖြင့် လုံလောက်နိုင်သည်။

သို့သော်လည်း သင့်ကွန်ပျူတာသည် အခြား process များကို တစ်ပြိုင်နက်တည်း run နေနိုင်သကဲ့သို့ ဖြစ်စဉ်များ ဖြစ်ပျက်လာသည်ကို စောင့်ဆိုင်းနေနိုင်သောကြောင့် Wall clock time (နာရီကြည့်၍ တိုင်းသောကြာချိန်) သည် လွဲမှားစေနိုင်သည်။ `time` command သည် _Real_၊ _User_ နှင့် _Sys_ အချိန်များအကြား ခွဲခြားပေးသည် -

- **Real** - စတင်ချိန်မှ ပြီးဆုံးချိန်အထိ နာရီကြည့်၍ တိုင်းတာသော ကြာချိန် (စောင့်ဆိုင်းချိန် အပါအဝင်)
- **User** - User ကုတ်များ run ရန် CPU အတွင်း ကုန်လွန်ခဲ့သော အချိန်
- **Sys** - Kernel ကုတ်များ run ရန် CPU အတွင်း ကုန်လွန်ခဲ့သော အချိန်

```bash
$ time curl https://missing.csail.mit.edu &> /dev/null
real	0m0.272s
user	0m0.079s
sys	    0m0.028s
```

ဤနေရာတွင် request သည် မီလီစက္ကန့် ၃၀၀ နီးပါး (real time) ကြာမြင့်ခဲ့သော်လည်း CPU အချိန် (user + sys) မှာ ၁၀၇ မီလီစက္ကန့်သာ ရှိခဲ့သည်။ ကျန်ရှိသော အချိန်မှာ ကွန်ရက်ကို စောင့်ဆိုင်းနေခဲ့ခြင်း ဖြစ်သည်။

## Resource Monitoring (အရင်းအမြစ် စောင့်ကြည့်စစ်ဆေးခြင်း)

အချို့အခါများတွင် သင့်ပရိုဂရမ်၏ စွမ်းဆောင်ရည်ကို ဓါတ်ခွဲစစ်ဆေးရန် ပထမဆုံး အဆင့်မှာ ၎င်း၏ အမှန်တကယ် အရင်းအမြစ် သုံးစွဲမှုကို နားလည်ခြင်း ဖြစ်သည်။ ပရိုဂရမ်များသည် အရင်းအမြစ် ကန့်သတ်ချက်များ ရှိနေသည့်အခါ မကြာခဏ နှေးကွေးစွာ အလုပ်လုပ်လေ့ရှိသည်။

- **ယေဘုယျ စောင့်ကြည့်စစ်ဆေးခြင်း**- [`htop`](https://htop.dev/) သည် လက်ရှိ run နေသော process များ၏ စာရင်းအင်း အမျိုးမျိုးကို ဖော်ပြပေးသည့် `top` ၏ မြှင့်တင်ထားသော ဗားရှင်း ဖြစ်သည်။ အသုံးဝင်သော shortcut မျာ- process များကို စီရန် `<F6>`၊ သစ်ပင်ပုံစံ အဆင့်ဆင့်ပြရန် `t`၊ thread များကို အဖွင့်အပိတ်လုပ်ရန် `h`။ ထို့အပြင် အရာအများအပြားကို _ပိုမို_ စောင့်ကြည့်ပေးသည့် [`btop`](https://github.com/aristocratos/btop) လည်း ရှိသည်။
- **I/O လုပ်ဆောင်ချက်များ**- [`iotop`](https://www.man7.org/linux/man-pages/man8/iotop.8.html) သည် တိုက်ရိုက် I/O သုံးစွဲမှု အချက်အလက်များကို ဖော်ပြပေးသည်။
- **Memory သုံးစွဲမှု**- [`free`](https://www.man7.org/linux/man-pages/man1/free.1.html) သည် စုစုပေါင်း လွတ်လပ်နေသော Memory နှင့် သုံးစွဲထားသော Memory ကို ဖော်ပြပေးသည်။
- **ပွင့်နေသော ဖိုင်များ**- [`lsof`](https://www.man7.org/linux/man-pages/man8/lsof.8.html) သည် process များက ဖွင့်လှစ်ထားသော ဖိုင်များ၏ အချက်အလက်များကို ဖော်ပြပေးသည်။ သီးခြားဖိုင်တစ်ခုကို မည်သည့် process က ဖွင့်ထားသည်ကို စစ်ဆေးရာတွင် အသုံးဝင်သည်။
- **ကွန်ရက် ချိတ်ဆက်မှုများ**- [`ss`](https://www.man7.org/linux/man-pages/man8/ss.8.html) သည် ကွန်ရက် ချိတ်ဆက်မှုများကို စောင့်ကြည့်နိုင်စေသည်။ အတွေ့ရများသော အသုံးပြုပုံမှာ မည်သည့် process က ပေးထားသော port ကို အသုံးပြုနေသည်ကို ရှာဖွေခြင်းဖြစ်သည်- `ss -tlnp | grep :8080`။
- **ကွန်ရက် သုံးစွဲမှု**- [`nethogs`](https://github.com/raboof/nethogs) နှင့် [`iftop`](https://pdw.ex-parrot.com/iftop/) တို့သည် process တစ်ခုချင်းစီအလိုက် ကွန်ရက် သုံးစွဲမှုကို စောင့်ကြည့်ရန် ကောင်းမွန်သော Interactive CLI tool များ ဖြစ်ကြသည်။

## Performance Data များကို ပုံဖော် ကြည့်ရှုခြင်း

လူများသည် ကိန်းဂဏန်း ဇယားများထက် graph မျဉ်းကွေးများတွင် ပုံစံ (pattern) များကို ပိုမို မြန်ဆန်စွာ သတိပြုမိကြသည်။ စွမ်းဆောင်ရည်ကို ဓါတ်ခွဲစစ်ဆေးသည့်အခါ သင့်ဒေတာများကို graph ဆွဲကြည့်ခြင်းဖြင့် ကိန်းဂဏန်း အကြမ်းများတွင် မမြင်နိုင်သော Trend များ၊ Spike များ နှင့် မူမမှန်မှုများကို ဖော်ထုတ်ပေးလေ့ ရှိသည်။

**ဒေတာများကို graph ဆွဲရလွယ်ကူအောင် ပြုလုပ်ခြင်း**- Debugging အတွက် print သို့မဟုတ် log statement များ ထည့်သွင်းသည့်အခါ နောက်ပိုင်းတွင် လွယ်ကူစွာ graph ဆွဲနိုင်ရန် output ကို format လုပ်ရန် စဉ်းစားပါ။ CSV format ဖြင့် သာမန် timestamp နှင့် တန်ဖိုး (`1705012345,42.5`) သည် စကားပြေ စာကြောင်းထက် graph ဆွဲရသည်မှာ ပိုမို လွယ်ကူသည်။ JSON-structured log များကိုလည်း နည်းပါးသော အားထုတ်မှုဖြင့် parse လုပ်၍ graph ဆွဲနိုင်သည်။ အခြားစကားဖြင့် ပြောရလျှင် သင့်ဒေတာများကို [သပ်သပ်ရပ်ရပ် ရေးသားပါ](https://vita.had.co.nz/papers/tidy-data.pdf)။

**gnuplot ဖြင့် လျှင်မြန်စွာ graph ဆွဲခြင်း**- ရိုးရှင်းသော command-line graph ဆွဲခြင်းအတွက် [`gnuplot`](http://www.gnuplot.info/) သည် ဒေတာဖိုင်များမှ graph များကို တိုက်ရိုက် ထုတ်လုပ်ပေးနိုင်သည် -

```bash
# Plot a simple CSV with timestamp,value
gnuplot -e "set datafile separator ','; plot 'latency.csv' using 1:2 with lines"
```

**matplotlib နှင့် ggplot2 ဖြင့် အကြိမ်ကြိမ် ဓါတ်ခွဲ စမ်းသပ်ခြင်း**- ပိုမို နက်ရှိုင်းသော ဓါတ်ခွဲစစ်ဆေးမှုအတွက် Python ၏ [`matplotlib`](https://matplotlib.org/) နှင့် R ၏ [`ggplot2`](https://ggplot2.tidyverse.org/) တို့သည် အကြိမ်ကြိမ် ဓါတ်ခွဲစမ်းသပ်မှုများကို ပြုလုပ်နိုင်စေသည်။ အခိုက်အတန့် graph ဆွဲခြင်းများနှင့် မတူဘဲ ဤ tool များသည် အယူအဆ (hypothesis) များကို စုံစမ်းစစ်ဆေးရန် ဒေတာများကို မြန်ဆန်စွာ အစိတ်အပိုင်းပိုင်းခြား၍ ပြောင်းလဲနိုင်စေသည်။ ggplot2 ၏ facet plot များသည် အထူးပင် စွမ်းအားထက်မြက်သည် — အမျိုးအစားအလိုက် (ဥပမာ- request latency ကို endpoint သို့မဟုတ် အချိန်အလိုက် ပိုင်းခြား၍) ဒေတာအစုအဝေး တစ်ခုတည်းကို subplot အများအပြားသို့ ခွဲထုတ်နိုင်ပြီး မဟုတ်ပါက ဖုံးကွယ်နေမည့် ပုံစံများကို ဖော်ထုတ်ပေးနိုင်သည်။

**နမူနာ အသုံးပြုမှုများ -**
- အချိန်အလိုက် request latency ကို graph ဆွဲခြင်းသည် အကြမ်း percentile များက ဖုံးကွယ်ထားသော ပုံမှန် နှေးကွေးမှုများ (garbage collection၊ cron job များ၊ traffic ပုံစံများ) ကို ဖော်ထုတ်ပေးသည်
- ကြီးထွားလာသော ဒေတာစထရက်ချာတစ်ခုအတွက် ထည့်သွင်းချိန် (insert time) များကို ပုံဖော်ကြည့်ရှုခြင်းသည် algorithm ၏ ရှုပ်ထွေးမှု ပြဿနာများကို ဖော်ပြပေးနိုင်သည် — vector ထည့်သွင်းမှုများ၏ graph သည် အောက်ခံ array အရွယ်အစား နှစ်ဆဖြစ်သွားသည့်အခါ ထူးခြားသော spike များကို ဖော်ပြမည်ဖြစ်သည်
- မတူညီသော Dimension များ (request အမျိုးအစား၊ user အစုအဝေး၊ server) အလိုက် metric များကို ပိုင်းခြားခြင်းသည် "တစ်စနစ်လုံးဆိုင်ရာ" ပြဿနာတစ်ခုသည် အမှန်တကယ်တွင် အမျိုးအစားတစ်ခုတည်း၌သာ သီးခြားဖြစ်ပေါ်နေခြင်းဖြစ်ကြောင်း မကြာခဏ ဖော်ထုတ်ပေးသည်

## CPU Profiler များ

လူများက _profiler_ အကြောင်း ပြောဆိုသည့်အခါ အချိန်အများစုတွင် _CPU profiler_ များကို ရည်ရွယ်ကြခြင်း ဖြစ်သည်။ အဓိက အမျိုးအစား နှစ်ခု ရှိသည် -

- **Tracing profiler များ** သည် သင့်ပရိုဂရမ် ပြုလုပ်သော function call တိုင်းကို မှတ်တမ်းတင်ထားကြသည်
- **Sampling profiler များ** သည် သင့်ပရိုဂရမ်ကို ပုံမှန် အချိန်အပိုင်းအခြားအလိုက် (ယေဘုယျအားဖြင့် ၁ မီလီစက္ကန့်တိုင်း) စစ်ဆေးပြီး ပရိုဂရမ်၏ stack ကို မှတ်တမ်းတင်ကြသည်

Sampling profiler များသည် နည်းပါးသော overhead ရှိကြပြီး Production တွင် အသုံးပြုရန် ယေဘုယျအားဖြင့် ပိုမိုနှစ်သက်ကြသည်။

### perf- Sampling Profiler

[`perf`](https://www.man7.org/linux/man-pages/man1/perf.1.html) သည် စံ Linux profiler ဖြစ်သည်။ ၎င်းသည် ပြန်လည် compile လုပ်ရန် မလိုဘဲ မည်သည့် ပရိုဂရမ်ကိုမဆို profile လုပ်နိုင်သည်။

`perf stat` သည် အချိန် မည်သည့်နေရာတွင် ကုန်လွန်သွားသည်ကို မြန်ဆန်သော သုံးသပ်ချက် ပေးသည် -

```bash
$ perf stat ./slow_program

 Performance counter stats for './slow_program':

         3,210.45 msec task-clock                #    0.998 CPUs utilized
               12      context-switches          #    3.738 /sec
                0      cpu-migrations            #    0.000 /sec
              156      page-faults               #   48.587 /sec
   12,345,678,901      cycles                    #    3.845 GHz
    9,876,543,210      instructions              #    0.80  insn per cycle
    1,234,567,890      branches                  #  384.532 M/sec
       12,345,678      branch-misses             #    1.00% of all branches
```

လက်တွေ့ကမ္ဘာ ပရိုဂရမ်များအတွက် Profiler output များသည် ကြီးမားသော အချက်အလက် ပမာဏ ပါဝင်လိမ့်မည်။ လူများသည် အမြင်အာရုံကို ပိုမို အသုံးပြုသော သတ္တဝါများ ဖြစ်ကြပြီး ကြီးမားသော ကိန်းဂဏန်း ပမာဏများကို ဖတ်ရှုရာတွင် တော်တော်ပင် ညံ့ဖျင်းကြသည်။ [Flame graph များ](https://www.brendangregg.com/flamegraphs.html) သည် profiling ဒေတာများကို ပိုမို နားလည်ရလွယ်ကူစေသည့် ရုပ်ပုံလွှာ ပုံဖော်ခြင်း (visualization) ဖြစ်သည်။

Flame graph တစ်ခုသည် Y axis တွင် function call များ၏ အဆင့်ဆင့် အစဉ်လိုက်ကို ဖော်ပြပြီး X axis တွင် ကုန်လွန်ခဲ့သော အချိန်နှင့် အချိုးကျ ဖော်ပြပေးသည်။ ၎င်းတို့သည် Interactive ဖြစ်ကြသည် — ပရိုဂရမ်၏ သီးခြား အစိတ်အပိုင်းများသို့ ချဲ့ကြည့် (zoom in) ရန် click နှိပ်နိုင်သည်။

[![FlameGraph](https://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)](https://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)

`perf` ဒေတာမှ flame graph တစ်ခု ထုတ်လုပ်ရန် -

```bash
# Record profile
perf record -g ./my_program

# Generate flame graph (requires flamegraph scripts)
perf script | stackcollapse-perf.pl | flamegraph.pl > flamegraph.svg
```

> Interactive web-based flame graph viewer အတွက် [Speedscope](https://www.speedscope.app/) ကို အသုံးပြုရန် သို့မဟုတ် စနစ်အဆင့် ဘက်စုံ ဓါတ်ခွဲစစ်ဆေးမှုအတွက် [Perfetto](https://perfetto.dev/) ကို အသုံးပြုရန် စဉ်းစားပါ။

### Valgrind ၏ Callgrind- Tracing Profiler

[`callgrind`](https://valgrind.org/docs/manual/cl-manual.html) သည် သင့်ပရိုဂရမ်၏ call ရာဇဝင်နှင့် instruction အရေအတွက်များကို မှတ်တမ်းတင်သည့် profiling tool တစ်ခု ဖြစ်သည်။ Sampling profiler များနှင့် မတူဘဲ ၎င်းသည် အတိအကျ call အရေအတွက်များကို ပံ့ပိုးပေးပြီး caller များနှင့် callee များအကြား ဆက်နွယ်မှုကို ဖော်ပြပေးနိုင်သည် -

```bash
# Run with callgrind
valgrind --tool=callgrind ./my_program

# Analyze with callgrind_annotate (text) or kcachegrind (GUI)
callgrind_annotate callgrind.out.<pid>
kcachegrind callgrind.out.<pid>
```

Callgrind သည် sampling profiler များထက် ပိုမိုနှေးကွေးသော်လည်း တိကျသော call အရေအတွက်များကို ပံ့ပိုးပေးပြီး အကယ်၍ သင်လိုအပ်ပါက cache ပြုမူဆောင်ရွက်ချက်များကိုပါ (`--cache-sim=yes` ဖြင့်) တုပပေးနိုင်သည်။

> အကယ်၍ သင်သည် သီးခြား ဘာသာစကားတစ်ခုကို အသုံးပြုနေပါက ပိုမိုအထူးပြုထားသော profiler များ ရှိနိုင်ပေသည်။ ဥပမာအားဖြင့် Python ၌ [`cProfile`](https://docs.python.org/3/library/profile.html) နှင့် [`py-spy`](https://github.com/benfred/py-spy) ရှိပြီး၊ Go ၌ [`go tool pprof`](https://pkg.go.dev/cmd/pprof) ရှိကာ၊ Rust ၌ [`cargo-flamegraph`](https://github.com/flamegraph-rs/flamegraph) (၎င်းမှာ အမှန်တကယ်တွင် compiled ပရိုဂရမ် မည်သည့်အရာအတွက်မဆို အလုပ်လုပ်သည်!) ရှိကြသည်။

## Memory Profiler များ

Memory profilerများသည် သင့်ပရိုဂရမ်က အချိန်နှင့်အမျှ Memory မည်သို့ သုံးစွဲနေသည်ကို နားလည်စေရန်နှင့် Memory leak များကို ရှာဖွေနိုင်ရန် ကူညီပေးသည်။

### Valgrind ၏ Massif

[`massif`](https://valgrind.org/docs/manual/ms-manual.html) သည် Heap memory သုံးစွဲမှုကို profile လုပ်ပေးသည် -

```bash
valgrind --tool=massif ./my_program
ms_print massif.out.<pid>
```

၎င်းသည် အချိန်နှင့်အမျှ heap သုံးစွဲမှုကို ဖော်ပြပေးပြီး memory leak များနှင့် အလွန်အမင်း သတ်မှတ်ထားမှု (excessive allocation) များကို ခွဲခြားသိရှိနိုင်ရန် ကူညီပေးသည်။

> Python အတွက်မူ [`memory-profiler`](https://pypi.org/project/memory-profiler/) သည် တစ်လိုင်းချင်းစီအလိုက် memory သုံးစွဲမှု အချက်အလက်ကို ပံ့ပိုးပေးသည်။

## Benchmarking (စွမ်းဆောင်ရည် နှိုင်းယှဉ်တိုင်းတာခြင်း)

မတူညီသော ရေးသားမှုများ သို့မဟုတ် tool များ၏ စွမ်းဆောင်ရည်ကို နှိုင်းယှဉ်ရန် လိုအပ်သည့်အခါ [`hyperfine`](https://github.com/sharkdp/hyperfine) သည် command-line ပရိုဂရမ်များကို benchmark ပြုလုပ်ရန် အလွန်ကောင်းမွန်သည် -

```bash
$ hyperfine --warmup 3 'fd -e jpg' 'find . -iname "*.jpg"'
Benchmark #1: fd -e jpg
  Time (mean ± σ):      51.4 ms ±   2.9 ms    [User: 121.0 ms, System: 160.5 ms]
  Range (min … max):    44.2 ms …  60.1 ms    56 runs

Benchmark #2: find . -iname "*.jpg"
  Time (mean ± σ):      1.126 s ±  0.101 s    [User: 141.1 ms, System: 956.1 ms]
  Range (min … max):    0.975 s …  1.287 s    10 runs

Summary
  'fd -e jpg' ran
   21.89 ± 2.33 times faster than 'find . -iname "*.jpg"'
```

> Web development အတွက်မူ browser developer tool များတွင် ကောင်းမွန်လှသော profiler များ ပါဝင်သည်။ [Firefox Profiler](https://profiler.firefox.com/docs/) နှင့် [Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools/rendering-tools) မှတ်တမ်းများကို ကြည့်ရှုပါ။

# လေ့ကျင့်ခန်းများ

## Debugging

1. **Sort ပြုလုပ်သော Algorithm တစ်ခုကို Debug လုပ်ပါ**- အောက်ပါ pseudocode သည် merge sort ကို ရေးသားထားခြင်း ဖြစ်သော်လည်း bug တစ်ခု ပါဝင်နေသည်။ ၎င်းအား သင်နှစ်သက်ရာ ဘာသာစကားတစ်ခုဖြင့် ရေးသားပါ၊ ထို့နောက် bug ကို ရှာဖွေပြင်ဆင်ရန် debugger (gdb၊ lldb၊ pdb သို့မဟုတ် သင့် IDE ၏ debugger) တစ်ခုကို အသုံးပြုပါ။

   ```
   function merge_sort(arr):
       if length(arr) <= 1:
           return arr
       mid = length(arr) / 2
       left = merge_sort(arr[0..mid])
       right = merge_sort(arr[mid..end])
       return merge(left, right)

   function merge(left, right):
       result = []
       i = 0, j = 0
       while i < length(left) AND j < length(right):
           if left[i] <= right[j]:
               append result, left[i]
               i = i + 1
           else:
               append result, right[i]
               j = j + 1
       append remaining elements from left and right
       return result
   ```

   စမ်းသပ်မှုဒေတာ- `merge_sort([3, 1, 4, 1, 5, 9, 2, 6])` သည် `[1, 1, 2, 3, 4, 5, 6, 9]` ကို ပြန်ပေးရမည် ဖြစ်သည်။ မမှန်ကန်သော element ကို ရွေးချယ်နေသည့် နေရာကို ရှာဖွေရန် breakpoint များကို သုံး၍ merge function အတွင်းသို့ တစ်ဆင့်ချင်းဝင်ရောက် (step through) စစ်ဆေးပါ။

1. [`rr`](https://rr-project.org/) ကို install လုပ်ပြီး ပျက်စီးမှု bug (corruption bug) တစ်ခုကို ရှာဖွေရန် reverse debugging ကို အသုံးပြုပါ။ ဤပရိုဂရမ်ကို `corruption.c` အဖြစ် သိမ်းဆည်းပါ -

   ```c
   #include <stdio.h>

   typedef struct {
       int id;
       int scores[3];
   } Student;

   Student students[2];

   void init() {
       students[0].id = 1001;
       students[0].scores[0] = 85;
       students[0].scores[1] = 92;
       students[0].scores[2] = 78;

       students[1].id = 1002;
       students[1].scores[0] = 90;
       students[1].scores[1] = 88;
       students[1].scores[2] = 95;
   }

   void curve_scores(int student_idx, int curve) {
       for (int i = 0; i < 4; i++) {
           students[student_idx].scores[i] += curve;
       }
   }

   int main() {
       init();
       printf("=== Initial state ===\n");
       printf("Student 0: id=%d\n", students[0].id);
       printf("Student 1: id=%d\n", students[1].id);

       curve_scores(0, 5);

       printf("\n=== After curving ===\n");
       printf("Student 0: id=%d\n", students[0].id);
       printf("Student 1: id=%d\n", students[1].id);

       if (students[1].id != 1002) {
           printf("\nERROR: Student 1's ID was corrupted! Expected 1002, got %d\n",
                  students[1].id);
           return 1;
       }
       return 0;
   }
   ```

   `gcc -g corruption.c -o corruption` ဖြင့် compile လုပ်၍ run ပါ။ Student 1 ၏ ID သည် ပျက်စီးသွားသည်၊ သို့သော် ပျက်စီးမှုမှာ student 0 ကိုသာ ကိုင်တွယ်သော function တစ်ခုအတွင်း ဖြစ်ပွားခဲ့ခြင်းဖြစ်သည်။ တရားခံကို ရှာဖွေရန် `rr record ./corruption` နှင့် `rr replay` ကို အသုံးပြုပါ။ `students[1].id` ပေါ်တွင် watchpoint တစ်ခု သတ်မှတ်ပြီး ပျက်စီးသွားပြီးနောက် မည်သည့် ကုတ်လိုင်းက ၎င်းအား ထပ်မံကျော်ရေးသွားခဲ့သည်ကို အတိအကျ ရှာဖွေရန် `reverse-continue` ကို အသုံးပြုပါ။

1. AddressSanitizer ဖြင့် Memory အမှားတစ်ခုကို Debug လုပ်ပါ။ ၎င်းကို `uaf.c` အဖြစ် သိမ်းဆည်းပါ -

   ```c
   #include <stdlib.h>
   #include <string.h>
   #include <stdio.h>

   int main() {
       char *greeting = malloc(32);
       strcpy(greeting, "Hello, world!");
       printf("%s\n", greeting);

       free(greeting);

       greeting[0] = 'J';
       printf("%s\n", greeting);

       return 0;
   }
   ```

   ပထမဦးစွာ sanitizer များ မပါဘဲ compile လုပ်၍ run ပါ- `gcc uaf.c -o uaf && ./uaf`။ ၎င်းမှာ အလုပ်လုပ်နေပုံ ပေါ်နိုင်သည်။ ယခု AddressSanitizer ဖြင့် compile ပြုလုပ်ပါ- `gcc -fsanitize=address -g uaf.c -o uaf && ./uaf`။ Error report ကို ဖတ်ရှုပါ။ ASan က မည်သည့် bug ကို ရှာတွေ့သနည်း။ ၎င်းတွေ့ရှိသည့် ပြဿနာကို ပြင်ဆင်ပါ။

1. `ls -l` ကဲ့သို့သော command တစ်ခုက ပြုလုပ်သည့် system call များကို စောင့်ကြည့်ဆွဲထုတ်ရန် `strace` (Linux) သို့မဟုတ် `dtruss` (macOS) ကို အသုံးပြုပါ။ ၎င်းသည် မည်သည့် system call များကို ပြုလုပ်နေသနည်း။ ပိုမို ရှုပ်ထွေးသော ပရိုဂရမ်တစ်ခုကို စောင့်ကြည့်ဆွဲထုတ်ကြည့်ပြီး ၎င်းက မည်သည့်ဖိုင်များကို ဖွင့်လှစ်သည်ကို ကြည့်ပါ။

1. နားလည်ရခက်သော error message တစ်ခုကို debug လုပ်ကူရန် LLM ကို အသုံးပြုပါ။ Compiler error တစ်ခုကို (အထူးသဖြင့် C++ template များ သို့မဟုတ် Rust မှ) ကူးယူ၍ ရှင်းလင်းချက်နှင့် ပြင်ဆင်ချက် တောင်းဆိုကြည့်ပါ။ `strace` သို့မဟုတ် address sanitizer မှ output အချို့ကို ၎င်းအတွင်းသို့ ထည့်သွင်းကြည့်ပါ။

## Profiling

1. သင်နှစ်သက်ရာ ပရိုဂရမ်တစ်ခုအတွက် အခြေခံ စွမ်းဆောင်ရည် စာရင်းအင်းများကို ရယူရန် `perf stat` ကို အသုံးပြုပါ။ မတူညီသော counter များသည် မည်သည့်အရာကို ဆိုလိုသနည်း။

1. `perf record` ဖြင့် profile ပြုလုပ်ပါ။ ၎င်းကို `slow.c` အဖြစ် သိမ်းဆည်းပါ -

   ```c
   #include <math.h>
   #include <stdio.h>

   double slow_computation(int n) {
       double result = 0;
       for (int i = 0; i < n; i++) {
           for (int j = 0; j < 1000; j++) {
               result += sin(i * j) * cos(i + j);
           }
       }
       return result;
   }

   int main() {
       double r = 0;
       for (int i = 0; i < 100; i++) {
           r += slow_computation(1000);
       }
       printf("Result: %f\n", r);
       return 0;
   }
   ```

   Debug symbol များနှင့်အတူ compile ပြုလုပ်ပါ- `gcc -g -O2 slow.c -o slow -lm`။ `perf record -g ./slow` ကို run ပါ၊ ထို့နောက် အချိန် မည်သည့်နေရာတွင် ကုန်လွန်သည်ကို ကြည့်ရန် `perf report` ကို run ပါ။ flamegraph script များကို အသုံးပြု၍ flame graph တစ်ခု ထုတ်လုပ်ကြည့်ပါ။

1. အလုပ်တစ်ခုတည်း၏ မတူညီသော ရေးသားချက် နှစ်ခုကို benchmark တိုင်းတာရန် `hyperfine` ကို အသုံးပြုပါ (ဥပမာ- `find` နှင့် `fd`၊ `grep` နှင့် `ripgrep` သို့မဟုတ် သင့်ကိုယ်ပိုင်ကုတ်၏ ဗားရှင်းနှစ်ခု)။

1. အရင်းအမြစ် များစွာသုံးသော ပရိုဂရမ်တစ်ခုကို run နေစဉ် သင့်စနစ်ကို စောင့်ကြည့်ရန် `htop` ကို အသုံးပြုပါ။ process တစ်ခု အသုံးပြုနိုင်သော CPU များကို ကန့်သတ်ရန် `taskset` ကို သုံးကြည့်ပါ- `taskset --cpu-list 0,2 stress -c 3`။ `stress` သည် အဘယ်ကြောင့် CPU သုံးခုကို မသုံးသနည်း။

1. အတွေ့ရများသော ပြဿနာတစ်ခုမှာ သင်စောင့်နားထောင်လိုသော port ကို အခြား process တစ်ခုက ရယူထားပြီး ဖြစ်နေခြင်း ဖြစ်သည်။ ထို process ကို မည်သို့ရှာဖွေရမည်ကို လေ့လာပါ- ပထမဦးစွာ port 4444 တွင် အနည်းဆုံး web server တစ်ခု စတင်ရန် `python -m http.server 4444` ကို အကောင်အထည်ဖော်ပါ။ သီးခြား terminal တစ်ခုတွင် process ကို ရှာဖွေရန် `ss -tlnp | grep 4444` ကို run ပါ။ ၎င်းအား `kill <PID>` ဖြင့် အဆုံးသတ်ပါ။
