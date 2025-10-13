cmake_minimum_required(VERSION 3.19...3.31)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "please use out-of-source build
  cmake -B build")
endif()

project(OctaveMEX LANGUAGES NONE)

enable_testing()


list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

find_package(Octave COMPONENTS Development Interpreter REQUIRED)

add_test(NAME BasicOctave
COMMAND Octave::Interpreter --eval "oruntests('${CMAKE_CURRENT_SOURCE_DIR}')"
)

add_subdirectory(src)

# auto-ignore build dir
file(GENERATE OUTPUT .gitignore CONTENT "*")
