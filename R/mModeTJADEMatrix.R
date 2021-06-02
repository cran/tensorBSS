mModeTJADEMatrix <-
function(x, m, i, j){
  xm <- mFlatten(x, m)
  matCov <- matrixCovariance(xm, 1)
  mJADEMatrix(xm, i, j, matCov)
}
