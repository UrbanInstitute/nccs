

get_core_paths <- function( paths, tscope="NONPROFIT", fscope="PZ" ) {
  expr <- paste0( "CORE-[0-9]{4}-", tscope )
  matches <- grep( expr, paths, value=T )
  matches <- grep( paste0( "-", fscope, "\\b"), matches, value=T )
  return( matches )
}



get_bmf_paths <- function( paths ) {
  expr <- "BMF-.*-PX"
  matches <- grep( expr, paths, value=T )
  return( matches )
}




make_urls <- function( paths ) {
  base <- "https://nccsdata.s3.us-east-1.amazonaws.com/"
  urls <- paste0( base, paths )
  return( urls )
}




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




get_core_fscope <- function( paths ) {
  expr <- "-P[CXZ]{1}\\b" 
  # expr2 <- "-SCOPE-P.\\b"
  # fscope1 <- stringr::str_extract( paths, expr1 )
  fscope <- stringr::str_extract( paths, expr )
  # fscope  <- na.omit( c( fscope1, tscope2 ) )
  fscope <- gsub( "^-|-$", "", fscope )
  return( as.character(fscope) )
}







make_buttons <- function( urls ) {
  buttons <- 
    paste0( 
      "<a href=",
      urls,
      " class='button'> DOWNLOAD </a>" )
  return( buttons ) 
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


make_buttons <- function( urls ) {
  buttons <- 
    paste0( "<a href=", urls, " class='button'> DOWNLOAD </a>" )
  return( buttons ) 
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


get_legacy_urls <- function(soi_paths){

  legacy_url <- "https://urbaninstitute.github.io/nccs-legacy/dictionary/soi/html/"
    
  matches <- gsub("legacy/soi-micro/[0-9]{4}/", "", soi_paths)
  matches <- gsub("\\.csv", "", matches)
  
  legacy_urls <- paste0(legacy_url, matches)
  
  return(legacy_urls)
}
