# Experimental Tests Configuration
# Tests for experimental features and functionality

# Lazy union tests
list(APPEND LAZYUNION_3D_FILES
  ${TEST_SCAD_DIR}/experimental/lazyunion-toplevel-objects.scad
  ${TEST_SCAD_DIR}/experimental/lazyunion-toplevel-for.scad
  ${TEST_SCAD_DIR}/experimental/lazyunion-nested-for.scad
  ${TEST_SCAD_DIR}/experimental/lazyunion-children.scad
  ${TEST_SCAD_DIR}/experimental/lazyunion-hull-for.scad
  ${TEST_SCAD_DIR}/experimental/lazyunion-difference-for.scad
  ${TEST_SCAD_DIR}/experimental/lazyunion-intersection-for.scad
  ${TEST_SCAD_DIR}/experimental/lazyunion-minkowski-for.scad
  ${TEST_SCAD_DIR}/experimental/lazyunion-transform-for.scad
)

list(APPEND LAZYUNION_2D_FILES
  ${TEST_SCAD_DIR}/experimental/lazyunion-toplevel-2dobjects.scad
)
list(APPEND LAZYUNION_FILES ${LAZYUNION_2D_FILES} ${LAZYUNION_3D_FILES})

# Fast CSG tests
list(APPEND FASTCSG_FILES
  ${TEST_SCAD_DIR}/experimental/fastcsg-issue4150.scad
  ${TEST_SCAD_DIR}/experimental/fastcsg-lazyunion-issue4109-1.scad
  ${TEST_SCAD_DIR}/experimental/fastcsg-lazyunion-issue4109-2.scad
  ${TEST_SCAD_DIR}/experimental/fastcsg-lazyunion-issue4109-3.scad
  ${TEST_SCAD_DIR}/experimental/fastcsg-lazyunion-issue4109-4.scad
  ${TEST_SCAD_DIR}/experimental/fastcsg-remesh-cube-1.scad
  ${TEST_SCAD_DIR}/experimental/fastcsg-remesh-cube-2.scad
  ${TEST_SCAD_DIR}/experimental/fastcsg-remesh-cubes.scad
)

# Experimental roof tests
list(APPEND EXPERIMENTAL_ROOF_FILES ${EXAMPLES_DIR}/Basics/roof.scad)
add_cmdline_test(dump-examples    EXPERIMENTAL OPENSCAD SUFFIX csg FILES ${EXPERIMENTAL_ROOF_FILES} ARGS --enable=roof)
add_cmdline_test(render-cgal      EXPERIMENTAL OPENSCAD SUFFIX png FILES ${EXPERIMENTAL_ROOF_FILES} ARGS --render --enable=roof --backend=cgal)
add_cmdline_test(render-manifold  EXPERIMENTAL OPENSCAD SUFFIX png FILES ${EXPERIMENTAL_ROOF_FILES} EXPECTEDDIR render ARGS --render --enable=roof --backend=manifold)
add_cmdline_test(preview-cgal     EXPERIMENTAL OPENSCAD SUFFIX png FILES ${EXPERIMENTAL_ROOF_FILES} EXPECTEDDIR preview ARGS --enable=roof --backend=cgal)
add_cmdline_test(preview-manifold EXPERIMENTAL OPENSCAD SUFFIX png FILES ${EXPERIMENTAL_ROOF_FILES} ARGS --enable=roof --backend=manifold)

# Experimental import function tests
list(APPEND EXPERIMENTAL_IMPORT_FILES
  ${TEST_SCAD_DIR}/json/import-json.scad
  ${TEST_SCAD_DIR}/json/import-json-relative-path.scad
  )
add_cmdline_test(echo           EXPERIMENTAL OPENSCAD SUFFIX echo FILES ${EXPERIMENTAL_IMPORT_FILES} ARGS --enable=import-function)

# Experimental text metrics tests
list(APPEND EXPERIMENTAL_TEXTMETRICS_ECHO_FILES
  ${TEST_SCAD_DIR}/misc/isobject-test.scad
  ${TEST_SCAD_DIR}/misc/text-metrics-test.scad
)
list(APPEND EXPERIMENTAL_TEXTMETRICS_FILES
  ${TEST_SCAD_DIR}/2D/features/text-metrics.scad
)
add_cmdline_test(echo           EXPERIMENTAL OPENSCAD SUFFIX echo FILES ${EXPERIMENTAL_TEXTMETRICS_ECHO_FILES} ARGS --enable=textmetrics)

# Lazy union tests
add_cmdline_test(lazyunion-export-csg EXPERIMENTAL OPENSCAD SUFFIX csg FILES ${LAZYUNION_FILES} ARGS --enable=lazy-union)
add_cmdline_test(lazyunion-preview    EXPERIMENTAL OPENSCAD SUFFIX png FILES ${LAZYUNION_FILES} EXPECTEDDIR preview ARGS --enable=lazy-union)
add_cmdline_test(lazyunion-render     EXPERIMENTAL OPENSCAD SUFFIX png FILES ${LAZYUNION_FILES} EXPECTEDDIR render ARGS --enable=lazy-union --render)
add_cmdline_test(lazyunion-render-stl EXPERIMENTAL OPENSCAD SUFFIX png FILES ${LAZYUNION_3D_FILES} EXPECTEDDIR render ARGS --enable=lazy-union --render --format=STL)

# Fast CSG tests
add_cmdline_test(fastcsg-preview      EXPERIMENTAL OPENSCAD SUFFIX png FILES ${FASTCSG_FILES} EXPECTEDDIR preview ARGS --enable=fast-csg)
add_cmdline_test(fastcsg-render       EXPERIMENTAL OPENSCAD SUFFIX png FILES ${FASTCSG_FILES} EXPECTEDDIR render ARGS --enable=fast-csg --render)
