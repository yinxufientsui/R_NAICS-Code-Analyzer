# Import the library 
library(readr)
library(tm)
library(Matrix)
library(SnowballC)
library(DT)

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

# Show the result for 6 digit 
function(input, output, session){
  ####For 6 digit###
  file1<- reactive({
    inFile1 <-input$uploaded_business_description
    if(is.null(inFile1))
      #inFile1 <- input$pasted_text
      return(NULL)
      
    business_desc <- read_file(inFile1$datapath)
    business_desc <- data.frame(Industry = "Business Name & Description",Description = business_desc)
    # Combine source code and text file
    # 6 digit code vs business description 
    d_6digit_bs <- rbind (business_desc,d_6digit)
    # Change column name of both combined documents
    names(d_6digit_bs)[1] = "doc_id"
    names(d_6digit_bs)[2] = "text"
    
    # Transfer the data into corpus 
    doc_corpus6 = VCorpus(DataframeSource(d_6digit_bs))
    # Apply data pre-processing to each corpus
    corpus_cleaned6 <- corpus_preprocessing(doc_corpus6)
    # Document term matrix
    # Apply TF-IDF Weighting 
    tfidf_6 <- DocumentTermMatrix(corpus_cleaned6,control = list(weighting = weightTfIdf))
    tfidf_m6 = as.matrix(tfidf_6)
    # Calculate Cosine Similarity for each digit 
    tfidf_cos_sim6 = round(cos_sim(tfidf_m6), digits = 2)
    # Create columns for similarity_score and corresponding code 
    d_6digit_bs["naics_6digit"] = code_6digit
    d_6digit_bs["similarity_score"] = tfidf_cos_sim6[1:ncol(tfidf_cos_sim6)]
    # Sort the data frame by similarity score
    code_bs_similarity6 = d_6digit_bs[order(-d_6digit_bs$similarity_score),]
    #Remove the first line of business description 
    code_bs_similarity6 = code_bs_similarity6[-1,]
    #Remove rowname 
    rownames(code_bs_similarity6) <- NULL
    #Download the output still the full code 
    output$download_code_bs_similarity_6digit <- downloadHandler(
      filename = function(){
        paste("industry_sim_6_digit-",Sys.Date(),".csv",sep = "")
      },
      content = function(file){
        write.csv(code_bs_similarity6,file)
      })
    
    return(code_bs_similarity6)##display how many rows in ui page

    })
  ####For 4 digit###
  file2<- reactive({
    inFile2 <-input$uploaded_business_description
    if(is.null(inFile2))
      return(NULL)
    business_desc <- read_file(inFile2$datapath)
    business_desc <- data.frame(Industry = "Business Name & Description",Description = business_desc)
    # Combine source code and text file
    d_4digit_bs <- rbind (business_desc,d_4digit)
    # Change column name of both combined documents
    names(d_4digit_bs)[1] = "doc_id"
    names(d_4digit_bs)[2] = "text"
    
    # Transfer the data into corpus 
    doc_corpus4 = VCorpus(DataframeSource(d_4digit_bs))
    # Apply data pre-processing to each corpus
    corpus_cleaned4 <- corpus_preprocessing(doc_corpus4)
    # Document term matrix
    # Apply TF-IDF Weighting 
    tfidf_4 <- DocumentTermMatrix(corpus_cleaned4,control = list(weighting = weightTfIdf))
    tfidf_m4 = as.matrix(tfidf_4)
    # Calculate Cosine Similarity for each digit 
    tfidf_cos_sim4 = round(cos_sim(tfidf_m4), digits = 2)
    # Create columns for similarity_score and corresponding code 
    d_4digit_bs["naics_4digit"] = code_4digit
    d_4digit_bs["similarity_score"] = tfidf_cos_sim4[1:ncol(tfidf_cos_sim4)]
    # Sort the data frame by similarity score
    code_bs_similarity4 = d_4digit_bs[order(-d_4digit_bs$similarity_score),]
    #Remove the first line of business description 
    code_bs_similarity4 = code_bs_similarity4[-1,]
    #Remove rowname 
    rownames(code_bs_similarity4) <- NULL
    #Download the output still the full code 
    output$download_code_bs_similarity_4digit <- downloadHandler(
      filename = function(){
        paste("industry_sim_4_digit-",Sys.Date(),".csv",sep = "")
      },
      content = function(file){
        write.csv(code_bs_similarity4,file)
      })
    return(code_bs_similarity4)
    
  })
    
    output$mytable1 <- DT::renderDataTable({
      DT::datatable(file1(),options = list(lengthMenu = c(5,10),pageLength = 10,searching= FALSE))
    })
    output$mytable2 <- DT::renderDataTable({
      DT::datatable(file2(),options = list(lengthMenu = c(5,10),pageLength = 10,searching= FALSE))
    })
}
  
