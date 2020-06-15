---
layout: lecture
title: "Version Kontrol (Git)"
date: 2019-01-22
ready: true
video:
  aspect: 56.25
  id: 2sjqTHE0zok
---

Versiyon kontrol sistemleri (VKS'leri), kaynak koddaki (veya diğer dosya ve klasörlerdeki) değişiklikleri izlemek için kullanılan araçlardır. 
Adından da anlaşılacağı gibi, bu araçlar değişiklik geçmişinin korunmasına yardımcı olur; ayrıca, işbirliğini de kolaylaştırırlar.
VKS'ler bir klasördeki ve içeriğindeki değişiklikleri bir dizi snapshots'da(anlık görüntüde) izler,
burada her snapshot(anlık görüntü), üst düzey bir dizindeki tüm dosya/klasör durumunu kapsar.
Ayrıca VKS'ler oluşturulan tüm snapshot'larda bu snapshot'ı oluşturanın kim olduğunu ve snapshot ile ilişkilenmiş mesajlar ve benzeri meta verileri de beraberinde saklar.

Versiyon kontrolü neden yararlıdır? Kendi kendinize çalışırken bile, bir projenin eski anlık görüntülerine bakmanıza, belirli 
değişikliklerin neden yapıldığına dair kayıtlar tutmanıza, paralel gelişimtirme dallarında çalışmanıza ve çok daha fazlasına izin 
verebilir.
Başkalarıyla çalışırken, diğer insanların neleri değiştirdiğini görmek ve eş zamanlı geliştirmedeki conflict'leri(çatışmaları) çözmek için paha biçilmez bir araçtır.
 
Ayrıca modern VKS'ler aşağıdaki soruları kolayca (ve genellikle otomatik olarak) cevaplamanızı sağlar:

- Bu modülü kim yazdı?
- Bu dosyanın bu satırı ne zaman düzenlendi? Kim tarafından? Neden düzenlendi?
- 1000'in üzerinde revizyondan sonra belirli bir birim testi(unit test) neden/ne zaman çalışmayı durdurdu?

Bir çok VKS'i mevcut olsa da **Git**, versiyon kontrolü için fiili standarttır.
Bu [XKCD karikatürü](https://xkcd.com/1597/) Git'in izlenimini anlatır.

![xkcd 1597](https://imgs.xkcd.com/comics/git.png)

Çünkü Git arayüzüleri bazen soyut kalıp kafa karışıklığına sebep olabiliyor. 
Buna başlarken seçtiğiniz arayüz sebep olabilir(komut satırı arayüzü ya da görsel arayüzlü arabirim).
Bir avuç komutu ezberleyip onları büyülü sözler gibi düşünmek ve bir şeyler ters gittiğinde
 yukarıdaki karikatür gibi davranmak mümkündür.

Hiç kuşkusuz ki Git'in çirkin bir arayüzü olsada altında yatan fikri ve tasarımı çok güzeldir.
Çirkin bir arayüzün _ezberlenmesi_ gerekirken, güzel bir tasarım _anlaşılabilir._
Bu nedenle, Git'in veri modelinden başlayıp daha sonra komut satırı arayüzünüyle devam eden tepeden tırnağa bir anlatımını yapacağız.
Veri modeli anlaşıldıktan sonra, komutların "temeldeki veri modelini nasıl manipüle ettikleri" daha iyi anlaşılabilir.

# Git'in veri modelleri

Versiyon kontrolünde uygulayabileceğiniz birçok geçici yaklaşım vardır.
Git, versiyon kontrolünün; versiyon geçmişini yönetebilmek, dallar(branch'lar) ile çalışmayı desteklemek 
ve işbirliği içinde çalışmayı mümkün kılmak gibi güzel özellikler sağlayan iyi düşünülmüş bir modele sahiptir.

## Snapshots(Anlık görüntüler)

Git, dosya ve dizinlerdeki kollesiyonların geçimişini bazı üst düzey dizinler içinde anlık görüntüler(snapshots) halinde modeller.
Git terminolojisinde bir dosyaya "blob" denir ve bu sadece bir bayt'tır.
Bir dizin "tree" olarak adlandırılır ve adları blob'larla veya tree'lerle eşleştirilir (böylece dizinler başka dizinler de içerebilir).
Snapshot'lar(anlık görüntüler), izlenmekte olan en üst düzey tree'lerdir.
Örneğin, aşağıdaki gibi bir ağacımız olabilir:

```
<root> (tree)
|
+- foo (tree)
|  |
|  + bar.txt (blob, contents = "merhaba dünya")
|
+- baz.txt (blob, contents = "git muhteşemdir")
```

Üst düzey tree iki eleman içerir. Bunlar; biri tree olan "foo" (bu da adı "bar.txt" olan bir blob element barındırır) 
ile bir blob olan "baz.txt" dir.

## Geçmiş modellemesi: ilişkili anlık görüntüler(snapshot'lar)

Bir versiyon kontrol sistemi anlık görüntüleri nasıl ilişkilendirmelidir? 
Basit bir model doğrusal bir geçmişe sahip olurdu. 
Bu geçmiş, snapshot'ların zaman sıralamasına uygun şekilde bir listesi olurdu.
Birçok nedenden dolayı Git böyle basit bir model kullanmaz.

Git'te geçmiş, anlık görüntülerin(snapshots'ların) yönlendirilmiş çevrimsel olmayan bir grafiğidir (DAG directed acyclic graph).
Bu kulağa havalı bir matematik cümlesi gibi gelebilir ama sizi korkutmamalıdır. Tüm bunlar, Git'deki her anlık görüntünün
(snapshot'ın) kendinden önceki bir dizi "ebeveyn'lerle" ilişkisi var demektir. Bu, tek bir ebeveyn yerine bir ebeveyn grubudur, 
çünkü bir anlık görüntü(snapshot) birden çok ebeveynden gelebilir(doğrusal bir tarihte olduğu gibi). Örneğin, iki paralel 
geliştirme dalının birleştirilmesi(merge) gibi.

Git, bu anlık görüntüleri(snapshot'ları) **"commit"** olarak  adlandırır. Bir commit geçmişini görselleştirmek bu şekilde görünebilir:

```
o <-- o <-- o <-- o
            ^  
             \
              --- o <-- o
```

Yukarıdaki ASCII sanatında, `o`lar tekil commit'lere(snapshot'lara) karşılık gelir.
Oklar her bir commit'in ebeveynini işareteder(Bu "önce gelir" ilişkisidir; "sonra gelir" değil).
Üçüncü commit'den sonra dallanma geçmişi, iki ayrı dala(branch'a) ayrılıyor. 
Bu iki ayrı özelliğin birbirinden bağımsız aynı anda geliştirilmesine örnek olabilir.
Bu brach'lar gelecekte her iki özelliği de barındıran yeni bir snapshot oluşturmak için birleştirilebilir(merge edilebilir). 
Ve yeni üretilen bu geçmiş kalın puntolarla gösterilir:

<pre>
o <-- o <-- o <-- o <---- <strong>o</strong>
            ^            /
             \          v
              --- o <-- o
</pre>

Git'teki commit'ler değişmezler. Bu, hataların düzeltilemeyeceği anlamına gelmez.
Şu var ki commit geçmişini düzenlemek için aslında tamamen yeni bir commit oluşturuyoruz 
ve referanslar(aşağıya bakınız) yenilerini gösterecek şekilde güncelleniyor.

## Sözde kod olarak veri modeli

Git'in veri modelinin sözde kodla yazıldığını görmek öğretici olabilir:

```
// bir dosya bir sürü bayttır
type blob = array<byte>

// bir dizinde adlandırılmış dosyalar ve dizinler bulunur
type tree = map<string, tree | blob>

// bir commit'te ebeveynler, meta veriler ve en üst düzey ağaç(top-level tree) vardır
type commit = struct {
    parent: array<commit>
    author: string
    message: string
    snapshot: tree
}
```

Temiz, basit bir geçmiş modeli.

## Nesneler ve içerik adresleme

Bir "nesne" bir blob, tree ya da commit'tir.

```
type object = blob | tree | commit
```

Git veri deposunda, tüm nesneler [SHA-1
 hash'leri](https://en.wikipedia.org/wiki/SHA-1) tarafından içerik-adreslenir.

```
objects = map<string, object>

def store(object):
    id = sha1(object)
    objects[id] = object

def load(id):
    return objects[id]
```

Blob'lar, tree'ler ve commit'ler bu şekilde birleştirilir ve hepsi nesnedir. Bunlar başka bir objeyi referans edeceklerinde aslında onları kendi disk gösterimlerinde direk _içermezler_ ama onları hash'lerle refearns gösterirler.

Örnek olarak; [Yukarıdaki](#snapshots)  örnek dizin yapısı için tree şöyle görünür: (görselleştirilmek için `git cat-file -p 698281bc680d1995c5f4caaf3359721a5a58d48d` kullanıldı)

```
100644 blob 4448adbf7ecd394f42ae135bbeed9676e894af85    baz.txt
040000 tree c68d233a33c5c06e0340e4c224f0afca87c8ce87    foo
```

Tree, içindeki bilgiler için işaretçilere(pointer'lara) sahiptir, baz.txt(blob) ve foo(tree). Eğer baz.txt'ye uyumlu hash tarafından adreslenmiş içeriklere `git cat-file -p 4448adbf7ecd394f42ae135bbeed9676e894af85` ile bakarsak aşağıdakini elde ederiz:

```
git is wonderful
```

## Referanslar

Şu an tüm snapshot'lar kendi SHA-1 hash fonksiyonları ile tespit edilebilirler. 
Bu elverişli değildir çünkü insanlar 40 karakterli hexadecimal sayıları hatırlamakta iyi değildirler. 

Git’in bu soruna çözümü, SHA-1 hashleri yerine “referanslar” adı verilen, insanlar tarafından okunabilir
isimlerdir. Referanslar commit'leri işaret ederler. Değişmez olan obje'lerin aksine, referanslar 
değiştirilebilirdir. (yeni bir commit'i işaret edecek şekilde güncellenebilir). Örneğin; `master` 
referansı genellikle ana geliştirme branch'daki(daldaki) son commit'i işaret eder.

```
references = map<string, string>

def update_reference(name, id):
    references[name] = id

def read_reference(name):
    return references[name]

def load_reference(name_or_id):
    if name_or_id in references:
        return load(references[name_or_id])
    else:
        return load(name_or_id)
```

Bunla birlikte Git uzun hexadecimal string'ler yerine "master" gibi insan tarafından kolay okunabilen isimlerle geçmişteki bir snapshot'ı temsil edebilir.

Bir detay da genellikle geçmişte "şu an nerdeyiz" kavramını bilmek isteriz.
Bu sebeple yeni snapshot aldığımızda neyle ilişkili olduğunu biliriz.(commit'in `parents`'ını nasıl belirledik?)
Git'te “şu anda bulunduğumuz yer”, “HEAD” adı verilen özel bir referanstır.

## Repo'lar

Son olarak Git _repo'larını_; veri `objeleri` ve `referanslar` olarak  kabaca tanımlayabiliriz.

Diskte, tüm Git depoları nesneler ve referanslardan oluşmaktadır: Git’in veri modeli bundan ibarettir. Bütün `git` komutları 
objeler ekleyip ve referasnlar ekleyip/güncelleyerek bazı commit DAG(directed acyclic graph) maniplasyonları ile ilişkilidir.

Herhangi bir komut yazarken, komutun grafik ve veri yapısının altında ne gibi bir değişiklik yaptığını düşünün. Buna karşılık,
commit DAG'de belli başlı bir değişiklik yapmaya çalışıyorsanız örnek olarak; "commit edilmemiş değişiklikleri atın ve `5d83f9` 
commit'ini işlemek için ‘master’ referans noktası olarak belirtin". _Muhtemelen, bunu uygulamak için bir komut vardır._
(Bu duruma örnek olarak `git checkout master; git reset -- hard 5d83f9e`)

# Staging area(hazırlanma alanı)

Bu, veri modeline dikey olan başka bir konsepttir. Fakat commit oluşturmak için gereken arayüzün bir parçasıdır da.

Anlık görüntü uygulamasının yukarıda açıklandığı gibi uygulanacağını hayal etmenin bir yolu da, çalışma dizininin mevcut durumuna 
göre yeni bir anlık görüntü oluştur **"anlık görüntü(snapshot) oluştur"** komutuna sahip olmaktır. Bazı versiyon kontrol 
araçları bu şekilde çalışır, ama Git bu şekilde çalışmaz. Temiz anlık görüntüler isteriz ve mevcut durumdan anlık görüntü 
oluşturmak her zaman ideal olmayabilir. Örneğin, iki ayrı özellik uyguluyoruz; Birincisinin **A** özelliğini, 
diğerinin de **B** özelliğini tanıttığı iki ayrı commit oluşturmak istiyorsunuz ve bugfix'ler ile beraber kodunuzun her yerine 
hata ayıklma ekran çıktıları eklemek istiyorsunuz. Tüm bu hata ayıklama ekran çıktılarını göndermeden(discarding) bir 
yandan da bugfix'i commit'lemek istediğiniz bir senaryo düşünün.

Git "staging area" denen bir mekanzima ile bir dahaki snapshot'da hangi değişikliklerin olması gerektiğini belirlemenizi yarayacak senaryolar sağlar.

# Git komut satırı arabirimi

Bilgilerin kopyalanmasını önlemek için aşağıdaki komutları ayrıntılı olarak açıklamayacağız. Daha fazla bilgi için şiddetle tavsiye edilen [Pro Git](https://git-scm.com/book/tr/v2)'e bakın veya ders videosunu izleyin.

## Temeller

{% comment %}

The `git init` command initializes a new Git repository, with repository
metadata being stored in the `.git` directory:

```console
$ mkdir myproject
$ cd myproject
$ git init
Initialized empty Git repository in /home/missing-semester/myproject/.git/
$ git status
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

How do we interpret this output? "No commits yet" basically means our version
history is empty. Let's fix that.

```console
$ echo "hello, git" > hello.txt
$ git add hello.txt
$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   hello.txt

$ git commit -m 'Initial commit'
[master (root-commit) 4515d17] Initial commit
 1 file changed, 1 insertion(+)
 create mode 100644 hello.txt
```

With this, we've `git add`ed a file to the staging area, and then `git
commit`ed that change, adding a simple commit message "Initial commit". If we
didn't specify a `-m` option, Git would open our text editor to allow us type a
commit message.

Now that we have a non-empty version history, we can visualize the history.
Visualizing the history as a DAG can be especially helpful in understanding the
current status of the repo and connecting it with your understanding of the Git
data model.

The `git log` command visualizes history. By default, it shows a flattened
version, which hides the graph structure. If you use a command like `git log
--all --graph --decorate`, it will show you the full version history of the
repository, visualized in graph form.

```console
$ git log --all --graph --decorate
* commit 4515d17a167bdef0a91ee7d50d75b12c9c2652aa (HEAD -> master)
  Author: Missing Semester <missing-semester@mit.edu>
  Date:   Tue Jan 21 22:18:36 2020 -0500

      Initial commit
```

This doesn't look all that graph-like, because it only contains a single node.
Let's make some more changes, author a new commit, and visualize the history
once more.

```console
$ echo "another line" >> hello.txt
$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   hello.txt

no changes added to commit (use "git add" and/or "git commit -a")
$ git add hello.txt
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   hello.txt

$ git commit -m 'Add a line'
[master 35f60a8] Add a line
 1 file changed, 1 insertion(+)
```

Now, if we visualize the history again, we'll see some of the graph structure:

```
* commit 35f60a825be0106036dd2fbc7657598eb7b04c67 (HEAD -> master)
| Author: Missing Semester <missing-semester@mit.edu>
| Date:   Tue Jan 21 22:26:20 2020 -0500
|
|     Add a line
|
* commit 4515d17a167bdef0a91ee7d50d75b12c9c2652aa
  Author: Anish Athalye <me@anishathalye.com>
  Date:   Tue Jan 21 22:18:36 2020 -0500

      Initial commit
```

Also, note that it shows the current HEAD, along with the current branch
(master).

We can look at old versions using the `git checkout` command.

```console
$ git checkout 4515d17  # previous commit hash; yours will be different
Note: checking out '4515d17'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 4515d17 Initial commit
$ cat hello.txt
hello, git
$ git checkout master
Previous HEAD position was 4515d17 Initial commit
Switched to branch 'master'
$ cat hello.txt
hello, git
another line
```

Git can show you how files have evolved (differences, or diffs) using the `git
diff` command:

```console
$ git diff 4515d17 hello.txt
diff --git c/hello.txt w/hello.txt
index 94bab17..f0013b2 100644
--- c/hello.txt
+++ w/hello.txt
@@ -1 +1,2 @@
 hello, git
 +another line
```

{% endcomment %}

- `git help <command>`: bir git  komutu için yardım alın
- `git init`: yeni bir git repo'su oluşturur, ilgili verileri `.git` dizininde saklar
- `git status`: neler olduğunu söyler
- `git add <filename>`: dosyaları staging area'ya(sahne alanına) ekler
- `git commit`: yeni bir commit oluşturur
    - Güzel commit mesajları [yazın](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)!
    - Güzel commit mesajları yazmak için [daha fazla neden](https://chris.beams.io/posts/git-commit/)!
- `git log`: commit geçmişini sade bir şekilde gösterir
- `git log --all --graph --decorate`: git geçmişini DAG'a göre görselleştirir
- `git diff <filename>`: son comit'ten bu yana yapılan değişiklikleri gösterir
- `git diff <revision> <filename>`: snapshot'lar arasındaki dosya farklılığını gösterir
- `git checkout <revision>`: HEAD'i ve mevcut brach'ı günceller

## Dallanma(Branching) ve birleştirme(merging)

{% comment %}

Branching allows you to "fork" version history. It can be helpful for working
on independent features or bug fixes in parallel. The `git branch` command can
be used to create new branches; `git checkout -b <branch name>` creates and
branch and checks it out.

Merging is the opposite of branching: it allows you to combine forked version
histories, e.g. merging a feature branch back into master. The `git merge`
command is used for merging.

{% endcomment %}

- `git branch`: brach'ları gösterir
- `git branch <name>`: bir branch oluşturur
- `git checkout -b <name>`: bir branch oluşturur ve ona geçer
    - buna eşdeğerdir `git branch <name>; git checkout <name>`
- `git merge <revision>`: mevcut dalla birleştirir(merge eder)
- `git mergetool`: birleştirme çakışmalarını(merge conflict'lerini) çözmek için havalı bir araç kullanın
- `git rebase`: yeni base'e yamaları yükler

## Remotes(Uzak repo)

- `git remote`: uzak depoları listeler
- `git remote add <name> <url>`: uzak bir depo ekler
- `git push <remote> <local branch>:<remote branch>`: nesneleri uzak depoya gönderir ve uzak depo referansını günceller
- `git branch --set-upstream-to=<remote>/<remote branch>`: yerel ve uzak branch'lar arasındaki yazışmaları ayarlar
- `git fetch`: uzaktaki objeleri/referansları çeker 
- `git pull`: buna eşdeğerdir `git fetch; git merge`
- `git clone`: uzaktaki repoyu indirir

## Geri alma

- `git commit --amend`: bir commit'in içeriği/mesajını günceller
- `git reset HEAD <file>`: bir dosyayı stagin area'dan çıkarır
- `git checkout -- <file>`: değişiklikleri gözardı eder

# Gelişmiş Git

- `git config`: Git [son derece özelleştirilebilirdir](https://git-scm.com/docs/git-config)
- `git clone --depth=1`: tüm versiyon geçmişi olmadan, yüzeysel bir klonlama yapar
- `git add -p`: etkileşimli staging
- `git rebase -i`: etkileşimli rebasing
- `git blame`: kimin en son hangi satırı düzenlediğini göstertir
- `git stash`: çalışma dizinindeki değişiklikleri geçici olarak kaldırır
- `git bisect`: binary search'le geçmişi arar (örneğin ilişki yoklaması)
- `.gitignore`: bilinçli şekilde izlenmeyen dosyaları yoksayılan 
olarak [belirtir](https://git-scm.com/docs/gitignore)


# Çeşitli

- **GUI'lar**: Git için çok sayıda [GUI istemcisi](https://git-scm.com/downloads/guis) var.
Şahsen biz bunları kullanmıyoruz. Bunların yerine komut satırı arayüzünü kullanıyoruz.
- **Kabuk(Shell) entegrasyonu**: Kabuğunuzun(shell'inizin) ([zsh](https://github.com/olivierverdier/zsh-git-prompt),
[bash](https://github.com/magicmonty/bash-git-prompt)) bir parçası olarak Git durumuna sahip olmak son derece kullanışlıdır.
Genellikle [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) gibi uygulama çatılarında(framework'lerde) bu, dahil olarak gelir.
- **Editör entegrasyonu**: Yukarıdakine benzer şekilde, birçok özelliğe sahip kullanışlı entegrasyonlar. [fugitive.vim](https://github.com/tpope/vim-fugitive) Vim için standart olandır.
- **İş akışları** :  Size veri modelini ve bazı temel komutları öğrettik; fakat büyük projeler üzerinde çalışırken hangi uygulamaları takip edeceğinizi söylemedik. (ve [birçok](https://nvie.com/posts/a-successful-git-branching-model/)
[farklı](https://www.endoflineblog.com/gitflow-considered-harmful)
[yaklaşım](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) var).
- **GitHub**: Git GitHub değildir. GitHub, [pull requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) adı verilen diğer projelere kod desteğinde bulunma imkanı sağlayan özel bir yola sahiptir.
- **Diğer Git sağlayıcıları**: Tek Git sağlayıcısı Github değildir. [GitLab](https://about.gitlab.com/) ve [BitBucket](https://bitbucket.org/) gibi birçok Git repository sağlayıcıları vardır.

# Kaynaklar

-  [Pro Git](https://git-scm.com/book/tr/v2)'i **okumanızı şiddetle tavsiye ediyoruz**.
Veri modellerini anladığınıza göre, 1-5 bölümlerinin üzerinden geçmek size Git'i verimli bir şekilde kullanmak için ihtiyaç duyduğunuz şeylerin çoğunu öğretecektir. Ayrıca gelecek bölümlerde bazı ilginç gelişmiş materyaller de var.
- [Oh Shit, Git!?!](https://ohshitgit.com/) yaygın Git hatalarından nasıl kurtulacağınız konusunda kısa bir rehberdir.
- [Git for Computer Scientists](https://eagain.net/articles/git-for-computer-scientists/), Git’in veri modelinin kısa bir açıklamasıdır ve bu ders notlarına göre daha az sözde kod ve daha havalı diyagramları vardır.
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/), meraklılar için Git’in uygulama ayrıntılarının veri modellerinin ötesinde ayrıntılı bir açıklamasıdır.
- [How to explain git in simple words](https://smusamashah.github.io/blog/2017/10/14/explain-git-in-simple-words)
- [Learn Git Branching](https://learngitbranching.js.org/), Git'i öğreten tarayıcı tabanlı bir oyundur.

# Alıştırmalar

1. Git ile ilgili geçmiş bir deneyiminiz yoksa, [Pro Git'in](https://git-scm.com/book/en/v2) 
   ilk birkaç bölümünü okumayı deneyin veya [Learn Git Branching](https://learngitbranching.js.org/) 
   gibi bir eğitimden faydalanın. Ve bunlar üzerinde çalışırken Git komutlarını veri modeliyle ilişkilendirmeye çalışın.
1. [Repoyu dersin sitesinden ](https://github.com/missing-semester/missing-semester) clone'layın.
    1. Versiyon geçmişini grafik olarak görselleştirp keşfedin.
    1. `README.md`'de en son değişiklik yapan kişi kim? (İpucu: parametre ekleyerek `git log`'u kullan)
    1. `_config.yml`'ın `collections:` satırına yapılan son değişiklik ile alakalı commit mesajı hangisidir? (İpucu: `git blame` ve `git show`'u kullanın)
1. Git'i öğrenirken yapılan yaygın hatalardan biri de git tarafından  yönetilmemesi gereken büyük dosyaları commit'lemek veya hassas bilgileri eklemektir. Bir repoya dosya eklemeyi, bazı commit'ler oluşturmayı ve ardından o dosyayı geçmişten silmeyi deneyin ([buna](https://help.github.com/articles/removing-sensitive-data-from-a-repository/) bakmak isteyebilirsiniz).
1. GitHub'daki bazı depoları klonlayın ve mevcut dosyalarından birini değiştirin. 
`git stash` yaptığınızda ne olur? `git log --all --oneline`'ı çalıştırdığınızda ne görüyorsunuz? 
`git stash` ile yaptıklarınızı geri almak için `git stash pop` komutunu çalıştırın. 
Hangi senaryoda bu yararlı olabilir?
1. Birçok komut satırı aracı gibi Git de `~/.gitconfig` adlı bir yapılandırma dosyası (veya dotfile) 
sağlar. `git graph` komutunu çalıştırdığınızda `git log --all --graph --decorate --oneline` çıktısını almanız için `~/.gitconfig` içinde bir takma ad(alias) oluşturun.  
1. `git config --global core.excludesfile ~/.gitignore_global` komutunu çalıştırdıktan sonra `~/.gitignore_global` içinde global yok sayma kalıplarını tanımlayabilirsiniz. Bunu yapın ve genel gitignore dosyanızı, `.DS_Store` gibi işletim sistemine özgü veya metin editörlerine özgü geçici dosyaları yok sayacak şekilde ayarlayın.
1. [Sınıfın web sitesinden repoyu](https://github.com/missing-semester-tr/missing-semester-tr.github.io) clone'layın
ve yapabileceğiniz bir iyileştirme bulun(yazım yanlışı gibi) ve Github'dan bir [pull request gönderin](https://github.com/missing-semester-tr/missing-semester-tr.github.io/blob/master/_2020/version-control.md).