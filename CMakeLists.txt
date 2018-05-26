cmake_minimum_required(VERSION 3.0)

project(ForIga Fortran)

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
      set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG}
           -Wall -fcheck=all -fbacktrace -std=f2008 -fcoarray=lib -fprofile-arcs -ftest-coverage")
    ELSEIF(${CMAKE_Fortran_COMPILER_ID} MATCHES "Intel"
        set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -warn all -check all -traceback -coarray=shared") )
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


include( thirdParty/THIRD_PARTY_SETUP.cmake )
find_package( BLAS REQUIRED )
find_package( LAPACK REQUIRED )

# Add my own submodules
add_subdirectory(modules)
add_subdirectory(executables)

# Unit test generation
enable_testing()
add_subdirectory(tests)
