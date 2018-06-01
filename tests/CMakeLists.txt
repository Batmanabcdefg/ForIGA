project(ForIGAtests Fortran)


add_subdirectory( basis )

# Add the tests below
add_test(NAME Test_is_two COMMAND test1)
