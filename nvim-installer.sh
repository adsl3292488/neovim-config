#!/bin/bash
SUPPORTED_OS_VERSIONS=$( (cat /etc/os-release | awk -F '=' '{if($1 == "VERSION_ID"){print $2}}' | sed 's/"//g'))
PACKAGE_DIR=./vim-packege
ROOT_DIR=$(pwd)

help() {
	echo "----------------------------------------------------------"
	echo "---- nvim_install.sh help "
	echo "---- nvim_install.sh package > Download Package"
	echo "---- nvim_install.sh nodejs > Install nodejs"
	echo "---- nvim_install.sh neovim > Install Neovim and setting"
	echo "---- nvim_install.sh all"
	echo "----------------------------------------------------------"
}

check_ver() {
	#echo "no" | dpkg-reconfigure dash
	if [ $SUPPORTED_OS_VERSIONS == "22.04" ]; then
		nodejs_ver=v22.12.0
		neovim_ver=0.10.4
		apt_package="gcc g++ curl wget git ripgrep build-essential make cmake python3.10 libpython3-dev python3-distutils python3-pip clang clang-tidy clang-format universal-ctags bear libtool-bin automake autoconf bison gperf flex texinfo libncurses5 libncurses5-dev ninja-build gettext unzip pkg-config rename software-properties-common npm xclip"
		apt_arr=($apt_package)
	elif [ $SUPPORTED_OS_VERSIONS == "20.04" ]; then
		nodejs_ver=v20.18.1
		neovim_ver=0.10.4
		apt_package="gcc g++ curl wget git ripgrep build-essential make cmake python3.8 libpython3-dev python3-distutils python3-pip clang clang-tidy clang-format universal-ctags bear libtool-bin automake autoconf bison gperf flex texinfo libncurses5 libncurses5-dev ninja-build gettext unzip pkg-config rename software-properties-common npm xclip"
		apt_arr=($apt_package)
	elif [ $SUPPORTED_OS_VERSIONS == "18.04" ]; then
		nodejs_ver=v18.20.5
		neovim_ver=0.10.4
		apt_package="gcc g++ curl wget git build-essential make cmake python3.6 libpython3-dev python3-distutils python3-pip clang clang-tidy clang-format ctags bear libtool-bin automake autoconf bison gperf flex texinfo libncurses5 libncurses5-dev ninja-build gettext unzip pkg-config rename software-properties-common npm xclip"
		apt_arr=($apt_package)
	else
		echo "Not Support system version"
		exit 1
	fi
	echo "------------------------------------"
	echo "----SYSTEM version : $SUPPORTED_OS_VERSIONS----"
	echo "----nodejs version : $nodejs_ver----"
	echo "----neovim version : $neovim_ver----"
	echo "------------------------------------"
}

check_pwd() {
	if [ ! $(commend -v sudo >/dev/null 2>&1) ]; then
		return 0
	fi
	echo "" | sudo -S true 2>/dev/null
	if [[ $? -eq 1 ]]; then
		read -p "[sudo] password for $USER: " -s password
		echo $password | sudo -S true
	fi
	if [[ $? -eq 0 ]]; then
		return 0
	fi
	echo "Password incorrect ,please try again"
	return 1
}

install_lazygit() {
	if [[ $(check_pwd) ]]; then
		exit 1
	fi
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	echo $password | sudo -S install lazygit -D -t /usr/local/bin/
}

download_package() {
	if [[ $(check_pwd) ]]; then
		exit 1
	fi
	check_ver
	if [[ ! -d "${PACKAGE_DIR}" ]]; then
		mkdir -p $PACKAGE_DIR
	fi
	if [ $SUPPORTED_OS_VERSIONS == "18.04" ]; then
		echo $password | sudo -S add-apt-repository ppa:git-core/ppa
		curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
		echo $password | sudo -S dpkg -i ripgrep_13.0.0_amd64.deb
		echo $password | sudo -S apt-get update
		echo $password | sudo -S apt-get install ripgrep -y
	fi
	echo "------------------------------------"
	echo $password | sudo -S apt-get update
	echo "apt install $apt_package"
	for i in ${apt_arr[@]}; do
		echo "apt install $i"
		echo $password | sudo -S apt-get install -y $i
	done
	echo $password | sudo -S npm install -g tree-sitter-cli
	echo $password | sudo -S npm install -g neovim
	echo "------------------------------------"
	echo "downloading node-$nodejs_ver"
	wget -P ./$PACKAGE_DIR https://nodejs.org/dist/$nodejs_ver/node-$nodejs_ver.tar.gz
	echo "downloading neovim-$neovim_ver"
	wget -P ./$PACKAGE_DIR https://github.com/neovim/neovim/archive/refs/tags/v$neovim_ver.tar.gz
	echo "Install lazygit from github"
	install_lazygit
}

install_nodejs() {
	if [[ $(check_pwd) ]]; then
		exit 1
	fi
	check_ver
	echo "Start to Install nodejs-$nodejs_ver"
	tar xzvf ./$PACKAGE_DIR/node-$nodejs_ver.tar.gz -C ./$PACKAGE_DIR
	cd ./$PACKAGE_DIR/node-$nodejs_ver
	./configure
	make -j4
	echo $password | sudo -S make install
}

install_neovim() {
	if [[ $(check_pwd) ]]; then
		exit 1
	fi
	check_ver
	echo "-----Start to Install neovim-$neovim_ver-----"
	tar xzvf ./$PACKAGE_DIR/v$neovim_ver.tar.gz -C $PACKAGE_DIR
	cd ./$PACKAGE_DIR/neovim-$neovim_ver
	make CMAKE_BUILD_TYPE=Release -j4
	echo $password | sudo -S make install

}
neovim_setup() {
	echo "-----NeoVim Setup-----"
	$(git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim)
	if [[ ! -d "~/.config" ]]; then
		mkdir ~/.config
	fi
	if [ -f ./nvim.zip ]; then
		unzip ./nvim.zip -d ~/.config/
	else
		cp -r $ROOT_DIR/nvim ~/.config/
	fi

	if [ -f ~/.clang-format ]; then
		cp $ROOT_DIR/.clang-format ~/
	fi
	echo "-----NeoVim Setup Finish----"
	echo "-----Please using nvim -c \"PackerSync\" to install plugin----"
}

all() {
	if [[ $(check_pwd) ]]; then
		exit 1
	fi
	check_ver
	download_package
	install_neovim
	install_nodejs
	neovim_setup
}

main() {
	if [[ $# -lt 1 ]]; then
		echo "The parameter is less than 1, please refer help"
		echo "$0 help"
		exit
	fi
	args=$1
	case "$args" in
	"help")
		help
		;;
	"all")
		all
		;;
	"neovim")
		install_neovim
		neovim_setup
		;;
	"nodejs")
		install_nodejs
		;;
	"package")
		download_package
		;;
	*)
		help
		;;
	esac
}
main $@
