cmake_minimum_required (VERSION 3.20)
project (prediction_eval)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(LibPressioTools REQUIRED)
find_package (LibPressioPredict REQUIRED)


add_executable(evaluation evaluation.cc)
find_library(LIBPRESSIO_LIB NAMES liblibpressio PATHS /home/ziweiq2/LibPressio/mydevenv/.spack-env/view/lib64)

link_directories("/home/ziweiq2/LibPressio/spack/opt/spack/linux-rhel9-zen4/gcc-14.2.0/libpressio-git.master_1.0.4-oblwz5qx36vpoiswvb6pnmxt67kcgxk6/lib64")


# target_link_libraries(evaluation PRIVATE pressio)
target_link_libraries(evaluation PRIVATE
		# pressio
		/home/ziweiq2/LibPressio/spack/opt/spack/linux-rhel9-zen4/gcc-14.2.0/libpressio-git.master_1.0.4-oblwz5qx36vpoiswvb6pnmxt67kcgxk6/lib64/liblibpressio.so

       	LibPressioTools::libpressio_meta
       	LibPressioPredict::libpressio_predict
)





set(CMAKE_PREFIX_PATH "$ENV{HOME}/LibPressio/predict-install")


include_directories($ENV{HOME}/LibPressio/predict-install/include)








