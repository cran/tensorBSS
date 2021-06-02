print.taug <-
function (x, ...) 
{
  cat("The tensorial augmentation based on", x$method, "gives for the data set", 
      x$data.name, "the dimension estimates:\n")
  print(sapply(x$ResMode, function(x) x$k))
  cat("The estimate for the standardized error variance is:\n") 
  print(x$Sigma2)
}
