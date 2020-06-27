---
layout: lecture
title: "Komut Satırı Ortamı"
date: 2019-01-21
ready: false
video:
  aspect: 56.25
  id: e8BO_dYxk5c
---

Bu dersimizde komut satırındaki iş yapma şeklimizi ve iş akışımızı iyileştirecek birkaç yöntemi ele alacağız. Dersimizin önceki bölümlerinde komut satırını kullandık, ancak bu aşamaya kadar komut satırında komutları çalıştırmaya odaklanmıştık. Bu dersimizde ise processleri (programların çalışan hali, işlem de denilebilir) eş zamanlı çalıştırmayı ve izlerini sürmeyi, processleri durdurmayı ve askıya almayı ve processleri arka planda çalıştırmayı ele alacağız.     

Dersimizin bu bölümünde yukarıdaki konulara ilave olarak komut satırı ortamımızı daha yetkin hale getirmek için kullanabileceğimiz araçlardan bazıları olan **alias** (kısaltmalar) kavramını ve **dotfile** adı verilen konfigürasyon dosyalarının kullanımını öğreneceğiz. Alias tanımları ve dotfile dosyaları uzun komutları tekrar tekrar yazmamıza gerek kalmadan kullanmamızı sağlarlar. Örneğin, farklı bilgisayarlarda çalışırken bu araçların kullanılması bize zaman kazandırır. Son olarak bu dersimizde uzaktaki bilgisayarlara SSH kullanarak nasıl erişebileceğimizi de ele alacağız.

# Görev Kontrolü

Bazı durumlarda devam eden bir görevi sonlandırma ihtiyacınız olacak. Örneğin uzun süren bir görevin (kapsamlı bir dizin yapısında arama yapmak için kullanılan `find` komutu gibi) durdurulması gibi. Çoğu zaman bu tür görevleri `Ctrl-C` tuş kombinasyonu ile durdurabilirsiniz. Gelin şimdi bu tuş kombinasyonun nasıl çalıştığını ve bazen processleri durdururken neden hata verdiğini ayrıntıları ile inceleyelim.

## Processleri Sonlandırma

Komut satırınız processler ile bilgi paylaşımında bulunmak için UNIX işletim sistemi seviyesinde yer alan ve _signal_ (sinyal) adı verilen bir iletişim yöntemi kullanır. Herhangi bir processese bir sinyal geldiğinde process çalışmasını durdurur, gelen sinyali işler ve sinyalin tipine ve içeriğine göre akışını değiştirir. Bu nedenle sinyaller kavram olarak birer _software interrupt_ (yazılım kesmesi) olarak değerlendirilir. 

> **Çevirmenin Notu:** Interrupt (kesme) kavramını yazılım veya donanım seviyesinde sistem bileşenlerinin birbirleri ile haberleşmek için kullandıkları bir yapı olarak düşünebilirsiniz. Yazılım seviyesinde kullanılan kesmeler _sofware interrput_ (yazılım kesmesi) olarak adlandırılır. Donanım (CPU, GPU) seviyesinde kullanılan kesmelere ise _hardware imterrupt_ (donanım kesmesi) olarak adlandırılır. Donanım kesmeleri için IRQ adı verilen ve donanıma doğrudan bağlı fiziksel veri yolu hatları kullanılır.

Bizim örneğimizdeki `Ctrl-C` tuş kombinasyonu uygulandığında komut satırı `SIGINT` adı verilen sinyali process'e gönderir.

Aşağıda `SIGINT` sinyalini yakalayan ve bu sinyali göz ardı ederek çalışmasına devam eden örnek bir Python programı örneği yer alıyor. Bu programı sonlandırmak için `Ctrl-\` tuş kombinasyonu ile üretilen `SIGQUIT` isimli sinyali kullanabiliriz.

```python
#!/usr/bin/env python
import signal, time

def handler(signum, time):
    print("\nSIGINT sinyalini yakaladım ama durmayacağım")

signal.signal(signal.SIGINT, handler)
i = 0
while True:
    time.sleep(.1)
    print("\r{}".format(i), end="")
    i += 1
```

Aşağıdaki terminal çıktısında örnek programımızın arka arkaya iki defa `SIGINT` sinyali alıp ardından da `SIGQUIT` sinyalini aldığında sergileyeceği davranışı görebilirsiniz. 

> Terminal çıktısında `Ctrl` tuşu `^` sembolü ile temsil edilmektedir.

```
$ python sigint.py
24^C
SIGINT sinyalini yakaladım ama durmayacağım
26^C
SIGINT sinyalini yakaladım ama durmayacağım
30^\[1]    39913 quit       python sigint.py
```

> **Çevirmenin Notu:** Terminal, komut satırı (shell) uygulamasının kullanıcı ile etkileşimde bulunması için kullanılan uygulamalara verilen genel bir isimdir.

Genelde terminal ile alakalı kesme istekleri `SIGINT` ve `SIGQUIT` sinyalleri ile ilişkilendirilir. Ancak, process'leri düzgün bir şekilde sonlandırmak için daha jenerik bir sinyal olan `SIGTERM` kullanılır. Process'e `SIGTERM` sinyalini göndermek için [`kill`](https://www.man7.org/linux/man-pages/man1/kill.1.html) komutunu `kill -TERM <PID>` şeklinde kullanabiliriz.


## Processleri Askıya Alma ve Arka Plana Atma

Sinyaller processleri durdurmanın yanı sıra farklı amaçlar için de kullanılabilir. Örneğin, `SIGSTOP` sinyali process'i askıya alır. Terminal'de `Ctrl-Z` tuş kombinasyonu uygulandığında komut satırı process'e `SIGTSTP` sinyalini gönderir. `SIGTSTP` sinyali _Terminal Stop_ ifadesinin kısaltmasıdır (`SIGSTOP` sinyalinin terminal versiyonu olarak da düşünebilirsiniz)

Askıya alınan görevlerin ön planda çalışmaya devam etmeleri için [`fg`](https://www.man7.org/linux/man-pages/man1/fg.1p.html) komutunu, arka planda çalışmaya devam etmeleri için de [`bg`](http://man7.org/linux/man-pages/man1/bg.1p.html) komutunu kullanabiliriz. 

[`jobs`](https://www.man7.org/linux/man-pages/man1/jobs.1p.html) komutu aktif terminal oturumunda çalışan görevleri listelemek için kullanılır. Bu görevler ile ilişkili komutlarınızda görevlerin pid ( görevleri adları ile veya farklı özellikleri ile aramak için [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html komutunu kullanabilirsiniz) değerlerini kullanabilirsiniz. Process'lere referans vermek için pid değerlerine alternatif olarak, daha kolay bir kullanım sunan, `%` sembolü ve görev numarası (`jobs` komutu tarafından listelenir) kombinasyonunu da kullanabilirsiniz. En son çalıştırılan arka plan görevine referans vermek için ise `$!` özel parametre değerini kullanabilirsiniz.

> **Çevirmenin Notu:** PID, UNIX'de _Process Identification Number_ adı verilen ve işletim sistemi tarafından otomatik olarak her process için üretilen 5 basamaklı sayısal bir değerdir.


Son bir bilgi olarak, herhangi bir komutun sonuna `&` eklerseniz ilgili komutun arka planda çalışacağını paylaşalım. Bu sayede komut satırı farklı komutlar girebilmeniz için serbest kalır. Ancak, `&` son eki ile çalıştırılan komutlar STDOUT olarak hala sizin komut satırınızı kullanacak ve bu durum zaman zaman işinizi zorlaştıracaktır (bu durumda arka plan komutlarının çıktıları için komut satırı yönlendirmelerini kullanabilirsiniz). 

> **Çevrimenin Notu:** STDOUT, _standard output_ ifadesinin kısaltmasıdır. STDOUT UNIX benzeri işletim sistemlerinde processlerin çıktılarını yazabileceği bir dosya tanımlayıcısını ifade eder. Genel olarak STDOUT ekranda çıktıları görmemizi sağlayan terminali ifade ederken uç bir örnek olarak bir yazıcının da STDOUT olarak tanımlanması ve process çıktılarının doğrudan yazıcıya gönderilmesi de mümkündür.


Çalışan bir process'i arka plana göndermek için process çalışırken `Ctrl-Z` tuş kombinasyonunu uygulayıp hemen ardından `bg` komutunu yazmalısınız. Ancak, arka plan processlerinizin terminalinizin alt processleri olduğunu unutmayın. Terminalinizi kapattığınızda ön planda veya arka planda çalışan tüm processleriniz de terminaliniz ile birlikte sonlandırılacaktır (bu durumda alt processlere `SIGHUP` sinyali gönderilir). Terminal kapatıldığında alt processlerin de sonlandırılmasını önlemek için processi [`nohup`](https://www.man7.org/linux/man-pages/man1/nohup.1.html) (`SIGHUP` sinyalini yakalayıp göz ardı eden bir çerçeve kod parçası veya programcık) veya `disown` parametreleri ile çalıştırmalısınız. Bu parametrelere alternatif olarak, bir sonraki bölümde ele alacağımız, terminal çoklayıcıları (multiplexer) da kullanabilirsiniz.

Yukarıdaki kavramların kullanımını gösteren örnek terminal çıktısını aşağıda inceleyebilirsiniz.

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

Özel bir sinyal olan `SIGKILL` process'ler tarafından yakalanamaz ve bu sinyal processleri anında sonlandırır. Ancak, bu sinyal alt processleri yetim (orphaned) bırakmak gibi yan etkilere sahiptir.

Bahsettiğimiz sinyaller ve diğer sinyaller hakkında daha fazla bilgi almak için [şu linkten](https://en.wikipedia.org/wiki/Signal_(IPC)) faydalanabilir veya komut satırında [`man signal`](https://www.man7.org/linux/man-pages/man7/signal.7.html)  veya `kill -t` komutlarını kullanabilirsiniz.


# Terminal Çoklayıcılar (Multiplexer)

Komut satırı ara yüzünü kullanırken zaman zaman aynı anda birden fazla şey yapmak isteyeceksiniz. Örneğin, kod editörünüz ile programınızı yan yana aynı anda çalıştırmak isteyebilirsiniz. Bu işlemleri ihtiyaç duydukça yeni terminal penceresi açarak yapabileceğiniz gibi bir terminal çoklayıcılar kullanarak daha esnek bir şekilde yapabilirsiniz.

[`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) gibi terminal çoklayıcılar terminal pencerelerini sekmeler (tab) veya bölmeler (pane) kullanarak çoklamanızı ve birden fazla komut satırı oturumundan bu pencerelere erişmenizi ve işlem yapmanızı sağlarlar. Tüm bunlara ilave olarak, terminal çoklayıcılar herhangi bir terminal oturumunu ayırarak bağımsız kullanmanızı ve daha sonra ihtiyaç duymanız halinde bu oturumu var olan bir terminal oturum ile ilişkilendirerek birleştirmenizi sağlarlar. Bu imkanlar, özellikle uzaktan eriştiğiniz bilgisayarlar ile çalışırken `nohup` gibi araçları kullanmaya gerek kalmadan iş akışınızı iyileştirecektir.  


Son zamanların en popüler terminal çoklayıcı aracı [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html)'dur. `tmux`, ciddi anlamda konfigüre edilebilen ve tuş kombinasyonu eşleştirmeleri sayesinde farklı sekmeler ve bölmeler arasında hızlıca konumlanmanızı sağlayan esnek bir yapıya sahiptir.

`tmux` kullanırken tuş kombinasyonu eşleştirmelerini bilmeniz gerekir. Bu eşleştirmeler `<C-b> x` formatında olup (1) önce `Ctrl+b` kombinasyonuna basmanız, (2) ardından `Ctrl+b` tuş kombinasyonunu serbest bırakıp (3) son olarak `x`'e basmanız gerekir.`tmux`, aşağıdaki nesne hiyerarşisine sahiptir:
- **Oturumlar** (Sessions) - oturum bir veya daha fazla penceresi olan bağımsız bir çalışma alanıdır
    + `tmux` yeni bir oturum başlatır.
    + `tmux new -s NAME` NAME parametresi ile adı belirtilen yeni bir oturum başlatır.
    + `tmux ls` tüm oturumları listeler.
    + `tmux` aktif durumda iken `<C-b> d` tuş kombinasyonu kullanarak o anki oturumu sökerek bağımsız hale getirebilirsiniz.
    + `tmux a` son oturumu birleştirmenizi sağlar. `-t` flag'ini kullanarak hangi oturumu birleştireceğinizi belirtebilirsiniz.

- **Pencereler** (Windows) - Kod editörleri veya tarayıcılardaki sekmelere benzerler. Pencereler aynı oturumun görsel olarak bağımsız parçalarıdır
    + `<C-b> c` Yeni bir pencere oluşturur. Açık pencereyi kapatmak için komut satırında `<C-d>` tuş kombinasyonunu kullanmanız yeterlidir.
    + `<C-b> N` _N._ pencereye konumlanmanızı sağlar. Her pencerenin bir numarası vardır.
    + `<C-b> p` Önceki pencereye konumlanmanızı sağlar.
    + `<C-b> n` Önceki pencereye konumlanmanızı sağlar.
    + `<C-b> ,` Aktif pencerenin ismini değiştirmenizi sağlar.
    + `<C-b> w` Pencereleri listelemenizi sağlar.

- **Bölmeler** (Panes) - vim'deki ayrılmış editör alanları gibi, bölmeler aynı ekranda birden fazla komut satırı kullanılabilmesini sağlarlar.
    + `<C-b> "` Bölmeyi yatay olarak ikiye bölmenizi sağlar.
    + `<C-b> %` Bölmeyi dikey olarak ikiye bölmenizi sağlar.
    + `<C-b> <direction>` Belirtilen _yön_'deki bölmeye konumlanmanızı sağlar. `<direction>` ile kastedilen yön tuşlarıdır.
    + `<C-b> z` Bölmenin yakınlaştırma faktörünü değiştirmenizi sağlar.
    + `<C-b> [` Geriye doğru kaydırma işlemini başlatır. Bu işlemi başlattıktan sonra `<space>` tuşuna basarak seçme işlemi başlatıp ardından da `<enter>` tuşuna basarak seçimi kopyalamanızı sağlar.
    + `<C-b> <space>` Bölmeler arasında sıralı olarak gezinmenizi sağlar.

Daha fazla ayrıntı için,
[şu linkte](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) yer alan `tmux` ile ilgili yazıyı ve [şu linkte](http://linuxcommand.org/lc3_adv_termmux.php) yer alan daha ayrıntılı ve `screen` komutunu da ele alan yazıyı okuyabilirsiniz. Bu iki kaynağa ilave olarak çoğu UNIX sistemde kurulu olarak gelen [`screen`](https://www.man7.org/linux/man-pages/man1/screen.1.html) komutunun ayrıntılarına da bakmak isteyebilirsiniz.

# Komut Kısaltmaları (Aliases)


Birçok flag ve ayrıntılı seçenek içeren komutları her defasında tekrar tekrar yazmak yorucu olabilir. Bu nedenle, çoğu komut satırı _komut kısaltmalarını_ destekler. Komut kısaltması, komut satırınızın sizin yerinize otomatik olarak yer değiştireceği uzun bir komutun kısa halidir. Örneğin, bash komut satırındaki komut kısaltmaları aşağıdaki yapıya sahiptir:

```bash
alias alias_name="kisaltilacak_komut arg1 arg2"
```

Yukarıdaki örnekte `=` sembolünün önünde ve arkasında boşluk olmadığına dikkat edin. Bunun nedeni [`alias`](https://www.man7.org/linux/man-pages/man1/alias.1p.html) komutunun tek argüman alan bir komut olmasıdır.

Komut kısaltmalarının kullanışlı pek çok özelliği vardır:

```bash
# Yaygın kullanılan -lh gibi flag'ler için kısayol oluşturmak için
alias ll="ls -lh"

# Yagın kullanılan uzun komutlar için kısayol oluşturma ve basılan tuş sayısını azaltmak için
alias gs="git status"
alias gc="git commit"
alias v="vim"

# Hatalı yazımları tölere etmek için
alias sl=ls

# Var olan komutları daha kullanışlı varsayılan değerler ile tanımlamak için
alias mv="mv -i"           # -i dosyanın üstüne yazmadan önce onay almak için kullanılan flag
alias mkdir="mkdir -p"     # -p ihtiyaç halinde üst dizinleri de oluşturmak için kullanılan flag
alias df="df -h"           # -h daha kolay okunabilir formatta basmak için kullanılan flag

# Kısaltma tanımında başka kısaltmalar da kullanılabilir
alias la="ls -A"
alias lla="la -l"

# Kısaltmalar ile ezdiğiniz var olan bir komutun orjinalini kullanmak için önüne \ koyun
\ls
# Tanımlı bir kısaltmayı unalias ile devre dışı bırakabilirsiniz
unalias la

# Kısaltmanın tanımını görmek için alias komutunu kısaltma adı parametresi ile çağırın 
alias ll
# Çıktısı ll='ls -lh' olacaktır
```

Komut kısaltmaları komut satırı oturumu sonlandığında geçersiz hale gelirler, yani normal şartlar altında kısaltmalarınız sadece tanımlı oldukları oturum için geçerlidirler. Komut kısaltmalarınızı tüm komut satırı oturumlarınızda kullanmak için kısaltmaları komut satırı konfigürasyon dosyalarının içinde tanımlamanız gerekir. Örneğin, bash komut satırı için kısaltmalarınızı `.bashrc` içinde veya benzer bir şekilde zsh kısaltmalarınızı da `.zshrc` konfigürasyon dosyası içinde tanımlamanız gerekir.


# Konfigürasyon Dosyaları (Dotfiles)

Çoğu programın konfigürasyonu _dotfiles_ adı verilen saf metin dosyalarında tanımlanır. Bu dosyalara _dotfiles_ denilmesinin nedeni dosya isimlerinin `.` ile başlamasıdır. Örneğin, `~/.vimrc` vim editörünün konfigürasyon dosyasıdır. Dosya isimlerinin `.` ile başlaması nedeni ile `ls` komutu varsayılan olarak gizili olan bu dosyaları listelemez.

Komut satırları bu tür dosyalar kullanılarak konfigüre edilen programlara iyi bir örnektir. Komut satırı programı çalıştırıldığında konfigürasyonlarını farklı birçok dosyadan okurlar. Komut satırı programınıza (bash, zsh vb.), komut satırını etkileşimli ve/veya kullanıcı oturumu ile başlatıp başlatmadığınıza bağlı olarak komut satırı programının başlatılma adımları çok karmaşık olabilir. Bu adımların ayrıntılarına harika bir kaynak olan [şu linkteki](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) yazıdan bakabilirsiniz. 


`bash` komut satırını kullanıyorsanız `.bashrc` veya `.bash_profile` dosyasını düzenlemeniz çoğu UNIX sisteminde yeterli olacaktır. Bu dosyalara, önceki bölümde bahsettiğimiz kısaltmalar veya `PATH` ortam değişkeninin içeriği gibi, komut satırı ilk çalışma anında yapılmasını istediğiniz işlemleri konfigürasyon olarak tanımlayabilirsiniz. Aslında kullandığınız çoğu programı komut satırından çalıştırabilmek için bu programların yer aldığı dizinleri komut satırı konfigürasyon dosyasına `export PATH="$PATH:/path/to/program/bin"` benzeri bir değer ile tanımlamanız gerekir. 

Dotfiles dosyalarını kullanarak konfigüre edebileceğiniz diğer bazı programlar şunlardır:

- `bash` komut satırı için `~/.bashrc`, `~/.bash_profile` 
- `git` kaynak kodu kontrol programını için `~/.gitconfig` 
- `vim` kod editörü için `~/.vimrc` dosyası ve `~/.vim` dizini.
- `ssh` uzak bilgisayarlara erişim programı için `~/.ssh/config`
- `tmux` komut satırı çoklayıcısı için`~/.tmux.conf`


Dotfile dosyalarını nasıl organize etmelisiniz? Bu dosyaların kendi dizinlerinde, kaynak kodu kontrolü altında (git, mercurial vb.) ve sembolik linkler kullanılarak tanımlanması gerekir.

> **Çevirmenin Notu:** Sembolik linkler UNIX benzeri işletim sistemlerinde özel bir dosya türü olup orjinal dosyanın konumunu barındırırlar.

Bu organizasyon şeklinin şu avantajları vardır:

- **Kolay kurulum**: yeni bir bilgisayara giriş yaptığınızda kendi konfigürasyonu bu bilgisayara dakikalar içinde uygulayabilirsiniz.
- **Taşınabilirlik**: araçlarınız her yerde aynı şekilde çalışacaktır.
- **Senkronizasyon**: dotfile dosyalarınız istediğiniz bilgisayarda düzenleyip diğer tüm bilgisayarlarınıza senkronize tutabilirsiniz.
- **Değişiklik takibi**: yazılımcılık kariyeriniz boyunca dotfile dosyalarınızı yönetmeniz gerekecektir. Bu nedenle değişiklik tarihçesine sahip olmak uzun soluklu çalışmalarınızda iyi olacaktır.

Neleri dotfile dosyalarınıza koymalısınız? Araçlarınızın konfigürasyonları ile ilgili ayrıntılara ilgili araçların çevrimiçi dokümanlarından veya [man](https://www.man7.org/linux/man-pages/man1/man.1.html) komutu ile görüntüleyebileceğiniz [elkitabı (man pages)]((https://en.wikipedia.org/wiki/Man_page) ) sayfalarından inceleyebilirsiniz. Alternatif olarak internette arama yaparak bulacağınız blog yazılarında yazarların bu araçlar için kullandıkları konfigürasyonlar hakkında bilgi alabilirsiniz. Kullandığınız araçların konfigürasyonları ile ilgili en iyi yöntemlerden bir diğeri de başkalarının dotfile dosyalarını incelemektir: Github'da [şu aramayı](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories) yaparak dotfile konfigürasyon dosyaları içeren depoları bulabilirsiniz. Bu depolardan en popüler olanına [şu linkten](https://github.com/mathiasbynens/dotfiles) göz atabilirsiniz (bu konfigürasyonları kopyala/yapıştır ile körü körüne incelemeden kullanmamanızı öneriyoruz).
Konu ile ilgili güzel kaynaklardan biri olan [şu linkteki](https://dotfiles.github.io/) sayfayı da inceleyebilirsiniz.

Bu dersi veren hocaların dotfile konfigürasyon dosyalarına açık olarak şu Github linklerinden erişebilirsiniz: [Anish](https://github.com/anishathalye/dotfiles),
[Jon](https://github.com/jonhoo/configs),
[Jose](https://github.com/jjgo/dotfiles).


## Taşınabilirlik

dotfile konfigürasyon dosyaları ile ilgili sorunlardan en önemlisi bu konfigürasyonların farklı bilgisayarlara taşınması halinde çalışmamasıdır. Örneğin, bilgisayarların farklı işletim sistemleri olabilir veya farklı komut satırı programları kullanılıyor olabilir. Bazı durumlarda bir konfigürasyonun sadece belirli bir ortamda geçerli olmasını da isteyebilirsiniz.

Bu durumları daha kolay yönetmek için birkaç numara kullanabilirsiniz. Konfigürasyon dosyanızın desteklemesi durumunda koşullu dallanma (if statement) cümlesine benzer yapıları kullanabilirsiniz. Örneğin, komut satırı konfigürasyon dosyanızda şöyle bir kullanım söz konusu olabilir:

```bash
if [[ "$(uname)" == "Linux" ]]; then {bir_islem_yap}; fi

# Komut satırı programına özel işlem yapmak için
if [[ "$SHELL" == "zsh" ]]; then {baska_bir_islem_yap}; fi

# Konfigürasyonu bilgisayara özel tanımlamak için
if [[ "$(hostname)" == "sunucu_adi" ]]; then {bir_islem_yap}; fi
```

Programınızın konfigürasyon dosyası destekliyorsa `include` benzeri yapıları kullanabilirsiniz. Örneğin `~/.gitconfig` dosyasında aşağıdakine benzer bir ayar yapabilirsiniz:

```
[include]
    path = ~/.gitconfig_local
```

Yukarıdaki tanım yapıldıktan sonra her bir bilgisayarda `~/.gitconfig_local` isimli konfigürasyon dosyası oluşturulup o bilgisayara özel konfigürasyon değerleri bu dosyada tanımlanabilir. Bu tür bilgisayara özel konfigürasyonları genel konfigürasyondan farklı bir kaynak kodu versiyon kontrolü deposunda kayıt altına alıp takip edebilirsiniz.

Bu yaklaşım, farklı programların ortak bir konfigürasyonu kullanma ihtiyacı olduğu durumlarda da uygulanabilir. Örneğin, `bash` ve `zsh` komut satırlarınızda aynı komut kısaltmalarını kullanmak istiyorsanız bu kısaltmaları `.aliases` konfigürasyon dosyasında tanımlayıp aşağıdaki şekilde komut satırınızı konfigüre edebilirsiniz:

```bash
# ~/.aliases dosyası var mı kontrol et, varsa dosya içeriğini source komutu ile yükle
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi
```

> **Çevirmenin Notu:** include benzeri yapılar birden fazla konfigürasyon dosyasının birleştirilmesini ve varsa tanımlı hiyerarşik üstünlük kurallarına göre değerlerden hangisinin geçerli kılınacağını tanımlamak için kullanılır



# Uzaktaki Bilgisayarlara Erişim

Yazılımcıların günlük iş akışlarında uzaktaki bilgisayarlara erişme ihtiyacı gün geçtikçe alışılmış bir hal aldı. Uzaktaki bir sunucuya backend yazılımının yeni bir versiyonunu yüklemek için veya daha yüksek işlem gücüne sahip bir sunucuda kodunuzu çalıştırmak için Secure Shell (SSH) kullanmanız gerekecektir. Dersimizde ele aldığımız tüm araçlar gibi SSH da esnek ve konfigüre edilebilen bir araçtır. Bu nedenle, SSH ile ilgili biraz ayrıntı öğrenmenin zararı olmayacaktır.

Uzaktaki bir sunucuda `ssh` ile erişmek için aşağıdaki komutu kullanabiliriz:

```bash
ssh foo@bar.mit.edu
```

Yukarıdaki komutta `foo` kullanıcısı ile `bar.mit.edu` isimli sunucuya bağlanmaya çalışıyoruz. Komutta belirtilen sunucuyu bir URL (`bar.mit.edu`) veya IP (`foobar@192.168.1.42`) adresi kullanarak tanımlayabiliriz. İlerleyen kısımlarda ssh konfigürasyon dosyasını düzenleyerek ilgili sunucuya `ssh bar` benzeri bir komut ile bağlanabileceğimizi göreceğiz.

## Komut çalıştırma

`ssh`'ın genelde göz ardı edilen özelliklerinden biri de doğrudan komut çalıştırma yeteneğidir. `ssh foobar@server ls` komutu `ls` komutunu doğrudan foobar sunucunun kök (home) dizininde çalıştırır. Bu özellik UNIX benzeri sistemlerde geniş bir kullanımı olan ve programlar arasında çıktı aktarımını sağlayan pipe yapısı ile de kullanılabilir. Örneğin, `ssh foobar@server ls | grep PATTERN` komutu uzak bilgisayarda çalışan `ls` komutunun çıktısında kendi bilgisayarınızda `grep` ile `PATTERN` örüntüsünü arayacak. `ls | ssh foobar@server grep PATTERN` komutu ise kendi bilgisayarınızda çalıştırılan `ls` komutunun çıktısını uzak sunucuya göndererek uzak sunucu üzerinden `grep` ile aynı aramayı yapacaktır.

## SSH Anahtarları

Anahtar tabanlı doğrulama yöntemi ile açık-anahtar (public-key) şifreleme kullanılarak sunucu bilgisayarın istemci bilgisayarın özel anahtarını (private key) ifşa etmeden bu özel anahtarın gerçek sahibi olduğunu doğrulaması sağlanır. Bu sayede `ssh` ile uzak sunucuya erişmek için her seferinde şifrenizi girmenize gerek kalmaz. Bu yöntemi kullandığınızda size özel anahtarınız (genelde `~/.ssh/id_rsa` ve son sürümlerde `~/.ssh/id_ed25519` isimli dosyada kayıt altına alınır) şifreniz yerine geçer.

### Anahtar üretme

Kendinize özel bir anahtar çifti (public-private key) üretmek için [`ssh-keygen`](https://www.man7.org/linux/man-pages/man1/ssh-keygen.1.html) komutunu kullanabilirsiniz.

```bash
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519
```
Anahtar çifitini üretirken, özel anahtarınızı ele geçiren birisinin bu anahtarı kullanarak uzak sunuculara erişmesini önlemek için passphrase adı verilen bir şifre tanımlamalısınız. Anahtar çiftini ürettikten sonra şifrenizi her seferinde girmemek için [`ssh-agent`](https://www.man7.org/linux/man-pages/man1/ssh-agent.1.html) veya [`gpg-agent`](https://linux.die.net/man/1/gpg-agent) programlarından birini kullanabilirsiniz. 

Kodunuzu Github'a göndermek için SSH anahtarlarını kullanıyorsanız [şu linkte](https://help.github.com/articles/connecting-to-github-with-ssh/)'ki adımları takip ederek bir anahtar çifti üretmiş olmalısınız. Şifrenizin olup olmadığını ve geçerliliğini kontrol etmek için `ssh-keygen -y -f /path/to/key` komutunu kullanabilirsiniz.

### Anahtar tabanlı doğrulama

`ssh`, hangi istemcilerin erişimine izin vereceğini belirlemek için `.ssh/authorized_keys` dosyasının içeriğini kullanır. Açık anahtarınızı uzak bilgisayada tanımlamak için aşağıdaki komutu kullanabilirsiniz:

```bash
cat .ssh/id_ed25519.pub | ssh foobar@remote 'cat >> ~/.ssh/authorized_keys'
```

Açık anahtarınızı kopyalama işlemini `ssh-copy-id` programını kullanarak aşağıdaki komut ile de yapabilirsiniz:

```bash
ssh-copy-id -i .ssh/id_ed25519.pub foobar@remote
```

## SSH ile dosya kopyalama

SSH ile dosya kopyalamanın birçok yolu vardır:

- `ssh+tee`, en basit yöntem `ssh` komutunu ve STDIN ile girdi alarak şu komutu kullanmaktır `cat localfile | ssh remote_server tee serverfile`. [`tee`](https://www.man7.org/linux/man-pages/man1/tee.1.html) komutu STDIN çıktısını bir dosyaya yazmak için kullanılır.
- [`scp`](https://www.man7.org/linux/man-pages/man1/scp.1.html) büyük dosya ve klasörleri kopyalarken güvenli kopyalama için `scp` komutunu kullanabilirsiniz. `scp` komutu dizinleri öz yinelemeli (recursive) olarak kopyalamamızı sağladığı daha kullanışlı bir komuttur. Bu komutun söz dizimi `scp path/to/local_file remote_host:path/to/remote_file` şeklindedir
- [`rsync`](https://www.man7.org/linux/man-pages/man1/rsync.1.html) `scp`'nin sağladığı kullanım kolaylığını daha da ileriye taşıyarak kendi bilgisayarınızdaki ve uzak sunucudaki dosyaların aynı içeriğe sahip olup olmadığını tespit ederek aynı içeriğe sahip dosyaların tekrar tekrar kopyalanmamasını sağlar. `rsync` aynı zamanda sembolik linkleri, dosya ve dizin yetkilerini daha iyi denetlememizi sağlar,  `--partial` flag'i ile de kesintiye uğrayan kopyalama işlemlerinizin sonradan kaldıkları yerden devam etmesini sağlayan ekstra özelliklere sahiptir. `rsync` komutunun söz dizimi `scp`'nin söz dizimine benzemektedir.

## Port Yönlendirme

Çoğu program bilgisayardaki belirli portları dinler. Herhangi bir program kendi bilgisayarınızdaki bir portu dinliyorsa `localhost:PORT` veya `127.0.0.1:PORT` yazarak programa ilgili port üzerinden veri gönderebilir veya alabilirsiniz. Ancak, uzak bir sunucudaki bir porta erişmek isterseniz ve bu uzak sunucunun ilgili portu ağ üzerinden erişebilir değilse ne yapacaksınız?

Yukarıda belirttiğimiz port işlemlerine _port yönlendirme_ denir ve iki şekilde yapılır: Yerel Port Yönlendirme ve Uzaktaki Portu Yönlendirme (ayrıntılar için aşağıdaki resimleri inceleyebilirsiniz, bu resimler [şu StackOverflow post'undan alıntıdır](https://unix.stackexchange.com/questions/115897/whats-ssh-port-forwarding-and-whats-the-difference-between-ssh-local-and-remot)).

**Yerel Port Yönlendirme**
![Yerel Port Yönlendirme](https://i.stack.imgur.com/a28N8.png  "Yerel Port Yönlendirme")

**Uzaktaki Portu Yönlendirme**
![Uzaktaki Portu Yönlendirme](https://i.stack.imgur.com/4iK3b.png  "Uzaktaki Portu Yönlendirme")

En alışılmış senaryolardan birisi yerel port yönlendirmedir. Bu senaryoda uzaktaki bir sunucuda çalışan bir program bu sunucudaki bir portu dinler, siz de kendi bilgisayarınızdaki bir portu uzak sunucudaki bu porta yönlendirirsiniz. Örneğin, uzak sunucuda `8888` portunu dinleyen `jupyter notebook` programını çalıştırıp `8888` portunu kendi bilgisayarınızdaki (yerel) `9999` portuna `ssh -L 9999:localhost:8888 foobar@remote_server` komutu ile yönlendirip kendi bilgisayarınızda `locahost:9999` yazarak uzak sunucudaki programa erişebilirsiniz.

## SSH Konfigürasyonu

Bu bölümde `ssh` komutu ile kullanabileceğimiz birçok argümanı ele aldık. `ssh` komutunu her seferinde bu argümanları tekrar tekrar yazarak kullanmak yerine aşağıdakine benzer komut kısaltmaları oluşturabilirsiniz
```bash
alias my_server="ssh -i ~/.id_ed25519 --port 2222 -L 9999:localhost:8888 foobar@remote_server
```

Ancak, komut kısaltmaları kullanmak yerine daha iyi bir alternatif olarak `~/.ssh/config` konfigürasyon dosyasını kullanabilirsiniz.

```bash
Host vm
    User foobar
    HostName 172.16.174.141
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
    LocalForward 9999 localhost:8888

# Konfigürasyonlarda wildcard da kullanabilirsiniz
Host *.mit.edu
    User foobaz
```

Kısaltmalar yerine `~/.ssh/config` kullanmanın diğer bir avantajı da  `scp`, `rsync` ve `mosh` gibi programların bu konfigürasyonu okuyarak kendilerine özel flag'lere dönüştürebilmeleridir.

`~/.ssh/config` konfigürasyon dosyasının genel anlamda diğer dotfile dosyalarınız ile aynı olduğunu söyleyebiliriz. Bu dosyayı da diğer dotfile dosyalarınız ile birlikte yönetebilirsiniz. Ancak, `~/.ssh/config` dosyasını açık olarak erişime açarsanız bu dosya içinde yer alan sunucu isimlerini, kullanıcı adlarını ve port bilgilerini tanımadığınız insanlar ile paylaşmış olursunuz. Bu hassas bilgilerin paylaşılması sunucularımızı hedef alan saldırılara neden olabilir, bu nedenle SSH konfigürasyonunuzu paylaşırken iki defa düşünün.

Sunuculardaki ssh konfigürasyonu genelde `/etc/ssh/sshd_config` dosyasında yer alır. Bu konfigürasyon dosyası içinde şifre ile erişimi engelleme, ssh portlarını değiştirme ve  X11 yönlendirme gibi değişiklikleri yapabilirsiniz. Sunucu üzerindeki konfigürasyonu kullanıcı bazında da özelleştirebilirsiniz.

## Diğer Konular

Uzak sunuculara erişim ile ilgili karşılaşılan genel sorunlardan bir tanesi de sunucunun uyku moduna geçmesi ve ağ değişikliği gibi nedenler ile oluşan bağlantı kopmalarıdır. Özellikle gecikme süresi uzun olan SSH bağlantıları kafanızı karıştırabilir. [Mosh](https://mosh.org/), mobil komut satırı, ağ değişikliklerini ve kısa süreli kesintileri yönetip akıllı yerel echo imkanı sunarak ssh'ı bir adım öteye taşır.

Bazen uzak sunucudaki bir dizini kendi bilgisayarınıza mount etmek isteyebilirsiniz. Bunun için [sshfs](https://github.com/libfuse/sshfs) aracını kullanarak uzak dizine kendi bilgisayarınızdaki bir dizin gibi erişebilirsiniz.

# Komut Satırları & Çatılar (Framework)

Komut satırı aracı ve scripting bölümünde `bash` komut satırını ele aldık, çünkü `bash` en yaygın kullanılan, kullanımı en kolay olan ve çoğu işletim sisteminde varsayılan komut satırı olarak hazır kurulu gelmektedir. Ancak, `bash` tek komut satırı seçeneği değildir.

Örneğin, `zsh` komut satırı `bash`'in bir üst kümesidir ve aşağıda birkaç örneğini verdiğimiz birçok kullanışlı özelliğe sahiptir:

- Daha akıllı globbing, `**`
- Inline globbing/wildcard genişletme
- Yazım kontrolü ve düzeltme
- Daha iyi komut tamamlama ve seçim
- Dizin yolu genişletme (örneğin `cd /u/lo/b` ifadesi `/usr/local/bin` şeklinde otomatik olarak genişletilir)

**Çatılar** (Frameworks) da komut satırınızın daha kullanışlı hale getirebilir. [prezto](https://github.com/sorin-ionescu/prezto) ve [oh-my-zsh](https://ohmyz.sh/) popüler çatılardan ikisidir, [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) veya [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) gibi daha özel ihtiyaçlara yönelik çatılar da vardır. [fish](https://fishshell.com/) gibi komut satırları ise kullanıcı dostu birçok özellik içerir. Kullanıcı dostu bu özelliklerden bazıları şunlardır:

- Sağdan sola yazılan diller için destek
- Komut dizimi renklendirme
- Komut tarihçesinde kısmi arama
- Elkitabı (man page) tabanlı flag tamamlama
- Daha akıllı otomatik komut tamamlama
- Temalar

Bu çatıları kullanırken akılda tutulması gereken konulardan biri bu çatıların komut satırınızı yavaşlatabileceğidir. Özellikle bu çatıların kodu performans için optimize edilmediyse veya gereğinden fazla kod içeriyorsa yavaşlık söz konusu olabilir. Böyle bir durum ile karşılaşırsanız bu çatıların çalışma anında inceleyebilir ve soruna neden olan özelliklerini kapatabilirsiniz veya iş akışınıza sağladıkları katkıya göre yavaşlığı kabullenerek kullanmaya devam edebilirsiniz.

# Terminal Emülatörleri

Komut satırınızı konfigüre ederek özelleştirmenin yanı sıra tercih edeceğiniz **terminal emülatörü** ve özellikleri için de biraz zaman harcamanız yerinde olacaktır. Kullanabileceğiniz birçok terminal emülatörü var (farklı emülatörlerini karşılaştırmasını [şu linkten](https://anarc.at/blog/2018-04-12-terminal-emulators-1/)inceleyebilirsiniz).

Terminal başında yüzlerce belki de binlerce saat geçireceğiniz için kullanacağınız terminalin ayarlarını incelemeniz iyi olacaktır. Aşağıda değiştirmek veya düzenlemek isteyeceğiniz bazı özellikleri sıralamaya çalıştık:  

- Yazı tipi seçimi
- Renk şeması
- Kısayol tuşları
- Sekme/bölme desteği
- Kaydırma konfigürasyonu
- Performans ([Alacritty](https://github.com/jwilm/alacritty) veya [kitty](https://sw.kovidgoyal.net/kitty/) gibi yeni nesil bazı terminaller GPU hızlandırma desteğine sahiptir).

# Alıştırmalar

## Görev kontrolü

1. Bu bölümde, `ps aux | grep` komutu ile görevlerimizin pid değerlerini bulmayı ve görevleri sonlandırmayı öğrendik. Ancak, görevleri sonlandırmanın daha iyi yöntemleri var. `sleep 10000` komutu ile terminalinizde bir görev başlatın, bu görevi `Ctrl-Z` ile arka plana atıp `bg` ile çalışmaya devam etmesini sağlayın. Sonra da [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) komutunu kullanarak bu görevin pid'ini bulun ve [`pkill`](http://man7.org/linux/man-pages/man1/pgrep.1.html) komutu ile pid'i kullanmadan bu görevi sonlandırın. (İpucu: `-af` flag'lerini kullanın).

1. Yeni bir process başlatmak için başka bir processin sonlanmasını gerektiren bir senaryomuz olsun. Bu işlemi nasıl gerçekleştirirsiniz? Bu alıştırmada bitmesini bekleyeceğimiz process `sleep 60 &` komutu ile başlattığımız processdir.
Bu işlemi gerçekleştirmenin yollarından bir tanesi [`wait`](https://www.man7.org/linux/man-pages/man1/wait.1p.html) komutunu kullanmaktır. sleep komutunu çalıştırıp `ls` komutunun arka plandaki sleep komutunun tamamlanmasını beklemesini sağlayın.

    Yukarıdaki strateji komutları farklı bash oturumlarında başlattığımızda doğru bir strateji olmayacaktır çünkü, `wait` komutu sadece alt processler için çalışır. Ders notlarında ele almadığımız komutlardan birisi de `kill` komutunun çıkış durumu değerinin başarı durumunda sıfır başarısızlık durumda ise sıfırdan farklı bir değer olduğudur. `kill -0` komutu process'e sinyal göndermez ancak process çalışmıyorsa sıfırdan farklı bir değer döndürür. `pidwait` isimli bir bash fonksiyonu oluşturun. Bu fonksiyon parametre olarak bir pid değeri alsın ve pid değeri ile tanımlanan process tamamlanana kadar beklesin. Bu fonksiyon çalışırken ve komutun tamamlanmasını beklerken gereksiz yere CPU kullanmamak için `sleep` komutunu kullanın.

## Terminal çoklayıcı

1. [Şu linkteki](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) `tmux` rehberini kullanarak ve [şu adımları](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/) adımları takip ederek basit özelleştirmeleri yapınız.

## Komut Kısaltmaları

1. `dc` isimli bir komut kısaltması tanımlayarak `cd` komutunun çalıştırılmasını sağlayın.

1.  `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10` komutunu çalıştırarak en çok kullandığınız 10 komutu listelerin ve bu 10 komut için daha kullanışlı komut kısaltmaları oluşturun. Not: yukarıdaki komut Bash için verilmiştir, eğer ZSH kullanıyorsanız, `history` yerine `history 1` kullanın.


## Dotfiles

1. dotfile dosyalarınız için bir dizin oluşturun ve bu dosyalar için versiyon kontrolü ayarlarını yapın.
1. Tanımladığınız klasöre kullandığınız programlardan birisi için içinde size özel özelleştirmelerin olduğu bir konfigürasyon dosyası ekleyin (başlangı olarak `$PS1` değişkenini düzenleyerek komut satırı promptunuzu özelleştirebilirsiniz).
1. dotfile konfigürasyonlarınızı otomatik olarak yeni bir bilgisayarda kullanmak için bir script geliştirin. Oluşturacağınız script her bir dosya için `ln -s` komutunu kullanacak kadar basit olabilir, veya bu işleme özel [yardımcı bir program](https://dotfiles.github.io/utilities/) kullanabilirsiniz.
1. dotfile kurulum scriptinizi temiz bir sanal bilgisayarda test edin.
1. Kullandığını tüm araçların dotfile konfigürasyonlarını dotfile deponuza taşıyın.
1. dotfile konfigürasyonlarınızı GitHub'da yayınlayın.

## Uzak Bilgisayarlar

Bu alıştırma için sanal bir Linux makinası oluşturun. Sanal makinalar ile ilgili bilginiz yoksa [şu linkteki](https://hibbard.eu/install-ubuntu-virtual-box/) adımları takip ederek bir tane oluşturun.

1. `~/.ssh/` dosyasını açın ve içinde bir anahtar çifti olup olmadığını kontrol edin. Anahtar çifit yoksa `ssh-keygen -o -a 100 -t ed25519` komutu ile bir tane anahtar çifit oluşturun. Anahtar çifti oluştururken bir şifre belirlemenizi ve `ssh-agent`'ı kullanmanızı öneriyoruz. `ssh-agent` kullanımı ile ilgili daha fazla bilgiye [şu linkten](https://www.ssh.com/ssh/agent) erişebilirsiniz.
1. `.ssh/config` dosyasına aşağıdaki konfigürasyonu ekleyin

```bash
Host vm
    User kullanıcı_adı
    HostName ip_adresi
    IdentityFile ~/.ssh/id_ed25519
    LocalForward 9999 localhost:8888
```
1. `ssh-copy-id vm` komutunu kullanarak ssh anahtarınızı sanal sunucuya kopyalayın.
1. Sanal makinanızda `python -m http.server 8888` komutunu kullanarak bir web sunucusu başlatın. Sanal makinanızdaki web sunucusuna kendi makinanızdan `http://localhost:9999` adresini kullanarak erişin.
1. Sanal makinanızdaki SSH konfigürasyonunuzu `sudo vim /etc/ssh/sshd_config` komutunu kullanarak açın ve `PasswordAuthentication` değerini değiştirerek şifre ile erişimi engelleyin. `PermitRootLogin` değerini değiştirerek root erişimini engelleyin.`ssh` servisini `sudo service sshd restart` komutu ile yeniden başlatın. Sanal makinanıza SSH ile tekrar erişmeyi deneyin.
1. (Meydan okuma) Sanal makinanıza [`mosh`](https://mosh.org/)'u kurun ve sunucuya bağlanın. Bağlandıktan sonra sanal sunucunun ağ kartını devreden çıkarın. mosh bu durumu tölere edebildi mi?
1. (Meydan okuma) `-N` ve `-f` flaglerinin `ssh`'da ne işe yaradığını öğrenip  arka planda port yönlendirme yapmak için bir komut yazın.
