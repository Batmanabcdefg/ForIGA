module BSpline_m

  use Settings_m 
  use Conversion_m

  implicit none

  type BSplineBasis_t
    real ( kind = rw ), allocatable :: knots_( : )
    integer ( kind = iw ) :: index_
    integer ( kind = iw ) :: order_

    contains
      procedure :: basisFunc => N
  end type BSplineBasis_t

contains
  pure function N( this, u ) result ( N_i_p )
    class( BSplineBasis_t ), intent( in ) :: this
    real( kind = rw ), intent( in ) :: u
    real( kind = rw ) :: N_i_p

    N_i_p = computeBasis( this%knots_, this%index_, this%order_, u )

  end function N

  pure recursive function computeBasis( knots, index, order, u ) result( N_i_p )
    real ( kind = rw ), intent( in ) :: knots( : )
    integer ( kind = iw ), intent( in ) :: index
    integer ( kind = iw ), intent( in ) :: order
    real ( kind = rw ), intent( in ) :: u
    real ( kind = rw ) :: N_i_p
    real ( kind = rw ) :: left
    real ( kind = rw ) :: right

    if ( order .EQ. 0 ) then
      N_i_p = logic2dbl( knots( index ) <= u .AND. u < knots( index + 1 ) )
    else
      if ( u < knots( index ) .OR. u > knots( index + 1 ) ) then
        N_i_p = 0.
      else
        left = ( u - knots( index ) ) / ( knots( index + order ) - knots( index ) )
        right = ( knots( index + order + 1 ) - u ) / ( knots( index + order + 1 ) - knots( index + 1 )  )

        if( isnan(  left ) ) then
         left = 0.
        endif
        if( isnan( right ) ) then
          right = 0.
        endif

        N_i_p = left * computeBasis( knots, index, order - 1, u ) + &
                right * computeBasis( knots, index + 1, order - 1, u )
      endif

    endif

  end function computeBasis


end module BSpline_m
