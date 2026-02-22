---
layout: lecture
title: "ಕಮಾಂಡ್-ಲೈನ್ ಪರಿಸರ"
description: >
  input/output streams, environment variables, ಮತ್ತು SSH ಬಳಸಿ remote machines ಜೊತೆಗೆ ಹೇಗೆ ಕೆಲಸ ಮಾಡುವುದು ಎಂಬುದನ್ನು ಕಲಿಯಿರಿ.
thumbnail: /static/assets/thumbnails/2026/lec2.png
date: 2026-01-13
ready: true
video:
  aspect: 56.25
  id: ccBGsPedE9Q
---

ಹಿಂದಿನ ಉಪನ್ಯಾಸದಲ್ಲಿ ನೋಡಿದಂತೆ, ಬಹುತೇಕ shells ಗಳು ಇತರೆ programs ಅನ್ನು ಶುರು ಮಾಡುವ launcher ಮಾತ್ರವಲ್ಲ.
ಪ್ರಯೋಗದಲ್ಲಿ ಅವು ಸಾಮಾನ್ಯ patterns ಮತ್ತು abstractions ಗಳಿಂದ ತುಂಬಿದ ಪೂರ್ಣ programming language ಒದಗಿಸುತ್ತವೆ.
ಆದರೆ, ಬಹುತೇಕ programming languages ಗಳಿಗಿಂತ ಭಿನ್ನವಾಗಿ, shell scripting ನಲ್ಲಿ ಎಲ್ಲವೂ programs ಅನ್ನು ಓಡಿಸುವುದು ಮತ್ತು ಅವು ಪರಸ್ಪರ ಸರಳವಾಗಿ ಹಾಗೂ ಪರಿಣಾಮಕಾರಿಯಾಗಿ ಸಂವಹನ ಮಾಡುವುದರ ಸುತ್ತ ವಿನ್ಯಾಸಗೊಂಡಿದೆ.

ವಿಶೇಷವಾಗಿ, shell scripting ಬಹಳ ಮಟ್ಟಿಗೆ _conventions_ ಗಳ ಮೇಲೆ ಅವಲಂಬಿತವಾಗಿದೆ.
ಒಂದು command line interface (CLI) program ವಿಶಾಲವಾದ shell ಪರಿಸರದಲ್ಲಿ ಚೆನ್ನಾಗಿ ಕೆಲಸ ಮಾಡಲು, ಅದು ಕೆಲವು ಸಾಮಾನ್ಯ patterns ಅನ್ನು ಅನುಸರಿಸಬೇಕು.
ಈಗ command line programs ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತವೆ ಹಾಗೂ ಅವನ್ನು ಹೇಗೆ ಬಳಸಬೇಕು ಮತ್ತು configure ಮಾಡಬೇಕು ಎಂಬುದಕ್ಕೆ ಅಗತ್ಯವಾದ ಪ್ರಮುಖ ಕಲ್ಪನೆಗಳನ್ನು ನೋಡೋಣ.

# ಕಮಾಂಡ್ ಲೈನ್ ಇಂಟರ್ಫೇಸ್

ಹೆಚ್ಚಿನ programming languages ಗಳಲ್ಲಿ function ಬರೆಯುವ ವಿಧಾನ ಹೀಗಿರುತ್ತದೆ:

```
def add(x: int, y: int) -> int:
    return x + y
```

ಇಲ್ಲಿ program ನ inputs ಮತ್ತು outputs ಅನ್ನು ಸ್ಪಷ್ಟವಾಗಿ ನೋಡಬಹುದು.
ಇದಕ್ಕೆ ವಿರುದ್ಧವಾಗಿ, shell scripts ಮೊದಲ ನೋಡಿಗೆ ವಿಭಿನ್ನವಾಗಿ ಕಾಣಬಹುದು.

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

ಇಂತಹ script ಗಳಲ್ಲಿ ಏನಾಗುತ್ತಿದೆ ಎಂಬುದನ್ನು ಸರಿಯಾಗಿ ಅರ್ಥಮಾಡಿಕೊಳ್ಳಲು, shell programs ಪರಸ್ಪರ ಅಥವಾ shell ಪರಿಸರದೊಂದಿಗೆ ಸಂವಹನ ಮಾಡುವಾಗ ಮತ್ತೆ ಮತ್ತೆ ಕಾಣಿಸುವ ಕೆಲವು ಕಲ್ಪನೆಗಳನ್ನು ಮೊದಲು ತಿಳಿದುಕೊಳ್ಳಬೇಕು:

- Arguments
- Streams
- Environment variables
- Return codes
- Signals

## Arguments

shell programs execute ಆಗುವಾಗ arguments ಗಳ ಪಟ್ಟಿಯನ್ನು ಸ್ವೀಕರಿಸುತ್ತವೆ.
Shell ನಲ್ಲಿ arguments ಸಾಮಾನ್ಯ strings ಮಾತ್ರ - ಅವನ್ನು ಹೇಗೆ ಅರ್ಥಮಾಡಿಕೊಳ್ಳಬೇಕು ಎಂಬುದು program ಮೇಲೇ ಅವಲಂಬಿತವಾಗಿರುತ್ತದೆ.
ಉದಾಹರಣೆಗೆ `ls -l folder/` ಅನ್ನು ಓಡಿಸಿದಾಗ, ನಾವು `/bin/ls` program ಅನ್ನು `['-l', 'folder/']` arguments ಜೊತೆಗೆ execute ಮಾಡುತ್ತೇವೆ.

ಒಂದು shell script ಒಳಗಿಂದ ಇವುಗಳನ್ನು ವಿಶೇಷ shell syntax ಮೂಲಕ ಪ್ರವೇಶಿಸುತ್ತೇವೆ.
ಮೊದಲ argument ಗೆ `$1`, ಎರಡನೇ argument ಗೆ `$2`, ಹೀಗೆ `$9` ವರೆಗೆ.
ಎಲ್ಲ arguments ಅನ್ನು list ಆಗಿ ಪಡೆಯಲು `$@`, ಮತ್ತು arguments ಸಂಖ್ಯೆ ಪಡೆಯಲು `$#` ಬಳಸುತ್ತೇವೆ.
ಹಾಗೆಯೇ program ಹೆಸರು `$0` ಮೂಲಕ ಲಭ್ಯ.

ಹೆಚ್ಚಿನ programs ನಲ್ಲಿ arguments ಗಳು _flags_ ಮತ್ತು ಸಾಮಾನ್ಯ strings ಮಿಶ್ರಣವಾಗಿರುತ್ತವೆ.
Flags ಗಳು dash (`-`) ಅಥವಾ double-dash (`--`) ಇಂದ ಆರಂಭವಾಗುವುದರಿಂದ ಗುರುತಿಸಬಹುದು.
Flags ಸಾಮಾನ್ಯವಾಗಿ optional ಆಗಿದ್ದು program ನ behavior ಅನ್ನು ಬದಲಿಸಲು ಉಪಯೋಗವಾಗುತ್ತವೆ.
ಉದಾಹರಣೆಗೆ `ls -l` ನಲ್ಲಿ `-l`, `ls` output format ಅನ್ನು ಬದಲಿಸುತ್ತದೆ.

`--all` ಮೊದಲಾದ long flags ಮತ್ತು `-a` ಮೊದಲಾದ single-letter flags ಎರಡನ್ನೂ ನೋಡುತ್ತೀರಿ.
ಅದೇ option ಎರಡೂ ರೂಪಗಳಲ್ಲಿ ಬರಬಹುದು - `ls -a` ಮತ್ತು `ls --all` ಸಮಾನ.
Single dash flags ಅನ್ನು ಸಾಮಾನ್ಯವಾಗಿ ಗುಂಪುಗೊಳಿಸುತ್ತಾರೆ, ಹಾಗಾಗಿ `ls -l -a` ಮತ್ತು `ls -la` ಕೂಡ ಸಮಾನ.
Flags ಕ್ರಮ ಬಹುಸಾರಿ ಮುಖ್ಯವಾಗುವುದಿಲ್ಲ - `ls -la` ಹಾಗೂ `ls -al` ಒಂದೇ ಫಲಿತಾಂಶ ಕೊಡುತ್ತವೆ.
ಕೆಲವು flags ಬಹಳ ಸಾಮಾನ್ಯ - ಉದಾ: `--help`, `--verbose`, `--version`.

> Flags ಗಳು shell conventions ಗೆ ಉತ್ತಮ ಮೊದಲ ಉದಾಹರಣೆ. Shell ಭಾಷೆ ನಿಮ್ಮ program ಕಡ್ಡಾಯವಾಗಿ `-` ಅಥವಾ `--` ನ್ನೇ ಈ ರೀತಿಯಲ್ಲಿ ಬಳಸಬೇಕು ಎಂದು ಹೇಳುವುದಿಲ್ಲ.
`myprogram +myoption myfile` ಎಂಬ syntax ಕೂಡ technically ಸಾಧ್ಯ. ಆದರೆ ಜನರ ನಿರೀಕ್ಷೆ dashes ಆಗಿರುವುದರಿಂದ ಅದು ಗೊಂದಲ ಉಂಟುಮಾಡುತ್ತದೆ.
> ಪ್ರಾಯೋಗಿಕವಾಗಿ, ಹೆಚ್ಚಿನ programming languages CLI flag parsing libraries ಒದಗಿಸುತ್ತವೆ (ಉದಾ. Python ನಲ್ಲಿ `argparse`).

CLI programs ನಲ್ಲಿ ಇನ್ನೊಂದು ಸಾಮಾನ್ಯ convention ಎಂದರೆ ಒಂದೇ ರೀತಿಯ ಅನೇಕ arguments ಸ್ವೀಕರಿಸುವುದು. ಈ ರೀತಿಯಲ್ಲಿ arguments ಕೊಟ್ಟಾಗ command ಪ್ರತಿಯೊಂದರ ಮೇಲೂ ಅದೇ ಕಾರ್ಯಾಚರಣೆ ನಡೆಸುತ್ತದೆ.

```shell
mkdir src
mkdir docs
# is equivalent to
mkdir src docs
```

ಮೊದಲಿಗೆ ಈ syntax sugar ಅನಾವಶ್ಯಕವಾಗಿ ಕಾಣಬಹುದು, ಆದರೆ _globbing_ ಜೊತೆಗೆ ಬಳಸಿದಾಗ ಇದು ಬಹಳ ಶಕ್ತಿಶಾಲಿ.
Globbing ಅಥವಾ globs ಎಂದರೆ shell program ಅನ್ನು ಕರೆಯುವ ಮೊದಲು ವಿಸ್ತರಿಸುವ ವಿಶೇಷ patterns.

ಈಗಿರುವ folder ನಲ್ಲಿ non-recursive ಆಗಿ ಎಲ್ಲಾ `.py` files ಅಳಿಸಬೇಕೆಂದು ಕಲ್ಪಿಸೋಣ. ಹಿಂದಿನ ಉಪನ್ಯಾಸದ ಆಧಾರದ ಮೇಲೆ ಹೀಗೆ ಮಾಡಬಹುದು:

```shell
for file in $(ls | grep -P '\.py$'); do
    rm "$file"
done
```

ಆದರೆ ಇದನ್ನು `rm *.py` ಅಷ್ಟಕ್ಕೆ ಸರಳಗೊಳಿಸಬಹುದು.

ನಾವು terminal ನಲ್ಲಿ `rm *.py` type ಮಾಡಿದಾಗ, shell `/bin/rm` ಅನ್ನು `['*.py']` arguments ಜೊತೆ ಕರೆಯುವುದಿಲ್ಲ.
ಅದರ ಬದಲು, shell ಪ್ರಸ್ತುತ folder ನಲ್ಲಿ `*.py` pattern ಗೆ ಹೊಂದುವ files ಹುಡುಕುತ್ತದೆ; ಇಲ್ಲಿ `*` ಎಂದರೆ zero ಅಥವಾ ಹೆಚ್ಚು ಯಾವುದೇ characters.
ಅದೇ folder ನಲ್ಲಿ `main.py` ಮತ್ತು `utils.py` ಇದ್ದರೆ `rm` program ಗೆ `['main.py', 'utils.py']` arguments ಸಿಗುತ್ತವೆ.

ಸಾಮಾನ್ಯ globs: wildcard `*` (ಯಾವುದೇ zero ಅಥವಾ ಹೆಚ್ಚು), `?` (ಯಾವುದೇ ಒಂದು), ಮತ್ತು curly braces.
Curly braces `{}` comma-separated patterns ಅನ್ನು ಅನೇಕ arguments ಆಗಿ ವಿಸ್ತರಿಸುತ್ತವೆ.

ಪ್ರಯೋಗದಲ್ಲಿ globs ಅನ್ನು examples ಮೂಲಕ ಅರ್ಥಮಾಡಿಕೊಳ್ಳುವುದು ಉತ್ತಮ.

```shell
touch folder/{a,b,c}.py
# Will expand to
touch folder/a.py folder/b.py folder/c.py

convert image.{png,jpg}
# Will expand to
convert image.png image.jpg

cp /path/to/project/{setup,build,deploy}.sh /newpath
# Will expand to
cp /path/to/project/setup.sh /path/to/project/build.sh /path/to/project/deploy.sh /newpath

# Globbing techniques can also be combined
mv *{.py,.sh} folder
# Will move all *.py and *.sh files
```

> ಕೆಲವು shells (ಉದಾ. zsh) ಇನ್ನಷ್ಟು advanced globbing ರೂಪಗಳನ್ನು support ಮಾಡುತ್ತವೆ - ಉದಾಹರಣೆಗೆ `**` recursive paths ಗೆ ವಿಸ್ತರಿಸುತ್ತದೆ. ಹಾಗಾಗಿ `rm **/*.py` ಎಲ್ಲಾ `.py` files ಅನ್ನು recursive ಆಗಿ ಅಳಿಸುತ್ತದೆ.

## Streams

ನಾವು ಈ ರೀತಿಯ program pipeline execute ಮಾಡಿದಾಗ:

```shell
cat myfile | grep -P '\d+' | uniq -c
```

`grep` program `cat` ಮತ್ತು `uniq` ಎರಡರೊಂದಿಗೆ ಸಂವಹನ ಮಾಡುತ್ತಿರುವುದನ್ನು ನೋಡುತ್ತೇವೆ.

ಇಲ್ಲಿ ಪ್ರಮುಖ ಗಮನಿಸಬೇಕಾದ ಅಂಶ ಎಂದರೆ ಮೂರೂ programs ಒಂದೇ ಸಮಯದಲ್ಲಿ ನಡೆಯುತ್ತವೆ.
ಅಂದರೆ shell ಮೊದಲು `cat`, ನಂತರ `grep`, ನಂತರ `uniq` ಅನ್ನು ಕ್ರಮವಾಗಿ ಮುಗಿಸಿ ಕರೆಯುವುದಿಲ್ಲ.
ಬದಲಾಗಿ ಮೂರನ್ನೂ spawn ಮಾಡಿ, `cat` ನ output ಅನ್ನು `grep` ನ input ಗೆ, `grep` ನ output ಅನ್ನು `uniq` ನ input ಗೆ ಜೋಡಿಸುತ್ತದೆ.
`|` pipe operator ಬಳಸಿದಾಗ data streams ಒಂದರಿಂದ ಮತ್ತೊಂದಕ್ಕೆ ಹರಿಯುತ್ತವೆ.

ಈ concurrency ಅನ್ನು ತೋರಿಸಲು, pipeline ನಲ್ಲಿರುವ commands ಎಲ್ಲವೂ ತಕ್ಷಣ ಶುರುವಾಗುತ್ತವೆ:

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

ಇಲ್ಲಿ `cat` ಹೊರತುಪಡಿಸಿ ಉಳಿದ processes ತಕ್ಷಣ ಆರಂಭವಾಗಿರುವುದನ್ನು ನೋಡಬಹುದು.
Shell ಎಲ್ಲಾ processes ಅನ್ನು ಮೊದಲು spawn ಮಾಡಿ streams ಅನ್ನು connect ಮಾಡುತ್ತದೆ. `sleep` ಮುಗಿದ ನಂತರವೇ `cat` ಶುರುವಾಗುತ್ತದೆ; ನಂತರ ಅದರ output `grep` ಗೆ ಹೋಗುತ್ತದೆ, ಹೀಗೆ ಮುಂದುವರಿಯುತ್ತದೆ.

ಪ್ರತಿ program ಗೆ `stdin` (standard input) ಎಂಬ input stream ಇರುತ್ತದೆ. Pipe ಮಾಡಿದಾಗ ಇದು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಜೋಡಣೆಯಾಗುತ್ತದೆ.
Script ಒಳಗೆ ಅನೇಕ programs `-` ಅನ್ನು filename ಆಗಿ ತೆಗೆದುಕೊಂಡು "stdin ನಿಂದ ಓದಿ" ಎಂದು ಅರ್ಥಮಾಡಿಕೊಳ್ಳುತ್ತವೆ:

```shell
# These are equivalent when data comes from a pipe
echo "hello" | grep "hello"
echo "hello" | grep "hello" -
```

ಹಾಗೆಯೇ ಪ್ರತಿಯೊಂದು program ಗೆ ಎರಡು output streams ಇವೆ: `stdout` ಮತ್ತು `stderr`.
`stdout` ಸಾಮಾನ್ಯ output - pipeline ನಲ್ಲಿ ಮುಂದಿನ command ಗೆ ಇದೇ ಹೋಗುತ್ತದೆ.
`stderr` warnings ಹಾಗೂ errors ಗಾಗಿ; ಇದರಿಂದ ಆ output ಮುಂದಿನ command ಪಾರ್ಸ್ ಮಾಡುವ data ಯಲ್ಲಿ ಮಿಶ್ರಣವಾಗುವುದಿಲ್ಲ.

```console
$ ls /nonexistent
ls: cannot access '/nonexistent': No such file or directory
$ ls /nonexistent | grep "pattern"
ls: cannot access '/nonexistent': No such file or directory
# The error message still appears because stderr is not piped
$ ls /nonexistent 2>/dev/null
# No output - stderr was redirected to /dev/null
```

ಈ streams redirect ಮಾಡಲು shell syntax ಕೊಡುತ್ತದೆ. ಕೆಲವು ಉದಾಹರಣೆಗಳು:

```shell
# Redirect stdout to a file (overwrite)
echo "hello" > output.txt

# Redirect stdout to a file (append)
echo "world" >> output.txt

# Redirect stderr to a file
ls foobar 2> errors.txt

# Redirect both stdout and stderr to the same file
ls foobar &> all_output.txt

# Redirect stdin from a file
grep "pattern" < input.txt

# Discard output by redirecting to /dev/null
cmd > /dev/null 2>&1
```

Unix philosophy ಯನ್ನು ಚೆನ್ನಾಗಿ ತೋರಿಸುವ ಮತ್ತೊಂದು tool ಎಂದರೆ [`fzf`](https://github.com/junegunn/fzf) - ಒಂದು fuzzy finder.
ಇದು stdin ನಿಂದ lines ಓದಿ, filter/select ಮಾಡಲು interactive interface ಒದಗಿಸುತ್ತದೆ:

```console
$ ls | fzf
$ cat ~/.bash_history | fzf
```

`fzf` ಅನ್ನು shell operations ಜೊತೆ ಹಲವಾರು ರೀತಿಯಲ್ಲಿ integrate ಮಾಡಬಹುದು. Shell customization ವಿಷಯದಲ್ಲಿ ಇದನ್ನು ಮತ್ತಷ್ಟು ನೋಡೋಣ.

## Environment variables

bash ನಲ್ಲಿ variables assign ಮಾಡಲು `foo=bar` syntax ಬಳಸುತ್ತೇವೆ; value ಪಡೆಯಲು `$foo` ಬಳಕೆ.
`foo = bar` invalid syntax - ಏಕೆಂದರೆ shell ಅದನ್ನು `foo` program ಅನ್ನು `['=', 'bar']` arguments ಜೊತೆ ಕರೆಯುವಂತೆ ಪಾರ್ಸ್ ಮಾಡುತ್ತದೆ.
Shell scripting ನಲ್ಲಿ space character argument splitting ಗಾಗಿ ಬಳಸಲಾಗುತ್ತದೆ.
ಈ behavior ಆರಂಭದಲ್ಲಿ ಗೊಂದಲಕಾರಿ ಆಗಬಹುದು - ಗಮನದಲ್ಲಿಡಿ.

Shell variables ಗೆ types ಇರುವುದಿಲ್ಲ - ಎಲ್ಲವೂ strings.
Shell ನಲ್ಲಿ single quotes ಮತ್ತು double quotes ಪರಸ್ಪರ ಬದಲಾಯಿಸಬಹುದಾದವುಗಳಲ್ಲ ಎಂಬುದನ್ನು ಗಮನಿಸಿ.
`'` ಒಳಗಿನ strings literal ಆಗಿರುತ್ತವೆ - variable expansion, command substitution, escape processing ಇಲ್ಲ.
`"` ಒಳಗಿನ strings ನಲ್ಲಿ ಇವು ನಡೆಯುತ್ತವೆ.

```shell
foo=bar
echo "$foo"
# prints bar
echo '$foo'
# prints $foo
```

command output ಅನ್ನು variable ಗೆ ಹಿಡಿಯಲು _command substitution_ ಬಳಸುತ್ತೇವೆ.
ನಾವು ಹೀಗೆ ಮಾಡಿದಾಗ:

```shell
files=$(ls)
echo "$files" | grep README
echo "$files" | grep ".py"
```

`ls` ನ output (`stdout`) `$files` variable ಗೆ ಸೇರುತ್ತದೆ; ನಂತರ ಅದನ್ನು ಬಳಸಬಹುದು.
`$files` ಒಳಗೆ newline ಗಳು ಉಳಿಯುತ್ತವೆ, ಆದ್ದರಿಂದ `grep` ಹಾಗೆ commands ಪ್ರತಿ item ಮೇಲೆ ಪ್ರತ್ಯೇಕವಾಗಿ ಕಾರ್ಯನಿರ್ವಹಿಸಬಹುದು.

ಇದಕ್ಕೆ ಸಂಬಂಧಿಸಿದ ಇನ್ನೊಂದು feature _process substitution_. `<( CMD )` ಅಂದರೆ `CMD` execute ಆಗಿ output temporary file ಗೆ ಹೋಗುತ್ತದೆ; `<()` ಆ file ಹೆಸರಿನಿಂದ substitute ಆಗುತ್ತದೆ.
STDIN ಬದಲು file path ಬೇಕು ಎನ್ನುವ commands ಗೆ ಇದು ಉಪಯುಕ್ತ.
ಉದಾ: `diff <(ls src) <(ls docs)` ನಿಂದ `src` ಮತ್ತು `docs` dirs ನಡುವಿನ ವ್ಯತ್ಯಾಸ ನೋಡಬಹುದು.

ಒಂದು shell program ಇನ್ನೊಂದು program ಅನ್ನು ಕರೆಯುವಾಗ, ಕೆಲವು variables ಕೂಡ pass ಮಾಡುತ್ತದೆ; ಇವನ್ನೇ ಸಾಮಾನ್ಯವಾಗಿ _environment variables_ ಎನ್ನುತ್ತೇವೆ.
ಪ್ರಸ್ತುತ environment variables ನೋಡಲು `printenv` ಬಳಸಬಹುದು.
ಒಂದು command ಗೆ ಮಾತ್ರ environment variable ಕೊಡುವುದಕ್ಕೆ command ಮುಂದೆ assignment ಮಾಡಬಹುದು.

> Environment variables ಅನ್ನು ಸಾಮಾನ್ಯವಾಗಿ ALL_CAPS ನಲ್ಲಿ ಬರೆಯುತ್ತಾರೆ (ಉದಾ: `HOME`, `PATH`, `DEBUG`). ಇದು technical requirement ಅಲ್ಲ, ಆದರೆ local shell variables (ಸಾಮಾನ್ಯವಾಗಿ lowercase) ಇಂದ ಬೇರ್ಪಡಿಸಲು ಸಹಾಯಕ.

```shell
TZ=Asia/Tokyo date  # prints the current time in Tokyo
echo $TZ  # this will be empty, since TZ was only set for the child command
```

ಅಥವಾ `export` built-in ಬಳಸಿ current environment ಅನ್ನು ಬದಲಿಸಬಹುದು; ಆಗ ಮುಂದಿನ child processes ಎಲ್ಲವೂ ಅದನ್ನು inherit ಮಾಡುತ್ತವೆ:

```shell
export DEBUG=1
# All programs from this point onwards will have DEBUG=1 in their environment
bash -c 'echo $DEBUG'
# prints 1
```

variable ತೆಗೆದುಹಾಕಲು `unset` built-in command - ಉದಾ: `unset DEBUG`.

> Environment variables ಕೂಡ shell convention ಆಗಿವೆ. ಅವುಗಳನ್ನು ಬಳಸಿ ಅನೇಕ programs ನ behavior ಅನ್ನು explicit flags ಇಲ್ಲದೆ implicit ಆಗಿ ಬದಲಿಸಬಹುದು. ಉದಾಹರಣೆಗೆ shell `$HOME` variable ನಲ್ಲಿ current user home path ಇಡುತ್ತದೆ. Programs ಇದನ್ನೇ ಓದಿ ಮಾಹಿತಿ ಪಡೆಯಬಹುದು; `--home /home/alice` ಅಂಥ explicit flag ಬೇಕಾಗುವುದಿಲ್ಲ. ಇದೇ ರೀತಿಯಾಗಿ `$TZ` ಅನ್ನು ಹಲವು programs date/time formatting ಗೆ ಬಳಸುತ್ತವೆ.

## Return codes

ಹಿಂದೆ ನೋಡಿದಂತೆ, shell program ನ ಪ್ರಮುಖ output `stdout/stderr` streams ಮತ್ತು filesystem side effects ಮೂಲಕ ವ್ಯಕ್ತವಾಗುತ್ತದೆ.

default ಆಗಿ shell script exit code zero ಹಿಂತಿರುಗಿಸುತ್ತದೆ.
Convention ಪ್ರಕಾರ zero ಅಂದರೆ ಯಶಸ್ಸು, nonzero ಅಂದರೆ ಕೆಲವು ಸಮಸ್ಯೆಗಳು ಎದುರಾದವು.
nonzero code ಹಿಂತಿರುಗಿಸಲು `exit NUM` built-in ಬಳಕೆ.
ಕೊನೆಯ command ನ return code ಅನ್ನು `$?` ಮೂಲಕ ಪಡೆಯಬಹುದು.

shell ನಲ್ಲಿ `&&` ಮತ್ತು `||` boolean operators ಇವೆ.
ಸಾಮಾನ್ಯ programming languages ಗಿಂತ ವಿಭಿನ್ನವಾಗಿ, shell ನಲ್ಲಿ ಇವು programs return codes ಮೇಲೆ ಕಾರ್ಯನಿರ್ವಹಿಸುತ್ತವೆ.
ಇವೆರಡೂ [short-circuiting](https://en.wikipedia.org/wiki/Short-circuit_evaluation) operators.
ಅಂದರೆ ಹಿಂದಿನ command ಯಶಸ್ಸು (exit code 0) ಅಥವಾ ವಿಫಲತೆ ಆಧರಿಸಿ ಮುಂದಿನ command conditionally execute ಮಾಡಬಹುದು.

```shell
# echo will only run if grep succeeds (finds a match)
grep -q "pattern" file.txt && echo "Pattern found"

# echo will only run if grep fails (no match)
grep -q "pattern" file.txt || echo "Pattern not found"

# true is a shell program that always succeeds
true && echo "This will always print"

# and false is a shell program that always fails
false || echo "This will always print"
```

ಈದೇ ತತ್ವ `if` ಮತ್ತು `while` statements ಗಳಿಗೂ ಅನ್ವಯಿಸುತ್ತದೆ - ನಿರ್ಧಾರ return code ಆಧರಿಸಿ ತೆಗೆದುಕೊಳ್ಳಲಾಗುತ್ತದೆ:

```shell
# if uses the return code of the condition command (0 = true, nonzero = false)
if grep -q "pattern" file.txt; then
    echo "Found"
fi

# while loops continue as long as the command returns 0
while read line; do
    echo "$line"
done < file.txt
```

## Signals

ಕೆಲವೊಮ್ಮೆ program ನಡೆಯುತ್ತಿರುವಾಗ ಅದನ್ನು interrupt ಮಾಡಬೇಕಾಗುತ್ತದೆ - ಉದಾ: command ಹೆಚ್ಚು ಸಮಯ ತೆಗೆದುಕೊಳ್ಳುವುದಾದರೆ.
ಅತ್ಯಂತ ಸರಳ ವಿಧಾನ `Ctrl-C` ಒತ್ತುವುದು; ಸಾಮಾನ್ಯವಾಗಿ command ನಿಲ್ಲುತ್ತದೆ.
ಆದರೆ ಇದು ಒಳಗೆ ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ? ಕೆಲವೊಮ್ಮೆ ಏಕೆ ನಿಲ್ಲುವುದಿಲ್ಲ?

```console
$ sleep 100
^C
$
```

> ಇಲ್ಲಿ `^C` ಅಂದರೆ terminal ನಲ್ಲಿ `Ctrl` ಕೀ ಹೇಗೆ ತೋರಿಸಲಾಗುತ್ತದೆ ಎಂಬುದು.

ಇದಕ್ಕೆ ಒಳಗಿನ ಕ್ರಮ ಹೀಗಿದೆ:

1. ನಾವು `Ctrl-C` ಒತ್ತುತ್ತೇವೆ
2. shell ಆ ವಿಶೇಷ key combination ಅನ್ನು ಗುರುತಿಸುತ್ತದೆ
3. shell process, `sleep` process ಗೆ `SIGINT` signal ಕಳುಹಿಸುತ್ತದೆ
4. signal, `sleep` process ನ execution ಅನ್ನು interrupt ಮಾಡುತ್ತದೆ

Signals ಒಂದು ವಿಶೇಷ communication mechanism.
ಒಂದು process signal ಸ್ವೀಕರಿಸಿದಾಗ ಅದು ತನ್ನ execution ನಿಲ್ಲಿಸಿ, signal handle ಮಾಡಿ, ಅದರ ಮಾಹಿತಿಯ ಆಧಾರದ ಮೇಲೆ control flow ಬದಲಿಸಬಹುದು.
ಈ ಕಾರಣಕ್ಕೆ signals ಅನ್ನು _software interrupts_ ಎಂದು ಕರೆಯುತ್ತಾರೆ.

ನಮ್ಮ ಸಂದರ್ಭದಲ್ಲಿ `Ctrl-C` ಒತ್ತಿದಾಗ shell `SIGINT` ಅನ್ನು process ಗೆ ಕಳುಹಿಸುತ್ತದೆ.
ಕೆಳಗೆ `SIGINT` ಅನ್ನು ಹಿಡಿದು ignore ಮಾಡುವ Python program ಇದೆ. ಈಗ ಇದನ್ನು ಕೊಲ್ಲಲು `Ctrl-\` ಮೂಲಕ `SIGQUIT` ಕಳುಹಿಸಬೇಕು.

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

ಈ program ಗೆ ಎರಡು ಸಲ `SIGINT`, ನಂತರ `SIGQUIT` ಕಳಿಸಿದರೆ ಹೀಗೆ ಕಾಣುತ್ತದೆ. `^` ಎಂದರೆ terminal ನಲ್ಲಿ `Ctrl` ಪ್ರದರ್ಶನ:

```console
$ python sigint.py
24^C
I got a SIGINT, but I am not stopping
26^C
I got a SIGINT, but I am not stopping
30^\[1]    39913 quit       python sigint.py
```

`SIGINT` ಮತ್ತು `SIGQUIT` ಸಾಮಾನ್ಯವಾಗಿ terminal ಸಂಬಂಧಿತವಾದರೂ, process ಅನ್ನು graceful ಆಗಿ ಹೊರಬರಲು ಕೇಳುವ ಸಾಮಾನ್ಯ signal ಎಂದರೆ `SIGTERM`.
ಇದನ್ನು [`kill`](https://www.man7.org/linux/man-pages/man1/kill.1.html) command ಮೂಲಕ `kill -TERM <PID>` syntax ನಲ್ಲಿ ಕಳಿಸಬಹುದು.

Signals process ಅನ್ನು terminate ಮಾಡುವುದಷ್ಟೇ ಅಲ್ಲ, ಬೇರೆ ಕೆಲಸಗಳೂ ಇವೆ. ಉದಾ: `SIGSTOP` process ಅನ್ನು pause ಮಾಡುತ್ತದೆ.
terminal ನಲ್ಲಿ `Ctrl-Z` ಒತ್ತಿದರೆ shell `SIGTSTP` (Terminal Stop) signal ಕಳುಹಿಸುತ್ತದೆ.

ಅದಾದ ಬಳಿಕ pause ಆದ job ಅನ್ನು foreground ಅಥವಾ background ನಲ್ಲಿ [`fg`](https://www.man7.org/linux/man-pages/man1/fg.1p.html) ಅಥವಾ [`bg`](https://man7.org/linux/man-pages/man1/bg.1p.html) ಮೂಲಕ ಮುಂದುವರಿಸಬಹುದು.

[`jobs`](https://www.man7.org/linux/man-pages/man1/jobs.1p.html) command ಪ್ರಸ್ತುತ terminal session ಗೆ ಸಂಬಂಧಿಸಿದ unfinished jobs ಪಟ್ಟಿಯನ್ನು ತೋರಿಸುತ್ತದೆ.
ಅವುಗಳನ್ನು pid ಮೂಲಕ (ಅದನ್ನು ಕಂಡುಹಿಡಿಯಲು [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) ಬಳಸಬಹುದು) ಸೂಚಿಸಬಹುದು.
ಅಥವಾ `jobs` ತೋರಿಸುವ job number ಜೊತೆ `%` ಬಳಸಿ ಸೂಚಿಸಬಹುದು.
ಕೊನೆಯ background job ಸೂಚಿಸಲು `$!` special parameter ಬಳಸಬಹುದು.

ಇನ್ನೊಂದು ವಿಷಯ: command ಕೊನೆಯಲ್ಲಿ `&` ಹಾಕಿದರೆ ಅದು background ನಲ್ಲಿ run ಆಗಿ prompt ತಕ್ಷಣ ಮರಳುತ್ತದೆ. ಆದರೆ ಅದು shell ನ STDOUT ಬಳಸುತ್ತಲೇ ಇರುತ್ತದೆ (ಅಗತ್ಯವಿದ್ದರೆ redirection ಬಳಸಿ).
ಇದಕ್ಕೆ ಸಮನಾಗಿ ಈಗಾಗಲೇ run ಆಗಿರುವ program ಅನ್ನು `Ctrl-Z` ನಂತರ `bg` ಮೂಲಕ background ಗೆ ಕಳುಹಿಸಬಹುದು.

background processes ಕೂಡ ನಿಮ್ಮ terminal ನ child processes ಆಗಿರುವುದರಿಂದ terminal ಮುಚ್ಚಿದರೆ ಅವು ಸತ್ತುಹೋಗುತ್ತವೆ (`SIGHUP` signal).
ಅದನ್ನು ತಪ್ಪಿಸಲು [`nohup`](https://www.man7.org/linux/man-pages/man1/nohup.1.html) ಬಳಸಿ run ಮಾಡಬಹುದು, ಅಥವಾ ಈಗಾಗಲೇ ಶುರುವಾದ process ಗೆ `disown` ಮಾಡಬಹುದು.
ಇಲ್ಲದಿದ್ದರೆ ಮುಂದಿನ ಭಾಗದಲ್ಲಿ ನೋಡುವ terminal multiplexer ಬಳಸಬಹುದು.

ಕೆಳಗಿನ sample session ಈ ಕಲ್ಪನೆಗಳಲ್ಲಿ ಕೆಲವು ತೋರಿಸುತ್ತದೆ.

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

$ kill -SIGHUP %2   # nohup protects from SIGHUP

$ jobs
[2]  + running    nohup sleep 2000

$ kill %2
[2]  + 18745 terminated  nohup sleep 2000
```

`SIGKILL` ಒಂದು ವಿಶೇಷ signal - process ಇದನ್ನು ಹಿಡಿಯಲು ಸಾಧ್ಯವಿಲ್ಲ ಮತ್ತು ಅದು ತಕ್ಷಣ terminate ಆಗುತ್ತದೆ.
ಆದರೆ ಇದರಿಂದ orphaned child processes ಹಾಗು ಇತರೆ side effects ಉಂಟಾಗುವ ಸಾಧ್ಯತೆ ಇದೆ.

Signals ಬಗ್ಗೆ ಇನ್ನಷ್ಟು ತಿಳಿಯಲು [ಈ ಲಿಂಕ್](https://en.wikipedia.org/wiki/Signal_(IPC)) ಅಥವಾ [`man signal`](https://www.man7.org/linux/man-pages/man7/signal.7.html), `kill -l` ನೋಡಿ.

Shell scripts ಒಳಗೆ signals ಬಂದಾಗ commands ನಡೆಸಲು `trap` built-in ಬಳಸಬಹುದು. Cleanup operations ಗೆ ಇದು ಉಪಯುಕ್ತ.

```shell
#!/usr/bin/env bash
cleanup() {
    echo "Cleaning up temporary files..."
    rm -f /tmp/mytemp.*
}
trap cleanup EXIT  # Run cleanup when script exits
trap cleanup SIGINT SIGTERM  # Also on Ctrl-C or kill
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

# ರಿಮೋಟ್ ಯಂತ್ರಗಳು

ಇಂದು ಬಹುತೇಕ programmers ತಮ್ಮ ದೈನಂದಿನ ಕೆಲಸದಲ್ಲಿ remote servers ಜೊತೆ ಕೆಲಸ ಮಾಡುತ್ತಾರೆ.
ಇದಕ್ಕಾಗಿ ಸಾಮಾನ್ಯ tool ಎಂದರೆ SSH (Secure Shell). ಇದು remote server ಗೆ connect ಆಗಲು ಮತ್ತು ಈಗಾಗಲೇ ಪರಿಚಿತ shell interface ಬಳಕೆ ಮಾಡಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ.
ಉದಾಹರಣೆಗೆ server ಗೆ ಹೀಗೆ ಸಂಪರ್ಕಿಸಬಹುದು:

```bash
ssh alice@server.mit.edu
```

ಇಲ್ಲಿ `server.mit.edu` ನಲ್ಲಿ `alice` user ಆಗಿ ssh ಮಾಡಲು ಪ್ರಯತ್ನಿಸುತ್ತಿದ್ದೇವೆ.

`ssh` ನ ಪ್ರಮುಖ ಆದರೆ ಕಡಿಮೆ ಗಮನಕ್ಕೆ ಬರುವ feature ಎಂದರೆ non-interactive command execution.
`ssh` command ನ stdin ಕಳುಹಿಸುವುದು ಮತ್ತು stdout ಸ್ವೀಕರಿಸುವುದನ್ನು ಸರಿಯಾಗಿ ನಿರ್ವಹಿಸುತ್ತದೆ, ಆದ್ದರಿಂದ ಇತರೆ commands ಜೊತೆ ಇದನ್ನು ಸೇರಿಸಬಹುದು:

```shell
# here ls runs in the remote, and wc runs locally
ssh alice@server ls | wc -l

# here both ls and wc run in the server
ssh alice@server 'ls | wc -l'

```

> disconnection, sleep mode, network ಬದಲಾವಣೆ, high-latency links ಇತ್ಯಾದಿಗಳನ್ನು ಉತ್ತಮವಾಗಿ ನಿಭಾಯಿಸುವ SSH ಪರ್ಯಾಯವಾಗಿ [Mosh](https://mosh.org/) ಅನ್ನು ಪ್ರಯತ್ನಿಸಿ.

remote server ನಲ್ಲಿ commands run ಮಾಡಲು `ssh` ನಿಮಗೆ authorization ಇದೆ ಎಂದು ದೃಢೀಕರಿಸಬೇಕು.
ಇದನ್ನು passwords ಅಥವಾ ssh keys ಮೂಲಕ ಮಾಡಬಹುದು.
Key-based authentication public-key cryptography ಬಳಸಿಕೊಂಡು client ಬಳಿ secret private key ಇದೆ ಎಂದು ಸರ್ವರ್‌ಗೆ ಸಾಬೀತುಪಡಿಸುತ್ತದೆ - key ನ್ನೇ ಬಹಿರಂಗಪಡಿಸದೆ.
Key-based authentication ಹೆಚ್ಚು ಸುಲಭ ಮತ್ತು ಹೆಚ್ಚು ಸುರಕ್ಷಿತ; ಆದ್ದರಿಂದ ಅದನ್ನೇ ಆದ್ಯತೆಯಿಂದ ಬಳಸಿ.
Private key (ಸಾಮಾನ್ಯವಾಗಿ `~/.ssh/id_rsa`, ಇತ್ತೀಚೆಗೆ `~/.ssh/id_ed25519`) ಪ್ರಾಯೋಗಿಕವಾಗಿ password ಸಮಾನ; ಆದ್ದರಿಂದ ಅದನ್ನು ಎಂದಿಗೂ ಹಂಚಿಕೊಳ್ಳಬೇಡಿ.

Key pair ರಚಿಸಲು [`ssh-keygen`](https://www.man7.org/linux/man-pages/man1/ssh-keygen.1.html) ಬಳಸಬಹುದು.

```bash
ssh-keygen -a 100 -t ed25519 -f ~/.ssh/id_ed25519
```

GitHub ಗೆ SSH keys ಮೂಲಕ push ಮಾಡಲು ನೀವು ಹಿಂದೆ configure ಮಾಡಿದ್ದರೆ, [ಈ ಹಂತಗಳು](https://help.github.com/articles/connecting-to-github-with-ssh/) ಬಹುಶಃ ನೀವು ಮಾಡಿರಬಹುದು ಮತ್ತು ಮಾನ್ಯ key pair ಇರಬಹುದು.
passphrase ಇದೆವೋ, ಸರಿಯೇ ಎಂದು ಪರಿಶೀಲಿಸಲು `ssh-keygen -y -f /path/to/key` ಬಳಸಬಹುದು.

server ಭಾಗದಲ್ಲಿ `ssh`, `.ssh/authorized_keys` ನೋಡಿ ಯಾವ clients ಗೆ ಪ್ರವೇಶ ಕೊಡಬೇಕೆಂದು ತೀರ್ಮಾನಿಸುತ್ತದೆ.
Public key ಕಾಪಿ ಮಾಡಲು:

```bash
cat .ssh/id_ed25519.pub | ssh alice@remote 'cat >> ~/.ssh/authorized_keys'

# or more simply (if ssh-copy-id is available)

ssh-copy-id -i .ssh/id_ed25519 alice@remote
```

commands ಮಾತ್ರವಲ್ಲ, ssh connection ಬಳಸಿ files ಅನ್ನು secure ಆಗಿ transfer ಕೂಡ ಮಾಡಬಹುದು.
[`scp`](https://www.man7.org/linux/man-pages/man1/scp.1.html) ಪರಂಪರೆಯ tool; syntax: `scp path/to/local_file remote_host:path/to/remote_file`.
[`rsync`](https://www.man7.org/linux/man-pages/man1/rsync.1.html), `scp` ಗಿಂತ ಉತ್ತಮ - local ಮತ್ತು remote ನಲ್ಲಿ ಸಮಾನ files ಮರು-copy ಆಗದಂತೆ ತಡೆಯುತ್ತದೆ.
ಇದಲ್ಲದೆ symlinks, permissions ಮೇಲೆ ಹೆಚ್ಚುವರಿ ನಿಯಂತ್ರಣ ಮತ್ತು interrupted copy ಮರುಪ್ರಾರಂಭಿಸುವ `--partial` ಹೀಗೆ features ಒದಗಿಸುತ್ತದೆ.
`rsync` syntax, `scp` ಗೆ ಹೋಲುತ್ತದೆ.

SSH client configuration `~/.ssh/config` ನಲ್ಲಿ ಇರುತ್ತದೆ. ಇಲ್ಲಿ hosts ಮತ್ತು default settings ಘೋಷಿಸಬಹುದು.
ಈ config file ಅನ್ನು `ssh` ಮಾತ್ರವಲ್ಲ `scp`, `rsync`, `mosh` ಮುಂತಾದ programs ಕೂಡ ಓದುತ್ತವೆ.

```bash
Host vm
    User alice
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519

# Configs can also take wildcards
Host *.mit.edu
    User alice
```

# ಟರ್ಮಿನಲ್ ಮಲ್ಟಿಪ್ಲೆಕ್ಸರ್ಸ್

command line interface ಬಳಸುವಾಗ ನೀವು ಹಲವಾರು ಕೆಲಸಗಳನ್ನು ಒಂದೇ ಸಮಯದಲ್ಲಿ ನಡೆಸಲು ಬಯಸುತ್ತೀರಿ.
ಉದಾಹರಣೆಗೆ editor ಮತ್ತು program ಅನ್ನು side-by-side ಓಡಿಸುವ ಅಗತ್ಯ ಬರುತ್ತದೆ.
ಹೊಸ terminal windows ತೆರೆದು ಇದನ್ನು ಮಾಡಬಹುದು, ಆದರೆ terminal multiplexer ಹೆಚ್ಚು ಬಲವಾದ ಪರಿಹಾರ.

[`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) ಮುಂತಾದ terminal multiplexers panes ಮತ್ತು tabs ಬಳಸಿ terminal windows ಅನ್ನು multiplex ಮಾಡಲು ಸಹಾಯ ಮಾಡುತ್ತವೆ.
ಇದರಿಂದ ಅನೇಕ shell sessions ಅನ್ನು ಪರಿಣಾಮಕಾರಿಯಾಗಿ ನಿರ್ವಹಿಸಬಹುದು.
ಇದಲ್ಲದೆ ಪ್ರಸ್ತುತ terminal session ಅನ್ನು detach ಮಾಡಿ ನಂತರ ಮರು-attach ಮಾಡಬಹುದು.
ಅದರ ಕಾರಣ remote machines ಜೊತೆ ಕೆಲಸಿಸುವಾಗ terminal multiplexers ಬಹಳ ಉಪಯುಕ್ತ - `nohup` ಮುಂತಾದ workaroundಗಳ ಅವಶ್ಯಕತೆ ಕಡಿಮೆ.

ಈ ದಿನಗಳಲ್ಲಿ ಅತಿ ಜನಪ್ರಿಯ terminal multiplexer ಎಂದರೆ [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html).
`tmux` ಬಹಳ configurable; keybindings ಗಳನ್ನು ಬಳಸಿ tabs ಮತ್ತು panes ಸೃಷ್ಟಿಸಿ ವೇಗವಾಗಿ navigate ಮಾಡಬಹುದು.

`tmux` keybindings ತಿಳಿದಿರಬೇಕು; ಅವೆಲ್ಲವೂ `<C-b> x` ರೂಪದಲ್ಲಿರುತ್ತವೆ: (1) `Ctrl+b` ಒತ್ತಿ, (2) ಬಿಡಿ, (3) `x` ಒತ್ತಿ.
`tmux` ನಲ್ಲಿ objects hierarchy ಹೀಗಿದೆ:

- **Sessions** - ಒಂದು session ಎಂದರೆ ಒಂದು ಅಥವಾ ಹೆಚ್ಚು windows ಇರುವ ಸ್ವತಂತ್ರ workspace
    + `tmux` ಹೊಸ session ಆರಂಭಿಸುತ್ತದೆ.
    + `tmux new -s NAME` ಕೊಟ್ಟರೆ ಆ ಹೆಸರಿನ session ಆರಂಭಿಸುತ್ತದೆ.
    + `tmux ls` ಪ್ರಸ್ತುತ sessions ಪಟ್ಟಿ ತೋರಿಸುತ್ತದೆ.
    + `tmux` ಒಳಗೆ `<C-b> d` current session detach ಮಾಡುತ್ತದೆ.
    + `tmux a` ಕೊನೆಯ session attach ಮಾಡುತ್ತದೆ. `-t` ಮೂಲಕ ನಿರ್ದಿಷ್ಟ session ಸೂಚಿಸಬಹುದು.

- **Windows** - editors/browsers ನ tabs ಗೆ ಸಮಾನ; session ಒಳಗಿನ ಪ್ರತ್ಯೇಕ ದೃಶ್ಯ ಭಾಗಗಳು
    + `<C-b> c` ಹೊಸ window ರಚಿಸುತ್ತದೆ. ಮುಚ್ಚಲು `<C-d>` ಬಳಸಿ shells terminate ಮಾಡಿ.
    + `<C-b> N` _N_ ನೇ window ಗೆ ಹೋಗುತ್ತದೆ.
    + `<C-b> p` ಹಿಂದಿನ window ಗೆ ಹೋಗುತ್ತದೆ.
    + `<C-b> n` ಮುಂದಿನ window ಗೆ ಹೋಗುತ್ತದೆ.
    + `<C-b> ,` current window rename ಮಾಡುತ್ತದೆ.
    + `<C-b> w` current windows ಪಟ್ಟಿ ತೋರಿಸುತ್ತದೆ.

- **Panes** - vim splits ಹಾಗೆ, ಒಂದೇ ದೃಶ್ಯದಲ್ಲಿ ಅನೇಕ shells
    + `<C-b> "` current pane ಅನ್ನು horizontally split ಮಾಡುತ್ತದೆ.
    + `<C-b> %` current pane ಅನ್ನು vertically split ಮಾಡುತ್ತದೆ.
    + `<C-b> <direction>` ನೀಡಿದ ದಿಕ್ಕಿನ pane ಗೆ ಹೋಗುತ್ತದೆ (arrow keys).
    + `<C-b> z` current pane zoom toggle ಮಾಡುತ್ತದೆ.
    + `<C-b> [` scrollback mode ಆರಂಭಿಸುತ್ತದೆ. ನಂತರ `<space>` selection, `<enter>` copy.
    + `<C-b> <space>` pane arrangements cycle ಮಾಡುತ್ತದೆ.

> `tmux` ಬಗ್ಗೆ ಇನ್ನಷ್ಟು ತಿಳಿಯಲು [ಈ quick tutorial](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) ಮತ್ತು [ಈ ವಿವರವಾದ ಲೇಖನ](https://linuxcommand.org/lc3_adv_termmux.php) ಓದಿ.

tmux ಮತ್ತು SSH ನಿಮ್ಮ toolkit ನಲ್ಲಿ ಸೇರಿದ ಮೇಲೆ, ಯಾವ ಯಂತ್ರದಲ್ಲಾದರೂ ನಿಮ್ಮ ಪರಿಸರ ಮನೆಯಂತಿರಬೇಕು ಎಂಬ ಆಸೆ ಬರುತ್ತದೆ. ಅಲ್ಲಿ shell customization ಬರುತ್ತದೆ.

# ಶೆಲ್ ಕಸ್ಟಮೈಸಿಂಗ್

ಹಲವಾರು command line programs _dotfiles_ ಎಂದು ಕರೆಯುವ plain-text files ಮೂಲಕ configure ಆಗುತ್ತವೆ
(ಯಾಕೆಂದರೆ ಫೈಲ್ ಹೆಸರು `.` ಇಂದ ಆರಂಭವಾಗುತ್ತದೆ - ಉದಾ. `~/.vimrc`; ಆದ್ದರಿಂದ `ls` ನಲ್ಲಿ default ಆಗಿ hidden ಆಗಿರುತ್ತವೆ).

> Dotfiles ಕೂಡ shell convention. ಮುಂದೆ ಇರುವ dot ಅವುಗಳನ್ನು listing ನಲ್ಲಿ ಮರೆಮಾಡಲು ಬಳಸಲಾಗುತ್ತದೆ (ಹೌದು, ಇದೂ ಒಂದು convention).

shell ಗಳು dotfiles ಬಳಸುವ programs ಗಳ ಉದಾಹರಣೆ.
startup ಸಮಯದಲ್ಲಿ shell ತನ್ನ configuration ಲೋಡ್ ಮಾಡಲು ಹಲವಾರು files ಓದುತ್ತದೆ.
shell ಪ್ರಕಾರ, login/interactive session ಪ್ರಕಾರ ಈ ಪ್ರಕ್ರಿಯೆ ಸಂಕೀರ್ಣವಾಗಬಹುದು.
[ಈ ಸಂಪನ್ಮೂಲ](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) ಅತ್ಯುತ್ತಮ ವಿವರ ನೀಡುತ್ತದೆ.

`bash` ಗಾಗಿ ಹೆಚ್ಚಿನ systems ನಲ್ಲಿ `.bashrc` ಅಥವಾ `.bash_profile` edit ಮಾಡಿದರೆ ಸಾಕಾಗುತ್ತದೆ.
ಇದೇ ರೀತಿ dotfiles ಮೂಲಕ configure ಆಗುವ tools ಕೆಲವು:

- `bash` - `~/.bashrc`, `~/.bash_profile`
- `git` - `~/.gitconfig`
- `vim` - `~/.vimrc` ಮತ್ತು `~/.vim` folder
- `ssh` - `~/.ssh/config`
- `tmux` - `~/.tmux.conf`

ಸಾಮಾನ್ಯ customization ಒಂದು: shell programs ಹುಡುಕುವ ಸ್ಥಳಗಳಿಗೆ ಹೊಸ paths ಸೇರಿಸುವುದು. software install ಮಾಡುವಾಗ ಇದು ನಿಮಗೆ ಕಾಣುತ್ತದೆ:

```shell
export PATH="$PATH:path/to/append"
```

ಇಲ್ಲಿ `$PATH` ನ current value ಗೆ ಹೊಸ path ಸೇರಿಸಿ, child processes ಗೆ inherit ಆಗುವಂತೆ ಮಾಡುತ್ತಿದ್ದೇವೆ.
ಇದರಿಂದ `path/to/append` ಅಡಿಯಲ್ಲಿ ಇರುವ programs ಪತ್ತೆಯಾಗುತ್ತವೆ.

shell customization ನಲ್ಲಿ ಸಾಮಾನ್ಯವಾಗಿ ಹೊಸ command-line tools install ಮಾಡುವುದೂ ಸೇರಿದೆ.
Package managers ಇದನ್ನು ಸುಲಭಗೊಳಿಸುತ್ತವೆ - download, install, update ಎಲ್ಲವನ್ನೂ ನಿರ್ವಹಿಸುತ್ತವೆ.
Operating system ಪ್ರಕಾರ package managers ಬದಲಾಗುತ್ತವೆ: macOS ನಲ್ಲಿ [Homebrew](https://brew.sh/), Ubuntu/Debian ನಲ್ಲಿ `apt`, Fedora ನಲ್ಲಿ `dnf`, Arch ನಲ್ಲಿ `pacman`.
Package managers ಬಗ್ಗೆ shipping code ಉಪನ್ಯಾಸದಲ್ಲಿ ಇನ್ನಷ್ಟು ನೋಡೋಣ.

macOS ನಲ್ಲಿ Homebrew ಬಳಸಿ ಉಪಯುಕ್ತವಾದ ಎರಡು tools install ಮಾಡುವ ವಿಧಾನ:

```shell
# ripgrep: a faster grep with better defaults
brew install ripgrep

# fd: a faster, user-friendly find
brew install fd
```

ಇವು install ಆದ ನಂತರ `grep` ಬದಲು `rg`, `find` ಬದಲು `fd` ಬಳಸಬಹುದು.

> **`curl | bash` ಬಗ್ಗೆ ಎಚ್ಚರಿಕೆ**: install ಸೂಚನೆಗಳಲ್ಲಿ `curl -fsSL https://example.com/install.sh | bash` ಆಗಾಗ ಕಾಣಬಹುದು. ಇದು script download ಆಗುತ್ತಿದ್ದಂತೆಯೇ execute ಮಾಡುವ pattern - ಸೌಲಭ್ಯಕರ ಆದರೆ ಅಪಾಯಕಾರಿ, ಏಕೆಂದರೆ ನೀವು ಪರಿಶೀಲಿಸದ code ಅನ್ನು ತಕ್ಷಣ ಓಡಿಸುತ್ತೀರಿ.
> ಹೆಚ್ಚು ಸುರಕ್ಷಿತ ವಿಧಾನ: ಮೊದಲು download ಮಾಡಿ, ಪರಿಶೀಲಿಸಿ, ನಂತರ execute ಮಾಡಿ.
> ```shell
> curl -fsSL https://example.com/install.sh -o install.sh
> less install.sh  # review the script
> bash install.sh
> ```
> ಕೆಲವು installers `/bin/bash -c "$(curl -fsSL https://url)"` ಎಂಬ ಸ್ವಲ್ಪ ಸುರಕ್ಷಿತ ರೂಪ ಬಳಸುತ್ತವೆ - ಕನಿಷ್ಠ script ಅನ್ನು bash interpret ಮಾಡುತ್ತದೆ.

install ಆಗದ command ಓಡಿಸಿದರೆ shell `command not found` ತೋರಿಸುತ್ತದೆ.
[command-not-found.com](https://command-not-found.com) ವೆಬ್‌ಸೈಟ್ ಯಾವುದೇ command ಹೇಗೆ install ಮಾಡುವುದು ಎಂಬುದನ್ನು ವಿವಿಧ package managers/distributions ಮೇಲೆ ಹುಡುಕಲು ಉಪಯುಕ್ತ.

ಮತ್ತೊಂದು ಉಪಯುಕ್ತ ಸಾಧನ [`tldr`](https://tldr.sh/) - ಸರಳ, example-ಕೇಂದ್ರಿತ man pages ಒದಗಿಸುತ್ತದೆ.
ದೀರ್ಘ documentation ಓದುವ ಬದಲು ಸಾಮಾನ್ಯ ಬಳಕೆ patterns ವೇಗವಾಗಿ ನೋಡಬಹುದು:

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

ಕೆಲವೊಮ್ಮೆ ಹೊಸ program ಬೇಡ - ನಿರ್ದಿಷ್ಟ flags ಜೊತೆಗೆ ಇರುವ command ಗೆ shorthand ಸಾಕು. ಅಲ್ಲಿ aliases ಉಪಯೋಗಕ್ಕೆ ಬರುತ್ತವೆ.

ನಮ್ಮದೇ command aliases ಅನ್ನು `alias` built-in ಮೂಲಕ ರಚಿಸಬಹುದು.
Shell alias ಅಂದರೆ ಬೇರೆ command ಗೆ short form; shell expression evaluate ಮಾಡುವ ಮೊದಲು ಅದನ್ನು substitute ಮಾಡುತ್ತದೆ.
ಉದಾಹರಣೆಗೆ bash ನಲ್ಲಿ alias ರಚನೆ:

```bash
alias alias_name="command_to_alias arg1 arg2"
```

> `=` ಸುತ್ತ space ಇರಬಾರದು; [`alias`](https://www.man7.org/linux/man-pages/man1/alias.1p.html) ಒಂದು single argument ತೆಗೆದುಕೊಳ್ಳುವ shell command.

Aliases ಗಳ ಕೆಲವು ಉಪಯುಕ್ತ ಬಳಕೆಗಳು:

```bash
# Make shorthands for common flags
alias ll="ls -lh"

# Save a lot of typing for common commands
alias gs="git status"
alias gc="git commit"

# Save you from mistyping
alias sl=ls

# Overwrite existing commands for better defaults
alias mv="mv -i"           # -i prompts before overwrite
alias mkdir="mkdir -p"     # -p make parent dirs as needed
alias df="df -h"           # -h prints human readable format

# Alias can be composed
alias la="ls -A"
alias lla="la -l"

# To ignore an alias run it prepended with \
\ls
# Or disable an alias altogether with unalias
unalias la

# To get an alias definition just call it with alias
alias ll
# Will print ll='ls -lh'
```

Aliases ಗೆ ಮಿತಿಗಳೂ ಇವೆ: command ಮಧ್ಯದಲ್ಲಿ arguments ತೆಗೆದುಕೊಳ್ಳುವ ಸಂಕೀರ್ಣ behavior ಗಳಿಗೆ aliases ಸಾಕಾಗುವುದಿಲ್ಲ. ಅಲ್ಲಿ shell functions ಬಳಸಿ.

ಬಹುತೇಕ shells ನಲ್ಲಿ `Ctrl-R` reverse history search ಕೊಡುತ್ತದೆ.
`Ctrl-R` ಒತ್ತಿ typing ಶುರು ಮಾಡಿದರೆ ಹಿಂದಿನ commands ಹುಡುಕಬಹುದು.
ಹಿಂದೆ ಪರಿಚಯಿಸಿದ `fzf` integration configure ಮಾಡಿದರೆ `Ctrl-R` ಇನ್ನಷ್ಟು ಶಕ್ತಿಶಾಲಿ interactive fuzzy history search ಆಗುತ್ತದೆ.

Dotfiles ಅನ್ನು ಹೇಗೆ ಸಂಘಟಿಸಬೇಕು?
ಅವುಗಳನ್ನು ಪ್ರತ್ಯೇಕ folder ನಲ್ಲಿ ಇಟ್ಟು, version control ನಲ್ಲಿ ಇಟ್ಟು, script ಮೂಲಕ **symlink** ಮಾಡಿ ಬಳಸಿ.
ಇದರಿಂದ ಲಾಭಗಳು:

- **ಸುಲಭ ಸ್ಥಾಪನೆ** - ಹೊಸ ಯಂತ್ರದಲ್ಲಿ login ಆದಾಗ ನಿಮ್ಮ customizations ಅನ್ನು ಕ್ಷಣಗಳಲ್ಲಿ ಅನ್ವಯಿಸಬಹುದು.
- **Portability** - ನಿಮ್ಮ tools ಎಲ್ಲೆಡೆ ಒಂದೇ ರೀತಿಯಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತವೆ.
- **Synchronization** - ಎಲ್ಲೆಡೆ dotfiles update ಮಾಡಿ sync ಇಡಬಹುದು.
- **Change tracking** - programming career മുഴುವರಿಗೂ dotfiles ಇರುತ್ತವೆ; version history ಬಹಳ ಉಪಯುಕ್ತ.

Dotfiles ನಲ್ಲಿ ಏನು ಹಾಕಬೇಕು?
Tool settings ತಿಳಿಯಲು online docs ಅಥವಾ [man pages](https://en.wikipedia.org/wiki/Man_page) ಓದಿ.
ನಿರ್ದಿಷ್ಟ programs ಕುರಿತು blog posts ಕೂಡ ಉತ್ತಮ ಮಾರ್ಗ.
ಇನ್ನೊಂದು ಮಾರ್ಗ - ಇತರರ dotfiles ನೋಡುವುದು.
GitHub ನಲ್ಲಿ ಅನೇಕ [dotfiles repositories](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories) ಲಭ್ಯ - ಜನಪ್ರಿಯದೊಂದು [ಇಲ್ಲಿ](https://github.com/mathiasbynens/dotfiles).
ಆದರೆ configurations ಅನ್ನು ಪರಿಶೀಲನೆ ಇಲ್ಲದೆ copy ಮಾಡಬೇಡಿ.
[ಈ ಸಂಪನ್ಮೂಲ](https://dotfiles.github.io/) ಕೂಡ ಒಳ್ಳೆಯದು.

ಈ ತರಗತಿಯ instructors ಅವರ dotfiles GitHub ನಲ್ಲಿ ಸಾರ್ವಜನಿಕವಾಗಿ ಲಭ್ಯ:
[Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/jjgo/dotfiles).

**Frameworks ಮತ್ತು plugins** ಕೂಡ shell ಅನುಭವವನ್ನು ಉತ್ತಮಗೊಳಿಸುತ್ತವೆ.
ಜನಪ್ರಿಯ frameworks: [prezto](https://github.com/sorin-ionescu/prezto), [oh-my-zsh](https://ohmyz.sh/).
ನಿರ್ದಿಷ್ಟ features ಗಾಗಿ plugins:

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - typing ಸಮಯದಲ್ಲಿ valid/invalid commands ಗೆ ಬಣ್ಣ
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - history ನಿಂದ command suggestions
- [zsh-completions](https://github.com/zsh-users/zsh-completions) - ಹೆಚ್ಚುವರಿ completion definitions
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) - fish-ಶೈಲಿ history search
- [powerlevel10k](https://github.com/romkatv/powerlevel10k) - ವೇಗವಾದ, customizable prompt theme

[fish](https://fishshell.com/) ಮೊದಲಾದ shells ಈ features ಗಳಲ್ಲಿ ಅನೇಕವನ್ನು default ಆಗಿಯೇ ಕೊಡುತ್ತವೆ.

> oh-my-zsh ಹೀಗೆ ದೊಡ್ಡ frameworks ಕಡ್ಡಾಯವಲ್ಲ. ಪ್ರತ್ಯೇಕ plugins install ಮಾಡಿದರೆ ಸಾಮಾನ್ಯವಾಗಿ ವೇಗವಾಗಿ ಹಾಗೂ ಹೆಚ್ಚಿನ ನಿಯಂತ್ರಣದೊಂದಿಗೆ ಇದೇ features ಪಡೆಯಬಹುದು. ದೊಡ್ಡ frameworks shell startup ಸಮಯವನ್ನು ಗಮನಾರ್ಹವಾಗಿ ನಿಧಾನಗೊಳಿಸಬಹುದು.

# ಶೆಲ್‌ನಲ್ಲಿನ AI

Shell ನಲ್ಲಿ AI tooling ಸೇರಿಸುವ ಹಲವು ಮಾರ್ಗಗಳಿವೆ. integration ಮಟ್ಟದ ಪ್ರಕಾರ ಕೆಲವು ಉದಾಹರಣೆಗಳು ಇಲ್ಲಿವೆ:

**Command generation**: [`simonw/llm`](https://github.com/simonw/llm) ಹಾಗೆಯ tools, natural language ವಿವರಣೆಯಿಂದ shell commands ರಚಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತವೆ.

```console
$ llm cmd "find all python files modified in the last week"
find . -name "*.py" -mtime -7
```

**Pipeline integration**: data process/transform ಮಾಡಲು LLMs ಅನ್ನು shell pipelines ಗೆ ಸೇರಿಸಬಹುದು.
formats ಅಸಂಗತವಾಗಿರುವ data ಯಿಂದ ಮಾಹಿತಿ ತೆಗೆಯುವಲ್ಲಿ regex ಕಷ್ಟವಾದಾಗ ಇದು ವಿಶೇಷವಾಗಿ ಉಪಯುಕ್ತ.

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

ಇಲ್ಲಿ `"$INSTRUCTIONS"` quoted ಆಗಿದೆ, ಏಕೆಂದರೆ variable ನಲ್ಲಿ spaces ಇವೆ.
`< users.txt` file content ಅನ್ನು stdin ಗೆ redirect ಮಾಡುತ್ತದೆ.

**AI shells**: [Claude Code](https://docs.anthropic.com/en/docs/claude-code) ಹಾಗೆಯ tools meta-shell ಆಗಿ ಕೆಲಸ ಮಾಡಿ English commands ಅನ್ನು shell operations, file edits, ಮತ್ತು ಸಂಕೀರ್ಣ multi-step tasks ಗಳಿಗೆ ಅನುವಾದಿಸುತ್ತವೆ.

# ಟರ್ಮಿನಲ್ ಎಮ್ಯುಲೇಟರ್ಸ್

shell customization ಜೊತೆಗೆ **terminal emulator** ಆಯ್ಕೆ ಮತ್ತು settings ಗೂ ಸಮಯ ಹೂಡುವುದು ಸೂಕ್ತ.
Terminal emulator ಅಂದರೆ ನಿಮ್ಮ shell ಓಡುವ text-based interface ನೀಡುವ GUI program.
ಇಂತಹ terminal emulators ಹಲವಾರು ಲಭ್ಯ.

terminal ನಲ್ಲಿ ನೀವು ನೂರಾರು ರಿಂದ ಸಾವಿರಾರು ಗಂಟೆಗಳವರೆಗೆ ಕಳೆಯುವ ಸಾಧ್ಯತೆ ಇರುವುದರಿಂದ ಅದರ settings ಮೇಲೆ ಗಮನ ಕೊಡುವುದು ಪ್ರಯೋಜನಕಾರಿ.
ಬದಲಾಯಿಸಲು ಪರಿಗಣಿಸಬಹುದಾದ ಅಂಶಗಳು:

- Font ಆಯ್ಕೆ
- Color scheme
- Keyboard shortcuts
- Tab/Pane support
- Scrollback configuration
- Performance (ಉದಾ. [Alacritty](https://github.com/alacritty/alacritty), [Ghostty](https://ghostty.org/) ಇತ್ಯಾದಿ terminals GPU acceleration ಒದಗಿಸುತ್ತವೆ)

# ವ್ಯಾಯಾಮಗಳು

## Arguments ಮತ್ತು Globs

1. `cmd --flag -- --notaflag` ಹೀಗೆ commands ಕಾಣಬಹುದು. ಇಲ್ಲಿ `--` ಒಂದು ವಿಶೇಷ argument: ಇದರ ನಂತರ flags parsing ನಿಲ್ಲಿಸಬೇಕು ಎಂದು program ಗೆ ಸೂಚಿಸುತ್ತದೆ. `--` ನಂತರ ಇರುವ ಎಲ್ಲವೂ positional arguments ಆಗಿ ಪರಿಗಣಿಸಬೇಕು. ಇದು ಯಾಕೆ ಉಪಯುಕ್ತ? `touch -- -myfile` ಪ್ರಯತ್ನಿಸಿ, ನಂತರ `--` ಬಳಸದೆ ಅದನ್ನು remove ಮಾಡಿ ನೋಡಿ.

1. [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) ಓದಿ ಮತ್ತು ಈ ರೀತಿಯಲ್ಲಿ files ಪಟ್ಟಿ ಮಾಡುವ `ls` command ಬರೆಯಿರಿ:
    - hidden files ಸೇರಿ ಎಲ್ಲಾ files ಕಾಣಬೇಕು
    - size human-readable ರೂಪದಲ್ಲಿ ತೋರಬೇಕು (ಉದಾ. 454279954 ಬದಲು 454M)
    - files recency ಆಧಾರದ ಮೇಲೆ ಕ್ರಮದಲ್ಲಿರಬೇಕು
    - output colorized ಆಗಿರಬೇಕು

    sample output:

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

1. Process substitution `<(command)` command output ಅನ್ನು file ಆಗಿ ಬಳಸಲು ಅನುಮತಿಸುತ್ತದೆ. `printenv` ಮತ್ತು `export` output ಹೋಲಿಸಲು `diff` ಬಳಸಿರಿ. ಅವು ಏಕೆ ಬೇರೆ? (Hint: `diff <(printenv | sort) <(export | sort)` ಪ್ರಯತ್ನಿಸಿ).

## Environment Variables

1. `marco` ಮತ್ತು `polo` ಎಂಬ bash functions ಬರೆಯಿರಿ:
   - `marco` execute ಮಾಡಿದಾಗ current working directory ಯಾವುದಾದರೂ ರೀತಿಯಲ್ಲಿ save ಆಗಬೇಕು.
   - ನಂತರ ನೀವು ಯಾವ directory ಯಲ್ಲಿದ್ದರೂ `polo` execute ಮಾಡಿದರೆ, `marco` execute ಮಾಡಿದ directory ಗೆ `cd` ಆಗಬೇಕು.
   Debug ಮಾಡಲು `marco.sh` ಫೈಲ್‌ನಲ್ಲಿ code ಬರೆಯಿರಿ ಮತ್ತು `source marco.sh` ಮೂಲಕ shell ಗೆ (re)load ಮಾಡಿ.

{% comment %}
marco() {
    export MARCO=$(pwd)
}

polo() {
    cd "$MARCO"
}
{% endcomment %}

## Return Codes

1. ಅಪರೂಪವಾಗಿ ವಿಫಲವಾಗುವ command ಇದೆ ಎಂದು ಊಹಿಸಿರಿ. Debug ಮಾಡಲು ಅದರ output ಹಿಡಿಯಬೇಕು, ಆದರೆ failure run ಸಿಗಲು ಸಮಯ ಹಿಡಿಯುತ್ತದೆ. ಕೆಳಗಿನ script fail ಆಗುವವರೆಗೆ ಅದನ್ನು ಓಡಿಸಿ, stdout ಮತ್ತು stderr ಅನ್ನು files ಗೆ capture ಮಾಡಿ, ಕೊನೆಯಲ್ಲಿ ಎಲ್ಲವನ್ನೂ print ಮಾಡುವ bash script ಬರೆಯಿರಿ. Bonus: fail ಆಗಲು ಎಷ್ಟು runs ಬೇಕಾಯಿತು ಎಂದು report ಮಾಡಿ.

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

## Signals ಮತ್ತು Job Control

1. terminal ನಲ್ಲಿ `sleep 10000` job ಆರಂಭಿಸಿ, `Ctrl-Z` ಮೂಲಕ background ಗೆ ಕಳುಹಿಸಿ, `bg` ಬಳಸಿ ಮುಂದುವರಿಸಿ. ನಂತರ [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) ಬಳಸಿ ಅದರ pid ಕಂಡುಹಿಡಿದು, pid ಅನ್ನು ನೇರವಾಗಿ type ಮಾಡದೆ [`pkill`](https://man7.org/linux/man-pages/man1/pgrep.1.html) ಬಳಸಿ kill ಮಾಡಿ. (Hint: `-af` flags ಬಳಸಿ).

1. ಒಂದು process ಮುಗಿಯುವವರೆಗೆ ಇನ್ನೊಂದು process ಪ್ರಾರಂಭಿಸಬಾರದು ಎಂದು ಹೇಳೋಣ. ಈ exercise ನಲ್ಲಿ limiting process ಎಂದರೆ `sleep 60 &`. ಇದನ್ನು ಸಾಧಿಸಲು [`wait`](https://www.man7.org/linux/man-pages/man1/wait.1p.html) command ಬಳಸಬಹುದು. `sleep` launch ಮಾಡಿ, `ls` command ಅನ್ನು background process ಮುಗಿಯುವವರೆಗೆ ಕಾಯುವಂತೆ ಮಾಡಿ ನೋಡಿ.

   ಆದರೆ ಬೇರೆ bash session ನಲ್ಲಿ ಇದ್ದರೆ ಇದು ಕೆಲಸ ಮಾಡುವುದಿಲ್ಲ, ಏಕೆಂದರೆ `wait` child processes ಮೇಲಷ್ಟೇ ಕೆಲಸ ಮಾಡುತ್ತದೆ.
   ನಾವು notes ನಲ್ಲಿ ಚರ್ಚಿಸದ ಒಂದು ವಿಷಯ: `kill` command ಯಶಸ್ವಿಯಾದರೆ exit status zero, ಇಲ್ಲದಿದ್ದರೆ nonzero.
   `kill -0` signal ಕಳುಹಿಸುವುದಿಲ್ಲ; process ಇಲ್ಲದಿದ್ದರೆ nonzero return ಕೊಡುತ್ತದೆ.
   ಕೊಟ್ಟ pid ಮುಗಿಯುವವರೆಗೆ ಕಾಯುವ `pidwait` ಎಂಬ bash function ಬರೆಯಿರಿ. CPU ವ್ಯರ್ಥವಾಗದಂತೆ `sleep` ಬಳಸಬೇಕು.

## Files ಮತ್ತು Permissions

1. (Advanced) ಒಂದು directory ಯಲ್ಲಿರುವ ಅತ್ಯಂತ ಇತ್ತೀಚೆಗೆ modified ಆದ file ಅನ್ನು recursive ಆಗಿ ಕಂಡುಹಿಡಿಯುವ command/script ಬರೆಯಿರಿ. ಹೆಚ್ಚಿನವಾಗಿ, recency ಪ್ರಕಾರ ಎಲ್ಲಾ files ಪಟ್ಟಿ ಮಾಡಬಹುದೇ?

## Terminal Multiplexers

1. ಈ `tmux` [tutorial](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) ಅನುಸರಿಸಿ, ನಂತರ [ಈ ಹಂತಗಳು](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/) ಬಳಸಿ ಕೆಲವು ಮೂಲಭೂತ customizations ಕಲಿಯಿರಿ.

## Aliases ಮತ್ತು Dotfiles

1. ತಪ್ಪಾಗಿ type ಮಾಡಿದಾಗ ಉಪಯೋಗವಾಗುವಂತೆ `cd` ಗೆ `dc` alias ರಚಿಸಿ.

1. `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10` command ಓಡಿಸಿ top 10 ಹೆಚ್ಚು ಬಳಸುವ commands ನೋಡಿ, ಅವಕ್ಕೆ ಚಿಕ್ಕ aliases ಬರೆಯುವ ಬಗ್ಗೆ ಯೋಚಿಸಿ. Note: ಇದು Bash ಗೆ. ZSH ಬಳಿಸಿದರೆ `history` ಬದಲು `history 1` ಬಳಸಿ.

1. dotfiles ಗಾಗಿ folder ರಚಿಸಿ, version control ಹೊಂದಿಸಿ.

1. ಕನಿಷ್ಠ ಒಂದು program (ಉದಾ: shell) ಗೆ configuration ಸೇರಿಸಿ. ಆರಂಭಕ್ಕೆ `$PS1` ಬದಲಿಸಿ prompt customize ಮಾಡುವಷ್ಟು ಸರಳವಾಗಿರಬಹುದು.

1. ಹೊಸ machine ನಲ್ಲಿ manual effort ಇಲ್ಲದೆ dotfiles ತ್ವರಿತವಾಗಿ install ಆಗುವ ವಿಧಾನ ಸಿದ್ಧಪಡಿಸಿ. ಸರಳ `ln -s` script ಸಾಕು, ಅಥವಾ [specialized utility](https://dotfiles.github.io/utilities/) ಬಳಸಿ.

1. ನಿಮ್ಮ install script ಅನ್ನು fresh virtual machine ನಲ್ಲಿ ಪರೀಕ್ಷಿಸಿ.

1. ನಿಮ್ಮ ಪ್ರಸ್ತುತ tool configurations ಎಲ್ಲವನ್ನೂ dotfiles repository ಗೆ ಸ್ಥಳಾಂತರಿಸಿ.

1. ನಿಮ್ಮ dotfiles ಅನ್ನು GitHub ನಲ್ಲಿ ಪ್ರಕಟಿಸಿ.

## Remote Machines (SSH)

ಈ exercises ಗಾಗಿ Linux virtual machine install ಮಾಡಿ (ಅಥವಾ ಈಗಾಗಲೇ ಇರುವುದನ್ನು ಬಳಸಿ).
Virtual machines ಪರಿಚಯವಿಲ್ಲದಿದ್ದರೆ [ಈ tutorial](https://hibbard.eu/install-ubuntu-virtual-box/) ನೋಡಿ.

1. `~/.ssh/` ಗೆ ಹೋಗಿ SSH key pair ಇದೆಯೇ ನೋಡಿ. ಇಲ್ಲದಿದ್ದರೆ `ssh-keygen -a 100 -t ed25519` ಬಳಸಿ generate ಮಾಡಿ. passphrase ಬಳಸುವುದು ಮತ್ತು `ssh-agent` ಬಳಸುವುದು ಶಿಫಾರಸು - ಹೆಚ್ಚಿನ ಮಾಹಿತಿ [ಇಲ್ಲಿ](https://www.ssh.com/ssh/agent).

1. `.ssh/config` ನಲ್ಲಿ ಈ ರೀತಿಯ entry ಸೇರಿಸಿ:

    ```bash
    Host vm
        User username_goes_here
        HostName ip_goes_here
        IdentityFile ~/.ssh/id_ed25519
        LocalForward 9999 localhost:8888
    ```

1. `ssh-copy-id vm` ಬಳಸಿ ನಿಮ್ಮ ssh key server ಗೆ copy ಮಾಡಿ.

1. VM ನಲ್ಲಿ `python -m http.server 8888` execute ಮಾಡಿ webserver ಶುರುಮಾಡಿ. ನಿಮ್ಮ machine ನಲ್ಲಿ `http://localhost:9999` ತೆರೆಯಿರಿ.

1. `sudo vim /etc/ssh/sshd_config` ಮೂಲಕ SSH server config edit ಮಾಡಿ. `PasswordAuthentication` value ಬದಲಿಸಿ password authentication disable ಮಾಡಿ. `PermitRootLogin` value ಬದಲಿಸಿ root login disable ಮಾಡಿ. `sudo service sshd restart` ಮೂಲಕ `ssh` service restart ಮಾಡಿ. ಮತ್ತೆ ssh ಮಾಡಿ ಪರೀಕ್ಷಿಸಿ.

1. (Challenge) VM ನಲ್ಲಿ [`mosh`](https://mosh.org/) install ಮಾಡಿ connection ಸ್ಥಾಪಿಸಿ. ನಂತರ server/VM network adapter disconnect ಮಾಡಿ. mosh ಸರಿಯಾಗಿ recover ಆಗುತ್ತದೆಯೇ ನೋಡಿ.

1. (Challenge) `ssh` command ನಲ್ಲಿ `-N` ಮತ್ತು `-f` flags ಏನು ಮಾಡುತ್ತವೆ ನೋಡಿ. background port forwarding ಮಾಡಲು ಸರಿಯಾದ command ಕಂಡುಹಿಡಿಯಿರಿ.
