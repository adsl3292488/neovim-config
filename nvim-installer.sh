#!/bin/bash
SUPPORTED_OS_VERSIONS=$(awk -F '=' '/VERSION_ID/ {gsub(/"/, "", $2); print $2}' /etc/os-release)
PACKAGE_DIR=./vim-packege
ROOT_DIR=$(pwd)

help() {
	echo "----------------------------------------------------------"
	echo "---- nvim_install.sh help "
	echo "---- nvim_install.sh package > Download Package"
	echo "---- nvim_install.sh neovim > Install Neovim and setting"
	echo "---- nvim_install.sh all"
	echo "----------------------------------------------------------"
}

check_ver() {
	if [ "$SUPPORTED_OS_VERSIONS" == "22.04" ]; then
		nodejs_ver=22.x
		neovim_ver=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
		apt_package="gcc g++ curl wget git ripgrep build-essential make cmake python3.10 libpython3-dev python3-distutils python3-pip clang clang-tidy clang-format universal-ctags bear libtool-bin automake autoconf bison gperf flex texinfo libncurses5 libncurses5-dev libpsl-dev ninja-build gettext unzip pkg-config rename software-properties-common xclip lua5.4 luarocks snapd"
		apt_arr=("$apt_package")
	elif [ "$SUPPORTED_OS_VERSIONS" == "20.04" ]; then
		nodejs_ver=20.x
		neovim_ver=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
		apt_package="gcc g++ curl wget git ripgrep build-essential make cmake python3.8 libpython3-dev python3-distutils python3-pip clang clang-tidy clang-format universal-ctags bear libtool-bin automake autoconf bison gperf flex texinfo libncurses5 libncurses5-dev libpsl-dev ninja-build gettext unzip pkg-config rename software-properties-common xclip lua5.3 luarocks snapd"
		apt_arr=("$apt_package")
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
    if ! command -v sudo >/dev/null 2>&1; then
        echo "sudo command not found. Continuing without sudo."
        return 2
    fi
	echo "" | sudo -S true 2>/dev/null
	if [[ $? -eq 1 ]]; then
		read -p "[sudo] password for $USER: " -s passwd
		export password=$passwd
		echo "$password" | sudo -S true
	fi
  
	if [[ $? -eq 0 ]]; then
		return 0
	else
		read -p "[sudo] password for $USER: " -s password
		echo $password | sudo -S true
		if [[ $? -eq 0 ]]; then
			return 0
		else
			echo "Password incorrect, please try again"
			return 1
		fi
	fi
}

install_lazygit() {

    check_pwd
    if [[ $? -eq 1 ]]; then
        exit 1
    fi
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	echo "$password" | sudo -S install lazygit -D -t /usr/local/bin/
}

download_package() {
    check_pwd
    if [[ $? -eq 1 ]]; then
        exit 1
    fi
	check_ver
	if [[ ! -d "${PACKAGE_DIR}" ]]; then
		mkdir -p $PACKAGE_DIR
	fi

	echo "$password" | sudo -S apt-get update
	echo "apt install $apt_package"
	for i in "${apt_arr[@]}"; do
		echo "apt install $i"
		echo "$password" | sudo -S apt-get install -y "$i"
	done
	echo "------Install curl------"
	echo "$password" | sudo -S snap install curl
	echo "------Install nodejs------"
	curl -fsSL https://deb.nodesource.com/setup_"$nodejs_ver" | sudo -E bash -
	echo "$password" | sudo -S apt-get install -y nodejs
	echo "$password" | sudo -S npm install -g tree-sitter-cli
	echo "$password" | sudo -S npm install -g neovim
	echo "------------------------------------"
	FD_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/fd/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
	wget -P ./$PACKAGE_DIR https://github.com/sharkdp/fd/releases/download/v"${FD_VERSION}"/fd_"${FD_VERSION}"_amd64.deb
	echo "$password" | sudo -S dpkg -i ./$PACKAGE_DIR/fd_"${FD_VERSION}"_amd64.deb
	echo "downloading neovim-$neovim_ver"
	wget -P ./$PACKAGE_DIR https://github.com/neovim/neovim/archive/refs/tags/v"$neovim_ver".tar.gz
	echo "Install lazygit from github"
	install_lazygit
}

install_neovim() {
    check_pwd
    if [[ $? -eq 1 ]]; then
        exit 1
    fi
	check_ver
	echo "-----Start to Install neovim-$neovim_ver-----"
	tar xzvf ./$PACKAGE_DIR/v"$neovim_ver".tar.gz -C $PACKAGE_DIR
	cd ./$PACKAGE_DIR/neovim-"$neovim_ver" || exit 1
	make CMAKE_BUILD_TYPE=Release -j4

	echo "$password" | sudo -S make install
}

neovim_setup() {
	echo "-----NeoVim Setup-----"
  [ ! -d "$HOME/.config" ] && mkdir -p "$HOME/.config"

	if [ -f ./nvim.zip ]; then
		unzip ./nvim.zip -d "$HOME"/.config/
	else
		cp -r "$ROOT_DIR"/nvim ~/.config/
	fi
  [ ! -f "$HOME/.clang-format" ] && cp "$ROOT_DIR/.clang-format" "$HOME/"
}

all() {
    check_pwd
    if [[ $? -eq 1 ]]; then
        exit 1
    fi
	check_ver
	download_package
	install_neovim
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
	"package")
		download_package
		;;
	*)
		help
		;;
	esac
}
main "$@"
