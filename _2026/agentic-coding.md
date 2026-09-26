---
layout: lecture
title: "Agentic Coding"
description: >
  ဆော့ဖ်ဝဲလ် ဖွံ့ဖြိုးတိုးတက်ရေး လုပ်ငန်းစဉ်များအတွက် AI coding agent များကို ထိရောက်စွာ အသုံးပြုနည်းကို လေ့လာပါ။
thumbnail: /static/assets/thumbnails/2026/lec7.png
date: 2026-01-21
ready: true
video:
  aspect: 56.25
  id: sTdz6PZoAnw
---

Coding agent များသည် ဖိုင်များ ဖတ်ခြင်း/ရေးခြင်း၊ ဝက်ဘ်ရှာဖွေခြင်းနှင့် shell command များကို စေခိုင်းခြင်း စသည့် tool များကို ရယူသုံးစွဲနိုင်သော စကားပြောဆိုနိုင်သည့် (conversational) AI model များ ဖြစ်ကြသည်။ ၎င်းတို့ကို IDE ထဲတွင်သော်လည်းကောင်း၊ သီးခြား command-line သို့မဟုတ် GUI tool များအဖြစ်သော်လည်းကောင်း အသုံးပြုနိုင်သည်။ Coding agent များသည် အလွန် ကိုယ်ပိုင်ဆုံးဖြတ်လုပ်ဆောင်နိုင်စွမ်း (autonomous) ရှိပြီး စွမ်းဆောင်ရည် ထက်မြက်သော tool များ ဖြစ်ကြသဖြင့် လုပ်ဆောင်ချက်မျိုးစုံတွင် အသုံးပြုနိုင်စေသည်။

ဤသင်ခန်းစာသည် [Development Environment and Tools](/2026/development-environment/) သင်ခန်းစာမှ AI ကိုအသုံးပြုသည့် ဖွံ့ဖြိုးတိုးတက်ရေးဆိုင်ရာ အကြောင်းအရာများပေါ်တွင် အခြေခံထားပါသည်။ အမြန် demo အနေဖြင့် [AI-powered development](/2026/development-environment/#ai-powered-development) အပိုင်းမှ ဥပမာကို ဆက်လက် လေ့လာကြည့်ကြပါစို့-

```python
from urllib.request import urlopen

def download_contents(url: str) -> str:
    with urlopen(url) as response:
        return response.read().decode('utf-8')

def extract(content: str) -> list[str]:
    import re
    pattern = r'\[.*?\]\((.*?)\)'
    return re.findall(pattern, content)

print(extract(download_contents("https://raw.githubusercontent.com/missing-semester/missing-semester/refs/heads/master/_2026/development-environment.md")))
```

ကျွန်ုပ်တို့သည် coding agent တစ်ခုအား အောက်ပါ task ကို prompt ပေး၍ စမ်းသပ်ကြည့်နိုင်သည်-

```
Turn this into a proper command-line program, with argparse for argument parsing. Add type annotations, and make sure the program passes type checking.
```

Agent သည် ဖိုင်ကို နားလည်အောင် ပထမဦးစွာ ဖတ်ရှုမည်ဖြစ်ပြီး၊ ထို့နောက် ပြင်ဆင်မှုများ ပြုလုပ်ကာ နောက်ဆုံးတွင် type annotation များ မှန်ကန်ကြောင်း သေချာစေရန် type checker ကို စေခိုင်း (invoke) မည်ဖြစ်သည်။ အကယ်၍ type checking ကျရှုံးသည်အထိ အမှားပြုလုပ်မိပါက ၎င်းသည် အကြိမ်ကြိမ် ပြန်လည်ပြင်ဆင် (iterate) ပါလိမ့်မည်။ သို့သော် ဤသည်မှာ ရိုးရှင်းသော task တစ်ခုဖြစ်သဖြင့် ထိုသို့ဖြစ်နိုင်ခြေ နည်းပါးသည်။ Coding agent များသည် အန္တရာယ်ရှိနိုင်သော tool များကို ရယူသုံးစွဲနိုင်သောကြောင့် မူလအစအတိုင်း (by default) agent harness များသည် tool ခေါ်ယူမှုများကို အတည်ပြုရန် အသုံးပြုသူထံ အကြောင်းကြားမေးမြန်းလေ့ရှိသည်။

> အကယ်၍ coding agent သည် အမှားပြုလုပ်မိပါက --- ဥပမာ သင့်ထံတွင် `mypy` binary ကို `$PATH` တွင် တိုက်ရိုက် ရရှိနိုင်သော်လည်း agent က `python -m mypy` ကို ခေါ်ယူရန် ကြိုးပမ်းနေပါက --- ၎င်းအား လမ်းကြောင်းမှန်သို့ ပြန်လည်ရောက်ရှိစေရန် စာသားဖြင့် feedback ပေးနိုင်သည်။

Coding agent များသည် multi-turn တုံ့ပြန်ဆက်ဆံမှုကို ထောက်ပံ့ပေးသဖြင့် agent နှင့် အပြန်အလှန် စကားပြောဆိုရင်း အလုပ်ကို ထပ်ခါတလဲလဲ ပြင်ဆင်သွားနိုင်သည်။ Agent သည် လမ်းကြောင်းမှားသို့ သွားနေပါက ကြားဖြတ်တားဆီး (interrupt) ပင် ပြုလုပ်နိုင်သည်။ သင့်တော်သော စဉ်းစားပုံစံ (mental model) တစ်ခုမှာ အလုပ်သင် (intern) တစ်ဦး၏ မန်နေဂျာကဲ့သို့ စဉ်းစားခြင်း ဖြစ်သည်- အလုပ်သင်သည် သေးငယ်စေ့စပ်သော အလုပ်များကို လုပ်ဆောင်ပေးမည်ဖြစ်သော်လည်း လမ်းညွှန်မှု လိုအပ်မည်ဖြစ်ပြီး၊ တစ်ခါတစ်ရံတွင် အမှားများ ပြုလုပ်မိသဖြင့် ပြင်ဆင်ပေးရန် လိုအပ်မည်ဖြစ်သည်။

> ပိုမို ရှင်းလင်းသော demo တစ်ခုအတွက်၊ ထွက်ပေါ်လာသည့် script ကို ရန်းကြည့်ရန် (run) agent ထံ ထပ်မံ မေးမြန်းကြည့်ပါ။ Output များကို လေ့လာပြီး ပြောင်းလဲမှုတစ်ခု ပြုလုပ်ပေးရန် တောင်းဆိုကြည့်ပါ (ဥပမာ absolute URL များကိုသာ ထည့်သွင်းပေးရန် တောင်းဆိုပါ)။

# AI model များနှင့် agent များ မည်သို့ အလုပ်လုပ်သနည်း

ခေတ်မီ [large language models (LLMs)](https://en.wikipedia.org/wiki/Large_language_model) များနှင့် agent harness များကဲ့သို့သော အခြေခံအဆောက်အအုံများ၏ အတွင်းပိုင်း အလုပ်လုပ်ပုံကို အသေးစိတ် ရှင်းလင်းပြသခြင်းသည် ဤသင်ခန်းစာ၏ နယ်ပယ်ထက် ကျော်လွန်နေပါသည်။ သို့သော်လည်း အဓိက အယူအဆအချို့ကို ခြုံငုံနားလည်ထားခြင်းသည် ဤရှေ့တန်းရောက် နည်းပညာ (bleeding edge technology) ကို ထိရောက်စွာ _အသုံးပြုရန်_ နှင့် ယင်း၏ ကန့်သတ်ချက်များကို နားလည်ရန်အတွက် အထောက်အကူဖြစ်စေသည်။

LLM များကို prompt စာသားများ (inputs) ပေးထားသည့်အခါ completion စာသားများ (outputs) ၏ ဖြစ်တန်းခြေ ဖြန့်ကျက်မှု (probability distribution) ကို ပုံဖော်ပေးခြင်းအဖြစ် ရှုမြင်နိုင်သည်။ LLM inference (ဥပမာ စကားပြောဆိုနိုင်သော chat app တစ်ခုသို့ မေးခွန်းတစ်ခု ပေးလိုက်သည့်အခါ ဖြစ်ပျက်လာသည့်အရာ) သည် ဤ probability distribution မှ _sample_ ရယူခြင်း ဖြစ်သည်။ LLM များတွင် သတ်မှတ်ထားသော _context window_ ရှိပြီး၊ ၎င်းသည် input နှင့် output စာသားများ၏ အများဆုံး အရှည်ပမာဏ ဖြစ်သည်။

{% comment %}
> In mathematical notation, the LLM models the probability distribution $\pi_\theta$ of completions $y$ conditioned on prompts $x$, and we sample from this distribution: $\hat{y} \sim \pi_\theta(\cdot \mid x)$.
{% endcomment %}

Conversational chat နှင့် coding agent များကဲ့သို့သော AI tool များကို ဤအခြေခံအယူအဆပေါ်တွင် တည်ဆောက်ထားခြင်းဖြစ်သည်။ Multi-turn တုံ့ပြန်ဆက်ဆံမှုများအတွက်၊ chat app များနှင့် agent များသည် turn marker များကို အသုံးပြုပြီး၊ အသုံးပြုသူထံမှ prompt အသစ်တစ်ခု ရရှိတိုင်း စကားပြောဆိုမှု သမိုင်းကြောင်း တစ်ခုလုံးကို prompt စာသားအဖြစ် ပေးပို့ကာ၊ အသုံးပြုသူ prompt တစ်ခုလျှင် LLM inference တစ်ကြိမ် စေခိုင်းသည်။ Tool-calling agent များအတွက်မူ harness သည် အချို့သော LLM output များကို tool တစ်ခုအား စေခိုင်းရန် တောင်းဆိုမှုအဖြစ် အဓိပ္ပာယ်ဖော်ယူပြီး၊ harness က tool ခေါ်ယူမှု၏ ရလဒ်များကို prompt စာသား၏ အစိတ်အပိုင်းအဖြစ် model ထံ ပြန်လည်ပေးပို့သည် (ထို့ကြောင့် tool call/response တစ်ခုစီအတွက် LLM inference ပြန်လည် ရန်းသည်)။ Tool-calling agent များ၏ အဓိက အယူအဆများကို [code စာကြောင်းရေ ၂၀၀ ဖြင့် ရေးသားအကောင်အထည်ဖော်နိုင်သည်](https://www.mihaileric.com/The-Emperor-Has-No-Clothes/)။

## သီးသန့်လုံခြုံမှု (Privacy)

AI coding tool အများစုသည် ၎င်းတို့၏ ပုံမှန် configuration တွင် သင့်ဒေတာ အများအပြားကို cloud ထံ ပေးပို့ကြသည်။ အချို့အခါများတွင် harness သည် လိုကယ်တွင် ရန်းပြီး LLM inference က cloud တွင် ရန်းသော်လည်း၊ အချို့အခါများတွင် ဆော့ဖ်ဝဲလ်၏ ပိုမိုများပြားသော အစိတ်အပိုင်းများက cloud တွင် ရန်းနေလေ့ရှိသည် (ဥပမာ ဝန်ဆောင်မှုပေးသူသည် သင့် repository တစ်ခုလုံး၏ မိတ္တူနှင့် AI tool နှင့် ပြုလုပ်ခဲ့သမျှ တုံ့ပြန်ဆောင်ရွက်မှု အားလုံးကို ရရှိသွားနိုင်ပါသည်)။

တော်တော်လေး ကောင်းမွန်သည့် open-source AI coding tool များနှင့် open-source LLM များ ရှိကြသော်လည်း (proprietary model များလောက်တော့ ကောင်းမွန်ခြင်း မရှိသေးပါ)၊ လက်ရှိအချိန်တွင် အသုံးပြုသူ အများစုအတွက် ရှေ့တန်းရောက် open LLM များကို လိုကယ်တွင် ရန်းရန်မှာ ဟာဒ်ဝဲလ် ကန့်သတ်ချက်များကြောင့် ဖြစ်နိုင်ခြေ မရှိသေးပါ။

# အသုံးပြုနိုင်သည့် အခြေအနေများ (Use cases)

Coding agent များကို လုပ်ဆောင်ချက် အမျိုးအစားများစွာအတွက် အသုံးဝင်စွာ အသုံးပြုနိုင်ပါသည်။ ဥပမာအချို့မှာ-

- **Feature အသစ်များကို အကောင်အထည်ဖော်ခြင်း။** အထက်ပါ ဥပမာအတိုင်း coding agent ထံ feature တစ်ခုကို အကောင်အထည်ဖော်ပေးရန် တောင်းဆိုနိုင်သည်။ ကောင်းမွန်သော specification ပေးပို့ခြင်းသည် နည်းပညာထက် ပန်းချီပညာကဲ့သို့ ပိုမိုဆန်းကြယ်သည်- သင့်ထံမှ agent သို့ ပေးသည့် input သည် သင်ဖြစ်စေချင်သည်များကို လုပ်ဆောင်နိုင်လောက်အောင် (အနည်းဆုံးတော့ သင် ထပ်မံပြင်ဆင်နိုင်ရန် လမ်းကြောင်းမှန်သို့ ဦးတည်စေရန်) ရှင်းလင်းပြည့်စုံရမည်ဖြစ်သော်လည်း၊ သင့်ကိုယ်တိုင် အလုပ်များလွန်းသွားသည်အထိ အသေးစိတ် လွန်းမနေသင့်ပေ။ Test-driven development သည် အထူး ထိရောက်နိုင်သည်- စမ်းသပ်ချက်များ (tests) ရေးသားပါ (သို့မဟုတ် စမ်းသပ်ချက်များ ရေးသားရာတွင် ကူညီရန် coding agent ကို အသုံးပြုပါ)၊ ၎င်းတို့သည် သင်လိုချင်သောအရာများကို မိမိရရ ပုံဖော်ပေးနိုင်ကြောင်း စစ်ဆေးပါ၊ ထို့နောက် ၎င်း feature ကို အကောင်အထည်ဖော်ပေးရန် coding agent ကို တောင်းဆိုပါ။ Model များသည် စဉ်ဆက်မပြတ် တိုးတက်လျက်ရှိရာ model များ မည်မျှ စွမ်းဆောင်နိုင်သည်ဆိုသည်ကို သင့်အနေဖြင့် အမြဲမပြတ် လေ့လာစမ်းသပ်နေရန် လိုအပ်မည်ဖြစ်သည်။
    > ကျွန်ုပ်တို့သည် ဤ Tufte-style sidenote များကို [အကောင်အထည်ဖော်ရန်](https://github.com/missing-semester/missing-semester/pull/345) Claude Code ကို အသုံးပြုခဲ့ပါသည်။
{%- comment %}
No need to demo this, since the intro of a lecture was a small demo of adding a new feature.
{% endcomment %}
- **အမှားများကို ပြင်ဆင်ခြင်း။** သင့်ထံတွင် compiler၊ linter၊ type checker သို့မဟုတ် test များမှ error များ ရှိနေပါက agent ထံ ၎င်းတို့ကို ပြင်ဆင်ပေးရန် တောင်းဆိုနိုင်သည်၊ ဥပမာ "fix the issues with mypy" ကဲ့သို့သော prompt မျိုး ပေးနိုင်သည်။ Coding model များကို feedback loop ထဲသို့ ရောက်ရှိစေနိုင်လျှင် အထူးပင် ထိရောက်မှုရှိရာ model အနေဖြင့် ကျရှုံးနေသော check ကို တိုက်ရိုက် ရန်းနိုင်အောင် ပြင်ဆင်ထားပါ၊ ထိုအခါ model သည် ကိုယ်တိုင် ပြန်လည်ပြင်ဆင်နိုင်မည်ဖြစ်သည်။ အကယ်၍ ဤသို့ ပြုလုပ်ရန် အဆင်မပြေပါက model သို့ feedback ကို ကိုယ်တိုင် ပေးပို့နိုင်သည်။
    > missing-semester repo ၏ commit [f552b55](https://github.com/missing-semester/missing-semester/commit/f552b5523462b22b8893a8404d2110c4e59613dd) တွင် ကျွန်ုပ်တို့သည် Claude Code အား "Review the agentic coding lecture for typos and grammatical issues" ဟု prompt ပေးခဲ့ပြီး၊ တွေ့ရှိရသော ပြဿနာများကို ပြင်ဆင်ရန် ထပ်မံ ခိုင်းစေခဲ့ရာ၊ ၎င်းတို့ကို commit [f1e1c41](https://github.com/missing-semester/missing-semester/commit/f1e1c417adba6b4149f7eef91ff5624de40dc637) တွင် commit ပြုလုပ်ခဲ့သည်။
{%- comment %}
Demo a coding agent fixing the bug in https://github.com/anishathalye/dotbot/commit/cef40c902ef0f52f484153413142b5154bbc5e99.

Write the failing tests to demo the bug, and then ask the agent to fix. Prepped in branch demo-bugfix.

Can run the failing test with:

    hatch test tests/test_cli.py::test_issue_357

Can prompt coding agent with:

    There is a bug I wrote a failing test for, you can repro it with `hatch test tests/test_cli.py::test_issue_357`. Fix the bug.

Get it to commit the changes.
{% endcomment %}
- **Refactoring ပြုလုပ်ခြင်း။** Coding agent များကို အသုံးပြု၍ ကုဒ်များကို နည်းလမ်းမျိုးစုံဖြင့် refactor ပြုလုပ်နိုင်သည်၊ ဥပမာ method တစ်ခု၏ အမည် ပြောင်းလဲခြင်းကဲ့သို့ ရိုးရှင်းသော task များမှသည် (ဤကဲ့သို့သော refactoring မျိုးကို [code intelligence](/2026/development-environment/#code-intelligence-and-language-servers) ကလည်း ထောက်ပံ့ပေးသည်) လုပ်ဆောင်ချက်တစ်ခုကို သီးခြား module တစ်ခုအဖြစ် ခွဲထုတ်ခြင်းကဲ့သို့ ရှုပ်ထွေးသော task များအထိ ပြုလုပ်နိုင်သည်။
    > ကျွန်ုပ်တို့သည် agentic coding ကို သီးခြား သင်ခန်းစာတစ်ခုအဖြစ် [ခွဲထုတ်ရန်](https://github.com/missing-semester/missing-semester/pull/344) Claude Code ကို အသုံးပြုခဲ့ပါသည်။
{%- comment %}
Show usage in Missing Semester, point out that the agent did make some mistakes.
{% endcomment %}
- **Code review ပြုလုပ်ခြင်း။** Coding agent များကို ကုဒ်များ စစ်ဆေးပေးရန် (review) တောင်းဆိုနိုင်သည်။ "review my latest changes that are not yet committed" ကဲ့သို့သော အခြေခံ လမ်းညွှန်ချက်များ ပေးနိုင်သည်။ အကယ်၍ သင်သည် pull request တစ်ခုကို review ပြုလုပ်လိုပြီး သင့် coding agent က web fetch ကို ထောက်ပံ့ပါက သို့မဟုတ် သင့်ထံတွင် [GitHub CLI](https://cli.github.com/) ကဲ့သို့သော command-line tool များ ထည့်သွင်းထားပါက coding agent ထံ "Review the pull request {link}" ဟုပင် တောင်းဆိုနိုင်ပြီး ၎င်းက ကျန်သည်များကို လုပ်ဆောင်ပေးသွားမည်ဖြစ်သည်။
{%- comment %}
In Porcupine repo, prompt agent with:

    Review this PR: https://github.com/anishathalye/porcupine/pull/39
{% endcomment %}
- **Codebase ကို နားလည်သဘောပေါက်ခြင်း။** Coding agent ထံ codebase နှင့် ပတ်သက်သည့် မေးခွန်းများ မေးမြန်းနိုင်ပြီး၊ ဤသည်မှာ အဖွဲ့သစ် သို့မဟုတ် project သစ်သို့ စတင်ဝင်ရောက်သူများ (onboarding) အတွက် အထူးပင် အသုံးဝင်ပါသည်။
{%- comment %}
Some prompts to try in the missing-semester repo:

    How do I run this site locally?

    How are the social preview cards implemented?
{% endcomment %}
- **Shell အဖြစ် အသုံးပြုခြင်း။** Coding agent အား task တစ်ခုကို ဖြေရှင်းရန် သီးခြား tool တစ်ခုကို အသုံးပြုခိုင်းနိုင်သည်၊ ထို့ကြောင့် "use the find command to find all files older than 30 days" သို့မဟုတ် "use mogrify to resize all the jpgs to 50% of their original size" ကဲ့သို့ လူစကား (natural language) အသုံးပြု၍ shell command တစ်ခုကို စေခိုင်းနိုင်သည်။
{%- comment %}
In Dotbot repo, prompt agent with:

    Use the ag command to find all Python renaming imports
{% endcomment %}
- **Vibe coding။** Agent များသည် သင့်ကိုယ်တိုင် code စာကြောင်းတစ်ကြောင်းမျှ ရေးသားရန် မလိုဘဲ အချို့သော application များကို အကောင်အထည်ဖော်နိုင်သည်အထိ စွမ်းဆောင်ရည် ထက်မြက်ကြသည်။
    > နည်းပြတစ်ဦးမှ vibe-code ပြုလုပ်ခဲ့သည့် လက်တွေ့ကမ္ဘာ project ၏ [ဥပမာတစ်ခုကို ဤနေရာတွင် ကြည့်နိုင်ပါသည်](https://github.com/cleanlab/office-presence-dashboard)။
{%- comment %}
In missing-semester repo, prompt agent with:

    Make this site look retro.
{% endcomment %}

# အဆင့်မြင့် Agent များ (Advanced agents)

ဤနေရာတွင် ကျွန်ုပ်တို့သည် coding agent များကို ပိုမို အဆင့်မြင့်စွာ အသုံးပြုသည့် ပုံစံများနှင့် စွမ်းဆောင်ရည်များကို အကျဉ်းချုပ် ဖော်ပြပေးသွားမည်ဖြစ်သည်။

- **ပြန်လည်အသုံးပြုနိုင်သော prompt များ။** ပြန်လည်အသုံးပြုနိုင်သော prompt သို့မဟုတ် template များကို ဖန်တီးပါ။ ဥပမာအားဖြင့် သီးခြားနည်းလမ်းဖြင့် code review ပြုလုပ်ရန် အသေးစိတ် prompt တစ်ခုကို ရေးသားပြီး ပြန်လည်အသုံးပြုနိုင်သော prompt အဖြစ် သိမ်းဆည်းထားနိုင်သည်။
    > Agent tool များသည် လျှင်မြန်စွာ တိုးတက်ပြောင်းလဲလျက်ရှိသည်။ အချို့သော tool များတွင် သီးခြား feature အဖြစ် Reusable prompt များကို မသုံးတော့ပါ (deprecated)။ ဥပမာ Codex နှင့် Claude Code တို့တွင် ၎င်းတို့ကို [skills](https://code.claude.com/docs/en/skills) များဖြင့် [အစားထိုးလိုက်ပါပြီ](https://developers.openai.com/codex/custom-prompts)။
- **ပြိုင်တူခိုင်းနိုင်သော agent များ (Parallel agents)။** Coding agent များသည် နှေးကွေးနိုင်ပါသည်- သင် prompt ပေးလိုက်ပါက ပြဿနာတစ်ခုအတွက် မိနစ်ပေါင်းများစွာ အလုပ်လုပ်နေနိုင်သည်။ သင်သည် agent မိတ္တူအများအပြားကို တစ်ပြိုင်နက်တည်း ရန်းထားနိုင်ပြီး၊ ၎င်းတို့အား အလုပ်တစ်ခုတည်းကို ခိုင်းစေခြင်း (LLM များသည် stochastic ဖြစ်သဖြင့် တစ်ခုတည်းသော အရာကို အကြိမ်ကြိမ် ရန်း၍ အကောင်းဆုံး အဖြေကို ရယူခြင်းက အသုံးဝင်နိုင်သည်) သို့မဟုတ် ကွဲပြားသော အလုပ်များကို ခိုင်းစေခြင်း (ဥပမာ တစ်ခုနှင့်တစ်ခု မထပ်သော feature နှစ်ခုကို တစ်ပြိုင်နက်တည်း အကောင်အထည်ဖော်ခြင်း) ပြုလုပ်နိုင်သည်။ ကွဲပြားသော agent ၏ ပြောင်းလဲမှုများ အချင်းချင်း နှောင့်ယှက်မှု မရှိစေရန် [version control](/2026/version-control/) သင်ခန်းစာတွင် ဆွေးနွေးခဲ့သည့် [git worktrees](https://git-scm.com/docs/git-worktree) များကို အသုံးပြုနိုင်သည်။
- **MCP များ။** _Model Context Protocol_ ကို ကိုယ်စားပြုသော MCP သည် သင့် coding agent များကို tool များနှင့် ချိတ်ဆက်ရန် အသုံးပြုနိုင်သည့် open protocol တစ်ခု ဖြစ်သည်။ ဥပမာ ဤ [Notion MCP server](https://github.com/makenotion/notion-mcp-server) သည် သင့် agent အား Notion document များကို ဖတ်/ရေး ပြုလုပ်စေနိုင်ပြီး၊ "{Notion doc} တွင် ချိတ်ဆက်ထားသော spec ကို ဖတ်ပါ၊ အကောင်အထည်ဖော်မှု အစီအစဉ်ကို Notion စာမျက်နှာသစ်အဖြစ် မူကြမ်းရေးပါ၊ ထို့နောက် စာမူကြမ်း (prototype) ကို အကောင်အထည်ဖော်ပါ" ကဲ့သို့သော အခြေအနေများတွင် အသုံးပြုနိုင်စေသည်။ MCP များကို ရှာဖွေရန် [Pulse](https://www.pulsemcp.com/servers) နှင့် [Glama](https://glama.ai/mcp/servers) ကဲ့သို့သော directory များကို အသုံးပြုနိုင်သည်။
- **Context စီမံခန့်ခွဲမှု။** ကျွန်ုပ်တို့ [အထက်တွင်](#how-ai-models-and-agents-work) ဖော်ပြခဲ့သည့်အတိုင်း coding agent များကို အခြေခံထားသော LLM များတွင် ကန့်သတ်ထားသော _context window_ ရှိသည်။ Coding agent များကို ထိရောက်စွာ အသုံးပြုနိုင်ရန် context ကို အကျိုးရှိစွာ အသုံးပြုဖို့ လိုအပ်သည်။ Agent ၌ လိုအပ်သော အချက်အလက်များ ရရှိနိုင်စေရေး သေချာအောင် ပြုလုပ်ရန် လိုအပ်သော်လည်း context window ပြည့်လျှံသွားခြင်း သို့မဟုတ် model ၏ စွမ်းဆောင်ရည် ကျဆင်းသွားခြင်းမှ ရှောင်ရှားရန် မလိုအပ်သော context များကို ရှောင်ကြဉ်ရမည် (context အရွယ်အစား ကြီးထွားလာသည်နှင့်အမျှ context window မပြည့်လျှံသေးသည့်တိုင် စွမ်းဆောင်ရည် ကျဆင်းသွားတတ်သည်)။ Agent harness များသည် context ကို အလိုအလျောက် ပံ့ပိုးပေးပြီး အတိုင်းအတာတစ်ခုအထိ စီမံခန့်ခွဲပေးသော်လည်း ထိန်းချုပ်မှု အများအပြားကိုမူ အသုံးပြုသူထံ ချန်ထားခဲ့သည်။
    - **Context window ကို ရှင်းလင်းခြင်း။** အခြေခံအကျဆုံး ထိန်းချုပ်မှုအဖြစ် coding agent များသည် context window ကို ရှင်းလင်းခြင်း (စကားပြောဆိုမှု အသစ်တစ်ခု စတင်ခြင်း) ကို ထောက်ပံ့ပေးပြီး၊ မသက်ဆိုင်သော မေးခွန်းများအတွက် ဤသို့ ပြုလုပ်သင့်သည်။
    - **စကားပြောဆိုမှုကို နောက်ပြန်ဆုတ်ခြင်း (Rewinding)။** အချို့သော coding agent များသည် စကားပြောဆိုမှု သမိုင်းကြောင်းရှိ အဆင့်များကို ပြန်ဖျက်ခြင်း (undoing) ကို ထောက်ပံ့ပေးသည်။ Agent အား အခြားလမ်းကြောင်းသို့ ဦးတည်စေမည့် ထပ်မံဖြည့်စွက် အကြောင်းကြားစာ ပေးပို့ခြင်းထက် "undo" ပြုလုပ်ခြင်းက ပိုမိုသင့်တော်သည့် အခြေအနေများတွင် ဤသို့ပြုလုပ်ခြင်းက context ကို ပိုမို ထိရောက်စွာ စီမံခန့်ခွဲနိုင်သည်။
{%- comment %}
Make up a quick demo.
{% endcomment %}
    - **Compaction ပြုလုပ်ခြင်း။** အကန့်အသတ်မရှိသော အရှည်ရှိ စကားပြောဆိုမှုများကို ဖြစ်နိုင်စေရန် coding agent များသည် context _compaction_ ကို ထောက်ပံ့ပေးသည်- အကယ်၍ စကားပြောဆိုမှု သမိုင်းကြောင်းသည် လွန်စွာ ရှည်လျားလာပါက၊ စကားပြောဆိုမှု၏ ရှေ့ပိုင်းကို အကျဉ်းချုပ်ရန် LLM ကို အလိုအလျောက် ခေါ်ယူမည်ဖြစ်ပြီး၊ စကားပြောဆိုမှု သမိုင်းကြောင်းကို ထိုအကျဉ်းချုပ်ဖြင့် အစားထိုးမည်ဖြစ်သည်။ အချို့သော agent များသည် လိုအပ်သည့်အခါ compaction စေခိုင်းနိုင်ရန် အသုံးပြုသူထံ ထိန်းချုပ်ခွင့် ပေးထားသည်။
{%- comment %}
Show `/compact` in Claude Code, show full summary.
{% endcomment %}
    - **llms.txt။** `/llms.txt` ဖိုင်သည် inference ပြုလုပ်ချိန်တွင် LLM များ အသုံးပြုရန် ရည်ရွယ်သည့် document တစ်ခုအတွက် အဆိုပြုထားသော [standard](https://llmstxt.org/) တည်နေရာ ဖြစ်သည်။ ထုတ်ကုန်များ (ဥပမာ [cursor.com/llms.txt](https://cursor.com/llms.txt))၊ ဆော့ဖ်ဝဲလ် library များ (ဥပမာ [ai.pydantic.dev/llms.txt](https://ai.pydantic.dev/llms.txt))၊ နှင့် API များ (ဥပမာ [apify.com/llms.txt](https://apify.com/llms.txt)) တို့တွင် ဖွံ့ဖြိုးတိုးတက်ရေး လုပ်ငန်းများအတွက် အဆင်ပြေစေမည့် `llms.txt` ဖိုင်များ ရှိနိုင်သည်။ ထိုကဲ့သို့သော document များသည် token တစ်ခုစီအလိုက် သတင်းအချက်အလက် ပိုမို သိပ်သည်းသဖြင့် သင့် coding agent ထံ HTML စာမျက်နှာကို ရယူဖတ်ရှုခိုင်းခြင်းထက် context အသုံးပြုမှု ပိုမို ထိရောက်သည်။ သင် အသုံးပြုရန် ကြိုးပမ်းနေသည့် dependency တစ်ခုနှင့် ပတ်သက်၍ coding agent တွင် တည်ဆောက်ပြီးသား ဗဟုသုတ မရှိသည့်အခါ (ဥပမာ LLM ၏ knowledge cutoff ပြီးမှ ထွက်ရှိလာခဲ့ခြင်း ကြောင့်) ပြင်ပ documentation များသည် အသုံးဝင်ပါသည်။
{%- comment %}
Side-by-side comparison in an empty repo (on Desktop or some other self-contained place, with `git init` run in it):

    Write a single-file Python program example in demo.py using semlib to sort "Ilya Sutskever", "Soumith Chintala", and "Donald Knuth" in terms of their fame as AI researchers.

    Write a single-file Python program example in demo.py using semlib to sort "Ilya Sutskever", "Soumith Chintala", and "Donald Knuth" in terms of their fame as AI researchers. See https://semlib.anish.io/llms.txt. Follow links to Markdown versions of any pages linked in llms.txt files.

Not sure why the agent doesn't do this by default. You'd probably put that last sentence in a CLAUDE.md file.
{% endcomment %}
    - **AGENTS.md။** Coding agent အများစုသည် coding agent များအတွက် README အဖြစ် [AGENTS.md](https://agents.md/) သို့မဟုတ် ဆင်တူရာ ဖိုင်များကို ထောက်ပံ့ပေးကြသည် (ဥပမာ Claude Code သည် `CLAUDE.md` ကို ရှာဖွေသည်)။ Agent စတင်သည့်အခါ ၎င်းသည် `AGENTS.md` ၏ ပါဝင်သည့် အချက်အလက် တစ်ခုလုံးဖြင့် context ကို ကြိုတင် ဖြည့်သွင်းပေးသည်။ Session များအားလုံးအတွက် အသုံးဝင်သည့် အကြံပြုချက်များကို agent သို့ ပေးအပ်ရန် ဤဖိုင်ကို အသုံးပြုနိုင်သည် (ဥပမာ code ပြောင်းလဲမှုများ ပြုလုပ်ပြီးနောက် type-checker ကို အမြဲ ရန်းရန် ညွှန်ကြားခြင်း၊ unit test များ မည်သို့ ရန်းရမည်ကို ရှင်းပြခြင်း သို့မဟုတ် agent ဝင်ရောက်ဖတ်ရှုနိုင်သည့် ပြင်ပ documentation လင့်ခ်များ ပံ့ပိုးပေးခြင်း)။ အချို့သော coding agent များသည် ဤဖိုင်ကို အလိုအလျောက် ထုတ်လုပ်ပေးနိုင်သည် (ဥပမာ Claude Code မှ `/init` command)။ `AGENTS.md` ၏ လက်တွေ့ကမ္ဘာ ဥပမာတစ်ခုကို [ဤနေရာတွင်](https://github.com/pydantic/pydantic-ai/blob/main/CLAUDE.md) ကြည့်နိုင်ပါသည်။
{%- comment %}
Dotbot example, CLAUDE.md that includes @DEVELOPMENT.md and says to always run the type checker and code formatter after making any changes to Python code.

Example prompt, off of master:

    Remove the "--version" command-line flag.

This is something that'll be fast, for demonstration purposes.
{% endcomment %}
    - **Skills များ။** `AGENTS.md` ထဲမှ အချက်အလက်များသည် agent ၏ context window ထဲသို့ အပြည့်အဝ အမြဲတမ်း load လုပ်ခံရသည်။ _Skills_ များသည် context ပမာဏ မလိုအပ်ဘဲ ကြီးထွားလာခြင်း (context bloat) ကို ရှောင်ရှားရန် ကြားခံ အဆင့်တစ်ခုကို ပေါင်းစပ်ပေးသည်- သင်သည် agent အား skill များ၏ စာရင်းနှင့် ယင်းတို့၏ ဖော်ပြချက်များကို ပံ့ပိုးပေးနိုင်ပြီး၊ agent က လိုအပ်သည့်အခါမှသာ ထို skill ကို "ဖွင့်" နိုင်သည် (ယင်း၏ context window ထဲသို့ load လုပ်နိုင်သည်)။
    - **Subagents များ။** အချို့သော coding agent များသည် သီးခြား task အလိုက် workflow များအတွက် agent များဖြစ်သည့် subagent များကို သတ်မှတ်ခွင့် ပြုထားသည်။ Top-level coding agent သည် သီးခြား task တစ်ခုကို ပြီးမြောက်စေရန် sub-agent တစ်ခုအား စေခိုင်းနိုင်ပြီး၊ ဤသည်မှာ top-level agent နှင့် subagent နှစ်ခုလုံးအတွက် context ကို ပိုမို ထိရောက်စွာ စီမံခန့်ခွဲနိုင်စေသည်။ Top-level agent ၏ context သည် subagent မြင်တွေ့သမျှ အရာအားလုံးဖြင့် ရှုပ်ထွေးမနေတော့ဘဲ၊ subagent သည်လည်း ယင်း၏ task အတွက် လိုအပ်သော context ကိုသာ ရရှိမည်ဖြစ်သည်။ ဥပမာတစ်ခုအနေဖြင့် အချို့သော coding agent များသည် web research ကို subagent အဖြစ် အကောင်အထည်ဖော်ကြသည်- top-level agent သည် subagent ထံ မေးခွန်းတစ်ခု မေးမည်ဖြစ်ပြီး၊ subagent က web ရှာဖွေခြင်းများ ပြုလုပ်၍ ဝက်ဘ်စာမျက်နှာတစ်ခုစီကို ရယူဖတ်ရှု သုံးသပ်ကာ မေးခွန်း၏ အဖြေကို top-level agent ထံ ပံ့ပိုးပေးမည်ဖြစ်သည်။ ဤနည်းဖြင့် top-level agent ၏ context တွင် ရယူထားသော ဝက်ဘ်စာမျက်နှာများ၏ အချက်အလက် အပြည့်အစုံကြောင့် ရှုပ်ထွေးမနေသလို၊ subagent ၏ context တွင်လည်း top-level agent ၏ ကျန်ရှိသော စကားပြောဆိုမှု သမိုင်းကြောင်းများ ပါဝင်မနေတော့ပါ။

Prompt များကို ရေးသားရန် လိုအပ်သည့် အဆင့်မြင့် feature အများအပြားအတွက် (ဥပမာ skills သို့မဟုတ် subagents)၊ စတင်နိုင်ရန် LLM များကို အသုံးပြုနိုင်သည်။ အချို့သော coding agent များတွင် ဤသို့ ပြုလုပ်နိုင်သည့် တည်ဆောက်ပြီးသား support ပင် ပါဝင်သည်။ ဥပမာ Claude Code သည် တိုတောင်းသော prompt တစ်ခုမှ subagent တစ်ခုကို ထုတ်လုပ်ပေးနိုင်သည် (`/agents` ကို ခေါ်ယူပြီး agent အသစ်တစ်ခု ဖန်တီးပါ)။ အောက်ပါ prompt ဖြင့် subagent တစ်ခု ဖန်တီးကြည့်ပါ-

```
A Python code checking agent that uses `mypy` and `ruff` to type-check, lint, and format *check* any files that have been modified from the last git commit.
```

ထို့နောက် သင်သည် top-level agent အား "use the code checker subagent" ကဲ့သို့သော စာသားဖြင့် subagent အား တိုက်ရိုက် စေခိုင်းရန် အသုံးပြုနိုင်သည်။ သို့မဟုတ် သင့်တော်သည့်အခါတွင် top-level agent ကို subagent ထံ အလိုအလျောက် စေခိုင်းစေနိုင်သည်၊ ဥပမာ Python ဖိုင်များကို ပြင်ဆင်ပြီးနောက် မျိုး ဖြစ်သည်။

# သတိပြုရမည့် အချက်များ (What to watch out for)

AI tool များသည် အမှားများ ပြုလုပ်နိုင်သည်။ ၎င်းတို့သည် နောက်လာမည့် token ကို ဖြစ်တန်းခြေအပေါ် မူတည်၍ ခန့်မှန်းပေးသည့် model အဖြစ်သာ တည်ဆောက်ထားသော LLM များပေါ်တွင် အခြေခံထားသည်။ ၎င်းတို့သည် လူသားများကဲ့သို့ "ဉာဏ်ရည်ထက်မြက်" သည် မဟုတ်ပါ။ မှန်ကန်မှုရှိမရှိနှင့် လုံခြုံရေးဆိုင်ရာ အမှားများ (security bugs) ရှိမရှိအတွက် AI ၏ output များကို စစ်ဆေးပါ။ အချို့အခါများတွင် code ကို စစ်ဆေးခြင်းသည် code ကို ကိုယ်တိုင် ရေးသားခြင်းထက် ပိုမို ခက်ခဲနိုင်သည်- အရေးကြီးသော code များအတွက် သင့်ကိုယ်တိုင် လက်ဖြင့် ရေးသားရန် စဉ်းစားပါ။ AI သည် လမ်းလွဲများသို့ ရောက်ရှိသွားနိုင်ပြီး သင့်အား မျက်စိလည်အောင် (gaslight) ကြိုးပမ်းနိုင်သည်- debugging သံသရာ (spirals) ထဲ ရောက်မသွားစေရန် သတိပြုပါ။ AI ကို အမှီသဟဲပြုစရာအဖြစ် မသုံးပါနှင့်၊ အလွန်အမင်း မှီခိုခြင်း သို့မဟုတ် အပေါ်ယံသာ နားလည်ခြင်းတို့ကို သတိထားပါ။ AI မပြုလုပ်နိုင်သေးသည့် ပရိုဂရမ်းမင်း task အမြောက်အမြား ရှိနေပါသေးသည်။ တွက်ချက်မှုဆိုင်ရာ စဉ်းစားတွေးခေါ်မှု (Computational thinking) သည် တန်ဖိုးရှိနေဆဲ ဖြစ်သည်။

# အကြံပြုထားသော ဆော့ဖ်ဝဲလ်များ (Recommended software)

IDE များနှင့် AI coding extension အများအပြားတွင် coding agent များ ပါဝင်ကြသည် ([development environment သင်ခန်းစာ](/2026/development-environment/) မှ အကြံပြုချက်များကို ကြည့်ပါ)။ အခြား လူကြိုက်များသော coding agent များတွင် Anthropic ၏ [Claude Code](https://www.claude.com/product/claude-code)၊ OpenAI ၏ [Codex](https://openai.com/codex/) နှင့် [opencode](https://github.com/anomalyco/opencode) ကဲ့သို့သော open-source agent များ ပါဝင်သည်။

# လေ့ကျင့်ခန်းများ (Exercises)

1. ပရိုဂရမ်းမင်း task တစ်ခုတည်းကို လေးကြိမ် ပြုလုပ်ခြင်းဖြင့် ကိုယ်တိုင် လက်ဖြင့် ကုဒ်ရေးခြင်း၊ AI autocomplete အသုံးပြုခြင်း၊ inline chat အသုံးပြုခြင်းနှင့် agent များ အသုံးပြုခြင်းတို့၏ အတွေ့အကြုံများကို နှိုင်းယှဉ်ကြည့်ပါ။ အကောင်းဆုံး ရွေးချယ်မှုမှာ သင် လုပ်ဆောင်နေဆဲဖြစ်သော project မှ သေးငယ်သော feature တစ်ခု ဖြစ်သည်။ အကယ်၍ အခြား အိုင်ဒီယာများကို ရှာဖွေနေပါက GitHub ရှိ open-source project များမှ "good first issue" ပုံစံ task များကို ပြီးမြောက်အောင် လုပ်ဆောင်ခြင်း သို့မဟုတ် [Advent of Code](https://adventofcode.com/) သို့မဟုတ် [LeetCode](https://leetcode.com/) ပုစ္ဆာများကို ဖြေရှင်းခြင်းဖြင့် စဉ်းစားနိုင်သည်။
1. မရင်းနှီးသေးသော codebase တစ်ခုကို လေ့လာစူးစမ်းရန် AI coding agent တစ်ခုကို အသုံးပြုပါ။ ဤသည်ကို သင် အမှန်တကယ် စိတ်ဝင်စားသော project တစ်ခုတွင် debug ပြုလုပ်လိုခြင်း သို့မဟုတ် feature အသစ်တစ်ခု ထည့်သွင်းလိုခြင်း အခြေအနေတွင် အကောင်းဆုံး ပြုလုပ်နိုင်သည်။ အကယ်၍ စိတ်ထဲတွင် မရှိပါက [opencode](https://github.com/anomalyco/opencode) agent တွင် လုံခြုံရေးဆိုင်ရာ feature များ မည်သို့ အလုပ်လုပ်သည်ကို နားလည်ရန် AI agent တစ်ခုကို အသုံးပြုကြည့်ပါ။
1. အစမှစ၍ သေးငယ်သော app တစ်ခုကို vibe code ပြုလုပ်ကြည့်ပါ။ သင့်ကိုယ်တိုင် လက်ဖြင့် code စာကြောင်းတစ်ကြောင်းမျှ မရေးပါနှင့်။
1. သင် ရွေးချယ်ထားသော coding agent အတွက် `AGENTS.md` (သို့မဟုတ် သင့် agent ၏ ဆင်တူရာ ဥပမာ `CLAUDE.md`)၊ skill တစ်ခု (ဥပမာ [skill in Claude Code](https://code.claude.com/docs/en/skills) သို့မဟုတ် [skill in Codex](https://developers.openai.com/codex/skills/))၊ နှင့် subagent တစ်ခု (ဥပမာ [subagent in Claude Code](https://code.claude.com/docs/en/sub-agents)) တို့ကို ဖန်တီး၍ စမ်းသပ်ပါ။ ၎င်းတို့ထဲမှ တစ်ခုကို အခြားတစ်ခုအစား မည်သည့်အချိန်တွင် အသုံးပြုချင်မည်နည်းဆိုသည်ကို စဉ်းစားပါ။ သင် ရွေးချယ်ထားသော coding agent သည် ဤ လုပ်ဆောင်ချက်အချို့ကို ထောက်ပံ့မည် မဟုတ်သည်ကို သတိပြုပါ- ၎င်းတို့ကို ကျော်လွန်သွားနိုင်သည် သို့မဟုတ် ထောက်ပံ့မှုပေးသော အခြား coding agent တစ်ခုကို စမ်းသပ်ကြည့်နိုင်သည်။
1. [Code Quality သင်ခန်းစာ](/2026/code-quality/) မှ Markdown bullet point များ regex လေ့ကျင့်ခန်းအတိုင်း တူညီသော ရည်မှန်းချက် ပြည့်မြောက်စေရန် coding agent တစ်ခုကို အသုံးပြုပါ။ ၎င်းသည် ဖိုင်ကို တိုက်ရိုက် ပြင်ဆင်ခြင်းဖြင့် task များကို ပြီးမြောက်စေသလား။ ဤကဲ့သို့သော task မျိုးကို ပြီးမြောက်ရန် ဖိုင်ကို Agent က တိုက်ရိုက် ပြင်ဆင်ခြင်း၏ အားနည်းချက်များနှင့် ကန့်သတ်ချက်များမှာ မည်သည်တို့နည်း။ ဖိုင်အား တိုက်ရိုက် ပြင်ဆင်ခြင်း မဟုတ်ဘဲ ပြီးမြောက်အောင် လုပ်ဆောင်နိုင်ရန် Agent ထံ မည်သို့ prompt ပေးရမည်နည်းဆိုသည်ကို ရှာဖွေပါ။ အကူအညီ- [ပထမဦးဆုံး သင်ခန်းစာ](/2026/course-shell/) တွင် ဖော်ပြခဲ့သော command-line tool များထဲမှ တစ်ခုကို အသုံးပြုရန် agent ထံ တောင်းဆိုပါ။
1. Coding agent အများစုသည် "yolo mode" ပုံစံကို ထောက်ပံ့ပေးကြသည် (ဥပမာ Claude Code တွင် `--dangerously-skip-permissions`)။ ဤ mode ကို တိုက်ရိုက် အသုံးပြုခြင်းသည် လုံခြုံမှုမရှိသော်လည်း virtual machine သို့မဟုတ် container ကဲ့သို့ သီးခြားခွဲထုတ်ထားသော ဝန်းကျင် (isolated environment) တွင် coding agent တစ်ခုကို ရန်းပြီး ကိုယ်ပိုင် လုပ်ဆောင်မှု (autonomous operation) ကို ဖွင့်ပေးခြင်းသည် လက်ခံနိုင်ဖွယ် ရှိသည်။ သင့် စက်ပေါ်တွင် ဤ setup ကို ရန်းနိုင်အောင် ပြုလုပ်ပါ။ [Claude Code devcontainers](https://code.claude.com/docs/en/devcontainer) သို့မဟုတ် [Docker Sandboxes / Claude Code](https://docs.docker.com/ai/sandboxes/agents/claude-code/) ကဲ့သို့သော documentation များသည် အသုံးဝင်နိုင်ပါသည်။ ဤ setup ကို တည်ဆောက်ရန် နည်းလမ်းတစ်မျိုးထက်မက ရှိပါသည်။
