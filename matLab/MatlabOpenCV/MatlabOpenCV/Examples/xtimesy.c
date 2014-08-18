#include "mex.h"                // Matlab mex header file

// C function multiply arrays x and y (of size) to give z
void xtimesy(int size, double x[],double y[], double z[])
{
 int i;
 for(i=0; i<size; i++)
  z[i] = x[i]*y[i];
}

// MEX interface function
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double *x,*y, *z;
  int i, size;

  // check number of input parameters is 3
  if(nrhs!=3) { mexErrMsgTxt("Three  inputs required.");   }
  else
      // check number of output parameters is 1
      if(nlhs>1) { mexErrMsgTxt("Too many  output arguments"); }
    plhs[0] = mxCreateDoubleMatrix(1,1, mxREAL);

  size= *mxGetPr(prhs[0]);                              // get size of arrays
  x = mxGetPr(prhs[1]);                                 // pointer to input array 1
  y = mxGetPr(prhs[2]);                                 // pointer to input array 2
  plhs[0] = mxCreateDoubleMatrix( 1 ,  size, mxREAL);   // allocate output array
  z = mxGetPr(plhs[0]);                                 // pointer to output array
  mexPrintf("array size %d\n", size, mxGetN(prhs[1]));

  xtimesy(size, x,y,z);                  // call C fuction to multiply arrays

  mexPrintf("result z = ");
  for( i=0; i<size; i++)                 // print the result
     mexPrintf(" %f", (float) z[i]);
}


