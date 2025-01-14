library(pdftools)
library(tm)
library(wordcloud)
library(RColorBrewer)

# Set the folder path containing the PDF files
folder <- '/Users/bson3/My Drive/PDFs/mine/'

# List all PDF files in the folder
pdf_files <- list.files(folder, pattern = "\\.pdf$", full.names = TRUE)

# Initialize a list to store text from each PDF
text_list <- list()

# Loop through all PDF files and extract text
for (file in pdf_files) {
  text <- pdf_text(file) # Extract text from the PDF
  text_list <- c(text_list, text) # Append text to the list
}

# Combine all text into a single Corpus
corpus <- Corpus(VectorSource(text_list))

# Text preprocessing
corpus <- tm_map(corpus, content_transformer(tolower)) # Convert to lowercase
corpus <- tm_map(corpus, removePunctuation) # Remove punctuation
corpus <- tm_map(corpus, removeNumbers) # Remove numbers
corpus <- tm_map(corpus, removeWords, stopwords("en")) # Remove stop words
corpus <- tm_map(corpus, stripWhitespace) # Remove extra whitespaces

# Create a Term-Document Matrix
tdm <- TermDocumentMatrix(corpus)
matrix <- as.matrix(tdm)
word_freq <- sort(rowSums(matrix), decreasing = TRUE)

# Create a data frame for word frequencies
word_freq_df <- data.frame(word = names(word_freq), freq = word_freq)

# File name for saving the word cloud
output_image <- "wordcloud.png"

# Save the word cloud as an image
png(filename = output_image, width = 800, height = 800)

set.seed(1234) # For reproducibility
wordcloud(
  words = word_freq_df$word,
  freq = word_freq_df$freq,
  min.freq = 2, # Minimum frequency of words to include
  max.words = 200, # Maximum number of words
  random.order = FALSE, # Words ordered by frequency
  colors = brewer.pal(8, "Dark2")
)

dev.off() # Close the graphics device