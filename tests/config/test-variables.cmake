# Test Variables Configuration
# Common variables and paths used throughout the test system

# Use variables for common paths, to reduce line lengths.

# Very commonly used cmake-provided paths
set(CBD ${CMAKE_BINARY_DIR}) # build top level
set(CSD ${CMAKE_SOURCE_DIR}) # project top level
set(CCBD ${CMAKE_CURRENT_BINARY_DIR}) # tests build dir
set(CCSD ${CMAKE_CURRENT_SOURCE_DIR}) # tests source dir

# Project paths
set(LIBRARIES_DIR       "${CSD}/libraries")
set(EXAMPLES_DIR        "${CSD}/examples")

# Test Data paths
set(TEST_DATA_DIR       "${CCSD}/data")
set(TEST_SCAD_DIR       "${CCSD}/data/scad")
set(TEST_CUSTOMIZER_DIR "${CCSD}/data/scad/customizer")
set(TEST_PYTHON_DIR     "${CCSD}/data/python")

# Test runner Python scripts
set(STLEXPORTSANITYTEST_PY "${CCSD}/stlexportsanitytest.py")
set(EXPORT_IMPORT_PNGTEST_PY     "${CCSD}/export_import_pngtest.py")
set(EXPORT_PNGTEST_PY    "${CCSD}/export_pngtest.py")
set(SHOULDFAIL_PY        "${CCSD}/shouldfail.py")
set(TEST_CMDLINE_TOOL_PY "${CCSD}/test_cmdline_tool.py")

# Test configuration options
option(USE_IMAGE_COMPARE_PY "Use built-in image_compare.py" ON)

# Test configurations
set(TEST_CONFIGS "Default" "Heavy" "Examples" "Bugs" "All" "Good")
