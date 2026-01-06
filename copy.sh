cp -r ~/.config/hypr .
cp -r ~/.config/hpaper .
cp -r ~/.config/wofi .
cp -r ~/.config/dunst .
cp -r ~/.config/waybar .
cp -r ~/.config/tmux .
cp ~/.zshrc .

pacman -Qqen >pkglist-repo.txt
pacman -Qqem >pkglist-aur.txt
