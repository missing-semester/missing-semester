---
layout: lecture
title: "ಪಠ್ಯದ ಅವಲೋಕನ + ಶೆಲ್‌ಗೆ ಪರಿಚಯ"
description: >
  ಈ ತರಗತಿಯ ಉದ್ದೇಶವನ್ನು ತಿಳಿದುಕೊಳ್ಳಿ, ಮತ್ತು ಶೆಲ್ ಅನ್ನು ಬಳಸಲು ಆರಂಭಿಸಿ.
thumbnail: /static/assets/thumbnails/2026/lec1.png
date: 2026-01-12
ready: true
video:
  aspect: 56.25
  id: MSgoeuMqUmU
---

# ನಾವು ಯಾರು?

ಈ ತರಗತಿಯನ್ನು [Anish](https://anish.io/),
[Jon](https://thesquareplanet.com/), ಮತ್ತು [Jose](http://josejg.com/) ಸಹ-ಬೋಧಿಸುತ್ತಾರೆ.
ನಾವು ಎಲ್ಲರೂ ಮಾಜಿ MIT ವಿದ್ಯಾರ್ಥಿಗಳು; ನಾವು ವಿದ್ಯಾರ್ಥಿಗಳಾಗಿದ್ದಾಗಲೇ ಈ MIT IAP ತರಗತಿಯನ್ನು
ಆರಂಭಿಸಿದ್ದೇವೆ. ನಮ್ಮನ್ನು ಒಟ್ಟಾಗಿ ಸಂಪರ್ಕಿಸಲು
[missing-semester@mit.edu](mailto:missing-semester@mit.edu) ಬಳಸಿ.

ಈ ತರಗತಿಯನ್ನು ಬೋಧಿಸಲು ನಮಗೆ ವೇತನ ಸಿಗುವುದಿಲ್ಲ, ಮತ್ತು ಈ ತರಗತಿಯಿಂದ ನಾವು ಯಾವುದೇ ರೀತಿಯಲ್ಲಿ ಆದಾಯ ಗಳಿಸುವುದಿಲ್ಲ.
ನಾವು ಎಲ್ಲಾ [ಪಠ್ಯ ಸಾಮಗ್ರಿಗಳನ್ನು](https://missing.csail.mit.edu/) ಮತ್ತು
[ಉಪನ್ಯಾಸಗಳ ದಾಖಲೆಗಳನ್ನು](https://www.youtube.com/@MissingSemester)
ಉಚಿತವಾಗಿ ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ ಲಭ್ಯವಾಗುವಂತೆ ಮಾಡಿದ್ದೇವೆ. ನೀವು ನಮ್ಮ ಕೆಲಸವನ್ನು ಬೆಂಬಲಿಸಲು ಬಯಸಿದರೆ,
ಅತ್ಯುತ್ತಮ ಮಾರ್ಗವೆಂದರೆ ಈ ತರಗತಿಯ ಬಗ್ಗೆ ಇತರರಿಗೆ ತಿಳಿಸುವುದು. ನೀವು ಕಂಪನಿ, ವಿಶ್ವವಿದ್ಯಾಲಯ,
ಅಥವಾ ದೊಡ್ಡ ಗುಂಪುಗಳಿಗೆ ಈ ವಿಷಯವನ್ನು ಕಲಿಸುವ ಬೇರೆ ಸಂಸ್ಥೆಯಾಗಿದ್ದರೆ, ದಯವಿಟ್ಟು ನಿಮ್ಮ ಅನುಭವ ವರದಿ/ಪ್ರಶಂಸಾಪತ್ರಗಳನ್ನು
ಇಮೇಲ್ ಮೂಲಕ ಕಳುಹಿಸಿ - ನಮಗೆ ಅದರ ಬಗ್ಗೆ ಕೇಳಲು ಸಂತೋಷವಾಗುತ್ತದೆ :)

# ಉದ್ದೇಶ

ಕಂಪ್ಯೂಟರ್ ವಿಜ್ಞಾನಿಗಳಾದ ನಾವು, ಪುನರಾವರ್ತಿತ ಕೆಲಸಗಳಲ್ಲಿ ಕಂಪ್ಯೂಟರ್‌ಗಳು ಬಹಳ ಸಹಾಯಕವೆಂದು ತಿಳಿದಿದ್ದೇವೆ.
ಆದರೆ, ತುಂಬಾ ಬಾರಿ ನಾವು ಮರೆತುಬಿಡುವುದು ಏನೆಂದರೆ - ಇದು ನಮ್ಮ ಪ್ರೋಗ್ರಾಂಗಳು ಮಾಡುವ ಗಣನೆಗಳಿಗೆಷ್ಟೇ ಅಲ್ಲ,
ನಮ್ಮ _ಕಂಪ್ಯೂಟರ್ ಬಳಕೆ_ಗೂ ಸಮಾನವಾಗಿ ಅನ್ವಯಿಸುತ್ತದೆ. ಕಂಪ್ಯೂಟರ್ ಸಂಬಂಧಿತ ಯಾವುದೇ ಸಮಸ್ಯೆಯಲ್ಲಿ
ಹೆಚ್ಚು ಉತ್ಪಾದಕವಾಗಲು ಹಾಗೂ ಇನ್ನಷ್ಟು ಜಟಿಲ ಸಮಸ್ಯೆಗಳನ್ನು ಪರಿಹರಿಸಲು ಸಹಾಯ ಮಾಡುವ ಬಹಳಷ್ಟು ಸಾಧನಗಳು
ನಮ್ಮ ಕೈಬೆರಳ ತುದಿಯಲ್ಲೇ ಇವೆ. ಆದರೂ ನಾವು ಹಲವರು ಅವುಗಳಲ್ಲಿ ಅಲ್ಪ ಭಾಗವನ್ನೇ ಬಳಸುತ್ತೇವೆ;
ಬಾಳಿಗೆ ಸಾಕಾಗುವಷ್ಟು ಕೆಲವು ಮಾಂತ್ರಿಕ ಆಜ್ಞೆಗಳನ್ನು ಕಂಠಪಾಠ ಮಾಡಿಕೊಂಡು, ಸಿಕ್ಕಿಬಿದ್ದಾಗ
ಇಂಟರ್ನೆಟ್‌ನಿಂದ ಆಜ್ಞೆಗಳನ್ನು ಅಂಧವಾಗಿ copy-paste ಮಾಡುತ್ತೇವೆ.

ಈ ತರಗತಿ ಅದನ್ನು [ಸರಿಪಡಿಸುವ](/about/) ಪ್ರಯತ್ನವಾಗಿದೆ.

ನೀವು ಈಗಾಗಲೇ ತಿಳಿದಿರುವ ಸಾಧನಗಳನ್ನು ಉತ್ತಮವಾಗಿ ಬಳಸುವುದನ್ನು ಕಲಿಸುವುದು, ನಿಮ್ಮ ಉಪಕರಣ ಪೆಟ್ಟಿಗೆಯಲ್ಲಿ ಸೇರಿಸಬಹುದಾದ
ಹೊಸ ಸಾಧನಗಳನ್ನು ತೋರಿಸುವುದು, ಮತ್ತು ಸ್ವತಃ ಇನ್ನಷ್ಟು ಸಾಧನಗಳನ್ನು ಅನ್ವೇಷಿಸುವ (ಬಹುಶಃ ನಿರ್ಮಿಸುವ) ಆಸಕ್ತಿಯನ್ನು
ಹುಟ್ಟಿಸುವುದು ನಮ್ಮ ಉದ್ದೇಶ. ಇದು ಕಂಪ್ಯೂಟರ್ ಸೈನ್ಸ್ ಪಠ್ಯಕ್ರಮಗಳಲ್ಲಿ ಇಲ್ಲದಿರುವ ಸೆಮಿಸ್ಟರ್ ಎಂದು ನಾವು ನಂಬುತ್ತೇವೆ.

# ತರಗತಿಯ ರಚನೆ

ಈ non-credit ತರಗತಿಯಲ್ಲಿ ಒಟ್ಟು ಒಂಬತ್ತು 1-ಗಂಟೆಯ ಉಪನ್ಯಾಸಗಳಿವೆ, ಮತ್ತು ಪ್ರತಿಯೊಂದು
[ವಿಶಿಷ್ಟ ವಿಷಯ](/2026/)ವನ್ನು ಕೇಂದ್ರೀಕರಿಸಿದೆ. ಉಪನ್ಯಾಸಗಳು ಬಹುತೇಕ ಸ್ವತಂತ್ರವಾಗಿದ್ದರೂ,
ಸೆಮಿಸ್ಟರ್ ಮುಂದುವರಿದಂತೆ ಹಿಂದಿನ ಉಪನ್ಯಾಸಗಳ ವಿಷಯವನ್ನು ನೀವು ತಿಳಿದಿರುವಿರಿ ಎಂಬುದನ್ನು ನಾವು ಊಹಿಸುತ್ತೇವೆ.
ಉಪನ್ಯಾಸ ಟಿಪ್ಪಣಿಗಳು ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ ಇವೆ, ಆದರೆ ತರಗತಿಯಲ್ಲಿ ಒಳಗೊಂಡಿರುವ ಕೆಲವು ವಿಷಯಗಳು
(ಉದಾ. ಡೆಮೊಗಳು) ಟಿಪ್ಪಣಿಗಳಲ್ಲಿಲ್ಲದಿರಬಹುದು. ಹಿಂದಿನ ವರ್ಷಗಳಂತೆ, ನಾವು ಉಪನ್ಯಾಸಗಳನ್ನು ದಾಖಲಿಸಿ
[ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ](https://www.youtube.com/@MissingSemester) ಪ್ರಕಟಿಸುತ್ತೇವೆ.

ಕೆಲವೇ 1-ಗಂಟೆಯ ಉಪನ್ಯಾಸಗಳಲ್ಲಿ ಬಹಳ ವಿಷಯವನ್ನು ಒಳಗೊಳ್ಳಲು ಪ್ರಯತ್ನಿಸುತ್ತಿರುವುದರಿಂದ, ಉಪನ್ಯಾಸಗಳು ದಟ್ಟವಾಗಿರುತ್ತವೆ.
ನೀವು ನಿಮ್ಮ ವೇಗದಲ್ಲಿ ವಿಷಯವನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಲು ಸಮಯ ಸಿಗುವಂತೆ, ಪ್ರತಿ ಉಪನ್ಯಾಸದಲ್ಲೂ ಅದರ ಪ್ರಮುಖ ಅಂಶಗಳನ್ನು
ಮಾರ್ಗದರ್ಶಿಸುವ ವ್ಯಾಯಾಮಗಳ ಒಂದು ಸೆಟ್ ಇರುತ್ತದೆ. ನಾವು ವಿಶೇಷ office hours ನಡೆಸುವುದಿಲ್ಲ,
ಆದರೆ [OSSU Discord](https://ossu.dev/#community)-ನಲ್ಲಿ,
`#missing-semester-forum` ನಲ್ಲಿ ಪ್ರಶ್ನೆಗಳನ್ನು ಕೇಳಲು, ಅಥವಾ
[missing-semester@mit.edu](mailto:missing-semester@mit.edu) ಗೆ ಇಮೇಲ್ ಮಾಡಲು ಪ್ರೋತ್ಸಾಹಿಸುತ್ತೇವೆ.

ನಮ್ಮ ಸಮಯ ಸೀಮಿತವಾಗಿರುವುದರಿಂದ, ಪೂರ್ಣ ಪ್ರಮಾಣದ ಕೋರ್ಸ್ ಒದಗಿಸುವಷ್ಟು ವಿವರದಲ್ಲಿ ಎಲ್ಲಾ ಸಾಧನಗಳನ್ನು ಚರ್ಚಿಸಲು
ನಮಗೆ ಸಾಧ್ಯವಾಗುವುದಿಲ್ಲ. ಸಾಧ್ಯವಾದಲ್ಲಿ, ಯಾವುದಾದರೂ ಸಾಧನ ಅಥವಾ ವಿಷಯವನ್ನು ಇನ್ನಷ್ಟು ಆಳವಾಗಿ ಕಲಿಯಲು
ಬಳಕೆಯಾಗುವ ಸಂಪನ್ಮೂಲಗಳತ್ತ ನಾವು ನಿಮ್ಮನ್ನು ಮುನ್ನಡೆಸುತ್ತೇವೆ. ಆದರೆ ಯಾವದಾದರೂ ವಿಷಯ ನಿಮ್ಮ ಆಸಕ್ತಿಯನ್ನು
ವಿಶೇಷವಾಗಿ ಸೆಳೆದರೆ, ದಯವಿಟ್ಟು ನಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸಿ ಸಲಹೆ ಕೇಳುವುದರಲ್ಲಿ ಹಿಂಜರಿಯಬೇಡಿ!

ಕೊನೆಗೆ, ತರಗತಿಯ ಬಗ್ಗೆ ನಿಮ್ಮ ಪ್ರತಿಕ್ರಿಯೆಯನ್ನು [missing-semester@mit.edu](mailto:missing-semester@mit.edu)
ಗೆ ಇಮೇಲ್ ಮೂಲಕ ಕಳುಹಿಸಿ.

# ವಿಷಯ 1: ಶೆಲ್

{% comment %}
lecturer: Jon
{% endcomment %}

## ಶೆಲ್ ಎಂದರೆ ಏನು?

ಇಂದಿನ ಕಂಪ್ಯೂಟರ್‌ಗಳಲ್ಲಿ ಆಜ್ಞೆಗಳನ್ನು ನೀಡಲು ಹಲವು ರೀತಿಯ ಇಂಟರ್ಫೇಸ್‌ಗಳು ಇವೆ - ಆಕರ್ಷಕ GUI,
ಧ್ವನಿ ಇಂಟರ್ಫೇಸ್‌ಗಳು, AR/VR, ಮತ್ತು ಇತ್ತೀಚೆಗೆ: LLMs. ಇವು 80% ಬಳಕೆ ಸಂದರ್ಭಗಳಿಗೆ ಅದ್ಭುತವಾಗಿವೆ,
ಆದರೆ ಬಹಳ ಬಾರಿ ನೀವು ಏನು ಮಾಡಬಹುದು ಎಂಬುದರಲ್ಲಿ ಮೂಲಭೂತ ಮಿತಿಗಳಿರುತ್ತವೆ - ಇರುವುದಿಲ್ಲದ ಬಟನ್ ಒತ್ತಲು
ಅಥವಾ ಪ್ರೋಗ್ರಾಂ ಮಾಡದ voice command ನೀಡಲು ಸಾಧ್ಯವಿಲ್ಲ. ನಿಮ್ಮ ಕಂಪ್ಯೂಟರ್ ಒದಗಿಸುವ ಸಾಧನಗಳನ್ನು ಸಂಪೂರ್ಣವಾಗಿ
ಬಳಸಲು, ನಮಗೆ ಹಳೆಯ ಶೈಲಿಗೆ ಹಿಂತಿರುಗಿ ಪಠ್ಯ ಆಧಾರಿತ ಇಂಟರ್ಫೇಸ್‌ಗೆ ಇಳಿಯಬೇಕು: The Shell.

ನಿಮ್ಮ ಕೈಗೆ ಸಿಗುವ ಬಹುತೇಕ ಎಲ್ಲಾ ಪ್ಲಾಟ್‌ಫಾರ್ಮ್‌ಗಳಲ್ಲಿ ಒಂದು ರೂಪದಲ್ಲಿ ಶೆಲ್ ಇರುತ್ತದೆ, ಮತ್ತು ಅವುಗಳಲ್ಲಿ ಹಲವೆಡೆ
ನಿಮಗೆ ಆಯ್ಕೆಗೆ ಅನೇಕ ಶೆಲ್‌ಗಳಿರುತ್ತವೆ. ವಿವರಗಳಲ್ಲಿ ವ್ಯತ್ಯಾಸ ಇದ್ದರೂ, ಅವುಗಳ ಮೂಲಭೂತ ಸ್ವರೂಪ ಒಂದೇ:
ಅವು ನಿಮಗೆ ಪ್ರೋಗ್ರಾಂಗಳನ್ನು ಓಡಿಸಲು, ಅವುಗಳಿಗೆ ಇನ್‌ಪುಟ್ ನೀಡಲು, ಮತ್ತು ಅವುಗಳ ಔಟ್‌ಪುಟ್ ಪರಿಶೀಲಿಸಲು
ಅರ್ಧ-ಸಂರಚಿತ ವಿಧಾನ ಒದಗಿಸುತ್ತವೆ.

ಶೆಲ್ _prompt_ ತೆರೆಯಲು (ಅಲ್ಲಿ ನೀವು ಆಜ್ಞೆಗಳನ್ನು ಟೈಪ್ ಮಾಡಬಹುದು), ಮೊದಲು _terminal_ ಬೇಕು;
ಇದು ಶೆಲ್‌ಗೆ ದೃಶ್ಯ ಇಂಟರ್ಫೇಸ್. ನಿಮ್ಮ ಸಾಧನದಲ್ಲಿ ಸಾಮಾನ್ಯವಾಗಿ ಇದು ಮೊದಲೇ ಇರುತ್ತದೆ,
ಅಥವಾ ಸುಲಭವಾಗಿ ಸ್ಥಾಪಿಸಬಹುದು:

- **Linux:**
  `Ctrl + Alt + T` ಒತ್ತಿರಿ (ಹೆಚ್ಚಿನ distributionsಗಳಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತದೆ). ಅಥವಾ ನಿಮ್ಮ applications menuದಲ್ಲಿ
  "Terminal" ಹುಡುಕಿ.
- **Windows:**
  `Win + R` ಒತ್ತಿ, `cmd` ಅಥವಾ `powershell` ಟೈಪ್ ಮಾಡಿ, Enter ಒತ್ತಿರಿ.
  ಪರ್ಯಾಯವಾಗಿ Start menuದಲ್ಲಿ "Terminal" ಅಥವಾ "Command Prompt" ಹುಡುಕಿ.
- **macOS:**
  Spotlight ತೆರೆಯಲು `Cmd + Space` ಒತ್ತಿ, "Terminal" ಟೈಪ್ ಮಾಡಿ, Enter ಒತ್ತಿರಿ.
  ಅಥವಾ Applications → Utilities → Terminal ನಲ್ಲಿ ನೋಡಿ.

Linux ಮತ್ತು macOS ನಲ್ಲಿ, ಇದು ಸಾಮಾನ್ಯವಾಗಿ Bourne Again SHell ಅಥವಾ ಸಂಕ್ಷಿಪ್ತವಾಗಿ "bash" ಅನ್ನು ತೆರೆಯುತ್ತದೆ.
ಇದು ಹೆಚ್ಚು ವ್ಯಾಪಕವಾಗಿ ಬಳಸುವ ಶೆಲ್‌ಗಳಲ್ಲಿ ಒಂದು, ಮತ್ತು ಇದರ syntax ಇತರೆ ಅನೇಕ ಶೆಲ್‌ಗಳಲ್ಲಿ ನೀವು ನೋಡುವುದಕ್ಕೆ ಹೋಲುತ್ತದೆ.
Windows ನಲ್ಲಿ, ನೀವು ಓಡಿಸಿದ ಆಜ್ಞೆಯ ಆಧಾರದ ಮೇಲೆ "batch" ಅಥವಾ "powershell" ಶೆಲ್‌ಗಳು ತೆರೆದುಕೊಳ್ಳುತ್ತವೆ.
ಇವು Windows-ನಿಗದಿತವಾಗಿವೆ; ಈ ತರಗತಿಯಲ್ಲಿ ನಾವು ಅವುಗಳ ಮೇಲೆ ಕೇಂದ್ರೀಕರಿಸುವುದಿಲ್ಲ, ಆದರೂ ನಾವು ಕಲಿಸುವ ವಿಷಯಗಳ ಬಹುಪಾಲಿಗೆ
ಇವುಗಳಲ್ಲಿ ಸಮಾನಾಂಶಗಳಿವೆ. ಆದ್ದರಿಂದ ನೀವು [Windows Subsystem for
Linux](https://docs.microsoft.com/en-us/windows/wsl/) ಅಥವಾ Linux virtual machine ಬಳಸುವುದು ಉತ್ತಮ.

bashಕ್ಕಿಂತ ಬಳಕೆ ಸೌಕರ್ಯದಲ್ಲಿ ಸುಧಾರಣೆಗಳನ್ನು ಹೊಂದಿರುವ ಇತರೆ ಶೆಲ್‌ಗಳೂ ಇವೆ (fish ಮತ್ತು zsh ಸಾಮಾನ್ಯ).
ಇವು ಬಹಳ ಜನಪ್ರಿಯ (ಎಲ್ಲಾ ಶಿಕ್ಷಕರೂ ಒಂದನ್ನಾದರೂ ಬಳಸುತ್ತಾರೆ), ಆದರೆ bashಷ್ಟು ಎಲ್ಲೆಡೆ ಸಾಮಾನ್ಯವಲ್ಲ,
ಮತ್ತು ಅನೇಕ ಮೂಲಭೂತ ಆಲೋಚನೆಗಳು ಒಂದೇ ಇರುವುದರಿಂದ ಈ ಉಪನ್ಯಾಸದಲ್ಲಿ ಅವುಗಳ ಮೇಲೆ ನಾವು ಕೇಂದ್ರೀಕರಿಸುವುದಿಲ್ಲ.

## ಇದನ್ನು ಏಕೆ ಕಾಳಜಿ ವಹಿಸಬೇಕು?

ಶೆಲ್ "clicking around" ಗಿಂತ (ಸಾಮಾನ್ಯವಾಗಿ) ಬಹಳ ವೇಗವಾಗಿರುವುದಷ್ಟೇ ಅಲ್ಲ,
ಒಂದು ಗ್ರಾಫಿಕಲ್ ಪ್ರೋಗ್ರಾಂನಲ್ಲಿ ಸುಲಭವಾಗಿ ಸಿಗದ ಅಭಿವ್ಯಕ್ತಿ ಶಕ್ತಿಯನ್ನೂ ಒದಗಿಸುತ್ತದೆ.
ನಾವು ನೋಡುವಂತೆ, ಶೆಲ್ ನಿಮಗೆ ಪ್ರೋಗ್ರಾಂಗಳನ್ನು ಸೃಜನಾತ್ಮಕವಾಗಿ _ಒಗ್ಗೂಡಿಸಿ_ ಬಹುತೇಕ ಯಾವುದೇ ಕಾರ್ಯವನ್ನು automate ಮಾಡಲು ಸಾಧ್ಯವಾಗಿಸುತ್ತದೆ.

ಶೆಲ್‌ನಲ್ಲಿ ದಿಟ್ಟತನ ಹೊಂದಿರುವುದು open-source software ಜಗತ್ತಿನಲ್ಲಿ ಸಾಗಲು ಸಹ ಬಹಳ ಉಪಯುಕ್ತ
(ಸ್ಥಾಪನಾ ಸೂಚನೆಗಳಲ್ಲಿ ಶೆಲ್ ಅಗತ್ಯವಾಗುವುದು ಸಾಮಾನ್ಯ), ನಿಮ್ಮ software projectsಗಳಿಗೆ continuous integration ನಿರ್ಮಿಸಲು
([Code Quality ಉಪನ್ಯಾಸ](/2026/code-quality/)ದಲ್ಲಿ ತಿಳಿಸಿದಂತೆ), ಮತ್ತು ಇತರೆ ಪ್ರೋಗ್ರಾಂಗಳು ವಿಫಲವಾದಾಗ ದೋಷಗಳನ್ನು debug ಮಾಡಲು.

## ಶೆಲ್‌ನಲ್ಲಿ ಸಂಚರಿಸುವುದು

ನೀವು terminal ಪ್ರಾರಂಭಿಸಿದಾಗ, ಸಾಮಾನ್ಯವಾಗಿ ಈ ರೀತಿಯಾಗಿ ಕಾಣುವ ಒಂದು _prompt_ ಕಾಣುತ್ತದೆ:

```console
missing:~$
```

ಇದು ಶೆಲ್‌ಗೆ ಮುಖ್ಯ ಪಠ್ಯ ಇಂಟರ್ಫೇಸ್. ಇದು ನೀವು `missing` ಯಂತ್ರದಲ್ಲಿದ್ದೀರಿ ಮತ್ತು ನಿಮ್ಮ
"current working directory" - ಅಂದರೆ ಈಗಿರುವ ಸ್ಥಳ - `~` ("home"ಗೆ ಸಂಕ್ಷಿಪ್ತ) ಎಂದು ಹೇಳುತ್ತದೆ.
`$` ಎಂದರೆ ನೀವು root user ಅಲ್ಲ (ಅದಕ್ಕೆ ನಂತರ ಬರುವೆವು). ಈ promptನಲ್ಲಿ ನೀವು _command_ ಟೈಪ್ ಮಾಡಬಹುದು;
ಅದನ್ನು ಶೆಲ್ ಅರ್ಥೈಸುತ್ತದೆ. ಅತಿ ಮೂಲಭೂತ ಆಜ್ಞೆ ಎಂದರೆ program ಅನ್ನು execute ಮಾಡುವುದು:

```console
missing:~$ date
Fri 10 Jan 2020 11:49:31 AM EST
missing:~$
```

ಇಲ್ಲಿ ನಾವು `date` program ಓಡಿಸಿದ್ದೇವೆ; ಅದು (ಅಪೇಕ್ಷಿತವಾಗಿಯೇ) ಪ್ರಸ್ತುತ ದಿನಾಂಕ ಮತ್ತು ಸಮಯ ಮುದ್ರಿಸುತ್ತದೆ.
ನಂತರ ಶೆಲ್ ಮುಂದಿನ ಆಜ್ಞೆಯನ್ನು ಕೇಳುತ್ತದೆ. ನಾವು _arguments_ ಜೊತೆಗೆ ಆಜ್ಞೆಯನ್ನು ಓಡಿಸಬಹುದು:

```console
missing:~$ echo hello
hello
```

ಈ ಸಂದರ್ಭದಲ್ಲಿ, `echo` program ಅನ್ನು `hello` argument ಜೊತೆ ಓಡಿಸಲು ಶೆಲ್‌ಗೆ ತಿಳಿಸಿದ್ದೇವೆ.
`echo` program ತನ್ನ arguments ಅನ್ನು ಮುದ್ರಿಸುತ್ತದೆ. ಶೆಲ್ ಆಜ್ಞೆಯನ್ನು whitespace ಆಧರಿಸಿ ವಿಭಜಿಸಿ,
ಮೊದಲ ಪದ ಸೂಚಿಸುವ program ಅನ್ನು ಓಡಿಸಿ, ನಂತರದ ಪ್ರತಿಯೊಂದು ಪದವನ್ನು program ಪ್ರವೇಶಿಸಬಹುದಾದ argument ಆಗಿ ನೀಡುತ್ತದೆ.
ನೀವು spaces ಅಥವಾ ಇತರೆ ವಿಶೇಷ ಅಕ್ಷರಗಳನ್ನು ಹೊಂದಿರುವ argument ನೀಡಬೇಕಾದರೆ (ಉದಾ., "My Photos" ಎಂಬ directory),
argument ಅನ್ನು `'` ಅಥವಾ `"` ("My Photos") ಮೂಲಕ quote ಮಾಡಬಹುದು, ಅಥವಾ ಅಗತ್ಯ ಅಕ್ಷರಗಳನ್ನು ಮಾತ್ರ `\`
(`My\ Photos`) ಮೂಲಕ escape ಮಾಡಬಹುದು.

ಆರಂಭಿಕ ಹಂತದಲ್ಲಿ ಅತ್ಯಂತ ಪ್ರಮುಖ ಆಜ್ಞೆಗಳಲ್ಲಿ ಒಂದು `man` - "manual"ಗೆ ಸಂಕ್ಷಿಪ್ತ.
`man` program, ಇತರೆ ಅನೇಕ ವಿಷಯಗಳ ಜೊತೆ, ನಿಮ್ಮ systemನಲ್ಲಿರುವ ಯಾವುದೇ command ಬಗ್ಗೆ ಹೆಚ್ಚಿನ ಮಾಹಿತಿ ನೀಡುತ್ತದೆ.
ಉದಾಹರಣೆಗೆ, `man date` ಓಡಿಸಿದರೆ, `date` ಏನು ಮತ್ತು ಅದರ ವರ್ತನೆ ಬದಲಿಸಲು ಯಾವ ಯಾವ arguments ಬಳಸಬಹುದು ಎಂಬುದನ್ನು ವಿವರಿಸುತ್ತದೆ.
ಹೆಚ್ಚಿನ commandsಗಳಿಗೆ `--help` argument ಕೊಟ್ಟರೂ ಸಂಕ್ಷಿಪ್ತ ಸಹಾಯ ಸಿಗುತ್ತದೆ.

> `man` ಜೊತೆಗೆ [`tldr`](https://tldr.sh/) ಅನ್ನು ಸ್ಥಾಪಿಸಿ ಬಳಸುವುದನ್ನು ಪರಿಗಣಿಸಿ,
> ಏಕೆಂದರೆ ಅದು terminalನಲ್ಲೇ ಸಾಮಾನ್ಯ ಬಳಕೆ ಉದಾಹರಣೆಗಳನ್ನು ತೋರಿಸುತ್ತದೆ.
> commands ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತವೆ ಮತ್ತು ನಿಮ್ಮ ಗುರಿ ಸಾಧಿಸಲು ಅವನ್ನು ಹೇಗೆ ಬಳಸುವುದು ಎಂಬುದನ್ನು ವಿವರಿಸುವಲ್ಲಿ
> LLMs ಸಹ ಸಾಮಾನ್ಯವಾಗಿ ತುಂಬಾ ಉತ್ತಮವಾಗಿರುತ್ತವೆ.

`man` ನಂತರ ಕಲಿಯಬೇಕಾದ ಅತ್ಯಂತ ಪ್ರಮುಖ command ಎಂದರೆ `cd` - "change directory".
ಈ command ಶೆಲ್‌ನಲ್ಲೇ built-in ಆಗಿದೆ; ಬೇರೆ program ಅಲ್ಲ (ಅಂದರೆ `which cd` ನೀಡಿದರೆ "no cd found" ಎಂದು ಹೇಳುತ್ತದೆ).
ಇದಕ್ಕೆ ನೀವು path ನೀಡಿದರೆ, ಆ path ನಿಮ್ಮ current working directory ಆಗುತ್ತದೆ.
working directory ಬದಲಾವಣೆ promptಲ್ಲೂ ಕಾಣಿಸುತ್ತದೆ:

```console
missing:~$ cd /bin
missing:/bin$ cd /
missing:/$ cd ~
missing:~$
```

> ಶೆಲ್‌ನಲ್ಲಿ auto-completion ಇದೆ - `<TAB>` ಒತ್ತುವುದರಿಂದ pathಗಳನ್ನು ಬೇಗ ಪೂರ್ಣಗೊಳಿಸಬಹುದು!

ಬಹಳ commandsನಲ್ಲಿ ಬೇರೆದೇನೂ ಸೂಚಿಸದಿದ್ದರೆ current working directory ಮೇಲೇ ಕಾರ್ಯ ನಡೆಯುತ್ತದೆ.
ನೀವು ಎಲ್ಲಿದ್ದೀರಿ ಎಂಬುದು ಗೊಂದಲವಾಗಿದೆಯಾದರೆ, `pwd` ಓಡಿಸಿ ಅಥವಾ `$PWD` environment variable ಅನ್ನು
(`echo $PWD`) ಮುದ್ರಿಸಿ - ಎರಡೂ current working directory ನೀಡುತ್ತವೆ.

current working directory ಮತ್ತೊಂದು ರೀತಿಯಲ್ಲೂ ಉಪಯುಕ್ತ - ಇದರಿಂದ _relative_ paths ಬಳಸಬಹುದು.
ಇಲ್ಲಿವರೆಗೂ ಕಂಡ pathsಗಳು _absolute_ - ಅವು `/` ಮೂಲಕ ಪ್ರಾರಂಭವಾಗಿ file system root (`/`)ದಿಂದ
ಒಂದು ಸ್ಥಳಕ್ಕೆ ತಲುಪಲು ಬೇಕಾದ ಸಂಪೂರ್ಣ directories ಸರಣಿಯನ್ನು ನೀಡುತ್ತವೆ. ಪ್ರಾಯೋಗಿಕವಾಗಿ,
ನೀವು ಹೆಚ್ಚಾಗಿ relative paths ಬಳಸುತ್ತೀರಿ; ಹೆಸರೇ ಸೂಚಿಸುವಂತೆ ಅವು current working directoryಗೆ ಸಂಬಂಧಿತ.
relative pathನಲ್ಲಿ (`/` ರಿಂದ ಪ್ರಾರಂಭವಾಗದ ಯಾವುದಾದರೂ), ಮೊದಲ path ಘಟಕವನ್ನು current working directoryಯಲ್ಲಿ ಹುಡುಕಲಾಗುತ್ತದೆ,
ಮತ್ತಿನ ಘಟಕಗಳು ಸಾಮಾನ್ಯವಾಗಿ ಸಾಗುತ್ತವೆ. ಉದಾಹರಣೆ:

```console
missing:~$ cd /
missing:/$ cd bin
missing:/bin$
```

ಪ್ರತಿ directoryಯಲ್ಲೂ ಎರಡು "special" ಘಟಕಗಳಿವೆ: `.` ಮತ್ತು `..`.
`.` ಎಂದರೆ "ಈ directory", ಮತ್ತು `..` ಎಂದರೆ "parent directory".
ಹೀಗಾಗಿ:

```console
missing:~$ cd /
missing:/$ cd bin/../bin/../bin/././../bin/..
missing:/$
```

ಯಾವುದೇ command argumentಗೆ absolute ಮತ್ತು relative paths ಎರಡನ್ನೂ ಸಾಮಾನ್ಯವಾಗಿ ಪರಸ್ಪರ ಬದಲಾಗಿ ಬಳಸಬಹುದು;
relative path ಬಳಸುವಾಗ ನಿಮ್ಮ current working directory ಏನು ಎಂಬುದನ್ನು ಮಾತ್ರ ಗಮನದಲ್ಲಿಡಿ!

> ನಿಮ್ಮ `cd` ಬಳಕೆಯನ್ನು ವೇಗಗೊಳಿಸಲು
> [`zoxide`](https://github.com/ajeetdsouza/zoxide) ಅನ್ನು ಸ್ಥಾಪಿಸಿ ಬಳಸುವುದನ್ನು ಪರಿಗಣಿಸಿ - `z`
> ನೀವು ಹೆಚ್ಚಾಗಿ ಹೋಗುವ pathsಗಳನ್ನು ನೆನಪಿಡುತ್ತದೆ ಮತ್ತು ಕಡಿಮೆ typing ಮೂಲಕ ಅಲ್ಲಿ ಕೊಂಡೊಯ್ಯುತ್ತದೆ.

## ಶೆಲ್‌ನಲ್ಲಿ ಏನು ಲಭ್ಯವಿದೆ?

ಆದರೆ ಶೆಲ್ `date` ಅಥವಾ `echo` ಮಾದರಿಯ ಪ್ರೋಗ್ರಾಂಗಳನ್ನು ಹೇಗೆ ಕಂಡುಹಿಡಿಯುತ್ತದೆ?
ಶೆಲ್‌ಗೆ command execute ಮಾಡಲು ಹೇಳಿದಾಗ, ಅದು `$PATH` ಎನ್ನುವ _environment variable_ ನೋಡುತ್ತದೆ,
ಅದರಲ್ಲೇ command ನೀಡಿದಾಗ programs ಹುಡುಕಬೇಕಾದ directories ಪಟ್ಟಿ ಇರುತ್ತದೆ:

```console
missing:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
missing:~$ which echo
/bin/echo
missing:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

ನಾವು `echo` command ಓಡಿಸಿದಾಗ, ಶೆಲ್ `echo` program ಓಡಿಸಬೇಕು ಎಂದು ಕಂಡು,
`$PATH`ನಲ್ಲಿರುವ `:`-ವಿಭಜಿತ directory ಪಟ್ಟಿಯಲ್ಲಿ ಆ ಹೆಸರಿನ file ಹುಡುಕುತ್ತದೆ.
ಕಂಡುಬಂದ ನಂತರ ಅದನ್ನು ಓಡಿಸುತ್ತದೆ (file _executable_ ಆಗಿದೆ ಎಂದು ಊಹಿಸಿ - ಅದಕ್ಕೆ ನಂತರ ಬರುತ್ತೇವೆ).
ಯಾವ program ಹೆಸರು ಯಾವ file ಅನ್ನು execute ಮಾಡುತ್ತಿದೆ ಎಂದು ತಿಳಿಯಲು `which` ಬಳಸಬಹುದು.
ನಾವು execute ಮಾಡಬೇಕಾದ fileಗೆ _path_ ನೇರವಾಗಿ ನೀಡಿ `$PATH` ಅನ್ನು ಸಂಪೂರ್ಣವಾಗಿ ಕಡೆಗಣಿಸಬಹುದು.

ಇದರಿಂದ ಶೆಲ್‌ನಲ್ಲಿ ನಾವು execute ಮಾಡಬಹುದಾದ _ಎಲ್ಲಾ_ programs ಕಂಡುಹಿಡಿಯುವ ಸುಳಿವು ಸಹ ಸಿಗುತ್ತದೆ:
`$PATH`ನಲ್ಲಿರುವ ಎಲ್ಲಾ directories ಒಳಗಿನ ವಿಷಯವನ್ನು ಪಟ್ಟಿ ಮಾಡುವುದು. ಅದನ್ನು `ls` programಗೆ
directory path ನೀಡಿ ಮಾಡಬಹುದು; `ls` files ಪಟ್ಟಿ ಮಾಡುತ್ತದೆ:

```console
missing:~$ ls /bin
```

> ಹೆಚ್ಚು ಮಾನವ ಸ್ನೇಹಿ `ls` ಅನುಭವಕ್ಕಾಗಿ [`eza`](https://eza.rocks/) ಅನ್ನು ಸ್ಥಾಪಿಸಿ ಬಳಸುವುದನ್ನು ಪರಿಗಣಿಸಿ.

ಇದು ಹೆಚ್ಚಿನ ಕಂಪ್ಯೂಟರ್‌ಗಳಲ್ಲಿ _ಬಹಳ_ programs ಮುದ್ರಿಸುತ್ತದೆ, ಆದರೆ ಇಲ್ಲಿ ಕೆಲವು ಪ್ರಮುಖಗಳನ್ನು ಮಾತ್ರ ನೋಡೋಣ.
ಮೊದಲು ಕೆಲವು ಸರಳವಾದವುಗಳು:

- `cat file` - `file`ನ ವಿಷಯವನ್ನು ಮುದ್ರಿಸುತ್ತದೆ.
- `sort file` - `file`ನ ಸಾಲುಗಳನ್ನು sorted ಕ್ರಮದಲ್ಲಿ ಮುದ್ರಿಸುತ್ತದೆ.
- `uniq file` - `file`ನಲ್ಲಿನ ಪಕ್ಕಪಕ್ಕದ ಪುನರಾವರ್ತಿತ ಸಾಲುಗಳನ್ನು ತೆಗೆದುಹಾಕುತ್ತದೆ.
- `head file` ಮತ್ತು `tail file` - ಕ್ರಮವಾಗಿ `file`ನ ಮೊದಲ ಮತ್ತು ಕೊನೆಯ ಕೆಲವು ಸಾಲುಗಳನ್ನು ಮುದ್ರಿಸುತ್ತವೆ.

> syntax highlighting ಮತ್ತು scrollingಗಾಗಿ `cat` ಬದಲು [`bat`](https://github.com/sharkdp/bat)
> ಅನ್ನು ಸ್ಥಾಪಿಸಿ ಬಳಸುವುದನ್ನು ಪರಿಗಣಿಸಿ.

`grep pattern file` ಎಂಬ command ಸಹ ಇದೆ; ಇದು `file`ನಲ್ಲಿ `pattern` ಗೆ ಹೊಂದುವ ಸಾಲುಗಳನ್ನು ಕಂಡುಹಿಡಿಯುತ್ತದೆ.
ಇದಕ್ಕೆ ಸ್ವಲ್ಪ ಹೆಚ್ಚುವರಿ ಗಮನ ಬೇಕು - ಇದು _ತುಂಬಾ_ ಉಪಯುಕ್ತವಾಗಿದ್ದು ನಿರೀಕ್ಷೆಗಿಂತ ಹೆಚ್ಚಿನ ವೈಶಿಷ್ಟ್ಯಗಳನ್ನೂ ಹೊಂದಿದೆ.
`pattern` ವಾಸ್ತವವಾಗಿ _regular expression_; ಇದು ಬಹಳ ಜಟಿಲ ಮಾದರಿಗಳನ್ನು ವ್ಯಕ್ತಪಡಿಸಬಲ್ಲದು -
ಅವುಗಳನ್ನು [Code Quality ಉಪನ್ಯಾಸದಲ್ಲಿ](/2026/code-quality/#regular-expressions) ನೋಡುತ್ತೇವೆ.
ನೀವು file ಬದಲು directory ನೀಡಬಹುದು (ಅಥವಾ ನೀಡದೆ `.` ಬಳಸಬಹುದು) ಮತ್ತು `-r` ಕೊಟ್ಟರೆ
directoryಯಲ್ಲಿನ ಎಲ್ಲಾ filesಗಳನ್ನು recursive ಆಗಿ ಹುಡುಕಬಹುದು.

> ಹೆಚ್ಚು ವೇಗದ ಮತ್ತು ಮಾನವ ಸ್ನೇಹಿ (ಆದರೆ ಕಡಿಮೆ portable) ಪರ್ಯಾಯಕ್ಕಾಗಿ
> `grep` ಬದಲು [`ripgrep`](https://github.com/BurntSushi/ripgrep) ಬಳಸುವುದನ್ನು ಪರಿಗಣಿಸಿ.
> `ripgrep` ಡೀಫಾಲ್ಟ್ ಆಗಿಯೇ current working directoryಯನ್ನು recursive ಆಗಿ ಹುಡುಕುತ್ತದೆ!

ಇನ್ನೂ ಸ್ವಲ್ಪ ಜಟಿಲ ಇಂಟರ್ಫೇಸ್ ಹೊಂದಿದ, ಆದರೆ ಬಹಳ ಉಪಯುಕ್ತ ಸಾಧನಗಳೂ ಇವೆ.
ಮೊದಲದು `sed`, ಇದು ಪ್ರೋಗ್ರಾಮ್ಯಾಟಿಕ್ file editor. filesಗಳಿಗೆ automated edits ಮಾಡಲು ಇದಕ್ಕೇ ತನ್ನದೇ programming language ಇದೆ,
ಆದರೆ ಅತ್ಯಂತ ಸಾಮಾನ್ಯ ಬಳಕೆ ಹೀಗಿದೆ:

```console
missing:~$ sed -i 's/pattern/replacement/g' file
```

ಇದು `file`ನಲ್ಲಿನ `pattern` ಎಲ್ಲ occurrenceಗಳನ್ನು `replacement` ನಿಂದ ಬದಲಿಸುತ್ತದೆ.
`-i` ಎಂದರೆ substitutions inline ಆಗಿಯೇ ನಡೆಯಬೇಕು (ಅಂದರೆ `file` ಬದಲಿಸದೆ substituted output ಮುದ್ರಿಸುವುದಲ್ಲ).
`s/` ಎಂದರೆ substitution ಮಾಡಲು sed ಭಾಷೆಯ ಸೂಚನೆ. `/` pattern ಮತ್ತು replacement ಅನ್ನು ಬೇರ್ಪಡಿಸುತ್ತದೆ.
ಕೊನೆಯ `/g` ಪ್ರತಿ ಸಾಲಿನಲ್ಲಿ ಮೊದಲ occurrence ಮಾತ್ರವಲ್ಲ, _ಎಲ್ಲ_ occurrences ಬದಲಿಸಬೇಕು ಎಂದು ಸೂಚಿಸುತ್ತದೆ.
`grep`ನಲ್ಲಿ ಇದ್ದಂತೆ, ಇಲ್ಲಿ `pattern` regular expression ಆಗಿದೆ, ಅದು ನಿಮ್ಮಿಗೆ ಹೆಚ್ಚಿನ ಅಭಿವ್ಯಕ್ತಿ ಶಕ್ತಿ ನೀಡುತ್ತದೆ.
regular expression substitutionsನಲ್ಲಿ `replacement` matched patternನ ಭಾಗಗಳನ್ನು ಮರುಉಲ್ಲೇಖಿಸಬಹುದೂ ಇದೆ;
ಸ್ವಲ್ಪದಲ್ಲೇ ಅದರ ಉದಾಹರಣೆ ನೋಡುತ್ತೇವೆ.

ಮುಂದೆ `find` ಇದೆ; ಇದು ನಿರ್ದಿಷ್ಟ ಷರತ್ತುಗಳಿಗೆ ಹೊಂದುವ filesಗಳನ್ನು (recursive ಆಗಿ) ಕಂಡುಹಿಡಿಯಲು ಸಹಾಯಮಾಡುತ್ತದೆ.
ಉದಾಹರಣೆ:

```console
missing:~$ find ~/Downloads -type f -name "*.zip" -mtime +30
```

ಇದು download directoryಯಲ್ಲಿ 30 ದಿನಗಳಿಗಿಂತ ಹಳೆಯ ZIP filesಗಳನ್ನು ಹುಡುಕುತ್ತದೆ.

```console
missing:~$ find ~ -type f -size +100M -exec ls -lh {} \;
```

ಇದು ನಿಮ್ಮ home directoryಯಲ್ಲಿನ 100Mಕ್ಕಿಂತ ದೊಡ್ಡ filesಗಳನ್ನು ಹುಡುಕಿ ಪಟ್ಟಿ ಮಾಡುತ್ತದೆ.
`-exec` ಒಂದು _command_ ಅನ್ನು ಸ್ವತಂತ್ರ `;` ಮೂಲಕ ಅಂತ್ಯಗೊಳಿಸಿ ಪಡೆಯುತ್ತದೆ (space ಹಾಗೆ ಇದನ್ನೂ escape ಮಾಡಬೇಕು),
ಮತ್ತು `{}` ಸ್ಥಾನದಲ್ಲಿ `find` ಪ್ರತಿ matching file path ಇಡುತ್ತದೆ ಎಂಬುದನ್ನು ಗಮನಿಸಿ.

```console
missing:~$ find . -name "*.py" -exec grep -l "TODO" {} \;
```

ಇದು TODO items ಹೊಂದಿರುವ `.py` filesಗಳನ್ನು ಕಂಡುಹಿಡಿಯುತ್ತದೆ.

`find` syntax ಸ್ವಲ್ಪ ಭಯ ಹುಟ್ಟಿಸುವಂತೆ ತೋರುವ ಸಾಧ್ಯತೆ ಇದೆ, ಆದರೆ ಇದು ಎಷ್ಟು ಉಪಯುಕ್ತವೋ ಎಂಬ ಭಾವನೆಯನ್ನು ಇದರಿಂದ ಪಡೆಯಬಹುದು!

> ಹೆಚ್ಚು ಮಾನವ ಸ್ನೇಹಿ (ಆದರೆ ಕಡಿಮೆ portable!) ಅನುಭವಕ್ಕಾಗಿ
> `find` ಬದಲು [`fd`](https://github.com/sharkdp/fd) ಅನ್ನು ಸ್ಥಾಪಿಸಿ ಬಳಸುವುದನ್ನು ಪರಿಗಣಿಸಿ.

ಮುಂದಿನದು `awk`; `sed`ನಂತೆ ಇದಕ್ಕೂ ತನ್ನದೇ programming language ಇದೆ.
`sed` filesಗಳನ್ನು edit ಮಾಡಲು ನಿರ್ಮಿತವಾದರೆ, `awk` ಅವನ್ನು parse ಮಾಡಲು ನಿರ್ಮಿತವಾಗಿದೆ.
`awk`ಯ ಅತ್ಯಂತ ಸಾಮಾನ್ಯ ಬಳಕೆ ಎಂದರೆ ನಿಯಮಿತ syntax ಇರುವ data files (ಉದಾ., CSV)ಗಳಲ್ಲಿ,
ಪ್ರತಿ record (ಅಂದರೆ ಸಾಲು)ಯ ಕೆಲವು ನಿರ್ದಿಷ್ಟ ಭಾಗಗಳನ್ನು ಮಾತ್ರ ತೆಗೆದುಹಾಕುವುದು:

```console
missing:~$ awk '{print $2}' file
```

ಇದು `file`ನ ಪ್ರತಿಯೊಂದು ಸಾಲಿನ whitespace-separated ಎರಡನೇ column ಮುದ್ರಿಸುತ್ತದೆ.
`-F,` ಸೇರಿಸಿದರೆ ಪ್ರತಿಯೊಂದು ಸಾಲಿನ comma-separated ಎರಡನೇ column ಮುದ್ರಿಸುತ್ತದೆ.
`awk` ಇದಕ್ಕಿಂತ ತುಂಬಾ ಹೆಚ್ಚನ್ನು ಮಾಡಬಲ್ಲದು - ಸಾಲುಗಳನ್ನು filter ಮಾಡುವುದು, aggregates ಲೆಕ್ಕಿಸುವುದು,
ಮತ್ತಷ್ಟು - ಸ್ವಲ್ಪ ಅನುಭವಕ್ಕೆ ವ್ಯಾಯಾಮಗಳನ್ನು ನೋಡಿ.

ಈ ಸಾಧನಗಳನ್ನು ಒಟ್ಟುಗೂಡಿಸಿದಾಗ, ನಾವು ಹೀಗೆ ಚೆನ್ನಾದ ಕೆಲಸಗಳನ್ನು ಮಾಡಬಹುದು:

```console
missing:~$ ssh myserver 'journalctl -u sshd -b-1 | grep "Disconnected from"' \
  | sed -E 's/.*Disconnected from .* user (.*) [^ ]+ port.*/\1/' \
  | sort | uniq -c \
  | sort -nk1,1 | tail -n10 \
  | awk '{print $2}' | paste -sd,
postgres,mysql,oracle,dell,ubuntu,inspur,test,admin,user,root
```

ಇದು remote serverನ SSH logs ತೆಗೆದು (ಮುಂದಿನ ಉಪನ್ಯಾಸದಲ್ಲಿ `ssh` ಬಗ್ಗೆ ಹೆಚ್ಚು ನೋಡುತ್ತೇವೆ),
disconnect messages ಹುಡುಕಿ, ಪ್ರತಿಯೊಂದು messageನಿಂದ username ತೆಗೆಯುತ್ತದೆ, ಮತ್ತು top 10 usernames ಅನ್ನು
comma-separated ರೂಪದಲ್ಲಿ ಮುದ್ರಿಸುತ್ತದೆ. ಒಂದೇ commandನಲ್ಲಿ! ಪ್ರತಿ ಹಂತವನ್ನು ವಿಶ್ಲೇಷಿಸುವುದನ್ನು ವ್ಯಾಯಾಮವಾಗಿ ಬಿಡುತ್ತೇವೆ.

## ಶೆಲ್ ಭಾಷೆ (bash)

ಹಿಂದಿನ ಉದಾಹರಣೆಯಲ್ಲಿ ಹೊಸ ಪರಿಕಲ್ಪನೆ ಬಂತು: pipes (`|`). ಇವು ಒಂದು programನ output ಅನ್ನು
ಮತ್ತೊಂದು programನ input ಜೊತೆ ಜೋಡಿಸುತ್ತವೆ. ಇದು ಕೆಲಸ ಮಾಡುವುದು ಏಕೆಂದರೆ command-line programsನ ಬಹುಪಾಲು,
`file` argument ಕೊಡದಿದ್ದರೆ ಅವು "standard input" (ಸಾಮಾನ್ಯವಾಗಿ ನಿಮ್ಮ keystrokes ಹೋಗುವ ಸ್ಥಳ) ಮೇಲೆ ಕಾರ್ಯನಿರ್ವಹಿಸುತ್ತವೆ.
`|` ಅಚ್ಚುಕಟ್ಟಾಗಿ `|` ಮುಂಚಿನ programನ "standard output" (ಸಾಮಾನ್ಯವಾಗಿ terminalಗೆ ಮುದ್ರವಾಗುವುದು)
ತೆಗೆದು `|` ನಂತರದ programಗೆ standard input ಆಗಿ ನೀಡುತ್ತದೆ. ಇದರಿಂದ ನೀವು shell programs ಅನ್ನು _compose_
ಮಾಡಬಹುದು - ಮತ್ತು ಇದು ಶೆಲ್ ಅನ್ನು ಅತ್ಯಂತ ಉತ್ಪಾದಕ ಪರಿಸರವಾಗಿಸುವ ಪ್ರಮುಖ ಕಾರಣಗಳಲ್ಲಿ ಒಂದು!

ವಾಸ್ತವವಾಗಿ, ಬಹುತೇಕ ಶೆಲ್‌ಗಳು bashನಂತೆ ಸಂಪೂರ್ಣ programming language ಅನ್ನು ಜಾರಿಗೊಳಿಸುತ್ತವೆ,
Python ಅಥವಾ Rubyಯಂತೆಯೇ. ಇದರಲ್ಲಿ variables, conditionals, loops, ಮತ್ತು functions ಇವೆ.
ನೀವು ಶೆಲ್‌ನಲ್ಲಿ commands ಓಡಿಸುವಾಗ, ಶೆಲ್ ಅರ್ಥೈಸುವ ಸಣ್ಣ ಕೋಡ್ ತುಣುಕನ್ನೇ ಬರೆಯುತ್ತಿದ್ದೀರಿ.
ಇಂದು ಸಂಪೂರ್ಣ bash ಕಲಿಸುವುದಿಲ್ಲ, ಆದರೆ ಕೆಲವು ಉಪಯುಕ್ತ ಅಂಶಗಳು ಇಲ್ಲಿವೆ:

ಮೊದಲು redirects: `>file` programನ standard output ಅನ್ನು terminalಗೆ ಬದಲಾಗಿ `file`ಗೆ ಬರೆಯಲು ಅನುಮತಿಸುತ್ತದೆ.
ಇದರಿಂದ ನಂತರ ವಿಶ್ಲೇಷಿಸಲು ಸುಲಭವಾಗುತ್ತದೆ. `>>file` ಬಳಸಿದರೆ overwrite ಮಾಡುವ ಬದಲು `file`ಗೆ append ಮಾಡುತ್ತದೆ.
`<file` ಸಹ ಇದೆ; ಇದು programಗೆ standard input ನಿಮ್ಮ keyboardನಿಂದ ಅಲ್ಲ, `file`ನಿಂದ ಓದಲು ಶೆಲ್‌ಗೆ ಸೂಚಿಸುತ್ತದೆ.

> ಇಲ್ಲಿ `tee` program ಉಲ್ಲೇಖಿಸಲು ಒಳ್ಳೆಯ ಸಮಯ. `tee` standard input ಅನ್ನು standard outputಗೆ ಮುದ್ರಿಸುತ್ತದೆ
> (`cat` ಹಾಗೆ), ಆದರೆ _ಹಾಗೆಯೇ_ ಅದನ್ನು fileಗೂ ಬರೆಯುತ್ತದೆ. ಹೀಗಾಗಿ
> `verbose cmd | tee verbose.log | grep CRITICAL`
> ಸಂಪೂರ್ಣ verbose log ಅನ್ನು fileನಲ್ಲಿ ಉಳಿಸಿಕೊಂಡೇ ನಿಮ್ಮ terminal ಸ್ವಚ್ಛವಾಗಿರಲು ಸಹಾಯಮಾಡುತ್ತದೆ!

ಮುಂದೆ conditionals: `if command1; then command2; command3; fi` ಮೊದಲು `command1` execute ಮಾಡುತ್ತದೆ,
ಮತ್ತು ಅದು error ಕೊಟ್ಟಿಲ್ಲದಿದ್ದರೆ `command2` ಮತ್ತು `command3` ಓಡಿಸುತ್ತದೆ.
ಬೇಕಾದರೆ `else` branch ಕೂಡ ಇರಿಸಬಹುದು. `command1` ಆಗಿ ಅತ್ಯಂತ ಸಾಮಾನ್ಯವಾಗಿ ಬಳಸುವ command ಎಂದರೆ `test`;
ಇದನ್ನು ಸಾಮಾನ್ಯವಾಗಿ `[ ` ರೂಪಕ್ಕೂ ಸಂಕ್ಷಿಪ್ತಗೊಳಿಸುತ್ತಾರೆ. ಇದು "file ಅಸ್ತಿತ್ವದಲ್ಲಿದೆಯೇ" (`test -f file` / `[ -f file ]`)
ಅಥವಾ "string ಮತ್ತೊಂದು stringಗೆ ಸಮಾನವೇ" (`[ "$var" = "string" ]`) ಮುಂತಾದ ಷರತ್ತುಗಳನ್ನು ಪರೀಕ್ಷಿಸಲು ನೆರವಾಗುತ್ತದೆ.
bashನಲ್ಲಿ `[[ ]]` ಕೂಡ ಇದೆ; ಇದು quoting ಸಂಬಂಧಿತ ವಿಚಿತ್ರ ವರ್ತನೆಗಳು ಕಡಿಮೆ ಇರುವ, `test`ನ "safer" built-in ರೂಪ.

bashನಲ್ಲಿ ಎರಡು ವಿಧದ loops ಇವೆ: `while` ಮತ್ತು `for`.
`while command1; do command2; command3; done` ಸಮಾನ `if` ರೂಪದಂತೆಯೇ ಕಾರ್ಯನಿರ್ವಹಿಸುತ್ತದೆ,
ಆದರೆ `command1` error ಕೊಡದವರೆಗೆ ಇದನ್ನು ಪುನಃ ಪುನಃ ಚಲಾಯಿಸುತ್ತದೆ.
`for varname in a b c d; do command; done` `command` ಅನ್ನು ನಾಲ್ಕು ಬಾರಿ execute ಮಾಡುತ್ತದೆ,
ಪ್ರತಿ ಬಾರಿ `$varname`ಗೆ `a`, `b`, `c`, `d` ಮೌಲ್ಯಗಳನ್ನು ಕ್ರಮವಾಗಿ ನೇಮಿಸಿ.
items ಅನ್ನು ಸ್ಪಷ್ಟವಾಗಿ ಪಟ್ಟಿ ಮಾಡುವ ಬದಲು, ನೀವು ಹೆಚ್ಚಾಗಿ "command substitution" ಬಳಸುತ್ತೀರಿ, ಉದಾಹರಣೆಗೆ:

```bash
for i in $(seq 1 10); do
```

ಇದು `seq 1 10` command execute ಮಾಡುತ್ತದೆ (1ರಿಂದ 10ವರೆಗೆ ಸಂಖ್ಯೆಗಳನ್ನು ಮುದ್ರಿಸುವುದು),
ನಂತರ ಸಂಪೂರ್ಣ `$()` ಅನ್ನು ಆ commandನ output ನಿಂದ ಬದಲಿಸುತ್ತದೆ. ಹೀಗೆ ನಿಮಗೆ 10-iteration for loop ಸಿಗುತ್ತದೆ.
ಹಳೆಯ codeನಲ್ಲಿ ಕೆಲವೊಮ್ಮೆ literal backticks ಕಾಣಬಹುದು (``for i in `seq 1 10`; do``)
`$()` ಬದಲು, ಆದರೆ `$()` nested ಆಗುವ ಕಾರಣ ನೀವು ಅದನ್ನೇ ಬಲವಾಗಿ ಆಯ್ಕೆಮಾಡಬೇಕು.

ನೀವು promptಲ್ಲೇ ಉದ್ದವಾದ shell scripts ಬರೆಯಬಹುದಾದರೂ, ಸಾಮಾನ್ಯವಾಗಿ ಅವನ್ನು `.sh` fileನಲ್ಲಿ ಬರೆಯುವುದು ಉತ್ತಮ.
ಉದಾಹರಣೆಗೆ, ಕೆಳಗಿನ script program ವಿಫಲವಾಗುವವರೆಗೆ loopನಲ್ಲಿ ಓಡಿಸುತ್ತದೆ,
ವಿಫಲವಾದ runನ output ಮಾತ್ರ ತೋರಿಸಿ, backgroundನಲ್ಲಿ CPUಗೆ ಒತ್ತಡ ಕೊಡುತ್ತದೆ
(ಉದಾ. flaky tests ಮರುಉತ್ಪಾದಿಸಲು ಉಪಯುಕ್ತ):

```bash
#!/bin/bash
set -euo pipefail

# Start CPU stress in background
stress --cpu 8 &
STRESS_PID=$!

# Setup log file
LOGFILE="test_runs_$(date +%s).log"
echo "Logging to $LOGFILE"

# Run tests until one fails
RUN=1
while cargo test my_test > "$LOGFILE" 2>&1; do
    echo "Run $RUN passed"
    ((RUN++))
done

# Cleanup and report
kill $STRESS_PID
echo "Test failed on run $RUN"
echo "Last 20 lines of output:"
tail -n 20 "$LOGFILE"
echo "Full log: $LOGFILE"
```

ಇದರಲ್ಲಿ ಹಲವಾರು ಹೊಸ ಅಂಶಗಳಿವೆ; ಅವುಗಳನ್ನು ಅನ್ವೇಷಿಸಲು ನಿಮಗೆ ಸ್ವಲ್ಪ ಸಮಯ ಕಳೆಯಲು ಶಿಫಾರಸು ಮಾಡುತ್ತೇನೆ,
ಏಕೆಂದರೆ ಉಪಯುಕ್ತ shell invocations ರೂಪಿಸಲು ಅವು ತುಂಬಾ ನೆರವಾಗುತ್ತವೆ - ಉದಾ. programsಗಳನ್ನು ಸಮಕಾಲಿಕವಾಗಿ ಓಡಿಸುವ
background jobs (`&`), ಸ್ವಲ್ಪ ಜಟಿಲ [shell
redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html),
ಮತ್ತು [arithmetic
expansion](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html).

ಆದರೂ programನ ಮೊದಲ ಎರಡು ಸಾಲುಗಳ ಬಗ್ಗೆ ಒಂದು ಕ್ಷಣ ಗಮನಿಸುವುದು ಸೂಕ್ತ.
ಮೊದಲದು "shebang" - ಶೆಲ್ scripts ಮಾತ್ರವಲ್ಲದೆ ಇತರೆ files ಮೇಲೆಯೂ ಇದನ್ನು ನೋಡುತ್ತೀರಿ.
`#!/path` ಎಂಬ magic incantation ನಿಂದ ಆರಂಭವಾಗುವ file execute ಆದಾಗ,
ಶೆಲ್ `/path` ನಲ್ಲಿ ಇರುವ program ಆರಂಭಿಸಿ, file ವಿಷಯವನ್ನು input ಆಗಿ ಅದಕ್ಕೆ ಒದಗಿಸುತ್ತದೆ.
shell script ಸಂದರ್ಭದಲ್ಲಿ, script ವಿಷಯವನ್ನು `/bin/bash` ಗೆ ಒದಗಿಸುವುದೇ ಇದರ ಅರ್ಥ.
ಆದರೆ `/usr/bin/python` shebang line ಹೊಂದಿರುವ Python scripts ಕೂಡ ಬರೆಯಬಹುದು!

ಎರಡನೇ ಸಾಲು bash ಅನ್ನು "stricter" ಮಾಡಲು, shell scripts ಬರೆಯುವಾಗ ಕಾಣುವ ಕೆಲವು footguns ಕಡಿಮೆ ಮಾಡಲು ಬಳಸಲಾಗುತ್ತದೆ.
`set` ಬಹಳ arguments ಪಡೆಯುತ್ತದೆ; ಸಂಕ್ಷಿಪ್ತವಾಗಿ - `-e` ಯಾವುದಾದರೂ command ವಿಫಲವಾದರೆ script ಬೇಗನೆ ಹೊರಬರುವಂತೆ ಮಾಡುತ್ತದೆ;
`-u` undefined variables ಬಳಕೆಯಾದರೆ ಖಾಲಿ string ಬಳಸುವುದಕ್ಕಿಂತ script crash ಆಗುವಂತೆ ಮಾಡುತ್ತದೆ;
`-o pipefail` `|` ಸರಣಿಯಲ್ಲಿನ programs ವಿಫಲವಾದರೆ ಸಂಪೂರ್ಣ shell script ಕೂಡ ಬೇಗನೆ ಹೊರಬರುವಂತೆ ಮಾಡುತ್ತದೆ.

> Shell programming ಯಾವ programming language ಹಾಗೆಯೇ ಆಳವಾದ ವಿಷಯ.
> ಆದರೆ ಎಚ್ಚರಿಕೆ: bashನಲ್ಲಿ gotchas ಅಸಾಮಾನ್ಯವಾಗಿ ಹೆಚ್ಚು ಇವೆ -
> ಅವುಗಳನ್ನು ಪಟ್ಟಿ ಮಾಡಲು [ಬಹು](https://tldp.org/LDP/abs/html/gotchas.html)
> [ವೆಬ್‌ಸೈಟ್‌ಗಳು](https://mywiki.wooledge.org/BashPitfalls) ಕೂಡ ಇವೆ.
> scripts ಬರೆಯುವಾಗ [shellcheck](https://www.shellcheck.net/) ಅನ್ನು ಹೆಚ್ಚು ಬಳಸಲು ನಾನು ಬಲವಾಗಿ ಶಿಫಾರಸು ಮಾಡುತ್ತೇನೆ.
> shell scripts ಬರೆಯಲು ಮತ್ತು debug ಮಾಡಲು LLMs ಸಹ ಅದ್ಭುತವಾಗಿವೆ; ಜೊತೆಗೆ bashಗೆ ತುಂಬಾ ದೊಡ್ಡದಾದಾಗ
> (100+ ಸಾಲುಗಳು) ಅವನ್ನು Python ಮಾದರಿಯ "real" programming language ಗೆ ಅನುವಾದಿಸುವುದಕ್ಕೂ ನೆರವಾಗುತ್ತವೆ.

# ಮುಂದಿನ ಹಂತಗಳು

ಈ ಹಂತದಲ್ಲಿ, ಮೂಲಭೂತ ಕೆಲಸಗಳನ್ನು ಮಾಡಲು ಬೇಕಾಗುವಷ್ಟು ಶೆಲ್ ಪರಿಚಯ ನಿಮಗಿದೆ.
ನೀವು ಆಸಕ್ತಿ ಇರುವ filesಗಳನ್ನು ಹುಡುಕಲು ಸಂಚರಿಸಬಲ್ಲಿರಿ ಮತ್ತು ಹೆಚ್ಚು programsಗಳ ಮೂಲ ಕಾರ್ಯಗಳನ್ನು ಬಳಸಬಲ್ಲಿರಿ.
ಮುಂದಿನ ಉಪನ್ಯಾಸದಲ್ಲಿ, ಶೆಲ್ ಮತ್ತು ಅನೇಕ ಉಪಯುಕ್ತ command-line programs ಬಳಸಿ ಹೆಚ್ಚು ಜಟಿಲ ಕಾರ್ಯಗಳನ್ನು
ಹೇಗೆ ಮಾಡುವುದು ಮತ್ತು automate ಮಾಡುವುದು ಎಂಬುದನ್ನು ನೋಡುತ್ತೇವೆ.

# ವ್ಯಾಯಾಮಗಳು

ಈ ಕೋರ್ಸ್‌ನ ಪ್ರತಿಯೊಂದು ತರಗತಿಯ ಜೊತೆ ಒಂದು ವ್ಯಾಯಾಮಗಳ ಸರಣಿ ಇರುತ್ತದೆ.
ಕೆಲವು ನಿರ್ದಿಷ್ಟ ಕಾರ್ಯಗಳನ್ನು ಕೇಳುತ್ತವೆ, ಇತರವು "X ಮತ್ತು Y programs ಪ್ರಯತ್ನಿಸಿ" ಎಂಬ ರೀತಿಯ open-ended ಆಗಿರುತ್ತವೆ.
ಅವನ್ನು ಪ್ರಯತ್ನಿಸಲು ನಾವು ನಿಮಗೆ ಬಲವಾಗಿ ಪ್ರೋತ್ಸಾಹಿಸುತ್ತೇವೆ.

ಈ ವ್ಯಾಯಾಮಗಳಿಗೆ ನಾವು ಪರಿಹಾರಗಳನ್ನು ಬರೆಯಿಲ್ಲ. ನೀವು ಯಾವುದಾದರೂ ವಿಷಯದಲ್ಲಿ ಸಿಲುಕಿದರೆ,
[Discord](https://ossu.dev/#community) ನ `#missing-semester-forum` ನಲ್ಲಿ ಪೋಸ್ಟ್ ಮಾಡಿ,
ಅಥವಾ ಇದುವರೆಗೆ ನೀವು ಪ್ರಯತ್ನಿಸಿದುದನ್ನು ವಿವರಿಸಿ ನಮಗೆ ಇಮೇಲ್ ಕಳುಹಿಸಿ - ನಾವು ಸಹಾಯ ಮಾಡಲು ಪ್ರಯತ್ನಿಸುತ್ತೇವೆ.
ಈ ವ್ಯಾಯಾಮಗಳು LLM ಜೊತೆ ಸಂವಾದ ಆರಂಭಿಸಲು ಪ್ರಾರಂಭಿಕ prompts ಆಗಿಯೂ ಚೆನ್ನಾಗಿ ಕೆಲಸ ಮಾಡುತ್ತವೆ,
ಅಲ್ಲಿ ನೀವು ವಿಷಯವನ್ನು ಸಂವಹನಾತ್ಮಕವಾಗಿ ಆಳಕ್ಕೆ ಅನ್ವೇಷಿಸಬಹುದು. ಈ ವ್ಯಾಯಾಮಗಳ ನಿಜವಾದ ಮೌಲ್ಯ ಉತ್ತರದಲ್ಲಲ್ಲ,
ಉತ್ತರವನ್ನು ಹುಡುಕುವ ಪ್ರಯಾಣದಲ್ಲಿದೆ. ಪರಿಹಾರಕ್ಕೆ ಅತಿ ಚಿಕ್ಕ ದಾರಿಗೆ ಮಾತ್ರ ಹೋಗುವುದಕ್ಕಿಂತ,
ವಿಷಯದ ಪಕ್ಕದ ದಾರಿಗಳನ್ನೂ ಅನುಸರಿಸಿ, ಕೆಲಸ ಮಾಡುವಾಗ "ಏಕೆ" ಎಂದು ಕೇಳುತ್ತಾ ಹೋಗುವಂತೆ ನಾವು ಪ್ರೋತ್ಸಾಹಿಸುತ್ತೇವೆ.

1. ಈ ಕೋರ್ಸ್‌ಗೆ, ನೀವು Bash ಅಥವಾ ZSH ಹೋಲುವ Unix shell ಬಳಸಬೇಕು. ನೀವು Linux ಅಥವಾ macOSನಲ್ಲಿ ಇದ್ದರೆ,
   ವಿಶೇಷವಾಗಿ ಏನೂ ಮಾಡಬೇಕಾಗಿಲ್ಲ. ನೀವು Windowsನಲ್ಲಿ ಇದ್ದರೆ, cmd.exe ಅಥವಾ PowerShell ಬಳಸುತ್ತಿಲ್ಲವೆಂದು ಖಚಿತಪಡಿಸಬೇಕು;
   Unix ಶೈಲಿಯ command-line tools ಬಳಸಲು [Windows Subsystem for
   Linux](https://docs.microsoft.com/en-us/windows/wsl/) ಅಥವಾ Linux virtual machine ಬಳಸಿ.
   ನೀವು ಸರಿಯಾದ shell ಬಳಸುತ್ತಿದ್ದೀರಿ ಎಂದು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಲು `echo $SHELL` command ಪ್ರಯತ್ನಿಸಿ.
   ಅದು `/bin/bash` ಅಥವಾ `/usr/bin/zsh` ಮಾದರಿಯದನ್ನು ತೋರಿಸಿದರೆ, ನೀವು ಸರಿಯಾದ program ಬಳಸುತ್ತಿದ್ದೀರಿ ಎಂದರ್ಥ.

1. `ls` ಗೆ ಇರುವ `-l` flag ಏನು ಮಾಡುತ್ತದೆ? `ls -l /` ಓಡಿಸಿ output ಪರಿಶೀಲಿಸಿ.
   ಪ್ರತಿ ಸಾಲಿನ ಮೊದಲ 10 ಅಕ್ಷರಗಳು ಏನನ್ನು ಸೂಚಿಸುತ್ತವೆ? (Hint: `man ls`)

1. `find ~/Downloads -type f -name "*.zip" -mtime +30` command ನಲ್ಲಿ `*.zip` ಒಂದು "glob" ಆಗಿದೆ.
   glob ಎಂದರೆ ಏನು? ಕೆಲವು files ಇರುವ ಪರೀಕ್ಷಾ directory ರಚಿಸಿ, `ls *.txt`, `ls file?.txt`,
   ಮತ್ತು `ls {a,b,c}.txt` ಮಾದರಿಗಳೊಂದಿಗೆ ಪ್ರಯೋಗ ಮಾಡಿ. Bash manualನ [Pattern
   Matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html) ನೋಡಿ.

1. `'single quotes'`, `"double quotes"`, ಮತ್ತು `$'ANSI quotes'` ಮಧ್ಯೆ ಏನು ವ್ಯತ್ಯಾಸ?
   literal `$`, ಒಂದು `!`, ಮತ್ತು newline character ಹೊಂದಿರುವ string ಅನ್ನು echo ಮಾಡುವ command ಬರೆಯಿರಿ.
   [Quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html) ನೋಡಿ.

1. ಶೆಲ್‌ಗೆ ಮೂರು standard streams ಇವೆ: stdin (0), stdout (1), ಮತ್ತು stderr (2).
   `ls /nonexistent /tmp` ಓಡಿಸಿ stdout ಅನ್ನು ಒಂದು fileಗೆ ಮತ್ತು stderr ಅನ್ನು ಮತ್ತೊಂದು fileಗೆ redirect ಮಾಡಿ.
   ಎರಡನ್ನೂ ಒಂದೇ fileಗೆ ಹೇಗೆ redirect ಮಾಡಬಹುದು? [Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html) ನೋಡಿ.

1. `$?` ಕೊನೆಯ commandನ exit status ಹಿಡಿದಿರುತ್ತದೆ (0 = success).
   `&&` ಹಿಂದಿನ command ಯಶಸ್ವಿಯಾದಾಗ ಮಾತ್ರ ಮುಂದಿನ command ಓಡಿಸುತ್ತದೆ; `||` ಹಿಂದಿನದು ವಿಫಲವಾದಾಗ ಮಾತ್ರ ಮುಂದಿನದು ಓಡಿಸುತ್ತದೆ.
   `/tmp/mydir` ಈಗಾಗಲೇ ಇಲ್ಲದಿದ್ದರೆ ಮಾತ್ರ create ಮಾಡುವ one-liner ಬರೆಯಿರಿ.
   [Exit Status](https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html) ನೋಡಿ.

1. `cd` ಏಕೆ ಶೆಲ್‌ನಲ್ಲೇ built-in ಆಗಿರಬೇಕು, standalone program ಆಗಿರಬಾರದು?
   (Hint: child process ತನ್ನ parent ಮೇಲೆ ಏನು ಪರಿಣಾಮ ಬೀರುವುದು ಮತ್ತು ಏನು ಸಾಧ್ಯವಿಲ್ಲ ಎಂಬುದನ್ನು ಯೋಚಿಸಿ.)

1. filename ಅನ್ನು argument (`$1`) ಆಗಿ ಸ್ವೀಕರಿಸುವ script ಬರೆಯಿರಿ ಮತ್ತು `test -f` ಅಥವಾ `[ -f ... ]`
   ಬಳಸಿ file ಅಸ್ತಿತ್ವದಲ್ಲಿದೆಯೇ ಎಂದು ಪರಿಶೀಲಿಸಿ. file ಇದ್ದರೂ ಇಲ್ಲದಿದ್ದರೂ ಬೇರೆ ಬೇರೆ ಸಂದೇಶ ಮುದ್ರಿಸಬೇಕು.
   [Bash Conditional
   Expressions](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html) ನೋಡಿ.

1. ಹಿಂದಿನ ವ್ಯಾಯಾಮದ script ಅನ್ನು fileಗೆ ಉಳಿಸಿ (ಉದಾ., `check.sh`).
   `./check.sh somefile` ಮೂಲಕ ಓಡಿಸಿ. ಏನಾಗುತ್ತದೆ? ಈಗ `chmod +x check.sh` ಓಡಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.
   ಈ ಹಂತ ಏಕೆ ಅಗತ್ಯ? (Hint: `chmod` ಮೊದಲು ಮತ್ತು ನಂತರ `ls -l check.sh` ನೋಡಿ.)

1. scriptನಲ್ಲಿ `set` flagsಗೆ `-x` ಸೇರಿಸಿದರೆ ಏನಾಗುತ್ತದೆ?
   ಒಂದು ಸರಳ scriptನಲ್ಲಿ ಪ್ರಯತ್ನಿಸಿ output ಗಮನಿಸಿ.
   [The Set
   Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html) ನೋಡಿ.

1. ಇಂದಿನ ದಿನಾಂಕವನ್ನು filenameನಲ್ಲಿ ಸೇರಿಸಿ file ಅನ್ನು backupಗೆ ನಕಲಿಸುವ command ಬರೆಯಿರಿ
   (ಉದಾ., `notes.txt` → `notes_2026-01-12.txt`). (Hint: `$(date
   +%Y-%m-%d)`). [Command
   Substitution](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html) ನೋಡಿ.

1. ಉಪನ್ಯಾಸದಲ್ಲಿನ flaky test script ಅನ್ನು `cargo test my_test` ಅನ್ನು hardcode ಮಾಡುವ ಬದಲು,
   test command ಅನ್ನು argument ಆಗಿ ಸ್ವೀಕರಿಸುವಂತೆ ಬದಲಿಸಿ. (Hint: `$1` ಅಥವಾ `$@`).
   [Special
   Parameters](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html) ನೋಡಿ.

1. ನಿಮ್ಮ home directoryಯಲ್ಲಿ ಅತ್ಯಂತ ಸಾಮಾನ್ಯ 5 file extensions ಕಂಡುಹಿಡಿಯಲು pipes ಬಳಸಿ.
   (Hint: `find`, `grep` ಅಥವಾ `sed` ಅಥವಾ `awk`, `sort`, `uniq -c`, ಮತ್ತು `head` ಒಟ್ಟುಗೂಡಿಸಿ.)

1. `xargs` stdinನ ಸಾಲುಗಳನ್ನು command arguments ಆಗಿ ಪರಿವರ್ತಿಸುತ್ತದೆ.
   `find` ಮತ್ತು `xargs` ಅನ್ನು (`find -exec` ಅಲ್ಲ) ಒಟ್ಟಿಗೆ ಬಳಸಿ, directoryಯಲ್ಲಿನ ಎಲ್ಲಾ `.sh` files ಕಂಡುಹಿಡಿದು,
   ಪ್ರತಿಯೊಂದರ ಸಾಲುಗಳನ್ನು `wc -l` ಮೂಲಕ ಎಣಿಸಿ. Bonus: spaces ಇರುವ filenames ಸಹ handle ಆಗುವಂತೆ ಮಾಡಿ.
   (Hint: `-print0` ಮತ್ತು `-0`). `man
   xargs` ನೋಡಿ.

1. `curl` ಬಳಸಿ course websiteನ HTML ಅನ್ನು
   (`https://missing.csail.mit.edu/`) ಪಡೆದು, ಅದನ್ನು `grep` ಗೆ pipe ಮಾಡಿ ಎಷ್ಟು ಉಪನ್ಯಾಸಗಳು ಪಟ್ಟಿ ಆಗಿವೆ ಎಂದು ಎಣಿಸಿ.
   (Hint: ಪ್ರತಿ ಉಪನ್ಯಾಸಕ್ಕೆ ಒಂದೇ ಬಾರಿ ಕಾಣುವ pattern ಹುಡುಕಿ; progress output ಮೌನಗೊಳಿಸಲು `curl -s` ಬಳಸಿ.)

1. [`jq`](https://jqlang.github.io/jq/) JSON data ಸಂಸ್ಕರಣೆಗೆ ಶಕ್ತಿಯುತ ಸಾಧನ.
   `https://microsoftedge.github.io/Demos/json-dummy-data/64KB.json` ನ sample data ಅನ್ನು `curl` ಮೂಲಕ ಪಡೆಯಿರಿ,
   ಮತ್ತು version 6ಕ್ಕಿಂತ ಹೆಚ್ಚಿರುವ ಜನರ ಹೆಸರುಗಳನ್ನು ಮಾತ್ರ ತೆಗೆಯಲು `jq` ಬಳಸಿ.
   (Hint: ರಚನೆ ನೋಡಲು ಮೊದಲು `jq .` ಗೆ pipe ಮಾಡಿ;
   ನಂತರ `jq '.[] | select(...) | .name'` ಪ್ರಯತ್ನಿಸಿ)

1. `awk` column ಮೌಲ್ಯಗಳ ಆಧಾರದ ಮೇಲೆ ಸಾಲುಗಳನ್ನು filter ಮಾಡಬಹುದು ಮತ್ತು output ಅನ್ನು ರೂಪಿಸಬಹುದು.
   ಉದಾಹರಣೆಗೆ, `awk '$3 ~ /pattern/ {$4=""; print}'` ಮೂರನೇ column `pattern` ಗೆ ಹೊಂದುವ ಸಾಲುಗಳನ್ನು ಮಾತ್ರ ಮುದ್ರಿಸುತ್ತದೆ,
   ಮತ್ತು ನಾಲ್ಕನೇ column ಅನ್ನು ಬಿಡುತ್ತದೆ. ಎರಡನೇ column 100ಕ್ಕಿಂತ ಹೆಚ್ಚಿನಾಗಿರುವ ಸಾಲುಗಳನ್ನು ಮಾತ್ರ ಮುದ್ರಿಸಿ,
   ಮೊದಲ ಮತ್ತು ಮೂರನೇ columns ಪರಸ್ಪರ ಬದಲಿಸುವ `awk` command ಬರೆಯಿರಿ.
   ಪರೀಕ್ಷೆಗೆ: `printf 'a 50 x\nb 150 y\nc 200 z\n'`

1. ಉಪನ್ಯಾಸದ SSH log pipeline ಅನ್ನು ವಿಶ್ಲೇಷಿಸಿ: ಪ್ರತಿ ಹಂತ ಏನು ಮಾಡುತ್ತದೆ?
   ನಂತರ ನಿಮ್ಮ ಹೆಚ್ಚು ಬಳಸುವ shell commands ಕಂಡುಹಿಡಿಯಲು ಅದಕ್ಕೆ ಸಮಾನದ್ದನ್ನು ನಿರ್ಮಿಸಿ
   `~/.bash_history` (ಅಥವಾ `~/.zsh_history`) ನಿಂದ.
