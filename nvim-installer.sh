#!/bin/bash
set -e
readonly PLATFORM=$(uname -s)
readonly SUPPORTED_OS_VERSIONS=$(awk -F '=' '/VERSION_ID/ {gsub(/"/, "", $2); print $2}' /etc/os-release)
readonly PACKAGE_DIR=./vim-package
readonly ROOT_DIR=$(pwd)

help() {
	echo "----------------------------------------------------------"
	echo "---- nvim_install.sh help "
	echo "---- nvim_install.sh package > Download Package"
	echo "---- nvim_install.sh neovim > Install Neovim and setting"
	echo "---- nvim_install.sh nodejs > Install Nodejs"
	echo "---- nvim_install.sh fd > Install fd"
	echo "---- nvim_install.sh lazygit > Install lazygit"
	echo "---- nvim_install.sh all"
	echo "----------------------------------------------------------"
}

check_ver() {
	if [ "$PLATFORM" == "Linux" ]; then
		case "$SUPPORTED_OS_VERSIONS" in
		"22.04")
			nodejs_ver=22.x
			apt_packages=(gcc g++ curl wget git ripgrep build-essential make
				cmake python3.10 libpython3-dev python3-distutils python3-pip clang
				clang-tidy clang-format universal-ctags bear libtool-bin automake
				autoconf bison gperf flex texinfo libncurses5 libncurses5-dev
				libpsl-dev ninja-build gettext unzip pkg-config rename
				software-properties-common xclip lua5.4 luarocks snapd rust-1.76-all)
			;;
		"24.04")
			nodejs_ver=24.x
			apt_packages=(gcc g++ curl wget git ripgrep build-essential make
				cmake python3.10 libpython3-dev python3-distutils python3-pip clang
				clang-tidy clang-format universal-ctags bear libtool-bin automake
				autoconf bison gperf flex texinfo libncurses5 libncurses5-dev
				libpsl-dev ninja-build gettext unzip pkg-config rename
				software-properties-common xclip lua5.4 luarocks snapd rust-1.76-all)
			;;
		*)
			nodejs_ver=20.x
			apt_packages=(gcc g++ curl wget git ripgrep build-essential make cmake
				python3.8 libpython3-dev python3-distutils python3-pip clang clang-tidy
				clang-format universal-ctags bear libtool-bin automake autoconf bison
				gperf flex texinfo libncurses5 libncurses5-dev libpsl-dev ninja-build
				gettext unzip pkg-config rename software-properties-common xclip lua5.3
				luarocks snapd rust-1.62-all)
			;;
		esac
	elif [ "$PLATFORM" == "debian" ]; then
		nodejs_ver=22.x
		apt_packages=(gcc g++ curl wget git ripgrep build-essential make
			cmake python3.10 libpython3-dev python3-distutils python3-pip clang
			clang-tidy clang-format universal-ctags bear libtool-bin automake
			autoconf bison gperf flex texinfo libncurses5 libncurses5-dev
			libpsl-dev ninja-build gettext unzip pkg-config rename
			software-properties-common xclip lua5.4 luarocks snapd rust-1.76-all)

	fi

	echo "------------------------------------"
	echo "----	PLATFORM : $PLATFORM"
	echo "----	SYSTEM version : $SUPPORTED_OS_VERSIONS"
	echo "----	nodejs version : $nodejs_ver"
	echo "------------------------------------"
}

check_pwd() {
	if ! command -v sudo >/dev/null 2>&1; then
		echo "sudo command not found, Continue without sudo"
		SUDO_AVAILABLE=0
		SUDO_CMD=""
		return 0
	fi

	SUDO_AVAILABLE=1
	SUDO_CMD="sudo"
	sudo -v
	while true; do
		sudo -n true
		sleep 60
	done &

	SUDO_PID=$!

	trap "kill $SUDO_PID" EXIT
	return 0
}

download_package() {
	if [[ ! -d "${PACKAGE_DIR}" ]]; then
		mkdir -p $PACKAGE_DIR
	fi

	$SUDO_CMD apt-get update

	# shellcheck disable=SC2068
	for pkg in "${apt_packages[@]}"; do
		if dpkg -s "$pkg" >/dev/null 2>&1; then
			echo "$pkg is already installed."
			continue
		fi
		for i in {1..3}; do
			echo -e "\033[32m apt install $pkg \033[0m"
			if $SUDO_CMD apt-get install -y "$pkg"; then
				break
			elif [ "$1" -eq 3 ]; then
				ecoh "Failed to install "$pkg" after 3 attempts."
			else
				echo "Retrying to install $pkg ($i/3)..."
				sleep 2
			fi
		done
	done

	echo "------Install curl------"
	if [ -f /.dockerenv ]; then
		echo "Running in a Docker container, skipping curl installation."
		return 0
	else
		$SUDO_CMD snap install curl
	fi
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

install_neovim() {
	neovim_ver=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
	echo "downloading neovim-$neovim_ver"
	neovim_pkg="$PACKAGE_DIR/v${neovim_ver}.tar.gz"
	if [[ ! -f "$neovim_pkg" ]]; then
		wget -q --show-progress -P "$PACKAGE_DIR" "https://github.com/neovim/neovim/archive/refs/tags/v$neovim_ver.tar.gz"
	fi

	echo "Extracting Neovim..."
	$SUDO_CMD tar xzvf "$PACKAGE_DIR/v${neovim_ver}.tar.gz" -C "$PACKAGE_DIR"
	cd "$PACKAGE_DIR/neovim-${neovim_ver}" || exit 1
	echo "Building Neovim..."
	$SUDO_CMD make CMAKE_BUILD_TYPE=Release -j"$(nproc)"

	echo "Installing Neovim..."
	$SUDO_CMD make install
}

install_nodejs() {
	echo "------Install nodejs------"
	if [[ "$SUDO_AVAILABLE" -eq 0 ]]; then
		curl -fsSL "https://deb.nodesource.com/setup_${nodejs_ver}" | bash -
	else
		curl -fsSL "https://deb.nodesource.com/setup_${nodejs_ver}" | sudo -E bash -
	fi
	$SUDO_CMD apt-get install -y nodejs
	$SUDO_CMD npm install -g tree-sitter-cli
	$SUDO_CMD npm install -g neovim
}

install_lazygit() {
	echo "------Install lazygit------"
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	$SUDO_CMD install lazygit -D -t /usr/local/bin/
}

install_fd() {
	echo "------Install fd------"
	FD_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/fd/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
	wget -P ./$PACKAGE_DIR https://github.com/sharkdp/fd/releases/download/v"${FD_VERSION}"/fd_"${FD_VERSION}"_amd64.deb
	$SUDO_CMD dpkg -i "$PACKAGE_DIR/fd_${FD_VERSION}_amd64.deb"
}

all() {
	download_package
	install_fd
	install_lazygit
	install_nodejs
	install_neovim
	neovim_setup
}

main() {
	check_pwd
	check_ver

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
	"fd")
		install_fd
		;;
	"lazygit")
		install_lazygit
		;;
	"nodejs")
		install_nodejs
		;;
	*)
		help
		;;
	esac
}
main "$@"
