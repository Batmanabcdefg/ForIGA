module BSplineTests_m
    use BSpline_m
    use Settings_m

    implicit none

    real( kind = rw ), parameter :: tol = 1e-6

    type BSplineConst_f
      real ( kind = rw ), dimension( 1:6 ) :: knots
      integer( kind = iw ) :: order = 0
    end type BSplineConst_f

    type BSplineLinear_f
      real ( kind = rw ), dimension( 1:6 ) :: knots
      integer( kind = iw ) :: order = 1
    end type BSplineLinear_f
    
    type BSplineQuadratic_f
      real ( kind = rw ), dimension( 1:6 ) :: knots
      integer( kind = iw ) :: order = 2
    end type BSplineQuadratic_f

    contains

      function genQuadraticKnots() result( knots )
        real( kind = rw ), dimension( 1:6 ) :: knots

        knots = (/ 0d0, 0d0, 0d0, 1d0, 1d0, 1d0 /)
      end function genQuadraticKnots

      function genBSplineConst( index ) result( bspline )
        integer( kind = iw ), intent( in ) :: index 
        type(BSplineBasis_t) :: bspline

        bspline = BSplineBasis_t( genQuadraticKnots(), index, 0 )

      end function genBSplineConst


end module BSplineTests_m