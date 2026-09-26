---
layout: lecture
title: "Editors"
presenter: Anish
date: 2019-01-22
order: 1
video:
  aspect: 62.5
  id: 1vLcusYSrI4
---

# စာတည်းဆော့ဖ်ဝဲများ (Editors) ၏ အရေးပါမှု

Programmer များအနေဖြင့် ကျွန်ုပ်တို့သည် ကျွန်ုပ်တို့၏ အချိန်အများစုကို Plain-text ဖိုင်များကို ပြင်ဆင်ရေးသားခြင်း (editing) ဖြင့် ကုန်လွန်စေကြသည်။ မိမိ၏ လိုအပ်ချက်နှင့် ကိုက်ညီသော Editor တစ်ခုကို လေ့လာရန် အချိန်ပေး ရင်းနှီးမြှုပ်နှံရကျိုး နပ်ပါသည်။

Editor အသစ်တစ်ခုကို မည်သို့ လေ့လာမည်နည်း။ ထို Editor ကို ခဏတာ အသုံးပြုရန် မိမိကိုယ်ကို တိုက်တွန်းအားထုတ်ရမည်ဖြစ်ပြီး၊ ၎င်းသည် သင်၏ လုပ်ဆောင်နိုင်စွမ်း (productivity) ကို ခေတ္တခဏ နှောင့်နှေးစေလျှင်ပင် အသုံးပြုရမည်ဖြစ်သည်။ မကြာမီ အကျိုးကျေးဇူး ပြန်လည် ရရှိလာမည်ဖြစ်သည် (အခြေခံများကို လေ့လာရန် သီတင်းပတ်နှစ်ပတ်ခန့်မျှ ပေးပါက လုံလောက်ပါသည်)။

ကျွန်ုပ်တို့သည် သင်တို့အား Vim အကြောင်း သင်ကြားပေးမည်ဖြစ်သော်လည်း အခြားသော Editor များကိုလည်း စမ်းသပ်ကြည့်ရှုရန် တိုက်တွန်းပါသည်။ ၎င်းသည် တစ်ဦးချင်းစီ၏ ကြိုက်နှစ်သက်မှုအပေါ် များစွာ မူတည်ပြီး လူများသည် [သဘောထား ကွဲလွဲမှုများစွာ](https://en.wikipedia.org/wiki/Editor_war) ရှိကြသည်။

မိနစ် ၅၀ အတွင်း စွမ်းအားထက်မြက်သော Editor တစ်ခု အသုံးပြုနည်းကို သင်ကြားမပေးနိုင်သောကြောင့် ကျွန်ုပ်တို့သည် အခြေခံများကို သင်ကြားပေးခြင်း၊ ပိုမို အဆင့်မြင့်သော လုပ်ဆောင်ချက်အချို့ကို ပြသပေးခြင်းနှင့် ဤ tool ကို ကျွမ်းကျင်စွာ အသုံးပြုနိုင်ရန် အရင်းအမြစ်များ မျှဝေပေးခြင်းတို့အပေါ် အဓိကထားသွားမည်ဖြစ်သည်။ ကျွန်ုပ်တို့သည် Vim ကို နမူနာထား၍ သင်ခန်းစာများကို သင်ကြားပေးမည်ဖြစ်သော်လည်း အယူအဆ အများစုသည် သင်အသုံးပြုသည့် အခြားသော စွမ်းအားထက်မြက်သည့် Editor များသို့လည်း ပေါင်းစပ်အသုံးပြုနိုင်မည်ဖြစ်သည် (ထိုသို့ ပေါင်းစပ်အသုံးပြု၍ မရပါက ထို Editor ကို သင် အသုံးမပြုသင့်ပါ!)။

![Editor Learning Curves](/2019/files/editor-learning-curves.jpg)

<!-- source: https://blogs.msdn.microsoft.com/steverowe/2004/11/17/code-editor-learning-curves/ -->

Editor သင်ယူမှုဆိုင်ရာ ဂရပ် (learning curves graph) ဆိုသည်မှာ ဒဏ္ဍာရီ (myth) တစ်ခုသာ ဖြစ်သည်။ စွမ်းအားထက်မြက်သော Editor တစ်ခု၏ အခြေခံများကို လေ့လာခြင်းသည် အလွန်ပင် လွယ်ကူပါသည် (ကျွမ်းကျင်ပိုင်နိုင်ရန် နှစ်ပေါင်းများစွာ ကြာမြင့်နိုင်သော်လည်း)။

ယနေ့ခေတ်တွင် မည်သည့် Editor များ ရေပန်းစားသနည်း။ ဤ [Stack Overflow စမ်းသပ်စစ်တမ်း](https://insights.stackoverflow.com/survey/2018/#development-environments-and-tools) ကို ကြည့်ပါ (Stack Overflow အသုံးပြုသူများသည် Programmer အားလုံးကို ကိုယ်စားမပြုနိုင်သောကြောင့် အနည်းငယ် ဘက်လိုက်မှု ရှိနိုင်သည်)။

## Command-line Editors များ

နောက်ဆုံးတွင် GUI editor တစ်ခုကို အသုံးပြုရန် ဆုံးဖြတ်လိုက်လျှင်ပင် Remote machine များပေါ်ရှိ ဖိုင်များကို လွယ်ကူစွာ ပြင်ဆင်နိုင်ရန် Command-line editor တစ်ခုကို လေ့လာထားရကျိုး နပ်ပါသည်။

# Nano

Nano သည် ရိုးရှင်းသော Command-line editor တစ်ခု ဖြစ်သည်။

- Arrow key များဖြင့် ရွှေ့လျားနိုင်သည်
- အခြားသော Shortcut များ (save, exit) အားလုံးကို အောက်ခြေတွင် ပြသထားသည်

# Vim

Vi/Vim သည် စွမ်းအားထက်မြက်သော Text editor တစ်ခု ဖြစ်သည်။ ၎င်းသည် နေရာအများစုတွင် မူလအတိုင်း ထည့်သွင်းလေ့ရှိသည့် Command-line ပရိုဂရမ်တစ်ခု ဖြစ်သောကြောင့် Remote machine ပေါ်ရှိ ဖိုင်များကို ပြင်ဆင်ရန် အလွန် အဆင်ပြေစေသည်။

Vim တွင် GVim နှင့် [MacVim](https://macvim-dev.github.io/macvim/) ကဲ့သို့သော Graphical version များလည်း ရှိသည်။ ၎င်းတို့သည် 24-bit color၊ Menu များ၊ Popup များကဲ့သို့သော အပိုဆောင်း Feature များကို ထောက်ပံ့ပေးသည်။

## Vim ၏ သဘောတရား (Philosophy of Vim)

- ပရိုဂရမ်မင်း ရေးသားသည့်အခါ သင်၏ အချိန်အများစုကို စာရေးသားခြင်းထက် စာဖတ်ခြင်း/ပြင်ဆင်ခြင်း (reading/editing) ဖြင့် ကုန်လွန်စေသည်
    - Vim သည် **modal** editor တစ်ခု ဖြစ်သည်- စာသားများ ထည့်သွင်းခြင်း (inserting text) နှင့် စာသားများကို ပြုပြင်ခြင်း (manipulating text) တို့အတွက် သီးခြား Mode များ ရှိသည်
- Vim ကို ပရိုဂရမ် ရေးသား၍ စီမံနိုင်သည် (Vimscript အပြင် Python ကဲ့သို့သော အခြား Language များနှင့်လည်း ပြုလုပ်နိုင်သည်)
- Vim ၏ Interface ကိုယ်တိုင်က Programming language တစ်ခုကဲ့သို့ ဖြစ်သည်
    - Keystroke များ (မှတ်မိလွယ်သော Mnemonic အမည်များဖြင့်) သည် Command များ ဖြစ်ကြသည်
    - Command များကို ပေါင်းစပ်အသုံးပြုနိုင်သည် (composable)
- Mouse ကို မသုံးပါနှင့်- အလွန် နှေးကွေးသည်
- Editor သည် သင် စဉ်းစားသည့် အရှိန်အတိုင်း လုပ်ဆောင်နိုင်ရမည်

## Vim အခြေခံ မိတ်ဆက် (Introductory Vim)

### Mode များ

Vim သည် လက်ရှိ Mode ကို ဘယ်ဘက် အောက်ခြေတွင် ပြသပေးသည်။

- Normal mode- ဖိုင်အတွင်း ရွှေ့လျားရန်နှင့် ပြင်ဆင်မှုများ ပြုလုပ်ရန်
    - သင်၏ အချိန်အများစုကို ဤနေရာတွင် ကုန်လွန်မည် ဖြစ်သည်
- Insert mode- စာသားများ ထည့်သွင်းရန်
- Visual (visual, line, သို့မဟုတ် block) mode- စာသား Block များကို ရွေးချယ် (select) ရန်

မည်သည့် Mode မှမဆို Normal mode သို့ ပြန်လည် ပြောင်းလဲရန် `<ESC>` ကို နှိပ်၍ Mode ပြောင်းနိုင်သည်။ Normal mode မှ Insert mode သို့ `i` ဖြင့်လည်းကောင်း၊ Visual mode သို့ `v` ဖြင့်လည်းကောင်း၊ Visual line mode သို့ `V` ဖြင့်လည်းကောင်း၊ Visual block mode သို့ `<C-v>` ဖြင့်လည်းကောင်း ဝင်ရောက်နိုင်သည်။

Vim ကို အသုံးပြုသည့်အခါ `<ESC>` key ကို အများအပြား အသုံးပြုရသဖြင့် Caps Lock key ကို Escape သို့ Remap ပြုလုပ်ရန် စဉ်းစားပါ။

### အခြေခံများ

Vim ex command များကို Normal mode တွင် `:{command}` ဖြင့် ရိုက်နှိပ် ထုတ်ပြန်သည်။

- `:q` ထွက်မည် (Window ပိတ်မည်)
- `:w` သိမ်းဆည်းမည် (Save)
- `:wq` သိမ်းဆည်းပြီး ထွက်မည်
- `:e {name of file}` ပြင်ဆင်ရန် ဖိုင်ကို ဖွင့်မည်
- `:ls` ဖွင့်ထားသော Buffer များကို ပြသမည်
- `:help {topic}` အကူအညီ ဖွင့်မည်
    - `:help :w` သည် `:w` ex command အတွက် Help ကို ဖွင့်ပေးသည်
    - `:help w` သည် `w` ရွှေ့လျားမှု (movement) အတွက် Help ကို ဖွင့်ပေးသည်

### ရွှေ့လျားခြင်း (Movement)

Vim သည် ထိရောက်သော ရွှေ့လျားမှု (efficient movement) ဖြင့် အဓိက လည်ပတ်သည်။ Normal mode တွင် ဖိုင်အတွင်း လမ်းကြောင်းရှာ သွားလာပါ။

- အကျင့်ဆိုးများကို ရှောင်ရှားရန် Arrow key များကို ပိတ်ထားပါ
```vim
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
```
- အခြေခံ ရွှေ့လျားမှု- `hjkl` (ဘယ်၊ အောက်၊ အထက်၊ ညာ)
- စကားလုံးများ- `w` (နောက်စကားလုံး)၊ `b` (စကားလုံး၏ အစ)၊ `e` (စကားလုံး၏ အဆုံး)
- စာကြောင်းများ- `0` (စာကြောင်း၏ အစ)၊ `^` (ပထမဆုံး ကွက်လပ်မဟုတ်သော စာလုံး)၊ `$` (စာကြောင်း၏ အဆုံး)
- မျက်နှာပြင်- `H` (မျက်နှာပြင်၏ အထိပ်)၊ `M` (မျက်နှာပြင်၏ အလယ်)၊ `L` (မျက်နှာပြင်၏ အောက်ခြေ)
- ဖိုင်- `gg` (ဖိုင်၏ အစ)၊ `G` (ဖိုင်၏ အဆုံး)
- စာကြောင်း နံပါတ်များ- `:{number}<CR>` သို့မဟုတ် `{number}G` (စာကြောင်း နံပါတ် {number})
- အထွေထွေ- `%` (ကိုက်ညီသော အရာ/တွဲဖက် ကိုက်ညီမှု)
- ရှာဖွေမှု- `f{character}`, `t{character}`, `F{character}`, `T{character}`
    - လက်ရှိ စာကြောင်းပေါ်တွင် ရှေ့သို့/နောက်သို့ {character} ကို ရှာမည်/အရောက်သွားမည်
- N ကြိမ် ထပ်မံပြုလုပ်ခြင်း- `{number}{movement}`၊ ဥပမာ `10j` သည် အောက်သို့ စာကြောင်း ၁၀ ကြောင်း ရွှေ့သည်
- ရှာဖွေခြင်း- `/{regex}`, ကိုက်ညီမှုများကို ရွှေ့လျားကြည့်ရှုရန် `n` / `N`

### ရွေးချယ်ခြင်း (Selection)

Visual mode များ-

- Visual
- Visual Line
- Visual Block

ရွေးချယ်မှုပြုလုပ်ရန် ရွှေ့လျားမှု Key (Movement keys) များကို အသုံးပြုနိုင်သည်။

### စာသားများကို ပြုပြင်ခြင်း (Manipulating text)

ယခင်က Mouse ဖြင့် ပြုလုပ်ခဲ့သမျှ အရာအားလုံးကို ယခုအခါ Keyboard များ (နှင့် စွမ်းအားထက်မြက်သည့် ပေါင်းစပ်အသုံးပြုနိုင်သော Command များ) ဖြင့် ပြုလုပ်မည်ဖြစ်သည်။

- `i` Insert mode သို့ ဝင်မည်
    - သို့သော် စာသားများကို ပြုပြင်ရန်/ဖျက်ပစ်ရန်အတွက် Backspace ထက် ပိုမိုကောင်းမွန်သည့် အရာတစ်ခုခုကို အသုံးပြုရန် လိုအပ်သည်
- `o` / `O` အောက်ခြေ / အထက်တွင် စာကြောင်းအသစ် ထည့်မည်
- `d{motion}` {motion} အတိုင်း ဖျက်မည်
    - ဥပမာ `dw` သည် စကားလုံးကို ဖျက်မည်၊ `d$` သည် စာကြောင်းအဆုံးထိ ဖျက်မည်၊ `d0` သည် စာကြောင်းအစထိ ဖျက်မည်
- `c{motion}` {motion} အတိုင်း ပြောင်းလဲမည်
    - ဥပမာ `cw` သည် စကားလုံးကို ပြောင်းလဲမည်
    - `d{motion}` ၏ နောက်တွင် `i` ရိုက်နှိပ်လိုက်သကဲ့သို့ ဖြစ်သည်
- `x` စာလုံး (character) ကို ဖျက်မည် (`dl` နှင့် ညီမျှသည်)
- `s` စာလုံး (character) ကို အစားထိုးမည် (`xi` နှင့် ညီမျှသည်)
- Visual mode + ပြုပြင်ခြင်း
    - စာသားကို ရွေးချယ်ပြီး ဖျက်ရန် `d` သို့မဟုတ် ပြောင်းလဲရန် `c` ကို နှိပ်ပါ
- Undo ပြုလုပ်ရန် `u`၊ Redo ပြုလုပ်ရန် `<C-r>`
- လေ့လာရန် အခြားအရာများစွာ ရှိပါသေးသည်- ဥပမာ `~` သည် စာလုံး၏ Case (စာလုံးကြီး/စာလုံးသေး) ကို ပြောင်းလဲပေးသည်

### အရင်းအမြစ်များ (Resources)

- `vimtutor` Vim ကို သင်ကြားပေးသည့် Command-line ပရိုဂရမ်
- Vim ကို လေ့လာရန် [Vim Adventures](https://vim-adventures.com/) ဂိမ်း

## Vim ကို စိတ်ကြိုက် ပြင်ဆင်ခြင်း (Customizing Vim)

Vim ကို `~/.vimrc` ရှိ Plain-text Configuration ဖိုင် (Vimscript command များ ပါဝင်သည်) ဖြင့် စိတ်ကြိုက် ပြင်ဆင်နိုင်သည်။ သင် ဖွင့်ထားလိုသည့် အခြေခံ Setting အများအပြား ရှိနိုင်ပါသည်။

စိတ်ကူးစိတ်သန်းများ ရရှိရန် GitHub ရှိ အခြားသူများ၏ Dotfile များကို လေ့လာပါ၊ သို့သော် အခြားသူများ၏ Configuration တစ်ခုလုံးကို Copy-and-paste မလုပ်မိပါစေနှင့်။ ၎င်းကို ဖတ်ပါ၊ နားလည်အောင် လုပ်ပါ၊ ထို့နောက် သင် လိုအပ်သည်များကိုသာ ယူပါ။

စဉ်းစားသင့်သည့် စိတ်ကြိုက်ပြင်ဆင်မှု (Customization) အချို့-

- Syntax highlighting- `syntax on`
- Color scheme များ
- စာကြောင်း နံပါတ်များ- `set nu` / `set rnu`
- အရာအားလုံးကို Backspace ဖြင့် ဖျက်နိုင်ခြင်း- `set backspace=indent,eol,start`

## အဆင့်မြင့် Vim (Advanced Vim)

ဤနေရာတွင် Editor ၏ စွမ်းအားကို ပြသရန် နမူနာ အနည်းငယ် ဖော်ပြထားပါသည်။ ဤသို့သော အရာအားလုံးကို ကျွန်ုပ်တို့ သင်ကြားမပေးနိုင်သော်လည်း သင် အသုံးပြုရင်းဖြင့် သင်ယူသွားရမည် ဖြစ်သည်။ ကောင်းမွန်သော နည်းလမ်းတစ်ခုမှာ- သင်၏ Editor ကို အသုံးပြုနေစဉ် "ဤအရာကို ပြုလုပ်ရန် ပိုမိုကောင်းမွန်သည့် နည်းလမ်း ရှိရမည်" ဟု စဉ်းစားမိပါက အမှန်တကယ် ရှိနေတတ်ပါသည်- အွန်လိုင်းတွင် ရှာဖွေကြည့်ပါ။

### ရှာဖွေခြင်းနှင့် အစားထိုးခြင်း (Search and replace)

`:s` (substitute) command ([documentation](https://vim.fandom.com/wiki/Search_and_replace))။

- `%s/foo/bar/g`
    - ဖိုင်တစ်ပြင်လုံးတွင် foo ကို bar ဖြင့် အစားထိုးမည်
- `%s/\[.*\](\(.*\))/\1/g`
    - အမည်တပ်ထားသော Markdown link များကို ရိုးရိုး URL များဖြင့် အစားထိုးမည်

### Window အများအပြား အသုံးပြုခြင်း (Multiple windows)

- Window များကို ခွဲခြားရန် `sp` / `vsp`
- အတူတူပင်ဖြစ်သော Buffer ၏ View အများအပြားကို ကြည့်ရှုနိုင်သည်

### Mouse ထောက်ပံ့မှု (Mouse support)

- `set mouse+=a`
    - Click နှိပ်ခြင်း၊ Scroll လုပ်ခြင်း၊ ရွေးချယ်ခြင်းတို့ကို ပြုလုပ်နိုင်သည်

### Macro များ

- Register `{character}` တွင် Macro စတင် အသံသွင်းရန် (record) `q{character}`
- Record လုပ်ခြင်း ရပ်တန့်ရန် `q`
- `@{character}` သည် Macro ကို ပြန်လည် မောင်းနှင်ပေးသည်
- Error ဖြစ်ပေါ်ပါက Macro လုပ်ဆောင်မှု ရပ်တန့်သွားမည်
- `{number}@{character}` သည် Macro ကို {number} ကြိမ် မောင်းနှင်ပေးသည်
- Macro များသည် Recursive (မိမိကိုယ်ကို ပြန်လည် ခေါ်ယူခြင်း) ဖြစ်နိုင်သည်
    - ပထမဦးစွာ `q{character}q` ဖြင့် Macro ကို ရှင်းထုတ်ပါ
    - Record လုပ်ခြင်း ပြီးစီးသည်အထိ (no-op ဖြစ်နေမည်ဖြစ်ပြီး) Macro ကို မောင်းနှင်ရန် `@{character}` အသုံးပြု၍ အသံသွင်းပါ
- ဥပမာ- XML ကို JSON သို့ ပြောင်းလဲခြင်း ([ဖိုင်](/2019/files/example-data.xml))
    - Key "name" / "email" ပါရှိသော Array of objects
    - Python ပရိုဂရမ်တစ်ခု အသုံးပြုမလား။
    - sed / regexes အသုံးပြုမလား
        - `g/people/d`
        - `%s/<person>/{/g`
        - `%s/<name>\(.*\)<\/name>/"name": "\1",/g`
        - ...
    - Vim command များ / macro များ
        - ပထမဆုံးနှင့် နောက်ဆုံး စာကြောင်းများကို ဖျက်ရန် `Gdd`, `ggdd`
        - Element တစ်ခုတည်းကို Format ပြုလုပ်ရန် Macro (register `e`)
            - `<name>` ပါသော စာကြောင်းသို့ သွားပါ
            - `qe^r"f>s": "<ESC>f<C"<ESC>q`
        - Person တစ်ဦးကို Format ပြုလုပ်ရန် Macro
            - `<person>` ပါသော စာကြောင်းသို့ သွားပါ
            - `qpS{<ESC>j@eA,<ESC>j@ejS},<ESC>q`
        - Person တစ်ဦးကို Format ပြုလုပ်ပြီး နောက်တစ်ဦးထံ သွားရန် Macro
            - `<person>` ပါသော စာကြောင်းသို့ သွားပါ
            - `qq@pjq`
        - ဖိုင်အဆုံးထိ Macro ကို မောင်းနှင်ပါ
            - `999@q`
        - နောက်ဆုံး `,` ကို ကိုယ်တိုင် ဖျက်ထုတ်ပြီး `[` နှင့် `]` Delimiter များကို ထည့်သွင်းပါ

## Vim ကို ပိုမို တိုးချဲ့ အသုံးပြုခြင်း (Extending Vim)

Vim ကို တိုးချဲ့ အသုံးပြုရန် Plugin များစွာ ရှိပါသည်။

ပထမဦးစွာ [vim-plug](https://github.com/junegunn/vim-plug)၊ [Vundle](https://github.com/VundleVim/Vundle.vim)၊ သို့မဟုတ် [pathogen.vim](https://github.com/tpope/vim-pathogen) ကဲ့သို့သော Plugin manager တစ်ခုဖြင့် စတင် တပ်ဆင်ပါ။

စဉ်းစားသင့်သည့် Plugin အချို့-

- [ctrlp.vim](https://github.com/kien/ctrlp.vim): fuzzy file finder
- [vim-fugitive](https://github.com/tpope/vim-fugitive): git ပေါင်းစပ်အသုံးပြုခြင်း
- [vim-surround](https://github.com/tpope/vim-surround): "surroundings" များကို ပြုပြင်ခြင်း
- [gundo.vim](https://github.com/sjl/gundo.vim): undo tree တွင် လမ်းကြောင်းရှာခြင်း
- [nerdtree](https://github.com/scrooloose/nerdtree): file explorer
- [syntastic](https://github.com/vim-syntastic/syntastic): syntax စစ်ဆေးခြင်း
- [vim-easymotion](https://github.com/easymotion/vim-easymotion): magic motion များ
- [vim-over](https://github.com/osyo-manga/vim-over): substitute preview

Plugin စာရင်းများ-

- [Vim Awesome](https://vimawesome.com/)

## အခြားသော ပရိုဂရမ်များတွင် Vim-mode အသုံးပြုခြင်း

ရေပန်းစားသော Editor အများအပြားတွင် (ဥပမာ vim နှင့် emacs) အခြားသော Tool များစွာက Editor emulation ကို ထောက်ပံ့ပေးသည်။

- Shell
    - bash: `set -o vi`
    - zsh: `bindkey -v`
    - `export EDITOR=vim` (`git` ကဲ့သို့သော ပရိုဂရမ်များ အသုံးပြုသည့် Environment variable)
- `~/.inputrc`
    - `set editing-mode vi`

Web [browser များ](https://vim.fandom.com/wiki/Vim_key_bindings_for_web_browsers) အတွက် Vim keybinding extension များပင် ရှိပါသည်၊ ရေပန်းစားသော Extension အချို့မှာ Google Chrome အတွက် [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en) နှင့် Firefox အတွက် [Tridactyl](https://github.com/tridactyl/tridactyl) တို့ ဖြစ်ကြသည်။

## အရင်းအမြစ်များ (Resources)

- [Vim Tips Wiki](https://vim.fandom.com/wiki/Vim_Tips_Wiki)
- [Vim Advent Calendar](https://vimways.org/2018/): အမျိုးမျိုးသော Vim အကြံပြုချက်များ
- [Neovim](https://neovim.io/) သည် ပိုမို တက်ကြွစွာ တိုးတက်လျက်ရှိသော ခေတ်မီ Vim reimplementation ဖြစ်သည်။
- [Vim Golf](https://www.vimgolf.com/): အမျိုးမျိုးသော Vim စိန်ခေါ်မှုများ

{% comment %}
# Resources

TODO resources for other editors?
{% endcomment %}

# လေ့ကျင့်ခန်းများ

1. Editor အချို့ကို စမ်းသပ်ကြည့်ပါ။ အနည်းဆုံး Command-line editor တစ်ခု (ဥပမာ Vim) နှင့် အနည်းဆုံး GUI editor တစ်ခု (ဥပမာ Atom) ကို စမ်းသပ်ပါ။ `vimtutor` ကဲ့သို့သော သင်ခန်းစာများမှတစ်ဆင့် လေ့လာပါ (သို့မဟုတ် အခြား Editor များအတွက် သက်ဆိုင်ရာ သင်ခန်းစာများ)။ Editor အသစ်တစ်ခု၏ အမှန်တကယ် ခံစားချက်ကို ရရှိစေရန် သင်၏ အလုပ်များကို လုပ်ဆောင်နေစဉ် နှစ်ရက်ခန့် တောက်လျှောက် အသုံးပြုရန် သန္နိဋ္ဌာန်ချပါ။

1. သင်၏ Editor ကို စိတ်ကြိုက် ပြင်ဆင်ပါ။ အွန်လိုင်းရှိ အကြံပြုချက်များနှင့် နည်းလမ်းများကို ကြည့်ရှုပြီး အခြားသူများ၏ Configuration များကိုလည်း လေ့လာပါ (လေ့လာလွယ်အောင် ရေးသားထားလေ့ရှိသည်)။

1. သင်၏ Editor အတွက် Plugin များကို စမ်းသပ်ကြည့်ပါ။

1. အနည်းဆုံး သီတင်းပတ်အနည်းငယ်မျှ စွမ်းအားထက်မြက်သော Editor တစ်ခုကို သီးသန့် အသုံးပြုရန် သန္နိဋ္ဌာန်ချပါ- ထိုအချိန်တွင် အကျိုးကျေးဇူးများကို စတင် မြင်တွေ့ရမည်ဖြစ်သည်။ တစ်ချိန်ချိန်တွင် သင်၏ Editor သည် သင် စဉ်းစားသည့် အရှိန်အတိုင်း အလုပ်လုပ်နိုင်မည် ဖြစ်သည်။

1. Linter တစ်ခု (ဥပမာ python အတွက် pyflakes) ကို ထည့်သွင်းပါ၊ ၎င်းကို သင်၏ Editor နှင့် ချိတ်ဆက်ပြီး အလုပ်လုပ်ပုံကို စမ်းသပ်ပါ။
