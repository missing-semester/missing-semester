---
layout: lecture
title: "Editörler (Vim)"
date: 2019-01-15
ready: true
video:
  aspect: 56.25
  id: a6Q8Na575qc
---

İngilizce uzun yazılar yazmak ve kod yazmak çok farklı aktiviteler. 
Programlama yaparken dosyaları değiştirdiğin, okuduğun, yönlendirdiğin 
ve kod düzenlemeleri yaptığın için uzun bir yazı yazmaya kıyasla daha fazla 
zaman harcarsın. Bu yüzden yazı yazmak ve kod yazmak için farklı programların 
(ör. Microsoft Word - Visual Studio Code) olması mantıklı.

Programlayıcılar olarak zamanımızın büyük bir kısmını kod düzenleyerek geçiririz 
bu yüzden ihtiyaçlarınızı karşılayan bir editöre hakim olmak için harcadığınız zaman 
buna değecektir. İşte yeni bir editörü öğrenmek için yapmanız gerekenler:

- Bir öğretici/tutorial ile başla (bu ders, artı olarak değindiğimiz kaynaklar)
- Bütün metin düzenleme ihtiyaçların için editörü kullanmaya çalış (başta seni 
yavaşlatsa bile)
- Öğrenmeye devam ettikçe işlerin yoluna girmeye başladığını göreceksin.
Öğrenmeyi bırakma

Eğer yukarıdaki metodları takip eder, bütün metin düzenleme amaçların için 
kendini yeni editörü kullanmaya adarsan, zaman çizgisi bunun gibi olacaktır. 
İlk bir yada iki saat içerisinde dosya açma, düzenleme, kaydetme ve çıkma gibi
temel editör fonksiyonlarını öğreneceksin. 20 saatlik bir kullanımdan sonra 
kullandığın eski editörde olduğun kadar hızlı olacaksın. 
Daha sonra faydalarını görmeye başlayacak, editör ile ilgili yeterli bilgiye 
sahip olacaksın ve kas hafızası ile kullandığın editör sana zaman kazandıracak. 
Modern metin editörleri havalı ve güçlüdür bu yüzden öğrenme asla sona ermez 
hatta daha fazla öğrendikçe hızında artacaktır.

# Hangi editörü öğrenmeliyiz?

Programlayıcıların editör seçmek için çok fazla [seçeneği](https://en.wikipedia.org/wiki/Editor_war) vardır.

Günümüzde hangi editörler daha popüler? Bunun için 
[StackOverflow](https://insights.stackoverflow.com/survey/2019/#development-environments-and-tools) 
anketini kontrol edebilirsiniz. [Visual Studio Code]
(https://code.visualstudio.com/) en popüler editördür. [Vim]
(https://www.vim.org/) ise komut satırı tabanlı en popüler editördür.

## Vim

Bu sınıftaki bütün eğitmenler editör olarak Vim kullanıyor. 
Vim zengin bir geçmişe sahiptir; Vi (1976) editöründen gelmekte ve bugün 
hala geliştirilmesi devam etmektedir. Vim’in arkasında gerçekten temiz 
fikirler var ve bu yüzden bir çok araç Vim emülasyon modunu desteklemektedir 
(ör. 1,4 milyon insan [Visual Studio Code için Vim emülasyonu]
(https://github.com/VSCodeVim/Vim) kurmuştur. 
Sonunda başka bir metin editörüne geçecek olsanız bile Vim muhtemelen öğrenmeye değecektir.

Vim’in bütün fonksiyonlarını 50 dakika içerisinde öğretmek mümkün değil bu yüzden odaklanıp anlatacağımız konular şunlardır;
-   Vim’in felsefesi,
-   Temel işlevlerin anlatılması,
-   Bir kaç ileri düzey işlevin gösterilmesi,
-   Vim de ustalaşmak için gerekli kaynakların size verilmesi

# Vim’in Felsefesi

Programlama yaparken zamanınızın çoğunu yazmaya değil okumaya / düzenlemeye 
harcarsınız. Bu yüzden Vim farklı modlara sahip bir editördür: metin eklemek 
veya metin işlemek için farklı modlara sahiptir. Vim programlanabilir 
(Vimscript ve Python gibi diğer diller ile) ve Vim’in arayüzünün kendisi 
bir programlama dilidir. Vim, fare kullanımından kaçınır, çünkü çok yavaştır; 
Vim, çok fazla hareket gerektirdiği için ok tuşlarını kullanmaktan bile kaçınır.

Sonuç olarak Vim, düşündüğünüz kadar hızlı olan bir editördür.

# Modal Düzenleme

Vim’in tasarımı, uzun metin akışları yazmak yerine, çok sayıda programcının 
zamanını; okumak, gezinmek ve küçük düzenlemeler yapmak için harcandığı fikrine dayanır. 
Bu nedenle Vim'in birden fazla çalışma modu vardır.
-   **Normal**: dosyanın içerisinde gezinmek ve değişiklikler yapmak için,    
-   **Insert**: metin eklemek için,    
-   **Replace**: metni değiştirmek için,    
-   **Visual (Plain, Line or Block)**: metin bloklarını seçmek için,
-   **Command-line:** bir komut çalıştırmak için

Klayve tuşlarının farklı çalışma modlarında farklı anlamları vardır. 
Örnek olarak, Insert modunda iken `x` harfine basarsak o harfi ekleyecektir 
ama Normal modda iken 'x' harfi imlecin altındaki karakteri siler ve 
Visual modda ise seçili olanı siler.

Varsayılan ayarlarda Vim, o anki çalışma modunu sol altta gösterir. 
Başlangıç modu/varsayılan mod Normal moddur. Genellikle zamanının çoğunu 
Normal mod ve Insert mod arasında geçireceksin. Herhangi bir moddan 
Normal moda geri dönmek için `<ESC>` tuşuna basarak modları değiştirebilirsiniz. 
Normal moddan `i` ile Insert moduna, `R` ile Replace moduna, `v` ile Visual moduna, 
`V` ile Visual Line moduna, `<C-v>` ile Visual Block moduna, `:` ile Command-line 
moduna girebilirsin.

Vim'i kullanırken `<ESC>` tuşunu çok fazla kullanırız. `<ESC>` tuşunu Caps Lock 
tuşuna atamayı düşünebilirsiniz. ([macOS instructions](https://vim.fandom.com/wiki/Map_caps_lock_to_escape_in_macOS)).

# Temel Öğeler

## Metin Ekleme

Normal modda iken Insert moduna girmek için `i` tuşuna basın. Şimdi Vim, 
Normal moda geri dönmek için `<ESC>` tuşuna basana kadar diğer metin editörleri 
gibi çalışır. Bu bilgi ve yukarıda açıklanan temel bilgilerle birlikte, 
Vim’i kullanarak dosyaları düzenlemeye başlamak için ihtiyacınız olan tek şeydir
(eğer bütün zamanınızı Insert Modundan düzenleme için harcıyorsanız çok da verimli değil).

## Bufferlar, sekmeler ve pencereler

Vim, “buffer” adı verilen bir dizi açık dosya tutar. Bir Vim oturumunda, 
her biri birkaç pencere (bölünmüş bölmeler) olan bir dizi sekme bulunur. 
Her pencere tek bir buffer gösterir. Web tarayıcıları gibi bildiğiniz 
diğer programların aksine, buffferlar ve pencereler arasında bire bir 
haberleşme yoktur; pencereler sadece görünümdür. Belirli bir buffer, 
birden fazla pencerede hatta aynı sekmede bile açılabilir. 
Bu özellik oldukça kullanışlı olabilir örneğin bir dosyanın 
iki farklı parçasını aynı anda görüntüleyebilirsiniz.

Varsayılan olarak Vim, tek bir pencere içeren tek bir sekmeyle açılır.

## Command-line

Command moduna Normal modda iken `:` yazarak giriş yapabiliriz. `:` Tuşuna 
bastığınızda bilgisayarınızın imleci ekranın altındaki komut satırına atlayacaktır. 
Bu mod, dosyaları açma, kaydetme, kapatma ve [Vim'den çıkış]
(https://twitter.com/iamdevloper/status/435555976687923200) yapma gibi 
birçok işleve sahiptir.

-   `:q` çıkış (pencereyi kapatır) 
-   `:w` kayıt (“yaz”)    
-   `:wq` kaydet ve çık    
-   `:e {dosyanın adı}` düzenlemek için dosyayı açar    
-   `:ls` açık bufferları gösterir    
-   `:help {konu}` yardımı açar
	-   `:help :w` `:w` komutu için yardımı açar
	- `:help w`  `w` tuşu için yardımı açar
	
# Vim'in arayüzü bir programlama dilidir

Vim’deki en önemli fikir Vim’in arayüzünün kendisinin bir programlama dili olmasıdır. 
Klavyedeki bazı tuşlar (anımsatıcı adlarla) komutlardır ve bu komutlar 
oluşturulabilir. Bu, özellikle komutlar kas hafızasına geçtiğinde dosya 
içerisinde daha verimli gezinmeler ve düzenlemeler yapılmasını sağlar.

## Gezinme

Bufferda gezinmek için hareket komutlarını kullanarak zamanınızı çoğunu 
Normal modda geçirmelisiniz. Vim'deki hareketlere “nouns” da denir, 
çünkü metin parçalarına atıfta bulunurlar.

-   Temel hareket: `hjkl` (sol, aşağı, yukarı, sağ)    
-   Kelimeler: `w` (sonraki kelime), `b` (kelimenin başlangıcı), `e` (kelimenin sonu)    
-   Satırlar: `0` (satırın başı), `^` (boşluk harici ilk karakter), `$` (satırın sonu)    
-   Ekran: `H` (ekranın en üstü), `M` (ekranın ortası), `L` (ekranın en altı)    
-   Kaydırma: `Ctrl-u` (yukarı), `Ctrl-d` (aşağı)    
-   Dosya: `gg` (dosyanın başı), `G` (dosyanın sonu)
-   Satır sayıları: `:{sayı}<CR>` yada `{sayı}G` (satır sayısı)
-   Misc: `%`
-   Bul: `f{karakter}`, `t{karakter}`, `F{karakter}`, `T{karakter}`
    -  üzerinde olduğun satırda bul/ileriye doğru bul/geriye doğru bul {karakter}
    - `,` / `;` eşleşenleri yönlendirmek için
-   Kelime arama: `/{regex}` n ile ileriye doğru arama, N ile geriye doğru arama

## Seçim

Visual Modları:

-   Visual
-   Visual Line    
-   Visual Block
    
Seçim yapmak için yön tuşlarını kullanabilirsiniz.

## Düzenlemeler

Fare ile yaptığınız her şeyi artık hareket komutlarıyla oluşturulan 
düzenleme komutlarını kullanarak klavyeden yapabilirsiniz. İşte Vim’in 
arayüzünün bir programlama dili gibi görünmeye başladığı yer burası. 
Vim’in düzenleme komutlarına “verbs” de denir, çünkü fiiller isimler üzerine etki eder.

- `i` Insert moduna giriş yapar
    - ama değiştirme/silme yapmak için backspace'den farklı bir tuş 
    kullanmak isteyebilirsin
- `o` / `O` aşağı/yukarı satır ekler
- `d{motion}` {motion} siler
    - ör. `dw` kelime siler, `d$` satırın sonuna kadar siler, `d0` satırın 
    başına kadar siler
- `c{motion}` {motion} değiştirir
    - ör. `cw` kelime değiştirir
    - `d{motion}`dan sonra gelen `i` gibi
- `x` karakter siler (`dl` ile aynı)
- `s` hatalı karakter yerine geçen karakter (`xi` ile aynı)
- Visual mod + manipülasyon
    - seçili metini silmek için `d` değiştirmek için `c`
- yapılan işlemi geri almak için `u`, yeniden yapmak için `<C-r>`
- `y` kopyalamak için / "yank" (aynı zamanda `d` gibi bazı diğer komutlarda kopyalar)
- `p` yapıştırmak için
- Daha fazlasını öğrenmek için: ör. `~` karakteri büyültür yada küçültür

## Sayılar

Noun’ları ve Verb’leri, belirli bir eylemi birkaç kez gerçekleştirecek 
bir sayı ile birleştirebilirsiniz.

-   `3w` = 3 kelime ileri    
-   `5j` = 5 satır aşağı    
-   `7dw` = 7 kelime sil

## Değiştiriciler

Bir noun’un anlamını değiştirmek için değiştiricileri kullanabilirsiniz. 
Örnek olarak, i “inside(içinde)” anlamına gelirken a “around(etraf)” anlamına 
gelmektedir.

-   `ci(` mevcut parantez çiftinin içeriğini değiştirme    
-   `ci[` mevcut köşeli parantez çiftinin içeriğini değiştirme    
-   `da’` çevresindeki tek tırnak dahil tek tırnaklı bir stringi silme

# Demo

Çalışmayan bir [fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz) uygulaması:

```python
def fizz_buzz(limit):
    for i in range(limit):
        if i % 3 == 0:
            print('fizz')
        if i % 5 == 0:
            print('fizz')
        if i % 3 and i % 5:
            print(i)

def main():
    fizz_buzz(10)
```

Aşağıdaki sorunları çözerek uygulamayı düzelteceğiz

-   Main çağırılmamış    
-   1 yerine 0 dan başlıyor    
-   15'in katları için ayrı satırlara “fizz” ve “buzz” yazdırıyor    
-   5’in katları için “fizz” yazdırıyor    
-   Kullanıcıdan girdi almak yerine 10’u hard coded olarak kullanıyor

{% comment %}
- main is never called
  - `G` end of file
  - `o` open new line below
  - type in "if __name__ ..." thing
- starts at 0 instead of 1
  - search for `/range`
  - `ww` to move forward 2 words
  - `i` to insert text, "1, "
  - `ea` to insert after limit, "+1"
- newline for "fizzbuzz"
  - `jj$i` to insert text at end of line
  - add ", end=''"
  - `jj.` to repeat for second print
  - `jjo` to open line below if
  - add "else: print()"
- fizz fizz
  - `ci'` to change fizz
- command-line argument
  - `ggO` to open above
  - "import sys"
  - `/10`
  - `ci(` to "int(sys.argv[1])"
{% endcomment %}

Çözümü için ders videosuna bakın. Yukarıdaki değişikliklerin Vim kullanılarak 
nasıl yapıldığını ve başka bir program kullanarak aynı düzenlemeleri nasıl 
yapabileceğinizi karşılaştırın. Vim'de ne kadar az tuşa basmanız gerektiğine 
dikkat edin bu, düzenleme hızınızı arttırır.

# Vim'i Özelleştirme

Vim, `~ / .vimrc` uzantısındaki düz metin yapılandırma dosyası aracılığıyla 
özelleştirilir (Vimscript komutları içeren). Muhtemelen açmak istediğiniz 
birçok temel ayar olacaktır.

Başlangıç olarak kullanabileceğiniz, ihtiyaçlarınızı karşılayacak 
bir temel yapılandırma dosyası sunuyoruz. Bunu kullanmanızı öneririz, 
çünkü Vim'in bazı ilginç varsayılan ayarlarını düzeltir. 
**Yapılandırma dosyamızı [buradan](https://missing-semester-tr.github.io/2020/files/vimrc) indirip `~ / .vimrc` uzantısına kaydedin.**
  
Vim özelleştirilebilir ve özelleştirme seçeneklerini keşfetmek için 
zaman ayırmaya değer. İlham almak için insanların GitHub'daki dotfile 
dosyalarına bakabilirsiniz, örnek olarak, eğitmenlerinizin Vim yapılandırmaları 
([Anish](https://github.com/anishathalye/dotfiles/blob/master/vimrc), [Jon](https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.vim) ([neovim](https://neovim.io/) kullanır), [Jose](https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.vim)). 
Bu konuda çok sayıda iyi blog yazıları var. İnsanların tüm yapılandırmasını 
kopyalayıp yapıştırmamaya çalışın, bunun yerine okuyun, anlayın ve ihtiyacınız 
olanı alın.

# Vim'in Ekstraları

Vim’e ekstra özellikler eklemek için bir çok plugin mevcuttur. 
İnternette karşılaşacağınız eski tavsiyelerin aksine, Vim için bir eklenti 
yöneticisi kullanmanıza gerek yoktur (Vim 8.0'dan beri). Bunun yerine yerleşik 
paket yöneticisi sistemini kullanabilirsiniz. 
Sadece `~/.vim/pack/vendor/start/` dizinini oluşturun ve pluginleri 
buraya koyun (örnek, `git clone`).

Sevdiğimiz bazı pluginler:
- [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim): bozuk dosya bulur
- [ack.vim](https://github.com/mileszs/ack.vim): kod arama
- [nerdtree](https://github.com/scrooloose/nerdtree): dosya gezgini
- [vim-easymotion](https://github.com/easymotion/vim-easymotion): ekstra hareketler

Burada çok uzun bir plugin listesi vermekten kaçınmaya çalışıyoruz. 
Kullandığımız diğer pluginleri görmek için eğitmenlerin dotfile'larına 
([Anish](https://github.com/anishathalye/dotfiles), [Jon](https://github.com/jonhoo/configs), [Jose](https://github.com/JJGO/dotfiles)) göz atabilirsiniz. Daha fazla Vim pluginleri için [Vim Awesome'a](https://vimawesome.com/) göz atın. 
Bu konuda da çok sayıda blog yazısı var: “en iyi Vim pluginleri” şeklinde aratarak 
bulabilirsiniz.

# Diğer Programlarda Vim-modu

Birçok araç Vim emülasyonunu destekliyor. Araca bağlı olarak kalitesi iyiden 
harikaya değişir. Havalı Vim özelliklerini desteklemeyebilir ama çoğu temel 
özellik gayet iyi bir şekilde çalışır.

## Shell

Bir Bash kullanıcısıysanız, `set -o vi` kullanın. 
Zsh kullanıyorsanız, `bindkey -v`. Fish için,`fish_vi_key_bindings`. 
Ayrıca, hangi shelli kullanırsanız kullanın, `export EDITOR=vim` komutu ile 
dışa aktarabilirsiniz. Bu, bir program editörü başlatmak istediğinde 
hangi editörü başlatılacağına karar vermek için kullanılan ortam değişkenidir. 
Örneğin `git`, commit mesajları için bu editörü kullanacaktır.

## Readline

Birçok program, komut satırı arabirimleri için 
[GNUReadline](https://tiswww.case.edu/php/chet/readline/rltop.html) 
kütüphanesini kullanır. Readline (temel) Vim emülasyonu da destekler `~/.inputrc` dosyasına 
aşağıdaki satırı ekleyerek etkinleştirebilirsin.

```
set editing-mode vi
```

Örneğin bu ayar ile Python REPL, Vim bindinglerini destekleyecektir.

## Diğerleri

[Web tarayıcıları](https://vim.fandom.com/wiki/Vim_key_bindings_for_web_browsers) 
için vim keybinding uzantıları bile vardır - bunlardan bazı popüler 
olanlar Google Chrome için [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en) 
ve Firefox için [Tridactyl'dir](https://github.com/tridactyl/tridactyl). 
Vim bindinglerini [Jupyter notebookdan](https://github.com/lambdalisue/jupyter-vim-binding) bile alabilirsiniz.

# Gelişmiş Vim

İşte size editörün gücünü gösteren birkaç örnek. Size bu tür şeylerin 
hepsini öğretemeyiz, ama siz ilerlemeye devam ettikce öğreneceksiniz. 
Ne zaman “bunu yapmanın daha iyi bir yolu olmalı” diye düşünürseniz 
internette araştırın çünkü muhtemelen bulacaksınız.

## Bul ve Değiştir

`:s` (substitute) komutu ([dokümantasyon](http://vim.wikia.com/wiki/Search_and_replace)).

- `%s/foo/bar/g`
    - global olarak dosyadaki “foo”ları “bar” ile değiştirir
- `%s/\[.*\](\(.*\))/\1/g`
    - isimlendirilmiş MarkDown linklerini düz URL’ler ile değiştirir

## Çoklu Pencere

- `:sp` / `:vsp` -   pencereleri bölmek için
- Aynı buffer için birden fazla görünüm olabilir.

## Makrolar

-  `{karakter}` register'ına bir makro kaydı başlatmak için `q{karakter}`
- kaydı durdurmak için `q`
- `@{karakter}` makroyu tekrar çalıştırır 
- Makro hata ile karşılaştığında çalışmayı durdurur
- `{sayı}@{karakter}`  {sayı} kez makroyu çalıştırır
- Makrolar recursive olabilir
	- öncelikle `q{karakter}q` ile makroyu temizle
	- daha sonra makroyu recursive olarak çağırmak için `@{karakter}` ile 
    makroyu kaydedin (kayıt tamamlanana kadar bir işlem yapılmayacak)
- Örnek: xml'den json'a  dönüştürme ([file](/2020/files/example-data.xml)) 
	- “name” / “email” anahtarlarına sahip nesne dizisi
	- Bir Python programı kullanmak?
	- sed / regexes kullanmak
		-   `g/people/d`
        - `%s/<person>/{/g`
        - `%s/<name>\(.*\)<\/name>/"name": "\1",/g`
        - ...
     - Vim komutları / makroları
        - `Gdd`, `ggdd` ilk ve son satırları siler
        - Tek bir elementi formatlamak için makro (register `e`)
            -  `<name>` ile satıra git
            - `qe^r"f>s": "<ESC>f<C"<ESC>q`
        - Bir kişiyi formatlamak için makro
            - `<person>` ile satıra git
            - `qpS{<ESC>j@eA,<ESC>j@ejS},<ESC>q`
        - Bir kişiyi formatlamak ve sonraki kişiye gitmek için makro
            - `<person>` ile satıra git
            - `qq@pjq`
        - Dosyanın sonuna kadar makroyu çalıştırır
            - `999@q`
        - Manuel olarak son `,` kaldırır ve `[`  `]` ayraçlarını ekler

# Kaynaklar

- `vimtutor` Vim kurulu şekilde gelen bir tutorial - Eğer Vim 
kuruluysa `vimtutor` 'u shell'inizden çalıştırabilirsiniz
- [Vim Adventures](https://vim-adventures.com/) Vim öğrenmek için oyun
- [Vim Tips Wiki](http://vim.wikia.com/wiki/Vim_Tips_Wiki)
- [Vim Advent Calendar](https://vimways.org/2019/) Çeşitli Vim taktikleri
- [Vim Golf](http://www.vimgolf.com/) programlama dilinin Vim'in arayüzü 
olduğu bir [code golf'dur](https://en.wikipedia.org/wiki/Code_golf)
- [Vi/Vim Stack Exchange](https://vi.stackexchange.com/)
- [Vim Screencasts](http://vimcasts.org/)
- [Practical Vim](https://pragprog.com/book/dnvim2/practical-vim-second-edition) (kitap)

# Egzersizler

1. `vimtutor`'u tamamla. Not: en iyi [80x24](https://en.wikipedia.org/wiki/VT100)  
terminalde gözükür. (24 satıra 80 sütun)
1. Bizim [basic vimrc'mizi](/2020/files/vimrc) indir 
ve `~/.vimrc` uzantısına kaydet. İyi dokümente edilmiş dosyayı okuyun (Vim kullanarak!) 
ve Vim'in yeni ayarlar ile nasıl farklı göründüğünü, farklı davrandığını gözlemleyin.
1. Bir plugin kurma ve yapılandırma:
   [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim).
   1. `mkdir -p ~/.vim/pack/vendor/start` komutu ile plugin dizini oluşturun 
   1. Plugin indirin: `cd ~/.vim/pack/vendor/start; git clone https://github.com/ctrlpvim/ctrlp.vim`
   1. Plugin için [dokümantasyonu](https://github.com/ctrlpvim/ctrlp.vim/blob/master/readme.md) okuyun. 
   Bir proje dizininde dosya bulmak, Vim’i açmak ve Vim komut satırını kullanarak 
   CtrlP’yi başlatmak (`:CtrlP`) için CtrlP’yi kullanmayı deneyin.
    1. [konfigürasyon'u](https://github.com/ctrlpvim/ctrlp.vim/blob/master/readme.md#basic-options) 
    `~/.vimrc`'nize ekleyerek CtrlP'yi özelleştirin. 
    CtrlP'yi açmak için Ctrl-P ye basın.
1. Vim'de pratik yapmak için derste gösterdiğimiz [Demo'yu](#demo) kendi 
bilgisayarınızda tekrar yapın.
1. Önümüzdeki bir ay _bütün_ metin düzenleme işleri için Vim'i kullanın. 
Bir şey verimsiz göründüğünde veya "daha iyi bir yol olmalı" diye düşündüğünüzde 
Google'da aratmayı deneyin, muhtemelen vardır. 
Eğer takıldığınız yer olursa ofis saatleri içerisinde yanımıza uğrayın yada bize mail gönderin.
1. Vim bindinglerini kullanmak için diğer araçlarını konfigüre et (yukarıdaki talimatlara bakın).
1. `~/.vimrc`'nizi daha da özelleştirin ve daha fazla plugin yükleyin.
1. (İleri düzey) Vim makrolarını kullanarak XML'den JSON'a dönüştürün ([örnek dosya](/2020/files/example-data.xml)). 
Kendi başına yapmayı dene, eğer takılırsan yukarıdaki [makrolar](#makrolar) bölümüne bakabilirsin.


