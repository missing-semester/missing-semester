---
layout: lecture
title: "Security and Cryptography"
description: >
  Learn about cryptographic primitives like hashes and key derivation functions, and understand how tools like Git and SSH use them.
thumbnail: /static/assets/thumbnails/2020/lec9.png
date: 2020-01-28
ready: true
video:
  aspect: 56.25
  id: tjwobAmnKTo
---
Phần học [này](/2019/security/) vào năm ngoái đã giới thiệu cho các bạn cách sử dụng máy tính một cách 
an toàn và bảo mật hơn. Năm nay, chúng tôi sẽ tập trung vào các khái niệm an toàn 
thông tin (security) và mật mã học (cryptography). Chúng sẽ giúp ta hiểu rõ thêm về các công cụ được
giới thiệu trước đây trong khóa học, ví dụ như việc dùng hàm băm (hash functions) trong
Git hoặc trong hàm tạo khóa (Key Derivation Functions), hoặc áp dụng các hệ thống mã hóa đối xứng (symmetric) và
bất đối xứng (asymmetric) trong trình SSH.

<!-- Last year's [security and privacy lecture](/2019/security/) focused on how you
can be more secure as a computer _user_. This year, we will focus on security
and cryptography concepts that are relevant in understanding tools covered
earlier in this class, such as the use of hash functions in Git or key
derivation functions and symmetric/asymmetric cryptosystems in SSH. -->

Cần lưu ý rằng phần học này không thể thay thế cho một khóa học đầy đủ và toàn diện về
an toàn máy tính ([6.858](https://css.csail.mit.edu/6.858/)) hay mã hóa học([6.857](https://courses.csail.mit.edu/6.857/) và 6.875). Đừng bao giờ đụng đến an toàn thông tinh nếu như bạn chưa hiểu về nó. 
Đặc biệt cần lưu ý đến việc [tự tạo các hàm mã hóa](https://www.schneier.com/blog/archives/2015/05/amateurs_produc.html) nếu như bạn không phải là một chuyên gia! 

<!-- This lecture is not a substitute for a more rigorous and complete course on
computer systems security ([6.858](https://css.csail.mit.edu/6.858/)) or
cryptography ([6.857](https://courses.csail.mit.edu/6.857/) and 6.875). Don't
do security work without formal training in security. Unless you're an expert,
don't [roll your own
crypto](https://www.schneier.com/blog/archives/2015/05/amateurs_produc.html).
The same principle applies to systems security.
-->

Phần học này sẽ cho bạn cái nhìn đơn giản hóa (nhưng theo tôi là thực dụng) về các khái niệm mật mã học. Phần học này là chắc chắn không đủ kiến thức để bạn có thể tư _thiết kế_ các hệ thống bảo mật và giao thức mật mã học.Tuy nhiên, chúng tôi hy vọng sẽ cho bạn kiến thức bao quát nhất về các chương trình và giao thức mà bạn đã và đang sử dụng.

<!-- This lecture has a very informal (but we think practical) treatment of basic
cryptography concepts. This lecture won't be enough to teach you how to
_design_ secure systems or cryptographic protocols, but we hope it will be
enough to give you a general understanding of the programs and protocols you
already use.
-->

# Entropy 

[Entropy](https://en.wikipedia.org/wiki/Entropy_(information_theory)) là một đơn vị đo độ hỗn độn (randomness). Nó rất hữu dụng trong việc đo lường độ mạnh của mật khẩu của bạn.

<!-- [Entropy](https://en.wikipedia.org/wiki/Entropy_(information_theory)) is a
measure of randomness. This is useful, for example, when determining the
strength of a password.
-->

![XKCD 936: Password Strength](https://imgs.xkcd.com/comics/password_strength.png)

Như bạn thấy trong truyện tranh ở trên [XKCD comic](https://xkcd.com/936/), mật khẩu "correcthorsebatterystaple" an toàn hơn mật khẩu "Tr0ub4dor&3". Làm sao ta khẳng định được điều này?

<!-- As the above [XKCD comic](https://xkcd.com/936/) illustrates, a password like
"correcthorsebatterystaple" is more secure than one like "Tr0ub4dor&3". But how
do you quantify something like this?
-->

Entropy được đo theo đơn vị _bits_, và khi được lựa một kết quả ngẫu nhiên trong phân phối đồng nhất (uniformly random), thì entropy sẽ bằng `log_2(# số kết quả có thể)`. Tung một đồng xu cho ta 1 bit entropy. Tung xúc xắc (6 mặt) cho ta khoản \~2.58 bits entropy

<!-- Entropy is measured in _bits_, and when selecting uniformly at random from a
set of possible outcomes, the entropy is equal to `log_2(# of possibilities)`.
A fair coin flip gives 1 bit of entropy. A dice roll (of a 6-sided die) has
\~2.58 bits of entropy.
-->

Chúng ta có thể giả định rằng kẻ xấu biết về _mô hình_ (model - ý nói về ký tự hợp thành mật khẩu) của mật khấu, nhưng không hề biết gì về độ ngẫu nhiên dùng để chọn mật khẩu đó.

<!-- You should consider that the attacker knows the _model_ of the password, but
not the randomness (e.g. from [dice
rolls](https://en.wikipedia.org/wiki/Diceware)) used to select a particular
password. -->

Bao nhiêu bits entropy thì là đủ? Đó hoàn toàn tùy theo mô hình mối nguy (threat model) của bạn. Đối với việc tấn công mật khẩu online (Online guessing - việc đoán mật khẩu ngay tại giao diện đăng nhập), như truyện tranh XKCD đã chỉ ra, tầm 40 bits entropy là rất tốt. Còn để phòng ngừa việc bị tấn công offline (Offline guessing - khi hacker có được một chuỗi băm của password của bạn và tìm cách giải mã nó), một mật khẩu mạnh hơn (tầm 80 bits hay hơn) là cần thiết

<!-- How many bits of entropy is enough? It depends on your threat model. For online
guessing, as the XKCD comic points out, \~40 bits of entropy is pretty good. To
be resistant to offline guessing, a stronger password would be necessary (e.g.
80 bits, or more).
-->

# Hàm băm (Hash functions)
Hàm băm mật mã học ([cryptographic hash
function](https://en.wikipedia.org/wiki/Cryptographic_hash_function)) là một hàm toán học để chuyển đổi một dữ liệu với kíck cỡ bất kỳ thành một kích cỡ được quy đinh. Hàm băm được mô tả khái quát như sau:

```
hash(value: array<byte>) -> vector<byte, N>  (với một N đã được định trước)
```

<!--
# Hash functions

A [cryptographic hash
function](https://en.wikipedia.org/wiki/Cryptographic_hash_function) maps data
of arbitrary size to a fixed size, and has some special properties. A rough
specification of a hash function is as follows:

```
hash(value: array<byte>) -> vector<byte, N>  (for some fixed N)
```
-->

Một ví dụ về hàm băm là [SHA1](https://en.wikipedia.org/wiki/SHA-1), được dùng trong Git.
Nó có thể băm nhỏ thông tin thành một chuỗi 160 bit thông tin (40 kí tự thập lục phân). 
Ta có thể thử băm SHA1 bằng câu lệnh `sha1sum`:

<!-- An example of a hash function is [SHA1](https://en.wikipedia.org/wiki/SHA-1),
which is used in Git. It maps arbitrary-sized inputs to 160-bit outputs (which
can be represented as 40 hexadecimal characters). We can try out the SHA1 hash
on an input using the `sha1sum` command:
-->

```console
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'hello' | sha1sum
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
$ printf 'Hello' | sha1sum
f7ff9e8b7bb2e09b70935a5d785e0cc5d9d0abf0
```

Một cách khái quát hơn, hàm băm là một hàm rất khó để đảo ngược (hard-to-invert), nhìn rất ngẫu nhiên (vì thêm một chữ vào chuỗi cần mã hóa sẽ tạo ra một chuỗi băm hoàn toàn khác) tuy nhiên lại tất định (deterministic). Đây là những mô tả về [mô hình hoàn hảo của hàm băm](https://en.wikipedia.org/wiki/Random_oracle). Hàm băm có những đặc tính:

<!--
At a high level, a hash function can be thought of as a hard-to-invert
random-looking (but deterministic) function (and this is the [ideal model of a
hash function](https://en.wikipedia.org/wiki/Random_oracle)). A hash function
has the following properties:
-->

- Tính tất tính (Deterministic): nếu input giống nhau thì kết quả output của hàm băm phải giống nhau.
- Tính không đảo ngược (Non-invertible): khó có thể tìm input `m` sao cho `hash(m) = h` với một kết 
quả hàm băm `h` mà ta có.
- Tính khó trùng (collision resistant): Cho input `m_1`, sẽ rất khó tìm `m_2` sao cho `hash(m_1) = hash(m_2)`.

<!--
- Deterministic: the same input always generates the same output.
- Non-invertible: it is hard to find an input `m` such that `hash(m) = h` for
some desired output `h`.
- Target collision resistant: given an input `m_1`, it's hard to find a
different input `m_2` such that `hash(m_1) = hash(m_2)`.
- Collision resistant: it's hard to find two inputs `m_1` and `m_2` such that
`hash(m_1) = hash(m_2)` (note that this is a strictly stronger property than
target collision resistance). -->

Lưu ý: mặc dù hữu dụng nhưng SHA-1 [không còn](https://shattered.io/) là một hàm băm tốt.
Bạn cũng có thể tham khảo về vòng đời của các hàm băm ở [đây](https://valerieaurora.org/hash.html).
Tuy vậy, việc lựa chọn một hàm băm tốt là hoàn toàn ngoài mục đích của phần học này. Nếu bạn
muốn hiểu thêm điều này, bạn cần phải học mật mã học hay an toàn thông tinh một cách chính quy hơn.

<!-- Note: while it may work for certain purposes, SHA-1 is [no
longer](https://shattered.io/) considered a strong cryptographic hash function.
You might find this table of [lifetimes of cryptographic hash
functions](https://valerieaurora.org/hash.html) interesting. However, note that
recommending specific hash functions is beyond the scope of this lecture. If you
are doing work where this matters, you need formal training in
security/cryptography.
-->

## Ứng Dụng
- Dùng trong Git để lưu trữ dữ liệu bằng địa chỉ (content-addressed storage). Ý tưởng về [hàm băm](https://en.wikipedia.org/wiki/Hash_function) là
một khái niệm tương đối bao quát (vì có những hàm băm không phải là hàm băm mã hóa). Vậy tại sao Git lại cần một hàm băm mã hóa?
- Dùng để rút gọn nội dung của một file. Phần mềm có thể được tải xuống từ những nguồn (nhiều khả năng là không an toàn) song song (mirrors). Ví dụ là các file ảnh Linux ISOs. Thật tốt nếu có thể kiểm chứng những file này và nguồn của chúng. Vì vậy, các trang chủ chính thức thường sẽ cung cấp các chuỗi băm (của nội dung file) cùng đường dẫn để tải chúng. Nhờ đó, ta có thể kiểm chứng sau khi đã tải các file này về.
- Dùng làm [Hệ thống chấp thuận, ủy nhiệm](https://en.wikipedia.org/wiki/Commitment_scheme). Đây là khi bạn chắc chắn muốn ủy nhiệm một giá trị nào đó và chỉ cho người khác biết một khoảng thời gian sau đó. Ví dụ khi bạn lật đồng xu "trong tâm trí" mà không có đồng xu thật được nhìn thấy và kiểm chứng bởi bạn và một bên khác. Bạn có thể lấy một giá trị `r = random()`, và chia sẻ kết quả hàm băm `h=sha256(r)`. Người thứ hai có thể sẽ đoán kết quả của việc lật đồng xu là mặt sấp (tail) hay mặt ngửa (head) (giữa hai người, có thể quy ước nếu số r là chẵn thì là mặt ngửa và lẻ thì là mặt sấp). Sau khi họ đã chọn kết quả thì bạn có thể cho họ biết giá trị đồng xu sau khi lật (trong đầu bạn) `r`. Người chơi cùng bạn có thể chắc chắn rằng bạn không khai gian bằng cách dùng hàm băm `sha256(r)` đề kiểm chứng kết quả bạn vừa nói và kết quả lúc nãy sau khi tung đồng xu là giống nhau (nếu kết quả hàm băm này và giá trị băm ủy nhiệm lúc nạy là giống nhau).

<!--
## Applications
- Git, for content-addressed storage. The idea of a [hash
function](https://en.wikipedia.org/wiki/Hash_function) is a more general
concept (there are non-cryptographic hash functions). Why does Git use a
cryptographic hash function?
- A short summary of the contents of a file. Software can often be downloaded
from (potentially less trustworthy) mirrors, e.g. Linux ISOs, and it would be
nice to not have to trust them. The official sites usually post hashes
alongside the download links (that point to third-party mirrors), so that the
hash can be checked after downloading a file.
- [Commitment schemes](https://en.wikipedia.org/wiki/Commitment_scheme).
Suppose you want to commit to a particular value, but reveal the value itself
later. For example, I want to do a fair coin toss "in my head", without a
trusted shared coin that two parties can see. I could choose a value `r =
random()`, and then share `h = sha256(r)`. Then, you could call heads or tails
(we'll agree that even `r` means heads, and odd `r` means tails). After you
call, I can reveal my value `r`, and you can confirm that I haven't cheated by
checking `sha256(r)` matches the hash I shared earlier.
-->

# Hàm tạo khóa (Key derivation functions)
Một khái niệm liên quan đến các hàm băm mật mã là các hàm tạo khóa (gọi tắt là KDF). Các hàm này được dùng 
trong nhiều ứng dụng như tạo các kết quả với cùng kich cỡ để làm khóa (key) dùng trong các thuật toán mật mã khác.
Thường thì các hàm KDF được thiết kể rất tốn thời gian và điều này giúp làm chậm hơn các cuộc tấn công offline, thử hết (brute-force).
<!--
# Key derivation functions

A related concept to cryptographic hashes, [key derivation
functions](https://en.wikipedia.org/wiki/Key_derivation_function) (KDFs) are
used for a number of applications, including producing fixed-length output for
use as keys in other cryptographic algorithms. Usually, KDFs are deliberately
slow, in order to slow down offline brute-force attacks.
-->

## Ứng Dụng
- Tạo khóa từ mật mã để dùng trong các hàm mật mã khác (ví dụ như trong mật mã đối xứng, xem phía dưới).
- Dùng trong lưu trữ thông tin đăng nhập. Lưu trữ mật khẩu chưa mã hóa là vô cùng nguy hiểm. Cách lưu trữ tốt hơn là 
tạo một chuỗi số ngẫu nhiên (gọi là muối ([salt](https://en.wikipedia.org/wiki/Salt_(cryptography)))) như `salt = random()` cho mỗi người dùng riêng biệt. Sau đó ta sẽ lưu giữ kết quả của `KDF(password + salt)` vào cơ sở dữ liệu. Khi người dùng đăng nhập, ta sẽ tra thông tin salt trong cơ sở dữ liệu và kết hợp cùng mật khẩu mà người dùng nhập để tạo kết quả bằng hàm KDF. Nếu kết quả này giống dữ liệu được lưu trữ cho người dùng thì ta cho phép họ đăng nhập.
<!--
## Applications

- Producing keys from passphrases for use in other cryptographic algorithms
(e.g. symmetric cryptography, see below).
- Storing login credentials. Storing plaintext passwords is bad; the right
approach is to generate and store a random
[salt](https://en.wikipedia.org/wiki/Salt_(cryptography)) `salt = random()` for
each user, store `KDF(password + salt)`, and verify login attempts by
re-computing the KDF given the entered password and the stored salt.
-->

# Mật mã học đối xứng
Bảo mật nội dung của một tin nhắn chắc chắn là khái niệm đầu tiên mà bạn biết về mật mã học.
Mật mã học bất đối xứng có thể làm điều này bằng các chức năng sau đây:

```
keygen() -> key  (đây là một hàm tạo số ngẫu nhiên)

encrypt(plaintext: array<byte>, key) -> array<byte>  (the ciphertext)
decrypt(ciphertext: array<byte>, key) -> array<byte>  (the plaintext)

*encrypt, decrypt là hàm mã hóa và hàm giải mã
**plaintext là nội dung chưa mã hóa
***ciphertext là nội dung mã hóa
```

Hàm mã hóa có tính chất là nếu biết kết quả mã hóa, sẽ rất khó để đoán nội dung chưa mã hóa nếu không
có khóa dùng trong mã hóa. Hàm giải mã thì chắc chắn phải có tính chất `decrypt(encrypt(m, k), k) = m`.

Một ví dụ về mật mã đối xứng là [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard).

<!--
# Symmetric cryptography

Hiding message contents is probably the first concept you think about when you
think about cryptography. Symmetric cryptography accomplishes this with the
following set of functionality:

```
keygen() -> key  (this function is randomized)

encrypt(plaintext: array<byte>, key) -> array<byte>  (the ciphertext)
decrypt(ciphertext: array<byte>, key) -> array<byte>  (the plaintext)
```

The encrypt function has the property that given the output (ciphertext), it's
hard to determine the input (plaintext) without the key. The decrypt function
has the obvious correctness property, that `decrypt(encrypt(m, k), k) = m`.

An example of a symmetric cryptosystem in wide use today is
[AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard).
-->

## Ứng Dụng

- Mã hóa các file để lưu trữ trên dịch vụ đám mây không đáng tin cậy. Việc này có thể được kết hợp với 
hàm tạo khóa KDF và như vậy bạn có thể bảo mật file bằng một mật khẩu của mình. Điều này được thực hiện 
bằng cách tạo khóa `key = KDF(mật khẩu)` rồi lưu giữ `encrypt(file, key)`.

<!--
## Applications

- Encrypting files for storage in an untrusted cloud service. This can be
combined with KDFs, so you can encrypt a file with a passphrase. Generate `key
= KDF(passphrase)`, and then store `encrypt(file, key)`.
-->

# Mật mã học bất đối xứng
Thuật ngữ "bất đối xứng" nhắc đến việc phương pháp này cần hai chìa khóa với hai chứng năng khác nhau.
Loại thứ nhất là chìa khóa riêng (private key), cần được giữ bí mật. Loại còn lại là chìa khóa chung 
và có thể được chia sẻ một cách thoải mái và không hề ảnh hưởng đến bảo mật thông tin (khác với việc không 
được chia sẻ chìa khóa trong bảo mật đối xứng). Mật mã bất đối xứng gồm các hàm sau để mã hóa/ giải mã hay 
để kí/ xác nhận chữ kí:

```
keygen() -> (public key, private key)  (đây là một hàm tạo số ngẫu nhiên)

encrypt(plaintext: array<byte>, public key) -> array<byte>  (the ciphertext)
decrypt(ciphertext: array<byte>, private key) -> array<byte>  (the plaintext)

sign(message: array<byte>, private key) -> array<byte>  (the signature)
verify(message: array<byte>, signature: array<byte>, public key) -> bool  (true nếu chữ kí là là xác thực và ngược lại là false)

*signature là chữ kí số
```
<!--
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
-->

Hàm encrypt/decrypt có chức năng như trong mật mã học đối xứng. Tin nhắn có thể được mã hóa
bằng chìa khóa _chung_. Kết quả mã hóa sau đó sẽ khó được sử sụng để đoán nội dung chưa được mã hóa nếu ta không 
có chìa khóa _riêng_. Hàm giải mã có thuộc tính `decrypt(encrypt(m, public key), private key) = m`.

<!-- The encrypt/decrypt functions have properties similar to their analogs from
symmetric cryptosystems. A message can be encrypted using the _public_ key.
Given the output (ciphertext), it's hard to determine the input (plaintext)
without the _private_ key. The decrypt function has the obvious correctness
property, that `decrypt(encrypt(m, public key), private key) = m`. -->

Mật mã học đối xứng và bất đối xứng có thể được hiểu như các loại khóa ngoài đời thực.
Mật mã học đối xứng thì giống như khóa cửa: ai có khóa thì khóa/ mở khóa được.
Còn bất đối xứng thì như loại khóa số: bạn có thể đưa ổ khóa số đã mở cho ai đó (chìa khóa
chung), họ sẽ cho tin nhắn vào trong hộp và khóa lại bằng ổ này, sau đó chỉ có bạn - người biết mật mã 
(chìa khóa riêng) có thể mở được ổ khóa.

<!-- Symmetric and asymmetric encryption can be compared to physical locks. A
symmetric cryptosystem is like a door lock: anyone with the key can lock and
unlock it. Asymmetric encryption is like a padlock with a key. You could give
the unlocked lock to someone (the public key), they could put a message in a
box and then put the lock on, and after that, only you could open the lock
because you kept the key (the private key).
-->

Hàm kí và xác nhận chữ kí thì có tác dụng như chữ kí tay của chúng ta. Sẽ rất khó để nhái chữ kí.
Không cần biết nội dung của tin nhắn, nếu không có chìa khóa _riêng_, sẽ rất khó để tạo ra một chữ kí
số để kết quả của hàm `verify(message, signature, public key)` là true. Và tất nhiên, hàm xác thực chữ kí
có tính chất đúng đắn sau: `verify(message,
sign(message, private key), public key) = true`.

<!--
The sign/verify functions have the same properties that you would hope physical
signatures would have, in that it's hard to forge a signature. No matter the
message, without the _private_ key, it's hard to produce a signature such that
`verify(message, signature, public key)` returns true. And of course, the
verify function has the obvious correctness property that `verify(message,
sign(message, private key), public key) = true`.
-->

## Ứng dụng
- [Bảo mật thư điện tử PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy). Người dùng thư có
thể thông báo chìa khóa chung trên mạng online (như trong một máy chủ PGP, hoặc trên trang web 
như [Keybase](https://keybase.io/)). Ai cũng có thể gửi thư mã hóa đến người dùng.
- Bảo mật tin nhắn. Những ứng dụng như [Signal](https://signal.org/) and
[Keybase](https://keybase.io/) dùng mật mã bất đối xứng để tạo các kênh liên lạc bí mật.
- Kí phần mềm. Git có thể dùng chữ kí số GPG để kí các commits và tags. Với một chìa khóa chung
được thông báo rộng rãi, ai cũng có thể kiểm chứng về độ xác thực về những phần mềm mà họ sẽ tải xuống.

<!--
## Applications

- [PGP email encryption](https://en.wikipedia.org/wiki/Pretty_Good_Privacy).
People can have their public keys posted online (e.g. in a PGP keyserver, or on
[Keybase](https://keybase.io/)). Anyone can send them encrypted email.
- Private messaging. Apps like [Signal](https://signal.org/) and
[Keybase](https://keybase.io/) use asymmetric keys to establish private
communication channels.
- Signing software. Git can have GPG-signed commits and tags. With a posted
public key, anyone can verify the authenticity of downloaded software.
-->

## Truyền dẫn chìa khóa
Bảo mật bất đối xứng thật sự tuyệt vời, nhưng đi cùng với nó là những thách thức 
trong việc chia sẻ khóa chung hay việc định danh khóa chung với một đối tượng đời thực. 
Có rất nhiều lời giải cho bài toán này. Ứng dụng nhắn tin Signal có một lời giải đơn giản: tin tưởng 
trong lần dùng đầu và cho phép trao đổi chìa khóa chung ngoài luồng (bạn phải tự xác thực số điện thoại của
đối tượng bạn nhắn tin ngoài đời). PGP thì có một phương pháp khác, gọi là "mạng lưới của sự tin cậy" 
([web of trust](https://en.wikipedia.org/wiki/Web_of_trust)). Keybase thì lại có một lời giải khác cho việc chứng thực xã hội ([social
proof](https://keybase.io/blog/chat-apps-softer-than-tofu)). Mỗi phương pháp có cái hay riêng; 
chúng tôi - những người tạo khóa học này thì thích cách của Keybase nhất.
<!--
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
-->

# Case studies

## Phần mềm quản lý mật khẩu
Đây là một công cụ hữu dụng mà mỗi người nên thử (vài ví dụ như [KeePassXC](https://keepassxc.org/), 
[pass](https://www.passwordstore.org/),hay [1Password](https://1password.com)). Những phần mềm này 
cho bạn sự tiện lợi để tạo các mật khẩu an toàn với entropy cao cho mỗi tài khoản đăng nhập. Chúng còn có thể lưu giữ 
các mật khẩu của bạn cùng một chỗ với bảo mật bằng mật mã đối xứng cùng chìa khóa tạo ra từ các hàm KDF và
mật khẩu mà bạn cung cấp.

Dùng các chương trình này cũng hạn chế việc lập lại mật khẩu (giúp bạn an toàn hơn khi một trong những trang
web có cùng mật khẩu bị tấn công). Điều tốt hơn nữa là bạn chỉ cần phải nhớ một mật khẩu an toàn duy nhất.

<!--
## Password managers

This is an essential tool that everyone should try to use (e.g.
[KeePassXC](https://keepassxc.org/), [pass](https://git.zx2c4.com/password-store/about/),
and [1Password](https://1password.com)). Password managers make it convenient to use unique,
randomly generated high-entropy passwords for all your logins, and they save
all your passwords in one place, encrypted with a symmetric cipher with a key
produced from a passphrase using a KDF.

Using a password manager lets you avoid password reuse (so you're less impacted
when websites get compromised), use high-entropy passwords (so you're less likely to
get compromised), and only need to remember a single high-entropy password.
-->

## Bảo mật hai lớp (2FA)
Phương pháp [bảo mật 2 lớp](https://en.wikipedia.org/wiki/Multi-factor_authentication) yêu cầu
bạn dùng một mật khẩu ("cái bạn biết") cùng với một trình xác thực 2FA (như [YubiKey](https://www.yubico.com/) - 
"cái bạn sở hữu") để bảo vệ bạn khỏi việc bị ăn cắp mật khẩu và các cuộc tấn công giả mạo ([phishing](https://en.wikipedia.org/wiki/Phishing)).
<!--
## Two-factor authentication

[Two-factor
authentication](https://en.wikipedia.org/wiki/Multi-factor_authentication)
(2FA) requires you to use a passphrase ("something you know") along with a 2FA
authenticator (like a [YubiKey](https://www.yubico.com/), "something you have")
in order to protect against stolen passwords and
[phishing](https://en.wikipedia.org/wiki/Phishing) attacks.
-->

## Mã hóa ổ cứng
Mã hóa toàn bộ ổ đĩa của máy tính của bạn là một cách bảo vệ thông tin của bạn dễ dàng
trong trường hợp bị mất cắp. Bạn có thể dùng [cryptsetup +
LUKS](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_a_non-root_file_system)
trên Linux, [BitLocker](https://fossbytes.com/enable-full-disk-encryption-windows-10/) trên
Windows, hoặc [FileVault](https://support.apple.com/en-us/HT204837) trên macOS. Những
trình này sẽ mã hóa nguyên ổ đĩa bằng mật mã đối xứng với chìa khóa được bảo vệ bằng mật khẩu của
bạn.
<!--

## Full disk encryption

Keeping your laptop's entire disk encrypted is an easy way to protect your data
in the case that your laptop is stolen. You can use [cryptsetup +
LUKS](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_a_non-root_file_system)
on Linux,
[BitLocker](https://fossbytes.com/enable-full-disk-encryption-windows-10/) on
Windows, or [FileVault](https://support.apple.com/en-us/HT204837) on macOS.
This encrypts the entire disk with a symmetric cipher, with a key protected by
a passphrase.
-->

## Tin nhắn bảo mật
Dùng [Signal](https://signal.org/) hay [Keybase](https://keybase.io/). Đây là những chương trình được bảo 
mật theo qui trình đầu cuối (end-to-end) bằng phương pháp mã hóa bất đối xứng. Tuy nhiên việc lấy chìa
khóa chung từ đối tác của bạn là cái đáng nói ở đây. Nếu bạn muốn bảo mật tốt, bạn cần xác thực chìa khóa
chung của đối tác ngoài luồng trao đổi ngoài đời thực (với Signal hay Keybase), hoặc phải tin tưởng bằng
chứng minh xã hội (social proofs - với Keybase).
<!--
## Private messaging

Use [Signal](https://signal.org/) or [Keybase](https://keybase.io/). End-to-end
security is bootstrapped from asymmetric-key encryption. Obtaining your
contacts' public keys is the critical step here. If you want good security, you
need to authenticate public keys out-of-band (with Signal or Keybase), or trust
social proofs (with Keybase).
-->

## SSH

Chúng tôi đã có bài học về SSH và chìa khóa trong SSH ở một bài học [trước](/2020/command-line/#remote-machines).
Bây giờ hãy phân tích về mặt mật mã học của vấn đề này.

Khi bạn chạy trình `ssh-keygen`, nó sẽ tạo một cặp khóa bất đối xứng, `public_key,
private_key`. Chúng được tạo lập một cách hoàn toàn ngẫu nhiên, bằng entropy được
cung cấp từ hệ điều hành (từ nhũng hoạt động phần cứng, v.v.). Chìa khóa chung
thì được lưu giữ nguyên vẹn vì nó không cần phải bí mật. Còn chìa khóa riêng thì cần được bảo mật 
trên ổ cứng của bạn. Vì vậy `ssh-keygen` sẽ đòi hỏi người dùng cung cấp một mật khẩu và
dùng nó để tạo một chìa khóa mới dùng để mã hóa chìa khóa riêng bằng bảo mật đối xứng.

<!--

We've covered the use of SSH and SSH keys in an [earlier
lecture](/2020/command-line/#remote-machines). Let's look at the cryptography
aspects of this.

When you run `ssh-keygen`, it generates an asymmetric key pair, `public_key,
private_key`. This is generated randomly, using entropy provided by the
operating system (collected from hardware events, etc.). The public key is
stored as-is (it's public, so keeping it a secret is not important), but at
rest, the private key should be encrypted on disk. The `ssh-keygen` program
prompts the user for a passphrase, and this is fed through a key derivation
function to produce a key, which is then used to encrypt the private key with a
symmetric cipher.
-->

Trong thực tế, một khi máy chủ biết chìa khóa chung của máy người dùng (được lưu giữ trong `.ssh/authorized_keys`),
máy người dùng kết nối có thể chứng minh danh tính bằng chữ kí bất đối xứng. Việc này được thực hiện qua quy trình
[thách đố-chứng minh (challenge-respone) ](https://en.wikipedia.org/wiki/Challenge%E2%80%93response_authentication).
Quy trình này được hiểu khái quát là khi máy chủ gửi một số ngẫu nhiên đến máy đầu cuối của người dùng. Máy này sẽ
kí tin nhắn và gửi lại máy chủ, nơi kiểm chứng chữ kí với các chìa khóa chung mà nó lưu giữ sẽ được diễn ra. Nếu thành công,
việc này sẽ chứng minh rằng máy đẩu cuối đang nắm giữ chìa khóa riêng thuộc cùng cặp với chìa khóa chung mà máy chủ đang
lưu giữ trong file `.ssh/authorized_keys` của máy chủ. Kết quả là máy chủ SSH chấp thuận cho máy người dùng đăng nhập vào.

<!--
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
-->

{% comment %}
extra topics, if there's time

security concepts, tips
- biometrics
- HTTPS
{% endcomment %}

# Một vài thông tin hữu dụng
- [Bài học năm ngoái](/2019/security/): khi chúng tôi tập trung về vấn đề an toàn và bảo mật theo cách nhìn của người dùng máy tính nhiều hơn.
- [Những câu trả lời đúng về mật mã học](https://latacora.micro.blog/2018/04/03/cryptographic-right-answers.html): những câu trả lời cho việc dùng thuật toán nào cho X,
với vô vàn vấn đề X thông dụng.

<!--
# Resources

- [Last year's notes](/2019/security/): from when this lecture was more focused on security and privacy as a computer user
- [Cryptographic Right Answers](https://latacora.micro.blog/2018/04/03/cryptographic-right-answers.html): answers "what crypto should I use for X?" for many common X.
-->

# Bài tập

1. **Entropy**
   1. Cho mật khẩu được cấu thành từ 4 từ viết thường trong từ điển Anh Ngữ. Biết rằng mỗi từ được lựa
   một cách ngẫu, đều nhau từ từ điển 100,000 từ. Ví dụ là "correcthorsebatterystaple`. Entropy của mật khẩu này là bao nhiêu bits?
   1. Cho một cách chọn mật khẩu khác trên: tạo mật khẩu dài 8 kí tự (cả hoa cả thường). Ví dụ như `rg8Ql34g`. Mật khẩu này có entropy là bao nhiêu?
   1. Trong hai mật khẩu trên, cái nào bảo mật hơn?
   1. Nếu hacker có thể đoán được 10,000 mật khẩu mỗi giây, sẽ mất bao lâu để đoán được các mật khẩu trên?

1. **Hàm băm mật mã**: Tải file hình của Debian từ một link [phụ](https://www.debian.org/CD/http-ftp/) (ví dụ từ [máy chủ Argentina](http://debian.xfree.com.ar/debian-cd/current/amd64/iso-cd/)) Kiểm chứng kết quả hàm băm (từ câu lệnh `sha256sum`) với kết quả băm được đăng trên trang chủ chính thức của Debian (file [này](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS) được lưu giữ trên `debian.org`, nếu bạn đã tải file trên đường link phụ của Argentina).

1. **Mật mã đối xứng** Mã hóa một file bằng AES qua câu lệnh [OpenSSL](https://www.openssl.org/): `openssl aes-256-cbc -salt -in {input filename} -out {output filename}`. Hãy xem nội dung file mã hóa bằng `cat` hay `hexdump`. Sau đó giải mã file bằng `openssl aes-256-cbc -d -in {input filename} -out {output filename}` và kiểm tra xem nội dung trước khi mã hóa và sau giải mã là giống nhau (bằng câu lệnh `cmp`).

1. **Mật mã bất đối xứng**
   1. Hãy cài đặt [chìa khóa SSH](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2) trên một máy tính mà bạn có thể đăng nhập được. Hãy chắc chắn rằng chìa khóa riêng của bạn được mã hóa bằng một mật khẩu.
   1. [Cài đặt GPG](https://www.digitalocean.com/community/tutorials/how-to-use-gpg-to-encrypt-and-sign-messages)
   1. Gửi Anish một thư điện tử bảo mật qua [chìa khóa chung](https://keybase.io/anish)
   1. Kí một commit trong Git với `git commit -S` hay tạo một Git tag với chữ kí bằng `git tag -s`. Xác thực chữ kí này trên commit bằng `git show --show-signature` hoặc trên tag bằng `git tag -v`.

<!--   
# Exercises

1. **Entropy.**
    1. Suppose a password is chosen as a concatenation of four lower-case
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
   mirror](http://debian.xfree.com.ar/debian-cd/current/amd64/iso-cd/)).
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
       weirdly with SSH keys). Make sure
       your private key is encrypted with a passphrase, so it is protected at
       rest.
    1. [Set up GPG](https://www.digitalocean.com/community/tutorials/how-to-use-gpg-to-encrypt-and-sign-messages)
    1. Send Anish an encrypted email ([public key](https://keybase.io/anish)).
    1. Sign a Git commit with `git commit -S` or create a signed Git tag with
       `git tag -s`. Verify the signature on the commit with `git show
       --show-signature` or on the tag with `git tag -v`.
-->