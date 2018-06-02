! Module for setting the precision in the entire library

module Settings_m

  use iso_fortran_env
  
  integer, parameter :: rw = 8 ! by default every real data is in double precision
  integer, parameter :: iw = 8 ! by default every interger data has 8 bytes
  integer, parameter :: images = 2 ! Number of images

end module Settings_m
