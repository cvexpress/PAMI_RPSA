#include "mex.h"
#include <string.h>
double singleLoss(double* x, double* y,double* W,int numRow)
{
	// x*y'
	double obj=0;
	int numCol=numRow;
    int i,j;
    
	for (i=0;i<numCol;i++)
	{
		int base=i*numRow;
		for(j=0;j<numRow;j++)
		{
			obj+=(x[j]*x[i]-y[j]*y[i])*W[base+j];
		}
	}
	return obj;
}
void weightedLoss(double* X,double* Y,double* W,double* out,int numRow,int numCol)
{   
    int i;
    #pragma omp parallel for schedule(dynamic,1) shared(numCol,out,X,Y,numRow) private(i)
	for (i=0;i<numCol;i++)
	{
	   out[i]=singleLoss(X+numRow*i, Y+numRow*i,W,numRow);
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
	weightedLoss(X,Y,W,out,numRow,numCol);


}
int main()
{
	return 0;
}

