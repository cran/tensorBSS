tPCAaug <- function(x, noise = "median", naug = 1, nrep = 1, sigma2=NULL, alpha=NULL)
{
  data.name <- deparse(substitute(x))
  method <- "tPCA"
  noise <- match.arg(noise, c("median", "quantile", "last", "known"))
  r <- length(dim(x)) - 1
  pr <- dim(x)[1:r]
  pr1 <- pr
  pr1[1]  <- 1
  xmu <- apply(x, 1:r, mean)
  x <- tensorCentering(x)
  U <- vector("list", r)
  Ds <- vector("list", r)
  D <- vector("list", r)
  ResMode <- vector("list", r)
  names(ResMode) <- paste0("Mode", 1:r)
  n <- dim(x)[r+1]
  
  for (m in 1:r) {
    mCov <- mModeCovariance(x, m, center = FALSE, normalize = FALSE)
    mEig <- eigen(mCov, symmetric = TRUE)
    U[[m]] <- mEig$vectors
    D[[m]] <- mEig$values
    Ds[[m]] <- mEig$values * pr[m] / pr[1]
  }
  
  AllScaledSig2 <- unlist(Ds)
  
  SigHat2 <- switch(noise,
                    median = median(AllScaledSig2),
                    last = min(AllScaledSig2),
                    quantile = { if (is.null(alpha)) stop("'alpha' must be numeric")
                      cut <- quantile(AllScaledSig2, probs = alpha)
                      mean(AllScaledSig2[AllScaledSig2 <=  cut]) },
                    known = ifelse(is.null(sigma2), 
                                   stop("'sigma2' must be numeric"), 
                                   sigma2)
  )
  
  AllSigHat2 <- numeric(r)
  
  
  for (m in 1:r) {
    
    mSigHat2 <- pr[1]/pr[m] * SigHat2
    AllSigHat2[m] <-  mSigHat2
    mSigHat <- sqrt(mSigHat2)
    
    LAMBDA <- (D[[m]]-mSigHat2)
    
    LAMBDA[LAMBDA < 0] <- 0
    if(nrep==1){
      Xm <- mFlatten(x,m)
      dXm <- dim(Xm)
      p <- dXm[1]
      q <- dXm[2]
      XSm <- array(rnorm(q * naug * n, 0, sd = mSigHat/sqrt(q)), 
                   dim = c(naug, q, n))
      XSm <- tensorCentering(XSm)
      XmAUG <- abind(Xm, XSm, along = 1)
      Mj <- mModeCovariance(XmAUG, 1, center = FALSE, normalize = FALSE) - diag(mSigHat2, nrow = p + naug)
      EigJ <- eigen(Mj, symmetric = TRUE)
      EigJs <- EigJ$vectors[-(1:p), , drop = FALSE]
      EigJsNorms <- colSums(EigJs^2)
    } else {
      EigJjNorms <- matrix(0, nrow = nrep, ncol = dim(x)[m] + naug)
      Xm <- mFlatten(x,m)
      dXm <- dim(Xm)
      p <- dXm[1]
      q <- dXm[2]
      
      for (j in (1:nrep))
      {
        XSm <- array(rnorm(q * naug * n, 0, sd = mSigHat/sqrt(q)), 
                     dim = c(naug, q, n))
        XSm <- tensorCentering(XSm)
        XmAUG <- abind(Xm, XSm, along = 1)
        Mj <- mModeCovariance(XmAUG, 1, center = FALSE, normalize = FALSE) - diag(mSigHat2, nrow = p + naug)
        EigJ <- eigen(Mj, symmetric = TRUE)
        EigJs <- EigJ$vectors[-(1:p), , drop = FALSE]
        EigJjNorms[j,] <- colSums(EigJs^2)
      }
      EigJsNorms <- colMeans(EigJjNorms)
    }
    
    LAMBDA2 <- c(LAMBDA,0)
    
    # fn: measure of variation of augmented eigenvectors
    fn <- (cumsum(c(0, EigJsNorms)))[1:(p+1)] 
    # phin: normalized eigenvalues
    phin <- (LAMBDA2/cumsum(LAMBDA2))[1:(p+1)] 
    # combined info
    gn <- fn + phin
    est.k <- which.min(gn) - 1
    ResMode[[m]] <- list(mode = paste("Mode", m), 
                         k = est.k, fn = fn, 
                         phin = phin, lambda = D[[m]],
                         gn = gn, comp = 0:p)
    
  }
  
  s <- tensorTransform2(x, U, 1:r, transpose = TRUE)
  RES <- list(U = U, D = D, S = s, ResMode = ResMode, xmu = xmu, 
              data.name = data.name, method = method, 
              Sigma2 = SigHat2/prod(pr[-1]), AllSigHat2=AllSigHat2)
  class(RES) <- c("taug","tladle")
  RES
}
