cmake_minimum_required(VERSION 3.19...3.25)

project(OctaveMEX LANGUAGES C CXX Fortran)

enable_testing()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

find_package(Octave COMPONENTS Development Interpreter REQUIRED)

add_test(NAME BasicOctave
COMMAND ${Octave_EXECUTABLE} --eval "oruntests('${CMAKE_CURRENT_SOURCE_DIR}')"
)

add_subdirectory(src)
