#include <RcppArmadillo.h>

RcppExport SEXP rnormCubeC(SEXP varp1, SEXP varp2, SEXP varp3);
RcppExport SEXP eigenVectorsC(SEXP varx);
RcppExport SEXP symmetricPowerC(SEXP varx, SEXP varr);
RcppExport SEXP mFOBIMatrixC(SEXP varx);
RcppExport SEXP mJADEMatrixC(SEXP varx, SEXP vari, SEXP varj, SEXP varcov);
RcppExport SEXP matrixCovarianceC(SEXP varx);
RcppExport SEXP mAutoCovMatrixC(SEXP varx, SEXP varlag);
RcppExport SEXP mTGFOBIMatrixC(SEXP varx, SEXP varlag);
RcppExport SEXP mTGJADEMatrixC(SEXP varx, SEXP vari, SEXP varj, SEXP varlags);
