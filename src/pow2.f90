program octave_file_io_example

use iso_c_binding, only : c_char, c_null_char, c_int, c_ptr, c_double, c_f_pointer

implicit none (type, external)

interface
subroutine prod(A, A2, N) bind(c, name="octave_prod")
  import
  real(c_double), intent(in) :: A(N)
  real(c_double), intent(inout) :: A2(1)
  integer(c_int), intent(in) :: N
end subroutine
end interface

real(c_double) :: A(2)
real(c_double) :: A2(1)

A = [3,2]

!> use C++ user function to read data
call prod(A, A2, size(A, kind=C_INT))

print '(a,2F7.3)', "in: ", A
print '(a,F7.3)', "out: ", A2

end program
