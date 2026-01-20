library( knitr )
library( tidyverse )
library( pander )

pc.2022 <- readr::read_csv( "22eoextract990.csv" )
pc.2023 <- readr::read_csv( "23eoextract990.csv" )
pc.2024 <- readr::read_csv( "24eoextract990.csv" )
pf.2022 <- readr::read_csv( "22eoextract990pf.csv" )
pf.2023 <- readr::read_csv( "23eoextract990pf.csv" )
pf.2024 <- readr::read_csv( "24eoextract990pf.csv" )

pc.2022$year <- pc.2022$tax_pd  %>% substr( 1, 4 )
pc.2023$year <- pc.2023$tax_pd  %>% substr( 1, 4 )
pc.2024$year <- pc.2024$tax_pd  %>% substr( 1, 4 )
pf.2022$year <- pf.2022$TAX_PRD %>% substr( 1, 4 )
pf.2023$year <- pf.2023$TAX_PRD %>% substr( 1, 4 )
pf.2024$year <- pf.2024$TAX_PRD %>% substr( 1, 4 )

pc.2024 %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the 2024 Form 990 Dataset" )

pf.2024 %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the 2024 Form 990-PF Dataset" )

pc.2024.subset <- filter( pc.2024, year=="2022" )
pc.2023.subset <- filter( pc.2023, year=="2022" )
pc.2022.subset <- filter( pc.2022, year=="2022" )
pf.2024.subset <- filter( pf.2024, year=="2022" )
pf.2023.subset <- filter( pf.2023, year=="2022" )
pf.2022.subset <- filter( pf.2022, year=="2022" )

pc.2024.subset %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the Subsetted 2024 Form 990 Dataset" )

pf.2024.subset %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the Subsetted 2024 Form 990-PF Dataset" )

names( pc.2024.subset ) <- tolower( names( pc.2024.subset ) )
names( pc.2023.subset ) <- tolower( names( pc.2023.subset ) )
names( pc.2022.subset ) <- tolower( names( pc.2022.subset ) )
names( pf.2024.subset ) <- tolower( names( pf.2024.subset ) )
names( pf.2023.subset ) <- tolower( names( pf.2023.subset ) )
names( pf.2022.subset ) <- tolower( names( pf.2022.subset ) )

pc.2024.subset2 <- 
  pc.2024.subset %>%
  select( ein, payrolltx, compnsatncurrofcr, 
          compnsatnandothr, othrsalwages, 
          pensionplancontrb, othremplyeebenef ) 

pc.2023.subset2 <- 
  pc.2023.subset %>%
  select( ein, payrolltx, compnsatncurrofcr, 
          compnsatnandothr, othrsalwages, 
          pensionplancontrb, othremplyeebenef ) 

pc.2022.subset2 <- 
  pc.2022.subset %>%
  select( ein, payrolltx, compnsatncurrofcr, 
          compnsatnandothr, othrsalwages, 
          pensionplancontrb, othremplyeebenef ) 

pf.2024.subset2 <- 
  pf.2024.subset %>%
  select( ein, compofficers, pensplemplbenf ) 

pf.2023.subset2 <- 
  pf.2023.subset %>%
  select( ein, compofficers, pensplemplbenf )

pf.2022.subset2 <- 
  pf.2022.subset %>%
  select( ein, compofficers, pensplemplbenf ) 

pc <- 
  bind_rows( pc.2024.subset2, 
             pc.2023.subset2, 
             pc.2022.subset2 )
pf <- 
  bind_rows( pf.2024.subset2, 
             pf.2023.subset2,
             pf.2022.subset2)

n_distinct( pc$ein )
nrow( pc )

n_distinct( pf$ein )
nrow( pf )

pc <- pc %>% distinct( ein, .keep_all = TRUE )
pf <- pf %>% distinct( ein, .keep_all = TRUE )

n_distinct( pc$ein )
nrow( pc )

n_distinct( pf$ein )
nrow( pf )

# helpful function for printing large numbers
dollarize <- function(x) 
{ paste0( "$", format( round(x,0), big.mark="," ) ) }

prtax <- sum( pc$payrolltx, na.rm = T )
dollarize( prtax )

salaries <- 
  sum( pc$compnsatncurrofcr,
       pc$compnsatnandothr,
       pc$othrsalwages,
       pc$pensionplancontrb,
       pc$othremplyeebenef, 
       na.rm = T )

dollarize( salaries )

ratio <- prtax / salaries
paste0( 100*round( ratio, 4 ), "%" )

salaries.pf <- 
  sum( pf$compofficers, 
       pf$pensplemplbenf, 
       na.rm = T )

dollarize( salaries.pf )

prtax.pf <- ratio * salaries.pf

dollarize( prtax.pf )

tax.total <- prtax + prtax.pf
dollarize( tax.total )

# According to https://www.bls.gov/data/inflation_calculator.htm,
# a dollar in January 2022 has the same buying power as $1.15 in December 2025,
# which is the latest available data.
( tax.total * 1.15 ) %>% dollarize()
# Result: $75,008,896,816, which rounds to $75 billion