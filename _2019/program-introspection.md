---
layout: lecture
title: "Introspeksi Program"
presenter: Anish
date: 2019-01-29
order: 1
video:
  aspect: 62.5
  id: 74MhV-7hYzg
---

# Debugging

Ketika printf-debugging tidak cukup baik: gunakan debugger.

Debugger memungkinkan Anda berinteraksi dengan eksekusi program, memungkinkan Anda melakukan hal-hal seperti:

- menghentikan eksekusi program ketika mencapai baris tertentu
- melangkah satu per satu melalui program
- memeriksa nilai variabel
- banyak fitur lanjutan lainnya

## GDB/LLDB

[GDB](https://www.gnu.org/software/gdb/) dan [LLDB](https://lldb.llvm.org/).
Mendukung banyak bahasa mirip-C.

Mari kita lihat [example.c](/2019/files/example.c). Kompilasi dengan flag debug:
`gcc -g -o example example.c`.

Buka GDB:

`gdb example`

Beberapa perintah:

- `run`
- `b {name of function}` - set a breakpoint
- `b {file}:{line}` - set a breakpoint
- `c` - continue
- `step` / `next` / `finish` - step in / step over / step out
- `p {variable}` - print value of variable
- `watch {expression}` - set a watchpoint that triggers when the value of the expression changes
- `rwatch {expression}` - set a watchpoint that triggers when the value is read
- `layout`

## PDB

[PDB](https://docs.python.org/3/library/pdb.html) adalah debugger Python.

Sisipkan `import pdb; pdb.set_trace()` di tempat Anda ingin masuk ke PDB, pada dasarnya merupakan hibrida dari debugger (seperti GDB) dan shell Python.

## Alat Pengembang Web browser

Contoh lain dari debugger, kali ini dengan antarmuka grafis.

# strace

Amati system call yang dibuat program: `strace {program}`.

# Profiling

Jenis-jenis profiling: CPU, memori, dll.

Profiler paling sederhana: `time`.

## Go

Jalankan kode tes dengan profiler CPU: `go test -cpuprofile=cpu.out`

Analisis profil: `go tool pprof -web cpu.out`

Jalankan kode tes dengan profiler Memori: `go test -memprofile=mem.out`

Analisis profil: `go tool pprof -web mem.out`

## Perf

Statistik performa dasar: `perf stat {command}`

Jalankan program dengan profiler: `perf record {command}`

Analisis profil: `perf report`
