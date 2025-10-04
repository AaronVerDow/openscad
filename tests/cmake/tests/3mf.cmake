list(APPEND EXPORT_3MF_TEST_FILES ${TEST_SCAD_DIR}/3mf/3mf-export.scad)

set(render-3mf-manifold_FILES ${render-off-manifold_FILES})

if (ENABLE_LIB3MF_TESTS)
add_cmdline_test(export-3mf              EXPERIMENTAL OPENSCAD SUFFIX 3mf FILES ${EXPORT_3MF_TEST_FILES} ARGS --enable=predictible-output)
add_cmdline_test(preview-3mf         SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX png FILES ${EXPORT_IMPORT_3D_PREVIEW_FILES} EXPECTEDDIR render-monotone ARGS ${OPENSCAD_EXE_ARG} --format=3MF)
add_cmdline_test(render-3mf-cgal     SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX png FILES ${EXPORT_IMPORT_3D_RENDER_FILES} EXPECTEDDIR render-monotone ARGS ${OPENSCAD_EXE_ARG} --format=3MF --render=force --backend=cgal)
add_cmdline_test(render-3mf-cgal     SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX png FILES ${EXPORT_IMPORT_3D_DIFFERENT_FILES} EXPECTEDDIR render-monotone ARGS ${OPENSCAD_EXE_ARG} --format=3MF --render=force --backend=cgal)
add_cmdline_test(render-3mf-manifold SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX png FILES ${EXPORT_IMPORT_3D_RENDER_FILES} EXPECTEDDIR render-monotone ARGS ${OPENSCAD_EXE_ARG} --format=3MF --render=force --backend=manifold)
add_cmdline_test(render-3mf-manifold SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX png FILES ${EXPORT_IMPORT_3D_DIFFERENT_FILES} EXPECTEDDIR render ARGS ${OPENSCAD_EXE_ARG} --format=3MF --render=force --backend=manifold)
add_cmdline_test(render-3mf-manifold SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX png FILES ${EXPORT_IMPORT_3D_DIFFERENT_MANIFOLD_FILES} EXPECTEDDIR render-manifold ARGS ${OPENSCAD_EXE_ARG} --format=3MF --render=force --backend=manifold)
endif()
