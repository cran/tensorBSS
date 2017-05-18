\name{tNSS.SD}
\alias{tNSS.SD}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
NSS-SD Method for Tensor-Valued Time Series
}
\description{
Estimates the non-stationary sources of a tensor-valued time series using separation information contained in two time intervals.
}
\usage{
tNSS.SD(x, n.cuts = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{Numeric array of an order at least two. It is assumed that the last dimension corresponds to the sampling units.}
  \item{n.cuts}{Either a 3-vector of interval cutoffs (the cutoffs are used to define the two intervals that are open below and closed above, e.g. \eqn{(a, b]}) or \code{NULL} (the time range is sliced into two parts of equal size).}
}
\details{
Assume that the observed tensor-valued time series comes from a tensorial BSS model where the sources have constant means over time but the component variances change in time. Then TNSS-SD estimates the non-stationary sources by dividing the time scale into two intervals and jointly diagonalizing the covariance matrices of the two intervals within each mode.
}
\value{
A list with class 'tbss', inheriting from class 'bss', containing the following components: 
\item{S}{Array of the same size as x containing the independent components.}
\item{W}{List containing all the unmixing matrices.}
\item{EV}{Eigenvalues obtained from the joint diagonalization.}
\item{n.cuts}{The interval cutoffs.}
\item{Xmu}{The data location.}
\item{datatype}{Character string with value "ts". Relevant for \code{\link{plot.tbss}}.}
}
\references{
\cite{Virta J., Nordhausen K. (2017): Blind source separation for nonstationary tensor-valued time series, \emph{submitted}, \bold{???},  ???--???.}
}
\author{
Joni Virta
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link[JADE]{NSS.SD}}, \code{\link[JADE]{NSS.JD}}, \code{\link[JADE]{NSS.TD.JD}}, \code{tNSS.JD}, \code{tNSS.TD.JD}
}

\examples{
# Create innovation series with block-wise changing variances
n1 <- 200
n2 <- 500
n3 <- 300
n <- n1 + n2 + n3
innov1 <- c(rnorm(n1, 0, 1), rnorm(n2, 0, 3), rnorm(n3, 0, 5))
innov2 <- c(rnorm(n1, 0, 1), rnorm(n2, 0, 5), rnorm(n3, 0, 3))
innov3 <- c(rnorm(n1, 0, 5), rnorm(n2, 0, 3), rnorm(n3, 0, 1))
innov4 <- c(rnorm(n1, 0, 5), rnorm(n2, 0, 1), rnorm(n3, 0, 3))

# Generate the observations
vecx <- cbind(as.vector(arima.sim(n = n, list(ar = 0.8), innov = innov1)),
              as.vector(arima.sim(n = n, list(ar = c(0.5, 0.1)), innov = innov2)),
              as.vector(arima.sim(n = n, list(ma = -0.7), innov = innov3)),
              as.vector(arima.sim(n = n, list(ar = 0.5, ma = -0.5), innov = innov4)))
             
# Vector to tensor
tenx <- t(vecx)
dim(tenx) <- c(2, 2, n)

# Run TNSS-SD
res <- tNSS.SD(tenx)
res$W
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{multivariate}
\keyword{array}
