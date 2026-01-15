---
name: website-preview
description: Take screenshots and interact with the rendered Jekyll website
---

# Website Preview

Render the Jekyll site locally, take screenshots, and verify design changes visually using ChromeDriver and browser automation.

## When to use this skill

Use this skill when:
- Modifying CSS, SCSS, or any styling files
- Editing HTML layouts (`_layouts/`) or includes (`_includes/`)
- Making changes that affect visual appearance
- The user asks to see how changes look
- You need to verify a design change worked correctly
- Working on any front-end aspects of the website

**Invoke this skill proactively** after making visual changes to the site.

## How to use this skill

### Step 1: Check Prerequisites

Before taking screenshots, verify both Jekyll and ChromeDriver are running.

**Check Jekyll server:**
```bash
curl -s -o /dev/null -w "%{http_code}" http://localhost:4000/ 2>/dev/null || echo "not running"
```

If not running (not 200), start it in background:
```bash
bundle exec jekyll serve --host 0.0.0.0 &
```
Wait a few seconds for it to build.

**Check ChromeDriver:**
```bash
cat /tmp/chromedriver_port 2>/dev/null || echo "not running"
```

If not running, start it:
```bash
./browser.sh chromedriver
```

This finds Chrome automatically and starts ChromeDriver on a free port.

### Step 2: Take Screenshots

Use `./browser.sh` for browser automation:

```bash
./browser.sh start http://localhost:4000/
./browser.sh screenshot /tmp/preview.png

./browser.sh dark
./browser.sh screenshot /tmp/preview-dark.png

./browser.sh mobile
./browser.sh screenshot /tmp/preview-mobile-dark.png

./browser.sh light
./browser.sh screenshot /tmp/preview-mobile-light.png

./browser.sh desktop
./browser.sh nav http://localhost:4000/2026/course-shell/
./browser.sh screenshot /tmp/course-shell.png

./browser.sh stop
```

Mode commands (`dark`, `light`, `mobile`, `desktop`) persist until changed.

### Step 3: View Screenshots

After taking a screenshot, use the Read tool to view it:
```
Read /tmp/preview.png
```

### Inspecting Elements

Execute JavaScript to query the page:
```bash
./browser.sh js "document.querySelector('nav').getBoundingClientRect()"
```

### After Making Changes

After modifying CSS/HTML:
1. Jekyll will auto-rebuild (watch for "Regenerating:" in Jekyll output)
2. Refresh: `./browser.sh nav http://localhost:4000/`
3. Take a new screenshot to verify changes

### Common Pages to Check

- Homepage: `http://localhost:4000/`
- Current year index: `http://localhost:4000/2026/`
- Lecture page: `http://localhost:4000/2026/course-shell/`
- About page: `http://localhost:4000/about/`

### ChromeDriver Lifecycle

**Keep ChromeDriver running** across multiple previews during a session. Only kill it when no more browser interactions are expected.

- `./browser.sh stop` - Ends the browser session (optional between screenshots)
- `./browser.sh kill` - Stops ChromeDriver entirely (only when done with all design work)

You do not need to run `./browser.sh kill` after each preview. Start ChromeDriver once at the beginning and leave it running.

### Troubleshooting

**Jekyll not rebuilding:** Run `bundle exec jekyll build` manually

**ChromeDriver errors:** Kill and restart
```bash
./browser.sh kill
./browser.sh chromedriver
```

**Session errors:** Stop any existing session first
```bash
./browser.sh stop
```
