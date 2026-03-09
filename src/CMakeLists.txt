add_custom_command(OUTPUT array_add.oct
COMMAND Octave::mkoctfile ${CMAKE_CURRENT_SOURCE_DIR}/array_add.cpp
)
add_custom_target(array_add ALL DEPENDS array_add.oct)

add_test(NAME Octave_array_add COMMAND Octave::Interpreter --eval "array_add_test()")


# --- Fortran: https://wiki.octave.org/Fortran
# Fortran in Octave MEX is accomplished by binding to C or C++ functions from Fortran
add_test(NAME GenDataFile
COMMAND Octave::Interpreter --eval "A = rand(3); save('-ascii', '${CMAKE_CURRENT_BINARY_DIR}/data.txt', 'A')"
)
set_property(TEST GenDataFile PROPERTY FIXTURES_SETUP data_fxt)


add_custom_command(OUTPUT fortran_exe
COMMAND Octave::mkoctfile --link-stand-alone -o fortran_exe
${CMAKE_CURRENT_SOURCE_DIR}/file.f90 ${CMAKE_CURRENT_SOURCE_DIR}/file.cpp
$<$<STREQUAL:${Octave_MKOCTFILE_Fortran_COMPILER},gfortran>:-lgfortran>
)
add_custom_target(fortran_file ALL DEPENDS fortran_exe)

add_test(NAME Octave_Fortran_file COMMAND fortran_exe
WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
set_property(TEST Octave_Fortran_file PROPERTY FIXTURES_REQUIRED data_fxt)

add_custom_command(OUTPUT pow2exe
COMMAND Octave::mkoctfile --link-stand-alone -o pow2exe
${CMAKE_CURRENT_SOURCE_DIR}/pow2.f90 ${CMAKE_CURRENT_SOURCE_DIR}/pow2.cpp
$<$<STREQUAL:${Octave_MKOCTFILE_Fortran_COMPILER},gfortran>:-lgfortran>
)
add_custom_target(pow2 ALL DEPENDS pow2exe)
add_test(NAME Octave_Fortran_array COMMAND pow2exe)




# --- props
get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)

if(WIN32)
  cmake_path(GET Octave_EXECUTABLE PARENT_PATH Octave_DLLPATH)

  set_property(TEST ${test_names} PROPERTY
  ENVIRONMENT_MODIFICATION PATH=path_list_prepend:${Octave_DLLPATH}
  )
endif()
