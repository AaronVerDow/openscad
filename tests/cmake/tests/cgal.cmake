add_cmdline_test(render-cgal      OPENSCAD FILES ${RENDER_COMMON_FILES} EXPECTEDDIR render SUFFIX png ARGS --render --backend=cgal)
add_cmdline_test(render-cgal      OPENSCAD FILES ${RENDER_DIFFERENT_EXPECTATIONS} SUFFIX png ARGS --render --backend=cgal)
add_cmdline_test(render-force-cgal OPENSCAD SUFFIX png FILES ${RENDERFORCETEST_FILES} ARGS --render=force --backend=cgal)
add_cmdline_test(render-stdio-cgal OPENSCAD SUFFIX png FILES ${RENDERSTDIOTEST_FILES} STDIO EXPECTEDDIR render ARGS --export-format png --render --backend=cgal)

add_cmdline_test(preview-cgal    OPENSCAD FILES ${PREVIEW_COMMON_FILES} EXPECTEDDIR preview SUFFIX png ARGS --backend=cgal)
add_cmdline_test(preview-cgal    OPENSCAD FILES ${PREVIEW_DIFFERENT_EXPECTATIONS} SUFFIX png ARGS --backend=cgal)
add_cmdline_test(throwntogether-cgal  OPENSCAD FILES ${ALL_THROWNTOGETHER_FILES} SUFFIX png EXPECTEDDIR throwntogether ARGS --preview=throwntogether --backend=cgal)

add_cmdline_test(render-csg-cgal SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX png FILES ${RENDER_COMMON_FILES} EXPECTEDDIR render ARGS ${OPENSCAD_EXE_ARG} --format=csg --render --backend=cgal)
add_cmdline_test(render-csg-cgal SCRIPT ${EXPORT_IMPORT_PNGTEST_PY} SUFFIX png FILES ${RENDER_DIFFERENT_EXPECTATIONS} EXPECTEDDIR render-cgal ARGS ${OPENSCAD_EXE_ARG} --format=csg --render --backend=cgal)

# FIXME: We don't actually need to compare the output of cgalstlsanitytest
# with anything. It's self-contained and returns != 0 on error
