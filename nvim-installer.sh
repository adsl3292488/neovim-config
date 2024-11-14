os_version=`cat /etc/os-release | awk -F '=' '{if($1 == "VERSION_ID"){print $2}}'`
#echo "no" | dpkg-reconfigure dash
echo [sudo] password for $USER :
read -s password

if [ $os_version == "\"22.04\"" ]; then
	nodejs_ver=v18.20.0
	neovim_ver=0.10.0
	apt_packege="gcc g++ curl wget git ripgrep build-essential make cmake python3.10 libpython3-dev python3-distutils python3-pip clang clang-tidy universal-ctags bear libtool-bin automake autoconf bison gperf flex texinfo libncurses5 libncurses5-dev ninja-build gettext unzip pkg-config rename software-properties-common npm xclip"
	apt_arr=($apt_packege)
elif [ $os_version == "\"20.04\"" ]; then
	nodejs_ver=v18.20.0
	neovim_ver=0.10.0
	apt_packege="gcc g++ curl wget git ripgrep build-essential make cmake python3.8 libpython3-dev python3-distutils python3-pip clang clang-tidy universal-ctags bear libtool-bin automake autoconf bison gperf flex texinfo libncurses5 libncurses5-dev ninja-build gettext unzip pkg-config rename software-properties-common npm xclip"
	apt_arr=($apt_packege)
elif [ $os_version == "\"18.04\"" ]; then
	nodejs_ver=v16.18.1
	neovim_ver=0.10.0
	apt_packege="gcc g++ curl wget git build-essential make cmake python3.6 libpython3-dev python3-distutils python3-pip clang clang-tidy ctags bear libtool-bin automake autoconf bison gperf flex texinfo libncurses5 libncurses5-dev ninja-build gettext unzip pkg-config rename software-properties-common npm xclip"
	apt_arr=($apt_packege)
else 
	echo "Not Support system version"
fi
packege_dir=./vim-packege
root_dir=`pwd`

help()
{
    echo "------------------------------------------"
    echo "---- nvim_install.sh help "
    echo "---- nvim_install.sh package"
    echo "---- nvim_install.sh nodejs"
    echo "---- nvim_install.sh neovim"
    echo "---- nvim_install.sh all"
    echo "------------------------------------------"
}

setting()
{
	echo "------------------------------------"
	echo "----SYSTEM version : $os_version----"
	echo "----nodejs version : $nodejs_ver----"
	echo "----neovim version : $neovim_ver----"
	echo "------------------------------------"
}

download_package()
{
	mkdir -p $packege_dir
	echo "------------------------------------"
#	apt-get clean
	echo $password | sudo -S apt-get update
	echo "apt install $apt_packege"
	for i in ${apt_arr[@]}
	do
		echo "apt install $i"
	echo $password | sudo -S apt-get install -y $i
	done
	if [ $os_version == "\"18.04\"" ];then
		curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
		echo $password | sudo -S dpkg -i ripgrep_13.0.0_amd64.deb
		echo $password | sudo -S apt-get update
		echo $password | sudo -S apt-get install ripgrep -y
	fi
	echo $password | sudo -S npm install -g tree-sitter-cli
	echo $password | sudo -S npm install -g neovim
	echo "------------------------------------"
	echo "downloading node-$nodejs_ver"
	wget -P ./$packege_dir https://nodejs.org/dist/$nodejs_ver/node-$nodejs_ver.tar.gz
	echo "downloading neovim-$neovim_ver"
	wget -P ./$packege_dir https://github.com/neovim/neovim/archive/refs/tags/v$neovim_ver.tar.gz 
}

install_nodejs()
{
	echo "Start to Install nodejs-$nodejs_ver"
	tar xzvf ./$packege_dir/node-$nodejs_ver.tar.gz -C ./$packege_dir
	cd ./$packege_dir/node-$nodejs_ver
	./configure
	make -j4
	echo $password | sudo -S make install
}

install_neovim()
{
	echo "-----Start to Install neovim-$neovim_ver-----"
	tar xzvf ./$packege_dir/v$neovim_ver.tar.gz -C $packege_dir
	cd ./$packege_dir/neovim-$neovim_ver
	make CMAKE_BUILD_TYPE=Release -j4
	echo $password | sudo -S make install

}
neovim_setup()
{
	echo "-----NeoVim SetUp-----"
   `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim`
    mkdir ~/.config
	if [ -f ./nvim.zip ];then
    	unzip ./nvim.zip -d ~/.config/
	else
		cp -r $root_dir/nvim ~/.config/
	fi
    echo "-----NeoVim SetUp Finish----"
    echo "-----Please using nvim -c \"PackerSync\" to install plugin----"
}

all()
{
    setting
    download_package
    install_neovim
    install_nodejs
    neovim_setup
}

args=$@
case "$args" in
    "help")
        help
        ;;
    "all")
        all
        ;;
    "neovim")
        setting
        install_neovim
        neovim_setup
        ;;
    "nodejs")
        setting
        install_nodejs
        ;;
    "package")
    download_package
        ;;
    *)
        help 
        ;;
esac
#setting
#download_packege
#install_nodejs
#install_neovim


