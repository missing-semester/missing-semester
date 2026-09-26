---
layout: lecture
title: "OS Customization"
presenter: Anish
date: 2019-01-29
order: 3
video:
  aspect: 62.5
  id: epSRVqQzeDo
special: true
---

သင့် operating system ၏ settings မီနူးများတွင် ပါရှိသည်များအပြင် မိမိ၏ OS ကို ပိုမိုစိတ်ကြိုက်ပြင်ဆင်နိုင်သော အရာများစွာ ရှိပါသည်။

# ကီးဘုတ် ခလုတ်များ ပြန်လည်သတ်မှတ်ခြင်း (Keyboard remapping)

သင့်ကီးဘုတ်တွင် သင်အသုံးသိပ်မပြုသည့် ခလုတ်များ ရှိနေနိုင်ပါသည်။ ထိုသို့ အသုံးမဝင်သော ခလုတ်များ ရှိနေမည့်အစား ၎င်းတို့ကို အသုံးဝင်သော လုပ်ဆောင်ချက်များ ပြုလုပ်နိုင်ရန် ပြန်လည်သတ်မှတ်ပေးနိုင်ပါသည် (remap ပြုလုပ်နိုင်ပါသည်။)

## အခြားခလုတ်များဆီသို့ ပြန်လည်သတ်မှတ်ခြင်း (Remapping to other keys)

အရိုးရှင်းဆုံး အရာမှာ ခလုတ်တစ်ခုကို အခြားခလုတ်တစ်ခုအဖြစ် ပြန်လည်သတ်မှတ်ပေးခြင်း ဖြစ်ပါသည်။ ဥပမာအားဖြင့် သင်သည် Caps Lock ခလုတ်ကို သိပ်မသုံးလျှင် ၎င်းကို ပိုမိုအသုံးဝင်သော ခလုတ်တစ်ခုခုအဖြစ် ပြောင်းလဲသတ်မှတ်နိုင်ပါသည်။ ဥပမာ သင်သည် Vim အသုံးပြုသူတစ်ဦးဖြစ်ပါက Caps Lock ခလုတ်ကို Escape ခလုတ်အဖြစ် ပြန်လည်သတ်မှတ်လိုပေမည်။

macOS တွင် System Preferences ရှိ Keyboard settings ထဲမှတစ်ဆင့် ခလုတ်အချို့ကို ပြန်လည်သတ်မှတ်နိုင်ပြီး ပိုမိုရှုပ်ထွေးသော သတ်မှတ်မှုများအတွက် သီးသန့်ဆော့ဖ်ဝဲလ် လိုအပ်ပါသည်။

## စိတ်ကြိုက် command များဆီသို့ ပြန်လည်သတ်မှတ်ခြင်း (Remapping to arbitrary commands)

ခလုတ်တစ်ခုကို အခြားခလုတ်တစ်ခုအဖြစ်သာ မကဘဲ ခလုတ်များ (သို့မဟုတ် ခလုတ်တွဲများ) ကို မိမိစိတ်ကြိုက် command များနှင့် တွဲဖက်သတ်မှတ်ပေးနိုင်သော tool များလည်း ရှိပါသည်။ ဥပမာအားဖြင့် `command-shift-t` နှိပ်လိုက်ပါက terminal window အသစ်တစ်ခု ဖွင့်လှစ်ပေးနိုင်ရန် သတ်မှတ်နိုင်ပါသည်။

# ဝှက်ထားသော OS Settings များကို စိတ်ကြိုက်ပြင်ဆင်ခြင်း (Customizing hidden OS settings)

## macOS

macOS တွင် `defaults` command မှတစ်ဆင့် အသုံးဝင်သော setting အများအပြားကို ပြင်ဆင်နိုင်ရန် ပံ့ပိုးပေးထားပါသည်။ ဥပမာအားဖြင့် ဝှက်ထားသော application များ၏ Dock icon များကို အလင်းစိမ့်ဝင်မြင်နိုင်သော (translucent) ပုံစံ ဖြစ်စေရန် ပြုလုပ်နိုင်ပါသည်-

```shell
defaults write com.apple.dock showhidden -bool true
```

ဖြစ်နိုင်ခြေရှိသော setting များ အားလုံးပါဝင်သည့် စာရင်းတစ်ခုတည်း ရနိုင်မည်မဟုတ်သော်လည်း သီးခြားစိတ်ကြိုက် ပြင်ဆင်မှုများ၏ စာရင်းများကို အွန်လိုင်းတွင် ရှာဖွေနိုင်ပါသည်၊ ဥပမာအားဖြင့် Mathias Bynens ၏ [.macos](https://github.com/mathiasbynens/dotfiles/blob/master/.macos) ကဲ့သို့ ဖြစ်ပါသည်။

# Window စီမံခန့်ခွဲခြင်း (Window management)

## Tiling window management (ဝင်းဒိုးများကို မျက်နှာပြင်ပေါ်တွင် နေရာယူ စီစဉ်ခြင်း)

[Tiling window management](https://en.wikipedia.org/wiki/Tiling_window_manager) ဆိုသည်မှာ window များကို ထပ်မနေသော frame များအဖြစ် စီစဉ်ပေးသည့် window စီမံခန့်ခွဲမှု နည်းလမ်းတစ်ခု ဖြစ်ပါသည်။ သင်သည် Linux အခြေခံ operating system ကို အသုံးပြုနေပါက tiling window manager တစ်ခုကို ထည့်သွင်းအသုံးပြုနိုင်ပြီး Windows သို့မဟုတ် macOS ကဲ့သို့သော OS များကို အသုံးပြုနေပါက ထိုသို့ လုပ်ဆောင်ချက်မျိုး ရရှိစေမည့် application များကို ထည့်သွင်းနိုင်ပါသည်။

## Screen စီမံခန့်ခွဲခြင်း (Screen management)

မျက်နှာပြင်များအကြား window များကို ရွှေ့ပြောင်း ထိန်းချုပ်နိုင်ရန် ကီးဘုတ် shortcut များကို သတ်မှတ်ထားနိုင်ပါသည်။

## Layout များ (Layouts)

မျက်နှာပြင်တစ်ခုပေါ်တွင် window များကို သီးခြားနေရာချထားလေ့ရှိပါက ထို layout ကို ကိုယ်တိုင် ကိုယ်ကျ လိုက်လံနေရာချနေမည့်အစား script ရေးသားထားနိုင်ပြီး layout အသစ်တစ်ခု ဖန်တီးခြင်းကို လွယ်ကူလျင်မြန်စွာ ပြုလုပ်နိုင်မည် ဖြစ်ပါသည်။

# လေ့လာရန် သယံဇာတများနှင့် Tool များ (Resources)

- [Hammerspoon](https://www.hammerspoon.org/) - macOS desktop များကို အလိုအလျောက် လုပ်ဆောင်ပေးသည့် tool
- [Rectangle](https://rectangleapp.com/) - macOS window manager
- [Karabiner](https://karabiner-elements.pqrs.org/) - ဆန်းသစ်သော macOS keyboard remapping tool
- [r/unixporn](https://www.reddit.com/r/unixporn/) - လူအများ၏ ဆန်းသစ်လှပသော configuration များ၏ screenshot များနှင့် မှတ်တမ်းများ

# လေ့ကျင့်ခန်းများ (Exercises)

1. သင့် Caps Lock ခလုတ်ကို သင် ပိုမိုအသုံးပြုသည့် ခလုတ်တစ်ခုခုဆီသို့ (ဥပမာ Escape၊ Ctrl သို့မဟုတ် Backspace ကဲ့သို့သော) မည်သို့ ပြန်လည်သတ်မှတ်ရမည်ကို လေ့လာရှာဖွေပါ။

1. Terminal window အသစ် သို့မဟုတ် browser window အသစ် ဖွင့်လှစ်ရန် စိတ်ကြိုက် global keyboard shortcut တစ်ခု ပြုလုပ်ပါ။

{% comment %}

TODO

- Bitbar / Polybar
- Clipboard Manager (stack/searchable history)

{% endcomment %}
