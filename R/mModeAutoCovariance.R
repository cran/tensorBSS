mModeAutoCovariance <-
function(x, m, lag, center = TRUE, normalize = TRUE){
  if(center == TRUE) x <- tensorCentering(x)
  xm <- mFlatten(x, m)
  normalize_int <- normalize*1
  mAutoCovMatrix(xm, lag, normalize_int)
}
