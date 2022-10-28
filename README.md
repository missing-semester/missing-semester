# The Missing Semester of Your CS Education

[![Build Status](https://github.com/missing-semester/missing-semester/workflows/Build/badge.svg)](https://github.com/missing-semester/missing-semester/actions?query=workflow%3ABuild) [![Links Status](https://github.com/missing-semester/missing-semester/workflows/Links/badge.svg)](https://github.com/missing-semester/missing-semester/actions?query=workflow%3ALinks)

Website for the [The Missing Semester of Your CS Education](https://missing.csail.mit.edu/) class!

Contributions are most welcome! If you have edits or new content to add, please
open an issue or submit a pull request.

## Development

To build and view the site locally, run:

```bash
bundle exec jekyll serve -w
```

If you'd prefer to develop the site in a Docker container (e.g., to avoid
having to install Ruby and dependencies on your host machine), run:


```bash
docker-compose up --build
```

Then, navigate to <http://localhost:4000> on your host machine to view the
website. Jekyll will re-build the website as you make changes to files.

## License

All the contents in this course, including the website source code, lecture notes, exercises, and lecture videos are licensed under Attribution-NonCommercial-ShareAlike 4.0 International [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). See [here](https://missing.csail.mit.edu/license) for more information on contributions or translations.
