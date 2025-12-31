---
layout: lecture
title: "Course Overview + Introduction to the Shell"
date: 2026-01-12
ready: true
---

<span class="construction">
This page is under construction for the IAP 2026 offering of Missing Semester. This lecture will cover topics similar to the [Course overview + shell](/2020/course-shell/) and [Shell Tools and Scripting](/2020/shell-tools/) lectures from the 2020 offering.
</span>

In this lecture, we'll cover:

- A brief overview of the course, including [_why_ we're teaching this course](/about/)
- The shell language
- Modern shell tools

{% comment %}
lecturer: everyone

- overview (keep this brief)
    - all three of us should introduce ourselves to the class
    - mention that we don't monetize the class in any way, and talk about how people can support our missions
    - explicitly call out a way for people to give us feedback (or experience reports/testimonials, esp. from companies and universities)
{% endcomment %}

# Topic 1: The Shell

{% comment %}
lecturer: Jon (for shell)
{% endcomment %}

## What is the shell?

Computers these days have a variety of interfaces for giving them
commands; fanciful graphical user interfaces, voice interfaces, AR/VR,
and more recently: LLMs. These are great for 80% of use-cases, but they
are often fundamentally restricted in what they allow you to do — you
cannot press a button that isn't there or give a voice command that
hasn't been programmed. To take full advantage of the tools your
computer provides, we have to go old-school and drop down to a textual
interface: The Shell.

Nearly all platforms you can get your hands on have a shell in one form
or another, and many of them have several shells for you to choose from.
While they may vary in the details, at their core they are all roughly
the same: they allow you to run programs, give them input, and inspect
their output in a semi-structured way.

To open a shell _prompt_ (where you can type commands), you first need a
_terminal_, which is the visual interface to a shell. Your device
probably shipped with one installed, or you can install one fairly
easily:

- **Linux:**
  Press `Ctrl + Alt + T` (works on most distributions). Or search for
  "Terminal" in your applications menu.
- **Windows:**
  Press `Win + R`, type `cmd` or `powershell`, and press Enter.
  Alternatively, search "Terminal" or "Command Prompt" in the Start menu.
- **macOS:**
  Press `Cmd + Space` to open Spotlight, type "Terminal", and press Enter.
  Or find it in Applications → Utilities → Terminal.

On Linux and macOS, this will usually open the Bourne Again SHell, or
"bash" for short. This is one of the most widely used shells, and its
syntax is similar to what you will see in many other shells. On Windows,
you'll be greeted by the "batch" or "powershell" shells, depending on
which command you ran. These are Windows-specific, and not what we'll be
focusing on in this class, although it has analogues for most of what
we'll be teaching. You'll instead want the [Windows Subsystem for
Linux](https://docs.microsoft.com/en-us/windows/wsl/) or a Linux virtual
machine.

Other shells exist, often with many ergonomic improvements over bash
(fish and zsh are among the most common). While these are very popular
(all the instructors use one), they're nowhere near as ubiquitous as
bash, and lean on many of the same concepts, so we won't be focusing on
those in this lecture.

## Why should you care about it?

The shell is not just (usually) much faster than "clicking around", it
also comes with expressive power you can't easily find in any one
graphical program. As we'll see, the shell gives you the ability to
_combine_ programs in creative ways to automate nearly any task.

Knowing your way around a shell is also very useful to navigate the
world of open-source software (which often come with install
instructions that require the shell), building continuous integration
for your software projects (as described in the "Code Quality" lecture),
and debugging errors when other programs fail.

## Navigating in the shell

When you launch your terminal, you will see a _prompt_ that often looks
a little like this:

```console
missing:~$
```

This is the main textual interface to the shell. It tells you that you
are on the machine `missing` and that your "current working directory",
or where you currently are, is `~` (short for "home"). The `$` tells you
that you are not the root user (more on that later). At this prompt you
can type a _command_, which will then be interpreted by the shell. The
most basic command is to execute a program:

```console
missing:~$ date
Fri 10 Jan 2020 11:49:31 AM EST
missing:~$
```

Here, we executed the `date` program, which (perhaps unsurprisingly)
prints the current date and time. The shell then asks us for another
command to execute. We can also execute a command with _arguments_:

```console
missing:~$ echo hello
hello
```

In this case, we told the shell to execute the program `echo` with the
argument `hello`. The `echo` program simply prints out its arguments.
The shell parses the command by splitting it by whitespace, and then
runs the program indicated by the first word, supplying each subsequent
word as an argument that the program can access. If you want to provide
an argument that contains spaces or other special characters (e.g., a
directory named "My Photos"), you can either quote the argument with `'`
or `"` (`"My Photos"`), or escape just the relevant characters with `\`
(`My\ Photos`).

Perhaps the most important command when you're starting out is `man`,
short of "manual". The `man` program, among other things, lets you look
up more information about any command on your system. For example, if
you run `man date`, it'll explain what `date` is, and all of the various
arguments you can pass it to alter its behavior. You can also usually
get a short version of the help by passing `--help` as an argument to
most commands.

> Consider installing and using [`tldr`](https://tldr.sh/) in addition
> to `man`, as it shows you common usage examples right there in the
> terminal. LLMs are also usually very good at explaining how commands
> work and how you can call them to achieve what you want to accomplish.

After `man`, the most important command to learn is `cd`, or "change
directory". This command is actually built into the shell, and isn't a
separate program (i.e., `which cd` will say "no cd found"). You pass it
a path, and that path becomes your current working directory. You'll
also see the working directory reflected in the shell prompt:

```console
missing:~$ cd /bin
missing:/bin$ cd /
missing:/$ cd ~
missing:~$
```

> Note that the shell comes with auto-completion, so you can often
> complete paths faster by pressing `<TAB>`!

A lot of commands operate on the current working directory if nothing
else is specified. If you're ever unsure where you are, you can run
`pwd` or print the `$PWD` environment variable, both of which produce
the current working directory.

The current working directory also come in handy in that it allows us to
use _relative_ paths. All the paths we've seen so far have been
_absolute_ --- they start with `/` and give the full set of directories
needed to navigate to some location from the root of the file system
(`/`). In practice, you'll more commonly work with relative paths; so
called because they are relative to the current working directory. In a
relative path (anything _not_ starting with `/`), the first path
component is looked up in the current working directory, and subsequent
components traverse as usual. For example:

```console
missing:~$ cd /
missing:/$ cd bin
missing:/bin$
```

There are also two "special" components that exist in every directory:
`.` and `..`. `.` is "this directory", and `..` is "the parent
directory". So:

```console
missing:~$ cd /
missing:/$ cd bin/../bin/../bin/././../bin/..
missing:/$
```

You can usually use absolute and relative paths interchangeably for any
command argument, just keep in mind what your current working directory
is when using a relative one!

> Consider installing and using
> [`zoxide`](https://github.com/ajeetdsouza/zoxide) to speed up your
> `cd`ing --- `z` will remember the paths you frequently visit and let
> you access with less typing.

## What is available in the shell?

But how does the shell know how to find programs like `date` or `echo`?
If the shell is asked to execute a command, it consults an _environment
variable_ called `$PATH` that lists which directories the shell should
search for programs when it is given a command:

```console
missing:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
missing:~$ which echo
/bin/echo
missing:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

When we run the `echo` command, the shell sees that it should execute
the program `echo`, and then searches through the `:`-separated list of
directories in `$PATH` for a file by that name. When it finds it, it
runs it (assuming the file is _executable_; more on that later). We can
find out which file is executed for a given program name using the
`which` program. We can also bypass `$PATH` entirely by giving the
_path_ to the file we want to execute.

This also gives a clue for how we can determine _all_ the programs we're
able to execute in the shell: by listing the contents of all the
directories on `$PATH`. We can do this by passing a given directory path
to the `ls` program, which lists files:

```console
missing:~$ ls /bin
```

> Consider installing and using [`eza`](https://eza.rocks/) for a more
> human-friendly `ls`.

This will, on most computers, print a _lot_ of programs, but we'll only
focus on some of the most important ones here. First, some simple ones:

- `cat file`, which prints the contents `file`.
- `sort file`, which prints out the lines of `file` in sorted order.
- `uniq file`, which eliminate consecutive duplicate lines from `file`.
- `head file` and `tail file`, which respectively print the first and
  last few lines of `file`.

> Consider installing and using [`bat`](https://github.com/sharkdp/bat)
> over `cat` for syntax highlighting and scrolling.

There's also `grep pattern file`, which finds lines matching `pattern`
in `file`. This one deserves slightly more attention as it's both _very_
useful and sports a wider array of features than one may expect.
`pattern` is actually a _regular expression_ which can express very
complex patterns --- we'll cover those in the editor lecture. You can
also specify a directory instead of a file (or leave it off for `.`) and
pass `-r` to recursively search all the files in a directory.

> Consider installing and using
> [`ripgrep`](https://github.com/BurntSushi/ripgrep) over `grep` for a
> faster and more human-friendly (but less portable) alternative.
> `ripgrep` will also recursively search the current working directory
> by default!

There are also some very useful tools with a slightly more complicated
interface. First among those is `sed`, which is a programmatic file
editor. It has its own programming language for making automated edits
to files, but the most common use of it is:

```console
missing:~$ sed -i 's/pattern/replacement/g' file
```

This replaces all instances of `pattern` with `replacement` in `file`.
The `-i` indicates that we want the substitutions to happen inline (as
opposed to leaving `file` unmodified and printing the substituted
contents). The `s/` is the way to express in the sed programming
language that we want to do a substitution. The `/` separates the
pattern from the replacement. And the trailing `/g` indicates that we
want to replace _all_ occurrences on each line rather than just the
first. As with `grep`, `pattern` here is a regular expression, which
gives you significant expressive power. Regular expression substitutions
also allow `replacement` to refer back to parts of the matched pattern;
we'll see an example of that in a second.

Next, we have `find`, which lets you find files (recursively) that match
certain conditions. For example:

```console
missing:~$ find ~/Downloads -type f -name "*.zip" -mtime +30
```

Finds ZIP files in the download directory that are older than 30 days.

```console
missing:~$ find ~ -type f -size +100M -exec ls -lh {} \;
```

Finds files larger than 100M in your home directory and lists them. Note
that `-exec` takes a _command_ terminated with a stand-alone `;` (which
we need to escape much like a space) where `{}` is replaced with each
matching file path by `find`.

```console
missing:~$ find . -name "*.py" -exec grep -l "TODO" {} \;
```

Finds any `.py` files with TODO items in them.

The syntax of `find` can be a little daunting, but hopefully this gives
you a sense of how useful it can be!

> Consider installing and using [`fd`](https://github.com/sharkdp/fd)
> instead of `find` for a more human-friendly (but less portable!)
> experience.

Next on the docket is `awk`, which, like `sed`, has its own programming
language. Where `sed` is built for editing files, `awk` is built for
parsing them. By far the most common use of `awk` is for data files with
a regular syntax (like CSV files) where you want to extract only certain
parts of every record (i.e., line):

```console
missing:~$ awk '{print $2}' file
```

Prints the second whitespace-separated column of every line of `file`.
If you add `-F,`, it'll print the second command-separated column of
every line. But there's a lot more beneath the surface of `awk`:

```console
missing:~$ awk '$3 ~ /pattern/ {$4=""; print $0}' file
```

Prints only lines of `file` where the third column value matches
`pattern` (a regular expression again!), while stripping out the fourth
column value.

Putting this (and more) together, we can do fancy things like:

```console
missing:~$ ssh myserver 'journalctl -u sshd -b-1 | grep "Disconnected from"' \
  | sed -E 's/.*Disconnected from .* user (.*) [^ ]+ port.*/\1/' \
  | sort | uniq -c \
  | sort -nk1,1 | tail -n10 \
  | awk '{print $2}' | paste -sd,
postgres,mysql,oracle,dell,ubuntu,inspur,test,admin,user,root
```

This establishes a remote connection to `myserver` (we'll talk more
about `ssh` in the next lecture), grabs the SSH logs, searches for
disconnect messages, extracts the username from each such message, sorts
them, prints the unique usernames along with their counts, picks out the
top 10, and then prints the usernames comma-separated. All in one
command!

## The shell language (bash)

The previous example introduced a new concept: pipes (`|`). These let
you string together the output of one program with the input of another.
This works because most command-line programs will operate on their
"standard input" (where your keystrokes normally go) if no `file`
argument is given. `|` takes the "standard output" (what normally gets
printed to your terminal) of the program before the `|` and makes it be
the standard input of the program after the `|`. This allows you to
_compose_ shell programs, and it's part of what makes the shell such a
productive environment to work in!

In fact, most shells implement a full programming language (like bash),
just like Python or Ruby. It has variables, conditionals, loops, and
functions. When you run commands in your shell, you are really writing a
small bit of code that your shell interprets. We won't teach you all of
bash today, but there are some bits you'll find particularly useful:

First, redirects: `>file` lets you take the standard output of a program
and write it to `file` instead of to your terminal. This makes it easier
to analyze after the fact. `>>file` will append to `file` rather than
overwrite it. There's also `<file` which tells the shell to read from
`file` instead of from your keyboard as the standard input to a program.

Next, conditionals: `if command1; then command2; command3; fi` will
execute `command1`, and if it doesn't result in an error, will run
`command2` and `command3`. You can also have an `else` branch if you
wish. The most common command to use as `command1` is the `test`
command, often abbreviated simply as `[`, which lets you evaluate
conditions like "does a file exist" (`test -f file` / `[ -f file ]`) or
"does a string equal another" (`[ "$var" = "string" ]`). In bash,
there's also `[[ ]]`, which is a "safer" built-in version of `test` that
has fewer odd behaviours around quoting.

Bash also has two forms of loops, `while` and `for`. `while command1; do
command2; command3; done` functions just like the equivalent `if`
command, except that it will re-execute the whole thing over and over
for as long as `command1` does not error. `for varname in a b c d; do
command; done` executes `command` four times, each time with `$varname`
set to one of `a`, `b`, `c`, and `d`. Instead of listing the items
explicitly, you'll often use "command substitution", such as:

```bash
for i in $(seq 1 10); do
```

This executes the command `seq 1 10` (which prints the numbers from 1 to
10 inclusive) and then replaces the whole `$()` with that command's
output, giving you a 10-iteration for loop. In older code you'll
sometimes see literal backticks instead of `$()`, but you should
strongly prefer the `$()` form as it can be nested.

While you _can_ write long shell scripts directly in your prompt, you'll
usually want to write them into a `.sh` file instead. For example,
here's a script that will run a program in a loop until it fails,
printing the output only of the failed run, while stressing your CPU in
the background (useful to reproduce flaky tests for example):

```bash
#!/bin/bash
set -euo pipefail

# Start CPU stress in background
stress --cpu 8 &
STRESS_PID=$!

# Setup log file
LOGFILE="test_runs_$(date +%s).log"
echo "Logging to $LOGFILE"

# Run tests until one fails
RUN=1
while cargo test my_test >> "$LOGFILE" 2>&1; do
    echo "Run $RUN passed"
    ((RUN++))
done

# Cleanup and report
kill $STRESS_PID
echo "Test failed on run $RUN"
echo "Last 20 lines of output:"
tail -n 20 "$LOGFILE"
echo "Full log: $LOGFILE"
```

This has a number of new things in it that I recommend you spend some
time diving into, as they're very useful in crafting useful shell
invocations like background jobs (`&`) to run programs concurrently,
trickier [shell
redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html),
and [arithmetic
expansion](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html).

It's worth spending a second on the first two lines of the program
though. The first is the "shebang" -- you'll see this at the top of
other files than shell scripts too. When a file that starts with the
magic incantation `#!/path` is executed, the shell will start the
program at `/path`, and pass it the contents of the file as input. In
the case of a shell script, this means passing the contents of the shell
script to `/bin/bash`, but you can also write Python scripts with a
shebang line of `/usr/bin/python`!

The second line is a way to make bash "stricter", and mitigate a number
of footguns when writing shell scripts. `set` can take a whole lot of
arguments, but briefly: `-e` makes it so that if any command fails, the
script exits early; `-u` makes it so that use of undefined variables
crashes the script rather than just using an empty string; and `-o
pipefail` makes it so that if programs in a `|` sequence fail, the
shell script as a whole also exits early.

> Shell programming is a deep topic, just as any programming language
> is, but be warned: bash has an unusual number of gotchas, to the point
> that there are [multiple](https://tldp.org/LDP/abs/html/gotchas.html)
> websites dedicated to [listing them](https://mywiki.wooledge.org/BashPitfalls).
> I highly recommend making heavy use of
> [shellcheck](https://www.shellcheck.net/) when writing them. LLMs are
> also great at writing and debugging shell scripts, as well as
> translating them to a "real" programming language (like Python) when
> they've grown too unwieldy for bash (100+ lines).

# Next steps

At this point you know your way around a shell enough to accomplish
basic tasks. You should be able to navigate around to find files of
interest and use the basic functionality of most programs. In the next
lecture, we will talk about how to perform and automate more complex
tasks using the shell and the many handy command-line programs out
there.

# Exercises

All classes in this course are accompanied by a series of exercises.
Some give you a specific task to do, while others are open-ended, like
"try using X and Y programs". We highly encourage you to try them out.

We have not written solutions for the exercises. If you are stuck on
anything in particular, feel free to send us an email describing what
you've tried so far, and we will try to help you out.

{% comment %}
TODO:

1. For this course, you need to be using a Unix shell like Bash or ZSH. If you
   are on Linux or macOS, you don't have to do anything special. If you are on
   Windows, you need to make sure you are not running cmd.exe or PowerShell;
   you can use [Windows Subsystem for
   Linux](https://docs.microsoft.com/en-us/windows/wsl/) or a Linux virtual
   machine to use Unix-style command-line tools. To make sure you're running
   an appropriate shell, you can try the command `echo $SHELL`. If it says
   something like `/bin/bash` or `/usr/bin/zsh`, that means you're running the
   right program.
1. What does the `-l` flag (an argument that starts with a `-` is
   usually called a "flag") to `ls` do? What do the first 10 characters
   of each line of output mean?
1. In the command `find ~/Downloads -type f -name "*.zip" -mtime +30`,
   the `*.zip` is a "glob". What is a glob?
1. What happens if you add `-x` to the list of `set` flags?
1. Write a script that checks if a file exists using `test`/`[` and prints different messages
1. Modify the flaky test script to accept the test name as an argument
1. Why does `cd` have to be built into the shell itself rather than a
   standalone program?
1. `xargs`
1. `2>`
1. `$?`, `&&`, and `||`; https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html
{% endcomment %}
