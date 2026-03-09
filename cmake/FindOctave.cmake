# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindOctave
----------

Finds GNU Octave interpreter, libraries and compilers.

Imported targets
^^^^^^^^^^^^^^^^

This module defines the following :prop_tgt:`IMPORTED` targets:

``Octave::Interpreter``
  Octave interpreter (the main program)
``Octave::Octave``
  include directories and libraries

If no ``COMPONENTS`` are specified, ``Interpreter`` is assumed.

Result Variables
^^^^^^^^^^^^^^^^

``Octave_FOUND``
  Octave interpreter and/or libraries were found
``Octave_<component>_FOUND``
  Octave <component> specified was found

``Octave_EXECUTABLE``
  Octave interpreter

``Octave_MKOCTFILE``
  Octave mkoctfile compiler wrapper

Hints
^^^^^

FindOctave checks the environment variable OCTAVE_EXECUTABLE for the
Octave interpreter.
#]=======================================================================]

if(DEFINED ENV{OCTAVE_EXECUTABLE})
  set(_octave_exe $ENV{OCTAVE_EXECUTABLE})
  cmake_path(GET _octave_exe PARENT_PATH _octave_hint_dirs)
endif()

if(WIN32)
  set(_arch mingw64)
  # currently MinGW is the only arch distributed by GNU Octave for Windows
  foreach(_p IN ITEMS "$ENV{LOCALAPPDATA}/Programs/GNU Octave" "$ENV{ProgramFiles}/GNU Octave")
    file(GLOB _g LIST_DIRECTORIES false "${_p}/Octave-*/${_arch}/bin/octave-config.exe")
    message(DEBUG "Octave glob hints: ${_g}")
    foreach(_h IN LISTS _g)
      cmake_path(GET _h PARENT_PATH _h)
      list(APPEND _octave_hint_dirs "${_h}")
    endforeach()
  endforeach()
endif()

message(VERBOSE "Octave hints: ${_octave_hint_dirs}")

find_program(Octave_CONFIG_EXECUTABLE
NAMES octave-config
HINTS ${_octave_hint_dirs}
PATH_SUFFIXES bin
DOC "Octave configuration helper"
)

unset(_octave_def)
if(Octave_CONFIG_EXECUTABLE)
  set(_octave_def NO_DEFAULT_PATH)

  execute_process(COMMAND ${Octave_CONFIG_EXECUTABLE} -p VERSION
  OUTPUT_VARIABLE Octave_VERSION
  OUTPUT_STRIP_TRAILING_WHITESPACE
  TIMEOUT 10
  )
endif()


if(Development IN_LIST Octave_FIND_COMPONENTS)

  if(Octave_CONFIG_EXECUTABLE AND NOT DEFINED Octave_MKOCTFILE)
    execute_process(COMMAND ${Octave_CONFIG_EXECUTABLE} -p OCTAVE_EXEC_HOME
    OUTPUT_VARIABLE Octave_OCTAVE_EXEC_HOME
    OUTPUT_STRIP_TRAILING_WHITESPACE TIMEOUT 10)
  endif()

  find_program(Octave_MKOCTFILE
  NAMES mkoctfile
  HINTS ${Octave_OCTAVE_EXEC_HOME} ${_octave_hint_dirs}
  PATH_SUFFIXES bin
  ${_octave_def}
  )

  if(Octave_MKOCTFILE)
    set(Octave_Development_FOUND true)
  endif()

endif()


if(Interpreter IN_LIST Octave_FIND_COMPONENTS)

  if(Octave_CONFIG_EXECUTABLE AND NOT DEFINED Octave_EXECUTABLE)
    execute_process(COMMAND ${Octave_CONFIG_EXECUTABLE} -p BINDIR
    OUTPUT_VARIABLE Octave_BINARY_DIR
    OUTPUT_STRIP_TRAILING_WHITESPACE TIMEOUT 10)
  endif()

  find_program(Octave_EXECUTABLE
  NAMES octave-cli octave
  HINTS ${Octave_BINARY_DIR} ${_octave_hint_dirs}
  PATH_SUFFIXES bin
  ${_octave_def}
  )

  if(Octave_EXECUTABLE)
    set(Octave_Interpreter_FOUND true)
  endif(Octave_EXECUTABLE)

endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Octave
VERSION_VAR Octave_VERSION
HANDLE_COMPONENTS
HANDLE_VERSION_RANGE
)


if(Octave_Development_FOUND)
  if(NOT TARGET Octave::mkoctfile)
    add_executable(Octave::mkoctfile IMPORTED)
    set_property(TARGET Octave::mkoctfile PROPERTY IMPORTED_LOCATION ${Octave_MKOCTFILE})
  endif()
endif()


if(Octave_Interpreter_FOUND)
  if(NOT TARGET Octave::Interpreter)
    add_executable(Octave::Interpreter IMPORTED)
    set_property(TARGET Octave::Interpreter PROPERTY IMPORTED_LOCATION ${Octave_EXECUTABLE})
    set_property(TARGET Octave::Interpreter PROPERTY VERSION "${Octave_VERSION}")
  endif()
endif()

mark_as_advanced(Octave_CONFIG_EXECUTABLE)
