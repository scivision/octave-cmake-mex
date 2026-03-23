find_program(brew NAMES brew)

if(brew)
  execute_process(COMMAND ${brew} --prefix octave
  OUTPUT_VARIABLE Octave_ROOT
  OUTPUT_STRIP_TRAILING_WHITESPACE
  RESULT_VARIABLE _ret)
  if(_ret EQUAL 0)
    message(STATUS "Octave via Homebrew: Octave_ROOT ${Octave_ROOT}")

    execute_process(COMMAND ${brew} --prefix gcc
    OUTPUT_VARIABLE gcc_prefix
    OUTPUT_STRIP_TRAILING_WHITESPACE
    RESULT_VARIABLE _ret)
    if(_ret EQUAL 0 AND IS_DIRECTORY ${gcc_prefix}/lib/gcc/current/)
      set(Octave_LDFLAGS -L${gcc_prefix}/lib/gcc/current/)
      message(STATUS "Octave_LDFLAGS: ${Octave_LDFLAGS}")
    endif()
  else()
    unset(Octave_ROOT)
  endif()
endif()
