#echo "Clone ORB_SLAM3.git"
#git clone https://github.com/UZ-SLAMLab/ORB_SLAM3.git
#
## thirdparty
#cp ORB_SLAM3/Thirdparty/* thirdparty/ -r

echo "Configuring and building Thirdparty/DBoW2 ..."
cd thirdparty/DBoW2
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j30

cd ../../g2o

echo "Configuring and building Thirdparty/g2o ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j30

cd ../../Sophus

echo "Configuring and building Thirdparty/Sophus ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j30

cd ../../../

#echo "Uncompress vocabulary ..."
#
#cd Vocabulary
#tar -xf ORBvoc.txt.tar.gz
#cd ..

echo "Configuring and building ORB_SLAM3 ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j30