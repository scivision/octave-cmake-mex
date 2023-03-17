
include(CheckCSourceCompiles)
include(CheckCXXSourceCompiles)


find_package(Octave COMPONENTS Development Interpreter REQUIRED)

set(CMAKE_REQUIRED_LIBRARIES ${Octave_LIBRARIES})
set(CMAKE_REQUIRED_INCLUDES ${Octave_INCLUDE_DIRS})

# --- C
check_c_source_compiles(
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

check_cxx_source_compiles(
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
