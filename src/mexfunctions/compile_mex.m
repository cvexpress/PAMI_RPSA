mex -v COMPFLAGS="$COMPFLAGS /openmp" weightedLoss.c

mex -v COMPFLAGS="$COMPFLAGS /openmp" weightedLossSparse.c  -largeArrayDims

mex -v COMPFLAGS="$COMPFLAGS /openmp" sumOutterProduct.c  -largeArrayDims
