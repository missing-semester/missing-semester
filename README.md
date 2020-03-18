# The Missing Semester of Your CS Education

Website for the [The Missing Semester of Your CS Education](https://missing.csail.mit.edu/) class!

Contributions are most welcome! If you have edits or new content to add, please
open an issue or submit a pull request.

## Development

To build and view the site locally, run:

```bash
bundle exec jekyll serve -w
```


### The ebook
#### Build the ebook
##### Requirements
Requires the packages Pandoc and MarkdownPP:

```
pip install pandoc MarkdownPP
```

##### Generate the ebook
Go to folder **ebook** and type
```
markdown-pp skeleton.md > bundled.md ; pandoc -o the-missing-semester.epub metadata.yaml bundled.md --toc ;
open the-missing-semester.epub
```
#### Explanation

[Mardown-pp](https://github.com/jreese/markdown-pp) allows to bundle all articles in one file from the "architecture" defined in skeleton.md. 

[Pandoc](https://pandoc.org/) is a tool to convert a markdown file to another format (I used epub here, but you could also make it a PDF)

- I created a new folder "/ebook" where I made a copy of all articles and remove their metadata ( YAML front-matter)
- I also removed some Jekyll lines
- metadata.yaml contains the metadata of the ebook-to-be.

#### Roadmap
What can be improved : 
- Add a nice cover image ( in metadata.yaml, I guess)
- Correct authors (I didn't really know what to put)
- Generate ebook directly from original articles (the ones in _2020)

The process for the ebook was inspired by [this article](https://medium.com/@davidgrophland/making-an-ebook-from-markdown-to-kindle-cf224326b1a2).
## License

All the content in this course, including the website source code, lecture notes, exercises, and lecture videos is licensed under Attribution-NonCommercial-ShareAlike 4.0 International [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). See [here](https://missing.csail.mit.edu/license) for more information on contributions or translations.
