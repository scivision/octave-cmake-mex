include(CheckSourceCompiles)

find_package(Octave COMPONENTS Development Interpreter REQUIRED)

set(CMAKE_REQUIRED_LIBRARIES Octave::Octave)

# --- C
check_source_compiles(C
[=[
#include "mex.h"

int main(void)
{
  mxArray** plhs = mxCreateDoubleMatrix (0, 0, mxREAL);
  return 0;
}
]=]
Octave_C_OK
)

# --- C++

check_source_compiles(CXX
"
#include <oct.h>
#include <cstdlib>

int main()
{
 Matrix a_matrix = Matrix (2, 2);
 return EXIT_SUCCESS;
}
"
Octave_CXX_OK
)
