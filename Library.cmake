include(CMakeParseArguments)
include(CMakePackageConfigHelpers)

#
#
#
function(QC_ADD_LIBRARY)
    set(optionArgs STATIC NOEXPORT NOAUTOMOC)
    set(oneValueArgs TARGET NS ALIAS EXPORT_BASE_NAME)
    set(multiValueArgs "")
    cmake_parse_arguments(ARG "${optionArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    if(NOT ARG_TARGET)
        message(FATAL_ERROR "QC_ADD_LIBRARY: No TARGET provided.")
    endif()

    if(NOT ARG_NS)
        message(FATAL_ERROR "QC_ADD_LIBRARY: No NS provided.")
    endif()

    if(NOT ARG_NOEXPORT)
        set(CMAKE_CXX_VISIBILITY_PRESET hidden)
        set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
    endif()

    if(ARG_STATIC)
        add_library(${ARG_TARGET} STATIC ${ARG_UNPARSED_ARGUMENTS})
        if(NOT ARG_NOEXPORT)
            string(TOUPPER ${ARG_TARGET} uppercase_target)

            if(ARG_EXPORT_BASE_NAME)
                string(TOUPPER ${ARG_EXPORT_BASE_NAME} uppercase_target)
            endif()

            add_definitions("-D${uppercase_target}_STATIC_DEFINE")
       endif()
    else(ARG_STATIC)
       add_library(${ARG_TARGET} SHARED ${ARG_UNPARSED_ARGUMENTS})
    endif()

    add_library("${ARG_NS}::${ARG_TARGET}" ALIAS ${ARG_TARGET})
    if(ARG_ALIAS)
        add_library(${ARG_ALIAS} ALIAS ${ARG_TARGET})
    endif()

    string(TOLOWER ${ARG_TARGET} LIBFILENAME)
    string(TOLOWER ${ARG_NS} LIBFILEPREFIX)
    set(LIBFILE "${LIBFILEPREFIX}_${LIBFILENAME}")

    if(NOT ARG_NOEXPORT)
        if(ARG_EXPORT_BASE_NAME)
            generate_export_header(${ARG_TARGET} BASE_NAME ${ARG_EXPORT_BASE_NAME})
        else()
            generate_export_header(${ARG_TARGET} BASE_NAME ${LIBFILE})
        endif()
    endif()

    set_target_properties(${ARG_TARGET} PROPERTIES OUTPUT_NAME ${LIBFILE})
    set_target_properties(${ARG_TARGET} PROPERTIES VERSION "${PROJECT_VERSION}" SOVERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}")
    set_target_properties(${ARG_TARGET} PROPERTIES CXX_STANDARD 17)
    set_target_properties(${ARG_TARGET} PROPERTIES CXX_STANDARD_REQUIRED ON)
    set_target_properties(${ARG_TARGET} PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${INCLUDE_INSTALL_DIR}/${ARG_NS}/${ARG_TARGET}")

    if(NOT ARG_NOAUTOMOC)
        set_target_properties(${ARG_TARGET} PROPERTIES AUTOMOC ON)
    endif()

    set_property(TARGET ${ARG_TARGET}
        APPEND PROPERTY INCLUDE_DIRECTORIES ${PROJECT_BINARY_DIR} ${PROJECT_SOURCE_DIR}
    )

    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${ARG_NS}${ARG_TARGET}Config.cmake.in")
        configure_package_config_file(
            "${CMAKE_CURRENT_SOURCE_DIR}/${ARG_NS}${ARG_TARGET}Config.cmake.in"
            "${CMAKE_CURRENT_BINARY_DIR}/${ARG_NS}${ARG_TARGET}Config.cmake"
          INSTALL_DESTINATION ${CMAKE_CONFIG_INSTALL_DIR}
          PATH_VARS INCLUDE_INSTALL_DIR
        )
        write_basic_package_version_file("${ARG_NS}${ARG_TARGET}ConfigVersion.cmake"
          VERSION ${PROJECT_VERSION} COMPATIBILITY SameMajorVersion
        )
    endif()
endfunction()

#
#
#
function(QC_INSTALL_LIBRARY)
    set(optionArgs NOEXPORT)
    set(oneValueArgs TARGET NS)
    set(multiValueArgs DIRECTORIES)
    cmake_parse_arguments(ARG "${optionArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT ARG_TARGET)
        message(FATAL_ERROR "QC_INSTALL_LIBRARY: No TARGET provided.")
    endif()

    if(NOT ARG_NS)
        message(FATAL_ERROR "QC_INSTALL_LIBRARY: No NS provided.")
    endif()

    install(TARGETS ${ARG_TARGET} EXPORT "${ARG_NS}${ARG_TARGET}Targets" ${INSTALL_TARGETS_DEFAULT_ARGS})
    install(EXPORT "${ARG_NS}${ARG_TARGET}Targets" DESTINATION "${CMAKE_CONFIG_INSTALL_DIR}" NAMESPACE "${ARG_NS}::")

    file(GLOB INSTALL_HEADERS "${PROJECT_BINARY_DIR}/*.h")
    install(FILES ${INSTALL_HEADERS} DESTINATION ${INCLUDE_INSTALL_DIR}/${ARG_NS}/${ARG_TARGET})

    foreach(_DIR ${ARG_DIRECTORIES})
        file(GLOB INSTALL_HEADERS "${PROJECT_SOURCE_DIR}/${_DIR}/*.h")
        file(MAKE_DIRECTORY ${INCLUDE_INSTALL_DIR}/${ARG_NS}/${ARG_TARGET}/${_DIR})

        install(FILES ${INSTALL_HEADERS} DESTINATION ${INCLUDE_INSTALL_DIR}/${ARG_NS}/${ARG_TARGET}/${_DIR})
    endforeach(_DIR ${ARG_DIRECTORIES})

    file(GLOB INSTALL_HEADERS "${PROJECT_SOURCE_DIR}/*.h")
    install(FILES ${INSTALL_HEADERS} DESTINATION ${INCLUDE_INSTALL_DIR}/${ARG_NS}/${ARG_TARGET})

    file(GLOB INSTALL_HEADERS "${PROJECT_BINARY_DIR}/${ARG_NS}/${ARG_TARGET}/*")
    install(FILES ${INSTALL_HEADERS} DESTINATION ${INCLUDE_INSTALL_DIR}/${ARG_NS}/${ARG_TARGET})

    file(GLOB INSTALL_CMAKE "${PROJECT_BINARY_DIR}/*Config.cmake")
    install(FILES ${INSTALL_CMAKE} DESTINATION ${CMAKE_CONFIG_INSTALL_DIR})

    file(GLOB INSTALL_CMAKE "${PROJECT_BINARY_DIR}/*ConfigVersion.cmake")
    install(FILES ${INSTALL_CMAKE} DESTINATION ${CMAKE_CONFIG_INSTALL_DIR})
endfunction()
