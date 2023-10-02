legacy/core/CORE-1989-CHARITIES-SCOPE-501C3-PZ.csv

CORE-1989-501C3-CHARITIES-SCOPE-PZ.csv
CORE-2017-501CE-NONPROFIT-SCOPE-PC.csv
BMF-2013-08-501CX-NONPROFIT-SCOPE-PX.csv

legacy/core/CORE-1991-501C3-PRIVFOUND-SCOPE-PF.csv

file <- "CORE-1989-CHARITIES-SCOPE-501C3-PZ.csv"


base <- "https://nccsdata.s3.us-east-1.amazonaws.com/"


yyyy <- stringr::str_extract( file, "-[0-9]{4}-" )
grep( "NONPROFITS", file, value=T )



d <- read.csv( "AWS-NCCSDATA.csv" )


get_core_paths <- function( paths, tscope="NONPROFIT", fscope="PZ" ) {
  expr <- paste0( "CORE-[0-9]{4}-", tscope )
  matches <- grep( expr, paths, value=T )
  matches <- grep( paste0( "-", fscope, "\\b"), matches, value=T )
  return( matches )
}

get_core_paths( paths=d$Key, tscope="CHARITIES", fscope="PC" )
get_core_paths( paths=d$Key, tscope="NONPROFIT", fscope="PZ" )
get_core_paths( paths=d$Key, tscope="PRIVFOUND", fscope="PF" )


get_bmf_paths <- function( paths ) {
  expr <- "BMF-.*-PX"
  matches <- grep( expr, paths, value=T )
  return( matches )
}

get_bmf_paths( d$Key )


char.paths <- get_core( paths=d$Key, type="CHARITIES" )

make_urls <- function( paths ) {
  base <- "https://nccsdata.s3.us-east-1.amazonaws.com/"
  urls <- paste0( base, paths )
  return( urls )
}

make_urls( paths )



get_core_year <- function( paths ) {
  yyyy <- stringr::str_extract( paths, "-[0-9]{4}-" )
  yyyy <- gsub( "-", "", yyyy )
  return( yyyy )
}


get_core_tscope <- function( paths ) {
  expr1 <- "-501C.-[A-Z]{9}-" 
  expr2 <- "-[A-Z]{9}-SCOPE-501C.-"
  tscope1 <- stringr::str_extract( paths, expr1 )
  tscope2 <- stringr::str_extract( paths, expr2 )
  tscope  <- na.omit( c( tscope1, tscope2 ) )
  tscope <- gsub( "^-|-$", "", tscope )
  return( as.character(tscope) )
}

get_core_tscope( "CORE-1989-501C3-CHARITIES-SCOPE-PZ.csv" )
get_core_tscope( "CORE-2017-501CE-NONPROFIT-SCOPE-PC.csv" )
get_core_tscope( "legacy/core/CORE-1991-501C3-PRIVFOUND-SCOPE-PF.csv" )



get_core_fscope <- function( paths ) {
  expr <- "-P[CXZ]{1}\\b" 
  # expr2 <- "-SCOPE-P.\\b"
  # fscope1 <- stringr::str_extract( paths, expr1 )
  fscope <- stringr::str_extract( paths, expr )
  # fscope  <- na.omit( c( fscope1, tscope2 ) )
  fscope <- gsub( "^-|-$", "", fscope )
  return( as.character(fscope) )
}





# BUILD METADATA TABLE
# OF ROWS AND COLUMN NAMES
# FOR DATA SERIES


BUTTON, TSCOPE, FSCOPE, OBS, FILESIZE


make_buttons <- function( urls ) {
  buttons <- 
    paste0( 
      "<a href=",
      urls,
      " class='button3'> DOWNLOAD </a>" )
  return( buttons ) 
}




paths <- get_core_paths( paths=d$Key, tscope="CHARITIES", fscope="PC" )
urls  <- make_urls( paths )
make_buttons( urls )




BUTTONS <- make_buttons( urls )
TSCOPE  <- get_core_tscope( paths )
FSCOPE  <- get_core_fscope( paths )
YEAR    <- get_core_year( paths )

catalog <- 
  data.frame( 
    BUTTONS, 
    NP_TYPE=TSCOPE, 
    FORM_SCOPE=FSCOPE, 
    YEAR=YEAR )

knitr::kable( catalog )







#####
#####


library("datasets")

tmp <- tempfile()
on.exit(unlink(tmp))
utils::write.csv(mtcars, file = tmp)
# put object with an upload progress bar
put_object(tmp, object = "mtcars.csv", bucket = "myexamplebucket", show_progress = TRUE)



library("datasets")
# write file to S3
tmp <- tempfile()
on.exit(unlink(tmp))
utils::write.csv(mtcars, file = tmp)
# put object with an upload progress bar
put_object(tmp, object = "mtcars.csv", bucket = "myexamplebucket", show_progress = TRUE)
# create a "folder" in a bucket
put_folder("example", bucket = "myexamplebucket")
## write object to the "folder"
put_object(tmp, object = "example/mtcars.csv", bucket = "myexamplebucket")
# write serialized, in-memory object to S3
x <- rawConnection(raw(0), "w")
utils::write.csv(mtcars, x)
put_object(rawConnectionValue(x), object = "mtcars.csv", bucket = "myexamplebucketname")
# use `headers` for server-side encryption
## require appropriate bucket policy
## encryption can also be set at the bucket-level using \code{\link{put_encryption}}
put_object(file = tmp, object = "mtcars.csv", bucket = "myexamplebucket",
headers = c('x-amz-server-side-encryption' = 'AES256'))
put_object(rawConnectionValue(x), object = "s3://myexamplebucketname/mtcars.csv")
close(x)
# read the object back from S3
read.csv(text = rawToChar(get_object(object = "s3://myexamplebucketname/mtcars.csv")))
# multi-part uploads for objects over 5MB
\donttest{
x <- rnorm(3e6)
saveRDS(x, tmp)
put_object(tmp, object = "rnorm.rds", bucket = "myexamplebucket",
show_progress = TRUE, multipart = TRUE)
identical(x, s3readRDS("s3://myexamplebucket/rnorm.rds"))
}
