#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP tensorBSS_eigenVectors(SEXP);
extern SEXP tensorBSS_matrixCovariance(SEXP);
extern SEXP tensorBSS_mAutoCovMatrix(SEXP, SEXP);
extern SEXP tensorBSS_mFOBIMatrix(SEXP);
extern SEXP tensorBSS_mJADEMatrix(SEXP, SEXP, SEXP, SEXP);
extern SEXP tensorBSS_mTGFOBIMatrix(SEXP, SEXP);
extern SEXP tensorBSS_mTGJADEMatrix(SEXP, SEXP, SEXP, SEXP);
extern SEXP tensorBSS_rnormCube(SEXP, SEXP, SEXP);
extern SEXP tensorBSS_symmetricPower(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"tensorBSS_eigenVectors",     (DL_FUNC) &tensorBSS_eigenVectors,     1},
  {"tensorBSS_matrixCovariance", (DL_FUNC) &tensorBSS_matrixCovariance, 1},
  {"tensorBSS_mAutoCovMatrix",   (DL_FUNC) &tensorBSS_mAutoCovMatrix,   2},
  {"tensorBSS_mFOBIMatrix",      (DL_FUNC) &tensorBSS_mFOBIMatrix,      1},
  {"tensorBSS_mJADEMatrix",      (DL_FUNC) &tensorBSS_mJADEMatrix,      4},
  {"tensorBSS_mTGFOBIMatrix",    (DL_FUNC) &tensorBSS_mTGFOBIMatrix,    2},
  {"tensorBSS_mTGJADEMatrix",    (DL_FUNC) &tensorBSS_mTGJADEMatrix,    4},
  {"tensorBSS_rnormCube",        (DL_FUNC) &tensorBSS_rnormCube,        3},
  {"tensorBSS_symmetricPower",   (DL_FUNC) &tensorBSS_symmetricPower,   2},
  {NULL, NULL, 0}
};

void R_init_tensorBSS(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
