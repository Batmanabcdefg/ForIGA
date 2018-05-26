project( thirdParty Fortran)

# Search for the PFUNIT executable
include(ExternalProject)
set(ExternalProjectCMakeArgs
    -DCMAKE_INSTALL_PREFIX=${CMAKE_SOURCE_DIR}/thirdParty/pfunit
    -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})

ExternalProject_Add(pfunit
    DOWNLOAD_COMMAND git submodule update
    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}
    SOURCE_DIR ${PROJECT_SOURCE_DIR}/thirdParty/pfunit
    BINARY_DIR ${PROJECT_BINARY_DIR}/thirdParty/pfunit-build
    STAMP_DIR ${PROJECT_BINARY_DIR}/thirdParty/pfunit-stamp
    TMP_DIR ${PROJECT_BINARY_DIR}/thirdParty/pfunit-tmp
    INSTALL_DIR ${PROJECT_BINARY_DIR}/thirdParty
    CMAKE_ARGS ${ExternalProjectCMakeArgs}
    )

include_directories(${PROJECT_BINARY_DIR}/thirdParty/pfunit/mod)

set(PFUNIT_DIR ${CMAKE_SOURCE_DIR}/thirdParty/pfunit)

message(STATUS "pfUnitDirectory: " ${PFUNIT_DIR})

file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/generated)
file(WRITE ${PROJECT_BINARY_DIR}/generated/testSuites.inc "")

include_directories(
    ${PROJECT_SOURCE_DIR}
    ${PROJECT_BINARY_DIR}/generated
    ${PFUNIT_DIR}/mod
    )
