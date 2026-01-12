---
layout: lecture
title: "Command-line Environment"
date: 2026-01-13
ready: true
---

{% comment %}
lecturer: Jose
{% endcomment %}

# Topic 2: The Command Line Environment

TODO: replace non-runnable examples with foo, bar, with sensible runnable versions whenever possible

## Shell Scripting

As we covered in the previous lecture, most shells are not a mere launcher to start up other programs, 
but in practice they provide an entire programming language full of common patterns and abstractions. 
However, unlike the majority of programming languages, in shell scripting everything is designed around running programs and getting them to communicate to other simply and efficiently. 

In particular, shell scripting is tightly bound by _conventions_. For a command line interface (CLI) program to play nicely within the broader shell environment there are some common patterns that it needs to follow. 
We will now cover many of the concepts required to understand how command line programs work as well as ubiquitious conventions on how use and configure them.

## The Command Line Interface

Writing a function in most programming languages looks like:

```
function add(x, y)
    return x + y
end
```

Here we can explicitly see the inputs and the outputs of the program.
In contrast, shell scripts can look quite different at first glance

```shell
#!/usr/bin/env bash
# TODO: verify, is this how we read stdin?

if [[-f $1]]; then
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

To properly understand what is going in scripts like this one we first need to introduce a few concepts that appear often when shell programs communicate with each other or with the shell environment:

- Arguments
- Buffers (TODO: check the proper name for this)
- Environment variables
- Return codes
- Signals

### Arguments

Shell programs receive a list of arguments when they are executed. 
Arguments are plain strings in shell, and it is up to the program how to interpret them.
For instance when we do `ls -l folder/`, we are executing the program `/bin/ls` with arguments `['-l', 'folder/']`.

From within a shell script we access these via special shell syntax.
To access the first argument we access the variable `$1`, second argument `$2` and so on and so forth until `$9`. To access all arguments as a list we use `$@` and to retrieve the number of arguments `$#`. Additionally we can also access the name of the program with `$0`.

For most programs the arguments will consist of a mixture of _flags_ and regular strings.
`flags` can be identified because they are preceeded by a dash (`-`) or double-dash (`--`). 
Flags are usually optional and their role is to modify the behavior of the program.
For example `ls -l` changes how `ls` formats its output.

You will see double dash flags with long names like `--list`, and single dash flags like `-l`, which are most often followed by a single letter.
The same option might be specified in both formats, `ls -l` and `ls --list` are equivalent.
the order in
And single dash flags are often grouped, `ls -l -a` and `ls -la` are also equivalent.
Some flags are quite prevalent and as you get more familiar with the shell environment you'll intuitively reach for them, for example (`--help`, `--verbose`, `--version`).

> Flags are a first good example of shell conventions. The shell language does not require that our program uses `-` or `--` in this particular way. 
Nothing prevents us from writing a program with syntax `myprogram +myoption myfile`, but it would lead to confusion since the expectation is that we use dashes.
> In practice, most programming languages provide CLI flag parsing libraries (e.g. `argparse` in python to parse arguments with the dash syntax).

Another common convention in CLI programs is for programs to accept the a variable number of arguments of the same type. When given arguments in this way the command  performs the same operation in each one of them. 

```shell
mkdir foo
mkdir bar
# is equivalent to
mkdir foo bar
```

This syntax sugar might seem unnecessary at first, but it becomes really powerful when combined with _globbing_. 
Globbing or globs are special patterns that the shell will expand before calling the program.

Say we wanted to delete all .py files in the current folder nonrecursively. From what we learned in the previous lecture we could achieve this by running

```shell
for file in $(ls | grep -P '.py$'); then 
    rm $file
done
```

But we can replace that with just `rm *.py`!

When we type `rm *.py` into the terminal, the shell will not call the `/bin/rm` program with arguments `['*.py']`.
Instead, the shell will search for files in the current folder matching the pattern `*.py` where `*` can match any string of zero or more characters of any type.
So if our folder has `foo.py` and `bar.py` then the `rm` program will receive arguments `['foo.py', 'bar.py']`.

The most common globs you will find are wildcards '*' (zero or more of anything), '?' (zero or one of anything) and curly braces.
Curly braces `{}` help you do expand

In practice, globs are best understood with motivating examples

```shell
convert image.{png,jpg}
# Will expand to
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# Will expand to
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# Globbing techniques can also be combined
mv *{.py,.sh} folder
# Will move all *.py and *.sh files
```

> Some shells (e.g. zsh) support even more advanced forms of globbing such as `**` that will expand to include  recursive paths. So `rm **/*.py` will delete all .py files recursively.


### Streams (TODO: check if these are buffer/stream/or other name)

Whenever we execute a program pipeline like 

```shell
cat myfile | grep -P '\d+' | uniq -c
```

we see that the `grep` program is communicating with both the `cat` and `uniq` programs.

An important observation here is that all three programs are executing at once. 
Namely, the shell is not first calling cat, then sort and then uniq.
Insted all three programs are being spawned and the shell is connecting the output of cat to the input of sort and the output of sort to the input of uniq.
When using the pipe operator `|`, the shell operates on streams of data that flow from one program to the next in the chain.

Every program has a input buffer, labeled stdin (for standard input). Whenever we want to access this stream within a script we use the following syntax

```shell
TODO: I don't know the syntax
```

Similarly, every program has two output buffers stdout and stderr.
The standard output is the one most commonly encountered and it is the one that is used for piping the output of the program to the next command in the pipeline.
The standard error is an alternative stream that is intended for programs to report warnings and other type of issues, without that output getting parsed by the next command in the chain.


The shell provides syntax for redirecting these streams, here are some illustrative examples

```shell
# TODO: examples with 2>, redirects with pipes, &| >> <file 
```

Any CLI tool that follows this rules. With enough care we can even get LLMs to interface . Here's an example with [`simonw/llm`](https://github.com/simonw/llm) program

```console
# TODO put here dog and cat breeds and fix multiline format
$ cat breeds.txt
# TODO: Sample outputs
INSTRUCTIONS="For each cat and dog breed in the input output dog or cat."
" Your output must consist of just lines with cat or dog, nothing else"
$ llm "$INSTRUCTIONS" < breeds.txt | sort | uniq -c
# TODO: sample output
```

Note how we are doing `"$INSTRUCTIONS"` instead of `$INSTRUCTIONS`. This is because the content of the variable contains spaces. With `< breeds.txt` we replace the llm command stdin with the content of the `breeds.txt file`. 


### Environment variables

To assign variables in bash we use the syntax `foo=bar`, and then access the value of the variable with the `$foo` syntax.
Note that `foo = bar` is invalid syntax as the shell will parse it as calling the program `foo` with arguments `['=', 'bar']`.
In shell scripting the role of the space character is to perform argument splitting. 
This behavior can be confusing and tricky to get used to, so keep it in mind.

Shell variables do not have types, they are all a strings.s
Note that when writing string expressions in the shell single and double quotes are not interchangeable.
Strings delimited with `'` are literal strings and will not perform string interpolation using variable values, whereas `"` delimited strings will.

```shell
foo=bar
echo "$foo"
# prints bar
echo '$foo'
# prints $foo
```

To capture the output of a command into a variable we use _command substitution_.
When we execute
```shell
files=$(ls)
echo $files | grep foo
echo $files | grep bar
```
the output (concretely the stdout) of ls is placed into the variable `$files` which we can access later.
The content of the `$files` variable does include the newlines from the ls output, which is how programs like `grep` know to operate on each item independently. 

A lesser known similar feature is _process substitution_, `<( CMD )` will execute `CMD` and place the output in a temporary file and substitute the `<()` with that file's name. 
This is useful when commands expect values to be passed by file instead of by STDIN. 
For example, `diff <(ls foo) <(ls bar)` will show differences between files in dirs  `foo` and `bar`.

Whenever a shell program calls another program it passes along a set of variables that are often referred to as _environment variables_.
From within a shell we can find the current environment variables by running `printenv`.
To pass an environment variable explicitly we can prepend a command with a variable assignment

```shell
DEBUG=1 cmd
echo $DEBUG # this will be empty, since DEBUG was only set for the child command
```

Alternatively, we can use the `export` built-in function that will modify our current environment and thus all children processes will 

```shell
export DEBUG=1
# All programs from this point onwards will have DEBUG=1 in their environment
ls -la
```

To delete a variable use the `unset` built-in command, e.g. `unset DEBUG`.

> Environment variables are another shell convention. They can be used to modify the behavior of many programs implicitly rather than explicitly. For example, the shell sets the $HOME environment variable with the path of the home folder of the current user. Then programs can access this variable to get this information instead of requiring a explicit `--home /home/alice`. (TODO: maybe mention another common envvar here)


## Return codes

As we saw earlier, the main output of a shell program is conveyed through the stdout/stderr buffers and filesystem side effects.

By default a shell script will return exit code zero.
The convention is that zero means everything went well whereas nonzero means some issues were encountered.
To return a nonzero exit code we have to use the `exit NUM` shell built-in.
We can access the return code of the last command that was run by accessing the special variable `$?`.

The shell has boolean operators '&&' and '||' for performing AND and OR operations respectively. 
Unlike those encountered in regular programming languages, the ones in the shell operate on the return code of programs.
Both of these are [short-circuiting](https://en.wikipedia.org/wiki/Short-circuit_evaluation) operators.
This means that they can be used to conditionally run commands based on the success or failure of previous commands, where sucess is determined based on whether the return code is zero or not. Some examples

```shell
# echo will only run if foo succeeds
foo && echo "Everything went well"

# echo will only run if foo fails
foo || echo "Something went wrong"

# true is a shell program that always succeeds,
true && echo "Everything went well"

# and false is a shell program that always fails
false || echo "Something went wrong"
```


### Signals

In some cases you will need to interrupt a program while it is executing, for instance if a command is taking too long to complete.
The simplest way to interrupt a program is to press `Ctrl-C` and the command will probably stop.
But how does this actually work and why does it sometimes fail to stop the process?

```console
$ sleep 100
^C
$
```

> Note, here `^` is how `Ctrl` is displayed when typed in the terminal.

Under the hood, what happened here is the following:

1. We pressed `Ctrl-C`
2. The shell identified the special combination of characters
3. The shell process sent a SIGINT signal to the `sleep` process
4. The signal interrupted the execution of the `sleep` process 

Signals are a special communication mechanism.
When a process receives a signal it stops its execution, deals with the signal and potentially changes the flow of execution based on the information that the signal delivered. For this reason, signals are _software interrupts_.


In our case, when typing `Ctrl-C` this prompts the shell to deliver a `SIGINT` signal to the process.
Here's a minimal example of a Python program that captures `SIGINT` and ignores it, no longer stopping. To kill this program we can now use the `SIGQUIT` signal instead, by typing `Ctrl-\`.

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

Here's what happens if we send `SIGINT` twice to this program, followed by `SIGQUIT`. Note that `^` is how `Ctrl` is displayed when typed in the terminal.

```
$ python sigint.py
24^C
I got a SIGINT, but I am not stopping
26^C
I got a SIGINT, but I am not stopping
30^\[1]    39913 quit       python sigint.py
```

While `SIGINT` and `SIGQUIT` are both usually associated with terminal related requests, a more generic signal for asking a process to exit gracefully is the `SIGTERM` signal.
To send this signal we can use the [`kill`](https://www.man7.org/linux/man-pages/man1/kill.1.html) command, with the syntax `kill -TERM <PID>`.

Signals can do other things beyond killing a process. For instance, `SIGSTOP` pauses a process. In the terminal, typing `Ctrl-Z` will prompt the shell to send a `SIGTSTP` signal, short for Terminal Stop (i.e. the terminal's version of `SIGSTOP`).

We can then continue the paused job in the foreground or in the background using [`fg`](https://www.man7.org/linux/man-pages/man1/fg.1p.html) or [`bg`](http://man7.org/linux/man-pages/man1/bg.1p.html), respectively.

The [`jobs`](https://www.man7.org/linux/man-pages/man1/jobs.1p.html) command lists the unfinished jobs associated with the current terminal session.
You can refer to those jobs using their pid (you can use [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) to find that out).
More intuitively, you can also refer to a process using the percent symbol followed by its job number (displayed by `jobs`). To refer to the last backgrounded job you can use the `$!` special parameter.

One more thing to know is that the `&` suffix in a command will run the command in the background, giving you the prompt back, although it will still use the shell's STDOUT which can be annoying (use shell redirections in that case).

To background an already running program you can do `Ctrl-Z` followed by `bg`.
Note that backgrounded processes are still children processes of your terminal and will die if you close the terminal (this will send yet another signal, `SIGHUP`).
To prevent that from happening you can run the program with [`nohup`](https://www.man7.org/linux/man-pages/man1/nohup.1.html) (a wrapper to ignore `SIGHUP`), or use `disown` if the process has already been started.
Alternatively, you can use a terminal multiplexer as we will see in the next section.

Below is a sample session to showcase some of these concepts.

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

$ bg %1
[1]  - 18653 continued  sleep 1000

$ jobs
[1]  - running    sleep 1000
[2]  + running    nohup sleep 2000

$ kill -STOP %1
[1]  + 18653 suspended (signal)  sleep 1000

$ jobs
[1]  + suspended (signal)  sleep 1000
[2]  - running    nohup sleep 2000

$ kill -SIGHUP %1
[1]  + 18653 hangup     sleep 1000

$ jobs
[2]  + running    nohup sleep 2000

$ kill -SIGHUP %2

$ jobs
[2]  + running    nohup sleep 2000

$ kill %2
[2]  + 18745 terminated  nohup sleep 2000

$ jobs

```

A special signal is `SIGKILL` since it cannot be captured by the process and it will always terminate it immediately. However, it can have bad side effects such as leaving orphaned children processes.

You can learn more about these and other signals [here](https://en.wikipedia.org/wiki/Signal_(IPC)) or typing [`man signal`](https://www.man7.org/linux/man-pages/man7/signal.7.html) or `kill -l`.

TODO: Explain `trap`

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

  Remove e[x]ecutable rights from the [g]roup:

      chmod g-x path/to/file

  Give [a]ll users rights to [r]ead and e[x]ecute:

      chmod a+rx path/to/file

  Give [o]thers (not in the file owner's group) the same rights as the [g]roup:

      chmod o=g path/to/file

  Remove all rights from [o]thers:

      chmod o= path/to/file

  Change permissions recursively giving [g]roup and [o]thers the ability to [w]rite:

      chmod -R g+w,o+w path/to/directory

  Recursively give [a]ll users [r]ead permissions to files and e[X]ecute permissions to sub-directories within a directory:

      chmod -R a+rX path/to/directory
```

> Your shell might tell you that something like `command not found: tldr`. That is because it is a more modern tool and it is not pre-installed in most OS. A good reference for how to install tools is the [https://command-not-found.com](https://command-not-found.com) website. It contains instructions for a huge collection of cli tools for popular OS distributions.

Each program is run as a specific user in the system, we can use the `whoami` command to find our user name and the `id -u` for find our UID (user id) which is the associated integer value that the OS associates with the user.

When running `sudo command`, the `command` is run as the root user which can bypass most permissions in the system. 
Try running `sudo whoami` and `sudo id -u` to see how the output changes (you might be prompted for your password).
To change the owner of a file or folder, we use the `chown` command.

You can learn more about UNIX file permissions [here](TODO: find link)



# Remote Machines

It has become more and more common for programmers to work with remote servers in their everyday work. The most common tool for the job here is SSH (Secure Shell) which will help us connect to a remote server and provide the now familiar shell interface. We connect to a server with a command like:

```bash
ssh foo@bar.mit.edu
```

Here we are trying to ssh as user `foo` in server `bar.mit.edu`.

An often overlooked feature of `ssh` is the ability to run commands non-interactively. `ssh` correctly handles sending the stdin and receiving the stdout of the command, so we can combine it with other commands

```shell
# here ls runs in the remote, and wc runs locally
ssh foobar@server ls | wc -l

# here both ls and wc run in the server 
ssh 'foobar@server ls | grep foo'

```

> Try installing [Mosh](https://mosh.org/) as a SSH replacement that can handle disconnections, entering/exit sleep, changing networks and dealing with high latency links.

For `ssh` to let us run commands in the remote server we need to prove that we are authorized to do so. 
We can do this via passwords or ssh keys.
Key-based authentication utilizes public-key cryptography to prove to the server that the client owns the secret private key without revealing the key. 
Key based authentication is both more convenient and more secure, so you should prefer it.
Note that the private key (often `~/.ssh/id_rsa` and more recently `~/.ssh/id_ed25519`) is effectively your password, so treat it like so, and don't put its content

To generate a pair you can run [`ssh-keygen`](https://www.man7.org/linux/man-pages/man1/ssh-keygen.1.html).
```bash
ssh-keygen -a 100 -t ed25519 -f ~/.ssh/id_ed25519
```

If you have ever configured pushing to GitHub using SSH keys, then you have probably done the steps outlined [here](https://help.github.com/articles/connecting-to-github-with-ssh/) and have a valid key pair already. To check if you have a passphrase and validate it you can run `ssh-keygen -y -f /path/to/key`.

At the server side `ssh` will look into `.ssh/authorized_keys` to determine which clients it should let in. To copy a public key over you can use:

```bash
cat .ssh/id_ed25519.pub | ssh foobar@remote 'cat >> ~/.ssh/authorized_keys'

# or equivalently if ssh-copy-id is available

ssh-copy-id -i .ssh/id_ed25519 foobar@remote
```

Beyond running commands, the connection that ssh establishes can be used to transfer file from and to the server securely. [`scp`](https://www.man7.org/linux/man-pages/man1/scp.1.html)  is the most traditional tool and the   syntax is `scp path/to/local_file remote_host:path/to/remote_file`. [`rsync`](https://www.man7.org/linux/man-pages/man1/rsync.1.html) improves upon `scp` by detecting identical files in local and remote, and preventing copying them again. It also provides more fine grained control over symlinks, permissions and has extra features like the `--partial` flag that can resume from a previously interrupted copy. `rsync` has a similar syntax to `scp`.

SSH client configuration is located at `~/.ssh/config` and it let us effectively declare hosts and set the default settings for them. This configuration file is not just read by `ssh` but also other programs like `scp`, `rsync`, `mosh`, &c

```bash
Host vm
    User foobar
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519

# Configs can also take wildcards
Host *.mit.edu
    User foobaz
```




# Terminal Multiplexers

As your command line workflows become increasingly complex, 

When using the command line interface you will often want to run more than one thing at once.
For instance, you might want to run your editor and your program side by side.
Although this can be achieved by opening new terminal windows, using a terminal multiplexer is a more versatile solution.

Terminal multiplexers like [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) allow you to multiplex terminal windows using panes and tabs so you can interact with multiple shell sessions in an efficient manner.
Moreover, terminal multiplexers let you detach a current terminal session and reattach at some point later in time.
Because of this, terminal multiplexers are really convenient when working with remote machines, as it avoids the need to use `nohup` and similar tricks.

The most popular terminal multiplexer these days is [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html). `tmux` is highly configurable and by using the associated keybindings you can create multiple tabs and panes and quickly navigate through them.

`tmux` expects you to know its keybindings, and they all have the form `<C-b> x` where that means (1) press `Ctrl+b`, (2) release `Ctrl+b`, and then (3) press `x`. `tmux` has the following hierarchy of objects:
- **Sessions** - a session is an independent workspace with one or more windows
    + `tmux` starts a new session.
    + `tmux new -s NAME` starts it with that name.
    + `tmux ls` lists the current sessions
    + Within `tmux` typing `<C-b> d`  detaches the current session
    + `tmux a` attaches the last session. You can use `-t` flag to specify which

- **Windows** - Equivalent to tabs in editors or browsers, they are visually separate parts of the same session
    + `<C-b> c` Creates a new window. To close it you can just terminate the shells doing `<C-d>`
    + `<C-b> N` Go to the _N_ th window. Note they are numbered
    + `<C-b> p` Goes to the previous window
    + `<C-b> n` Goes to the next window
    + `<C-b> ,` Rename the current window
    + `<C-b> w` List current windows

- **Panes** - Like vim splits, panes let you have multiple shells in the same visual display.
    + `<C-b> "` Split the current pane horizontally
    + `<C-b> %` Split the current pane vertically
    + `<C-b> <direction>` Move to the pane in the specified _direction_. Direction here means arrow keys.
    + `<C-b> z` Toggle zoom for the current pane
    + `<C-b> [` Start scrollback. You can then press `<space>` to start a selection and `<enter>` to copy that selection.
    + `<C-b> <space>` Cycle through pane arrangements.

> To learn more about tmux, consider reading [this](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) quick tutorial  and [this](http://linuxcommand.org/lc3_adv_termmux.php) more detailed explanation.


# Configuring the CLI environment

Shell scripting is designed with configurability and ease of use in mind. Most aspects of your shell can be configured. 

We can start with a simple change, adding new locations for the shell to find programs. THis is a rather common pattern and you will encounter it when installing software with the cli

```shell
export PATH="$PATH:path/to/append"
```
Here, we are telling the shell to set the value of the $PATH variable to its current value plus a new path, and have all children processes inherit this new value for PATH.
This will allow children processes to find programs located under `/path/to/append`.


TODO: 


We can also create our own command aliases using the `alias` shell built-in. 
A shell alias is a short form for another command that your shell will replace automatically before evaluting the expression. 
For instance, an alias in bash has the following structure:

```bash
alias alias_name="command_to_alias arg1 arg2"
```

> Note that there is no space around the equal sign `=`, because [`alias`](https://www.man7.org/linux/man-pages/man1/alias.1p.html) is a shell command that takes a single argument.

Aliases have many convenient features:

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

Alias have limitations in 


To make an alias persistent you need to include it in shell startup files, like `.bashrc` or `.zshrc`, which we are going to introduce in the next section.


However, these previous modifications will not persist our shell session. 
Namely, we would have to rerun them on every new shell to be able to use them.
To make the change persistent we need to modify the shell configuration file, which is read upon startup.

# Dotfiles

A wide array command line programs are configured using plain-text files known as _dotfiles_
(because the file names begin with a `.`, e.g. `~/.vimrc`, so that they are
hidden in the directory listing `ls` by default).

> Dotfiles are yet another shell convention. The dot in the front is to "hide" them when listing (yes, another convention). 

Shells are one example of programs configured with such files. On startup, your shell will read many files to load its configuration.
Depending on the shell, whether you are starting a login and/or interactive the entire process can be quite complex.
[Here](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) is an excellent resource on the topic.

For `bash`, editing your `.bashrc` or `.bash_profile` will work in most systems.
Here you can include commands that you want to run on startup, like the alias we just described or modifications to your `PATH` environment variable like we saw before.

Some other examples of tools that can be configured through dotfiles are:

- `bash` - `~/.bashrc`, `~/.bash_profile`
- `git` - `~/.gitconfig`
- `vim` - `~/.vimrc` and the `~/.vim` folder
- `ssh` - `~/.ssh/config`
- `tmux` - `~/.tmux.conf`

How should you organize your dotfiles? They should be in their own folder,
under version control, and **symlinked** into place using a script. This has
the benefits of:

- **Easy installation**: if you log in to a new machine, applying your
customizations will only take a minute.
- **Portability**: your tools will work the same way everywhere.
- **Synchronization**: you can update your dotfiles anywhere and keep them all
in sync.
- **Change tracking**: you're probably going to be maintaining your dotfiles
for your entire programming career, and version history is nice to have for
long-lived projects.

What should you put in your dotfiles?
You can learn about your tool's settings by reading online documentation or
[man pages](https://en.wikipedia.org/wiki/Man_page). Another great way is to
search the internet for blog posts about specific programs, where authors will
tell you about their preferred customizations. Yet another way to learn about
customizations is to look through other people's dotfiles: you can find tons of
[dotfiles
repositories](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories)
on GitHub --- see the most popular one
[here](https://github.com/mathiasbynens/dotfiles) (we advise you not to blindly
copy configurations though).
[Here](https://dotfiles.github.io/) is another good resource on the topic.

All of the class instructors have their dotfiles publicly accessible on GitHub: [Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/jjgo/dotfiles).


# AI

TODO: Section with message: "There are many ways to incorporate AI tooling in the shell. From helping launch commands (show example with simonw llm cmd), to using AI within the pipeline (move llm command with dogs/cats from earlier here), running a terminal emulator with AI autocomplete like Warp, to using something like Claude Code as a meta shell that accepts English commands

# Terminal Emulators

Along with customizing your shell, it is worth spending some time figuring out your choice of **terminal emulator** and its settings. 
A terminal emulator is a GUI program that (TODO: finish this)
There are many many terminal emulators out there (here is a [comparison](https://anarc.at/blog/2018-04-12-terminal-emulators-1/)) - TODO: replace with more recent comparison.

Since you might be spending hundreds to thousands of hours in your terminal it pays off to look into its settings. Some of the aspects that you may want to modify in your terminal include:

- Font choice
- Color Scheme
- Keyboard shortcuts
- Tab/Pane support
- Scrollback configuration
- Performance (some newer terminals like [Alacritty](https://github.com/jwilm/alacritty) or [Ghostty](TODO:link) offer GPU acceleration).



# Exercises (TODO: group them by topic and sort them by the order they appear in the lecture, prepend bold labels)
TODO: maybe add a few more short exercises on topics missing them

1. you might see `cmd --flag -- --notaflag` pattern. TODO: finish

2. Run the following three commands, reason about what the first command is doing and the output of the third command

<!-- ```shell
mkdir foo bar
touch {foo,bar}/{a..h}
touch foo/x bar/y
diff <(ls foo) <(ls bar)
``` -->

1. For shell programs that do no support a variable number of inputs you can use `xargs -0` (TODO: check flag) to get a similar behavior succintly. (TODO: should this be an exercise?)


2. TODO: Exercise on `true` and `false`, why do they exist?

1. Read [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) and write an `ls` command that lists files in the following manner

    - Includes all files, including hidden files
    - Sizes are listed in human readable format (e.g. 454M instead of 454279954)
    - Files are ordered by recency
    - Output is colorized

    A sample output would look like this

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

1. Write bash functions  `marco` and `polo` that do the following.
Whenever you execute `marco` the current working directory should be saved in some manner, then when you execute `polo`, no matter what directory you are in, `polo` should `cd` you back to the directory where you executed `marco`.
For ease of debugging you can write the code in a file `marco.sh` and (re)load the definitions to your shell by executing `source marco.sh`.

{% comment %}
marco() {
    export MARCO=$(pwd)
}

polo() {
    cd "$MARCO"
}
{% endcomment %}

1. Say you have a command that fails rarely. In order to debug it you need to capture its output but it can be time consuming to get a failure run.
Write a bash script that runs the following script until it fails and captures its standard output and error streams to files and prints everything at the end.
Bonus points if you can also report how many runs it took for the script to fail.

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

1. As we covered in the lecture `find`'s `-exec` can be very powerful for performing operations over the files we are searching for.
However, what if we want to do something with **all** the files, like creating a zip file?
As you have seen so far commands will take input from both arguments and STDIN.
When piping commands, we are connecting STDOUT to STDIN, but some commands like `tar` take inputs from arguments.
To bridge this disconnect there's the [`xargs`](https://www.man7.org/linux/man-pages/man1/xargs.1.html) command which will execute a command using STDIN as arguments.
For example `ls | xargs rm` will delete the files in the current directory.

    Your task is to write a command that recursively finds all HTML files in the folder and makes a zip with them. Note that your command should work even if the files have spaces (hint: check `-d` flag for `xargs`).
    {% comment %}
    find . -type f -name "*.html" | xargs -d '\n'  tar -cvzf archive.tar.gz
    {% endcomment %}

    If you're on macOS, note that the default BSD `find` is different from the one included in [GNU coreutils](https://en.wikipedia.org/wiki/List_of_GNU_Core_Utilities_commands). You can use `-print0` on `find` and the `-0` flag on `xargs`. As a macOS user, you should be aware that command-line utilities shipped with macOS may differ from the GNU counterparts; you can install the GNU versions if you like by [using brew](https://formulae.brew.sh/formula/coreutils).

1. (Advanced) Write a command or script to recursively find the most recently modified file in a directory. More generally, can you list all files by recency?



1. From what we have seen, we can use some `ps aux | grep` commands to get our jobs' pids and then kill them, but there are better ways to do it. Start a `sleep 10000` job in a terminal, background it with `Ctrl-Z` and continue its execution with `bg`. Now use [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) to find its pid and [`pkill`](http://man7.org/linux/man-pages/man1/pgrep.1.html) to kill it without ever typing the pid itself. (Hint: use the `-af` flags).

1. Say you don't want to start a process until another completes. How would you go about it? In this exercise, our limiting process will always be `sleep 60 &`.
One way to achieve this is to use the [`wait`](https://www.man7.org/linux/man-pages/man1/wait.1p.html) command. Try launching the sleep command and having an `ls` wait until the background process finishes.

    However, this strategy will fail if we start in a different bash session, since `wait` only works for child processes. One feature we did not discuss in the notes is that the `kill` command's exit status will be zero on success and nonzero otherwise. `kill -0` does not send a signal but will give a nonzero exit status if the process does not exist.
    Write a bash function called `pidwait` that takes a pid and waits until the given process completes. You should use `sleep` to avoid wasting CPU unnecessarily.

1. Follow this `tmux` [tutorial](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) and then learn how to do some basic customizations following [these steps](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/).

1. Create an alias `dc` that resolves to `cd` for when you type it wrong.

1.  Run `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10`  to get your top 10 most used commands and consider writing shorter aliases for them. Note: this works for Bash; if you're using ZSH, use `history 1` instead of just `history`.


Let's get you up to speed with dotfiles.
1. Create a folder for your dotfiles and set up version
   control.
1. Add a configuration for at least one program, e.g. your shell, with some
   customization (to start off, it can be something as simple as customizing your shell prompt by setting `$PS1`).
1. Set up a method to install your dotfiles quickly (and without manual effort) on a new machine. This can be as simple as a shell script that calls `ln -s` for each file, or you could use a [specialized
   utility](https://dotfiles.github.io/utilities/).
1. Test your installation script on a fresh virtual machine.
1. Migrate all of your current tool configurations to your dotfiles repository.
1. Publish your dotfiles on GitHub.

Install a Linux virtual machine (or use an already existing one) for this exercise. If you are not familiar with virtual machines check out [this](https://hibbard.eu/install-ubuntu-virtual-box/) tutorial for installing one.

1. Go to `~/.ssh/` and check if you have a pair of SSH keys there. If not, generate them with `ssh-keygen -a 100 -t ed25519`. It is recommended that you use a password and use `ssh-agent` , more info [here](https://www.ssh.com/ssh/agent).
1. Edit `.ssh/config` to have an entry as follows

    ```bash
    Host vm
        User username_goes_here
        HostName ip_goes_here
        IdentityFile ~/.ssh/id_ed25519
        LocalForward 9999 localhost:8888
    ```
1. Use `ssh-copy-id vm` to copy your ssh key to the server.
1. Start a webserver in your VM by executing `python -m http.server 8888`. Access the VM webserver by navigating to `http://localhost:9999` in your machine.
1. Edit your SSH server config by doing  `sudo vim /etc/ssh/sshd_config` and disable password authentication by editing the value of `PasswordAuthentication`. Disable root login by editing the value of `PermitRootLogin`. Restart the `ssh` service with `sudo service sshd restart`. Try sshing in again.
1. (Challenge) Install [`mosh`](https://mosh.org/) in the VM and establish a connection. Then disconnect the network adapter of the server/VM. Can mosh properly recover from it?
1. (Challenge) Look into what the `-N` and `-f` flags do in `ssh` and figure out a command to achieve background port forwarding.


{% comment %}
lecturer: Jose

- shell environment
    - environment variables, PATH
    - aliases
    - job control (Ctrl-C, Ctrl-Z, bg, fg, jobs)
    - fzf
- tmux
- ssh, keys
- customizing your shell and tools, dotfiles
- atuin
- AI shell
    - https://www.warp.dev/
    - https://github.com/eliyastein/llm-zsh-plugin
    - https://github.com/day50-dev/Zummoner
{% endcomment %}
