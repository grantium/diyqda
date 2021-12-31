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

A second paragraph of news content, and maybe more follow.
```


I am developing a process that is informed by [grounded field theory](https://en.wikipedia.org/wiki/Grounded_theory), but in the end will be represented in large part by whiz-bang visuals. I need to get the aggregates data into R nicely. My process works nicely with [Ryan J.A. Murphy's blog post](https://axle.design/an-integrated-qualitative-analysis-environment-with-obsidian) if you are using that as a foundation for qualitative data analyis. 

This is paragraph-level coding. So take the example from above, but say I'm tagging and writing about [[topic_report_release]] under that code/page, and same with ``[[dc]]`` for news about the district, and then ```[[another_tag]]``` just for kicks.

```
---
headline: "Giant news happened"
outlet: "Targeted News Service"
author: "Targeted News Service"
date: June 6, 2016
---

WASHINGTON–Today, reports were released.[[topic_report_release]] [[dc]]

A second paragraph of news content that say something about Washington, and maybe more follow.[[another tag]] [[dc]]
```
What this does is turn a folder full of markdown notes like that and make turn it into structured data like this. 
| File | Paragraph | Headline              | Outlet                  | Author                  | Date         | Text                                                       | Codes                            |
|------|-----------|-----------------------|-------------------------|-------------------------|--------------|------------------------------------------------------------|----------------------------------|
| 1    | 1         | "Giant news happened" | "Targeted News Service" | "Targeted News Service" | June 6, 2016 | WASHINGTON–Today, reports were released.                   | [[topic_report_release]], [[dc]] |
| 1    | 2         | "Giant news happened" | "Targeted News Service" | "Targeted News Service" | June 6, 2016 | A second paragraph of news content, and maybe more follow. | [[another tag]], [[dc]]          |

My needs will develop over time but I can't promise this package will - but if you need it to shape data connect to 
