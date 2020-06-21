---
layout: lecture
title: "Kursa genel bakış + shell"
date: 2019-01-13
ready: true
video:
  aspect: 56.25
  id: Z56Jmr9Z34Q
---

# Motivasyon

Bilgisayar bilimcileri olarak, bilgisayarların tekrarlayan görevlere
yardımcı olma konusunda ne kadar harika olduklarını biliyoruz. Ancak,
bunun programların gerçekleştirmesini istediğimiz hesaplamalar için
olduğu kadar bilgisayar kullanımımız için de geçerli olduğunu sıkça
unutuyoruz.  Elimizin altında, bilgisayarla ilgili herhangi bir problem
üzerinde çalışırken daha üretken olabilmemizi ve daha karmaşık sorunları
çözebilmemizi sağlayan çok sayıda araç var. Buna rağmen çoğumuz bu
araçların sadece küçük bir kısmını kullanıyoruz; bizi idare etmeye
yetecek birkaç sihirli sözcük biliyoruz, takıldığımızda ise
internetten körlemesine kopyalayıp yapıştırıyoruz.

Bu ders, bunun üzerine gitmeyi hedefler.

Halihazırda bildiğiniz araçlardan en iyi şekilde nasıl yararlanacağınızı
öğretmek, alet çantanıza ekleyebileceğiniz yeni araçlar göstermek ve daha
fazlasını kendi başınıza keşfetmeniz için biraz heyecan aşılamak
istiyoruz. Ve bunun çoğu Bilgisayar Bilimi müfredatında eksik bir dönem
olduğuna inanıyoruz.

# Dersin yapısı

Bu ders, her biri [spesifik bir konuya](/2020/) odaklanan birer saatlik 11
dersten oluşmaktadır. Dersler büyük ölçüde bağımsız olsa da kursta
ilerledikçe önceki derslerin içeriğine aşina olduğunuzu varsayacağız.
Online ders notlarımız da olacak ancak bu notlarda bulunmayan çok sayıda
içerik (demolar şeklinde) ele alınacaktır. Dersleri kaydedeceğiz ve
kayıtlarını online olarak yayınlayacağız.

11 ders boyunca çok fazla noktaya değinmeye çalışıyoruz, bu yüzden
dersler oldukça yoğun. İçeriği kendi temponuzda öğrenmenize zaman tanımak
için her ders, sizi dersin kilit noktalarında yönlendiren bir dizi
alıştırma içeriyor. Her dersin sonunda sorularınızı yanıtlamanıza
yardımcı olmak için hazır olacağımız ofis saatleri düzenliyoruz. Kursa
online olarak katılıyorsanız, sorularınızı bize
[missing-semester@mit.edu](mailto:missing-semester@mit.edu) adresinden
yönlendirebilirsiniz.

Sahip olduğumuz sınırlı zaman nedeniyle, içeriğimizi tüm araçlara ve
araçların her özelliğine değinen bir dersle aynı düzeyde tutamayacağız.
Mümkün oldukça, sizi bir aracın veya konunun derinlerine inebilmeniz için
başka kaynaklara yönlendirmeye çalışacağız. Ancak aklınıza özellikle
takılan bir şey olursa, bize ulaşmaktan ve tavsiye istemekten çekinmeyin!

# Konu 1: Shell

## Shell (Kabuk) nedir?

Bilgisayarlar, günümüzde komutlar verebilmemiz için çeşitli arayüzlere
sahiptirler; fantastik kullanıcı grafik arayüzler, ses arayüzleri ve
hatta AR/VR her yerdeler. Bunlar, kullanım durumlarının %80'i için
mükemmeldirler, ancak genellikle yapmanıza izin verdikleri şeyler
sınırlıdır - olmayan bir butona basamaz ve önceden tanımlanmamış sesli
komut veremezsiniz. Bilgisayarınızın sağladığı araçlardan tam olarak
yararlanmak için geleneksel bir yönteme dönmeli ve metin tabanlı bir
arayüze bakmalıyız: Shell.

Elinizin altında bulunan neredeyse her platformda bir şekilde shell
bulunur ve ayrıca çoğunda da seçim yapabileceğiniz birkaç farklı shell
mevcuttur. Teferruatta farklılık gösterseler de, özlerinde hepsi kabaca
aynıdır: programları çalıştırmanıza, onlara girdi vermenize ve
çıktılarını yarı yapılandırılmış şekilde gözden geçirmenize izin
verirler.

Bu derste Bourne Again SHell yani kısaca "bash" üzerine odaklanacağız. Bu
shell, en yaygın kullanılanlardan birisidir ve sözdizimi birçok shell ile
benzerdir. Komutlarınızı yazabileceğiniz yer olan Shell _prompt_'u
(kabuk istemi) açmak için, önce bir _terminale_ ihtiyacınız vardır.
Cihazınızda muhtemelen bir tane kuruludur. Yoksa da kolayca bir tane
kurabilirsiniz.

## Shell kullanımı

Terminalinizi başlattığınızda, genellikle şöyle görünen bir
_istem (prompt)_ ile karşılaşırsınız:

```console
missing:~$ 
```

Bu, shell için ana metin tabanlı arayüzdür. `missing` makinesinde
olduğunuzu ve halihazırda bulunduğunuz yer olan geçerli çalışma
dizininizin, `~` yani home (ev) olduğunu gösterir. `$` ise root (kök)
kullanıcı olmadığınızı gösterir (ileride buna değinilecek). Bu istemde,
shell tarafından yorumlanacak bir _komut_ yazabilirsiniz. En temel komut
bir programı yürütmektir:

```console
missing:~$ date
Cum 19 Haz 2020 14:27:32 +03
missing:~$ 
```

Burada, (beklenildiği gibi) mevcut tarih ve saati yazdıran `date`
programını yürüttük. Shell sonrasında bizden, yürütmek için başka bir
komut ister. Aynı zamanda, bir komutu _argümanlar_ ile birlikte
yürütebiliriz:

```console
missing:~$ echo merhaba
merhaba
```

Bu örnekte, shell'e `echo` programını `merhaba` argümanıyla yürütmesini
söyledik. `echo` programı basitçe argümanlarını yazdırır. Shell, komutu
boşluk karakterlerinden bölerek ayrıştırır ve ardından ilk sözcük
tarafından belirtilen programı çalıştırır.  Sonraki sözcükleri programa
erişebileceği bir argüman olarak sağlar. Boşluk veya başka özel
karakterler içeren argümanlar vermek isterseniz (örn. "Aile Fotograflari"
isminde bir dizin), argümanı `'` veya `"` tırnak işaretleri arasına
alabilir (`"Aile Fotograflari"`) veya ilgili karakterlerden  `\` ile
kaçınabilirsiniz (`Aile\ Fotograflari`).

Peki shell `date` veya `echo` programlarını nerede bulacağını nasıl
biliyor? Shell esasen bir programlama ortamıdır, tıpkı Python veya Ruby
gibi. Bu nedenle değişkenler, koşullar, döngüler ve fonksiyonlara (bir
sonraki derste değinilecek) sahiptir. Bir komut çalıştırdığınızda,
shell'inizin yorumladığı ufak bir kod yazmış olursunuz. Barındırdığı
anahtar sözcüklerden biriyle eşleşmeyen bir komutu yürütmesi istendiğinde
shell, programı hangi dizinlerde  araması gerektiğini listeleyen `$PATH`
isimli _ortam değişkenine_ başvurur:


```console
missing:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
missing:~$ which echo
/bin/echo
missing:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

`echo` komutunu çalıştırdığımızda, shell `echo` programını yürütmesi
gerektiğini anlar ve bu isimdeki dosyayı bulmak için `$PATH` 'te bulunan
stringi `:` ile ayırarak elde ettiği dizinlerde arama yapar. Bulduğunda
ise çalıştırır (dosyanın _executable_ (yürütülebilir) olduğu göz önüne
alınırsa, buna ileride değinilecek). `which` programını kullanarak
verilen bir program için hangi dosyanın yürütüldüğünü bulabiliriz. Aynı
zamanda, yürütmek istediğimiz dosyanın _yolunu_ vererek `$PATH` 'i
tamamen es geçebiliriz.

## Shell içerisinde gezinme

Shell içerisinde bir path (yol), dizin listesinin birleştirilmiş halidir;
macOS ve Linux'ta `/` , Windows'ta ise `\` ile birleştirilmiştir. Linux
ve macOS'ta `/` yolu dosya sisteminin "root" (kök) dizinidir. Diğer tüm
dizinleri ve dosyaları altında barındırır. Windows'ta ise her disk bölümü
için ayrı root dizin vardır (örn `C:\`). Bu derste genel olarak Linux
dosya sistemi kullandığınızı varsayacağız. `/` ile başlayan yola
_absolute path_ (mutlak yol), diğerlerine ise _relative path_
(göreceli yol) denir. Realtive path'ler, `pwd` komutuyla görebildiğimiz
ve `cd` komutuyla değiştirebileceğimiz, geçerli çalışma dizinine
bağlıdır. Bir path'de (yolda) `.` mevcut dizini, `..` ise üst dizini
belirtir:

```console
missing:~$ pwd
/home/missing
missing:~$ cd /home
missing:/home$ pwd
/home
missing:/home$ cd ..
missing:/$ pwd
/
missing:/$ cd ./home
missing:/home$ pwd
/home
missing:/home$ cd missing
missing:~$ pwd
/home/missing
missing:~$ ../../bin/echo merhaba
merhaba
```
Shell istemimizin geçerli çalışma dizininin ne olduğu konusunda bizi
bilgilendirdiğine dikkat edin. İsteminizi, her çeşit yararlı bilgiyi
gösterecek şekilde yapılandırabilirsiniz. Bunu sonraki bir derste ele
alacağız.

Genel olarak, bir programı çalıştırdığımızda, aksi belirtilmedikçe
geçerli dizinde çalışır. Örneğin, dosyaları orada arar ve gerektiğinde
yeni dosyalar orada oluşturur.

Belirli bir dizinde nelerin var olduğunu görmek için `ls` komutunu
kullanırız:

```console
missing:~$ ls
missing:~$ cd ..
missing:/home$ ls
missing
missing:/home$ cd ..
missing:/$ ls
bin
boot
dev
etc
home
...
```

İlk argüman olarak bir dizin verilmedikçe, `ls` geçerli dizinin içeriğini
yazdırır. Çoğu komut, davranışlarını değiştiren `-` ile başlayan flag
(bayrak) ve option (seçenek: bir değere sahip bayrak) ifadeleri alır.
Genelde, `-h` veya `--help` bayrağıyla (Windows'ta `/?`) bir programı
çalıştırmak, size hangi bayrakları ve seçenekleri kullanabileceğinizi
bildiren yardım metni yazdırır. Örneğin, `ls --help` bize şunu söyler:

```
  -l                         use a long listing format
                             (uzun liste biçimi kullan)
```

```console
missing:~$ ls -l /home
drwxr-xr-x 1 missing  users  4096 Jun 15  2019 missing
```

Bu, bize mevcut her dosya ve dizin hakkında daha fazla bilgi verir. İlk
olarak, satırın başındaki `d` bize `missing` 'in bir dizin olduğunu
söyler.Ardından üç karakterden oluşan üç grup (`rwx`, `r-x`, `r-x`)
gelir. Bunlar, sırasıyla dosya sahibinin (`missing`), dosya sahibinin
bulunduğu grubun (`users`) ve diğerlerinin ilgili öğe üzerinde hangi
izinlere sahip olduğunu gösterir. `-` ilgili kişinin ilgili izne sahip
olmadığını belirtir. Yukarıdaki örnekte, `missing` dizininde yalnızca
dosya sahibine değişiklik yapma (`w`)  izni verilir
(örn. dosya ekleme/silme). Bir dizine girebilmek için, kullanıcının bu
dizinde ve üst dizinlerinde arama (`x`) iznine sahip olması gerekir.
İçeriğini listelemek için ise kullanıcının bu dizinde okuma (`r`) iznine
sahip olması gerekir. Dosya izinleri de beklediğiniz gibidir. `/bin`
dizinindeki hemen hemen tüm dosyaların son grubumuz olan "diğerleri"
için `x` iznine sahip olduğuna dikkat edin, böylece herkes bu programları
yürütebilir.

Bu noktada bilinmesi gereken diğer kullanışlı programlardan bazıları
şunlardır:  `mv` (dosya adlandırma/taşıma), `cp` (dosya kopyalama) ve
`mkdir` (yeni dizin oluşturma).

Bir programın argümanları, girdileri, çıktıları ve genel olarak nasıl
çalıştığı hakkında _daha fazla_ bilgi edinmek isterseniz `man` programını
bir deneyin. Argüman olarak programın adını alır ve size manuel sayfasını
gösterir. Çıkmak isterseniz `q` tuşuna basın.

```console
missing:~$ man ls
```

## Programları bağlama

Shell (kabuk) içerisinde, programlar kendileriyle ilişkili iki ana akışa
sahiptir: input stream (girdi akışı), output stream (çıktı akışı).
Program girdi okumaya çalıştığında girdi akışından okur, bir şey
yazdıracağı zaman çıktı akışına yazdırır. Normalde, bir programın girdi
ve çıktı akışı terminalinizdir. Yani, girdi olarak klavyeniz ve çıktı
olarak ekranınız. Ancak, bu akışları yeniden düzenleyebilirsiniz!

En basit yönlendirme şekli `< file` ve `> file` 'dır. Bunlar, bir
programın girdi ve çıktı akışlarını sırasıyla bir dosyaya yönlendirmenize
müsade ederler:

```console
missing:~$ echo merhaba > merhaba.txt
missing:~$ cat merhaba.txt
merhaba
missing:~$ cat < merhaba.txt
merhaba
missing:~$ cat < merhaba.txt > merhaba2.txt
missing:~$ cat merhaba2.txt
merhaba
```

Ayrıca bir dosyaya ekleme yapmak için `>>` kullanabilirsiniz. Bu tür
girdi / çıktı yönlendirmesinin en başarılı olduğu yer _pipe_'ların
kullanımıdır. `|` operatörü, programları birinin çıktısını diğerinin
girdisi olacak şekilde "zincirlemenizi" sağlar:

```console
missing:~$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2019 var
missing:~$ curl --head --silent google.com | grep --ignore-case content-length | cut --delimiter=' ' -f2
219
```

"Data wrangling" üzerine yapacağımız derste, pipe'lardan nasıl
faydalanılacağı hakkında daha fazla detaya gireceğiz.

## Çok amaçlı ve güçlü bir araç

Unix benzeri sistemlerin çoğunda, özel bir kullanıcı vardır: "root" (kök)
kullanıcısı. Yukarıda dosya listelemesinde görmüş olabilirsiniz. Root
kullanıcısı (neredeyse) tüm erişim kısıtlamalarının üzerindedir ve
sistemde herhangi bir dosyayı oluşturabilir, okuyabilir ve silebilir.
Ancak, yanlışlıkla bir şeyleri berbat etmek çok kolay olduğundan,
sisteminizde genellikle root kullanıcısı olarak oturum açmazsınız. Bunun
yerine, `sudo` komutunu kullanırsınız. Adından da anlaşılacağı gibi, "su"
ve "do" kavramlarından oluşur. “su”, “super user” (süper kullanıcı) veya
root kullanıcısı anlamına gelir. "do" ise bildiğiniz gibi yapmak anlamına
gelir. "İzin reddedildi" (Permission denied) hatası aldığınızda, nedeni
genelde o işi root olarak yapmanız gerektiğindendir. Yine de öncesinde
gerçekten bunu yapmak istediğinizi iki kez kontrol ettiğinizden emin olun!

Örneğin, yapılabilmesi için root kullanıcısı olunması gereken bir şey,
`/sys` dizinine bağlanan `sysfs` dosya sisteminde değişiklik yapmaktır.
`sysfs` , birtakım kernel (çekirdek) parametrelerini dosya olarak saklar,
böylece özel araçlar kullanmadan, kerneli o anda kolayca yeniden
yapılandırabilirsiniz.
**sysfs'nin Windows ve macOS'ta mevcut olmadığını unutmayın.**

Örneğin, dizüstü bilgisayarınızın ekranının parlaklığı, bu dizin altında
`brightness` olarak adlandırılan bir dosyada tutulur:

```
/sys/class/backlight
```

Bu dosyaya bir değer yazarak ekran parlaklığını değiştirebiliriz. İlk
düşünceniz şöyle bir şey yapmak olabilir:

```console
$ sudo find -L /sys/class/backlight -maxdepth 2 -name '*brightness*'
/sys/class/backlight/thinkpad_screen/brightness
$ cd /sys/class/backlight/thinkpad_screen
$ sudo echo 3 > brightness
An error occurred while redirecting file 'brightness'
open: Permission denied
```

Bu hata süpriz olabilir. Oysa komutu `sudo` ile çalıştırmıştık! Bu shell
hakkında bilmek gereken önemli bir şeydir. `|`, `>` ve `<` gibi işlemler
programın kendisi tarafından değil, _shell tarafından_ gerçekleştirilir.
`echo` ve arkadaşlarının `|` 'den haberi olmaz. Her ne olursa olsun
girdilerinden okur ve çıktılarına yazarlar. Yukarıdaki durumda; _shell_,
bunu `sudo echo` 'nun çıktısı olarak ayarlamadan önce parlaklık dosyasını
yazmak için açmaya çalışır. Ancak shell, root olarak çalışmadığı için
bunu yapması engellenir. Bu bilgiyi kullanarak bu sorunu çözebiliriz:

```console
$ echo 3 | sudo tee brightness
```

`tee` programı, `brightness` dosyasını yazmak için açan bir program
olduğundan ve root olarak çalıştığından dolayı tüm izinlere sahiptir.
`/sys` aracılığıyla her çeşit eğlenceli ve yararlı şeyi kontrol
edebilirsiniz, örneğin sistem LEDlerinin durumu gibi (dosya yolunuz
farklı olabilir):

```console
$ echo 1 | sudo tee /sys/class/leds/input6::scrolllock/brightness
```

# Sonraki adımlar

Gelinen noktada, temel görevleri yerine getirmek için shell kullanırken
nasıl bir yol izleyeceğinizi biliyorsunuz. İlgilenilen dosyaları bulmak
için gezinebilmeniz ve çoğu programın temel fonksiyonlarını
kullanabilmeniz gerekir. Bir sonraki derste, shell ve birçok kullanışlı
komut satırı programını kullanarak, daha karmaşık görevlerin nasıl
gerçekleştirileceği ve otomatikleştirileceği hakkında konuşacağız.

# Alıştırmalar

 1. `/tmp` altında  `missing` isimli yeni bir dizin oluşturun.
 1. `touch` programının nasıl kullanıldığına bir göz atın. `man` programı
 yardımcınız olacaktır.
 1. `touch` programını kullanarak `missing` içerisinde `semester` isimli
 yeni
    bir dosya oluşturun.
 1. Bu dosyaya her seferinde bir satır olarak aşağıdakileri yazın:
    ```
    #!/bin/sh
    curl --head --silent https://missing.csail.mit.edu
    ```
    İlk satır başlarda karmaşık gelebilir. `#` işaretinin bash'te yorum
    satırı başlattığını ve `!` operatörünün çift tırnaklı (") stringlerin
    içinde özel bir anlamının olduğunu bilmek faydalı olacaktır. Bash,
    tek tırnaklı stringlere (') farklı davranır: içindeki her değer kendi
    değerini korur. Daha fazla bilgi için bash'in
    [quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html)
    manuel sayfasına bakın.
 1. Dosyayı yürütmeyi deneyin, yani shell'de scriptin yolunu (`./semester`)
    yazın ve enter tuşuna basın. `ls` çıktısına danışarak neden işe
    yaramadığını kavrayın (ipucu: dosya izinlerine bakın).
 1. `sh` yorumlayıcısını başlatıp `semester` dosyasını ilk argüman olarak
 vererek komutu çalıştırın, yani `sh semester`. `./semester` çalışmazken
 bu neden işe yaradı?
 1. `chmod` nasıl kullanıldığına bir göz atın (örneğin `man chmod`).
 1. `sh semester` kullanmak yerine `./semester` kullanabilmeyi sağlamak
 için `chmod` kullanın. Shell dosyanızın sh kullanılarak yorumlanması
 gerektiğini nereden biliyor? Daha fazla bilgi için
 [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) hakkındaki bu
 sayfaya bakın.
 1. `semester` dosyasındaki "Last-Modified" yani değiştirilme tarihinin
 çıktısını, ev dizininizde `last-modified.txt` isimli bir dosyaya
 yazdırmak için `|` ve `>` kullanın.
 1. Dizüstü bilgisayarınızın pil düzeyini veya masaüstü bilgisayarınızın
 CPU sıcaklığını `/sys` 'den okuyan bir komut yazın. NOT: macOS veya
 Windows kullanıcısısıysanız, işletim sisteminizin sysfs'si yoktur, bu
 nedenle bu egzersizi atlayabilirsiniz.
