---
layout: lecture
title: "ಏಜೆಂಟಿಕ್ ಕೋಡಿಂಗ್"
description: >
  ಸಾಫ್ಟ್‌ವೇರ್ ಅಭಿವೃದ್ಧಿ ಕಾರ್ಯಗಳಲ್ಲಿ AI coding agents ಅನ್ನು ಪರಿಣಾಮಕಾರಿಯಾಗಿ ಹೇಗೆ ಬಳಸುವುದು ಎಂಬುದನ್ನು ಕಲಿಯಿರಿ.
thumbnail: /static/assets/thumbnails/2026/lec7.png
date: 2026-01-21
ready: true
video:
  aspect: 56.25
  id: sTdz6PZoAnw
---

Coding agents ಎಂದರೆ files ಓದುವುದು/ಬರೆಯುವುದು, web search, ಮತ್ತು shell commands ಅನ್ನು ಚಾಲನೆ ಮಾಡುವಂತಹ tools ಗೆ ಪ್ರವೇಶವಿರುವ conversational AI models. ಇವು IDE ಒಳಗೇ ಇರಬಹುದು ಅಥವಾ standalone command-line/GUI tools ರೂಪದಲ್ಲಿರಬಹುದು. Coding agents ಹೆಚ್ಚಿನ ಮಟ್ಟದಲ್ಲಿ autonomous ಮತ್ತು ಶಕ್ತಿಶಾಲಿ ಸಾಧನಗಳಾಗಿದ್ದು, ಬಹು ವಿಧದ ಬಳಕೆ ಸಂದರ್ಭಗಳನ್ನು ಬೆಂಬಲಿಸುತ್ತವೆ.

ಈ ಉಪನ್ಯಾಸವು [Development Environment and Tools](/2026/development-environment/) ಉಪನ್ಯಾಸದ AI-powered development ವಿಷಯದ ಮೇಲೆ ಮುಂದುವರೆಯುತ್ತದೆ. ತ್ವರಿತ demoಗಾಗಿ, [AI-powered development](/2026/development-environment/#ai-powered-development) ವಿಭಾಗದ ಉದಾಹರಣೆಯನ್ನು ಮುಂದುವರಿಸೋಣ:

```python
from urllib.request import urlopen

def download_contents(url: str) -> str:
    with urlopen(url) as response:
        return response.read().decode('utf-8')

def extract(content: str) -> list[str]:
    import re
    pattern = r'\[.*?\]\((.*?)\)'
    return re.findall(pattern, content)

print(extract(download_contents("https://raw.githubusercontent.com/missing-semester/missing-semester/refs/heads/master/_2026/development-environment.md")))
```

ಈ ಕಾರ್ಯವನ್ನು coding agent ಗೆ prompt ಆಗಿ ಹೀಗೆ ನೀಡಬಹುದು:

```
Turn this into a proper command-line program, with argparse for argument parsing. Add type annotations, and make sure the program passes type checking.
```

Agent ಮೊದಲು file ಓದಿ ಅರ್ಥಮಾಡಿಕೊಳ್ಳುತ್ತದೆ, ನಂತರ ಅಗತ್ಯ edits ಮಾಡುತ್ತದೆ, ಕೊನೆಯಲ್ಲಿ type annotations ಸರಿಯೇ ಎಂಬುದನ್ನು ಪರಿಶೀಲಿಸಲು type checker ಅನ್ನು ಚಾಲನೆ ಮಾಡುತ್ತದೆ. type checking ವಿಫಲವಾಗುವ ತಪ್ಪು ಮಾಡಿದರೆ, ಸಾಮಾನ್ಯವಾಗಿ ಅದು iterate ಮಾಡುತ್ತದೆ. ಈ task ಸರಳವಾದುದರಿಂದ ಅದು ಸಂಭವಿಸುವ ಸಾಧ್ಯತೆ ಕಡಿಮೆ. Coding agents ಗೆ ಹಾನಿಕಾರಕವಾಗಬಹುದಾದ tools ಗೆ ಪ್ರವೇಶ ಇರುವುದರಿಂದ, default ಆಗಿ agent harnesses tool calls ಗೆ user confirmation ಕೇಳುತ್ತವೆ.

> Coding agent ತಪ್ಪು ಮಾಡಿದರೆ - ಉದಾಹರಣೆಗೆ `$PATH` ನಲ್ಲಿ `mypy` binary ನೇರವಾಗಿ ಲಭ್ಯವಾಗಿದ್ದರೂ agent `python -m mypy` ಅನ್ನು ಪ್ರಯತ್ನಿಸಿದರೆ - ನೀವು text feedback ನೀಡಿ ಅದನ್ನು ಸರಿಯಾದ ದಾರಿಗೆ ತಿರುಗಿಸಬಹುದು.

Coding agents multi-turn interaction ಅನ್ನು ಬೆಂಬಲಿಸುತ್ತವೆ. ಹಾಗಾಗಿ agent ಜೊತೆ ಹಿಂತಿರುಗಿ ಮಾತನಾಡುತ್ತಾ ಕೆಲಸವನ್ನು ಹಂತ ಹಂತವಾಗಿ ಮುಂದುವರಿಸಬಹುದು. Agent ತಪ್ಪು ದಿಕ್ಕಿನಲ್ಲಿ ಹೋಗುತ್ತಿದ್ದರೆ ಮಧ್ಯದಲ್ಲೇ interrupt ಕೂಡ ಮಾಡಬಹುದು. ಉಪಯುಕ್ತ mental model ಎಂದರೆ intern ಅನ್ನು ನಿರ್ವಹಿಸುವ manager: intern ಸೂಕ್ಷ್ಮ ಕೆಲಸ ಮಾಡುತ್ತಾನೆ, ಆದರೆ ಮಾರ್ಗದರ್ಶನ ಬೇಕಾಗುತ್ತದೆ, ಕೆಲವೊಮ್ಮೆ ತಪ್ಪು ಮಾಡುತ್ತಾನೆ ಮತ್ತು ತಿದ್ದುವಿಕೆ ಅಗತ್ಯವಾಗುತ್ತದೆ.

> ಇನ್ನಷ್ಟು ಸ್ಪಷ್ಟ demoಗಾಗಿ, follow-up ಆಗಿ agent ಗೆ ಫಲಿತ script ಅನ್ನು run ಮಾಡಲು ಹೇಳಿ. outputs ನೋಡಿ, ಬಳಿಕ ಬದಲಾವಣೆ ಕೇಳಿ (ಉದಾ: absolute URLs ಮಾತ್ರ ಸೇರಿಸು ಎಂದು).

# AI models ಮತ್ತು agents ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತವೆ

ಆಧುನಿಕ [large language models (LLMs)](https://en.wikipedia.org/wiki/Large_language_model) ಗಳ ಒಳಾಂಗಣ ಕಾರ್ಯವಿಧಾನ ಮತ್ತು agent harnesses ಮೊದಲಾದ infrastructure ಅನ್ನು ಸಂಪೂರ್ಣವಾಗಿ ವಿವರಿಸುವುದು ಈ ಕೋರ್ಸ್ ವ್ಯಾಪ್ತಿಗೆ ಹೊರತಾಗಿದೆ. ಆದರೂ, ಈ cutting-edge ತಂತ್ರಜ್ಞಾನವನ್ನು ಪರಿಣಾಮಕಾರಿಯಾಗಿ _ಬಳಸಲು_ ಮತ್ತು ಅದರ ಮಿತಿಗಳನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಲು ಕೆಲವು ಪ್ರಮುಖ ಕಲ್ಪನೆಗಳ high-level ತಿಳುವಳಿಕೆ ಉಪಯುಕ್ತ.

LLMs ಅನ್ನು prompt strings (inputs) ನೀಡಿದಾಗ completion strings (outputs) ಗಳ probability distribution ಅನ್ನು ಮಾದರಿಪಡಿಸುವ ವ್ಯವಸ್ಥೆಯಾಗಿ ನೋಡಬಹುದು. LLM inference (ಉದಾ: conversational chat app ಗೆ ನೀವು query ಕೊಟ್ಟಾಗ ನಡೆಯುವುದು) ಈ probability distribution ಇಂದ _sample_ ಮಾಡುತ್ತದೆ. LLMs ಗೆ ಸ್ಥಿರ _context window_ ಇರುತ್ತದೆ - input ಮತ್ತು output strings ನ ಗರಿಷ್ಠ ಒಟ್ಟು ಉದ್ದ.

{% comment %}
> In mathematical notation, the LLM models the probability distribution $\pi_\theta$ of completions $y$ conditioned on prompts $x$, and we sample from this distribution: $\hat{y} \sim \pi_\theta(\cdot \mid x)$.
{% endcomment %}

Conversational chat ಮತ್ತು coding agents ಮೊದಲಾದ AI tools ಈ ಮೂಲ ಘಟಕದ ಮೇಲೆ ನಿರ್ಮಿಸಲ್ಪಟ್ಟಿವೆ. Multi-turn interactions ಗಾಗಿ, chat apps ಮತ್ತು agents turn markers ಬಳಸುತ್ತವೆ ಮತ್ತು ಪ್ರತಿಯೊಂದು ಹೊಸ user prompt ಗೆ ಸಂಪೂರ್ಣ conversation history ನ್ನೇ prompt string ಆಗಿ ಕಳುಹಿಸುತ್ತವೆ; ಅಂದರೆ ಪ್ರತಿ user prompt ಗೆ LLM inference ಒಮ್ಮೆ ನಡೆಯುತ್ತದೆ. Tool-calling agents ನಲ್ಲಿ, harness ಕೆಲವು LLM outputs ಅನ್ನು tool invoke requests ಆಗಿ ಅರ್ಥಮಾಡಿಕೊಳ್ಳುತ್ತದೆ; ನಂತರ tool call ಫಲಿತಾಂಶವನ್ನು prompt string ಭಾಗವಾಗಿ model ಗೆ ಹಿಂತಿರುಗಿಸುತ್ತದೆ (ಹೀಗಾಗಿ ಪ್ರತಿಯೊಂದು tool call/response ಗೆ LLM inference ಮತ್ತೆ ನಡೆಯುತ್ತದೆ). Tool-calling agents ನ ಮೂಲ ಕಲ್ಪನೆಗಳನ್ನು [200 lines of code](https://www.mihaileric.com/The-Emperor-Has-No-Clothes/) ನಲ್ಲಿ implement ಮಾಡಬಹುದು.

## Privacy

ಬಹುತೇಕ AI coding tools ತಮ್ಮ ಸಾಮಾನ್ಯ configurations ನಲ್ಲಿ ನಿಮ್ಮ data ಯ ದೊಡ್ಡ ಭಾಗವನ್ನು cloud ಗೆ ಕಳುಹಿಸುತ್ತವೆ. ಕೆಲವೊಮ್ಮೆ harness local ನಲ್ಲಿ ನಡೆಯುತ್ತದೆ ಆದರೆ LLM inference cloud ನಲ್ಲಿ ನಡೆಯುತ್ತದೆ. ಇನ್ನು ಕೆಲವೊಮ್ಮೆ software ನ ಇನ್ನಷ್ಟು ಭಾಗ cloud ನಲ್ಲೇ ನಡೆಯಬಹುದು (ಉದಾ: service provider ಗೆ ನಿಮ್ಮ ಸಂಪೂರ್ಣ repository ನ ಪ್ರತಿಯೇ ಸಿಗುವ ಮಟ್ಟಿಗೆ, ಜೊತೆಗೆ AI tool ಜೊತೆಗಿನ interactions ಕೂಡ).

Open-source AI coding tools ಮತ್ತು open-source LLMs ಉತ್ತಮ ಮಟ್ಟದಲ್ಲಿವೆ (proprietary models ಮಟ್ಟಕ್ಕೆ ಇನ್ನೂ ಸಂಪೂರ್ಣವಾಗಿ ಸಮಾನವಲ್ಲ). ಆದರೆ ಪ್ರಸ್ತುತ ಬಹುತೇಕ ಬಳಕೆದಾರರಿಗೆ hardware ಮಿತಿಗಳ ಕಾರಣ bleeding-edge open LLMs ಅನ್ನು local ನಲ್ಲಿ ನಡೆಸುವುದು ಪ್ರಾಯೋಗಿಕವಾಗಿಲ್ಲ.

# ಬಳಕೆ ಸಂದರ್ಭಗಳು

Coding agents ವಿವಿಧ ರೀತಿಯ ಕಾರ್ಯಗಳಿಗೆ ಸಹಾಯಕ. ಕೆಲವು ಉದಾಹರಣೆಗಳು:

- **ಹೊಸ features ಜಾರಿಗೊಳಿಸುವುದು.** ಮೇಲಿನ ಉದಾಹರಣೆಯಂತೆ coding agent ಗೆ feature implement ಮಾಡಲು ಕೇಳಬಹುದು. ಉತ್ತಮ specification ಬರೆಯುವುದು ಈಗಲೂ ಕಲೆ ಮತ್ತು ವಿಜ್ಞಾನ ಮಿಶ್ರಣದ ವಿಷಯ. Agent ಗೆ ಸಾಕಷ್ಟು ವಿವರಣಾತ್ಮಕ input ನೀಡಬೇಕು, ಆಗ ಅದು ನಿಮ್ಮ ದಿಕ್ಕಿನಲ್ಲಿ ಕೆಲಸ ಆರಂಭಿಸುತ್ತದೆ (ಮುಂದೆ iterate ಮಾಡಬಹುದು). ಆದರೆ ಅತಿಯಾಗಿ ವಿವರಿಸಿದರೆ ನೀವು ಮಾಡಬೇಕಾದ ಕೆಲಸವೇ ಹೆಚ್ಚು ಆಗುತ್ತದೆ. Test-driven development ಇಲ್ಲಿ ಪರಿಣಾಮಕಾರಿ: tests ಬರೆಯಿರಿ (ಅಥವಾ tests ಬರೆಯಲು coding agent ನೆರವು ಬಳಸಿ), ಅವು ನಿಮ್ಮ ನಿರೀಕ್ಷೆಗಳನ್ನು ಹಿಡಿದಿವೆಯೇ ಎಂದು ಪರಿಶೀಲಿಸಿ, ಬಳಿಕ feature implement ಮಾಡಲು agent ಗೆ ಕೇಳಿ. Models ನಿರಂತರವಾಗಿ ಸುಧಾರಿಸುತ್ತಿರುವುದರಿಂದ, ಅವುಗಳ ಸಾಮರ್ಥ್ಯದ ಬಗ್ಗೆ ನಿಮ್ಮ ಅಂದಾಜನ್ನು ನಿರಂತರವಾಗಿ ನವೀಕರಿಸಬೇಕು.
    > ನಾವು Claude Code ಬಳಸಿ ಈ Tufte-ಶೈಲಿಯ sidenotes ಅನ್ನು [implement](https://github.com/missing-semester/missing-semester/pull/345) ಮಾಡಿದ್ದೇವೆ.
{%- comment %}
No need to demo this, since the intro of a lecture was a small demo of adding a new feature.
{% endcomment %}
- **ದೋಷ ಸರಿಪಡಿಸುವುದು.** Compiler, linter, type checker, ಅಥವಾ tests ನಿಂದ errors ಬಂದರೆ agent ಗೆ ಅವನ್ನು ಸರಿಪಡಿಸಲು ಕೇಳಬಹುದು, ಉದಾ: "fix the issues with mypy" ಎಂಬ prompt. Coding models feedback loop ನಲ್ಲಿ ವಿಶೇಷವಾಗಿ ಪರಿಣಾಮಕಾರಿಯಾಗುತ್ತವೆ. ಆದ್ದರಿಂದ ಸಾಧ್ಯವಾದರೆ model ಗೆ failing check ನ್ನೇ ನೇರವಾಗಿ run ಮಾಡಲು ಅವಕಾಶ ಕೊಡಿ, ಆಗ ಅದು ಸ್ವಯಂಚಾಲಿತವಾಗಿ iterate ಮಾಡಬಹುದು. ಅದು ಸಾಧ್ಯವಿಲ್ಲದಿದ್ದರೆ manual feedback ಕೊಡಬಹುದು.
    > missing-semester repo ಯ [f552b55](https://github.com/missing-semester/missing-semester/commit/f552b5523462b22b8893a8404d2110c4e59613dd) commit ನಲ್ಲಿ ನಾವು Claude Code ಗೆ "Review the agentic coding lecture for typos and grammatical issues" ಎಂದು prompt ನೀಡಿದ್ದೆವು. ನಂತರ ಅದು ಕಂಡುಹಿಡಿದ ಸಮಸ್ಯೆಗಳನ್ನು ಸರಿಪಡಿಸಲು ಕೇಳಿದ್ದೇವೆ. ಅವು [f1e1c41](https://github.com/missing-semester/missing-semester/commit/f1e1c417adba6b4149f7eef91ff5624de40dc637) ನಲ್ಲಿ commit ಆಗಿವೆ.
{%- comment %}
Demo a coding agent fixing the bug in https://github.com/anishathalye/dotbot/commit/cef40c902ef0f52f484153413142b5154bbc5e99.

Write the failing tests to demo the bug, and then ask the agent to fix. Prepped in branch demo-bugfix.

Can run the failing test with:

    hatch test tests/test_cli.py::test_issue_357

Can prompt coding agent with:

    There is a bug I wrote a failing test for, you can repro it with `hatch test tests/test_cli.py::test_issue_357`. Fix the bug.

Get it to commit the changes.
{% endcomment %}
- **Refactoring.** Coding agents ಬಳಸಿ ವಿವಿಧ ರೀತಿಯ refactoring ಮಾಡಬಹುದು - method rename ಮಾಡುವ ಸರಳ ಕೆಲಸದಿಂದ (ಇದು [code intelligence](/2026/development-environment/#code-intelligence-and-language-servers) ಮೂಲಕವೂ ಸಾಧ್ಯ) ಹಿಡಿದು, functionality ಅನ್ನು ಪ್ರತ್ಯೇಕ module ಗೆ ಬೇರ್ಪಡಿಸುವಂತಹ ಸಂಕೀರ್ಣ ಕೆಲಸಗಳವರೆಗೆ.
    > ನಾವು Claude Code ಬಳಸಿ agentic coding ಅನ್ನು ಸ್ವತಂತ್ರ ಉಪನ್ಯಾಸವಾಗಿ [split](https://github.com/missing-semester/missing-semester/pull/344) ಮಾಡಿದ್ದೇವೆ.
{%- comment %}
Show usage in Missing Semester, point out that the agent did make some mistakes.
{% endcomment %}
- **Code review.** Coding agents ಗೆ code review ಮಾಡಲು ಕೇಳಬಹುದು. ಉದಾ: "review my latest changes that are not yet committed" ಎಂಬ ಸರಳ ಮಾರ್ಗದರ್ಶನ ನೀಡಿ. Pull request review ಮಾಡಲು coding agent ಗೆ web fetch support ಇದ್ದರೆ, ಅಥವಾ [GitHub CLI](https://cli.github.com/) ಮೊದಲಾದ command-line tools ಇದ್ದರೆ, "Review the pull request {link}" ಎಂದು ಕೇಳಿದರೂ ಅದು ಉಳಿದುದನ್ನು ನಿರ್ವಹಿಸಬಹುದು.
{%- comment %}
In Porcupine repo, prompt agent with:

    Review this PR: https://github.com/anishathalye/porcupine/pull/39
{% endcomment %}
- **Code understanding.** Codebase ಬಗ್ಗೆ coding agent ಗೆ ಪ್ರಶ್ನೆ ಕೇಳಬಹುದು. ಹೊಸ project ಗೆ onboarding ಆಗುವಾಗ ಇದು ವಿಶೇಷವಾಗಿ ಸಹಾಯಕ.
{%- comment %}
Some prompts to try in the missing-semester repo:

    How do I run this site locally?

    How are the social preview cards implemented?
{% endcomment %}
- **Shell ಆಗಿ ಬಳಸುವುದು.** ನಿರ್ದಿಷ್ಟ task ಗೆ ಒಂದು tool ಬಳಸುವಂತೆ coding agent ಗೆ ಕೇಳಬಹುದು. ಹಾಗಾಗಿ natural language ಬಳಸಿ shell command ಕಾರ್ಯಗತಗೊಳಿಸಬಹುದು, ಉದಾ: "use the find command to find all files older than 30 days" ಅಥವಾ "use mogrify to resize all the jpgs to 50% of their original size".
{%- comment %}
In Dotbot repo, prompt agent with:

    Use the ag command to find all Python renaming imports
{% endcomment %}
- **Vibe coding.** Agents ಈಗ ಇಷ್ಟು ಶಕ್ತಿಶಾಲಿಯಾಗಿವೆ ಎಂದು ನೀವು ಸ್ವತಃ ಒಂದು ಸಾಲು code ಕೂಡ ಬರೆಯದೇ ಕೆಲವು applications ನಿರ್ಮಿಸಬಹುದು.
    > instructor ಗಳಲ್ಲಿ ಒಬ್ಬರು vibe-coded ಮಾಡಿದ ನೈಜ project ಉದಾಹರಣೆ [ಇಲ್ಲಿ](https://github.com/cleanlab/office-presence-dashboard).
{%- comment %}
In missing-semester repo, prompt agent with:

    Make this site look retro.
{% endcomment %}

# ಮುಂದುವರಿದ agents

ಇಲ್ಲಿ coding agents ನ ಕೆಲವು ಮುಂದುವರಿದ usage patterns ಮತ್ತು ಸಾಮರ್ಥ್ಯಗಳ ಸಂಕ್ಷಿಪ್ತ ಅವಲೋಕನ:

- **Reusable prompts.** ಮರುಬಳಕೆಯ prompts/templates ರಚಿಸಿ. ಉದಾ: ನಿರ್ದಿಷ್ಟ ಶೈಲಿಯಲ್ಲಿ code review ಮಾಡಲು ವಿವರವಾದ prompt ಬರೆದು reuse ಮಾಡಬಹುದು.
- **Parallel agents.** Coding agents ನಿಧಾನವಾಗಿರಬಹುದು - prompt ಕೊಟ್ಟ ಬಳಿಕ ಕೆಲವೊಮ್ಮೆ ದಶಕ ನಿಮಿಷಗಳವರೆಗೆ ಕೆಲಸ ಮಾಡಬಹುದು. ಒಂದೇ ಸಮಯದಲ್ಲಿ ಹಲವು agent instances ನಡೆಸಬಹುದು: ಒಂದೇ task ಮೇಲೆ (LLMs stochastic ಆದ್ದರಿಂದ ಒಂದೇ task ಹಲವು ಬಾರಿ ನಡೆಸಿ ಉತ್ತಮ ಉತ್ತರ ಆಯ್ಕೆ ಮಾಡಬಹುದು) ಅಥವಾ ಬೇರೆ tasks ಮೇಲೆ (ಉದಾ: ಒಟ್ಟಿಗೆ ಎರಡು non-overlapping features implement ಮಾಡುವುದು). Agents ಒಂದರ ಬದಲಾವಣೆ ಮತ್ತೊಂದಕ್ಕೆ ಅಡ್ಡಿಯಾಗದಂತೆ [git worktrees](https://git-scm.com/docs/git-worktree) ಬಳಸಬಹುದು; ಇದನ್ನು [version control](/2026/version-control/) ಉಪನ್ಯಾಸದಲ್ಲಿ ನೋಡುತ್ತೇವೆ.
- **MCPs.** MCP ಅಂದರೆ _Model Context Protocol_ - coding agents ಅನ್ನು tools ಜೊತೆ ಸಂಪರ್ಕಿಸಲು open protocol. ಉದಾ: ಈ [Notion MCP server](https://github.com/makenotion/notion-mcp-server) ಮೂಲಕ agent Notion docs ಓದಲು/ಬರೆಯಲು ಸಾಧ್ಯವಾಗುತ್ತದೆ. ಆಗ "{Notion doc} ನಲ್ಲಿ link ಆಗಿರುವ spec ಓದಿ, Notion ನಲ್ಲಿ ಹೊಸ page ಆಗಿ implementation plan draft ಮಾಡಿ, ನಂತರ prototype implement ಮಾಡು" ಎಂಬ use case ಸಾಧ್ಯ. MCPs ಕಂಡುಹಿಡಿಯಲು [Pulse](https://www.pulsemcp.com/servers), [Glama](https://glama.ai/mcp/servers) ಮೊದಲಾದ directories ಉಪಯುಕ್ತ.
- **Context management.** [ಮೇಲೆ](#ai-models-ಮತ್ತು-agents-ಹೇಗೆ-ಕೆಲಸ-ಮಾಡುತ್ತವೆ) ಹೇಳಿದಂತೆ coding agents ಆಧಾರವಾದ LLMs ಗೆ ಸೀಮಿತ _context window_ ಇದೆ. Coding agents ಅನ್ನು ಪರಿಣಾಮಕಾರಿಯಾಗಿ ಬಳಸಲು context ನ ಸರಿಯಾದ ನಿರ್ವಹಣೆ ಅಗತ್ಯ. Agent ಗೆ ಬೇಕಾದ ಮಾಹಿತಿ ಸಿಗಬೇಕು, ಆದರೆ ಅನಗತ್ಯ context ತಪ್ಪಿಸಬೇಕು - ಇಲ್ಲವಾದರೆ context window overflow ಆಗಬಹುದು ಅಥವಾ model performance ಕುಸಿಯಬಹುದು (window ತುಂಬದಿದ್ದರೂ context ಬೆಳೆಯುತ್ತಲೇ ಹೋದರೆ ಇದು ಸಾಮಾನ್ಯ). Agent harnesses context ಅನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ನೀಡುತ್ತವೆ ಮತ್ತು ಕೆಲವು ಮಟ್ಟಿಗೆ ನಿರ್ವಹಿಸುತ್ತವೆ, ಆದರೆ ಬಳಕೆದಾರನ ಕೈಯಲ್ಲಿಯೂ ಸಾಕಷ್ಟು ನಿಯಂತ್ರಣ ಇರುತ್ತದೆ.
    - **Context window clear ಮಾಡುವುದು.** ಅತ್ಯಂತ ಮೂಲ ನಿಯಂತ್ರಣ - coding agents context window clear ಮಾಡುವುದು (ಹೊಸ conversation ಆರಂಭಿಸುವುದು) ಬೆಂಬಲಿಸುತ್ತವೆ. ಸಂಬಂಧವಿಲ್ಲದ ಹೊಸ ಪ್ರಶ್ನೆಗಳಿಗೆ ಇದು ಉತ್ತಮ.
    - **Conversation rewind ಮಾಡುವುದು.** ಕೆಲವು coding agents conversation history ಯ ಹಂತಗಳನ್ನು undo ಮಾಡಲು ಅವಕಾಶ ಕೊಡುತ್ತವೆ. Agent ಅನ್ನು ಬೇರೆ ದಾರಿಗೆ ನಡೆಸಲು follow-up message ಕೊಡುವುದಕ್ಕಿಂತ, undo ಸೂಕ್ತವಾಗಿರುವ ಸಂದರ್ಭಗಳಲ್ಲಿ ಇದು context management ಗೆ ಹೆಚ್ಚು ಪರಿಣಾಮಕಾರಿ.
{%- comment %}
Make up a quick demo.
{% endcomment %}
    - **Compaction.** ಅಸೀಮ ಉದ್ದದ conversations ಗೆ coding agents context _compaction_ ಬೆಂಬಲಿಸುತ್ತವೆ: conversation history ಬಹಳ ಉದ್ದವಾದರೆ prefix ಭಾಗವನ್ನು summarize ಮಾಡಲು ಮತ್ತೊಂದು LLM ಅನ್ನು ಕರೆಯುತ್ತಾರೆ, ನಂತರ ಮೂಲ history ಬದಲು summary ಇಡುತ್ತಾರೆ. ಕೆಲವು agents ಬಳಕೆದಾರರಿಗೆ ಬೇಕಾದಾಗ compaction invoke ಮಾಡಲು ನಿಯಂತ್ರಣ ನೀಡುತ್ತವೆ.
{%- comment %}
Show `/compact` in Claude Code, show full summary.
{% endcomment %}
    - **llms.txt.** `/llms.txt` file ಎಂದರೆ inference ಸಮಯದಲ್ಲಿ LLMs ಬಳಕೆಗಾಗಿ ನಿರ್ದಿಷ್ಟಪಡಿಸಿದ [standard](https://llmstxt.org/) ಸ್ಥಳ. Products (ಉದಾ: [cursor.com/llms.txt](https://cursor.com/llms.txt)), libraries (ಉದಾ: [ai.pydantic.dev/llms.txt](https://ai.pydantic.dev/llms.txt)), APIs (ಉದಾ: [apify.com/llms.txt](https://apify.com/llms.txt)) ಇತ್ಯಾದಿಗಳಲ್ಲಿ `llms.txt` files ಇರಬಹುದು. ಇವು token ಗೆ ಹೆಚ್ಚಿನ ಮಾಹಿತಿ ಸಾಂದ್ರತೆಯನ್ನು ನೀಡುವುದರಿಂದ context-efficient ಆಗಿವೆ; coding agent ಗೆ HTML page fetch/read ಮಾಡಿಸುವುದಕ್ಕಿಂತ ಉತ್ತಮ. External documentation ವಿಶೇಷವಾಗಿ agent ಗೆ dependency ಬಗ್ಗೆ built-in ಜ್ಞಾನ ಇಲ್ಲದಾಗ ಉಪಯುಕ್ತ (ಉದಾ: dependency LLM knowledge cutoff ಬಳಿಕ ಪ್ರಕಟವಾಗಿದ್ದರೆ).
{%- comment %}
Side-by-side comparison in an empty repo (on Desktop or some other self-contained place, with `git init` run in it):

    Write a single-file Python program example in demo.py using semlib to sort "Ilya Sutskever", "Soumith Chintala", and "Donald Knuth" in terms of their fame as AI researchers.

    Write a single-file Python program example in demo.py using semlib to sort "Ilya Sutskever", "Soumith Chintala", and "Donald Knuth" in terms of their fame as AI researchers. See https://semlib.anish.io/llms.txt. Follow links to Markdown versions of any pages linked in llms.txt files.

Not sure why the agent doesn't do this by default. You'd probably put that last sentence in a CLAUDE.md file.
{% endcomment %}
    - **AGENTS.md.** ಹೆಚ್ಚಿನ coding agents [AGENTS.md](https://agents.md/) ಅಥವಾ ಅದರ ಸಮಾನ ಫೈಲ್‌ಗಳನ್ನು (ಉದಾ: Claude Code ನಲ್ಲಿ `CLAUDE.md`) coding agents ಗಾಗಿ README ಆಗಿ ಬೆಂಬಲಿಸುತ್ತವೆ. Agent ಪ್ರಾರಂಭವಾದಾಗ `AGENTS.md` ಸಂಪೂರ್ಣ ವಿಷಯವನ್ನು context ನಲ್ಲಿ ಪೂರ್ವಭರ್ತಿಯಾಗಿ ಸೇರಿಸುತ್ತದೆ. Session ಗಳಾದ್ಯಂತ ಸಾಮಾನ್ಯವಾಗಿರುವ ಮಾರ್ಗದರ್ಶನ ಇಲ್ಲಿ ಕೊಡಬಹುದು (ಉದಾ: code changes ನಂತರ type-checker ಸದಾ run ಮಾಡು, unit tests ಹೇಗೆ run ಮಾಡುವುದು ಹೇಳು, ಅಥವಾ agent browse ಮಾಡಬಹುದಾದ third-party docs links ಕೊಡು). ಕೆಲವು coding agents ಈ file ಅನ್ನು auto-generate ಮಾಡುತ್ತವೆ (ಉದಾ: Claude Code ನ `/init` command). ನೈಜ-world `AGENTS.md` ಉದಾಹರಣೆಗೆ [ಇಲ್ಲಿ](https://github.com/pydantic/pydantic-ai/blob/main/CLAUDE.md) ನೋಡಿ.
{%- comment %}
Dotbot example, CLAUDE.md that includes @DEVELOPMENT.md and says to always run the type checker and code formatter after making any changes to Python code.

Example prompt, off of master:

    Remove the "--version" command-line flag.

This is something that'll be fast, for demonstration purposes.
{% endcomment %}
    - **Skills.** `AGENTS.md` ನಲ್ಲಿರುವ ವಿಷಯವು ಯಾವಾಗಲೂ ಸಂಪೂರ್ಣವಾಗಿ context window ಗೆ ಲೋಡ್ ಆಗುತ್ತದೆ. _Skills_ ಇದನ್ನು ನಿಯಂತ್ರಿಸಲು ಒಂದು ಹೆಚ್ಚುವರಿ indirection ಕೊಡುತ್ತವೆ: skill descriptions ಜೊತೆ skills ಪಟ್ಟಿ ನೀಡಬಹುದು; ನಂತರ agent ಅಗತ್ಯವಿದ್ದಾಗ ಆಯ್ದ skill ಅನ್ನು "open" ಮಾಡಿ context ಗೆ ಲೋಡ್ ಮಾಡಬಹುದು.
    - **Subagents.** ಕೆಲವು coding agents task-specific workflows ಗಾಗಿ subagents ವ್ಯಾಖ್ಯಾನಿಸಲು ಅವಕಾಶ ಕೊಡುತ್ತವೆ. Top-level agent ನಿರ್ದಿಷ್ಟ task ಪೂರ್ಣಗೊಳಿಸಲು subagent ಅನ್ನು invoke ಮಾಡಬಹುದು. ಇದರಿಂದ top-level agent ಮತ್ತು subagent ಎರಡೂ context ಅನ್ನು ಉತ್ತಮವಾಗಿ ನಿರ್ವಹಿಸಬಹುದು. Top-level agent context ಗೆ subagent ನೋಡಿದ ಎಲ್ಲವೂ ತುಂಬುವುದಿಲ್ಲ; subagent ಗೆ ಅದರ task ಗೆ ಬೇಕಾದ context ಮಾತ್ರ ಸಿಗುತ್ತದೆ. ಉದಾ: ಕೆಲವು coding agents web research ಅನ್ನು subagent ರೂಪದಲ್ಲಿ ಜಾರಿಗೊಳಿಸುತ್ತವೆ - top-level agent query ಕೇಳುತ್ತದೆ, subagent web search ನಡೆಸಿ, pages ತಂದು, ಅವನ್ನು ವಿಶ್ಲೇಷಿಸಿ, top-level agent ಗೆ ಉತ್ತರ ನೀಡುತ್ತದೆ. ಇದರಿಂದ top-level agent context ಗೆ pages ಗಳ ಸಂಪೂರ್ಣ ವಿಷಯ ತುಂಬುವುದಿಲ್ಲ; ಹಾಗೆಯೇ subagent context ಗೆ top-level agent ನ ಉಳಿದ conversation history ಕೂಡ ತುಂಬುವುದಿಲ್ಲ.

Prompts ಬರೆಯುವ ಅಗತ್ಯವಿರುವ ಮುಂದುವರಿದ features ಗಳಲ್ಲಿ (ಉದಾ: skills, subagents), LLMs ಅನ್ನು ಆರಂಭಿಕ draft ಗಾಗಿ ಬಳಸಬಹುದು. ಕೆಲವು coding agents ನಲ್ಲಿ ಇದಕ್ಕೆ built-in support ಇರುತ್ತದೆ. ಉದಾ: Claude Code ನಲ್ಲಿ ಚಿಕ್ಕ prompt ನಿಂದ subagent ರಚಿಸಬಹುದು (`/agents` invoke ಮಾಡಿ ಹೊಸ agent ರಚಿಸಿ). ಈ prompt ಪ್ರಯತ್ನಿಸಿ:

```
A Python code checking agent that uses `mypy` and `ruff` to type-check, lint, and format *check* any files that have been modified from the last git commit.
```

ನಂತರ top-level agent ಗೆ "use the code checker subagent" ಎಂಬ ಸಂದೇಶ ನೀಡಿ subagent ಅನ್ನು ಸ್ಪಷ್ಟವಾಗಿ invoke ಮಾಡಬಹುದು. Python files ಬದಲಾಯಿಸಿದ ನಂತರ top-level agent ಸ್ವಯಂಚಾಲಿತವಾಗಿ subagent invoke ಮಾಡುವಂತೆ ಕೂಡ ಕೆಲವು ಸಂದರ್ಭಗಳಲ್ಲಿ ಮಾಡಬಹುದು.

# ಗಮನಿಸಬೇಕಾದ ವಿಷಯಗಳು

AI tools ತಪ್ಪು ಮಾಡುತ್ತವೆ. ಇವು LLMs ಮೇಲೆ ನಿರ್ಮಿತವಾಗಿವೆ; LLMs ಅಂದರೆ probabilistic next-token-prediction models ಮಾತ್ರ. ಇವು ಮಾನವರಂತೆ "intelligent" ಅಲ್ಲ. AI output ಅನ್ನು correctness ಮತ್ತು security bugs ದೃಷ್ಟಿಯಿಂದ ಪರಿಶೀಲಿಸಿ. ಕೆಲವು ಸಂದರ್ಭಗಳಲ್ಲಿ code verify ಮಾಡುವುದು ಅದನ್ನು ಕೈಯಿಂದ ಬರೆಯುವುದಕ್ಕಿಂತ ಕಷ್ಟವಾಗಬಹುದು. ಅತ್ಯಂತ ಪ್ರಮುಖ code ಗಾಗಿ ಕೈಯಿಂದ ಬರೆಯುವುದನ್ನು ಪರಿಗಣಿಸಿ. AI ಕೆಲವೊಮ್ಮೆ rabbit hole ಗೆ ಹೋಗಬಹುದು ಮತ್ತು ತಪ್ಪು ದಾರಿಗೆಳೆಯುವ ಉತ್ತರ ಕೊಡಬಹುದು - debugging spiral ಗಳ ಬಗ್ಗೆ ಎಚ್ಚರವಾಗಿರಿ. AI ಅನ್ನು crutch ಆಗಿ ಬಳಸಬೇಡಿ; ಅತಿಯಾದ ಅವಲಂಬನೆ ಅಥವಾ ಮೇಲ್ಮೈ ತಿಳುವಳಿಕೆ ಅಪಾಯಕಾರಿ. ಇನ್ನೂ ಅನೇಕ programming tasks ಗಳನ್ನು AI ಮಾಡಲು ಸಾಧ್ಯವಿಲ್ಲ. Computational thinking ಇನ್ನೂ ಅತ್ಯಂತ ಮೌಲ್ಯಯುತ.

# ಶಿಫಾರಸು ಮಾಡಿದ software

ಹಲವಾರು IDEs / AI coding extensions ಗಳಲ್ಲಿ coding agents ಒಳಗೊಂಡಿರುತ್ತವೆ ([development environment lecture](/2026/development-environment/) ಶಿಫಾರಸುಗಳನ್ನು ನೋಡಿ). ಇತರೆ ಜನಪ್ರಿಯ coding agents: Anthropic ನ [Claude Code](https://www.claude.com/product/claude-code), OpenAI ನ [Codex](https://openai.com/codex/), ಮತ್ತು [opencode](https://github.com/anomalyco/opencode) ಮೊದಲಾದ open-source agents.

# ವ್ಯಾಯಾಮಗಳು

1. ಒಂದೇ programming task ಅನ್ನು ನಾಲ್ಕು ಬಾರಿ ಮಾಡಿ - ಕೈಯಿಂದ coding, AI autocomplete, inline chat, ಮತ್ತು agents ಬಳಸಿ - ಅನುಭವವನ್ನು ಹೋಲಿಸಿ. ಉತ್ತಮ ಆಯ್ಕೆ ಎಂದರೆ ನೀವು ಈಗಾಗಲೇ ಕೆಲಸ ಮಾಡುತ್ತಿರುವ project ನ ಒಂದು ಸಣ್ಣ feature. ಇನ್ನಷ್ಟು ಕಲ್ಪನೆಗಳಿಗಾಗಿ GitHub open-source projects ನಲ್ಲಿ "good first issue" ಶೈಲಿಯ tasks, ಅಥವಾ [Advent of Code](https://adventofcode.com/) / [LeetCode](https://leetcode.com/) ಸಮಸ್ಯೆಗಳು ಪ್ರಯತ್ನಿಸಬಹುದು.
1. ಅಪರಿಚಿತ codebase ಅನ್ವೇಷಿಸಲು AI coding agent ಬಳಸಿ. ಇದು ನೀವು ನಿಜವಾಗಿಯೂ ಕಾಳಜಿ ಇರುವ project ನಲ್ಲಿ bug debug ಮಾಡಬೇಕು ಅಥವಾ ಹೊಸ feature ಸೇರಿಸಬೇಕು ಎಂಬ ಸಂದರ್ಭದಲ್ಲೇ ಉತ್ತಮ. ಅಂತಹ project ನೆನಪಿಗೆ ಬರದಿದ್ದರೆ, [opencode](https://github.com/anomalyco/opencode) agent ನಲ್ಲಿ security-ಸಂಬಂಧಿತ features ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತವೆ ಎಂದು AI agent ಮೂಲಕ ಅರ್ಥಮಾಡಿಕೊಳ್ಳಿ.
1. ಸಣ್ಣ app ಅನ್ನು ಆರಂಭದಿಂದ vibe code ಮಾಡಿ. ಕೈಯಿಂದ ಒಂದು ಸಾಲು code ಕೂಡ ಬರೆಯಬೇಡಿ.
1. ನಿಮ್ಮ ಇಷ್ಟದ coding agent ಗಾಗಿ `AGENTS.md` (ಅಥವಾ ಅದರ ಸಮಾನ file, ಉದಾ: `CLAUDE.md`) ರಚಿಸಿ ಮತ್ತು ಪರೀಕ್ಷಿಸಿ; ಜೊತೆಗೆ reusable prompt (ಉದಾ: [custom slash command in Claude Code](https://code.claude.com/docs/en/slash-commands) ಅಥವಾ [custom prompts in Codex](https://developers.openai.com/codex/custom-prompts)), skill (ಉದಾ: [skill in Claude Code](https://code.claude.com/docs/en/skills) ಅಥವಾ [skill in Codex](https://developers.openai.com/codex/skills/)), ಮತ್ತು subagent (ಉದಾ: [subagent in Claude Code](https://code.claude.com/docs/en/sub-agents)) ಪ್ರಯತ್ನಿಸಿ. ಯಾವ ಸಂದರ್ಭದಲ್ಲೇನು ಬಳಸಬೇಕು ಎಂಬುದನ್ನು ಚಿಂತಿಸಿ. ನಿಮ್ಮ ಆಯ್ಕೆ coding agent ಕೆಲವು features ಬೆಂಬಲಿಸದೇ ಇರಬಹುದು; ಅಂಥದ್ದಾದರೆ ಅವನ್ನು ಬಿಟ್ಟುಬಿಡಿ ಅಥವಾ ಬೆಂಬಲವಿರುವ ಬೇರೆ agent ಪ್ರಯತ್ನಿಸಿ.
1. [Code Quality lecture](/2026/code-quality/) ನ Markdown bullet points regex exercise ನಲ್ಲಿ ಇರುವಂತೆಯೇ coding agent ಬಳಸಿ ಒಂದೇ ಗುರಿ ಸಾಧಿಸಿ. ಅದು task ಅನ್ನು direct file edits ಮೂಲಕ ಪೂರ್ಣಗೊಳಿಸುತ್ತದೆಯೇ? ಆ ರೀತಿಯಲ್ಲಿ agent ನೇರವಾಗಿ file edit ಮಾಡುವುದರ ದೋಷಗಳು ಮತ್ತು ಮಿತಿಗಳು ಯಾವುವು? Direct file edits ಮಾಡದೆ task ಮುಗಿಸುವಂತೆ prompt ಹೇಗೆ ನೀಡಬೇಕು ಎಂದು ಕಂಡುಹಿಡಿಯಿರಿ. ಸೂಚನೆ: [first lecture](/2026/course-shell/) ನಲ್ಲಿ ಹೇಳಿದ command-line tools ಗಳಲ್ಲಿ ಒಂದನ್ನು ಬಳಸುವಂತೆ ಕೇಳಿ.
1. ಹೆಚ್ಚಿನ coding agents ಗಳಲ್ಲಿ "yolo mode" ಇರುವ ಒಂದು ರೂಪ ಇರುತ್ತದೆ (ಉದಾ: Claude Code ನಲ್ಲಿ `--dangerously-skip-permissions`). ಈ mode ಅನ್ನು ನೇರವಾಗಿ ಬಳಸುವುದು ಸುರಕ್ಷಿತವಲ್ಲ. ಆದರೆ virtual machine ಅಥವಾ container ಮೊದಲಾದ isolated environment ನಲ್ಲಿ coding agent ನಡೆಸಿ autonomous operation ಸಕ್ರಿಯಗೊಳಿಸುವುದು ಒಪ್ಪಿಕೊಳ್ಳಬಹುದಾದ ಮಾರ್ಗವಾಗಬಹುದು. ಈ setup ಅನ್ನು ನಿಮ್ಮ ಯಂತ್ರದಲ್ಲಿ ಚಾಲನೆ ಮಾಡಿ. [Claude Code devcontainers](https://code.claude.com/docs/en/devcontainer) ಅಥವಾ [Docker Sandboxes / Claude Code](https://docs.docker.com/ai/sandboxes/claude-code/) ಮೊದಲಾದ docs ಸಹಾಯಕವಾಗಬಹುದು. ಇದನ್ನು ಹೊಂದಿಸಲು ಒಂದಕ್ಕಿಂತ ಹೆಚ್ಚು ವಿಧಾನಗಳಿವೆ.
