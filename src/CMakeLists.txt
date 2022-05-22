
include(CheckSourceCompiles)

set(CMAKE_REQUIRED_LIBRARIES ${Octave_LIBRARIES})
set(CMAKE_REQUIRED_INCLUDES ${Octave_INCLUDE_DIRS})

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

if(Octave_C_OK)

  add_executable(octave_c octave_mex.c)
  target_link_libraries(octave_c PRIVATE Octave::Octave)

  add_test(NAME Octave_C COMMAND octave_c)

endif(Octave_C_OK)

# --- C++

set(CMAKE_CXX_STANDARD 11)  # need for test with Clang
check_source_compiles(CXX
"
#include <oct.h>

int main()
{
 Matrix a_matrix = Matrix (2, 2);
 return EXIT_SUCCESS;
}
"
Octave_CXX_OK
)

if(Octave_CXX_OK)

  add_executable(octave_cpp octave_mex.cpp)
  target_link_libraries(octave_cpp PRIVATE Octave::Octave)
  target_compile_features(octave_cpp PRIVATE cxx_std_11)

  add_test(NAME Octave_CPP COMMAND octave_cpp)


# --- Fortran: https://wiki.octave.org/Fortran
# Fortran in Octave MEX is accomplished by binding to C or C++ functions from Fortran
  add_test(NAME GenDataFile
  COMMAND ${Octave_EXECUTABLE} --eval "A = rand(3); save('-ascii', '${CMAKE_CURRENT_BINARY_DIR}/data.txt', 'A')"
  )
  set_tests_properties(GenDataFile PROPERTIES
  FIXTURES_SETUP data_fxt
  TIMEOUT 15
  )

  add_library(cpp_file file.cpp)
  target_link_libraries(cpp_file PRIVATE Octave::Octave)
  target_compile_features(cpp_file PRIVATE cxx_std_11)

  add_executable(fortran_file file.f90)
  target_link_libraries(fortran_file PRIVATE cpp_file)

  add_test(NAME Octave_Fortran_file COMMAND fortran_file
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )
  set_tests_properties(Octave_Fortran_file PROPERTIES
  FIXTURES_REQUIRED data_fxt
  )

endif(Octave_CXX_OK)



# --- props
get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)
set_tests_properties(${test_names} PROPERTIES TIMEOUT 20)
if(WIN32 AND CMAKE_VERSION VERSION_GREATER_EQUAL 3.22)
  cmake_path(GET Octave_EXECUTABLE PARENT_PATH Octave_DLLPATH)
  set_tests_properties(${test_names} PROPERTIES ENVIRONMENT_MODIFICATION PATH=path_list_append:${Octave_DLLPATH})
endif()
