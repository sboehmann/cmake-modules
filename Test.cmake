include(CMakeParseArguments)
include(MarkNonGuiExecutable)

# Add test executables.
#
#   qc_add_test(<sources>
#                  LINK_LIBRARIES <library> [<library> [...]]
#                  [NAME_PREFIX <prefix>]
#                  GUI)

function(QC_ADD_TEST)
    set(options GUI)
    set(oneValueArgs TEST_NAME NAME_PREFIX)
    set(multiValueArgs LINK_LIBRARIES)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT BUILD_TESTING)
        return()
    endif()

    find_package(Qt5Test ${REQUIRED_QT_VERSION} NO_MODULE)
    if(NOT Qt5Test_FOUND)
        return()
    endif()

    set(_sources ${ARG_UNPARSED_ARGUMENTS})
    list(LENGTH _sources _sourceCount)

    if(ARG_TEST_NAME)
        set(_targetname ${ARG_TEST_NAME})
    elseif(${_sourceCount} EQUAL "1")
        #use the source file name without extension as the testname
        get_filename_component(_targetname ${_sources} NAME_WE)
    else()
        #more than one source file passed, but no test name given -> error
        message(FATAL_ERROR "qc_add_test() called with multiple source files but without setting \"TEST_NAME\"")
    endif()

    set(_testname "${ARG_NAME_PREFIX}${_targetname}")
    if(ARG_NAME_PREFIX)
        set(_testname "${ARG_NAME_PREFIX}_${_targetname}")
    endif()

    remove_definitions(-DQT_NO_CAST_TO_ASCII)
    remove_definitions(-DQT_NO_CAST_FROM_ASCII)
    remove_definitions(-DQT_NO_CAST_FROM_BYTEARRAY)
    remove_definitions(-DQT_NO_URL_CAST_FROM_STRING)
    remove_definitions(-DQT_STRICT_ITERATORS)

    add_executable(tst_${_testname} ${_sources})
    if(NOT ARG_GUI)
        evm_mark_nongui_executable(tst_${_testname})
    endif()

    add_test(NAME ${_testname} COMMAND tst_${_testname} -tickcounter)
    target_link_libraries(tst_${_testname} ${ARG_LINK_LIBRARIES} Qt5::Core Qt5::Test)
endfunction()


#
#
#
function(QC_ADD_TESTS)
    set(options GUI)
    set(oneValueArgs NAME_PREFIX)
    set(multiValueArgs LINK_LIBRARIES COMMON_SOURCES)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(_gui "")
    if(ARG_GUI)
        set(_gui GUI)
    endif()

    foreach(_tstsrc ${ARG_UNPARSED_ARGUMENTS})
        #use the source file name without extension as the testname
        get_filename_component(_targetname ${_tstsrc} NAME_WE)
        qc_add_test(${_tstsrc} ${ARG_COMMON_SOURCES}
            TEST_NAME ${_targetname}
            NAME_PREFIX ${ARG_NAME_PREFIX}
            LINK_LIBRARIES ${ARG_LINK_LIBRARIES}
            ${_gui}
        )
    endforeach()
endfunction()
