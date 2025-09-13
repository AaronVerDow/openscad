# Modular OpenSCAD Test Configuration
# This is a simplified, modular version of the original CMakeLists.txt
# See ../doc/testing.txt for instructions

cmake_minimum_required(VERSION 3.13)
# Explicitly use new include policy to avoid globally shadowing included modules
cmake_policy(SET CMP0017 NEW)
cmake_policy(SET CMP0057 NEW) # Interpret IN_LIST
cmake_policy(SET CMP0070 NEW) # Allow relative paths for file(GENERATE ...)

###############################
# Include Configuration Modules
###############################

# Load common variables and paths
include(${CMAKE_CURRENT_SOURCE_DIR}/config/test-variables.cmake)

# Load helper functions
include(${CMAKE_CURRENT_SOURCE_DIR}/config/test-functions.cmake)

# Load dependencies and setup
include(${CMAKE_CURRENT_SOURCE_DIR}/config/test-dependencies.cmake)

# Load test command functions
include(${CMAKE_CURRENT_SOURCE_DIR}/config/test-commands.cmake)

###############################
# Configure Templated Files
###############################

# Set up custom commands to run before & after Ctest run.
# 1. Start/stop Virtual Framebuffer for linux/bsd. 2. Pretty Print
message(STATUS "creating CTestCustom.cmake")
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/CTestCustom.template
               ${CMAKE_CURRENT_BINARY_DIR}/CTestCustom.cmake @ONLY)

###############################
# Define Test File Lists
###############################

# Find all scad files
file(GLOB FEATURES_2D_FILES   ${TEST_SCAD_DIR}/2D/features/*.scad)
file(GLOB FEATURES_3D_FILES   ${TEST_SCAD_DIR}/3D/features/*.scad)
file(GLOB ISSUES_2D_FILES     ${TEST_SCAD_DIR}/2D/issues/*.scad)
file(GLOB ISSUES_3D_FILES     ${TEST_SCAD_DIR}/3D/issues/*.scad)
file(GLOB BUGS_2D_FILES       ${TEST_SCAD_DIR}/bugs2D/*.scad)
file(GLOB BUGS_FILES          ${TEST_SCAD_DIR}/bugs/*.scad)
file(GLOB DEPRECATED_3D_FILES ${TEST_SCAD_DIR}/3D/misc/*.scad)

# Format-specific files
file(GLOB SCAD_DXF_FILES      ${TEST_SCAD_DIR}/dxf/*.scad)
file(GLOB SCAD_SVG_FILES      ${TEST_SCAD_DIR}/svg/*.scad)
file(GLOB SCAD_AMF_FILES      ${TEST_SCAD_DIR}/amf/*.scad)
file(GLOB SCAD_NEF3_FILES     ${TEST_SCAD_DIR}/nef3/*.scad)
file(GLOB SCAD_OBJ_FILES      ${TEST_SCAD_DIR}/obj/*.scad)
file(GLOB SCAD_OFF_FILES      ${TEST_SCAD_DIR}/off/*.scad)
file(GLOB SCAD_STL_FILES      ${TEST_SCAD_DIR}/stl/*.scad)
file(GLOB SCAD_3MF_FILES      ${TEST_SCAD_DIR}/3mf/*.scad)

# Example files
file(GLOB EXAMPLE_FILES       ${EXAMPLES_DIR}/*/*.scad)

# 2D examples
list(APPEND EXAMPLE_2D_FILES
  ${EXAMPLES_DIR}/Old/example015.scad
  ${EXAMPLES_DIR}/Advanced/module_recursion.scad
  ${EXAMPLES_DIR}/Functions/list_comprehensions.scad
  ${EXAMPLES_DIR}/Functions/polygon_areas.scad
  ${EXAMPLES_DIR}/Functions/recursion.scad
)

# 3D examples (remove 2D files from 3D examples)
list(APPEND EXAMPLE_3D_FILES ${EXAMPLE_FILES})
list(REMOVE_ITEM EXAMPLE_3D_FILES
  ${EXAMPLES_DIR}/Old/example015.scad
  ${EXAMPLES_DIR}/Advanced/module_recursion.scad
  ${EXAMPLES_DIR}/Functions/list_comprehensions.scad
  ${EXAMPLES_DIR}/Functions/polygon_areas.scad
  ${EXAMPLES_DIR}/Functions/recursion.scad
)

###############################
# Define Test Configurations
###############################

# Clear test config cache variables
foreach(CONFIG $CACHE{TEST_CONFIGS})
  unset(${CONFIG}_TEST_CONFIG CACHE)
endforeach()

# Heavy tests are tests taking more than 5 seconds on a decent 2023 desktop
set_test_config(Heavy FILES
  render-csg-cgal_issue267-normalization-crash
  render-cgal_issue267-normalization-crash
)

# Bugs
set_test_config(Bugs FILES ${BUGS_FILES} ${BUGS_2D_FILES} PREFIXES
 render-cgal render-manifold render-csg-cgal preview-cgal preview-manifold throwntogether-cgal throwntogether-manifold)
set_test_config(Bugs FILES ${BUGS_FILES} PREFIXES
  preview-off render-monotone 
  preview-stl 
  render-stl render-stl-manifold
  render-off render-off-manifold
)

# Examples
set_test_config(Examples FILES ${EXAMPLE_FILES} PREFIXES
  render-cgal render-manifold
  preview-cgal preview-manifold preview-manifold preview throwntogether-cgal throwntogether-manifold 
  render-csg-cgal render-monotone 
  preview-off render-off dump-examples)
set_test_config(Examples FILES ${EXAMPLE_2D_FILES} PREFIXES render-dxf)

###############################
# Include Test Category Modules
###############################

# Load test categories
include(${CMAKE_CURRENT_SOURCE_DIR}/categories/2d-tests.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/categories/3d-tests.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/categories/import-export-tests.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/categories/bug-tests.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/categories/experimental-tests.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/categories/misc-tests.cmake)

###############################
# Additional Test Definitions
###############################

# Examples tests
add_cmdline_test(dump-examples OPENSCAD SUFFIX csg FILES ${EXAMPLE_FILES})
add_cmdline_test(render-cgal   OPENSCAD SUFFIX png FILES ${EXAMPLE_FILES} EXPECTEDDIR render ARGS --render --backend=cgal)
add_cmdline_test(render-manifold OPENSCAD SUFFIX png FILES ${EXAMPLE_FILES} EXPECTEDDIR render ARGS --render --backend=manifold)
add_cmdline_test(preview-cgal  OPENSCAD SUFFIX png FILES ${EXAMPLE_FILES} EXPECTEDDIR preview ARGS --backend=cgal)
add_cmdline_test(preview-manifold OPENSCAD SUFFIX png FILES ${EXAMPLE_FILES} ARGS --backend=manifold)
add_cmdline_test(throwntogether-cgal OPENSCAD SUFFIX png FILES ${EXAMPLE_FILES} EXPECTEDDIR throwntogether ARGS --render --backend=cgal)
add_cmdline_test(throwntogether-manifold OPENSCAD SUFFIX png FILES ${EXAMPLE_FILES} ARGS --render --backend=manifold)

# Special tests
add_cmdline_test(echo         OPENSCAD SUFFIX echo FILES ${TEST_SCAD_DIR}/issues/issue4172-echo-vector-stack-exhaust.scad ARGS --quiet --trace-usermodule-parameters=false)

# Render force tests
add_cmdline_test(render-force-cgal OPENSCAD SUFFIX png FILES ${RENDERFORCETEST_FILES} EXPECTEDDIR render ARGS --render=force --backend=cgal)
add_cmdline_test(render-force-manifold OPENSCAD SUFFIX png FILES ${RENDERFORCETEST_FILES} EXPECTEDDIR render ARGS --render=force --backend=manifold)

# Manifold hard warnings test
add_cmdline_test(render-force-manifold-hardwarnings OPENSCAD SUFFIX png FILES ${MANIFOLDHARDWARNING_FILES} EXPECTEDDIR render ARGS --render=force --backend=manifold --hardwarnings)

# Monotone color scheme test
add_cmdline_test(render-monotone OPENSCAD SUFFIX png FILES ${EXPORT_IMPORT_3D_PREVIEW_FILES} ${SIMPLE_EXPORT_IMPORT_2D_FILES} ARGS --colorscheme=Monotone --render)

# SVG viewbox tests
list(APPEND SVG_VIEWBOX_TESTS
  viewbox_300x400_none viewbox_600x200_none
  viewbox_300x400_meet_xMinYMin viewbox_300x400_meet_xMidYMin viewbox_300x400_meet_xMaxYMin
  viewbox_600x200_meet_xMinYMin viewbox_600x200_meet_xMinYMid viewbox_600x200_meet_xMinYMax
  viewbox_600x200_slice_xMaxYMin viewbox_600x200_slice_xMidYMin viewbox_600x200_slice_xMinYMin
  viewbox_600x600_slice_xMinYMax viewbox_600x600_slice_xMinYMid viewbox_600x600_slice_xMinYMin
)

foreach(SVG_VIEWBOX_TEST ${SVG_VIEWBOX_TESTS})
  add_cmdline_test(svgviewbox-${SVG_VIEWBOX_TEST} SCRIPT ${EXPORT_PNGTEST_PY} SUFFIX png FILES ${TEST_SCAD_DIR}/svg/viewbox_${SVG_VIEWBOX_TEST}.scad ARGS ${OPENSCAD_EXE_ARG} --format=SVG)
endforeach()

# OpenSCAD command line tests
add_cmdline_test(openscad-camcenter OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/camera-tests.scad ARGS --camera=0,0,0,0,0,0,0,0,1 --camera-center=0,0,0)
add_cmdline_test(openscad-camdist OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/camera-tests.scad ARGS --camera=0,0,0,0,0,0,0,0,1 --camera-distance=1)
add_cmdline_test(openscad-cameye OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/camera-tests.scad ARGS --camera=0,0,0,0,0,0,0,0,1 --camera-eye=0,0,0)
add_cmdline_test(openscad-camortho OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/camera-tests.scad ARGS --camera=0,0,0,0,0,0,0,0,1 --camera-ortho)
add_cmdline_test(openscad-camrot OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/camera-tests.scad ARGS --camera=0,0,0,0,0,0,0,0,1 --camera-rotate=1)
add_cmdline_test(openscad-camtrans OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/camera-tests.scad ARGS --camera=0,0,0,0,0,0,0,0,1 --camera-translate=1)

# Color scheme tests
add_cmdline_test(openscad-colorscheme-clearsky OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/color-tests.scad ARGS --colorscheme=ClearSky)
add_cmdline_test(openscad-colorscheme-cornfield OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/color-tests.scad ARGS --colorscheme=Cornfield)
add_cmdline_test(openscad-colorscheme-metallic OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/color-tests.scad ARGS --colorscheme=Metallic)
add_cmdline_test(openscad-colorscheme-monotone OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/color-tests.scad ARGS --colorscheme=Monotone)
add_cmdline_test(openscad-colorscheme-starnight OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/color-tests.scad ARGS --colorscheme=Starnight)
add_cmdline_test(openscad-colorscheme-sunset OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/color-tests.scad ARGS --colorscheme=Sunset)

# Image size and stretch tests
add_cmdline_test(openscad-imgsize OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/image-tests.scad ARGS --imgsize=100,100)
add_cmdline_test(openscad-imgstretch OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/image-tests.scad ARGS --imgstretch=1.5)

# Hard warnings test
add_cmdline_test(openscad-hardwarnings OPENSCAD SUFFIX echo FILES ${TEST_SCAD_DIR}/misc/warning-tests.scad ARGS --hardwarnings)

# Override tests
add_cmdline_test(openscad-override OPENSCAD SUFFIX echo FILES ${TEST_SCAD_DIR}/misc/override-tests.scad ARGS --override=param1=10,param2=20)

###############################
# Debug Information
###############################

# Use cmake option "--log-level DEBUG" during top level config to see this
message(DEBUG "Available test configurations: ${TEST_CONFIGS}")
foreach(CONF ${TEST_CONFIGS})
  list(SORT ${CONF}_TEST_CONFIG)
  message(DEBUG "${CONF}: ${${CONF}_TEST_CONFIG}")
endforeach()
