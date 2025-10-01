set(VIEWBOX_TEST "${TEST_SCAD_DIR}/svg/extruded/viewbox-test.scad")
foreach(TEST ${SVG_VIEWBOX_TESTS})
  add_cmdline_test(svgviewbox-${TEST} OPENSCAD ARGS --imgsize 600,600 "-Dfile=\"${TEST_DATA_DIR}/svg/viewbox/${TEST}.svg\";" SUFFIX png FILES ${VIEWBOX_TEST})
endforeach()

add_cmdline_test(svgimport OPENSCAD ARGS --imgsize 600,600 SUFFIX png FILES
  ${TEST_SCAD_DIR}/svg/extruded/box-w-holes.scad
  ${TEST_SCAD_DIR}/svg/extruded/simple-center.scad
)

add_cmdline_test(render-svg  SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX png FILES ${EXPORT_IMPORT_2D_RENDER_FILES} ${SCAD_SVG_FILES} EXPECTEDDIR render ARGS ${OPENSCAD_EXE_ARG} --format=SVG --render=force)

# SVG Export
add_cmdline_test(export-svg SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX svg FILES ${SCAD_SVG_FILES} ARGS ${OPENSCAD_EXE_ARG} --format=SVG)
add_cmdline_test(export-svg-fill-stroke SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX svg FILES ${SCAD_SVG_FILES} ARGS ${OPENSCAD_EXE_ARG} --format=SVG -O export-svg/fill=true -O export-svg/fill-color=cyan -O export-svg/stroke-color=magenta -O export-svg/stroke-width=3)
add_cmdline_test(export-svg-fill-only SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX svg FILES ${SCAD_SVG_FILES} ARGS ${OPENSCAD_EXE_ARG} --format=SVG -O export-svg/fill=true -O export-svg/fill-color=blue -O export-svg/stroke=false)
