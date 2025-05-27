# JudaicaLink Docker Image

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