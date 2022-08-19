Xin cám ơn quý bạn vì đã cân nhắc đóng góp cho project dịch thuật này!

# Pull Request và Issues
Mọi đóng góp về dịch thuật cho repository này cần phải được làm thông qua các Pull Request.
Để pull request, bạn cần fork repository này, tạo một branch mới, thực hiện việc thay đổi và
mở PR trên giao diện của GitHub.

Khi mở PR, xin lưu ý là PR này sẽ để merge vào `master` branch của repo `missing-semester-vn.github.io`!

# Lưu ý về format dịch thuật
## Tiếng Việt trước, tiếng Anh theo sau
Khi dịch thuật, bạn cần chuyển phần chữ tiếng Anh gốc thành comment để ta có thể theo dõi những thay đổi 
về nội dung của repo gốc dễ dàng hơn (đây là một forked repo từ bản missing-semester gốc). Bạn có thể dùng dấu
`<!-- English original content -->` để comment như ví dụ (đã lược dịch trong [security.md](_2020/security.md)) sau:

```
...
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
...
```

## Chuyển nghĩa tiếng Việt cho các từ tiếng Anh
Khi bắt gặp các từ chuyên nghành học thuật bằng tiếng Anh, chúng ta sẽ:
- chuyển nghĩa tiếng Việt cho lần gặp đầu tiên
- dùng từ tiếng Anh cho phần còn lại của bài dịch.

Ví dụ:
```
... version control systems (trình quản lý phiên bản) ...
```