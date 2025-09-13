# Modular OpenSCAD Test Configuration v2
# This version avoids duplicate test definitions by using a cleaner approach
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

# Misc files
list(APPEND MISC_FILES
  ${TEST_SCAD_DIR}/misc/arg-permutations.scad
  ${TEST_SCAD_DIR}/misc/escape-test.scad
  ${TEST_SCAD_DIR}/misc/include-tests.scad
  ${TEST_SCAD_DIR}/misc/include-overwrite-main.scad
  ${TEST_SCAD_DIR}/misc/include-overwrite-main2.scad
  ${TEST_SCAD_DIR}/misc/use-tests.scad
  ${TEST_SCAD_DIR}/misc/assert-tests.scad
  ${TEST_SCAD_DIR}/misc/let-module-tests.scad
  ${TEST_SCAD_DIR}/misc/localfiles-test.scad
  ${TEST_SCAD_DIR}/misc/parser-tests.scad
  ${TEST_SCAD_DIR}/misc/builtin-tests.scad
  ${TEST_SCAD_DIR}/misc/dim-all.scad
  ${TEST_SCAD_DIR}/misc/string-test.scad
  ${TEST_SCAD_DIR}/misc/string-indexing.scad
  ${TEST_SCAD_DIR}/misc/string-unicode.scad
  ${TEST_SCAD_DIR}/misc/chr-tests.scad
  ${TEST_SCAD_DIR}/misc/ord-tests.scad
  ${TEST_SCAD_DIR}/misc/vector-values.scad
  ${TEST_SCAD_DIR}/misc/search-tests.scad
  ${TEST_SCAD_DIR}/misc/search-tests-unicode.scad
  ${TEST_SCAD_DIR}/misc/recursion-test-function.scad
  ${TEST_SCAD_DIR}/misc/recursion-test-function2.scad
  ${TEST_SCAD_DIR}/misc/recursion-test-function3.scad
  ${TEST_SCAD_DIR}/misc/recursion-test-module.scad
  ${TEST_SCAD_DIR}/misc/tail-recursion-tests.scad
  ${TEST_SCAD_DIR}/misc/value-reassignment-tests.scad
  ${TEST_SCAD_DIR}/misc/value-reassignment-tests2.scad
  ${TEST_SCAD_DIR}/misc/variable-scope-tests.scad
  ${TEST_SCAD_DIR}/misc/scope-assignment-tests.scad
  ${TEST_SCAD_DIR}/misc/lookup-tests.scad
  ${TEST_SCAD_DIR}/misc/expression-shortcircuit-tests.scad
  ${TEST_SCAD_DIR}/misc/parent_module-tests.scad
  ${TEST_SCAD_DIR}/misc/children-tests.scad
  ${TEST_SCAD_DIR}/misc/range-tests.scad
  ${TEST_SCAD_DIR}/misc/no-break-space-test.scad
  ${TEST_SCAD_DIR}/misc/unicode-tests.scad
  ${TEST_SCAD_DIR}/misc/utf8-tests.scad
  ${TEST_SCAD_DIR}/misc/nbsp-utf8-test.scad
  ${TEST_SCAD_DIR}/misc/nbsp-latin1-test.scad
  ${TEST_SCAD_DIR}/misc/concat-tests.scad
  ${TEST_SCAD_DIR}/misc/include-recursive-test.scad
  ${TEST_SCAD_DIR}/misc/errors-warnings.scad
  ${TEST_SCAD_DIR}/misc/errors-warnings-included.scad
  ${TEST_SCAD_DIR}/misc/children-warnings-tests.scad
  ${TEST_SCAD_DIR}/misc/isundef-test.scad
  ${TEST_SCAD_DIR}/misc/islist-test.scad
  ${TEST_SCAD_DIR}/misc/isnum-test.scad
  ${TEST_SCAD_DIR}/misc/isbool-test.scad
  ${TEST_SCAD_DIR}/misc/isstring-test.scad
  ${TEST_SCAD_DIR}/misc/operators-tests.scad
  ${TEST_SCAD_DIR}/misc/expression-precedence.scad
  ${TEST_SCAD_DIR}/misc/builtins-calling-vec3vec2.scad
  ${TEST_SCAD_DIR}/misc/leaf-module-warnings.scad
  ${TEST_SCAD_DIR}/issues/issue1472.scad
  ${TEST_SCAD_DIR}/misc/empty-stl.scad
  ${TEST_SCAD_DIR}/issues/issue1516.scad
  ${TEST_SCAD_DIR}/issues/issue1528.scad
  ${TEST_SCAD_DIR}/issues/issue1923.scad
  ${TEST_SCAD_DIR}/misc/preview_variable.scad
)

# Function test files
file(GLOB FUNCTION_FILES ${TEST_SCAD_DIR}/functions/*.scad)

# Redefinition test files
file(GLOB REDEFINITION_FILES ${TEST_SCAD_DIR}/redefinition/*.scad)

# Failing tests
list(APPEND FAILING_FILES
  ${TEST_SCAD_DIR}/issues/issue1890-comment.scad
  ${TEST_SCAD_DIR}/issues/issue1890-include.scad
  ${TEST_SCAD_DIR}/issues/issue1890-string.scad
  ${TEST_SCAD_DIR}/issues/issue1890-use.scad
)

# AST dump tests
list(APPEND ASTDUMP_FILES ${MISC_FILES}
  ${TEST_SCAD_DIR}/functions/assert-expression-fail1-test.scad
  ${TEST_SCAD_DIR}/functions/assert-expression-fail2-test.scad
  ${TEST_SCAD_DIR}/functions/assert-expression-fail3-test.scad
  ${TEST_SCAD_DIR}/functions/assert-expression-tests.scad
  ${TEST_SCAD_DIR}/functions/echo-expression-tests.scad
  ${TEST_SCAD_DIR}/functions/expression-precedence-tests.scad
  ${TEST_SCAD_DIR}/functions/let-test-single.scad
  ${TEST_SCAD_DIR}/functions/let-tests.scad
  ${TEST_SCAD_DIR}/functions/list-comprehensions.scad
  ${TEST_SCAD_DIR}/functions/exponent-operator-test.scad
  ${TEST_SCAD_DIR}/misc/ifelse-ast-dump.scad
  ${TEST_SCAD_DIR}/svg/id-layer-selection-test.scad
)

# Echo tests
list(APPEND ECHO_FILES ${FUNCTION_FILES} ${MISC_FILES} ${REDEFINITION_FILES}
  ${TEST_SCAD_DIR}/3D/features/for-tests.scad
  ${TEST_SCAD_DIR}/3D/features/rotate-parameters.scad
  ${TEST_SCAD_DIR}/3D/features/linear_extrude-parameter-tests.scad
  ${TEST_SCAD_DIR}/misc/expression-evaluation-tests.scad
  ${TEST_SCAD_DIR}/misc/echo-tests.scad
)

# Combine test files for different test types
list(APPEND DUMP_FILES ${FEATURES_2D_FILES} ${FEATURES_3D_FILES} ${DEPRECATED_3D_FILES} ${MISC_FILES})

# 2D tests
list(APPEND RENDER_2D_FILES ${FEATURES_2D_FILES} ${SCAD_DXF_FILES} ${ISSUES_2D_FILES} ${EXAMPLE_2D_FILES})
list(APPEND ALL_2D_FILES
  ${FEATURES_2D_FILES}
  ${ISSUES_2D_FILES}
  ${EXAMPLE_2D_FILES}
  ${SCAD_DXF_FILES}
  ${SCAD_SVG_FILES}
  ${TEST_SCAD_DIR}/2D/features/text-metrics.scad
)

# 3D tests
list(APPEND RENDER_3D_FILES ${FEATURES_3D_FILES} ${SCAD_AMF_FILES} ${DEPRECATED_3D_FILES} ${ISSUES_3D_FILES} ${EXAMPLE_3D_FILES} ${SCAD_NEF3_FILES})
list(APPEND RENDER_3D_FILES
  ${TEST_SCAD_DIR}/misc/include-tests.scad
  ${TEST_SCAD_DIR}/misc/use-tests.scad
  ${TEST_SCAD_DIR}/misc/assert-tests.scad
  ${TEST_SCAD_DIR}/misc/let-module-tests.scad
  ${TEST_SCAD_DIR}/misc/localfiles-test.scad
)

# Import tests
list(APPEND STL_IMPORT_FILES
  ${TEST_SCAD_DIR}/stl/stl-import-invalidvertex.scad
  ${TEST_SCAD_DIR}/stl/stl-import-toomanyvertices.scad
  ${TEST_SCAD_DIR}/stl/stl-import-unparseable.scad
  ${TEST_SCAD_DIR}/stl/stl-import-centered.scad
)

list(APPEND OBJ_IMPORT_FILES ${TEST_SCAD_DIR}/obj/obj-import-centered.scad)
list(APPEND 3MF_IMPORT_FILES ${TEST_SCAD_DIR}/3mf/3mf-import-centered.scad)
list(APPEND OFF_IMPORT_FILES ${TEST_SCAD_DIR}/off/off-import-centered.scad)

# Combine all render files
list(APPEND ALL_RENDER_FILES ${RENDER_2D_FILES} ${RENDER_3D_FILES} ${BUGS_FILES} ${BUGS_2D_FILES})

# Preview only files
list(APPEND PREVIEW_ONLY_FILES
  ${TEST_SCAD_DIR}/3D/features/child-background.scad
  ${TEST_SCAD_DIR}/3D/features/highlight-and-background-modifier.scad
  ${TEST_SCAD_DIR}/3D/features/highlight-modifier2.scad
  ${TEST_SCAD_DIR}/3D/features/background-modifier2.scad
  ${TEST_SCAD_DIR}/2D/issues/issue5574.scad
)

# Color tests
list(APPEND COLOR_3D_TEST_FILES
  ${TEST_SCAD_DIR}/misc/color-cubes.scad
  ${TEST_SCAD_DIR}/3D/features/color-tests3.scad
  ${TEST_SCAD_DIR}/3D/features/linear_extrude-parameter-tests.scad
  ${TEST_SCAD_DIR}/3D/features/resize-tests.scad
)

# Combine all preview files (excluding render files to avoid duplicates)
list(APPEND ALL_PREVIEW_FILES ${3MF_IMPORT_FILES} ${OBJ_IMPORT_FILES} ${OFF_IMPORT_FILES} ${STL_IMPORT_FILES} ${PREVIEW_ONLY_FILES})

# Create a separate list for render files that should also be tested in preview mode
# (excluding the preview-only files to avoid duplicates)
list(APPEND RENDER_FOR_PREVIEW ${ALL_RENDER_FILES})
list(REMOVE_ITEM RENDER_FOR_PREVIEW ${PREVIEW_ONLY_FILES})

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
# Test Definitions
###############################

# Basic tests
add_cmdline_test(dump           OPENSCAD SUFFIX csg FILES ${DUMP_FILES})
add_cmdline_test(echo           OPENSCAD SUFFIX echo FILES ${ECHO_FILES})
add_cmdline_test(astdump        OPENSCAD SUFFIX ast FILES ${ASTDUMP_FILES})

# Render tests - use combined lists to avoid duplicates
add_cmdline_test(render-cgal    OPENSCAD SUFFIX png FILES ${ALL_RENDER_FILES} EXPECTEDDIR render ARGS --render --backend=cgal)
add_cmdline_test(render-manifold OPENSCAD SUFFIX png FILES ${ALL_RENDER_FILES} EXPECTEDDIR render ARGS --render --backend=manifold)
add_cmdline_test(preview-cgal   OPENSCAD SUFFIX png FILES ${ALL_PREVIEW_FILES} ${RENDER_FOR_PREVIEW} EXPECTEDDIR preview ARGS --backend=cgal)
add_cmdline_test(preview-manifold OPENSCAD SUFFIX png FILES ${ALL_PREVIEW_FILES} ${RENDER_FOR_PREVIEW} ARGS --backend=manifold)
add_cmdline_test(throwntogether-cgal OPENSCAD SUFFIX png FILES ${ALL_RENDER_FILES} EXPECTEDDIR throwntogether ARGS --render --backend=cgal)
add_cmdline_test(throwntogether-manifold OPENSCAD SUFFIX png FILES ${ALL_RENDER_FILES} ARGS --render --backend=manifold)

# Examples tests
add_cmdline_test(dump-examples OPENSCAD SUFFIX csg FILES ${EXAMPLE_FILES})

# Customizer tests
file(GLOB CUSTOMIZER_FILES ${TEST_CUSTOMIZER_DIR}/*.scad)
add_cmdline_test(customizer     OPENSCAD SUFFIX ast FILES ${CUSTOMIZER_FILES})

# JSON tests
file(GLOB JSON_FILES ${TEST_SCAD_DIR}/json/*.scad)
add_cmdline_test(echo           OPENSCAD SUFFIX echo FILES ${JSON_FILES})

# Non-ASCII filename test
add_cmdline_test(export-csg-nonascii  OPENSCAD FILES ${TEST_SCAD_DIR}/misc/sfære.scad SUFFIX csg)

# Failing tests
add_failing_test(shouldfail RETVAL 1 SUFFIX echo FILES ${FAILING_FILES})

# Special tests
add_cmdline_test(echo         OPENSCAD SUFFIX echo FILES ${TEST_SCAD_DIR}/issues/issue4172-echo-vector-stack-exhaust.scad ARGS --quiet --trace-usermodule-parameters=false)

# DXF specific tests
add_cmdline_test(render-dxf     OPENSCAD SUFFIX png FILES ${SCAD_DXF_FILES} EXPECTEDDIR render ARGS --render)

# SVG specific tests
add_cmdline_test(export-svg SCRIPT ${EXPORT_PNGTEST_PY} SUFFIX png FILES ${SCAD_SVG_FILES} ARGS ${OPENSCAD_EXE_ARG} --format=SVG)

# Import/Export tests
add_cmdline_test(preview-stl    OPENSCAD SUFFIX png FILES ${STL_IMPORT_FILES} EXPECTEDDIR preview ARGS --render)
add_cmdline_test(render-stl     OPENSCAD SUFFIX png FILES ${STL_IMPORT_FILES} EXPECTEDDIR render ARGS --render=force)
add_cmdline_test(preview-off    OPENSCAD SUFFIX png FILES ${OFF_IMPORT_FILES} EXPECTEDDIR preview ARGS --render)
add_cmdline_test(render-off     OPENSCAD SUFFIX png FILES ${OFF_IMPORT_FILES} EXPECTEDDIR render ARGS --render=force)

# Export tests (compare actually exported files)
add_cmdline_test(export-stl              EXPERIMENTAL OPENSCAD SUFFIX stl FILES ${TEST_SCAD_DIR}/stl/stl-export.scad ARGS --enable=predictible-output --render)
add_cmdline_test(export-obj              EXPERIMENTAL OPENSCAD SUFFIX obj FILES ${TEST_SCAD_DIR}/obj/obj-export.scad ARGS --enable=predictible-output --render)
add_cmdline_test(export-3mf              EXPERIMENTAL OPENSCAD SUFFIX 3mf FILES ${TEST_SCAD_DIR}/3mf/3mf-export.scad ARGS --enable=predictible-output --render)
add_cmdline_test(export-pov              EXPERIMENTAL OPENSCAD SUFFIX pov FILES ${TEST_SCAD_DIR}/pov/pov-export.scad ARGS --enable=predictible-output --render)

# Export/import color support
add_cmdline_test(offcolorpngtest EXPERIMENTAL SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX png FILES ${COLOR_3D_TEST_FILES} EXPECTEDDIR render-manifold ARGS ${OPENSCAD_EXE_ARG} --format=OFF --backend=manifold --render)

# PDF Export
add_cmdline_test(export-pdf              EXPERIMENTAL SCRIPT ${EXPORT_PNGTEST_PY} SUFFIX png FILES ${TEST_SCAD_DIR}/pdf/pdf-export.scad ARGS ${OPENSCAD_EXE_ARG} --format=PDF)
add_cmdline_test(export-pdf-fill         EXPERIMENTAL SCRIPT ${EXPORT_PNGTEST_PY} SUFFIX png FILES ${TEST_SCAD_DIR}/pdf/pdf-export-fill.scad ARGS ${OPENSCAD_EXE_ARG} --format=PDF)

# STL export sanity test
add_cmdline_test(export-stl-sanitytest  SCRIPT ${STLEXPORTSANITYTEST_PY} SUFFIX txt FILES ${TEST_SCAD_DIR}/misc/normal-nan.scad ARGS ${OPENSCAD_EXE_ARG})

# Monotone color scheme test
add_cmdline_test(render-monotone OPENSCAD SUFFIX png FILES ${TEST_SCAD_DIR}/misc/square10.scad ARGS --colorscheme=Monotone --render)

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
