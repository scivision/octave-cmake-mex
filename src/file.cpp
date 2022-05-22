// Octave header
#include <oct.h>
#include <ls-mat-ascii.h>

extern "C" int octave_load (const char*, double**, int*);

//! Load a single matrix, stored in ASCII format, from a data file.
//!
//! @param file_name name of the data file.
//! @param data pointer to the read-in matrix stored as fortran vector
//!             (column-major order).
//! @param numel number of elements in @p data.

int octave_load (const char* file_name, double** data, int* numel)
{
  // Define variable to hold the read data.
  octave_value read_data;

  // Read a plain ASCII matrix from data file.
  std::ifstream in_file_stream (file_name, std::ios::binary);
  read_mat_ascii_data (in_file_stream, file_name, read_data);
  in_file_stream.close ();

  // Convert read data to numerical array (matrix).
  NDArray A = read_data.array_value ();

  // Extract number of elements in matrix A.
  *numel = A.numel ();

  // Allocate memory to pointer to returned values.
  *data  = (double*) malloc (A.numel () * sizeof (double));

  // Copy the content of matrix A to data structure Fortran can handle.
  memcpy (*data, A.fortran_vec (), A.numel () * sizeof (double));

  return 0;
}
