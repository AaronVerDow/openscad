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

# Bug tests are defined in the main CMakeLists.txt to avoid duplicates
