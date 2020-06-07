---
layout: lecture
title: "Bu dersleri niye veriyoruz"
---

Geleneksel Bilgisayar Bilimi eğitimi sırasında, İşletim Sistemleri, Programlama Dilleri 
ve Makine Öğrenmesi gibi bir çok gelişmiş konuyu öğreten çok sayıda ders alacaksınız.
Ancak birçok kurumda nadiren kapsanan ve bunun yerine öğrencilerin kendi başlarına 
başa çıkmaları gereken bir konu vardır bu da **computing ecosystem literacy'dir.**

Yıllar içinde, MIT'de birkaç dersin öğretilmesine yardımcı olduk ve defalarca birçok öğrencinin kullanabileceği araçlar hakkında sınırlı bilgiye sahip olduğunu gördük. Bilgisayarlar manuel görevleri otomatikleştirmek için oluşturulmuştur, ancak öğrenciler genellikle tekrarlayan görevleri elle gerçekleştirir ya da sürüm kontrolü ve metin editörleri gibi güçlü araçlardan tam olarak yararlanamazlar. Bu en iyi ihtimalle verimsizlik ve zaman kaybına yol açarken en kötü ihtimalle veri kaybı veya belirli görevleri tamamlayamama gibi sorunlara da yol açar.

Bu konular üniversite müfredatının bir parçası olarak öğretilmez: öğrencilere asla bu araçların nasıl kullanılacağı veya en azından bunların nasıl verimli bir şekilde kullanılacağı gösterilmez ve böylece basit olması gereken görevler için bile zaman ve çaba harcarlar. Standart Bilgisayar Bilimleri müfredatında, öğrencilerin hayatlarını önemli ölçüde kolaylaştırabilecek bilgisayar ekosistemi ile ilgili kritik konular eksiktir.

# Hiç Anlatılmamış Bilgisayar Bilimleri Döneminiz

Buna çare olmak amacı ile; etkili bir bilgisayar bilimcisi ve programcısı olmak için gerekli olduğunu düşündüğümüz tüm başlıkları kapsayan bir müfredat yürütüyoruz. Bu müfredat eğitici ve pratiktir ve karşılaşabileceğiniz çeşitli durumlarda hemen uygulayabileceğiniz araçlara ve tekniklere uygulamalı bir giriş sağlar. Bu ders, MIT'nin Ocak 2020'deki "Bağımsız Faaliyetler Dönemi" sırasında  öğrenci tarafından yürütülen daha kısa sınıflar içeren bir aylık bir dönem boyunca yürütülmektedir. Dersler sadece MIT öğrencilerine açık olsa da, video kayıtları ile beraber tüm ders materyallerini halka sunacağız.

Bu sizin için uygun gibi görünüyorsa, sınıfın ne öğreteceğine dair bazı somut örnekler:

## Komut satırı kabuğu(command shell)

Alias'lar(takma adlar), script'ler ve derleme sistemleri ile sıradan ve tekrarlanan görevleri nasıl otomatikleştiririz?
Artık bir metin belgesinden kopyala-yapıştır komutlar kullanmak yok!
Artık 15 komutu arka arkaya çalıştırmak yok!
Artık "şunu çalıştırmayı unutmuşsun!" ya da "Şu parametreyi atlamışsın!" gibi hatalar görmek yok!

Örneğin, geçmişinizde hızlı bir şekilde arama yapmak büyük bir zaman tasarrufu olabilir. Aşağıdaki örnekte, `convert` komutları için shell geçmişinizde gezinmeyle ilgili birkaç püf noktası gösteriyoruz.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/history.mp4" type="video/mp4">
</video>

## Versiyon Kontrolü

Versiyon kontrol sistemini nasıl doğru bir şekilde nasıl kullanabilir ve bizi olası bir felaketten kurtarmak, başkalarıyla işbirliği yapmak ve sorunlu değişiklikleri hızlı bir şekilde bulmak ve izole etmek için bundan nasıl faydalanabiliriz? 
Artık `rm -rf; git clone` yok! Artık `merge conflict`'ler yok!(en azından daha az) Artık devasa yorum satırları yok! 
Artık kodunuzun çalışmasına neyin engel olduğunu nasıl bulacağınız konusunda endişelenmenize gerek yok! 
Artık "Hayırr! Çalışan kodu mu sildim!" demek yok! 
Hatta size diğer insanların projelerine pull request atarak nasıl katkı sağlayacağınızı bile öğreteceğiz!

Aşağıdaki örnekte, bir birim testini(unit test) hangi commit'in bozduğunu bulmak için `git bisect`'i kullanıyoruz ve daha sonra bunu `git revert` ile düzeltiyoruz.
<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/git.mp4" type="video/mp4">
</video>

## Metin düzenleme

Dosyaları hem yerel olarak hem de uzaktan komut satırında nasıl etkili şekilde düzenlersiniz ve gelişmiş metin editörlerinden nasıl yararlanırsınız? 
Artık habire kopyala yapıştır yapmaya gerek yok!
Artık kendini tekrarlayan dosya düzenlemeleri yok

Vim makroları en iyi özelliklerinden biridir, aşağıdaki örnekte, bir html tablosunu iç içe bir vim makrosu kullanarak hızlı bir şekilde csv formatına dönüştürüyoruz.
<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/vim.mp4" type="video/mp4">
</video>

## Uzak makineler

SSH anahtarları ve terminal multiplexing kullanarak uzak makinelerle çalışırken nasıl akıl sağlığımızı koruruz?
Artık aynı anda iki komutu çalıştırmak için birçok terminali açık tutmaya gerek yok.
Artık her bağlandığınızda prolanızı yazmanıza gerek yok.
Artık internet bağlantınız kesildiğinden veya dizüstü bilgisayarınızı yeniden başlattığınızdan her şeyi kaybetmenize gerek yok.

Aşağıdaki örnekte, oturumları uzak sunucularda canlı tutmak için "tmux" ve ağ dolaşımını ve bağlantıyı kesmek için "mosh" kullanıyoruz.

<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/ssh.mp4" type="video/mp4">
</video>

## Dosyaları bulmak

Aradığınız dosyaları nasıl hızlı şekilde bulursunuz?
Artık aradığınız kod parçasını bulmak için projenizdeki tüm dosyalara tıklamanıza gerek yok.

Aşağıdaki örnekte hızlı bir şekilde `fd` içeren dosyaları ve `rg` içeren kod parçacıklarını arıyoruz. Ayrıca `fasd` kullanarak hızlı bir şekilde  cd've vim'de en son/sıklıkla kullanılan dosya/klasörleri görebiliriz.
<video autoplay="autoplay" loop="loop" controls muted playsinline  oncontextmenu="return false;"  preload="auto"  class="demo">
  <source src="/static/media/demos/find.mp4" type="video/mp4">
</video>

## Veri düzenleme

Verileri ve dosyaları doğrudan komut satırından hızlı ve kolay bir şekilde nasıl değiştirebilir, görüntüleyebilir, ayrıştırabilir, çizebilir ve hesaplayabiliriz?
Artık 'log' dosyalarından kopya yapıştırmaya gerek yok.
Artık veriler üzerinden elle hesap yapmaya gerek yok.
Artık elle tablolar çizmek yok.

## Sanal makineler

Yeni işletim sistemlerini denemek, ilgisiz projeleri izole etmek ve ana makinenizi temiz ve düzenli tutmak için sanal makineleri nasıl kullanabilirsiniz?
Artık bir security lab yaparken bilgisayarınızı yanlışlıkla bozmayacaksınız.
Artık farklı versiyonlara sahip milyonlarca rastgele kurulmuş paket yok.

## Güvenlik

Tüm sırlarınızı dünyaya açmadan interneti nasıl kullanabilirsiniz?
Artık kendi başınıza çılgın kriterlere uyması gereken parolalar bulmaya son.
Artık güvenli olmayan, açık WiFi ağları yok.
Artık şifrelenmemiş mesajlaşmalar yok.

# Sonuç

Bunlar ve daha fazlası, 12 derse yayılarak anlatılacaktır ve her bir ders sahip olduğunuz araçlara daha fazla aşina olmanız için egzersizler içerecektir.
Ocak ayını bekleyemiyorsanız, geçen yıl IAP boyunca yürüttüğümüz[Hacker Tools](https://hacker-tools.github.io/lectures) derslerine de göz atabilirsiniz. Aynı konuların çoğunu kapsar.

Yüz yüze ya da sanal, ocak ayında görüşmek dileğiyle!

İyi hacklemeler,<br>
Anish, Jose, ve Jon