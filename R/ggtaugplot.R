ggtaugplot <- function (x, crit = "gn", type = "l", scales = "free", position = "horizontal",
                        ylab = crit, xlab = "component", main = deparse(substitute(x)), 
                        ...) 
{
  crit <- match.arg(crit, c("gn", "fn", "phin", 
                            "lambda"))
  position <- match.arg(position, c("horizontal", "vertical"))
  switch(crit,
         "fn" = {
           fn <- sapply(x$ResMode,"[[","fn")
           comp <-  sapply(x$ResMode,"[[","comp")
           L <- lengths(fn)
           DF <- data.frame(mode = factor(rep(names(L), L)), comp = unlist(comp, use.names=FALSE), crit = unlist(fn, use.names=FALSE)) 
         },
         "gn" = {
           gn <- sapply(x$ResMode,"[[","gn")
           comp <-  sapply(x$ResMode,"[[","comp")
           L <- lengths(gn)
           DF <- data.frame(mode = factor(rep(names(L), L)), comp = unlist(comp, use.names=FALSE), crit = unlist(gn, use.names=FALSE)) 
         },
         "phin" = {
           phin <- sapply(x$ResMode,"[[","phin")
           comp <-  sapply(x$ResMode,"[[","comp")
           L <- lengths(phin)
           DF <- data.frame(mode = factor(rep(names(L), L)), comp = unlist(comp, use.names=FALSE), crit = unlist(phin, use.names=FALSE)) 
         },
         "lambda" = {
           lambda <- sapply(x$ResMode,"[[","lambda")
           comp <-  sapply(x$ResMode,"[[","comp")
           comp <- lapply(comp, function(x) x[-2])
           L <- lengths(lambda)
           DF <- data.frame(mode = factor(rep(names(L), L)), comp = unlist(comp, use.names=FALSE), crit = unlist(lambda, use.names=FALSE)) 
         }
  )
  
  
  crit <- match.arg(crit, c("gn", "fn", "phin", "lambda"))
  type <- ifelse(type == "l", 1, 0)
  
  if(position == "horizontal"){
    ggplot(DF, aes(x = comp, y = crit)) + 
      geom_point() +
      geom_line(alpha = type) +
      facet_wrap(. ~  mode, scales = scales, ncol = length(x$AllSigHat2)) +
      labs(x = xlab, y = ylab, title = main) +
      ggtitle(main) + 
      theme_bw() +
      theme(plot.title = element_text(hjust = 0.5), panel.spacing = unit(1, "lines"))
  }
  else if(position == "vertical"){
    ggplot(DF, aes(x = comp, y = crit)) + 
      geom_point() +
      geom_line(alpha = type) +
      facet_wrap(mode ~ ., scales = scales, nrow = length(x$AllSigHat2)) +
      labs(x = xlab, y = ylab, title = main) +
      ggtitle(main) + 
      theme_bw() +
      theme(plot.title = element_text(hjust = 0.5), panel.spacing = unit(1, "lines"))
  }
  
}

