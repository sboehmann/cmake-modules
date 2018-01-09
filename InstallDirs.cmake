# This module defines a bunch of variables used as locations for install directories
# for files of the package which is using this module. These variables don't say
# anything about the location of the installed CF5.
# They are all relative (to CMAKE_INSTALL_PREFIX).
#
#  BIN_INSTALL_DIR          - the directory where executables will be installed
#  SBIN_INSTALL_DIR         - the directory where system executables will be installed
#  BUNDLE_INSTALL_DIR       - Mac only: the directory where application bundles will be installed
#  LIB_INSTALL_DIR          - the directory where libraries will be installed
#  CMAKE_CONFIG_INSTALL_DIR - the directory wgere CMake configuration files will be installed
#  CONFIG_INSTALL_DIR       - the directory where config files will be installed
#  DATA_INSTALL_DIR         - the parent directory where applications can install their data
#  HTML_INSTALL_DIR         - the directory where HTML documentation will be installed
#  ICON_INSTALL_DIR         - the directory where the icons will be installed
#  INFO_INSTALL_DIR         - the directory where info files will be installed
#  RESOURCE_INSTALL_DIR     - the directory where resource files will be installed
#  LOCALE_INSTALL_DIR       - the directory where translations will be installed
#  PLUGIN_INSTALL_DIR       - the directory where plugins will be installed
#  QT_PLUGIN_INSTALL_DIR    - the directory where Qt plugins will be installed
#  INCLUDE_INSTALL_DIR      - the directory where include files will be installed
#  QML_INSTALL_DIR          - the directory where QML2 imports will be installed
#  MAN_INSTALL_DIR          - the directory where man pages will be installed
#
#
# The variable INSTALL_TARGETS_DEFAULT_ARGS can be used when installing libraries
# or executables into the default locations.
#
# The INSTALL_TARGETS_DEFAULT_ARGS variable should be used when libraries are installed.
# It should also be used when installing applications, since then
# on OS X application bundles will be installed to BUNDLE_INSTALL_DIR.
#
# The variable MUST NOT be used for installing plugins.
# It also MUST NOT be used for executables which are intended to go into sbin/.
#
# Usage is like this:
#    install(TARGETS myApp ${INSTALL_TARGETS_DEFAULT_ARGS} )
#
# This will install libraries correctly under UNIX, OSX and Windows
#

if(NOT CONFIG_DESTINATION_FOUND)
    set(CONFIG_DESTINATION_FOUND TRUE)

    if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
        get_filename_component( INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/install" REALPATH)
        set(CMAKE_INSTALL_PREFIX ${INSTALL_PREFIX} CACHE PATH "Project install prefix" FORCE)
        message("CMAKE_INSTALL_PREFIX initialized to default setting '${CMAKE_INSTALL_PREFIX}'")
    endif()

    set(INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})

    if(WIN32)
      set(RELATIVE_BIN_INSTALL_DIR           ""                )
      set(RELATIVE_SBIN_INSTALL_DIR          ""                )
      set(RELATIVE_BUNDLE_INSTALL_DIR        ""                )
      set(RELATIVE_LIB_INSTALL_DIR           ""                )
      set(RELATIVE_CMAKE_CONFIG_INSTALL_DIR  "cmake"           )
      set(RELATIVE_CONFIG_INSTALL_DIR        "config"          )
      set(RELATIVE_DATA_INSTALL_DIR          "data"            )
      set(RELATIVE_HTML_INSTALL_DIR          "html"            )
      set(RELATIVE_ICON_INSTALL_DIR          "icons"           )
      set(RELATIVE_INFO_INSTALL_DIR          "info"            )
      set(RELATIVE_RESOURCE_INSTALL_DIR      "resources"       )
      set(RELATIVE_LOCALE_INSTALL_DIR        "locale"          )
      set(RELATIVE_PLUGIN_INSTALL_DIR        "plugins"         )
      set(RELATIVE_QT_PLUGIN_INSTALL_DIR     "plugins"         )
      set(RELATIVE_INCLUDE_INSTALL_DIR       "include"         )
      set(RELATIVE_QML_INSTALL_DIR           "qml"             )
      set(RELATIVE_MAN_INSTALL_DIR           "man"             )
    else()
      set(RELATIVE_BIN_INSTALL_DIR           "bin"             )
      set(RELATIVE_SBIN_INSTALL_DIR          "sbin"            )
      set(RELATIVE_BUNDLE_INSTALL_DIR        ""                )
      set(RELATIVE_LIB_INSTALL_DIR           "lib"             )
      set(RELATIVE_CMAKE_CONFIG_INSTALL_DIR  "cmake"           )
      set(RELATIVE_CONFIG_INSTALL_DIR        "share/config"    )
      set(RELATIVE_DATA_INSTALL_DIR          "share/data"      )
      set(RELATIVE_HTML_INSTALL_DIR          "share/html"      )
      set(RELATIVE_ICON_INSTALL_DIR          "share/icons"     )
      set(RELATIVE_INFO_INSTALL_DIR          "share/info"      )
      set(RELATIVE_RESOURCE_INSTALL_DIR      "share/resources" )
      set(RELATIVE_LOCALE_INSTALL_DIR        "share/locale"    )
      set(RELATIVE_PLUGIN_INSTALL_DIR        "share/plugins"   )
      set(RELATIVE_QT_PLUGIN_INSTALL_DIR     "share/plugins"   )
      set(RELATIVE_INCLUDE_INSTALL_DIR       "include"         )
      set(RELATIVE_QML_INSTALL_DIR           "share/qml"       )
      set(RELATIVE_MAN_INSTALL_DIR           "share/man"       )
    endif()

    set(BIN_INSTALL_DIR           "${INSTALL_PREFIX}/${RELATIVE_BIN_INSTALL_DIR}"          )
    set(SBIN_INSTALL_DIR          "${INSTALL_PREFIX}/${RELATIVE_SBIN_INSTALL_DIR}"         )
    set(BUNDLE_INSTALL_DIR        "${INSTALL_PREFIX}/${RELATIVE_BUNDLE_INSTALL_DIR}"       )
    set(LIB_INSTALL_DIR           "${INSTALL_PREFIX}/${RELATIVE_LIB_INSTALL_DIR}"          )
    set(CMAKE_CONFIG_INSTALL_DIR  "${INSTALL_PREFIX}/${RELATIVE_CMAKE_CONFIG_INSTALL_DIR}" )
    set(CONFIG_INSTALL_DIR        "${INSTALL_PREFIX}/${RELATIVE_CONFIG_INSTALL_DIR}"       )
    set(DATA_INSTALL_DIR          "${INSTALL_PREFIX}/${RELATIVE_DATA_INSTALL_DIR}"         )
    set(HTML_INSTALL_DIR          "${INSTALL_PREFIX}/${RELATIVE_HTML_INSTALL_DIR}"         )
    set(ICON_INSTALL_DIR          "${INSTALL_PREFIX}/${RELATIVE_ICON_INSTALL_DIR}"         )
    set(INFO_INSTALL_DIR          "${INSTALL_PREFIX}/${RELATIVE_INFO_INSTALL_DIR}"         )
    set(RESOURCE_INSTALL_DIR      "${INSTALL_PREFIX}/${RELATIVE_RESOURCE_INSTALL_DIR}"     )
    set(LOCALE_INSTALL_DIR        "${INSTALL_PREFIX}/${RELATIVE_LOCALE_INSTALL_DIR}"       )
    set(PLUGIN_INSTALL_DIR        "${INSTALL_PREFIX}/${RELATIVE_PLUGIN_INSTALL_DIR}"       )
    set(QT_PLUGIN_INSTALL_DIR     "${INSTALL_PREFIX}/${RELATIVE_QT_PLUGIN_INSTALL_DIR}"    )
    set(INCLUDE_INSTALL_DIR       "${INSTALL_PREFIX}/${RELATIVE_INCLUDE_INSTALL_DIR}"      )
    set(QML_INSTALL_DIR           "${INSTALL_PREFIX}/${RELATIVE_QML_INSTALL_DIR}"          )
    set(MAN_INSTALL_DIR           "${INSTALL_PREFIX}/${RELATIVE_MAN_INSTALL_DIR}"          )

    set(INSTALL_TARGETS_DEFAULT_ARGS
          RUNTIME  DESTINATION "${BIN_INSTALL_DIR}"     COMPONENT Runtime
          BUNDLE   DESTINATION "${BUNDLE_INSTALL_DIR}"  COMPONENT Runtime
          LIBRARY  DESTINATION "${LIB_INSTALL_DIR}"     COMPONENT Runtime
          ARCHIVE  DESTINATION "${LIB_INSTALL_DIR}"     COMPONENT Devel
          INCLUDES DESTINATION "${INCLUDE_INSTALL_DIR}"
    )

    # on the Mac support an extra install directory for application bundles
    #if(APPLE)
    #    set(INSTALL_TARGETS_DEFAULT_ARGS ${INSTALL_TARGETS_DEFAULT_ARGS} BUNDLE DESTINATION "${BUNDLE_INSTALL_DIR}")
    #endif()

    # new in cmake 2.8.9: this is used for all installed files which do not have a component set
    # so set the default component name to the name of the project, if a project name has been set:
    if(NOT "${PROJECT_NAME}" STREQUAL "Project")
        set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME "${PROJECT_NAME}")
    endif()
endif()
