
# Here are a few methods for getting text from PDF files. Do read through 
# the instructions carefully! NOte that this code is written for Windows 7,
# slight adjustments may be needed for other OSs

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

master3 <- master2[with(master2,master2$Document.Type == "PUBLIC SUBMISSIONS" & 
                          master2$Document.SubType == "Public Comment" &
                          !is.na(master2$Attachment.Count) &  
                          File.Type %in% c("pdf","N/A")),]

#order by ID for easy identification of missing values
master4 <- master3[order(master3$Document.ID),] 



# Tell R what folder contains your 1000s of PDFs
dest <- "C:/Users/CR Analytics/Documents/Graduate School/Summer Study/CommentOutput"
#change wd to text file location for simplified i/o
setwd(dest)

# make a vector of PDF file names
myfiles <- paste0(master4$Document.ID,".pdf")
#myfiles <- list.files(path = dest, pattern = "pdf",  full.names = TRUE)


lapply(myfiles, function(i) system(paste('"C:/Program Files/xpdf/bin64/pdftotext.exe"',
                                         paste0('"', i, '"')), wait = FALSE) )

# where are the txt files you just made?
dest # in this folder







