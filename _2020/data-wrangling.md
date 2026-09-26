---
layout: lecture
title: "Data Wrangling"
description: >
  sed၊ awk နှင့် Regular Expression များကဲ့သို့သော Command-line tool များကို အသုံးပြု၍ ဒေတာများကို ပြုပြင်ပြောင်းလဲနည်း လေ့လာပါ။
thumbnail: /static/assets/thumbnails/2020/lec4.png
date: 2020-01-16
ready: true
video:
  aspect: 56.25
  id: sz_dsktIjt4
special: true
---

ဒေတာများကို Format တစ်ခုမှ အခြား Format တစ်ခုသို့ ပြောင်းလဲလိုသည့် အခြေအနေမျိုး ကြုံတွေ့ဖူးပါသလား။ အမှန်တကယ် ကြုံဖူးကြပါလိမ့်မည်။ ဤသင်ခန်းစာသည် ယင်းအကြောင်းကို အဓိကထား သင်ကြားပေးသွားမည် ဖြစ်ပါသည်။ အထူးသဖြင့် စာသား သို့မဟုတ် Binary format ရှိ ဒေတာများကို မိမိ လိုချင်သော ပုံစံအတိုင်း ရရှိသည်အထိ ပြုပြင်ပြင်ဆင်ခြင်း (Data Wrangling) အကြောင်း ဖြစ်ပါသည်။

ယခင် သင်ခန်းစာများတွင် အခြေခံ Data Wrangling အချို့ကို တွေ့မြင်ခဲ့ရပြီး ဖြစ်သည်။ `|` (pipe) operator ကို အသုံးပြုတိုင်း Data Wrangling ကို ပြုလုပ်နေခြင်း ဖြစ်သည်။ ဥပမာ `journalctl | grep -i intel` command ကို ကြည့်ပါ။ ယင်းက စနစ်၏ Log များအနက် Intel ပါဝင်သော စာကြောင်းများကို ရှာဖွေပေးသည်။ ဤသည်မှာ စနစ် log အပြည့်အစုံမှ မိမိအတွက် အသုံးဝင်သော Format သို့ ပြောင်းလဲလိုက်ခြင်း ဖြစ်သည်။ Data Wrangling ၏ အဓိက သဘောတရားမှာ မိမိ ထံတွင် ရှိသော tool များကို မည်သို့ ပေါင်းစပ် အသုံးပြုရမည်ကို တတ်မြောက်ထားခြင်း ဖြစ်သည်။

အစမှ စတင်ကြည့်ကြပါစို့။ Data wrangle ပြုလုပ်ရန်အတွက် အရာနှစ်ခု လိုအပ်သည်—Wrangle ပြုလုပ်မည့် ဒေတာ နှင့် ယင်းဒေတာကို ပြုလုပ်မည့် အရာ တို့ ဖြစ်ကြသည်။ Log ဖိုင်များသည် အလွန် ကောင်းမွန်သော စံနမူနာ ဖြစ်သည်၊ အကြောင်းမှာ ယင်းတို့ကို လေ့လာကြည့်ရှုရန် လိုအပ်သော်လည်း ဖိုင်တစ်ခုလုံးကို ဖတ်ရှုရန် မဖြစ်နိုင်သောကြောင့် ဖြစ်သည်။ အောက်ပါ command ဖြင့် Server ၏ log ကို စစ်ဆေးကြည့်ပါ-

```bash
ssh myserver journalctl
```

ဤသည်မှာ စာသားများ လွန်စွာ များပြားလှသည်။ SSH နှင့် သက်ဆိုင်သည်များကိုသာ ခွဲထုတ်ကြည့်ကြမည်-

```bash
ssh myserver journalctl | grep sshd
```

ဒီနေရာမှာ Pipe ကို အသုံးပြု၍ Remote server ပေါ်ရှိ ဖိုင်ကို မိမိ စက်ပေါ်ရှိ `grep` ထံသို့ Stream ပြုလုပ်ပေးပို့ထားခြင်း ဖြစ်သည်။ ဤသည်မှာလည်း အချက်အလက်များ လွန်စွာ များပြားနေပါသေးသည်။ ထို့ကြောင့် အောက်ပါအတိုင်း ပိုမို ကောင်းမွန်အောင် ပြုလုပ်ကြပါစို့-

```bash
ssh myserver 'journalctl | grep sshd | grep "Disconnected from"' | less
```

အဘယ်ကြောင့် Quote ခံထားသနည်း။ Log များသည် အလွန် ကြီးမားနိုင်သဖြင့် မိမိ စက်ထံသို့ ဒေတာ အားလုံး Stream လုပ်ပြီးမှ Filter လုပ်ခြင်းသည် ကွန်ရက် လှိုင်းနှုန်း အဟောသိက္ခာ ဖြစ်စေသည်။ ထို့ကြောင့် Remote server ပေါ်တွင် Filter စတင် ပြုလုပ်ပြီးမှ မိမိ စက်ထံသို့ ပေးပို့ခြင်း ဖြစ်သည်။ `less` သည် စာသားများကို အထက်အောက် ရွှေ့လျားကြည့်ရှုနိုင်သော Pager ကို ပံ့ပိုးပေးသည်။ ယာယီ ဖိုင်အဖြစ် သိမ်းဆည်း၍လည်း ကြည့်ရှုနိုင်ပါသည်-

```console
$ ssh myserver 'journalctl | grep sshd | grep "Disconnected from"' > ssh.log
$ less ssh.log
```

ဤနေရာတွင် မလိုအပ်သော စာသားများ ပါဝင်နေသေးသည်။ ယင်းတို့ကို ဖယ်ရှားရန်အတွက် အလွန် စွမ်းအားထက်မြက်သော tool တစ်ခု ဖြစ်သည့် **`sed`** ကို လေ့လာကြပါစို့။

`sed` သည် "stream editor" တစ်ခု ဖြစ်သည်။ ယင်းတွင် ဖိုင်ကို တိုက်ရိုက် ပြုပြင်ခြင်းထက် မည်သို့ ပြုပြင်ရမည်ဆိုသော Command တိုများကို ပေးပို့ရသည်။ အသုံးအများဆုံး Command မှာ `s` (substitution - အစားထိုးခြင်း) ဖြစ်သည်-

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed 's/.*Disconnected from //'
```

ယခု ကျွန်ုပ်တို့ ရေးသားလိုက်သည်မှာ **Regular Expression** (Regex) ဖြစ်သည်။ ယင်းသည် စာသားများကို ပုံစံ (pattern) များနှင့် တိုက်ဆိုင် စစ်ဆေးပေးသော စွမ်းအားထက်မြက်သည့် စနစ်ဖြစ်သည်။ `s` command ၏ ပုံစံမှာ `s/REGEX/SUBSTITUTION/` ဖြစ်သည်။

## Regular expressions (ပုံမှန် ဖော်ပြချက်များ)

Regular expression များကို နားလည်ထားခြင်းသည် အလွန် အသုံးဝင်လှပါသည်။ အထက်ပါ ဥပမာ `/.*Disconnected from /` ကို လေ့လာကြည့်ကြပါစို့။ 

အသုံးများသော Regex Pattern များမှာ-
 - `.` Newline မှလွဲ၍ မည်သည့် စာလုံးတစ်လုံးမဆို
 - `*` ရှေ့ စာလုံး 0 ခု သို့မဟုတ် မည်မျှမဆို ပါဝင်ခြင်း
 - `+` ရှေ့ စာလုံး 1 ခု သို့မဟုတ် မည်မျှမဆို ပါဝင်ခြင်း
 - `[abc]` `a`၊ `b` သို့မဟုတ် `c` အနက် စာလုံးတစ်လုံး ပါဝင်ခြင်း
 - `(RX1|RX2)` `RX1` သို့မဟုတ် `RX2` ကို ကိုက်ညီခြင်း
 - `^` စာကြောင်း ၏ အစ
 - `$` စာကြောင်း ၏ အဆုံး

`sed` တွင် အထူး သင်္ကေတများ အဖြစ် အဓိပ္ပာယ်ဖော်ရန် `\` ခံပေးရန် လိုအပ်သည် သို့မဟုတ် `-E` flag ကို အသုံးပြုနိုင်ပါသည်။

Perl command-line တွင် non-greedy matching ပြုလုပ်ရန် `?` ကို အသုံးပြုနိုင်သည်-

```bash
perl -pe 's/.*?Disconnected from //'
```

ဖိုင် စာကြောင်း တစ်ခုလုံးကို တိုက်ဆိုင် စစ်ဆေးရန်-

```bash
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user .* [^ ]+ port [0-9]+( \[preauth\])?$//'
```

မိမိ သိမ်းဆည်းလိုသော စာသားကို Capture Group ဖြင့် သိမ်းဆည်းနိုင်သည်-

```bash
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

Regex များကို စမ်းသပ်ရန် [regex101.com](https://regex101.com/) ကဲ့သို့သော ဝဘ်ဆိုက်များကို အသုံးပြုနိုင်ပါသည်။

## Back to data wrangling (Data wrangling သို့ ပြန်လည် ဝင်ရောက်ခြင်း)

ယခု ကျွန်ုပ်တို့တွင် အောက်ပါ Command ရှိနေပြီ ဖြစ်သည်-

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

မကြာခဏ ရောက်ရှိလာသော အသုံးပြုသူ အမည်များကို စီစဉ် ကြည့်ရှုရန် `sort` နှင့် `uniq -c` ကို အသုံးပြုနိုင်သည်-

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
```

`sort -n` သည် ကိန်းဂဏန်း အစဉ်လိုက် စီစဉ်ပေးပြီး `-k1,1` သည် ပထမဆုံး ကော်လံအတိုင်း စီစဉ်ပေးသည်။

ရလဒ်များကို စာကြောင်း တစ်ကြောင်းစီ မဟုတ်ဘဲ ကော်မာ ခွဲခြားထားသော စာရင်းအဖြစ် ပြောင်းလဲရန် `paste -sd,` ကို အသုံးပြုနိုင်သည်-

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
 | awk '{print $2}' | paste -sd,
```

## awk -- အခြား Editor တစ်ခု (awk -- another editor)

`awk` သည် စာသား သတင်းအချက်အလက် စီးကြောင်းများကို ပြုပြင်ရာတွင် အလွန် ကောင်းမွန်သော ပရိုဂရမ်းမင်း ဘာသာစကား ဖြစ်သည်။

`awk` တွင် `$0` သည် စာကြောင်း တစ်ကြောင်းလုံး ဖြစ်ပြီး `$1` မှ `$n` တို့မှာ ကော်လံ (field) များ ဖြစ်ကြသည်။ `{print $2}` သည် ဒုတိယ ကော်လံကို ထုတ်ပေးခြင်း ဖြစ်သည်။

```bash
 | awk '$1 == 1 && $2 ~ /^c[^ ]*e$/ { print $2 }' | wc -l
```

`awk` ပရိုဂရမ် တွင် `BEGIN` နှင့် `END` ဘလောက်များကို အသုံးပြု၍ တွက်ချက်မှုများ ပြုလုပ်နိုင်သည်-

```awk
BEGIN { rows = 0 }
$1 == 1 && $2 ~ /^c[^ ]*e$/ { rows += $1 }
END { print rows }
```

## ဒေတာများကို ဆန်းစစ်ခြင်း (Analyzing data)

`bc` ကို အသုံးပြု၍ Shell တွင် သင်္ချာ တွက်ချက်မှုများ ပြုလုပ်နိုင်သည်-

```bash
 | paste -sd+ | bc -l
```

[R](https://www.r-project.org/) ကို အသုံးပြု၍ အချက်အလက် စာရင်းအင်းများကို ဆန်းစစ်နိုင်သည်-

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | awk '{print $1}' | R --no-echo -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
```

`gnuplot` ကို အသုံးပြု၍ Graph ပုံစံ ရေးဆွဲနိုင်သည်-

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
 | gnuplot -p -e 'set boxwidth 0.5; plot "-" using 1:xtic(2) with boxes'
```

## Binary data များကို ပြုပြင်ခြင်း (Wrangling binary data)

`ffmpeg` နှင့် `gzip` များကို အသုံးပြု၍ Binary data များကိုလည်း Pipe ဖြင့် ချိတ်ဆက် ပြုပြင်နိုင်သည်-

```bash
ffmpeg -loglevel panic -i /dev/video0 -frames 1 -f image2 -
 | convert - -colorspace gray -
 | gzip
 | ssh mymachine 'gzip -d | tee copy.jpg | env DISPLAY=:0 feh -'
```

# လေ့ကျင့်ခန်းများ (Exercises)

၁။ [RegexOne](https://regexone.com/) တွင် Regular Expression လေ့ကျင့်ခန်းများကို လေ့ကျင့်ပါ။
၂။ `/usr/share/dict/words` ထဲတွင် အနည်းဆုံး `a` ၃ လုံး ပါဝင်ပြီး `'s` ဖြင့် မဆုံးသော စကားလုံး အရေအတွက်ကို ရှာဖွေပါ။
၃။ `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt` ဟု ရေးသားခြင်းသည် အဘယ်ကြောင့် မကောင်းသနည်း။ `man sed` တွင် အစားထိုးနည်းကို ရှာဖွေပါ။
၄။ မိမိ စက်၏ နောက်ဆုံး boot တက်ခဲ့သော စာရင်းများမှ ပျမ်းမျှ၊ မီဒီယံနှင့် အများဆုံး အချိန်ကို ရှာဖွေပါ။ (`journalctl` သို့မဟုတ် `log show` ကို အသုံးပြုပါ)။
၅။ နောက်ဆုံး ၃ ကြိမ် boot တက်မှုအတွင်း တူညီမှု မရှိသော log စာကြောင်းများကို ရှာဖွေပါ။
၆။ အွန်လိုင်း ဒေတာ အစုံများမှ `curl` ဖြင့် ဒေတာ ရယူပြီး `jq` သို့မဟုတ် `pup` အသုံးပြု၍ ကော်လံ နှစ်ခုကို ခွဲထုတ်ပါ။
