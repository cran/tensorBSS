\name{ggtaugplot}
\alias{ggtaugplot}

\title{
Augmentation plot for each mode of an object of class taug using ggplot2
}
\description{
The augmentation plot is a measure for deciding about the number of interesting components. Of interest for the augmentation plot, which is quite similar to the ladle plot, is the minimum.
The function offers, however, also the possibility to plot other criterion values that combined make up the actual criterion. 
}
\usage{
ggtaugplot(x, crit = "gn", type = "l", scales = "free", position = "horizontal",
  ylab = crit, xlab = "component", main = deparse(substitute(x)),  ...)
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{an object of class taug.}
  \item{crit}{the criterion to be plotted, options are \code{"gn"}, \code{"fn"}, \code{"phin"} and \code{"lambda"}.}
  \item{type}{plotting type, either lines \code{l} or points \code{p}.}
  \item{position}{placement of augmentation plots for separate modes, options are \code{"horizontal"} and \code{"vertical"}.}
  \item{scales}{determines whether the x- and y-axis scales are shared or allowed to vary freely across the subplots. The options are: both axes are free (the default, \code{"free"}), x-axis is free (\code{"free_x"}), y-axis is free (\code{"free_y"}), neither is free (\code{"fixed"}).}
  \item{ylab}{default ylab value.}
  \item{xlab}{default xlab value.}
  \item{main}{default title.}
  \item{\dots}{other arguments for the plotting functions.}
}
\details{
The main criterion of the augmentation criterion is the scaled sum of the eigenvalues and the measure of variation of the eigenvectors up to the component of interest.

The sum is denoted \code{"gn"} and the individual parts are \code{"fn"} for the measure of the eigenvector variation and \code{"phin"} for the scaled eigenvalues.
The last option \code{"lambda"} corresponds to the unscaled eigenvalues yielding then a screeplot.

The plot is drawn separately for each mode of the data.
}

\references{
\cite{Radojicic, U., Lietzen, N., Nordhausen, K. and Virta, J. (2021), On order determinaton in 2D PCA. Manuscript.}
}


\author{
Klaus Nordhausen, Joni Virta, Una Radojicic
}

\seealso{
\code{\link{tPCAaug}}
}
\examples{
library(ICtest)


# matrix-variate example
n <- 200
sig <- 0.6

Z <- rbind(sqrt(0.7)*rt(n,df=5)*sqrt(3/5),
           sqrt(0.3)*runif(n,-sqrt(3),sqrt(3)),
           sqrt(0.3)*(rchisq(n,df=3)-3)/sqrt(6),
           sqrt(0.9)*(rexp(n)-1),
           sqrt(0.1)*rlogis(n,0,sqrt(3)/pi),
           sqrt(0.5)*(rbeta(n,2,2)-0.5)*sqrt(20)
)

dim(Z) <- c(3, 2, n)

U1 <- rorth(12)[,1:3]
U2 <- rorth(8)[,1:2]
U <- list(U1=U1, U2=U2)
Y <- tensorTransform2(Z,U,1:2)
EPS <- array(rnorm(12*8*n, mean=0, sd=sig), dim=c(12,8,n))
X <- Y + EPS


TEST <- tPCAaug(X)
TEST
ggtaugplot(TEST)

# higher order tensor example

Z2 <- rnorm(n*3*2*4*6)

dim(Z2) <- c(3,2,4,6,n)

U2.1 <- rorth(10)[ ,1:3]
U2.2 <- rorth(8)[ ,1:2]
U2.3 <- rorth(5)[ ,1:4]
U2.4 <- rorth(15)[ ,1:6]

U2 <- list(U1 = U2.1, U2 = U2.2, U3 = U2.3, U4 = U2.4)
Y2 <- tensorTransform2(Z2, U2, 1:4)
EPS2 <- array(rnorm(10*8*5*15*n, mean=0, sd=sig), dim=c(10, 8, 5, 15, n))
X2 <- Y2 + EPS2


TEST2 <- tPCAaug(X2)
ggtaugplot(TEST2, crit = "lambda", position = "vertical",
 scales = "free_x")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ hplot }% use one of  RShowDoc("KEYWORDS")
