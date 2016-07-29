
#source code file for downloading pdf files from regs.gov site

#import master list file (all docs to read.csv) that was downloaded using the All Documents link at
##https://www.regulations.gov/docketBrowser?rpp=25&so=DESC&sb=commentDueDate&po=0&D=EPA-HQ-OAR-2013-0602
##Use the export option and then save as a .csv file for loading into df format
library(httr)
library(downloader)
httr::set_config( config( ssl_verifypeer = 0L ) )

#set working directory
wd <- "C:/Users/CR Analytics/documents/graduate School/Summer Study/Master Document List"
setwd(wd)


##create function to convert dates not in standard r format

setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )

#import master list file (all docs to read.csv) that was downloaded using the All Documents link at
##https://www.regulations.gov/docketBrowser?rpp=25&so=DESC&sb=commentDueDate&po=0&D=EPA-HQ-OAR-2013-0602
##Use the export option and then save as a .csv file for loading into df format
master <- read.csv("all docs to read.csv", header = TRUE, sep = ",",
                   colClasses = c("Document.ID" = "character", 
                                  "Document.Type" = "character",
                                  "Posted.Date" = "myDate",
                                  "Document.SubType" = "character",
                                  "Attachment.Count" = "character",
                                  "File.Type" ="character",
                                  "Number.Of.Pages" = "character"))

#subset fields needed for loop
  keep1 <- c("Document.ID","Document.Type","Posted.Date","Document.SubType",
              "Attachment.Count", "File.Type","Number.Of.Pages")
  master2 <- master[keep1]
  
#logic reduction of datafile - PUBLIC SUBMISSIONS  AND PDFs ONLY
  master2$Attachment.Count <- as.numeric(master$Attachment.Count)
  master2$Number.Of.Pages <- as.numeric(master$Number.Of.Pages)

    master3 <- master2[with(master2,Document.Type == "PUBLIC SUBMISSIONS" & 
        !is.na(master2$Attachment.Count) &  File.Type %in% c("pdf","N/A")),]
    
    #order by ID for easy identification of missing values
   master4 <- master3[order(master3$Document.ID),] 
  

#START LOOP LOGIC FOR DOWNLOADING FILES
  
   df <- data.frame(doc = character(),
                    pullDate = integer(),
                    status=integer(),
                    fileType=character(),
                    content=character(),
                    stringsAsFactors=FALSE) 

   
pull <-  master4[1:nrow(master4),1]


pullfiles <- function(range) {
  
   for(i in range) {
     
     

link <- paste0("https://www.regulations.gov/contentStreamer?documentId=",
               pull[i],
               "&attachmentNumber=1&disposition=attachment&contentType=pdf")


dest <- paste0("C:/Users/CR Analytics/documents/graduate School/Summer Study/CommentOutput/",
               pull[i],".pdf")





result <<- GET(link)

docnew <<- pull[i]
pulldatenew <<- as.Date(result$date)
statusnew <<- result$status_code
filetypenew <<- headers(result)$'content-type'
contentnew <<- headers(result)$'content-disposition'

if(filetypenew != "pdf") next

newrowdf <<- data.frame(doc = docnew, pullDate = pulldatenew, status = statusnew,
            fileType = filetypenew, content = contentnew)

df <<- rbind(df, newrowdf)








   

##method for downloading pdf docs from Regulations.gov
###"wb" is key for binary file types
download(url = link, destfile = dest, mode = "wb", quiet = TRUE)

Sys.sleep(1)

   }

}

pullfiles(1:5000)
Sys.sleep(60)
pullfiles(5001:1000)
Sys.sleep(60)
pullfiles(10001:15000)
Sys.sleep(60)
pullfiles(15001:20000)
Sys.sleep(60)
pullfiles(20001:25000)
Sys.sleep(60)
pullfiles(25001:30000)
Sys.sleep(60)

