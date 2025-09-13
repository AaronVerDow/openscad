# 2D Tests Configuration
# Tests for 2D geometry and operations

# Find all 2D test files
file(GLOB FEATURES_2D_FILES   ${TEST_SCAD_DIR}/2D/features/*.scad)
file(GLOB ISSUES_2D_FILES     ${TEST_SCAD_DIR}/2D/issues/*.scad)
file(GLOB BUGS_2D_FILES       ${TEST_SCAD_DIR}/bugs2D/*.scad)

# DXF import/export tests
file(GLOB SCAD_DXF_FILES      ${TEST_SCAD_DIR}/dxf/*.scad)

# SVG import/export tests  
file(GLOB SCAD_SVG_FILES      ${TEST_SCAD_DIR}/svg/*.scad)

# 2D examples
list(APPEND EXAMPLE_2D_FILES
  ${EXAMPLES_DIR}/Old/example015.scad
  ${EXAMPLES_DIR}/Advanced/module_recursion.scad
  ${EXAMPLES_DIR}/Functions/list_comprehensions.scad
  ${EXAMPLES_DIR}/Functions/polygon_areas.scad
  ${EXAMPLES_DIR}/Functions/recursion.scad
)

# Combine 2D test files
list(APPEND FILES_2D ${FEATURES_2D_FILES} ${ISSUES_2D_FILES} ${EXAMPLE_2D_FILES})
list(APPEND ALL_2D_FILES
  ${FILES_2D}
  ${SCAD_DXF_FILES}
  ${SCAD_SVG_FILES}
  ${TEST_SCAD_DIR}/2D/features/text-metrics.scad
)

# 2D test configurations
list(APPEND RENDER_2D_FILES ${FEATURES_2D_FILES} ${SCAD_DXF_FILES} ${ISSUES_2D_FILES} ${EXAMPLE_2D_FILES})
list(APPEND DUMP_FILES ${FEATURES_2D_FILES})
list(APPEND ECHO_FILES ${FEATURES_2D_FILES} ${ISSUES_2D_FILES})

# 2D tests are defined in the main CMakeLists.txt to avoid duplicates
