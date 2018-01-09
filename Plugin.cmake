include(CMakeParseArguments)

#
#
#
function(QC_ADD_PLUGIN)
    set(optionArgs "")
    set(oneValueArgs NAME)
    set(multiValueArgs SOURCES)
    cmake_parse_arguments(ARG "${optionArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    add_definitions("-DQT_PLUGIN")
    add_definitions("-DQC_PLUGIN")
    add_library(${ARG_NAME} SHARED ${ARG_SOURCES})
    set_target_properties(${ARG_NAME} PROPERTIES PREFIX "")

    set_target_properties(${ARG_NAME} PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/plugins"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/plugins"
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/plugins"
    )
    set_target_properties(${ARG_NAME} PROPERTIES CXX_STANDARD 14)
    set_target_properties(${ARG_NAME} PROPERTIES CXX_STANDARD_REQUIRED ON)
endfunction()

#
#
#
function(QC_INSTALL_PLUGIN targetName)
    install(TARGETS ${targetName} DESTINATION ${PLUGIN_INSTALL_DIR})
endfunction()
