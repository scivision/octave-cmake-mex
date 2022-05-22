program octave_file_io_example

use iso_c_binding, only : c_char, c_null_char, c_int, c_ptr, c_double, c_f_pointer

implicit none (type, external)

interface
integer(c_int) function octave_load (filename, data, N) bind(c, name="octave_load")
  import
  character(kind=c_char), intent(in) :: filename(*)
  type(c_ptr), intent(out) :: data
  integer(c_int), intent(out) :: N
end function octave_load
end interface

integer(c_int) :: res
type(c_ptr) :: data
real(c_double), pointer :: fdata(:)
integer(c_int) :: numel
logical :: exists
character(*, kind=c_char), parameter :: fn = c_char_'data.txt' // c_null_char

inquire(file=fn, exist=exists)
if(.not. exists) error stop 'data file does not exist: ' // fn

!> use C++ user function to read data
res = octave_load(fn, data, numel)
if(res /= 0) error stop "C++ failed to load data from: " // fn

call c_f_pointer (data, fdata, [numel])

print '(100F7.3)', fdata

end program
