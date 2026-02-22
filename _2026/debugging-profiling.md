---
layout: lecture
title: "ಡಿಬಗ್ಗಿಂಗ್ ಮತ್ತು ಪ್ರೊಫೈಲಿಂಗ್"
description: >
  ಲಾಗಿಂಗ್ ಮತ್ತು ಡಿಬಗ್ಗರ್‌ಗಳನ್ನು ಬಳಸಿ ಪ್ರೋಗ್ರಾಂಗಳನ್ನು ಹೇಗೆ ಡಿಬಗ್ ಮಾಡುವುದು, ಮತ್ತು ಕಾರ್ಯಕ್ಷಮತಿಗಾಗಿ ಕೋಡ್ ಅನ್ನು ಹೇಗೆ ಪ್ರೊಫೈಲ್ ಮಾಡುವುದು ಎಂಬುದನ್ನು ಕಲಿಯಿರಿ.
thumbnail: /static/assets/thumbnails/2026/lec4.png
date: 2026-01-15
ready: true
panopto: "https://mit.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=a72c48e3-5eb2-46fa-aa03-b3b700e1ca8d"
video:
  aspect: 56.25
  id: 8VYT9TcUmKs
---

ಪ್ರೋಗ್ರಾಮಿಂಗ್‌ನಲ್ಲಿನ ಒಂದು ಸುವರ್ಣ ನಿಯಮವೆಂದರೆ: ಕೋಡ್ ನೀವು ನಿರೀಕ್ಷಿಸುವುದನ್ನು ಮಾಡುವುದಿಲ್ಲ, ನೀವು ಅದಕ್ಕೆ ಹೇಳಿದುದನ್ನೇ ಮಾಡುತ್ತದೆ. ಈ ಅಂತರವನ್ನು ಭರ್ತಿಮಾಡುವುದು ಕೆಲವೊಮ್ಮೆ ಬಹಳ ಕಷ್ಟಕರವಾಗಿರಬಹುದು. ಈ ಉಪನ್ಯಾಸದಲ್ಲಿ ದೋಷಯುಕ್ತ ಮತ್ತು ಸಂಪನ್ಮೂಲ-ಆಹಾರಿ ಕೋಡ್‌ನೊಂದಿಗೆ ಕೆಲಸ ಮಾಡಲು ಉಪಯುಕ್ತ ತಂತ್ರಗಳನ್ನು ನೋಡೋಣ: ಡಿಬಗ್ಗಿಂಗ್ ಮತ್ತು ಪ್ರೊಫೈಲಿಂಗ್.

# ಡಿಬಗ್ಗಿಂಗ್

## Printf ಡಿಬಗ್ಗಿಂಗ್ ಮತ್ತು ಲಾಗಿಂಗ್

> "The most effective debugging tool is still careful thought, coupled with judiciously placed print statements" - Brian Kernighan, _Unix for Beginners_.

ಒಂದು ಪ್ರೋಗ್ರಾಂ ಅನ್ನು ಡಿಬಗ್ ಮಾಡಲು ಮೊದಲ ವಿಧಾನವೆಂದರೆ, ಸಮಸ್ಯೆಯನ್ನು ಕಂಡುಹಿಡಿದ ಸ್ಥಳದ ಸುತ್ತಲೂ print statements ಸೇರಿಸಿ, ಸಮಸ್ಯೆಗೆ ಕಾರಣವೇನು ಎಂಬುದನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಲು ಸಾಕಷ್ಟು ಮಾಹಿತಿ ದೊರೆಯುವವರೆಗೆ ಅದನ್ನು ಮರುಮರು ಪ್ರಯತ್ನಿಸುವುದು.

ಎರಡನೇ ವಿಧಾನವೆಂದರೆ ad hoc print statements ಬದಲು ನಿಮ್ಮ ಪ್ರೋಗ್ರಾಂನಲ್ಲಿ logging ಬಳಸುವುದು. Logging ಎಂದರೆ ಮೂಲತಃ "ಹೆಚ್ಚು ಜಾಗ್ರತೆಯಿಂದ print ಮಾಡುವುದು", ಮತ್ತು ಸಾಮಾನ್ಯವಾಗಿ ಇದನ್ನು logging framework ಮೂಲಕ ಮಾಡಲಾಗುತ್ತದೆ. ಇವು ಸಾಮಾನ್ಯವಾಗಿ ಕೆಳಗಿನಂತಿರುವ built-in ಬೆಂಬಲವನ್ನು ಒಳಗೊಂಡಿರುತ್ತವೆ:

- ಲಾಗ್‌ಗಳನ್ನು (ಅಥವಾ ಲಾಗ್‌ಗಳ ಉಪಸಮೂಹಗಳನ್ನು) ಬೇರೆ output ಸ್ಥಳಗಳಿಗೆ ಕಳುಹಿಸುವ ಸಾಮರ್ಥ್ಯ;
- ತೀವ್ರತಾ ಮಟ್ಟಗಳನ್ನು (INFO, DEBUG, WARN, ERROR ಮುಂತಾದವು) ಹೊಂದಿಸಿ, ಅವುಗಳ ಆಧಾರದ ಮೇಲೆ output ಅನ್ನು ಫಿಲ್ಟರ್ ಮಾಡುವ ಸಾಮರ್ಥ್ಯ; ಮತ್ತು
- log entries ಗೆ ಸಂಬಂಧಿಸಿದ ಡೇಟಾವನ್ನು structured logging ರೂಪದಲ್ಲಿ ಉಳಿಸುವ ಬೆಂಬಲ, ಇದರಿಂದ ನಂತರ ಅವನ್ನು ಸುಲಭವಾಗಿ ಹೊರತೆಗೆಯಬಹುದು.

ಸಾಮಾನ್ಯವಾಗಿ, ಡಿಬಗ್ಗಿಂಗ್‌ಗೆ ಬೇಕಾದ ಮಾಹಿತಿ ಮುಂಚೆಯೇ ಲಭ್ಯವಾಗಲೆಂದು ನೀವು ಪ್ರೋಗ್ರಾಮಿಂಗ್ ಮಾಡುವಾಗಲೇ logging statements ಅನ್ನು ಪ್ರೋಆಕ್ಟಿವ್ ಆಗಿ ಸೇರಿಸುತ್ತೀರಿ.
ಮತ್ತು ನಿಜಕ್ಕೂ, print statements ಬಳಸಿ ಸಮಸ್ಯೆಯನ್ನು ಕಂಡು ಸರಿಪಡಿಸಿದ ನಂತರ, ಅವನ್ನು ತೆಗೆದುಹಾಕುವ ಮೊದಲು ಸರಿಯಾದ log statements ಆಗಿ ಪರಿವರ್ತಿಸುವುದು ಬಹಳ ಉಪಯುಕ್ತ.
ಈ ವಿಧಾನದಿಂದ ಮುಂದೆಯೂ ಹೋಲುವ ದೋಷಗಳು ಕಂಡುಬಂದರೆ,
ಕೋಡ್ ಅನ್ನು ತಿದ್ದುಪಡಿ ಮಾಡದೇ ನಿಮಗೆ ಬೇಕಾದ diagnostic ಮಾಹಿತಿ ಈಗಾಗಲೇ ಲಭ್ಯವಾಗಿರುತ್ತದೆ.

> **Third-party logs**: ಅನೇಕ ಪ್ರೋಗ್ರಾಂಗಳು ಚಾಲನೆಯಲ್ಲಿರುವಾಗ ಹೆಚ್ಚಿನ ಮಾಹಿತಿಯನ್ನು ಮುದ್ರಿಸಲು `-v` ಅಥವಾ `--verbose` flag ಅನ್ನು ಬೆಂಬಲಿಸುತ್ತವೆ. ನಿರ್ದಿಷ್ಟ command ಏಕೆ ವಿಫಲವಾಗುತ್ತಿದೆ ಎಂಬುದನ್ನು ತಿಳಿಯಲು ಇದು ಉಪಯುಕ್ತವಾಗಬಹುದು. ಕೆಲವು ಪ್ರೋಗ್ರಾಂಗಳು ಹೆಚ್ಚಿನ ವಿವರಗಳಿಗೆ flag ಅನ್ನು ಮರುಮರು ನೀಡಲು ಸಹ ಅವಕಾಶ ಕೊಡುತ್ತವೆ. services (databases, web servers, ಇತ್ಯಾದಿ) ಗೆ ಸಂಬಂಧಿಸಿದ ಸಮಸ್ಯೆಗಳನ್ನು ಡಿಬಗ್ ಮಾಡುವಾಗ, ಅವುಗಳ logs ಪರಿಶೀಲಿಸಿ - Linux ನಲ್ಲಿ ಸಾಮಾನ್ಯವಾಗಿ `/var/log/` ನಲ್ಲಿ ಇರುತ್ತವೆ. systemd services ಗಳ log ವೀಕ್ಷಿಸಲು `journalctl -u <service>` ಬಳಸಿ. third-party libraries ಗಾಗಿ, environment variables ಅಥವಾ configuration ಮೂಲಕ debug logging ಬೆಂಬಲವಿದೆಯೇ ಎಂದು ನೋಡಿ.

## ಡಿಬಗ್ಗರ್‌ಗಳು

ನೀವು ಏನು print ಮಾಡಬೇಕು ಎಂದು ತಿಳಿದಿದ್ದಾಗ ಮತ್ತು ಕೋಡ್ ಅನ್ನು ಸುಲಭವಾಗಿ ತಿದ್ದುಪಡಿ ಮಾಡಿ ಮರುಚಾಲನೆ ಮಾಡಬಹುದಾಗಿದ್ದಾಗ print debugging ಉತ್ತಮವಾಗಿ ಕೆಲಸ ಮಾಡುತ್ತದೆ. ಆದರೆ ಯಾವ ಮಾಹಿತಿ ಬೇಕು ಎಂಬುದು ಸ್ಪಷ್ಟವಿಲ್ಲದಾಗ, ದೋಷವು ಪುನರುತ್ಪಾದಿಸಲು ಕಷ್ಟವಾದ ಸಂದರ್ಭಗಳಲ್ಲಿ ಮಾತ್ರ ಕಾಣಿಸಿಕೊಂಡಾಗ, ಅಥವಾ ಪ್ರೋಗ್ರಾಂ ತಿದ್ದುಪಡಿ ಮಾಡಿ ಮರುಪ್ರಾರಂಭಿಸುವುದು ದುಬಾರಿಯಾದಾಗ (ಉದಾ: ದೀರ್ಘ startup ಸಮಯ, ಮರುಸೃಷ್ಟಿಸಲು ಕಷ್ಟವಾದ ಸ್ಥಿತಿ) debuggers ಬಹಳ ಮೌಲ್ಯಮಯವಾಗುತ್ತವೆ.

ಡಿಬಗ್ಗರ್‌ಗಳು ಪ್ರೋಗ್ರಾಂ ಕಾರ್ಯಗತಗೊಳ್ಳುವ ಸಂದರ್ಭದಲ್ಲಿ ಅದರೊಂದಿಗೆ ಸಂವಹನ ಮಾಡಲು ಅವಕಾಶ ನೀಡುವ ಸಾಧನಗಳು. ಇವುಗಳ ಮೂಲಕ ನೀವು:

- ನಿರ್ದಿಷ್ಟ ಸಾಲಿಗೆ ತಲುಪಿದಾಗ ಕಾರ್ಯಗತಗೊಳಿಸುವಿಕೆಯನ್ನು ನಿಲ್ಲಿಸಬಹುದು.
- ಒಂದೊಂದು instruction ಅನ್ನು ಹಂತ ಹಂತವಾಗಿ ನಡೆಸಬಹುದು.
- crash ನಂತರ variable ಮೌಲ್ಯಗಳನ್ನು ಪರಿಶೀಲಿಸಬಹುದು.
- ನಿರ್ದಿಷ್ಟ condition ಸತ್ಯವಾದಾಗ ಮಾತ್ರ ಕಾರ್ಯಗತಗೊಳಿಸುವಿಕೆಯನ್ನು ನಿಲ್ಲಿಸಬಹುದು.
- ಮತ್ತು ಇನ್ನೂ ಅನೇಕ ಸುಧಾರಿತ ವೈಶಿಷ್ಟ್ಯಗಳನ್ನು ಬಳಸಬಹುದು.

ಬಹುತೇಕ programming languages ಗಳು debugger‌ನ ಯಾವುದೋ ರೂಪವನ್ನು ಬೆಂಬಲಿಸುತ್ತವೆ (ಅಥವಾ ಅದೊಂದಿಗೇ ಬರುತ್ತವೆ). ಅತ್ಯಂತ ಬಹುಮುಖವಾದವು **general-purpose debuggers** ಆಗಿರುವ [`gdb`](https://www.gnu.org/software/gdb/) (GNU Debugger) ಮತ್ತು [`lldb`](https://lldb.llvm.org/) (LLVM Debugger), ಇವು ಯಾವುದೇ native binary ಅನ್ನು ಡಿಬಗ್ ಮಾಡಬಲ್ಲವು. ಅನೇಕ ಭಾಷೆಗಳಿಗೆ runtime ಜೊತೆಗೆ ಹೆಚ್ಚು ಒಗ್ಗೂಡುವ **language-specific debuggers** ಕೂಡ ಇವೆ (ಉದಾ: Python‌ನ pdb, Java‌ನ jdb).

`gdb` C, C++, Rust ಮತ್ತು ಇತರೆ compiled languages ಗಾಗಿ de-facto standard debugger ಆಗಿದೆ. ಇದು ಯಾವುದಾದರೂ process ಅನ್ನು ಪರಿಶೀಲಿಸಲು ಮತ್ತು ಅದರ ಪ್ರಸ್ತುತ machine state - registers, stack, program counter ಮುಂತಾದವುಗಳನ್ನು - ತಿಳಿಯಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ.

ಕೆಲವು ಉಪಯುಕ್ತ GDB commands:

- `run` - ಪ್ರೋಗ್ರಾಂ ಪ್ರಾರಂಭಿಸು
- `b {function}` ಅಥವಾ `b {file}:{line}` - breakpoint ಹೊಂದಿಸು
- `c` - ಕಾರ್ಯಗತಗೊಳಿಸುವಿಕೆ ಮುಂದುವರಿಸು
- `step` / `next` / `finish` - ಒಳಗೆ ಹೋಗು / ಮೇಲಿಂದ ಮುಂದುವರಿಸು / ಹೊರಗೆ ಬಾ
- `p {variable}` - variable ಮೌಲ್ಯ ಮುದ್ರಿಸು
- `bt` - backtrace (call stack) ತೋರಿಸು
- `watch {expression}` - ಮೌಲ್ಯ ಬದಲಾಗುವಾಗ break ಆಗು

> source code ಮತ್ತು command prompt ಅನ್ನು split-screen ನಲ್ಲಿ ನೋಡಲು GDBಯ TUI mode (`gdb -tui` ಅಥವಾ GDB ಒಳಗೆ `Ctrl-x a`) ಬಳಸುವುದನ್ನು ಪರಿಗಣಿಸಿ.

### Record-Replay ಡಿಬಗ್ಗಿಂಗ್

ಕೆಲವು ಅತ್ಯಂತ ಕಿರಿಕಿರಿ ಉಂಟುಮಾಡುವ ದೋಷಗಳು _Heisenbugs_ ಆಗಿರುತ್ತವೆ: ಅವನ್ನು ಗಮನಿಸಲು ಪ್ರಯತ್ನಿಸಿದಾಗ ಅವು ಕಾಣೆಯಾಗುವುದು ಅಥವಾ ವರ್ತನೆ ಬದಲಾಗುವುದು. race conditions, timing-dependent bugs, ಮತ್ತು ನಿರ್ದಿಷ್ಟ system ಪರಿಸ್ಥಿತಿಗಳಲ್ಲಿ ಮಾತ್ರ ಕಾಣಿಸಿಕೊಳ್ಳುವ ಸಮಸ್ಯೆಗಳು ಈ ವರ್ಗಕ್ಕೆ ಸೇರುತ್ತವೆ. ಇಂತಹ ಸಂದರ್ಭಗಳಲ್ಲಿ ಪರಂಪರागत ಡಿಬಗ್ಗಿಂಗ್ ಹೆಚ್ಚಾಗಿ ಫಲಕಾರಿಯಾಗುವುದಿಲ್ಲ, ಏಕೆಂದರೆ ಪ್ರೋಗ್ರಾಂ ಅನ್ನು ಮತ್ತೆ ಓಡಿಸಿದಾಗ ವರ್ತನೆ ಬದಲಾಗಿರುತ್ತದೆ (ಉದಾ: print statements ಕಾರಣದಿಂದ code ನಿಧಾನವಾಗಿ ಓಡಿ race ನಡೆಯದೇ ಇರಬಹುದು).

**Record-replay debugging** ಈ ಸಮಸ್ಯೆಗೆ ಪರಿಹಾರ ನೀಡುತ್ತದೆ: ಪ್ರೋಗ್ರಾಂ ಕಾರ್ಯಗತಗೊಳಿಸುವಿಕೆಯನ್ನು ದಾಖಲಿಸಿ, ಅದನ್ನು deterministic ರೀತಿಯಲ್ಲಿ ಬೇಕಾದಷ್ಟು ಬಾರಿ replay ಮಾಡಲು ಅವಕಾಶ ನೀಡುತ್ತದೆ. ಇನ್ನೂ ಉತ್ತಮವೆಂದರೆ, ಕಾರ್ಯಗತಗೊಳಿಸುವಿಕೆಯಲ್ಲಿ _ಹಿಂದಕ್ಕೆ_ ಹೋಗಿ ದೋಷ ಎಲ್ಲಿ ಸಂಭವಿಸಿತು ಎಂಬುದನ್ನು ಖಚಿತವಾಗಿ ಕಂಡುಹಿಡಿಯಬಹುದು.

[rr](https://rr-project.org/) Linux ಗಾಗಿ ಶಕ್ತಿಶಾಲಿ ಸಾಧನವಾಗಿದೆ. ಇದು ಪ್ರೋಗ್ರಾಂ ಕಾರ್ಯಗತಗೊಳಿಸುವಿಕೆಯನ್ನು ದಾಖಲಿಸಿ, ಸಂಪೂರ್ಣ debugging ಸಾಮರ್ಥ್ಯಗಳೊಂದಿಗೆ deterministic replay ಮಾಡಲು ಅವಕಾಶ ನೀಡುತ್ತದೆ. ಇದು GDB ಜೊತೆ ಕೆಲಸ ಮಾಡುವುದರಿಂದ, interface ಈಗಾಗಲೇ ಪರಿಚಿತವಾಗಿರುತ್ತದೆ.

ಮೂಲ ಬಳಕೆ:

```bash
# Record a program execution
rr record ./my_program

# Replay the recording (opens GDB)
rr replay
```

ನಿಜವಾದ ಶಕ್ತಿ replay ವೇಳೆ ಗೋಚರಿಸುತ್ತದೆ. ಕಾರ್ಯಗತಗೊಳಿಸುವಿಕೆ deterministic ಆಗಿರುವುದರಿಂದ, ನೀವು **reverse debugging** commands ಬಳಸಬಹುದು:

- `reverse-continue` (`rc`) - breakpoint ತಲುಪುವವರೆಗೆ ಹಿಂದಕ್ಕೆ ಓಡು
- `reverse-step` (`rs`) - ಒಂದು ಸಾಲು ಹಿಂದಕ್ಕೆ ಹಂತ ಹಾಕು
- `reverse-next` (`rn`) - function calls ಬಿಟ್ಟು ಹಿಂದಕ್ಕೆ ಹಂತ ಹಾಕು
- `reverse-finish` - ಪ್ರಸ್ತುತ function ಗೆ ಪ್ರವೇಶಿಸುವವರೆಗೆ ಹಿಂದಕ್ಕೆ ಓಡು

ಡಿಬಗ್ಗಿಂಗ್‌ಗಾಗಿ ಇದು ಅತ್ಯಂತ ಶಕ್ತಿಯುತ ವಿಧಾನವಾಗಿದೆ. ಉದಾಹರಣೆಗೆ crash ಆಗಿದೆ ಎಂದ್ಕೊಳ್ಳಿ - ದೋಷ ಎಲ್ಲಿರಬಹುದು ಎಂದು ಊಹಿಸಿ breakpoints ಹಾಕುವುದಕ್ಕೆ ಬದಲು, ನೀವು:

1. crash ವರೆಗೆ ಓಡಿಸಿ
2. corrupted state ಪರಿಶೀಲಿಸಿ
3. corrupted variable ಮೇಲೆ watchpoint ಹೊಂದಿಸಿ
4. `reverse-continue` ಬಳಸಿ ಅದು ಎಲ್ಲಿ corrupt ಆಯಿತು ಎಂದು ಖಚಿತವಾಗಿ ಕಂಡುಹಿಡಿಯಿರಿ

**rr ಅನ್ನು ಯಾವಾಗ ಬಳಸಬೇಕು:**
- ಮಧ್ಯಂತರವಾಗಿ ವಿಫಲವಾಗುವ flaky tests
- race conditions ಮತ್ತು threading bugs
- ಪುನರುತ್ಪಾದಿಸಲು ಕಷ್ಟವಾದ crashes
- "ಸಮಯದಲ್ಲಿ ಹಿಂದೆ ಹೋಗಬಹುದೇ?" ಎಂದು ನೀವು ಬಯಸುವ ಯಾವುದೇ bug

> ಗಮನಿಸಿ: rr Linux ನಲ್ಲಿ ಮಾತ್ರ ಕೆಲಸ ಮಾಡುತ್ತದೆ ಮತ್ತು hardware performance counters ಅಗತ್ಯವಿರುತ್ತವೆ. ಈ counters ಅನ್ನು expose ಮಾಡದ VMಗಳಲ್ಲಿ (ಉದಾ: ಬಹುತೇಕ AWS EC2 instances) ಇದು ಕೆಲಸ ಮಾಡುವುದಿಲ್ಲ, ಮತ್ತು GPU access ಗೆ ಬೆಂಬಲವಿಲ್ಲ. macOSಗಾಗಿ [Warpspeed](https://warpspeed.dev/) ನೋಡಿ.

> **rr ಮತ್ತು concurrency**: rr ಕಾರ್ಯಗತಗೊಳಿಸುವಿಕೆಯನ್ನು deterministicವಾಗಿ ದಾಖಲಿಸುವುದರಿಂದ, ಇದು thread scheduling ಅನ್ನು serialize ಮಾಡುತ್ತದೆ. ಅಂದರೆ ನಿರ್ದಿಷ್ಟ timing ಮೇಲೆ ಅವಲಂಬಿತವಾಗಿರುವ ಕೆಲವು race conditions rr ಅಡಿ ಕಾಣಿಸದೇ ಇರಬಹುದು. ಆದರೂ rr race debugging ಗೆ ಉಪಯುಕ್ತವೇ - ಒಮ್ಮೆ failing run ಅನ್ನು capture ಮಾಡಿದರೆ ಅದನ್ನು ವಿಶ್ವಾಸಾರ್ಹವಾಗಿ replay ಮಾಡಬಹುದು - ಆದರೆ intermittent bug ಹಿಡಿಯಲು ಹಲವು recording ಪ್ರಯತ್ನಗಳು ಬೇಕಾಗಬಹುದು. concurrency ಸೇರದ ದೋಷಗಳಿಗೆ rr ಅತ್ಯಂತ ಉತ್ತಮ: ನೀವು ಅದೇ ಕಾರ್ಯಗತಗೊಳಿಸುವಿಕೆಯನ್ನು ಎಂದಿಗೂ ಪುನರುತ್ಪಾದಿಸಿ reverse debugging ಮೂಲಕ corruption ಹಂತವರೆಗೆ ತಲುಪಬಹುದು.

## System Call ಟ್ರೇಸಿಂಗ್

ಕೆಲವೊಮ್ಮೆ ನಿಮ್ಮ ಪ್ರೋಗ್ರಾಂ operating system ಜೊತೆ ಹೇಗೆ ಸಂವಹನ ಮಾಡುತ್ತದೆ ಎಂಬುದನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಬೇಕಾಗುತ್ತದೆ. ಪ್ರೋಗ್ರಾಂಗಳು kernel ನಿಂದ ಸೇವೆಗಳನ್ನು ಕೇಳಲು [system calls](https://en.wikipedia.org/wiki/System_call) ಮಾಡುತ್ತವೆ - files ತೆರೆಯುವುದು, memory allocate ಮಾಡುವುದು, processes ರಚಿಸುವುದು ಮುಂತಾದವು. ಈ calls ಅನ್ನು trace ಮಾಡುವುದರಿಂದ ಪ್ರೋಗ್ರಾಂ ಏಕೆ hang ಆಗುತ್ತಿದೆ, ಯಾವ files ಅನ್ನು access ಮಾಡಲು ಪ್ರಯತ್ನಿಸುತ್ತಿದೆ, ಅಥವಾ ಯಾವ ಸ್ಥಳದಲ್ಲಿ ಕಾಯುವಿಕೆಯಲ್ಲಿ ಸಮಯ ಕಳೆಯುತ್ತಿದೆ ಎಂಬುದು ಗೊತ್ತಾಗಬಹುದು.

### strace (Linux) ಮತ್ತು dtruss (macOS)

[`strace`](https://www.man7.org/linux/man-pages/man1/strace.1.html) ಪ್ರೋಗ್ರಾಂ ಮಾಡುವ ಪ್ರತಿಯೊಂದು system call ಅನ್ನು ಗಮನಿಸಲು ಅವಕಾಶ ನೀಡುತ್ತದೆ:

```bash
# Trace all system calls
strace ./my_program

# Trace only file-related calls
strace -e trace=file ./my_program

# Follow child processes (important for programs that start other programs)
strace -f ./my_program

# Trace a running process
strace -p <PID>

# Show timing information
strace -T ./my_program
```

> macOS ಮತ್ತು BSD ಯಲ್ಲಿ, ಸಮಾನ ಕಾರ್ಯಕ್ಷಮತೆಗೆ [`dtruss`](https://www.manpagez.com/man/1/dtruss/) (ಇದು `dtrace` ಅನ್ನು wrap ಮಾಡುತ್ತದೆ) ಬಳಸಿ:

> `strace` ಕುರಿತು ಇನ್ನಷ್ಟು ಆಳವಾಗಿ ತಿಳಿಯಲು Julia Evans ಅವರ ಅತ್ಯುತ್ತಮ [strace zine](https://jvns.ca/strace-zine-unfolded.pdf) ನೋಡಿ.

### bpftrace ಮತ್ತು eBPF

[eBPF](https://ebpf.io/) (extended Berkeley Packet Filter) Linux ನಲ್ಲಿನ ಶಕ್ತಿಶಾಲಿ ತಂತ್ರಜ್ಞಾನವಾಗಿದೆ; ಇದು kernel ಒಳಗೆ sandboxed programs ಓಡಿಸಲು ಅವಕಾಶ ಮಾಡುತ್ತದೆ. [`bpftrace`](https://github.com/iovisor/bpftrace) eBPF programs ಬರೆಯಲು high-level syntax ಒದಗಿಸುತ್ತದೆ. ಇವು kernel ನಲ್ಲಿ ನಡೆಯುವ arbitrary programs ಆಗಿರುವುದರಿಂದ, ಅವುಗಳಿಗೆ ದೊಡ್ಡ ಮಟ್ಟದ expressive power ಇದೆ (ಆದರೆ ಸ್ವಲ್ಪ awk-like ಅಸೌಕರ್ಯಕರ syntax ಸಹ ಇದೆ). ಇವುಗಳ ಸಾಮಾನ್ಯ ಬಳಕೆ ಪ್ರಕರಣವೆಂದರೆ ಯಾವ system calls invoke ಆಗುತ್ತಿವೆ ಎಂಬುದನ್ನು ಪರಿಶೀಲಿಸುವುದು - aggregations (ಉದಾ: counts ಅಥವಾ latency statistics) ಸೇರಿದಂತೆ - ಅಥವಾ system call arguments ಅನ್ನು introspect (ಅಥವಾ filter) ಮಾಡುವುದು.

```bash
# Trace file opens system-wide (prints immediately)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_openat { printf("%s %s\n", comm, str(args->filename)); }'

# Count system calls by name (prints summary on Ctrl-C)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_* { @[probe] = count(); }'
```

ಆದರೆ, [`bcc`](https://github.com/iovisor/bcc) போன்ற toolchain ಬಳಸಿ eBPF programs ಅನ್ನು ನೇರವಾಗಿ C ಯಲ್ಲಿ ಬರೆಯಬಹುದು. ಇದರಲ್ಲಿ `biosnoop` (disk operations ಗೆ latency distributions ಮುದ್ರಿಸಲು) ಅಥವಾ `opensnoop` (open files ಎಲ್ಲವನ್ನೂ ಮುದ್ರಿಸಲು) ಮುಂತಾದ [ಬಹಳ ಉಪಯುಕ್ತ ಸಾಧನಗಳು](https://www.brendangregg.com/blog/2015-09-22/bcc-linux-4.3-tracing.html) ಕೂಡ ದೊರಕುತ್ತವೆ.

`strace` ನ ಲಾಭವೆಂದರೆ ಅದನ್ನು ತಕ್ಷಣವೇ ಸುಲಭವಾಗಿ ಪ್ರಾರಂಭಿಸಬಹುದು. ಆದರೆ ಕಡಿಮೆ overhead ಬೇಕಾದಾಗ, kernel functions ಮೂಲಕ trace ಮಾಡಬೇಕಾದಾಗ, ಅಥವಾ ಯಾವುದಾದರೂ aggregation ಬೇಕಾದಾಗ `bpftrace` ಅನ್ನು ಬಳಸುವುದು ಸೂಕ್ತ. ಆದರೆ `bpftrace` ಅನ್ನು `root` ಆಗಿ ಓಡಿಸಬೇಕು, ಹಾಗೂ ಇದು ಸಾಮಾನ್ಯವಾಗಿ ನಿರ್ದಿಷ್ಟ process ಮಾತ್ರವಲ್ಲದೆ ಸಂಪೂರ್ಣ kernel ಅನ್ನು monitor ಮಾಡುತ್ತದೆ ಎಂಬುದನ್ನು ಗಮನಿಸಿ. ನಿರ್ದಿಷ್ಟ program ಗುರಿಯಾಗಬೇಕಾದರೆ command name ಅಥವಾ PID ಆಧಾರವಾಗಿ filter ಮಾಡಬಹುದು:

```bash
# Filter by command name (prints summary on Ctrl-C)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_* /comm == "bash"/ { @[probe] = count(); }'

# Trace a specific command from startup using -c (cpid = child PID)
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_* /pid == cpid/ { @[probe] = count(); }' -c 'ls -la'
```

`-c` flag ನಿರ್ದಿಷ್ಟ command ಅನ್ನು ಓಡಿಸಿ ಅದರ PID ಅನ್ನು `cpid` ಗೆ ಹೊಂದಿಸುತ್ತದೆ. ಪ್ರೋಗ್ರಾಂ ಪ್ರಾರಂಭವಾದ ಕ್ಷಣದಿಂದ trace ಮಾಡಲು ಇದು ಉಪಯುಕ್ತ. trace ಆಗುತ್ತಿರುವ command ಮುಗಿದ ನಂತರ bpftrace aggregated ಫಲಿತಾಂಶಗಳನ್ನು ಮುದ್ರಿಸುತ್ತದೆ.

### ನೆಟ್ವರ್ಕ್ ಡಿಬಗ್ಗಿಂಗ್

ನೆಟ್ವರ್ಕ್ ಸಮಸ್ಯೆಗಳಿಗಾಗಿ [`tcpdump`](https://www.man7.org/linux/man-pages/man1/tcpdump.1.html) ಮತ್ತು [Wireshark](https://www.wireshark.org/) ಬಳಸಿ network packets capture ಮಾಡಿ ವಿಶ್ಲೇಷಿಸಬಹುದು:

```bash
# Capture packets on port 80
sudo tcpdump -i any port 80

# Capture and save to file for Wireshark analysis
sudo tcpdump -i any -w capture.pcap
```

HTTPS traffic ಗಾಗಿ encryption ಇರುವುದರಿಂದ tcpdump ಕಡಿಮೆ ಉಪಯುಕ್ತವಾಗಬಹುದು. [mitmproxy](https://mitmproxy.org/) போன்ற tools intercepting proxy ಆಗಿ ಕೆಲಸಮಾಡಿ encrypted traffic ಪರಿಶೀಲಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತವೆ. web applications ನ HTTPS requests ಡಿಬಗ್ ಮಾಡಲು browser developer tools (Network tab) ಸಾಮಾನ್ಯವಾಗಿ ಸುಲಭ ವಿಧಾನವಾಗಿದೆ - ಇವು decrypted request/response data, headers, ಮತ್ತು timing ತೋರಿಸುತ್ತವೆ.

## ಮೆಮೊರಿ ಡಿಬಗ್ಗಿಂಗ್

buffer overflows, use-after-free, memory leaks ಮುಂತಾದ memory bugs ಅತ್ಯಂತ ಅಪಾಯಕಾರಿ ಮತ್ತು ಡಿಬಗ್ ಮಾಡಲು ಕಷ್ಟವಾದವುಗಳಾಗಿವೆ. ಇವು ತಕ್ಷಣ crash ಆಗದೇ, ನಂತರದ ಹಂತಗಳಲ್ಲಿ ಸಮಸ್ಯೆ ಉಂಟುಮಾಡುವ ರೀತಿಯಲ್ಲಿ memory ಅನ್ನು ಹಾಳುಮಾಡಬಹುದು.

### Sanitizers

memory bugs ಹುಡುಕುವ ಒಂದು ವಿಧಾನವೆಂದರೆ **sanitizers** ಬಳಸುವುದು. ಇವು compiler ವೈಶಿಷ್ಟ್ಯಗಳು; runtime ನಲ್ಲಿ errors ಪತ್ತೆಹಚ್ಚಲು ನಿಮ್ಮ code ಅನ್ನು instrument ಮಾಡುತ್ತವೆ. ಉದಾಹರಣೆಗೆ ವ್ಯಾಪಕವಾಗಿ ಬಳಕೆಯಲ್ಲಿರುವ **AddressSanitizer (ASan)** ಕೆಳಗಿನ ದೋಷಗಳನ್ನು ಪತ್ತೆಹಚ್ಚುತ್ತದೆ:
- Buffer overflows (stack, heap, ಮತ್ತು global)
- Use-after-free
- Use-after-return
- Memory leaks

```bash
# Compile with AddressSanitizer
gcc -fsanitize=address -g program.c -o program
./program
```

ಉಪಯುಕ್ತವಾದ ಹಲವು sanitizers ಲಭ್ಯವಿವೆ:

- **ThreadSanitizer (TSan)**: multithreaded code ನಲ್ಲಿ data races ಪತ್ತೆಹಚ್ಚುತ್ತದೆ (`-fsanitize=thread`)
- **MemorySanitizer (MSan)**: uninitialized memory ಓದುಗಳನ್ನು ಪತ್ತೆಹಚ್ಚುತ್ತದೆ (`-fsanitize=memory`)
- **UndefinedBehaviorSanitizer (UBSan)**: integer overflow ಮುಂತಾದ undefined behavior ಪತ್ತೆಹಚ್ಚುತ್ತದೆ (`-fsanitize=undefined`)

sanitizers ಬಳಸಲು recompilation ಅಗತ್ಯ, ಆದರೆ CI pipelines ಮತ್ತು ದೈನಂದಿನ development ನಲ್ಲಿ ಬಳಕೆಗೆ ಸಾಕಷ್ಟು ವೇಗವಾಗಿವೆ.

### Valgrind: ಮರುಸಂಕಲನ ಸಾಧ್ಯವಿಲ್ಲದಾಗ

[Valgrind](https://valgrind.org/) memory errors ಪತ್ತೆಹಚ್ಚಲು ನಿಮ್ಮ ಪ್ರೋಗ್ರಾಂ ಅನ್ನು virtual machine ಗೆ ಸಮಾನವಾದ ನಿಯಂತ್ರಿತ ಪರಿಸರದಲ್ಲಿ ಓಡಿಸುತ್ತದೆ. sanitizers ಗಿಂತ ನಿಧಾನ, ಆದರೆ recompilation ಅಗತ್ಯವಿಲ್ಲ:

```bash
valgrind --leak-check=full ./my_program
```

ಈ ಸಂದರ್ಭಗಳಲ್ಲಿ Valgrind ಬಳಸಿ:
- source code ಇಲ್ಲದಿದ್ದಾಗ
- ಮರುಸಂಕಲನ ಮಾಡಲು ಆಗದಿದ್ದಾಗ (third-party libraries)
- sanitizers ರೂಪದಲ್ಲಿ ಲಭ್ಯವಿಲ್ಲದ ನಿರ್ದಿಷ್ಟ tools ಬೇಕಾದಾಗ

Valgrind ನಿಜವಾಗಿ ಬಹಳ ಶಕ್ತಿಯುತ ನಿಯಂತ್ರಿತ execution environment ಆಗಿದೆ. profiling ವಿಭಾಗಕ್ಕೆ ಬಂದಾಗ ಇದರ ಬಗ್ಗೆ ಇನ್ನಷ್ಟು ನೋಡುತ್ತೇವೆ.

## ಡಿಬಗ್ಗಿಂಗ್‌ಗಾಗಿ AI

Large language models ಪರಂಪರಾಗತ tools ಗೆ ಪೂರಕವಾಗುವ ರೀತಿಯಲ್ಲಿ ಆಶ್ಚರ್ಯಕರವಾಗಿ ಉಪಯುಕ್ತ debugging assistants ಆಗಿವೆ. ನಿರ್ದಿಷ್ಟ ರೀತಿಯ debugging ಕಾರ್ಯಗಳಲ್ಲಿ ಇವು ಹೆಚ್ಚು ಪರಿಣಾಮಕಾರಿ.

**LLMs ಉತ್ತಮವಾಗಿ ನೆರವಾಗುವ ಸ್ಥಳಗಳು:**

- **ಗುಂಗುರುವ error messages ವಿವರಣೆ**: Compiler errors - ವಿಶೇಷವಾಗಿ C++ templates ಅಥವಾ Rust borrow checker ನವು - ಬಹಳ ಗೂಢವಾಗಿರಬಹುದು. LLMs ಅವನ್ನು ಸರಳ ಭಾಷೆಗೆ ಅನುವಾದಿಸಿ ತಿದ್ದುಪಡಿ ಸಲಹೆಗಳನ್ನು ನೀಡಬಹುದು.

- **ಭಾಷೆ ಮತ್ತು abstraction ಗಡಿಗಳನ್ನು ದಾಟುವುದು**: ಹಲವು ಭಾಷೆಗಳನ್ನು ಅಡ್ಡಬರುವ ದೋಷವನ್ನು (ಉದಾ: Python binding ಮೂಲಕ ಕಾಣಿಸಿಕೊಳ್ಳುವ C library ದೋಷ) ಡಿಬಗ್ ಮಾಡುತ್ತಿರುವಾಗ, LLMs ವಿಭಿನ್ನ ಪದರಗಳನ್ನು ಅನ್ವೇಷಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತವೆ. FFI boundaries, build system issues, ಮತ್ತು cross-language debugging ನಲ್ಲಿ ಇವು ವಿಶೇಷವಾಗಿ ಉತ್ತಮ (ಉದಾ: ನನ್ನ ಪ್ರೋಗ್ರಾಂ ದೋಷ ತೋರಿಸುತ್ತದೆ, ಆದರೆ ಅದು dependency ಯ ದೋಷ ಎಂದು ನಾನು ನಂಬುತ್ತೇನೆ).

- **ಲಕ್ಷಣಗಳು ಮತ್ತು ಮೂಲ ಕಾರಣಗಳ ನಡುವೆ ಸಂಬಂಧ ಕಂಡುಹಿಡಿಯುವುದು**: "ನನ್ನ ಪ್ರೋಗ್ರಾಂ ಸರಿಯಾಗಿ ಕೆಲಸ ಮಾಡುತ್ತದೆ ಆದರೆ ನಿರೀಕ್ಷಿತಕ್ಕಿಂತ 10x memory ಹೆಚ್ಚು ಬಳಕೆ ಮಾಡುತ್ತಿದೆ" ಎಂಬಂತ ಅಸ್ಪಷ್ಟ ಲಕ್ಷಣಗಳನ್ನು ಪರಿಶೀಲಿಸಲು LLMs ಸಾಧ್ಯ ಕಾರಣಗಳು ಮತ್ತು ಯಾವ ಅಂಶಗಳನ್ನು ಪರೀಕ್ಷಿಸಬೇಕು ಎಂಬುದರ ಬಗ್ಗೆ ದಿಕ್ಕು ತೋರಿಸುತ್ತವೆ.

- **crash dumps ಮತ್ತು stack traces ವಿಶ್ಲೇಷಣೆ**: stack trace ಅಂಟಿಸಿ, ಅದಕ್ಕೆ ಸಾಧ್ಯ ಕಾರಣಗಳ ಬಗ್ಗೆ ಪ್ರಶ್ನಿಸಬಹುದು.

> **debug symbols ಬಗ್ಗೆ ಗಮನಿಸಿ**: ಅರ್ಥಪೂರ್ಣ stack traces ಮತ್ತು debugging ಗಾಗಿ, binaries (ಮತ್ತು link ಆಗಿರುವ libraries) debug symbols (`-g` flag) ಜೊತೆ compile ಆಗಿರುವುದನ್ನು ಖಚಿತಪಡಿಸಿ. debug ಮಾಹಿತಿ ಸಾಮಾನ್ಯವಾಗಿ DWARF format ನಲ್ಲಿ ಸಂಗ್ರಹವಾಗಿರುತ್ತದೆ. ಜೊತೆಗೆ frame pointers (`-fno-omit-frame-pointer`) ಜೊತೆ compile ಮಾಡಿದರೆ stack traces ಹೆಚ್ಚು ವಿಶ್ವಾಸಾರ್ಹವಾಗುತ್ತವೆ - ವಿಶೇಷವಾಗಿ profiling tools ಗಾಗಿ. ಇಲ್ಲದಿದ್ದರೆ stack traces ನಲ್ಲಿ memory addresses ಮಾತ್ರ ಕಾಣಿಸಬಹುದು ಅಥವಾ ಅವು ಅಪೂರ್ಣವಾಗಿರಬಹುದು. ಇದು Python ಅಥವಾ Java ಗಿಂತ native compiled programs (C++, Rust) ಗಾಗಿ ಹೆಚ್ಚು ಮಹತ್ವದ್ದಾಗಿದೆ.

**ಗಮನದಲ್ಲಿರಬೇಕಾದ ಮಿತಿಗಳು:**
- LLMs ಯುಕ್ತಿಯುಕ್ತವಾಗಿ ಕೇಳಿಸಬಹುದಾದರೂ ತಪ್ಪಾದ ವಿವರಣೆಗಳನ್ನು (hallucinations) ನೀಡಬಹುದು
- ಅವು ದೋಷವನ್ನು ಸರಿಪಡಿಸುವ ಬದಲು ಅದನ್ನು ಮಸುಕಾಗಿಸುವ ತಿದ್ದುಪಡಿಗಳನ್ನು ಸೂಚಿಸಬಹುದು
- ಸಲಹೆಗಳನ್ನು ಯಾವಾಗಲೂ ನೈಜ debugging tools ಬಳಸಿ ಪರಿಶೀಲಿಸಿ
- ಇವು ನಿಮ್ಮ code ಅರಿವಿಗೆ ಪರ್ಯಾಯವಲ್ಲ; ಪೂರಕ ಮಾತ್ರ

> ಇದು Development Environment ಉಪನ್ಯಾಸದಲ್ಲಿ ಒಳಗೊಂಡಿರುವ [general AI coding capabilities](/2026/development-environment/#ai-powered-development) ಇಂದ ಭಿನ್ನವಾಗಿದೆ. ಇಲ್ಲಿ ನಾವು ವಿಶೇಷವಾಗಿ LLMs ಅನ್ನು debugging ನೆರವಿಗಾಗಿ ಬಳಸುವ ಬಗ್ಗೆ ಮಾತನಾಡುತ್ತಿದ್ದೇವೆ.

# ಪ್ರೊಫೈಲಿಂಗ್

ನಿಮ್ಮ code ಕಾರ್ಯಾತ್ಮಕವಾಗಿ ಸರಿಯಾಗಿದ್ದರೂ, ಅದೇ ಸಮಯದಲ್ಲಿ ಎಲ್ಲ CPU ಅಥವಾ memory ಸಂಪನ್ಮೂಲಗಳನ್ನು ಉಪಯೋಗಿಸಿದರೆ ಅದು ಸಾಕಾಗುವುದಿಲ್ಲ. algorithms ತರಗತಿಗಳು ಸಾಮಾನ್ಯವಾಗಿ big _O_ notation ಅನ್ನು ಕಲಿಸುತ್ತವೆ, ಆದರೆ ನಿಮ್ಮ ಪ್ರೋಗ್ರಾಂಗಳಲ್ಲಿ hot spots ಹೇಗೆ ಕಂಡುಹಿಡಿಯುವುದು ಎಂಬುದನ್ನು ಕಲಿಸುವುದಿಲ್ಲ. [premature optimization is the root of all evil](https://wiki.c2.com/?PrematureOptimization) ಎಂಬುದರಿಂದ, profilers ಮತ್ತು monitoring tools ಬಗ್ಗೆ ಕಲಿಯುವುದು ಮುಖ್ಯ. ಇವು ನಿಮ್ಮ ಪ್ರೋಗ್ರಾಂನ ಯಾವ ಭಾಗಗಳಲ್ಲಿ ಹೆಚ್ಚು ಸಮಯ ಮತ್ತು/ಅಥವಾ ಸಂಪನ್ಮೂಲ ಬಳಕೆಯಾಗುತ್ತಿದೆ ಎಂಬುದನ್ನು ತಿಳಿಸಿ, ನೀವು ಸುಧಾರಣೆಗೊಳಿಸಬೇಕಾದ ಭಾಗಗಳ ಮೇಲೆ ಕೇಂದ್ರೀಕರಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತವೆ.

## ಸಮಯ ಮಾಪನ

ಕಾರ್ಯಕ್ಷಮತೆ ಅಳೆಯುವ ಅತ್ಯಂತ ಸರಳ ವಿಧಾನವೆಂದರೆ ಸಮಯ ಮಾಪನ. ಅನೇಕ ಸಂದರ್ಭಗಳಲ್ಲಿ ನಿಮ್ಮ code ನಲ್ಲಿ ಎರಡು ಬಿಂದುಗಳ ನಡುವೆ ತೆಗೆದುಕೊಂಡ ಸಮಯವನ್ನು print ಮಾಡಿದರೆ ಸಾಕಾಗಬಹುದು.

ಆದರೆ wall clock time ತಪ್ಪುದಾರಿ ತೋರಿಸಬಹುದು, ಏಕೆಂದರೆ ನಿಮ್ಮ ಕಂಪ್ಯೂಟರ್ ಸಮಕಾಲೀನವಾಗಿ ಬೇರೆ processes ಓಡಿಸುತ್ತಿರಬಹುದು ಅಥವಾ ಘಟನೆಗಳಿಗಾಗಿ ಕಾಯುತ್ತಿರಬಹುದು. `time` command _Real_, _User_, ಮತ್ತು _Sys_ ಸಮಯಗಳನ್ನು ಪ್ರತ್ಯೇಕಿಸುತ್ತದೆ:

- **Real** - ಆರಂಭದಿಂದ ಅಂತ್ಯವರೆಗಿನ wall clock ಸಮಯ, ಕಾಯುವ ಸಮಯ ಸಹಿತ
- **User** - user code ನಡೆಸುವಾಗ CPU ನಲ್ಲಿ ಕಳೆದ ಸಮಯ
- **Sys** - kernel code ನಡೆಸುವಾಗ CPU ನಲ್ಲಿ ಕಳೆದ ಸಮಯ

```bash
$ time curl https://missing.csail.mit.edu &> /dev/null
real	0m0.272s
user	0m0.079s
sys	    0m0.028s
```

ಈ ಉದಾಹರಣೆಯಲ್ಲಿ request ಸುಮಾರು 300 milliseconds (real time) ತೆಗೆದುಕೊಂಡರೂ, CPU ಸಮಯ ಕೇವಲ 107ms (user + sys) ಮಾತ್ರ. ಉಳಿದದ್ದು network ಕಾಯುವಿಕೆಯಲ್ಲಿ ಕಳೆದಿದೆ.

## ಸಂಪನ್ಮೂಲ ಮಾನಿಟರಿಂಗ್

ನಿಮ್ಮ ಪ್ರೋಗ್ರಾಂನ ಕಾರ್ಯಕ್ಷಮತೆಯನ್ನು ವಿಶ್ಲೇಷಿಸುವ ಮೊದಲ ಹೆಜ್ಜೆಯಾಗಿ ಅದರ ನಿಜವಾದ ಸಂಪನ್ಮೂಲ ಬಳಕೆ ಏನು ಎಂಬುದನ್ನು ತಿಳಿದುಕೊಳ್ಳುವುದು ಅಗತ್ಯವಾಗಿರಬಹುದು. programs ಸಾಮಾನ್ಯವಾಗಿ resource constrained ಆಗಿದ್ದಾಗ ನಿಧಾನವಾಗಿ ಓಡುತ್ತವೆ.

- **General Monitoring**: [`htop`](https://htop.dev/) `top` ನ ಸುಧಾರಿತ ರೂಪವಾಗಿದ್ದು, ಪ್ರಸ್ತುತ ಓಡುತ್ತಿರುವ processes ಗಳ ವಿವಿಧ ಅಂಕಿಅಂಶಗಳನ್ನು ತೋರಿಸುತ್ತದೆ. ಉಪಯುಕ್ತ keybinds: processes sort ಮಾಡಲು `<F6>`, tree hierarchy ತೋರಿಸಲು `t`, threads toggle ಮಾಡಲು `h`. ಹೆಚ್ಚುವರಿಯಾಗಿ _ಇನ್ನಷ್ಟು_ ಅಂಶಗಳನ್ನು ಮಾನಿಟರ್ ಮಾಡುವ [`btop`](https://github.com/aristocratos/btop) ಕೂಡ ಇದೆ.

- **I/O Operations**: [`iotop`](https://www.man7.org/linux/man-pages/man8/iotop.8.html) live I/O ಬಳಕೆ ಮಾಹಿತಿಯನ್ನು ತೋರಿಸುತ್ತದೆ.

- **Memory Usage**: [`free`](https://www.man7.org/linux/man-pages/man1/free.1.html) ಒಟ್ಟು free ಮತ್ತು used memory ತೋರಿಸುತ್ತದೆ.

- **Open Files**: [`lsof`](https://www.man7.org/linux/man-pages/man8/lsof.8.html) processes ತೆರೆಯಿರುವ files ಬಗ್ಗೆ ಮಾಹಿತಿ ಪಟ್ಟಿ ಮಾಡುತ್ತದೆ. ನಿರ್ದಿಷ್ಟ file ಅನ್ನು ಯಾವ process ತೆರೆಯಿದೆ ಎಂಬುದನ್ನು ಪರಿಶೀಲಿಸಲು ಉಪಯುಕ್ತ.

- **Network Connections**: [`ss`](https://www.man7.org/linux/man-pages/man8/ss.8.html) network connections ಮಾನಿಟರ್ ಮಾಡಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ. ಸಾಮಾನ್ಯ ಬಳಕೆ: ನಿರ್ದಿಷ್ಟ port ಅನ್ನು ಯಾವ process ಬಳಸುತ್ತಿದೆ ಎಂದು ಕಂಡುಹಿಡಿಯುವುದು - `ss -tlnp | grep :8080`.

- **Network Usage**: [`nethogs`](https://github.com/raboof/nethogs) ಮತ್ತು [`iftop`](https://pdw.ex-parrot.com/iftop/) process ಪ್ರತಿ network ಬಳಕೆಯನ್ನು ಮಾನಿಟರ್ ಮಾಡಲು ಉತ್ತಮ interactive CLI tools.

## ಕಾರ್ಯಕ್ಷಮತಾ ಡೇಟಾ ದೃಶ್ಯೀಕರಣ

ಮಾನವರು ಸಂಖ್ಯೆಗಳ ಪಟ್ಟಿಗಿಂತ ಗ್ರಾಫ್‌ಗಳಲ್ಲಿ ಮಾದರಿಗಳನ್ನು ಬಹಳ ವೇಗವಾಗಿ ಗುರುತಿಸುತ್ತಾರೆ. ಕಾರ್ಯಕ್ಷಮತಾ ವಿಶ್ಲೇಷಣೆಯಲ್ಲಿ ಡೇಟಾವನ್ನು plot ಮಾಡಿದರೆ raw ಸಂಖ್ಯಗಳಲ್ಲಿ ಕಾಣದ trends, spikes, anomalies ಸ್ಪಷ್ಟವಾಗುತ್ತವೆ.

**ಡೇಟಾವನ್ನು plot ಮಾಡಲು ಸೂಕ್ತಗೊಳಿಸುವುದು**: debugging ಗಾಗಿ print ಅಥವಾ log statements ಸೇರಿಸುವಾಗ, output ಅನ್ನು ನಂತರ ಸುಲಭವಾಗಿ graph ಮಾಡಲು ಸಾಧ್ಯವಾಗುವಂತೆ ವಿನ್ಯಾಸಗೊಳಿಸುವುದನ್ನು ಪರಿಗಣಿಸಿ. ಉದಾ: CSV (`1705012345,42.5`) ರೂಪದಲ್ಲಿ ಸರಳ timestamp ಮತ್ತು value, prose sentence ಗಿಂತ plot ಮಾಡಲು ಬಹಳ ಸುಲಭ. JSON-structured logs ಕೂಡ ಕಡಿಮೆ ಪ್ರಯತ್ನದಲ್ಲಿ parse ಮಾಡಿ plot ಮಾಡಬಹುದು. ಅಂದರೆ, ನಿಮ್ಮ ಡೇಟಾವನ್ನು [tidy ರೀತಿಯಲ್ಲಿ](https://vita.had.co.nz/papers/tidy-data.pdf) log ಮಾಡಿ.

**gnuplot ಮೂಲಕ ವೇಗವಾದ plotting**: ಸರಳ command-line plotting ಗಾಗಿ [`gnuplot`](http://www.gnuplot.info/) data files ನಿಂದ ನೇರವಾಗಿ graphs ರಚಿಸಬಹುದು:

```bash
# Plot a simple CSV with timestamp,value
gnuplot -e "set datafile separator ','; plot 'latency.csv' using 1:2 with lines"
```

**matplotlib ಮತ್ತು ggplot2 ಮೂಲಕ ಪುನರಾವರ್ತಿತ ಅನ್ವೇಷಣೆ**: ಆಳವಾದ ವಿಶ್ಲೇಷಣೆಗೆ Python ನ [`matplotlib`](https://matplotlib.org/) ಮತ್ತು R ನ [`ggplot2`](https://ggplot2.tidyverse.org/) ಉಪಕರಣಗಳು iterative exploration ಗೆ ಅನುಕೂಲಕರ. one-off plotting ಗಿಂತ ಭಿನ್ನವಾಗಿ, ಇವು hypotheses ಪರಿಶೀಲಿಸಲು data ಅನ್ನು ತ್ವರಿತವಾಗಿ slice ಮತ್ತು transform ಮಾಡಲು ಸಹಾಯ ಮಾಡುತ್ತವೆ. ggplot2 ನ facet plots ವಿಶೇಷವಾಗಿ ಶಕ್ತಿಶಾಲಿ - category ಆಧಾರದ ಮೇಲೆ ಒಂದೇ dataset ಅನ್ನು ಹಲವಾರು subplots ಗಳಾಗಿ ವಿಭಜಿಸಬಹುದು (ಉದಾ: endpoint ಅಥವಾ time-of-day ಪ್ರಕಾರ request latency faceting), ಇದರಿಂದ ಮರೆಯಾಗಿದ್ದ ಮಾದರಿಗಳು ಗೋಚರಿಸುತ್ತವೆ.

**ಉದಾಹರಣೆ ಬಳಕೆ ಪ್ರಕರಣಗಳು:**
- ಕಾಲಾಂತರದಲ್ಲಿ request latency plot ಮಾಡಿದರೆ periodic slowdowns (garbage collection, cron jobs, traffic patterns) ಗೋಚರಿಸುತ್ತವೆ - raw percentiles ಇದನ್ನು ಮರೆಮಾಚಬಹುದು
- ಬೆಳೆಯುತ್ತಿರುವ data structure ಗಾಗಿ insert times ದೃಶ್ಯೀಕರಿಸಿದರೆ algorithmic complexity ಸಮಸ್ಯೆಗಳು ಬಯಲಾಗಬಹುದು - vector insertions plot ನಲ್ಲಿ backing array ದ್ವಿಗುಣಗೊಳ್ಳುವಾಗ ಲಕ್ಷಣಾತ್ಮಕ spikes ಕಾಣುತ್ತವೆ
- ಬೇರೆ dimensions (request type, user cohort, server) ಆಧಾರವಾಗಿ metrics faceting ಮಾಡಿದಾಗ, "system-wide" ಸಮಸ್ಯೆ ವಾಸ್ತವದಲ್ಲಿ ಒಂದೇ category ಗೆ ಸೀಮಿತವಾಗಿರುವುದು ಅನೇಕ ಬಾರಿ ತಿಳಿಯುತ್ತದೆ

## CPU ಪ್ರೊಫೈಲರ್‌ಗಳು

ಜನರು _profilers_ ಎಂದು ಹೇಳಿದಾಗ ಹೆಚ್ಚಿನ ಸಂದರ್ಭಗಳಲ್ಲಿ _CPU profilers_ ಅನ್ನು ಉದ್ದೇಶಿಸುತ್ತಾರೆ. ಮುಖ್ಯವಾಗಿ ಎರಡು ವಿಧಗಳಿವೆ:

- **Tracing profilers** ನಿಮ್ಮ ಪ್ರೋಗ್ರಾಂ ಮಾಡುವ ಪ್ರತಿಯೊಂದು function call ನ ದಾಖಲೆಯನ್ನು ಇಟ್ಟುಕೊಳ್ಳುತ್ತವೆ
- **Sampling profilers** ನಿಮ್ಮ ಪ್ರೋಗ್ರಾಂ ಅನ್ನು ಅವಧಿ ಅವಧಿಗೆ (ಸಾಮಾನ್ಯವಾಗಿ ಪ್ರತಿ millisecond) sample ಮಾಡಿ stack ಅನ್ನು ದಾಖಲಿಸುತ್ತವೆ

Sampling profilers ಗಳ overhead ಕಡಿಮೆ ಇರುವುದರಿಂದ, production ಬಳಕೆಗೆ ಸಾಮಾನ್ಯವಾಗಿ ಇವುಗಳನ್ನು ಮೆಚ್ಚಲಾಗುತ್ತದೆ.

### perf: sampling profiler

[`perf`](https://www.man7.org/linux/man-pages/man1/perf.1.html) Linux ನ ಮಾನದಂಡ profiler ಆಗಿದೆ. ಇದು recompilation ಇಲ್ಲದೇ ಯಾವುದೇ ಪ್ರೋಗ್ರಾಂ ಅನ್ನು profile ಮಾಡಬಹುದು:

`perf stat` ಸಮಯ ಎಲ್ಲಿ ವ್ಯಯವಾಗುತ್ತಿದೆ ಎಂಬುದರ ತ್ವರಿತ ಅವಲೋಕನ ನೀಡುತ್ತದೆ:

```bash
$ perf stat ./slow_program

 Performance counter stats for './slow_program':

         3,210.45 msec task-clock                #    0.998 CPUs utilized
               12      context-switches          #    3.738 /sec
                0      cpu-migrations            #    0.000 /sec
              156      page-faults               #   48.587 /sec
   12,345,678,901      cycles                    #    3.845 GHz
    9,876,543,210      instructions              #    0.80  insn per cycle
    1,234,567,890      branches                  #  384.532 M/sec
       12,345,678      branch-misses             #    1.00% of all branches
```

ನೈಜ ಲೋಕದ programs ಗೆ profiler output ಬಹಳ ದೊಡ್ಡ ಮಾಹಿತಿಯನ್ನು ಒಳಗೊಂಡಿರುತ್ತದೆ. ಮಾನವರು ದೃಶ್ಯಾಧಾರಿತ ಪ್ರಾಣಿಗಳಾಗಿರುವುದರಿಂದ, ದೊಡ್ಡ ಪ್ರಮಾಣದ ಸಂಖ್ಯೆಗಳ ಓದಿನಲ್ಲಿ ಕಡಿಮೆ ಪರಿಣಾಮಕಾರಿಗಳು. [Flame graphs](https://www.brendangregg.com/flamegraphs.html) profiling data ಅರ್ಥಮಾಡಿಕೊಳ್ಳುವುದನ್ನು ಬಹಳ ಸುಲಭಗೊಳಿಸುವ ದೃಶ್ಯೀಕರಣ ವಿಧಾನವಾಗಿದೆ.

flame graph ನಲ್ಲಿ function calls ನ hierarchy Y axis ಮೇಲೆ ಹಾಗೂ ತೆಗೆದುಕೊಳ್ಳುವ ಸಮಯ X axis ಮೇಲೆ ಅನುಪಾತವಾಗಿ ತೋರಿಸಲಾಗುತ್ತದೆ. ಅವು interactive ಆಗಿರುವುದರಿಂದ, ನಿರ್ದಿಷ್ಟ ಭಾಗಗಳಿಗೆ click ಮಾಡಿ zoom ಮಾಡಬಹುದು.

[![FlameGraph](https://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)](https://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)

`perf` data ನಿಂದ flame graph ರಚಿಸಲು:

```bash
# Record profile
perf record -g ./my_program

# Generate flame graph (requires flamegraph scripts)
perf script | stackcollapse-perf.pl | flamegraph.pl > flamegraph.svg
```

> interactive web-based flame graph viewer ಗಾಗಿ [Speedscope](https://www.speedscope.app/) ಅಥವಾ comprehensive system-level analysis ಗಾಗಿ [Perfetto](https://perfetto.dev/) ಬಳಸುವುದನ್ನು ಪರಿಗಣಿಸಿ.

### Valgrind ನ Callgrind: tracing profiler

[`callgrind`](https://valgrind.org/docs/manual/cl-manual.html) ನಿಮ್ಮ ಪ್ರೋಗ್ರಾಂನ call history ಮತ್ತು instruction counts ದಾಖಲಿಸುವ profiling tool ಆಗಿದೆ. sampling profilers ಗಿಂತ ವಿಭಿನ್ನವಾಗಿ, ಇದು ಖಚಿತ call counts ನೀಡುತ್ತದೆ ಮತ್ತು callers-ಗೆ-callees ಸಂಬಂಧವನ್ನು ತೋರಿಸುತ್ತದೆ:

```bash
# Run with callgrind
valgrind --tool=callgrind ./my_program

# Analyze with callgrind_annotate (text) or kcachegrind (GUI)
callgrind_annotate callgrind.out.<pid>
kcachegrind callgrind.out.<pid>
```

Callgrind sampling profilers ಗಿಂತ ನಿಧಾನವಾದರೂ, ನಿಖರ call counts ಒದಗಿಸುತ್ತದೆ ಮತ್ತು ಅಗತ್ಯವಿದ್ದರೆ cache behavior ಅನ್ನು (`--cache-sim=yes`) simulate ಮಾಡಬಹುದು.

> ನೀವು ನಿರ್ದಿಷ್ಟ ಭಾಷೆಯನ್ನು ಬಳಸುತ್ತಿದ್ದರೆ, ಇನ್ನಷ್ಟು ವಿಶೇಷ profilers ಲಭ್ಯವಿರಬಹುದು. ಉದಾಹರಣೆಗೆ, Python ನಲ್ಲಿ [`cProfile`](https://docs.python.org/3/library/profile.html) ಮತ್ತು [`py-spy`](https://github.com/benfred/py-spy), Go ನಲ್ಲಿ [`go tool pprof`](https://pkg.go.dev/cmd/pprof), ಮತ್ತು Rust ನಲ್ಲಿ [`cargo-flamegraph`](https://github.com/flamegraph-rs/flamegraph) ಇದೆ.

## ಮೆಮೊರಿ ಪ್ರೊಫೈಲರ್‌ಗಳು

memory profilers ನಿಮ್ಮ ಪ್ರೋಗ್ರಾಂ ಕಾಲಕ್ರಮದಲ್ಲಿ memory ಅನ್ನು ಹೇಗೆ ಬಳಸುತ್ತಿದೆ ಎಂಬುದನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಲು ಮತ್ತು memory leaks ಪತ್ತೆಹಚ್ಚಲು ಸಹಾಯ ಮಾಡುತ್ತವೆ.

### Valgrind ನ Massif

[`massif`](https://valgrind.org/docs/manual/ms-manual.html) heap memory ಬಳಕೆಯನ್ನು profile ಮಾಡುತ್ತದೆ:

```bash
valgrind --tool=massif ./my_program
ms_print massif.out.<pid>
```

ಇದು ಕಾಲಕ್ರಮದಲ್ಲಿ heap usage ತೋರಿಸಿ memory leaks ಮತ್ತು ಅತಿಯಾದ allocation ಗುರುತಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ.

> Python ಗಾಗಿ [`memory-profiler`](https://pypi.org/project/memory-profiler/) line-by-line memory usage ಮಾಹಿತಿ ಒದಗಿಸುತ್ತದೆ.

## ಬೆಂಚ್ಮಾರ್ಕಿಂಗ್

ಬೇರೆ implementations ಅಥವಾ tools ಗಳ ಕಾರ್ಯಕ್ಷಮತೆಯನ್ನು ಹೋಲಿಸಬೇಕಾದಾಗ, command-line programs ಬೆಂಚ್ಮಾರ್ಕ್ ಮಾಡಲು [`hyperfine`](https://github.com/sharkdp/hyperfine) ಅತ್ಯುತ್ತಮ ಸಾಧನವಾಗಿದೆ:

```bash
$ hyperfine --warmup 3 'fd -e jpg' 'find . -iname "*.jpg"'
Benchmark #1: fd -e jpg
  Time (mean ± σ):      51.4 ms ±   2.9 ms    [User: 121.0 ms, System: 160.5 ms]
  Range (min … max):    44.2 ms …  60.1 ms    56 runs

Benchmark #2: find . -iname "*.jpg"
  Time (mean ± σ):      1.126 s ±  0.101 s    [User: 141.1 ms, System: 956.1 ms]
  Range (min … max):    0.975 s …  1.287 s    10 runs

Summary
  'fd -e jpg' ran
   21.89 ± 2.33 times faster than 'find . -iname "*.jpg"'
```

> web development ಗಾಗಿ browser developer tools ನಲ್ಲಿ ಅತ್ಯುತ್ತಮ profilers ಒಳಗೊಂಡಿವೆ. [Firefox Profiler](https://profiler.firefox.com/docs/) ಮತ್ತು [Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools/rendering-tools) documentation ನೋಡಿ.

# ಅಭ್ಯಾಸಗಳು

## ಡಿಬಗ್ಗಿಂಗ್

1. **sorting algorithm ಅನ್ನು ಡಿಬಗ್ ಮಾಡಿ**: ಕೆಳಗಿನ pseudocode merge sort ಅನ್ನು ಅನುಷ್ಠಾನಗೊಳಿಸುತ್ತದೆ, ಆದರೆ ಇದರಲ್ಲಿ ಒಂದು bug ಇದೆ. ಇದನ್ನು ನಿಮ್ಮ ಆಯ್ಕೆಯ ಭಾಷೆಯಲ್ಲಿ ಅನುಷ್ಠಾನಗೊಳಿಸಿ, ನಂತರ debugger (gdb, lldb, pdb, ಅಥವಾ ನಿಮ್ಮ IDE ಯ debugger) ಬಳಸಿ bug ಅನ್ನು ಕಂಡುಹಿಡಿದು ಸರಿಪಡಿಸಿ.

   ```
   function merge_sort(arr):
       if length(arr) <= 1:
           return arr
       mid = length(arr) / 2
       left = merge_sort(arr[0..mid])
       right = merge_sort(arr[mid..end])
       return merge(left, right)

   function merge(left, right):
       result = []
       i = 0, j = 0
       while i < length(left) AND j < length(right):
           if left[i] <= right[j]:
               append result, left[i]
               i = i + 1
           else:
               append result, right[i]
               j = j + 1
       append remaining elements from left and right
       return result
   ```

   ಪರೀಕ್ಷಾ vector: `merge_sort([3, 1, 4, 1, 5, 9, 2, 6])` ಫಲಿತಾಂಶವಾಗಿ `[1, 1, 2, 3, 4, 5, 6, 9]` ಮರಳಬೇಕು. ತಪ್ಪಾದ element ಯಾವ ಸ್ಥಳದಲ್ಲಿ ಆಯ್ಕೆಯಾಗುತ್ತಿದೆ ಎಂಬುದನ್ನು ಕಂಡುಹಿಡಿಯಲು breakpoints ಬಳಸಿ merge function ಅನ್ನು ಹಂತ ಹಂತವಾಗಿ ನಡೆಸಿ.

1. [`rr`](https://rr-project.org/) install ಮಾಡಿ ಮತ್ತು reverse debugging ಬಳಸಿ corruption bug ಅನ್ನು ಕಂಡುಹಿಡಿಯಿರಿ. ಈ program ಅನ್ನು `corruption.c` ಎಂಬ ಹೆಸರಿನಲ್ಲಿ ಉಳಿಸಿ:

   ```c
   #include <stdio.h>

   typedef struct {
       int id;
       int scores[3];
   } Student;

   Student students[2];

   void init() {
       students[0].id = 1001;
       students[0].scores[0] = 85;
       students[0].scores[1] = 92;
       students[0].scores[2] = 78;

       students[1].id = 1002;
       students[1].scores[0] = 90;
       students[1].scores[1] = 88;
       students[1].scores[2] = 95;
   }

   void curve_scores(int student_idx, int curve) {
       for (int i = 0; i < 4; i++) {
           students[student_idx].scores[i] += curve;
       }
   }

   int main() {
       init();
       printf("=== Initial state ===\n");
       printf("Student 0: id=%d\n", students[0].id);
       printf("Student 1: id=%d\n", students[1].id);

       curve_scores(0, 5);

       printf("\n=== After curving ===\n");
       printf("Student 0: id=%d\n", students[0].id);
       printf("Student 1: id=%d\n", students[1].id);

       if (students[1].id != 1002) {
           printf("\nERROR: Student 1's ID was corrupted! Expected 1002, got %d\n",
                  students[1].id);
           return 1;
       }
       return 0;
   }
   ```

   `gcc -g corruption.c -o corruption` ಮೂಲಕ compile ಮಾಡಿ ಮತ್ತು program ಅನ್ನು ಓಡಿಸಿ. Student 1 ರ ID corrupt ಆಗುತ್ತದೆ, ಆದರೆ corruption student 0 ಅನ್ನು ಮಾತ್ರ ತಾಕುವ function ನಲ್ಲಿ ಆಗುತ್ತದೆ. ಕಾರಣವನ್ನು ಕಂಡುಹಿಡಿಯಲು `rr record ./corruption` ಮತ್ತು `rr replay` ಬಳಸಿ. `students[1].id` ಮೇಲೆ watchpoint ಹೊಂದಿಸಿ, corruption ಆದ ನಂತರ `reverse-continue` ಬಳಸಿ ಅದನ್ನು ಯಾವ code ಸಾಲು overwrite ಮಾಡಿತು ಎಂದು ಖಚಿತವಾಗಿ ಪತ್ತೆಹಚ್ಚಿ.

1. AddressSanitizer ಬಳಸಿ memory error ಡಿಬಗ್ ಮಾಡಿ. ಇದನ್ನು `uaf.c` ಎಂದು ಉಳಿಸಿ:

   ```c
   #include <stdlib.h>
   #include <string.h>
   #include <stdio.h>

   int main() {
       char *greeting = malloc(32);
       strcpy(greeting, "Hello, world!");
       printf("%s\n", greeting);

       free(greeting);

       greeting[0] = 'J';
       printf("%s\n", greeting);

       return 0;
   }
   ```

   ಮೊದಲು sanitizers ಇಲ್ಲದೆ compile ಮಾಡಿ ಓಡಿಸಿ: `gcc uaf.c -o uaf && ./uaf`. ಇದು ಕೆಲಸ ಮಾಡಿದಂತೆ ಕಾಣಬಹುದು. ಈಗ AddressSanitizer ಜೊತೆಗೆ compile ಮಾಡಿ: `gcc -fsanitize=address -g uaf.c -o uaf && ./uaf`. error report ಓದಿ. ASan ಯಾವ bug ಪತ್ತೆಹಚ್ಚುತ್ತದೆ? ಅದು ಗುರುತಿಸಿದ ಸಮಸ್ಯೆಯನ್ನು ಸರಿಪಡಿಸಿ.

1. `strace` (Linux) ಅಥವಾ `dtruss` (macOS) ಬಳಸಿ `ls -l` போன்ற command ಮಾಡುವ system calls ಅನ್ನು trace ಮಾಡಿ. ಅದು ಯಾವ system calls ಮಾಡುತ್ತಿದೆ? ಇನ್ನಷ್ಟು ಸಂಕೀರ್ಣ program ಅನ್ನು trace ಮಾಡಿ ಅದು ಯಾವ files ತೆರೆಯುತ್ತದೆ ಎಂಬುದನ್ನೂ ನೋಡಿ.

1. ಗುಂಗುರುವ error message ಅನ್ನು ಡಿಬಗ್ ಮಾಡಲು LLM ಬಳಸಿ. ಒಂದು compiler error (ವಿಶೇಷವಾಗಿ C++ templates ಅಥವಾ Rust ನಿಂದ) ನಕಲಿಸಿ ಅದರ ವಿವರಣೆ ಮತ್ತು ತಿದ್ದುಪಡಿ ಕೇಳಿ. `strace` ಅಥವಾ address sanitizer output ನ ಕೆಲ ಭಾಗಗಳನ್ನು ಕೂಡ ನೀಡಿ ಪ್ರಯತ್ನಿಸಿ.

## ಪ್ರೊಫೈಲಿಂಗ್

1. ನಿಮ್ಮ ಆಯ್ಕೆಯ program ಗೆ `perf stat` ಬಳಸಿ ಮೂಲ ಕಾರ್ಯಕ್ಷಮತಾ ಅಂಕಿಅಂಶಗಳನ್ನು ಪಡೆಯಿರಿ. ವಿಭಿನ್ನ counters ಎಂದರೆ ಏನು?

1. `perf record` ಬಳಸಿ profile ಮಾಡಿ. ಇದನ್ನು `slow.c` ಎಂದು ಉಳಿಸಿ:

   ```c
   #include <math.h>
   #include <stdio.h>

   double slow_computation(int n) {
       double result = 0;
       for (int i = 0; i < n; i++) {
           for (int j = 0; j < 1000; j++) {
               result += sin(i * j) * cos(i + j);
           }
       }
       return result;
   }

   int main() {
       double r = 0;
       for (int i = 0; i < 100; i++) {
           r += slow_computation(1000);
       }
       printf("Result: %f\n", r);
       return 0;
   }
   ```

   debug symbols ಜೊತೆ compile ಮಾಡಿ: `gcc -g -O2 slow.c -o slow -lm`. `perf record -g ./slow` ಓಡಿಸಿ, ನಂತರ `perf report` ಬಳಸಿ ಸಮಯ ಎಲ್ಲಿ ಕಳೆಯುತ್ತಿದೆ ನೋಡಿ. flamegraph scripts ಬಳಸಿ flame graph ರಚಿಸಲು ಪ್ರಯತ್ನಿಸಿ.

1. ಒಂದೇ ಕಾರ್ಯದ ಎರಡು ವಿಭಿನ್ನ implementations ಅನ್ನು `hyperfine` ಬಳಸಿ ಬೆಂಚ್ಮಾರ್ಕ್ ಮಾಡಿ (ಉದಾ: `find` vs `fd`, `grep` vs `ripgrep`, ಅಥವಾ ನಿಮ್ಮದೇ code ನ ಎರಡು ಆವೃತ್ತಿಗಳು).

1. resource-intensive program ಓಡಿಸುತ್ತಿರುವಾಗ ನಿಮ್ಮ system ಅನ್ನು `htop` ಮೂಲಕ ಮಾನಿಟರ್ ಮಾಡಿ. process ಯಾವ CPUs ಬಳಕೆ ಮಾಡಬಹುದು ಎಂಬುದನ್ನು ಮಿತಿಗೊಳಿಸಲು `taskset` ಬಳಸಿ ಪ್ರಯತ್ನಿಸಿ: `taskset --cpu-list 0,2 stress -c 3`. `stress` ಮೂರು CPUs ಬಳಸದೇ ಇರುವುದಕ್ಕೆ ಕಾರಣವೇನು?

1. ನೀವು listen ಮಾಡಲು ಬಯಸುವ port ಅನ್ನು ಬೇರೆ process ಈಗಾಗಲೇ ಬಳಸುತ್ತಿರುವುದು ಸಾಮಾನ್ಯ ಸಮಸ್ಯೆ. ಆ process ಅನ್ನು ಹೇಗೆ ಪತ್ತೆಹಚ್ಚುವುದು ಎಂಬುದನ್ನು ಕಲಿಯಿರಿ: ಮೊದಲು port 4444 ಮೇಲೆ ಕನಿಷ್ಠ web server ಆರಂಭಿಸಲು `python -m http.server 4444` ನಡೆಸಿ. ಪ್ರತ್ಯೇಕ terminal ನಲ್ಲಿ `ss -tlnp | grep 4444` ಓಡಿಸಿ process ಪತ್ತೆಮಾಡಿ. ನಂತರ `kill <PID>` ಮೂಲಕ ಅದನ್ನು ಸ್ಥಗಿತಗೊಳಿಸಿ.
