#!/bin/zsh
setopt EXTENDED_GLOB

dir=$( cd "$(dirname "$0")" || exit;  pwd -P)

dotfiles=(".gitconfig" ".tmux.conf" ".bashrc")
for dotfile in "${dotfiles[@]}"; do
  ln -sf "${dir}/${dotfile}" "${HOME}/"
done

rm -rf ${HOME}/.vim

vimfolders=(".vim/files/backup" ".vim/files/info" ".vim/files/swap" ".vim/files/undo" ".vim/vim-addons")
for vimfolder in "${vimfolders[@]}"; do
  mkdir -p "${HOME}/${vimfolder}"
done

cd ${HOME}/.vim/vim-addons
git init
while IFS= read -r line; do git submodule add $line; done < <(cat ${dir}/.gitmodules | grep 'url' | cut -c 8-)
git submodule update --init --recursive
${HOME}/.vim/vim-addons/YouCompleteMe/install.py
git add . && git commit -m 'initial commit'

cd ${dir}
ln -sf "${dir}/vim/.vimrc" "${HOME}/.vim/vimrc"

zshfiles=(".zlogin" ".zlogout" ".zprofile" ".zshenv" ".zprezto" ".zpreztorc" ".zshrc")
for rcfile in "${zshfiles[@]}"; do
  rm -rf "${HOME}/${rcfile}"
done

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${HOME}/.zprezto"
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
rm -f ${HOME}/.zshrc
rm -f ${HOME}/.zpreztorc
ln -sf "${dir}/zsh/.zshrc" "${HOME}/"
ln -sf "${dir}/zsh/.zpreztorc" "${HOME}/"
ln -sf "${dir}/zsh/prompt_josh_setup" "${HOME}/.zprezto/modules/prompt/functions/prompt_josh_setup"
