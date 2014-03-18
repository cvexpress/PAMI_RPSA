
#include "mex.h"
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    
//     int     *jc;
//  int      starting_row_index, stopping_row_index;
//  int      elements_in_second_col;
// 
//  /* Get the starting positions of the data in the sparse array. */  
//    jc = mxGetJc(prhs[0]);
// 
//  /* How many elements are in the second column of the sparse array. 
// */
//    starting_row_index = *(jc + 1);
//    stopping_row_index = *(jc + 2);
//    elements_in_second_col = stopping_row_index - 
// starting_row_index;
//    mexPrintf("There are %d elements in the second column.\n", 
//               elements_in_second_col);
   mwIndex     *jc;
   mwIndex    *ir;
 double     *ptr;
  int m;
  int n;
  int i;
  int j;
//  /* Get the starting positions of the data in the sparse array. */  
//   mexPrintf("fine");
  ir = mxGetIr(prhs[0]);

  jc = mxGetJc(prhs[0]);
  ptr=mxGetPr(prhs[0]);
 m=mxGetM(prhs[0]);
  n=mxGetN(prhs[0]);
// 
//  /* How many elements are in the second column of the sparse array. 
// */
 mexPrintf('fine');
  for (i=0;i<9;i++)
     
      {
        mexPrintf("%d ", ir[i]);
      }
  mexPrintf("\n");
  for (i=0;i<9;i++)
     
      {
        mexPrintf("%d ", jc[i]);
      }

}