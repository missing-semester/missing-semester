---
layout: lecture
title: "Program Introspection"
presenter: Anish
date: 2019-01-29
order: 1
video:
  aspect: 62.5
  id: 74MhV-7hYzg
---

# Debugging

printf-debugging ပြုလုပ်ခြင်းက လုံလောက်မှု မရှိတော့သည့်အခါ debugger ကို အသုံးပြုပါ။

Debugger များသည် ပရိုဂရမ်၏ အလုပ်လုပ်ဆောင်မှု (execution) နှင့် တိုက်ရိုက် ထိတွေ့ဆက်ဆံ လုပ်ဆောင်နိုင်စေပြီး အောက်ပါ အချက်များကို ပြုလုပ်နိုင်စေပါသည်။

- သတ်မှတ်ထားသော စာကြောင်းတစ်ကြောင်းသို့ ရောက်ရှိသည့်အခါ ပရိုဂရမ် အလုပ်လုပ်နေမှုကို ရပ်တန့်ခြင်း
- ပရိုဂရမ်ကို တစ်ကြောင်းချင်းစီ (single-step) အဆင့်လိုက် ပတ်လည်စစ်ဆေး မောင်းနှင်ခြင်း
- Variable များ၏ တန်ဖိုးများကို စစ်ဆေးခြင်း
- အခြားသော အဆင့်မြင့် လုပ်ဆောင်ချက်များစွာ ပြုလုပ်နိုင်ခြင်း

## GDB/LLDB

[GDB](https://www.gnu.org/software/gdb/) နှင့် [LLDB](https://lldb.llvm.org/)။ C ၏ ပုံစံတူ ဘာသာစကား အမြောက်အမြားကို ထောက်ပံ့ပေးထားပါသည်။

[example.c](/2019/files/example.c) ကို ကြည့်ကြပါစို့။ Debug flags ဖြင့် compile လုပ်ပါ:
`gcc -g -o example example.c`။

GDB ကို ဖွင့်ပါ:

`gdb example`

အချို့သော command များ:

- `run`
- `b {name of function}` - breakpoint တစ်ခု သတ်မှတ်ရန်
- `b {file}:{line}` - breakpoint တစ်ခု သတ်မှတ်ရန်
- `c` - ဆက်လက် အလုပ်လုပ်ရန် (continue)
- `step` / `next` / `finish` - step in / step over / step out ပြုလုပ်ရန်
- `p {variable}` - variable ၏ တန်ဖိုးကို ထုတ်ပြရန်
- `watch {expression}` - expression ၏ တန်ဖိုး ပြောင်းလဲသွားသည့်အခါ အလိုအလျောက် သတိပေးရပ်တန့်မည့် watchpoint တစ်ခု သတ်မှတ်ရန်
- `rwatch {expression}` - တန်ဖိုးကို ဖတ်ရှုသည့်အခါ အလိုအလျောက် သတိပေးရပ်တန့်မည့် watchpoint တစ်ခု သတ်မှတ်ရန်
- `layout`

## PDB

[PDB](https://docs.python.org/3/library/pdb.html) သည် Python debugger ဖြစ်ပါသည်။

PDB ထဲသို့ ရောက်ရှိလိုသည့် နေရာတွင် `import pdb; pdb.set_trace()` ကို ထည့်သွင်းပါ။ ၎င်းသည် အခြေခံအားဖြင့် debugger (GDB ကဲ့သို့) နှင့် Python shell တို့ကို ပေါင်းစပ်ထားသော hybrid စနစ်တစ်ခု ဖြစ်ပါသည်။

## Web browser Developer Tools

နောက်ထပ် debugger အမျိုးအစား တစ်ခု ဖြစ်ပြီး ယခုတစ်ကြိမ်တွင်မူ graphical interface ပါဝင်ပါသည်။

# strace

ပရိုဂရမ်တစ်ခုမှ ပြုလုပ်သော system call များကို လေ့လာစောင့်ကြည့်ခြင်း: `strace {program}`။

# Profiling

Profiling အမျိုးအစားများ: CPU, memory အစရှိသည်တို့ ဖြစ်ကြသည်။

အရိုးရှင်းဆုံး profiler: `time`။

## Go

Test code ကို CPU profiler ဖြင့် မောင်းနှင်ပါ: `go test -cpuprofile=cpu.out`

Profile ကို ဆန်းစစ်သုံးသပ်ပါ: `go tool pprof -web cpu.out`

Test code ကို Memory profiler ဖြင့် မောင်းနှင်ပါ: `go test -memprofile=mem.out`

Profile ကို ဆန်းစစ်သုံးသပ်ပါ: `go tool pprof -web mem.out`

## Perf

အခြေခံ စွမ်းဆောင်ရည် စာရင်းအင်းများ: `perf stat {command}`

ပရိုဂရမ်ကို profiler ဖြင့် မောင်းနှင်ပါ: `perf record {command}`

Profile ကို ဆန်းစစ်သုံးသပ်ပါ: `perf report`
