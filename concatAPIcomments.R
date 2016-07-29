

##this program will concatenate all of the .csv files downloaded from the API

#goal is to create clean comment text file where comments were submitted
##through direct text entry format with no associated attachment

##set storeage area as working directory

apitxt <- "C:/Users/CR Analytics/Documents/Graduate School/Summer Study/CommentOutput"

setwd(apitxt)


##create vector of file names to read through for loop
myapitxt <- list.files(pattern = "csv",  full.names =FALSE)
myapitxt

##create empty dataframe to write comments out to
dftxt <- data.frame(documentId = character(),
                 commentText=character(),
                 stringsAsFactors=FALSE) 

##start for loop

for(i in 1:length(myapitxt))  {
  
  if(file.info(myapitxt[i])$size < 5) next
  
  filetxt <<- read.csv(file = myapitxt[i], header = TRUE, sep = ",", 
                       colClasses = c("documentType" = "character", 
                                      "attachmentCount" = "integer"))
  
  filetxt2 <<- filetxt[with(filetxt,filetxt$documentType == "Public Submission" & 
                              filetxt$attachmentCount == 0),]
  
  if (nrow(filetxt2) == 0) next
  
  #subset fields 
  keep1 <<- c("documentId","commentText")
  filetxt3 <<- filetxt2[keep1]
  
  newdftxt <<- data.frame(documentId = filetxt3$documentId,
                          commentText = filetxt3$commentText)
  
  if(newdftxt$commentText == "See Attached") next
  
  dftxt <<- rbind(dftxt, newdftxt)
  
}
dftxt2 <- unique(dftxt)

write.csv(dftxt2,"all_api_comments.csv",row.names = FALSE)
