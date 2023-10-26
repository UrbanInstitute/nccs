# Script with helper functions to construct catalog pages


#' @title Retrieve paths to files in S3 objects
#' 
#' @description get_file_paths uses regular expressions to match the keys of
#' objects hosted on an AWS S3 bucket. A record of all objects in a bucket must
#' first be constructed
#' 
#' @param series character scalar. Name of NCCS data series. Accepted values
#' are "core", "bmf".
#' @param paths character vector. Vector of object keys from S3 bucket.
#' @param tscope character scalar. Type of tax exemption. Accepted values are
#'               "NONPROFIT" ( All other 501c type organizations besides 501c3), 
#'               "CHARITIES" (501c3 nonprofit organizations), 
#'               "PRIVFOUND" (501c3 private foundations). 
#'               Default == NULL
#' @param fscope character scalar. Form type. Accepted values are:
#'               "PZ": 990 + 990EZ filers
#'               "PC": 990 filers only
#'               "PF": 990PF private foundations
#'               Default == NULL     
#' 
#' @return character vector. Matching paths

get_file_paths <- function(series,
                           paths,
                           tscope = NULL,
                           fscope = NULL){
  if (series == "bmf"){
    expr <- "BMF-.*-PX" 
    paths <- grep(expr, paths, value = TRUE)
  } else if (series == "core"){
    expr <- paste0( "CORE-[0-9]{4}-501C[0-9A-Z]-", tscope )
    paths <- grep( expr, paths, value=T )
    paths <- grep( paste0( "-", fscope, "\\b"), paths, value=T )
  }
  
 return(paths)
  
}

#' @title Create download links for objects in S3 buckets
#' 
#' @description make_s3_urls creates hyperlinks that directly point to s3 objects
#' and trigger a download
#' 
#' @param paths character vector. Vector of object keys from S3 bucket.
#' 
#' @return character vector. Links to download objects in paths

make_s3_urls <- function( paths ) {
  base <- "https://nccsdata.s3.us-east-1.amazonaws.com/"
  urls <- paste0( base, paths )
  return( urls )
}

#' @title Create links to archived web pages in https://urbaninstitute.github.io/nccs-legacy/
#' 
#' @description make_archive_urls creates hyperlinks that directly point to 
#' archived web pages from the now defunct NCCS Data Archive. These pages describe
#' the datasets belonging to an S3 object with a key specified in paths.
#' 
#' @param series character scalar. Name of NCCS data series. Accepted values
#' are "core", "bmf".
#' @param paths character vector. Vector of object keys from S3 bucket.
#' 
#' @return character vector. Links to archived web pages for object keys in paths
make_archive_urls <- function(series,
                              paths){
  
  base_url = sprintf("https://urbaninstitute.github.io/nccs-legacy/dictionary/%s/%s_archive_html/",
                     series,
                     series)
  
  expr_dic = list("core" = "legacy/core/",
                  "bmf" = "legacy/bmf/")
  matches <- gsub(expr_dic[[series]], "", paths)
  matches <- gsub("\\.csv", "", matches)
  
  archive_urls <- paste0(base_url, matches)
  
  return(archive_urls)  
}


#' @title Extract the tax year for a data set
#' 
#' @description get_year uses regular expressions to extract the tax year 
#' (format: yyyy) for which a data set with a specific object key in 'paths'
#' covers
#' 
#' @param paths character vector. Vector of object keys from S3 bucket.
#' 
#' @return character vector. Tax years for datasets.

get_year <- function( paths ) {
  yyyy <- stringr::str_extract( paths, "-[0-9]{4}-" )
  yyyy <- gsub( "-", "", yyyy )
  return( yyyy )
}

#' @title Extract the release month for a data set
#' 
#' @description get_year uses regular expressions to extract the release month
#' (format: yyyy) for which a "bmf" data set with a specific object key in 'paths'
#' covers
#' 
#' @param paths character vector. Vector of bmf object keys from S3 bucket.
#' 
#' @return character vector. Release months for datasets.

get_month <- function( paths ) {
  mm <- stringr::str_extract( paths, "-[0-9]{2}-" )
  mm <- gsub( "-", "", mm )
  return( mm )
}

#' @title Create html cide for download buttons
#' 
#' @description make_buttons creates html code for buttons on a catalog page 
#' that either link to the download url for an s3 object or the archived data 
#' dictionary
#' 
#' @param urls character vector. Vector of links to s3 object downloads or
#' archived data dictionaries.
#' @param button_name character scalar. Name of button to construct. Accepted
#' values are "DOWNLOAD" or "PROFILE".
#' 
#' @return character scalar. HTML code to construct button.

make_buttons <- function(urls, button_name) {
  
  button_dic = list("download" = " class='button'> DOWNLOAD </a>",
                    "profile" = " class='button2'> PROFILE </a>")
  
  buttons <- paste0("<a href=",
                    urls,
                    button_dic[[button_name]] )
  return( buttons ) 
}

##### Undocumented functions #########


get_core_tscope <- function( paths ) {
  expr1 <- "-501C.-[A-Z]{9}-" 
  expr2 <- "-[A-Z]{9}-SCOPE-501C.-"
  tscope1 <- stringr::str_extract( paths, expr1 )
  tscope2 <- stringr::str_extract( paths, expr2 )
  tscope  <- na.omit( c( tscope1, tscope2 ) )
  tscope <- gsub( "^-|-$", "", tscope )
  return( as.character(tscope) )
}




get_core_fscope <- function( paths ) {
  expr <- "-P[CXZ]{1}\\b" 
  # expr2 <- "-SCOPE-P.\\b"
  # fscope1 <- stringr::str_extract( paths, expr1 )
  fscope <- stringr::str_extract( paths, expr )
  # fscope  <- na.omit( c( fscope1, tscope2 ) )
  fscope <- gsub( "^-|-$", "", fscope )
  return( as.character(fscope) )
}

############
############   EFILE
############


get_efile_paths <- function( paths ) {
  expr <- "csv$"
  matches <- grep( expr, paths, value=T )
  return( matches )
}


get_efile_year <- function( paths ) {
  yyyy <- stringr::str_extract( paths, "-[0-9]{4}-" )
  yyyy <- gsub( "-", "", yyyy )
  return( yyyy )
}


# x <- "parsed/F9-P00-T00-HEADER-2009.csv"

get_efile_names <- function( x ) {
  x <- gsub( "parsed/", "", x )
  x <- gsub( "-[0-9]{4}.csv", "", x )
  return(x)
}

get_rdb_cardinality <- function( paths ) {
  ttt  <- stringr::str_extract( paths, "-T[0-9]{2}-" )
  ttt <- gsub(  "-", "", ttt )
  ttt <- gsub( "^T", "", ttt )
  card <- ifelse( ttt == "00", "1:1", "1:M" )
}

############
############   SOI-MICRO
############


get_soi_paths <- function( paths, tscope="NONPROFIT", fscope="PZ" ) {
  expr <- paste0( "SOI-MICRODATA-[0-9]{4}-501C[0-9A-Z]-", tscope )
  matches <- grep( expr, paths, value=T )
  matches <- grep( paste0( "-", fscope, "\\b"), matches, value=T )
  return( matches )
} 


get_legacy_soi_urls <- function(soi_paths){

  legacy_url <- "https://urbaninstitute.github.io/nccs-legacy/dictionary/soi/html/"
    
  matches <- gsub("legacy/soi-micro/[0-9]{4}/", "", soi_paths)
  matches <- gsub("\\.csv", "", matches)
  
  legacy_urls <- paste0(legacy_url, matches)
  
  return(legacy_urls)
}
