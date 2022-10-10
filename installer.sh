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

echo "----------------------------------------" #| lolcat
echo "downloading Judaicalink site..." #| lolcat
cd /data/judaicalink/web.judaicalink.org/hugo/ || exit
git clone https://github.com/judaicalink/judaicalink-site.git
echo "done."  #| lolcat

echo "----------------------------------------" #| lolcat
echo "updating and building..." #| lolcat
cd /data/judaicalink/web.judaicalink.org/  || exit
./update.sh
./rebuild.sh
echo "done."  | lolcat

echo "----------------------------------------" #| lolcat
echo "downloading generators..." #| lolcat
cd /data/judaicalink || exit
git clone --branch master https://github.com/judaicalink/judaicalink-generators.git

# Pubby
echo "----------------------------------------" #| lolcat
echo "downloading Pubby..." #| lolcat
cd /data/judaicalink || exit
git clone https://github.com/lod-pubby/pubby-django.git

# Setup
echo "----------------------------------------" #| lolcat
echo "setting up Pubby..." #| lolcat
cd /app || exit
cp pubby/runserver.sh /data/judaicalink/pubby-django/
cp pubby/update.sh /data/judaicalink/pubby-django/update.sh
touch /data/judaicalink/pubby-django/update.log

# create venv
python3 -m venv /data/judaicalink/venv
source /data/judaicalink/pubby-venv/bin/activate
ls -s /data/judaicalink/pubby-venv/bin/activate /data/judaicalink/pubby-django/activate
cd /data/judaicalink/pubby-django || exit
# install requirements
cp /app/pubby/requirements.txt /data/judaicalink/pubby-django/
pip install gunicorn
pip install django
pip install rdflib
pip install sparqlwrapper
pip install regex
pip install git+https://github.com/FlorianRupp/django-webhook-consume.git
pip install environ
pip install django-environ
#pip install -r requirements.txt

cd /data/judaicalink/pubby-django || exit
./update.sh
cp /app/pubby/pubby.service /etc/systemd/system/
systemctl daemon-reload
systemctl start pubby.service

# loader
cd /app || exit
echo "----------------------------------------" #| lolcat
echo "downloading loader..." #| lolcat
cd /data/judaicalink || exit
git clone -b master https://github.com/judaicalink/judaicalink-loader.git

# Labs
echo "----------------------------------------" #| lolcat
echo "downloading Labs..." #| lolcat
cd /data/judaicalink || exit
git clone --branch deployment https://github.com/wisslab/judaicalink-labs.git
cd /data/judaicalink/judaicalink-labs || exit
pip install -r requirements.txt --user
cp labs/settings_dev.py /data/judaicalink/judaicalink-labs/labs/settings.py
cd /data/judaicalink/judaicalink-labs/labs/ || exit
python3 manage.py migrate --noinput
python3 manage.py collectstatic --noinput
python3 manage.py createsuperuser --noinput --username admin --email admin@admin.com --password admin
python3 manage.py runserver # change to service

# Fix services pubby and labs

echo "done."  #| lolcat
exit 0