#include "mex.h"
#include <string.h>
double singleLoss(double* x, double* y,double* W,int index, mwIndex* ir_X, mwIndex* jc_X, mwIndex* ir_Y, mwIndex* jc_Y)
{
	// x*y'
	double obj=0;
    double obj1=0;
	int numCol=numRow;
    mwIndex start;
    mwIndex over;
    mwIndex i,j;
    begin=jc_X[index];
    over=jc_X[index+1];
    for (i=start;i<over;i++) // find a column
    {
        mwIndex posR=ir_X[i]; // The row pos of a value
        double  valueR=x[i];  // The value
        //////////////////////////////////////
        double weight=W[i*numRow+i];
        obj=obj+0.5*valueR*valueR*weight;
        
        //////////////////////////////////////
        for (j=i+1;j<over;j++)
        {
            mwIndex posR=ir_X[j];
            double valueR1=x[j];
            weight=W[j*numRow+i];
            obj=obj+weight*valueR1*valueR;
        }
    }
  
    start=jc_Y[index];
    over=jc_Y[index+1];
    for (i=start;i<over;i++) // find a column
    {
        mwIndex posR=ir_Y[i]; // The row pos of a value
        double  valueR=y[i];  // The value
        //////////////////////////////////////
        double weight=W[i*numRow+i];
        obj1=obj1+0.5*valueR*valueR*weight;
        
        //////////////////////////////////////
        for (j=i+1;j<over;j++)
        {
            mwIndex posR=ir_Y[j];
            double valueR1=y[j];
            weight=W[j*numRow+i];
            obj1=obj1+weight*valueR1*valueR;
        }
    }
    obj=2*(obj-obj1);
    return obj;
}
void weightedLoss(double* X,double* Y,double* W,double* out,int numRow,int numCol, mwIndex* ir_X, mwIndex* jc_X, mwIndex* ir_Y, mwIndex* jc_Y)
{   
    int i;
    #pragma omp parallel for schedule(dynamic,1) shared(numCol,out,X,Y,numRow,ir_X,jc_X,ir_Y,jc_Y) private(i)
	for (i=0;i<numCol;i++)
	{
	   out[i]=singleLoss(X, Y,W,i,ir_X,jc_X,ir_Y,jc_Y);
       //printf("id=%d\n",omp_get_thread_num()); 
	}
}

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{   int numRow;
    int numCol;
    double* X;
    double* Y;
    double* W;
    double* out;
    
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
/*	if (!(mxIsDouble(prhs[0]))||!(mxIsDouble(prhs[1]))||!(mxIsDouble(prhs[2])))
	{
		mexErrMsgTxt("The input must be of type double.");
	}*/
    
    numRow=mxGetM(prhs[0]);
  
    numCol=mxGetN(prhs[0]);

    X=mxGetPr(prhs[0]);
	
    Y=mxGetPr(prhs[1]);
	
    W=mxGetPr(prhs[2]);
	plhs[0]=mxCreateDoubleMatrix(numCol,1,mxREAL);
	
    out=mxGetPr(plhs[0]);
	weightedLoss(X,Y,W,out,numRow,numCol,ir_X,jc_X,ir_Y,jc_Y);


}
int main()
{
	return 0;
}

