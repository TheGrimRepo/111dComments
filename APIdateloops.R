
#Code to loop function(documents) through comment cycle
##Need to make sure to stay under the 1000 API limit with 
###each iteration.




##First check for counts by day to see if any exceed 1000

#create list of posted date range for looping


##Program assumes that the function <documents> is read in from the readmaster.R file

dater <- seq(as.Date("2014/6/24"), as.Date("2016/3/30"), by = "day")
dater2 <- as.character(dater)

i=1

for(i in 1:length(dater2))  {

  cat("\n i has been set to the value of",i)


#call function documents with API parameters
mydata <- documents(apikey = 'JGGMvcYVdizFLpXYQG3rE7tvEQYEU9wXUEwWPpNR', countsOnly = 0, 
                    docketID = 'EPA-HQ-OAR-2013-0602',postedDate1 = dater2[i])


#export returned data and desired data fields
#keep  <- c("documentId", "postedDate","attachmentCount",
          # "commentText","documentStatus", "documentType", "title",
          # "numberOfCommentsReceived")

#oneday <- mydata[keep]

saveout <- paste0("C:/Users/CR Analytics/documents/graduate School/Summer Study/CommentOutput/",
                  "comments_",dater2[i],".csv")


write.csv(mydata,saveout,row.names = FALSE)



}