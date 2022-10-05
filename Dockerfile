FROM ubuntu:latest

LABEL maintainer="JudaicaLink | Benjamin Schnabel <schnabel@hdm-stuttgart.de>"

RUN apt-get -y update && apt-get -y upgrade && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-setuptools \
    python3-venv \
    python3-wheel \
    git \
    nodejs \
    npm \
    hugo \
    yarn \
    figlet \
    ruby \
    curl \
    vim \
    tmux \
    wget \
    #fuseki \
    #elasticsearch \
    #kibana \
    nginx \
    rsync \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ADD installer.sh ./
COPY site/* ./site/

# Vim
COPY /conf/vim/.vimrc /app/.vimrc

# Bash
COPY /conf/bash/.bashrc /app/.bashrc

# NGINX
COPY nginx/* /etc/nginx/
COPY nginx/sites-available/* /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/judaicalink.conf /etc/nginx/sites-enabled/judaicalink
RUN rm /etc/nginx/sites-enabled/default

COPY . .

ENV PORT_APACHE=80
ENV PORT_SSL=443
ENV PORT_HUGO=443

EXPOSE 80
EXPOSE 443
EXPOSE 1313

CMD [ "nginx", "-g", "daemon off;" ]
RUN bash -c "./installer.sh"
