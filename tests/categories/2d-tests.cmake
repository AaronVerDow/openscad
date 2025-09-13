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

# Add 2D tests
add_cmdline_test(dump           OPENSCAD SUFFIX csg FILES ${FEATURES_2D_FILES})
add_cmdline_test(echo           OPENSCAD SUFFIX echo FILES ${FEATURES_2D_FILES} ${ISSUES_2D_FILES})
add_cmdline_test(render-cgal    OPENSCAD SUFFIX png FILES ${RENDER_2D_FILES} EXPECTEDDIR render ARGS --render --backend=cgal)
add_cmdline_test(render-manifold OPENSCAD SUFFIX png FILES ${RENDER_2D_FILES} EXPECTEDDIR render ARGS --render --backend=manifold)
add_cmdline_test(preview-cgal   OPENSCAD SUFFIX png FILES ${RENDER_2D_FILES} EXPECTEDDIR preview ARGS --backend=cgal)
add_cmdline_test(preview-manifold OPENSCAD SUFFIX png FILES ${RENDER_2D_FILES} ARGS --backend=manifold)
add_cmdline_test(throwntogether-cgal OPENSCAD SUFFIX png FILES ${RENDER_2D_FILES} EXPECTEDDIR throwntogether ARGS --render --backend=cgal)
add_cmdline_test(throwntogether-manifold OPENSCAD SUFFIX png FILES ${RENDER_2D_FILES} ARGS --render --backend=manifold)

# DXF specific tests
add_cmdline_test(render-dxf     OPENSCAD SUFFIX png FILES ${SCAD_DXF_FILES} EXPECTEDDIR render ARGS --render)

# SVG specific tests
add_cmdline_test(export-svg SCRIPT ${EXPORT_PNGTEST_PY} SUFFIX png FILES ${SCAD_SVG_FILES} ARGS ${OPENSCAD_EXE_ARG} --format=SVG)
