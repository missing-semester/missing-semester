---
layout: lecture
title: "Command-line Environment"
description: >
  เรียนรู้วิธีการทำงานของโปรแกรม command-line ตั้งแต่ input/output streams, environment variables ไปจนถึงการเชื่อมต่อ remote machine ด้วย SSH
thumbnail: /static/assets/thumbnails/2026/lec2.png
date: 2026-01-13
ready: true
video:
  aspect: 56.25
  id: ccBGsPedE9Q
---

อย่างที่เราคุยกันในบทก่อน shell ส่วนใหญ่ไม่ได้เป็นแค่ตัว launcher สำหรับรันโปรแกรมอื่น แต่จริงๆ แล้วมันคือภาษาโปรแกรมที่สมบูรณ์ มี patterns และ abstractions ให้ใช้มากมาย สิ่งที่ทำให้ shell scripting แตกต่างจากภาษาอื่นคือ ทุกอย่างถูกออกแบบมาเพื่อการรันโปรแกรมและให้โปรแกรมต่างๆ สื่อสารกันได้อย่างง่ายและมีประสิทธิภาพ

โดยเฉพาะอย่างยิ่ง shell scripting ผูกติดอยู่กับ _conventions_ มาก สำหรับโปรแกรม CLI จะทำงานร่วมกับสภาพแวดล้อม shell ได้ดี มันต้องปฏิบัติตาม patterns ทั่วไปบางอย่าง บทนี้เราจะมาทำความเข้าใจ concepts เหล่านั้น รวมถึง conventions ที่พบได้ทั่วไปสำหรับการใช้งานและ configure โปรแกรม CLI

# The Command Line Interface

การเขียน function ในภาษาโปรแกรมทั่วไปจะมีหน้าตาแบบนี้:

```
def add(x: int, y: int) -> int:
    return x + y
```

เราเห็น input และ output ได้ชัดเจน แต่ shell scripts นั้นมีหน้าตาต่างออกไปมากเมื่อมองแวบแรก:

```shell
#!/usr/bin/env bash

if [[ -f $1 ]]; then
    echo "Target file already exists"
    exit 1
else
    if $DEBUG; then
        grep 'error' - | tee $1
    else
        grep 'error' - > $1
    fi
    exit 0
fi
```

เพื่อทำความเข้าใจ script แบบนี้อย่างถ่องแท้ เราต้องรู้จัก concepts สำคัญที่ปรากฏบ่อยเมื่อโปรแกรม shell สื่อสารกันหรือกับสภาพแวดล้อม shell:

- Arguments
- Streams
- Environment variables
- Return codes
- Signals

## Arguments

โปรแกรม shell รับ arguments เป็น list ตอนที่ถูกรัน Arguments คือ strings ธรรมดา และเป็นหน้าที่ของโปรแกรมเองที่จะตีความว่าจะใช้อย่างไร ตัวอย่างเช่น เมื่อรัน `ls -l folder/` คือการรันโปรแกรม `/bin/ls` ด้วย arguments `['-l', 'folder/']`

ภายใน shell script เราเข้าถึง arguments ผ่าน syntax พิเศษ โดย `$1` คือ argument แรก, `$2` คือตัวที่สอง ไล่ไปจนถึง `$9` ใช้ `$@` เพื่อเข้าถึง arguments ทั้งหมดเป็น list, `$#` สำหรับจำนวน arguments และ `$0` สำหรับชื่อโปรแกรม

Arguments ส่วนใหญ่จะเป็นการผสมกันระหว่าง _flags_ และ strings ธรรมดา Flags สังเกตได้จากการนำหน้าด้วยขีด (`-`) หรือขีดคู่ (`--`) Flags มักเป็น optional และใช้ปรับพฤติกรรมของโปรแกรม ตัวอย่างเช่น `ls -l` เปลี่ยนรูปแบบการแสดงผลของ `ls`

Flags แบบขีดคู่มีชื่อยาว เช่น `--all` และแบบขีดเดียวมักตามด้วยตัวอักษรเดียว เช่น `-a` โดย `ls -a` กับ `ls --all` ให้ผลเหมือนกัน Single dash flags มักรวมกันได้ ดังนั้น `ls -l -a` กับ `ls -la` ก็เท่ากัน ลำดับ flags มักไม่สำคัญ flags ที่พบบ่อยและควรรู้จักไว้ได้แก่ `--help`, `--verbose`, `--version`

> Flags เป็นตัวอย่างแรกของ shell conventions ภาษา shell ไม่ได้บังคับให้ใช้ `-` หรือ `--` แต่การไม่ทำตามจะทำให้คนอื่นสับสน ในทางปฏิบัติ ภาษาโปรแกรมส่วนใหญ่มี library สำหรับ parse CLI flags อยู่แล้ว เช่น `argparse` ใน Python

Convention อีกอย่างของ CLI คือการรับ arguments จำนวนตัวแปรที่เป็น type เดียวกัน เมื่อได้รับแบบนี้ คำสั่งจะทำ operation เดิมกับแต่ละตัว:

```shell
mkdir src
mkdir docs
# เทียบเท่ากับ
mkdir src docs
```

Syntax นี้จะทรงพลังมากเมื่อรวมกับ _globbing_ ซึ่งเป็น special patterns ที่ shell จะขยายก่อนเรียกโปรแกรม

สมมติเราต้องการลบไฟล์ .py ทั้งหมดในโฟลเดอร์ปัจจุบัน วิธียาวคือ:

```shell
for file in $(ls | grep -P '\.py$'); do
    rm "$file"
done
```

แต่เราใช้แค่ `rm *.py` แทนได้เลย!

เมื่อพิมพ์ `rm *.py` shell จะไม่ส่ง `['*.py']` ไปให้ `/bin/rm` แต่จะค้นหาไฟล์ที่ match กับ pattern `*.py` ก่อน โดย `*` match ได้กับ string ใดๆ (รวมถึงว่างเปล่า) ดังนั้นถ้าในโฟลเดอร์มี `main.py` และ `utils.py` โปรแกรม `rm` จะได้รับ `['main.py', 'utils.py']`

Globs ที่พบบ่อย ได้แก่ `*` (ศูนย์ตัวหรือมากกว่า), `?` (หนึ่งตัว) และ `{}` สำหรับขยาย list ออกเป็นหลาย arguments:

```shell
touch folder/{a,b,c}.py
# ขยายเป็น
touch folder/a.py folder/b.py folder/c.py

convert image.{png,jpg}
# ขยายเป็น
convert image.png image.jpg

cp /path/to/project/{setup,build,deploy}.sh /newpath
# ขยายเป็น
cp /path/to/project/setup.sh /path/to/project/build.sh /path/to/project/deploy.sh /newpath

# รวมวิธีการ glob เข้าด้วยกันได้
mv *{.py,.sh} folder
# ย้ายทุกไฟล์ *.py และ *.sh
```

> บาง shell เช่น zsh รองรับ `**` ที่ขยายแบบ recursive ด้วย เช่น `rm **/*.py` จะลบไฟล์ .py ทุกตัวในทุก subfolder


## Streams

เมื่อรัน pipeline แบบนี้:

```shell
cat myfile | grep -P '\d+' | uniq -c
```

จะเห็นว่า `grep` สื่อสารกับทั้ง `cat` และ `uniq` สิ่งสำคัญที่ควรรู้คือทั้งสามโปรแกรมรันพร้อมกันทีเดียว shell ไม่ได้รัน cat เสร็จก่อนแล้วค่อยรัน grep แต่ spawn ทั้งสามพร้อมกันและเชื่อม output ของ cat เข้า input ของ grep และ output ของ grep เข้า input ของ uniq

เราสามารถพิสูจน์ได้ว่าทุกคำสั่งใน pipeline เริ่มพร้อมกันจริง:

```console
$ (sleep 15 && cat numbers.txt) | grep -P '^\d$' | sort | uniq  &
[1] 12345
$ ps | grep -P '(sleep|cat|grep|sort|uniq)'
  32930 pts/1    00:00:00 sleep
  32931 pts/1    00:00:00 grep
  32932 pts/1    00:00:00 sort
  32933 pts/1    00:00:00 uniq
  32948 pts/1    00:00:00 grep
```

จะเห็นว่าทุก process ยกเว้น `cat` รันอยู่ทันที shell spawn และเชื่อม streams ไว้ก่อนที่ process ใดจะเสร็จ `cat` จะเริ่มก็ต่อเมื่อ sleep เสร็จ แล้ว output ก็จะไหลต่อไปยัง grep ตามลำดับ

ทุกโปรแกรมมี input stream ที่เรียกว่า stdin (standard input) เมื่อใช้ pipe stdin จะเชื่อมต่ออัตโนมัติ หลายโปรแกรมรับ `-` เป็นชื่อไฟล์ หมายถึง "อ่านจาก stdin":

```shell
# สองคำสั่งนี้เทียบเท่ากันเมื่อข้อมูลมาจาก pipe
echo "hello" | grep "hello"
echo "hello" | grep "hello" -
```

ทุกโปรแกรมมี output streams สองตัว คือ stdout และ stderr stdout ใช้สำหรับ pipe ข้อมูลไปโปรแกรมถัดไป ส่วน stderr ใช้สำหรับ error messages และ warnings โดยไม่ถูก parse โดยโปรแกรมถัดไปใน pipeline:

```console
$ ls /nonexistent
ls: cannot access '/nonexistent': No such file or directory
$ ls /nonexistent | grep "pattern"
ls: cannot access '/nonexistent': No such file or directory
# error ยังแสดงอยู่เพราะ stderr ไม่ถูก pipe
$ ls /nonexistent 2>/dev/null
# ไม่มี output เพราะ stderr ถูก redirect ไปที่ /dev/null
```

Shell มี syntax สำหรับ redirect streams:

```shell
# Redirect stdout ไปยังไฟล์ (เขียนทับ)
echo "hello" > output.txt

# Redirect stdout ไปยังไฟล์ (ต่อท้าย)
echo "world" >> output.txt

# Redirect stderr ไปยังไฟล์
ls foobar 2> errors.txt

# Redirect ทั้ง stdout และ stderr ไปยังไฟล์เดียวกัน
ls foobar &> all_output.txt

# Redirect stdin จากไฟล์
grep "pattern" < input.txt

# ทิ้ง output โดย redirect ไปที่ /dev/null
cmd > /dev/null 2>&1
```

อีก tool ที่มีประโยชน์และสะท้อน Unix philosophy ได้ดีคือ [`fzf`](https://github.com/junegunn/fzf) ซึ่งเป็น fuzzy finder มันอ่าน lines จาก stdin และเปิด interactive interface ให้กรองและเลือก:

```console
$ ls | fzf
$ cat ~/.bash_history | fzf
```

`fzf` สามารถผสานเข้ากับ shell operations ต่างๆ ได้มาก เราจะเห็นการใช้งานเพิ่มเติมในหัวข้อ shell customization


## Environment variables

ใน bash เราใช้ syntax `foo=bar` เพื่อกำหนดค่าตัวแปร และเข้าถึงค่าด้วย `$foo` ระวังว่า `foo = bar` เป็น syntax ที่ผิด เพราะ shell จะตีความว่าเป็นการเรียกโปรแกรม `foo` ด้วย arguments `['=', 'bar']` ใน shell scripting ช่องว่างทำหน้าที่แยก arguments โดยเฉพาะ ซึ่งอาจทำให้สับสนในช่วงแรก ควรจำไว้ให้ดี

ตัวแปรใน shell ไม่มี type ทุกตัวเป็น string และ single quote กับ double quote ใช้แทนกันไม่ได้ Strings ที่ล้อมด้วย `'` เป็น literal strings จะไม่ขยาย variables ไม่ทำ command substitution และไม่ process escape sequences แต่ `"` จะทำทั้งหมดนั้น:

```shell
foo=bar
echo "$foo"
# แสดง bar
echo '$foo'
# แสดง $foo
```

เพื่อ capture output ของคำสั่งเข้าตัวแปร เราใช้ _command substitution_:

```shell
files=$(ls)
echo "$files" | grep README
echo "$files" | grep ".py"
```

output ของ ls จะถูกเก็บในตัวแปร `$files` โดยรวม newlines ไว้ด้วย ซึ่งทำให้ `grep` รู้ว่าต้องทำงานกับแต่ละรายการแยกกัน

feature ที่คล้ายกันแต่ไม่ค่อยรู้จักคือ _process substitution_ โดย `<( CMD )` จะรัน `CMD` เก็บ output ลงในไฟล์ชั่วคราว แล้วแทนที่ `<()` ด้วยชื่อไฟล์นั้น มีประโยชน์เมื่อคำสั่งต้องรับค่าผ่านไฟล์แทน STDIN เช่น `diff <(ls src) <(ls docs)` จะแสดงความแตกต่างระหว่างไฟล์ในสองโฟลเดอร์

เมื่อ shell program เรียกโปรแกรมอื่น มันจะส่งชุดตัวแปรที่เรียกว่า _environment variables_ ไปด้วย เราดู environment variables ปัจจุบันได้ด้วย `printenv` และส่งค่าไปชั่วคราวได้โดยนำหน้าคำสั่ง:

> Environment variables ตามแบบแผนจะเขียนด้วยตัวพิมพ์ใหญ่ (เช่น `HOME`, `PATH`, `DEBUG`) นี่เป็น convention ไม่ใช่ข้อบังคับ แต่ช่วยให้แยกแยะออกจาก local shell variables ที่มักเป็นตัวพิมพ์เล็ก

```shell
TZ=Asia/Tokyo date  # แสดงเวลาปัจจุบันในโตเกียว
echo $TZ  # จะว่างเปล่า เพราะ TZ ถูก set เฉพาะสำหรับ child command นั้นเท่านั้น
```

หรือจะใช้ `export` เพื่อให้ child processes ทุกตัว inherit ตัวแปรนั้น:

```shell
export DEBUG=1
# โปรแกรมทุกตัวหลังจากนี้จะมี DEBUG=1 ใน environment
bash -c 'echo $DEBUG'
# แสดง 1
```

ลบตัวแปรด้วย `unset` เช่น `unset DEBUG`

> Environment variables ใช้ปรับพฤติกรรมโปรแกรมแบบ implicit แทนที่จะ explicit เช่น shell set `$HOME` ด้วย path ของ home folder และโปรแกรมต่างๆ ก็ใช้ตัวแปรนี้แทนที่จะรับ `--home /home/alice` อย่างชัดเจน อีกตัวอย่างคือ `$TZ` ที่หลายโปรแกรมใช้ format วันที่และเวลา

## Return codes

output หลักของ shell program ส่งผ่าน stdout/stderr streams และการแก้ไข filesystem

shell script return exit code เป็นศูนย์โดย default Convention คือศูนย์หมายถึงสำเร็จ ส่วนค่าอื่นหมายถึงมีปัญหา เพื่อ return exit code ที่ไม่ใช่ศูนย์ ใช้ `exit NUM` และเข้าถึง return code ของคำสั่งล่าสุดผ่าน `$?`

Shell มี boolean operators `&&` (AND) และ `||` (OR) ที่ทำงานกับ return code ของโปรแกรม ทั้งสองเป็น [short-circuiting](https://en.wikipedia.org/wiki/Short-circuit_evaluation) operators ซึ่งใช้รันคำสั่งแบบมีเงื่อนไขตามผลลัพธ์ของคำสั่งก่อนหน้า:

```shell
# echo จะรันก็ต่อเมื่อ grep สำเร็จ (พบ match)
grep -q "pattern" file.txt && echo "Pattern found"

# echo จะรันก็ต่อเมื่อ grep ล้มเหลว (ไม่พบ match)
grep -q "pattern" file.txt || echo "Pattern not found"

# true คือโปรแกรมที่สำเร็จเสมอ
true && echo "This will always print"

# false คือโปรแกรมที่ล้มเหลวเสมอ
false || echo "This will always print"
```

หลักการเดียวกันใช้กับ `if` และ `while` ทั้งสองใช้ return codes ในการตัดสินใจ:

```shell
# if ใช้ return code ของ condition command (0 = true, ไม่ใช่ศูนย์ = false)
if grep -q "pattern" file.txt; then
    echo "Found"
fi

# while ทำงานต่อไปตราบที่คำสั่ง return 0
while read line; do
    echo "$line"
done < file.txt
```

## Signals

บางครั้งต้องหยุดโปรแกรมขณะที่มันทำงาน วิธีง่ายที่สุดคือกด `Ctrl-C` แต่ทำไมบางทีมันถึงไม่หยุด?

```console
$ sleep 100
^C
$
```

> `^C` คือวิธีที่ `Ctrl` แสดงผลใน terminal

สิ่งที่เกิดขึ้นจริงๆ คือ:

1. กด `Ctrl-C`
2. Shell ระบุ key combination พิเศษนั้น
3. Shell ส่ง SIGINT signal ไปยัง process `sleep`
4. Signal หยุดการทำงานของ `sleep`

Signals เป็นกลไกสื่อสารพิเศษ เมื่อ process รับ signal มันจะหยุดชั่วคราว จัดการ signal และอาจเปลี่ยนทิศทางการทำงาน ด้วยเหตุนี้ signals จึงเป็น _software interrupts_

ต่อไปนี้เป็น Python program ตัวอย่างที่ดัก `SIGINT` แล้วละเว้นมัน ทำให้โปรแกรมไม่หยุด ต้องใช้ `SIGQUIT` (Ctrl-\) แทน:

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

ผลที่ได้เมื่อส่ง `SIGINT` สองครั้ง ตามด้วย `SIGQUIT`:

```console
$ python sigint.py
24^C
I got a SIGINT, but I am not stopping
26^C
I got a SIGINT, but I am not stopping
30^\[1]    39913 quit       python sigint.py
```

`SIGTERM` เป็น signal ทั่วไปที่ใช้ขอให้ process ออกอย่าง graceful ส่งได้ด้วย [`kill`](https://www.man7.org/linux/man-pages/man1/kill.1.html) ด้วย syntax `kill -TERM <PID>`

Signals ทำได้มากกว่าแค่ kill process ตัวอย่างเช่น `SIGSTOP` หยุดชั่วคราว (pause) process ใน terminal กด `Ctrl-Z` จะส่ง `SIGTSTP` (Terminal Stop) จากนั้นใช้ [`fg`](https://www.man7.org/linux/man-pages/man1/fg.1p.html) หรือ [`bg`](https://man7.org/linux/man-pages/man1/bg.1p.html) เพื่อ continue ใน foreground หรือ background

คำสั่ง [`jobs`](https://www.man7.org/linux/man-pages/man1/jobs.1p.html) แสดง jobs ที่ยังไม่เสร็จในปัจจุบัน อ้างอิง job ด้วย pid (ใช้ [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) เพื่อหา) หรือใช้ `%` ตามด้วยหมายเลข job และ `$!` สำหรับ job ล่าสุดที่ background

suffix `&` รันคำสั่งใน background และคืน prompt กลับมาทันที หรือ background โปรแกรมที่รันอยู่แล้วด้วย `Ctrl-Z` แล้วตามด้วย `bg`

ระวังว่า backgrounded processes ยังเป็น child ของ terminal และจะตายเมื่อปิด terminal (จะส่ง `SIGHUP`) ป้องกันได้ด้วยการรันผ่าน [`nohup`](https://www.man7.org/linux/man-pages/man1/nohup.1.html) หรือใช้ `disown` ถ้า process เริ่มไปแล้ว หรือใช้ terminal multiplexer (จะพูดถึงในหัวข้อถัดไป)

ตัวอย่าง session สำหรับแสดง concepts เหล่านี้:

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

$ kill -SIGHUP %1
[1]  + 18653 hangup     sleep 1000

$ kill -SIGHUP %2   # nohup ป้องกันจาก SIGHUP

$ jobs
[2]  + running    nohup sleep 2000

$ kill %2
[2]  + 18745 terminated  nohup sleep 2000
```

`SIGKILL` เป็น signal พิเศษที่ process ไม่สามารถ capture ได้และจะ terminate ทันทีเสมอ แต่อาจทิ้ง orphaned child processes ไว้

อ่านเพิ่มเติมเกี่ยวกับ signals ได้ [ที่นี่](https://en.wikipedia.org/wiki/Signal_(IPC)) หรือรัน [`man signal`](https://www.man7.org/linux/man-pages/man7/signal.7.html) หรือ `kill -l`

ภายใน shell scripts ใช้ `trap` built-in เพื่อรันคำสั่งเมื่อรับ signals มีประโยชน์สำหรับ cleanup:

```shell
#!/usr/bin/env bash
cleanup() {
    echo "Cleaning up temporary files..."
    rm -f /tmp/mytemp.*
}
trap cleanup EXIT  # รัน cleanup เมื่อ script ออก
trap cleanup SIGINT SIGTERM  # รันด้วยเมื่อกด Ctrl-C หรือ kill
```
{% comment %}
### Users, Files and Permissions

Lastly, another way programs have to indirectly communicate with each other is using files.
For a program to be able to correctly read/write/delete files and folders, the file permissions must allow the operation.

Listing a specific file will give the following output

```console
$ ls -l notes.txt
-rw-r--r--  1 alice  users  12693 Jan 11 23:05 notes.txt
```

Here `ls` is listing what is the owner of the file, user `alice`, and the group `users`. Then the `rw-r--r--` are a shorthand notation for the permissions.
In this case, the file `notes.txt` has read/write permissions for the user alice `rw-`, and only read permissions for the group and the rest of users in the file system.

```console
$ ./script.sh
# permission denied
$ chmod +x script.sh
$ ls -l script.sh
-rwxr-xr-x  1 alice  users  3125 Jan 11 23:07 script.sh
$ ./script.sh
```

For a script to be executable, the executable rights must be set, hence why we had to use the `chmod` (change mode) program.
`chmod` syntax, while intuitive, is not obvious when first encountered.
If you, like me, prefer to learn by example, this is a good usecase of the `tldr` tool (note that you need to install it first).

```console
❯ tldr chmod
  Change the access permissions of a file or directory.
  More information: <https://www.gnu.org/software/coreutils/chmod>.

  Give the [u]ser who owns a file the right to e[x]ecute it:

      chmod u+x path/to/file

  Give the [u]ser rights to [r]ead and [w]rite to a file/directory:

      chmod u+rw path/to/file_or_directory

  Give [a]ll users rights to [r]ead and e[x]ecute:

      chmod a+rx path/to/file
```

Run `tldr chmod` to see more examples, including recursive operations and group permissions.

> Your shell might show you something like `command not found: tldr`. That is because it is a more modern tool and it is not pre-installed in most systems. A good reference for how to install tools is the [https://command-not-found.com](https://command-not-found.com) website. It contains instructions for a huge collection of CLI tools for popular OS distributions.

Each program is run as a specific user in the system. We can use the `whoami` command to find our user name and `id -u` to find our UID (user id) which is the integer value that the OS associates with the user.

When running `sudo command`, the `command` is run as the root user which can bypass most permissions in the system.
Try running `sudo whoami` and `sudo id -u` to see how the output changes (you might be prompted for your password).
To change the owner of a file or folder, we use the `chown` command.

You can learn more about UNIX file permissions [here](https://en.wikipedia.org/wiki/File-system_permissions#Traditional_Unix_permissions)

So far we've focused on your local machine, but many of these skills become even more valuable when working with remote servers.

{% endcomment %}

# Remote Machines

ทุกวันนี้ programmer หลายคนทำงานกับ remote servers อยู่เป็นประจำ tool ที่ใช้กันมากที่สุดคือ SSH (Secure Shell) ที่ช่วยให้เราเชื่อมต่อกับ remote server และใช้งาน shell interface ที่คุ้นเคย:

```bash
ssh alice@server.mit.edu
```

feature ของ `ssh` ที่มักถูกมองข้ามคือความสามารถในการรันคำสั่งแบบ non-interactive โดย `ssh` จัดการ stdin/stdout ได้ถูกต้อง ทำให้รวมกับคำสั่งอื่นได้:

```shell
# ls รันบน remote, wc รันบน local
ssh alice@server ls | wc -l

# ทั้ง ls และ wc รันบน server
ssh alice@server 'ls | wc -l'

```

> ลองติดตั้ง [Mosh](https://mosh.org/) เป็นตัวแทน SSH ที่รองรับ disconnect, เปลี่ยน network และ latency สูงได้ดีกว่า

เพื่อให้ `ssh` อนุญาตให้รันคำสั่งได้ ต้องพิสูจน์ตัวตนผ่าน password หรือ SSH key การ authenticate ด้วย key ใช้ public-key cryptography พิสูจน์กับ server ว่าเป็นเจ้าของ private key โดยไม่เปิดเผย key นั้น วิธีนี้สะดวกและปลอดภัยกว่า ควรใช้แทน password ระวังว่า private key (มักอยู่ที่ `~/.ssh/id_rsa` หรือ `~/.ssh/id_ed25519`) คือรหัสผ่านของคุณ อย่าแชร์ให้ใคร

สร้าง key pair ด้วยคำสั่ง:

```bash
ssh-keygen -a 100 -t ed25519 -f ~/.ssh/id_ed25519
```

ถ้าเคย configure SSH สำหรับ GitHub แล้ว คุณอาจมี key pair อยู่แล้ว ตรวจสอบด้วย `ssh-keygen -y -f /path/to/key`

ฝั่ง server `ssh` ดูที่ `.ssh/authorized_keys` เพื่อตัดสินว่า client ไหนเข้าได้ copy public key ขึ้นไปด้วย:

```bash
cat .ssh/id_ed25519.pub | ssh alice@remote 'cat >> ~/.ssh/authorized_keys'

# หรือง่ายกว่า (ถ้ามี ssh-copy-id)

ssh-copy-id -i .ssh/id_ed25519 alice@remote
```

นอกจากรันคำสั่ง การเชื่อมต่อ SSH ยังใช้ transfer files ได้อย่างปลอดภัย [`scp`](https://www.man7.org/linux/man-pages/man1/scp.1.html) เป็น tool ดั้งเดิมที่มี syntax คือ `scp path/to/local_file remote_host:path/to/remote_file` และ [`rsync`](https://www.man7.org/linux/man-pages/man1/rsync.1.html) พัฒนาต่อจาก `scp` โดย detect ไฟล์ที่เหมือนกันเพื่อหลีกเลี่ยงการ copy ซ้ำ รองรับ symlinks, permissions และ `--partial` flag สำหรับ resume การ copy ที่ถูกขัดจังหวะ

SSH client configuration อยู่ที่ `~/.ssh/config` ให้ประกาศ hosts และ default settings ไฟล์นี้ถูกอ่านโดย `ssh`, `scp`, `rsync`, `mosh` ด้วย:

```bash
Host vm
    User alice
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519

# ใช้ wildcards ได้
Host *.mit.edu
    User alice
```




# Terminal Multiplexers

เมื่อใช้ command line เราอาจต้องการรันหลายอย่างพร้อมกัน เช่น editor กับโปรแกรมคู่กัน การเปิด terminal window ใหม่ทำได้ แต่ terminal multiplexer เป็นทางเลือกที่ versatile กว่า

Terminal multiplexers อย่าง [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) ให้เรา multiplex terminal windows ด้วย panes และ tabs เพื่อจัดการ shell sessions หลายตัวอย่างมีประสิทธิภาพ ยิ่งไปกว่านั้น ยังให้ detach session และ reattach ในภายหลังได้ มีประโยชน์มากเมื่อทำงานกับ remote machines เพราะไม่ต้องใช้ `nohup`

`tmux` ปรับแต่งได้มากและมี keybindings ทุกอันรูปแบบ `<C-b> x` หมายถึง (1) กด `Ctrl+b`, (2) ปล่อย, (3) กด `x` โครงสร้างของ `tmux`:

- **Sessions** - workspace อิสระที่มีหนึ่ง window หรือมากกว่า
    + `tmux` เริ่ม session ใหม่
    + `tmux new -s NAME` เริ่มด้วยชื่อ
    + `tmux ls` แสดง sessions ทั้งหมด
    + `<C-b> d` detach session ปัจจุบัน
    + `tmux a` attach session ล่าสุด (ใช้ `-t` ระบุ session)

- **Windows** - เทียบเท่ากับ tabs ในแต่ละ session
    + `<C-b> c` สร้าง window ใหม่ ปิดด้วย `<C-d>`
    + `<C-b> N` ไปยัง window ที่ N
    + `<C-b> p` / `<C-b> n` ไปยัง window ก่อนหน้า/ถัดไป
    + `<C-b> ,` เปลี่ยนชื่อ window
    + `<C-b> w` แสดง windows ทั้งหมด

- **Panes** - แบ่งหน้าจอใน window เดียวกัน
    + `<C-b> "` แบ่งแนวนอน
    + `<C-b> %` แบ่งแนวตั้ง
    + `<C-b> <direction>` ย้ายระหว่าง panes (ใช้ arrow keys)
    + `<C-b> z` zoom pane ปัจจุบัน
    + `<C-b> [` เข้า scrollback mode (กด `<space>` เริ่ม select, `<enter>` copy)
    + `<C-b> <space>` วน cycle รูปแบบการจัด panes

> อ่านเพิ่มเติมเกี่ยวกับ tmux ได้จาก [tutorial นี้](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) และ [คำอธิบายละเอียด](https://linuxcommand.org/lc3_adv_termmux.php)

เมื่อมี tmux และ SSH แล้ว คุณก็จะอยากปรับแต่ง environment ให้รู้สึกเหมือนบ้านไม่ว่าจะอยู่บน machine ไหน นั่นคือที่มาของ shell customization

# Customizing the Shell

โปรแกรม command line จำนวนมาก configure ด้วยไฟล์ text ธรรมดาที่เรียกว่า _dotfiles_ (ชื่อไฟล์ขึ้นต้นด้วย `.` เช่น `~/.vimrc` ทำให้ซ่อนอยู่ใน `ls` โดย default)

> Dotfiles เป็น shell convention อีกอย่าง จุดที่นำหน้าเพื่อ "ซ่อน" ไว้เมื่อ list

Shell เป็นหนึ่งในโปรแกรมที่ configure ด้วยไฟล์เหล่านี้ เมื่อ startup shell จะอ่านไฟล์หลายอันเพื่อโหลด configuration รายละเอียดอ่านเพิ่มได้ [ที่นี่](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html)

สำหรับ `bash` แก้ไข `.bashrc` หรือ `.bash_profile` ได้บนระบบส่วนใหญ่ ตัวอย่าง tools ที่ configure ผ่าน dotfiles:

- `bash` - `~/.bashrc`, `~/.bash_profile`
- `git` - `~/.gitconfig`
- `vim` - `~/.vimrc` และโฟลเดอร์ `~/.vim`
- `ssh` - `~/.ssh/config`
- `tmux` - `~/.tmux.conf`

การเปลี่ยน configuration ที่พบบ่อยคือการเพิ่ม path ใหม่ให้ shell หาโปรแกรม:

```shell
export PATH="$PATH:path/to/append"
```

คำสั่งนี้บอก shell ให้ set `$PATH` เป็นค่าปัจจุบันบวกกับ path ใหม่ และ child processes ทั้งหมดจะ inherit ค่านี้ ทำให้หาโปรแกรมใน `path/to/append` ได้

การ customize shell มักหมายถึงการติดตั้ง command-line tools ใหม่ Package managers ช่วยจัดการ download, ติดตั้ง และอัปเดต macOS ใช้ [Homebrew](https://brew.sh/), Ubuntu/Debian ใช้ `apt`, Fedora ใช้ `dnf`, Arch ใช้ `pacman` เราจะพูดถึง package managers ในบท shipping code

ตัวอย่างการติดตั้ง tools ที่มีประโยชน์ด้วย Homebrew:

```shell
# ripgrep: grep ที่เร็วกว่าพร้อม defaults ที่ดีกว่า
brew install ripgrep

# fd: find ที่เร็วกว่าและใช้งานง่ายกว่า
brew install fd
```

เมื่อติดตั้งแล้ว ใช้ `rg` แทน `grep` และ `fd` แทน `find` ได้เลย

> **คำเตือนเรื่อง `curl | bash`**: คำแนะนำการติดตั้งหลายอันมีรูปแบบ `curl -fsSL https://example.com/install.sh | bash` ซึ่ง download script แล้วรันทันที สะดวกแต่เสี่ยง เพราะรัน code ที่ยังไม่ได้ตรวจสอบ ทางที่ปลอดภัยกว่าคือ:
> ```shell
> curl -fsSL https://example.com/install.sh -o install.sh
> less install.sh  # ตรวจสอบ script ก่อน
> bash install.sh
> ```
> บาง installer ใช้ `/bin/bash -c "$(curl -fsSL https://url)"` ซึ่งอย่างน้อยก็ให้ bash interpret แทน shell ปัจจุบัน

เมื่อรันคำสั่งที่ยังไม่ได้ติดตั้ง shell จะแสดง `command not found` เว็บไซต์ [command-not-found.com](https://command-not-found.com) มีวิธีติดตั้งสำหรับ package managers และ distributions ต่างๆ

[`tldr`](https://tldr.sh/) เป็นอีก tool ที่มีประโยชน์ ให้ man pages แบบย่อเน้นตัวอย่าง แทนที่จะอ่าน documentation ยาวๆ:

```console
$ tldr fd
  An alternative to find.
  Aims to be faster and easier to use than find.

  Recursively find files matching a pattern in the current directory:
      fd "pattern"

  Find files that begin with "foo":
      fd "^foo"

  Find files with a specific extension:
      fd --extension txt
```

บางครั้งไม่ต้องการโปรแกรมใหม่ทั้งหมด แค่ shortcut สำหรับคำสั่งที่มีอยู่พร้อม flags เฉพาะ นั่นคือที่มาของ aliases

เราสร้าง aliases ด้วย `alias` shell built-in shell alias คือรูปย่อของคำสั่งอื่นที่ shell จะแทนที่อัตโนมัติก่อน evaluate:

```bash
alias alias_name="command_to_alias arg1 arg2"
```

> ไม่มีช่องว่างรอบเครื่องหมาย `=` เพราะ [`alias`](https://www.man7.org/linux/man-pages/man1/alias.1p.html) รับ argument เดียว

ตัวอย่าง aliases ที่มีประโยชน์:

```bash
# shorthand สำหรับ flags ที่ใช้บ่อย
alias ll="ls -lh"

# ลดการพิมพ์สำหรับคำสั่งที่ใช้บ่อย
alias gs="git status"
alias gc="git commit"

# ป้องกันการพิมพ์ผิด
alias sl=ls

# เขียนทับคำสั่งด้วย defaults ที่ดีกว่า
alias mv="mv -i"           # -i ถามก่อน overwrite
alias mkdir="mkdir -p"     # -p สร้าง parent dirs โดยอัตโนมัติ
alias df="df -h"           # -h แสดงในรูปแบบที่อ่านง่าย

# Alias ต่อกันได้
alias la="ls -A"
alias lla="la -l"

# ข้าม alias ชั่วคราวด้วย \
\ls
# หรือลบ alias ด้วย unalias
unalias la

# ดู alias definition ด้วย
alias ll
# แสดง ll='ls -lh'
```

Aliases ไม่สามารถรับ arguments ตรงกลางคำสั่งได้ สำหรับ logic ที่ซับซ้อนกว่านั้น ควรใช้ shell functions แทน

Shell ส่วนใหญ่รองรับ `Ctrl-R` สำหรับค้นหา history แบบย้อนกลับ เมื่อ configure shell integration ของ `fzf` แล้ว `Ctrl-R` จะกลายเป็น interactive fuzzy search ผ่าน history ทั้งหมด ซึ่ง powerful กว่า default มาก

Dotfiles ควร organize อย่างไร? ควรอยู่ในโฟลเดอร์ของตัวเอง ภายใต้ version control และ **symlinked** เข้าที่ด้วย script ประโยชน์ที่ได้:

- **ติดตั้งง่าย**: บน machine ใหม่ใช้เวลาแค่นาทีเดียว
- **Portability**: ทำงานเหมือนกันทุกที่
- **Synchronization**: update ที่ไหนก็ sync ทุกที่
- **Change tracking**: มี version history สำหรับ project ที่ยืนยาว

เรียนรู้ settings ของ tools ได้จากเอกสารออนไลน์หรือ [man pages](https://en.wikipedia.org/wiki/Man_page) หรือดูจากบทความ blog หรือดู dotfiles ของคนอื่นบน [GitHub](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories) ตัวที่ได้รับความนิยมสูงสุดดูได้ [ที่นี่](https://github.com/mathiasbynens/dotfiles) (แต่ไม่แนะนำให้ copy ตรงๆ โดยไม่ทำความเข้าใจก่อน) และ [dotfiles.github.io](https://dotfiles.github.io/) เป็นแหล่งข้อมูลที่ดีอีกแห่ง

อาจารย์ผู้สอนทุกคนเปิดเผย dotfiles บน GitHub: [Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/jjgo/dotfiles)

**Frameworks และ plugins** ปรับปรุง shell ได้อีกมาก frameworks ทั่วไปได้แก่ [prezto](https://github.com/sorin-ionescu/prezto) หรือ [oh-my-zsh](https://ohmyz.sh/) และ plugins ขนาดเล็กสำหรับ features เฉพาะ:

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - ระบายสีคำสั่ง valid/invalid ขณะพิมพ์
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - แนะนำคำสั่งจาก history ขณะพิมพ์
- [zsh-completions](https://github.com/zsh-users/zsh-completions) - completion definitions เพิ่มเติม
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) - ค้นหา history แบบ fish
- [powerlevel10k](https://github.com/romkatv/powerlevel10k) - prompt theme ที่เร็วและ customize ได้

Shells อย่าง [fish](https://fishshell.com/) มี features เหล่านี้ built-in อยู่แล้ว

> ไม่จำเป็นต้องใช้ framework ขนาดใหญ่อย่าง oh-my-zsh การติดตั้ง plugins แยกมักเร็วกว่าและให้ control มากกว่า Frameworks ขนาดใหญ่อาจทำให้ shell startup ช้าลงมาก ควรติดตั้งเฉพาะที่ใช้จริง


# AI ใน Shell

มีหลายวิธีในการผสาน AI เข้ากับ shell workflow:

**Command generation**: Tools อย่าง [`simonw/llm`](https://github.com/simonw/llm) ช่วย generate shell commands จากคำอธิบายภาษาธรรมชาติ:

```console
$ llm cmd "find all python files modified in the last week"
find . -name "*.py" -mtime -7
```

**Pipeline integration**: LLMs ผสานเข้ากับ shell pipelines ได้ เหมาะมากเมื่อต้องการ extract ข้อมูลจาก formats ที่ไม่สม่ำเสมอซึ่ง regex จะยุ่งยาก:

```console
$ cat users.txt
Contact: john.doe@example.com
User 'alice_smith' logged in at 3pm
Posted by: @bob_jones on Twitter
Author: Jane Doe (jdoe)
Message from mike_wilson yesterday
Submitted by user: sarah.connor
$ INSTRUCTIONS="Extract just the username from each line, one per line, nothing else"
$ llm "$INSTRUCTIONS" < users.txt
john.doe
alice_smith
bob_jones
jdoe
mike_wilson
sarah.connor
```

ใช้ `"$INSTRUCTIONS"` (ใส่ quotes) เพราะตัวแปรมีช่องว่าง และ `< users.txt` เพื่อ redirect เนื้อหาไฟล์ไปยัง stdin

**AI shells**: Tools อย่าง [Claude Code](https://docs.anthropic.com/en/docs/claude-code) ทำหน้าที่เป็น meta-shell ที่รับคำสั่งภาษาอังกฤษและแปลเป็น shell operations, การแก้ไขไฟล์ และ tasks ที่ซับซ้อนกว่า

# Terminal Emulators

นอกจาก customize shell แล้ว ควรใช้เวลาเลือก **terminal emulator** ที่เหมาะกับตัวเองด้วย terminal emulator คือโปรแกรม GUI ที่ให้ text-based interface สำหรับรัน shell

เนื่องจากคุณจะใช้เวลาหลายร้อยถึงหลายพันชั่วโมงใน terminal จึงคุ้มค่าที่จะปรับ settings สิ่งที่ควรพิจารณา:

- การเลือกฟอนต์
- Color Scheme
- Keyboard shortcuts
- รองรับ Tab/Pane
- การตั้งค่า Scrollback
- Performance (terminals ใหม่อย่าง [Alacritty](https://github.com/alacritty/alacritty) หรือ [Ghostty](https://ghostty.org/) มี GPU acceleration)



# แบบฝึกหัด

## Arguments และ Globs

1. คุณอาจเห็นคำสั่งแบบ `cmd --flag -- --notaflag` โดย `--` เป็น argument พิเศษที่บอกให้โปรแกรมหยุด parse flags ทุกอย่างหลัง `--` จะถือเป็น positional argument ทำไมสิ่งนี้ถึงมีประโยชน์? ลองรัน `touch -- -myfile` แล้วลบมันโดยไม่ใช้ `--`

1. อ่าน [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) แล้วเขียนคำสั่ง `ls` ที่แสดงผลแบบนี้:
    - แสดงไฟล์ทั้งหมด รวมถึงไฟล์ที่ซ่อน
    - ขนาดแสดงในรูปแบบที่อ่านง่าย (เช่น 454M แทน 454279954)
    - เรียงตามความใหม่ล่าสุด
    - Output มีสี

    ตัวอย่าง output:

    ```
    -rw-r--r--   1 user group 1.1M Jan 14 09:53 baz
    drwxr-xr-x   5 user group  160 Jan 14 09:53 .
    -rw-r--r--   1 user group  514 Jan 14 06:42 bar
    -rw-r--r--   1 user group 106M Jan 13 12:12 foo
    drwx------+ 47 user group 1.5K Jan 12 18:08 ..
    ```

{% comment %}
ls -lath --color=auto
{% endcomment %}

1. Process substitution `<(command)` ให้ใช้ output ของคำสั่งราวกับว่าเป็นไฟล์ ใช้ `diff` กับ process substitution เพื่อเปรียบเทียบ output ของ `printenv` และ `export` ทำไมมันถึงต่างกัน? (Hint: ลอง `diff <(printenv | sort) <(export | sort)`)

## Environment Variables

1. เขียน bash functions `marco` และ `polo` ดังนี้: เมื่อรัน `marco` ให้บันทึก current working directory ไว้ แล้วเมื่อรัน `polo` ไม่ว่าจะอยู่ที่ไหน ให้ `cd` กลับไปยัง directory นั้น เพื่อ debug ง่ายขึ้น เขียน code ในไฟล์ `marco.sh` และโหลดด้วย `source marco.sh`

{% comment %}
marco() {
export MARCO=$(pwd)
}

polo() {
cd "$MARCO"
}
{% endcomment %}

## Return Codes

1. สมมติคุณมีคำสั่งที่ล้มเหลวนานๆ ครั้ง เพื่อ debug ต้องการ capture output แต่กว่าจะเจอการ fail อาจใช้เวลานาน เขียน bash script ที่รัน script ต่อไปนี้จนกว่าจะล้มเหลว และ capture stdout และ stderr ไปยังไฟล์ แล้วแสดงทุกอย่างในตอนท้าย โบนัสถ้า report ได้ว่าใช้กี่ครั้งก่อนจะล้มเหลว:

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
until [["$?" -ne 0]];
do
count=$((count+1))
./random.sh &> out.txt
done

echo "found error after $count runs"
cat out.txt
{% endcomment %}

## Signals และ Job Control

1. เริ่ม job `sleep 10000` ใน terminal, background ด้วย `Ctrl-Z` แล้ว continue ด้วย `bg` จากนั้นใช้ [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) หา pid และ [`pkill`](https://man7.org/linux/man-pages/man1/pgrep.1.html) เพื่อ kill โดยไม่ต้องพิมพ์ pid เลย (Hint: ใช้ flags `-af`)

1. สมมติคุณไม่ต้องการเริ่ม process จนกว่า process อื่นจะเสร็จ ทำได้อย่างไร? ใน exercise นี้ limiting process คือ `sleep 60 &` วิธีหนึ่งคือใช้ [`wait`](https://www.man7.org/linux/man-pages/man1/wait.1p.html) ลองรัน sleep แล้วให้ `ls` รอจนกว่า background process จะเสร็จ

    อย่างไรก็ตาม วิธีนี้จะล้มเหลวถ้าเริ่มใน bash session ที่ต่างกัน เพราะ `wait` ทำงานได้เฉพาะกับ child processes `kill -0` ไม่ส่ง signal แต่จะให้ exit status ที่ไม่ใช่ศูนย์ถ้า process ไม่มีอยู่ เขียน bash function `pidwait` ที่รับ pid และรอจนกว่า process นั้นจะเสร็จ ใช้ `sleep` เพื่อหลีกเลี่ยงการใช้ CPU โดยไม่จำเป็น

## Files and Permissions

1. (ขั้นสูง) เขียนคำสั่งหรือ script เพื่อค้นหาไฟล์ที่ถูกแก้ไขล่าสุดใน directory แบบ recursive และ list ไฟล์ทั้งหมดเรียงตามความใหม่ล่าสุดได้ไหม?

## Terminal Multiplexers

1. ทำตาม `tmux` [tutorial](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) แล้วเรียนรู้การ customize เบื้องต้นตาม [ขั้นตอนเหล่านี้](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/)

## Aliases และ Dotfiles

1. สร้าง alias `dc` ที่ resolve ไปยัง `cd` สำหรับเมื่อพิมพ์ผิด

1. รัน `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10` เพื่อดู 10 คำสั่งที่ใช้บ่อยที่สุด แล้วพิจารณาเขียน aliases ที่สั้นกว่า หมายเหตุ: สำหรับ ZSH ใช้ `history 1` แทน `history`

1. สร้างโฟลเดอร์สำหรับ dotfiles และ setup version control

1. เพิ่ม configuration สำหรับโปรแกรมอย่างน้อยหนึ่งตัว เช่น shell พร้อม customization บางอย่าง (เริ่มต้นอาจง่ายๆ แค่ customize shell prompt ด้วย `$PS1`)

1. Setup วิธีติดตั้ง dotfiles อย่างรวดเร็วบน machine ใหม่ อาจเป็นแค่ shell script ที่เรียก `ln -s` สำหรับแต่ละไฟล์ หรือใช้ [specialized utility](https://dotfiles.github.io/utilities/)

1. ทดสอบ installation script บน virtual machine ที่ใหม่สะอาด

1. ย้าย tool configurations ปัจจุบันทั้งหมดไปยัง dotfiles repository

1. เผยแพร่ dotfiles บน GitHub

## Remote Machines (SSH)

ติดตั้ง Linux virtual machine (หรือใช้อันที่มีอยู่แล้ว) สำหรับ exercises เหล่านี้ ถ้าไม่คุ้นเคยกับ virtual machines ดู [tutorial นี้](https://hibbard.eu/install-ubuntu-virtual-box/)

1. ไปที่ `~/.ssh/` และตรวจสอบว่ามี SSH key pair ไหม ถ้าไม่มี generate ด้วย `ssh-keygen -a 100 -t ed25519` แนะนำให้ใช้ password และ `ssh-agent` ดูข้อมูลเพิ่มเติม [ที่นี่](https://www.ssh.com/ssh/agent)

1. แก้ไข `.ssh/config` ให้มี entry ดังนี้:

    ```bash
    Host vm
        User username_goes_here
        HostName ip_goes_here
        IdentityFile ~/.ssh/id_ed25519
        LocalForward 9999 localhost:8888
    ```

1. ใช้ `ssh-copy-id vm` เพื่อ copy ssh key ไปยัง server

1. เริ่ม webserver ใน VM ด้วย `python -m http.server 8888` แล้วเข้าถึงผ่าน `http://localhost:9999` บน machine ของคุณ

1. แก้ไข SSH server config ด้วย `sudo vim /etc/ssh/sshd_config` — ปิด password authentication โดยแก้ `PasswordAuthentication` และปิด root login โดยแก้ `PermitRootLogin` จากนั้น restart ด้วย `sudo service sshd restart` แล้วลอง ssh เข้าอีกครั้ง

1. (Challenge) ติดตั้ง [`mosh`](https://mosh.org/) ใน VM แล้วสร้าง connection จากนั้น disconnect network adapter mosh สามารถ recover ได้ไหม?

1. (Challenge) ศึกษา flags `-N` และ `-f` ใน `ssh` และหาคำสั่งสำหรับทำ background port forwarding
