project(basis Fortran)

file(GLOB ${PROJECT_NAME}_sources "*.f90")

message(STATUS "Sources for project ${PROJECT_NAME}: ${${PROJECT_NAME}_sources}")

set(BASIS_DIR ${CMAKE_CURRENT_DIR} PARENT_SCOPE)
add_library(${PROJECT_NAME} SHARED ${${PROJECT_NAME}_sources})

install(TARGETS ${PROJECT_NAME}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib/shared)

target_link_libraries( ${PROJECT_NAME} util )
