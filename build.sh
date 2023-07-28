echo "Clone ORB_SLAM3.git"
git clone https://github.com/UZ-SLAMLab/ORB_SLAM3.git

# thirdparty
cp ORB_SLAM3/Thirdparty/* thirdparty/ -r

sudo apt install libboost-dev libboost-serialization-dev -y
sudo apt install openssl libssl-dev -y

echo "Clear build file ..."
rm -rf thirdparty/DBoW2/build
rm -rf thirdparty/g2o/build
rm -rf thirdparty/Sophus/build
rm -rf build

echo "Configuring and building thirdparty/DBoW2 ..."
cd thirdparty/DBoW2 \
&&mkdir build \
&&cd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DOpenCV_DIR=/home/bert/CLionProjects/orbslam3/thirdparty/opencv/install/Release/lib/cmake/opencv4
make -j30

cd ../../g2o

echo "Configuring and building thirdparty/g2o ..."

mkdir build \
&&cd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DEigen3_DIR=/home/bert/CLionProjects/orbslam3/thirdparty/eigen/install/Release/share/eigen3/cmake
make -j30

cd ../../Sophus

echo "Configuring and building thirdparty/Sophus ..."

mkdir build \
&&cd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DEigen3_DIR=/home/bert/CLionProjects/orbslam3/thirdparty/eigen/install/Release/share/eigen3/cmake
make -j30

cd ../../../

echo "Uncompress vocabulary ..."
cd Vocabulary
tar -xf ORBvoc.txt.tar.gz
cd ..

echo "Configuring and building ORB_SLAM3 ..."

mkdir build \
&&cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j30