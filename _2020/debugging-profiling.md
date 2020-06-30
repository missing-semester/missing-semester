---
layout: lecture
title: "Hata Ayıklama ve Ayrıntılı İnceleme"
date: 2019-01-23
ready: true
video:
  aspect: 56.25
  id: l812pUnKxME
---

Yazılım geliştirmenin altın kurallarından birisi yazdığınız programın sizin beklentinize göre değil programa yapacağı işi nasıl tarif ettiğinize göre çalışacağıdır. Bu dersimizde, hata barındıran ve beklediğimizden fazla kaynak tüketen programlarda hata ayıklama ve ayrıntılı inceleme için kullanacağımız faydalı yöntemleri inceleyeceğiz.

# Hata ayıklama (Debugging)

## Printf ile hata ayıklama ve loglama

"En etkili hata ayıklama aracı dikkatli düşünce ve akıllıca kullanılmış print cümlecikleridir." — Brian Kernighan, _Unix for Beginners_.

Bir programda hata ayıklama için kullanılan ilk yöntem hatanın tespit edildiği kod bloklarının etrafına yerleştirilen print cümlecikleridir. Hata ile ilgili yeterince bilgi sahibi olana kadar print cümleciklerini ekleme işlemi yinelenir.

İkinci yöntem ise print cümlecikleri yerine programınızda loglama yaklaşımını kullanmaktır. Loglama, birkaç sebeple print cümleciklerinden daha iyi bir yöntemdir:

- print cümleciklerinde olduğu gibi sadece standard output'a değil dosyalara, soketlere ve hatta uzak sunuculara logları yazabilirsiniz.
- Loglama farklı önem derecelerinin (INFO, DEBUG, WARN, ERROR vb.) kullanılmasını destekler.Bu önem dereceleri sayesinde log mesajlarını filtreleyerek daha kolay inceleyebilirsiniz.
- İlk defa ortaya çıkan hatalar için log çıktısının hatayı daha kolay anlamanıza yetecek miktarda bilgi barındırması olasıdır.

Mesajları loglayan örnek bir program kodunu [şu Python dosyasından](/static/files/logger.py) inceleyebilirsiniz:

```bash
$ python logger.py
# Sadece print cümlecikleri kullanarak işlenmemiş çıktı
$ python logger.py log
# Formatlı log çıktısı
$ python logger.py log ERROR
# Sadece önem seviyesi ERROR veya üstü olan mesajları göster
$ python logger.py color
# Renkli ve formatlı log mesajları göster
```

Log mesajlarını daha okunabilir hale getirmek için favori yöntemlerinden birisi logları renkler kullanarak kodlamaktır. Şu ana kadar terminalinizin bazı şeyleri daha okunaklı hale getirmek için renkleri kullandığının farkına varmışsınızdır. Pekiyi, terminal bunu nasıl yapar? `ls` veya `grep` gibi programlar[ANSI escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code) adı verilen özel karakter dizilimlerini kullanır. Bu karakter dizilimleri komut satırınıza çıktıları nasıl renklendirmesi gerektiğini söyler. Örneğin, `echo -e "\e[38;2;255;0;0mBu satır kırmızı renktedir\e[0m"` komutunu çalıştırdığınızda terminalinizde kırmızı renkli olarak `Bu satır kırmızı renktedir` mesajını yazacaktır. Aşağıdaki örnek script çoğu RGB kodlu rengin nasıl yazdırılabileceğini gösterir.

```bash
#!/usr/bin/env bash
for R in $(seq 0 20 255); do
    for G in $(seq 0 20 255); do
        for B in $(seq 0 20 255); do
            printf "\e[38;2;${R};${G};${B}m█\e[0m";
        done
    done
done
```
> **Çevirenin Notu:** RGB, Red(Kırmızı)-Green(Yeşil)-Blue(Mavi) renk bileşenlerinden her birinin 8 bit ve 0-255 arasında bir değer ile ifade edildiği ve 17 miliyona yakın rengin temsil edilebildiği bir renklendirme şemasıdır.

## 3. parti program logları

Daha kapsamlı programlar geliştirmeye başladıkça bu programların farklı programlara bağımlılıkları oluşmaya başlayacaktır. Web sunucuları, veritabanları veya mesajlaşma programları bu tür bağımlılıklar için tipik örneklerdir. Bu tür programlar ile etkileşim halinde zaman zaman bu programların loglarını da incelemeniz gerekecektir, sadece kendi programınızın logları bazı durumlarda yetersiz kalacaktır.

Çoğu program kendi loglarını sistemlerinizde bir konuma yazarlar. UNIX ve benzeri sistemlerde bu logları `/var/log` dizinine yazmak genel geçer bir yöntemdir. Örneğin, [NGINX](https://www.nginx.com/) web sunucusu loglarını `/var/log/nginx` dizinine yazar. Çoğu Linux sistem kurulu servisleri veya çalışan servisler gibi pek çok işlemi kontrol etmek için `systemd` adı verilen özel bir hayalet program (daemon) kullanır. `systemd` log çıktılarını `/var/log/journal` dizini içine özel bir formatta yazar. `systemd` loglarını incelemek için [`journalctl`](https://www.man7.org/linux/man-pages/man1/journalctl.1.html) komutunu kullanabilirsiniz. Benzer şekilde macOS'da da `/var/log/system.log` dosyası yer alır ancak gün geçtikçe daha fazla sayıda program loglarını bu konuma değil sistemin kendi loguna yazar. macOS'da system.log içeriğini [`log show`](https://www.manpagez.com/man/1/log/) komutu ile görüntüleyebilirsiniz. Çoğu UNIX sistemde [`dmesg`](https://www.man7.org/linux/man-pages/man1/dmesg.1.html) komutu ile işletim sisteminin kernel loglarını görüntüleyebilirsiniz.

Sistemin kendi loguna yazmak için [`logger`](https://www.man7.org/linux/man-pages/man1/logger.1.html)  adı verilen komut satırı programını kullanabilirsiniz. Aşağıdaki örnekte `logger` kullanılarak sistem loguna yazma ve sistem logundan görüntüleme işlemlerinin nasıl yapılabileceğini görebilirsiniz. Çoğu programlama dili bindingler aracılığı ile sistem loguna erişim ve kullanım imkanı sunar.

```bash
logger "Merhaba sistem logu"
# macOS üzerinde logu görüntülemek için
log show --last 1m | grep Merhaba
# Linux üzerinde logu görüntülemek için 
journalctl --since "1m ago" | grep Merhaba
```

Veri işleme dersimizde de gördüğünüz üzere log mesajları büyük miktarda ve zengin içeriğe sahip oldukları için log mesajlarından faydalı bilgileri ayıklamak için bu mesajları işlemek ve filtrelemek gerekecektir. Eğer yoğun olarak `journalctl` ve `log show` ile log mesajlarını inceliyorsanız bu komutların flaglerini kullanarak ilk aşama filtreleme işlemlerini rahatlıkla yapabilirsiniz. Bununla birlikte gelişmiş log gösterim ve log dosyalarına konumlama özellikleri sunan [`lnav`](http://lnav.org/) gibi araçları da kullanabilirsiniz. 

## Hata ayıklayıcılar (Debuggers)

printf cümlecikleri ile yapacağınız hata ayıklama işlemleri ihtiyacınızı karşılamıyorsa hata ayıklayıcı (debugger) adı verilen özel programları kullanmalısınız. Hata ayıklayıcılar programınız ile çalışma anında etkileşime geçmenizi sağlarlar. Bu sayede:

- Programınızın çalışmasını belirttiğiniz herhangi bir satırda duraklatabilirsiniz
- Programınızı her seferinde bir komut olacak şekilde duraklatarak çalıştırabilirsiniz
- Programınız hata ile sonlandığında tüm program değişkenlerinin içeriğini inceleyebilirsiniz
- Belirli bir koşul oluştuğunda programınızı sonlandırabilirsiniz
- Daha bir çok gelişmiş özellik sayesinde hata ayıklama işlemlerini daha rahat yapabilirsiniz

Çoğu programlama dili ve ortamının kendi hata ayıklayıcısı vardır. Python için bu hata ayıklayıcı [`pdb`](https://docs.python.org/3/library/pdb.html) komutu ile kullanabileceğiniz Python Debugger'dır.

Aşağıda `pdb`'nin desteklediği bazı komutlar yer almaktadır:

- **l**(ist) - Aktif kod satırı etrafındaki 11 kod satırını gösterir veya önceki listeleme işlemini devam ettirir.
- **s**(tep) - Aktif kod satırını çalıştırıp, mümkün olan ilk anda da çalışmayı duraklatır.
- **n**(ext) - Aktif fonksiyonu sonraki satıra kadar veya fonksiyonun sonlandığı satıra kadar çalıştırır.
- **b**(reak) - breakpoint adı verilen duraklama noktası tanımlar (verilen argümana bağlı olarak).
- **p**(rint) - İfadeyi aktif bağlamda çalıştırır ve değerini yazdırır. Buna ilave olarak [`pprint`](https://docs.python.org/3/library/pprint.html) kullanan **pp** alternatifi da vardır.
- **r**(eturn) - Programın çalışmasını aktif fonksiyon sonuna kadar devam ettirir.
- **q**(uit) - Hata ayıklayıcıyı durdurur.

Gelin şimdi `pdb` kullanarak aşağıdaki hatalı Python kodunu düzeltelim. (Ders videosuna bakınız).

```python
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n):
            if arr[j] > arr[j+1]:
                arr[j] = arr[j+1]
                arr[j+1] = arr[j]
    return arr

print(bubble_sort([4, 2, 1, 8, 7, 6]))
```

Python yorumlanan bir dil olduğu için komut satırından `pdb`'yi kullanarak komutları ve kod parçalarını çalıştırabiliriz. `pdb`'ye alternatif olarak [`IPython`](https://ipython.org) REPL ortamını kullanan [`ipdb`](https://pypi.org/project/ipdb/)'yi de kullanabilirsiniz. `ipdb` cümle tamamlama, kod renklendirme, daha iyi yığın izleme ve daha iyi gözlemleme gibi imkanları `pdb` ile benzer bir ara yüz sağlayarak kullanabilmemizi sağlar. 

Daha alt seviyede programlama işlemleri için [`gdb`](https://www.gnu.org/software/gdb/) ( gdb kullanımını kolaylaştıran [`pwndbg`](https://github.com/pwndbg/pwndbg) eklentisini de kullanabilirsiniz) ve [`lldb`](https://lldb.llvm.org/) gibi araçları kullanabilirsiniz. Bu araçlar C benzeri dillerdeki hata ayıklama işlemleri için optimize edilmişlerdir ve aşağı yukarı yukarıda ele aldığımız iş akışını kullanarak program değişkenlerini görüntülemenizi sağlarlar.

> **Çevirmenin Notu:** REPL, Read-Evaluate-Print-Loop adı verilen iş akışının kısaltmasıdır. Çoğunlukla yorumlanan dillerde (Python, JavaScript vb.) etkileşimli geliştirme ortamında girdiğiniz kodun yorumlayıcı tarafından okunması (read), sonrasında değerlendirilmesi (evaluate) ve sonuçlarının da genelde terminalde gösterilmesini (print) ifade eden döngüyü (loop) ifade eder.

## Özelleşmiş Araçlar

Kendi geliştirmediğiniz ve derlenmiş bir programda hata ayıklama yapmanız gerektiğinde bu işlem için de özelleşmiş araçlar vardır. Programlar sadece işletim sistemi kernelinin yapabileceği işlemleri yapabilmek için [Sistem çağrıları (System Calls)](https://en.wikipedia.org/wiki/System_call) adı verilen komutları kullanırlar. Bu sistem çağırılarını Linux üzerinde [`strace`](https://www.man7.org/linux/man-pages/man1/strace.1.html), macOS ve BSD üzerinde ise[`dtrace`](http://dtrace.org/blogs/about/) gibi araçlar ile yakalayıp inceleyebilirsiniz. `dtrace`, kendi dili olan `D` dilini kullandığı için kullanımı biraz zor olabilir. `dtrace`'i kullanan ancak `strace`'e benzer ara yüz sağlayan [`dtruss`](https://www.manpagez.com/man/1/dtruss/) macOS ve BSD üzerinde size daha rahat bir kullanım sağlayacaktır (daha fazla ayrıntı için [şu linkteki](https://8thlight.com/blog/colin-jones/2015/11/06/dtrace-even-better-than-strace-for-osx.html) içeriği inceleyebilirsiniz). 


Aşağıdaki örnekte `ls` komutunun kullandığı [`stat`](https://www.man7.org/linux/man-pages/man2/stat.2.html) sistem çağrısının izini sürmek için `strace` ve `dtruss` araçlarının kullanımını görebilirsiniz. `strace` hakkında daha ayrıntılı bilgi sahibi olmak için [şu linkteki](https://blogs.oracle.com/linux/strace-the-sysadmins-microscope-v2) içeriği okumanızı tavsiye ediyorum.


```bash
# Linux
sudo strace -e lstat ls -l > /dev/null
4
# macOS
sudo dtruss -t lstat64_extended ls -l > /dev/null
```

Programınızdaki bazı sorunları tespit etmek için programın ağ üzerinden alıp verdiği paketleri incelemeniz gerekebilir. Bu durumda [`tcpdump`](https://www.man7.org/linux/man-pages/man1/tcpdump.1.html) ve [Wireshark](https://www.wireshark.org/) gibi paket analizi araçlarını kullanarak ağ paketi içerikleri inceleyebilir ve çeşitili kriterlere göre filtreleyebilirsiniz.

Web geliştiricileri için Chrome ve Firefox tarayıcılarının geliştirici araçları oldukça kullanışlıdır. Bu araçlardan bazıları şunlardır: 
- Kaynak kodu görüntüleme - herhangi bir web sitesinin HTML/CSS/JS kodlarını incelemek için kullanılabilir.
- Canlı HTML, CSS, JS düzenleme - test için web sitesinin kodunu ve stilini canlı olarak değiştirmek için kullanılabilir.
- Javascript komut satırı - Javascript komutlarını çalıştırmak için kullanılabilir.
- Ağ - web sitesinin yaptığı ağ isteklerinin zamanlamasını analiz etmek için kullanılabilir.
- Depolama - web sitesinin çerezlerini ve depoladığı diğer verileri incelemek için kullanılabilir


## Statik Kod Analizi

Bazı hataları incelemek için herhangi bir kod çalıştırmanıza gerek yoktur. Örneğin, sadece yazılan kodu okuyarak bir döngünün sayaç değişkeninin dış bağlamdaki aynı isimli bir değişkeni gölgelediğini (döngünün dışındaki bağlamda yer alan değişkenin değerini bozma durumu) anlayabilirsiniz. Benzer şekilde sadece koda bakarak henüz tanımlanmamış bir değişkenin kullanılmaya çalışıldığını görebilirsiniz. Bu tür durumlarda [statik kod analizi](https://en.wikipedia.org/wiki/Static_program_analysis) araçlarını kullanabilirsiniz. Statik kod analizi araçları kaynak kodunuzu girdi olarak alıp tanımlı kuralları kodunuza uygulayarak kodun doğruluğunu çıkarsamaya çalışırlar.

Aşağıdaki Python kod parçasında birkaç hata var. İlk olarak `foo` isimli döngü sayaç değişkeni daha yukarıda tanımlanmış olan `foo` fonksiyonunu maskelemektedir. Ayrıca son satırda değişken olarak `bar` yerine `baz` isimli değişken kullanılmaya çalışılmış. Örnek kod parçası `sleep` çağrısı tamamlandıktan sonra (program çalıştırıldıktan aşağı yukarı 1 dakika sonra) hatalı bir şekilde sonlanır.

```python
import time

def foo():
    return 42

for foo in range(5):
    print(foo)
bar = 1
bar *= 0.2
time.sleep(60)
print(baz)
```

Statik kod analizi araçları yukarıdakine benzer kod hatalarını tespit edebilirler. Yukarıdaki örnek kod parçasını [`pyflakes`](https://pypi.org/project/pyflakes)'e verdiğimizde her iki hatanın da tespit edileceğini görürsünüz. Aynı kod parçasını [`mypy`](http://mypy-lang.org/) isimli tip kontrolü analizi yapan araca girdi olarak verdiğimizde `bar` değişkenin ilk anda tipinin `int` olduğunu ancak sonradan `float` tipine dönüştürüldüğü tespit edecektir. Tekrar etmek gerekirse, bu sorunları kod çalıştırmadan statik kod analizi araçları kullanarak tespit ettik.

Komut satırı araçları dersimizde benzer statik analizi yapmamızı sağlayan [`shellcheck`](https://www.shellcheck.net/) aracını ele almıştık.

```bash
$ pyflakes foobar.py
foobar.py:6: redefinition of unused 'foo' from line 3
foobar.py:11: undefined name 'baz'

$ mypy foobar.py
foobar.py:6: error: Incompatible types in assignment (expression has type "int", variable has type "Callable[[], Any]")
foobar.py:9: error: Incompatible types in assignment (expression has type "float", variable has type "int")
foobar.py:11: error: Name 'baz' is not defined
Found 3 errors in 1 file (checked 1 source file)
```

Çoğu entegre yazılım geliştirme (IDE) ortamı bu araçların çıktılarını gösterme ve ilgili kod satırlarına konumlanma desteği sunar. Bu yönteme genelde **code linting** denir ve kod yazım stili ve güvenlik gibi denetimler için de kullanılan bir yöntemdir.

Vim kullanıyorsanız [`ale`](https://vimawesome.com/plugin/ale) veya [`syntastic`](https://vimawesome.com/plugin/syntastic) eklentileri ile benzer denetimlerin yapılmasını sağlayabilirsiniz. Python için [`pylint`](https://github.com/PyCQA/pylint) ve [`pep8`](https://pypi.org/project/pep8/) araçlarını kod yazımı stili denetimi için, [`bandit`](https://pypi.org/project/bandit/)'i ise yaygın güvenlik problemleri denetimi için kullanabilirsiniz. Diğer programlama dilleri için kullanabileceğiniz statik kod analizi araçlarının listesine [Awesome Static Analysis](https://github.com/mre/awesome-static-analysis) sayfasından, linter araçları listesine de [Awesome Linters](https://github.com/caramelomartins/awesome-linters) sayfasından göz atabilirsiniz.

Kod stili denetlemesi yapan araçları bütünleyici araçlar olarak kod formatlama araçları da kullanılır. Python için [`black`](https://github.com/psf/black), Go için `gofmt`, Rust için `rustfmt` ve JavaScript, HTML ve CSS için [`prettier`](https://prettier.io/) bu araçlardan bazılarıdır. Bu araçlar kodunuzu ilgili programlama dili için tanımlı genel geçer yazım stili kurallarını kullanarak otomatik olarak formatlarlar. Kod stiliniz ile ilgili denetimleri bu araçların kontrolüne bırakmak istemiyor olabilirsiniz. Ancak, diğer yazılımcıların sizin kodunuzu daha rahata okuması, aynı zamanda da sizin diğerlerinin kodunu daha rahat okuyabilmeniz için kod stili standartlarının kullanımı önemlidir. 


# Ayrıntılı İnceleme (Profiling)

Kodunuz beklediğiniz gibi çalışıyor olsa bile, eğer kodunuz gereğinden fazla CPU veya bellek kullanıyorsa programınız yeterince iyi kodlanmamış demektir. Algoritma derslerinde genelde big _O_ notasyonu öğretilir, ancak bu derslerde kötü performansa neden olan kod parçalarını nasıl tespit edebileceğiniz öğretilmez. Yazılımcılar arasında ["vakitsiz optimizasyon tüm kötülüklerin anasıdır" (premature optimization is the root of all evil)](http://wiki.c2.com/?PrematureOptimization) şeklinde bir söylem vardır. Bu söylem performans optimizasyonun doğru anda yapılmasının değerini ifade eder, bu nedele programlarınızın çalışma anındaki performans karakteristiklerini ayrıntılı inceleme için faydalanabileceğini araçların (profiling ve monitoring araçları) kullanımı hakkında fikriniz olmalı. Bu araçlar sayesinde programlarınızın hangi kısımlarının en çok zaman ve kaynak harcadığını tespit ederek doğru anda nokta atışı optimizasyon çalışmaları ile program davranışını ideale yaklaştırabilirsiniz.

> **Çevirmenin Notu:** [_Big O_](https://en.wikipedia.org/wiki/Big_O_notation#:~:text=Big%20O%20is%20a%20member,as%20the%20input%20size%20grows.) notasyonu ( O(x) şeklinde gösterilir) algoritmaların çalışma anında harcadığı zaman veya diğer kaynakları kullanma ölçüsünü ifade eden bir algoritma performansı ölçme yöntemidir. _Big O_ notasyonu Bachmann–Landau notasyonu veya asymptotic notation adı da verilen bir dizi notasyondan sadece bir tanesidir. Bu notasyonun arka planında ciddi matematiksel önermeler ve tesptiler yer alır. Kendi oluşturduğunuz algoritmalar için veya hazır verilen algoritmalar için **O(1)**, **O(n)**, **O(n^2)**, **O(logN)**, **O(NlogN)** ve **O(n!)** gibi performans ölçülerini ve algoritmaların hangi koşullarda ilgili ölçülere uygun performans sergilediğini incelemenizi öneriyorum.  

## Zamanlama

İki kod satırı arasında programınızın programınızın harcadığı zamanı, hata ayıklama işleminde olduğu gibi, sadece print cümlecikleri ve zamanlayıcıları kullanarak tespit edebilirsiniz. Aşağıdaki Python kod örneğinde [`time`](https://docs.python.org/3/library/time.html) modülü ile bu işlemin nasıl yapılabileceğini görebilirsiniz.

```python
import time, random
n = random.randint(1, 10) * 100

# Şu anki zamanı bir değişkene ata
start = time.time()

# Herhangi bir işlem yap
print("{} ms boyunca bekleyeceğim".format(n))
time.sleep(n/1000)

# start ile şu anki zaman arasındaki farkı hesapla
print(time.time() - start)

# Çıktı
# 500 ms boyunca bekleyeceğim
# 0.5713930130004883
```

Ancak, duvar saati ile yapılan yukarıdakine benzer bir zamanlama ölçümü sizi yanıltabilir. Çünkü, bilgisayarınız sadece sizin programınızı değil diğer programları da aynı anda çalıştırmaktadır veya bir olayın olmasını bekliyor olabilir. Bu nedenle, zamanlama ölçmek için kullanılan araçlar _Gerçek_ (Real), _Kullanıcı_ (User) ve _Sistem_ (Sys)zamanları şeklinde üç kırılıma sahiptirler. Genel anlamda, _Kullanıcı_ + _Sistem_ zamanlarının toplamı programınızın gerçekte kullandığı CPU zamanını verirler. Daha fazla bilgi için [şu linki](https://stackoverflow.com/questions/556405/what-do-real-user-and-sys-mean-in-the-output-of-time1) inceleyebilirsiniz.

- _Gerçek_ Zaman - Programınızın başlaması ile bitmesi arasında geçen zamandır. Ölçülen bu zamana diğer process'ler için harcanan zaman veya bir olayı beklerken (I/O veya ağ) geçen zaman da dahildir.
- _Kullanıcı_ Zamanı - Yazdığınız kodun harcadığı CPU zamanını verir.
- _Sistem_ Zamanı - İşletim sistemi kernel kodu çalıştırmak için harcanan CPU zamanını verir.

Örneğin, [`time`](https://www.man7.org/linux/man-pages/man1/time.1.html) modülü kullanarak ağ üzerinden HTTP ile veri alan bir kod parçasının zamanlamasını incelediğimizde yavaş bir ağ bağlantısına sahipesiniz aşağıdaki gibi bir durum ile karşılaşırsınız. Bu durumda HTTP üzerinden yapılan talebin 2 saniyede tamamlandığını ancak programın sadece 15 milisaniye seviyesinde CPU _Kullanıcı_ zamanı ve 12 milisaniye seviyesinde CPU _Sistem_ zamanı harcadığını görürüz.

```bash
$ time curl https://missing.csail.mit.edu &> /dev/null`
real    0m2.561s
user    0m0.015s
sys     0m0.012s
```

> **Çevirmenin Notu:** `/dev/null` Unix benzeri işletim sistemlerinde özel bir dosya tanımlayıcısıdır. Bu dosyaya yapılan tüm yazma işlemleri yazılan tüm veriyi göz ardı ederek yazma işlemini için başarı kodu döndürür. Daha fazla ayrıntı için [şu linke](https://en.wikipedia.org/wiki/Null_device) göz atabilirsiniz. 

## Ayrıntılı İnceleme Araçları (Profilers)

### Merkezi İşlem Birimi (CPU)

Ayrıntılı inceleme araçlarından bahsedilirken genelde _CPU_ kullanımı ile ilgili inceleme yapmamızı sağlayan araçlar kastedilir. _CPU_ kullanımını incelememizi sağlayan araçlar en sık rastladığımız ayrıntılı inceleme araçlarıdır. İki tür _CPU_ inceleme aracı vardır: _takip_ (tracing) ve _örneklem_ (sampling) inceleme araçları. _Takip_ tipindeki araçlar kodunuzun içindeki tüm fonksiyon çağırılarını izlenmesini ve takip edilmesini sağlarken _örneklem_ tipindeki araçlar belirli aralıklarla (genelde her milisaniyede bir defa) programınıza göz atarak programınızın yığınını (stack) kayıt altına alırlar. _Örneklem_ tipindeki araçlar topladıkları örneklemler üzerinde bir takım istatistikler yöntemler uygulayarak programınızın en çok hangi işlemlerde zaman harcadığını size raporlarlar. Bu konu hakkında daha ayrıntılı bilgi sahibi olmak isterseniz [şu linkten](https://jvns.ca/blog/2017/12/17/how-do-ruby---python-profilers-work-) erişebileceğiniz giriş seviyesindeki kaynaktan faydalanabilirsiniz.

Çoğu programlama dili komut satırından kullanabileceğiniz _CPU_ inceleme araçları ile birlikte gelir. Bu araçlar çoğu zaman entegre geliştirme ortamları (IDE) ile de çalışır, ancak bir bu dersimizde komut satırı araçlarını kullanacağız. 

Python için fonksiyon çağırıları için harcanan zamanı `cProfile` modülünü kullanarak ayrıntılı bir şekilde inceleyebiliriz. Aşağıda, bir dosya içinde grep benzeri bir yöntem ile arama yapan örnek bir Python kodu yer almaktadır.


```python
#!/usr/bin/env python

import sys, re

def grep(pattern, file):
    with open(file, 'r') as f:
        print(file)
        for i, line in enumerate(f.readlines()):
            pattern = re.compile(pattern)
            match = pattern.search(line)
            if match is not None:
                print("{}: {}".format(i, line), end="")

if __name__ == '__main__':
    times = int(sys.argv[1])
    pattern = sys.argv[2]
    for i in range(times):
        for file in sys.argv[3:]:
            grep(pattern, file)
```

Yukarıdaki örnek programı aşağıda verilen komut ile ayrıntılı olarak inceleyebiliriz. İnceleme sonucuna baktığımızda en çok CPU zamanı harcayan işlemlerin I/O işlemleri ve regex işlemlerinin olduğunu görüyoruz. regex ifadelerini bir defa derleyip kod akışında derlenmiş ifadeyi kullanmak mümkün olduğu için `re.compile()` satırını döngü bloğundan çıkararak kodun zaman performansı açısından daha verimli hale getirebiliriz.

```bash
$ python -m cProfile -s tottime grep.py 1000 '^(import|\s*def)[^,]*$' *.py

[omitted program output]

 ncalls  tottime  percall  cumtime  percall filename:lineno(function)
     8000    0.266    0.000    0.292    0.000 {built-in method io.open}
     8000    0.153    0.000    0.894    0.000 grep.py:5(grep)
    17000    0.101    0.000    0.101    0.000 {built-in method builtins.print}
     8000    0.100    0.000    0.129    0.000 {method 'readlines' of '_io._IOBase' objects}
    93000    0.097    0.000    0.111    0.000 re.py:286(_compile)
    93000    0.069    0.000    0.069    0.000 {method 'search' of '_sre.SRE_Pattern' objects}
    93000    0.030    0.000    0.141    0.000 re.py:231(compile)
    17000    0.019    0.000    0.029    0.000 codecs.py:318(decode)
        1    0.017    0.017    0.911    0.911 grep.py:3(<module>)

[omitted lines]
```

Python ile hazır gelen `cProfile` modülünün ve diğer bir çok CPU incelemesi için kullanılan araçların temel sorunu zaman ölçümünü fonksiyon çağrısı bazında yapmalarıdır. Bu yöntem, özellikle 3. parti kütüphaneler kullanıyorsanız çok hızlı bir yöntemdir. Çünkü, bu yöntem ile bu kütüphanelerin içindeki fonksiyonlar da zaman ölçümüne dahil edilir. 

Ayrıntılı inceleme verisini göstermek için satır bazında harcanan zamanın gösterilmesi daha uygun ve anlaşılır bir yöntemdir. Bu yöntemi kullanan inceleme araçların _satır bazlı_ incelem araçları denir. 

Örneğin, aşağıdaki Python kod parçası ders sitemizin içeriğini indirip, bu içerik içindeki tüm linkleri ayıklar.


```python
#!/usr/bin/env python
import requests
from bs4 import BeautifulSoup

# @profile ibaresi satır bazlı inceleme aracına get_urls() fonksiyonunu
# incelemek istediğimizi ifade eden bir direktiftir
@profile
def get_urls():
    response = requests.get('https://missing.csail.mit.edu')
    s = BeautifulSoup(response.content, 'lxml')
    urls = []
    for url in s.find_all('a'):
        urls.append(url['href'])

if __name__ == '__main__':
    get_urls()
```


Eğer, Python ile hazır gelen `cProfile`'ı kullansaydık inceleme çıktısı olarak 2500 satırlık bir sonuç ile karşılaşacaktık. 2500 satırlık bu sonucu satır satır sıralayıp incelemek bir zahmetli olacaktır. Bunun yerine aynı kod örneğini [`line_profiler`](https://github.com/rkern/line_profiler) aracını kullanarak çalıştırdığımızda fonksiyon içindeki her bir satır için aşağıdakine benzer bir çıktı elde ederiz.

```bash
$ kernprof -l -v a.py
Wrote profile results to urls.py.lprof
Timer unit: 1e-06 s

Total time: 0.636188 s
File: a.py
Function: get_urls at line 5

Line #  Hits         Time  Per Hit   % Time  Line Contents
==============================================================
 5                                           @profile
 6                                           def get_urls():
 7         1     613909.0 613909.0     96.5      response = requests.get('https://missing.csail.mit.edu')
 8         1      21559.0  21559.0      3.4      s = BeautifulSoup(response.content, 'lxml')
 9         1          2.0      2.0      0.0      urls = []
10        25        685.0     27.4      0.1      for url in s.find_all('a'):
11        24         33.0      1.4      0.0          urls.append(url['href'])
```

### Bellek (Memory)

C ve C++ gibi dillerde programlarınızda bellek sızıntısı (memory leak) oluşabilir ve bu durumda programınız işletim sisteminden aldığı belleği ihtiyacı olmadığı halde çalıştığı süre boyunca kendinde tutabilir. Bu tip durumları ayrıntılı bir şekilde incelemek için [Valgrind](https://valgrind.org/) benzeri bellek sızıntısı tespitinde size yardımcı olabilecek araçları kullanabilirsiniz.

Python gibi ihtiyaç duyduğu belleği doğrudan işletim sisteminden değil de sanal makina benzeri bir yapı sunan kendi özgü çalışma ortamı olan diller için de bellek sızıntıları nadir de olsa karşılaşılan durumlardır. Bu tür dillere `garbage collected` diller denir ve bu dillerde yazdığımız kodun kullandığı bellek tüm bellek referansları geçersiz hale gelince `garbage collector` tarafından otomatik olarak geri alınır. Bu tür dillerde de nesnelere referans vermek için kullanılan işaretçiler nedeniyle bellek sızıntısının meydana gelebilir. Aşağıda, [memory-profiler](https://pypi.org/project/memory-profiler/) (`@profile` direktifini bu araçla da kullandığımıza dikkat edin) kullanarak bellek incelemesi yapılan bir Python programının çıktısı yer almaktadır.

```python
@profile
def my_func():
    a = [1] * (10 ** 6)
    b = [2] * (2 * 10 ** 7)
    del b
    return a

if __name__ == '__main__':
    my_func()
```

```bash
$ python -m memory_profiler example.py
Line #    Mem usage  Increment   Line Contents
==============================================
     3                           @profile
     4      5.97 MB    0.00 MB   def my_func():
     5     13.61 MB    7.64 MB       a = [1] * (10 ** 6)
     6    166.20 MB  152.59 MB       b = [2] * (2 * 10 ** 7)
     7     13.61 MB -152.59 MB       del b
     8     13.61 MB    0.00 MB       return a
```

### Olay Ayrıntı İncelemesi (Event Profling)

Hata ayıklama için kullandığımız `strace` de olduğu gibi ayrıntılı inceleme yapmak istediğiniz kodu bir kara kutu olarak görmek isteyebilirsiniz. Bu durumda [`perf`](https://www.man7.org/linux/man-pages/man1/perf.1.html) komutunu kullanabilirsiniz. `perf` komutu CPU mimarileri arasındaki farklar soyutlama ile ortadan kaldırıp zaman ve bellek kullanımı ölçmek yerine sistem olaylarını ve ilişkili aktiviteleri bize raporlar. Örneğin, `perf` komutu düşük cache yerelliği (cache locality) sorunlarını veya yüksek miktarda sayfa hatalarını (page fault) ve ortak kaynak kullanımını senkronize etmek için kullanılan kilit sorunlarını (livelock) kolayca raporlayabilir.

Aşağıda `perf` komutunun kullanımı ile ilgili özet verilmiştir:

- `perf list` - perf ile takip edilip incelenebilecek olayları listeler.
- `perf stat COMMAND ARG1 ARG2` - Bir komut veya process ile ilişkili olayların sayısını raporlar 
- `perf record COMMAND ARG1 ARG2` - Bir komutun çalışması sırasındaki olayları kayıt altında alıp komut ile ilgili istatistikleri `perf.data` dosyasına kaydeder.
- `perf report` - `perf.data` dosyasında yer alan verileri formatlayıp raporlar

>**Çevirmenin Notu:** Cache locality, ilişkili verilerin bir birine yakın bellek alanlarında olduğu varsayımı ile belirli bellek bölgelerinin ön belleğe alınması ve belirli kod parçalarının bellekten okuma hızında performans iyileştirmesi sağlayan bir yöntemdir. 

>**Çevirmenin Notu:** Page fault, bellekte yer alan ancak bellek donanımı tarafından henüz adreslenmemiş bellek alanlarına erişilmek istendiğinde oluşan donanım seviyesindeki bir hatadır. Bu hata bellekten okuma performansını olumsuz etkiler.

>**Çevirmenin Notu:** Live lock, ortak bir kaynağı kullanmaya çalışan eş zamanlı işlemlerin dönüşümlü olarak çok kısa sürelerde kilit oluşturup sonra da bu kilidi serbest bırakmaları ve hiç birinin ilgili işlemi tamamlayacak kadar süre elde ederek ilgili ortak kaynağa erişememsi nedeni ile ortaya çıkan bir kaynak kullanım sorunudur. Bu sorun uygulamaların iş yapıyor gibi görünüp işlemlerini bitirememelerine neden olur. 

### Görselleştirme

Gerçek dünyada olay inceleme araçları programların çok karmaşık olması nedeni ile büyük miktarda bilgi üretecektir. İnsanlar görsel canlılardır ve büyük miktardaki veriyi ve sayıyı yorumlamakta, anlamakta ve bir sonuç çıkarmakta güçlük çekerler. Bu nedenle olay inceleme araçlarının çıktılarını daha kolay anlaşılabilir hale getiren bir çok yardımcı araç vardır.

_Örneklem_ (sampling) tipindeki ayrıntı inceleme araçlarının çıktılarını incelemek için kullanılan görselleştirme yöntemlerinden bir tanesi [Flame Graph](http://www.brendangregg.com/flamegraphs.html) adı verilen yöntemdir. Bu yöntemde fonksiyon çağırıları Y ekseninde yer alır ve her bir fonksiyon için harcanan süre de X ekseninde gösterilir. Bu grafikler aynı zamanda etkileşimlidir ve programınızın herhangi bir parçası ile ilgili kısmı yakınlaştırmanızı ve yığın bilgisini (stack trace) görmenizi sağlar (aşağıdaki görselde herhangi bir yere tıklamayı deneyin).

[![FlameGraph](http://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)](http://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)


Çağırı grafları veya akış kontrol grafları programınızdaki fonksiyonlar arasındaki ilişkileri görselleştirir. Bu graflarda fonksiyonlar düğüm, fonksiyon çağırıları da kenar olarak görselleştirilir. Python için [`pycallgraph`](http://pycallgraph.slowchop.com/en/master/) kullanarak bu grafları üretebilirsiniz.

![Call Graph](https://upload.wikimedia.org/wikipedia/commons/2/2f/A_Call_Graph_generated_by_pycallgraph.png)


>**Çevirmenin Notu:** Graf ve grafik birbiri yerine kullanılan ancak aralarında ufak da olsa fark olan kavramlardır. Graf matematiksel bir fonksiyonun görsel olarak ifade edilmiş halidir, grafik ise günlük kullanımda birden çok büyüklük arasındaki ilişkilerin görsel halini tarif eden bir terimdir.

## Kaynak Kullanımı İzleme (Resource Monitoring)

Programınızın performansı hakkında fikir sahibi olmak için ilk adım olarak programınızın kaynak kullanımını analiz etmeniz gerekir. Programlar genelde kısıtlı kaynak durumunda yavaş çalışırlar, örneğin yavaş ağ bağlantısı veya yeterli miktarda bellek olmadığı durumlarda. CPU kullanımıi bellek kullanımı, ağ performansı, disk kullanımı gibi sistem kaynaklarının kullanımını ölçmek bir çok araç vardır. 

- **Genel İzleme** - Büyük ihtimalle bu işlem için en popüler araçlardan birisi [`htop`](https://hisham.hm/htop/index.php)'dır. `htop`, [`top`](https://www.man7.org/linux/man-pages/man1/top.1.html) aracının daha gelişmiş halidir. `htop` bilgisayarımızda çalışan processler ile ilgili çeşitli istatistikleri raporlayabilir. `htop` bir çok seçenek ve tuş kombinasyonuna sahiptir. Örneğin, `<F6>` tuşu ile processleri sıralayabilirsiniz, `t` seçeneği ile processleri ağaç hiyerarşisinde görüntüleyebilirsiniz, `h` seçeneği ile threadlerin gösterilmesini veya gizlenmesini sağlayabilirsiniz. Benzer özelliklere ve güzel bir kullanıc ara yüzüne sahip [`glances`](https://nicolargo.github.io/glances/) aracına da inceleyebilirsiniz. Tüm processler için özet ölçümleri görmek için [`dstat`](http://dag.wiee.rs/home-made/dstat/) aracını kullanabilirsiniz. `dstat` I/O, ağ, CPU kullanımı ve diğer birçok sistem bileşeni için gerçek zamanlı istatistikleri ve ölçümleri hesaplayabilir.
- **I/O İşlemleri** - [`iotop`](https://www.man7.org/linux/man-pages/man8/iotop.8.html) aracı gerçek zamanlı I/O kullanım bilgilerini gösteren ve yüksek I/O yapan processleri kontrol etmenizi sağlayan bir araçtır.
- **Disk Kullanımı** - [`df`](https://www.man7.org/linux/man-pages/man1/df.1.html) disk alanı (partition) bazındaki kullanım verilerini, [`du`](http://man7.org/linux/man-pages/man1/du.1.html) ise konumlanılan dizinde yer alan dosyaların disk kullanımını gösteren araçlardır. Bu araçların kabul ettiği `-h` seçeneği ile gösterimin daha okunaklı raporlanması sağlanabilir. `du`'nun daha interaktif versiyonu olan [`ncdu`](https://dev.yorhel.nl/ncdu) dizinlere konumlanma, dosya ve dizinleri silme gibi işlemleri destekler. 
- **Bellek Kullanımı** -  [`free`](https://www.man7.org/linux/man-pages/man1/free.1.html) aracı bilgisayarınızdaki toplam, kullanılmayan ve kullanılan bellek miktarı bilgisini gösteren bir araçtır. Bellek bilgisi `htop` gibi araçlar tarafından da gösterilir.
- **Kullanımdaki Dosyalar** - [`lsof`](https://www.man7.org/linux/man-pages/man8/lsof.8.html) aracı processler tarafından kullanılan dosyalara ilişkin bilgileri gösteren bir araçtır. Bu araç bir processing belirli bir dosyayı kullanıp kullanmadığını araştırmak için ideal bir araçtır. 
- **Ağ Bağlantıları ve Konfigürasyonu** - [`ss`](https://www.man7.org/linux/man-pages/man8/ss.8.html) aracı gelen ve giden ağ paket istatistiklerini ve ağ bağdaştırıcısı istatistiklerini incelemenizi sağlayan bir araçtır. `ss` aracı genel olarak bir portu hangi process'in kullandığını görmek için kullanılır. Yönlendirme, ağ cihazları ve bağdaştırıcılarına ilişkin bilgileri görmek için [`ip`](http://man7.org/linux/man-pages/man8/ip.8.html) komutunu kullanabilirsiniz. Unix benzeri sistemlerde kurulu gelen `netstat` ve `ifconfig` gibi araçlar kullanımdan kaldırılmak üzere belirlenmiş araçlardır. Bunların yerine yukarıda bahsettiğimiz araç ve komutları kullanabilirsiniz.
- **Ağ Kullanımı** - [`nethogs`](https://github.com/raboof/nethogs) ve [`iftop`](http://www.ex-parrot.com/pdw/iftop/) gibi etkileşimli araçlar ağ kullanımını incelemek için kullanılabilir. 

Yukarıda bahsettiğimiz araçları ve komutları test etmek için [`stress`](https://linux.die.net/man/1/stress) komutu ile bilgisayarınızda yapay yük oluşturabilirsiniz.


### Özelleşmiş Araçlar

Bazı durumlarda ayrıntıları ile ilgilenmeden iki aracın performansını karşılaştırmak isteyebilirsiniz. [`hyperfine`](https://github.com/sharkdp/hyperfine) gibi araçlar birbirinin alternatifi olan komut satırı araçlarının performanslarını karşılaştırmanızı sağlar. Örneğin, komut satırı ve scripting dersinde `find` komutu yerine `fd` komutunu kullanmanızı önermiştik. `hyperfine` ile bu iki komutu karşılaştırabiliriz. Aşağıdaki örneğimizde karşılaştırma sonucunda `fd` komutunun `find` komutundan 20 kat daha hızlı olduğunu görebilirsiniz.


```bash
$ hyperfine --warmup 3 'fd -e jpg' 'find . -iname "*.jpg"'
Benchmark #1: fd -e jpg
  Time (mean ± σ):      51.4 ms ±   2.9 ms    [User: 121.0 ms, System: 160.5 ms]
  Range (min … max):    44.2 ms …  60.1 ms    56 runs

Benchmark #2: find . -iname "*.jpg"
  Time (mean ± σ):      1.126 s ±  0.101 s    [User: 141.1 ms, System: 956.1 ms]
  Range (min … max):    0.975 s …  1.287 s    10 runs

Summary
  'fd -e jpg' ran
   21.89 ± 2.33 times faster than 'find . -iname "*.jpg"'
```

Hata ayıklama araçlarında olduğu gibi ayrıntılı inceleme araçları noktasında da web tarayıcıları olağanüstü yardımcı araçlara sahiptirler. Bu araçları kullanarak web sayfalarının yüklenme sürelerini, yükleme sırasında hangi işlemlerde zaman harcandığını (yükleme, görselleştirme, scripting vb.) inceleyebilirsiniz. Tarayıcı ayrıntılı inceleme araçlarının ayrıntıları için şu linklere [Firefox](https://developer.mozilla.org/en-US/docs/Mozilla/Performance/Profiling_with_the_Built-in_Profiler), [Chrome](https://developers.google.com/web/tools/chrome-devtools/rendering-tools) göz atabilirsiniz: .


# Alıştırmalar

## Hata Ayıklama
1. Linux'da `journalctl` veya macOS'da `log show` komutlarını kullanarak superuser kullanıcısının son bir günde kullandığı komutları listeleyin. Eğer son bir gün içinde çalıştırılmış herhangi bir komut yoksa `sudo ls` gibi zararsız birkaç komut çalıştırarak işlemi tekrar deneyin.

1. [Şu linkteki](https://github.com/spiside/pdb-tutorial) uygulamalı `pdb` dersini adım adım yaparak `pdb` komutlarını tanıyın. Daha ayrıntılı bilgi edinmek için [şu sayfaya](https://realpython.com/python-debugging-pdb) göz atabilirsiniz.

1. [`shellcheck`](https://www.shellcheck.net/) aracını kurarak aşağıdaki scripti denetleyiniz. Aşağıdaki koda nasıl bir sorun var? Bu sorunu düzeltin. Kod editörünüze linter eklentisini kurarak yazım ile ilgili uyarıları otomatik olarak almaya başlayın.

   ```bash
   #!/bin/sh
   ## Example: a typical script with several problems
   for f in $(ls *.m3u)
   do
     grep -qi hq.*mp3 $f \
       && echo -e 'Playlist $f contains a HQ file in mp3 format'
   done
   ```

1. (İleri Seviye) Tersine hata ayıklama (reversible debugging) konusu ile ilgili [şu linkteki](https://undo.io/resources/reverse-debugging-whitepaper/) yazıyı okuyun ve [`rr`](https://rr-project.org/) veya [`RevPDB`](https://morepypy.blogspot.com/2016/07/reverse-debugging-for-python.html) kullanarak bir örnek çalıştırın.

## Ayrıntılı İnceleme

1. [Şu Python dosyasında](/static/files/sorts.py) farklı birkaç sıralama algoritması yer alıyor. [`cProfile`](https://docs.python.org/3/library/profile.html) ve [`line_profiler`](https://github.com/rkern/line_profiler) kullanarak insertion sort ve quicksort algoritmalarının çalışma zamanlarını karşılaştırın. Bu algoritmaların darboğazları nelerdir? Algoritmaların bellek kullanımını görmek için `memory_profiler`'ı kullanın. Insertion sort algoritması diğerlerine göre neden daha iyi bir performansa sahip? Quicksort sıralama algoritmasının ilave bellek kullanmayan inplace versiyonunu inceleyin. Meydan okuma: `perf` aracını kullanarak her bir algoritmanın döngü sayısını, ön bellek kullanımını inceleyin.

1. Aşağıda, her bir argüman için Fibonacci sayısını hesaplayan örnek Python fonksiyon kodu verilmiştir.

   ```python
   #!/usr/bin/env python
   def fib0(): return 0

   def fib1(): return 1

   s = """def fib{}(): return fib{}() + fib{}()"""

   if __name__ == '__main__':

       for n in range(2, 10):
           exec(s.format(n, n-1, n-2))
       # from functools import lru_cache
       # for n in range(10):
       #     exec("fib{} = lru_cache(1)(fib{})".format(n, n))
       print(eval("fib9()"))
   ```

   Yukarıdaki kodu bir dosyaya taşıyarak çalıştırılabilir hale getirin.[`pycallgraph`](http://pycallgraph.slowchop.com/en/master/) aracını kurun. Kodu `pycallgraph graphviz -- ./fib.py` komutu ile çalıştırın ve `pycallgraph.png` dosyasının açarak içeriğini kontrol edin. `fib0` fonksiyonu kaç defa çağırılmış? Fonksiyonel programlama yöntemlerinden biri `memoization` yöntemini kullanarak kodumuzun performansını iyileştirebiliriz. Yorum satırı olarak yukarıda yer alan kodu kullanılır hale getirerek kodu `pycallgraph`ile yeniden çalıştırın. `fibN` fonksiyonunu bu düzenlemeler sonrasında kaç defa çağırıyoruz?

1. Genel sorunlardan bir tanesi kullanmak istediğiniz bir portun başka bir process tarafında o anda kullanılıyor olmasıdır. Gelin isteğimiz portu kullanan process'in pid değerini öğrenelim. Önce `python -m http.server 4444` komutu ile 4444 portunu dinleyen minimal bir web suncusu çalıştırın. Farklı bir terminal penceresinde `lsof | grep LISTEN` komutunu çalıştırıp portları dinleyen tüm processleri listeleyin. 4444 portunu kullanan process'in pid'ini bulup bu process'i `kill <PID>` komutu ile sonlandırın.

1. Process'lerin kullanacağı kaynakları sınırlamak araç çantanızda bulunması gereken faydalı araçlardan biridir.
`stress -c 3` komutunu çalıştırın ve `htop` komutu ile CPU kullanımını görselleştirin. Şimdi de `taskset --cpu-list 0,2 stress -c 3` komutunu çalıştırarak yine `htop` ile görselleştirin. `stress` komutu 3 CPU mu kullanıyor? `stress` neden 3 CPU kullanmıyor? Ayrıntılar için [`man taskset`](https://www.man7.org/linux/man-pages/man1/taskset.1.html) sayfasını inceleyin.
Meydan Okuma: taskset ile tanımladığını kaynak kullanımı sınırlandırmasını [`cgroups`](https://www.man7.org/linux/man-pages/man7/cgroups.7.html) kullanarak oluşturmayı deneyin. Bu sefer `stress -m` komutunun bellek kullanımını sınırlandırmayı deneyin.

1. (İleri Seviye) `curl ipinfo.io` komutu HTTP isteği yaparak açık IP adresiniz ile ilgili bilgileri alır. [Wireshark](https://www.wireshark.org/) uygulamasını açın `curl`'un gönderip aldığı paketleri izlemeyi deneyin. (İpucu: Wireshark'da sadece HTTP paketlerini izlemek için `http` filtersini kullanın).

