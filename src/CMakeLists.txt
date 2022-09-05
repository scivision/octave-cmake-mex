if(Octave_C_OK)

  add_executable(octave_c octave_mex.c)
  target_link_libraries(octave_c PRIVATE Octave::Octave)

  add_test(NAME Octave_C COMMAND octave_c)

endif(Octave_C_OK)


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
  set_property(TEST GenDataFile PROPERTY FIXTURES_SETUP data_fxt)


  add_executable(fortran_file file.f90 file.cpp)
  target_link_libraries(fortran_file PRIVATE Octave::Octave)

  add_test(NAME Octave_Fortran_file COMMAND fortran_file
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )
  set_property(TEST Octave_Fortran_file PROPERTY FIXTURES_REQUIRED data_fxt)

  # not working, probably incorrect syntax
  add_library(cpp_pow2 OBJECT pow2.cpp)
  target_link_libraries(cpp_pow2 PRIVATE Octave::Octave)

  add_executable(pow2 pow2.f90 $<TARGET_OBJECTS:cpp_pow2>)
  target_link_libraries(pow2 PRIVATE Octave::Octave)
  # add_test(NAME Octave_Fortran_array COMMAND pow2)

endif(Octave_CXX_OK)



# --- props
get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)

set_property(TEST ${test_names} PROPERTY TIMEOUT 20)

if(WIN32 AND CMAKE_VERSION VERSION_GREATER_EQUAL 3.22)
  cmake_path(GET Octave_EXECUTABLE PARENT_PATH Octave_DLLPATH)
  set_property(TEST ${test_names} PROPERTY
  ENVIRONMENT_MODIFICATION PATH=path_list_append:${Octave_DLLPATH}
  )
endif()
