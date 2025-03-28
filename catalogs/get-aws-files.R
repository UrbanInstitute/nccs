# install.packages( "aws.s3" )
# install.packages( "aws.signature", repos = c(cloudyr = "http://cloudyr.github.io/drat", getOption("repos")))

library( aws.s3 )
library( aws.signature )
library( data.table )
library( lubridate )



# CREATE TOKENS: 
# in windows cmd / powershell:   aws sts get-session-token



mytoken <- 
"xxx"

Sys.setenv("AWS_ACCESS_KEY_ID" = "xxxxxx",
           "AWS_SECRET_ACCESS_KEY" = "xxxxxxx",
           "AWS_DEFAULT_REGION" = "us-east-1",
           "AWS_SESSION_TOKEN" = mytoken )

locate_credentials()





# USE bucketlist() TO RETRIEVE FILE NAMES

#  nccs-data-archive
#  nccs-data-archive-logs
#  nccs-efile
#  nccsdata


dir.create("AWS")
setwd("AWS")



######
######  NCCSDATA
######


buck.list <- 
  get_bucket( bucket = 'nccsdata', max = Inf )

dt <- buck.list %>% rbindlist(fill=TRUE) %>% as.data.frame()

# remove duplicate rows - drop Owner field
# dt$Owner <- as.character( dt$Owner )

keep <- 
  c( "Key", "LastModified", 
     "ETag", "Size", 
     "StorageClass", "Bucket" )

dt <- dt[ keep ]
dt <- unique( dt )

sizemb <- as.character( round( dt$Size / 1000000, 1 ) )
dt$SizeMB <- paste0( sizemb," mb" ) 

dt$URL <- paste0( "https://nccsdata.s3.us-east-1.amazonaws.com/", dt$Key )

write.csv( dt, "catalogs/AWS-NCCSDATA.csv", row.names=F )



######
######  NCCS-EFILE
######


# ORIGINAL EFILE CATALOG
# buck.list <- 
#   get_bucket( 
#     bucket = 'nccs-efile', 
#     prefix="parsed", 
#     max = Inf  )


buck.list <- 
  get_bucket( 
    bucket = 'nccs-efile', 
    prefix="public", 
    max = Inf  )

dt       <- rbindlist( buck.list, fill=TRUE )
dt       <- as.data.frame(dt)
dt$Owner <- as.character( dt$Owner )

# remove duplicate rows - drop Owner field

keep <- 
  c( "Key", "LastModified", "ETag", "Size", 
     "StorageClass", "Bucket" )

dt <- dt[ keep ]
dt <- unique( dt ) 

dt$URL <- paste0( "https://nccs-efile.s3.us-east-1.amazonaws.com/", dt$Key )

write.csv( dt, "AWS-NCCS-EFILE-V2.csv", row.names=F )







