# diyqda
Helps turn a folder of wikilink-coded plaintext files into structured data corpus.

## How I came to this project

While analyzing a body of text files in the software app Obsidian, I fell into a pattern of collecting documents that were essentially this:

```
---
yaml header
---
body text paragraph

more body text
```

I'm analyzing media for a project, but many datasets may look like this. My yaml headers look like `author: "First, Last:` and `date: April 13, 2016`. They are individual lines at the start of the document separated by three hyphens: `---`. It also has a bunch of wikilinks in the text.

This script reads a folder of markdown files and gives you a structured dataset that includes:
- full-text corpus with file and paragraph references
- a metadata table containing your yaml headers

only cares about YAML in the header, text, paragraphs and wikilinks.

 into R and captures the above items.

Here's the type of file I designed it for.

```
---
title: "Gary Clark Jr_ This Land_ Review"
source: "Pitchfork"
rating: 5
---

According to Clark, it wasn’t merely the overall political climate that pushed him to write “This Land,” it was a specific incident with a new neighbor—one who couldn’t believe a young black man could own a sprawling ranch just outside of Austin. Gary Clark Jr. channeled his anger over this casual racism into a dose of fury so controlled, its origin becomes obscured—it becomes a proper blues song, in other words, where the specific is turned into something universal. [[topic_songwriting]] [[people_gary_clark_jr]]

Ironically, “This Land” isn’t necessarily a harbinger for the rest of _This Land_, the Texas bluesman’s third studio album. Apart from “Feed the Babies,” which offers a vague plea for growth and understanding, there isn’t another song that directly confronts a societal woe, nor is there much anger flowing through its other 15 songs. What “This Land” does indicate is how Clark no longer feels restricted by the confining dictates of modern blues. [[genre_blues]]
```

Incidentally, this script works nicely with [Ryan J.A. Murphy's blog post](https://axle.design/an-integrated-qualitative-analysis-environment-with-obsidian). 

This can't replace expensive QDA software, but it can bootstrap a similar and swift workflow for knowledge generation.

If you are doing qualitative analysis, know that this is paragraph-level coding. You can't split paragraphs or codes inbetween words - it's only matching codes to paragraphs.

Here's how it works.

`> p <- read_md_files('~/your_folder_here/')

When we inspect `p` we see:
```
> str(p)
List of 3
 $ metadata : tibble [3 × 5] (S3: tbl_df/tbl/data.frame)
  ..$ title   : chr [1:3] "Supreme Court of Russia" "Gary Clark Jr_ This Land_ Review" "2010 PapaJohns.com Bowl"
  ..$ source  : chr [1:3] "Wikipedia" "Pitchfork" "Wikipedia"
  ..$ rating  : int [1:3] 2 5 3
  ..$ file_n  : chr [1:3] "0001" "0002" "0003"
  ..$ para_len: num [1:3] 4 2 4
 $ text     :'data.frame':	25 obs. of  3 variables:
  ..$ file_n   : chr [1:25] "0001" "0001" "0001" "0001" ...
  ..$ paragraph: num [1:25] -4 -3 -2 -1 0 1 2 3 4 -4 ...
  ..$ text     : chr [1:25] "---" "title: Supreme Court of Russia" "source: Wikipedia" "rating: 2" ...
 $ code_list: tibble [5 × 4] (S3: tbl_df/tbl/data.frame)
  ..$ file_n   : chr [1:5] "0001" "0001" "0002" "0002" ...
  ..$ paragraph: num [1:5] 1 1 1 1 2
  ..$ text     : chr [1:5] "There are 115 members of the Supreme Court. Supreme Court judges are nominated by the President of Russia and a"| __truncated__ "There are 115 members of the Supreme Court. Supreme Court judges are nominated by the President of Russia and a"| __truncated__ "According to Clark, it wasn’t merely the overall political climate that pushed him to write “This Land,” it was"| __truncated__ "According to Clark, it wasn’t merely the overall political climate that pushed him to write “This Land,” it was"| __truncated__ ...
  ..$ codes    : chr [1:5] "russian_supreme_court" "government_administrative_structure" "topic_songwriting" "people_gary_clark_jr" ...
  ```
