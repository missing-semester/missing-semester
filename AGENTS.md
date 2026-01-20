# AGENT.md

This file provides guidance to AI coding agents working with this repository. See [agents.md](https://agents.md/) for the specification.

## Project Overview

This is the website for **The Missing Semester of Your CS Education** (https://missing.csail.mit.edu/), an MIT class teaching practical computing tools. It's a Jekyll static site hosted on GitHub Pages.

## Build and Test Commands

**Local development:**
```bash
bundle exec jekyll serve -w
```
Then visit http://localhost:4000

**Docker alternative:**
```bash
docker-compose up --build
```

**Build only:**
```bash
bundle exec jekyll build
```

## Website Preview

When making visual changes (CSS, layouts, includes), use `browser.sh` for headless Chrome screenshots. See `.claude/skills/website-preview/SKILL.md` for detailed instructions (Claude Code: this is a skill you can invoke with `/website-preview`).

**Quick reference:**
```bash
./browser.sh chromedriver           # Start ChromeDriver (run once per session)
./browser.sh start http://localhost:4000/  # Open browser session
./browser.sh screenshot /tmp/preview.png   # Capture screenshot
./browser.sh dark                   # Enable dark mode
./browser.sh light                  # Enable light mode
./browser.sh mobile                 # Mobile viewport (375x812)
./browser.sh desktop                # Desktop viewport (1400x900)
./browser.sh nav <url>              # Navigate to URL
./browser.sh stop                   # End browser session
./browser.sh kill                   # Stop ChromeDriver
```

After taking a screenshot, read the file to view it.

## Architecture

**Content organization:**
- `_2019/`, `_2020/`, `_2026/` - Lecture content by year (Jekyll collections)
- Each lecture is a markdown file with YAML front matter (date, title, ready status, video links)

**Layouts and templates:**
- `_layouts/` - Page templates (default.html, lecture.html, page.html, redirect.html)
- `_includes/` - Reusable HTML partials (head.html, nav.html)

**Static assets:**
- `static/css/` - Stylesheets (main.css, syntax.css)
- `static/media/` - Videos and images
- `static/files/` - Downloadable resources

**Configuration:**
- `_config.yml` - Jekyll settings, collections, site URL
- Collections defined: 2019, 2020, 2026

## CI/CD

GitHub Actions workflows:
- `build.yml` - Builds Jekyll site on push/PR and weekly
- `links.yml` - Validates external links using proof-html

## License

CC BY-NC-SA 4.0 - content can be adapted with attribution for non-commercial use.
