cmake_minimum_required(VERSION 3.0)

project(build_test Fortran)

enable_language(Fortran)

# Check whether the user has selected a BUILD_TYPE
IF ("${CMAKE_BUILD_TYPE}" STREQUAL "")

    message(STATUS "Build type not explicitly set. Trying to guess...")
    get_filename_component(BINDIR ${PROJECT_BINARY_DIR} NAME)
    IF (${BINDIR} MATCHES "RELEASE")
        set(CMAKE_BUILD_TYPE "RELEASE")
        message(STATUS "Set to ${CMAKE_BUILD_TYPE}")
    ELSEIF(${BINDIR} MATCHES "DEBUG")
        set(CMAKE_BUILD_TYPE "DEBUG")
        message(STATUS "Set to ${CMAKE_BUILD_TYPE}")
    ELSE()
        message(WARNING "Unable to deduce build type. Use -DCMAKE_BUILD_TYPE=<RELEASE/DEBUG>")
    ENDIF(${BINDIR} MATCHES "RELEASE")

ELSE()
    message(STATUS "Build Type is ${CMAKE_BUILD_TYPE}")
ENDIF("${CMAKE_BUILD_TYPE}" STREQUAL "")

set(CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/generated/mods)

include_directories(${CMAKE_Fortran_MODULE_DIRECTORY})
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR})

# if DEBUG requested, set the various debug options.
IF(${CMAKE_BUILD_TYPE} MATCHES "DEBUG")
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -fdiagnostics-color=always")
    IF(${CMAKE_Fortran_COMPILER_ID} MATCHES "GNU")
        set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -Wall -fcheck=all -fbacktrace -std=f2008 -fcoarray=lib")
    ELSEIF(${CMAKE_Fortran_COMPILER_ID} MATCHES "Intel")
        set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -warn all -check all -traceback -coarray=shared")
    ELSE()
        message(WARNING "Unable to determine Compiler ID: ${CMAKE_Fortran_COMPILER_ID}")
    ENDIF(${CMAKE_Fortran_COMPILER_ID} MATCHES "GNU")
    message(STATUS "Debug flags for ${CMAKE_Fortran_COMPILER_ID}: ${CMAKE_Fortran_FLAGS_DEBUG}")
ENDIF(${CMAKE_BUILD_TYPE} MATCHES "DEBUG")

IF(${CMAKE_BUILD_TYPE} MATCHES "RELEASE")
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3 -std=f2008 -fdiagnostics-color=always")
    IF(${CMAKE_Fortran_COMPILER_ID} MATCHES "GNU")
        set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -fcoarray=lib")
    ENDIF(${CMAKE_BUILD_TYPE} MATCHES "GNU")
    message(STATUS "Release flags for ${CMAKE_Fortran_COMPILER_ID}: ${CMAKE_Fortran_FLAGS_RELEASE}")
ENDIF(${CMAKE_BUILD_TYPE} MATCHES "RELEASE")

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

set(PFUNIT_DIR ${PROJECT_BINARY_DIR}/thirdParty/pfunit)

file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/generated)
file(WRITE ${PROJECT_BINARY_DIR}/generated/testSuites.inc "")

include_directories(
    ${PROJECT_SOURCE_DIR}
    ${PROJECT_BINARY_DIR}/generated
    ${PFUNIT_DIR}/mod
    )

# Add my own submodules
add_subdirectory(modules)
add_subdirectory(executables)

# Unit test generation
add_subdirectory(tests)
enable_testing()

# Add the tests below
add_test(NAME Test_is_two COMMAND test1)
