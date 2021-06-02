\name{mFlatten}
\alias{mFlatten}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Flattening an Array Along One Mode
}
\description{
Reshapes a higher order array (tensor) into a matrix with a process known as m-mode flattening or matricization.
}
\usage{
mFlatten(x, m)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
an \eqn{(r + 1)}-dimensional array with \eqn{r \geq 2}{r >= 2}. The final mode is understood to correspond to the observations (i.e., its length is usually the sample size n). 
}
  \item{m}{
an integer between \eqn{1} and \eqn{r} signifying the mode along which the array should be flattened. Note that the flattening cannot be done w.r.t. the final \eqn{(r + 1)}th mode.
}
}

\details{
If the original tensor \code{x} has the size \eqn{p_1 \times \cdots \times p_r \times n}{p_1 x ... x p_r x n}, then \code{mFlatten(x, m)} returns tensor of size \eqn{p_m \times p_1 \cdots p_{m - 1} p_{m + 1} \cdots p_r \times n}{p_m x p_1 ... p_{m - 1} p_{m + 1} ... p_r x n} obtained by gathering all \eqn{m}-mode vectors of \code{x} into a wide matrix (an \eqn{m}-mode vector of \code{x} is any vector of length \eqn{p_m} obtained by varying the \eqn{m}th index and holding the other indices constant).
}

\value{
The \eqn{m}-mode flattened 3rd order tensor of size \eqn{p_m \times p_1 \cdots p_{m - 1} p_{m + 1} \cdots p_r \times n}{p_m x p_1 ... p_{m - 1} p_{m + 1} ... p_r x n}.
}

\author{
Joni Virta
}


%\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
\examples{
n <- 10
x <- t(cbind(rnorm(n, mean = 0),
             rnorm(n, mean = 1),
             rnorm(n, mean = 2),
             rnorm(n, mean = 3),
             rnorm(n, mean = 4),
             rnorm(n, mean = 5)))
             
dim(x) <- c(3, 2, n)

dim(mFlatten(x, 1))
dim(mFlatten(x, 2))
}
\keyword{ utilities }
\keyword{ array }
