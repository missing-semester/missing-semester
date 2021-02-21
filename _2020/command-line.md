---
layout: lecture
title: "コマンドライン環境"
date: 2020-01-21
ready: true
video:
  aspect: 56.25
  id: e8BO_dYxk5c
---

この講義では、シェルを使ったワークフローを改善できる方法をいくつか見ていきます。ここまでしばらくシェルを使ってきましたが、主に様々なコマンドの実行に注目してきました。ここからは、複数のプロセスを監視しつつ同時に走らせる方法、特定のプロセスを一時停止または中断する方法、プロセスをバックグラウンドで走らせる方法を見ていきます。

さらに、シェルやその他のツールを、エイリアスを定義したりドットファイルで設定したりして、改善していく様々な方法を見ていきます。この双方が時間の節約になるでしょう。例えば、長いコマンドを打つことなく、自分のマシン全てで同じ設定を使えるようになります。SSHを使ってリモートマシンで作業する方法も見ていきます。


# ジョブコントロール

ジョブの実行中に中断する必要が出てくるケースがあります。例えば、コマンドが完了までに時間がかかりすぎる場合などです（`find`でとても巨大なディレクトリ構造を検索する場合など）。
ほとんどの場合、`Ctrl-C`でコマンドは停止します。
ですがこれは、実際にどのように機能しているのでしょうか、そしてプロセスの停止に失敗することがあるのはなぜでしょうか？

## プロセスの停止（kill）

シェルは、 _シグナル_ と呼ばれるUNIXのコミュニケーションメカニズムを使用し、処理する情報を通信しています。プロセスがシグナルを受け取ると、そのシグナルが伝える情報に基づき、実行を停止し、シグナルに対処し、実行フローを潜在的に変更します。そのため、シグナルは _ソフトウェア的中断_ です。

このケースでは、`Ctrl-C`とタイプすると、シェルが`SIGINT`シグナルをプロセスに伝達します。

以下はPythonプログラムの最小例です。これは`SIGINT`をキャプチャし、無視し、停止しません。このプログラムを停止するには、代わりに`Ctrl-\`とタイプして、`SIGQUIT`を使用する必要があります。

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

このプログラムに`SIGINT`を2回送信し、続いて`SIGQUIT`を送信すると、以下が発生します。`^`は`Ctrl`がターミナルにタイプされたときに表示される文字です。

```
$ python sigint.py
24^C
I got a SIGINT, but I am not stopping
26^C
I got a SIGINT, but I am not stopping
30^\[1]    39913 quit       python sigint.py
```

`SIGINT`と`SIGQUIT`は両方とも通常はターミナルに関連したリクエストに関連づけられます。一方で、プロセスが完璧に終了するように命令するより一般的シグナルが`SIGTERM`です。
このシグナルを送るには [`kill`](https://www.man7.org/linux/man-pages/man1/kill.1.html) コマンドを使用します。シンタックスは`kill -TERM <PID>`です。

## 一時停止とバックグラウンドプロセス

シグナルがプロセスを停止する他にも様々なことができます。例えば、`SIGSTOP`はプロセスを一時停止します。ターミナルで`Ctrl-Z`と入力すると、シェルに`SIGTSTP`シグナルを送るよう指示します。これはTerminal Stopの省略です（つまり`SIGSTOP`のターミナル版ということです）。

一時停止したジョブは[`fg`](https://www.man7.org/linux/man-pages/man1/fg.1p.html) または [`bg`](http://man7.org/linux/man-pages/man1/bg.1p.html) を使用して、それぞれフォアグラウンドやバックグラウンドで継続できます。

[`jobs`](https://www.man7.org/linux/man-pages/man1/jobs.1p.html) コマンドは、現在のターミナルセッションに関連付けられた未完了のジョブをリスト表示します。
これらのジョブはプロセスIDを使用して参照できます（プロセスIDは [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) で調べられます）。
さらに直感的に、プロセスはパーセント記号に続くジョブ番号でも参照できます（`jobs`で表示されます）。最新のバックグラウンドジョブは、特別な`$!`で参照できます。

もう一つ知っておくべきことは、コマンドに接尾辞`&`をつけると、そのコマンドをバックグラウンドで実行し、プロンプトを表示することです。これは変わらずシェルのSTDOUTを使用するので、鬱陶しく感じるかもしれません（その場合はシェルのリダイレクトを使いましょう）。

既に実行中のプログラムをバックグラウンドに移動するには、`Ctrl-Z`の後に`bg`を入力しましょう。バックグラウンドプロセスはターミナルの子プロセスのままで、ターミナルを閉じると消滅することをお忘れなく（これはまた別のシグナル、`SIGHUP`を送信します）。
これが起きるのを防ぐためには、プログラムを[`nohup`](https://www.man7.org/linux/man-pages/man1/nohup.1.html) （`SIGHUP`を無視するラッパー）と一緒に実行するか、またはプロセスが既に開始している場合は`disown`を使いましょう。
他の方法として、次のセクションで紹介するターミナルマルチプレクサも使用できます。

以下は、これらのコンセプトのいくつかを示すためのセッション例です。

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

特別なシグナルは`SIGKILL`で、これはプロセスでキャプチャできず、どんな時でもプロセスを即時終了します。しかし、孤児プロセスを残してしまうなどの悪影響もあります。

これらや他のシグナルは [こちら](https://en.wikipedia.org/wiki/Signal_(IPC)) 、または [`man signal`](https://www.man7.org/linux/man-pages/man7/signal.7.html) もしくは`kill -t`と入力することで詳細を表示できます。


# ターミナルマルチプレクサ

コマンドラインインターフェイスの使用中、複数のプロセスを走らせたいと思うことがしばしばあるでしょう。
例えば、エディタをプログラムと並べて走らせたい場合などです。
これは新しいターミナルウィンドウを開くことで達成できますが、ターミナルマルチプレクサを使用する方が、より多用途のソリューションとなります。

[`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) のようなターミナルマルチプレクサは、ペインやタブを使用してターミナルウィンドウを多重表示できるので、複数のシェルセッションとインタラクトできます。
さらにターミナルマルチプレクサは、現在のターミナルセッションをデタッチでき、後に再度アタッチすることができます。
これで`nohup`や似たようなトリックを使う必要がなくなるので、リモートマシンで作業している時にワークフローを大幅に改善できます。

近年最も人気のあるターミナルマルチプレクサは [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) です。`tmux`は高度な設定が可能で、関連付けられたキーバインディングで複数のタブやペインを作成でき、素早く移動ができます。

`tmux`ではキーバインディングの事前知識が必要です。キーは全て`<C-b> x`のような形式で、これは (1)`Ctrl+b`を押し (2)`Ctrl+b`を離し、そして (3)`x`を押すという意味です。
`tmux`には次のようなオブジェクトの階層構造があります。
- **セッション** - セッションは単一または複数のウィンドウを持つ独立したワークスペースのこと
    +`tmux` 新しいセッションを開始
    +`tmux new -s 名前` その名前がついたセッションを開始
    +`tmux ls` 現在のセッションをリスト表示
    +`tmux` 内で`<C-b> d` と入力すると現在のセッションをデタッチ
    +`tmux a` で最後のセッションをアタッチ。`-t` でどのセッションが特定できます。

- **ウィンドウ** - エディタやブラウザのタブに相当。同一のセッション内で視覚的に分離したパーツのこと
    +`<C-b> c` 新しいウィンドウを作成。閉じるには`<C-d>` でシェルを終了する
    +`<C-b> N` _N_ 番目のウィンドウに移動。ウィンドウは番号付けされていることに注意
    +`<C-b> p` 前のウィンドウに移動
    +`<C-b> n` 次のウィンドウに移動
    +`<C-b> ,` 現在のウィンドウの名前を変更
    +`<C-b> w` 現在のウィンドウをリスト表示

- **ペイン** - ペインは、vimのスプリッターのように、同一の視覚的ディスプレイの中に複数のセルを表示できる
    +`<C-b> "` 現在のペインを水平に分割
    +`<C-b> %` 現在のペインを垂直に分割
    +`<C-b> <方向>` 指定した _方向_ のペインに移動。ここでの方向は矢印キーを意味する。
    +`<C-b> z` 現在のペインのズームを切り替え
    +`<C-b> [` スクロールバックを開始。`<space>` を押して選択を開始し、`<enter>` でその選択範囲をコピーできる。
    +`<C-b> <space>` ペインを順番に移動。


さらに学びたい場合は、
[こちら](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) に`tmux`のクイックチュートリアルが、 [ここ](http://linuxcommand.org/lc3_adv_termmux.php) に元となる`screen`コマンドを含めたより詳細な説明があります。 [`screen`](https://www.man7.org/linux/man-pages/man1/screen.1.html) はほとんどのUNIXシステムにインストールされているので、慣れておいた方が良いでしょう。

# エイリアス

たくさんのフラッグや詳細オプションを含めた長いコマンドを打つのは面倒くさくなることがあります。
そのためほとんどのシェルでは _エイリアス_ をサポートしています。
シェルエイリアスとは他のコマンドの短縮形で、シェルが自動的に置換してくれます。
例として、 bash のエイリアスは次のような構造です。

```bash
alias alias_name="command_to_alias arg1 arg2"
```

等号`=`の左右にスペースがないことに注意してください。[`alias`](https://www.man7.org/linux/man-pages/man1/alias.1p.html) はシェルコマンドで、単一の引数を取ります。

エイリアスにはたくさんの便利な機能があります。

```bash
# 一般的なフラッグの省略形
alias ll="ls -lh"

# 一般的なコマンドのタイピング数を大幅に減らす
alias gs="git status"
alias gc="git commit"
alias v="vim"

# ミスタイプを防ぐ
alias sl=ls

# 既存のコマンドをより良いデフォルトに上書き
alias mv="mv -i"           # -i 上書き前に警告
alias mkdir="mkdir -p"     # -p 必要に応じて親ディレクトリを作る
alias df="df -h"           # -h 人間が読める形式で表示

# エイリアスは組み合わせ可能
alias la="ls -A"
alias lla="la -l"

# エイリアスを無視するには \ を前につける
\ls
# またはunaliasでエイリアスを無効化
unalias la

# エイリアスの定義を表示するにはaliasで呼び出し
alias ll
# これはll='ls -lh'を表示する
```

Note that aliases do not persist shell sessions by default.
To make an alias persistent you need to include it in shell startup files, like `.bashrc` or `.zshrc`, which we are going to introduce in the next section.


# Dotfiles

Many programs are configured using plain-text files known as _dotfiles_
(because the file names begin with a `.`, e.g. `~/.vimrc`, so that they are
hidden in the directory listing `ls` by default).

Shells are one example of programs configured with such files. On startup, your shell will read many files to load its configuration.
Depending on the shell, whether you are starting a login and/or interactive the entire process can be quite complex.
[Here](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) is an excellent resource on the topic.

For `bash`, editing your `.bashrc` or `.bash_profile` will work in most systems.
Here you can include commands that you want to run on startup, like the alias we just described or modifications to your `PATH` environment variable.
In fact, many programs will ask you to include a line like `export PATH="$PATH:/path/to/program/bin"` in your shell configuration file so their binaries can be found.

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
on Github --- see the most popular one
[here](https://github.com/mathiasbynens/dotfiles) (we advise you not to blindly
copy configurations though).
[Here](https://dotfiles.github.io/) is another good resource on the topic.

All of the class instructors have their dotfiles publicly accessible on GitHub: [Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/jjgo/dotfiles).


## Portability

A common pain with dotfiles is that the configurations might not work when working with several machines, e.g. if they have different operating systems or shells. Sometimes you also want some configuration to be applied only in a given machine.

There are some tricks for making this easier.
If the configuration file supports it, use the equivalent of if-statements to
apply machine specific customizations. For example, your shell could have something
like:

```bash
if [[ "$(uname)" == "Linux" ]]; then {do_something}; fi

# Check before using shell-specific features
if [[ "$SHELL" == "zsh" ]]; then {do_something}; fi

# You can also make it machine-specific
if [[ "$(hostname)" == "myServer" ]]; then {do_something}; fi
```

If the configuration file supports it, make use of includes. For example,
a `~/.gitconfig` can have a setting:

```
[include]
    path = ~/.gitconfig_local
```

And then on each machine, `~/.gitconfig_local` can contain machine-specific
settings. You could even track these in a separate repository for
machine-specific settings.

This idea is also useful if you want different programs to share some configurations. For instance, if you want both `bash` and `zsh` to share the same set of aliases you can write them under `.aliases` and have the following block in both:

```bash
# Test if ~/.aliases exists and source it
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi
```

# Remote Machines

It has become more and more common for programmers to use remote servers in their everyday work. If you need to use remote servers in order to deploy backend software or you need a server with higher computational capabilities, you will end up using a Secure Shell (SSH). As with most tools covered, SSH is highly configurable so it is worth learning about it.

To `ssh` into a server you execute a command as follows

```bash
ssh foo@bar.mit.edu
```

Here we are trying to ssh as user `foo` in server `bar.mit.edu`.
The server can be specified with a URL (like `bar.mit.edu`) or an IP (something like `foobar@192.168.1.42`). Later we will see that if we modify ssh config file you can access just using something like `ssh bar`.

## Executing commands

An often overlooked feature of `ssh` is the ability to run commands directly.
`ssh foobar@server ls` will execute `ls` in the home folder of foobar.
It works with pipes, so `ssh foobar@server ls | grep PATTERN` will grep locally the remote output of `ls` and `ls | ssh foobar@server grep PATTERN` will grep remotely the local output of `ls`.


## SSH Keys

Key-based authentication exploits public-key cryptography to prove to the server that the client owns the secret private key without revealing the key. This way you do not need to reenter your password every time. Nevertheless, the private key (often `~/.ssh/id_rsa` and more recently `~/.ssh/id_ed25519`) is effectively your password, so treat it like so.

### Key generation

To generate a pair you can run [`ssh-keygen`](https://www.man7.org/linux/man-pages/man1/ssh-keygen.1.html).
```bash
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519
```
You should choose a passphrase, to avoid someone who gets hold of your private key to access authorized servers. Use [`ssh-agent`](https://www.man7.org/linux/man-pages/man1/ssh-agent.1.html) or [`gpg-agent`](https://linux.die.net/man/1/gpg-agent) so you do not have to type your passphrase every time.

If you have ever configured pushing to GitHub using SSH keys, then you have probably done the steps outlined [here](https://help.github.com/articles/connecting-to-github-with-ssh/) and have a valid key pair already. To check if you have a passphrase and validate it you can run `ssh-keygen -y -f /path/to/key`.

### Key based authentication

`ssh` will look into `.ssh/authorized_keys` to determine which clients it should let in. To copy a public key over you can use:

```bash
cat .ssh/id_ed25519.pub | ssh foobar@remote 'cat >> ~/.ssh/authorized_keys'
```

A simpler solution can be achieved with `ssh-copy-id` where available:

```bash
ssh-copy-id -i .ssh/id_ed25519.pub foobar@remote
```

## Copying files over SSH

There are many ways to copy files over ssh:

- `ssh+tee`, the simplest is to use `ssh` command execution and STDIN input by doing `cat localfile | ssh remote_server tee serverfile`. Recall that [`tee`](https://www.man7.org/linux/man-pages/man1/tee.1.html) writes the output from STDIN into a file.
- [`scp`](https://www.man7.org/linux/man-pages/man1/scp.1.html) when copying large amounts of files/directories, the secure copy `scp` command is more convenient since it can easily recurse over paths. The syntax is `scp path/to/local_file remote_host:path/to/remote_file`
- [`rsync`](https://www.man7.org/linux/man-pages/man1/rsync.1.html) improves upon `scp` by detecting identical files in local and remote, and preventing copying them again. It also provides more fine grained control over symlinks, permissions and has extra features like the `--partial` flag that can resume from a previously interrupted copy. `rsync` has a similar syntax to `scp`.

## Port Forwarding

In many scenarios you will run into software that listens to specific ports in the machine. When this happens in your local machine you can type `localhost:PORT` or `127.0.0.1:PORT`, but what do you do with a remote server that does not have its ports directly available through the network/internet?.

This is called _port forwarding_ and it
comes in two flavors: Local Port Forwarding and Remote Port Forwarding (see the pictures for more details, credit of the pictures from [this StackOverflow post](https://unix.stackexchange.com/questions/115897/whats-ssh-port-forwarding-and-whats-the-difference-between-ssh-local-and-remot)).

**Local Port Forwarding**
![Local Port Forwarding](https://i.stack.imgur.com/a28N8.png  "Local Port Forwarding")

**Remote Port Forwarding**
![Remote Port Forwarding](https://i.stack.imgur.com/4iK3b.png  "Remote Port Forwarding")

The most common scenario is local port forwarding, where a service in the remote machine listens in a port and you want to link a port in your local machine to forward to the remote port. For example, if we execute  `jupyter notebook` in the remote server that listens to the port `8888`. Thus, to forward that to the local port `9999`, we would do `ssh -L 9999:localhost:8888 foobar@remote_server` and then navigate to `locahost:9999` in our local machine.


## SSH Configuration

We have covered many many arguments that we can pass. A tempting alternative is to create shell aliases that look like
```bash
alias my_server="ssh -i ~/.id_ed25519 --port 2222 -L 9999:localhost:8888 foobar@remote_server
```

However, there is a better alternative using `~/.ssh/config`.

```bash
Host vm
    User foobar
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
    LocalForward 9999 localhost:8888

# Configs can also take wildcards
Host *.mit.edu
    User foobaz
```

An additional advantage of using the `~/.ssh/config` file over aliases  is that other programs like `scp`, `rsync`, `mosh`, &c are able to read it as well and convert the settings into the corresponding flags.


Note that the `~/.ssh/config` file can be considered a dotfile, and in general it is fine for it to be included with the rest of your dotfiles. However, if you make it public, think about the information that you are potentially providing strangers on the internet: addresses of your servers, users, open ports, &c. This may facilitate some types of attacks so be thoughtful about sharing your SSH configuration.

Server side configuration is usually specified in `/etc/ssh/sshd_config`. Here you can make changes like disabling password authentication, changing ssh ports, enabling X11 forwarding, &c. You can specify config settings on a per user basis.

## Miscellaneous

A common pain when connecting to a remote server are disconnections due to shutting down/sleeping your computer or changing a network. Moreover if one has a connection with significant lag using ssh can become quite frustrating. [Mosh](https://mosh.org/), the mobile shell, improves upon ssh, allowing roaming connections, intermittent connectivity and providing intelligent local echo.

Sometimes it is convenient to mount a remote folder. [sshfs](https://github.com/libfuse/sshfs) can mount a folder on a remote server
locally, and then you can use a local editor.


# Shells & Frameworks

During shell tool and scripting we covered the `bash` shell because it is by far the most ubiquitous shell and most systems have it as the default option. Nevertheless, it is not the only option.

For example, the `zsh` shell is a superset of `bash` and provides many convenient features out of the box such as:

- Smarter globbing, `**`
- Inline globbing/wildcard expansion
- Spelling correction
- Better tab completion/selection
- Path expansion (`cd /u/lo/b` will expand as `/usr/local/bin`)

**Frameworks** can improve your shell as well. Some popular general frameworks are [prezto](https://github.com/sorin-ionescu/prezto) or [oh-my-zsh](https://ohmyz.sh/), and smaller ones that focus on specific features such as [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) or [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search). Shells like [fish](https://fishshell.com/) include many of these user-friendly features by default. Some of these features include:

- Right prompt
- Command syntax highlighting
- History substring search
- manpage based flag completions
- Smarter autocompletion
- Prompt themes

One thing to note when using these frameworks is that they may slow down your shell, especially if the code they run is not properly optimized or it is too much code. You can always profile it and disable the features that you do not use often or value over speed.

# Terminal Emulators

Along with customizing your shell, it is worth spending some time figuring out your choice of **terminal emulator** and its settings. There are many many terminal emulators out there (here is a [comparison](https://anarc.at/blog/2018-04-12-terminal-emulators-1/)).

Since you might be spending hundreds to thousands of hours in your terminal it pays off to look into its settings. Some of the aspects that you may want to modify in your terminal include:

- Font choice
- Color Scheme
- Keyboard shortcuts
- Tab/Pane support
- Scrollback configuration
- Performance (some newer terminals like [Alacritty](https://github.com/jwilm/alacritty) or [kitty](https://sw.kovidgoyal.net/kitty/) offer GPU acceleration).

# Exercises

## Job control

1. From what we have seen, we can use some `ps aux | grep` commands to get our jobs' pids and then kill them, but there are better ways to do it. Start a `sleep 10000` job in a terminal, background it with `Ctrl-Z` and continue its execution with `bg`. Now use [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) to find its pid and [`pkill`](http://man7.org/linux/man-pages/man1/pgrep.1.html) to kill it without ever typing the pid itself. (Hint: use the `-af` flags).

1. Say you don't want to start a process until another completes, how you would go about it? In this exercise our limiting process will always be `sleep 60 &`.
One way to achieve this is to use the [`wait`](https://www.man7.org/linux/man-pages/man1/wait.1p.html) command. Try launching the sleep command and having an `ls` wait until the background process finishes.

    However, this strategy will fail if we start in a different bash session, since `wait` only works for child processes. One feature we did not discuss in the notes is that the `kill` command's exit status will be zero on success and nonzero otherwise. `kill -0` does not send a signal but will give a nonzero exit status if the process does not exist.
    Write a bash function called `pidwait` that takes a pid and waits until the given process completes. You should use `sleep` to avoid wasting CPU unnecessarily.

## Terminal multiplexer

1. Follow this `tmux` [tutorial](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) and then learn how to do some basic customizations following [these steps](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/).

## Aliases

1. Create an alias `dc` that resolves to `cd` for when you type it wrongly.

1.  Run `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10`  to get your top 10 most used commands and consider writing shorter aliases for them. Note: this works for Bash; if you're using ZSH, use `history 1` instead of just `history`.


## Dotfiles

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

## Remote Machines

Install a Linux virtual machine (or use an already existing one) for this exercise. If you are not familiar with virtual machines check out [this](https://hibbard.eu/install-ubuntu-virtual-box/) tutorial for installing one.

1. Go to `~/.ssh/` and check if you have a pair of SSH keys there. If not, generate them with `ssh-keygen -o -a 100 -t ed25519`. It is recommended that you use a password and use `ssh-agent` , more info [here](https://www.ssh.com/ssh/agent).
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
1. (Challenge) Look into what the `-N` and `-f` flags do in `ssh` and figure out what a command to achieve background port forwarding.
