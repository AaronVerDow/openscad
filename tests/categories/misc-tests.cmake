# Miscellaneous Tests Configuration
# Tests for various miscellaneous functionality

# Misc test files
list(APPEND MISC_FILES
  ${TEST_SCAD_DIR}/misc/arg-permutations.scad
  ${TEST_SCAD_DIR}/misc/escape-test.scad
  ${TEST_SCAD_DIR}/misc/include-tests.scad
  ${TEST_SCAD_DIR}/misc/include-overwrite-main.scad
  ${TEST_SCAD_DIR}/misc/include-overwrite-main2.scad
  ${TEST_SCAD_DIR}/misc/use-tests.scad
  ${TEST_SCAD_DIR}/misc/assert-tests.scad
  ${TEST_SCAD_DIR}/misc/let-module-tests.scad
  ${TEST_SCAD_DIR}/misc/localfiles-test.scad
  ${TEST_SCAD_DIR}/misc/parser-tests.scad
  ${TEST_SCAD_DIR}/misc/builtin-tests.scad
  ${TEST_SCAD_DIR}/misc/dim-all.scad
  ${TEST_SCAD_DIR}/misc/string-test.scad
  ${TEST_SCAD_DIR}/misc/string-indexing.scad
  ${TEST_SCAD_DIR}/misc/string-unicode.scad
  ${TEST_SCAD_DIR}/misc/chr-tests.scad
  ${TEST_SCAD_DIR}/misc/ord-tests.scad
  ${TEST_SCAD_DIR}/misc/vector-values.scad
  ${TEST_SCAD_DIR}/misc/search-tests.scad
  ${TEST_SCAD_DIR}/misc/search-tests-unicode.scad
  ${TEST_SCAD_DIR}/misc/recursion-test-function.scad
  ${TEST_SCAD_DIR}/misc/recursion-test-function2.scad
  ${TEST_SCAD_DIR}/misc/recursion-test-function3.scad
  ${TEST_SCAD_DIR}/misc/recursion-test-module.scad
  ${TEST_SCAD_DIR}/misc/tail-recursion-tests.scad
  ${TEST_SCAD_DIR}/misc/value-reassignment-tests.scad
  ${TEST_SCAD_DIR}/misc/value-reassignment-tests2.scad
  ${TEST_SCAD_DIR}/misc/variable-scope-tests.scad
  ${TEST_SCAD_DIR}/misc/scope-assignment-tests.scad
  ${TEST_SCAD_DIR}/misc/lookup-tests.scad
  ${TEST_SCAD_DIR}/misc/expression-shortcircuit-tests.scad
  ${TEST_SCAD_DIR}/misc/parent_module-tests.scad
  ${TEST_SCAD_DIR}/misc/children-tests.scad
  ${TEST_SCAD_DIR}/misc/range-tests.scad
  ${TEST_SCAD_DIR}/misc/no-break-space-test.scad
  ${TEST_SCAD_DIR}/misc/unicode-tests.scad
  ${TEST_SCAD_DIR}/misc/utf8-tests.scad
  ${TEST_SCAD_DIR}/misc/nbsp-utf8-test.scad
  ${TEST_SCAD_DIR}/misc/nbsp-latin1-test.scad
  ${TEST_SCAD_DIR}/misc/concat-tests.scad
  ${TEST_SCAD_DIR}/misc/include-recursive-test.scad
  ${TEST_SCAD_DIR}/misc/errors-warnings.scad
  ${TEST_SCAD_DIR}/misc/errors-warnings-included.scad
  ${TEST_SCAD_DIR}/misc/children-warnings-tests.scad
  ${TEST_SCAD_DIR}/misc/isundef-test.scad
  ${TEST_SCAD_DIR}/misc/islist-test.scad
  ${TEST_SCAD_DIR}/misc/isnum-test.scad
  ${TEST_SCAD_DIR}/misc/isbool-test.scad
  ${TEST_SCAD_DIR}/misc/isstring-test.scad
  ${TEST_SCAD_DIR}/misc/operators-tests.scad
  ${TEST_SCAD_DIR}/misc/expression-precedence.scad
  ${TEST_SCAD_DIR}/misc/builtins-calling-vec3vec2.scad
  ${TEST_SCAD_DIR}/misc/leaf-module-warnings.scad
  ${TEST_SCAD_DIR}/issues/issue1472.scad
  ${TEST_SCAD_DIR}/misc/empty-stl.scad
  ${TEST_SCAD_DIR}/issues/issue1516.scad
  ${TEST_SCAD_DIR}/issues/issue1528.scad
  ${TEST_SCAD_DIR}/issues/issue1923.scad
  ${TEST_SCAD_DIR}/misc/preview_variable.scad
)

# Function test files
file(GLOB FUNCTION_FILES ${TEST_SCAD_DIR}/functions/*.scad)

# Redefinition test files
file(GLOB REDEFINITION_FILES ${TEST_SCAD_DIR}/redefinition/*.scad)

# AST dump tests
list(APPEND ASTDUMP_FILES ${MISC_FILES}
  ${TEST_SCAD_DIR}/functions/assert-expression-fail1-test.scad
  ${TEST_SCAD_DIR}/functions/assert-expression-fail2-test.scad
  ${TEST_SCAD_DIR}/functions/assert-expression-fail3-test.scad
  ${TEST_SCAD_DIR}/functions/assert-expression-tests.scad
  ${TEST_SCAD_DIR}/functions/echo-expression-tests.scad
  ${TEST_SCAD_DIR}/functions/expression-precedence-tests.scad
  ${TEST_SCAD_DIR}/functions/let-test-single.scad
  ${TEST_SCAD_DIR}/functions/let-tests.scad
  ${TEST_SCAD_DIR}/functions/list-comprehensions.scad
  ${TEST_SCAD_DIR}/functions/exponent-operator-test.scad
  ${TEST_SCAD_DIR}/misc/ifelse-ast-dump.scad
  ${TEST_SCAD_DIR}/svg/id-layer-selection-test.scad
)

# Echo tests
list(APPEND ECHO_FILES ${FUNCTION_FILES} ${MISC_FILES} ${REDEFINITION_FILES}
  ${TEST_SCAD_DIR}/3D/features/for-tests.scad
  ${TEST_SCAD_DIR}/3D/features/rotate-parameters.scad
  ${TEST_SCAD_DIR}/3D/features/linear_extrude-parameter-tests.scad
  ${TEST_SCAD_DIR}/misc/expression-evaluation-tests.scad
  ${TEST_SCAD_DIR}/misc/echo-tests.scad
)

# Add misc tests
add_cmdline_test(astdump        OPENSCAD SUFFIX ast FILES ${ASTDUMP_FILES})
add_cmdline_test(echo           OPENSCAD SUFFIX echo FILES ${ECHO_FILES})
add_cmdline_test(dump           OPENSCAD SUFFIX csg FILES ${MISC_FILES})

# Customizer tests
file(GLOB CUSTOMIZER_FILES ${TEST_CUSTOMIZER_DIR}/*.scad)
add_cmdline_test(customizer     OPENSCAD SUFFIX ast FILES ${CUSTOMIZER_FILES})

# JSON tests
file(GLOB JSON_FILES ${TEST_SCAD_DIR}/json/*.scad)
add_cmdline_test(echo           OPENSCAD SUFFIX echo FILES ${JSON_FILES})

# Non-ASCII filename test
add_cmdline_test(export-csg-nonascii  OPENSCAD FILES ${TEST_SCAD_DIR}/misc/sfære.scad SUFFIX csg)
