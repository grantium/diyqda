# diyqda
Helps turn a folder of wikilink-coded plaintext files into structured data corpus.

## How I came to this project

While analyzing a body of text files in the software app Obsidian, I fell into a pattern of collecting documents that were essentially this:

```
---
yaml header
---
body text paragraph
```

This is for a media analysis project - a bunch of web articles. The yaml headers look like `author: "First, Last:` and `date: April 13, 2016`. They are individual lines at the start of the document separated by three hyphens: `---`.

For example,

```
---
headline: "Giant news happened"
outlet: "Targeted News Service"
author: "Targeted News Service"
date: June 6, 2016
---

WASHINGTON–Today, reports were released.
```


I am developing a process that is informed by [grounded field theory](https://en.wikipedia.org/wiki/Grounded_theory), but in the end will be represented in large part by whiz-bang visuals. I need to get the aggregates data into R nicely. My process works nicely with [Ryan J.A. Murphy's blog post](https://axle.design/an-integrated-qualitative-analysis-environment-with-obsidian) if you are using that as a foundation for qualitative data analyis. 

This is paragraph-level coding. I'm working on my portfolio, and that is enough for me. Feel free to branch it if you need it!
