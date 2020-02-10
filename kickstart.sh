#!/bin/bash

# Init basic tools
init(){
  sudo apt install -y build-essential gcc make perl dkms
  sudo apt update
  sudo apt upgrade
  sudo apt dist-upgrade
  
  ssh-keygen -t rsa
}

# Update sources.list
update_sources(){
  _tgt_dir="/etc/apt/sources.list.d";
  _bkp_dir="${_tgt_dir}.O";
  _tmp_dir="/tmp/sources.list.d";

  if ( sudo mv "${_tgt_dir}" "${_bkp_dir}" ); then
    echo "Installing repository files to ${_tgt_dir}";
    sudo mkdir /etc/apt/sources.list.d;
    pushd /etc/apt/sources.list.d > /dev/null;
    grep -Ev '^#x|^\s*$' ./sources_list.txt | while read _line; do
      if ( echo "${_line}" | grep -q '^#_' );
        then
          _tgt_file=$(echo "${_line}"|cut -f2 -d' ');
          echo; echo "CREATE ${_tgt_file}";
        else
          echo "${_line}" | sudo tee -a "${_tgt_file}";
      fi;
    done;
    popd > /dev/null;
  else
    echo "Could not move ${_tgt_dir} ${_bkp_dir}. Please try running";
    echo "  'sudo rm -rf ${_tmp_dir} && sudo mv ${_bkp_dir} ${_tmp_dir}'";
    echo "  and then reattempt this action.";
  fi

  sudo ls >/dev/null && if [ 1 ]; then
    sudo apt update 2>&1 | grep NO_PUBKEY | sed -e 's?^.*NO_PUBKEY ??' \
    | while read _hash; do
        wget -O- "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${_hash}" \
          | sudo apt-key add -;
    done
  fi

  sudo apt-get update
}

# Install usefull tools
install_tools(){
  sudo apt update && sudo apt -y upgrade && sudo apt -y dist-upgrade;
  sudo apt install build-essential 			\
  				kubuntu-restricted-extras 		\
  				diffpdf 						          \
  				dmidecode 						        \
    				ffmpeg 							        \
    				gimp 							          \
    				gimp-data-extras 				    \
    				gimp-help-en 					      \
    				git 							          \
    				google-chrome-stable 			  \
    				htop 							          \
    				hwinfo 							        \
    				inkscape 						        \
    				kdiff3 							        \
    				kruler 							        \
    				meld 							          \
    				mesa-utils  					      \
    				mlocate 						        \
    				mtp-tools 						      \
    				net-tools 						      \
    				nfs-common  					      \
    				p7zip-full 						      \
    				p7zip-rar 						      \
    				pavucontrol     				    \
     				ppa-purge						        \
     				rar 							          \
     				sdparm							        \
     				steam-installer					    \
     				sqlite							        \
     				sysstat							        \
     				texlive							        \
    				tree 							          \
    				ttf-mscorefonts-installer 	\
    				ubuntu-wallpapers				    \
    				vdpau-driver-all          	\
    				vdpauinfo						        \
    				openvpn							        \
    				telegram-desktop				    \
    				vdpau-driver-all				    \
    				vdpauinfo						        \
    				apt-transport-https
}

# Docker and docker-compose
install_docker(){ 
  sudo apt install docker-ce
  sudo usermod -aG docker ${USER}
  sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

# Pycharm
install_pycharm(){
  pushd ~/Downloads
  wget 'https://download.jetbrains.com/python/pycharm-professional-2019.3.3.tar.gz?_ga=2.37580136.996380524.1581351371-1876604223.1581351371'
  _hash='8b5f7f1db3c53c1cddcde4c50c9d23528726cf7618144abcb5f80b5bd6fe058c' \
  && if ( sha256sum ideaIU-2019.2.4.tar.gz |grep -v "${_hash}"); then
    echo '--- Results ---'
    echo 'FAIL. DO NOT USE this package, it does not match checksum.';
    echo 'Please notify JetBrains of this issue.'
  else
    echo '--- Results ---'
    echo 'SUCCESS. Package passes checksum.';
  fi

  sudo tar xvzf ./pycharm-professional-2019.3.3.tar.gz -C /usr/local/lib
  popd
}


# Spotify
install_spotify(){
  curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add - 
  sudo apt-get install spotify-client
}

# Visual Code
install_vcode(){
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  sudo apt-get install code
}

########################################################################################################################

init
update_sources
install_tools
install_docker
install_vcode
install_spotify
install_pycharm
