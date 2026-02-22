---
layout: lecture
title: "ಆವೃತ್ತಿ ನಿಯಂತ್ರಣ ಮತ್ತು Git"
description: >
  Git ನ data model ಅನ್ನು ತಿಳಿದುಕೊಂಡು, version control ಮತ್ತು collaboration ಗಾಗಿ Git ಅನ್ನು ಬಳಸುವ ವಿಧಾನವನ್ನು ಕಲಿಯಿರಿ.
thumbnail: /static/assets/thumbnails/2026/lec5.png
date: 2026-01-16
ready: true
video:
  aspect: 56.25
  id: 9K8lB61dl3Y
---

Version control systems (VCSs) ಎಂದರೆ source code
(ಅಥವಾ files ಮತ್ತು folders ಗಳ ಇತರ ಸಂಗ್ರಹಗಳು) ಗಳಲ್ಲಿನ ಬದಲಾವಣೆಗಳನ್ನು ಹಾದುಹೋಗುವಂತೆ ಟ್ರ್ಯಾಕ್ ಮಾಡಲು ಬಳಸುವ ಉಪಕರಣಗಳು. ಹೆಸರೇ ಸೂಚಿಸುವಂತೆ, ಈ ಉಪಕರಣಗಳು
ಬದಲಾವಣೆಗಳ ಇತಿಹಾಸವನ್ನು ನಿರ್ವಹಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತವೆ; ಇನ್ನೂ ಮುಂದೆ, ಅವು collaboration ನ್ನೂ ಸುಗಮಗೊಳಿಸುತ್ತವೆ.
ತಾರ್ಕಿಕವಾಗಿ ನೋಡಿದರೆ, VCSs ಒಂದು folder ಹಾಗೂ ಅದರ ಒಳಪರಿವಿಡಿಯನ್ನು
_snapshots_ ಗಳ ಸರಣಿಯಾಗಿ ಟ್ರ್ಯಾಕ್ ಮಾಡುತ್ತವೆ; ಇಲ್ಲಿ ಪ್ರತಿಯೊಂದು snapshot, top-level directory ಒಳಗಿನ files/folders ಗಳ ಸಂಪೂರ್ಣ ಸ್ಥಿತಿಯನ್ನು ಒಳಗೊಂಡಿರುತ್ತದೆ. VCSs ಪ್ರತಿಯೊಂದು
snapshot ಅನ್ನು ಯಾರು ಸೃಷ್ಟಿಸಿದರು, snapshot ಗೆ ಸಂಬಂಧಿಸಿದ ಸಂದೇಶಗಳು, ಇತ್ಯಾದಿ metadata ಯನ್ನೂ ನಿರ್ವಹಿಸುತ್ತವೆ.

Version control ಯಾಕೆ ಉಪಯುಕ್ತ? ನೀವು ಒಬ್ಬರೇ ಕೆಲಸ ಮಾಡುತ್ತಿದ್ದರೂ ಸಹ, ಇದು ಯೋಜನೆಯ ಹಳೆಯ snapshots ಗಳನ್ನು ನೋಡಲು, ನಿರ್ದಿಷ್ಟ ಬದಲಾವಣೆಗಳನ್ನು ಏಕೆ ಮಾಡಲಾಯಿತು ಎಂಬ ಲಾಗ್ ಅನ್ನು ಉಳಿಸಲು,
ಅಭಿವೃದ್ಧಿಯ ಸಮಾಂತರ branches ಗಳಲ್ಲಿ ಕೆಲಸ ಮಾಡಲು ಮತ್ತು ಇನ್ನೂ ಅನೇಕ ಕಾರ್ಯಗಳಿಗೆ ನೆರವಾಗುತ್ತದೆ. ಇತರರೊಂದಿಗೆ ಕೆಲಸ ಮಾಡುವಾಗ, ಇದು ಇತರರು ಏನು ಬದಲಾಯಿಸಿದ್ದಾರೆ ಎಂಬುದನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಲು,
ಹಾಗೂ concurrent development ನಲ್ಲಿ ಉಂಟಾಗುವ conflicts ಗಳನ್ನು ಪರಿಹರಿಸಲು ಅಮೂಲ್ಯವಾದ ಸಾಧನವಾಗುತ್ತದೆ.

ಆಧುನಿಕ VCSsಗಳು ಈ ರೀತಿಯ ಪ್ರಶ್ನೆಗಳಿಗೆ ಸುಲಭವಾಗಿ (ಮತ್ತು ಬಹುಶಃ ಸ್ವಯಂಚಾಲಿತವಾಗಿ) ಉತ್ತರಿಸಲು ಸಹ ಅವಕಾಶ ಮಾಡಿಕೊಡುತ್ತವೆ:

- ಈ module ಅನ್ನು ಯಾರು ಬರೆದರು?
- ಈ ನಿರ್ದಿಷ್ಟ file ನ ಈ ನಿರ್ದಿಷ್ಟ line ಅನ್ನು ಯಾವಾಗ ಸಂಪಾದಿಸಲಾಯಿತು? ಯಾರೆಂದರು? ಏಕೆ
  ಸಂಪಾದಿಸಲಾಯಿತು?
- ಕಳೆದ 1000 revisions ಗಳಲ್ಲಿ, ನಿರ್ದಿಷ್ಟ unit test ಯಾವಾಗ/ಏಕೆ ಕೆಲಸ ಮಾಡುವುದು ನಿಂತಿತು?

ಇತರೆ VCSs ಇದ್ದರೂ ಸಹ, version control ಗಾಗಿ **Git** de facto standard ಆಗಿದೆ.
ಈ [XKCD comic](https://xkcd.com/1597/) Git ನ ಖ್ಯಾತಿಯನ್ನು ಚೆನ್ನಾಗಿ ಹಿಡಿದಿಡುತ್ತದೆ:

![xkcd 1597](https://imgs.xkcd.com/comics/git.png)

Git ನ interface ಒಂದು leaky abstraction ಆಗಿರುವುದರಿಂದ, Git ಅನ್ನು top-down ರೀತಿಯಲ್ಲಿ ಕಲಿಯುವುದು (ಅಂದರೆ ಅದರ interface / command-line interface ರಿಂದ ಪ್ರಾರಂಭಿಸುವುದು)
ಸಾಕಷ್ಟು ಗೊಂದಲಕ್ಕೆ ಕಾರಣವಾಗಬಹುದು. ಕೆಲವು commands ಗಳನ್ನು ಕೇವಲ ಮನಪಾಠ ಮಾಡಿಕೊಂಡು ಅವನ್ನು magic
incantations ಎಂದು ಭಾವಿಸಿ, ಏನಾದರೂ ತಪ್ಪಾದಾಗ ಮೇಲಿನ comic ನಲ್ಲಿರುವ ವಿಧಾನವನ್ನೇ ಅನುಸರಿಸುವ ಸಾಧ್ಯತೆಯಿದೆ.

Git ನ interface ಆಕರ್ಷಕವಲ್ಲ ಎಂಬುದು ಸತ್ಯವಾದರೂ, ಅದರ ಒಳಗಿನ design ಮತ್ತು ಕಲ್ಪನೆಗಳು ಅತ್ಯಂತ ಸುಂದರವಾಗಿವೆ. ಅಂದರೆ, ಅಸ್ವಚ್ಛ interface ಅನ್ನು _memorize_ ಮಾಡಬೇಕಾಗುತ್ತದೆ, ಆದರೆ ಉತ್ತಮ design ಅನ್ನು _understand_ ಮಾಡಬಹುದು.
ಈ ಕಾರಣಕ್ಕಾಗಿ, ನಾವು Git ನ ವಿವರಣೆಯನ್ನು bottom-up ರೀತಿಯಲ್ಲಿ ನೀಡುತ್ತೇವೆ - ಮೊದಲು ಅದರ data model, ನಂತರ command-line interface.
ಒಮ್ಮೆ data model ಅರ್ಥವಾದ ನಂತರ, commands ಗಳು ಒಳಗಿನ data model ಅನ್ನು ಹೇಗೆ ಪ್ರಭಾವಿಸುತ್ತವೆ ಎಂಬ ದೃಷ್ಟಿಯಿಂದ ಇನ್ನೂ ಸ್ಪಷ್ಟವಾಗಿ ಅರ್ಥವಾಗುತ್ತವೆ.

# Git ನ data model

Git ನ ಮೇಧಾವಿತ್ವವು ಅದರ ಸುಸಂರಚಿತ data model ನಲ್ಲಿ ಇದೆ; ಇದೇ version control ನ ಅನೇಕ ಉಪಯುಕ್ತ ಲಕ್ಷಣಗಳನ್ನು - ಉದಾಹರಣೆಗೆ history ನಿರ್ವಹಣೆ, branches ಬೆಂಬಲ, ಮತ್ತು collaboration - ಸಾಧ್ಯಗೊಳಿಸುತ್ತದೆ.

## Snapshot ಗಳು

Git, ನಿರ್ದಿಷ್ಟ top-level directory ಒಳಗಿನ files ಮತ್ತು folders ಗಳ ಇತಿಹಾಸವನ್ನು snapshots ಗಳ ಸರಣಿಯಾಗಿ ಮಾದರೀಕರಿಸುತ್ತದೆ. Git ಪದಪ್ರಯೋಗದಲ್ಲಿ file ಅನ್ನು
"blob" ಎಂದು ಕರೆಯುತ್ತಾರೆ; ಅದು bytes ಗಳ ಸಮೂಹ ಮಾತ್ರ. directory ಅನ್ನು "tree" ಎಂದು ಕರೆಯುತ್ತಾರೆ; ಅದು ಹೆಸರುಗಳನ್ನು blobs ಅಥವಾ trees ಗಳಿಗೆ ನಕ್ಷೆಗೊಳಿಸುತ್ತದೆ (ಅಂದರೆ directories ಒಳಗೆ ಇತರ directories ಇರಬಹುದು). snapshot ಎಂದರೆ ಟ್ರ್ಯಾಕ್ ಮಾಡಲಾಗುತ್ತಿರುವ top-level tree.
ಉದಾಹರಣೆಗೆ, ನಮ್ಮಲ್ಲಿ ಈ ಕೆಳಗಿನ tree ಇರಬಹುದು:

```
<root> (tree)
|
+- foo (tree)
|  |
|  + bar.txt (blob, contents = "hello world")
|
+- baz.txt (blob, contents = "git is wonderful")
```

ಈ top-level tree ಯಲ್ಲಿ ಎರಡು ಅಂಶಗಳಿವೆ: "foo" ಎಂಬ tree (ಅದರೊಳಗೆ ಒಂದು ಅಂಶವಾದ "bar.txt" blob ಇದೆ), ಮತ್ತು "baz.txt" blob.

## History ಮಾದರೀಕರಣ: snapshots ಗಳ ಸಂಬಂಧ

ಒಂದು version control system snapshots ಗಳನ್ನು ಹೇಗೆ ಪರಸ್ಪರ ಸಂಬಂಧಿಸಬೇಕು? ಒಂದು ಸರಳ ಮಾದರಿ ಎಂದರೆ linear history ಇರುವುದು. history ಎಂದರೆ ಕಾಲಕ್ರಮದಲ್ಲಿ ಸರಿದಟ್ಟಲಾದ snapshots ಗಳ ಪಟ್ಟಿಯಾಗಿರಬಹುದು.
ಅನೇಕ ಕಾರಣಗಳಿಂದ Git ಇಂತಹ ಸರಳ ಮಾದರಿಯನ್ನು ಬಳಸುವುದಿಲ್ಲ.

Git ನಲ್ಲಿ history ಎಂದರೆ snapshots ಗಳ directed acyclic graph (DAG).
ಇದು ಅತಿಯಾಗಿ ಗಣಿತಪದದಂತೆ ಕೇಳಿಸಬಹುದು, ಆದರೆ ಭಯಪಡುವ ಅಗತ್ಯವಿಲ್ಲ. ಇದರ ಅರ್ಥ, Git ನಲ್ಲಿನ ಪ್ರತಿಯೊಂದು snapshot ತನ್ನಿಗಿಂತ ಮುಂಚೆ ಬಂದ snapshots ಗಳಾದ "parents" ಗಳ ಗುಂಪನ್ನು ಸೂಚಿಸುತ್ತದೆ.
ಇದು single parent ಅಲ್ಲ, parents ಗಳ set ಆಗಿರುವುದು (linear history ಯಲ್ಲಿ single parent ಇರುತ್ತದೆ) ಏಕೆಂದರೆ ಒಂದು snapshot ಬಹು parents ಗಳಿಂದ ಇಳಿಯಿರಬಹುದು - ಉದಾಹರಣೆಗೆ ಅಭಿವೃದ್ಧಿಯ ಎರಡು ಸಮಾಂತರ branches ಗಳನ್ನು ಸೇರಿಸುವ (merging) ಸಂದರ್ಭದಲ್ಲಿ.

Git ಈ snapshots ಗಳನ್ನು "commit" ಗಳು ಎಂದು ಕರೆಯುತ್ತದೆ. commit history ಯನ್ನು ದೃಶ್ಯೀಕರಿಸಿದರೆ ಇದು ಹೀಗಿರಬಹುದು:

```
o <-- o <-- o <-- o
            ^
             \
              --- o <-- o
```

ಮೇಲಿನ ASCII art ನಲ್ಲಿ `o` ಗಳು ಪ್ರತ್ಯೇಕ commits (snapshots) ಗಳಿಗೆ ಹೊಂದುತ್ತವೆ.
ಬಾಣಗಳು ಪ್ರತಿಯೊಂದು commit ನ parent ಕಡೆ ತೋರಿಸುತ್ತವೆ (ಇದು "comes before" ಸಂಬಂಧ, "comes after" ಅಲ್ಲ). ಮೂರನೇ commit ನಂತರ history ಎರಡು ಪ್ರತ್ಯೇಕ branches ಗಳಾಗಿ ವಿಭಜಿತವಾಗುತ್ತದೆ.
ಇದು ಉದಾಹರಣೆಗೆ ಪರಸ್ಪರ ಸ್ವತಂತ್ರವಾಗಿ ಸಮಾಂತರವಾಗಿ ಅಭಿವೃದ್ಧಿಪಡಿಸಲಾಗುತ್ತಿರುವ ಎರಡು features ಗಳಿಗೆ ತಕ್ಕಂತೆ ಇರಬಹುದು. ಭವಿಷ್ಯದಲ್ಲಿ ಈ branches ಗಳನ್ನು merge ಮಾಡಿ ಎರಡೂ features ಒಳಗೊಂಡ ಹೊಸ snapshot ರಚಿಸಬಹುದು; ಆಗ history ಈ ಕೆಳಗಿನಂತಾಗುತ್ತದೆ, ಇಲ್ಲಿ ಹೊಸ merge commit ಅನ್ನು bold ನಲ್ಲಿ ತೋರಿಸಲಾಗಿದೆ:

<pre class="highlight">
<code>
o <-- o <-- o <-- o <---- <strong>o</strong>
            ^            /
             \          v
              --- o <-- o
</code>
</pre>

Git ನಲ್ಲಿನ commits immutable. ಇದರಿಂದ ತಪ್ಪುಗಳನ್ನು ಸರಿಪಡಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ ಎಂಬ ಅರ್ಥವಲ್ಲ; commit history ಗೆ ಮಾಡುವ "edits" ಎಂದರೆ ವಾಸ್ತವವಾಗಿ ಸಂಪೂರ್ಣ ಹೊಸ commits ರಚಿಸುವುದು, ಮತ್ತು references (ಕೆಳಗೆ ನೋಡಿ) ಗಳನ್ನು ಹೊಸ commits ಕಡೆ ತೋರಿಸುವಂತೆ ಅಪ್ಡೇಟ್ ಮಾಡುವುದು.

## Pseudocode ರೂಪದಲ್ಲಿನ data model

Git ನ data model ಅನ್ನು pseudocode ರೂಪದಲ್ಲಿ ನೋಡಿದರೆ ಉಪಯುಕ್ತವಾಗಬಹುದು:

```
// a file is a bunch of bytes
type blob = array<byte>

// a directory contains named files and directories
type tree = map<string, tree | blob>

// a commit has parents, metadata, and the top-level tree
type commit = struct {
    parents: array<commit>
    author: string
    message: string
    snapshot: tree
}
```

ಇದು history ಯ ಸ್ವಚ್ಛ ಮತ್ತು ಸರಳ ಮಾದರಿ.

## Objects ಮತ್ತು content-addressing

"object" ಎಂದರೆ blob, tree, ಅಥವಾ commit:

```
type object = blob | tree | commit
```

Git ನ data store ನಲ್ಲಿ ಎಲ್ಲಾ objects ಗಳಿಗೂ ಅವುಗಳ [SHA-1
hash](https://en.wikipedia.org/wiki/SHA-1) ಆಧಾರಿತ content-addressing ಮಾಡಲಾಗುತ್ತದೆ.

```
objects = map<string, object>

def store(object):
    id = sha1(object)
    objects[id] = object

def load(id):
    return objects[id]
```

Blobs, trees, ಮತ್ತು commits ಗಳನ್ನು ಈ ರೀತಿಯಲ್ಲಿ ಏಕೀಕರಿಸಲಾಗಿದೆ: ಅವೆಲ್ಲವೂ objects.
ಅವು ಇತರ objects ಗಳನ್ನು ಸೂಚಿಸುವಾಗ, on-disk representation ನಲ್ಲಿ ಅವನ್ನು ನೇರವಾಗಿ _contain_ ಮಾಡುವುದಿಲ್ಲ; ಬದಲಾಗಿ ಅವುಗಳ hash ಮೂಲಕ reference ಇರುತ್ತದೆ.

ಉದಾಹರಣೆಗೆ, ಮೇಲಿನ [example directory structure](#snapshots) ಗೆ ಹೊಂದುವ tree
(`git cat-file -p 698281bc680d1995c5f4caaf3359721a5a58d48d` ಬಳಸಿ ದೃಶ್ಯೀಕರಿಸಿದರೆ),
ಇಂತಿದೆ:

```
100644 blob 4448adbf7ecd394f42ae135bbeed9676e894af85    baz.txt
040000 tree c68d233a33c5c06e0340e4c224f0afca87c8ce87    foo
```

tree ಸ್ವತಃ ತನ್ನ ಒಳಪರಿವಿಡಿಗಳಿಗೆ pointers ಇಟ್ಟುಕೊಂಡಿದೆ: `baz.txt` (ಒಂದು blob) ಮತ್ತು `foo`
(ಒಂದು tree). `git cat-file -p 4448adbf7ecd394f42ae135bbeed9676e894af85` ಮೂಲಕ baz.txt ಗೆ ಹೊಂದುವ hash ನ content ನೋಡಿದರೆ, ನಮಗೆ ಈ ಕೆಳಗಿನದು ಸಿಗುತ್ತದೆ:

```
git is wonderful
```

## References (ಉಲ್ಲೇಖಗಳು)

ಈಗ ಎಲ್ಲ snapshots ಗಳನ್ನೂ ಅವುಗಳ SHA-1 hashes ಮೂಲಕ ಗುರುತಿಸಬಹುದು. ಆದರೆ ಇದು ಅಸೌಕರ್ಯಕರ, ಏಕೆಂದರೆ ಮಾನವರು 40 hexadecimal ಅಕ್ಷರಗಳ ಸರಣಿಯನ್ನು ಸುಲಭವಾಗಿ ನೆನಪಿಡಲಾಗುವುದಿಲ್ಲ.

ಈ ಸಮಸ್ಯೆಗೆ Git ನೀಡುವ ಪರಿಹಾರ SHA-1 hashes ಗಳಿಗೆ human-readable ಹೆಸರುಗಳು - ಅವನ್ನು
"references" ಎಂದು ಕರೆಯುತ್ತಾರೆ. References ಗಳು commits ಗೆ pointers.
immutable ಆಗಿರುವ objects ಗೆ ವಿರುದ್ಧವಾಗಿ references mutable (ಹೊಸ commit ಕಡೆ point ಮಾಡುವಂತೆ ಅಪ್ಡೇಟ್ ಮಾಡಬಹುದು). ಉದಾಹರಣೆಗೆ, `master` reference ಸಾಮಾನ್ಯವಾಗಿ ಮುಖ್ಯ development branch ನ ಇತ್ತೀಚಿನ commit ಕಡೆ ತೋರಿಸುತ್ತದೆ.

```
references = map<string, string>

def update_reference(name, id):
    references[name] = id

def read_reference(name):
    return references[name]

def load_reference(name_or_id):
    if name_or_id in references:
        return load(references[name_or_id])
    else:
        return load(name_or_id)
```

ಈ ಮೂಲಕ, Git ಉದ್ದವಾದ hexadecimal string ಬದಲು "master" ಹಾಗಿನ human-readable ಹೆಸರುಗಳನ್ನು ಬಳಸಿ history ಯಲ್ಲಿನ ನಿರ್ದಿಷ್ಟ snapshot ಅನ್ನು ಸೂಚಿಸಬಹುದು.

ಒಂದು ಸೂಕ್ಷ್ಮ ಅಂಶವೇನೆಂದರೆ, history ಯಲ್ಲಿ "ನಾವು ಈಗ ಎಲ್ಲಿದ್ದೇವೆ" ಎಂಬ ಕಲ್ಪನೆ ಬೇಕಾಗುತ್ತದೆ, ಏಕೆಂದರೆ ಹೊಸ snapshot ತೆಗೆದಾಗ ಅದು ಯಾವದಕ್ಕೆ ಸಂಬಂಧಿತ ಎಂಬುದು ತಿಳಿದಿರಬೇಕು
(commit ನ `parents` field ಹೇಗೆ ಸೆಟ್ ಮಾಡಬೇಕು ಎಂಬ ಅರ್ಥದಲ್ಲಿ). Git ನಲ್ಲಿ ಈ "ನಾವು ಈಗ ಎಲ್ಲಿದ್ದೇವೆ" ಎಂಬುದಕ್ಕೆ "HEAD" ಎಂಬ ವಿಶೇಷ reference ಇದೆ.

## Repositories (ಸಂಗ್ರಹಣೆಗಳು)

ಕೊನೆಯಲ್ಲಿ, Git _repository_ ಅನ್ನು (ಸರಳವಾಗಿ) ಹೀಗೆ ವ್ಯಾಖ್ಯಾನಿಸಬಹುದು: ಅದು
`objects` ಮತ್ತು `references` ಎಂಬ data.

ಡಿಸ್ಕ್ ಮೇಲೆ Git ಸಂಗ್ರಹಿಸುವುದೆಲ್ಲ objects ಮತ್ತು references ಮಾತ್ರ: Git ನ data model ಅಷ್ಟೇ. ಎಲ್ಲಾ `git` commands ಗಳು commit DAG ಮೇಲೆ ಯಾವುದೋ ಬದಲಾವಣೆಗೇ ನಕ್ಷೆಯಾಗುತ್ತವೆ - objects ಸೇರಿಸುವುದು ಮತ್ತು references ಸೇರಿಸುವುದು/ಅಪ್ಡೇಟ್ ಮಾಡುವುದು.

ನೀವು ಯಾವ command ಅನ್ನು ಟೈಪ್ ಮಾಡುತ್ತಿದ್ದರೂ, ಅದು underlying graph data structure ಮೇಲೆ ಯಾವ ರೀತಿಯ manipulation ಮಾಡುತ್ತಿದೆ ಎಂದು ಯೋಚಿಸಿ. ಅದೇ ರೀತಿಯಾಗಿ, commit DAG ನಲ್ಲಿ ನಿರ್ದಿಷ್ಟ ಬದಲಾವಣೆ ಮಾಡಲು ನೀವು ಯತ್ನಿಸುತ್ತಿದ್ದರೆ - ಉದಾಹರಣೆಗೆ "uncommitted changes ತಿರಸ್ಕರಿಸಿ 'master' ref ಅನ್ನು `5d83f9e` commit ಕಡೆ ತೋರಿಸುವಂತೆ ಮಾಡು" - ಅದಕ್ಕಾಗಿ command ಇದ್ದೇ ಇರುತ್ತದೆ (ಈ ಪ್ರಕರಣದಲ್ಲಿ `git checkout master; git reset
--hard 5d83f9e`).

# Staging area (ಸ್ಥಗಿತ ಪ್ರದೇಶ)

ಇದು data model ಗೆ orthogonal ಆಗಿರುವ ಮತ್ತೊಂದು ಕಲ್ಪನೆ, ಆದರೆ commits ರಚಿಸಲು ಬಳಸುವ interface ನ ಮಹತ್ವದ ಭಾಗವಾಗಿದೆ.

ಮೇಲೆ ವಿವರಿಸಿದ snapshotting ಅನ್ನು ಜಾರಿಗೆ ತರಲು ನೀವು ಕಲ್ಪಿಸಬಹುದಾದ ಒಂದು ವಿಧಾನ ಎಂದರೆ _current
state_ of the working directory ಆಧಾರದ ಮೇಲೆ ಹೊಸ snapshot ರಚಿಸುವ "create snapshot" command ಇರುವುದು. ಕೆಲವು version control tools ಹೀಗೆ ಕೆಲಸ ಮಾಡುತ್ತವೆ, ಆದರೆ Git ಹೀಗೆ ಅಲ್ಲ. ನಮಗೆ clean snapshots ಬೇಕು, ಮತ್ತು ಪ್ರಸ್ತುತ ಸ್ಥಿತಿಯಿಂದ snapshot ತೆಗೆದುದು ಯಾವಾಗಲೂ ಸೂಕ್ತವಾಗದೇ ಇರಬಹುದು. ಉದಾಹರಣೆಗೆ, ನೀವು ಎರಡು ಪ್ರತ್ಯೇಕ features ಜಾರಿಗೆ ತಂದಿದ್ದೀರಿ, ಆದರೆ ಎರಡು ಪ್ರತ್ಯೇಕ commits ರಚಿಸಲು ಬಯಸುತ್ತೀರಿ - ಮೊದಲ commit ಮೊದಲ feature ಅನ್ನು, ಮುಂದಿನ commit ಎರಡನೇ feature ಅನ್ನು ಪರಿಚಯಿಸುವಂತೆ. ಅಥವಾ ನೀವು bugfix ಜೊತೆಗೆ ಕೋಡ್ ತುಂಬೆಲ್ಲ debugging print statements ಸೇರಿಸಿದ್ದೀರಿ ಎಂದು ಕಲ್ಪಿಸಿ; ನೀವು print statements ಗಳನ್ನು ಬಿಟ್ಟು, bugfix ಮಾತ್ರ commit ಮಾಡಲು ಬಯಸಬಹುದು.

Git ಇಂತಹ ಸಂದರ್ಭಗಳಿಗೆ ಹೊಂದಿಕೊಳ್ಳಲು, "staging
area" ಎಂಬ ಯಾಂತ್ರಿಕತೆಯ ಮೂಲಕ ಮುಂದಿನ snapshot ನಲ್ಲಿ ಯಾವ modifications ಒಳಗೊಳ್ಳಬೇಕು ಎಂದು ನೀವು ಸ್ಪಷ್ಟವಾಗಿ ಸೂಚಿಸಲು ಅವಕಾಶ ನೀಡುತ್ತದೆ.

# Git command-line interface (ಆಜ್ಞಾ-ಸಾಲು ಅಂತರ್ಮುಖ)

ಮಾಹಿತಿಯ ಪುನರಾವರ್ತನೆ ತಪ್ಪಿಸಲು, ಕೆಳಗಿನ commands ಗಳನ್ನು ಈ lecture notes ನಲ್ಲಿ ನಾವು ವಿವರವಾಗಿ ವಿವರಿಸುವುದಿಲ್ಲ. ಹೆಚ್ಚಿನ ಮಾಹಿತಿಗಾಗಿ ಬಲವಾಗಿ ಶಿಫಾರಸು ಮಾಡಲ್ಪಟ್ಟ [Pro
Git](https://git-scm.com/book/en/v2) ನೋಡಿ, ಅಥವಾ lecture ವಿಡಿಯೋ ವೀಕ್ಷಿಸಿ.

## ಮೂಲಭೂತಾಂಶಗಳು

- `git help <command>`: git command ಒಂದಕ್ಕೆ ಸಹಾಯ ಪಡೆಯಿರಿ
- `git init`: ಹೊಸ git repo ರಚಿಸುತ್ತದೆ; data `.git` directory ಯಲ್ಲಿ ಸಂಗ್ರಹವಾಗುತ್ತದೆ
- `git status`: ಈಗ ಏನು ನಡೆಯುತ್ತಿದೆ ಎಂಬುದನ್ನು ತಿಳಿಸುತ್ತದೆ
- `git add <filename>`: files ಅನ್ನು staging area ಗೆ ಸೇರಿಸುತ್ತದೆ
- `git commit`: ಹೊಸ commit ರಚಿಸುತ್ತದೆ
    - [ಉತ್ತಮ commit messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) ಬರೆಯಿರಿ!
    - [ಉತ್ತಮ commit messages](https://chris.beams.io/posts/git-commit/) ಬರೆಯಲು ಇನ್ನೂ ಹೆಚ್ಚು ಕಾರಣಗಳು!
- `git log`: history ಯ flattened log ಅನ್ನು ತೋರಿಸುತ್ತದೆ
- `git log --all --graph --decorate`: history ಯನ್ನು DAG ರೂಪದಲ್ಲಿ ದೃಶ್ಯೀಕರಿಸುತ್ತದೆ
- `git diff <filename>`: staging area ಗೆ ಸಂಬಂಧಿಸಿದಂತೆ ನೀವು ಮಾಡಿದ ಬದಲಾವಣೆಗಳನ್ನು ತೋರಿಸುತ್ತದೆ
- `git diff <revision> <filename>`: snapshots ನಡುವೆ file ನ ವ್ಯತ್ಯಾಸಗಳನ್ನು ತೋರಿಸುತ್ತದೆ
- `git checkout <revision>`: HEAD ಅನ್ನು ಅಪ್ಡೇಟ್ ಮಾಡುತ್ತದೆ (branch checkout ಮಾಡಿದರೆ current branch ನ್ನೂ)

## Branching ಮತ್ತು merging

- `git branch`: branches ತೋರಿಸುತ್ತದೆ
- `git branch <name>`: branch ರಚಿಸುತ್ತದೆ
- `git switch <name>`: branch ಗೆ ಸ್ವಿಚ್ ಆಗುತ್ತದೆ
- `git checkout -b <name>`: branch ರಚಿಸಿ ಅದಕ್ಕೆ ಸ್ವಿಚ್ ಆಗುತ್ತದೆ
    - `git branch <name>; git switch <name>` ಗೆ ಸಮಾನ
- `git merge <revision>`: current branch ಗೆ merge ಮಾಡುತ್ತದೆ
- `git mergetool`: merge conflicts ಪರಿಹರಿಸಲು ಸಹಾಯಕವಾದ advanced tool ಬಳಸುತ್ತದೆ
- `git rebase`: patches ಗಳ ಸಮೂಹವನ್ನು ಹೊಸ base ಮೇಲೆ rebase ಮಾಡುತ್ತದೆ

## Remotes (ದೂರದ ಸಂಗ್ರಹಣೆಗಳು)

- `git remote`: remotes ಪಟ್ಟಿಮಾಡುತ್ತದೆ
- `git remote add <name> <url>`: remote ಸೇರಿಸುತ್ತದೆ
- `git push <remote> <local branch>:<remote branch>`: objects ಅನ್ನು remote ಗೆ ಕಳುಹಿಸಿ, remote reference ಅಪ್ಡೇಟ್ ಮಾಡುತ್ತದೆ
- `git branch --set-upstream-to=<remote>/<remote branch>`: local ಮತ್ತು remote branch ನಡುವಿನ ಹೊಂದಾಣಿಕೆ ಸೆಟ್ ಮಾಡುತ್ತದೆ
- `git fetch`: remote ನಿಂದ objects/references ಅನ್ನು ಪಡೆಯುತ್ತದೆ
- `git pull`: `git fetch; git merge` ಗೆ ಸಮಾನ
- `git clone`: remote ನಿಂದ repository ಡೌನ್‌ಲೋಡ್ ಮಾಡುತ್ತದೆ

## Undo (ಹಿಂತಿರುಗಿಸುವುದು)

- `git commit --amend`: commit ನ contents/message ಸಂಪಾದಿಸುತ್ತದೆ
- `git reset <file>`: file ಅನ್ನು unstage ಮಾಡುತ್ತದೆ
- `git restore`: ಬದಲಾವಣೆಗಳನ್ನು ತಿರಸ್ಕರಿಸುತ್ತದೆ

# ಉನ್ನತ Git

- `git config`: Git [ಅತ್ಯಂತ ಕಸ್ಟಮೈಸ್ ಮಾಡಬಹುದಾದ](https://git-scm.com/docs/git-config) ವ್ಯವಸ್ಥೆ
- `git clone --depth=1`: ಸಂಪೂರ್ಣ version history ಇಲ್ಲದೆ shallow clone
- `git add -p`: interactive staging
- `git rebase -i`: interactive rebasing
- `git blame`: ಕೊನೆಯಾಗಿ ಯಾವ line ಅನ್ನು ಯಾರು ಸಂಪಾದಿಸಿದ್ದಾರೆ ಎಂಬುದನ್ನು ತೋರಿಸುತ್ತದೆ
- `git stash`: working directory ಯಲ್ಲಿನ modifications ಅನ್ನು ತಾತ್ಕಾಲಿಕವಾಗಿ ತೆಗೆದುಹಾಕುತ್ತದೆ
- `git bisect`: history ಯಲ್ಲಿ binary search (ಉದಾ: regressions ಗಾಗಿ)
- `git revert`: ಹಿಂದಿನ commit ನ ಪರಿಣಾಮವನ್ನು ಹಿಂದಿರುಗಿಸುವ ಹೊಸ commit ರಚಿಸುತ್ತದೆ
- `git worktree`: ಒಂದೇ ಸಮಯದಲ್ಲಿ ಅನೇಕ branches checkout ಮಾಡುತ್ತದೆ
- `.gitignore`: ಉದ್ದೇಶಪೂರ್ವಕವಾಗಿ untracked ಆಗಿರುವ ಯಾವ files ಅನ್ನು ನಿರ್ಲಕ್ಷಿಸಬೇಕು ಎಂದು [ನಿರ್ದಿಷ್ಟಪಡಿಸಿ](https://git-scm.com/docs/gitignore)

# ಇತರೆ ವಿಷಯಗಳು

- **GUIs**: Git ಗಾಗಿ ಅನೇಕ [GUI clients](https://git-scm.com/downloads/guis)
ಲಭ್ಯವಿವೆ. ನಾವು ವೈಯಕ್ತಿಕವಾಗಿ ಅವನ್ನು ಬಳಸುವುದಿಲ್ಲ; ಬದಲಿಗೆ command-line
interface ನ್ನೇ ಬಳಸುತ್ತೇವೆ.
- **Shell integration**: ನಿಮ್ಮ shell prompt ನಲ್ಲಿ Git status ಕಾಣುವುದು ಬಹಳ ಉಪಯುಕ್ತ ([zsh](https://github.com/olivierverdier/zsh-git-prompt),
[bash](https://github.com/magicmonty/bash-git-prompt)). ಸಾಮಾನ್ಯವಾಗಿ [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) ತರದ frameworks ಗಳಲ್ಲಿ ಒಳಗೊಂಡಿರುತ್ತದೆ.
- **Editor integration**: ಮೇಲಿನಂತೆಯೇ, ಅನೇಕ ವೈಶಿಷ್ಟ್ಯಗಳೊಂದಿಗೆ ಸುಲಭ integrations ಲಭ್ಯ. Vim ಗಾಗಿ [fugitive.vim](https://github.com/tpope/vim-fugitive) ಮಾನದಂಡದ plugin.
- **Workflows**: ನಾವು ನಿಮಗೆ data model ಮತ್ತು ಕೆಲವು basic commands ಕಲಿಸಿದ್ದೇವೆ; ಆದರೆ ದೊಡ್ಡ projects ಮೇಲೆ ಕೆಲಸ ಮಾಡುವಾಗ ಯಾವ ಅಭ್ಯಾಸಗಳನ್ನು ಅನುಸರಿಸಬೇಕು ಎಂದು ಹೇಳಿಲ್ಲ (ಮತ್ತು [ಹಲವಾರು](https://nvie.com/posts/a-successful-git-branching-model/)
[ಬೇರೆ](https://www.endoflineblog.com/gitflow-considered-harmful)
[ವಿಧಾನಗಳು](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) ಇವೆ).
- **GitHub**: Git ಅಂದರೆ GitHub ಅಲ್ಲ. GitHub ನಲ್ಲಿ ಇತರ projects ಗೆ code ಕೊಡುಗೆ ನೀಡಲು [pull
requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) ಎಂಬ ನಿರ್ದಿಷ್ಟ ವಿಧಾನವಿದೆ.
- **Other Git providers**: GitHub ವಿಶಿಷ್ಟವಲ್ಲ: [GitLab](https://about.gitlab.com/) ಮತ್ತು
[BitBucket](https://bitbucket.org/) ಮುಂತಾದ ಅನೇಕ Git repository hosts ಇವೆ.

# ಸಂಪನ್ಮೂಲಗಳು

- [Pro Git](https://git-scm.com/book/en/v2) ಓದುವುದು **ಬಲವಾಗಿ ಶಿಫಾರಸು ಮಾಡಲಾಗಿದೆ**.
Chapters 1--5 ಓದಿದರೆ, ಈಗ ನೀವು data model ಅನ್ನು ಅರ್ಥಮಾಡಿಕೊಂಡಿರುವುದರಿಂದ, Git ಅನ್ನು ನಿಪುಣವಾಗಿ ಬಳಸಲು ಅಗತ್ಯವಿರುವ ಬಹುತೇಕ ವಿಷಯ ಕಲಿಯಬಹುದು. ನಂತರದ ಅಧ್ಯಾಯಗಳಲ್ಲಿ ಆಸಕ್ತಿದಾಯಕ advanced ವಿಷಯಗಳಿವೆ.
- [Oh Shit, Git!?!](https://ohshitgit.com/) ಕೆಲವು ಸಾಮಾನ್ಯ Git ತಪ್ಪುಗಳಿಂದ ಹೇಗೆ ಹೊರಬರಬೇಕು ಎಂಬುದರ ಚಿಕ್ಕ ಮಾರ್ಗದರ್ಶಿ.
- [Git for Computer
Scientists](https://eagain.net/articles/git-for-computer-scientists/) ಈ lecture notes ಗಿಂತ ಕಡಿಮೆ pseudocode ಮತ್ತು ಹೆಚ್ಚು ದೃಶ್ಯಾತ್ಮಕ diagrams ಗಳೊಂದಿಗೆ Git ನ data model ಗೆ ಚಿಕ್ಕ ವಿವರಣೆ ನೀಡುತ್ತದೆ.
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/)
data model ಕ್ಕಿಂತ ಮೀರಿ Git implementation ವಿವರಗಳನ್ನು ಕುತೂಹಲವುಳ್ಳವರಿಗಾಗಿ ಸವಿಸ್ತಾರವಾಗಿ ವಿವರಿಸುತ್ತದೆ.
- [How to explain git in simple
words](https://smusamashah.github.io/blog/2017/10/14/explain-git-in-simple-words)
- [Learn Git Branching](https://learngitbranching.js.org/) Git ಕಲಿಸುವ browser ಆಧಾರಿತ game.

# ಅಭ್ಯಾಸಗಳು

1. ನಿಮಗೆ Git ಬಗ್ಗೆ ಹಿಂದಿನ ಅನುಭವವಿಲ್ಲದಿದ್ದರೆ, [Pro Git](https://git-scm.com/book/en/v2) ನ ಮೊದಲ ಕೆಲವು ಅಧ್ಯಾಯಗಳನ್ನು ಓದಿ ಅಥವಾ [Learn Git Branching](https://learngitbranching.js.org/) ರೀತಿಯ tutorial ಪೂರ್ಣಗೊಳಿಸಿ. ನೀವು ಮುಂದುವರಿಯುವಂತೆ, Git commands ಗಳನ್ನು data model ಜೊತೆಗೆ ಸಂಬಂಧಿಸಿ ನೋಡಿ.
1. [ಕ್ಲಾಸ್ ವೆಬ್‌ಸೈಟ್ repository](https://github.com/missing-semester/missing-semester) ಅನ್ನು clone ಮಾಡಿ.
    1. version history ಅನ್ನು graph ರೂಪದಲ್ಲಿ ದೃಶ್ಯೀಕರಿಸಿ ಅನ್ವೇಷಿಸಿ.
    1. `README.md` ಅನ್ನು ಕೊನೆಯಾಗಿ ಪರಿಷ್ಕರಿಸಿದ ವ್ಯಕ್ತಿ ಯಾರು? (ಸುಳಿವು: `git log` ಅನ್ನು argument ಜೊತೆಗೆ ಬಳಸಿ).
    1. `_config.yml` ನ `collections:` line ಗೆ ಸಂಬಂಧಿಸಿದ ಕೊನೆಯ ಬದಲಾವಣೆಯ commit message ಏನು? (ಸುಳಿವು: `git blame` ಮತ್ತು `git
       show` ಬಳಸಿ).
1. Git ಕಲಿಯುವಾಗ ಸಾಮಾನ್ಯ ತಪ್ಪೊಂದೇನೆಂದರೆ Git ಮೂಲಕ ನಿರ್ವಹಿಸಬಾರದ ದೊಡ್ಡ files ಅನ್ನು commit ಮಾಡುವುದು ಅಥವಾ sensitive ಮಾಹಿತಿಯನ್ನು ಸೇರಿಸುವುದು. repository ಗೆ ಒಂದು file ಸೇರಿಸಿ, ಕೆಲವು commits ಮಾಡಿ, ನಂತರ ಆ file ಅನ್ನು _history_ ಯಿಂದ ಅಳಿಸಿ (ಇತ್ತೀಚಿನ commit ನಿಂದ ಮಾತ್ರವಲ್ಲ). ನೀವು
   [ಇದನ್ನು](https://help.github.com/articles/removing-sensitive-data-from-a-repository/) ನೋಡಬಹುದು.
1. GitHub ನಿಂದ ಯಾವುದಾದರೂ repository clone ಮಾಡಿ, ಅದರಲ್ಲಿನ ಇರುವ file ಒಂದನ್ನು ಪರಿಷ್ಕರಿಸಿ.
   `git stash` ಮಾಡಿದಾಗ ಏನಾಗುತ್ತದೆ? `git log
   --all --oneline` ಚಾಲನೆ ಮಾಡಿದಾಗ ಏನು ಕಾಣುತ್ತದೆ? `git stash` ಮೂಲಕ ಮಾಡಿದುದನ್ನು ಹಿಂತಿರುಗಿಸಲು `git stash pop` ಚಾಲನೆ ಮಾಡಿ.
   ಇದು ಯಾವ ಸಂದರ್ಭದಲ್ಲಿ ಉಪಯುಕ್ತವಾಗಬಹುದು?
1. ಅನೇಕ command line tools ಗಳಂತೆ, Git ಕೂಡ `~/.gitconfig` ಎಂಬ configuration file (ಅಥವಾ dotfile) ಒದಗಿಸುತ್ತದೆ. `~/.gitconfig` ನಲ್ಲಿ alias ರಚಿಸಿ, ನೀವು `git graph` ಓಡಿಸಿದಾಗ `git log --all --graph --decorate
   --oneline` ಔಟ್‌ಪುಟ್ ಸಿಗುವಂತೆ ಮಾಡಿ. ಇದನ್ನು ನೇರವಾಗಿ `~/.gitconfig` file ಅನ್ನು
   [editing](https://git-scm.com/docs/git-config#Documentation/git-config.txt-alias)
   ಮಾಡುವ ಮೂಲಕ ಅಥವಾ alias ಸೇರಿಸಲು `git config` command ಬಳಸಿ ಮಾಡಬಹುದು. git aliases ಬಗ್ಗೆ ಮಾಹಿತಿ
   [ಇಲ್ಲಿ](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases) ಲಭ್ಯ.
1. `git config --global core.excludesfile ~/.gitignore_global` ಚಾಲನೆ ಮಾಡಿದ ನಂತರ, `~/.gitignore_global` ನಲ್ಲಿ global ignore patterns ವ್ಯಾಖ್ಯಾನಿಸಬಹುದು. ಇದು Git ಬಳಸುವ global ignore file ನ ಸ್ಥಳವನ್ನು ಸೆಟ್ ಮಾಡುತ್ತದೆ, ಆದರೆ ಆ path ನಲ್ಲಿ file ಅನ್ನು ನೀವು ಕೈಯಾರೆ ರಚಿಸಬೇಕು. ನಿಮ್ಮ global gitignore file ಅನ್ನು `.DS_Store` ತರದ OS-specific ಅಥವಾ editor-specific temporary files ಅನ್ನು ignore ಮಾಡುವಂತೆ ಸಿದ್ಧಗೊಳಿಸಿ.
1. [ಕ್ಲಾಸ್ ವೆಬ್‌ಸೈಟ್ repository](https://github.com/missing-semester/missing-semester) ಅನ್ನು fork ಮಾಡಿ, typo ಅಥವಾ ಇತರ ಸುಧಾರಣೆ ಒಂದನ್ನು ಕಂಡುಹಿಡಿದು, GitHub ನಲ್ಲಿ pull request ಸಲ್ಲಿಸಿ
   (ನೀವು [ಇದನ್ನು](https://github.com/firstcontributions/first-contributions) ನೋಡಬಹುದು).
   ದಯವಿಟ್ಟು ಉಪಯುಕ್ತ PRs ಮಾತ್ರ ಸಲ್ಲಿಸಿ (ದಯವಿಟ್ಟು spam ಮಾಡಬೇಡಿ). ಸುಧಾರಣೆ ಕಂಡುಬರದಿದ್ದರೆ ಈ exercise ಅನ್ನು ಬಿಡಬಹುದು.
1. ಸಹಕಾರಾತ್ಮಕ ಪರಿಸ್ಥಿತಿಯನ್ನು ಅನುಕರಿಸಿ merge conflicts ಪರಿಹರಿಸುವ ಅಭ್ಯಾಸ ಮಾಡಿ:
    1. `git init` ಮೂಲಕ ಹೊಸ repository ರಚಿಸಿ ಮತ್ತು ಕೆಲವು lines ಹೊಂದಿರುವ `recipe.txt` file ರಚಿಸಿ (ಉದಾ: ಸರಳ recipe).
    1. ಅದನ್ನು commit ಮಾಡಿ, ನಂತರ ಎರಡು branches ರಚಿಸಿ: `git branch salty` ಮತ್ತು `git branch
       sweet`.
    1. `salty` branch ನಲ್ಲಿ ಒಂದು line ಪರಿಷ್ಕರಿಸಿ (ಉದಾ: "1 cup sugar" ಅನ್ನು "1
       cup salt" ಎಂದು ಬದಲಿಸಿ) ಮತ್ತು commit ಮಾಡಿ.
    1. `sweet` branch ನಲ್ಲಿ ಅದೇ line ಅನ್ನು ಬೇರೆ ರೀತಿಯಲ್ಲಿ ಪರಿಷ್ಕರಿಸಿ (ಉದಾ: "1
       cup sugar" ಅನ್ನು "2 cups sugar" ಎಂದು ಬದಲಿಸಿ) ಮತ್ತು commit ಮಾಡಿ.
    1. ಈಗ `master` ಗೆ switch ಆಗಿ `git merge salty`, ನಂತರ `git merge
       sweet` ಪ್ರಯತ್ನಿಸಿ. ಏನಾಗುತ್ತದೆ? `recipe.txt` ಯ ವಿಷಯವನ್ನು ನೋಡಿ -
       `<<<<<<<`, `=======`, ಮತ್ತು `>>>>>>>` markers ಗಳ ಅರ್ಥವೇನು?
    1. ನೀವು ಬಯಸುವ content ಉಳಿಯುವಂತೆ file ಸಂಪಾದಿಸಿ conflict ಪರಿಹರಿಸಿ,
       conflict markers ತೆಗೆದುಹಾಕಿ, ಮತ್ತು `git add`
       ಹಾಗೂ `git commit` (ಅಥವಾ `git merge --continue`) ಮೂಲಕ merge ಪೂರ್ಣಗೊಳಿಸಿ. ಪರ್ಯಾಯವಾಗಿ, graphical ಅಥವಾ terminal-based merge tool ಬಳಸಿಕೊಂಡು conflict ಪರಿಹರಿಸಲು `git mergetool` ಪ್ರಯತ್ನಿಸಿ.
    1. ನೀವು ಇಷ್ಟೇ ರಚಿಸಿದ merge history ಅನ್ನು ದೃಶ್ಯೀಕರಿಸಲು `git log --graph --oneline` ಬಳಸಿ.
