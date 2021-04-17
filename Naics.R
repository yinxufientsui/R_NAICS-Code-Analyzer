# Install package 
install.packages("dplyr")#enable data frame manipulation 
install.packages("readr")
install.packages("tm")
install.packages('SnowballC')#implements Porter's word stemming 

# Import the library 
library(dplyr)
library(readr)
library(NLP)
library(tm)
library(Matrix)
library(SnowballC)

### Defined Functions ###
# Pre-processing data with defined function
corpus_preprocessing = function(corpus){
  # Replace special symbols with space 
  toSpace <- content_transformer(function (x , pattern) gsub(pattern, " ", x))
  # Normalization
  corpus <- tm_map(corpus, toSpace, "/")
  corpus <- tm_map(corpus,toSpace,"@")
  corpus <- tm_map(corpus,toSpace,"\\｜")
  corpus <- tm_map(corpus,toSpace,"#")
  corpus <- tm_map(corpus, toSpace, "®")
  # Casing (upper case & lower case), convert the text to lower case
  corpus <- tm_map(corpus, content_transformer(tolower))
  # Remove punctuation 
  corpus <- tm_map(corpus, removePunctuation)
  # Remove extra white space 
  corpus <- tm_map(corpus, stripWhitespace)
  # Remove Stop words
  corpus <- tm_map(corpus,removeWords,stopwords("english"))
  corpus <- tm_map(corpus,removeWords,c("the","and","The","And","A","An","a","an","e","d"))
  # Stemming (e.g. -ing vs original)
  corpus <- tm_map(corpus,stemDocument, language ="english")
  return(corpus)
}

# Calculate cosine similarity with TF-IDF
cos_sim = function(matrix){
  numerator = matrix %*% t(matrix)
  A = sqrt(apply(matrix^2, 1, sum))
  denumerator = A %*% t(A)
  return(numerator / denumerator)
}

# Read the case data
d_6digit <- read.csv("data/6digit_test.csv", encoding = "UTF-8")
d_4digit <- read.csv("data/4digit_test.csv", encoding = "UTF-8")
code_6digit <- read.csv("data/6digit.csv", header=FALSE,encoding = "UTF-8")
code_4digit <- read.csv("data/4digit.csv", header=FALSE,encoding = "UTF-8")
business_desc <- read_file("data/bd3.txt")

# Convert the targeted file into data frame
bs_df <- data.frame(Industry = "Business Name & Description",Description = business_desc)

# Combine source code and text file
# 6 digit code vs business description 
d_6digit_bs <- rbind (bs_df,d_6digit)
# 4 digit code vs business description
d_4digit_bs <- rbind (bs_df,d_4digit)

# Change column name of both combined documents
names(d_6digit_bs)[1] = "doc_id"
names(d_6digit_bs)[2] = "text"
names(d_4digit_bs)[1] = "doc_id"
names(d_4digit_bs)[2] = "text"
names(code_6digit)[1] = "naics_6_code"
names(code_4digit)[1] = "naics_4_code"

# Transfer the data into corpus 
# 6- digit
doc_corpus6 = VCorpus(DataframeSource(d_6digit_bs))
# 4- digit
doc_corpus4 = VCorpus(DataframeSource(d_4digit_bs))

# Apply data pre-processing to each corpus
# 6- digit
corpus_cleaned6 <- corpus_preprocessing(doc_corpus6)
# 4- digit
corpus_cleaned4 <- corpus_preprocessing(doc_corpus4)

#Create a Document Term matrix, which containing the frequency of the words
#each row represents a document/text message 
#each column represents a distinct text/name
#each cell is a count of the token for a document/text message

# 6- digit
doc_dtm6 <- DocumentTermMatrix(corpus_cleaned6)
dtm_m6 <- as.matrix(doc_dtm6)
# 4- digit
doc_dtm4 <- DocumentTermMatrix(corpus_cleaned4)
dtm_m4 <- as.matrix(doc_dtm4)

# Apply TF-IDF Weighting 
# 6 digit
tfidf_6 <- DocumentTermMatrix(doc_corpus6,control = list(weighting = weightTfIdf))
tfidf_m6 = as.matrix(tfidf_6)
# 4 digit
tfidf_4 <- DocumentTermMatrix(doc_corpus4,control = list(weighting = weightTfIdf))
tfidf_m4 = as.matrix(tfidf_4)

# Calculate Cosine Similarity for each digit 
# 6 digit
tfidf_cos_sim6 = cos_sim(tfidf_m6)

# 4 digit
tfidf_cos_sim4 = cos_sim(tfidf_m4)

# Create columns for similarity_score and corresponding code 
# 6 digit
d_6digit_bs["naics_6digit"] = code_6digit
d_6digit_bs["similarity_score"] = tfidf_cos_sim6[1:ncol(tfidf_cos_sim6)]
# 4 digit
d_4digit_bs["naics_4digit"] = code_4digit
d_4digit_bs["similarity_score"] = tfidf_cos_sim4[1:ncol(tfidf_cos_sim4)]

# Sort the data frame by similarity score
# 6 digit
code_bs_similarity6 = d_6digit_bs[order(-d_6digit_bs$similarity_score),]
# Display the top ten 
top_10_6digit_code <-code_bs_similarity6 %>% top_n(10)
# Display the top five
top_5_6digit_code <- code_bs_similarity6 %>% top_n(5)
# 4 digit 
code_bs_similarity4 = d_4digit_bs[order(-d_4digit_bs$similarity_score),]
# Display the top ten 
top_10_4digit_code <-code_bs_similarity4 %>% top_n(10)
# Display the top five
top_5_4digit_code <- code_bs_similarity4 %>% top_n(5)

#consider to remove the second row 
View(code_bs_similarity6[-1,])
rownames(code_bs_similarity4) <- NULL
View(code_bs_similarity4[-1,])
#write into csv
write.csv(top_10_6digit_code,"industry_sim_6_digit.csv")
write.csv(code_bs_similarity4,"industry_sim_4_digit.csv")

#clear environment 
rm(list = ls())   
