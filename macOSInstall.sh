#Start ROS Install
#curl https://raw.githubusercontent.com/mikepurvis/ros-install-osx/master/install | bash
#End ROS
if [[ ! $* == *--pt2* ]]; then
read -n1 -rsp "Before we get started, make sure XCode is installed. Also install XQuarts, relog, and run again. Press space when it is" key
git config --global user.email "logan_ellis@me.com"
git config --global user.name "loganE"

if [[ ! -f ~/.ssh/id_rsa.pub ]]; then
ssh-keygen -t rsa -b 4096 -C "logan_ellis@me.com"
fi

read -n1 -rsp "Go to github, and paste SSH key. Press space to continue install..." key

echo "Installing ROS Now"
cd ~/

chmod +x install && ./install

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
brew install lsusb arp-scan byobu

  if [ ! -d ~/vimfiles/ ]; then
    cd ~/ && git clone http://www.github.com/logane/vimfiles
    ln -s ~/vimfiles/ ~/.vim
  fi
echo "Go ahead and close iterm completely. Open a new window of iterm, then run ./macInstall.sh --pt2"
exit 1
fi

if [[ $* == *--pt2* ]]; then
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
echo 'source ~/ros_catkin_ws/install_isolated/setup.bash' >> ~/.bash_profile
ln -s ~/Dropbox/sandbox/ ~/sandbox
ln -s ~/Dropbox/Homework ~/hw

if [[ -d ~/.byobu ]]; then
  mkdir ~/.byobu
fi

cp ~/osInstallScripts/tmux.conf ~/.byobu/.tmux.conf
if [[ -f ~/.bash_aliases ]]; then
  rm -rf ~/.bash_aliases
fi
ln -s ~/osInstallScripts/bash_aliases ~/.bash_aliases
echo "source ~/.bash_aliases" >> ~/.bash_profile

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

#random
brew tap d12frosted/emacs-plus
brew install emacs-plus
brew linkapps emacs-plus

brew install ctags gdb

echo "set startup-with-shell off" >> ~/.gdbinit
fi

echo 'Whew. All done now'

#QGround Control
#Slack
#MenuMeters
#Bettersnaptool (APP STORE)
#caffeine
#http://www.silabs.com/Support%20Documents/Software/Mac_OSX_VCP_Driver.zip
#


