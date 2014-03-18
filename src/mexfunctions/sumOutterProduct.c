#include "mex.h"
#include <string.h>
#include <stdio.h>
void outerProduct(double* x, double* y,int index, int numRow,mwIndex* ir_X, mwIndex* jc_X, mwIndex* ir_Y, mwIndex* jc_Y,double* op)
{
	// x*x'-y*y'
	double obj=0;
    double obj1=0;
    double valueR;
    double valueR1;
    int base;
    mwIndex start;
    mwIndex over;
    mwIndex i,j;
    mwIndex posR;
    mwIndex posC;
    mwIndex pos;
    start=jc_X[index];
    over=jc_X[index+1];
   // mexPrintf("step 2\n");
    for (i=start;i<over;i++) // find a column
    {   
        //mexPrintf("step 3.1\n");
        posC=ir_X[i]; // The row pos of a value
       // mexPrintf("step 3.2\n");
        valueR=x[i];  // The value
        base=numRow*posC-posC*(posC-1)/2-posC;
      //  mexPrintf("step 3.3\n");
        for (j=i;j<over;j++)
        {   
          //  mexPrintf("step 3.4\n");
            posR=ir_X[j];
           // mexPrintf("step 3.5\n");
            valueR1=x[j];
          //  mexPrintf("step 3.6\n");
            pos=base+posR;
            op[pos]=valueR1*valueR;
          
        }
       
    }
    start=jc_Y[index];
    over=jc_Y[index+1];
    //mexPrintf("step 3\n");
    for (i=start;i<over;i++) // find a column
    {
         // mexPrintf("step 3.7.1\n");
        posC=ir_Y[i]; // The row pos of a value
        valueR=y[i];  // The value
        base=numRow*posC-posC*(posC-1)/2-posC;
        for (j=i;j<over;j++)
        {   //  mexPrintf("step 3.7.2\n");
            posR=ir_Y[j];
            valueR1=y[j];
           //  mexPrintf("step 3.7.3\n");
            pos=base+posR;
            //mexPrintf("step 3.7.4 %d,%d,%d,%d \n",numRow,posR,posC,pos);
          //  if (pos<0||pos>=9591)
          //  {
           //    mexPrintf("error, %d,%d,%d,%d \n",numRow,posR,posC,pos);
           // }
            op[pos]=op[pos]-valueR1*valueR;
        }
    }
}
void sumOuterProduct(double* X,double* Y,double* index,int numRow,int numCol, mwIndex* ir_X, mwIndex* jc_X, mwIndex* ir_Y, mwIndex* jc_Y,double* out)
{   
    int i;
    int j;
    int num;
    int numT;
    double* op;
  
    numT=omp_get_max_threads();
    op=malloc((numT*num*sizeof(double)));
    mexPrintf("numT=%d",numT);
    num=(numRow+1)*numRow/2;
    #pragma omp parallel for schedule(dynamic,1) shared(index,op,num,numCol,out,X,Y,numRow,ir_X,jc_X,ir_Y,jc_Y) private(i)
	for (i=0;i<numCol;i++)
	{
        if(index[i])
        {   
         
            int currentID=omp_get_thread_num();
 //           mexPrintf("id=%d",currentID); 
            memset(op+currentID*num,0,num*sizeof(double));
           // mexPrintf("%d\n",i);
  //          outerProduct(X, Y,i,numRow,ir_X,jc_X,ir_Y,jc_Y,op);
           // mexPrintf("%d -\n",i);
         /*   #pragma omp critical
            {
                for (j=0;j<num;j++)
                {
                    out[j]=out[j]+op[j];
                }          
            }*/
            
          
        }
       
	}
    free(op);
}
// X, Y, index
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{   
    int numRow;   // num of Row
    int numCol;   // num of Col
    
    int num;     // num of elements
    double* index; // index vector
    double* X;    //X
    double* Y;    //Y
    double* out;  //output
    
    mwIndex    *jc_X;
    mwIndex    *ir_X;
    
    mwIndex    *jc_Y;
    mwIndex    *ir_Y;
	
    
	if (nrhs!=3)
	{
		mexErrMsgTxt("Exactly three input parameters required.");
	}
	if (nlhs>1)
	{
		mexErrMsgTxt("Too many output arguments.");
	}

    
    numRow=mxGetM(prhs[0]);  //X
    numCol=mxGetN(prhs[0]);
    X=mxGetPr(prhs[0]);
    Y=mxGetPr(prhs[1]);
    index=mxGetPr(prhs[2]);
    ir_X=mxGetIr(prhs[0]);
    jc_X=mxGetJc(prhs[0]);
    ir_Y=mxGetIr(prhs[1]);
    jc_Y=mxGetJc(prhs[1]);
    num=numRow*(numRow+1)/2;
	plhs[0]=mxCreateDoubleMatrix(num,1,mxREAL);
    out=mxGetPr(plhs[0]);
    memset(out,0,sizeof(double)*num);
    //mexPrintf("step 1 %d\n",num);
	sumOuterProduct(X,Y,index,numRow,numCol,ir_X,jc_X,ir_Y,jc_Y,out);
}
int main()
{
	return 0;
}

