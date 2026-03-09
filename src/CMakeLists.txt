add_custom_command(OUTPUT addtwomatrices.oct
COMMAND Octave::mkoctfile ${CMAKE_CURRENT_SOURCE_DIR}/addtwomatrices.cpp
)
add_custom_target(addtwomatrices ALL DEPENDS addtwomatrices.oct)

add_test(NAME Octave_addtwomatrices
COMMAND Octave::Interpreter --path ${CMAKE_CURRENT_BINARY_DIR} --eval "addtwomatrices_test()"
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)


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
  set_property(TEST ${test_names} PROPERTY
  ENVIRONMENT_MODIFICATION PATH=path_list_prepend:${Octave_BINARY_DIR}
  )
elseif(APPLE)
  set_property(TEST ${test_names} PROPERTY
  ENVIRONMENT_MODIFICATION DYLD_LIBRARY_PATH=path_list_prepend:${Octave_OCTLIBDIR})
else()
  set_property(TEST ${test_names} PROPERTY
  ENVIRONMENT_MODIFICATION LD_LIBRARY_PATH=path_list_prepend:${Octave_OCTLIBDIR})
endif()
