echo "Configuring and building thirdparty/DBoW2 ..."

cd thirdparty/DBoW2 \
&&mkdir build \
&&cd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DOpenCV_DIR=/home/bert/CLionProjects/orbslam2/thirdparty/opencv/install/Release/share/OpenCV
make -j30

cd ../../g2o

echo "Configuring and building thirdparty/g2o ..."

mkdir build \
&&cd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DEIGEN3_INCLUDE_DIR=/home/bert/CLionProjects/orbslam2/thirdparty/eigen/install/Release/include/eigen3
make -j30

cd ../../../

echo "Uncompress vocabulary ..."

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM2 ..."

rm -rf build \
&&mkdir build \
&&cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j30
