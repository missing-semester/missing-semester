---
layout: lecture
title: "Version Control (Git)"
description: >
  Git ၏ data model နှင့် Version control၊ ပူးပေါင်းဆောင်ရွက်မှုများအတွက် Git ကို မည်သို့ အသုံးပြုရမည်နည်း လေ့လာပါ။
thumbnail: /static/assets/thumbnails/2020/lec6.png
date: 2020-01-22
ready: true
video:
  aspect: 56.25
  id: 2sjqTHE0zok
---

Version control systems (VCSs) ဆိုသည်မှာ Source Code များ (သို့မဟုတ် အခြား ဖိုင်နှင့် Folder စုစည်းမှုများ) ၏ အပြောင်းအလဲများကို ခြေရာခံရန် အသုံးပြုသည့် Tool များ ဖြစ်ကြသည်။ အမည်တွင် ဖော်ပြထားသည့်အတိုင်း ဤ Tool များသည် အပြောင်းအလဲများ၏ သမိုင်းကြောင်းကို ထိန်းသိမ်းပေးသည့်အပြင် အခြားသူများနှင့် ပူးပေါင်းဆောင်ရွက်မှုကိုလည်း လွယ်ကူစေပါသည်။
VCS များသည် Folder တစ်ခုနှင့် ယင်း၏ ပါဝင်မှုများကို ပုံရိပ်လွှာ (snapshot) အစဉ်လိုက်များဖြင့် ခြေရာခံပေးပြီး၊ Snapshot တစ်ခုစီသည် Top-level Directory အတွင်းရှိ ဖိုင်/Folder များ၏ အခြေအနေတစ်ခုလုံးကို ငုံ့ကြည့်နိုင်အောင် စုစည်းထားပေးပါသည်။ ထို့အပြင် VCS များသည် Snapshot တစ်ခုစီကို မည်သူဖန်တီးခဲ့သည်၊ အမှတ်အသား စာတိုများ (messages) အစရှိသည့် Metadata များကိုပါ ထိန်းသိမ်းပေးပါသည်။

Version control ကို အသုံးပြုခြင်းသည် အဘယ်ကြောင့် အသုံးဝင်သနည်း။ မိမိတစ်ဦးတည်း အလုပ်လုပ်နေချိန်တွင်ပင် ပရောဂျက်၏ Snapshot အဟောင်းများကို ပြန်လည်ကြည့်ရှုနိုင်ခြင်း၊ အချို့သော အပြောင်းအလဲများကို အဘယ်ကြောင့် ပြုလုပ်ခဲ့ကြောင်း မှတ်တမ်းတင်ထားနိုင်ခြင်း၊ ပြိုင်တူ ဖွံ့ဖြိုးတိုးတက်ရေး Branch များ (parallel branches) ဖြင့် အလုပ်လုပ်နိုင်ခြင်း အစရှိသည်တို့ကို ပြုလုပ်နိုင်ပါသည်။ အခြားသူများနှင့် ပူးပေါင်းလုပ်ဆောင်သည့်အခါတွင်လည်း အခြားသူများ မည်သည့်အရာများ ပြောင်းလဲထားသည်ကို ကြည့်ရှုနိုင်သည့်အပြင် ပြိုင်တူ လုပ်ဆောင်ရာတွင် ဖြစ်ပေါ်လာသည့် ပဋိပက္ခများ (conflicts) ကို ဖြေရှင်းရာ၌ အလွန် တန်ဖိုးရှိသော Tool ဖြစ်ပါသည်။

ခေတ်မီ VCS များသည် အောက်ပါ မေးခွန်းများကိုလည်း လွယ်ကူစွာ (နှင့် အလိုအလျောက်) ဖြေကြားပေးနိုင်ပါသည် -

- ဤ Module ကို မည်သူ ရေးသားခဲ့သနည်း။
- ဤ ဖိုင်၏ ဤ သီးခြား စာကြောင်းကို မည်သည့်အချိန်တွင်၊ မည်သူက ပြင်ဆင်ခဲ့သနည်း။ အဘယ်ကြောင့် ပြင်ဆင်ခဲ့သနည်း။
- လွန်ခဲ့သော မူကွဲ ၁၀၀၀ အတွင်း၊ မည်သည့်အချိန်/မည်သည့်အကြောင်းကြောင့် သီးခြား Unit Test တစ်ခု အလုပ်မလုပ်တော့ဘဲ ဖြစ်သွားသနည်း။

အခြားသော VCS များ ရှိသော်လည်း **Git** သည် Version control အတွက် အဓိက စံနှုန်း (de facto standard) ဖြစ်ပါသည်။
ဤ [XKCD comic](https://xkcd.com/1597/) လေးသည် Git ၏ ကျော်ကြားမှုကို သရော်ထားပါသည် -

![xkcd 1597](https://imgs.xkcd.com/comics/git.png)

Git ၏ Interface သည် leaky abstraction ဖြစ်သောကြောင့် Git ကို Top-down နည်းလမ်းဖြင့် (ယင်း၏ Interface / Command-line Interface မှ စတင်၍) လေ့လာခြင်းသည် ရှုပ်ထွေးမှုများစွာ ဖြစ်ပေါ်စေနိုင်ပါသည်။ Command အနည်းငယ်ကို အလွတ်ကျက်မှတ်ထားပြီး မန္တန်အဖြစ် မှတ်ယူကာ၊ ပြဿနာ တစ်ခုခု တက်လာပါက အထက်ပါ Comic ပါ အယူအဆအတိုင်း ပြုလုပ်လေ့ ရှိကြပါသည်။

Git တွင် ရှုပ်ထွေးသော Interface ရှိသည်ကို လက်ခံရမည် ဖြစ်သော်လည်း ယင်း၏ အောက်ခံ ဒီဇိုင်းနှင့် အယူအဆများသည် အလွန် သပ်ရပ်လှပပါသည်။ ရှုပ်ထွေးသော Interface ကို အလွတ်ကျက်မှတ်ရမည် ဖြစ်သော်လည်း လှပသော ဒီဇိုင်းကိုမူ _နားလည်သဘောပေါက်_ နိုင်ပါသည်။ ထို့ကြောင့် ကျွန်ုပ်တို့သည် Git ကို ယင်း၏ Data model မှ စတင်၍ အောက်ခြေမှ အထက်သို့ (Bottom-up) ရှင်းလင်းသင်ကြားပေးမည် ဖြစ်ပြီး၊ နောက်ပိုင်းမှ Command-line Interface အကြောင်းကို လွှမ်းခြုံ သင်ကြားပါမည်။ Data model ကို နားလည်သွားပါက Command များသည် အောက်ခံ Data model ကို မည်သို့ စီမံခန့်ခွဲသည်ဆိုသည်ကို ပိုမို နားလည်သဘောပေါက်လာပါမည်။

# Git's data model

Version control အတွက် အသုံးပြုနိုင်သော နည်းလမ်းများစွာ ရှိပါသည်။ Git တွင် Version control ၏ အင်္ဂါရပ်ကောင်းများဖြစ်သော သမိုင်းကြောင်း ထိန်းသိမ်းခြင်း၊ Branch များကို ထောက်ပံ့ခြင်း နှင့် ပူးပေါင်းဆောင်ရွက်မှုကို လွယ်ကူစေခြင်း အစရှိသည်တို့ကို အပြည့်အဝ ပေးစွမ်းနိုင်သည့် သေချာစွာ စနစ်တကျ ရေးဆွဲထားသော Model တစ်ခု ရှိပါသည်။

## Snapshots

Git သည် Top-level Directory တွင်းရှိ ဖိုင်များနှင့် Folder များ စုစည်းမှု၏ သမိုင်းကြောင်းကို Snapshot များ အစဉ်လိုက်အဖြစ် ပုံဖော်ထားပါသည်။ Git ဝေါဟာရတွင် ဖိုင်ကို "blob" ဟု ခေါ်ဆိုပြီး ယင်းသည် Byte အစုအဝေးမျှသာ ဖြစ်သည်။ Directory ကို "tree" ဟု ခေါ်ဆိုပြီး ယင်းသည် အမည်များကို blobs သို့မဟုတ် trees သို့ ချိတ်ဆက်ပေးပါသည် (ထို့ကြောင့် Directory များတွင် အခြား Directory များ ပါဝင်နိုင်သည်)။ Snapshot ဆိုသည်မှာ ခြေရာခံနေသော Top-level Tree ဖြစ်ပါသည်။ ဥပမာအားဖြင့် အောက်ပါအတိုင်း Tree တစ်ခု ရှိနိုင်ပါသည် -

```
<root> (tree)
|
+- foo (tree)
|  |
|  + bar.txt (blob, contents = "hello world")
|
+- baz.txt (blob, contents = "git is wonderful")
```

Top-level Tree တွင် အစိတ်အပိုင်း နှစ်ခု ပါဝင်ပါသည်၊ "foo" ဟုခေါ်သော Tree တစ်ခု (၎င်းကိုယ်တိုင်တွင် "bar.txt" ဟုခေါ်သော blob တစ်ခု ပါဝင်သည်) နှင့် "baz.txt" ဟုခေါ်သော blob တစ်ခုတို့ ဖြစ်ကြသည်။

## Modeling history: relating snapshots

Version control စနစ်တစ်ခုသည် Snapshot များကို မည်သို့ ဆက်စပ်ပေးသင့်သနည်း။ ရိုးရှင်းသော Model တစ်ခုမှာ မျဉ်းဖြောင့် သမိုင်းကြောင်း (linear history) ဖြစ်ပါမည်။ သမိုင်းကြောင်းသည် အချိန်အစဉ်လိုက် Snapshot များ၏ စာရင်း ဖြစ်ပါမည်။ သို့သော် အကြောင်းကြောင်း ကြောင့် Git သည် ဤကဲ့သို့ ရိုးရှင်းသော Model ကို မသုံးပါ။

Git တွင် သမိုင်းကြောင်းဆိုသည်မှာ Snapshot များ၏ Directed Acyclic Graph (DAG) ဖြစ်ပါသည်။ ဤသည်မှာ သင်္ချာစကားလုံးဆန်း ဖြစ်ကောင်းဖြစ်နိုင်သော်လည်း စိတ်မပူပါနှင့်။ ဤသည်၏ အဓိပ္ပာယ်မှာ Git ရှိ Snapshot တစ်ခုစီသည် ယင်း၏ အလျင် ရှိခဲ့သော မိဘများ "parents" ၏ အစုအဝေးကို ညွှန်းဆိုနေခြင်း ဖြစ်ပါသည်။ မိဘ တစ်ခုတည်း (linear history တွင် ဖြစ်သကဲ့သို့) မဟုတ်ဘဲ မိဘ အစုအဝေး ဖြစ်နေရခြင်းမှာ Snapshot တစ်ခုသည် မိဘများစွာမှ ဆင်းသက်လာနိုင်သောကြောင့် ဖြစ်သည် (ဥပမာ ပြိုင်တူ ဖွံ့ဖြိုးတိုးတက်နေသော Branch နှစ်ခုကို ပေါင်းစပ် merge လုပ်လိုက်သည့်အခါမျိုးတွင် ဖြစ်သည်)။

Git သည် ဤ Snapshot များကို "commit" များဟု ခေါ်ဆိုပါသည်။ Commit သမိုင်းကြောင်းကို ပုံဖော်ကြည့်ပါက အောက်ပါအတိုင်း တွေ့ရပါမည် -

```
o <-- o <-- o <-- o
            ^
             \
              --- o <-- o
```

အထက်ပါ ASCII Art တွင် `o` များသည် သီးခြား Commit (snapshot) များကို ကိုယ်စားပြုပါသည်။
မြားများသည် Commit တစ်ခုစီ၏ Parent ကို ညွှန်ပြနေခြင်း ဖြစ်ပါသည် ("နောက်မှ လာသည်" မဟုတ်ဘဲ "ရှေ့မှ လာသည်" ဆက်ဆံရေး ဖြစ်သည်)။ တတိယ Commit ပြီးနောက် သမိုင်းကြောင်းသည် သီးခြား Branch နှစ်ခုအဖြစ် ခွဲထွက်သွားသည်။ ဤသည်မှာ ဥပမာအားဖြင့် သီးခြား Feature နှစ်ခုကို တစ်ပြိုင်နက်တည်း သီးခြားစီ ဖွံ့ဖြိုးတိုးတက်အောင် ပြုလုပ်နေခြင်းနှင့် တူညီပါသည်။ နောင်တွင် ဤ Branch နှစ်ခုကို Merge ပြုလုပ်၍ Feature နှစ်ခုစလုံး ပါဝင်သော Snapshot အသစ်တစ်ခုကို ဖန်တီးနိုင်ပြီး၊ အောက်ပါအတိုင်း သမိုင်းကြောင်း အသစ်တစ်ခု ထွက်ပေါ်လာမည် ဖြစ်ကာ Merge commit အသစ်ကို စာလုံးအထူဖြင့် ဖော်ပြထားပါသည် -

<pre class="highlight">
<code>
o <-- o <-- o <-- o <---- <strong>o</strong>
            ^            /
             \          v
              --- o <-- o
</code>
</pre>

Git ရှိ Commit များသည် မပြောင်းလဲနိုင်သော (immutable) အရာများ ဖြစ်ကြသည်။ ဤသည်မှာ အမှားများကို ပြင်ဆင်၍ မရနိုင်ဟု ဆိုလိုခြင်း မဟုတ်ပါ၊ Commit သမိုင်းကြောင်းကို "ပြင်ဆင်ခြင်း" ဆိုသည်မှာ အမှန်တကယ်အားဖြင့် Commit အသစ်တစ်ခုလုံးကို ဖန်တီးလိုက်ခြင်း ဖြစ်ပြီး References များကို Commit အသစ်သို့ ညွှန်ပြအောင် အပ်ဒိတ်လုပ်လိုက်ခြင်း ဖြစ်သည်။

## Data model, as pseudocode

Git ၏ Data model ကို Pseudocode ဖြင့် ရေးသားထားသည်ကို ကြည့်ပါက ပိုမို ရှင်းလင်းသွားပါမည် -

```
// file ဆိုသည်မှာ Byte အစုအဝေး ဖြစ်သည်
type blob = array<byte>

// directory တွင် အမည်တပ်ထားသော ဖိုင်များနှင့် directory များ ပါဝင်သည်
type tree = map<string, tree | blob>

// commit တွင် parents, metadata နှင့် top-level tree တို့ ပါဝင်သည်
type commit = struct {
    parents: array<commit>
    author: string
    message: string
    snapshot: tree
}
```

ဤသည်မှာ သမိုင်းကြောင်း၏ သပ်ရပ်ရှင်းလင်းသော Model ဖြစ်ပါသည်။

## Objects and content-addressing

"object" ဆိုသည်မှာ blob, tree သို့မဟုတ် commit ဖြစ်ပါသည် -

```
type object = blob | tree | commit
```

Git data store တွင် object အားလုံးကို ယင်းတို့၏ [SHA-1 hash](https://en.wikipedia.org/wiki/SHA-1) ဖြင့် Content-addressing ပြုလုပ်ထားပါသည် -

```
objects = map<string, object>

def store(object):
    id = sha1(object)
    objects[id] = object

def load(id):
    return objects[id]
```

Blobs, trees နှင့် commits များကို ဤနည်းဖြင့် ပေါင်းစည်းထားပါသည် - ယင်းတို့ အားလုံးသည် object များ ဖြစ်ကြသည်။ ယင်းတို့သည် အခြား object များကို ညွှန်းဆိုသည့်အခါ၊ Disc ပေါ်တွင် Object တစ်ခုလုံးကို _ထည့်သွင်း_ ထားခြင်း မဟုတ်ဘဲ Hash ဖြင့် ညွှန်းဆိုထားသော Reference ကိုသာ သိမ်းဆည်းထားပါသည်။

ဥပမာအားဖြင့် [အထက်ပါ](#snapshots) Directory စနစ်၏ Tree ကို (`git cat-file -p 698281bc680d1995c5f4caaf3359721a5a58d48d` ဖြင့် ကြည့်ရှုထားသော) အောက်ပါအတိုင်း တွေ့ရပါမည် -

```
100644 blob 4448adbf7ecd394f42ae135bbeed9676e894af85    baz.txt
040000 tree c68d233a33c5c06e0340e4c224f0afca87c8ce87    foo
```

Tree ကိုယ်တိုင်တွင် ပါဝင်သော အရာများဖြစ်သည့် `baz.txt` (blob) နှင့် `foo` (tree) သို့ ညွှန်ပြသော Pointers များ ပါဝင်ပါသည်။ `git cat-file -p 4448adbf7ecd394f42ae135bbeed9676e894af85` Command ဖြင့် `baz.txt` ၏ hash ဖြင့် ကြည့်ရှုလိုက်ပါက အောက်ပါအတိုင်း ရရှိမည် ဖြစ်သည် -

```
git is wonderful
```

## References

ယခုအခါ Snapshot အားလုံးကို SHA-1 Hashes များဖြင့် ခွဲခြားသတ်မှတ်နိုင်ပြီ ဖြစ်သည်။ သို့သော် လူများသည် 16 စီးပါ 40-digit Hexadecimal စာလုံးများကို မှတ်မိရန် မလွယ်ကူသဖြင့် အဆင်မပြေပါ။

ဤပြဿနာအတွက် Git ၏ ဖြေရှင်းချက်မှာ SHA-1 Hashes များကို လူနားလည်လွယ်သော အမည်များ ပေးခြင်းဖြစ်ပြီး ယင်းတို့ကို "References" ဟု ခေါ်ဆိုပါသည်။ References များသည် Commit များကို ညွှန်ပြသော Pointers များ ဖြစ်ကြသည်။ မပြောင်းလဲနိုင်သော Objects များနှင့် မတူဘဲ References များသည် ပြောင်းလဲနိုင်ပါသည် (Commit အသစ်သို့ ညွှန်ပြအောင် အပ်ဒိတ်လုပ်နိုင်သည်)။ ဥပမာအားဖြင့် `master` reference သည် အဓိက Branch ၏ နောက်ဆုံး Commit ကို ညွှန်ပြလေ့ ရှိပါသည်။

```
references = map<string, string>

def update_reference(name, id):
    references[name] = id

def read_reference(name):
    return references[name]

def load_reference(name_or_id):
    if name_or_id in references:
        return load(references[name_or_id])
    else:
        return load(name_or_id)
```

ဤနည်းဖြင့် Git သည် ရှည်လျားသော Hexadecimal String အစား "master" ကဲ့သို့သော လူနားလည်လွယ်သော အမည်များကို သမိုင်းကြောင်းရှိ သီးခြား Snapshot များကို ညွှန်းဆိုရန် အသုံးပြုနိုင်ပါသည်။

အသေးစိတ် အချက်တစ်ခုမှာ သမိုင်းကြောင်းတွင် "လက်ရှိ ရောက်ရှိနေသော နေရာ" ကို သိရှိလိုခြင်း ဖြစ်သည်၊ ထို့မှသာ Snapshot အသစ်တစ်ခု ရယူသည့်အခါ မည်သည့်အရာနှင့် ယှဉ်တွဲရမည်နည်း (Commit ၏ `parents` field ကို မည်သို့ သတ်မှတ်မည်နည်း) ကို သိရှိနိုင်မည် ဖြစ်သည်။ Git တွင် ထို "လက်ရှိ ရောက်ရှိနေသော နေရာ" သည် "HEAD" ဟုခေါ်သော အထူး Reference ဖြစ်ပါသည်။

## Repositories

နောက်ဆုံးတွင် Git _repository_ ၏ အဓိပ္ပာယ်ကို သတ်မှတ်နိုင်ပါပြီ - ယင်းသည် `objects` နှင့် `references` Data များ ဖြစ်ကြပါသည်။

Disc ပေါ်တွင် Git သိမ်းဆည်းထားသမျှသည် objects နှင့် references များသာ ဖြစ်ကြသည် - Git ၏ Data model တွင် ဒါအကုန်ပါပဲ။ `git` command အားလုံးသည် objects များကို ထည့်သွင်းခြင်းနှင့် references များကို အပ်ဒိတ်လုပ်ခြင်းဖြင့် Commit DAG ကို မွမ်းမံ ပြင်ဆင်နေခြင်း ဖြစ်ပါသည်။

Command တစ်ခုခုကို ရိုက်နှိပ်လိုက်တိုင်း၊ ထို Command သည် အောက်ခံ Graph Data Structure ကို မည်သို့ ပြောင်းလဲနေသည်ဆိုသည်ကို စဉ်းစားပါ။ အလားတူပင် Commit DAG သို့ သီးခြား ပြောင်းလဲမှုတစ်ခုခု ပြုလုပ်လိုပါက (ဥပမာ "မသိမ်းရသေးသော အပြောင်းအလဲများကို စွန့်ပစ်ပြီး 'master' ref ကို commit `5d83f9e` သို့ ညွှန်ပြပါ") ထိုသို့ ပြုလုပ်ရန် Command တစ်ခုခု ရှိနေမည် ဖြစ်သည် (ဥပမာ `git checkout master; git reset --hard 5d83f9e`)။

# Staging area

ဤသည်မှာ Data model နှင့် သီးခြား အယူအဆ ဖြစ်သော်လည်း Commit များ ဖန်တီးသည့် Interface ၏ အစိတ်အပိုင်းတစ်ခု ဖြစ်ပါသည်။

Snapshot ရယူခြင်းကို အကောင်အထည်ဖော်ရာတွင် Working Directory ၏ _လက်ရှိ အခြေအနေ_ ကို အခြေခံ၍ Snapshot အသစ် ဖန်တီးပေးသည့် "create snapshot" command တစ်ခု ရှိမည်ဟု ထင်မြင်နိုင်ပါသည်။ အချို့သော Version control tool များသည် ဤသို့ အလုပ်လုပ်ကြသော်လည်း Git မဟုတ်ပါ။ ကျွန်ုပ်တို့သည် သပ်ရပ်သန့်ရှင်းသော Snapshot များကို အလိုရှိကြပြီး၊ လက်ရှိ အခြေအနေ တစ်ခုလုံးမှ Snapshot ရယူခြင်းသည် အမြဲတမ်း မသင့်တော်နိုင်ပါ။ ဥပမာအားဖြင့် သီးခြား Feature နှစ်ခုကို ရေးသားထားပြီး သီးခြား Commit နှစ်ခု ဖန်တီးလိုသည် ဆိုပါစို့၊ ပထမ Commit တွင် ပထမ Feature ပါဝင်ပြီး ဒုတိယ Commit တွင် ဒုတိယ Feature ပါဝင်စေလိုသည်။ သို့မဟုတ် Code တွင် ပုံနှိပ်ထုတ်ဝေထားသော Debugging print စာကြောင်းများ ပါဝင်နေပြီး Bugfix နှင့်အတူ ရောနှောနေသည် ဆိုပါစို့၊ Bugfix ကိုသာ Commit လုပ်ပြီး Print စာကြောင်းများကို စွန့်ပစ်လိုပါမည်။

Git သည် "Staging area" ဟုခေါ်သော နည်းလမ်းမှတဆင့် မည်သည့် အပြောင်းအလဲများကို နောက် Snapshot တွင် ထည့်သွင်းမည်ဆိုသည်ကို သီးခြား သတ်မှတ်ခွင့် ပြုထားပါသည်။

# Git command-line interface

အချက်အလက်များ ထပ်မံ မဖြစ်စေရန်အတွက် အောက်ပါ Command များကို အသေးစိတ် ရှင်းပြမည် မဟုတ်ပါ။ အသေးစိတ်အတွက် အလွန် အကြံပြုထားသော [Pro Git](https://git-scm.com/book/en/v2) ကို ဖတ်ရှုပါ သို့မဟုတ် သင်ခန်းစာ ဗီဒီယိုကို ကြည့်ရှုပါ။

## Basics

{% comment %}

The `git init` command initializes a new Git repository, with repository
metadata being stored in the `.git` directory:

```console
$ mkdir myproject
$ cd myproject
$ git init
Initialized empty Git repository in /home/missing-semester/myproject/.git/
$ git status
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

How do we interpret this output? "No commits yet" basically means our version
history is empty. Let's fix that.

```console
$ echo "hello, git" > hello.txt
$ git add hello.txt
$ git status
On branch master
No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   hello.txt

$ git commit -m 'Initial commit'
[master (root-commit) 4515d17] Initial commit
 1 file changed, 1 insertion(+)
 create mode 100644 hello.txt
```

With this, we've `git add`ed a file to the staging area, and then `git
commit`ed that change, adding a simple commit message "Initial commit". If we
didn't specify a `-m` option, Git would open our text editor to allow us type a
commit message.

Now that we have a non-empty version history, we can visualize the history.
Visualizing the history as a DAG can be especially helpful in understanding the
current status of the repo and connecting it with your understanding of the Git
data model.

The `git log` command visualizes history. By default, it shows a flattened
version, which hides the graph structure. If you use a command like `git log
--all --graph --decorate`, it will show you the full version history of the
repository, visualized in graph form.

```console
$ git log --all --graph --decorate
* commit 4515d17a167bdef0a91ee7d50d75b12c9c2652aa (HEAD -> master)
  Author: Missing Semester <missing-semester@mit.edu>
  Date:   Tue Jan 21 22:18:36 2020 -0500

      Initial commit
```

This doesn't look all that graph-like, because it only contains a single node.
Let's make some more changes, author a new commit, and visualize the history
once more.

```console
$ echo "another line" >> hello.txt
$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   hello.txt

no changes added to commit (use "git add" and/or "git commit -a")
$ git add hello.txt
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   hello.txt

$ git commit -m 'Add a line'
[master 35f60a8] Add a line
 1 file changed, 1 insertion(+)
```

Now, if we visualize the history again, we'll see some of the graph structure:

```
* commit 35f60a825be0106036dd2fbc7657598eb7b04c67 (HEAD -> master)
| Author: Missing Semester <missing-semester@mit.edu>
| Date:   Tue Jan 21 22:26:20 2020 -0500
|
|     Add a line
|
* commit 4515d17a167bdef0a91ee7d50d75b12c9c2652aa
  Author: Anish Athalye <me@anishathalye.com>
  Date:   Tue Jan 21 22:18:36 2020 -0500

      Initial commit
```

Also, note that it shows the current HEAD, along with the current branch
(master).

We can look at old versions using the `git checkout` command.

```console
$ git checkout 4515d17  # previous commit hash; yours will be different
Note: checking out '4515d17'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 4515d17 Initial commit
$ cat hello.txt
hello, git
$ git checkout master
Previous HEAD position was 4515d17 Initial commit
Switched to branch 'master'
$ cat hello.txt
hello, git
another line
```

Git can show you how files have evolved (differences, or diffs) using the `git
diff` command:

```console
$ git diff 4515d17 hello.txt
diff --git c/hello.txt w/hello.txt
index 94bab17..f0013b2 100644
--- c/hello.txt
+++ w/hello.txt
@@ -1 +1,2 @@
 hello, git
 +another line
```

{% endcomment %}

- `git help <command>`: git command အတွက် အကူအညီ ရယူရန်
- `git init`: Git repo အသစ်တစ်ခု ဖန်တီးရန် (`.git` directory တွင် metadata များကို သိမ်းဆည်းသည်)
- `git status`: လက်ရှိ အခြေအနေများကို ကြည့်ရှုရန်
- `git add <filename>`: ဖိုင်များကို Staging area သို့ ထည့်သွင်းရန်
- `git commit`: Commit အသစ်တစ်ခု ဖန်တီးရန်
    - [ကောင်းမွန်သော commit message များ](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) ရေးသားပါ!
    - [ကောင်းမွန်သော commit message များ ရေးသားရခြင်း အကြောင်းအရင်းများ](https://chris.beams.io/posts/git-commit/)!
- `git log`: သမိုင်းကြောင်း မှတ်တမ်းများကို မျဉ်းဖြောင့် ပုံစံဖြင့် ပြသရန်
- `git log --all --graph --decorate`: သမိုင်းကြောင်းကို DAG Graph ပုံစံဖြင့် မြင်တွေ့ရရန်
- `git diff <filename>`: Staging area နှင့် ယှဉ်လျှင် ပြုလုပ်ထားသော အပြောင်းအလဲများကို ပြသရန်
- `git diff <revision> <filename>`: Snapshot များ ကြားရှိ ဖိုင်ပြောင်းလဲမှုများကို ပြသရန်
- `git checkout <revision>`: HEAD ကို အပ်ဒိတ်လုပ်ရန် (Branch ကို checkout လုပ်ပါက လက်ရှိ branch ကိုပါ ပြောင်းလဲပေးသည်)

## Branching and merging

{% comment %}

Branching allows you to "fork" version history. It can be helpful for working
on independent features or bug fixes in parallel. The `git branch` command can
be used to create new branches; `git checkout -b <branch name>` creates and
branch and checks it out.

Merging is the opposite of branching: it allows you to combine forked version
histories, e.g. merging a feature branch back into master. The `git merge`
command is used for merging.

{% endcomment %}

- `git branch`: Branch များကို ပြသရန်
- `git branch <name>`: Branch အသစ် ဖန်တီးရန်
- `git checkout -b <name>`: Branch အသစ် ဖန်တီးပြီး ထို branch သို့ ချက်ချင်း ပြောင်းလဲရန်
    - `git branch <name>; git checkout <name>` နှင့် တူညီသည်
- `git merge <revision>`: လက်ရှိ branch အတွင်းသို့ ပေါင်းစပ်ရန်
- `git mergetool`: Merge conflicts များကို ဖြေရှင်းရန် Tool ဖြင့် အကူအညီ ရယူရန်
- `git rebase`: Patches များကို Base အသစ်တစ်ခု ပေါ်သို့ Rebase ပြုလုပ်ရန်

## Remotes

- `git remote`: Remote စာရင်းများကို ပြရန်
- `git remote add <name> <url>`: Remote အသစ် ထည့်ရန်
- `git push <remote> <local branch>:<remote branch>`: Remote သို့ Objects များကို ပို့ပြီး Remote reference ကို အပ်ဒိတ်လုပ်ရန်
- `git branch --set-upstream-to=<remote>/<remote branch>`: Local နှင့် Remote branch ကြား ဆက်သွယ်မှု သတ်မှတ်ရန်
- `git fetch`: Remote မှ Objects/References များကို ယူဆောင်ရန်
- `git pull`: `git fetch; git merge` နှင့် တူညီသည်
- `git clone`: Remote မှ Repository ကို ဒေါင်းလုဒ် ရယူရန်

## Undo

- `git commit --amend`: Commit ၏ စာတို သို့မဟုတ် အကြောင်းအရာကို ပြင်ဆင်ရန်
- `git reset HEAD <file>`: Staging area မှ ဖိုင်ကို ပြန်ထုတ်ရန်
- `git checkout -- <file>`: ပြုလုပ်ထားသော အပြောင်းအလဲများကို စွန့်ပစ်ရန်

# Advanced Git

- `git config`: Git ကို [စိတ်ကြိုက် ပြင်ဆင်နိုင်စွမ်း မြင့်မားသည်](https://git-scm.com/docs/git-config)
- `git clone --depth=1`: သမိုင်းကြောင်း အပြည့်အစုံ မပါဘဲ အပေါ်ယံ Clone လုပ်ရန်
- `git add -p`: Interactive ပုံစံဖြင့် Staging ပြုလုပ်ရန်
- `git rebase -i`: Interactive ပုံစံဖြင့် Rebase ပြုလုပ်ရန်
- `git blame`: စာကြောင်း တစ်ကြောင်းစီကို မည်သူ နောက်ဆုံး ပြင်ဆင်ခဲ့သည်ကို ပြသရန်
- `git stash`: Working directory ရှိ ပြင်ဆင်ချက်များကို ခေတ္တ ဖယ်ရှားသိမ်းဆည်းထားရန်
- `git bisect`: သမိုင်းကြောင်းတွင် အမှားများကို Binary search ဖြင့် ရှာဖွေရန်
- `.gitignore`: ခြေရာမခံဘဲ ပစ်ပယ်ထားမည့် ဖိုင်များကို [သတ်မှတ်ရန်](https://git-scm.com/docs/gitignore)

# Miscellaneous

- **GUIs**: Git အတွက် [GUI clients](https://git-scm.com/downloads/guis) များစွာ ရှိပါသည်။ ကျွန်ုပ်တို့ ကိုယ်တိုင်မူ ယင်းတို့ကို မသုံးဘဲ Command-line interface ကိုသာ အသုံးပြုပါသည်။
- **Shell integration**: သင်၏ Shell prompt တွင် Git status ပါဝင်နေခြင်းသည် အလွန် အဆင်ပြေပါသည် ([zsh](https://github.com/olivierverdier/zsh-git-prompt), [bash](https://github.com/magicmonty/bash-git-prompt))။ [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) ကဲ့သို့သော Framework များတွင် မူလ ပါဝင်လေ့ရှိသည်။
- **Editor integration**: အထက်ပါအတိုင်း အသုံးဝင်သော အင်္ဂါရပ်များစွာဖြင့် ပေါင်းစပ်ထားနိုင်ပါသည်။ [fugitive.vim](https://github.com/tpope/vim-fugitive) သည် Vim အတွက် စံနှုန်း ဖြစ်ပါသည်။
- **Workflows**: ကျွန်ုပ်တို့သည် Data model နှင့် အခြေခံ Command များကို သင်ကြားပေးခဲ့ပြီး ဖြစ်သည်; ပရောဂျက် ကြီးများတွင် အလုပ်လုပ်ရာ၌ မည်သည့် နည်းလမ်းများကို လိုက်နာရမည် ဆိုသည်ကိုမူ မပြောပြရသေးပါ ([နည်းလမ်း ကွဲပြားမှုများစွာ](https://nvie.com/posts/a-successful-git-branching-model/) ရှိကြသည်)။
- **GitHub**: Git သည် GitHub မဟုတ်ပါ။ GitHub တွင် [pull requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) ဟုခေါ်သော အခြား ပရောဂျက်များသို့ Code ပံ့ပိုးပေးသည့် သီးခြား နည်းလမ်း ရှိပါသည်။
- **Other Git providers**: GitHub သည် သီးခြား အထူး မဟုတ်ပါ - [GitLab](https://about.gitlab.com/) နှင့် [BitBucket](https://bitbucket.org/) အပါအဝင် Git Repository Hosts များစွာ ရှိကြပါသည်။

# Resources

- [Pro Git](https://git-scm.com/book/en/v2) သည် **အလွန် ဖတ်ရှုသင့်သော စာအုပ်** ဖြစ်ပါသည်။ အခန်း ၁ မှ ၅ ထိ ဖတ်ရှုလိုက်ပါက Data model ကို နားလည်ထားပြီးဖြစ်၍ Git ကို ကျွမ်းကျင်စွာ အသုံးပြုနိုင်မည် ဖြစ်သည်။ နောက်ပိုင်း အခန်းများတွင် စိတ်ဝင်စားဖွယ် အဆင့်မြင့် အကြောင်းအရာများ ပါဝင်သည်။
- [Oh Shit, Git!?!](https://ohshitgit.com/) သည် အတွေ့ရများသော Git အမှားများမှ မည်သို့ ပြန်လည် ကုစားရမည်ကို ရေးသားထားသော လမ်းညွှန် အတို ဖြစ်သည်။
- [Git for Computer Scientists](https://eagain.net/articles/git-for-computer-scientists/) သည် Git ၏ Data model ကို Pseudocode နည်းပါးစွာဖြင့် ပုံကားချပ်များစွာ အသုံးပြု၍ ရှင်းလင်းထားသော စာတမ်း ဖြစ်သည်။
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/) သည် စိတ်ဝင်စားသူများအတွက် Data model ထက်ကျော်လွန်သော Git ၏ အသေးစိတ် အကောင်အထည်ဖော်မှုများကို ရှင်းလင်းထားခြင်း ဖြစ်သည်။
- [How to explain git in simple words](https://smusamashah.github.io/blog/2017/10/14/explain-git-in-simple-words)
- [Learn Git Branching](https://learngitbranching.js.org/) သည် Git သင်ကြားပေးသော Browser အခြေပြု ဂိမ်း ဖြစ်သည်။

# Exercises

1. Git နှင့် ပတ်သက်၍ အတွေ့အကြုံ မရှိသေးပါက [Pro Git](https://git-scm.com/book/en/v2) ၏ ပထမ အခန်းအနည်းငယ်ကို ဖတ်ပါ သို့မဟုတ် [Learn Git Branching](https://learngitbranching.js.org/) သင်ခန်းစာကို ပြုလုပ်ပါ။ ပြုလုပ်နေစဉ်အတွင်း Git command များကို Data model နှင့် ယှဉ်တွဲ စဉ်းစားပါ။
1. [ဤအတန်း၏ ဝဘ်ဆိုက် repository](https://github.com/missing-semester/missing-semester) ကို Clone လုပ်ပါ။
    1. သမိုင်းကြောင်းကို Graph အဖြစ် ကြည့်ရှု၍ လေ့လာပါ။
    1. `README.md` ကို နောက်ဆုံး ပြင်ဆင်ခဲ့သူမှာ မည်သူနည်း။ (အချက်အလက်- `git log` ကို argument ဖြင့် သုံးပါ)။
    1. `_config.yml` ၏ `collections:` စာကြောင်းကို နောက်ဆုံး ပြင်ဆင်ခဲ့သည့် commit ၏ message မှာ ဘာနည်း။ (အချက်အလက်- `git blame` နှင့် `git show` ကို သုံးပါ)။
1. Git လေ့လာရာတွင် အတွေ့ရများသော အမှားတစ်ခုမှာ Git ဖြင့် မစီမံသင့်သော ဖိုင်ကြီးများကို Commit လုပ်မိခြင်း သို့မဟုတ် အရေးကြီးသော အချက်အလက်များကို ထည့်သွင်းမိခြင်း ဖြစ်သည်။ Repository သို့ ဖိုင်တစ်ခု ထည့်ပါ၊ Commit လုပ်ပါ၊ ထို့နောက် သမိုင်းကြောင်းထဲမှ ထိုဖိုင်ကို ပယ်ဖျက်ပါ ([ဤနေရာတွင်](https://help.github.com/articles/removing-sensitive-data-from-a-repository/) ကြည့်ရှုနိုင်သည်)။
1. GitHub မှ Repository တစ်ခုကို Clone လုပ်ပါ၊ ရှိပြီးသား ဖိုင်တစ်ခုကို ပြင်ပါ။ `git stash` ရန်းလိုက်သည့်အခါ မည်သို့ ဖြစ်သွားသနည်း။ `git log --all --oneline` ရန်းသည့်အခါ မည်သည်ကို တွေ့ရသနည်း။ `git stash pop` ရန်း၍ ပြုလုပ်ခဲ့သည်ကို ပြန်ဖျက်ပါ။ မည်သည့် အခြေအနေတွင် ဤသည်မှာ အသုံးဝင်သနည်း။
1. Command line tool အများစုကဲ့သို့ပင် Git တွင် `~/.gitconfig` ဟုခေါ်သော Configuration file (dotfile) ပါရှိသည်။ `~/.gitconfig` တွင် Alias တစ်ခု ဖန်တီး၍ `git graph` ရန်းလိုက်ပါက `git log --all --graph --decorate --oneline` ၏ output ရရှိအောင် ပြုလုပ်ပါ။ `~/.gitconfig` ဖိုင်ကို [တိုက်ရိုက် ပြင်ဆင်ခြင်း](https://git-scm.com/docs/git-config#Documentation/git-config.txt-alias) ဖြင့်လည်းကောင်း၊ `git config` command ဖြင့်လည်းကောင်း ပြုလုပ်နိုင်ပါသည်။ Git alias အကြောင်းကို [ဒီမှာ](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases) ကြည့်နိုင်ပါသည်။
1. `git config --global core.excludesfile ~/.gitignore_global` ကို ရန်းပြီးနောက် `~/.gitignore_global` တွင် Global ignore pattern များကို သတ်မှတ်နိုင်ပါသည်။ ဤသည်မှာ Git အသုံးပြုမည့် Global ignore file နေရာကို သတ်မှတ်ပေးခြင်း ဖြစ်သော်လည်း ထိုလမ်းကြောင်းတွင် ဖိုင်ကို ကိုယ်တိုင် ဖန်တီးရန် လိုအပ်ဆဲ ဖြစ်သည်။ သင်၏ Global gitignore ဖိုင်တွင် OS သို့မဟုတ် Editor သီးသန့် ယာယီဖိုင်များ (ဥပမာ `.DS_Store`) ကို Ignore လုပ်ရန် သတ်မှတ်ပါ။
1. [ဤအတန်း၏ ဝဘ်ဆိုက် repository](https://github.com/missing-semester/missing-semester) ကို Fork လုပ်ပါ၊ စာလုံးပေါင်း မှားယွင်းမှု သို့မဟုတ် တိုးတက်ကောင်းမွန်အောင် ပြုလုပ်နိုင်မည့် အရာကို ရှာပြီး GitHub တွင် Pull Request တင်ပါ ([ဤနေရာတွင်](https://github.com/firstcontributions/first-contributions) ကြည့်နိုင်ပါသည်)။ အသုံးဝင်သော PR များကိုသာ တင်ပေးပါ (ကျေးဇူးပြု၍ Spam မလုပ်ပါနှင့်!)။ တိုးတက်အောင် ပြုလုပ်စရာ မတွေ့ပါက ဤလေ့ကျင့်ခန်းကို ကျော်နိုင်ပါသည်။
