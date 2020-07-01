---
layout: lecture
title: "Potpourri"
date: 2019-01-29
ready: true
video:
  aspect: 56.25
  id: JZDt-PRq0uo
---

## İçindekiler

- [Tuş Kombinasyonlarını Ayarlama](#keyboard-remapping)
- [Arka Planda Çalışan Servisler (Daemons)](#daemons)
- [FUSE](#fuse)
- [Yedekleme](#backups)
- [Uygulama Programlama Ara Yüzleri (API)](#apis)
- [Komut Satırı İpuçları](#common-command-line-flagspatterns)
- [Pencere Yöneticileri](#window-managers)
- [Sanal Özel Ağalar (VPN)](#vpns)
- [Markdown](#markdown)
- [Hammerspoon(macOS masaüstü otomasyonu)](#hammerspoon-desktop-automation-on-macos)
- [Başlatma ve Canlı USB'ler](#booting--live-usbs)
- [Docker, Vagrant, Sanal Makinalar, Bulut, OpenStack](#docker-vagrant-vms-cloud-openstack)
- [Not Defterleri Programlama Ortamları](#notebook-programming)
- [GitHub](#github)

## Tuş Kombinasyonlarını Ayarlama

Programcı olarak bilgisayar ile ana iletişim yönteminizi klavyenizdir. Bilgisayarınızdaki diğer bileşenlerin hemen hepsi gibi klavyenizi de konfigüre edebilirsiniz (emin olun bu çabaya değecektir).

Klavyeniz için yapabileceğiniz en basit konfigürasyon tuş kombinasyonlarınızı yeniden ayarlamaktır. Bu ayarlama genelde tuşlara basıldığında oluşan olayı yakalayan, bu olayı tanıyan ve ardından yaptığınız konfigürasyona göre başka bir olayı tetikleyen programlar kullanılarak yapılır. Klavye tuşlarını ayarlamaya birkaç örnek olarak şunları verebiliriz:

- Caps Lock tuşunu Ctrl veya Escape ile eşleştirmek. Dersin hocaları olark bu konfigürasyonu yapmanızı öneriyoruz. Çünkü, Caps Lock tuşu klavyedeki konumu itibariyle oldukça kullanışlı bir pozisyonda yer alıyor ancak program yazarken nadiren kullanılıyor.
- PrtSc tuşunu müzik çalar programını başlatıp durdurmak için ayarlamak. Çoğu işletim sisteminde müzik çalar programlar tarafından kullanılabilecek fiziksel tuşlar da yer alır.
- Ctrl ve Meta (Windows veya Command (macOS) tuşu) tuşlarının yerlerini değiştirmek.

3.parti programlar kullanarak kendi belirleyeceğiniz tuş kombinasyonları ile genel geçer bazı işlemlerin yapılmasını sağlayabilirsiniz. Bu tür bir ayarlamada ilgili program sürekli bir şekilde tuş kombinasyonlarınızı takip eder ve konfigüre ettiğiniz tuş kombinasyonunu yakaladığında, genelde bir script tanımlayarak, ayarladığınız işlemi tetiklemektedir. Bu şekilde yapabileceğiniz işlemlere birkaç örnek olarak şunlar verilebilir:

- Yeni bir terminal veya tarayıcı penceresi açmak
- Uzun bir e-posta adresi veya öğrenci numarası gibi uzun bir metni yapıştırmak
- Bilgisayarı veya monitörlerinizi uyku moduna almak
- Oturumunuzu kapatmak veya sonlandırmak

Bu yöntemi kullanarak örneğin aşağıdaki daha karmaşık senaryoları da gerçekleştirebilirsiniz:
- Beş defa arka arkaya Shift tuşuna basıldığında Caps Lock'u aktif hale getirmek.
- Dokunma veya uzun süreli basma gibi durumlarda farklı işlemler yapmak. Örneğin Caps Lock tuşuna dokunulduğunda Esc tuşu ile eşleştirmek, uzun süre basıldığında ise Ctrl tuşu ile eşleştirmek gibi.
- Eşleştirme konfigürasyonunu kullandığınız programa veya klavyeye özel hale getirmek.

Bu işlemleri yapmak için kullanabileceğiniz bazı araçların bilgilerine aşağıdaki linklerden erişebilirsiniz:
- macOS - [karabiner-elements](https://pqrs.org/osx/karabiner/), [skhd](https://github.com/koekeishiya/skhd) veya [BetterTouchTool](https://folivora.ai/)
- Linux - [xmodmap](https://wiki.archlinux.org/index.php/Xmodmap) veya [Autokey](https://github.com/autokey/autokey)
- Windows - Windows'un kendi kontrol paneli, [AutoHotkey](https://www.autohotkey.com/) veya [SharpKeys](https://www.randyrants.com/category/sharpkeys/)
- QMK - Klavyeniz özelleştirilmiş firmware kullanımını destekliyorsa [QMK](https://docs.qmk.fm/) kullanarak klavyenizi donanım seviyesinde konfigüre edebilirsiniz.

## Arka Planda Çalışan Servisler (Daemons)

Büyük ihtimalle arka planda çalışan program konseptine aşinasınızdır, ancak `daemon` terimi size yabancı gelebilir. Çoğu bilgisayarda kullanıcının başlatmadığı ve kullanıcı ile etkileşimde bulunmayan ancak arka planda çalışan programlar vardır. Bu programlar bilgisayar çalışmaya başlar başlamaz otomatik olarak çalışırlar ve arka planda bazı işlemler yaparlar. Çoğu UNIX benzeri işletim sisteminde bu programların isimleri `d` ile biter. Örneğin `sshd`, SSH servisidir ve SSH isteklerini dinleyip SSH ile bilgisayara bağlanmaya çalışan kullanıcının gerekli yetkilere sahip olup olmadığını kontrol eder.

Linux'daki `systemd` servisi (system daemon) arka planda çalışan kullanıcı servislerini yönetmek için kullanılan en yaygın çözümdür. `systemctl status` komutunu çalıştırarak tanımlı servislerin listesini görüntüleyebilirsiniz. Listede göreceğiniz servislerin bir çoğu size yabancı gelebilir, ancak bu servisler ağ yönetimi, DNS sorgularını çözümleme veya kullanıcı ara yüzünü yönetmek gibi önemli işlemlerin arka planda gerçekleşmesini sağlarlar. `systemd` servisi ile `systemctl` komutunu kullanarak etkileşime geçebilirsiniz. `systemctl` komutu ile servisleri aktif hale getirebilir (`enable`), pasif hale getirebilir (`disable`), başlatabilir (`start`), sonlandırabilir (`stop`), yeniden başlatabilirsiniz (`restart`) veya servislerin durumunu (`status`)kontrol edebilirsiniz.

Daha da ilginci, `systemd` servisleri yönetmek için oldukça kullanışlı bir ara yüz sunar. Aşağıda, basit bir Pyhthon programını servis olarak arka planda çalıştırmak için oluşturulan bir servis tanımı yer almaktadır. Servis tanımındaki alanların ayrıntılarına girmeyeceği, ancak bu alanların çoğunun adının yeterince açıklayıcı olduğunu söyleyebiliriz.


>**Çevirmenin Notu:** Ders notlarında computers (bilgisayar) şeklinde bir kullanım olmasına rağmen aslında kastedilen işletim sistemleridir.

>**Çevirmenin Notu:** Dersin bu bölümünde UNIX benzeri işletim sistemlerinde arka plan servisleri ile ilgili bilgiler verilmiş. Ancak, benzer servis tanımlamalarını Windows ve diğer işletim sistemlerinde de yapmak mümkündür.

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Custom App
After=network.target

[Service]
User=foo
Group=foo
WorkingDirectory=/home/foo/projects/mydaemon
ExecStart=/usr/bin/local/python3.7 app.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Ayrıca, arka planda belirli frekanslarda çalışmasını istediğiniz servisleri tanımlamak için [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html) aracını kullanabilirsiniz. `cron` aracı UNIX benzeri işletim sistemlerinde kurulu olarak gelir ve yaptığınız konfigürasyona göre ilgili programları zamanı geldiğinde çalıştırı.

>**Çevirmenin Notu:** Windows işletim sisteminde `cron` benzeri imkanlar sunan `Windows Task Scheduler` servisini kullanabilirsiniz.

## FUSE

Modern sistemler genelde daha küçük alt sistemlerden meydana gelir. İşletim sisteminiz rahatlıkla farklı dosya sistemlerini (file system) destekleyebilir, çünkü dosya sistemlerinin yapabilecekleri işlemleri ifade eden ortak bir dil vardır. Örneğin, `touch` komutunu çalıştırdığınızda işletim sistemi bir işletim sistemi çağrısı yapar ve işletim sisteminin kernel'i kullanılan dosya sistemine özel komut ile yeni bir dosya oluşturulmasını sağlar. UNIX benzeri işletim sistemlerinde dosya sistemi geleneksel olarak bir `kernel module` olarak geliştirilir ve bu modüle sadece işletim sisteminin kerneli erişebilir.

>**Çevirmenin Notu:** kernel (çekirdek) kavramı tüm işletim sistemlerinde öyle veya böyle yer alan bir kavramdır. kernel, işletim sisteminin donanıma en yakın mantıkasal katmanını temsil eder ve alt seviye işletim sistemi işlemleri bu katmanda çalışan programcıklar tarafından yerine getirilir. Bu programcıklar `kernel mode` denilen özel bir modda çalışır ve güvenlik erişim seviyeleri itibariyle oldukça sıkı denetim altındadırlar.  Bizim yazdığımız programlar ise `user mode` adı verilen bir modda çalışır (`user space` adı verilen bir çerçevede çalışan programlar) ve doğrudan kernel ile etkileşimde bulunmalarına işletim sistemi tarafından izin verilmez.


[FUSE](https://en.wikipedia.org/wiki/Filesystem_in_Userspace) (Filesystem in User Space) ile UNIX benzeri işletim sistemlerinde dosya sistemlerini `user space` adı verilen bir çerçevede çalışan programlar olarak geliştirebiliriz. `FUSE` teknolojisi sayesinde geliştirdiğimiz dosya sistemi programı dosya sistemi çağırılarını yakalar ve bunları işletim sistemi kernel'inde ilgili ara yüzlere köprüler. Bu teknoloji ile pratikte dosya sistemi çağırıları yakalanarak çok farklı işlemler yapılabilir.

Örneğin, FUSE ile sanal bir dosya sistemi kurgulayarak dosya sistemi çağırılarının SSH ile uzak sunuculara yönlendirilerek dosya işlemlerinin uzak sunucu üzerinden gerçekleştirilmesini sağlayabilirsiniz. Bu sayede kendi bilgisayarınızdaki programlar uzak sunucudaki dosyalar üzerinde sanki yerel dosyalarmış gibi işlem yapabilirler. Bu yöntem `sshfs` aracının uyguladığı yöntemdir.

FUSE dosya sistemleri için bazı ilginç örnekler şunlardır:
- [sshfs](https://github.com/libfuse/sshfs) - SSH üzerinden uzak sunucudaki dosyalara yerel dosyalarmış gibi erişim sağlar.
- [rclone](https://rclone.org/commands/rclone_mount/) - Dropbox, Google Drive, Amazon S3, Google Cloud Storage gibi depolama servislerini yerel disk olarak tanımlanıp kullanılmasını sağlar.
- [gocryptfs](https://nuetzlich.net/gocryptfs/) - Şifreleme çözümü sunar. Dosyalar şifrelenmiş olarak kayıt altına alınır, ancak dosya sistemi etkin hale getirildiğinde dosyalara açık bir şekilde erişimi mümkün kılar.
- [kbfs](https://keybase.io/docs/kbfs) - Uçtan uca şifreleme desteği olan dağıtık dosya sistemidir. Bu dosya sistemini kullanarak özel, paylaşılmış veya açık klasörler oluşturabilirsiniz.
- [borgbackup](https://borgbackup.readthedocs.io/en/stable/usage/mount.html) - Şifrelenmiş ve sıkıştırılmış yedekleme dosyalarınızı kolayca disk olarak tanımlamanızı ve kullanmanızı sağlar.

## Yedekleme

Verilerinizi yedeklemediğiniz durumda bu verileri herhangi bir anda sonsuza dek kaybedebilirsiniz. Dosyaları sağa sola kopyalamak kolay bir işlemdir, ancak güvenilir yedekler oluşturmak oldukça zordur. Aşağıda bazı basit yedekleme yöntemlerine ve bu yöntemlerden bazılarında karşılaşılan sorunlara değindik.

Öncelikle, aynı disk üzerine alınan bir yedek gerçek anlamda yedek değildir. Çünkü, diskiniz verileriniz için tek sorun noktasıdır (single point of failure). Benzer şekilde, evde sakladığınız harici diskiniz de yedekleme için iyi bir seçenek değildir, çünkü harici diskiniz çalınabilir veya doğal afet ve yangın gibi olaylarda hasar görebilir. Bu yöntemler yerine, kendi bilgisayarınız veya eviniz dışındaki bir yerde yedeklerin tutulması daha güvenli bir yöntemdir.

Veri senkronizasyon çözümleri yedekleme çözümü değildir. Örneğin, Dropbox ve Google Drive gibi çözümler kullanımı kolay çözümlerdir. Ancak, bu servislerdeki verileri sildiğinizde veya veriler bozulduğunda bu değişiklikler veri kaynaklarına da otomatik yansıyacaktır. Benzer şekilde RAID gibi veri tutarlılığı ve sürekliliği sağlayan çözümler de uygun çözümler değildir, çünkü bu yöntemler de silme veya bozulma gibi durumlara engel olamaz.

>**Çevirmenin Notu:** RAID, Redundant Array Of Inexpensive Disks kısaltmasıdır ve bir depolama sanallaştırma yöntemidir. Bu yöntemde birden fazla disk bir özel donanımlar ile birbiri ile dizi olarak ilişkilendirilir. RAID seviyesine göre bir diskteki veri blokları dizi içindeki bir veya daha fazla dike de kopyalanır. RAID'e dahil disklerden herhangi birinde arıza olması durumunda bozulan diskteki veri dizideki diğer disklerdeki kopyasından geri dönüştürülür. Ancak, RAID yöntemi veri kaybında kesin bir çözüm sunmaz. RAID seviyesine göre bir anda en çok kaç diskteki arızanın tölere edileceği hesaplanır. Bulut tabanlı veri merkezlerinde RAID ve benzeri teknolojiler kullanılarak donanım arızaları durumunda veri kaybı önlenir.

İyi yedekleme yöntemleri versiyonlama, veri tekilleştirme ve güvenlik gibi özelliklere sahip olmalıdır. Versiyonlama yedeklerinizin tarihçesi kolay bir şekilde yönetmenizi ve zamanda istediğiniz ana geri dönmenizi sağlar. Veri tekilleştirme, yedekleme sırasında sadece iki yedekleme anı arasındaki değişiklikleri yedeklenmesini sağlayan bir yöntemdir. Yedeklerinizi kimin okuyabileceği, kimin yedeklerinizde yer alan dosyaları silebileceği veya yedeklerin kendisini yönetebileceğini denetlemek gerekli bir güvenlik özelliğidir. Son olarak, gözü kör bir şekilde yedeklerinize güvenmemelisiniz. Bu nedenle, zaman zaman yedeklerinizi açarak içeriklerinin sağlıklı ve erişilebilir durumda olduğunu da kontrol etmelisiniz.


Yedekleme ihtiyacı sadece kendi bilgisayarınızdaki dosyalar ile sınırlı değildir. Web uygulamalarının gelişimine baktığımızda sizinle ilgili önemli miktarda veri bulut servislerinde kayıt altında tutulmaktadır. Örneğin, e-postalarınız, fotoğraflarınız ve çalma listeleriniz gibi veriler bir hesap ile erişebildiğiniz servislerde kayıt altında tutulmaktadır. Bu servislere erişmek için kullandığınız hesaba erişiminizi kaybettiğinizde bu servislerde yer alan verilerinize de erişimi kaybetmiş olursunuz. Bu tür durumlar ile karşılaşmamak için çevrimiçi servislerde yer alan verilerinizi de çevrimdışı olarak yedeklemeniz gerekmektedir. İnternet'de arama yaparak insanların geliştirdiği bir çok çevrimdışı yedekleme çözümünü bulabilirsiniz. Bu konuda daha fazla ayrıntı için 2019 yılı ders notlarındaki [Backups](/2019/backups) kısmına göz atabilirsiniz.


## Uygulama Programlama Ara Yüzleri (API)

Dersimizde kendi bilgisayarınızdaki işlevleri daha etkin bir şekilde
yerine getirmek için neler yapabileceğinizden bahsettik. Ancak, derste
ele aldığımız çoğu konu çevrimiçi bağlamda da işe yarayacaktır. Çoğu çevrimiçi
servis Uygulama Programlama Ara Yüzleri (Application Programmin Interface) üzerinden
çevrimiçi veri ve hizmetlere erişim imkanı sunar. Örneğin, ABD hükümeti hava durumunu
sorgulayabileceğiniz bir API sunar. Bu API ile komut satırınızda hızlıca bulunduğunuz
konumun hava durumunu gösterebilirsiniz.


Bu API'lerin çoğu benzer formattadır. Bu API'lere, genelde `api.service.com`
şeklinde, yapısal bir kök URL kullanarak erişebilirsiniz. Kök adresin sonunda
kullanmak istediğiniz servisin adını (path) ve sorgulama kriterlerinizi (query string)
ekleyerek işlem yapabilirsiniz. Örneğin, ABD hükümetinin hava durumu API'sinden sorgulama
yapmak için `https://api.weather.gov/points/39.063357,26.879370` URL değeri ile GET sorgusu
yapabilirsiniz (sorgulama yapmak için `curl` aracını kullanabilirsiniz). API'den gelen
cevap verisinde o çevredeki diğer konumların hava durumunu sorgulamanızı sağlayabilecek
linkler yer alacaktır. API'ler genelde JSON adı verilen bir formatta veri döndürür.
JSON veriyi incelemek için [`jq`](https://stedolan.github.io/jq/) benzeri araçları kullanabilirsiniz.

>**Çevirmenin Notu:** URL, Uniform Resource Locator teriminin kısaltmasıdır.
Çevrimiçi veya yerel kaynakların adreslenmesi ve kolay erişimi için kullanılan
bir formattır.

>**Çevirmenin Notu:** JSON, JavaScript Object Notation teriminin kısaltmasıdır. JSON
bir veri transfer formatıdır ve standart bir şemaya ihtiyaç duymadan JavaScript nesnelerinin
metin olarak transfer edilmesini sağlar. JSON formatı aynı zamanda insanların gözle rahatlıkla
okuyup anlamlandırabilecekleri bir yapıdadır.

Bazı API'lere erişim için doğrulama gerekir. Bu durumda genelde _token_ adı verilen ön tanımlı bir
değeri isteklerinize iliştirmeniz ve API'nin bu _token_'ı doğrulayarak sizi tanıması gerekir.
Doğrulama gereksinimleri her API için farklı olabilir, bu nedenle kullanacağınız API'nin dokümanlarını
dikkatlice okumalısınız. Bu dokümanlarda genelde doğrulama için "[OAuth](https://www.oauth.com/)" isimli bir
protokolden bahsedildiğini göreceksiniz. OAuth, temelde API erişimi sırasında sizi temsil eden bir _token_ değerinin
üretilmesini ve bu _token_'ın sizi temsilen programlarınız tarafından kullanılmasını sağlar. Bu _token_'ların sizi temsil
eden kritik büyüklükler olduğunu unutmamalısınız. Bu nedele, _tokan_'larınızı ele geçiren herhangi birisi sizin yerinize
ilgili API'lerden işlem yapabilir ve size özel verilere erişebilir.


[IFTTT](https://ifttt.com/) API'ler etrafında kurgulanmış bir servistir. IEFTT kullanarak çevrimiçi bir çok API'yi ardı ardına
bir birini çağıracak şekilde organize ederek işlemler yapabilirsiniz. IEFTT servisine göz atmanızı öneririz.

>**Çevirmenin Notu:** IEFTT kullanarak, örneğin Gmail hesabınızdaki maillerde eklenti olarak gelen resim ve fotoğrafları otomatik olarak Dropbox veya farklı bir servise gönderme işlemini kod yazmadan kolayca yapabilirsiniz. Farklı bir örnek olarak, yine Gmail hesabınıza gelen mailleri izleyerek belirli kişilerden mail gelmesi durumunda Philips HUE lambalarınızın renklerini bilgilendirme amaçlı değiştirebilirsiniz.



## Komut Satırı İpuçları

Komut satırı araçları birbirinden farklı kullanım seçeneklerine sahiptir. Bu nedenle
herhangi bir komut satırı aracını kullanmadan önce aracın `man` el kitabı sayfalarını
incelemelisiniz. Bu araçlar birbirinden farklı seçenklere sahip olsa da bilmeniz gereken
ortak bazı özelliklere de sahiptir:

 - Çoğu araç `--help` flag'ini destekler. Araç bu flag ile çağırıldığında
 kullanıma ilişkin açıklayıcı bilgileri gösterir.
 - Geri döndürmesi mümkün olmayan değişiklikler yapan araçların çoğu `dry run`
 adı verilen bir çalışma modunu destekler. `dry run`  moduna bu araçlar sadece
 yapacakları işlemi gerçekten yapsalar hangi işlemleri yapacaklarını gösterirler.
 Benzer şekilde bu araçların etkileşimli modu da vardır. Bu modda çalıştırdığınızda
 araçlar gerçekleştirecekleri kritik işlemler için onay alma veya ihtiyaç duydukları
 parametre değerlerini girmenizi bekleme gibi işlemleri yaparlar.
 - Aracın versiyonunu görmek için `--version` veya `-V` flag'lerini kullanabilirsiniz. Özellikle hata
 bildirimi yapacaksanız bu bilgi aracı geliştirenlere yardımcı olacaktır.
 - Komut satırı araçlarının çoğu `--verbose` veya `-v` flag'ini destekler. Bu flag'in kullanıldığı
 durumda araç normalde olduğundan daha fazla bilgiyi gösterir. Daha da fazla bilgi görüntülenmesi için
 `-vvv` şeklinde kullanım da destekleniyor olabilir. Bu bilgiler hata ayıklama gibi durumlarda
 size yardımcı olacaktır. Benzer şekilde çoğu araç `--quiet` flag'ini destekler ve bu durumda sadece
 hata mesajlarını gösterirler.
 - Çoğu araç dosya adı parametresi olarak `-` karakterini destekler. Gerçek dosya adı yerine `-` kullanıldığında
 yapılan işleme göre "standard input"'dan okuma veya "standard output"'a yazmayı destekler.
 - Veri silme veya geri dönülmez bir şekilde veriyi değiştirme işlemi yapan araçların çoğu varsayılan
 olarak öz yinelemeli (recursive) çalışmazlar. Öz yinelemeli çalışma için bu araçların `-r` flag'ini
 destekleyip desteklemediğini kontrol edebilirsiniz.
 - Bazen normal bir parametrenin değerini bir flag gibi ilgili araca geçmek isteyebilirsiniz.
 Örneğin `-r` isimli bir dosyayı kullanmak istediğinizi düşünelim, veya SSH kullanarak bir programı
 uzak bir sunucuda `ssh machine foo` komutu ile çalıştırmak istediğinizi düşünelim. `--` özel argümanı
 bu araçların flag'leri işleme almasını engeller ve `-` ile başlayan değerler normal parametre olarak
 işlenir. Örneğin, `rm -- -r` komutu -r isimli dosyayı siler veya `ssh machine --for-ssh -- foo --for-foo` komutu
 `for-ssh` ve `for-foo` değerlerini parametre değeri olarak yorumlar.


## Pencere Yöneticileri

Çoğunuz Windows, macOS ve Ubuntu'dan sürükle/bırak tarzındaki pencere yöneticilerine aşinasınızdır. Bu tür pencere yöneticileri ekranda birbirinden ayrı olarak konumlandırılabilen, boyutu değiştirilebilen, sürüklenebilen ve bir birinin üstüne konumlandırılabilen pencereleri yönetirler. Ancak, bunlar pencere yöneticileri arasındaki türlerden sadece bir tanesidir ve bu tür pencere yöneticilerine `floating` pencere yöneticileri denir. Bu türün dışında, özellikle Linux için, çok farklı türde pencere yöneticileri de vardır. `floating` pencere yöneticilerine en yaygın alternatiflerden birisi de `tiling` pencere yöneticileridir. `tiling` pencere yöneticileri kullanıldığına pencereler hiç bir zaman bir biri ile çakışmaz ve pencereler ekranınızda alt alta veya yan yana kendilerine ait alanları kullanacak şekilde (tmux'daki bölmeler gibi) organize edilirler. `tiling` pencere yöneticileri kullanıldığında ekranda açık olan tüm uygulamalar aynı anda belirli bir dizilime göre yan yana ve/veya alt alta gösterilirler. Tek bir aktif pencereniz varsa bu pencere tüm ekranı kaplar. İkinci bir pencere açtığınızda ise ilk pencerenin boyutları yeni pencereye ekranda alan sağlamak için otomatik olarak küçülür (genelde 2/3 veya 1/3 oranında boyutları küçülür). Üçüncü bir pencere açarsanız ilk iki pencere bu pencereye alan sağlamak için otomatik olarak küçülür. `tmux` bölmelerinde olduğu gibi pencereler arasında da kısayol tuşlarını kullanarak gezinebilir, pencerelerin boyutlarını isteğinize göre değiştirebilirsiniz. `tiling` pencere yöneticileri göz atmaya değer bir araçlardır.


## Özel Sanal Ağlar (VPN)

Özel sanal ağlar (VPN) bu günlerde oldukça fazla rağbet görüyor ve kullanılıyorlar. Bu durumun her zaman [iyi amaçlar](https://gist.github.com/joepie91/5a9909939e6ce7d09e29) için olup olmadığı ise henüz net değil. VPN'in size sağladığı imkanları ve ortaya çıkaracağı riskleri bilmeniz faydalı olacaktır. En pozitif hali ile VPN, internet hizmet sağlayıcınızı (ISP) değiştirme yöntemidir. Bu durumda bilgisayarınızdan internete çıkan tüm trafik gerçek konumunuz yerine VPN sağlayıcısı üzerinden şifreli bir şekilde çıkacak ve internetin geri kalanı sizin konumunuzun VPN sağlayıcısının konumu ile aynı olduğunu düşünecektir.

Bu durum çekici görünmesine rağmen gerçekte yaptığınız şey aslında güven anlamında gerçek internet hizmet sağlayıcınıza değil VPN sağlayıcınıza güvendiğiniz anlamına gelir. Normalde internet sağlayıcınızın izleyebileceği internet trafiğiniz artık VPN sağlayıcınız tarafından izlenir hale gelir. VPN sağlayıcınıza internet hizmet sağlayıcınızdan daha fazla güveniyorsanız bu güven sizin lehinizedir aksi durumda bu ilişkiden elde edeceğiniz fayda kuşkuludur. Havaalanında uçağınızı beklerken açık Wi-Fi ağına güvenmeyip VPN hizmetini kullanmayı tercih etmeniz şüphesiz anlamlıdır. Ancak, kendi evinizde kendi Wi-Fi ağınızı kullanıyorsanız VPN sağlayıcısı tercih etmenizin eksi ve artıları o kadar net olmayabilir.  

Son dönemde internet trafiğinizin neredeyse tamamı (en azından hassas içerikli trafiğiniz) HTTPS veya TLS gibi teknolojiler ile zaten şifreleniyor. Bu durumda, sakıncalı bir ağada olup olmadığınızın pek de önemi yoktur çünkü internet hizmet sağlayıcınız sadece iletişimde bulunduğunuz sunucular hakkında bilgi edinebilir, bu sunucular ile alış/verişini yaptığınız veriye dair herhangi bir bilgiye sahip olamaz.

VPN sağlayıcılarının yazılımlarını yanlış konfigüre ederek zayıf şifreleme yöntemleri kullanmaları veya hiç şifreleme kullanmamaları duyulmamış bir durum değildir. Bazı VPN sağlayıcıları kötü niyetli bir şekilde (veya fırsatçılık yaparak) onların üzerinden gönderdiğiniz tüm trafiği kayıt altına alarak 3. parti şirketlere bu bilgileri satarlar. Kötü bir VPN sağlayıcısının hizmetini kullanmak hiç bir VPN hizmeti kullanmamaktan daha kötüdür.

MIT, kendi öğrencileri için [VPN hizmeti](https://ist.mit.edu/vpn) sunar. Eğer kendi VPN hizmetinizi kullanmak isterseniz [WireGuard](https://www.wireguard.com/)'a göz atabilirsiniz.

## Markdown

Kariyeriniz boyunca büyük ihtimalle farklı amaçlar için doküman üretmeniz gerekecektir. Genelde de bu dokümanları basit yöntemler ile formatlamak isteyeceksiniz. Dokümanlarınızda bazı metinlerin koyu veya eğik olarak biçimlendirilmesi, linklerin eklenmesi veya formatlı kod parçaları oluşturulması gerekecek. Tüm bu işlemler için Word veya LaTeX gibi ağır siklet programlar kullanmak yerine daha hafif bir biçimlendirme dili olarak [Markdown](https://commonmark.org/help/) kullanmayı düşünebilirsiniz.

Büyük ihtimalle şu ana kadar Markdown'un kendisini veya , adı Markdown olmasa bile, bir çeşidini görmüşsünüzdür. Markdown'un kendisi veya alt kümeleri neredeyse tüm araçlar tarafından destekleniyor. Temelinde Markdown, insanların saf metin oluştururken kullandıkları formatlama yöntemlerini kodlamak için oluşturulmuş bir formattır. Bir kelimeye vurgu yapmak (*eğik*) için bu kelimenin önüne ve ardına `*` karakteri eklenir. Koyu font (**koyu**) ile bir kelimeyi vurgulamak için kelimenin önüne ve arkasına `**` karakterleri eklenir.`#` ile başlayan satırlar başlıklardır ve `#` sayısı arttırılarak alt başlıklar oluşturulur. `-` ile başlayan bir satır numarasız listede bir madde, sayı ve `.` ile başlayan satırlar da numaralı listede bir maddedir. Ters tek tırnak ile çevrelenmiş kelimeler kaynak kodu biçiminde formatlanır, kod satırları da dört adet boşluk karakteri veya üç ters tırnak kullanılarak oluşturulur:

    ```
    kaynak kodu satırları ters üç tırnak ile başlayıp 
    biten bloğun arasına yazılır
    ```

Link eklemek için linkin metninin köşeli parantez çifti ile çevreleyip hemen ardından da linkin kendisi normal parantez çifti ile çevreleyebiliriz: `[name](url)`. Markdown hızlıca kullanmaya başlayıp her yerde kullanabileceğiniz bir formatlama dilidir. Aslında, bu dersin ve diğer derslerin notları da Markdown kullanılarak yazılmıştır. Ders notlarını saf Markdown hallerini [şu linkten](https://raw.githubusercontent.com/missing-semester-tr/missing-semester-tr.github.io/master/_2020/potpourri.md) inveleyebilirsiniz.


## Hammerspoon (masaüstü macOS otomasyonu)

[Hammerspoon](https://www.hammerspoon.org/) macOS için kullanılabilen bir masaüstü otomasyon programıdır. Hammerspoon, Lua scriptleri ile işletim sisteminin bileşenlerine erişmenizi ve bu sayede  klavye, fare, pencereler, monitörler, dosya sistemi ve diğer bir çok sistem elemanı ile etkileşimde bulunmanıza imkan sağlar.

Hammerspoon ile aşağıdakine benzer işlemleri yapabilirsiniz:

- Pencereleri belirli pozisyona taşımak için tuş eşleştirmeleri oluşturabilirsiniz.
- Menü çubuğuna bir buton ekleyerek bu butona basıldığında pencereleri belirli bir düzene göre dizilmesini sağlayabilirsiniz.
- Labaratuvara vardığınızı Wi-Fi ağını tespit ederek hoparlörlerinizi otomatik olarak kapatabilrsiniz.
- Yanlışlıkla arkadaşınızı şarj kablosunu alırsanız ekranda uyarı gösterilmesini sağlayabilirsiniz.


Hammerspoon, menü butonları, basılan tuşlar veya işletim sistemi olayları ile ilişkilendirilmiş Lua kodunuzun çalıştırılmasını sağlayan bir araçtır. Hammerspoon işletim sistemi ile etkileşime geçmenizi sağlayan çok kapsamlı bir kütüphane sunar ve Hammerspoon ile yapabileceklerinizin sınırı neredeyse yoktur. Çoğu insan kendi Hammerspoon konfigürasyonlarını açık olarak yayınlamaktadır. Bu nedenle, arama yaparak ihtiyacınız olan işlemin konfigürasyonunu kolayca bulabilirsiniz. Tabii ki Hammerspoon ile yerine getirmek istediğiniz işlevi her zaman kendi başınızda sıfırdan yapmayı da tercih edebilirsiniz.


### Kaynaklar

- [Hammerspoon'a Giriş](https://www.hammerspoon.org/go/)
- [Basit Konfigürasyonlar](https://github.com/Hammerspoon/hammerspoon/wiki/Sample-Configurations)
- [Anish'in Hammerspoon Konfigürasyonu](https://github.com/anishathalye/dotfiles-local/tree/mac/hammerspoon)

## Başlatma ve Canlı USB'ler

Bilgisayarınızı başlattığınızda işletim sistemi yüklenmeden önce [BIOS](https://en.wikipedia.org/wiki/BIOS)/[UEFI](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) adı verilen özel bir program sisteminizi hazır hale getirir. Bu aşamada, özel bir tuş kombinasyonu kullanarak, bu programın konfigürasyonunu değiştirebilirsiniz. Örneğin, başlama anında ekranda "BIOS konfigürasyonu için F9'a bazın. Başlatma menüsü için F12'ye basın" ("Press F9 to configure BIOS. Press F12 to enter boot menu.") şeklinde veya buna benzer bir bilgilendirme mesajı olabilir. BIOS menüsünden bilgisayarınızın donanımı ile ilgili pek çok konfigürasyon seçeneğini değiştirebilirsiniz. Hatta, başlatma menüsüne erişerek bilgisayarınızı alternatif kaynaklardan başlatılacak şekilde konfigüre edebilirsiniz.

[Canlı USB'ler (Live USB)](https://en.wikipedia.org/wiki/Live_USB) içinde işletim sistemi yer alan flaş belleklerdir. Bu USB'leri bir işletim sistemini (örneğin, herhangi bir Linux dağıtımı) indirip USB flaş belleğe kaydederek (geleneksel olarak bu işleme `burn` denir) kendiniz oluşturabilirsiniz. Bu işlem alışılagelmiş `.iso` imaj dosyalarını kopyalamaktan biraz daha karmaşıktır. Bu işlemi kolaylaştıran [UNetbootin](https://unetbootin.github.io/) gibi araçlar kullanabilirsiniz.

Canlı USB'ler çok farklı durumda oldukça kullanışlıdırlar. Örneğin, normal işletim sisteminiz çöktüğünde işletim sisteminizi tamir etmek veya bu mümkün değilse diskinizdeki verileri kurtarmak için canlı USB'leri kullanabilirsiniz.


## Docker, Vagrant, Sanal Makinalar, Bulut, OpenStack

[Sanal makinalar](https://en.wikipedia.org/wiki/Virtual_machine) ve onlara benzer contanerlar gibi teknolojiler işletim sistemi dahil tam teşekküllü bir bilgisayarı emüle etmek için kullanılabilirler. Bu araçlar izole test, geliştirme ve inceleme ortamları (örneğin, zararlı yazılımları incelemesi) oluşturmak için oldukça kullanışlıdırlar.

[Vagrant](https://www.vagrantup.com/), bilgisayar konfigürasyonlarını (işletim sistemi, hizmetler, paketler vb.) kod ile tanımlamanızı ve `vagrant up` komutu ile bu konfigürasyonlardan sanal makinalar ayağa kaldırmanızı sağlayan bir araçtır. [Docker](https://www.docker.com/), konsept olarak Vagrant'a benzer ancak containerları kullanır. 

Bulutta sanal makinalar kiralayıp hızlı bir şekilde bu sunuculara erişim sağalayabilirsiniz. Örneğin:

- Sürekli çalışan ve açık IP adresine sahip ucuz bir sunucu ihtiyacını karşılamak için
- Yüksek kapasitede CPU, disk, bellek veya GPU sahip bir sunucu kullanmak için
- Normalde sahip olabileceğinizden fazla sayıda sunucu ihtiyacını varsa (faturalama genelde saniye bazında yapılır, bu nedenle kısa süreli yüksek kaynak ihtiyacınız için 1000 tane sunucuyu birkaç dakikalığına kiralayabilirsiniz)



Bu hizmetleri [Amazon AWS](https://aws.amazon.com/), [Google
Cloud](https://cloud.google.com/), ve
[DigitalOcean](https://www.digitalocean.com/) gibi popüler bulut hizmet sağlayıcılarından kiralama benzeri yöntemler ile kullanabilirsiniz.

Eğer MIT CSAIL üyesi iseniz, araştırma projeleriniz için [CSAIL OpenStack](https://tig.csail.mit.edu/shared-computing/open-stack/) üzerinden ücretsiz olarak sanal makinalar kiralayabilirsiniz.

## Not Defteri Programlama Ortamları

Etkileşimli ve araştırma amaçlı programlama işlemleri için [not defteri benzeri programlama ortamları](https://en.wikipedia.org/wiki/Notebook_interface) oldukça kullanışlıdırlar. Günümüzde en popüler not defteri programlama ortamlarından birisi, Python ve birkaç diğer dil için, [Jupyter](https://jupyter.org/)'dir. Matematiksel işlemler için ise [Wolfram Mathematica](https://www.wolfram.com/mathematica/) en popüler ortamdır.


## GitHub

[GitHub](https://github.com/), açık kaynak programlar için en popüler platformdur. Derste bahsettiğimiz [vim](https://github.com/vim/vim), 
[Hammerspoon](https://github.com/Hammerspoon/hammerspoon) ve bir çok diğer araç Github üzerinde geliştirilip yönetilmektedir. Açık kaynak projelere katkı sağlamak ve gündelik işlerinizde kullandığınız araçların gelişimine katkı sağlamak oldukça kolaydır.

Github üzerinde iki şekilde açık kaynak projelere katkı sağlayabilirsiniz:

- [Issue](https://help.github.com/en/github/managing-your-work-on-github/creating-an-issue) oluşturarak. Bu sayede kullandığınız araçlardaki bir sorunu geliştiricilere bildirebilir veya yeni bir özelliğin eklenmesi talebinde bulunabilirsiniz. Bu işlemlerden hiç birisinin kod yazabilmek veya okuyabilmek ile ilgisi yoktur, bu nedenle bu işlemleri yapmak oldukça basittir. Yüksek kaliteli hata raporları geliştiriciler için çok kıymetlidir, araçlar ile ilgili tartışmalara da fikirlerinizle katkı sağlayabilirsiniz. 
- [Pull
request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) oluşturarak projelere kod katkısı yapabilirsiniz. Bu işlem issue oluşturmaktan daha zahmetlidir. Github'da herhangi bir projenin deposunu kopyalayıp ([fork](https://help.github.com/en/github/getting-started-with-github/fork-a-repo)), kodu bilgisayarınıza indirip (clone), yeni bir dal oluşturarak ve değişiklikler yaparak bu değişikliklerin ana projenin kod deposuna birleştirilmesini (pull request oluşturarak ([pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) oluşturarak) sağlayabilirsiniz. Pull request oluşturduktan sonra genelde katkı sağladığınız açık kaynak proje'nin yöneticileri birkaç tur yaptığınız değişiklik ile ilgili iletişimde bulunacaksınız. Çoğu zaman, açık kaynak projelerde "Katkı Sağlama Kuralları", giriş seviyesi için uygun olarak etiketlenmiş issue'lar, hatta bazı projelerde ilk defa katkı yapacaklar için mentorluk programları gibi imkanlar da sunulur.
