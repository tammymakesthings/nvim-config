#!/bin/bash
set -exu
set -o pipefail

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
    brew install lua-language-server
else
    echo "lua-language-server is already installed. Skip installing it."
fi

#######################################################################
#                            Ripgrep part                             #
#######################################################################
if [[ -z "$(command -v ripgrep)" ]]
then
    echo "Installing ripgrep"
    brew install ripgrep
else
    echo "ripgrep is already installed. Skip installing it."
fi

#######################################################################
#                            Ctags install                            #
#######################################################################
if [[ -z "$(command -v ctags)" ]]
then
    echo "Install ctags"
    brew install exuberant-ctags
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
