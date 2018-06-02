function basis_bspline_n_1_0_test() result( test_succ ) 
  use BSplineTests_m
  use Settings_m

  implicit none

  type ( BSplineBasis_t ) :: bspline
  integer( kind = iw ), parameter :: index = 1
  real( kind = rw ), dimension(2) :: N_1_0
  integer( kind = iw ) :: test_succ
  logical, dimension( 2 ) :: N_1_0_succ

  !! We create the needed number of knots for the BSpline, since
  !! a quadratic spline has to be created each knot value is present in the knot
  !! vector two times. An additional time it's repeated since an open knot vector is intended
  bspline = genBSplineConst( index )
  N_1_0( 1 ) = bspline%basisFunc( 0d0 )
  N_1_0( 2 ) = bspline%basisFunc( 1d0 )

  N_1_0_succ( 1 ) = N_1_0( 1 ) == 0d0
  N_1_0_succ( 2 ) = N_1_0( 2 ) == 0d0

  if ( N_1_0_succ( 1 ) .EQV. N_1_0_succ( 2 ) ) then 
    test_succ = 0
  else 
    test_succ = 1
  endif

end function basis_bspline_n_1_0_test
