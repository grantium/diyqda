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

```
library(tidyverse,yaml)
> p <- read_md_files('~/your_folder_here/')
```

When we look at the structure of `p` we see:
```
> str(p)
List of 3
 $ metadata : tibble [3 × 5] (S3: tbl_df/tbl/data.frame)
  ..$ title   : chr [1:3] "Supreme Court of Russia" "Gary Clark Jr_ This Land_ Review" "2010 PapaJohns.com Bowl"
  ..$ source  : chr [1:3] "Wikipedia" "Pitchfork" "Wikipedia"
  ..$ rating  : int [1:3] 2 5 3
  ..$ file_n  : chr [1:3] "0001" "0002" "0003"
  ..$ para_len: int [1:3] 4 2 4
 $ text     : tibble [25 × 3] (S3: tbl_df/tbl/data.frame)
  ..$ file_n   : chr [1:25] "0001" "0001" "0001" "0001" ...
  ..$ paragraph: int [1:25] -4 -3 -2 -1 0 1 2 3 4 -4 ...
  ..$ text     : chr [1:25] "---" "title: Supreme Court of Russia" "source: Wikipedia" "rating: 2" ...
 $ code_list: tibble [5 × 4] (S3: tbl_df/tbl/data.frame)
  ..$ file_n   : chr [1:5] "0001" "0001" "0002" "0002" ...
  ..$ paragraph: int [1:5] 1 1 1 1 2
  ..$ text     : chr [1:5] "There are 115 members of the Supreme Court. Supreme Court judges are nominated by the President of Russia and a"| __truncated__ "There are 115 members of the Supreme Court. Supreme Court judges are nominated by the President of Russia and a"| __truncated__ "According to Clark, it wasn’t merely the overall political climate that pushed him to write “This Land,” it was"| __truncated__ "According to Clark, it wasn’t merely the overall political climate that pushed him to write “This Land,” it was"| __truncated__ ...
  ..$ codes    : chr [1:5] "russian_supreme_court" "government_administrative_structure" "topic_songwriting" "people_gary_clark_jr" ...
  ```
**The funtion returns a list of three items.** What information is duplicated is done so for convenience. `file_n` in each table can serve as an index.

$text contains the file name, a paragraph ID and textual content of the paragraph, and this repeats until the file is over. The YAML headers are processed with [viking's r-yaml package](https://github.com/viking/r-yaml). Rather than discarding that information, I start the paragraph index after the header is over. This lets you perform text analysis content distribution in paragraphs with an accurate count, but still refer to the header if you need it.

$code_list is largely the same as $text, but contains an additional column with wikilinks separated by paragraph.

To assign the metadata to a variable, just use `my_metadata <- p$metadata`.

To assign the text table to a variable use `my_text <- p$text`.

And finally, the code list: `my_codes <- p$code_list`.

If you just want to write these to a file and open them in a spreadsheet, you can write one of the variables you made above using `write_csv` from Tidyverse.
  
```
write_csv(my_metadata,'metadata.csv')
```
