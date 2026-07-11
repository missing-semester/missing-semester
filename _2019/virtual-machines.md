---
layout: lecture
title: "Mesin Virtual dan Container"
presenter: Anish, Jon
date: 2019-01-15
order: 2
video:
  aspect: 56.25
  id: LJ9ki5zq6Ik
---

# Mesin Virtual

Mesin virtual adalah komputer simulasi. Anda dapat mengkonfigurasi guest virtual
machine dengan sistem operasi dan konfigurasi tertentu lalu menggunakannya tanpa
mempengaruhi lingkungan host Anda.

Untuk kelas ini, Anda dapat menggunakan VM untuk bereksperimen dengan sistem operasi, perangkat lunak,
dan konfigurasi tanpa risiko: Anda tidak akan mempengaruhi lingkungan pengembangan
utama Anda.

Secara umum, VM memiliki banyak kegunaan. VM sering digunakan untuk menjalankan perangkat lunak
yang hanya berjalan pada sistem operasi tertentu (misalnya menggunakan VM Windows di Linux
untuk menjalankan perangkat lunak khusus Windows). VM juga sering digunakan untuk bereksperimen dengan
perangkat lunak yang berpotensi berbahaya.

## Fitur yang Berguna

- **Isolasi**: hypervisor melakukan isolasi guest dari
host dengan cukup baik, sehingga Anda dapat menggunakan VM untuk menjalankan perangkat lunak yang buggy
atau tidak terpercaya dengan relatif aman.

- **Snapshot**: Anda dapat mengambil "snapshot" dari virtual machine Anda, menangkap
seluruh keadaan mesin (disk, memori, dll.), membuat perubahan pada mesin Anda,
dan kemudian mengembalikan ke keadaan sebelumnya. Ini berguna untuk menguji
tindakan yang berpotensi merusak, diantara hal lainnya.

## Kekurangan

Mesin virtual umumnya lebih lambat dibandingkan berjalan langsung di bare metal, sehingga mungkin
tidak cocok untuk aplikasi tertentu.

## Pengaturan

- **Sumber daya**: dibagi dengan mesin host; perhatikan hal ini saat mengalokasikan
sumber daya fisik.

- **Jaringan**: banyak opsi, NAT default seharusnya berfungsi baik untuk sebagian besar kasus
penggunaan.

- **Guest addon**: banyak hypervisor dapat menginstal perangkat lunak di guest untuk
mengaktifkan integrasi yang lebih baik dengan sistem host. Anda harus menggunakan ini jika bisa.

## Sumber Daya

- Hypervisor
    - [VirtualBox](https://www.virtualbox.org/) (open-source)
    - [Virt-manager](https://virt-manager.org/) (open-source, mengelola virtual machine KVM dan container LXC)
    - [VMWare](https://www.vmware.com/) (komersial, tersedia dari IS&T [untuk
    mahasiswa MIT](https://ist.mit.edu/vmware-fusion))

Jika Anda sudah familiar dengan hypervisor/VM populer, Anda mungkin ingin mempelajari lebih lanjut tentang cara melakukan ini melalui command line. Salah satu opsinya adalah toolkit [libvirt](https://wiki.libvirt.org/page/UbuntuKVMWalkthrough) yang memungkinkan Anda mengelola berbagai penyedia virtualisasi/hypervisor yang berbeda.

## Latihan

1. Unduh dan instal sebuah hypervisor.

1. Buat virtual machine baru dan instal distribusi Linux (misalnya
[Debian](https://www.debian.org/)).

1. Bereksperimenlah dengan snapshot. Cobalah hal-hal yang selalu ingin Anda coba, seperti
   menjalankan `sudo rm -rf --no-preserve-root /`, dan lihat apakah Anda dapat memulihkan
   dengan mudah.

1. Baca apa itu [fork-bomb](https://en.wikipedia.org/wiki/Fork_bomb) (`:(){ :|:& };:`) dan jalankan di VM untuk melihat bahwa isolasi sumber daya (CPU, Memori, dll.) berfungsi.

1. Instal guest addon dan bereksperimenlah dengan mode windowing yang berbeda,
   berbagi file, dan fitur lainnya.

# Container

Mesin Virtual relatif berat; bagaimana jika Anda ingin menjalankan
mesin secara otomatis? Masuk ke container!

 - Amazon Firecracker
 - Docker
 - rkt
 - lxc

Container _sebagian besar_ hanyalah kumpulan dari berbagai fitur keamanan Linux,
seperti virtual file system, virtual network interfaces, chroot,
trik virtual memory, dan sejenisnya, yang bersama-sama memberikan kesan
virtualisasi.

Tidak sepenuhnya seaman atau terisolasi seperti VM, tetapi cukup dekat dan semakin
baik. Biasanya berkinerja lebih tinggi, dan jauh lebih cepat untuk dimulai, tetapi tidak
selalu.

Peningkatan kinerja berasal dari fakta bahwa tidak seperti VM yang menjalankan salinan lengkap sistem operasi, container berbagi kernel Linux dengan host. Namun perhatikan bahwa jika Anda menjalankan container Linux di Windows/macOS, sebuah VM Linux perlu aktif sebagai lapisan tengah di antara keduanya.

![Docker vs VM](/2019/files/containers-vs-vms.png)
_Perbandingan antara container Docker dan Mesin Virtual. Kredit: blog.docker.com_

Container berguna ketika Anda ingin menjalankan tugas otomatis dalam
setup yang terstandarisasi:

 - Build system
 - Lingkungan pengembangan
 - Server yang sudah dikemas
 - Menjalankan program yang tidak terpercaya
    - Menilai tugas mahasiswa
    - (Beberapa) komputasi awan
 - Continuous integration
    - Travis CI
    - GitHub Actions

Selain itu, perangkat lunak container seperti Docker juga telah digunakan secara luas sebagai solusi untuk [dependency hell](https://en.wikipedia.org/wiki/Dependency_hell). Jika sebuah mesin perlu menjalankan banyak layanan dengan dependency yang bertentangan, mereka dapat diisolasi menggunakan container.

Biasanya, Anda menulis file yang mendefinisikan cara membangun container Anda.
Anda mulai dengan _base image_ minimal (seperti Alpine Linux), dan kemudian
daftar perintah untuk dijalankan guna menyiapkan lingkungan yang Anda inginkan (instal
paket, salin file, bangun proyek, tulis file konfigurasi, dll.). Biasanya,
ada juga cara untuk menentukan port eksternal yang harus
tersedia, dan _entrypoint_ yang menentukan perintah apa yang harus dijalankan
saat container dimulai (seperti script penilaian).

Dengan cara yang mirip dengan situs web repositori kode (seperti [GitHub](https://github.com/)), ada beberapa situs web repositori container (seperti [DockerHub](https://hub.docker.com/)) di mana banyak layanan perangkat lunak memiliki image yang sudah dibangun sebelumnya yang dapat dengan mudah di-deploy.

## Latihan

1. Pilih perangkat lunak container (Docker, LXC, ...) dan instal image Linux sederhana. Coba SSH ke dalamnya.

1. Cari dan unduh image container yang sudah dibangun sebelumnya untuk web server populer (nginx, apache, ...)