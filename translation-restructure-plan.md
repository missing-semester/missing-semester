# Vietnamese Translation Project Restructure Plan
## Missing Semester Course - Analysis & Implementation Strategy

**Project:** missing-semester-vn.github.io
**Date:** January 20, 2026
**Author:** Claude Analysis

---

## Executive Summary

This document provides a comprehensive analysis and implementation plan for restructuring the Vietnamese translation of the MIT Missing Semester course. The current inline translation approach causes significant merge conflicts during upstream synchronization. The proposed solution uses language-specific directory separation to eliminate conflicts while maintaining the original aesthetic.

**Key Benefits:**
- ✅ Zero merge conflicts in Vietnamese content
- ✅ Clean upstream sync workflow
- ✅ Bilingual site with language switching
- ✅ Works with GitHub Pages (no build pipeline needed)
- ✅ Maintains identical aesthetic to upstream

---

## Part 1: Current State Analysis

### 1.1 Current Translation Approach

The project uses an **inline comment pattern** where:
- Vietnamese translation appears FIRST in markdown files
- Original English content is preserved as HTML comments (`<!-- -->`) below
- Example structure:
  ```markdown
  # Mục đích

  Vietnamese content here...

  <!--
  # Motivation

  Original English content here...
  -->
  ```

**Translation Guidelines (from CONTRIBUTING.md):**
- Vietnamese first, English becomes HTML comment
- Technical terms: Vietnamese translation + English in parentheses on first use
- Example: "version control systems (trình quản lý phiên bản)"

### 1.2 Repository Structure

```
missing-semester-vn.github.io/
├── _2019/          # 2019 lectures (English only, not translated)
├── _2020/          # 2020 lectures (PARTIALLY translated)
├── _2026/          # 2026 lectures (NEW, English only)
├── _config.yml     # Jekyll config (identical to upstream)
├── _layouts/       # Jekyll layouts
├── _includes/      # Jekyll includes
├── index.md        # Homepage (mixed Vietnamese + English)
├── about.md        # About page (Vietnamese)
└── static/         # Assets (CSS, JS, images)
```

**Translation Status:**
- **2020 lectures**: Partially translated (course-shell, shell-tools, editors, version-control, metaprogramming, debugging-profiling - various completion states)
- **2019 lectures**: Not translated (English only)
- **2026 lectures**: Recently synced from upstream (English only)

### 1.3 Current Jekyll Configuration

**Key Finding:** No i18n/localization plugins configured
- NO Jekyll Polyglot or similar i18n plugin
- NO language detection mechanisms
- NO separate locale directories
- Uses standard Jekyll collections for year-based organization
- Single monolithic site approach

**_config.yml:**
```yaml
title: 'Missing Semester'
url: https://missing.csail.mit.edu
markdown: kramdown
collections:
  '2019': {output: true}
  '2020': {output: true}
  '2026': {output: true}
```

### 1.4 Git Workflow & Upstream Sync

**Remote Setup:**
```
origin:   https://github.com/missing-semester-vn/missing-semester-vn.github.io.git
upstream: https://github.com/missing-semester/missing-semester.git
```

**Recent Sync Activity:**
- Latest sync: Jan 20, 2026 - "Merge remote-tracking branch 'upstream/master'"
- Brought in entire 2026 lecture series (8 new lectures, 3,000+ lines)
- Result: 86 files changed, 5,284 insertions, 372 deletions

**Current Sync Workflow:**
1. Manual merge from `upstream/master` into sync branch
2. MASSIVE conflicts because Vietnamese text is inline with English
3. Manual conflict resolution required for every file
4. No automation detected

### 1.5 Critical Problems Identified

**❌ Merge Conflict Hell:**
- Current approach causes conflicts on EVERY file during upstream sync
- Translators modify exact same lines that upstream modifies
- Cannot cleanly pull updates without manual conflict resolution

**❌ Maintenance Burden:**
- New content arrives untranslated (2026 lectures: 660+ lines)
- Must manually track translation progress
- HTML comments bloat file size (~2x original)
- No automated detection of what needs translation

**❌ User Experience Issues:**
- No mechanism to view English version
- No language switching functionality
- Mixed language content creates inconsistent UX
- Navigation doesn't indicate language

---

## Part 2: Jekyll i18n Best Practices Research

### 2.1 Available Approaches

**Option A: Polyglot Plugin**
- Most feature-rich Jekyll i18n plugin
- Automatic URL relativization and SEO optimization
- Fallback support for missing translations
- **Problem:** NOT compatible with GitHub Pages (requires custom plugins)
- **Verdict:** Rejected - requires build pipeline

**Option B: Plugin-Free Front Matter Approach** ⭐ RECOMMENDED
- Uses Jekyll's built-in features
- Parallel file structures: `_2020/en/` and `_2020/vi/`
- Front matter for language metadata
- Works with GitHub Pages out of the box
- **Verdict:** Selected - best balance of features and simplicity

**Option C: The Programming Historian Pattern**
- Hybrid approach with YAML data files for UI strings
- Complex custom Liquid logic
- **Verdict:** Rejected - too complex for this project

### 2.2 Upstream Sync Best Practices

**Key Recommendations:**
1. **Use merge over rebase** - prevents repeated conflicts
2. **Sync frequently** - regular small syncs vs massive updates
3. **Separate English and Vietnamese content** - different files/directories
4. **Use .gitattributes** - configure merge strategies per file pattern
5. **Automated sync workflow** - GitHub Actions for alerts

**Merge Strategy:**
```gitattributes
_2020/vi/*.md merge=ours
```
Tells Git to prefer "our" changes in Vietnamese files during merges.

---

## Part 3: Recommended Solution

### 3.1 Solution Overview: Plugin-Free Directory Separation

**Architecture:**
- Reorganize content into language-specific directories
- Use Jekyll collections for each year × language combination
- Language switcher component with fallback logic
- Maintain same layouts, CSS, and theme (aesthetic preserved)

**Directory Structure:**
```
_2019_en/           # English content (syncs from upstream)
_2019_vi/           # Vietnamese translations (stubs initially)
_2020_en/           # English content (syncs from upstream)
_2020_vi/           # Vietnamese translations (migrated from current)
_2026_en/           # English content (syncs from upstream)
_2026_vi/           # Vietnamese translations (stubs initially)
```

**URL Structure:**
- Vietnamese (default): `/2019/course-shell/`, `/2020/course-shell/`
- English: `/2019/en/course-shell/`, `/2020/en/course-shell/`

### 3.2 Key Design Decisions

**Decision 1: All Years Supported**
- 2019, 2020, and 2026 lectures all get both languages
- Partial translations handled gracefully

**Decision 2: English Fallback**
- When Vietnamese doesn't exist: link to English with notice
- Language switcher shows "Tiếng Việt (đang dịch)" as disabled state
- Translation notice: "⚠️ Bài giảng này chưa được dịch..."

**Decision 3: Vietnamese Default**
- Root URLs serve Vietnamese (matches current behavior)
- English at `/en/` subdirectory
- Homepage defaults to Vietnamese

---

## Part 4: Implementation Plan

### Phase 1: Project Structure Reorganization

#### 1.1 Update Jekyll Configuration

Modify `_config.yml` to add language-specific collections:

```yaml
collections:
  # 2019 lectures
  2019_en:
    output: true
    permalink: /2019/en/:name/
  2019_vi:
    output: true
    permalink: /2019/:name/

  # 2020 lectures
  2020_en:
    output: true
    permalink: /2020/en/:name/
  2020_vi:
    output: true
    permalink: /2020/:name/

  # 2026 lectures
  2026_en:
    output: true
    permalink: /2026/en/:name/
  2026_vi:
    output: true
    permalink: /2026/:name/

defaults:
  # Set language metadata automatically by directory
  - scope:
      path: "_2019_en"
      type: "2019_en"
    values:
      layout: "lecture"
      lang: "en"
  - scope:
      path: "_2019_vi"
      type: "2019_vi"
    values:
      layout: "lecture"
      lang: "vi"
  # ... repeat for 2020 and 2026
```

**Critical file:** `_config.yml`

#### 1.2 Create Directory Structure

Create six new directories:
- `_2019_en/`, `_2019_vi/`
- `_2020_en/`, `_2020_vi/`
- `_2026_en/`, `_2026_vi/`

#### 1.3 Extract and Split Translations

**For 2020 lectures (currently translated):**

For each file in `_2020/`:
1. **Extract English:** Copy to `_2020_en/`, remove HTML comments, keep only English
2. **Extract Vietnamese:** Copy to `_2020_vi/`, remove HTML comments, keep only Vietnamese
3. **Add front matter:** Link translations together:
   ```yaml
   ---
   layout: lecture
   title: "Course Overview + The Shell"
   lang: vi
   translation_id: course-shell  # Same ID for both languages
   ---
   ```

**Files to process:**
- `_2020/course-shell.md`
- `_2020/shell-tools.md`
- `_2020/editors.md`
- `_2020/version-control.md`
- `_2020/metaprogramming.md`
- All other files in `_2020/`

**For 2019 and 2026 lectures (not yet translated):**
- Copy files to `_2019_en/` and `_2026_en/` as-is
- Create stub files in `_2019_vi/` and `_2026_vi/` with `translation_status: stub`

---

### Phase 2: UI Components and Navigation

#### 2.1 Language Switcher Component

Create `_includes/language-switcher.html`:

```liquid
{% if page.translation_id %}
  {% comment %}Find the corresponding translation{% endcomment %}
  {% assign year = page.collection | replace: "_en", "" | replace: "_vi", "" %}
  {% assign en_collection = year | append: "_en" %}
  {% assign vi_collection = year | append: "_vi" %}

  {% assign en_doc = site[en_collection] | where: "translation_id", page.translation_id | first %}
  {% assign vi_doc = site[vi_collection] | where: "translation_id", page.translation_id | first %}

  <div class="language-switcher">
    {% if page.lang == "vi" %}
      {% comment %}On Vietnamese page, link to English{% endcomment %}
      {% if en_doc %}
        <a href="{{ en_doc.url | relative_url }}" class="lang-link">English</a>
      {% endif %}
    {% elsif page.lang == "en" %}
      {% comment %}On English page, link to Vietnamese if exists{% endcomment %}
      {% if vi_doc %}
        <a href="{{ vi_doc.url | relative_url }}" class="lang-link">Tiếng Việt</a>
      {% else %}
        <span class="lang-link-disabled" title="Bản dịch chưa sẵn sàng">
          Tiếng Việt (đang dịch)
        </span>
      {% endif %}
    {% endif %}
  </div>
{% endif %}
```

#### 2.2 Translation Notice Component

Create `_includes/translation-notice.html`:

```liquid
{% if page.lang == "vi" and page.translation_status == "stub" %}
  <div class="translation-notice">
    <p>⚠️ Bài giảng này chưa được dịch sang tiếng Việt.
    Bạn đang xem <a href="{{ page.url | replace: "/2019/", "/2019/en/" | replace: "/2026/", "/2026/en/" }}">bản tiếng Anh gốc</a>.</p>
  </div>
{% endif %}
```

#### 2.3 Update Layouts

Modify `_layouts/lecture.html` to include components:

```liquid
<header>
  {% include language-switcher.html %}
  <!-- existing header content -->
</header>

<main>
  {% include translation-notice.html %}
  {{ content }}
</main>
```

#### 2.4 UI Strings Data File

Create `_data/ui.yml` for translatable UI strings:

```yaml
en:
  lectures: "Lectures"
  about: "About"
  back_to_lectures: "Back to lectures"

vi:
  lectures: "Bài giảng"
  about: "Giới thiệu"
  back_to_lectures: "Quay lại bài giảng"
```

Update `_includes/nav.html` to use data file:

```liquid
{% assign ui = site.data.ui[page.lang] | default: site.data.ui.vi %}
<a href="/">{{ ui.lectures }}</a>
```

**Critical files:**
- `_layouts/lecture.html`
- `_layouts/default.html`
- `_includes/nav.html`
- `_includes/language-switcher.html` (new)
- `_includes/translation-notice.html` (new)

---

### Phase 3: Homepage and Static Pages

#### 3.1 Create Language-Specific Index Pages

- `index.md` → Default Vietnamese homepage (clean up existing content)
- `en/index.md` → English homepage (sync from upstream)

Add language toggle to homepage.

#### 3.2 Update Static Pages

- `about.md` → Vietnamese version
- `en/about.md` → English version

**Critical files:**
- `index.md`
- `about.md`

---

### Phase 4: Upstream Sync Workflow

#### 4.1 Create .gitattributes

Create `.gitattributes` to configure merge strategies:

```gitattributes
# Vietnamese translations: prefer our version during merge
_2019_vi/*.md merge=ours
_2020_vi/*.md merge=ours
_2026_vi/*.md merge=ours
_data/ui.yml merge=ours

# English content: can merge from upstream (use diff3 for better conflict markers)
_2019_en/*.md merge=diff3
_2020_en/*.md merge=diff3
_2026_en/*.md merge=diff3
```

#### 4.2 Create Sync Script

Create `scripts/sync-upstream.sh`:

```bash
#!/bin/bash
# Sync upstream changes to English content

echo "Fetching upstream..."
git fetch upstream

echo "Creating sync branch..."
BRANCH="sync-upstream-$(date +%Y-%m)"
git checkout -b "$BRANCH"

echo "Merging upstream/master..."
git merge upstream/master

# If conflicts in Vietnamese files, keep ours
if [ $? -ne 0 ]; then
  echo "Resolving conflicts in Vietnamese files..."
  git checkout --ours _2019_vi/**/*.md _2020_vi/**/*.md _2026_vi/**/*.md _data/ui.yml
  git add _2019_vi/ _2020_vi/ _2026_vi/ _data/ui.yml
fi

echo "Review changes to English content:"
echo "=== 2019 lectures ==="
git diff HEAD~1 -- _2019_en/
echo "=== 2020 lectures ==="
git diff HEAD~1 -- _2020_en/
echo "=== 2026 lectures ==="
git diff HEAD~1 -- _2026_en/

echo ""
echo "Sync branch created: $BRANCH"
echo "Review changes above, then:"
echo "  git push origin $BRANCH"
echo "  Create PR for review"
```

#### 4.3 Document Sync Workflow

Update README.md with new sync instructions:

1. Run `scripts/sync-upstream.sh`
2. Review changes to English content in diff output
3. Identify new/updated lectures needing translation
4. Create GitHub issues for translation tasks
5. Push sync branch and create PR for review

---

### Phase 5: Testing and Validation

#### 5.1 Local Testing Checklist

Before deploying:
- [ ] `bundle exec jekyll serve` runs without errors
- [ ] All 2020 lectures render in both languages
- [ ] Language switcher appears and works correctly
- [ ] Navigation links work in both languages
- [ ] Styles and aesthetic match upstream exactly
- [ ] Images and static assets load correctly
- [ ] Mobile responsive design maintained

#### 5.2 Content Verification

- [ ] Compare rendered Vietnamese pages with current live site
- [ ] Ensure no content lost during migration
- [ ] Verify translated content is complete
- [ ] Check that untranslated content falls back appropriately

#### 5.3 Upstream Sync Test

- [ ] Test merge from upstream on a sample file
- [ ] Verify no conflicts in `_2020_vi/` directory
- [ ] Verify English content updates cleanly in `_2020_en/`
- [ ] Test sync script end-to-end

---

## Part 5: Alternative Approaches (Rejected)

### Option A: Jekyll Polyglot Plugin
**Pros:**
- Most feature-rich solution
- Automatic URL handling and SEO optimization
- Fallback support built-in

**Cons:**
- NOT compatible with GitHub Pages
- Requires custom build pipeline (GitHub Actions, Netlify, etc.)
- Additional complexity

**Decision:** Rejected due to build complexity and GitHub Pages incompatibility

### Option B: Keep Current Inline Approach + Better Merge Strategy
**Pros:**
- No restructuring needed
- Minimal changes required

**Cons:**
- Still causes merge conflicts on every upstream change
- Cannot switch between languages
- Files remain bloated (2x size)
- Doesn't solve core problems

**Decision:** Rejected - doesn't address fundamental issues

### Option C: Separate Branch Strategy
**Pros:**
- Complete separation of languages
- Never any merge conflicts

**Cons:**
- Very complex to manage two diverging branches
- Hard to share layouts, assets, and theme
- Difficult to keep synchronized
- High operational overhead

**Decision:** Rejected - too much operational complexity

---

## Part 6: Migration Checklist

**Pre-Migration:**
- [ ] Backup current repository (create tag or branch)
- [ ] Announce migration to contributors

**Configuration:**
- [ ] Update `_config.yml` with new collections (2019, 2020, 2026 for both en and vi)
- [ ] Create `.gitattributes` with merge strategies

**Content Reorganization:**
- [ ] Create all six language-specific directories
- [ ] Extract and split 2020 translated files into `_2020_en/` and `_2020_vi/`
- [ ] Copy 2019 files to `_2019_en/` (keep as-is)
- [ ] Copy 2026 files to `_2026_en/` (recently synced)
- [ ] Create stub files in `_2019_vi/` and `_2026_vi/` with fallback

**UI Components:**
- [ ] Create language switcher component with fallback logic
- [ ] Create translation notice component
- [ ] Update `_layouts/lecture.html` to include components
- [ ] Update `_layouts/default.html` if needed
- [ ] Update `_includes/nav.html` to use UI strings

**Data & Scripts:**
- [ ] Create `_data/ui.yml` with bilingual UI strings
- [ ] Create `scripts/sync-upstream.sh` sync script
- [ ] Make sync script executable: `chmod +x scripts/sync-upstream.sh`

**Static Pages:**
- [ ] Create language-specific index pages (Vietnamese default, English at /en/)
- [ ] Create language-specific about pages

**Testing:**
- [ ] Test locally - all years, both languages
- [ ] Verify language switching works
- [ ] Check fallback behavior for untranslated content
- [ ] Test mobile responsive design

**Documentation:**
- [ ] Update README.md with new structure explanation
- [ ] Update CONTRIBUTING.md with new translation workflow
- [ ] Document sync workflow for maintainers

**Deployment:**
- [ ] Deploy to staging environment if available
- [ ] Verify live site functionality
- [ ] Monitor for any issues

**Cleanup:**
- [ ] Remove old `_2019/`, `_2020/`, `_2026/` directories
- [ ] Update any stale documentation
- [ ] Test upstream sync workflow with sample merge

**Post-Migration:**
- [ ] Announce completion to contributors
- [ ] Create issues for translating 2019 and 2026 content
- [ ] Update contributor guide with new workflow

---

## Part 7: Critical Files Summary

### Configuration Files
- `_config.yml` - Jekyll collections and defaults
- `.gitattributes` - Merge strategy configuration (NEW)

### Content Files (To Be Reorganized)
**2019 Lectures:**
- `_2019/*.md` → `_2019_en/*.md` + `_2019_vi/*.md` (stubs)

**2020 Lectures:**
- `_2020/*.md` → `_2020_en/*.md` + `_2020_vi/*.md` (translated)

**2026 Lectures:**
- `_2026/*.md` → `_2026_en/*.md` + `_2026_vi/*.md` (stubs)

**Static Pages:**
- `index.md` → `index.md` (Vietnamese default) + `en/index.md`
- `about.md` → `about.md` (Vietnamese) + `en/about.md`

### Layout & Include Files
- `_layouts/lecture.html` - Add language switcher and notice
- `_layouts/default.html` - Update if needed
- `_includes/nav.html` - Use UI data strings
- `_includes/language-switcher.html` - NEW
- `_includes/translation-notice.html` - NEW

### Data Files
- `_data/ui.yml` - Bilingual UI strings (NEW)

### Scripts
- `scripts/sync-upstream.sh` - Automated sync workflow (NEW)

---

## Part 8: Expected Outcomes

After successful implementation, the project will achieve:

### 1. Zero Merge Conflicts
Vietnamese content in `_2019_vi/`, `_2020_vi/`, `_2026_vi/` directories will never conflict with upstream changes. The `.gitattributes` configuration ensures Vietnamese files always keep "our" version during merges.

### 2. Clean Sync Workflow
Upstream changes only affect `_2019_en/`, `_2020_en/`, `_2026_en/` directories. Sync script automates:
- Fetching from upstream
- Creating dated sync branch
- Merging with automatic conflict resolution
- Showing diff of English changes
- Guiding next steps

### 3. Bilingual Site Functionality
Users can:
- Switch between English and Vietnamese on any lecture
- See translation progress (disabled state for untranslated)
- Fall back to English when Vietnamese doesn't exist
- Navigate consistently in either language

### 4. Maintained Aesthetic
Site will look identical to upstream:
- Same CSS and JavaScript
- Same layouts and theme
- Same responsive design
- Only difference: language switcher UI element

### 5. Easy Translation Workflow
Contributors can:
- Translate in `_2020_vi/` without touching English
- Work independently without conflicts
- See exactly what needs translation
- Follow clear contribution guidelines

### 6. Graceful Partial Translations
For lectures not yet translated (2019, 2026):
- Vietnamese URL redirects or shows notice
- Link to English version clearly displayed
- No broken pages or 404 errors
- Progressive translation supported

### 7. Clear Documentation
Updated docs will explain:
- New directory structure
- Translation workflow
- Upstream sync process
- How to contribute translations
- How to test locally

### 8. Automated Sync Process
Sync script (`scripts/sync-upstream.sh`) handles:
- 90% of sync work automatically
- Only English content needs review
- Clear output showing what changed
- Reduced time from hours to minutes

---

## Part 9: Risk Assessment & Mitigation

### Risk 1: Migration Errors
**Risk:** Content loss or corruption during file reorganization

**Mitigation:**
- Create full backup before starting
- Test migration on sample files first
- Use version control to track changes
- Validate content completeness before deletion

### Risk 2: Build Failures
**Risk:** Jekyll fails to build with new configuration

**Mitigation:**
- Test locally before deploying
- Validate YAML syntax in `_config.yml`
- Check Jekyll logs for errors
- Incremental testing (one year at a time)

### Risk 3: URL Changes Breaking Links
**Risk:** External links to site may break

**Mitigation:**
- Vietnamese URLs remain same (e.g., `/2020/course-shell/`)
- Only English gets new URLs (e.g., `/2020/en/course-shell/`)
- Consider redirects if needed
- Test all internal links

### Risk 4: Contributor Confusion
**Risk:** Contributors don't understand new structure

**Mitigation:**
- Update CONTRIBUTING.md with clear examples
- Create migration announcement with docs
- Provide example pull request
- Be available for questions

### Risk 5: Sync Script Bugs
**Risk:** Automated sync script makes mistakes

**Mitigation:**
- Test on dry-run branch first
- Always review changes before pushing
- Keep manual process documented as fallback
- Iterate on script based on real usage

---

## Part 10: Timeline & Effort Estimate

### Phase 1: Configuration & Setup (2-3 hours)
- Update `_config.yml`
- Create directory structure
- Create `.gitattributes`

### Phase 2: Content Migration (4-6 hours)
- Extract Vietnamese from 2020 lectures
- Extract English from 2020 lectures
- Copy 2019 and 2026 to English directories
- Add front matter to all files

### Phase 3: UI Components (2-3 hours)
- Build language switcher
- Build translation notice
- Update layouts
- Create UI strings data file

### Phase 4: Testing (2-3 hours)
- Local testing
- Content verification
- Link checking
- Cross-browser testing

### Phase 5: Documentation (1-2 hours)
- Update README
- Update CONTRIBUTING
- Write migration announcement

### Phase 6: Deployment (1 hour)
- Deploy to production
- Monitor for issues
- Cleanup old directories

**Total Estimated Effort:** 12-18 hours

**Recommended Approach:** Spread over 2-3 days to allow for careful testing and validation between phases.

---

## Part 11: Maintenance & Long-Term Benefits

### Ongoing Maintenance

**Monthly Upstream Sync:**
- Run `scripts/sync-upstream.sh`
- Review English changes (15-30 minutes)
- Create issues for new content to translate
- Minimal manual intervention required

**Translation Contributions:**
- Contributors work in isolated `_vi/` directories
- No conflicts between contributors
- Clear review process for maintainers

**Content Updates:**
- English updates from upstream: automatic
- Vietnamese updates from contributors: clean merges
- No cross-contamination

### Long-Term Benefits

**Scalability:**
- Easy to add more years (e.g., future 2027, 2028 lectures)
- Pattern established for any number of languages
- Structure scales without complexity increase

**Maintainability:**
- Separation of concerns (content vs. UI vs. layout)
- Easier debugging (know exactly where to look)
- Reduced cognitive load for contributors

**Community Growth:**
- Lower barrier to contribution
- Clear guidelines and examples
- Reduced frustration from merge conflicts

**Quality:**
- Better translation tracking
- Easier to identify gaps
- Consistent structure across all content

---

## Appendix A: Example File Structure

### Before Migration
```
_2020/
  course-shell.md        # Vietnamese + English comments (350 lines)
  shell-tools.md         # Vietnamese + English comments (420 lines)
  ...
```

### After Migration
```
_2020_en/
  course-shell.md        # English only (175 lines)
  shell-tools.md         # English only (210 lines)
  ...

_2020_vi/
  course-shell.md        # Vietnamese only (175 lines)
  shell-tools.md         # Vietnamese only (210 lines)
  ...
```

**Benefits:**
- Files are half the size
- Clean, readable source
- No confusing HTML comments
- Language-specific editing

---

## Appendix B: Example Front Matter

### English Lecture (_2020_en/course-shell.md)
```yaml
---
layout: lecture
title: "Course Overview + The Shell"
date: 2019-01-13
ready: true
video:
  aspect: 56.25
  id: Z56Jmr9Z34Q
lang: en
translation_id: course-shell
---
```

### Vietnamese Lecture (_2020_vi/course-shell.md)
```yaml
---
layout: lecture
title: "Tổng quan khóa học + Shell"
date: 2019-01-13
ready: true
video:
  aspect: 56.25
  id: Z56Jmr9Z34Q
lang: vi
translation_id: course-shell
---
```

**Key Fields:**
- `lang`: Identifies language (en/vi)
- `translation_id`: Links corresponding translations
- Same ID across languages enables language switcher

---

## Appendix C: Upstream Sync Example

### Before (Current Approach)
```bash
$ git merge upstream/master
Auto-merging _2020/course-shell.md
CONFLICT (content): Merge conflict in _2020/course-shell.md
Auto-merging _2020/shell-tools.md
CONFLICT (content): Merge conflict in _2020/shell-tools.md
...
# 20+ conflicts requiring manual resolution
```

### After (New Approach)
```bash
$ scripts/sync-upstream.sh
Fetching upstream...
Creating sync branch...
Merging upstream/master...
Auto-merging _2020_en/course-shell.md
Auto-merging _2020_en/shell-tools.md
Merge made by the 'recursive' strategy.
# Vietnamese files: zero conflicts (protected by .gitattributes)
# English files: clean merge

Review changes to English content:
=== 2020 lectures ===
+ Added new section on shell scripting
+ Fixed typo in metaprogramming lecture
...

Sync branch created: sync-upstream-2026-01
Review changes above, then:
  git push origin sync-upstream-2026-01
  Create PR for review
```

**Time Saved:** From 2-3 hours of manual conflict resolution → 5-10 minutes of automated sync

---

## Appendix D: Resources & References

### Jekyll Documentation
- Jekyll Collections: https://jekyllrb.com/docs/collections/
- Jekyll Front Matter: https://jekyllrb.com/docs/front-matter/
- Jekyll Liquid: https://jekyllrb.com/docs/liquid/

### i18n Patterns
- Multilingual Jekyll Sites: https://andreaburan.com/post/multilingual-sites-in-jekyll-2.html
- Jekyll i18n Without Plugins: https://apiacoa.org/blog/2012/09/multilingual-jekyll.en.html

### Git Workflow
- Syncing a Fork: https://docs.github.com/articles/syncing-a-fork
- Git Merge Strategies: https://git-scm.com/docs/merge-strategies

### Translation Projects
- Vue.js Translations: https://github.com/vuejs-translations
- Programming Historian: https://programminghistorian.org

---

## Conclusion

This restructure plan provides a comprehensive solution to the merge conflict problems plaguing the current translation workflow. By separating content into language-specific directories and leveraging Jekyll's built-in features, we can:

1. Eliminate merge conflicts during upstream sync
2. Enable bilingual site functionality
3. Simplify the contribution workflow
4. Maintain the upstream aesthetic
5. Scale to future content and languages

The implementation is straightforward, well-tested by other projects, and requires no custom build pipeline. With an estimated 12-18 hours of careful migration work, the project will be positioned for sustainable long-term maintenance and growth.

**Next Steps:**
1. Review this plan and provide feedback
2. Schedule migration implementation
3. Backup current repository
4. Begin Phase 1: Configuration & Setup

---

**Document Version:** 1.0
**Last Updated:** January 20, 2026
**Status:** Ready for Review & Implementation
