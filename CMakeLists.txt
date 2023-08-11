cmake_minimum_required(VERSION 3.10)
project(ORB_SLAM2 LANGUAGES CXX)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_MODULE_PATH})

#------------------------------------------
# CXX build flags
#------------------------------------------
set(CMAKE_VERBOSE_MAKEFILE no)
set(CMAKE_CXX_STANDARD_COMPUTED_DEFAULT "11")
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if (CMAKE_BUILD_TYPE)
    # Terminate build if build option is invalid (i.e. Not Debug or Release)
    if (NOT CMAKE_BUILD_TYPE MATCHES "Debug" AND NOT CMAKE_BUILD_TYPE MATCHES "Release")
        message(FATAL_ERROR "Invalid build type: should be either Debug or Release")
    endif (NOT CMAKE_BUILD_TYPE MATCHES "Debug" AND NOT CMAKE_BUILD_TYPE MATCHES "Release")

    message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
endif (CMAKE_BUILD_TYPE)

# Default build type (Release)
if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Build type: Release (default)")
    set(CMAKE_BUILD_TYPE "Release" CACHE
            STRING "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
            "Debug" "Release") # Set the possible values of build type for cmake-gui
endif (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)

if (CMAKE_BUILD_TYPE MATCHES "Debug")
    set(CMAKE_CXX_FLAGS "-g -O0 -fPIC")
    add_definitions(-DBUILD_DEBUG=1)
elseif (CMAKE_BUILD_TYPE MATCHES "Release")
    set(CMAKE_CXX_FLAGS "-g -O3 -DNDEBUG -fPIC")
    add_definitions(-DBUILD_DEBUG=0)
endif ()

#----------------------------------------
# Load third party libraries
#----------------------------------------

# Define system-installed library paths
list(APPEND CMAKE_PREFIX_PATH /usr)
LIST(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake_modules)

# Load libraries
include(cmake_files/find_eigen3)
include(cmake_files/find_image_exts) # ${IMAGE_LIBS} - png, jpeg, tiff, zlib
include(cmake_files/find_yaml_cpp)
include(cmake_files/find_opencv)
#include(cmake_files/find_ceres)
include(cmake_files/find_gl) # ${GL_LIBS} - OpenGL, GLUT, GLEW
include(cmake_files/find_pangolin)
include(cmake_files/find_gtest)
include(cmake_files/find_easy_profiler)
include(cmake_files/find_doxygen)
include(cmake_files/find_spdlog)

include_directories("modules")
include_directories(
        ${PROJECT_SOURCE_DIR}
        ${PROJECT_SOURCE_DIR}/modules/orbslam2/include
        ${EIGEN3_INCLUDE_DIR}
        ${Pangolin_INCLUDE_DIRS}
)

#----------------------------------------
# Build internal libraries
#----------------------------------------
set(CMAKE_CXX_STANDARD_COMPUTED_DEFAULT "11")
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)

add_library(${PROJECT_NAME} SHARED
        modules/orbslam2/src/System.cc
        modules/orbslam2/src/Tracking.cc
        modules/orbslam2/src/LocalMapping.cc
        modules/orbslam2/src/LoopClosing.cc
        modules/orbslam2/src/ORBextractor.cc
        modules/orbslam2/src/ORBmatcher.cc
        modules/orbslam2/src/FrameDrawer.cc
        modules/orbslam2/src/Converter.cc
        modules/orbslam2/src/MapPoint.cc
        modules/orbslam2/src/KeyFrame.cc
        modules/orbslam2/src/Map.cc
        modules/orbslam2/src/MapDrawer.cc
        modules/orbslam2/src/Optimizer.cc
        modules/orbslam2/src/PnPsolver.cc
        modules/orbslam2/src/Frame.cc
        modules/orbslam2/src/KeyFrameDatabase.cc
        modules/orbslam2/src/Sim3Solver.cc
        modules/orbslam2/src/Initializer.cc
        modules/orbslam2/src/Viewer.cc
)

add_subdirectory(modules/module1)

target_link_libraries(${PROJECT_NAME}
        ${OpenCV_LIBS}
        ${EIGEN3_LIBS}
        ${Pangolin_LIBRARIES}
        ${PROJECT_SOURCE_DIR}/thirdparty/DBoW2/lib/libDBoW2.so
        ${PROJECT_SOURCE_DIR}/thirdparty/g2o/lib/libg2o.so
)

#----------------------------------------
# Executables
#----------------------------------------

add_executable(example1
        examples/example1.cpp
        )
target_include_directories(example1 PRIVATE
        ${MODULE1_INCLUDE_PATH}
        )
target_link_libraries(example1 PRIVATE
        module1
        )

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/examples/RGB-D)

add_executable(rgbd_tum
        examples/RGB-D/rgbd_tum.cc)
target_link_libraries(rgbd_tum ${PROJECT_NAME})

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/examples/Stereo)

add_executable(stereo_kitti
        examples/Stereo/stereo_kitti.cc)
target_link_libraries(stereo_kitti ${PROJECT_NAME})

add_executable(stereo_euroc
        examples/Stereo/stereo_euroc.cc)
target_link_libraries(stereo_euroc ${PROJECT_NAME})


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/examples/Monocular)

add_executable(mono_tum
        examples/Monocular/mono_tum.cc)
target_link_libraries(mono_tum ${PROJECT_NAME})

add_executable(mono_kitti
        examples/Monocular/mono_kitti.cc)
target_link_libraries(mono_kitti ${PROJECT_NAME})

add_executable(mono_euroc
        examples/Monocular/mono_euroc.cc)
target_link_libraries(mono_euroc ${PROJECT_NAME})
