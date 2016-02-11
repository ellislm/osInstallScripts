echo "here we go..."
numcores="$(nproc)"
scriptDir=~/Dropbox/Backups/osInstallScripts
rosversion=kinetic
if [[ $( lsb_release -r | grep -oP "[0-9]+" | head -1 ) == 14 ]]; then
  rosversion=jade
fi

#some basics:
sudo apt-get install -y git xclip chromium-browser flashplugin-installer curl

sudo apt-get update

if [ ! -f ~/.ssh/id_rsa.pub ]; then
ssh-keygen -t rsa -b 4096 -C "logan_ellis@me.com"
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub
read -n1 -rsp "Go to github, and paste SSH key. Press space to continue install..." key
fi

#For color coded
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update

#Apt install list
cat ${scriptDir}/apt_install.txt | sudo xargs -n 1 apt install -y


#Ros Install
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y ros-$rosversion-desktop-full
sudo apt-get install -y python-catkin-tools
sudo rosdep init
rosdep update
echo "source /opt/ros/${rosversion}/setup.bash" >> ~/.bashrc
source ~/.bashrc
source /opt/ros/$rosversion/setup.bash
sudo apt-get install -y python-rosinstall
sudo apt-get install -y ros-$rosversion-control-toolbox 

if [[ rosversion=jade ]]; then
sudo apt-get install -y ros-jade-hokuyo-node
fi
#for PCL And libraries
cd ~/
git clone https://github.com/PointCloudLibrary/pcl.git
cd ~/pcl
mkdir release
cd release
cmake -DCMAKE_BUILD_TYPE=None \
      -DCMAKE_CXX_FLAGS=-std=c++11\
      -DBUILD_CUDA=OFF -DBUILD_GPU=OFF -DBUILD_apps=OFF -DBUILD_examples=OFF -DBUILD_geometry=OFF \
      -DBUILD_geometry=OFF -DBUILD_global_tests=OFF -DBUILD_ml=OFF -DBUILD_ml=OFF -DBUILD_ml=OFF \
      -DBUILD_outofcore=OFF -DBUILD_people=OFF -DBUILD_recognition=OFF -DBUILD_segmentation=OFF \
      -DBUILD_simulation=OFF -DBUILD_surface_on_nurbs=OFF -DBUILD_visualization=OFF ..
make -j$numcores && sudo make install -j$numcores

#All dat Vim Goodness
if [[ ! -d ~/fzf ]]; then
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
sudo ~/.fzf/install
fi

if [[ ! -d ~/vimfiles ]]; then
git clone https://www.github.com/logane/vimfiles ~/.vim
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


# simulation tools
#sudo apt-get remove modemmanager
#Pip install
cat ${scriptDir}/pip_global.txt | sudo xargs -n 1 pip install

if [[ ! -d ~/.byobu ]];then
mkdir ~/.byobu
fi
cp ~/Dropbox/Backups/osInstallScripts/tmux.conf ~/.byobu/.tmux.conf

#Linking Aliases
ln -s ~/Dropbox/Backups/bash_aliases ~/.bash_aliases
ln -s ~/Dropbox/Backups/bash_functions ~/.bash_functions
echo "source ~/.bash_aliases" >> ~/.bashrc
echo "source ~/.bash_functions" >> ~/.bashrc

mkdir ~/sandbox
