---
layout: lecture
title: "Shell Araçları ve Scripting"
date: 2019-01-14
ready: true
video:
  aspect: 56.25
  id: kgII-YWo3Zw
---

Bu derste, komut satırında sıklıkla kullanacağınız en yaygın komutları içeren bazı shell araçları ile birlikle bash'i bir scripting dili olarak kullanmanın temellerini işleyeceğiz.

# Shell Scripting

Şu ana kadar shell'de komutları nasıl çalıştırdığımızı ve bu komutları nasıl birbirine bağladığımızı (pipe) gördük. Fakat, birçok senaryoda komutları bir seri şeklinde çalıştırmak ve koşullu ifadeler ya da döngüler gibi akış kontrolü deyimleri kullanmak isteyeceksiniz.

Bir adım daha karmaşık hale gidersek, sırada Shell scriptleri var.
Birçok shell kendi değişkenleri, akış kontrolü ve kendi dil yapısına sahip bir scripting diline sahiptir.
Shell scriptlemeyi diğer scriptleme dillerinden farklı kılan şey özellikle shell ile alakalı görevler için optimize edilmiş olmasıdır. Bu yüzden, komut boru hattı oluşturma, sonuçları dosyaya kaydetme ve standart girdiden okuma gibi işlemler shell scriptingde en temel yapı taşlarıdır. Bu da genel geçer scriptleme dillerine karşı büyük bir avantaj ve kolaylık sağlar.
Bu derste, en yaygın shell scriptleme dili olan bash'e odaklanacağız.

Bash'te bir değişkene atama yapmak için `foo=bar` komutunu kullanıyor ve değişkenin değerine `$foo` komutu ile ulaşıyoruz.
Dikkat etmek gereken bir nokta, `foo = bar` komutunun çalışmayacağıdır. Çünkü boşluk bırakıldığında shell bu komutu `=` ve `bar` argümanlarına sahip `foo` programını çalıştırmak şeklinde yorumlayacaktır.
Genellikle, shell scriptlerinde boşluk karakteri argümanları ayırma görevini üstlenir. Bu durum başlangıçta biraz kafa karıştırıcı gelebilir, bu yüzden her zaman dikkat edin. 

Bash'te stringler `'` ve `"` karakterleri ile tanımlanabilir, fakat bu iki yöntem birbirine eşlenik sonuçlar doğurmaz.
`'` karakteri ile tanımlanan stringler `gerçel stringlerdir` ve değişken değerlerinin yerine geçmezler. Fakat `"` ile tanımlanan stringler değişken değerlerini gösterirler. Aşağıdaki örnek bu durumu açıklamaktadır:

```bash
foo=bar
echo "$foo"
# prints bar
echo '$foo'
# prints $foo
```

Birçok programlama dili gibi bash scripteme dili de akış kontrolü deyimlerini desteklemektedir. Bunların arasında `if`, `case`, `while` ve `for` gibi yapılar bulunmaktadır.
Benzer şekilde, `bash` argüman alan ve bunlarla işlemler yapabilen fonksiyonlara destek sağlamaktadır. Aşağıda yeni bir dizin oluşturup, onun içine `cd`leyen bir fonksiyon örneği bulunmaktadır:


```bash
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```

`$1` script/fonksiyona verilen ilk argümanın yerine geçmektedir.
Diğer scriptleme dillerinin aksine, bash argümanlara, hata kodlarına ve gerekli bazı diğer değişkenlere işaret etmek için birçok özel değişken kullanır. Aşağıda bunlardan bazıları bulunmaktadır. Daha kapsamlı bir liste [bu linkte](https://www.tldp.org/LDP/abs/html/special-chars.html) bulunabilir.
- `$0` - Script'in adı
- `$1`'den `$9`'a kadar - Scripte verilen argümanlar (`$1` birinci argüman olmak üzere).
- `$@` - Tüm argümanlar
- `$#` - Argüman sayısı
- `$?` - Bir önceki komutun döndürdüğü kod
- `$$` - İşlem Kimlik Numarası (Process Identification Number-PID)
- `!!` - Argümanları da dahil bir önceki komut. Sık kullanıldığı bir yer eğer bir komut sadece gerekli izinleri alamadığı için başarısız oluyorsa, ardından `sudo !!` şeklinde çağırmaktır.
- `$_` - En son komutun en son argümanı. Eğer interaktif bir shell kullanıyorsanız, `Esc` ardından `.` kullanarak da bunu elde edebilirsiniz.

Komutlar genellikle `STDOUT`'u çıktılar için, `STDERR`'i hatalar için kullanır ve bir Dönüş Kodu kullanarak da hataları scriptleme için daha kolay hale getirecek şekilde belirtir.
Dönüş Kodu ya da çıkış statüsü script/komutların işlemlerin nasıl sonuçlandığını kullanıcıya iletme yoludur.
0 değeri genellikle her şeyin iyi gittiği; 0'dan başka değerler de bir hatanın oluştuğu anlamına gelirler.

Çıkış kodları ileriki komutları koşullu ifadelerle çalıştırabilmemizi sağlar. Bunun için ikisi de [kısa-devre operatörü](https://en.wikipedia.org/wiki/Short-circuit_evaluation) olan `&&` (ve operatörü) ve `||` (veya operatörü) kullanılabilir. Ayrıca farklı komutlar `;` kullanarak aynı satırda da yazılabilir.
`true` (doğru) bir program her zaman 0 dönüş koduna sahiptir ve `false`(yanlış) bir komut ise her zaman 1 dönüş kodunu döndürür.
Şimdi bazı örneklere bakalım.

```bash
false || echo "Aaa, çalışmadı"
# Aaa, çalışmadı

true || echo "Çıktı yok"
#

true && echo "Her şey süper"
# Her şey süper

false && echo "Çıktı yok"
#

true ; echo "Bu her zaman çalışacak"
# Bu her zaman çalışacak

false ; echo "Bu her zaman çalışacak"
# Bu her zaman çalışacak
```

Genelde sıklıkla yapılmak istenen bir başka işlem ise komutların çıktılarını bir değişken şeklinde kullanmaktır. _komut değişimi_ bu iş için kullanılabilecek bir yöntemdir.
`$( CMD )` nerede kullanılırsa kullanılsın, `CMD` komutunu çalıştıracak, komutun çıktısını alacak ve kullanıldığı yere bu çıktıyı yazacaktır.
Örneğin, eğer `for file in $(ls)` komutunu çalıştırırsanız, shell ilk önce `ls` komutunu çağırıp sonra gelen değerler üzerinde bir döngü oluşturacaktır.
Daha az bilinen benzer bir özellik ise _işlem değişimidir_, `<( CMD )` komutu `CMD` komutunu çalıştıracak, çıktıyı geçici bir dosyaya yerleştirecek ve `<()` kısmı yerine dosyanın ismini yazacaktır. Bu method özellikle STDIN yerine dosyaları argüman olarak bekleyen komutları kullanmak için oldukça faydalıdır. Örneğin, `diff <(ls foo) <(ls bar)` komutu `foo` ve `bar` dizinlerindeki dosyalar arasındaki farkları göstermektedir.


Çok fazla şeyin üstünden geçtik. Bu özelliklerin bazılarını görebileceğimiz bir örnek görelim şimdi de. Bu örnekte verdiğimiz argümanlar üzerinden yineleyip, `foobar` stringini `grep`leyip , eğer bulunmazsa dosyaya bir yorum olarak ekleyeceğiz.

```bash
#!/bin/bash

echo "$(date) tarihinde program başlatılıyor" # Tarih yerine yazılacaktır

echo "$$ pid kodlu $0 programı $# argümanlarıyla çalıştırılıyor"

for file in $@; do
    grep foobar $file > /dev/null 2> /dev/null
    # Eğer verilen kalıp bulunmazsa , grep 1 çıkış koduna sahip
    # STDOUT ve STDERR ile işimiz olmadığı için onları null bir registera yönlendiriyoruz
    if [[ $? -ne 0 ]]; then
        echo "$file dosyasında foobar yok, ekleniyor"
        echo "# foobar" >> "$file"
    fi
done
```

If içindeki karşılaştırmada `$?` değerinin 0 olmadığını kontrol ettik.
Bash bunun gibi birçok karşılaştırma sunuyor - [`test`](https://www.man7.org/linux/man-pages/man1/test.1.html) linkinde detaylı bir liste bulabilirsiniz.
Bash'te karşılaştırma yaparken, tekli köşeli parantezler `[ ]` yerine ikili köşeli parantezler `[[ ]]` kullanmayı tercih etmeniz daha iyi olabilir. `sh` şeklinde bir script oluşturulmayacağına rağmen bu şekilde hata yapma ihtimaliniz azalmaktadır. [Burada](http://mywiki.wooledge.org/BashFAQ/031) daha detaylı bir açıklama bulabilirsiniz.

Scriptleri çalıştırırken, genellikle benzer argümanlar sağlamak isteyeceksiniz. Bash bunu birkaç farklı şekilde kolaylaştırıyor. Bunlardan biri de dosya ismi genişlemesi kullanmak. Bu tekniklere shell _globbing_ adı verilmektedir.
- Wildcards - Wildcardlar birden çok seçim yapmada oldukça faydalıdır. Nerede wildcard kullanmak isterseniz, `?` ve `*` karakterlerini sırasıyla bir ve herhangi bir sayıdaki karakterle eşleştirmek için kullanabilirsiniz. Örneğin, `foo`, `foo1`, `foo2`, `foo10` ve `bar` dosyaları verildiğinde, `rm foo?` komutu `foo1` ve `foo2` dosyalarını silerken `rm foo*` `bar` hariç tüm dosyaları silecektir.
- Köşeli parantezler `{}` - Ne zaman bir komutta ortak altdizgiler bulunursa, otomatik olarak genişlemeyi sağlamak için `{}` kullanılabilir. Özellikle dosyaları taşırken ve dönüştürürken bu özellik oldukça kullanışlı olmaktadır.

```bash
convert image.{png,jpg}
# Alttaki hale genişleyecektir
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# Alttaki hale genişleyecektir
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# Globbing teknikleri beraber de kullanabilir
mv *{.py,.sh} folder
# Tüm *.py ve *.sh dosyalarını taşıyacaktır


mkdir foo bar
# Bu komut foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h şeklinde dosyalar oluşturacaktır
touch {foo,bar}/{a..h}
touch foo/x bar/y
# foo ve bar dizinlerindeki dosyalar arasındaki farklar
diff <(ls foo) <(ls bar)
# Çıktılar
# < x
# ---
# > y
```

<!-- Son olarak, borular(pipes) `|` scriptlemenin temel özelliklerinden birisidir. Borular bir programın çıktısını öbür programa girdi olarak verebilmeyi sağlar. Boruları veri işleme dersinde daha detaylı işleyeceğiz. -->

`bash` scriptleri yazmak ustalık ve dikkat isteyebilir. [Shellcheck](https://github.com/koalaman/shellcheck) gibi araçlar sh/bash scriptlerinizdeki hataları bulmanıza yardımcı olabilirler

Terminalden çalıştırılabilmek için scriptleriniz bash dilinde yazılmak zorunda değildir. Örneğin, aşağıda argümanlarını ters çevrilmiş şekilde yazdırılan basit bir Python scripti görülmektedir:

```python
#!/usr/local/bin/python
import sys
for arg in reversed(sys.argv[1:]):
    print(arg)
```

Kernel bu scripti bir shell komutu yerine bir Python interpreteru kullanarak çalıştıracağını bilmektedir çünkü scriptin en başındaki satırda bir [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) bulunmaktadır.
Shebang satırlarını scriptlerin taşınabilirliğini artıran, komut sistemde nerede ise orayı bulabilen [`env`](https://www.man7.org/linux/man-pages/man1/env.1.html) komutu kullanarak yazmak iyi bir uygulamadır. Lokasyonu bulmak için, `env` komutu ilk derste tanıtılan `PATH` ortam değişkenini kullanır.
Bu örnekte shebang satırı `#!/usr/bin/env python` şeklinde gözükecektir.

Shell fonksiyonları ve scriptleri arasında aklınızda tutmanız gereken bazı farklılıklar şu şekildedir:
- Fonksiyonlar shell ile aynı dilde yazılmak zorunda iken, scriptler herhangi bir dilde yazılabilir. Bu yüzden scriptlere shebang eklemek önemlidir.
- Fonksiyonlar tanımlandıkları zaman yüklenirler. Scripler ise her çalıştırıldıklarında tekrar yüklenirler. Bu yüzden fonksiyonlar biraz daha hızlı yüklenirler, fakat değiştirdiğiniz her zaman, tanımlamalarını tekrar yüklemek zorunda kalırsınız.
- Fonksiyonlar var olan shell ortamında çalışırken, scriptler kendi işlemleri üzerinde farklı bir ortamda çalışırlar. Bu yüzden, fonksiyonlar ortam değişkenlerini düzenleyebilir, örneğin bulunduğunuz dizini değiştirmek, fakat scriptler düzenleyemezler. Scriptler [`export`](https://www.man7.org/linux/man-pages/man1/export.1p.html) komutu kullanarak dışarı verilen ortam değişkenlerini değer geçirme ile erişirler.
- Tüm programlama dilleri gibi, fonksiyonlar modülarite, kod tekrar kullanımı, ve shell kodunun anlaşılırlığı için oldukça önemli yapılardır . Çoğu zaman, shell scriptleri kendi fonksiyon tanımlarını kullanırlar.

# Shell Araçları

## Komutların nasıl kullanılacağının bulunması

Bu noktada, mahlaslama(aliasing) bölümünde kullanılan `ls -l`, `mv -i` ve `mkdir -p` gibi işaretleri(flag) nasıl bulabileceğimizi merak ediyor olabilirsiniz.
Genel olarak herhangi bir komut için komutun ne yaptığını ve farklı seçeneklerinin neler olduğunu nasıl öğreniriz?
Elbette googlelamaya başlayabilirsiniz, fakat UNIX StackOverflow'dan önceden beri var olduğu için, shell içinden bu bilgilere ulaşmanın yolları var.

Shell dersinde gördüğümüz üzere, ilk akla gelen yöntem bahsedilen komutu `-h` veya `--help` işaretlerini kullanarak çağırmak olabilir. Daha detaylı bir yöntem `man` komutunu kullanmak olabilir.
Manual için bir kısaltma olan, [`man`](https://www.man7.org/linux/man-pages/man1/man.1.html) belirttiğimiz komut için bir manual sayfası (manpage olarak da adlandırılır) sağlar.
Örneğin, `man rm`, `rm` komutunun nasıl çalıştığını, ne yaptığını ve daha önce gösterdiğimiz `-i` işareti gibi alabileceği işaretleri çıktı olarak verir.
Aslında, şu ana kadar verdiğimiz linkler komutların Linux manual sayfalarının çevrimiçi haliydi.
Native olmayan, kullanıcı tarafından yüklenen komutların bile eğer geliştirici yazıp yükleme sürecine dahil ettiyse bir manpage'i olabilir.
ncurses vb. tabanlı interaktif araçlar içinse, komutların yardımına genellikle program içinde :help komutu veya `?` yazarak erişilebilir.

Bazen manpage'ler komutların fazlaca detaylı tanımlamalarını içerebilir, böylelikle yaygın kullanımlar için hangi işaretleri/sözdizimini kullanacağını kavramak zorlaşabilir.
[TLDR sayfaları](https://tldr.sh/) bu soruna tamamlayıcı  zekice çözümlerdir. Bir komutun kullanım senaryolarından örnekler vererek hangi durumda hangi seçeneğin kullanılması gerektiğinin kolayca anlaşılmasını sağlar.
Mesela kendimi, [tar](https://tldr.ostera.io/tar) ve [ffmpeg](https://tldr.ostera.io/ffmpeg) programları için daha çok manpage'ler yerine tldr sayfalarını kontrol ederken buluyorum.


## Dosyaları bulmak

Her programlamacının karşılaştığı en sık tekrarlayan işlerden biri dosyaları ve dizinleri bulmaktır.
Tüm UNIX ve benzeri sistemler dosyaları bulmak için harika bir araç olan [`find`](https://www.man7.org/linux/man-pages/man1/find.1.html) paketiyle birlikte gelir. `find` bir kritere göre dosyaları özyinelemeli şekilde arar. Bazı örnekler:

```bash
# Tüm src isimli dizinleri bul
find . -name src -type d
# Konumunun içinde test geçen tüm python dosyalarını bul
find . -path '**/test/**/*.py' -type f
# Son gün içinde değiştirilen tüm dosyaları bul
find . -mtime -1
# 500k'dan 10M'a kadar olan tüm zip dosyalarını bul
find . -size +500k -size -10M -name '*.tar.gz'
```
Dosyaları listelemenin yanında, find ayrıca sorgunuzla bulduğunuz dosyalar üzerinde komutlar çalıştırabilir.
Bu özellik oldukça monoton işlerin basitleştirilmesi için inanılmaz şekilde faydalıdır.
```bash
# .tmp uzantılı tüm dosyaları sil
find . -name '*.tmp' -exec rm {} \;
# Tüm PNG dosyalarını bul ve JPG'e çevir
find . -name '*.png' -exec convert {} {.}.jpg \;
```

`find` oldukça sık kullanılmasına rağmen, sözdizimini hatırlamak bazen hatırlaması zor olabilir.
Örneğin, bir kalıpla eşleşen dosyaları bulmaya çalışırken `KALIP`, `find -name '*KALIP*'` (veya eğer kalıbın büyük/küçük harf ayrımı yapmamasını istiyorsanız `-iname`) komutunu çalıştırmalısınız.
Bu senaryolar için mahlaslar(alias) oluşturabilirsiniz, fakat shell felsefesinin bir kısmı da farklı alternatifleri değerlendirmenin iyi olduğudur.
Unutmayın, shellin en iyi özelliklerinden biri sadece programlar çağırıyor olmanızdır, böylece bazıları için farklı alternatifler bulabilir, hatta kendiniz alternatifler yazabilirsiniz.
Örneğin, [`fd`](https://github.com/sharkdp/fd) `find`a basit, hızlı ve kullanıcı dostu bir alternatiftir.
Renklendirilmiş çıktılar, regex eşleştirme ve Unicode desteği gibi güzel özellikleri varsayılan olarak sunar. Bana göre, ayrıca, daha içgüdüsel bir sözdizimine sahiptir.
Örneğin, bir `KALIP`ı bulmaya çalışıyorken sözdizimi `fd KALIP`tır.

Birçok kişi `find` ve `fd`nin iyi olduğunda hemfikirdir, ama bazılarınız her seferinde dosyalar için arama yapmanın daha hızlı arama yapmak için bir tür index veya veritabanı oluşturmaya göre verimliliğini sorguluyor olabilir.
[`locate`](https://www.man7.org/linux/man-pages/man1/locate.1.html) komutu tam olarak bunun içindir.
`locate`, [`updatedb`](https://www.man7.org/linux/man-pages/man1/updatedb.1.html) ile güncellenen bir veritabanı kullanır.
Birçok sistemde, `updatedb`, [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html) kullanılarak günlük olarak güncellenir.
Yani, ikisi arasında hız ve güncellikten birinden vazgeçilir.
Buna ek olarak, `find` ve benzeri araçlar ayrıca dosya boyutu, düzenleme tarihi, dosya izinleri gibi özellikler üstünden de dosyaları bulabilirken, `locate` sadece dosya ismini kullanır.
Daha detaylı bir karşılaştırma [burada](https://unix.stackexchange.com/questions/60205/locate-vs-find-usage-pros-and-cons-of-each-other) bulunabilir.

## Kodu Bulmak

Dosyaları isimleriyle aramak faydalı, fakat en az bunun kadar sık dosyaları *içeriklerine* göre de bulmak isteyeceksiniz. 
Yaygın bir senaryo, bir kalıbı içeren tüm dosyaları ve bu dosyalar içinde bahsedilen kalıbın nerede geçtiğini bulmak istemektir.
Bunu başarabilmek için, çoğu UNIX ve benzeri sistemde verilen metinde kalıp eşleştirmesi yapmayı sağlayan jenerik [`grep`](https://www.man7.org/linux/man-pages/man1/grep.1.html) komutu bulunmaktır.
Oldukça değerli bir shell aracı olan `grep` komutunu veri işleme dersinde oldukça detaylı işleyeceğiz.

Şu anlık, `grep` komutunun birçok işaretçisiyle(flag) birlikte çok yönlü bir araç olduğunu bilmeniz yeterlidir.
Benim sıklıkla kullandıklarım arasında, `-C` işaretçisi eşleşen satırın etrafındaki **C**ontexti yazdırmak için kullanılır, `-v` ise eşleşmenin tümleyenini(in**v**erting) almak için kullanılır, kalıpla **eşleşmeyen** tüm satırları yazdırma şeklinde. Örneğin, `grep -C 5` eşleşmenin olduğu satırın 5 üst ve 5 altındaki satırları gösterir.
Birçok dosya arasında hızlıca arama yapmak istediğimizde de, `-R` işaretçisi özyinelemeli şekilde (**R**ecursively) dizinlerin içine girip eşleşen stringler için dosyaları aramayı sağlar.

Fakat `grep -R` birçok şekilde geliştirlebilir,`.git` klasörlerini yok saymak, çoklu CPU desteği vb. gibi.
Birçok `grep` alternatifi geliştirilmiştir; bunların arasında [ack](https://beyondgrep.com/), [ag](https://github.com/ggreer/the_silver_searcher) ve [rg](https://github.com/BurntSushi/ripgrep) bulunmaktadır.
Bunların hepsi şahanedir ve az çok aynı işlevi görmektedir.
Şu an hızı ve içgüdüsel olması sebebyile ripgrep (`rg`) kullanmaktayım. Bazı örnekler:
```bash
# requests kütüphanesini kullandığım bütün python dosyalarını bul
rg -t py 'import requests'
# Shebang satırı içermeyen tüm dosyaları bul (gizli dosyalar dahil)
rg -u --files-without-match "^#!"
# Tüm 'foo'ları bul ve sonraki 5 satırı yazdır.
rg foo -A 5
# Eşleşmenin istatistilerini yazdır (eşleşen dosyalar ve satırların sayısı)
rg --stats PATTERN
```

Dikkat edilmesi gereken nokta `find`/`fd`'de olduğu gibi, bu problemlerin bu araçlardan herhangi birini kullarak çözülebileceğinin farkında olmaktır. Kullandığınız spesifik aracın çok da bir önemi yoktur.

## Shell komutlarını bulmak

Şu ana kadar nasıl dosyaları ve kodları bulabileceğimizi gördük. Fakat shell'de daha fazla zaman harcadıkça, bir noktada kullandığınız spesifik komutları bulmak isteyebilirsiniz.
Bilinmezi gereken ilk nokta üst ok tuşunun en son çalıştırdığınız komutu size vereceğidir, ve bu tuşa daha fazla bastıkça yavaşça shell geçmişinizde ilerleyebilirsiniz.

`history` komutu ise shell geçmişine programlanabilir şekilde erişmenizi sağlar.
Bu komut shell geçmişinizi standard çıktıya yazdıracaktır.
Eğer geçmiş içinde arama yapmak istersek, `history` komutunun çıktısını `grep`e bağlayıp(pipe) kalıplar ile arama yapabiliriz.
`history | grep find` komutu geçmişte kullanılan "find" altdizgesini içeren komutları çıktı olarak verir.

Birçok shellde, `Ctrl+R` kullanarak geçmişiniz içinde geriye doğru arama yapabilirsiniz.
`Ctrl+R`a bastıktan sonra, geçmişinizde aramak istediğiniz diziyi yazabilirsiniz.
Daha da fazla bastıkça girdiğiniz diziyi içeren eşleşmeler içinde ilerleyebilirsiniz.
[zsh](https://github.com/zsh-users/zsh-history-substring-search)de YUKARI/AŞAĞI tuşlarını kullanarak da bu fonksiyon aktifleştirilebilir.
`Ctrl+R` üzerine güzel bir ekleme [fzf](https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#ctrl-r) kısayolları kullaranak sağlanabilir.
`fzf` genel amaçlı, birçok komut ile kullanılabilen bir bulanık arayıcıdır (fuzzy finder).
Burada bulanık şekilde geçmişinizde eşleştirme yapıp sonuçları kullanışlı ve görsel olarak hoş bir şekilde sunar.

Kullanmayı gerçekten çok sevdiğim komut geçmişi ile alakalı bir diğer özellik de **geçmiş-tabanlı otomatik öneriler**.
İlk olarak [fish](https://fishshell.com/) shell ile sunulan bu özellik dinamik olarak şu anki komutunuzu aynı şekilde başlayan en son yazdığınız komuta otomatik olarak tamamlar.
[zsh](https://github.com/zsh-users/zsh-autosuggestions)'de aktif edilebilir bir özellik olarak bulunmaktadır ve shell kullanım kalitenizi gerçekten arttırabilecek bir hile olabilir.

Son olarak da, akılda bulunması gereken bir özellik eğer bir komuta boşluk karakteri ile başlanırsa, onun shell geçmişine eklenmeyeceğidir.
Bu özellik özellikle şifreler veya hassas bilgiler içeren komutlar kullanırken kullanışlı olmaktadır.
Eğer baştaki boşluğu koymayı unuttuysanız, her zaman `.bash_history` ya da `.zhistory` dosyalarını manuel olarak düzenleyerek bir girdiyi silebilirsiniz.

## Dizinler Arasında Hareket Etme

Şu ana kadar, zaten işlem yapmak istediğiniz dizinde olduğunuzu varsaydık. Peki, dizinler arasında nasıl kolaylıkla hareket edebiliriz?
Bunu yapmanın birçok kolay yolu var. Mesela shell mahlasları(aliases) oluşturmak veya [ln -s](https://www.man7.org/linux/man-pages/man1/ln.1.html) komutuyla symlinkler oluşturmak gibi. Fakat aslında geliştiriciler bu probleme oldukça zekice ve sofistike çözümler geliştirdiler şu ana kadar.

Bu kursun genel temasında olduğu şekilde, çoğunlukla en yaygın durumları optimize etmek istersiniz.
En sık ve/veya en son erişilen dosya ve dizinlere erişmek [`fasd`](https://github.com/clvv/fasd) ve [`autojump`](https://github.com/wting/autojump) gibi araçlarla yapılabilir.
Fasd dosyaları ve dizinleri [_frecency_](https://developer.mozilla.org/en/The_Places_frecency_algorithm) ölçütüne göre sıralar. Frecency, sıklık(frequency) ve yenilik(recency) kelimelerinin birleşmesiyle oluşmuştur.
Varsayılan olarak, `fasd`, `z` komutu kullanarak _frecent_ bir dizinin isminden bir parça kullanarak dizine `cd`lemenizi sağlar. Örneğin, eğer `/home/user/files/cool_project` dizinini sıklıkla kullanıyorsanız, `z cool` yazarak kolayca buraya zıplayabilirsiniz. Autojump kullanırkense, aynı dizin değişimi `j cool` yazarak yapılabilir.

Dizin yapılarına hızlıca kuşbakışı bakabilmek için birçok kompleks araç bulunmaktadır. Bunlardan bazıları: [`tree`](https://linux.die.net/man/1/tree), [`broot`](https://github.com/Canop/broot) veya [`nnn`](https://github.com/jarun/nnn) veya [`ranger`](https://github.com/ranger/ranger) gibi tam ölçekli dosya yöneticileri

# Örnekler

1. [`man ls`](https://www.man7.org/linux/man-pages/man1/ls.1.html) sayfasını okuyun ve aşağıdaki şekilde dosyaları listeleyen bir `ls` komutu yazın.

    - Tüm dosyaları içerir, gizli dosyalar dahil
    - Dosya büyüklükleri, kullanıcı dostu şekilde yazdırılmalıdır (örneğin 454279954 yerine 454M)
    - Dosyalar yeniden eskiye doğru sıralanmalıdır
    - Çıktı renklendirilmelidir

    Örnek çıktı aşağıdaki şekilde görünebilir:

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

1. Aşağıdaki işlemleri yapan `marco` ve `polo` komutlarını yazın.
`marco`yu çalıştırdığınız her zaman, şu an içinde olduğunuz dizin bir şekilde kaydedilir, sonra `polo` komutunu çalıştırdığınızda, nerede olursanız olun, `polo`, `marco` komutunu çalıştırdığınız dizine geri `cd`ler.

Debug işlemini kolaylaştırmak için kodunuzu ayrı bir `marco.sh` dosyasına yazıp `source marco.sh` komutunu çalıştırarak tanımlamaları shellinize (tekrar) yükleyebilirsiniz.

{% comment %}
marco() {
    export MARCO=$(pwd)
}

polo() {
    cd "$MARCO"
}
{% endcomment %}

1. Nadiren başarısız olan bir komutunuz var diyelim. Debuglayabilmeniz için çıktısını yakalamanız lazım ama başarısız olan bir sonuç almak için tek tek çalıştırmak zaman kaybettirici oluyor.
Aşağıdaki scripti başarısız olana kadar çalıştırıp standard çıktıyı yakalayan ve hataları bir dosyaya yönlendirip en sonunda her şeyi çıktı olarak veren bir bash scripti yazın.
Bonus Puan: Kaçıncı çalıştırma sonucunda scriptin hata verdiğini gösterin. 

    ```bash
    #!/usr/bin/env bash

    n=$(( RANDOM % 100 ))

    if [[ n -eq 42 ]]; then
       echo "Bir yerlerde hata var"
       >&2 echo "Hatta sihirli sayıları kullanmaktan kaynaklanıyor"
       exit 1
    fi

    echo "Her şey plana göre gitti"
    ```

{% comment %}
#!/usr/bin/env bash

count=0
until [[ "$?" -ne 0 ]];
do
  count=$((count+1))
  ./random.sh &> out.txt
done

echo "$count çalıştırmadan sonra hata bulundu"
cat out.txt
{% endcomment %}

1. Derste gördüğümüz üzere `find` komutunun `-exec` işaretçisi aradığımız dosyalar üzerinde işlem yapmak için oldukça güçlü bir araç.
Peki, bulduğumuz **tüm** dosyalar üzerinde bir işlem yapmak istesek, mesela hepsinden bir zip dosyası oluşturmak gibi? 
Şu ana kadar gördüğünüz üzere komutlar hem argümanlarından hem de STDIN'den girdi alabiliyorlar.
Komutları birbirine bağlarken (piping), STDOUT'u STDIN'e bağlıyoruz, fakat `tar` gibi bazı komutlar argümanlardan girdi alıyorlar.
Arada bir köprü olmak için [`xargs`](https://www.man7.org/linux/man-pages/man1/xargs.1.html) komutu STDIN'i argümanları olarak kullanarak komutu çalıştırır.
Örneğin `ls | xargs rm` şu anki dizindeki dosyaları siler.

    Göreviniz öz yinelemeli şekilde bir klasördeki tüm HTML dosyalarını bulup onlarla bir zip dosyası oluşturmak. Unutmayın, komutunuz dosyalarınızın isminde boşluk olsa da çalışmalıdır. (ipucu: `xargs`'ın `-d` işaretçisine bakın)
    {% comment %}
    find . -type f -name "*.html" | xargs -d '\n'  tar -cvzf archive.tar.gz
    {% endcomment %}

1. (İleri Seviye) Özyinelemeli şekilde bir klasördeki en son düzenlenen dosyayı bulan bir komut veya script yazın. Daha genel olarak, tüm dosyaları en yeniden eskiye doğru sıralayabilir misiniz?
