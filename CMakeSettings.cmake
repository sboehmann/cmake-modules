# The following variables can be set to TRUE to skip parts of the functionality:
#  SKIP_RPATH_SETTINGS
#  SKIP_BUILD_SETTINGS
#  SKIP_TEST_SETTINGS

################ RPATH handling ####################################

if(NOT SKIP_RPATH_SETTINGS)
   if(NOT LIB_INSTALL_DIR)
      message(FATAL_ERROR "LIB_INSTALL_DIR not set. This is necessary for using the RPATH settings.")
   endif()

   set(_abs_LIB_INSTALL_DIR "${LIB_INSTALL_DIR}")
   if(NOT IS_ABSOLUTE "${_abs_LIB_INSTALL_DIR}")
      set(_abs_LIB_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/${LIB_INSTALL_DIR}")
   endif()

   if(UNIX)
      if(APPLE)
 #        set(CMAKE_INSTALL_NAME_DIR ${_abs_LIB_INSTALL_DIR})
      else()
         # add our LIB_INSTALL_DIR to the RPATH (but only when it is not one of the standard system link
         # directories listed in CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES) and use the RPATH figured out
         # by cmake when compiling

#         list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${_abs_LIB_INSTALL_DIR}" _isSystemLibDir)
#         list(FIND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES      "${_abs_LIB_INSTALL_DIR}" _isSystemCxxLibDir)
#         list(FIND CMAKE_C_IMPLICIT_LINK_DIRECTORIES        "${_abs_LIB_INSTALL_DIR}" _isSystemCLibDir)

#         if("${_isSystemLibDir}" STREQUAL "-1" AND "${_isSystemCxxLibDir}" STREQUAL "-1" AND "${_isSystemCLibDir}" STREQUAL "-1")
#            set(CMAKE_INSTALL_RPATH "${_abs_LIB_INSTALL_DIR}")
#         endif()

#         set(CMAKE_SKIP_BUILD_RPATH FALSE)
#         set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
#         set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
#         set(CMAKE_MACOSX_RPATH TRUE)
      endif()
   endif()
endif()


################ Build-related settings ###########################

if(NOT SKIP_BUILD_SETTINGS)
   set(CMAKE_COLOR_MAKEFILE ON)
   set(CMAKE_VERBOSE_MAKEFILE OFF)

   # with cmake >= 2.8.4 a manually specified variable which is not used will produces a warning.
   # However, we do not want this warning for the variable QT_QMAKE_EXECUTABLE.
   set(__suppress_unused_warning_for_QT_QMAKE_EXECUTABLE_var "${QT_QMAKE_EXECUTABLE}")

   # Always include srcdir and builddir in include path
   # This saves typing ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR} in about every subdir
   # since cmake 2.4.0
   set(CMAKE_INCLUDE_CURRENT_DIR ON)

   # put the include dirs which are in the source or build tree
   # before all other include dirs, so the headers in the sources
   # are prefered over the already installed ones
   # since cmake 2.4.1
   set(CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE ON)

   # Add the src and build dir to the BUILD_INTERFACE include directories
   # of all targets. Similar to CMAKE_INCLUDE_CURRENT_DIR, but transitive.
   # Since CMake 2.8.11
   set(CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE ON)

   # When a shared library changes, but its includes do not, don't relink
   # all dependencies. It is not needed.
   # Since CMake 2.8.11
   set(CMAKE_LINK_DEPENDS_NO_SHARED ON)

   # Default to shared libs, if no type is explicitely given to add_library():
   set(BUILD_SHARED_LIBS TRUE CACHE BOOL "If enabled, shared libs will be built by default, otherwise static libs")

   # Enable automoc in cmake
   # Since CMake 2.8.6
   set(CMAKE_AUTOMOC ON)

   set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

   # By default, create 'GUI' executables.
   # Since CMake 2.8.8
   set(CMAKE_WIN32_EXECUTABLE ON)
#   set(CMAKE_MACOSX_BUNDLE ON)

   # By default, don't put a prefix on MODULE targets. add_library(MODULE) is basically for plugin targets,
   # and plugins don't have a prefix.
   set(CMAKE_SHARED_MODULE_PREFIX "")

   set(CMAKE_DEBUG_POSTFIX d)
   set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
   set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)


   # ensure out of source build
   if(NOT DISABLE_FORCE_OUT_OF_SOURCE_BUILD)
     string(COMPARE EQUAL "${CMAKE_SOURCE_DIR}" "${CMAKE_BINARY_DIR}" insource)
     if(insource)
       message(FATAL_ERROR "This project requires an out of source build. Please create a separate build directory and run 'cmake path_to_sources [options]' there.")
     endif()
   endif(NOT DISABLE_FORCE_OUT_OF_SOURCE_BUILD)

   # cleanup ?
   unset(EXECUTABLE_OUTPUT_PATH)
   unset(LIBRARY_OUTPUT_PATH)
   unset(ARCHIVE_OUTPUT_DIRECTORY)
   unset(LIBRARY_OUTPUT_DIRECTORY)
   unset(RUNTIME_OUTPUT_DIRECTORY)
endif()

###################################################################

if(NOT SKIP_INCLUDE)
   include(FeatureSummary)
endif()

###################################################################
