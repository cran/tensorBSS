\name{tPCAaug}
\alias{tPCAaug}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Order Determination for Tensorial PCA Using Augmentation 
}
\description{
In a tensorial PCA context the dimensions of a core tensor are estimated based on augmentation of additional noise components. Information from both eigenvectors and eigenvalues are then used to obtain the dimension estimates.
}
\usage{
tPCAaug(x, noise = "median", naug = 1, nrep = 1, 
  sigma2 = NULL, alpha = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
array of an order at least three with the last dimension corresponding to the sampling units.
}
  \item{noise}{
specifies how to estimate the noise variance. Can be one of  
\code{"median"}, \code{"quantile"}, \code{"last"}, \code{"known"}. Default is \code{"median"}. 
See details for further information.
}
  \item{naug}{
number of augmented variables in each mode.  Default is 1.
}
  \item{nrep}{
number of repetitions for the augmentation. Default is 1.
}
  \item{sigma2}{
if \code{noise = "known"} the value of the noise variance.
}
  \item{alpha}{
if \code{noise = "quantile"} this specifies the quantile to be used.
}
}
\details{
For simplicity details are given for matrix valued observations.

Assume having a sample of \eqn{p_1 \times p_2}{p_1 x p_2} matrix-valued observations which are realizations of the model
\eqn{X = U_L Z U_R'+ N},
where \eqn{U_L} and \eqn{U_R} are matrices with orthonormal columns, \eqn{Z} is the random, zero mean \eqn{k_1 \times k_2}{k_1 x k_2} core matrix with \eqn{k_1 \leq p_1}{k_1 <= p_1} and \eqn{k_2 \leq p_2}{k_2 <= p_2}. 
\eqn{N} is \eqn{p_1 \times p_2}{p_1 x p_2} matrix-variate noise that follows a matrix variate spherical distribution with \eqn{E(N) = 0} and \eqn{E(N N') = \sigma^2 I_{p_1}}{E(N N') = sigma^2 I_p_1} and is independent from \eqn{Z}. The goal is to estimate \eqn{k_1} and \eqn{k_2}. For that purpose the eigenvalues and eigenvectors of the left and right covariances are used. To evaluate the variation in the eigenvectors, in each mode the matrix \eqn{X} is augmented with \code{naug} normally distributed components appropriately scaled by noise standard deviation. The procedure can be repeated \code{nrep} times to reduce random variation in the estimates. 


The procedure needs an estimate of the noise variance and four options are available via the argument \code{noise}:

 \enumerate{
    \item \code{noise = "median"}: Assumes that at least half of components are noise and uses thus the median of the pooled and scaled eigenvalues as an estimate.
    \item \code{noise = "quantile"}: Assumes that at least  100 \code{alpha} \% of the components are noise and uses the mean of the lower \code{alpha} quantile of the pooled and scaled eigenvalues from all modes as an estimate.
    \item \code{noise = "last"}: Uses the pooled information from all modes and then the smallest eigenvalue as estimate.
    \item \code{noise = "known"}: Assumes the error variance is known and needs to be provided via \code{sigma2}. 
  }



}
\value{
A list of class `taug` inheriting from class `tladle` and containing:
  \item{U}{list containing the modewise rotation matrices.}
  \item{D}{list containing the modewise eigenvalues.}
  \item{S}{array of the same size as \code{x} containing the principal components.}
  \item{ResMode}{a list with the modewise results which are lists containing:
  \describe{
  \item{mode}{label for the mode.}
  \item{k}{the order estimated for that mode.}
  \item{fn}{vector giving the measures of variation of the eigenvectors.}
  \item{phin}{normalized eigenvalues.}
  \item{lambda}{the unnormalized eigenvalues used to compute phin.}
  \item{gn}{the main criterion augmented order estimator.}
  \item{comp}{vector from 0 to the number of dimensions to be evaluated.}
  }}
  \item{xmu}{the data location}
  \item{data.name}{string with the name of the input data}
  \item{method}{string \code{tPCA}.}
  \item{Sigma2}{estimate of standardized sigma2 from the model described above or the standardized provided value. Sigma2 is the estimate for the variance of individual entries of \code{N}.}
  \item{AllSigHat2}{vector of noise variances used for each mode.}
  }

\references{
\cite{Radojicic, U., Lietzen, N., Nordhausen, K. and Virta, J. (2021): Dimension Estimation in Two-Dimensional PCA. In S. Loncaric, T. Petkovic and D. Petrinovic (editors) "Proceedings of the 12 International Symposium on Image and Signal Processing and Analysis (ISPA 2021)", 16-22. \doi{10.1109/ISPA52656.2021.9552114}.}

\cite{Radojicic, U., Lietzen, N., Nordhausen, K. and Virta, J. (2022): Order Determination for Tensor-valued Observations Using Data Augmentation. <arXiv:2207.10423>.}
}

\author{
Klaus Nordhausen, Una Radojicic
}



\seealso{
\code{\link{tPCA}}, \code{\link{tPCAladle}}
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
# Dimension should be 3 and 2 and (close to) sigma2 0.36
TEST

# Noise variance in i-th mode is equal to Sigma2 multiplied by the product 
# of number of colums of all modes except i-th one

TEST$Sigma2*c(8,12)
# This is returned as
TEST$AllSigHat2

# higher order tensor example

Z2 <- rnorm(n*3*2*4*10)

dim(Z2) <- c(3,2,4,10,n)

U2.1 <- rorth(12)[ ,1:3]
U2.2 <- rorth(8)[ ,1:2]
U2.3 <- rorth(5)[ ,1:4]
U2.4 <- rorth(20)[ ,1:10]

U2 <- list(U1 = U2.1, U2 = U2.2, U3 = U2.3, U4 = U2.4)
Y2 <- tensorTransform2(Z2, U2, 1:4)
EPS2 <- array(rnorm(12*8*5*20*n, mean=0, sd=sig), dim=c(12, 8, 5, 20, n))
X2 <- Y2 + EPS2


TEST2 <- tPCAaug(X2, noise = "quantile", alpha =0.3)
TEST2
}
\keyword{multivariate}
\keyword{array}
