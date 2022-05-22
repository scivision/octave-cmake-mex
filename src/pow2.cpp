#include <iostream>
#include <oct.h>

extern "C" void octave_prod(double*, double*, int*);

void octave_prod(double* A, double* A2, int* numel){

  Matrix Ao(1,*numel, *A);
  Matrix A2o(1, 1);

  std::cout << "Ao: " << Ao << std::endl;

  A2o = Ao.prod(1);

  // Allocate memory to pointer to returned values.
  A2 = (double*) malloc (A2o.numel() * sizeof (double));

  // Copy the content of matrix A to data structure Fortran can handle.
  memcpy(A2, A2o.fortran_vec(), A2o.numel() * sizeof (double));

  std::cout << "A2: " << *A2 << std::endl;
}
