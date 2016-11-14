
echo "here we go..."
numcores="$(nproc)"
#some basics:
sudo apt-get install -y git xclip chromium-browser flashplugin-installer curl

#Pixhawk 4 Shit
sudo usermod -a -G dialout $USER
sudo add-apt-repository ppa:george-edison55/cmake-3.x -y

#For color coded
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update


for i in  g++ cmake cmake-curses-gui cmake-qt-gui doxygen mpi-default-dev openmpi-bin openmpi-common  libflann* vim vim-gtk vlc libarmadillo* \
libcgal-dev libcgal-qt* libeigen3-dev libboost-all-dev libvtk6* libqhull* libusb-dev install libgtest-dev git-core freeglut3-dev pkg-config build-essential libxmu-dev \
libxi-dev libusb-1.0-0-dev graphviz mono-complete qt-sdk openjdk-8-jdk openjdk-8-jre screen byobu python-pip python-dev python-wstool libgsl-dev python-pip ntpdate texmaker vim vim-gtk \
ant protobuf-compiler libeigen3-dev libopencv-dev openjdk-8-jdk openjdk-8-jre clang-3.5 lldb-3.5 exuberant-ctags libclang-dev xz-utils libpthread-workqueue-dev liblua5.2-dev lua5.2 libncurses-dev \
python-argparse git-core wget zip python-empy qtcreator cmake build-essential genromfs g++-4.9; do
sudo apt-get install -y $i
done

if [ ! -f ~/.ssh/id_rsa.pub ]; then
ssh-keygen -t rsa -b 4096 -C "logan_ellis@me.com"
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub
read -n1 -rsp "Go to github, and paste SSH key. Press space to continue install..." key
fi


#Ros Install
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y ros-jade-desktop-full
sudo apt-get install -y python-catkin-tools
sudo rosdep init
rosdep update
echo "source /opt/ros/jade/setup.bash" >> ~/.bashrc
source ~/.bashrc
source /opt/ros/jade/setup.bash
sudo apt-get install -y python-rosinstall
sudo apt-get install -y ros-jade-control-toolbox 
sudo apt-get install -y ros-jade-hokuyo-node
#for PCL And libraries
cd ~/
git clone https://github.com/PointCloudLibrary/pcl.git
#cd ~/pcl
#mkdir release
#cd release
#cmake -DCMAKE_BUILD_TYPE=None ..
#echo 'SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")' >> ~/pcl/CMakeLists.txt
#make -j$numcores && sudo make install -j$numcores

#Delete vim and recompile from source
#sudo apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
#    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
#    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
#    python3-dev ruby-dev lua5.1 lua5.1-dev git
#sudo apt-get remove -y vim vim-runtime gvim vim-gtk
#sudo apt-get remove -y vim-common vim-gui-common vim-tiny
#sudo apt-get install -y checkinstall

#cd ~
#git clone https://github.com/vim/vim.git
#cd vim
#./configure --with-features=huge \
#            --enable-multibyte \
#            --enable-rubyinterp \
#            --enable-pythoninterp \
#            --with-python-config-dir=/usr/lib/python2.7/config \
#            --enable-python3interp \
 #           --with-python3-config-dir=/usr/lib/python3.5/config \
#            --enable-perlinterp \
#            --enable-luainterp \
#            --enable-gui=gtk2 --enable-cscope --prefix=/usr
#make VIMRUNTIMEDIR=/usr/share/vim/vim80
#sudo checkinstall

#Setting Vim as default editor
#sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1 
#sudo update-alternatives --set editor /usr/bin/vim
#sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
#sudo update-alternatives --set vi /usr/bin/vim



#All dat Vim Goodness
if [[ ! -d ~/fzf ]]; then
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
sudo ~/.fzf/install
fi

if [[ ! -d ~/vimfiles ]]; then
git clone https://www.github.com/logane/vimfiles
ln -s vimfiles ~/.vim
fi
vim -c "PlugInstall" +qall

#Youcomplete me install
cd ~/.vim/plugged/YouCompleteMe
./install.py --clang-completer
cd ~/



cd ~/.vim/plugged/color_coded
mkdir build && cd build
cmake ..
make -j$numcores && sudo make -j$numcores install 
make clean && make clean_clang
#end color_coded


sudo apt-get update

# simulation tools
sudo apt-get remove modemmanager

#Sphinx for docs
pip install sphinx sphinx-autobuild
if [[ ! -d ~/.byobu ]];then
mkdir ~/.byobu
fi
cp ~/osInstallScripts/tmux.conf ~/.byobu/.tmux.conf
cp ~/osInstallScripts/bash_aliases ~/.bash_aliases
echo "source ~/.bash_aliases" >> ~/.bashrc

mkdir ~/sandbox && cd ~/sandbox
git clone -b develop  git@gitlab.rasl.ri.cmu.edu:logane/laser_mav.git

cd laser_mav
bash <(curl -L -s https://goo.gl/KSmEYZ) && ./update --devel
