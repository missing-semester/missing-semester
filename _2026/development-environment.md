---
layout: lecture
title: "Development Environment ಮತ್ತು Tools"
description: >
  IDEs, Vim, language servers, ಮತ್ತು AI-powered development tools ಬಗ್ಗೆ ಕಲಿಯಿರಿ.
thumbnail: /static/assets/thumbnails/2026/lec3.png
date: 2026-01-14
ready: true
video:
  aspect: 56.25
  id: QnM1nVzrkx8
---

_development environment_ ಎಂದರೆ software ಅಭಿವೃದ್ಧಿಗೆ ಬಳಸುವ tools ಸಮೂಹ. ಇದರ ಕೇಂದ್ರದಲ್ಲಿ text editing functionality ಇರುತ್ತದೆ; ಜೊತೆಗೆ syntax highlighting, type checking, code formatting, autocomplete ಮೊದಲಾದ ಬೆಂಬಲ ವೈಶಿಷ್ಟ್ಯಗಳು ಇರುತ್ತವೆ. [VS Code][vs-code] ಮೊದಲಾದ _integrated development environments_ (IDEs) ಈ ಎಲ್ಲವನ್ನು ಒಂದೇ application ನಲ್ಲಿ ಒಟ್ಟುಗೂಡಿಸುತ್ತವೆ. Terminal-based development workflows ನಲ್ಲಿ [tmux](https://github.com/tmux/tmux) (terminal multiplexer), [Vim](https://www.vim.org/) (text editor), [Zsh](https://www.zsh.org/) (shell), ಮತ್ತು ಭಾಷೆ-ನಿರ್ದಿಷ್ಟ command-line tools ಬಳಸಲಾಗುತ್ತವೆ - ಉದಾ: [Ruff](https://docs.astral.sh/ruff/) (Python linter ಮತ್ತು formatter), [Mypy](https://mypy-lang.org/) (Python type checker).

IDEs ಮತ್ತು terminal-based workflows ಎರಡಕ್ಕೂ ತಮ್ಮದೇ ಬಲ-ದೌರ್ಬಲ್ಯಗಳಿವೆ. ಉದಾ: graphical IDEs ಕಲಿಯಲು ಸುಲಭವಾಗಬಹುದು, ಹಾಗೂ ಇಂದಿನ IDE ಗಳಲ್ಲಿ AI autocomplete ಮೊದಲಾದ out-of-the-box AI integrations ಉತ್ತಮವಾಗಿರುತ್ತವೆ. ಮತ್ತೊಂದೆಡೆ terminal-based workflows ಹಗುರವಾಗಿವೆ; GUI ಇಲ್ಲದ ಅಥವಾ software install ಸಾಧ್ಯವಿಲ್ಲದ ಪರಿಸರಗಳಲ್ಲಿ ಕೆಲವೊಮ್ಮೆ ಇದೇ ಏಕೈಕ ಆಯ್ಕೆ. ಎರಡರ ಮೇಲೂ ಮೂಲ ಪರಿಚಯ ಬೆಳೆಸಿಕೊಳ್ಳಿ, ಮತ್ತು ಕನಿಷ್ಠ ಒಂದರಲ್ಲಿ ನೈಪುಣ್ಯ ಗಳಿಸಿ. ಈಗಾಗಲೇ ನಿಮಗೆ ಇಷ್ಟದ IDE ಇಲ್ಲದಿದ್ದರೆ, [VS Code][vs-code] ನಿಂದ ಪ್ರಾರಂಭಿಸಲು ಶಿಫಾರಸು.

ಈ ಉಪನ್ಯಾಸದಲ್ಲಿ ನಾವು ನೋಡೋವುದು:

- [ಪಠ್ಯ ಸಂಪಾದನೆ ಮತ್ತು Vim](#text-editing-and-vim)
- [ಕೋಡ್ ಇಂಟೆಲಿಜೆನ್ಸ್ ಮತ್ತು language servers](#code-intelligence-and-language-servers)
- [AI-ಆಧಾರಿತ ಅಭಿವೃದ್ಧಿ](#ai-powered-development)
- [Extensions ಮತ್ತು ಇತರೆ IDE ವೈಶಿಷ್ಟ್ಯಗಳು](#extensions-and-other-ide-functionality)

[vs-code]: https://code.visualstudio.com/

# Text editing and Vim

Programming ಮಾಡುವಾಗ ಹೆಚ್ಚು ಸಮಯ code ನಲ್ಲಿ ಸಂಚರಿಸುವುದು, snippets ಓದುವುದು, edits ಮಾಡುವುದು ಇತ್ಯಾದಿಗಳಲ್ಲೇ ಕಳೆಯುತ್ತದೆ - ದೀರ್ಘ ಪಠ್ಯ ನಿರಂತರವಾಗಿ ಬರೆಯುವುದಕ್ಕಿಂತಲೂ, file ಅನ್ನು top-to-bottom ಓದುವುದಕ್ಕಿಂತಲೂ. [Vim] ಈ ಕೆಲಸಗಳ ವಿನ್ಯಾಸಕ್ಕೆ ಹೊಂದಿಕೆಯಾಗುವಂತೆ optimize ಮಾಡಲಾದ text editor.

**Vim ನ ತತ್ತ್ವ.** Vim ನ ಮೂಲಭೂತ ಕಲ್ಪನೆ ಬಹಳ ಸುಂದರ: Vim interface ತಾನೇ navigation ಮತ್ತು text editing ಗಾಗಿ ವಿನ್ಯಾಸಗೊಂಡ programming language ಆಗಿದೆ. Keystrokes (ಅರ್ಥಪೂರ್ಣ mnemonic ಹೆಸರುಗಳೊಂದಿಗೆ) commands ಆಗಿವೆ; commands composable ಆಗಿವೆ. Vim mouse ಬಳಕೆಯನ್ನು ತಪ್ಪಿಸುತ್ತದೆ - ಅದು ನಿಧಾನ. Vim arrow keys ಬಳಕೆಯನ್ನೂ ಕಡಿಮೆ ಮಾಡುತ್ತದೆ - ಹೆಚ್ಚು ಕೈ ಚಲನೆ ಬೇಕಾಗುತ್ತದೆ. ಫಲಿತಾಂಶ: ನಿಮ್ಮ ಚಿಂತನೆಯ ವೇಗಕ್ಕೆ ಹೊಂದಿಕೊಂಡಂತೆ brain-computer interface ಅನುಭವ ನೀಡುವ editor.

**ಇತರೆ software ನಲ್ಲಿ Vim ಬೆಂಬಲ.** [Vim] ನ್ನೇ ನೇರವಾಗಿ ಬಳಸದೆ ಅದರ ಮೂಲ ಕಲ್ಪನೆಗಳ ಲಾಭ ಪಡೆಯಬಹುದು. Text editing ಒಳಗೊಂಡ ಅನೇಕ software ಗಳಲ್ಲಿ "Vim mode" ಇದೆ - built-in ಆಗಿರಬಹುದು ಅಥವಾ plugin ಆಗಿರಬಹುದು. ಉದಾ: VS Code ನಲ್ಲಿ [VSCodeVim](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim) plugin ಇದೆ, Zsh ನಲ್ಲಿ Vim emulation ಗೆ [built-in support](https://zsh.sourceforge.io/Guide/zshguide04.html) ಇದೆ, Claude Code ನಲ್ಲೂ [built-in support](https://code.claude.com/docs/en/interactive-mode#vim-editor-mode) ಇದೆ. ನೀವು ಬಳಸುವ text-editing tools ಬಹುತೇಕ ಯಾವುದಾದರೂ ರೂಪದಲ್ಲಿ Vim mode ಬೆಂಬಲಿಸುತ್ತವೆ.

## Modal editing

Vim ಒಂದು _modal editor_: ವಿಭಿನ್ನ ಕಾರ್ಯಗಳಿಗೆ ವಿಭಿನ್ನ modes ಇವೆ.

- **Normal**: file ನಲ್ಲಿ ಸಂಚರಿಸಿ edits ಮಾಡಲು
- **Insert**: text ಸೇರಿಸಲು
- **Replace**: text ಬದಲಿಸಲು
- **Visual** (plain, line, block): text blocks ಆಯ್ಕೆ ಮಾಡಲು
- **Command-line**: command run ಮಾಡಲು

Keystrokes ಅರ್ಥ mode ಪ್ರಕಾರ ಬದಲಾಗುತ್ತದೆ. ಉದಾ: Insert mode ನಲ್ಲಿ `x` ಒತ್ತಿದರೆ literal "x" ಸೇರುತ್ತದೆ. ಆದರೆ Normal mode ನಲ್ಲಿ cursor ಕೆಳಗಿನ character delete ಆಗುತ್ತದೆ. Visual mode ನಲ್ಲಿ selection delete ಆಗುತ್ತದೆ.

Default configuration ನಲ್ಲಿ Vim ಕೆಳ ಎಡ ಭಾಗದಲ್ಲಿ current mode ತೋರಿಸುತ್ತದೆ. ಪ್ರಾರಂಭ/ಪೂರ್ವನಿಯೋಜಿತ mode Normal mode. ಸಾಮಾನ್ಯವಾಗಿ ಹೆಚ್ಚು ಸಮಯ Normal ಮತ್ತು Insert mode ನಡುವೆ ಕಳೆಯುತ್ತೀರಿ.

Modes ಬದಲಿಸಲು `<ESC>` ಕೀ ಬಳಸಿ - ಯಾವುದೇ mode ನಿಂದ Normal mode ಗೆ ಮರಳಬಹುದು. Normal mode ನಿಂದ Insert ಗೆ `i`, Replace ಗೆ `R`, Visual ಗೆ `v`, Visual Line ಗೆ `V`, Visual Block ಗೆ `<C-v>` (Ctrl-V; ಕೆಲವೊಮ್ಮೆ `^V`), Command-line mode ಗೆ `:` ಬಳಸಿ.

Vim ಬಳಸುವಾಗ `<ESC>` ಅನ್ನು ತುಂಬಾ ಬಾರಿ ಬಳಸುತ್ತೀರಿ. ಆದ್ದರಿಂದ Caps Lock ಅನ್ನು Escape ಗೆ remap ಮಾಡುವುದನ್ನು ಪರಿಗಣಿಸಿ ([macOS instructions](https://vim.fandom.com/wiki/Map_caps_lock_to_escape_in_macOS)); ಅಥವಾ ಸರಳ key sequence ಮೂಲಕ `<ESC>` ಗೆ [alternative mapping](https://vim.fandom.com/wiki/Avoid_the_escape_key#Mappings) ರಚಿಸಬಹುದು.

## Basics: inserting text

Normal mode ನಿಂದ `i` ಒತ್ತಿ Insert mode ಗೆ ಹೋಗಿ. ಈಗ `<ESC>` ಒತ್ತಿ Normal ಗೆ ಮರಳುವವರೆಗೆ Vim ಇತರೆ ಸಾಮಾನ್ಯ text editor ಹೋಲೆಯೇ ವರ್ತಿಸುತ್ತದೆ. ಮೇಲಿನ ಮೂಲಭೂತಗಳ ಜೊತೆಗೆ ಇದಿಷ್ಟೇ ಸಾಕು - Vim ನಲ್ಲಿ files edit ಮಾಡಲು ಪ್ರಾರಂಭಿಸಬಹುದು (Insert mode ನಲ್ಲೇ ಇಡೀ ಸಮಯ ಕಳೆಯುತ್ತಿದ್ದರೆ ಮಾತ್ರ ದಕ್ಷತೆ ಕಡಿಮೆ).

## Vim's interface is a programming language

Vim interface ಒಂದು programming language. Keystrokes (mnemonic ಹೆಸರುಗಳೊಂದಿಗೆ) commands ಆಗಿವೆ; commands _compose_ ಆಗುತ್ತವೆ. ಇದರಿಂದ ಪರಿಣಾಮಕಾರಿ navigation ಮತ್ತು edits ಸಾಧ್ಯವಾಗುತ್ತವೆ, ವಿಶೇಷವಾಗಿ commands muscle memory ಆಗಿದ ಮೇಲೆ - keyboard layout ಕಲಿತ ಮೇಲೆ typing ವೇಗ ಹೆಚ್ಚಿದಂತೆ.

### Movement

ಸಮಯದ ಬಹುಪಾಲು Normal mode ನಲ್ಲಿ ಇರಬೇಕು. Movement commands ಬಳಸಿ file ನಲ್ಲಿ ಸಂಚರಿಸಿ. Vim ನಲ್ಲಿ movements ಅನ್ನು "nouns" ಎಂದೂ ಕರೆಯುತ್ತಾರೆ, ಏಕೆಂದರೆ ಅವು text chunks ಸೂಚಿಸುತ್ತವೆ.

- ಮೂಲ ಚಲನೆ: `hjkl` (ಎಡ, ಕೆಳಗೆ, ಮೇಲೆ, ಬಲ)
- ಪದಗಳು: `w` (ಮುಂದಿನ ಪದ), `b` (ಪದದ ಆರಂಭ), `e` (ಪದದ ಅಂತ್ಯ)
- ಸಾಲುಗಳು: `0` (ಸಾಲಿನ ಆರಂಭ), `^` (ಮೊದಲ ಖಾಲಿಯಲ್ಲದ ಅಕ್ಷರ), `$` (ಸಾಲಿನ ಅಂತ್ಯ)
- ತೆರೆ: `H` (ತೆರೆಯ ಮೇಲ್ಭಾಗ), `M` (ಮಧ್ಯಭಾಗ), `L` (ಕೆಳಭಾಗ)
- ಸ್ಕ್ರೋಲ್: `Ctrl-u` (ಮೇಲಕ್ಕೆ), `Ctrl-d` (ಕೆಳಕ್ಕೆ)
- ಫೈಲ್: `gg` (ಫೈಲ್ ಆರಂಭ), `G` (ಫೈಲ್ ಅಂತ್ಯ)
- ಸಾಲು ಸಂಖ್ಯೆಗಳು: `:{number}<CR>` ಅಥವಾ `{number}G` (ಸಾಲು {number})
    - `<CR>` ಎಂದರೆ carriage return / enter key
- ಇತರೆ: `%` (ಹೊಂದುವ ಜೋಡಿ item, ಉದಾ: parenthesis ಅಥವಾ brace)
- ಹುಡುಕು: `f{character}`, `t{character}`, `F{character}`, `T{character}`
    - ಪ್ರಸ್ತುತ ಸಾಲಿನಲ್ಲಿ {character} ಅನ್ನು ಮುಂದೆ/ಹಿಂದೆ ಹುಡುಕುತ್ತದೆ
    - ಹೊಂದಿಕೆಗಳ ನಡುವೆ ಸಂಚರಿಸಲು `,` / `;`
- ಹುಡುಕಾಟ: `/{regex}`, ಹೊಂದಿಕೆಗಳ ನಡುವೆ ಸಂಚರಿಸಲು `n` / `N`

### Selection

ದೃಶ್ಯ ಮೋಡ್‌ಗಳು:

- Visual: `v`
- Visual Line: `V`
- Visual Block: `Ctrl-v`

ಆಯ್ಕೆ ಮಾಡಲು movement keys ಬಳಸಬಹುದು.

### Edits

ನೀವು mouse ಬಳಸಿ ಮಾಡುತ್ತಿದ್ದ ಹಲವಾರು editing ಕೆಲಸಗಳನ್ನು ಈಗ keyboard ಮೂಲಕ movement commands ಜೊತೆ compose ಆಗುವ editing commands ಮೂಲಕ ಮಾಡುತ್ತೀರಿ. ಇಲ್ಲಿಯೇ Vim interface ಒಂದು programming language ನಂತೆ ಸ್ಪಷ್ಟವಾಗುತ್ತದೆ. Vim editing commands ಅನ್ನು "verbs" ಎಂದು ಕರೆಯುತ್ತಾರೆ, ಏಕೆಂದರೆ verbs nouns ಮೇಲೆ ಕಾರ್ಯನಿರ್ವಹಿಸುತ್ತವೆ.

- `i` Insert mode ಗೆ ಹೋಗಲು
    - ಆದರೆ text manipulate/delete ಮಾಡಲು backspace ಗಿಂತ ಹೆಚ್ಚಿನ commands ಬಳಸುವುದು ಉತ್ತಮ
- `o` / `O` ಕೆಳಗೆ / ಮೇಲೆ line ಸೇರಿಸಲು
- `d{motion}` delete {motion}
    - ಉದಾ: `dw` delete word, `d$` line ಅಂತ್ಯವರೆಗೆ delete, `d0` line ಆರಂಭದವರೆಗೆ delete
- `c{motion}` change {motion}
    - ಉದಾ: `cw` change word
    - `d{motion}` ನಂತರ `i` ಹೋಲುತ್ತದೆ
- `x` character delete (`dl` ಗೆ ಸಮಾನ)
- `s` substitute character (`cl` ಗೆ ಸಮಾನ)
- Visual mode + manipulation
    - text ಆಯ್ಕೆ ಮಾಡಿ, `d` delete ಅಥವಾ `c` change
- `u` undo, `<C-r>` redo
- `y` copy / "yank" (`d` ಮೊದಲಾದ ಕೆಲವು commands ಕೂಡ copy ಮಾಡುತ್ತವೆ)
- `p` paste
- ಇನ್ನೂ ಬಹಳವು: ಉದಾ `~` character case flip ಮಾಡುತ್ತದೆ, `J` lines join ಮಾಡುತ್ತದೆ

### Counts

Nouns ಮತ್ತು verbs ಗೆ count ಸೇರಿಸಿ action ಅನ್ನು ಹಲವು ಬಾರಿ ನಡೆಸಬಹುದು.

- `3w` 3 words ಮುಂದೆ ಸರಿಯುತ್ತದೆ
- `5j` 5 lines ಕೆಳಗೆ ಸರಿಯುತ್ತದೆ
- `7dw` 7 words delete ಮಾಡುತ್ತದೆ

### Modifiers

Modifier ಗಳಿಂದ noun ನ ಅರ್ಥ ಬದಲಾಗುತ್ತದೆ. ಸಾಮಾನ್ಯ modifiers: `i` ("inner" ಅಥವಾ "inside"), `a` ("around").

- `ci(` ಪ್ರಸ್ತುತ parentheses ಜೋಡಿಯ ಒಳಗಿನ ವಿಷಯ ಬದಲಾಯಿಸುತ್ತದೆ
- `ci[` ಪ್ರಸ್ತುತ square brackets ಜೋಡಿಯ ಒಳಗಿನ ವಿಷಯ ಬದಲಾಯಿಸುತ್ತದೆ
- `da'` single-quoted string ಪೂರ್ಣವಾಗಿ (quotes ಸಹಿತ) delete ಮಾಡುತ್ತದೆ

## Putting it all together

ಇಲ್ಲಿ ಒಂದು broken [fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz) implementation ಇದೆ:

```python
def fizz_buzz(limit):
    for i in range(limit):
        if i % 3 == 0:
            print("fizz", end="")
        if i % 5 == 0:
            print("fizz", end="")
        if i % 3 and i % 5:
            print(i, end="")
        print()

def main():
    fizz_buzz(20)
```

ಈ ದೋಷಗಳನ್ನು ಸರಿಪಡಿಸಲು, Normal mode ನಿಂದ ಆರಂಭಿಸಿ, ಕೆಳಗಿನ command ಕ್ರಮ ಬಳಸಿ:

- Main call ಆಗುವುದಿಲ್ಲ
    - file ಅಂತ್ಯಕ್ಕೆ jump ಮಾಡಲು `G`
    - ಕೆಳಗೆ ಹೊಸ line **o**pen ಮಾಡಲು `o`
    - `if __name__ == "__main__": main()` ಎಂದು type ಮಾಡಿ
        - editor ನಲ್ಲಿ Python language support ಇದ್ದರೆ Insert mode ನಲ್ಲಿ auto-indentation ಆಗಬಹುದು
    - Normal mode ಗೆ ಮರಳಲು `<ESC>`
- 1 ಬದಲು 0 ರಿಂದ ಆರಂಭವಾಗುತ್ತದೆ
    - `range` ಹುಡುಕಲು `/` ನಂತರ `range` ಹಾಗೂ `<CR>`
    - ಎರಡು **w**ords ಮುಂದೆ ಹೋಗಲು `ww` (`2w` ಕೂಡ ಬಳಸಿ; ಆದರೆ ಸಣ್ಣ counts ನಲ್ಲಿ count ಬರೆವುದಕ್ಕಿಂತ key ಮರುಬಳಕೆ ಸಾಮಾನ್ಯ)
    - **i**nsert mode ಗೆ `i`, ನಂತರ `1,` ಸೇರಿಸಿ
    - Normal mode ಗೆ `<ESC>`
    - ಮುಂದಿನ ಪದದ **e**nd ಗೆ `e`
    - **a**ppend mode ಗೆ `a`, ನಂತರ `+ 1` ಸೇರಿಸಿ
    - Normal mode ಗೆ `<ESC>`
- 5 ರ multiples ಗೆ "fizz" ಮುದ್ರಿಸುತ್ತದೆ
    - line 6 ಗೆ `:6<CR>`
    - quotes ಒಳಗಿನ ಭಾಗ **c**hange **i**nside ಮಾಡಲು `ci"`, ನಂತರ `"buzz"` ಹಾಕಿ
    - Normal mode ಗೆ `<ESC>`

## Learning Vim

Vim ಕಲಿಯಲು ಅತ್ಯುತ್ತಮ ವಿಧಾನ: ಮೂಲಭೂತಗಳನ್ನು (ಇಲ್ಲಿವರೆಗೆ ನೋಡಿದ್ದು) ಕಲಿತು, ನಂತರ ನಿಮ್ಮ software ಎಲ್ಲೆಲ್ಲಿ ಸಾಧ್ಯವೋ ಅಲ್ಲಿ Vim mode ಸಕ್ರಿಯಗೊಳಿಸಿ ನಿಜವಾದ ಕೆಲಸದಲ್ಲಿ ಬಳಸುವುದು. Mouse ಅಥವಾ arrow keys ಗೆ ತಕ್ಷಣ ಮರಳುವ ಅಭ್ಯಾಸ ತಪ್ಪಿಸಿ. ಕೆಲವು editors ನಲ್ಲಿ arrow keys unbind ಮಾಡಿ ಉತ್ತಮ ಅಭ್ಯಾಸ ಬೆಳೆಸಿಕೊಳ್ಳಬಹುದು.

### Additional resources

- ಈ ತರಗತಿಯ ಹಿಂದಿನ ಆವೃತ್ತಿಯ [Vim lecture](/2020/editors/) - ಅಲ್ಲಿ Vim ಅನ್ನು ಹೆಚ್ಚಿನ ಆಳದಲ್ಲಿ ನೋಡಿದ್ದೇವೆ
- `vimtutor` Vim ಜೊತೆ ಬರುತ್ತದೆ - Vim install ಇದ್ದರೆ shell ನಿಂದ `vimtutor` run ಮಾಡಬಹುದು
- [Vim Adventures](https://vim-adventures.com/) - Vim ಕಲಿಯುವ ಆಟ
- [Vim Tips Wiki](https://vim.fandom.com/wiki/Vim_Tips_Wiki)
- [Vim Advent Calendar](https://vimways.org/2019/) - ಹಲವು Vim ಸಲಹೆಗಳು
- [VimGolf](https://www.vimgolf.com/) - [code golf](https://en.wikipedia.org/wiki/Code_golf), ಆದರೆ programming language Vim UI
- [Vi/Vim Stack Exchange](https://vi.stackexchange.com/)
- [Vim Screencasts](http://vimcasts.org/)
- [Practical Vim](https://pragprog.com/titles/dnvim2/) (ಪುಸ್ತಕ)

[Vim]: https://www.vim.org/

# Code intelligence and language servers

IDEs ಸಾಮಾನ್ಯವಾಗಿ language-specific support ಕೊಡುತ್ತವೆ. ಇದು code ನ semantic understanding ಆಧರಿಸಿ _language servers_ ಗೆ ಸಂಪರ್ಕಿಸುವ IDE extensions ಮೂಲಕ ನಡೆಯುತ್ತದೆ. Language servers ಗಳು [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) ಅನ್ನು ಜಾರಿಗೊಳಿಸುತ್ತವೆ. ಉದಾ: [Python extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-python.python), [Pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance) ಮೇಲೆ ಅವಲಂಬಿತ. [Go extension for VS Code](https://marketplace.visualstudio.com/items?itemName=golang.go), first-party [gopls](https://go.dev/gopls/) ಬಳಕೆ ಮಾಡುತ್ತದೆ. ನೀವು ಕೆಲಸ ಮಾಡುವ ಭಾಷೆಗಳ extension + language server install ಮಾಡಿದರೆ IDE ಯಲ್ಲಿ ಅನೇಕ language-specific ವೈಶಿಷ್ಟ್ಯಗಳು ಸಕ್ರಿಯವಾಗುತ್ತವೆ:

- **Code completion.** ಉತ್ತಮ autocomplete/autosuggest - ಉದಾ: `object.` ನಂತರ object's fields/methods ಕಾಣುವುದು.
- **Inline documentation.** hover/autosuggest ಸಮಯದಲ್ಲಿ documentation ಕಾಣುವುದು.
- **Jump-to-definition.** ಬಳಕೆ ಸ್ಥಳದಿಂದ definition ಗೆ ಹೋಗುವುದು - ಉದಾ: `object.field` ಇಂದ field definition ಗೆ.
- **Find references.** ಮೇಲಿನದಕ್ಕೆ ವಿರೋಧ - ನಿರ್ದಿಷ್ಟ field/type ಎಲ್ಲೆಲ್ಲಿ ಬಳಕೆಯಾಗಿದೆ ಎನ್ನುವುದು ಕಂಡುಹಿಡಿಯುವುದು.
- **Help with imports.** imports ಸಂಘಟಿಸುವುದು, unused imports ತೆಗೆದುಹಾಕುವುದು, missing imports ಸೂಚಿಸುವುದು.
- **Code quality.** ಈ tools standalone ಆಗಿಯೂ ಬಳಸಬಹುದು; ಆದರೆ language servers ಮುಖಾಂತರವೂ ಈ functionality ಲಭ್ಯ. Code formatting auto-indent/auto-format ಮಾಡುತ್ತದೆ. Type checkers/linters ನೀವು type ಮಾಡುವಾಗಲೇ ದೋಷ ಹಿಡಿಯುತ್ತವೆ. ಈ ವರ್ಗವನ್ನು [code quality](/2026/code-quality/) ಉಪನ್ಯಾಸದಲ್ಲಿ ಆಳವಾಗಿ ನೋಡುತ್ತೇವೆ.

## Configuring language servers

ಕೆಲವು ಭಾಷೆಗಳಲ್ಲಿ extension ಮತ್ತು language server install ಮಾಡಿದರೆ ಸಾಕು. ಇತರ ಭಾಷೆಗಳಲ್ಲಿ language server ನ ಸಂಪೂರ್ಣ ಲಾಭ ಪಡೆಯಲು IDE ಗೆ ನಿಮ್ಮ environment ಬಗ್ಗೆ ತಿಳಿಸಬೇಕು. ಉದಾ: VS Code ನಲ್ಲಿ [Python environment](https://code.visualstudio.com/docs/python/environments) ಸೂಚಿಸಿದರೆ language server ಗೆ installed packages ಗೋಚರಿಸುತ್ತವೆ. Environments ಕುರಿತು ಹೆಚ್ಚಿನ ಮಾಹಿತಿ [packaging and shipping code](/2026/shipping-code/) ಉಪನ್ಯಾಸದಲ್ಲಿ.

ಭಾಷೆ ಪ್ರಕಾರ language server ಗೆ configure ಮಾಡಬಹುದಾದ settings ಇರಬಹುದು. ಉದಾ: VS Code ಯ Python support ನಲ್ಲಿ optional type annotations ಬಳಸದೆ ಇರುವ projects ಗಾಗಿ static type checking disable ಮಾಡಬಹುದು.

# AI-powered development

2021 ಮಧ್ಯಭಾಗದಲ್ಲಿ OpenAI ಯ [Codex model](https://openai.com/index/openai-codex/) ಬಳಸಿದ [GitHub Copilot][github-copilot] ಪರಿಚಯವಾದ ನಂತರ, [LLMs](https://en.wikipedia.org/wiki/Large_language_model) software engineering ನಲ್ಲಿ ವ್ಯಾಪಕವಾಗಿ ಅಳವಡಿಸಲ್ಪಟ್ಟಿವೆ. ಈಗ ಮುಖ್ಯವಾಗಿ ಮೂರು form factors ಹೆಚ್ಚು ಬಳಕೆಯಲ್ಲಿವೆ: autocomplete, inline chat, coding agents.

[github-copilot]: https://github.com/features/copilot/ai-code-editor

## Autocomplete

AI-powered autocomplete, ನಿಮ್ಮ IDE ಯ ಪರಂಪರಾಗತ autocomplete ಹೋಲೆಯೇ ಕಾಣುತ್ತದೆ - ನೀವು type ಮಾಡುವಾಗ cursor ಸ್ಥಾನದಲ್ಲೇ completions ಸೂಚಿಸುತ್ತದೆ. ಕೆಲವೊಮ್ಮೆ ಇದು passive feature ಆಗಿ "ಹಾಗೇ ಕೆಲಸ ಮಾಡುತ್ತದೆ". ಅದಕ್ಕಿಂತ ಮುಂದೆ, AI autocomplete ಸಾಮಾನ್ಯವಾಗಿ code comments ಮೂಲಕ [prompted](https://en.wikipedia.org/wiki/Prompt_engineering) ಆಗುತ್ತದೆ.

ಉದಾಹರಣೆಗೆ lecture notes content download ಮಾಡಿ links ತೆಗೆಯುವ script ಬರೆಯೋಣ. ಆರಂಭ:

```python
import requests

def download_contents(url: str) -> str:
```

Model function body autocomplete ಮಾಡುತ್ತದೆ:

```python
    response = requests.get(url)
    return response.text
```

Comments ಮೂಲಕ completion ಅನ್ನು ಇನ್ನಷ್ಟು guide ಮಾಡಬಹುದು. ಉದಾ: Markdown links ತೆಗೆದುಹಾಕುವ function ಬರೆಯಲು ಶುರುಮಾಡಿದಾಗ function name ಸಾಕಷ್ಟು descriptive ಆಗಿರದಿದ್ದರೆ:

```python
def extract(contents: str) -> list[str]:
```

Model ಈ ರೀತಿಯ completion ಕೊಡಬಹುದು:

```python
    lines = contents.splitlines()
    return [line for line in lines if line.strip()]
```

Code comments ಮೂಲಕ completion ದಿಕ್ಕು ತೋರಿಸಬಹುದು:

```python
def extract(content: str) -> list[str]:
    # extract all Markdown links from the content
```

ಈ ಬಾರಿ completion ಉತ್ತಮವಾಗಿರುತ್ತದೆ:

```python
    import re
    pattern = r'\[.*?\]\((.*?)\)'
    return re.findall(pattern, content)
```

ಇಲ್ಲಿ ಈ AI coding tool ನ ಒಂದು ಮಿತಿ ಕಾಣಿಸುತ್ತದೆ: cursor ಇರುವ ಸ್ಥಳಕ್ಕಷ್ಟೇ completion ಕೊಡುತ್ತದೆ. ಈ ಸಂದರ್ಭದಲ್ಲಿ `import re` ಅನ್ನು function ಒಳಗೆ ಬದಲಾಗಿ module ಮಟ್ಟದಲ್ಲಿ ಇಡುವುದು ಉತ್ತಮ ಅಭ್ಯಾಸ.

ಮೇಲಿನ ಉದಾಹರಣೆಯಲ್ಲಿ comments ಮೂಲಕ code completion ಹೇಗೆ steer ಮಾಡಬಹುದು ತೋರಿಸಲು function name ಉದ್ದೇಶಪೂರ್ವಕವಾಗಿ ಸರಳವಾಗಿ ಇಡಲಾಗಿದೆ. ಪ್ರಾಯೋಗಿಕವಾಗಿ `extract_links` ಹೀಗೆ descriptive function names ಬಳಸಿ, docstrings ಬರೆಯುವುದು ಉತ್ತಮ (ಇದರಿಂದ model ಮೇಲಿನಂತೆಯೇ ಸೂಕ್ತ completion ಕೊಡುತ್ತದೆ).

Demo ಗಾಗಿ script ಪೂರ್ಣಗೊಳಿಸಬಹುದು:

```python
print(extract(download_contents("https://raw.githubusercontent.com/missing-semester/missing-semester/refs/heads/master/_2026/development-environment.md")))
```

## Inline chat

Inline chat ನಲ್ಲಿ line/block ಆಯ್ಕೆ ಮಾಡಿ, ನೇರವಾಗಿ AI model ಗೆ edit ಸೂಚಿಸಬಹುದು. ಈ mode ನಲ್ಲಿ model ಇರುವ code ನ್ನೇ ಬದಲಾಯಿಸಬಹುದು (autocomplete ಇಂದ ವ್ಯತ್ಯಾಸ - ಅದು cursor ನಂತರದ code ಮಾತ್ರ ಪೂರ್ಣಗೊಳಿಸುತ್ತದೆ).

ಮೇಲಿನ ಉದಾಹರಣೆ ಮುಂದುವರಿಸಿದರೆ, third-party `requests` library ಬಳಸಬಾರದು ಎಂದು ತೀರ್ಮಾನಿಸಿದ್ದೇವೆ ಎಂದು ಊಹಿಸೋಣ. ಸಂಬಂಧಿತ ಮೂರು lines ಆಯ್ಕೆ ಮಾಡಿ inline chat invoke ಮಾಡಿ ಹೀಗೆ ಹೇಳಬಹುದು:

```
use built-in libraries instead
```

Model ನೀಡುವ ಪ್ರಸ್ತಾವನೆ:

```python
from urllib.request import urlopen

def download_contents(url: str) -> str:
    with urlopen(url) as response:
        return response.read().decode('utf-8')
```

## Coding agents

Coding agents ಬಗ್ಗೆ [Agentic Coding](/2026/agentic-coding/) ಉಪನ್ಯಾಸದಲ್ಲಿ ಆಳವಾಗಿ ನೋಡುತ್ತೇವೆ.

## Recommended software

ಜನಪ್ರಿಯ AI IDEs ಗಳಲ್ಲಿ [GitHub Copilot][github-copilot] extension ಹೊಂದಿರುವ [VS Code][vs-code] ಮತ್ತು [Cursor](https://cursor.com/) ಪ್ರಮುಖ. GitHub Copilot ಇದೀಗ [students](https://github.com/education/students), teachers, ಮತ್ತು ಜನಪ್ರಿಯ open-source project maintainers ಗಾಗಿ ಉಚಿತ ಲಭ್ಯ. ಈ ಕ್ಷೇತ್ರ ವೇಗವಾಗಿ ಬದಲಾಗುತ್ತಿದೆ; ಮುಂಚೂಣಿ ಉತ್ಪನ್ನಗಳಲ್ಲಿ ಅನೇಕವು ಸಮಾನ ಮಟ್ಟದ ವೈಶಿಷ್ಟ್ಯಗಳನ್ನು ಹೊಂದಿವೆ.

# Extensions and other IDE functionality

IDEs ಶಕ್ತಿಶಾಲಿ tools. _Extensions_ ಅವನ್ನು ಇನ್ನಷ್ಟು ಶಕ್ತಿಶಾಲಿಯಾಗಿಸುತ್ತವೆ. ಒಂದು ಉಪನ್ಯಾಸದಲ್ಲಿ ಎಲ್ಲ ವೈಶಿಷ್ಟ್ಯಗಳನ್ನು ಆವರಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ, ಆದ್ದರಿಂದ ಇಲ್ಲಿ ಕೆಲ ಪ್ರಮುಖ extensions ಕಡೆ ಸೂಚನೆಗಳನ್ನು ಕೊಡುತ್ತೇವೆ. ಈ ಕ್ಷೇತ್ರವನ್ನು ನೀವು ಸ್ವತಃ ಅನ್ವೇಷಿಸಲು ಪ್ರೋತ್ಸಾಹಿಸುತ್ತೇವೆ. ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ ಜನಪ್ರಿಯ IDE extensions ಪಟ್ಟಿಗಳು ಹಲವೆಡೆ ಲಭ್ಯ - ಉದಾ: Vim plugins ಗೆ [Vim Awesome](https://vimawesome.com/), ಮತ್ತು [ಜನಪ್ರಿಯತೆ ಆಧಾರದ ಮೇಲೆ ಸಜ್ಜುಗೊಳಿಸಿದ VS Code extensions](https://marketplace.visualstudio.com/search?target=VSCode&category=All%20categories&sortBy=Installs).

- [Development containers](https://containers.dev/): ಜನಪ್ರಿಯ IDEs ಬೆಂಬಲಿಸುತ್ತವೆ (ಉದಾ: [VS Code support](https://code.visualstudio.com/docs/devcontainers/containers)). Dev containers ಮೂಲಕ development tools ಅನ್ನು container ಒಳಗೆ ನಡೆಸಬಹುದು. ಇದು portability ಮತ್ತು isolation ಗೆ ಸಹಾಯಕ. [packaging and shipping code](/2026/shipping-code/) ಉಪನ್ಯಾಸದಲ್ಲಿ containers ಕುರಿತು ಹೆಚ್ಚಿನ ವಿವರ.
- Remote development: SSH ಬಳಸಿ remote machine ನಲ್ಲಿ development ಮಾಡಿ (ಉದಾ: [Remote SSH plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)). Cloud ನಲ್ಲಿ ಇರುವ ಶಕ್ತಿಶಾಲಿ GPU machine ಮೇಲೆ code ಬರೆಯಲು/ಓಡಿಸಲು ಇದು ಉಪಯುಕ್ತ.
- Collaborative editing: Google Docs ಶೈಲಿಯಲ್ಲಿ ಅದೇ file ಅನ್ನು ಒಟ್ಟಿಗೆ edit ಮಾಡಿ (ಉದಾ: [Live Share plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=MS-vsliveshare.vsliveshare)).

# Exercises

1. ನೀವು ಬಳಸುವ ಎಲ್ಲ Vim-support software ಗಳಲ್ಲಿ (ಉದಾ: editor, shell) Vim mode ಸಕ್ರಿಯಗೊಳಿಸಿ. ಮುಂದಿನ ಒಂದು ತಿಂಗಳು ನಿಮ್ಮ text editing ಕೆಲಸಗಳೆಲ್ಲ Vim mode ನಲ್ಲಿ ಮಾಡಿ. ಯಾವುದಾದರೂ ಅಸಮರ್ಥವಾಗಿ ಕಂಡರೆ, ಅಥವಾ "ಇದಕ್ಕಿಂತ ಉತ್ತಮ ಮಾರ್ಗ ಇರಬೇಕು" ಅನ್ನಿಸಿದರೆ Google ನಲ್ಲಿ ಹುಡುಕಿ - ಬಹುಶಃ ಉತ್ತಮ ಮಾರ್ಗ ಇರುತ್ತದೆ.
1. [VimGolf](https://www.vimgolf.com/) ನಲ್ಲಿ ಒಂದು challenge ಪೂರ್ಣಗೊಳಿಸಿ.
1. ನೀವು ಕೆಲಸ ಮಾಡುತ್ತಿರುವ project ಗೆ IDE extension ಮತ್ತು language server configure ಮಾಡಿ. Library dependencies ಗೆ jump-to-definition ಸೇರಿದಂತೆ ನಿರೀಕ್ಷಿತ features ಸರಿಯಾಗಿ ಕೆಲಸ ಮಾಡುತ್ತಿವೆಯೇ ಪರಿಶೀಲಿಸಿ. ಈ exercise ಗೆ ನಿಮ್ಮ code ಇಲ್ಲದಿದ್ದರೆ GitHub open-source project ಒಂದನ್ನು ಬಳಸಿ (ಉದಾ: [this one](https://github.com/spf13/cobra)).
1. IDE extensions ಪಟ್ಟಿ ವೀಕ್ಷಿಸಿ, ನಿಮಗೆ ಉಪಯುಕ್ತವೆನಿಸುವ ಒಂದು extension install ಮಾಡಿ.
