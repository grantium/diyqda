# diyqda
Helps turn a folder of wikilink-coded plaintext files into a structured data corpus.

## How I came to this project

While analyzing a body of text files, I fell into a pattern of collecting documents that were essentially this:

```
--- (yaml header)
key: value
key: valye
---
body text paragraph [[wikilink]] [[wikilink]]

more body text [[wikilink]] [[wikilink]] [[wikilink]]
```

I need to keep all them separate, and count where they are in the document. That's what this does, but only at the paragraph level - I'm not splitting sentences or paragraphs, so this is more of a rapid-workflow kind of solution. I plan to use it in the design stages of creative projects and maybe project reflection.

I'm sharing to hopefully saves someone a moment or two, or in my case being new to R, quite a bit of time. 

This script reads a folder of markdown files and gives you a structured dataset that includes:
- full-text corpus with file and paragraph references
- a metadata table containing your yaml headers

 into R and captures the above items into a list of 3 tibbles. I use Tidyverse for much of it, and this is not a complete solution. But if you want to use Quanteda on your Obsidian vault or throw together some quick visualizations, this might get you partway there!
 
### Here's the type of file I designed it for.

```
---
title: "Gary Clark Jr_ This Land_ Review"
source: "Pitchfork"
rating: 5
---

According to Clark, it wasn’t merely the overall political climate that pushed him to write “This Land,” it was a specific incident with a new neighbor—one who couldn’t believe a young black man could own a sprawling ranch just outside of Austin. Gary Clark Jr. channeled his anger over this casual racism into a dose of fury so controlled, its origin becomes obscured—it becomes a proper blues song, in other words, where the specific is turned into something universal. [[topic_songwriting]] [[people_gary_clark_jr]]

Ironically, “This Land” isn’t necessarily a harbinger for the rest of _This Land_, the Texas bluesman’s third studio album. Apart from “Feed the Babies,” which offers a vague plea for growth and understanding, there isn’t another song that directly confronts a societal woe, nor is there much anger flowing through its other 15 songs. What “This Land” does indicate is how Clark no longer feels restricted by the confining dictates of modern blues. [[genre_blues]]
```

Incidentally, this script works nicely with [Ryan J.A. Murphy's blog post](https://axle.design/an-integrated-qualitative-analysis-environment-with-obsidian) because I read and used parts of his process for mine.

This can't replace expensive QDA software, but it can bootstrap a swift workflow for manually processing huge set of files in my quick qualitative analysis project.

If you are doing qualitative analysis, know that this is paragraph-level coding. You can't split paragraphs or codes inbetween words - it's only matching codes to paragraphs.

## Here's how it works.

The main part is a function. I'm working on turning this into a library and I will include library instructions when I do.

This relies on `tidyverse` and `r-yaml` so load those libraries first.

```
> library(tidyverse,yaml)
```

Call it by assigning it to a variable and passing it your folder of markdown files.

```
> p <- read_md_files('~/your_folder_here/')
```

Once it's done, let's examine `p` with `str()`.

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

**The function returns a list of three items.** What information is duplicated is done so for convenience. Of the three, text is the most duplicative and if you didn't save it you wouldn't lose anything. `file_n` in each table is the index.

**$text contains** the file name, a paragraph ID and textual content of the paragraph, and this repeats until the file is over. The YAML headers are processed with [viking's r-yaml package](https://github.com/viking/r-yaml). I retain the YAML header in `text` and `code_list' but start the paragraph ID at 0 at the 2nd three-hyphen YAML line. The idea here is to be nondestructive with the loaded file while allowing for an accurate paragraph index in content analysis. To assign the text table to a variable use `my_text <- p$text`.

**$metadata** contains example data above - but in yours it should be your yaml. I have only tested it with simple key-value pairs, but the standard is finicky so your mileage may vary. To your metadata, I add paragraph count (minus header) and file_n for linking to other tables. To assign the metadata to a variable, just use `my_metadata <- p$metadata`.

**$code_list is** largely the same as `$text`, but contains an additional column with the wikilink text (no brackets) unrolled by paragraph and by code. It separates this in a way that I think is tidy, but doesn't feel right - feel free to submit an issue here if you have an idea for another layout, I might be interested. To copy `code_list` to a variable, use `my_codes <- p$code_list`.

If you just want to write these to a file and open them in a spreadsheet, you can write one of the variables you made above using `write_csv` from Tidyverse. We already loaded that earlier, so we can just run the command.

```
> write_csv(my_metadata,'metadata.csv')
```
## Related Resources

 - [An Integrated Qualitative Analysis Environment with Obsidian](https://axle.design/an-integrated-qualitative-analysis-environment-with-obsidian) - has a sample Obsidian environment for this type of work environment and I borrowed the date-plugin trick, but I'm a novice at Javascript so I got stuck on Dataview
 - [Quoth plugin](https://github.com/erykwalder/quoth)
 - pseudometa linked to [this solution they cooked up](https://gist.github.com/chrisgrieser/80581254be5d7f3bc830d2d7c6cd980c) for their current analysis from the Obsidian Discord
