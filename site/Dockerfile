# Verwende das Hugo-Image für den Build
FROM klakegg/hugo:ext-alpine AS hugo-build

# Arbeitsverzeichnis für Hugo
WORKDIR /src

# Klone das GitHub-Repository
ARG GIT_REPO_URL=https://github.com/judaicalink/judaicalink-site
ARG GIT_BRANCH=master
RUN git clone --branch $GIT_BRANCH $GIT_REPO_URL .

# Fetch the latest release tag and clone
#RUN LATEST_TAG=$(curl -s https://api.github.com/repos/GIT_REPO_URL/releases/latest | grep tag_name | cut -d '"' -f 4) && \
#    git clone --depth 1 --branch $LATEST_TAG https://github.com/GIT_REPO_URL.git . && \
#    echo "Cloned latest release: $LATEST_TAG"

# Kompiliere die Hugo-Website in das Verzeichnis "public"
RUN hugo

# NGINX-Image für die Auslieferung der statischen Dateien
FROM nginx:alpine

# Entferne den Standard-Inhalt von NGINX
RUN rm -rf /usr/share/nginx/html/*

# Kopiere die kompilierten Dateien von Hugo in das Standardverzeichnis von NGINX
COPY --from=hugo-build /src/public /usr/share/nginx/html

RUN mkdir -p /data/judaicalink/web.judaicalink.org/hugo/judaicalink-site/

# Copy the compiled files from Hugo to the data directory
COPY --from=hugo-build /src/ /data/judaicalink/web.judaicalink.org/hugo/judaicalink-site/

# Exponiere den Standardport von NGINX
EXPOSE 80
