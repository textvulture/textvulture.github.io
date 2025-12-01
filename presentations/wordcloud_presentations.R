library(pdftools)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(dplyr)
library(stringr)
library(textstem)

folder <- "/Users/bson3/My Drive/PDFs/mine/"

pdf_files <- list.files(folder, pattern = "\\.pdf$", full.names = TRUE)

## 1. Read PDFs more efficiently: one string per document
# pdf_text() returns pages; paste pages together per file
text_list <- lapply(pdf_files, function(file) {
  txt <- pdf_text(file)
  paste(txt, collapse = " ")
})

names(text_list) <- basename(pdf_files)

## 2. Make a corpus
corpus <- Corpus(VectorSource(text_list))

## 3. Text preprocessing ----

# helper to replace patterns with space
to_space <- content_transformer(function(x, pattern) gsub(pattern, " ", x))

# lowercase first
corpus <- tm_map(corpus, content_transformer(tolower))

kpop_fix <- content_transformer(function(x) {
  # handle "k-pop" and "k pop" after lowercasing
  x <- gsub("k[- ]pop", "kpop", x)
  x
})
corpus <- tm_map(corpus, kpop_fix)

# now do general hyphen → space
corpus <- tm_map(corpus, to_space, "-")

corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)

# Custom stopwords: add academic boilerplate + your name
custom_stop <- c(
  stopwords("en"),
  "et", "al", "however", "therefore", "using", "also", 
  "may", "can", "one", "two", "three",
  "figure", "table", "appendix", "copyright",
  "son", "byunghwan", "ben",
  "university", "press", "springer", "wiley"
)

corpus <- tm_map(corpus, removeWords, custom_stop)
corpus <- tm_map(corpus, stripWhitespace)

## 4. Term–Document Matrix
tdm <- TermDocumentMatrix(corpus)
m <- as.matrix(tdm)

## 5. Compute frequencies & filter
word_freq <- rowSums(m)

word_freq_df <- data.frame(
  word = names(word_freq),
  freq = as.numeric(word_freq),
  stringsAsFactors = FALSE
) %>%
  filter(
    freq >= 2,
    nchar(word) >= 3
  ) %>%
  arrange(desc(freq))

## 5b. Lemmatize & collapse variants
word_freq_df$lemma <- lemmatize_words(word_freq_df$word)

word_freq_lemma <- word_freq_df %>%
  group_by(lemma) %>%
  summarize(freq = sum(freq), .groups = "drop") %>%
  arrange(desc(freq))

word_freq_df2 <- word_freq_lemma %>%
  rename(word = lemma)

# Make "kpop" display nicely as "K-pop"
word_freq_df2$word[word_freq_df2$word == "kpop"] <- "K-pop"

## 6. Save word cloud as a higher-resolution image
output_image <- "wordcloud_publications.png"

png(filename = output_image, width = 1200, height = 1200, res = 200)
par(mar = c(0, 0, 0, 0))

set.seed(1234)
wordcloud(
  words = word_freq_df2$word,
  freq = word_freq_df2$freq,
  max.words = 100,
  random.order = FALSE,
  rot.per = 0.15,
  scale = c(5, 0.8),
  colors = brewer.pal(8, "Dark2")
)

dev.off()