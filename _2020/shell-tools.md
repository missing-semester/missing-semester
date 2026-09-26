---
layout: lecture
title: "Shell Tools နှင့် Scripting"
description: >
  Shell scripts များ ရေးသားနည်းနှင့် စွမ်းအားထက်မြက်သော Command-line tool များကို အသုံးပြုနည်း လေ့လာပါ။
thumbnail: /static/assets/thumbnails/2020/lec2.png
date: 2020-01-14
ready: true
video:
  aspect: 56.25
  id: kgII-YWo3Zw
---

ဤသင်ခန်းစာတွင် bash ကို Scripting ဘာသာစကားအဖြစ် အသုံးပြုခြင်း အခြေခံများနှင့်အတူ Command-line တွင် မကြာခဏ ပြုလုပ်ရလေ့ရှိသော လုပ်ငန်းဆောင်တာများအတွက် အရေးပါသည့် Shell tool အများအပြားကို မိတ်ဆက်ပေးသွားမည် ဖြစ်ပါသည်။

# Shell Scripting

ယခင် သင်ခန်းစာတွင် Shell တွင် Command များကို မည်သို့ Execute လုပ်ရမည်နှင့် ၎င်းတို့ကို Pipe ဖြင့် မည်သို့ ချိတ်ဆက်ရမည်ကို လေ့လာခဲ့ပြီး ဖြစ်သည်။ သို့သော် အခြေအနေ အများစုတွင် Command အများအပြားကို အစဉ်လိုက် လုပ်ဆောင်ရန်နှင့် Conditionals သို့မဟုတ် Loops ကဲ့သို့သော Control Flow များ အသုံးပြုရန် လိုအပ်လေ့ရှိသည်။

Shell scripts များသည် ပိုမို ရှုပ်ထွေးသော နောက်တစ်ဆင့် ဖြစ်ကြသည်။ Shell အများစုတွင် Variables များ၊ Control Flow များနှင့် သီးသန့် Syntax များ ပါဝင်သော ကိုယ်ပိုင် Scripting ဘာသာစကား ရှိကြသည်။ Shell Scripting ၏ အခြား Scripting ဘာသာစကားများနှင့် ကွဲပြားသော အချက်မှာ Shell နှင့် သက်ဆိုင်သော လုပ်ငန်းဆောင်တာများကို အထူး ပြုလုပ်နိုင်ရန် Design ထုတ်ထားခြင်း ဖြစ်သည်။ ထို့ကြောင့် Command Pipeline များ ဖန်တီးခြင်း၊ ရလဒ်များကို File များအဖြစ် သိမ်းဆည်းခြင်းနှင့် Standard Input မှ ဖတ်ရှုခြင်းတို့မှာ Shell Scripting တွင် မူလ ပါဝင်ပြီးသား ဖြစ်သဖြင့် ယေဘုယျ Scripting ဘာသာစကားများထက် အသုံးပြုရ ပိုမို လွယ်ကူစေပါသည်။ ဤသင်ခန်းစာတွင် အသုံးအများဆုံး ဖြစ်သည့် Bash Scripting ကို အဓိကထား လေ့လာသွားပါမည်။

Bash တွင် Variable များ သတ်မှတ်ရန် `foo=bar` syntax ကို အသုံးပြုပြီး Variable ၏ တန်ဖိုးကို ရယူရန် `$foo` ကို အသုံးပြုသည်။ `foo = bar` ဟု ရေးသားပါက အလုပ်လုပ်မည် မဟုတ်ပါ (ယင်းကို `foo` ပရိုဂရမ်အား `=` နှင့် `bar` အား Argument အဖြစ် ပေးပို့လိုက်သည်ဟု အဓိက အဓိပ္ပာယ်ဖော်သောကြောင့် ဖြစ်သည်)။ ယေဘုယျအားဖြင့် Shell Script များတွင် Space (ဟာကွက်) သည် Argument များကို ခွဲခြားပေးသည်ကို သတိပြုပါ။

Bash တွင် String များကို `'` နှင့် `"` တို့ဖြင့် သတ်မှတ်နိုင်သော်လည်း ၎င်းတို့သည် တူညီမှု မရှိပါ။ `'` ဖြင့် သတ်မှတ်ထားသော String များသည် Literal String (မူရင်း စာသားအတိုင်း) ဖြစ်ပြီး Variable တန်ဖိုးများကို အစားထိုးပေးမည် မဟုတ်ဘဲ၊ `"` ဖြင့် သတ်မှတ်ထားသော String များတွင်မူ Variable တန်ဖိုးများကို အစားထိုးပေးမည် ဖြစ်သည်။

```bash
foo=bar
echo "$foo"
# prints bar
echo '$foo'
# prints $foo
```

အခြား ပရိုဂရမ်းမင်း ဘာသာစကားများကဲ့သို့ပင် Bash သည် `if`၊ `case`၊ `while` နှင့် `for` အပါအဝင် Control flow စနစ်များကို ပံ့ပိုးပေးသည်။ ထို့ပြင် `bash` တွင် Argument များကို လက်ခံပြီး အလုပ်လုပ်နိုင်သော Function များလည်း ပါရှိသည်။ အောက်ပါ ဥပမာမှာ Directory တစ်ခု ဖန်တီးပြီး ထို Directory အတွင်းသို့ `cd` ဝင်ရောက်ပေးသော Function ဖြစ်သည်-

```bash
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```

ဒီနေရာမှာ `$1` သည် Script/Function ၏ ပထမဆုံး Argument ဖြစ်သည်။ အခြား Scripting ဘာသာစကားများနှင့် မတူဘဲ Bash တွင် Argument များ၊ Error Code များနှင့် အခြား သက်ဆိုင်ရာ Variable များကို ညွှန်းဆိုရန် အထူး Variable များကို အသုံးပြုကြသည်။ အောက်တွင် အချို့ကို စုစည်းဖော်ပြထားပါသည်-
- `$0` - Script ၏ အမည်
- `$1` မှ `$9` - Script သို့ ပေးပို့လိုက်သော Argument များ။ `$1` မှာ ပထမဆုံး Argument ဖြစ်သည်။
- `$@` - Argument အားလုံး
- `$#` - Argument အရေအတွက်
- `$?` - ယခင် Command ၏ Return Code (အလုပ်လုပ်ပုံ အခြေအနေ)
- `$$` - လက်ရှိ Script ၏ Process Identification Number (PID)
- `!!` - Argument အပါအဝင် ယခင် Command အပြည့်အစုံ။ မကြာခဏ အသုံးပြုသော စံနမူနာမှာ Permission မရှိ၍ Command ပျက်စီးသွားသည့်အခါ `sudo !!` ဖြင့် Command ကို sudo အဖြစ် ချက်ချင်း ပြန်လည် Run ခြင်း ဖြစ်သည်။
- `$_` - ယခင် Command ၏ နောက်ဆုံး Argument။ Interactive shell တွင် `Esc` နှိပ်ပြီး `.` သို့မဟုတ် `Alt+.` နှိပ်၍လည်း ဤတန်ဖိုးကို ရယူနိုင်သည်။

Command များသည် ပုံမှန်အားဖြင့် ရလဒ်များကို `STDOUT` မှလည်းကောင်း၊ Error များကို `STDERR` မှလည်းကောင်း ထုတ်ပေးကြပြီး၊ Error အခြေအနေများကို Script တွင် ပိုမို အဆင်ပြေစွာ စစ်ဆေးနိုင်ရန် Return Code များကို ပေးပို့ကြသည်။ Return Code သို့မဟုတ် Exit Status သည် Script/Command များ၏ လုပ်ဆောင်ချက် မည်သို့ ပြီးစီးခဲ့ကြောင်း ဖော်ပြသော နည်းလမ်းဖြစ်သည်။ တန်ဖိုး 0 ဖြစ်ပါက အရာအားလုံး အဆင်ပြေကြောင်း အဓိပ္ပာယ်ရပြီး 0 မဟုတ်ပါက Error ဖြစ်ပွားခဲ့ကြောင်း အဓိပ္ပာယ်ရသည်။

Exit Code များကို အသုံးပြု၍ Command များကို `&&` (AND operator) နှင့် `||` (OR operator) တို့ဖြင့် အခြေအနေပေါ် မူတည်၍ Run နိုင်ပါသည်။ Command များကို စာကြောင်း တစ်ကြောင်းတည်းတွင် မာလတီကော်လံ `;` ဖြင့်လည်း ခွဲခြားနိုင်ပါသည်။ `true` ပရိုဂရမ်သည် အမြဲတမ်း 0 return code ပေးပြီး `false` command သည် အမြဲတမ်း 1 return code ပေးသည်။

```bash
false || echo "Oops, fail"
# Oops, fail

true || echo "Will not be printed"
#

true && echo "Things went well"
# Things went well

false && echo "Will not be printed"
#

true ; echo "This will always run"
# This will always run

false ; echo "This will always run"
# This will always run
```

အခြား အသုံးများသော စံနမူနာတစ်ခုမှာ Command ၏ Output ကို Variable အဖြစ် ရယူလိုခြင်း ဖြစ်သည်။ ယင်းကို _Command substitution_ ဖြင့် ပြုလုပ်နိုင်ပါသည်။ `$( CMD )` ဟု ရေးသားပါက `CMD` ကို Execute လုပ်ပြီး Output ကို ထိုနေရာတွင် အစားထိုးပေးမည် ဖြစ်သည်။ ဥပမာ `for file in $(ls)` ဟု ရေးပါက Shell က ပထမဦးစွာ `ls` ကို ခေါ်ယူပြီး ရရှိလာသော တန်ဖိုးများကို တိုင်ပတ် (iterate) လုပ်ဆောင်မည် ဖြစ်သည်။ အလားတူ လုပ်ဆောင်ချက်တစ်ခုမှာ _Process substitution_ ဖြစ်ပြီး၊ `<( CMD )` သည် `CMD` ကို Execute လုပ်၍ Output ကို ယာယီ ဖိုင်အဖြစ် သိမ်းဆည်းကာ `<()` နေရာတွင် ထို ဖိုင်အမည်ကို အစားထိုးပေးသည်။ ဥပမာ `diff <(ls foo) <(ls bar)` သည် `foo` နှင့် `bar` directory ထဲရှိ file အပြောင်းအလဲများကို နှိုင်းယှဉ်ပြသပေးမည် ဖြစ်သည်။

အောက်ပါ ဥပမာတွင် Argument အဖြစ် ပေးပို့ထားသော ဖိုင်များကို စစ်ဆေး၍ `foobar` စာသား ပါရှိခြင်း မရှိပါက ဖိုင်၏ အဆုံးတွင် Comment အဖြစ် ထပ်ပေါင်းထည့်ပေးပုံကို ဖော်ပြထားသည်-

```bash
#!/bin/bash

echo "Starting program at $(date)" # Date will be substituted

echo "Running program $0 with $# arguments with pid $$"

for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    # When pattern is not found, grep has exit status 1
    # We redirect STDOUT and STDERR to a null register since we do not care about them
    if [[ $? -ne 0 ]]; then
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
done
```

Bash တွင် နှိုင်းယှဉ်ချက်များ ပြုလုပ်ရာတွင် `[ ]` အစား Bracket နှစ်ထပ် `[[ ]]` ကို အသုံးပြုရန် အကြံပြုပါသည်။

Script များကို Run သည့်အခါ အလားတူ Argument များကို လွယ်ကူစွာ ပေးပို့နိုင်ရန် ဖိုင်အမည် တိုးချဲ့ခြင်း (Filename expansion) သို့မဟုတ် Shell _globbing_ ကို အသုံးပြုနိုင်သည်-
- Wildcards - `?` (စာလုံး တစ်လုံး) နှင့် `*` (စာလုံး မည်မျှမဆို) ကို အသုံးပြု၍ ရှာဖွေနိုင်ပါသည်။ ဥပမာ `rm foo?` သည် `foo1` နှင့် `foo2` ကို ဖျက်ဆီးမည် ဖြစ်ပြီး `rm foo*` သည် `bar` မှလွဲ၍ ကျန်ရှိသော `foo` စတင်သည့် ဖိုင်အားလုံးကို ဖျက်ဆီးမည် ဖြစ်သည်။
- Curly braces `{}` - တွန့်ကွင်း `{}` များကို အသုံးပြု၍ အသုံးများသော စာသားများကို အလိုအလျောက် တိုးချဲ့ခိုင်းနိုင်ပါသည်။ ဥပမာ `convert image.{png,jpg}` သည် `convert image.png image.jpg` ဟု တိုးချဲ့သွားမည် ဖြစ်သည်။

```bash
convert image.{png,jpg}
# Will expand to
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# Will expand to
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# Globbing techniques can also be combined
mv *{.py,.sh} folder
# Will move all *.py and *.sh files

mkdir foo bar
# This creates files foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h
touch {foo,bar}/{a..h}
touch foo/x bar/y
# Show differences between files in foo and bar
diff <(ls foo) <(ls bar)
```

`bash` script များ ရေးသားရာတွင် အမှားများကို ကူညီ ရှာဖွေပေးရန် [shellcheck](https://github.com/koalaman/shellcheck) ကဲ့သို့သော tool များကို အသုံးပြုနိုင်ပါသည်။

Script များကို Bash တစ်ခုတည်း မဟုတ်ဘဲ Python ကဲ့သို့သော အခြား ဘာသာစကားများဖြင့်လည်း ရေးသားနိုင်ပါသည်။ ဖိုင်၏ ထိပ်ဆုံးတွင် [Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) စာကြောင်း (ဥပမာ `#!/usr/bin/env python`) ထည့်သွင်းပေးထားပါက Kernel က သက်ဆိုင်ရာ Interpreter ဖြင့် Run ပေးမည် ဖြစ်သည်။

# Shell Tools

## Command များ အသုံးပြုပုံကို ရှာဖွေခြင်း (Finding how to use commands)

Command များနှင့် ပတ်သက်၍ အသေးစိတ် ညွှန်းဆိုချက် စာအုပ်များကို ကြည့်ရှုရန် [`man`](https://www.man7.org/linux/man-pages/man1/man.1.html) (manual) ကို အသုံးပြုနိုင်ပါသည်။ ဥပမာ `man rm` ဖြင့် `rm` command ၏ အသုံးပြုပုံနှင့် Flag များကို ကြည့်ရှုနိုင်ပါသည်။

Manpage များသည် တစ်ခါတစ်ရံ လွန်စွာ အသေးစိတ်ကျသဖြင့် ရိုးရှင်းသော အသုံးပြုပုံ စံနမူနာများကို အမြန် ကြည့်လိုပါက [TLDR pages](https://tldr.sh/) ကို အသုံးပြုနိုင်ပါသည်။

## ဖိုင်များ ရှာဖွေခြင်း (Finding files)

UNIX စနစ်များတွင် ဖိုင်များနှင့် Directory များကို လိုက်လံ ရှာဖွေရန် [`find`](https://www.man7.org/linux/man-pages/man1/find.1.html) tool ပါဝင်ပါသည်။

```bash
# Find all directories named src
find . -name src -type d
# Find all python files that have a folder named test in their path
find . -path '*/test/*.py' -type f
# Find all files modified in the last day
find . -mtime -1
# Find all zip files with size in range 500k to 10M
find . -size +500k -size -10M -name '*.tar.gz'
```

`find` သည် တွေ့ရှိသော ဖိုင်များပေါ်တွင် `-exec` Flag ဖြင့် Command များ တိုက်ရိုက် Run ပေးနိုင်ပါသည်။

`find` ၏ အစားထို ပိုမို မြန်ဆန် အသုံးပြုရ လွယ်ကူသော Tool အဖြစ် [`fd`](https://github.com/sharkdp/fd) ကို အသုံးပြုနိုင်ပါသည်။ အလားတူ စနစ်အတွင်း အညွှန်း (index) စနစ်ဖြင့် လျှင်မြန်စွာ ရှာဖွေရန် [`locate`](https://www.man7.org/linux/man-pages/man1/locate.1.html) ကို အသုံးပြုနိုင်ပါသည်။

## ကုဒ်များ ရှာဖွေခြင်း (Finding code)

ဖိုင် စာသား အကြောင်းအရာများအတွင်း စာသား ပုံစံ (pattern) များကို ရှာဖွေရန် [`grep`](https://www.man7.org/linux/man-pages/man1/grep.1.html) ကို အသုံးပြုသည်။ ပိုမို မြန်ဆန်သော ခေတ်မီ အစားထိုး Tool များအဖြစ် [ripgrep (`rg`)](https://github.com/BurntSushi/ripgrep) ကို အသုံးပြုနိုင်သည်-

```bash
# Find all python files where I used the requests library
rg -t py 'import requests'
# Find all files (including hidden files) without a shebang line
rg -u --files-without-match "^#\!"
# Find all matches of foo and print the following 5 lines
rg foo -A 5
# Print statistics of matches (# of matched lines and files )
rg --stats PATTERN
```

## Shell Command များကို ပြန်လည်ရှာဖွေခြင်း (Finding shell commands)

ယခင် ရိုက်ထည့်ခဲ့ဖူးသော Command များကို ရှာဖွေရန် `history` command ကို သို့မဟုတ် `Ctrl+R` ကို အသုံးပြုနိုင်ပါသည်။ ထို့ပြင် [fzf](https://github.com/junegunn/fzf) fuzzy finder ကို အသုံးပြု၍ လည်းကောင်း၊ [fish](https://fishshell.com/) သို့မဟုတ် [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) ဖြင့် History အခြေပြု အလိုအလျောက် အကြံပြုချက်များ ရယူ၍လည်းကောင်း အသုံးပြုနိုင်ပါသည်။

## Directory များအတွင်း သွားလာခြင်း (Directory Navigation)

မကြာခဏ သွားရောက်လေ့ရှိသော Directory များသို့ လျင်မြန်စွာ `cd` ဝင်ရောက်ရန် [`fasd`](https://github.com/clvv/fasd) ( command `z` ) သို့မဟုတ် [`autojump`](https://github.com/wting/autojump) ( command `j` ) တို့ကို အသုံးပြုနိုင်ပါသည်။ Directory အဆောက်အအုံကို သtree ပုံစံ ကြည့်ရှုရန် [`tree`](https://linux.die.net/man/1/tree) သို့မဟုတ် [`broot`](https://github.com/Canop/broot) တို့ကို အသုံးပြုနိုင်ပါသည်။

# လေ့ကျင့်ခန်းများ (Exercises)

၁။ [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) ကို ဖတ်ရှုပြီး ဖိုင်ဝှက်များ ပါဝင်သော၊ ဖိုင်ပမာဏကို ဖတ်ရှုရ လွယ်ကူသော format (ဥပမာ 454M) ဖြင့် ဖော်ပြထားသော၊ မကြာသေးမီက ပြင်ဆင်ခဲ့သော စီစဉ်မှုအတိုင်း စီထားသော အရောင်ပါဝင်သည့် `ls` command တစ်ခု ရေးသားပါ။

{% comment %}
ls -lath --color=auto
{% endcomment %}

၂။ `marco` နှင့် `polo` ဟုခေါ်သော Bash function နှစ်ခုကို ရေးသားပါ။ `marco` ကို Execute လုပ်သည့်အခါ လက်ရှိ ရောက်ရှိနေသော Directory ကို သိမ်းဆည်းထားရမည်ဖြစ်ပြီး၊ မည်သည့် Directory တွင် ရောက်ရှိနေသည်ဖြစ်စေ `polo` ကို Execute လုပ်လိုက်သည်နှင့် `marco` Run ခဲ့သော Directory သို့ ပြန်လည် `cd` ဝင်ရောက်သွားရမည် ဖြစ်သည်။

{% comment %}
marco() {
    export MARCO=$(pwd)
}

polo() {
    cd "$MARCO"
}
{% endcomment %}

၃။ ပျက်စီးခဲသော Command တစ်ခု ရှိသည် ဆိုပါစို့။ ထို Command ပျက်စီးသွားသည့်အထိ ထပ်ခါတလဲလဲ Run ပေးပြီး Error နှင့် Output များကို ဖိုင်ထဲသို့ သိမ်းဆည်းကာ မည်မျှ ကြိမ်ဖန် Run ခဲ့ရကြောင်း ထုတ်ပြန်ပေးသော Bash script တစ်ခု ရေးသားပါ။

    ```bash
    #!/usr/bin/env bash

    n=$(( RANDOM % 100 ))

    if [[ n -eq 42 ]]; then
       echo "Something went wrong"
       >&2 echo "The error was using magic numbers"
       exit 1
    fi

    echo "Everything went according to plan"
    ```

{% comment %}
#!/usr/bin/env bash

count=0
until [[ "$?" -ne 0 ]];
do
  count=$((count+1))
  ./random.sh &> out.txt
done

echo "found error after $count runs"
cat out.txt
{% endcomment %}

၄။ `find` ၏ `-exec` ကို အသုံးပြု၍ ရှာဖွေတွေ့ရှိသမျှ HTML ဖိုင်များအားလုံးကို Zip ဖိုင်အဖြစ် ပြောင်းလဲပေးသော Command တစ်ခုကို [`xargs`](https://www.man7.org/linux/man-pages/man1/xargs.1.html) အသုံးပြု၍ ရေးသားပါ။

၅။ (အဆင့်မြင့်) Directory တစ်ခုအတွင်း မကြာသေးမီက ပြင်ဆင်ထားသော ဖိုင်ကို ရှာဖွေပေးသည့် သို့မဟုတ် ဖိုင်အားလုံးကို ပြင်ဆင်ခဲ့သော အချိန်အလိုက် စီစဉ်ပေးသည့် Command သို့မဟုတ် Script တစ်ခု ရေးသားပါ။
