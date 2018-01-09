# Marks an executable target as not being a GUI application.
#
#   evm_mark_nongui_executable(<target1> [<target2> [...]])
#
# This will indicate to CMake that the specified targets should not be included
# in a MACOSX_BUNDLE and should not be WIN32_EXECUTABLEs.  On platforms other
# than MacOS X or Windows, this will have no effect.

#
#
#
function(evm_mark_nongui_executable)
  foreach(_target ${ARGN})
    set_target_properties( ${_target} PROPERTIES WIN32_EXECUTABLE FALSE MACOSX_BUNDLE FALSE)
  endforeach()
endfunction()
