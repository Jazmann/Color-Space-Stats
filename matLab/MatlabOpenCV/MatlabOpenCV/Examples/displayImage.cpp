/*******************************************************************
This is a simple MEX file. It just calls OpenCV functions for loading,
smothing and diaplaying the results
********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <cv.h>
#include <highgui.h>
#include "mex.h"

int smoothImage(char* filename){
    //load the image
    IplImage* img = cvLoadImage(filename);
    if(!img){
            printf("Cannot load image file: %s\n",filename);
            return -1;}
    //create another image
    IplImage* img_smooth = cvCloneImage(img);
    //smooth the image img and save the result to img_smooth
    cvSmooth(img, img_smooth, CV_GAUSSIAN, 5, 5);
    // create windows to show images
    cvNamedWindow("Original Image", CV_WINDOW_AUTOSIZE);
    cvMoveWindow("Original Image", 100, 100);
    cvNamedWindow("Smoothed Image", CV_WINDOW_AUTOSIZE);
    cvMoveWindow("Smoothed Image", 400, 400);
    // show the images
    cvShowImage("Original Image", img );
    cvShowImage("Smoothed Image", img_smooth );
    // wait for a key
    cvWaitKey(0);
    //destroy windows
    cvDestroyWindow("Original Image");
    cvDestroyWindow("Smoothed Image");
    //release images
    cvReleaseImage(& img);
    cvReleaseImage(& img_smooth);
    return 0;};
    
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]){
    if (nrhs != 0){
        mexErrMsgTxt("Do not give input arguments.");}
    if (nlhs != 0){
        mexErrMsgTxt("Do not give output arguments.");}
    char *name = "cameraman.png";
    smoothImage(name);}