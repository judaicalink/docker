#!/bin/bash
# lolcat
apt -y update
apt-get -y install lolcat

#wget https://github.com/busyloop/lolcat/archive/master.zip
#unzip master.zip
#cd lolcat-master/bin || exit
#gem install lolcat
cd /app || exit

# powerline
pip install --user powerline-status
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir .local/share/fonts/
mkdir .config/fontconfig/conf.d/
mv PowerlineSymbols.otf ~/.local/share/fonts/
fc-cache -vf ~/.local/share/fonts/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
cd /app || exit

# Oh My Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
cd /app || exit

# Pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Vim airline
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline

# NERDTree
git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree


# Figlet
git clone https://github.com/xero/figlet-fonts.git
cp -R figlet-fonts/* /usr/share/figlet/

echo  -e "\033[0;34m" "
                      .(###(.
                     .(#####/
                      /##(##,
                    .#(.   .#(.
    .####(.        *#,       /#,         (###/.
    /################(((######################(
     .*/##.     *#,/###########,/#,     .###/.
         ,#/  .#(.##############(.#(.  (#.
          .(#/#,/#################,/#*#(
           .##/,###################.(#(
          *#* (#,################(,#( /#.
        .##.   ,#//#############,/#.   .#(
    .#####.     .(#./#########/.#(      .####,
    ##########################################,
     ./(*.         .(#.     .#(          *##/.
                     ,#/   /#,
                      ,#####.
                      (#####*
                       .(#/.                      "

figlet -l "JudaicaLink" -f 3d
echo "Welcome to JudaicaLink's download generator script!"
echo "(c) 2022 JudaicaLink"
echo "Benjamin Schnabel <schnabel@hdm-stuttgart.de>"

echo "----------------------------------------" | lolcat
read  -n 1 -s -r -p "Please enter to continue"
echo "creating directories..." | lolcat

mkdir /data/
mkdir /data/judaicalink/
mkdir /data/judaicalink/web.judaicalink.org/
mkdir /data/judaicalink/web.judaicalink.org/hugo/


chmod +x ./site/update.sh
chmod +x ./site/rebuild.sh
cp ./site/update.sh /data/judaicalink/web.judaicalink.org/
cp ./site/rebuild.sh /data/judaicalink/web.judaicalink.org/
echo "done."  | lolcat

echo "----------------------------------------" | lolcat
echo "downloading Judaicalink site..." | lolcat
cd /data/judaicalink/web.judaicalink.org/hugo/ || exit
git clone https://github.com/judaicalink/judaicalink-site.git
echo "done."  | lolcat

echo "----------------------------------------" #| lolcat
echo "updating and building..." | lolcat
cd /app  || exit
./update.sh
./rebuild.sh
echo "done."  | lolcat

echo "----------------------------------------" #| lolcat
echo "downloading generators..." | lolcat
cd /app || exit
git clone --branch master https://github.com/judaicalink/judaicalink-generators.git

echo "done."  | lolcat
exit 0