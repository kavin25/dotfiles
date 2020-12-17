# dotangad's (neo)vim

1. Clone this repo
```sh
mv $HOME/.config/nvim $HOME/.config/nvim.bak >> /dev/null
git clone https://github.com/dotangad/dotvim $HOME/.config/nvim
```

2. Install `vim-plug`
```sh
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
