# Import/Export Tests Configuration
# Tests for file format import and export functionality

# Export tests (compare actually exported files)
add_cmdline_test(export-stl              EXPERIMENTAL OPENSCAD SUFFIX stl FILES ${EXPORT_STL_TEST_FILES} ARGS --enable=predictible-output --render)
add_cmdline_test(export-obj              EXPERIMENTAL OPENSCAD SUFFIX obj FILES ${EXPORT_OBJ_TEST_FILES} ARGS --enable=predictible-output --render)
add_cmdline_test(export-3mf              EXPERIMENTAL OPENSCAD SUFFIX 3mf FILES ${EXPORT_3MF_TEST_FILES} ARGS --enable=predictible-output --render)
add_cmdline_test(export-pov              EXPERIMENTAL OPENSCAD SUFFIX pov FILES ${EXPORT_POV_TEST_FILES} ARGS --enable=predictible-output --render)

# Export/import color support
add_cmdline_test(offcolorpngtest EXPERIMENTAL SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX png FILES ${COLOR_3D_TEST_FILES} EXPECTEDDIR render-manifold ARGS ${OPENSCAD_EXE_ARG} --format=OFF --backend=manifold --render)

# PDF Export
add_cmdline_test(export-pdf              EXPERIMENTAL SCRIPT ${EXPORT_PNGTEST_PY} SUFFIX png FILES ${TEST_SCAD_DIR}/pdf/pdf-export.scad ARGS ${OPENSCAD_EXE_ARG} --format=PDF)
add_cmdline_test(export-pdf-fill         EXPERIMENTAL SCRIPT ${EXPORT_PNGTEST_PY} SUFFIX png FILES ${TEST_SCAD_DIR}/pdf/pdf-export-fill.scad ARGS ${OPENSCAD_EXE_ARG} --format=PDF)

# Export/import tests
add_cmdline_test(render-monotone OPENSCAD SUFFIX png FILES ${EXPORT_IMPORT_3D_PREVIEW_FILES} ${SIMPLE_EXPORT_IMPORT_2D_FILES} ARGS --colorscheme=Monotone --render)

# STL export sanity test
add_cmdline_test(export-stl-sanitytest  SCRIPT ${STLEXPORTSANITYTEST_PY} SUFFIX txt FILES ${TEST_SCAD_DIR}/misc/normal-nan.scad ARGS ${OPENSCAD_EXE_ARG})

# Export/import tests for different backends
add_cmdline_test(render-csg-cgal OPENSCAD SUFFIX png FILES ${EXPORT_IMPORT_3D_FILES} EXPECTEDDIR render ARGS --render)
add_cmdline_test(render-csg-manifold OPENSCAD SUFFIX png FILES ${EXPORT_IMPORT_3D_FILES} EXPECTEDDIR render ARGS --render --backend=manifold)

# Export tests for different formats
add_cmdline_test(export-binstl          EXPERIMENTAL OPENSCAD SUFFIX stl FILES ${TEST_SCAD_DIR}/misc/binary-stl-export.scad ARGS --enable=predictible-output --render)

# 3MF export tests
if(ENABLE_3MF_TESTS)
  add_cmdline_test(export-3mf              EXPERIMENTAL OPENSCAD SUFFIX 3mf FILES ${EXPORT_3MF_TEST_FILES} ARGS --enable=predictible-output --render)
endif()

# POV export tests
add_cmdline_test(export-pov-as-is        EXPERIMENTAL OPENSCAD SUFFIX pov FILES ${TEST_SCAD_DIR}/pov/pov-export.scad ARGS --enable=predictible-output --render)
add_cmdline_test(export-pov-distance-1   EXPERIMENTAL OPENSCAD SUFFIX pov FILES ${TEST_SCAD_DIR}/pov/pov-export.scad ARGS --enable=predictible-output --render --camera=0,0,0,0,0,0,0,0,1 --camera-distance=1)
add_cmdline_test(export-pov-rotate-1     EXPERIMENTAL OPENSCAD SUFFIX pov FILES ${TEST_SCAD_DIR}/pov/pov-export.scad ARGS --enable=predictible-output --render --camera=0,0,0,0,0,0,0,0,1 --camera-rotate=1)
add_cmdline_test(export-pov-rotate-2     EXPERIMENTAL OPENSCAD SUFFIX pov FILES ${TEST_SCAD_DIR}/pov/pov-export.scad ARGS --enable=predictible-output --render --camera=0,0,0,0,0,0,0,0,1 --camera-rotate=2)
add_cmdline_test(export-pov-rotate-3     EXPERIMENTAL OPENSCAD SUFFIX pov FILES ${TEST_SCAD_DIR}/pov/pov-export.scad ARGS --enable=predictible-output --render --camera=0,0,0,0,0,0,0,0,1 --camera-rotate=3)
add_cmdline_test(export-pov-translate-1  EXPERIMENTAL OPENSCAD SUFFIX pov FILES ${TEST_SCAD_DIR}/pov/pov-export.scad ARGS --enable=predictible-output --render --camera=0,0,0,0,0,0,0,0,1 --camera-translate=1)
add_cmdline_test(export-pov-translate-2  EXPERIMENTAL OPENSCAD SUFFIX pov FILES ${TEST_SCAD_DIR}/pov/pov-export.scad ARGS --enable=predictible-output --render --camera=0,0,0,0,0,0,0,0,1 --camera-translate=2)
add_cmdline_test(export-pov-translate-3  EXPERIMENTAL OPENSCAD SUFFIX pov FILES ${TEST_SCAD_DIR}/pov/pov-export.scad ARGS --enable=predictible-output --render --camera=0,0,0,0,0,0,0,0,1 --camera-translate=3)
add_cmdline_test(export-pov-translate-4  EXPERIMENTAL OPENSCAD SUFFIX pov FILES ${TEST_SCAD_DIR}/pov/pov-export.scad ARGS --enable=predictible-output --render --camera=0,0,0,0,0,0,0,0,1 --camera-translate=4)
