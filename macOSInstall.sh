#Start ROS Install
#curl https://raw.githubusercontent.com/mikepurvis/ros-install-osx/master/install | bash
#End ROS

git config --global user.email "logan_ellis@me.com"
git config --global user.name "loganE"

if [[ ! -f ~/.ssh/id_rsa.pub ]]; then
ssh-keygen -t rsa -b 4096 -C "logan_ellis@me.com"

echo "Go ahead and add your SSH to github, then type Yes to continue"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) make install; break;;
        No ) exit;;
    esac
done
fi

#Vimfiles
echo 'Installing Vim'
brew install macvim --with-lua -env-std --with-override-system-vim
brew linkapps macvim
brew install xz cmake

#fzf Install
brew install fzf
# Install shell extensions
/usr/local/opt/fzf/install
echo '[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> ~/.bash_profile

brew update && brew tap jlhonora/lsusb
brew install lsusb arp-scan

if [ ! -d ~/vimfiles/ ]; then
	cd ~/ && git clone http://www.github.com/logane/vimfiles
	ln -s ~/vimfiles/ ~/.vim
fi

reset
vim -c "PlugInstall" +qall

echo 'Compiling YCM and Color Coded'
cd ~/vimfiles/plugged/YouCompleteMe/
./install.py --clang-complete

cd ~/vimfiles/plugged/color_coded
rm -rf build
mkdir build && cd build
cmake ..
make && make install

cp ~/vimfiles/_fonts/* /Library/Fonts

echo 'if [ -f ~/.bashrc ]; then . ~/.bashrc; fi' >> ~/.bash_profile
echo "alias la='ls -a'">> ~/.bash_profile
echo 'source ~/ros_catkin_ws/install_isolated/setup.bash' >> ~/.bash_profile
ln -s ~/Dropbox/sandbox/ ~/sandbox
ln -s ~/Dropbox/Homework ~/hw
ln -s ~/Dropbox/bashrc ~/.bashrc

#PX4 Install
brew tap PX4/homebrew-px4
brew tap osrf/simulation
brew update
brew install git bash-completion genromfs kconfig-frontends gcc-arm-none-eabi
brew install astyle ninja
brew install ant graphviz sdformat3 rotobuf
brew install cgal --with-imaging
pip install empy pyserial
#to mount 
brew tap homebrew/fuse
brew install homebrew/fuse/osxfuse
brew install homebrew/fuse/ext4fuse
echo 'Whew. All done now'

#QGround Control
#Slack
#MenuMeters
#Bettersnaptool (APP STORE)
#caffeine
#http://www.silabs.com/Support%20Documents/Software/Mac_OSX_VCP_Driver.zip
#
