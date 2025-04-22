#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "LibPressioPredict::libpressio_predict" for configuration "Release"
set_property(TARGET LibPressioPredict::libpressio_predict APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(LibPressioPredict::libpressio_predict PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib64/liblibpressio_predict.so"
  IMPORTED_SONAME_RELEASE "liblibpressio_predict.so"
  )

list(APPEND _cmake_import_check_targets LibPressioPredict::libpressio_predict )
list(APPEND _cmake_import_check_files_for_LibPressioPredict::libpressio_predict "${_IMPORT_PREFIX}/lib64/liblibpressio_predict.so" )

# Import target "LibPressioPredict::pressio_predict_bench" for configuration "Release"
set_property(TARGET LibPressioPredict::pressio_predict_bench APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(LibPressioPredict::pressio_predict_bench PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/pressio_predict_bench"
  )

list(APPEND _cmake_import_check_targets LibPressioPredict::pressio_predict_bench )
list(APPEND _cmake_import_check_files_for_LibPressioPredict::pressio_predict_bench "${_IMPORT_PREFIX}/bin/pressio_predict_bench" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
