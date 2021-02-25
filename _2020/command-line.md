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

ジョブの実行中に中断する必要が出てくるケースがあります。例えば、コマンドが完了までに時間がかかりすぎる場合などです（ `find` でとても巨大なディレクトリ構造を検索する場合など）。
ほとんどの場合、 `Ctrl-C` でコマンドは停止します。
ですがこれは、実際にどのように機能しているのでしょうか、そしてプロセスの停止に失敗することがあるのはなぜでしょうか？

## プロセスの停止（kill）

シェルは、 _シグナル_ と呼ばれるUNIXのコミュニケーションメカニズムを使用し、処理する情報を通信しています。プロセスがシグナルを受け取ると、そのシグナルが伝える情報に基づき、実行を停止し、シグナルに対処し、実行フローを潜在的に変更します。そのため、シグナルは _ソフトウェア的中断_ です。

このケースでは、 `Ctrl-C` とタイプすると、シェルが `SIGINT` シグナルをプロセスに伝達します。

以下はPythonプログラムの最小例です。これは `SIGINT` をキャプチャし、無視し、停止しません。このプログラムを停止するには、代わりに `Ctrl-\` とタイプして、 `SIGQUIT` を使用する必要があります。

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

このプログラムに `SIGINT` を2回送信し、続いて `SIGQUIT` を送信すると、以下が表示されます。 `^ ` は `Ctrl` がターミナルにタイプされたときに表示される文字です。

```
$ python sigint.py
24^C
I got a SIGINT, but I am not stopping
26^C
I got a SIGINT, but I am not stopping
30^\[1]    39913 quit       python sigint.py
```

`SIGINT` と `SIGQUIT` は両方とも通常はターミナルに関連したリクエストに関連づけられます。一方で、プロセスが完璧に終了するように命令する、より一般的なシグナルが `SIGTERM` です。
このシグナルを送るには [`kill`](https://www.man7.org/linux/man-pages/man1/kill.1.html) コマンドを使用します。シンタックスは `kill -TERM <PID>` です。

## 一時停止とバックグラウンドプロセス

シグナルは、プロセスを停止する他にも様々なことができます。例えば、 `SIGSTOP` はプロセスを一時停止します。ターミナルで `Ctrl-Z` と入力すると、シェルに `SIGTSTP` シグナルを送るよう指示します。これはTerminal Stopの省略です（つまり `SIGSTOP` のターミナル版ということです）。

一時停止したジョブは[`fg`](https://www.man7.org/linux/man-pages/man1/fg.1p.html) または [`bg`](http://man7.org/linux/man-pages/man1/bg.1p.html) を使用して、それぞれフォアグラウンドやバックグラウンドで継続できます。

[`jobs`](https://www.man7.org/linux/man-pages/man1/jobs.1p.html) コマンドは、現在のターミナルセッションに関連付けられた未完了のジョブをリスト表示します。
これらのジョブはプロセスIDを使用して参照できます（プロセスIDは [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) で調べられます）。
さらに直感的に、プロセスはパーセント記号に続くジョブ番号でも参照できます（`jobs` で表示されます）。最新のバックグラウンドジョブは、特別な `$!` で参照できます。

もう一つ知っておくべきことは、コマンドに接尾辞 `&` をつけると、そのコマンドをバックグラウンドで実行し、プロンプトを表示することです。これは同じシェルのSTDOUTを使用するので、鬱陶しく感じるかもしれません（その場合はシェルのリダイレクトを使いましょう）。

既に実行中のプログラムをバックグラウンドに移動するには、 `Ctrl-Z` の後に `bg` を入力します。バックグラウンドプロセスはターミナルの子プロセスのままで、ターミナルを閉じると消滅することをお忘れなく（これはまた別のシグナル、 `SIGHUP` を送信します）。
これが起きるのを防ぐには、プログラムを[`nohup`](https://www.man7.org/linux/man-pages/man1/nohup.1.html) （`SIGHUP` を無視するラッパー）と一緒に実行するか、またはプロセスが既に開始している場合は `disown` を使いましょう。
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

`SIGKILL` という特別なシグナルがあり、これはプロセスでキャプチャできず、どんな時でもプロセスを即時終了します。しかし、孤児プロセスを残してしまうなどの悪影響もあります。

これらや他のシグナルは [こちら](https://en.wikipedia.org/wiki/Signal_(IPC)) 、または [`man signal`](https://www.man7.org/linux/man-pages/man7/signal.7.html) もしくは `kill -t` と入力することで詳細を表示できます。


# ターミナルマルチプレクサ

コマンドラインインターフェイスの使用中、複数のプロセスを走らせたいと思うことがしばしばあるでしょう。
例えば、エディタをプログラムと並べて走らせたい場合などです。
これは新しいターミナルウィンドウを開くことで達成できますが、ターミナルマルチプレクサを使用する方が、より多用途のソリューションとなります。

[`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) のようなターミナルマルチプレクサは、ペインやタブを使用してターミナルウィンドウを多重表示できるので、複数のシェルセッションとインタラクトできます。
さらにターミナルマルチプレクサは、現在のターミナルセッションをデタッチでき、後に再度アタッチすることができます。
これで `nohup` や似たようなトリックを使う必要がなくなるので、リモートマシンで作業している時にワークフローを大幅に改善できます。

近年最も人気のあるターミナルマルチプレクサは [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) です。 `tmux` は高度な設定が可能で、関連付けられたキーバインディングで複数のタブやペインを作成でき、素早く移動ができます。

`tmux` ではキーバインディングの事前知識が必要です。キーは全て `<C-b> x` のような形式で、これは (1) `Ctrl+b` を押し (2) `Ctrl+b` を離し、そして (3) `x` を押すという意味です。
`tmux` には次のようなオブジェクトの階層構造があります。
- **セッション** - セッションは単一または複数のウィンドウを持つ独立したワークスペースのこと
    + `tmux` 新しいセッションを開始
    + `tmux new -s 名前` その名前がついたセッションを開始
    + `tmux ls` 現在のセッションをリスト表示
    + `tmux` 内で `<C-b> d` と入力すると現在のセッションをデタッチ
    + `tmux a` で最後のセッションをアタッチ。 `-t` でどのセッションが特定できます。

- **ウィンドウ** - エディタやブラウザのタブに相当。同一のセッション内で視覚的に分離したパーツのこと
    + `<C-b> c` 新しいウィンドウを作成。閉じるには `<C-d>` でシェルを終了する
    + `<C-b> N` _N_ 番目のウィンドウに移動。ウィンドウは番号付けされていることに注意
    + `<C-b> p` 前のウィンドウに移動
    + `<C-b> n` 次のウィンドウに移動
    + `<C-b> ,` 現在のウィンドウの名前を変更
    + `<C-b> w` 現在のウィンドウをリスト表示

- **ペイン** - vimのスプリッターのように、同一の視覚的ディスプレイの中に複数のセルを表示できる
    + `<C-b> "` 現在のペインを水平に分割
    + `<C-b> %` 現在のペインを垂直に分割
    + `<C-b> <方向>` 指定した _方向_ のペインに移動。ここでの方向は矢印キーを意味する。
    + `<C-b> z` 現在のペインのズームを切り替え
    + `<C-b> [` スクロールバックを開始。 `<space>` を押して選択を開始し、 `<enter>` でその選択範囲をコピーできる。
    + `<C-b> <space>` ペインを順番に移動。


さらに学びたい場合は、
[こちら](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) に `tmux` のクイックチュートリアルが、 [ここ](http://linuxcommand.org/lc3_adv_termmux.php) に元となる `screen` コマンドを含めたより詳細な説明があります。 [`screen`](https://www.man7.org/linux/man-pages/man1/screen.1.html) はほとんどのUNIXシステムにインストールされているので、慣れておいた方が良いでしょう。

# エイリアス

たくさんのフラッグや詳細オプションを含めた長いコマンドを打つのは面倒くさくなることがあります。
そのため、ほとんどのシェルでは _エイリアス_ をサポートしています。
シェルエイリアスとは他のコマンドの短縮形で、シェルが自動的に置換してくれるものです。
例として、 bash のエイリアスは次のような構造をしています。

```bash
alias alias_name="command_to_alias arg1 arg2"
```

等号 `=` の左右にスペースがないことに注意してください。[`alias`](https://www.man7.org/linux/man-pages/man1/alias.1p.html) はシェルコマンドで、単一の引数を取ります。

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
エイリアスは既定ではシェルセッションに存続しないことに注意しましょう。
エイリアスを存続させるには、これを `.bashrc` や `.zshrc` などのシェルのスタートアップファイルに書く必要があります。これらは次のセクションで紹介します。


# ドットファイル

多くのプログラムは、 _ドットファイル_ （例えば `~/.vimrc` など、ファイル名が `.` で始まるからです。これらはデフォルトではディレクトリ内の列挙 `ls` では表示されません）として知られる平文ファイルで設定されています。

シェルはこのようなファイルで設定されるプログラムの一例です。起動時シェルは、設定をロードするために沢山のファイルを読み込みます。
シェルによっては、ログイン and/or 対話型どちらの開始時でも、プロセス全体が非常に複雑になることがあります。
[これ](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) はこの話題に関する素晴らしいリソースです。

`bash` に関しては、ほとんどのシステムで `.bashrc` または `.bash_profile` の編集が効果的です。
ここにはスタートアップ時に走らせたいコマンドを書き込めます。例えば説明したばかりのエイリアスや、 `PATH` 環境変数の編集などです。
実際多くのファイルは、バイナリを見つけられるように、シェル設定ファイルに `export PATH="$PATH:/path/to/program/bin"` のような行を書くように要求してきます。

ドットファイルで設定できるツールの他の例としては以下があります。

- `bash` - `~/.bashrc` 、 `~/.bash_profile`
- `git` - `~/.gitconfig`
- `vim` - `~/.vimrc` と `~/.vim` フォルダ
- `ssh` - `~/.ssh/config`
- `tmux` - `~/.tmux.conf`

ドットファイルはどうやって整理すれば良いのでしょうか？ これらはそれぞれのフォルダ内で、バージョン管理下にあり、スクリプトを使って**symlink**で位置づけされるべきです。これには次の利点があります。

- **インストールが簡単**: 新しいマシンにログインした時、カスタマイズの適用がすぐに可能。
- **移植性**: ツールがどこでも同じように動く。
- **同期**: not ファイルをどこでもアップデートでき、全てを同期できる。
- **変更履歴**: ドットファイルは、プログラミングキャリアを通してメンテナンスし続けることになるだろう。長期プロジェクトにはバージョン管理があると便利。

ドットファイルには何を書くべきでしょうか？
ツールのセッティングに関しては、オンラインのドキュメントや
[manページ](https://en.wikipedia.org/wiki/Man_page)を読めば学べます。
特定のプログラムに関して、著者がお気に入りのカスタマイズを紹介しているブログポストをインターネットで検索することも、大きな助けとなるでしょう。
カスタマイズに関して学ぶ更なる方法は、他の人のドットファイルを閲覧することです。 GitHub には大量の
[ドットファイルリポジトリ](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories)
があります --- 一番人気なのは
[これ]](https://github.com/mathiasbynens/dotfiles) です（設定をむやみにコピーするのはお勧めしません）。
[これ](https://dotfiles.github.io/) も、このトピックに関する素晴らしいリソースです。

講義の講師は全員、ドットファイルを GitHub で公開しています。
[Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/jjgo/dotfiles).


## 移植性

ドットファイルでよくある面倒事といえば、複数のマシンで作業している時、例えば異なる OS やシェルの場合、設定が動かないことがあることです。
ある設定を特定のマシンにだけ適用したい場合もあるでしょう。

この解決法となる小技があります。
もし設定ファイルがサポートしているなら、if文で同値を使って、マシンに応じた設定を適用できます。
例えばシェルには次のようなものが適用できます。

```bash
if [[ "$(uname)" == "Linux" ]]; then {do_something}; fi

# Check before using shell-specific features
if [[ "$SHELL" == "zsh" ]]; then {do_something}; fi

# You can also make it machine-specific
if [[ "$(hostname)" == "myServer" ]]; then {do_something}; fi
```

もし設定ファイルがサポートしているなら、includeを有効活用しましょう。例えば、
`~/.gitconfig` には次のような設定ができます。

```
[include]
    path = ~/.gitconfig_local
```

そして各マシンでは、 `~/.gitconfig_local` にマシンに応じた設定を書き込みます。
これらは個別マシン用の設定のリポジトリでバージョン管理もできます。

このアイディアは、異なるプログラムで同じ設定を共有したい場合にも便利です。
例えば、 `bash` と `zsh` で同じエイリアスのセットを共有したい場合、 `.aliases` にそれを記述し、両方のファイルに次のブロックを記述します。

```bash
# Test if ~/.aliases exists and source it
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi
```

# リモートマシン

プログラマーが日常の業務でリモートサーバを使うことは、ますます一般的になってきました。
バックエンドソフトウェアのデプロイにリモートサーバを使う必要がある場合、またはより高い計算能力を持つサーバが必要な場合、セキュアシェル（Secure Sell、SSH）を使うことになるでしょう。
取り上げてきたほとんどのツールと同じように SSH も高度な設定が可能なので、学ぶ価値があります。

サーバに `ssh` するには次のコマンドを実行します。

```bash
ssh foo@bar.mit.edu
```

ここではサーバ `bar.mit.edu` にユーザー `foo` として SSH しようとしています。
サーバは URL（例： `bar.mit.edu` ）または IP （例： `foobar@192.168.1.42` ）で指定できます。
SSH の設定ファイルを編集すれば、 `ssh bar` のようなコマンドを使うだけでアクセスできるようになります。これは後で紹介します。

## コマンドの実行

見逃されがちな `ssh` の機能は、直接コマンドを実行できることです。
`ssh foobar@server ls` は `ls` を foobar のホームフォルダで実行します。
パイプも使用できるので、 `ssh foobar@server ls | grep PATTERN` は `ls` のリモート出力をローカルでgrepできますし、
`ls | ssh foobar@server grep PATTERN` は `ls` のローカルの出力をリモートでgrepします。


## SSH鍵

鍵認証は、公開鍵の暗号化を使い、クライアントが非公開の秘密鍵を持っていることを、鍵を明かすことなくサーバに証明します。
この方法では、毎回パスワードを再入力する必要はありません。
しかし秘密鍵（しばしば `~/.ssh/id_rsa` 、最近では `~/.ssh/id_ed25519` ）は実効的にパスワードと同等なので、取り扱いには注意しましょう。

### 鍵生成

鍵ペアを生成するには [`ssh-keygen`](https://www.man7.org/linux/man-pages/man1/ssh-keygen.1.html) を実行します。
```bash
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519
```
誰かが秘密鍵を入手し、権限のあるサーバにアクセスするのを防ぐために、パスフレーズを選ぶ必要があります。
[`ssh-agent`](https://www.man7.org/linux/man-pages/man1/ssh-agent.1.html) または[`gpg-agent`](https://linux.die.net/man/1/gpg-agent) を使うと、毎回パスフレーズを入力する必要がなくなります。

SSH鍵を使ってGitHubにpushする設定を行ったことがあるならば、既に [ここ](https://help.github.com/articles/connecting-to-github-with-ssh/) で紹介されているステップを行い、有効な鍵ペアを持っていることでしょう。パスフレーズがあることを確認し、パスフレーズを有効化するには、 `ssh-keygen -y -f /path/to/key` を実行します。

### 鍵認証

`ssh` は、どのクライアントをログインさせるか決定するために、 `.ssh/authorized_keys` を閲覧します。公開鍵をコピーするには以下を使用します。

```bash
cat .ssh/id_ed25519.pub | ssh foobar@remote 'cat >> ~/.ssh/authorized_keys'
```

より簡単な方法は、使用できる場合 `ssh-copy-id` を使うことです。

```bash
ssh-copy-id -i .ssh/id_ed25519.pub foobar@remote
```

## SSHでファイルをコピーする

SSHを通してファイルをコピーする方法はたくさんあります。

- `ssh+tee` 一番簡単な方法は、 `cat localfile | ssh remote_server tee serverfile` で、 `ssh` コマンドの実行とSTDIN入力を使用することです。[`tee`](https://www.man7.org/linux/man-pages/man1/tee.1.html) はSTDINの出力をファイルに書き込むことを思い出しましょう。
- [`scp`](https://www.man7.org/linux/man-pages/man1/scp.1.html) 大量のファイルやディレクトリをコピーする場合、簡単にパスを再帰処理するので、セキュアコピー（secure copy） `scp` コマンドがより便利です。 シンタックスは `scp path/to/local_file remote_host:path/to/remote_file` です。
- [`rsync`](https://www.man7.org/linux/man-pages/man1/rsync.1.html) は `scp` を改善したもので、ローカルとリモートで同一のファイルを検出し、それらを再度コピーすることを防ぎます。また、symlink、パーミッションに関してさらに詳細な管理をでき、前回中断されたコピーを再開する `--partial` フラッグのような追加機能もあります。 `rsync` は `scp` に似たシンタックスです。

## ポートフォワーディング

マシン上で特定のポートだけlistenするソフトウェアに遭遇することがあるでしょう。
この場合ローカルマシンで `localhost:PORT` または `127.0.0.1:PORT` とタイプしますが、
ネットワーク・インターネットで直接使用できるポートがないリモートサーバではどうすれば良いでしょうか？

これは _ポートフォワーディング_ と呼ばれ、2種類があります。
ローカルポートフォワーディングとリモートポートフォワーディングです
（詳細は画像を参考のこと。画像のクレジットは
[このStackOverflowのポスト](https://unix.stackexchange.com/questions/115897/whats-ssh-port-forwarding-and-whats-the-difference-between-ssh-local-and-remot) 
に帰属します）。

**ローカルポートフォワーディング**
![ローカルポートフォワーディング](https://i.stack.imgur.com/a28N8.png  "ローカルポートフォワーディング")

**リモートポートフォワーディング**
![リモートポートフォワーディング](https://i.stack.imgur.com/4iK3b.png  "リモートポートフォワーディング")

最も一般的なシナリオはローカルポートフォワーディングです。リモートマシンのサービスが特定のポートをlistenし、
ローカルマシンのポートをリンクしてリモートポートにフォワードしたい場合です。
例えば、ポート `8888` をlistenするリモートサーバで `jupyter notebook` を実行したとします。
その場合、それをローカルポートの `9999` にフォワードするには、
`ssh -L 9999:localhost:8888 foobar@remote_server` を実行し、
ローカルマシンで `locahost:9999` に移動します。


## SSH設定

パスできるたくさんの引数について紹介してきました。
魅力的な代替案は、次のようなシェルエイリアスを作ることです。
```bash
alias my_server="ssh -i ~/.id_ed25519 --port 2222 -L 9999:localhost:8888 foobar@remote_server
```

ですが、`~/.ssh/config` を使ったより良い代替案があります。

```bash
Host vm
    User foobar
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
    LocalForward 9999 localhost:8888

# 設定はワイルドカードも使用可能
Host *.mit.edu
    User foobaz
```

エイリアスよりも`~/.ssh/config` を使う上での追加のメリットは、`scp` 、`rsync` 、`mosh` などもファイルを読み込めることと、設定を関連したフラグに変換できることです。


`~/.ssh/config` ファイルはドットファイルとして考慮され、一般的には他のドットファイルと一緒にしても構わないことに注意してください。
ですが、パブリックにする場合は、インターネットで見知らぬ他人に潜在的に提供している情報に気をつけましょう。サーバのアドレス、ユーザー、オープンなポートなどです。
これはある種の攻撃を引き起こすことがあるので、SSH設定をシェアするときは気をつけましょう。

サーバサイドの設定は通常は `/etc/ssh/sshd_config` ここに記載されます。
ここではパスワード認証の無効化や、SSHポートの変更、X11フォワーディングの有効化などの変更を行えます。
ユーザーごとに設定を特定できます。

## その他

リモートサーバに接続時のよくある面倒事は、コンピューターのシャットダウンやスリープ、
またはネットワーク変更による切断です。
また、かなりのラグがある接続で SSH をするのもイライラの元になります。
モバイルシェルの [Mosh](https://mosh.org/) は、SSHを改善し、ローミングによる接続、
不安定な接続を許容し、インテリジェントなローカルエコーを提供します。

リモートフォルダをマウントするのが便利な時もあります。
[sshfs](https://github.com/libfuse/sshfs) はリモートサーバにあるフォルダをローカルにマウントでき、ローカルのエディタで使用できます。


# シェルとフレームワーク

シェルツールとスクリプティングの講義では、 `bash` シェルを紹介しました。
これは今のところ最もユビキタスなシェルで、ほとんどのシステムがデフォルトのオプションとして備えているからです。
しかし、これが唯一のオプションというわけではありません。

例えば `zsh` シェルは `bash` セルの上位セットで、
以下のような、すぐに使えるたくさんの便利機能があります。

- よりスマートなglob、 `**`
- インラインglob/ワイルドカード拡張
- スペル訂正
- より良いTab補完/選択
- パス拡張（ `cd /u/lo/b` は `/usr/local/bin` に拡張されます)

**フレームワーク** でもシェルの改善が可能です。
人気の一般的なフレームワークとして、
[prezto](https://github.com/sorin-ionescu/prezto) 、
[oh-my-zsh](https://ohmyz.sh/) など、
特定の機能に焦点を当てたより小規模なものとして
[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) や [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) などがあります。
[fish](https://fishshell.com/) のようなシェルには、このようなユーザーフレンドリーな機能がたくさんのデフォルトで入っています。以下に例を挙げます。

- 右側にプロンプト表示
- コマンドシンタックスハイライト
- サブストリング履歴検索
- manpage ベースのフラッグ補完
- よりスマートな自動補完
- プロンプトのテーマ

このようなフレームワークの使用時に注意するべきことは、
特に最適化されていないコードや、最適化されすぎたコードを走らせる場合、
シェルの速度が低下するかもしれないことです。
頻繁に使わない機能や、スピードを犠牲にする機能の見直しと無効化はいつでもできます。

# ターミナルエミュレータ

シェルのカスタマイズと同時に、
**ターミナルエミュレータ** の選択とその設定の見直しにも時間を割く価値があります。
ターミナルエミュレータは非常にたくさんあります（[比較表](https://anarc.at/blog/2018-04-12-terminal-emulators-1/)）。

ターミナルには何十万時間も費やすことになるでしょうから、
設定を見直すのは効果があるでしょう。
ターミナルで変更したくなるポイントとしては以下があります。

- フォントの選択
- カラースキーム
- キーボードショートカット
- タブ/ペインのサポート
- スクロールバッグ設定
- パフォーマンス（[Alacritty](https://github.com/jwilm/alacritty) や [kitty](https://sw.kovidgoyal.net/kitty/) のような新しいターミナルでは、GPUアクセラレーションが使用可能です）。

# 練習問題

## ジョブコントロール

1. 今回扱った中で、 `ps aux | grep` コマンドを使用してジョブの PID を取得し、停止できますが、より良い方法があります。
ターミナルで `sleep 10000` を開始し、 `Ctrl-Z` でバックグラウンドに移動した後、
`bg` で実行を続けましょう。
そうして [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) を使ってPIDを探し、
[`pkill`](http://man7.org/linux/man-pages/man1/pgrep.1.html) で PID 自体を入力せずに停止しましょう。
（ヒント： `-af` フラッグを使いましょう）。

1. 他のプロセスが完了するまで新しいプロセスを開始したくない場合、どうしますか？
   この練習問題では、制限となるプロセスは `sleep 60 &` を使用します。
   これを達成する方法の一つは、
   [`wait`](https://www.man7.org/linux/man-pages/man1/wait.1p.html)
   を使用することです。
   sleep コマンドを実行し、バックグラウンドプロセスの終了するまで `ls` を待機させてみましょう。

   ですが、他の bash セッションで開始した場合、この戦略は失敗します。
   `wait` は子プロセスにのみ作用するからです。
   この講義ノートで取り扱わなかった機能の1つに、
   `kill` コマンドの終了ステータスは成功の場合0で、
   失敗の場合はノンゼロであることがあります。
   `kill -0` は、シグナルは送りませんが、
   もしプロセスが存在しない場合はノンゼロの終了ステータスを返します。
   PIDを引数に取り、そのプロセスが完了するまで待機する、 `pidwait` というbash関数を書きましょう。
   CPUを無駄遣いしないために、 `sleep` を使いましょう。

## ターミナルマルチプレクサ

1. `tmux` [チュートリアル](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)
   に従い、
   [このステップ](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/)
   に従って基本のカスタマイズを行う方法を学びましょう。

## エイリアス

1. `cd` を間違えて `dc` と間違えて入力した時に解決してくれるエイリアスを作りましょう。

1.  `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10` を使い、最も頻繁に使うコマンド10個を確認し、短いエイリアスを書くことを考えてみましょう。注意：これはbashで機能します。もしZSHを使用している場合、 `history` 
   の代わりに `history 1` を使いましょう。


## ドットファイル

ドットファイルでスピードアップしましょう。
1. ドットファイルのフォルダを作り、バージョン管理しましょう。
2. 例えばシェルなど、最低1つのプログラムに向けた、カスタマイズを加えた設定をしましょう
   （手始めに、 `$PS1` を設定してシェルプロンプトをカスタマイズするようなシンプルなものが望ましい）。
3. 新しいマシンで、ドットファイルを素早く（そしてマニュアル入力なしに）インストールするメソッドを設定しましょう。各ファイルの `ln -s` を呼び出すようなシェルスクリプトのようなシンプルなもの、または [特化ユーティリティ](https://dotfiles.github.io/utilities/) を使いましょう。
4. インストールしたスクリプトをまっさらなバーチャルマシンで試しましょう。
5. 現在のツール設定をドットファイルのレポジトリに全て統合しましょう。
6. ドットファイルを GitHub で公開しましょう。

## リモートマシン

この練習用に、 Linux のバーチャルマシン（VM）をインストールしましょう（または既存のものを使いましょう）。
もしバーチャルマシンに馴染みが無いならば、インストールは [これ](https://hibbard.eu/install-ubuntu-virtual-box/) を参考にしましょう。

1. `~/.ssh/` に行き、SSH鍵のペアがそこにあるか確認しましょう。
   もしなかった場合、 `ssh-keygen -o -a 100 -t ed25519` で生成しましょう。
   パスワードと `ssh-agent` の使用を推奨します。
   詳細は [こちら](https://www.ssh.com/ssh/agent) 。
2. `.ssh/config` を編集して、次の内容を記載しましょう。

```bash
Host vm
    User username_goes_here
    HostName ip_goes_here
    IdentityFile ~/.ssh/id_ed25519
    LocalForward 9999 localhost:8888
```
1. `ssh-copy-id vm` を使用して、 ssh 鍵をサーバにコピーしましょう。
1. Start a webserver in your VM by executing `python -m http.server 8888` を実行して、VMで Web サーバを開始しましょう。
   自分のマシンで `http://localhost:9999` に移動し、VMのウェブサーバにアクセスしましょう。
2. `sudo vim /etc/ssh/sshd_config` を実行してSSHサーバ設定を編集し、
   `PasswordAuthentication` の値を編集してパスワード認証を無効にしましょう。
   `PermitRootLogin` の値を編集して、rootのログインを無効にしましょう。
   `sudo service sshd restart` で `ssh` サービスを再起動しましょう。
   ssh でのログインを再度やってみましょう。
3. （チャレンジ） VMに [`mosh`](https://mosh.org/) をインストールして接続を確立しましょう。その後サーバ/VMのネットワークアダプタから切断しましょう。
   mosh はその状態から適切に回復できますか？
4. （チャレンジ） `ssh` の `-N` と `-f` フラッグを調べ、
   バックグラウンドのポートフォワーディングを実行するコマンドは何か考えてみましょう。
