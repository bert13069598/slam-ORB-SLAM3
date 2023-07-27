cmake_minimum_required(VERSION 3.10)
project(ORB_SLAM3 LANGUAGES CXX)
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

# Load libraries
include(cmake_files/find_eigen3)
include(cmake_files/find_image_exts) # ${IMAGE_LIBS} - png, jpeg, tiff, zlib
include(cmake_files/find_yaml_cpp)
include(cmake_files/find_opencv)
include(cmake_files/find_ceres)
include(cmake_files/find_gl) # ${GL_LIBS} - OpenGL, GLUT, GLEW
include(cmake_files/find_pangolin)
include(cmake_files/find_gtest)
include(cmake_files/find_easy_profiler)
include(cmake_files/find_doxygen)
include(cmake_files/find_spdlog)

include_directories("modules")
include_directories(
        ${PROJECT_SOURCE_DIR}
        ${PROJECT_SOURCE_DIR}/modules/orbslam3/include
        ${PROJECT_SOURCE_DIR}/modules/orbslam3/include/CameraModels
        ${PROJECT_SOURCE_DIR}/thirdparty/Sophus
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
        modules/orbslam3/src/System.cc
        modules/orbslam3/src/Tracking.cc
        modules/orbslam3/src/LocalMapping.cc
        modules/orbslam3/src/LoopClosing.cc
        modules/orbslam3/src/ORBextractor.cc
        modules/orbslam3/src/ORBmatcher.cc
        modules/orbslam3/src/FrameDrawer.cc
        modules/orbslam3/src/Converter.cc
        modules/orbslam3/src/MapPoint.cc
        modules/orbslam3/src/KeyFrame.cc
        modules/orbslam3/src/Atlas.cc
        modules/orbslam3/src/Map.cc
        modules/orbslam3/src/MapDrawer.cc
        modules/orbslam3/src/Optimizer.cc
        modules/orbslam3/src/Frame.cc
        modules/orbslam3/src/KeyFrameDatabase.cc
        modules/orbslam3/src/Sim3Solver.cc
        modules/orbslam3/src/Viewer.cc
        modules/orbslam3/src/ImuTypes.cc
        modules/orbslam3/src/G2oTypes.cc
        modules/orbslam3/src/CameraModels/Pinhole.cpp
        modules/orbslam3/src/CameraModels/KannalaBrandt8.cpp
        modules/orbslam3/src/OptimizableTypes.cpp
        modules/orbslam3/src/MLPnPsolver.cpp
        modules/orbslam3/src/GeometricTools.cc
        modules/orbslam3/src/TwoViewReconstruction.cc
        modules/orbslam3/src/Config.cc
        modules/orbslam3/src/Settings.cc
        modules/orbslam3/include/System.h
        modules/orbslam3/include/Tracking.h
        modules/orbslam3/include/LocalMapping.h
        modules/orbslam3/include/LoopClosing.h
        modules/orbslam3/include/ORBextractor.h
        modules/orbslam3/include/ORBmatcher.h
        modules/orbslam3/include/FrameDrawer.h
        modules/orbslam3/include/Converter.h
        modules/orbslam3/include/MapPoint.h
        modules/orbslam3/include/KeyFrame.h
        modules/orbslam3/include/Atlas.h
        modules/orbslam3/include/Map.h
        modules/orbslam3/include/MapDrawer.h
        modules/orbslam3/include/Optimizer.h
        modules/orbslam3/include/Frame.h
        modules/orbslam3/include/KeyFrameDatabase.h
        modules/orbslam3/include/Sim3Solver.h
        modules/orbslam3/include/Viewer.h
        modules/orbslam3/include/ImuTypes.h
        modules/orbslam3/include/G2oTypes.h
        modules/orbslam3/include/CameraModels/GeometricCamera.h
        modules/orbslam3/include/CameraModels/Pinhole.h
        modules/orbslam3/include/CameraModels/KannalaBrandt8.h
        modules/orbslam3/include/OptimizableTypes.h
        modules/orbslam3/include/MLPnPsolver.h
        modules/orbslam3/include/GeometricTools.h
        modules/orbslam3/include/TwoViewReconstruction.h
        modules/orbslam3/include/SerializationUtils.h
        modules/orbslam3/include/Config.h
        modules/orbslam3/include/Settings.h)

add_subdirectory(thirdparty/g2o)
add_subdirectory(modules/module1)

target_link_libraries(${PROJECT_NAME}
        ${OpenCV_LIBS}
        ${EIGEN3_LIBS}
        ${Pangolin_LIBRARIES}
        ${PROJECT_SOURCE_DIR}/thirdparty/DBoW2/lib/libDBoW2.so
        ${PROJECT_SOURCE_DIR}/thirdparty/g2o/lib/libg2o.so
        -lboost_serialization
        -lcrypto
        module1
        )
include_directories(${PROJECT_NAME}
        ${MODULE1_INCLUDE_PATH}
            )

# If RealSense SDK is found the library is added and its examples compiled
if(realsense2_FOUND)
    include_directories(${PROJECT_NAME}
            ${realsense_INCLUDE_DIR}
            )
    target_link_libraries(${PROJECT_NAME}
            ${realsense2_LIBRARY}
            )
endif()

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

#Monocular examples
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

add_executable(mono_tum_vi
        examples/Monocular/mono_tum_vi.cc)
target_link_libraries(mono_tum_vi ${PROJECT_NAME})

if(realsense2_FOUND)
    add_executable(mono_realsense_t265
            examples/Monocular/mono_realsense_t265.cc)
    target_link_libraries(mono_realsense_t265 ${PROJECT_NAME})

    add_executable(mono_realsense_D435i
            examples/Monocular/mono_realsense_D435i.cc)
    target_link_libraries(mono_realsense_D435i ${PROJECT_NAME})
endif()

#Stereo examples
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/examples/Stereo)

add_executable(stereo_kitti
        examples/Stereo/stereo_kitti.cc)
target_link_libraries(stereo_kitti ${PROJECT_NAME})

add_executable(stereo_euroc
        examples/Stereo/stereo_euroc.cc)
target_link_libraries(stereo_euroc ${PROJECT_NAME})

add_executable(stereo_tum_vi
        examples/Stereo/stereo_tum_vi.cc)
target_link_libraries(stereo_tum_vi ${PROJECT_NAME})

if(realsense2_FOUND)
    add_executable(stereo_realsense_t265
            examples/Stereo/stereo_realsense_t265.cc)
    target_link_libraries(stereo_realsense_t265 ${PROJECT_NAME})

    add_executable(stereo_realsense_D435i
            examples/Stereo/stereo_realsense_D435i.cc)
    target_link_libraries(stereo_realsense_D435i ${PROJECT_NAME})
endif()