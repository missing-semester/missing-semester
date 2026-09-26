---
layout: lecture
title: "Web နှင့် Web Browser များ"
presenter: Jose
date: 2019-01-31
order: 1
video:
  aspect: 62.5
  id: XpZO3S8odec
special: true
---

Terminal ပြီးရင် Web Browser ဟာ သင်အချိန်တော်တော်များများ အသုံးပြုရမယ့် Tool တစ်ခုဖြစ်ပါတယ်။ ဒါကြောင့်မို့လို့ သူ့ကို ထိရောက်ပြီး အကျိုးရှိရှိ ဘယ်လိုအသုံးပြုရမလဲဆိုတာ လေ့လာသင်ယူထားတာ ထိုက်တန်ပါတယ်။

## Shortcuts (ဖြတ်လမ်းနည်းများ)

မိမိရဲ့ Browser ထဲမှာ ကလစ်လိုက်နှိပ်နေခြင်းဟာ အမြဲတမ်း အမြန်ဆုံးနည်းလမ်း မဟုတ်ပါဘူး။ အသုံးများတဲ့ Shortcut တွေကို ယှဉ်တွဲသိရှိထားခြင်းဟာ ရေရှည်မှာ တကယ်ပဲ အကျိုးရှိစေမှာ ဖြစ်ပါတယ်။

- Link တစ်ခုပေါ်မှာ `Middle Button Click` (Mouse ဘီးနှိပ်ခြင်း) နှိပ်ပါက Tab အသစ်တစ်ခုမှာ ဖွင့်ပေးပါမည်။
- `Ctrl+T` - Tab အသစ်တစ်ခု ဖွင့်ရန်။
- `Ctrl+Shift+T` - မကြာသေးမီက ပိတ်လိုက်သော Tab ကို ပြန်ဖွင့်ရန်။
- `Ctrl+L` - Search bar ထဲမှ စာသားများကို ရွေးချယ်ရန်။
- `Ctrl+F` - Webpage အတွင်း ရှာဖွေရန်။ အကယ်၍ သင်သည် ဤသို့မကြာခဏ ရှာဖွေလေ့ရှိပါက Search များတွင် Regular Expression များကို ပံ့ပိုးပေးသည့် Extension တစ်ခုကို အသုံးပြုခြင်းဖြင့် အကျိုးရှိနိုင်ပါတယ်။


## Search operators (ရှာဖွေမှု သင်္ကေတများ)

Google သို့မဟုတ် DuckDuckGo ကဲ့သို့သော Web Search Engine များသည် ပိုမိုတိကျ အသေးစိတ်ကျသော ရှာဖွေမှုများ ပြုလုပ်နိုင်ရန် Search Operator များကို ပံ့ပိုးပေးထားပါတယ်-

- `"bar foo"` - bar foo ဟူသော စကားစု အတိအကျ ပါဝင်မှုကို သတ်မှတ်ရှာဖွေပေးသည်။
- `foo site:bar.com` - bar.com ဝက်ဘ်ဆိုက် အတွင်း၌သာ foo ကို ရှာဖွေပေးသည်။
- `foo -bar` - bar ဟူသော စကားလုံး ပါဝင်သည့် ရလဒ်များကို ရှာဖွေမှုမှ ဖယ်ထုတ်ပေးသည်။
- `foobar filetype:pdf` - ထို File Extension ရှိသည့် ဖိုင်များကို ရှာဖွေပေးသည်။
- `(foo|bar)` - foo သို့မဟုတ် bar ပါဝင်သည့် ကိုက်ညီမှုများကို ရှာဖွေပေးသည်။

[Google](https://ahrefs.com/blog/google-advanced-search-operators/) နှင့် [DuckDuckGo](https://duck.co/help/results/syntax) ကဲ့သို့သော လူကြိုက်များသည့် Engine များအတွက် ပိုမိုပြည့်စုံသည့် စာရင်းများကို သက်ဆိုင်ရာ Link များတွင် ဝင်ရောက်ကြည့်ရှုနိုင်ပါတယ်။


## Searchbar (ရှာဖွေမှုဘား)

Searchbar ဟာလည်း စွမ်းဆောင်ရည်ထက်မြက်တဲ့ Tool တစ်ခု ဖြစ်ပါတယ်။ Browser အများစုဟာ ဝက်ဘ်ဆိုက်များမှ Search Engine များကို အလိုအလျောက် ရယူမှတ်သားထားနိုင်ပါတယ်။ Keyword argument ကို ပြင်ဆင်ခြင်းဖြင့်-

- Google Chrome တွင် [chrome://settings/searchEngines](chrome://settings/searchEngines) ၌ ရှိသည်။
- Firefox တွင် [about:preferences#search](about:preferences#search) ၌ ရှိသည်။

ဥပမာအားဖြင့် `y SOME SEARCH TERMS` ဟု ရိုက်ထည့်ရုံဖြင့် YouTube ထဲတွင် တိုက်ရိုက် ရှာဖွေနိုင်အောင် ပြုလုပ်နိုင်ပါတယ်။

ထို့ပြင် သင့်ထံတွင် ကိုယ်ပိုင် Domain ရှိပါက Registrar မှတစ်ဆင့် Subdomain Forward ပြုလုပ်ထားနိုင်ပါတယ်။ ဥပမာအားဖြင့် ကျွန်တော်သည် `https://ht.josejg.com` ကို ဤသင်တန်း ဝက်ဘ်ဆိုက်သို့ ချိန်ညှိ (map) ထားပါတယ်။ ဤနည်းဖြင့် `ht.` ဟု ရိုက်ထည့်လိုက်သည်နှင့် Searchbar က အလိုအလျောက် ဖြည့်စွက် (autocomplete) ပေးသွားမှာ ဖြစ်ပါတယ်။ ဤစနစ်၏ အခြားကောင်းမွန်သည့် အချက်တစ်ခုမှာ Bookmark များနှင့် မတူဘဲ Browser တိုင်းတွင် အလုပ်လုပ်မည် ဖြစ်ခြင်းပင် ဖြစ်ပါတယ်။

## Privacy extensions (သီးသန့်လုံခြုံရေးဆိုင်ရာ Extension များ)

ယနေ့ခေတ်တွင် ကြော်ငြာများကြောင့် Web ကြည့်ရှုရသည်မှာ စိတ်ရှုပ်စရာ ကောင်းလာပြီး Tracker များကြောင့် ကိုယ်ရေးအချက်အလက် ကျူးလွန်ခံရမှုများ ရှိလာပါတယ်။ ထို့ပြင် ကောင်းမွန်သည့် Adblocker တစ်ခုသည် ကြော်ငြာအများစုကို ပိတ်ပင်ပေးရုံသာမက သံသယဖြစ်ဖွယ်နှင့် မကောင်းသော မဲလ်ဝဲ ဝက်ဘ်ဆိုက်များကိုလည်း အများသုံး Blacklist စာရင်းများတွင် ပါဝင်သောကြောင့် ပိတ်ပင်ပေးသွားမည် ဖြစ်ပါတယ်။ ၎င်းတို့သည် ပြုလုပ်ရသည့် Request အရေအတွက်ကို လျှော့ချပေးခြင်းဖြင့် ဝက်ဘ်ဆိုက် ပွင့်သည့်ကြာချိန် (page load time) ကိုလည်း အချို့နေရာများတွင် ပိုမိုမြန်ဆန်စေပါတယ်။ အကြံပြုလိုသည့် Extension အချို့မှာ-

- **uBlock origin** ([Chrome](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm), [Firefox](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)) - သတ်မှတ်ထားသော စည်းမျဉ်းများ (rules) ပေါ်မူတည်၍ ကြော်ငြာများနှင့် Tracker များကို ပိတ်ပင်ပေးသည်။ သင်၏ ဒေသ သို့မဟုတ် သုံးစွဲမှု အလေ့အထများပေါ် မူတည်၍ ထပ်မံဖွင့်လှစ်နိုင်သောကြောင့် Settings ထဲရှိ ဖွင့်ထားသော Blacklist စာရင်းများကို ကြည့်ရှုစစ်ဆေးသင့်ပါတယ်။ [အင်တာနက်ပေါ်ရှိ](https://github.com/gorhill/uBlock/wiki/Filter-lists-from-around-the-web) Filter စာရင်းများကိုလည်း ထည့်သွင်း အသုံးပြုနိုင်ပါတယ်။

- **[Privacy Badger](https://privacybadger.org/)** - Tracker များကို အလိုအလျောက် ထောက်လှမ်း၍ ပိတ်ပင်ပေးသည်။ ဥပမာ သင်သည် ဝက်ဘ်ဆိုက်တစ်ခုမှ တစ်ခုသို့ ကူးပြောင်း ကြည့်ရှုသည့်အခါ ကြော်ငြာကုမ္ပဏီများသည် သင်ဝင်ရောက်သည့် ဆိုက်များကို စောင့်ကြည့်မှတ်သားပြီး သင့်ဆိုင်ရာ Profile တစ်ခု တည်ဆောက်ကြသည်။

- **[HTTPS everywhere](https://www.eff.org/https-everywhere)** - ရရှိနိုင်ပါက ဝက်ဘ်ဆိုက်၏ HTTPS Version သို့ အလိုအလျောက် ပြန်လည်ညွှန်းပို့ (redirect) ပေးသည့် ကောင်းမွန်သော Extension တစ်ခု ဖြစ်သည်။

ဤကဲ့သို့သော Addon များအကြောင်း ပိုမို၍ [ဤနေရာတွင်](https://www.privacytools.io/privacy-browser-addons/) လေ့လာနိုင်ပါတယ်။

## Style customization (ဒီဇိုင်း ပုံစံ ပြင်ဆင်ခြင်း)

Web Browser များသည် သင်၏ _ကွန်ပျူတာစက်_ ပေါ်တွင် အလုပ်လုပ်နေသည့် အခြားသော Software တစ်ခု မျှသာ ဖြစ်သောကြောင့် ၎င်းတို့ ဘာပြသရမည်၊ ဘယ်လို ပြုမူဆောင်ရွက်ရမည် ဆိုသည်ကို နောက်ဆုံး ဆုံးဖြတ်ခွင့်မှာ သင့်တွင် ရှိပါတယ်။ ထိုသို့ ပြုလုပ်နိုင်သည့် ဥပမာတစ်ခုမှာ Custom Style များ ပြုလုပ်ခြင်း ဖြစ်ပါတယ်။ Browser များသည် Webpage တစ်ခု၏ ဒီဇိုင်းပုံစံကို ဖော်ပြရန် (render) Cascading Style Sheets (အတိုကောက် CSS) ကို အသုံးပြုကြပါတယ်။

ဝက်ဘ်ဆိုက်တစ်ခု၏ Source Code ကို Inspect ပြုလုပ်ခြင်းဖြင့် ၎င်း၏ အကြောင်းအရာများနှင့် ဒီဇိုင်းပုံစံများကို ယာယီ ပြောင်းလဲကြည့်ရှုနိုင်ပါတယ်။ (ဒါကြောင့်လည်း Webpage ၏ Screenshot များကို မည်သည့်အခါမျှ ရာနှုန်းပြည့် မယုံကြည်သင့်သည့် အကြောင်းရင်း ဖြစ်ပါတယ်)။

အကယ်၍ သင်သည် Webpage တစ်ခု၏ Style Settings များကို အမြဲတမ်း အစားထိုး (override) ပြုလုပ်ရန် သင်၏ Browser အား ခိုင်းစေလိုပါက Extension တစ်ခုကို အသုံးပြုရန် လိုအပ်မည် ဖြစ်သည်။ ကျွန်ုပ်တို့ အကြံပြုလိုသည်မှာ **[Stylus](https://github.com/openstyles/stylus)** ([Firefox](https://addons.mozilla.org/en-US/firefox/addon/styl-us/), [Chrome](https://chrome.google.com/webstore/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne?hl=en)) ဖြစ်ပါတယ်။


ဥပမာအားဖြင့် သင်တန်း ဝက်ဘ်ဆိုက်အတွက် အောက်ပါ Style ကို ရေးသားနိုင်ပါတယ်-


```css

body {
    background-color: #2d2d2d;
    color: #eee;
    font-family: Fira Code;
    font-size: 16pt;
}

a:link {
    text-decoration: none;
    color: #0a0;
}
```

ထို့ပြင် Stylus သည် အခြားသူများ ရေးသားထားပြီး [userstyles.org](https://userstyles.org/) တွင် တင်ထားသော Style များကိုလည်း ရှာဖွေပေးနိုင်ပါတယ်။ လူသိများသော ဝက်ဘ်ဆိုက် အများစုတွင် Dark Theme အပြင်အဆင် အနည်းဆုံး တစ်ခု သို့မဟုတ် တစ်ခုထက်မက ရှိတတ်ကြပါတယ်။ FYI အနေဖြင့် Stylish ကို အသုံးမပြုသင့်ပါ။ အဘယ်ကြောင့်ဆိုသော် အသုံးပြုသူ၏ ဒေတာများကို ပေါက်ကြားစေကြောင်း တွေ့ရှိထားရသောကြောင့် ဖြစ်ပြီး အသေးစိတ်ကို [ဤနေရာတွင်](https://arstechnica.com/information-technology/2018/07/stylish-extension-with-2m-downloads-banished-for-tracking-every-site-visit/) ဖတ်ရှုနိုင်ပါတယ်။


## Functionality Customization (လုပ်ဆောင်ချက်များ ပုံစံပြင်ဆင်ခြင်း)

ဒီဇိုင်းပုံစံကို ပြင်ဆင်နိုင်သကဲ့သို့ပင် ဝက်ဘ်ဆိုက်တစ်ခု၏ လုပ်ဆောင်ပုံ ပြုမူပုံကိုလည်း Custom JavaScript ရေးသားပြီး [Tampermonkey](https://tampermonkey.net/) ကဲ့သို့သော Browser Extension ဖြင့် ချိတ်ဆက်အသုံးပြုကာ ပြောင်းလဲနိုင်ပါတယ်။

ဥပမာ အောက်ပါ Script သည် J နှင့် K Key များကို အသုံးပြု၍ Vim ကဲ့သို့ သွားလာလှုပ်ရှားမှု (navigation) ပြုလုပ်နိုင်စေပါတယ်-

```js
// ==UserScript==
// @name         VIM HT
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Vim JK for our website
// @author       You
// @match        https://hacker-tools.github.io/*
// @grant        none
// ==UserScript==


(function() {
    'use strict';

    window.onkeyup = function(e) {
        var key = e.keyCode ? e.keyCode : e.which;

        if (key == 74) { // J is key 74
            window.scrollBy(0,500);;
        }else if (key == 75) { // K is key 75
            window.scrollBy(0,-500);;
        }
    }
})();
```

[OpenUserJS](https://openuserjs.org/) နှင့် [Greasy Fork](https://greasyfork.org/en) ကဲ့သို့သော Script Repository များလည်း ရှိကြပါတယ်။ သို့သော်လည်း သတိပြုရမည်မှာ အခြားသူများ၏ User Script များကို ထည့်သွင်းခြင်းသည် သင့်ခရက်ဒစ်ကတ် နံပါတ်များကို ခိုးယူခြင်းကဲ့သို့သော မည်သည့်အရာကိုမဆို ပြုလုပ်နိုင်သဖြင့် အလွန် အန္တရာယ်များနိုင်ပါတယ်။ သင့်ကိုယ်တိုင် စာကြောင်း တစ်ကြောင်းချင်းစီ ဖတ်ကြည့်ပြီး ၎င်းပြုလုပ်သည်များကို နားလည်ကာ သံသယဖြစ်ဖွယ် မရှိကြောင်း သေချာစွာ မသိမချင်း မည်သည့် Script ကိုမျှ မထည့်သွင်းပါနှင့်။ သင် မဖတ်နိုင်သော Minified သို့မဟုတ် Obfuscated (ထှာဆန်းအောင် ဖုံးကွယ်ထားသော) Code များ ပါဝင်သည့် Script ကို မည်သည့်အခါမျှ မထည့်သွင်းပါနှင့်။

## Web APIs

Web service များတွင် Web Request များ ပြုလုပ်ပြီး သက်ဆိုင်ရာ ဝန်ဆောင်မှုများနှင့် ချိတ်ဆက် လုပ်ဆောင်နိုင်ရန် Web API ဟုခေါ်သော Application Interface များကို ပံ့ပိုးပေးလာကြခြင်းမှာ ပိုမို ခေတ်စားလာခဲ့ပါတယ်။
ဤခေါင်းစဉ်နှင့် ပတ်သက်ပြီး ပိုမို အသေးစိတ်ကျသော မိတ်ဆက်ကို [ဤနေရာတွင်](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Client-side_web_APIs/Introduction) ဖတ်ရှုနိုင်ပါတယ်။ အများသုံးနိုင်သော [Public API အများအပြား](https://github.com/toddmotto/public-apis) ရှိကြပါတယ်။ Web API များသည် အကြောင်းရင်း အမြောက်အမြားအတွက် အသုံးဝင်လှပါတယ်-

- **Retrieval (အချက်အလက်ရယူခြင်း)** - Web API များသည် မြေပုံများ၊ မိုးလေဝသ အခြေအနေ သို့မဟုတ် သင့် Public IP Address ကဲ့သို့သော အချက်အလက်များကို အလွယ်တကူ ပံ့ပိုးပေးနိုင်ပါတယ်။ ဥပမာအားဖြင့် `curl ipinfo.io` သည် သင့် Public IP၊ တိုင်းဒေသကြီး၊ တည်နေရာ စသည်တို့နှင့် ပတ်သက်သည့် အသေးစိတ် အချက်အလက်အချို့ ပါဝင်သော JSON object တစ်ခုကို ပြန်ပေးမည် ဖြစ်သည်။ စနစ်တကျ Parse ပြုလုပ်ခြင်းဖြင့် ဤ Tool များကို Command Line Tool များနှင့်ပင် ချိတ်ဆက်နိုင်ပါတယ်။ အောက်ပါ Bash function သည် Google ၏ Autocompletion API နှင့် ချိတ်ဆက်ပြီး ပထမဆုံး ကိုက်ညီမှု ၁၀ ခုကို ပြန်လည် ထုတ်ပေးပါသည်။

```bash
function c() {
    url='https://www.google.com/complete/search?client=hp&hl=en&xhr=t'
    # NB: user-agent must be specified to get back UTF-8 data!
    curl -H 'user-agent: Mozilla/5.0' -sSG --data-urlencode "q=$*" "$url" |
        jq -r ".[1][][0]" |
        sed 's,</\?b>,,g'
}
```

- **Interaction (တုံ့ပြန်ဆောင်ရွက်ခြင်း)** - Web API endpoint များကို လုပ်ဆောင်ချက်များ စတင်ရန် (trigger action) လည်း အသုံးပြုနိုင်ပါတယ်။ ၎င်းတို့သည် သက်ဆိုင်ရာ ဝန်ဆောင်မှုမှတစ်ဆင့် ရယူနိုင်သော Authentication Token တစ်ခုခု လိုအပ်လေ့ရှိပါတယ်။ ဥပမာ အောက်ပါ command ကို သုံးစွဲခြင်းဖြင့်
`curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' "https://hooks.slack.com/services/$SLACK_TOKEN"` သည် Channel တစ်ခုအတွင်းသို့ `Hello, World!` ဟူသော မက်ဆေ့ဂျ်ကို ပေးပို့ပေးမည် ဖြစ်သည်။

- **Piping (ချိတ်ဆက် အလုပ်လုပ်စေခြင်း)** - Web API ရှိသည့် ဝန်ဆောင်မှု အချို့သည် အတော်ပင် လူကြိုက်များသောကြောင့် အများသုံး Web API များကို အချင်းချင်း ချိတ်ဆက်ပေးခြင်း (gluing) များကို Server တွင် တစ်ပါတည်း ထည့်သွင်း အကောင်အထည်ဖော် ပံ့ပိုးပေးထားပြီး ဖြစ်ပါတယ်။ [If This Then That](https://ifttt.com/) နှင့် [Zapier](https://zapier.com/) ကဲ့သို့သော ဝန်ဆောင်မှုများမှာ ထိုသို့ ပြုလုပ်ပေးထားခြင်း ဖြစ်ပါတယ်။


## Web Automation (ဝက်ဘ်ဆိုက် လုပ်ဆောင်ချက်များကို အလိုအလျောက် ခိုင်းစေခြင်း)

အချို့သော အခြေအနေများတွင် Web API များသည် မလုံလောက်ပါ။ အကယ်၍ ဖတ်ရှုရန်သာ လိုအပ်ပါက `pup` ကဲ့သို့သော HTML Parser သို့မဟုတ် Python ၏ BeautifulSoup ကဲ့သို့သော Library များကို အသုံးပြုနိုင်ပါတယ်။ သို့သော် တုံ့ပြန်ဆောင်ရွက်မှု သို့မဟုတ် JavaScript အကောင်အထည်ဖော်မှု လိုအပ်ပါက ထိုနည်းလမ်းများသည် လုံလောက်မှု မရှိတော့ပါ။

- **WebDriver** - ဥပမာ အောက်ပါ Script သည် ဝက်ဘ်ဆိုက် ရိုက်ထည့်သည့် အပြုအမူကို တုပ (simulate) ပြီး သတ်မှတ်ထားသော URL ကို Wayback Machine အသုံးပြု၍ သိမ်းဆည်းပေးမည် ဖြစ်သည်-

```python
from selenium.webdriver import Firefox
from selenium.webdriver.common.keys import Keys


def snapshot_wayback(driver, url):

    driver.get("https://web.archive.org/")
    elem = driver.find_element_by_class_name('web-save-url-input')
    elem.clear()
    elem.send_keys(url)
    elem.send_keys(Keys.RETURN)
    driver.close()


driver = Firefox()
url = 'https://hacker-tools.github.io'
snapshot_wayback(driver, url)
```


## Exercises (လေ့ကျင့်ခန်းများ)

1. သင်၏ Web Browser တွင် မကြာခဏ အသုံးပြုလေ့ရှိသော Keyword Search Engine တစ်ခုကို ပြင်ဆင်ကြည့်ပါ။
1. ဖော်ပြခဲ့သော Extension များကို ထည့်သွင်းပါ။ ဝက်ဘ်ဆိုက်တစ်ခုအတွက် uBlock Origin/Privacy Badger ကို မည်သို့ ပိတ်နိုင်မည်နည်းဆိုသည်ကို လေ့လာပါ။ မည်သည့် ကွာခြားချက်များကို မြင်တွေ့ရပါသနည်း။ YouTube ကဲ့သို့ ကြော်ငြာများပြားသည့် ဝက်ဘ်ဆိုက်တစ်ခုတွင် စမ်းသပ်ကြည့်ပါ။
1. Stylus ကို ထည့်သွင်းပြီး ပေးထားသော CSS ကို အသုံးပြု၍ သင်တန်း ဝက်ဘ်ဆိုက်အတွက် Custom Style တစ်ခု ရေးသားပါ။ အသုံးများသော ပရိုဂရမ်းမင်း သင်္ကေတများမှာ `=   ==   ===   >=   =>   ++   /=   ~=` ဖြစ်ကြသည်။ Font ကို Fira Code သို့ ပြောင်းလိုက်သည့်အခါ ၎င်းတို့တွင် မည်သို့ ပြောင်းလဲသွားသနည်း။ ပိုမိုသိရှိလိုပါက Programming Font Ligatures အကြောင်း ရှာဖွေကြည့်ပါ။
1. သင့်မြို့/ဒေသ၏ မိုးလေဝသ အခြေအနေကို ရယူနိုင်သည့် Web API တစ်ခုကို ရှာဖွေပါ။
1. သင်၏ Browser တွင် မကြာခဏ ပြုလုပ်ရသည့် ထပ်တလဲလဲ အလုပ်များကို အလိုအလျောက် ပြုလုပ်နိုင်ရန် [Selenium](https://www.selenium.dev/documentation/) ကဲ့သို့သော WebDriver Software တစ်ခုကို အသုံးပြုကြည့်ပါ။
