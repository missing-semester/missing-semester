---
layout: lecture
title: "Security and Cryptography"
description: >
  Hashes နှင့် key derivation functions ကဲ့သို့သော Cryptographic primitives များနှင့် Git၊ SSH ကဲ့သို့သော Tool များက ယင်းတို့ကို မည်သို့ သုံးစွဲပုံများ လေ့လာပါ။
thumbnail: /static/assets/thumbnails/2020/lec9.png
date: 2020-01-28
ready: true
video:
  aspect: 56.25
  id: tjwobAmnKTo
special: true
---

လွန်ခဲ့သော နှစ်၏ [လုံခြုံရေး နှင့် သီးသန့်လုံခြုံမှု သင်ခန်းစာ](/2019/security/) သည် ကွန်ပျူတာ _အသုံးပြုသူ_ တစ်ယောက်အနေဖြင့် ပိုမို လုံခြုံအောင် မည်သို့ နေထိုင်ရမည်ကို အဓိကထားခဲ့သည်။ ဤနှစ်တွင်မူ Git ရှိ Hash function များ၊ SSH ရှိ Key derivation function များနှင့် Symmetric/Asymmetric cryptosystems များကဲ့သို့ ဤအတန်းတွင် ယခင်က သင်ကြားခဲ့သော Tool များကို နားလည်စေမည့် လုံခြုံရေး နှင့် Cryptography အယူအဆများကို အဓိကထား သင်ကြားပါမည်။

ဤသင်ခန်းစာသည် ကွန်ပျူတာစနစ် လုံခြုံရေး ([6.858](https://css.csail.mit.edu/6.858/)) သို့မဟုတ် Cryptography ([6.857](https://courses.csail.mit.edu/6.857/) နှင့် 6.875) အတန်းအပြည့်အစုံအတွက် အစားထိုးခြင်း မဟုတ်ပါ။ လုံခြုံရေးနှင့် ပတ်သက်သော စနစ်တကျ သင်တန်း မတက်ရောက်ဘဲ လုံခြုံရေး အလုပ်များကို မလုပ်ဆောင်ပါနှင့်။ ကျွမ်းကျင်သူ မဟုတ်ပါက မိမိကိုယ်တိုင် [Crypto ရေးသားခြင်း မပြုပါနှင့်](https://www.schneier.com/blog/archives/2015/05/amateurs_produc.html)။ ထို စည်းမျဉ်းသည် စနစ် လုံခြုံရေးအတွက်လည်း အတူတူပင် ဖြစ်ပါသည်။

ဤသင်ခန်းစာသည် အခြေခံ Cryptography အယူအဆများကို လွတ်လပ်စွာ (သို့သော် လက်တွေ့ကျကျ) သင်ကြားထားခြင်း ဖြစ်သည်။ ဤသင်ခန်းစာသည် လုံခြုံသော စနစ်များ သို့မဟုတ် Cryptographic protocol များကို မည်သို့ _ဒီဇိုင်းထုတ်ရမည်_ ကို သင်ကြားရန် မလုံလောက်သော်လည်း သင် အသုံးပြုနေပြီးသား ပရိုဂရမ်များနှင့် Protocol များကို ယေဘုယျ နားလည်စေရန် ကူညီပေးလိမ့်မည်ဟု မျှော်လင့်ပါသည်။

# Entropy

[Entropy](https://en.wikipedia.org/wiki/Entropy_(information_theory)) ဆိုသည်မှာ ရန်ဒမ်ဖြစ်မှု (randomness) ကို တိုင်းတာခြင်း ဖြစ်သည်။ ဤသည်မှာ ဥပမာ စကားဝှက် တစ်ခု၏ ကြံ့ခိုင်မှုကို ဆုံးဖြတ်ရာတွင် အသုံးဝင်ပါသည်။

![XKCD 936: Password Strength](https://imgs.xkcd.com/comics/password_strength.png)

အထက်ပါ [XKCD comic](https://xkcd.com/936/) က သရုပ်ဖော်ထားသည့်အတိုင်း "correcthorsebatterystaple" ကဲ့သို့သော စကားဝှက်သည် "Tr0ub4dor&3" ထက် ပိုမို လုံခြုံမှု ရှိပါသည်။ သို့သော် ဤကဲ့သို့သော အရာကို မည်သို့ ပမာဏ သတ်မှတ်မနည်း။

Entropy ကို _bits_ ဖြင့် တိုင်းတာပြီး၊ ဖြစ်နိုင်ခြေရှိသော အစုအဝေးမှ ညီမျှစွာ သီးသန့် ရွေးချယ်သည့်အခါ Entropy သည် `log_2(# of possibilities)` နှင့် တူညီပါသည်။ မျှတသော အကြွေစေ့ တစ်ပြား ပစ်လိုက်ခြင်းသည် Entropy 1 bit ရရှိပါသည်။ ၆ မျက်နှာပါ အန်စာတုံး တစ်ခု ပစ်လိုက်ခြင်းသည် Entropy \~2.58 bits ရရှိပါသည်။

တိုက်ခိုက်သူသည် စကားဝှက်၏ _ပုံစံ (model)_ ကို သိရှိသော်လည်း စကားဝှက် ရွေးချယ်ရန် အသုံးပြုထားသော Random ဖြစ်မှုကို ([အန်စာတုံး ပစ်ခြင်း](https://en.wikipedia.org/wiki/Diceware) စသည်) မသိရှိပါ ဟု သတ်မှတ်ရပါမည်။

Entropy မည်မျှ လုံလောက်သနည်း။ ခြိမ်းခြောက်မှု မူဘောင်ပေါ် မူတည်ပါသည်။ အွန်လိုင်းမှ ခန့်မှန်းခြင်းအတွက် XKCD comic တွင် ထောက်ပြထားသကဲ့သို့ \~40 bits ၏ Entropy သည် အတော်အတန် ကောင်းမွန်ပါသည်။ အော့ဖ်လိုင်းမှ ခန့်မှန်းခြင်းကို ခံနိုင်ရည်ရှိစေရန် ပိုမို ခိုင်မာသော စကားဝှက် လိုအပ်ပါမည် (ဥပမာ 80 bits သို့မဟုတ် ထိုထက်ပို၍)။

# Hash functions

[cryptographic hash function](https://en.wikipedia.org/wiki/Cryptographic_hash_function) သည် မည်သည့် ဆိုဒ်ရှိမဆို အချက်အလက်များကို ပုံသေ ဆိုဒ်တစ်ခုသို့ ပြောင်းလဲပေးပြီး အထူး ဂုဏ်သတ္တိများ ရှိကြသည်။ Hash function ၏ ယေဘုယျ ပုံစံမှာ အောက်ပါအတိုင်း ဖြစ်ပါသည် -

```
hash(value: array<byte>) -> vector<byte, N>  (for some fixed N)
```

Hash function ၏ ဥပမာတစ်ခုမှာ Git တွင် အသုံးပြုထားသော [SHA1](https://en.wikipedia.org/wiki/SHA-1) ဖြစ်ပါသည်။ ၎င်းသည် မည်သည့် ဆိုဒ်ရှိမဆို Input များကို 160-bit Output (Hexadecimal စာလုံး ၄၀) အဖြစ် ပြောင်းလဲပေးသည်။ `sha1sum` command ဖြင့် Input အပေါ် SHA1 hash ကို စမ်းသပ်ကြည့်နိုင်ပါသည် -

```console
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'Hello' | sha1sum
f7ff9e8b7bb2e09b70935a5d785e0cc5d9d0abf0
```

အဆင့်မြင့် ရူထောင့်မှကြည့်လျှင် Hash function ကို ပြန်လည် ပြောင်းလဲရန် ခက်ခဲသော Random ကဲ့သို့ (သေချာသော) Function ဟု စဉ်းစားနိုင်ပါသည်။ Hash function တွင် အောက်ပါ ဂုဏ်သတ္တိများ ရှိပါသည် -

- Deterministic: တူညီသော Input သည် အမြဲတမ်း တူညီသော Output ကို ထုတ်ပေးသည်။
- Non-invertible: သီးခြား Output `h` အတွက် `hash(m) = h` ဖြစ်မည့် Input `m` ကို ရှာဖွေရန် ခက်ခဲသည်။
- Target collision resistant: Input `m_1` ဖြင့် `hash(m_1) = hash(m_2)` ဖြစ်မည့် ကွဲပြားသော Input `m_2` ကို ရှာဖွေရန် ခက်ခဲသည်။
- Collision resistant: `hash(m_1) = hash(m_2)` ဖြစ်မည့် Input နှစ်ခု `m_1` နှင့် `m_2` ကို ရှာဖွေရန် ခက်ခဲသည်။

သတိပြုရန်မှာ SHA-1 ကို ပြင်းထန်သော Cryptographic hash function တစ်ခုအဖြစ် [မသတ်မှတ်တော့ပါ](https://web.archive.org/web/20260207211148/https://shattered.io/)။
သီးခြား Hash function များကို အကြံပြုခြင်းသည် ဤသင်ခန်းစာ၏ နယ်ပယ်ထက် ကျော်လွန်ပါသည်။ လုံခြုံရေး အလုပ်များ လုပ်ဆောင်ပါက formal training ရယူရန် လိုအပ်ပါသည်။

## Applications

- Content-addressed storage အတွက် Git။ [hash function](https://en.wikipedia.org/wiki/Hash_function) ၏ အယူအဆသည် ပိုမို ယေဘုယျ ကျသည်။ Git က Cryptographic hash function ကို အဘယ်ကြောင့် သုံးသနည်း။
- ဖိုင်တစ်ခု၏ အကြောင်းအရာ အတိုချုပ်။ စော့ဖ်ဝဲလ်များကို Mirror များမှ ဒေါင်းလုဒ် ရယူလေ့ ရှိကြသဖြင့် တရားဝင် ဝဘ်ဆိုက်များက ဒေါင်းလုဒ် ဖိုင်နှင့်အတူ Hash ကို တင်ပေးထားလေ့ ရှိသည်။
- [Commitment schemes](https://en.wikipedia.org/wiki/Commitment_scheme)။ သီးခြား တန်ဖိုးတစ်ခုကို သတ်မှတ်ထားပြီး နောက်မှ ထုတ်ပြလိုသည့် အခါမျိုး ဖြစ်သည်။ ဥပမာ အကြွေစေ့ ပစ်ခြင်း။ `r = random()` ကို ရွေးပြီး `h = sha256(r)` ကို မျှဝေသည်။ အခြားသူက ခန်းမှန်းပြီးနောက် `r` ကို ထုတ်ပြ၍ စိစစ်စေသည်။

# Key derivation functions

Cryptographic hashes များနှင့် ဆက်စပ်နေသော အယူအဆတစ်ခုမှာ [key derivation functions](https://en.wikipedia.org/wiki/Key_derivation_function) (KDFs) ဖြစ်ပြီး အခြား Cryptographic algorithm များတွင် Key အဖြစ် သုံးရန် ပုံသေ အလျားရှိ Output ထုတ်ပေးခြင်း အပါအဝင် အသုံးချမှုများစွာတွင် သုံးသည်။ သာမန်အားဖြင့် အော့ဖ်လိုင်း တိုက်ခိုက်မှုများကို နှောင့်နှေးစေရန် KDF များကို တမင် နှေးကွေးအောင် ပြုလုပ်ထားသည်။

## Applications

- Passphrases မှတဆင့် အခြား Cryptographic algorithm များတွင် သုံးမည့် Key များ ထုတ်လုပ်ခြင်း။
- လော့ဂ်အင် အချက်အလက်များ သိမ်းဆည်းခြင်း။ Plaintext password များကို သိမ်းခြင်းမှာ မကောင်းပါ; User တိုင်းအတွက် Random [salt](https://en.wikipedia.org/wiki/Salt_(cryptography)) `salt = random()` ကို ထုတ်ယူ၍ `KDF(password + salt)` ကို သိမ်းဆည်းရန် ဖြစ်သည်။

# Symmetric cryptography

အကြောင်းအရာများကို ဖုံးကွယ်ခြင်းသည် Cryptography အကြောင်း စဉ်းစားလျှင် ပထမဆုံး တွေးမိသော အရာ ဖြစ်သည်။ Symmetric cryptography သည် အောက်ပါ လုပ်ဆောင်ချက်များဖြင့် ပြုလုပ်သည် -

```
keygen() -> key  (this function is randomized)

encrypt(plaintext: array<byte>, key) -> array<byte>  (the ciphertext)
decrypt(ciphertext: array<byte>, key) -> array<byte>  (the plaintext)
```

Encrypt function သည် Output (ciphertext) မှ Key မရှိဘဲ Input (plaintext) ကို ရှာဖွေရန် ခက်ခဲသော ဂုဏ်သတ္တိ ရှိသည်။ Decrypt function မူ `decrypt(encrypt(m, k), k) = m` ဖြစ်သည်။

ယနေ့ခေတ် အသုံးများသော Symmetric cryptosystem ၏ ဥပမာမှာ [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) ဖြစ်သည်။

## Applications

- မယုံကြည်ရသော Cloud service တွင် သိမ်းရန် ဖိုင်များကို Encrypt လုပ်ခြင်း။ KDF များဖြင့် တွဲဖက်၍ Passphrase ဖြင့် Encrypt လုပ်နိုင်ပါသည်။ `key = KDF(passphrase)` ထုတ်ယူ၍ `encrypt(file, key)` ကို သိမ်းသည်။

# Asymmetric cryptography

"Asymmetric" ဟု ခေါ်ဆိုရခြင်းမှာ တာဝန်ကွဲပြားသော Key နှစ်ခု ပါဝင်သောကြောင့် ဖြစ်သည်။ Private key သည် လျှို့ဝှက် ထားရမည် ဖြစ်ပြီး Public key မူ အများသို့ မျှဝေနိုင်ပြီး လုံခြုံရေးကို မထိခိုက်ပါ။ အောက်ပါ လုပ်ဆောင်ချက်များ ပါဝင်ပါသည် -

```
keygen() -> (public key, private key)  (this function is randomized)

encrypt(plaintext: array<byte>, public key) -> array<byte>  (the ciphertext)
decrypt(ciphertext: array<byte>, private key) -> array<byte>  (the plaintext)

sign(message: array<byte>, private key) -> array<byte>  (the signature)
verify(message: array<byte>, signature: array<byte>, public key) -> bool  (whether or not the signature is valid)
```

Message ကို _public_ key ဖြင့် Encrypt လုပ်နိုင်သည်၊ _private_ key မရှိဘဲ Plaintext ကို ရရှိရန် ခက်ခဲသည်။ `decrypt(encrypt(m, public key), private key) = m` ဖြစ်သည်။

Symmetric နှင့် Asymmetric ကို သော့ခလောက်များဖြင့် ယှဉ်တွဲနိုင်ပါသည်။ Symmetric သည် တံခါး သော့ခလောက်ကဲ့သို့ သော့ရှိသူတိုင်း ပိတ်/ဖွင့် နိုင်သည်။ Asymmetric မူ သော့ပါသော သော့ခလောက်ကဲ့သို့ အများသို့ သော့ခလောက် (Public key) ပေးထားပြီး သော့ (Private key) ကို မိမိတစ်ဦးတည်း ကိုင်ဆောင်ထားခြင်း ဖြစ်သည်။

Sign/verify function များသည် လက်မှတ် အတု ပြုလုပ်ရန် ခက်ခဲသော ဂုဏ်သတ္တိ ရှိသည်။ Private key မရှိဘဲ `verify(message, signature, public key)` ကို true ထွက်အောင် Signature ထုတ်ရန် ခက်ခဲသည်။ `verify(message, sign(message, private key), public key) = true` ဖြစ်သည်။

## Applications

- [PGP email encryption](https://en.wikipedia.org/wiki/Pretty_Good_Privacy)။
- သီးသန့် မက်ဆေ့ဂျ် ပို့ခြင်း ([Signal](https://signal.org/) နှင့် [Keybase](https://keybase.io/))။
- စော့ဖ်ဝဲလ် လက်မှတ်ရေးထိုးခြင်း (Git တွင် GPG-signed commits များ သုံးနိုင်သည်)။

## Key distribution

Asymmetric-key cryptography သည် အလွန် ကောင်းမွန်သော်လည်း Public key များကို လူအမှန်နှင့် တွဲဖက် ဖြန့်ဝေရန် စိန်ခေါ်မှု ရှိသည်။ Signal တွင် ပထမဆုံး အသုံးပြုမှုကို ယုံကြည်ခြင်း သို့မဟုတ် ပြင်ပမှ စိစစ်ခြင်း သုံးသည်။ PGP တွင် [web of trust](https://en.wikipedia.org/wiki/Web_of_trust) သုံးသည်။ Keybase တွင် [social proof](https://keybase.io/blog/chat-apps-softer-than-tofu) သုံးသည်။

# Case studies

## Password managers

လူတိုင်း အသုံးပြုသင့်သော Tool ဖြစ်သည် (ဥပမာ [KeePassXC](https://keepassxc.org/), [pass](https://git.zx2c4.com/password-store/about/), [1Password](https://1password.com))။ မတူညီသော စကားဝှက်များကို အသုံးပြုစေနိုင်ပြီး၊ KDF မှတဆင့် Passphrase ဖြင့် Symmetric cipher ဖြင့် ဖိုင်အဖြစ် သိမ်းဆည်းပေးသည်။

## Two-factor authentication

[Two-factor authentication](https://en.wikipedia.org/wiki/Multi-factor_authentication) (2FA) သည် စကားဝှက် ("သိထားသော အရာ") နှင့်အတူ Authenticator ("ပိုင်ဆိုင်သော အရာ") ကို တွဲဖက် အသုံးပြုစေခြင်း ဖြစ်သည်။

## Full disk encryption

ကွန်ပျူတာ အခိုးခံရပါက Data များကို ကာကွယ်ရန် Full disk encryption ကို သုံးပါ။ Linux တွင် [cryptsetup + LUKS](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_a_non-root_file_system)၊ Windows တွင် [BitLocker](https://fossbytes.com/enable-full-disk-encryption-windows-10/)၊ macOS တွင် [FileVault](https://support.apple.com/en-us/HT204837)။

## Private messaging

[Signal](https://signal.org/) သို့မဟုတ် [Keybase](https://keybase.io/) ကို သုံးပါ။ End-to-end security ကို Asymmetric key ဖြင့် စတင်တည်ဆောက်ထားသည်။

## SSH

`ssh-keygen` ရန်းသည့်အခါ Asymmetric key pair (`public_key, private_key`) ထုတ်ပေးသည်။ `ssh-keygen` က Passphrase တောင်းပြီး KDF မှတဆင့် Key ထုတ်ယူကာ Private key ကို Disc ပေါ်တွင် Encrypt လုပ်၍ သိမ်းသည်။

Server တွင် Client ၏ Public key ရှိသည့်အခါ (`.ssh/authorized_keys` တွင်)၊ Client သည် Challenge-response မှတဆင့် Asymmetric signature ဖြင့် မိမိ ပိုင်ဆိုင်ကြောင်း သက်သေပြ၍ လော့ဂ်အင် ဝင်ရောက်သည်။

# Resources

- [Last year's notes](/2019/security/)
- [Cryptographic Right Answers](https://latacora.micro.blog/2018/04/03/cryptographic-right-answers.html)

# Exercises

1. **Entropy.**
    1. စကားဝှက်တစ်ခုကို စာလုံး ၁၀၀,၀၀၀ ပါသော အဘိဓာန်မှ သီးခြား စကားလုံး ၄ ခု တွဲဖက်၍ ရွေးချယ်သည်ဆိုပါစို့ (ဥပမာ `correcthorsebatterystaple`)။ Entropy bits မည်မျှ ရှိသနည်း။
    2. စကားဝှက်တစ်ခုကို စာလုံး ၈ လုံးပါသော Random အက္ခရာ/ကိန်းဂဏန်းများဖြင့် ရွေးချယ်သည်ဆိုပါစို့ (ဥပမာ `rg8Ql34g`)။ Entropy bits မည်မျှ ရှိသနည်း။
    3. မည်သည့် စကားဝှက်က ပိုမို ခိုင်မာသနည်း။
    4. တိုက်ခိုက်သူက ၁ စက္ကန့်လျှင် စကားဝှက် ၁၀,၀၀၀ ခန့်မှန်းနိုင်ပါက၊ စကားဝှက်တစ်ခုစီကို ခန့်မှန်းမိရန် ပျမ်းမျှ အချိန်မည်မျှ ကြာမည်နည်း။
2. **Cryptographic hash functions.** Debian image တစ်ခုကို [Mirror](https://www.debian.org/CD/http-ftp/) မှ ဒေါင်းလုဒ် လုပ်ပြီး Hash စိစစ်ပါ။
3. **Symmetric cryptography.** OpenSSL ဖြင့် AES encryption သုံး၍ ဖိုင်ကို Encrypt လုပ်ပါ: `openssl aes-256-cbc -salt -in {input filename} -out {output filename}`။ `cat` သို့မဟုတ် `hexdump` ဖြင့် ကြည့်ပါ။ `openssl aes-256-cbc -d -in {input filename} -out {output filename}` ဖြင့် Decrypt ပြန်လုပ်ပြီး `cmp` ဖြင့် တူမတူ စစ်ပါ။
4. **Asymmetric cryptography.**
    1. SSH keys များ တပ်ဆင်ပါ။
    2. GPG တပ်ဆင်ပါ။
    3. Encrypted email ပို့ပါ။
    4. `git commit -S` ဖြင့် Git commit ကို Sign လုပ်ပါ။ `git show --show-signature` ဖြင့် စိစစ်ပါ။
