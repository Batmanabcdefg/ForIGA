module Conversion_m

    contains

    pure double precision function logic2dbl( a )
        logical, intent(in) :: a

        if ( a ) then
            logic2dbl = 1.d0
        else
            logic2dbl = 0.d0
        end if

    end function logic2dbl

end module Conversion_m