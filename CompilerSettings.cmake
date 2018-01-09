#
# This module sets up CMAKE_CXX_FLAGS for a set of predefined buildtypes as documented below.
#
#  A note on the possible values for CMAKE_BUILD_TYPE and how they are handles:
#
#  Release
#      optimised for speed, qDebug/qCDebug turned off, no debug symbols, no asserts
#
#  RelWithDebInfo (Release with debug info)
#      similar to Release, optimised for speed, but with debugging symbols on (-g)
#
#  Debug
#      optimised but debuggable, debugging on (-g)
#      (-fno-reorder-blocks -fno-schedule-insns -fno-inline)
#
#  DebugFull
#      No optimisation, full debugging on (-g3)
#
#  Profile
#      DebugFull + -ftest-coverage -fprofile-arcs
#
#  The default buildtype is RelWithDebInfo.
#
#  It is expected that the "Debug" build type be still debuggable with gdb without going
#  all over the place, but still produce better performance.
#  It's also important to note that gcc cannot detect all warning conditions unless the
#  optimiser is active.

include(CheckCXXCompilerFlag)
include(GenerateExportHeader)

if( NOT CONFIG_COMPILER_FOUND )
    set(CONFIG_COMPILER_FOUND TRUE)

    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)

    # Set a default build type for single-configuration CMake generators if no build type is set.
    if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE RelWithDebInfo)
    endif()

    ######################################################
    #  Qt releated stuff
    ######################################################

    # Disable functions deprecated in version 6.0.0 of Qt or any earlier version.
    add_definitions(-DQT_DISABLE_DEPRECATED_BEFORE=0x060000)

    # Disable some implicit casts for QString and QByteArray
    # use QStringLiteral, QByteArrayLiteral or QLatin1String instead.
    add_definitions(-DQT_NO_CAST_TO_ASCII)
    add_definitions(-DQT_NO_CAST_FROM_ASCII)
    add_definitions(-DQT_NO_CAST_FROM_BYTEARRAY)

    # Disables automatic conversions from QString (or char *) to QUrl to avoid missing QUrl::resolved() calls
    add_definitions(-DQT_NO_URL_CAST_FROM_STRING)

    # Defining that macro while using Qt disables the Qt keywords ‘signals’ and ‘slots’, forcing the
    # user to use the alternative keywords ‘Q_SIGNALS’ and ‘Q_SLOTS’ instead.
    # This is desirable when using boost, which uses ‘signals’ itself, and when using some Mac headers
    # which use ‘slots’.
    #add_definitions(-DQT_NO_SIGNALS_SLOTS_KEYWORDS)

    # Use most convenient syntax for fast String/StringBuilder concatenation everywhere (see QString api)
    add_definitions(-DQT_USE_FAST_CONCATENATION -DQT_USE_FAST_OPERATOR_PLUS)

    # Avoid assign non-const iterators to const-iterators for performance ressons.
    add_definitions(-DQT_STRICT_ITERATORS)

    ######################################################
    #  the platform specific stuff
    ######################################################

    if(WIN32)
        # windows, microsoft compiler
        if(MSVC OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
            set(__PLATFORM_DEFINITIONS -DWIN32_LEAN_AND_MEAN)

            # C4250: 'class1' : inherits 'class2::member' via dominance
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4250")

            # C4251: 'identifier' : class 'type' needs to have dll-interface to be used by clients of class 'type2'
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4251")

            # C4396: 'identifier' : 'function' the inline specifier cannot be used when a friend declaration refers
            # to a specialization of a function template
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4396")

            # 'identifier' : no suitable definition provided for explicit template instantiation request
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4661")

            # to avoid a lot of deprecated warnings
            set(__PLATFORM_DEFINITIONS ${__PLATFORM_DEFINITIONS} -D_CRT_SECURE_NO_DEPRECATE -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_SCL_SECURE_NO_WARNINGS)
        endif()

        # we don't support anything below w2k and all winapi calls are unicodes
        set(__PLATFORM_DEFINITIONS ${_CF5_PLATFORM_DEFINITIONS} -D_WIN32_WINNT=0x0501 -DWINVER=0x0501 -D_WIN32_IE=0x0501 -DUNICODE)
    endif()

    if(APPLE)
    endif()

    ############################################################
    # compiler specific settings
    ############################################################

    if(CMAKE_BUILD_TYPE)
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "DebugFull" "Release" "RelWithDebInfo" "Profile")
    endif()

    if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        if("${CMAKE_CXX_COMPILER_VERSION}" VERSION_LESS "5.2.0")
            message(FATAL_ERROR "GCC 5.2.0 or later is required")
        endif()

        set(CMAKE_CXX_FLAGS_RELEASE        "-O2 -DNDEBUG -DQT_NO_DEBUG")
        set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
        set(CMAKE_CXX_FLAGS_DEBUG          "-g -O2 -fno-reorder-blocks -fno-schedule-insns -fno-inline")
        set(CMAKE_CXX_FLAGS_DEBUGFULL      "-g3 -fno-inline")
        set(CMAKE_CXX_FLAGS_PROFILE        "-g3 -fno-inline -ftest-coverage -fprofile-arcs")

        set(CMAKE_C_FLAGS_RELEASE          "-O2 -DNDEBUG -DQT_NO_DEBUG")
        set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
        set(CMAKE_C_FLAGS_DEBUG            "-g -O2 -fno-reorder-blocks -fno-schedule-insns -fno-inline")
        set(CMAKE_C_FLAGS_DEBUGFULL        "-g3 -fno-inline")
        set(CMAKE_C_FLAGS_PROFILE          "-g3 -fno-inline -ftest-coverage -fprofile-arcs")

        set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -std=iso9899:2011 -Wundef -Wcast-align -Werror-implicit-function-declaration -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -Wmissing-format-attribute -fno-common")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -fno-exceptions -DQT_NO_EXCEPTIONS -fno-check-new -fno-common")

        set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-undefined")

        # gcc under Windows
        if(MINGW)
            set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--export-all-symbols")
            set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--export-all-symbols")
        endif()

        check_cxx_compiler_flag(-Woverloaded-virtual __HAVE_W_OVERLOADED_VIRTUAL)
        if(__HAVE_W_OVERLOADED_VIRTUAL)
            set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Woverloaded-virtual")
        endif()

        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror=return-type")
    endif()


    if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        set(CMAKE_CXX_FLAGS_RELEASE        "-O2 -DNDEBUG -DQT_NO_DEBUG")
        set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
        set(CMAKE_CXX_FLAGS_DEBUG          "-g -O2 -fno-inline")
        set(CMAKE_CXX_FLAGS_DEBUGFULL      "-g3 -fno-inline")
        set(CMAKE_CXX_FLAGS_PROFILE        "-g3 -fno-inline -ftest-coverage -fprofile-arcs")

        set(CMAKE_C_FLAGS_RELEASE          "-O2 -DNDEBUG -DQT_NO_DEBUG")
        set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
        set(CMAKE_C_FLAGS_DEBUG            "-g -O2 -fno-inline")
        set(CMAKE_C_FLAGS_DEBUGFULL        "-g3 -fno-inline")
        set(CMAKE_C_FLAGS_PROFILE          "-g3 -fno-inline -ftest-coverage -fprofile-arcs")

        set(CMAKE_EXE_LINKER_FLAGS_COVERAGE "${CMAKE_EXE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
        set(CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
        set(CMAKE_MODULE_LINKER_FLAGS_PROFILE "${CMAKE_MODULE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")

        set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -std=iso9899:2011 -Wundef -Wcast-align -Werror-implicit-function-declaration -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -Wmissing-format-attribute -fno-common")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x -Wnon-virtual-dtor -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -Woverloaded-virtual -fno-common -Werror=return-type")
    endif()
endif()
