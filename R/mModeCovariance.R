mModeCovariance <-
function(x, m, center = TRUE, normalize = TRUE){
  if(center == TRUE) x <- tensorCentering(x)
  xm <- mFlatten(x, m)
  normalize_int <- normalize*1
  matrixCovariance(xm, normalize_int)
}
