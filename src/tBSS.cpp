#include "tBSS.h"
#include <Rcpp.h>
//#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;


// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
SEXP rnormCubeC(SEXP varp1, SEXP varp2, SEXP varp3) {
  
  int p1 = as<int>(varp1);
  int p2 = as<int>(varp2);
  int p3 = as<int>(varp3);
  
  cube ncube(p1, p2, p3, fill::randn);

  
  return Rcpp::List::create(Rcpp::Named("ncube") = ncube//,
                            //Rcpp::Named("varp1") = p1,
                            //Rcpp::Named("varp2") = p2,
                            //Rcpp::Named("varp3") = p3
                            );
  
}



// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
SEXP eigenVectorsC(SEXP varx) {
  
  mat x = as<mat>(varx);
  
  mat eig_vec;
  vec eig_val;
  
  eig_sym(eig_val, eig_vec, x);
  
  return Rcpp::wrap(fliplr(eig_vec));
}



// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
SEXP symmetricPowerC(SEXP varx, SEXP varr) {
  
  mat x = as<mat>(varx);
  float r = as<float>(varr);
  
  mat eig_vec;
  vec eig_val;
  
  eig_sym(eig_val, eig_vec, x);
  
  mat pow_val = diagmat(pow(sort(eig_val, "descend"), r));
  
  return Rcpp::wrap(fliplr(eig_vec)*pow_val*fliplr(eig_vec).t());
}



// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
SEXP mFOBIMatrixC(SEXP varx) {
  
  cube xcube = as<cube>(varx);
  int rows = xcube.n_rows;
  int cols = xcube.n_cols;
  int slices = xcube.n_slices;
  
  mat matFOBI(rows, rows, fill::zeros);
  
  for (int i = 0; i < slices; i++)
  {
    matFOBI = matFOBI + xcube.slice(i)*xcube.slice(i).t()*xcube.slice(i)*xcube.slice(i).t();
  }
  
  matFOBI = matFOBI/(cols*slices);
  
  return Rcpp::wrap(matFOBI);
}




// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
SEXP mJADEMatrixC(SEXP varx, SEXP vari, SEXP varj, SEXP varcov) {
  
  cube xcube = as<cube>(varx);
  int rows = xcube.n_rows;
  int cols = xcube.n_cols;
  int slices = xcube.n_slices;
  
  float i = as<float>(vari) - 1;
  float j = as<float>(varj) - 1;
  
  int delta = (i == j);
  
  mat cov = as<mat>(varcov);
  
  mat matJADE(rows, rows, fill::zeros);
  
  mat matEij(rows, rows, fill::zeros);
  matEij(i, j) = 1;
  
  arma::mat matEji(rows, rows, fill::zeros);
  matEji(j, i) = 1;
  
  arma::mat matEye(rows, rows);
  matEye.eye();
  
  for (int t = 0; t < slices; t++)
  {
    matJADE = matJADE + dot(xcube.slice(t).row(i), xcube.slice(t).row(j).t())*xcube.slice(t)*xcube.slice(t).t();
  }
  matJADE = matJADE/(cols*slices);
  
  matJADE = matJADE - cov*(matEij + matEji + delta*cols*matEye)*cov;
  
  return Rcpp::wrap(matJADE);
}




// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
SEXP matrixCovarianceC(SEXP varx) {
  
  cube xcube = as<cube>(varx);
  int rows = xcube.n_rows;
  int cols = xcube.n_cols;
  int slices = xcube.n_slices;
  
  mat matCov(rows, rows, fill::zeros);
  
  for (int i = 0; i < slices; i++)
  {
    matCov = matCov + xcube.slice(i)*xcube.slice(i).t();
  }
  
  matCov = matCov/(cols*slices);
  
  return Rcpp::wrap(matCov);
}



// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
SEXP mAutoCovMatrixC(SEXP varx, SEXP varlag) {
  
  cube xcube = as<cube>(varx);
  int rows = xcube.n_rows;
  int cols = xcube.n_cols;
  int slices = xcube.n_slices;
    
  int lag = as<int>(varlag);
	
  mat matAutoCov(rows, rows, fill::zeros);
  
  for (int t = 0; t < (slices - lag); t++)
  {
    matAutoCov = matAutoCov + xcube.slice(t)*xcube.slice(t + lag).t();
  }
  matAutoCov = matAutoCov/(cols*(slices - lag));
   
  return Rcpp::wrap(matAutoCov);
}

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
SEXP mTGFOBIMatrixC(SEXP varx, SEXP varlag) {
  
  cube xcube = as<cube>(varx);
  int rows = xcube.n_rows;
  int cols = xcube.n_cols;
  int slices = xcube.n_slices;
    
  int lag = as<int>(varlag);
	
  mat matTGFOBI(rows, rows, fill::zeros);
  
  for (int t = 0; t < (slices - lag); t++)
  {
    matTGFOBI = matTGFOBI + xcube.slice(t)*xcube.slice(t + lag).t()*xcube.slice(t + lag)*xcube.slice(t).t();
  }
  
  matTGFOBI = matTGFOBI/(cols*(slices - lag));
  
  return Rcpp::wrap(matTGFOBI);
}


// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
SEXP mTGJADEMatrixC(SEXP varx, SEXP vari, SEXP varj, SEXP varlags) {
  
  cube xcube = as<cube>(varx);
  int rows = xcube.n_rows;
  int cols = xcube.n_cols;
  int slices = xcube.n_slices;
  
  float i = as<float>(vari) - 1;
  float j = as<float>(varj) - 1;
 
  vec lags = as<vec>(varlags);
  
  mat matJADE(rows, rows, fill::zeros);
  
  for (int t = 0; t < (slices - lags(1)); t++)
  {
    matJADE = matJADE + dot(xcube.slice(t + lags(0)).row(i), xcube.slice(t + lags(1)).row(j).t())*xcube.slice(t + lags(2))*xcube.slice(t + lags(3)).t();
  }
  matJADE = matJADE/(cols*(slices - lags(1)));
  
  return Rcpp::wrap(matJADE);
}

