#!/bin/bash
set -exu
set -o pipefail

if [[ ! -d "$HOME/sw/" ]]; then
    mkdir -p "$HOME/sw"
fi

# Install some Python packages used by Nvim plugins.
echo "Installing Python packages"
declare -a PY_PACKAGES=("pynvim" 'python-lsp-server[all]' "black" "vim-vint" "pyls-isort" "pylsp-mypy")
pip install ${PY_PACKAGES}

# Install vim-language-server
npm install -g vim-language-server bash-language-server

#######################################################################
#                         lua-language-server                         #
#######################################################################

if [[ -z "$(command -v lua-language-server)" ]]
then
    echo 'Install lua-language-server'
    pushd $HOME/sw
    git clone git@github.com:LuaLS/lua-language-server
    cd lua-language-server
    chmod +x **/*.sh
    ./make.sh && ln -s bin/lua-language-server ~/sw/bin/lua-language-server
    popd
  fi
else
    echo "lua-language-server is already installed. Skip installing it."
fi

#######################################################################
#                            Ripgrep part                             #
#######################################################################
if [[ -z "$(command -v ripgrep)" ]]
then
    echo "Installing ripgrep"
    sudo apt install ripgrep
else
    echo "ripgrep is already installed. Skip installing it."
fi

#######################################################################
#                            Ctags install                            #
#######################################################################
if [[ -z "$(command -v ctags)" ]]
then
    echo "Install ctags"
    sudo apt install exuberant-ctags
else
    echo "ctags is already installed. Skip installing it."
fi

echo "Installing packer.nvim"
if [[ ! -d ~/.local/share/nvim/site/pack/packer/opt/packer.nvim ]]; then
    git clone --depth=1 https://github.com/wbthomason/packer.nvim \
        ~/.local/share/nvim/site/pack/packer/opt/packer.nvim
fi

echo "Installing nvim plugins, please wait"
nvim -c "autocmd User PackerComplete quitall" -c "PackerSync"

echo "Finished installing Nvim and its dependencies!"
