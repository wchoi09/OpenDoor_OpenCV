#!/bin/sh
## 3-1 Update OS: To ensure our system is up-to-date, run the following
sudo apt update
sudo apt dist-upgrade

# 3-2 Install Dependencies and Libraries
## Compiler Tools
sudo apt install build-essential cmake pkg-config git
sudo apt install gcc g++

# image and video I/O libraries
sudo apt install libjpeg-dev libtiff5 libpng16-16 libpng-dev
sudo apt install libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev libx264-dev libxine2-dev
sudo apt install libv4l-dev v4l-utils

sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

# Install X windows libraries and OpenGL libraries
sudo apt install mesa-utils
sudo apt install libxmu-dev libxi-dev
sudo apt install libglu1-mesa libglu1-mesa-dev
sudo apt install libgles2-mesa libgles2-mesa-dev
sudo apt install libgl1-mesa-dev libgl1-mesa-dri 
sudo apt install libgtkgl2.0-1 libgtkgl2.0-dev libgtkglext1-dev
sudo apt install zlib1g zlib1g-dev
sudo apt install libboost-all-dev
sudo apt install libavresample-dev

# optimization libraries
sudo apt install libopenblas-dev libatlas-base-dev liblapack-dev gfortran libeigen3-dev
sudo apt install freeglut3 freeglut3-dev liblapack-doc libblas-dev
sudo apt install libtbb2 libtbb-dev libdc1394-utils libdc1394-22-dev

# GTK GUI support
sudo apt install libx11-dev libgtk-3-dev
# Option: libgtk2.0-dev / libgtk-3-dev / libqt4-dev / libqt5-dev (choose 1)

# Python3 and Development Packages
sudo apt install python3-dev python3.7-dev python3-pip

# Virtual Environment
sudo pip3 install virtualenv virtualenvwrapper “picamera[array]”
sudo pip3 install numpy (--upgrade)

# INSTALLATION STARTS HERE
# Specify OpenCV Version
cvVersion=”$master”

# Save current working directory and create a working directory
cwd=$(pwd)/opencv
mkdir -p $cwd
cd $cwd

## 3-3 Virtual Environment Setup
nano ~/.bashrc
## Append the following lines
# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
# Save and exit via ctrl + x, y, enter

# Reload ~/.bashrc
source ~/.bashrc

# Create Python3 Virtual Environment
mkvirtualenv OpenCV-“$cvVersion”-py3 -p python3

# Note: Python 2.7 will reach end of its life on January 1st, 2020 so I do not recommend using Python 2.7.

pip3 install cython
pip3 install numpy scipy matplotlib scikit-image scikit-learn ipython dlib
pip3 install face_recognition imutils
# quit virtual environment
deactivate

## 3-4 Download OpenCV to the Virtual Environment
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout $cvVersion
cd ..

git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout $cvVersion
cd ..

cd opencv

# Apply Patch
# https://github.com/AastaNV/JEP/blob/master/script/install_opencv4.1.1_Jetson.sh
sed -i 's/include <Eigen\/Core>/include <eigen3\/Eigen\/Core>/g' modules/core/include/opencv2/core/private.hpp
echo "find_package(OpenGL REQUIRED)" >>./samples/cpp/CMakeLists.txt
echo "find_package(GLUT REQUIRED)" >> ./samples/cpp/CMakeLists.txt
echo “find_package(ZLIB REQUIRED)” >> ./samples/cpp/CMakeLists.txt
sed -i '38s/.*/ ocv_target_link_libraries(${tgt} ${OPENCV_LINKER_LIBS}
${OPENCV_CPP_SAMPLES_REQUIRED_DEPS} ${OPENGL_LIBRARIES} ${GLUT_LIBRARY})/'
./samples/cpp/CMakeLists.txt

# /home/pi/opencv/opencv_contrib/modules/dnn_superres/samples/dnn_superres_multioutput.cpp
# Line 48: find “ss = std::…”, switch to “ss.str(output_names_str)”
mkdir build
cd build

## 3-4 Pt.2 Make and Install OpenCV to the Virtual Environment
workon OpenCV-“$cvVersion”-py3
cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
-D WITH_GSTREAMER=ON \
-D WITH_LIBV4L=ON \
-D WITH_V4L=ON \
-D WITH_TBB=ON \
-D WITH_IPP=OFF \
-D WITH_1394=OFF \
-D BUILD_WITH_DEBUG_INFO=OFF \
-D BUILD_DOCS=OFF \
-D INSTALL_C_EXAMPLES=ON \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D WITH_QT=OFF \
-D WITH_GTK=ON \
-D WITH_OPENGL=ON \
-D OPENCV_ENABLE_NONFREE=ON \
-D WITH_XINE=ON \
-D CMAKE_SHARED_LINKER_FLAGS=-latomic \
-D BUILD_NEW_PYTHON_SUPPORT=ON \
-D ENABLE_CXX11=ON \
-D ENABLE_NEON=ON \
-D ENABLE_VFPV3=ON \
-D OPENCV_SKIP_PYTHON_LOADER=ON \
-D OPENCV_PYTHON3_INSTALL_PATH=/home/pi/.virtualenvs/OpenCV-master-py3/lib/python3.7/site-packages \
-D BUILD_TESTS=OFF \
-D BUILD_EXAMPLES=OFF \
-D PYTHON_DEFAULT_EXECUTABLE=/usr/bin/python3 \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D BUILD_PERF_TESTS=OFF ..

# nproc refers to the number of CPU cores available in your system
make -j$(nproc)
sudo make install


## 3-5 Testing the Installation
# on a new terminal, activate virtual environment, run python and import OpenCV to check the installation
workon OpenCV-master-py3
python3
import cv2

# cv2 is the OpenCV library we installed, if the result of the last line outputs no errors, we are ready

# Installation is complete, end of shell script.







