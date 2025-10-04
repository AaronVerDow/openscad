list(APPEND MANIFOLDHARDWARNING_FILES
  ${TEST_SCAD_DIR}/3D/features/polyhedron-soup.scad
  ${TEST_SCAD_DIR}/3D/issues/issue5741.scad
  ${TEST_SCAD_DIR}/3D/issues/issue5555.scad
  ${TEST_SCAD_DIR}/3D/issues/issue5555b.scad
  ${TEST_SCAD_DIR}/3D/issues/issue5135.scad
  ${TEST_SCAD_DIR}/3D/issues/issue5135-good.scad
)

if (ENABLE_MANIFOLD)
add_cmdline_test(render-manifold OPENSCAD FILES ${RENDER_COMMON_FILES} EXPECTEDDIR render SUFFIX png ARGS --render --backend=manifold)
add_cmdline_test(render-manifold OPENSCAD FILES ${RENDER_DIFFERENT_EXPECTATIONS} SUFFIX png ARGS --render --backend=manifold)
add_cmdline_test(render-force-manifold      OPENSCAD SUFFIX png FILES ${RENDERFORCETEST_FILES} EXPECTEDDIR render ARGS --render=force --backend=manifold)
# This tests that no warnings are issued when using Manifold for converting or processing geometry
add_cmdline_test(render-force-manifold-hardwarnings OPENSCAD SUFFIX png FILES ${MANIFOLDHARDWARNING_FILES} EXPECTEDDIR render ARGS --render=force --backend=manifold --hardwarnings)
add_cmdline_test(preview-manifold OPENSCAD SUFFIX png FILES ${PREVIEW_COMMON_FILES} EXPECTEDDIR preview ARGS --backend=manifold)
add_cmdline_test(preview-manifold OPENSCAD SUFFIX png FILES ${PREVIEW_DIFFERENT_EXPECTATIONS} ARGS --backend=manifold)
endif()

add_cmdline_test(throwntogether-manifold  OPENSCAD FILES ${ALL_THROWNTOGETHER_FILES} SUFFIX png EXPECTEDDIR throwntogether ARGS --preview=throwntogether --backend=manifold)
