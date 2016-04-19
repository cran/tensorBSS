\name{tensorStandardize}
\alias{tensorStandardize}

\title{Standardize an Observation Array}
\description{
Standardizes an array of array-valued observations simultaneously from each mode. The method can be seen as a higher-order analogy for the regular multivariate standardization of random vectors.
}
\usage{
tensorStandardize(x)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{Array of an order higher than two with the last dimension corresponding to the sampling units.}
}
\details{
The algorithm first centers the \eqn{n}{n} observed tensors \eqn{X_i}{Xi} to have an element-wise mean of zero. Then it estimates the \eqn{m}{m}th mode covariance matrix \eqn{Cov_m(X) = E(X^{(m)} X^{(m)T})/(p_1 \ldots p_{m-1} p_{m+1} \ldots p_r)}{Cov_m(X) = E(X(m) X(m)^T)/(p1 ... p(m-1) p(m+1) ... pr)}, where \eqn{X^{(m)}}{X(m)} is the centered \eqn{m}{m}-flattening of \eqn{X}{X}, for each mode and transforms the observations with the inverse square roots of the covariance matrices from the corresponding modes.
}
\value{
A list containing the following components: 
\item{x }{Array of the same size as \code{x} containing the standardized observations.}
\item{S }{List containing inverse square roots of the covariance matrices of different modes.}
}
\author{
Joni Virta
}
\examples{
# Generate sample data.
n <- 100
x <- t(cbind(rnorm(n, mean = 0),
             rnorm(n, mean = 1),
             rnorm(n, mean = 2),
             rnorm(n, mean = 3),
             rnorm(n, mean = 4),
             rnorm(n, mean = 5)))
             
dim(x) <- c(3, 2, n)

# Standardize
z <- tensorStandardize(x)$x

# The m-mode covariance matrices of the standardized tensors
mModeCovariance(z, 1)
mModeCovariance(z, 2)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }
\keyword{ array }
