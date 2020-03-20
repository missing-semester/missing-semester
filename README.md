# The Missing Semester of Your CS Education

Website for the [The Missing Semester of Your CS Education](https://missing.csail.mit.edu/) class!

Contributions are most welcome! If you have edits or new content to add, please
open an issue or submit a pull request.

## Development

To build and view the site locally, run:

```bash
bundle exec jekyll serve -w
```


### The ebook 📕
#### Build the ebook
##### Requirements
Requires the packages Pandoc and MarkdownPP:

```
pip install pandoc MarkdownPP
```

##### Generate the ebook
Go to folder **ebook** and run the bash script **makeBook** :
 
```
./makeBook
```
#### Explanation

[Mardown-pp](https://github.com/jreese/markdown-pp) allows to bundle all articles in one file from the "architecture" defined in skeleton.md. 

[Pandoc](https://pandoc.org/) is a tool to convert a markdown file to another format (I used epub here, but you could also make it a PDF)

**The folder "/ebook" contains copy of all articles where metadata (YAML front-matter) was removed, as well as some Jekyll syntax.**

What the `makeBook` script does : 
1. skeleton.md contains the structure of the ebook and specified which articles will be imported.
2. Markdown-pp performs the imports and outputs a file (bundled.md).
3. Pandoc converts the bundled.md file into a EPUB file, using metadata.yaml for filling the metadata (title, authors,...) of the EPUB. `--toc` creates a table of contents in the document.

More info for the metadata : https://pandoc.org/MANUAL.html#epub-metadata


#### Roadmap
What can be improved : 
- In metadata.yaml : 
    - Add a better cover image
    - Correct authors (I didn't really know what to put)
- Generate ebook directly from original articles (the ones in _2020). For now, changes in original articles are not transmitted to the ebook.

The process for the ebook was inspired by [this article](https://medium.com/@davidgrophland/making-an-ebook-from-markdown-to-kindle-cf224326b1a2).
## License

All the content in this course, including the website source code, lecture notes, exercises, and lecture videos is licensed under Attribution-NonCommercial-ShareAlike 4.0 International [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). See [here](https://missing.csail.mit.edu/license) for more information on contributions or translations.
