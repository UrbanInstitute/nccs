blue   <- "#73bfe2"
yellow <- "#fdd870"



squarit <- function( x, y, prob, lw, yellow )
{
  
  scale.x <- 1 - rnorm( 1, 0, 0.2 )
  scale.y <- 1 - rnorm( 1, 0, 0.2 )
  
  width.x <- seq( from=0, to=1, length.out=50 ) * scale.x
  width.y <- seq( from=0, to=1, length.out=50 ) * scale.y
  
  center.x <- 0.5 + rnorm( 1, 0, 0.1 )
  center.y <- 0.5 + rnorm( 1, 0, 0.1 )
  
  move.x <- cumsum( rnorm(50,0,0.01) )
  move.y <- cumsum( rnorm(50,0,0.01) )

  xleft   <- center.x - width.x/2 + move.x
  xright  <- center.x + width.x/2 + move.x
  ybottom <- center.y - width.y/2 + move.y
  ytop    <- center.y + width.y/2 + move.y
  
  xleft[     xleft > 0.95 ] <- 0.95
  xright[   xright > 0.95 ] <- 0.95
  ybottom[ ybottom > 0.95 ] <- 0.95
  ytop[       ytop > 0.95 ] <- 0.95
  
  xleft[     xleft < 0.05 ] <- 0.05
  xright[   xright < 0.05 ] <- 0.05
  ybottom[ ybottom < 0.05 ] <- 0.05
  ytop[       ytop < 0.05 ] <- 0.05
  
  # prob <- 0.05
  tf <- rep( c(T,F), times=c(100*prob,100*(1-prob)) )
  keep <- sample( tf, 50 )
  
  xleft   <- xleft[ keep ]   + x
  xright  <- xright[ keep ]  + x
  ybottom <- ybottom[ keep ] + y
  ytop    <- ytop[ keep ]    + y
  
  lw.scale <- 1+(cumsum( rnorm( 50, 0, 0.02 ) ))[keep]
  lw.scale[ lw.scale < 0.7 ] <- 0


  rect( xleft, ybottom, 
        xright, ytop, 
        border=yellow, lwd=lw*lw.scale )

  # rect( xleft, ybottom, 
  #      xright, ytop, 
  #      border=yellow, lwd=0.01 )

}

squarit( x=1, y=0, prob=0.1, lw=1, yellow )



makeTransparent <-function( someColor, alpha=100 )
{
  newColor <- col2rgb(someColor)
  apply( newColor, 2, function(curcoldata){rgb(red=curcoldata[1], green=curcoldata[2],
    blue=curcoldata[3],alpha=alpha, maxColorValue=255)})
}

makeTransparent( blue )


buildit <- function( 
    x=9, y=6, p=0.1, lw=0.1, 
    blue, yellow, 
    savepng=F, fn="tileart.png" )
{
  
  if( savepng )
  {
    png( filename = fn,
         width = 540, height = 360, units = "px", 
         pointsize = 4, res = 1600 ) 
  }

  
  numx <- x
  numy <- y
  
  par( bg = blue )   # "#12719e"
  par( mar=c(0.1,0.1,0.1,0.1) )
  plot.new()
  plot.window( xlim=c( 0, numx ), ylim=c( 0, numy ) )
  # box( col="#fdbf11" )
  
  # rect( xleft=0, ybottom=0, 
  #       xright=numx, ytop=numy, 
  #       border=yellow, lwd=0 )
  
  for( i in 0:(numx-1) )
  {
    for( j in 0:(numy-1) )
    {
      squarit( x=i, y=j, prob=p, lw=lw, yellow ) 
    }
  }
  
  if( savepng ){ dev.off() } 
  
}





blue <- "#1273A1"
yellow <- "#fdd870"


blue   <- "#73bfe2"
yellow <- "#fdd870"

yellow <- "#fce39e"
# yellow <- "#fff2cf"


buildit( x=6, y=4, p=0.2, lw=3, blue=blue, yellow=yellow )



for( i in 1:20 )
{
  
  fn <- paste0( "dataset-placeholder-", i, ".png" )
  x <- sample( 4:12, 1 )
  y <- sample( 3:8, 1 )
  scale.p <- 20/(x*y) + rnorm( 1, 0, 2.5/(x*y) )
  scale.lw <- 1 + 15/(x*y) - 18^2/(x*y)^2
  
  buildit( 
    x=x, y=y, 
    p=0.1*scale.p, 
    lw=0.3*scale.lw, 
    fn=fn, 
    savepng=T,
    blue=blue,
    yellow=yellow )
  
}


