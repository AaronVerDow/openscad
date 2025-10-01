# Types of tests:
# o echo: Just record console output
# o dump: Export .csg
# o render-cgal: Export to PNG using --render
# o render-force-cgal: Export to PNG using --render=force
# o render-manifold: Export to PNG using --render with --backend=manifold
# o render-force-manifold: Export to PNG using --render=force with --backend=manifold
# o preview-cgal: Export to PNG using OpenCSG
# o preview-manifold: Export to PNG in preview mode with --backend=manifold
# o throwntogether-cgal: Export to PNG using the Throwntogether renderer
# o throwntogether-manifold
# o render-csg-cgal: 1) Export to .csg, 2) import .csg and export to PNG (--render)
# o render-monotone: Same as render-cgal but with the "Monotone" color scheme
# o preview-stl: Export to STL, Re-import and render to PNG (--render)
# o render-stl: Export to STL, Re-import and render to PNG (--render=force)
# o preview-off: Export to OFF, Re-import and render to PNG (--render)
# o render-off: Export to STL, Re-import and render to PNG (--render=force)
# o render-dxf: Export to DXF, Re-import and render to PNG (--render=force)
#

include(./tests/ast.cmake)

add_cmdline_test(csgterm      OPENSCAD SUFFIX term FILES
  ${TEST_SCAD_DIR}/misc/allexpressions.scad
  ${TEST_SCAD_DIR}/misc/allfunctions.scad
  ${TEST_SCAD_DIR}/misc/allmodules.scad
)

include(./tests/echo.cmake)

add_cmdline_test(dump           OPENSCAD FILES ${FEATURES_2D_FILES} ${FEATURES_3D_FILES} ${DEPRECATED_3D_FILES} ${MISC_FILES} SUFFIX csg ARGS)
add_cmdline_test(dump-examples  OPENSCAD FILES ${EXAMPLE_FILES} SUFFIX csg ARGS)
# non-ASCII filenames
add_cmdline_test(export-csg-nonascii  OPENSCAD FILES ${TEST_SCAD_DIR}/misc/sfære.scad SUFFIX csg)

include(./tests/manifold.cmake)

# 
# OBJECT echo tests
#

file(GLOB OBJECT_TEST ${TEST_SCAD_DIR}/experimental/object/*.scad)
add_cmdline_test(echo EXPERIMENTAL OPENSCAD SUFFIX echo FILES ${OBJECT_TEST} ARGS --enable object-function)


#
# Export/import tests
#

# FIXME: Reintroduce
list(APPEND COLOR_EXPORT_TEST_FILES
  ${TEST_SCAD_DIR}/misc/color-export.scad
)

list(APPEND EXPORT_IMPORT_3D_FILES
${TEST_SCAD_DIR}/3D/features/mirror-tests.scad
${TEST_SCAD_DIR}/3D/features/polyhedron-nonplanar-tests.scad
${TEST_SCAD_DIR}/3D/features/rotate_extrude-tests.scad
${TEST_SCAD_DIR}/3D/features/union-coincident-test.scad
${TEST_SCAD_DIR}/3D/issues/fn_bug.scad
${TEST_SCAD_DIR}/3D/issues/issue1105c.scad
${TEST_SCAD_DIR}/3D/issues/issue1215.scad
${TEST_SCAD_DIR}/3D/issues/issue1215b.scad
${TEST_SCAD_DIR}/3D/issues/issue1221.scad
${TEST_SCAD_DIR}/3D/issues/issue1225.scad
${TEST_SCAD_DIR}/3D/issues/issue1258.scad
${TEST_SCAD_DIR}/3D/issues/issue2259.scad
${TEST_SCAD_DIR}/3D/issues/issue5216.scad
${TEST_SCAD_DIR}/misc/bad-stl-pcbvicebar.scad
${TEST_SCAD_DIR}/misc/bad-stl-tardis.scad
${TEST_SCAD_DIR}/misc/bad-stl-wing.scad
${TEST_SCAD_DIR}/misc/nonmanifold-polyhedron.scad
${TEST_SCAD_DIR}/misc/preview_variable.scad
)

list(APPEND EXPORT_IMPORT_3D_DIFFERENT_FILES
${TEST_SCAD_DIR}/3D/issues/issue904.scad
${TEST_SCAD_DIR}/3D/issues/issue1105.scad
${TEST_SCAD_DIR}/3D/issues/issue1105b.scad
${TEST_SCAD_DIR}/3D/issues/issue1105d.scad
${TEST_SCAD_DIR}/3D/issues/issue1215c.scad
${TEST_SCAD_DIR}/misc/internal-cavity.scad
${TEST_SCAD_DIR}/misc/internal-cavity-polyhedron.scad
${TEST_SCAD_DIR}/misc/rotate_extrude-hole.scad
)

list(APPEND EXPORT_IMPORT_3D_DIFFERENT_MANIFOLD_FILES
${TEST_SCAD_DIR}/3D/features/polyhedron-tests.scad
)

#
# There are some caveats with export and import, so we need to test a few combinations:
# 1. It may be possible to export a non-manifold mesh (e.g. malformed polyhedron) due to 
#    no manifoldness checks at export time. This is by design, e.g. to allow users to 
#    troubleshoot externally.
# 2. It may be possible to import such non-manifolds and preview or render them, but it will
#    likely fail when trying to construct a data structure requiring manifold objects (e.g. --render=force)
#
# This leads to three types of tests:
# 1. <format>render: Manifold object export + render (both with --render=force)
# 2. <format>preview: Non-manifold polyhedron export + preview
# 3. <format>render: Complex Manifold polyhedron export + render (both with --render=force)
#    e.g. self-touching polyhedron or malformed but repairable.
#

include(./tests/pov.cmake)

# Trivial Export/Import files: Sanity-checks bidirectional file format import/export
set(SIMPLE_EXPORT_IMPORT_2D_FILES ${TEST_SCAD_DIR}/misc/square10.scad)
set(SIMPLE_EXPORT_IMPORT_3D_FILES ${TEST_SCAD_DIR}/misc/cube10.scad)
set(SIMPLE_EXPORT_IMPORT_NON_MANIFOLD ${TEST_SCAD_DIR}/3D/misc/polyhedron-single-triangle.scad)

set(EXPORT_IMPORT_2D_RENDER_FILES ${SIMPLE_EXPORT_IMPORT_2D_TESTS} ${FILES_2D})

set(EXPORT_IMPORT_3D_PREVIEW_FILES ${SIMPLE_EXPORT_IMPORT_NON_MANIFOLD} ${SIMPLE_EXPORT_IMPORT_3D_FILES})
set(EXPORT_IMPORT_3D_RENDER_FILES ${SIMPLE_EXPORT_IMPORT_3D_FILES} ${EXPORT_IMPORT_3D_FILES})
list(REMOVE_ITEM EXPORT_IMPORT_3D_RENDER_FILES
  # Non-manifold polyhedrons can never be rendered
  ${TEST_SCAD_DIR}/misc/nonmanifold-polyhedron.scad
)
set(EXPORT_IMPORT_3D_RENDERMANIFOLD_FILES ${EXPORT_IMPORT_3D_RENDER_FILES})

# Manifoldness corner cases
set(FILES_MANIFOLD_CORNER_CASES
  ${TEST_SCAD_DIR}/3D/misc/tetracyl-slim.scad
  ${TEST_SCAD_DIR}/3D/misc/tetracyl-touch-edge.scad
  ${TEST_SCAD_DIR}/3D/misc/tetracyl-touch-edge-nonmanifold.scad
  ${TEST_SCAD_DIR}/3D/misc/tetracyl-touch-vertex.scad
  ${TEST_SCAD_DIR}/3D/misc/tetracyl-touch-vertex-nonmanifold.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedrons-touch-edge-nonmanifold.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedrons-touch-edge.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedrons-touch-vertex-nonmanifold.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedrons-touch-vertex.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedrons-touch-face-nonmanifold.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedrons-touch-face.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedron-self-touch-edge-nonmanifold.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedron-self-touch-edge.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedron-self-touch-face-nonmanifold.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedron-self-touch-face.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedron-self-touch-vertex-nonmanifold.scad
  ${TEST_SCAD_DIR}/3D/misc/polyhedron-self-touch-vertex.scad
  ${TEST_SCAD_DIR}/3D/features/rotate_extrude-touch-edge.scad
  ${TEST_SCAD_DIR}/3D/features/rotate_extrude-touch-vertex.scad
)

# Export-import tests
add_cmdline_test(render-monotone OPENSCAD SUFFIX png FILES ${EXPORT_IMPORT_3D_PREVIEW_FILES} ${SIMPLE_EXPORT_IMPORT_2D_FILES} ARGS --colorscheme=Monotone --render)

include(./tests/dxf.cmake)
include(./tests/stl.cmake)
include(./tests/cgal.cmake)
include(./tests/obj.cmake)
include(./tests/off.cmake)
include(./tests/amf.cmake)
include(./tests/3mf.cmake)
include(./tests/pdf.cmake)
include(./tests/svg.cmake)
include(./tests/expected_fail.cmake)

# Verify that test framework is paying attention to alpha channel, issue 1492
#add_cmdline_test(openscad-colorscheme-cornfield-alphafail  ARGS --colorscheme=Cornfield SUFFIX png FILES ${EXAMPLES_DIR}/Basics/logo.scad)

# The "expected image" supplied for this "alphafail" test has the alpha channel for all background pixels cleared (a==0),
# when they should be opaque (a==1) for this colorscheme.
# So if test framework is functioning properly then the image comparison should fail.
# Commented out because the master branch isn't capable of making the expected image yet.
# Also TEST_GENERATE=1 makes an expected image that makes the test fail.
#set_property(TEST openscad-colorscheme-cornfield-alphafail_logo PROPERTY WILL_FAIL TRUE)

include(./tests/customizer.cmake)
include(./tests/camera.cmake)
include(./tests/view_options.cmake)
include(./tests/colorscheme.cmake)
include(./tests/experimental.cmake)
include(./tests/relative_filenames.cmake)
