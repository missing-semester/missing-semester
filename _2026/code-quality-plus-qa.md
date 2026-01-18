---
layout: lecture
title: "Code Quality + Q&A"
thumbnail: /static/assets/thumbnails/2026/lec9.png
date: 2026-01-23
ready: true
---

<span class="construction">
This page is under construction for the IAP 2026 offering of Missing Semester. This lecture will cover topics similar to the [Metaprogramming](/2020/metaprogramming/) lecture from the 2020 offering.
</span>

In this lecture, we'll cover:

- Formatting and linting, including AI remediation
- Testing, including fuzzing and property-based testing, and AI test generation
- Code coverage
- Make, [just](https://github.com/casey/just)
- Continuous integration, GitHub actions
- Regular expressions

{% comment %}
lecturer: Anish

- Autoformatters
- Linters
    - AI for addressing issues
    - [semgrep](https://github.com/semgrep/semgrep) for custom linting
- Testing
    - including fuzzing, property-based testing
    - AI for writing tests
- Code coverage
- Make, just
    - sometimes, language-specific versions of this (e.g., npm scripts)
- Continuous integration, GitHub Actions
- Regular expressions (moved from dev env lecture)
{% endcomment %}

# Regular expressions for pattern matching

_Regular expressions_, commonly abbreviated as "regex", is a language used to represent sets of strings. IDEs support regex for pattern-based search and search-and-replace. Regex patterns are also used commonly for pattern matching in other contexts such as command-line tools. For example, [ag](https://github.com/ggreer/the_silver_searcher) supports regex patterns for codebase-wide search (e.g., `ag "import .* as .*"` will find all renamed imports in Python), and [go test](https://pkg.go.dev/cmd/go#hdr-Test_packages) supports a `-run [regexp]` option for selecting a subset of tests. Furthermore, programming languages have built-in support for third-party libraries for regular expression matching, so you can use regexes for functionality such as pattern matching, validation, and parsing.

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
- `\b` matches any word _boundary_ (e.g., in the string "missing semester", matches just before the "m", just after the "g", just before the "s", and just after the "r")
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

## Limitations

[Regular languages](https://en.wikipedia.org/wiki/Regular_language) are powerful but limited; there are classes of strings that cannot be expressed as a standard regex (e.g., it is [not possible](https://en.wikipedia.org/wiki/Pumping_lemma_for_regular_languages) to write a regular expression that matches the set of strings {a^n b^n \| n &ge; 0}, the set of strings of a number of "a"s followed by the same number of "b"s; more practically, languages like HTML are not regular languages). In practice, modern regex engines support features like lookahead and backreferences that extend support beyond regular languages, and they are practically extremely useful, but it is important to know that they are still limited in their expressive power. For more sophisticated languages, you might need to reach for a more capable type of parser (for one example, see [pyparsing](https://github.com/pyparsing/pyparsing), a [PEG](https://en.wikipedia.org/wiki/Parsing_expression_grammar) parser).

## Learning regex

We recommend learning the fundamentals (what we have covered in this lecture), and then looking at regex references as you need them, rather than memorizing the entirety of the language.

Conversational AI tools can be effective at helping you generating regex patterns. For example, try prompting your favorite LLM with the following query:

```
Write a Python-style regex pattern that matches the requested path from log lines from Nginx. Here is an example log line:

169.254.1.1 - - [09/Jan/2026:21:28:51 +0000] "GET /feed.xml HTTP/2.0" 200 2995 "-" "python-requests/2.32.3"
```

# Q&A

{% comment %}
lecturer: everyone
{% endcomment %}

In the second half, we will cover student questions. Please submit your questions in advance of the lecture:

**<https://forms.gle/4jnhiok72KQUD3Tn7>**

See [here](/2020/qa/) for the Q&A from the previous offering of this course.

# Exercises

1. Practice regex search-and-replace by replacing the `-` [Markdown bullet markers](https://spec.commonmark.org/0.31.2/#bullet-list-marker) with `*` bullet markers in the [lecture notes for today](https://raw.githubusercontent.com/missing-semester/missing-semester/refs/heads/master/_2026/development-environment.md). Note that just replacing all the "-" characters in the file would be incorrect, as there are many uses of that character that are not bullet markers.
1. Write a regex to capture from JSON structures of the form `{"name": "Alyssa P. Hacker", "college": "MIT"}` the name (e.g., `Alyssa P. Hacker`, in this example). Hint: in your first attempt, you might end up writing a regex that extracts `Alyssa P. Hacker", "college": "MIT`; read about greedy quantifiers in the [Python regex docs](https://docs.python.org/3/library/re.html) to figure out how to fix it.
