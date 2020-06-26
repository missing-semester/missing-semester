---
layout: lecture
title: "Güvenlik ve Kriptografi"
date: 2019-01-28
ready: false
video:
  aspect: 56.25
  id: tjwobAmnKTo
---

Geçen yılın [güvenlik ve gizlilik dersi](/2019/security/) bir bilgisayar 
_kullanıcısı_ olarak nasıl daha güvende olacağımıza odaklandı. Bu yıl, amacına
uygun olarak Git'de Hash Fonksiyonları kullanımı ya da anahtar türetme 
fonksiyonları ve SSH'da simetrik/asimetrik şifreleme sistemleri gibi daha önce 
bu sınıfta bahsettiğimiz araçların güvenlik ve şifreleme konseptlerine odaklanacağız.

Bu kurs bilgisayar sistem güvenliği ([6.858](https://css.csail.mit.edu/6.858/)) ya da
kriptografi ([6.857](https://courses.csail.mit.edu/6.857/) and 6.875) dersinin yerini 
tutacak kadar detaylı değildir. Güvenlik konusunda resmi bir eğitim almadan güvenlik ile
alakalı bir çalışma yapmayın. Uzman olana kadar, sakın [kendi şifreleme 
algoritmanızı](https://www.schneier.com/blog/archives/2015/05/amateurs_produc.html) oluşturup
kullanmayın.

Aynı durum sistem  güvenliği için de geçerlidir.

Bu ders temel kriptografi konseptleri hakkında resmi olmayan (ama pratik olduğunu düşündüğümüz) bir işleyişe sahip. Bu ders güvenli sistemler ya da güvenlik protokolleri _tasarlamak_ için yeterli değil, ancak size kullandığınız programları ve protokolleri anlayacak kadar genel bilgi vereceğini umut ediyoruz.

# Entropi

[Entropi](https://en.wikipedia.org/wiki/Entropy_(information_theory)) rastgeleliğin ölçüsüdür. Parolaların gücünün belirlenmesi gibi alanlarda oldukça kullanışlı.

![XKCD 936: Password Strength](https://imgs.xkcd.com/comics/password_strength.png)

Yukarıdaki [XKCD karikatüründeki](https://xkcd.com/936/) bahsedildiği gibi,
"correcthorsebatterystaple" gibi bir şifre "Tr0ub4dor&3" gibi bir şifreden daha güvenli.
Ama böyle bir şey nasıl ölçülebilir?

Entropi _bit_ cinsinden ölçülür, bir olasılıklar kümesi için entropi hesaplanırken şu
şekilde hesaplanır: `log_2(olasılıkların sayısı)`. Yani adil bir madeni paranın yazı tura
atılmasının entropisi 1 bittir (log_2(2)). 6 yüzlü bir zar atıldığında entropisi
\~2.58 bit olacaktır (log_2(6)).

Saldırganın parolanın _modelini_ bildiği, ancak
parola seçmek için kullanılan rastgeleliği (örneğin [zar atmak](https://en.wikipedia.org/wiki/Diceware))
bilmediği varsayılır.

Ne kadar entropi yeterlidir? Bu sizin tehdit modelinize bağlıdır. Online tahminler için XKCD karikatüründe
de göründüğü gibi \~40 bit entropi yeterlidir. Offline bir tahmin saldırısı için daha sağlam parolalar
önemlidir. (80 bit ya da daha fazla.)

# Hash fonksiyonları (Özet fonksiyonları)

[Kriptografik hash fonksiyonu](https://en.wikipedia.org/wiki/Cryptographic_hash_function) değişken uzunluklu veri kümelerini, sabit uzunluklu veri kümelerine haritalayan algoritma veya alt programdır.
Bazı özel özelliklere sahiptir. Bir hash fonksiyonu kabaca aşağıdaki özelliklere sahiptir:

```
hash(value: array<byte>) -> vector<byte, N>  (Sabit bir N için)
```

Hash fonksiyonlarına örnek olarak, Git'de de kullanılan [SHA1](https://en.wikipedia.org/wiki/SHA-1)
verilebilir. İsteğe bağlı uzunlukla bir karakter dizisini 160 bit'e haritalar. (40 onaltılık karakter olarak gösterilebilir.). `sha1sum` komutu ile bir girdi kullanarak SHA1'i deneyebiliriz:

```console
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'Hello' | sha1sum 
f7ff9e8b7bb2e09b70935a5d785e0cc5d9d0abf0
```

Yüksek düzeyden bakıldığında, bir hash fonksiyonu tersinin alınması çok zor, rastgele görünümlü (ancak deterministik) bir fonksiyondur (ve bu [hash fonksiyonunun ideal bir modelidir](https://en.wikipedia.org/wiki/Random_oracle)). Bir hash fonksiyonu aşağıdaki özelliklere sahiptir:

- Deterministik: her zaman aynı girdi için aynı çıktıyı verir. Rastgelelik yoktur.
- Tersinemez (Ters görüntüye dayanıklılık): `m` girdisi için `hash(m) = h` ise `h`'ı kullanarak `m`'i
  bulmak zor olmalıdır. Hash fonksiyonu tek yönlü olmalıdır.
- Hedef çakışması direnci: İki ayrı mesajın aynı hash’inin olması çok zor olmalıdır. Bir `m_1` mesajının
  hash değeri ile farklı bir mesaj olan `m_2`'nin hash değerinin aynı olmasının zorluğudur. Çakışma örneği:
  `hash(m_1) = hash(m_2)`.
- Çakışma Direnci: Herhangi iki farklı girdinin aynı özeti çıktı olarak üretmemesidir. Hash değerleri aynı
  olan `hash(m_1) = hash(m_2)` iki girdinin `m_1` `m_2` bulunması zor olmalıdır. (bunun kesinlikle daha
  güçlü bir özellik olduğunu unutmayın).

Not: belirli amaçlar için çalışabilse de, SHA-1 [artık](https://shattered.io/) güçlü
bir kriptografik hash fonksiyonu değildir. [Kriptografik hash fonksiyonlarının yaşam süresi](https://valerieaurora.org/hash.html)
ile ilgili ilgi çekici bir tablo bulabilirsiniz. Ancak, spesifik hash fonksiyonlarının önerilmesi bu dersin
hedeflerinden ve amaçlarından değil. Eğer önemli bir işte bir hash fonksiyonu kullanacaksınız, önce
güvenlik ve kriptografi alanında ciddi bir ders almalısınız. 

## Uygulamalar

- Git, içerik adresli depolama için kullanır. [Hash fonksiyonu](https://en.wikipedia.org/wiki/Hash_function)
  fikri daha genel bir konsepttir (kriptografik olmayan hash fonksiyonu).
  Git neden kriptografik hash fonksiyonu kullanır?

- Dosya içeriğinin kısa bir özeti. Yazılımlar bazen (potansiyel 
  olarak daha az güvenilir) mirrorlardan indirilebilir. Örneğin: Linux ISOları,
  ve onlara güvenmemek iyi bir seçim olabilir. Resmi siteler genellikle dosyaların
  hashlerini indirme linklerinin (üçüncü parti bir siteye referans eden) yanında 
  gösterirler, böylece hashler dosya indirildikten sonra kontrol edilebilir.

- [Üstlenme şemaları](https://en.wikipedia.org/wiki/Commitment_scheme).
Belirli bir değere bağlı kalmak istediğinizi, ancak değerin kendisini daha sonra 
ortaya çıkardığını varsayalım. Örneğin, Alice ve Bob'un aynı ortamda bulunmadığını
ve bir kişi seçmek için yazı tura atacaklarını varsayalım. Alice ve Bob birer tane
madeni parayı atacaklar ve ikisinin sonucu aynıysa Alice bir yemek ısmarlayacak,
eğer ikisinin sonuçları farklı olursa Bob yemek ısmarlayacak. Bu durumda ilk kimin
sonucunu söyleyeceği karşı tarafın hile yapması ile sonuçlanabilir. Dolayısı ile şöyle
bir yol izlenebilir. Tek sayıların yazıyı, çift sayıların turayı var sayılarak sonuçlar
önce bir hash fonksiyonundan geçirilir. `a` Alice'in sonucunu (yazı geldiğini varsayıyoruz)
temsil eden sayı örneğin "1789" ve `b` Bob'un sonucunu (tura geldiğini varsayıyoruz)
"59980" temsil ediyor. Her iki tarafta da birbirlerine hash fonskiyonalrı sonucu
`hash(a)` ve `hash(b)`  birbirleriyle paylaşılabilir 2 tarafta bu hashleri aldıktan sonra
birbirlerine söyledikleri (teklik ve çiftlik durumuna göre yazı ya da tura olduğu belirlenen)
sayıları teyit edebilirler. Böylece iki tarafın da hile yapmasının önüne geçilir.

# Anahtar türetme fonksiyonları

Kriptografik hashlerle ilgili bir terim, [anahtar türetme
fonksiyonları](https://en.wikipedia.org/wiki/Key_derivation_function) (ATF)
diğer kriptografik fonksiyonlarda anahtar olarak kullanılacak belirli uzunlukta
çıktılar üretmeyi de içeren bir dizi işlemde kullanılır. Genellikle ATF'ler kasıtlı
olarak yavaş tutulur. Burada amaç çevrimdışı kaba kuvvet saldırılarını yavaşlatmaktır.

## Uygulamalar

- Diğer kriptografik fonksiyonlarda kullanmak için parolalardan anahtar üretimi.
(Örneğin: simetrik kriptografi, aşağıda bahsediliyor).
- Giriş bilgilerini saklamada kullanılır. Parolaları düz metin halinde tutmak kötüdür;
  doğru yaklaşım her kullanıcı için bir [salt (tuz)](https://en.wikipedia.org/wiki/Salt_(cryptography)) oluşturmak `salt = random()` ve saklamaktır. `ATF(password + salt)` değeri de saklanır.
  Giriş isteği saklanan salt ve girilen parola kullanılarak ATF değerinin yeniden hesaplanması
  ve saklanan değer ile karşılaştırılması ile kontrol edilir.

# Simetrik şifreleme

Kriptografi hakkında düşündüğünüzde mesaj içeriklerinin gizlenmesi muhtemelen aklınıza
gelen ilk konsept olacaktır. Simetrik şifreleme bunu aşağıdaki fonksiyon seti ile başarır:

```
keygen() -> anahtar  (bu fonksiyon rastgeledir)

şifrele(düz metin: array<byte>, anahtar) -> array<byte>  (şifrelenmiş metin)
çöz(şifrelenmiş metin: array<byte>, anahtar) -> array<byte>  (çözümlenmiş düz metin)
```

Şifreleme fonksiyonu sonuç olarak bir çıktı verir (şifreli metin), key olmadan
şifrelemeyi çözmek ve veriye (düz metin) ulaşmak oldukça zordur. Şifre
çözme fonksiyonu tam doğruluk özelliğine sahiptir, `şifrele(çöz(m, k), k) = m`'dir.

Günümüzde yaygın olarak kullanılan bir simetrik şifreleme sistemi de
[AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)tir.

## Uygulamalar

- Güvenilmeyen bir bulut saklama servisinde dosyaları saklamak için kullanılabilir. 
  ATF ile birlikte kullanılabilir, böylece bir parola kullanılarak dosyalarınızı 
  şifreleyebilirsiniz. Anahtarı üretin `anahtar = ATF(passphrase)`, ve daha sonra
  `şifrele(dosya, anahtar)` sonucunu depolayabilirsiniz.

# Asimetrik şifreleme

"Asimetrik" terimi burada iki farklı role sahip iki anahtar kullanıldığına referans eder.
Hususi (private) anahtarın adından da anlaşılabileceği gibi gizli tutulması gerekir. Umumi (public)
anahtar herekese açık olarak paylaşılabilir. Simetrik şifrelemenin aksine güvenliği etkilemez.
Asimetrik şifreleme sitemleri şifrelemek/çözmek ve imzalamak/doğrulamak için aşağıdaki fonksiyonları
takip eder:

```
keygen() -> (umumi anahtar, hususi anahtar)  (bu fonksiyon rastgeledir)

şifrele(düz metin: array<byte>, umumi anahtar) -> array<byte>  (şifrelenmiş metin)
çöz(şifrelenmiş metin: array<byte>, hususi anahtar) -> array<byte>  (çözümlenmiş düz metin)

imzala(mesaj: array<byte>, hususi anahtar) -> array<byte>  (imza)
doğrula(mesaj: array<byte>, imza: array<byte>, umumi anahtar) -> bool  (imzanın geçerli olup olmadığı)
```

The encrypt/decrypt functions have properties similar to their analogs from
symmetric cryptosystems. A message can be encrypted using the _public_ key.
Given the output (ciphertext), it's hard to determine the input (plaintext)
without the _private_ key. The decrypt function has the obvious correctness
property, that `decrypt(encrypt(m, public key), private key) = m`.

Symmetric and asymmetric encryption can be compared to physical locks. A
symmetric cryptosystem is like a door lock: anyone with the key can lock and
unlock it. Asymmetric encryption is like a padlock with a key. You could give
the unlocked lock to someone (the public key), they could put a message in a
box and then put the lock on, and after that, only you could open the lock
because you kept the key (the private key).

The sign/verify functions have the same properties that you would hope physical
signatures would have, in that it's hard to forge a signature. No matter the
message, without the _private_ key, it's hard to produce a signature such that
`verify(message, signature, public key)` returns true. And of course, the
verify function has the obvious correctness property that `verify(message,
sign(message, private key), public key) = true`.

## Applications

- [PGP email encryption](https://en.wikipedia.org/wiki/Pretty_Good_Privacy).
People can have their public keys posted online (e.g. in a PGP keyserver, or on
[Keybase](https://keybase.io/)). Anyone can send them encrypted email.
- Private messaging. Apps like [Signal](https://signal.org/) and
[Keybase](https://keybase.io/) use asymmetric keys to establish private
communication channels.
- Signing software. Git can have GPG-signed commits and tags. With a posted
public key, anyone can verify the authenticity of downloaded software.

## Key distribution

Asymmetric-key cryptography is wonderful, but it has a big challenge of
distributing public keys / mapping public keys to real-world identities. There
are many solutions to this problem. Signal has one simple solution: trust on
first use, and support out-of-band public key exchange (you verify your
friends' "safety numbers" in person). PGP has a different solution, which is
[web of trust](https://en.wikipedia.org/wiki/Web_of_trust). Keybase has yet
another solution of [social
proof](https://keybase.io/blog/chat-apps-softer-than-tofu) (along with other
neat ideas). Each model has its merits; we (the instructors) like Keybase's
model.

# Örnek çalışmalar

## Parola yöneticileri

Herkesin kullanmayı denemesi gereken gerekli bir araçtır. (örneğin,
[KeePassXC](https://keepassxc.org/)). Parola yöneticileri ziyaret ettiğiniz websiteleri için
benzersiz, rastgele üretilmiş yüksek entropili parolalar oluşturur. Bu parolaları
sizin parola yöneticisi veri tabanı için kullandığınız ana parolayı ATF'den geçirerek ürettiği
anahtar yardımıyla simetrik olarak şifrelenmiş şekilde tek bir yerde saklarlar.

Parola yöneticisi kullanmak parolanın yeniden kullanmanızı önlemenizi sağlar (böylece web sitelerinin
güvenliği ihlal edildiğinde daha az etkilenirsiniz), yüksek entropi parolaları kullanırsınız (bu 
nedenle güvenlik tehlikesi daha düşüktür) ve yalnızca tek bir yüksek entropi parolasını hatırlamanız 
gerekir.

## 2 faktörlü kimlik doğrulama

[2 faktörlü kimlik doğrulama](https://en.wikipedia.org/wiki/Multi-factor_authentication)
(2FA) kimlik doğrulama yöntemi 2FA doğrulayıcısı ([YubiKey](https://www.yubico.com/) gibi,
"sahip olduğun bir şey") yanında "bildiğin bir parola" gerektirir. Çalınan parolalara ve
[oltalama (phishing)](https://en.wikipedia.org/wiki/Phishing) ataklarına karşı korumak için kullanılır.

## Tam disk şifrelenmesi

Dizüstü bilgisayarınızın tüm diskini şifreli tutmak, dizüstü bilgisayarınızın
çalınması durumunda verilerinizi korumanın kolay bir yoludur. Linux'ta [cryptsetup +
LUKS](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_a_non-root_file_system),
Windows'ta [BitLocker](https://fossbytes.com/enable-full-disk-encryption-windows-10/),
ya da macOS'te [FileVault](https://support.apple.com/en-us/HT204837) kullanabilirsiniz.
Bu tüm diski parolanızdan türetilecek bir anahtar ile simetrik bir şifreleme metodu
ile şifreleyecektir.

## Özel mesajlaşma

[Signal](https://signal.org/) ya da [Keybase](https://keybase.io/) kullanın. Uçtan uca
güvenlik asimetrik şifrelemeden ön yüklenmiştir. Burada kişilerinizin umumi anahtarlarını
elde edebilmek kritik bir adımdır. Eğer iyi bir güvenlik istiyorsanız, umumi anahtarları
bant dışı doğrulamaya ihtiyacınız var (Signal ya da Keybase ile), ya da
sosyal kanıtlara güvenmeniz gerekecektir (Keybase ile).

## SSH

[Önceki derslerden birinde](/2020/command-line/#remote-machines) SSH kullanımını
ve SSH anahtarları işlendi. Bunun kriptografik yönlerine bakalım.

`ssh-keygen` çalıştırıldığında size `umumi anahtar ve hususi anahtar` içeren bir
anahtar çifti oluşturur. İşletim sistemi tarafından sağlanan entropi kullanılarak,
rastgele oluşturulur. (donanım etkinliklerinden toplanan vs.). Umumi anahtar
olduğu gibi saklanmalıdır (herkese açıktır, saklamaya gerek yoktur), ancak
hususi anahtar diskte şifrelenmiş olarak saklanmalıdır. `ssh-keygen` programı
kullanıcıdan bir parola ister. Bir anahtar üretmek için bu parolayı anahtar türetme
fonksiyonundan geçirir. Üretilen anahtar hususi anahtarı simetrik olarak şifrelemede
kullanılır.

Kullanımda, sunucuda istemcinin herkese açık (umumi) anahtarı bulunur (`.ssh/authorized_keys`
dosyasında saklanır), bir istemci bağlantı için kimliğini asimetrik imzaları kullanarak kanıtlar.
Bu işlem [challenge-response](https://en.wikipedia.org/wiki/Challenge%E2%80%93response_authentication)
sayesinde yapılır. Basitçe anlatmak gerekirse, sunucu rastgele bir sayı seçer ve onu
istemciye gönderir. Sonrasında, istemci bu mesajı imzalayıp imzayı sunucuya geri gönderir.
Sunucu gelen imzalanmış veriyi kendisinde olan umumi anahtarı kullanarak kontrol eder.
Bu yöntem etkili olarak istemcinin, sunucuda bulunan `.ssh/authorized_keys` dosyasındaki umumi
anahtarın, hususi anahtarına sahip olduğunu doğrulamaya yarar.

{% comment %}
zaman ayırabilecekler için, ekstra başlıklar

güvenlik kavramları ve ipuçları,
- biyometrikler
- HTTPS
{% endcomment %}

# Kaynaklar

- [Geçen yılın notları](/2019/security/): bir bilgisayar kullanıcısı olarak nasıl daha güvende olacağımıza odaklanır
- [Cryptographic Right Answers](https://latacora.micro.blog/2018/04/03/cryptographic-right-answers.html): yaygın X'ler için "X için hangi şifrelemeyi kullanmalıyım?" sorusunu cevaplar.

# Egzersizler

1. **Entropi.**
    1. 100,000 kelimeye sahip bir sözlükten rastgele benzersiz 5 kelime seçtiğimizi,
       ve bu 5 kelimeyi birleştirerek bir parola ürettiğimizi varsayalım.
       Örnek olarak şuna benzeyecek: `correcthorsebatterystaple`. Oluşan parola kaç
       bit entropiye sahip olur?

    2. İkinci bir alternatif şema hayal edin. 8 rastgele alfa-numerik karakterden oluşan
       (küçük ve büyük harflerin ikisini de barındırabilir) bir parola ürettiniz.
       Örneğin, `rg8Ql34g`. Bu parola kaç bit entropiye sahip olur?

    3. Hangisi daha güçlü bir paroladır.

    4. Bir saldırganın saniyede 10,000 parola deneyebildiğini varsayın. Ortalama
       olarak, bu iki parolayı kırma süresi ne kadar olabilir?

2. **Kriptografik özet fonksiyonları.** Bir [mirror](https://www.debian.org/CD/http-ftp/)'dan
   Debian imajı indirin. (Örneğin, [Arjantin'deki
   bir mirror](http://debian.xfree.com.ar/debian-cd/current/amd64/iso-cd/).
   Resmi Debian web sitesinden verilen hashi kullanarak (Arjantin örneği için [bu
   dosya](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS) hash'e çapraz
   kontrol uygulayın (örneğin, `sha256sum` komutunu kullanarak).

3. **Simetrik şifreleme.** [OpenSSL](https://www.openssl.org/)
   kullanarak bir dosyayı AES ile şifreleyin: `openssl aes-256-cbc -salt -in {giren 
   dosya} -out {çıkış dosyası}`. İçeriğine `cat` ya da
   `hexdump` kullanarak bakın. `openssl aes-256-cbc -d -in {giren dosya} -out
   {çıkış dosyası}` ile şifreyi çözün ve `cmp` çözülmüş dosya ile ilk dosyanın içeriğinin
   aynı olduğunu doğrulayın.

4. **Asimetrik şifreleme.**
    1. [SSH
       anahtarlarınızı](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
       erişimizin olduğu bir bilgisayara kurun. Bağlantıdaki öğreticide anlatılan RSA yerine,
       daha güvenli olan [ED25519 anahtarlarını](https://wiki.archlinux.org/index.php/SSH_keys#Ed25519) kullanın.
       Hususi anahtarınızın bir parola ile şifrelendiğinden emin olun, böylece dosya duruyorken korunur.
    2. [GPG kullanın](https://www.digitalocean.com/community/tutorials/how-to-use-gpg-to-encrypt-and-sign-messages)
    3. Çalgan'a şifrelenmiş bir e-posta gönderin ([umumi anahtarı](https://keybase.io/calganaygun)).
    4. `git commit -S` kullanarak bir Git commiti imzalayın ya da `git tag -s` ile imzalanmış
       bir Git etiketi oluşturun. `git show
       --show-signature` ile committeki imzayı doğrulayın ya da `git tag -v` ile etiket için doğrulayın.
