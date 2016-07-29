

##grabbing txt files for detecting image files
library(qdap)
library(tm)
# Tell R what folder contains your 1000s of PDFs
dest <- "C:/Users/CR Analytics/Documents/Graduate School/Summer Study/CommentOutput"
#change wd to text file location for simplified i/o
setwd(dest)

#create list of text files in directory after convertinfg from pdf
myfilestxt <- list.files(path = dest, pattern = "txt",  full.names = FALSE)

#create a corpus with all comments to be able to run text cleaning
docs <- Corpus(URISource(myfilestxt,encoding = "UTF-8"),
               readerControl = list(language = "en"))


#for viewing text in files
#strwrap(docs[[1]])

#text cleaning
docs <- tm_map(docs, content_transformer(tolower))#convert to lower case
docs <- tm_map(docs, removeNumbers)#remove numbers
docs <- tm_map(docs, removeWords, stopwords("english"))#remove common words
docs <- tm_map(docs, removePunctuation, preserve_intra_word_dashes = TRUE)#removes punctuation
docs <- tm_map(docs, stripWhitespace)#removes extra white space


#toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))

#docs <- tm_map(docs, toSpace, "[s{2}]")

dftxt <- data.frame(documentID = character(),
                 commentTxt  = character(),
                 stringsAsFactors=FALSE) 

for (i in 1:length(myfilestxt)) {

comment <- strwrap(docs[[i]])
commentTxt <- capture.output(cat(comment, sep=" ")) 

if(is.character(commentTxt) & length(commentTxt) == 0) next

documentID <- gsub(pattern = ".txt", replacement = "",meta(docs[[i]], "id"))


newrowdf <<- data.frame(documentID = documentID, commentTxt = commentTxt,
                       stringsAsFactors=FALSE)



dftxt <<- rbind(dftxt, newrowdf)


}

##read out text cleaned
# final <-"C:/Users/CR Analytics/Documents/Graduate School/Summer Study/CommentOutput/FinalOutput/pdfComments.csv"
# 
# write.csv(dftxt, final,row.names = FALSE)

##read out raw
final <-"C:/Users/CR Analytics/Documents/Graduate School/Summer Study/CommentOutput/FinalOutput/rawpdfComments.csv"

write.csv(dftxt, final,row.names = FALSE)


#create spellcheck version with no misspelled words
final <-"C:/Users/CR Analytics/Documents/Graduate School/Summer Study/CommentOutput/FinalOutput/pdfComments.csv"

dftxt2 <- read.csv(final, header = TRUE, sep = ',',stringsAsFactors = FALSE)

for (i in 1:nrow(dftxt2))  {

z <- strsplit(as.character(dftxt2[i,2]), split = " ")
z2 <- c(z[[1]])

pot_spell <- lapply(z2, which_misspelled)
misspelled <- which(sapply(pot_spell, function(x) !is.null(x)))
z3 <- z2[misspelled]


z3sp <- lapply(z3, function(x) paste0(" ",x," "))


chkrow <- mgsub(pattern = z3sp,replacement="",text.var = dftxt2[i,2],
                leadspace = TRUE, trailspace = TRUE, order.pattern = TRUE,
                fixed = TRUE)

dftxt2[i,2] <- chkrow



if(i%%500 == 0) print(i)

}


final2 <-"C:/Users/CR Analytics/Documents/Graduate School/Summer Study/CommentOutput/FinalOutput/pdfCommentsSp.csv"

write.csv(dftxt2, final2,row.names = FALSE)



##lcreate a new corpus document with the vector from clean dataset


vdocs <- VectorSource(dftxt2$CommentTxt)

vdocs2 <- VCorpus(vdocs)







