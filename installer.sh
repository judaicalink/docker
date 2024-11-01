#!/bin/bash
# lolcat
apt -y update
apt-get -y install lolcat

ln -s /usr/games/lolcat /usr/bin/
cd /app || exit

# powerline
pip install --user powerline-status
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir .local/
mkdir .local/share/
mkdir .local/share/fonts/
mkdir .config/
mkdir .config/fontconfig/
mkdir .config/fontconfig/conf.d/
mv PowerlineSymbols.otf .local/share/fonts/
fc-cache -vf .local/share/fonts/
mv 10-powerline-symbols.conf .config/fontconfig/conf.d/
cd /app || exit

# Oh My Bash
#bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

cd /app || exit

# Pathogen
mkdir -p .vim/autoload .vim/bundle && \
curl -LSso .vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Vim airline
git clone https://github.com/vim-airline/vim-airline .vim/bundle/vim-airline

# NERDTree
git clone https://github.com/preservim/nerdtree.git .vim/bundle/nerdtree


# Figlet
git clone https://github.com/xero/figlet-fonts.git
cp -R figlet-fonts/* /usr/share/figlet/

colorred="\033[31m"
colorpowder_blue="\033[1;36m" #with bold
colorblue="\033[34m"
colornormal="\033[0m"
colorwhite="\033[97m"
colorlightgrey="\033[90m"

printf "                   ${colorred} ##       ${colorlightgrey} .         \n"
printf "             ${colorred} ## ## ##      ${colorlightgrey} ==         \n"
printf "           ${colorred}## ## ## ##      ${colorlightgrey}===         \n"
printf "       /\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\\\___/ ===       \n"
printf "  ${colorblue}~~~ ${colorlightgrey}{${colorblue}~~ ~~~~ ~~~ ~~~~ ~~ ~ ${colorlightgrey}/  ===- ${colorblue}~~~${colorlightgrey}\n"
printf "       \\\______${colorwhite} o ${colorlightgrey}         __/           \n"
printf "         \\\    \\\        __/            \n"
printf "          \\\____\\\______/               \n"
printf "${colorpowder_blue}                                          \n"
printf "          |          |                    \n"
printf "       __ |  __   __ | _  __   _          \n"
printf "      /  \\\| /  \\\ /   |/  / _\\\ |     \n"
printf "      \\\__/| \\\__/ \\\__ |\\\_ \\\__  | \n"
printf " ${colornormal}                                         \n"


echo  -e "\033[0;34m" "
                      .(###(.
                     .(#####/
                      /##(##,
                    .#(.   .#(.
    .####(.        *#,       /#,         (###/.
    /########################################(
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
                       .(#/.                      " | lolcat

printf " ${colornormal}                                         \n"

figlet -l "JudaicaLink" -f slant -w 200 | lolcat
echo "Welcome to JudaicaLink's download generator script!" | lolcat
echo "(c) 2022 JudaicaLink" | lolcat
echo "Benjamin Schnabel <schnabel@hdm-stuttgart.de>" | lolcat
echo "----------------------------------------"  | lolcat
echo "creating directories..."  | lolcat

alias python='/usr/bin/python3'

mkdir /data/
mkdir /data/judaicalink/
mkdir /data/judaicalink/web.judaicalink.org/
mkdir /data/judaicalink/web.judaicalink.org/hugo/


chmod +x ./site/update.sh
chmod +x ./site/rebuild.sh
cp ./site/update.sh /data/judaicalink/web.judaicalink.org/
cp ./site/rebuild.sh /data/judaicalink/web.judaicalink.org/
echo "done."   | lolcat

echo "----------------------------------------" | lolcat
echo "downloading Judaicalink site..." | lolcat
cd /data/judaicalink/web.judaicalink.org/hugo/ || exit
git clone https://github.com/judaicalink/judaicalink-site.git
latesttag=$(git describe --tags)
echo checking out ${latesttag}
git checkout ${latesttag}
echo "done."  #| lolcat

echo "----------------------------------------" | lolcat
echo "updating and building..." | lolcat
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
touch /var/log/pubby.log
touch /data/judaicalink/pubby-django/update.log

# create venv
python3 -m venv /data/judaicalink/venv
source /data/judaicalink/venv/bin/activate
# install requirements
#cp /app/pubby/requirements.txt /data/judaicalink/pubby-django/
pip install -r /app/requirements.txt

cd /data/judaicalink/pubby-django || exit
./update.sh
cp /app/pubby/pubby.service /etc/systemd/system/
#Fixme: systemctl daemon-reload
#Fixme: systemctl start pubby.service
#./runserver.sh start &

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
cp /app/labs/sample.env /data/judaicalink/judaicalink-labs/labs/.env
cp /app/labs/runserver.sh /data/judaicalink/judaicalink-labs/
cp /app/labs/update.sh /data/judaicalink/judaicalink-labs/
mkdir /var/log/daphne/
touch /var/log/daphne/daphne.log

cd /data/judaicalink/judaicalink-labs/labs/ || exit
python3 manage.py migrate --noinput
python3 manage.py collectstatic --noinput
python3 manage.py createsuperuser --noinput --username admin --email admin@admin.com

# Ontology
cd /data/judaicalink || exit
git clone https://github.com/judaicalink/judaicalink-ontology.git


# Discord update bot
cd /data/judaicalink || exit
git clone https://github.com/FlorianRupp/discord-update-bot.git
pip install discord

# Fuseki
echo "----------------------------------------" #| lolcat
echo "downloading Fuseki..." #| lolcat
cd /app || exit
wget https://dlcdn.apache.org/jena/binaries/apache-jena-fuseki-4.6.1.tar.gz
tar -xvzf apache-jena-fuseki-4.6.1.tar.gz
FUSEKI_HOME="/usr/share/fuseki"
FUSEKI_BASE="/etc/fuseki"
mkdir -p $FUSEKI_HOME
mkdir -p $FUSEKI_BASE
mkdir /data/fuseki/
mkdir /data/fuseki/databases/
mkdir /data/fuseki/databases/judaicalink/
cp -r apache-jena-fuseki-4.6.1/* $FUSEKI_HOME
cp -r ./fuseki/* $FUSEKI_BASE
cp /app/apache-jena-fuseki-4.6.1/fuseki.service /etc/systemd/system/
useradd fuseki
chown -R fuseki:fuseki $FUSEKI_BASE
chown -R fuseki:fuseki $FUSEKI_HOME
ln -s /etc/fuseki/databases /data/fuseki/databases
chmod -R 755 $FUSEKI_BASE
#systemctl daemon-reload

# Solr
echo "----------------------------------------" #| lolcat
echo "downloading Solr..." #| lolcat
cd /app || exit


# Generators
source /data/judaicalink/venv/bin/activate
mkdir /data/judaicalink/dumps/
mkdir /data/judaicalink/dumps/gba/
mkdir /data/judaicalink/dumps/gba/current/
cd /data/judaicalink/judaicalink-generators/gidal/scripts/ || exit
python3 generator.py

# download all data from the server
mkdir /data/judaicalink/dumps/
wget -r -np -R "index.html*" https://data.judaicalink.org/dumps/
cp -r data.judaicalink.org/dumps/* /data/judaicalink/dumps/


echo "done."  #| lolcat
exit 0