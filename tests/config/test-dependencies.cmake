# Test Dependencies Configuration
# Check and configure dependencies required for testing

# If ctest is run with no configuration specified, then force "Default"
set_directory_properties(PROPERTIES TEST_INCLUDE_FILES "${CCSD}/EnforceConfig.cmake")

# MCAD
if(NOT EXISTS ${LIBRARIES_DIR}/MCAD/__init__.py)
  message(FATAL_ERROR "MCAD not found. You can install from the OpenSCAD root as follows: \n  git submodule update --init --recursive")
endif()
list(APPEND CTEST_ENVIRONMENT "OPENSCADPATH=${LIBRARIES_DIR}")

find_package(Python3 3.4 COMPONENTS Interpreter REQUIRED)
message(STATUS "Found Python at ${Python3_EXECUTABLE}")

# Image comparison - expected test image vs actual generated image
if(USE_IMAGE_COMPARE_PY)
  set(VENV_DIR "${CCBD}/venv")
  message(STATUS "Preparing image_compare.py for test suite image comparison: ${VENV_DIR}")

  # Since msys2 on Windows prefers bin/ over Scripts, we need to look for the actual folder to determine
  # how to utilize the venv
  find_path(VENV_BIN_PATH activate PATHS "${VENV_DIR}/bin" "${VENV_DIR}/Scripts" NO_DEFAULT_PATH NO_CACHE)
  if(WIN32)
    set(IMAGE_COMPARE_EXE "${VENV_BIN_PATH}/python.exe")
  else()
    set(IMAGE_COMPARE_EXE "${VENV_BIN_PATH}/python")
  endif()
  if(EXISTS "${IMAGE_COMPARE_EXE}")
    message(STATUS "venv found, testing libraries")
    execute_process(
      COMMAND "${IMAGE_COMPARE_EXE}" "${CCSD}/image_compare.py" "--status"
      WORKING_DIRECTORY "${CCSD}" ERROR_QUIET RESULT_VARIABLE ret)
    if(ret AND NOT ret EQUAL 0)
      message(STATUS "venv libraries incomplete")
      set(BUILD_VENV TRUE)
    else()
      message(STATUS "venv libraries complete")
      set(BUILD_VENV FALSE)
    endif()
  else()
    message(STATUS "venv not found")
    set(BUILD_VENV TRUE)
  endif()
  if(BUILD_VENV)
    message(STATUS "Setting up testing venv for image comparison")
    execute_process(
      COMMAND "${Python3_EXECUTABLE}" "-m" "venv" "venv" "--system-site-packages" "--without-pip"
      WORKING_DIRECTORY "${CCBD}")
    # Since msys2 on Windows prefers bin/ over Scripts, we need to look for the actual folder to determine
    # how to utilize the venv
    find_path(VENV_BIN_PATH activate PATHS "${VENV_DIR}/bin" "${VENV_DIR}/Scripts" NO_DEFAULT_PATH NO_CACHE)
    if(WIN32)
      set(IMAGE_COMPARE_EXE "${VENV_BIN_PATH}/python.exe")
    else()
      set(IMAGE_COMPARE_EXE "${VENV_BIN_PATH}/python")
    endif()
    execute_process(
      COMMAND "${IMAGE_COMPARE_EXE}" "-m" "ensurepip"
      WORKING_DIRECTORY "${CCBD}")
    execute_process(
      COMMAND "${IMAGE_COMPARE_EXE}" "-m" "pip" "install" "numpy" "Pillow"
      WORKING_DIRECTORY "${CCBD}")
  endif()
  set(COMPARATOR "-c" "${IMAGE_COMPARE_EXE}")
else()
  # Use ImageMagick for image comparison
  find_program(MAGICK_COMPARE_EXE magick compare)
  if(MAGICK_COMPARE_EXE)
    message(STATUS "Found ImageMagick: ${MAGICK_COMPARE_EXE}")
    set(COMPARATOR "-m" "${MAGICK_COMPARE_EXE}")
    # Workaround for OpenMP bug in ImageMagick
    if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
      message(STATUS "ImageMagick: OpenMP bug workaround - setting MAGICK_THREAD_LIMIT=1")
      list(APPEND CTEST_ENVIRONMENT "MAGICK_THREAD_LIMIT=1")
    endif()
  else()
    # Fallback to diffpng
    find_program(DIFFPNG_EXE diffpng)
    if(DIFFPNG_EXE)
      message(STATUS "Found diffpng: ${DIFFPNG_EXE}")
      set(COMPARATOR "-d" "${DIFFPNG_EXE}")
    else()
      message(FATAL_ERROR "No image comparison tool found. Please install ImageMagick or diffpng, or enable USE_IMAGE_COMPARE_PY")
    endif()
  endif()
endif()

# Disable LIB3MF tests if library was disabled in build
if(NOT LIB3MF_FOUND)
  message(STATUS "LIB3MF not found - disabling 3MF tests")
  set(ENABLE_3MF_TESTS FALSE)
else()
  set(ENABLE_3MF_TESTS TRUE)
endif()

# Platform Specific Configurations
# Workaround Gallium bugs
if ( ${CMAKE_SYSTEM_PROCESSOR} MATCHES "ppc")
  message(STATUS "Workaround PPC bug https://bugs.freedesktop.org/show_bug.cgi?id=42540")
  list(APPEND CTEST_ENVIRONMENT "MESA_GL_VERSION_OVERRIDE=3.3")
endif()

if ( ${CMAKE_SYSTEM_PROCESSOR} MATCHES "mips")
  message(STATUS "Workaround MIPS bug https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=868745")
  list(APPEND CTEST_ENVIRONMENT "MESA_GL_VERSION_OVERRIDE=3.3")
endif()

# Determine path for openscad executable
if(EXISTS "$ENV{OPENSCAD_BINARY}")
  set(OPENSCAD_BINPATH "$ENV{OPENSCAD_BINARY}")
else()
  if(WIN32)
    set(SUFFIX_WITH_DASH ".exe")
  else()
    set(SUFFIX_WITH_DASH "")
  endif()
  if(EXISTS "${CBD}/bin/openscad${SUFFIX_WITH_DASH}")
    set(OPENSCAD_BINPATH "${CBD}/bin/openscad${SUFFIX_WITH_DASH}")
  else()
    set(OPENSCAD_BINPATH "${CBD}/openscad${SUFFIX_WITH_DASH}")
  endif()
endif()

list(APPEND CTEST_ENVIRONMENT "OPENSCAD_BINARY=${OPENSCAD_BINPATH}")
# Argument used for import/export tests
set(OPENSCAD_EXE_ARG "--openscad=${OPENSCAD_BINPATH}")
