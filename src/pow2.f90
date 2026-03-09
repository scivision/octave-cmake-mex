program octave_file_io_example

use iso_c_binding

implicit none (type, external)

interface
subroutine prod(A, A2, N) bind(c, name="octave_prod")
  import
  integer(c_size_t), intent(in), value :: N
  real(c_double), intent(in) :: A(N)
  real(c_double), intent(inout) :: A2(1)
end subroutine
end interface

real(c_double) :: A(2)
real(c_double) :: A2(1)

A = [3,2]

!> use C++ user function to read data
call prod(A, A2, size(A, kind=C_SIZE_T))

print '(a,2F7.3)', "Fortran in: ", A
print '(a,F7.3)', "Fortran out: ", A2

if (A2(1) /= product(A)) error stop "Error: A2 does not match the product of A"

print *, "OK: A2 matches the product of A"

end program
