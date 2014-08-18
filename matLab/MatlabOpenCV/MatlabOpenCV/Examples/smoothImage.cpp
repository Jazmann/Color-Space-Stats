/*******************************************************************
 This is a simple MEX file that accepts as inputs an image and the
 size of a Gausian filter(two parameters). Then it applies the filter
 to the image by calling the OpenCV function cvSmooth and returns the 
 filtered image to a matlab variable.
********************************************************************/

#include <cv.h>
#include <highgui.h>
#include <cxcore.h>

#ifndef HAS_OPENCV
#define HAS_OPENCV
#endif

#include "mex.h"
#include "mc_convert.h"
#include "mc_convert.cpp"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,
        const mxArray *prhs[]) {
    
    if (nrhs == 0){
        mexErrMsgTxt("Three arguments are needed for the function");}
    if (nlhs == 0){
        mexErrMsgTxt("Give only one output arguments to the function");}
        
    //Read Matlab image and load it to an IplImage struct
    IplImage* inputImg = mxArr_to_new_IplImage(prhs[0]);
    
    //Read the filter parameters
    double filterHeight, filterWidth;
    mat_to_scalar (prhs[1], &filterHeight);
    mat_to_scalar (prhs[2], &filterWidth);
            
    //smooth the input image and save the result to outputImg
    IplImage* outputImg = cvCloneImage(inputImg);
    cvSmooth(inputImg, outputImg, CV_GAUSSIAN, filterWidth, filterHeight);
    
    //Return output image to mxArray (Matlab matrix)
    plhs[0] = IplImage_to_new_mxArr(outputImg);
    cvReleaseImage(&inputImg);
    cvReleaseImage(&outputImg);
    
}