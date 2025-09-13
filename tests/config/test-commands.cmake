# Test Command Functions
# Functions for adding different types of tests

#
# This functions adds cmd-line tests given files.
#
# Usage add_cmdline_test(testbasename [EXE <executable>] [ARGS <args to exe>]
#                        [SCRIPT <script>]
#                        [EXPECTEDDIR <shared dir>] SUFFIX <suffix> FILES <test files>
#                        [EXPERIMENTAL])
#
# EXPERIMENTAL: If set, tag all tests as experimental
#
function(add_cmdline_test TESTCMD_BASENAME)
  cmake_parse_arguments(TESTCMD "OPENSCAD;STDIO;EXPERIMENTAL" "EXE;SCRIPT;SUFFIX;KERNEL;EXPECTEDDIR" "FILES;ARGS" ${ARGN})

  if(TESTCMD_OPENSCAD)
    set(TESTCMD_EXE ${OPENSCAD_BINPATH})
  else()
    if(TESTCMD_EXE)
      # Use provided executable
    else()
      set(TESTCMD_EXE ${Python3_EXECUTABLE})
    endif()
  endif()

  if(TESTCMD_SCRIPT)
    set(TESTCMD_SCRIPT ${TESTCMD_SCRIPT})
  else()
    set(TESTCMD_SCRIPT ${TEST_CMDLINE_TOOL_PY})
  endif()

  if(TESTCMD_EXPECTEDDIR)
    set(TESTCMD_EXPECTEDDIR ${TESTCMD_EXPECTEDDIR})
  else()
    set(TESTCMD_EXPECTEDDIR ${TESTCMD_BASENAME})
  endif()

  foreach(SCADFILE ${TESTCMD_FILES})
    get_test_fullname(${TESTCMD_BASENAME} ${SCADFILE} TEST_FULLNAME)
    
    # Get test configurations
    get_test_config(${TEST_FULLNAME} FOUNDCONFIGS)
    if (NOT FOUNDCONFIGS)
      set_test_config(Default FILES ${TEST_FULLNAME})
    endif()
    set_test_config(All FILES ${TEST_FULLNAME})
    list(FIND FOUNDCONFIGS Bugs FOUND)
    if (FOUND EQUAL -1)
      set_test_config(Good FILES ${TEST_FULLNAME})
    endif()
    get_test_config(${TEST_FULLNAME} CONFVAL)

    # Check if this is an experimental test
    if(TESTCMD_EXPERIMENTAL)
      set(CONFVAL "Experimental")
    endif()

    # Build command string for debugging
    string(JOIN " " DBG_COMMAND_STR
      "add_test(" ${TEST_FULLNAME} CONFIGURATIONS ${CONFVAL}
      COMMAND ${Python3_EXECUTABLE}
      ${TEST_CMDLINE_TOOL_PY} ${COMPARATOR} -c ${IMAGE_COMPARE_EXE}
      -e ${CCSD}/regression/${TESTCMD_EXPECTEDDIR}
      -a ${CCBD}/tests/output/${TESTCMD_EXPECTEDDIR}
      -s ${TESTCMD_SUFFIX}
      ${TESTCMD_ARGS}
      ${SCADFILE}
    )

    if(NOT TESTCMD_EXPERIMENTAL)
      # Use cmake option "--log-level DEBUG" during top level config to see this
      message(DEBUG "${DBG_COMMAND_STR}")
      add_test(NAME ${TEST_FULLNAME} CONFIGURATIONS ${CONFVAL}
        COMMAND ${Python3_EXECUTABLE}
        ${TEST_CMDLINE_TOOL_PY} ${COMPARATOR} -c ${IMAGE_COMPARE_EXE}
        -e ${CCSD}/regression/${TESTCMD_EXPECTEDDIR}
        -a ${CCBD}/tests/output/${TESTCMD_EXPECTEDDIR}
        -s ${TESTCMD_SUFFIX}
        ${TESTCMD_ARGS}
        ${SCADFILE})
      set_property(TEST ${TEST_FULLNAME} PROPERTY ENVIRONMENT "${CTEST_ENVIRONMENT}")
    else()
      message(DEBUG "Experimental Test not added: ${DBG_COMMAND_STR}")
    endif()
  endforeach()
endfunction()

#
# Usage add_failing_test(testbasename  RETVAL <expected return value>  SUFFIX <suffix>  FILES <test files>
#                        [EXE <executable>] [SCRIPT <script>] [ARGS <args to exe>])
#
function(add_failing_test TESTCMD_BASENAME)
  cmake_parse_arguments(TESTCMD "" "RETVAL;EXE;SCRIPT;SUFFIX" "FILES;ARGS" ${ARGN})

  if(TESTCMD_EXE)
    set(TESTCMD_EXE ${TESTCMD_EXE})
  else()
    set(TESTCMD_EXE ${Python3_EXECUTABLE})
  endif()

  if(TESTCMD_SCRIPT)
    set(TESTCMD_SCRIPT ${TESTCMD_SCRIPT})
  else()
    set(TESTCMD_SCRIPT ${SHOULDFAIL_PY})
  endif()

  foreach(SCADFILE ${TESTCMD_FILES})
    get_test_fullname(${TESTCMD_BASENAME} ${SCADFILE} TEST_FULLNAME)
    
    # Get test configurations
    get_test_config(${TEST_FULLNAME} FOUNDCONFIGS)
    if (NOT FOUNDCONFIGS)
      set_test_config(Default FILES ${TEST_FULLNAME})
    endif()
    set_test_config(All FILES ${TEST_FULLNAME})
    unset(FOUNDCONFIGS)
    get_test_config(${TEST_FULLNAME} FOUNDCONFIGS)
    set(CONFVAL ${FOUNDCONFIGS})

    add_test(NAME ${TEST_FULLNAME} CONFIGURATIONS ${CONFVAL} COMMAND ${TESTCMD_EXE} ${TESTCMD_SCRIPT} "${SCADFILE}" -s ${TESTCMD_SUFFIX} ${TESTCMD_ARGS})
    set_property(TEST ${TEST_FULLNAME} PROPERTY ENVIRONMENT "${CTEST_ENVIRONMENT}")
  endforeach()
endfunction()

#
# Add output file test
#
function(add_output_file_test TESTCMD_BASENAME)
  cmake_parse_arguments(TESTCMD "" "FILE;FORMAT" "" ${ARGN})

  add_test(NAME "${TESTCMD_BASENAME}_${TESTCMD_FORMAT}_run" CONFIGURATIONS Default COMMAND ${OPENSCAD_BINPATH} ${TESTCMD_FILE} -o ${TESTCMD_BASENAME}.${TESTCMD_FORMAT})
  add_test(NAME "${TESTCMD_BASENAME}_${TESTCMD_FORMAT}_check" CONFIGURATIONS Default COMMAND ${CMAKE_COMMAND} -E cat ${TESTCMD_BASENAME}.${TESTCMD_FORMAT})
  set_tests_properties("${TESTCMD_BASENAME}_${TESTCMD_FORMAT}_check" PROPERTIES DEPENDS "${TESTCMD_BASENAME}_${TESTCMD_FORMAT}_run")
endfunction()
