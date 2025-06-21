# dotfiles

Setup
```
git clone https://github.com/yadm-dev/yadm.git ~/.yadm-project
mkdir -p ${HOME}/bin
ln -s ~/.yadm-project/yadm ~/bin/yadm


# Make sure ${HOME}/bin is in our path
export PATH="${HOME}/bin:$(echo $PATH | sed "s|${HOME}/bin:||g" | sed "s|:${HOME}/bin||g")"

yadm clone https://github.com/honeycut1/dotfiles.git
```

