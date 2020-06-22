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
keygen() -> anahtar  (bu fonksiyon rastgele'dir)

şifrele(düz metin: array<byte>, anahtar) -> array<byte>  (şifreli metin)
şifreyiçöz(şifreli metin: array<byte>, anahtar) -> array<byte>  (düz metin)
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

# Asymmetric cryptography

The term "asymmetric" refers to there being two keys, with two different roles.
A private key, as its name implies, is meant to be kept private, while the
public key can be publicly shared and it won't affect security (unlike sharing
the key in a symmetric cryptosystem). Asymmetric cryptosystems provide the
following set of functionality, to encrypt/decrypt and to sign/verify:

```
keygen() -> (public key, private key)  (this function is randomized)

encrypt(plaintext: array<byte>, public key) -> array<byte>  (the ciphertext)
decrypt(ciphertext: array<byte>, private key) -> array<byte>  (the plaintext)

sign(message: array<byte>, private key) -> array<byte>  (the signature)
verify(message: array<byte>, signature: array<byte>, public key) -> bool  (whether or not the signature is valid)
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

# Case studies

## Password managers

This is an essential tool that everyone should try to use (e.g.
[KeePassXC](https://keepassxc.org/)). Password managers let you use unique,
randomly generated high-entropy passwords for all your websites, and they save
all your passwords in one place, encrypted with a symmetric cipher with a key
produced from a passphrase using a KDF.

Using a password manager lets you avoid password reuse (so you're less impacted
when websites get compromised), use high-entropy passwords (so you're less likely to
get compromised), and only need to remember a single high-entropy password.

## Two-factor authentication

[Two-factor
authentication](https://en.wikipedia.org/wiki/Multi-factor_authentication)
(2FA) requires you to use a passphrase ("something you know") along with a 2FA
authenticator (like a [YubiKey](https://www.yubico.com/), "something you have")
in order to protect against stolen passwords and
[phishing](https://en.wikipedia.org/wiki/Phishing) attacks.

## Full disk encryption

Keeping your laptop's entire disk encrypted is an easy way to protect your data
in the case that your laptop is stolen. You can use [cryptsetup +
LUKS](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_a_non-root_file_system)
on Linux,
[BitLocker](https://fossbytes.com/enable-full-disk-encryption-windows-10/) on
Windows, or [FileVault](https://support.apple.com/en-us/HT204837) on macOS.
This encrypts the entire disk with a symmetric cipher, with a key protected by
a passphrase.

## Private messaging

Use [Signal](https://signal.org/) or [Keybase](https://keybase.io/). End-to-end
security is bootstrapped from asymmetric-key encryption. Obtaining your
contacts' public keys is the critical step here. If you want good security, you
need to authenticate public keys out-of-band (with Signal or Keybase), or trust
social proofs (with Keybase).

## SSH

We've covered the use of SSH and SSH keys in an [earlier
lecture](/2020/command-line/#remote-machines). Let's look at the cryptography
aspects of this.

When you run `ssh-keygen`, it generates an asymmetric keypair, `public_key,
private_key`. This is generated randomly, using entropy provided by the
operating system (collected from hardware events, etc.). The public key is
stored as-is (it's public, so keeping it a secret is not important), but at
rest, the private key should be encrypted on disk. The `ssh-keygen` program
prompts the user for a passphrase, and this is fed through a key derivation
function to produce a key, which is then used to encrypt the private key with a
symmetric cipher.

In use, once the server knows the client's public key (stored in the
`.ssh/authorized_keys` file), a connecting client can prove its identity using
asymmetric signatures. This is done through
[challenge-response](https://en.wikipedia.org/wiki/Challenge%E2%80%93response_authentication).
At a high level, the server picks a random number and sends it to the client.
The client then signs this message and sends the signature back to the server,
which checks the signature against the public key on record. This effectively
proves that the client is in possession of the private key corresponding to the
public key that's in the server's `.ssh/authorized_keys` file, so the server
can allow the client to log in.

{% comment %}
extra topics, if there's time

security concepts, tips
- biometrics
- HTTPS
{% endcomment %}

# Resources

- [Last year's notes](/2019/security/): from when this lecture was more focused on security and privacy as a computer user
- [Cryptographic Right Answers](https://latacora.micro.blog/2018/04/03/cryptographic-right-answers.html): answers "what crypto should I use for X?" for many common X.

# Exercises

1. **Entropy.**
    1. Suppose a password is chosen as a concatenation of five lower-case
       dictionary words, where each word is selected uniformly at random from a
       dictionary of size 100,000. An example of such a password is
       `correcthorsebatterystaple`. How many bits of entropy does this have?
    1. Consider an alternative scheme where a password is chosen as a sequence
       of 8 random alphanumeric characters (including both lower-case and
       upper-case letters). An example is `rg8Ql34g`. How many bits of entropy
       does this have?
    1. Which is the stronger password?
    1. Suppose an attacker can try guessing 10,000 passwords per second. On
       average, how long will it take to break each of the passwords?
1. **Cryptographic hash functions.** Download a Debian image from a
   [mirror](https://www.debian.org/CD/http-ftp/) (e.g. [from this Argentinean
   mirror](http://debian.xfree.com.ar/debian-cd/current/amd64/iso-cd/).
   Cross-check the hash (e.g. using the `sha256sum` command) with the hash
   retrieved from the official Debian site (e.g. [this
   file](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS)
   hosted at `debian.org`, if you've downloaded the linked file from the
   Argentinean mirror).
1. **Symmetric cryptography.** Encrypt a file with AES encryption, using
   [OpenSSL](https://www.openssl.org/): `openssl aes-256-cbc -salt -in {input
   filename} -out {output filename}`. Look at the contents using `cat` or
   `hexdump`. Decrypt it with `openssl aes-256-cbc -d -in {input filename} -out
   {output filename}` and confirm that the contents match the original using
   `cmp`.
1. **Asymmetric cryptography.**
    1. Set up [SSH
       keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
       on a computer you have access to (not Athena, because Kerberos interacts
       weirdly with SSH keys). Rather than using RSA keys as in the linked
       tutorial, use more secure [ED25519
       keys](https://wiki.archlinux.org/index.php/SSH_keys#Ed25519). Make sure
       your private key is encrypted with a passphrase, so it is protected at
       rest.
    1. [Set up GPG](https://www.digitalocean.com/community/tutorials/how-to-use-gpg-to-encrypt-and-sign-messages)
    1. Send Anish an encrypted email ([public key](https://keybase.io/anish)).
    1. Sign a Git commit with `git commit -S` or create a signed Git tag with
       `git tag -s`. Verify the signature on the commit with `git show
       --show-signature` or on the tag with `git tag -v`.
