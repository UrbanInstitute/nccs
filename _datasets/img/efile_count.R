
library( irs990efile )
library( dplyr )
# EFILER COUNTS
options( timeout = 600 ) # allows 10 minutes before timeout for large files                      
index <- irs990efile::get_current_index_full()
t <- table( index$TaxYear, index$FormType ) 
t |> format( big.mark="," ) |> knitr::kable( align="r" )

f9 <- dplyr::filter( index, FormType == "990" & TaxYear > 2008 )
ez <- dplyr::filter( index, FormType == "990EZ" & TaxYear > 2008)
pf <- dplyr::filter( index, FormType == "990PF" & TaxYear > 2008)

t1 <- table( f9$TaxYear ) |> as.data.frame(stringsAsFactors=F)
t2 <- table( ez$TaxYear ) |> as.data.frame(stringsAsFactors=F)
t3 <- table( pf$TaxYear ) |> as.data.frame(stringsAsFactors=F)

par( mfrow=c(1,3), mar=c(3,2,5.2,2) )

plot( 
  t1$Var1, t1$Freq, 
  pch=19, cex=2, 
  type="b", bty="n",
  xlab="", ylab="",
  yaxt="n",
  main="990 RETURNS",
  cex.main=2.5, cex.axis=1.5,
  xlim=c(2010,2024),
  ylim=c(t1$Freq[1],1.2*max(t1$Freq) ) )

text(  
  t1$Var1, t1$Freq,
  paste0(round(t1$Freq/1000,0),"k"),
  cex=1.2, pos=3, offset=1.3 )

plot( 
  t2$Var1, t2$Freq, 
  pch=19, cex=2, 
  type="b", bty="n",
  xlab="", ylab="",
  yaxt="n",
  main="990EZ RETURNS",
  cex.main=2.5, cex.axis=1.5,
  xlim=c(2010,2024),
  ylim=c(t2$Freq[1],1.2*max(t2$Freq) ) )

text(  
  t2$Var1, t2$Freq,
  paste0(round(t2$Freq/1000,0),"k"),
  cex=1.2, pos=3, offset=1.3 )

plot( 
  t3$Var1, t3$Freq, 
  pch=19, cex=2, 
  type="b", bty="n",
  xlab="", ylab="",
  yaxt="n",
  main="990PF RETURNS",
  cex.main=2.5, cex.axis=1.5,
  xlim=c(2010,2024),
  ylim=c(t3$Freq[1],1.2*max(t3$Freq) ) )

text(  
  t3$Var1, t3$Freq,
  paste0(round(t3$Freq/1000,0),"k"),
  cex=1.2, pos=3, offset=1.3 )

