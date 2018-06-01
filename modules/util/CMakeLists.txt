project(util Fortran)

file(GLOB ${PROJECT_NAME}_sources "*.f90")

message(STATUS "Sources for project ${PROJECT_NAME}: ${${PROJECT_NAME}_sources}")

set(UTIL_DIR ${CMAKE_CURRENT_BINARY_DIR} PARENT_SCOPE)
add_library(${PROJECT_NAME} STATIC ${${PROJECT_NAME}_sources})

message(STATUS "Util-dir:" ${UTIL_DIR})

install(TARGETS ${UITL_DIR}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib/static)
