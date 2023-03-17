cmake_minimum_required(VERSION 3.13...3.26)

project(OctaveMEX LANGUAGES C CXX Fortran)

enable_testing()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

set(CMAKE_CXX_STANDARD 11)

include(cmake/octave.cmake)

add_test(NAME BasicOctave
COMMAND ${Octave_EXECUTABLE} --eval "oruntests('${CMAKE_CURRENT_SOURCE_DIR}')"
)

add_subdirectory(src)

file(GENERATE OUTPUT .gitignore CONTENT "*")
