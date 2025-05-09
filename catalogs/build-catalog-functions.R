# Script with helper functions to construct catalog pages

#' @title Construct catalog data frame for rendering in catalog page
#' 
#' @description construct_catalog automates the workflow for creating the data.frame
#' object used to build catalog tables.
#' 
#' @param s3_catalog. data.frame. Data frame containing metadata for objects in S3
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
#' @param np_type character scalar. Name of nonprofit type in table column for
#'                Nonprofit Type. Format: "501C{3/E}-{CHARITIES/NONPROFIT/PRIVFOUND}. 
#'                Default == NULL
#' 
#' @return data.frame. Catalog table
#' 
#' @import dplyr
construct_catalog <- function(s3_catalog,
                              series,
                              paths,
                              tscope = NULL,
                              fscope = NULL,
                              np_type = NULL){
  
  paths <- get_file_paths(series = series,
                          paths = paths,
                          tscope = tscope,
                          fscope = fscope)
  size <- s3_catalog %>% 
    dplyr::filter(Key %in% paths) %>% 
    dplyr::mutate(size_mb = paste0(as.character(round(Size / 1000000, 1)),
                                   " mb")) %>% 
    dplyr::pull("size_mb")
    
  download_urls <- make_s3_urls(paths = paths)
  
  if (series == "revocations"){
    
    log_urls <- grep("LOG", download_urls, value = TRUE)
    log_buttons <- make_buttons(urls = log_urls, button_name = "download")
    
    org_urls <- grep("ORG", download_urls, value = TRUE)
    org_buttons <- make_buttons(urls = org_urls, button_name = "download")
    
    table_urls <- grep("TABLE", download_urls, value = TRUE)
    table_buttons <- make_buttons(urls = table_urls, button_name = "download")
    
    catalog <- data.frame(log_buttons,
                          org_buttons,
                          table_buttons)
    catalog$YEAR <- get_year(log_urls)
    catalog$MONTH <- get_month(log_urls)
    
    return(catalog)
    
  }
  
  else {
    
    download_buttons <- make_buttons(urls = download_urls, 
                                     button_name = "download")
    
  }
    
  if (! series %in% c("census-crosswalk")){
    
    profile_urls <- make_archive_urls(series = series, paths = paths)
    profile_buttons <- make_buttons(urls = profile_urls, button_name = "profile")
    catalog <- data.frame(download_buttons,
                          profile_buttons,
                          size)
    
  } else {
    
    catalog <- data.frame(download_buttons,
                          size)
  
  }

  if (series %in% c("bmf")){
    
    catalog$MONTH <- get_month(paths)
    
    }
  
  if (! series %in% c("misc", "census-crosswalk")){

    catalog$YEAR <- get_year(paths)
    catalog$NP_TYPE <- np_type
    catalog$FORM_SCOPE <- fscope
  }
  
  return(catalog)
  
}


#' @title Retrieve paths to files in S3 objects
#' 
#' @description get_file_paths uses regular expressions to match the keys of
#' objects hosted on an AWS S3 bucket. A record of all objects in a bucket must
#' first be constructed
#' 
#' @param series character scalar. Name of NCCS data series. Accepted values
#' are "core", "bmf", "misc", "census-crosswalk".
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
  if (series == "bmf") {
    expr <- "BMF-.*-PX" 
    paths <- grep(expr, paths, value = TRUE)
  } else if (series == "core"){
    expr <- paste0( "CORE-[0-9]{4}-501C[0-9A-Z]-", tscope )
    paths <- grep( expr, paths, value = TRUE )
    paths <- grep( paste0( "-", fscope, "\\.csv"), paths, value=T )
  } else if (series == "misc"){
    expr <- "SUPPLEMENTAL-CORE.*"
    paths <- grep(expr, paths, value = TRUE)
  } else if (series == "soi"){
    expr <- paste0( "SOI-MICRODATA-[0-9]{4}-501C[0-9A-Z]-", tscope )
    paths <- grep( expr, paths, value=T )
    paths <- grep( paste0( "-", fscope, "\\b"), paths, value=T )
  } else if (series == "census-crosswalk"){
    paths <- grep("BLOCKX.csv|TRACTX.csv", paths, value = TRUE)
  } else if (series == "revocations"){
    paths <- grep("REVOCATIONS", paths, value = TRUE)
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
#' are "core", "bmf", "misc".
#' @param paths character vector. Vector of object keys from S3 bucket.
#' 
#' @return character vector. Links to archived web pages for object keys in paths
make_archive_urls <- function(series,
                              paths){
  
  base_url = sprintf("https://urbaninstitute.github.io/nccs-legacy/dictionary/%s/%s_archive_html/",
                     series,
                     series)
  
  expr_dic = list("core" = "legacy/core/",
                  "bmf" = "legacy/bmf/",
                  "misc" = "legacy/misc/",
                  "soi" = "legacy/soi-micro/[0-9]{4}/")
  
  unavail_url <- "https://urbaninstitute.github.io/nccs/catalogs/dd_unavailable.html"
  
  matches <- gsub(expr_dic[[series]], "", paths)
  matches <- gsub("\\.csv", "", matches)
  
  archive_urls <- paste0(base_url, matches)
  archive_urls <- lapply(archive_urls,
                         function(x)
                           if (RCurl::url.exists(x))
                             x
                         else
                           unavail_url)
  
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
  yyyy <- stringr::str_extract( paths, "\\b(19|20)\\d{2}\\b" )
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
  mm <- stringr::str_extract( paths, "\\b(0|1)\\d{1}\\b" )
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
  
  buttons <- paste0("<a href='",
                    urls,
                    "'",
                    button_dic[[button_name]] )
  return( buttons ) 
}


#' @title Build catalog table for revocations
#' 
#' @description Use the URL from the AWS-NCCSDATA file to construct
#' a table of buttons. 
#' 
#' @param URLS The Url field from AWS-NCCSDATA 
#' 
#' @return character scalar. HTML code to construct button.
get_catalog_revocations <- function( URLS ) {
  
  series <- "raw/revocations"
  series_urls <- grep( series, URLS, value=TRUE )
  
  log_urls <- grep("LOG", series_urls, value = TRUE)
  log_buttons <- make_buttons( urls = log_urls, button_name = "download" )
  
  org_urls <- grep("ORG", series_urls, value = TRUE)
  org_buttons <- make_buttons(urls = org_urls, button_name = "download")
      
  table_urls <- grep("TABLE", series_urls, value = TRUE)
  table_buttons <- make_buttons(urls = table_urls, button_name = "download")
  
  YEAR <- get_year( log_urls )
  MONTH <- get_month( log_urls ) 
  
  catalog <- 
    data.frame( YEAR, MONTH, log_buttons,  
                org_buttons, table_buttons ) %>% 
    arrange( desc(YEAR), desc(MONTH) )
  
  names(catalog) <- 
    c( "Year",
       "Month",
       "Revoked Organizations",
       "Log of Revocations", 
       "Number of Revocations" )
       
  return( catalog )
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

  legacy_url <- "https://urbaninstitute.github.io/nccs-legacy/dictionary/soi/soi_archive_html/"
    
  matches <- gsub("legacy/soi-micro/[0-9]{4}/", "", soi_paths)
  matches <- gsub("\\.csv", "", matches)
  
  legacy_urls <- paste0(legacy_url, matches)
  
  return(legacy_urls)
}
