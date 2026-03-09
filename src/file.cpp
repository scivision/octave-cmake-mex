// Octave header
#include <octave/oct.h>
#include <ls-mat-ascii.h>
#include <algorithm>
#include <memory>

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
  if (!in_file_stream)
    return 1;

  read_mat_ascii_data (in_file_stream, file_name, read_data);
  in_file_stream.close ();

  // Convert read data to numerical array (matrix).
  NDArray A = read_data.array_value ();

  // Extract number of elements in matrix A.
  const auto num_elements = A.numel ();
  *numel = num_elements;

  // Allocate memory using std::unique_ptr for automatic cleanup on exception.
  auto data_ptr = std::make_unique<double[]>(num_elements);

  // Copy the content of matrix A to data structure using std::copy (type-safe).
  const double* src = A.fortran_vec ();
  std::copy (src, src + num_elements, data_ptr.get());

  // Transfer ownership to caller.
  *data = data_ptr.release();

  return 0;
}
