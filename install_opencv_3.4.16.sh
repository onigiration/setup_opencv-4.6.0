if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <Install Folder>"
    exit
fi

folder="$1"
user="user"
passwd="pass"

sudo sudo apt-get purge *libopencv*

sudo apt-get update
sudo apt-get install -y build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt-get install -y python2.7-dev python3.6-dev python-dev python-numpy python3-numpy
sudo apt-get install -y libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev
sudo apt-get install -y libv4l-dev v4l-utils qv4l2 v4l2ucp
sudo apt-get install -y curl
sudo apt-get update

echo "** Download opencv-3.4.16"
cd $folder
curl -L https://github.com/opencv/opencv/archive/3.4.16.zip -o opencv-3.4.16.zip
curl -L https://github.com/opencv/opencv_contrib/archive/3.4.16.zip -o opencv_contrib-3.4.16.zip
unzip opencv-3.4.16.zip
unzip opencv_contrib-3.4.16.zip

cd opencv-3.4.16/

echo "** Apply patch"
sed -i 's/include <Eigen\/Core>/include <eigen3\/Eigen\/Core>/g' modules/core/include/opencv2/core/private.hpp
sed -i 's/{CUDNN_INCLUDE_DIR}\/cudnn.h/{CUDNN_INCLUDE_DIR}\/cudnn_version.h/g' cmake/FindCUDNN.cmake

echo "** Building..."
mkdir release
cd release/
cmake \
-D CMAKE_BUILD_TYPE=RELEASE \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D WITH_CUDA=ON \
-D WITH_CUDNN=ON \
-D CUDA_ARCH_BIN="5.3,6.2,7.2" \
-D CUDA_ARCH_PTX="" \
-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.3.0/modules \
-D WITH_GSTREAMER=ON \
-D WITH_LIBV4L=ON \
-D BUILD_opencv_cudaarithm=ON -D BUILD_opencv_cudabgsegm=ON -D BUILD_opencv_cudacodec=ON \
-D BUILD_opencv_cudafeatures2d=ON -D BUILD_opencv_cudafilters=ON -D BUILD_opencv_cudaimgproc=ON \
-D BUILD_opencv_cudalegacy=ON -D BUILD_opencv_cudaobjdetect=ON -D BUILD_opencv_cudaoptflow=ON \
-D BUILD_opencv_cudastereo=ON -D BUILD_opencv_cudawarping=ON -D BUILD_opencv_cudev=ON \
-D BUILD_opencv_python2=ON \
-D BUILD_opencv_python3=ON \
-D BUILD_TESTS=OFF \
-D BUILD_PERF_TESTS=OFF \
-D BUILD_EXAMPLES=OFF \
-D CMAKE_INSTALL_PREFIX=/usr/local ..
make -j$(nproc)
#sudo make install
#echo 'export PYTHONPATH=$PYTHONPATH:'$PWD'/python_loader/' >> ~/.bashrc
#source ~/.bashrc

echo "** Install opencv successfully"
