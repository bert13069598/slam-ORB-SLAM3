echo "Configuring and building thirdparty/DBoW2 ..."

cd thirdparty/DBoW2 \
&&mkdir build \
&&cd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DOpenCV_DIR=/home/bert/CLionProjects/orbslam2/thirdparty/opencv/install/Release/lib/cmake/opencv4
make -j30

cd ../../g2o

echo "Configuring and building thirdparty/g2o ..."

mkdir build \
&&cd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DEigen3_DIR=/home/bert/CLionProjects/orbslam2/thirdparty/eigen/install/Release/share/eigen3/cmake
make -j30

cd ../../../

echo "Uncompress vocabulary ..."

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM2 ..."

mkdir build \
&&cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j30
