read_md_files <- function(md_dir) {
  mk_links_regex <- "(\\[\\[.+?\\]\\])" # regex for extracting [[wikilinks]]
  file_list <- list.files(path=md_dir, pattern="*.md") # obtain file list in folder md_dir
  texts <- data.frame(file_n=character(),
                      paragraph=as.numeric(),
                      text=character(),
                      stringsAsFactors = FALSE) # creates empty dataframe
  metadata_by_file <- tribble(~file_n, ~date, ~headline, ~outlet, ~author)
  for (i in 1:length(file_list)) {
    p <- read.delim(paste(md_dir, file_list[i], sep = ""),
                    header=FALSE,
                    col.names = c("text"),
                    stringsAsFactors = FALSE) # read.delim here is automatically splitting by paragraph
    # q <- str_match(p$text,"---") I tried a vector-based solution first, I don't understand enough to figure it out
    # which(is.na(q), arr.ind = TRUE)
    text_yaml <- "---" # reset yaml string
    for (md_end in 2:length(p$text)){ # LOOK FOR YAML - specifically the second closing '---', so I'm skipping line 1.
      # If there's no second '---' then there is not a YAML header
      if (p$text[md_end] == "---"){ # if it's the last yaml line...
        break # were done - get out
      } else if (i == length(p$text)) {
        md_end <- 0
        break
      }
      else {
        text_yaml <- paste(text_yaml, p$text[i],' ',sep='')
      }
    }
    if (md_end == 0) {
      print(paste("No YAML processed for file: ", file_list[i], sep=''))

    } else { # process that yaml!
      #    corpus_yaml[[i]][1] <- file_list[i] # add filename
      text_yaml <- paste(text_yaml, '---', sep='')
      local_return <- yaml.load(p$text[1:md_end]) # add metadata via yaml.load of the yaml section only
      local_return <- as_tibble(local_return) %>%
        mutate(file_n = str_remove(file_list[i],'.md')) #%>% #add a filename as a
      if (i == 1) {
        metadata_by_file <- local_return
      } else {
      metadata_by_file <- add_row(as_tibble(metadata_by_file),local_return)}
    }
    p <- p %>% mutate(file_n=sub(".md", "", x=file_list[i]), # add filename as label
                      paragraph=row_number()-md_end) # add paragraph number
    texts <- bind_rows(texts, p)
  }
  metadata_by_file <- left_join(metadata_by_file,(texts %>%
                                                    group_by (file_n) %>%
                                                    summarize(para_len = max(paragraph))))
  code_list <- texts %>% # apply the codes - you have two options, uncomment the one you want
    mutate(codes = str_extract_all(text,mk_links_regex)) %>% # create new column with list of codes
    unnest_longer(codes) %>% # remove wikilinks from corpus
    mutate(text = str_remove_all(text, mk_links_regex)) %>%
    mutate(codes = str_remove_all(codes, '\\[')) %>%
    mutate(codes = str_remove_all(codes, '\\]')) #%>%
  return <- list(metadata_by_file, texts, drop_na(code_list))
  names(return) <- c('metadata', 'text', 'code_list')
  return(return)
}
