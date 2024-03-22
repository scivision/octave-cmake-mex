cmake_minimum_required(VERSION 3.19...3.29)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "please use out-of-source build
  cmake -B build")
endif()

project(OctaveMEX LANGUAGES C CXX)

enable_testing()

option(fortran "use Fortran" on)

if(fortran)
  enable_language(Fortran)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

set(CMAKE_CXX_STANDARD 11)

include(cmake/octave.cmake)

add_test(NAME BasicOctave
COMMAND ${Octave_EXECUTABLE} --eval "oruntests('${CMAKE_CURRENT_SOURCE_DIR}')"
)

add_subdirectory(src)

# auto-ignore build dir
file(GENERATE OUTPUT .gitignore CONTENT "*")
