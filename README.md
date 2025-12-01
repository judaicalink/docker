# JudaicaLink Docker Image

[![Open Source? Yes!](https://badgen.net/badge/Open%20Source%20%3F/Yes%21/blue?icon=github)](https://github.com/Naereen/badges/)
![license](https://badgen.net/badge/license/MIT/blue)
![Maintenance](https://img.shields.io/maintenance/yes/2025)

[![made-with-Markdown](https://img.shields.io/badge/Made%20with-Markdown-1f425f.svg)](http://commonmark.org)

![github](https://badgen.net/badge/icon/github?icon=github&label)
![release](https://badgen.net/github/release/judaicalink/docker?color=green)
![releases](https://badgen.net/github/releases/judaicalink/docker)
![stars](https://badgen.net/github/stars/judaicalink/docker)![forks](https://badgen.net/github/forks/judaicalink/docker)
![issues](https://badgen.net/github/issues/judaicalink/docker)
![commits](https://badgen.net/github/commits/judaicalink/docker)
![last-commit](https://badgen.net/github/last-commit/judaicalink/docker)
![branches](https://badgen.net/github/branches/judaicalink/docker)
![contributors](https://badgen.net/github/contributors/judaicalink/docker)

![wiki](https://badgen.net/badge/icon/wiki?icon=wiki&label)
[![Documentation Status](https://readthedocs.org/projects/judaicalink-docs/badge/?version=latest)](http://judaicalink-docs.readthedocs.io/?badge=latest)

![discord](https://badgen.net/badge/icon/discord?icon=discord&label)
![Discord](https://img.shields.io/discord/696646598868074576)



This is the Docker image for the JudaicaLink application.
it generates a complete JudaicaLink application.

# How to use

Clone the repository:

    git clone -b master https://github.com/judaicalink/docker.git

Run the following command:

    docker-compose build && docker-compose up -d

This will build the image and start the containers in detached mode.

To run the containers in the foreground, use:

    docker-compose up


# How to configure

# How to use
## Terminal

1. Activate the virtual environment

Using the venv `source /data/judaicalink/venv/bin/activate`.

2. Start labs server `service labs start`.
3. Start pubby server `service pubby start`.
4. Run the loader script `python /data/judaicalink/judaicalink/loader.py`.
This loads all the triples into the triple store (Fuseki).

## Access from the browser
### Web
In you browser go to 'http://localhost'

### Labs

### Pubby 

### Solr


### Fuseki
Fuseki uses a User Interface. Navigate to `http://localhost:3030`. The port may differ if you have changed it in the `docker-compose.yml` file.

### The JudaicaLink site

### JudaicaLink labs



# Components
* Fuseki
* Solr
* NGINX
* Redis
* Daphne
* Guincorn
* Hugo
* Python Django
