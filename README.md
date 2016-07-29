# 111dComments
Sentiment analysis of public comments on the Clean Power Plan - proposed regulations on green house gas emissions from electric generating units

# R Programs for accessing Regulations.gov data
## APIreadmaster.R 
Creates a function called documents that can be called to request document/docket information from the Regulations.gov website.  

## APIdateloop.R
Wrapper for document function that is run in the APIreadmaster.R file.  PUlls all API documents by date and docket ID within API limits

## Download pdf File Looping.R
Script to create an httr request to the Regulations.gov website and request a file download for a specific list of document ids

## concatAPIcomments.R
Takes the comments downloaded by day in the Download pdf File Looping.R script and creates a data frame of comments and document IDs

## mergecleanapi.R
Runs text cleaning and unwraps text into one long string to get read for combining with pdf sourced comments

## mergecleanpdf
Scripts for converting binary pdf files to txt files.  Consolidates txt files and cleans and unwraps the data into one long string
