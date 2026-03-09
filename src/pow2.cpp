#include <cstring>
#include <oct.h>

extern "C" void octave_prod(double*, double*, std::size_t);

void octave_prod(double* A, double* A2, std::size_t numel){

  Matrix Ao(1, numel);
  Matrix A2o(1, 1);

  // Copy caller-provided contiguous data into an Octave matrix.
  std::memcpy(Ao.fortran_vec(), A, numel * sizeof(double));

  A2o = Ao.prod(1);

  // Write into the caller-provided output buffer.
  A2[0] = A2o(0, 0);
}
