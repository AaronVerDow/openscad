# Bug Tests Configuration
# Tests for known bugs and regression tests

# Bug test files
file(GLOB BUGS_FILES       ${TEST_SCAD_DIR}/bugs/*.scad)
file(GLOB BUGS_2D_FILES    ${TEST_SCAD_DIR}/bugs2D/*.scad)

# Issue test files
file(GLOB ISSUES_2D_FILES     ${TEST_SCAD_DIR}/2D/issues/*.scad)
file(GLOB ISSUES_3D_FILES     ${TEST_SCAD_DIR}/3D/issues/*.scad)

# Failing tests
list(APPEND FAILING_FILES
  ${TEST_SCAD_DIR}/issues/issue1890-comment.scad
  ${TEST_SCAD_DIR}/issues/issue1890-include.scad
  ${TEST_SCAD_DIR}/issues/issue1890-string.scad
  ${TEST_SCAD_DIR}/issues/issue1890-use.scad
)

# Add bug tests
add_cmdline_test(dump           OPENSCAD SUFFIX csg FILES ${BUGS_FILES} ${BUGS_2D_FILES})
add_cmdline_test(echo           OPENSCAD SUFFIX echo FILES ${BUGS_FILES} ${BUGS_2D_FILES})
add_cmdline_test(render-cgal    OPENSCAD SUFFIX png FILES ${BUGS_FILES} ${BUGS_2D_FILES} EXPECTEDDIR render ARGS --render --backend=cgal)
add_cmdline_test(render-manifold OPENSCAD SUFFIX png FILES ${BUGS_FILES} ${BUGS_2D_FILES} EXPECTEDDIR render ARGS --render --backend=manifold)
add_cmdline_test(preview-cgal   OPENSCAD SUFFIX png FILES ${BUGS_FILES} ${BUGS_2D_FILES} EXPECTEDDIR preview ARGS --backend=cgal)
add_cmdline_test(preview-manifold OPENSCAD SUFFIX png FILES ${BUGS_FILES} ${BUGS_2D_FILES} ARGS --backend=manifold)
add_cmdline_test(throwntogether-cgal OPENSCAD SUFFIX png FILES ${BUGS_FILES} ${BUGS_2D_FILES} EXPECTEDDIR throwntogether ARGS --render --backend=cgal)
add_cmdline_test(throwntogether-manifold OPENSCAD SUFFIX png FILES ${BUGS_FILES} ${BUGS_2D_FILES} ARGS --render --backend=manifold)

# Add failing tests
add_failing_test(shouldfail RETVAL 1 SUFFIX echo FILES ${FAILING_FILES})

# Issue-specific tests
add_cmdline_test(echo           OPENSCAD SUFFIX echo FILES ${ISSUES_2D_FILES} ${ISSUES_3D_FILES})
add_cmdline_test(render-cgal    OPENSCAD SUFFIX png FILES ${ISSUES_2D_FILES} ${ISSUES_3D_FILES} EXPECTEDDIR render ARGS --render --backend=cgal)
add_cmdline_test(render-manifold OPENSCAD SUFFIX png FILES ${ISSUES_2D_FILES} ${ISSUES_3D_FILES} EXPECTEDDIR render ARGS --render --backend=manifold)
add_cmdline_test(preview-cgal   OPENSCAD SUFFIX png FILES ${ISSUES_2D_FILES} ${ISSUES_3D_FILES} EXPECTEDDIR preview ARGS --backend=cgal)
add_cmdline_test(preview-manifold OPENSCAD SUFFIX png FILES ${ISSUES_2D_FILES} ${ISSUES_3D_FILES} ARGS --backend=manifold)
