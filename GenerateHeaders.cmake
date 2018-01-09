include(CMakeParseArguments)

function(QC_UPDATE_FILE_CONTENT file content)
    set(content "// WARNING! All changes made in this file will be lost!\n${content}\n")
    if(EXISTS "${file}")
        set(current_content)
        file(READ "${file}" current_content)
        if("${current_content}" STREQUAL "${content}")
            return()
        endif()
    endif()

    file(WRITE ${file} "${content}")
endfunction()

#
#
#
function(QC_GENERATE_HEADERS)
    set(optionArgs NOTARGET)
    set(oneValueArgs TARGET NS)
    set(multiValueArgs "")
    cmake_parse_arguments(ARG "${optionArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT ARG_TARGET)
        if(NOT ARG_NOTARGET)
            message(FATAL_ERROR "QC_GENERATE_HEADERS: No TARGET provided.")
        endif()

        set(ARG_TARGET "")
    endif()

    if(NOT ARG_NS)
        message(FATAL_ERROR "QC_GENERATE_HEADERS: No NS provided.")
    endif()

    set(ARG_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})

    foreach(_CLASSNAME ${ARG_UNPARSED_ARGUMENTS})
        string(TOLOWER ${_CLASSNAME} includefile)
        get_filename_component(fileName ${_CLASSNAME} NAME)
        string(TOLOWER ${fileName} lowercasefilename)

        set(FANCY_HEADER_NAME ${ARG_OUTPUT_DIR}/${ARG_NS}/${ARG_TARGET}/${fileName})

        if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${includefile}.h")
            message(FATAL_ERROR "Could not find \"${includefile}.h\"")
        endif()

        if(ARG_NOTARGET)
            qc_update_file_content("${FANCY_HEADER_NAME}" "#include \"${includefile}.h\"")
        else()
            qc_update_file_content("${FANCY_HEADER_NAME}" "#include \"../${ARG_TARGET}/${includefile}.h\"")

            if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../${ARG_TARGET}/${includefile}.h")
                qc_update_file_content("${CMAKE_CURRENT_BINARY_DIR}/../${ARG_TARGET}/${includefile}.h" "#include \"${CMAKE_CURRENT_SOURCE_DIR}/${includefile}.h\"")
            endif()
        endif()
    endforeach()
endfunction()
