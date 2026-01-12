---
layout: lecture
title: "Development Environment and Tools"
date: 2026-01-14
ready: true
---

A _development environment_ is a set of tools for developing software. At the heart of a development environment is text editing functionality, along with accompanying features such as syntax highlighting, type checking, code formatting, and autocomplete. _Integrated development environments_ (IDEs) such as [VS Code][vs-code] bring together all of this functionality into a single application. Terminal-based development workflows combine tools such as [tmux](https://github.com/tmux/tmux) (a terminal multiplexer), [Vim](https://www.vim.org/) (a text editor), [Zsh](https://www.zsh.org/) (a shell), and language-specific command-line tools, such as [Ruff](https://docs.astral.sh/ruff/) (a Python linter and code formatter) and [Mypy](https://mypy-lang.org/) (a Python type checker).

IDEs and terminal-based workflows each have their strengths and weaknesses. For example, graphical IDEs can be easier to learn, and today's IDEs generally have better out-of-the-box AI integrations like AI autocomplete; on the other hand, terminal-based workflows are lightweight, and they may be your only option in environments where you don't have a GUI or can't install software. We recommend you develop basic familiarity with both and develop mastery of at least one. If you don't already have a preferred IDE, we recommend starting with [VS Code][vs-code].

In this lecture, we'll cover:

- [Text editing and Vim](#text-editing-and-vim)
- [Code intelligence and language servers](#code-intelligence-and-language-servers)
- [AI-powered development](#ai-powered-development)
- [Regular expressions for search and replace](#regular-expressions-for-search-and-replace)
- [Extensions and other IDE functionality](#extensions-and-other-ide-functionality)

[vs-code]: https://code.visualstudio.com/

# Text editing and Vim

When programming, you spend most of your time navigating through code, reading snippets of code, and making edits to code, rather than writing long streams or reading files top-to-bottom. [Vim] is a text editor that is optimized for this distribution of tasks.

**The philosophy of Vim.** Vim has a beautiful idea as its foundation: its interface is itself a programming language, designed for navigating and editing text. Keystrokes (with mnemonic names) are commands, and these commands are composable. Vim avoids the use of the mouse, because it's too slow; Vim even avoids use of the arrow keys because it requires too much movement. The result: an editor that feels like a brain-computer interface and matches the speed at which you think.

**Vim support in other software.** You don't have to use [Vim] itself to benefit from the ideas at its core. Many programs that involve any kind of text editing support "Vim mode", either as built-in functionality or as a plugin. For example, VS Code has the [VSCodeVim](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim) plugin, Zsh has [built-in support](https://zsh.sourceforge.io/Guide/zshguide04.html) for Vim emulation, and even Claude Code has [built-in support](https://code.claude.com/docs/en/interactive-mode#vim-editor-mode) for Vim editor mode. Chances are that any tool you use that involves text editing supports Vim mode in one way or another.

## Modal editing

Vim is a _modal editor_: it has different operating modes for different classes of tasks.

- **Normal**: for moving around a file and making edits
- **Insert**: for inserting text
- **Replace**: for replacing text
- **Visual** (plain, line, or block): for selecting blocks of text
- **Command-line**: for running a command

Keystrokes have different meanings in different operating modes. For example, the letter `x` in Insert mode will just insert a literal character "x", but in Normal mode, it will delete the character under the cursor, and in Visual mode, it will delete the selection.

In its default configuration, Vim shows the current mode in the bottom left. The initial/default mode is Normal mode. You'll generally spend most of your time between Normal mode and Insert mode.

You change modes by pressing `<ESC>` (the escape key) to switch from any mode back to Normal mode. From Normal mode, enter Insert mode with `i`, Replace mode with `R`, Visual mode with `v`, Visual Line mode with `V`, Visual Block mode with `<C-v>` (Ctrl-V, sometimes also written `^V`), and Command-line mode with `:`.

You use the `<ESC>` key a lot when using Vim: consider remapping Caps Lock to Escape ([macOS instructions](https://vim.fandom.com/wiki/Map_caps_lock_to_escape_in_macOS)) or create an [alternative mapping](https://vim.fandom.com/wiki/Avoid_the_escape_key#Mappings) for `<ESC>` with a simple key sequence.

## Basics: inserting text

From Normal mode, press `i` to enter Insert mode. Now, Vim behaves like any other text editor, until you press `<ESC>` to return to Normal mode. This, along with the basics explained above, are all you need to start editing files using Vim (though not particularly efficiently, if you're spending all your time editing from Insert mode).

## Vim's interface is a programming language

Vim's interface is a programming language. Keystrokes (with mnemonic names) are commands, and these commands _compose_. This enables efficient movement and edits, especially once the commands become muscle memory, just like typing becomes super efficient once you've learned your keyboard layout.

### Movement

You should spend most of your time in Normal mode, using movement commands to navigate the file. Movements in Vim are also called "nouns", because they refer to chunks of text.

- Basic movement: `hjkl` (left, down, up, right)
- Words: `w` (next word), `b` (beginning of word), `e` (end of word)
- Lines: `0` (beginning of line), `^` (first non-blank character), `$` (end of line)
- Screen: `H` (top of screen), `M` (middle of screen), `L` (bottom of screen)
- Scroll: `Ctrl-u` (up), `Ctrl-d` (down)
- File: `gg` (beginning of file), `G` (end of file)
- Line numbers: `:{number}<CR>` or `{number}G` (line {number})
    - `<CR>` refers to the carriage return / enter key
- Misc: `%` (matching item, like parenthesis or brace)
- Find: `f{character}`, `t{character}`, `F{character}`, `T{character}`
    - find/to forward/backward {character} on the current line
    - `,` / `;` for navigating matches
- Search: `/{regex}`, `n` / `N` for navigating matches

### Selection

Visual modes:

- Visual: `v`
- Visual Line: `V`
- Visual Block: `Ctrl-v`

Can use movement keys to make selection.

### Edits

Everything that you used to do with the mouse, you now do with the keyboard using editing commands that compose with movement commands. Here's where Vim's interface starts to look like a programming language. Vim's editing commands are also called "verbs", because verbs act on nouns.

- `i` enter Insert mode
    - but for manipulating/deleting text, want to use something more than backspace
- `o` / `O` insert line below / above
- `d{motion}` delete {motion}
    - e.g. `dw` is delete word, `d$` is delete to end of line, `d0` is delete to beginning of line
- `c{motion}` change {motion}
    - e.g. `cw` is change word
    - like `d{motion}` followed by `i`
- `x` delete character (equivalent to `dl`)
- `s` substitute character (equivalent to `cl`)
- Visual mode + manipulation
    - select text, `d` to delete it or `c` to change it
- `u` to undo, `<C-r>` to redo
- `y` to copy / "yank" (some other commands like `d` also copy)
- `p` to paste
- Lots more to learn: for example, `~` flips the case of a character, and `J` joins together lines

### Counts

You can combine nouns and verbs with a count, which will perform a given action a number of times.

- `3w` move 3 words forward
- `5j` move 5 lines down
- `7dw` delete 7 words

### Modifiers

You can use modifiers to change the meaning of a noun. Some modifiers are `i`, which means "inner" or "inside", and `a`, which means "around".

- `ci(` change the contents inside the current pair of parentheses
- `ci[` change the contents inside the current pair of square brackets
- `da'` delete a single-quoted string, including the surrounding single quotes

## Putting it all together

Here is a broken [fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz) implementation:

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

We use the following sequence of commands to fix the issues, beginning in Normal mode:

- Main is never called
    - `G` to jump to the end of the file
    - `o` to **o**pen a new line below
    - Type in `if __name__ == "__main__": main()`
        - If your editor has Python language support, it might do some auto-indentation for you in Insert mode
    - `<ESC>` to go back to Normal mode
- Starts at 0 instead of 1
    - `/` followed by `range` and `<CR>` to search for "range"
    - `ww` to move forward two **w**ords (you could also use `2w`, but in practice, for small counts it's common to repeat the key instead of using the count functionality)
    - `i` to switch to **i**nsert mode, and add `1,`
    - `<ESC>` to go back to Normal mode
    - `e` to jump to the **e**nd of the next word
    - `a` to start **a**ppending text, and add `+ 1`
    - `<ESC>` to go back to Normal mode
- Prints "fizz" for multiples of 5
    - `:6<CR>` to go to line 6
    - `ci"` to **c**hange **i**nside the '**"**', change to `"buzz"`
    - `<ESC>` to go back to Normal mode

## Learning Vim

The best way to learn Vim is to learn the fundamentals (what we've covered so far) and then just enable Vim mode in all your software and start using it in practice. Avoid the temptation to use the mouse or the arrow keys; in some editors, you can unbind the arrow keys to force yourself to build good habits.

### Additional resources

- The [Vim lecture](/2020/editors/) from the previous iteration of this class --- we have covered Vim in more depth there
- `vimtutor` is a tutorial that comes installed with Vim --- if Vim is installed, you should be able to run `vimtutor` from your shell
- [Vim Adventures](https://vim-adventures.com/) is a game to learn Vim
- [Vim Tips Wiki](http://vim.wikia.com/wiki/Vim_Tips_Wiki)
- [Vim Advent Calendar](https://vimways.org/2019/) has various Vim tips
- [VimGolf](http://www.vimgolf.com/) is [code golf](https://en.wikipedia.org/wiki/Code_golf), but where the programming language is Vim's UI
- [Vi/Vim Stack Exchange](https://vi.stackexchange.com/)
- [Vim Screencasts](http://vimcasts.org/)
- [Practical Vim](https://pragprog.com/titles/dnvim2/) (book)

[Vim]: https://www.vim.org/

# Code intelligence and language servers

IDEs generally offer language-specific support that requires semantic understanding of the code through IDE extensions that connect to _language servers_ that implement [Language Server Protocol](https://microsoft.github.io/language-server-protocol/). For example, the [Python extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-python.python) relies on [Pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance), and the [Go extension for VS Code](https://marketplace.visualstudio.com/items?itemName=golang.go) relies on the first-party [gopls](https://go.dev/gopls/). By installing the extension and language server for the languages you work with, you can enable many language-specific features in your IDE, such as:

- **Code formatting.** Auto-indentation and auto-formatting for blocks of code.
- **Code completion.** Better autocomplete and autosuggest, such as being able to see an object's fields and methods after typing `object.`.
- **Inline documentation.** Seeing documentation on hover and autosuggest.
- **Jump-to-definition.** Jumping from a use site to the definition, such as being able to go from a field reference `object.field` to the definition of the field.
- **Find references.** The inverse of the above, find all sites where a particular item such as a field or type is referenced.
- **Type checking and linting.** Find errors in your code as you type.
- **Help with imports.** Organizing imports, removing unused imports, flagging missing imports.

## Configuring language servers

For some languages, all you need to do is install the extension and language server, and you'll be all set. For others, to get the maximum benefit from the language server, you need to tell the IDE about your environment. For example, pointing VS Code to your [Python environment](https://code.visualstudio.com/docs/python/environments) will enable the language server to see your installed packages. Environments are covered in more depth in our [lecture on packaging and shipping code](/2026/shipping-code/).

Depending on the language, there might be some settings you can configure for your language server. For example, using the Python support in VS Code, you can disable static type checking for projects that don't make use of Python's optional type annotations.

# AI-powered development

Since the introduction of [GitHub Copilot][github-copilot] using OpenAI's [Codex model](https://openai.com/index/openai-codex/) in mid 2021, [LLMs](https://en.wikipedia.org/wiki/Large_language_model) have become widely adopted in software engineering. There are three main form factors in use right now: autocomplete, inline chat, and coding agents.

[github-copilot]: https://github.com/features/copilot/ai-code-editor

## Autocomplete

AI-powered autocomplete has the same form factor as traditional autocomplete in your IDE, suggesting completions at your cursor position as you type. Sometimes, it's used as a passive feature that "just works". Beyond that, AI autocomplete is generally [prompted](https://en.wikipedia.org/wiki/Prompt_engineering) using code comments.

For example, let's write a script to download the contents of these lecture notes and extract all the links. We can start with:

```python
url = "https://raw.githubusercontent.com/missing-semester/missing-semester/refs/heads/master/_2026/development-environment.md"
```

Next, we can prompt the autocomplete model by writing a comment:

```python
# download the url and get its contents as a string
```

The model will suggest something like:

```python
import requests
response = requests.get(url)
content = response.text
```

We can also write some partial code, using a descriptive variable name to guide the model::

```python
import re
links = re.findall(
```

And the model will complete the line:

```python
links = re.findall(r'\[([^\]]+)\]\((https?://[^\)]+)\)', content)
```

## Inline chat

Inline chat lets you select a line or block and then directly prompt the AI model to propose an edit. In this interaction mode, the model can make changes to existing code (which differs from autocomplete, which only completes code beyond the cursor).

Continuing the example from above, supposed we don't like that the model is using the third-party `requests` library. We could select the relevant three lines of code, invoke inline chat, and say something like:

```
use built-in libraries instead
```

The model proposes:

```python
import urllib.request
with urllib.request.urlopen(url) as response:
    content = response.read().decode('utf-8')
```

## Coding agents

Coding agents are conversational AI models with access to tools such as reading/writing files, web search, and invoking shell commands. They live either in the IDE or in standalone command-line or GUI tools. Coding agents are highly autonomous and powerful tools, enabling a wide variety of use cases.

Continuing the example from above, we can try prompting a coding agent with the following task:

> Turn this into a proper command-line program, with argparse for argument parsing. Add type annotations, and make sure the program passes type checking.

The agent will read the file to understand it, then make some edits, and finally invoke the type checker to make sure the type annotations are correct. If it makes a mistake such that it fails type checking, it will likely iterate, though this is a simple task so that is unlikely to happen. Because coding agents have access to tools that may be harmful, by default, agent harnesses prompt the user to confirm tool calls.

Coding agents support multi-turn interaction, so you can iterate on work over a back-and-forth conversation with the agent. You can even interrupt the agent if it's going down the wrong track. One helpful mental model might be that of a manager of an intern: the intern will do the nitty gritty work, but will require guidance, and will occasionally do the wrong thing and need to be corrected.

### How AI models and agents work

Fully explaining the inner workings of modern [large language models (LLMs)](https://en.wikipedia.org/wiki/Large_language_model) and infrastructure such as agent harnesses is beyond the scope of this course. However, having a high-level understanding of some of the key ideas is helpful for effectively _using_ this bleeding edge technology and understanding its limitations.

LLMs can be viewed as modeling the probability distribution of completion strings (outputs) given prompt strings (inputs). LLM inference (what happens when you, e.g., supply a query to a conversational chat app) _samples_ from this probability distribution. LLMs have a fixed _context window_, the maximum length of the input and output strings.

AI tools such as conversational chat and coding agents build on top of this primitive. For multi-turn interactions, chat apps and agents use turn markers and supply the entire conversation history as the prompt string every time there is a new user prompt, invoking LLM inference once per user prompt. For tool-calling agents, the harness interprets certain LLM outputs as requests to invoke a tool, and the harness supplies the results of the tool call back to the model as part of the prompt string (so LLM inference runs again every time there is a tool call/response).

### Use cases

Coding agents can be helpful for a wide variety of tasks. Some examples:

- **Implementing new features.** As in the example above, you can ask a coding agent to implement a feature. Giving a good specification is more of an art than a science at this point; you want the input to the agent to be descriptive enough so that the agent does what you want it to do (at least heading in the right direction so you can iterate), but not overly descriptive to the point where you're doing too much work yourself. Models are continually improving, so you'll have to keep your intuition up-to-date on what the models are capable of.
- **Fixing errors.** If you have errors from your compiler, linter, type checker, or tests, you can ask your agent to correct them, for example with a prompt like "fix the issues with mypy". You can get it to run in a loop where it'll autonomously iterate on running the check, making edits, and repeating until it fixes all the issues. You do need to keep an eye on it though, sometimes it can go down the wrong track.
- **Refactoring.** You can use coding agents to refactor code in various ways, from simple tasks like renaming a method (this kind of refactoring is also supported by [code intelligence](#code-intelligence-and-language-servers)) to more complex tasks like breaking out functionality into a separate module.
- **Code review.** You can ask coding agents to review code. You can give them basic guidance, like "review my latest changes that are not yet committed". If you want to review a pull request and your coding agent supports web fetch, or you have command-line tools like the [GitHub CLI](https://cli.github.com/) installed, you might even be able to ask the coding agent "Review the pull request {link}" and it'll handle it from there.
- **Code understanding.** You can ask a coding agent questions about a codebase, which can be particularly helpful for onboarding.
- **Vibe coding.** Agents are powerful enough that you can implement some applications without writing a single line of code yourself.

### Advanced agents

Here, we give a brief overview of some more advanced usage patterns and capabilities of coding agents.

- **Parallel agents.** Coding agents can be slow: you can prompt the agent, and it can work at a problem for tens of minutes. You can run multiple copies of agents at the same time, either working on the same task (LLMs are stochastic, so it can be helpful to run the same thing multiple times and take the best solution) or different tasks (e.g., implement two non-overlapping features at the same time). To keep the different agents' changes from interfering with each other, you can use [git worktrees](https://git-scm.com/docs/git-worktree), which we cover in the lecture on [version control](/2026/version-control/).
- **MCPs.** MCP, which stands for _Model Context Protocol_, is an open protocol that you can use to connect your coding agents with tools. For example, this [Notion MCP server](https://github.com/makenotion/notion-mcp-server) can let your agent read/write Notion docs, enabling use cases like "read the spec linked in {Notion doc}, draft an implementation plan as a new page in Notion, and then implement a prototype". For discovering MCPs, you can use directories like [Pulse](https://www.pulsemcp.com/servers) and [Glama](https://glama.ai/mcp/servers).
- **Context management.** As we noted [above](#how-ai-models-and-agents-work), the LLMs that underlie coding agents have a limited _context window_. Effective use of coding agents necessitates making good use of context. You want to make sure the agent has access to the information it needs, but avoid unnecessary context to avoid overflowing the context window or degrading the performance of the model (which tends to happen as context size grows, even if it doesn't overflow the context window). Agent harnesses automatically supply, and to some degree, manage context, but a lot of control is left to the user.
    - **Clearing the context window.** The most basic control, coding agents support clearing the context window (starting a new conversation), which you should do for unrelated queries.
    - **Rewinding the conversation.** Some coding agents support undoing steps in the conversation history. Rather than give a follow-up message steering the agent in a different direction, in situations where an "undo" makes more sense, this more effectively manages context.
    - **Compaction.** To enable conversations of unbounded length, coding agents support context _compaction_: if the conversation history grows too long, they will automatically call an LLM to summarize the prefix of the conversation, and replace the conversation history with the summary. Some agents give control to the user to invoke compaction when desired.
    - **AGENTS.md.** Most coding agents support [AGENTS.md](https://agents.md/) or similar (e.g., Claude Code looks for `CLAUDE.md`) as a README for coding agents. When the agent starts, it pre-fills the context with the entire contents of `AGENTS.md`. You can use this to give the agent advice that is common across sessions (e.g., instruct it to always run the type-checker after making code changes, explain how to run unit tests, or provide links to third-party docs that the agent can browse). Some coding agents can auto-generate this file (e.g., the `/init` command in Claude Code). See [here](https://github.com/pydantic/pydantic-ai/blob/main/CLAUDE.md) for a real-world example of an `AGENTS.md`.
    - **Skills.** Content in the `AGENTS.md` is always loaded, in its entirety, into the context window of an agent. _Skills_ add one level of indirection to avoid context bloat: you can provide the agent with a list of skills along with descriptions, and the agent can "open" the skill (load it into its context window) as desired.
    - **Subagents.** Some coding agents let you define subagents, which are agents for task-specific workflows. The top-level coding agent can invoke a sub-agent to complete a particular task, which enables both the top-level agent and subagent to more effectively manage context. The top-level agent's context isn't bloated with everything the subagent sees, and the subagent can get just the context it needs for its task. As one example, some coding agents implement the web research as a subagent: the top-level agent will pose a query to the subagent, which will run web search, retrieve individual web pages, analyze them, and provide an answer to the query to the top-level agent. This way, the top-level agent doesn't have its context bloated by the full content of all retrieved web pages, and the subagent doesn't have in its context the rest of the conversation history of the top-level agent.

## What to watch out for

AI tools can make mistakes. They are built on LLMs, which are just probabilistic next-token-prediction models. They are not "intelligent" in the same way as humans. Review AI output for correctness and security bugs. Sometimes verifying code can be harder than writing the code yourself; for critical code, consider writing it by hand. AI can go down rabbit holes and try to gaslight you; be aware of debugging spirals. Don't use AI as a crutch, and be wary of overreliance or having a shallow understanding. There's still a huge class of programming tasks that AI is still incapable of doing. Computational thinking is still valuable.

## Recommended software

Some popular AI IDEs are [VS Code][vs-code] with the [GitHub Copilot][github-copilot] extension and [Cursor](https://cursor.com/). GitHub Copilot is currently available [for free for students](https://github.com/education/students), teachers, and maintainers of popular open source projects. These IDEs include coding agents; other popular coding agents include Anthropic's [Claude Code](https://www.claude.com/product/claude-code) and OpenAI's [Codex](https://openai.com/codex/). This is a rapidly evolving space. Many of the leading products have roughly equivalent functionality.

# Regular expressions for search and replace

_Regular expressions_, commonly abbreviated as "regex", is a language used to represent sets of strings. IDEs support regex for pattern-based search and search-and-replace. Regex patterns are also used commonly in other contexts such as command-line tools. For example, [ag](https://github.com/ggreer/the_silver_searcher) supports regex patterns for codebase-wide search (e.g., `ag "import .* as .*"` will find all renamed imports in Python), and [go test](https://pkg.go.dev/cmd/go#hdr-Test_packages) supports a `-run [regexp]` option for selecting a subset of tests. Furthermore, programming languages have built-in support or third-party libraries for regular expression matching, so you can use regexes for functionality such as pattern matching, validation, and parsing.

To help build intuition, below are some examples of regex patterns. In this lecture, we use [Python regex syntax](https://docs.python.org/3/library/re.html). There are many flavors of regex, with slight variation between them, especially in the more sophisticated functionality. You can use an online regex tester like [regex101](https://regex101.com/) to develop and debug regular expressions.

- `abc` --- matches the literal "abc".
- `missing|semester` --- matches the string "missing" or the string "semester".
- `\d{4}-\d{2}-\d{2}` --- matches dates in YYYY-MM-DD format, such as "2026-01-14". Beyond ensuring that the string consists of four digits, a dash, two digits, a dash, and two digits, this does not validate the date, so "2026-01-99" matches this regex pattern too.
- `.+@.+` --- matches email addresses, strings that contain some text, then an "@", and then some more text. This does only the most basic validation and matches strings like "nonsense@@@email". A regex that matches email addresses with no false positives or negatives [exists](https://pdw.ex-parrot.com/Mail-RFC822-Address.html) but is impractical.

## Regex syntax

You can find a comprehensive guide to regex syntax in [this documentation](https://docs.python.org/3/library/re.html#regular-expression-syntax) (or one of many other resources available online). Here are some of the basic building blocks:

- `abc` matches the literal string, when the characters have no special meaning (in this example, "abc")
- `.` matches any single character
- `[abc]` matches a single character contained in the brackets (in this example, "a", "b", or "c")
- `[^abc]` matches a single character except those contained in the brackets (e.g., "d")
- `[a-f]` matches a single character contained in the range indicated in the brackets (e.g., "c", but not "q")
- `a|b` matches either pattern (e.g., "a" or "b")
- `\d` matches any digit character (e.g., "3")
- `\w` matches any word character (e.g., "x")
- `(...)` matches the group of a pattern
- `...?` matches zero or one of a pattern, such as `words?` to match "word" or "words"
- `...*` matches any number of a pattern, such as `.*` to match any number of any character
- `...+` matches one or more of a pattern, such as `\d+` to match any non-zero number of digits
- `...{N}` matches exactly N of a pattern, such as `\d{4}` for 4 digits
- `\.` matches a literal "."
- `\\` matches a literal "\\"
- `^` matches the start of the line
- `$` matches the end of the line

## Capture groups and references

If you use regex groups `(...)`, you can refer to sub-parts of the match for extraction or search-and-replace purposes. For example, to extract just the month from a YYYY-MM-DD style date, you can use the following Python code:

```python
>>> import re
>>> re.match(r"\d{4}-(\d{2})-\d{2}", "2026-01-14").group(1)
'01'
```

In your text editor, you can use reference capture groups in replace patterns. The syntax might vary between IDE. For example, in VS Code, you can use variables like `$1`, `$2`, etc., and in Vim, you can use `\1`, `\2`, etc., to reference groups.

## Learning regex

We recommend learning the fundamentals (what we have covered in this lecture), and then looking at regex references as you need them, rather than memorizing the entirety of the language.

Conversational AI tools can be effective at helping you generating regex patterns. For example, try prompting your favorite LLM with the following query:

```
Write a Python-style regex pattern that matches the requested path from log lines from Nginx. Here is an example log line:

169.254.1.1 - - [09/Jan/2026:21:28:51 +0000] "GET /feed.xml HTTP/2.0" 200 2995 "-" "python-requests/2.32.3"
```

# Extensions and other IDE functionality

IDEs are powerful tools, made even more powerful by _extensions_. We can't cover all of these features in a single lecture, but here we provide some pointers to a couple popular extensions. We encourage you to explore this space on your own; there are many lists of popular IDE extensions available online, such as [Vim Awesome](https://vimawesome.com/) for Vim plugins and [VS Code extensions sorted by popularity](https://marketplace.visualstudio.com/search?target=VSCode&category=All%20categories&sortBy=Installs).

- [Development containers](https://containers.dev/): supported by popular IDEs (e.g., [supported by VS Code](https://code.visualstudio.com/docs/devcontainers/containers)), dev containers let you use a container to run development tools. This can be helpful for portability or isolation. The lecture on [lecture on packaging and shipping code](/2026/shipping-code/) covers containers in more depth.
- Remote development: do development on a remote machine using SSH (e.g., with the [Remote SSH plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)). This can be handy, for example, if you want to develop and run code on a beefy GPU machine in the cloud.
- Collaborative editing: edit the same file, Google Docs style (e.g., with the [Live Share plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=MS-vsliveshare.vsliveshare)).

# Exercises

1. Enable Vim mode in all the software you use that supports it, such as your editor and your shell, and use Vim mode for all your text editing for the next month. Whenever something seems inefficient, or when you think "there must be a better way", try Googling it, there probably is a better way.
1. Complete a challenge from [VimGolf](https://www.vimgolf.com/).
1. Configure an IDE extension and language server for a project that you're working on. Ensure that all the expected functionality, such as jump-to-definition for library dependencies, works as expected. If you don't have code that you can use for this exercise, you can use some open-source project from GitHub (such as [this one](https://github.com/spf13/cobra)).
1. Compare the experience of coding by hand, using AI autocomplete, inline chat, and agents by doing the same programming task four times. The best candidate is a small-sized feature from a project you're already working on. If you're looking for other ideas, you could consider completing "good first issue" style tasks in open-source projects on GitHub, or [Advent of Code](https://adventofcode.com/) or [LeetCode](https://leetcode.com/) problems.
1. Use an AI coding agent to navigate an unfamiliar codebase. This is best done in the context of wanting to debug or add a new feature to a project you actually care about. If you don't have any that come to mind, try using an AI agent to understand how security-related features work in the [crush](https://github.com/charmbracelet/crush) agent.
1. Vibe code a small app from scratch. Do not write a single line of code by hand.
1. Practice regex search-and-replace by replacing the `-` [Markdown bullet markers](https://spec.commonmark.org/0.31.2/#bullet-list-marker) with `*` bullet markers in the [lecture notes for today](https://raw.githubusercontent.com/missing-semester/missing-semester/refs/heads/master/_2026/development-environment.md). Note that just replacing all the "-" characters in the file would be incorrect, as there are many uses of that character that are not bullet markers.
1. Use an AI agent to accomplish the same goal as in the exercise above.
1. Browse a list of IDE extensions and install one that seems useful to you.
