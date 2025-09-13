# 3D Tests Configuration
# Tests for 3D geometry and operations

# Find all 3D test files
file(GLOB FEATURES_3D_FILES   ${TEST_SCAD_DIR}/3D/features/*.scad)
file(GLOB ISSUES_3D_FILES     ${TEST_SCAD_DIR}/3D/issues/*.scad)
file(GLOB BUGS_FILES          ${TEST_SCAD_DIR}/bugs/*.scad)
file(GLOB DEPRECATED_3D_FILES ${TEST_SCAD_DIR}/3D/misc/*.scad)

# 3D format import/export tests
file(GLOB SCAD_AMF_FILES      ${TEST_SCAD_DIR}/amf/*.scad)
file(GLOB SCAD_NEF3_FILES     ${TEST_SCAD_DIR}/nef3/*.scad)
file(GLOB SCAD_OBJ_FILES      ${TEST_SCAD_DIR}/obj/*.scad)
file(GLOB SCAD_OFF_FILES      ${TEST_SCAD_DIR}/off/*.scad)
file(GLOB SCAD_STL_FILES      ${TEST_SCAD_DIR}/stl/*.scad)
file(GLOB SCAD_3MF_FILES      ${TEST_SCAD_DIR}/3mf/*.scad)

# 3D examples (remove 2D files from 3D examples)
list(APPEND EXAMPLE_3D_FILES ${EXAMPLE_FILES})
list(REMOVE_ITEM EXAMPLE_3D_FILES
  ${EXAMPLES_DIR}/Old/example015.scad
  ${EXAMPLES_DIR}/Advanced/module_recursion.scad
  ${EXAMPLES_DIR}/Functions/list_comprehensions.scad
  ${EXAMPLES_DIR}/Functions/polygon_areas.scad
  ${EXAMPLES_DIR}/Functions/recursion.scad
)

# Combine 3D test files
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
  # result will not be empty
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

# Combine all preview files
list(APPEND ALL_PREVIEW_FILES ${3MF_IMPORT_FILES} ${OBJ_IMPORT_FILES} ${OFF_IMPORT_FILES} ${STL_IMPORT_FILES} ${ALL_RENDER_FILES} ${PRUNE_TEST} ${PREVIEW_ONLY_FILES})

# Add 3D tests
add_cmdline_test(dump           OPENSCAD SUFFIX csg FILES ${FEATURES_3D_FILES} ${DEPRECATED_3D_FILES})
add_cmdline_test(echo           OPENSCAD SUFFIX echo FILES ${FEATURES_3D_FILES} ${ISSUES_3D_FILES} ${DEPRECATED_3D_FILES})
add_cmdline_test(render-cgal    OPENSCAD SUFFIX png FILES ${RENDER_3D_FILES} EXPECTEDDIR render ARGS --render --backend=cgal)
add_cmdline_test(render-manifold OPENSCAD SUFFIX png FILES ${RENDER_3D_FILES} EXPECTEDDIR render ARGS --render --backend=manifold)
add_cmdline_test(preview-cgal   OPENSCAD SUFFIX png FILES ${ALL_PREVIEW_FILES} EXPECTEDDIR preview ARGS --backend=cgal)
add_cmdline_test(preview-manifold OPENSCAD SUFFIX png FILES ${ALL_PREVIEW_FILES} ARGS --backend=manifold)
add_cmdline_test(throwntogether-cgal OPENSCAD SUFFIX png FILES ${ALL_RENDER_FILES} EXPECTEDDIR throwntogether ARGS --render --backend=cgal)
add_cmdline_test(throwntogether-manifold OPENSCAD SUFFIX png FILES ${ALL_RENDER_FILES} ARGS --render --backend=manifold)

# Import/Export tests
add_cmdline_test(preview-stl    OPENSCAD SUFFIX png FILES ${STL_IMPORT_FILES} EXPECTEDDIR preview ARGS --render)
add_cmdline_test(render-stl     OPENSCAD SUFFIX png FILES ${STL_IMPORT_FILES} EXPECTEDDIR render ARGS --render=force)
add_cmdline_test(preview-off    OPENSCAD SUFFIX png FILES ${OFF_IMPORT_FILES} EXPECTEDDIR preview ARGS --render)
add_cmdline_test(render-off     OPENSCAD SUFFIX png FILES ${OFF_IMPORT_FILES} EXPECTEDDIR render ARGS --render=force)
