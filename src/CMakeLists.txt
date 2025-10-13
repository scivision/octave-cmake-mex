add_custom_command(OUTPUT array_add.oct COMMAND mkoctfile ${CMAKE_CURRENT_SOURCE_DIR}/array_add.cpp)

add_custom_target(array_add ALL DEPENDS array_add.oct)


# --- Fortran: https://wiki.octave.org/Fortran
# Fortran in Octave MEX is accomplished by binding to C or C++ functions from Fortran
add_test(NAME GenDataFile
COMMAND Octave::Interpreter --eval "A = rand(3); save('-ascii', '${CMAKE_CURRENT_BINARY_DIR}/data.txt', 'A')"
)
set_property(TEST GenDataFile PROPERTY FIXTURES_SETUP data_fxt)

return()

add_executable(fortran_file file.f90 file.cpp)

add_test(NAME Octave_Fortran_file COMMAND fortran_file
WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
set_property(TEST Octave_Fortran_file PROPERTY FIXTURES_REQUIRED data_fxt)

# not working, probably incorrect syntax
add_library(cpp_pow2 OBJECT pow2.cpp)

add_executable(pow2 pow2.f90 $<TARGET_OBJECTS:cpp_pow2>)
# add_test(NAME Octave_Fortran_array COMMAND pow2)




# --- props
get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)

if(WIN32 AND CMAKE_VERSION VERSION_GREATER_EQUAL 3.22)
  cmake_path(GET Octave_EXECUTABLE PARENT_PATH Octave_DLLPATH)
  set_property(TEST ${test_names} PROPERTY
  ENVIRONMENT_MODIFICATION PATH=path_list_prepend:${Octave_DLLPATH}
  )
endif()
