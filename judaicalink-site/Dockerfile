# Verwende das Hugo-Image für den Build
FROM klakegg/hugo:ext-alpine AS hugo-build

# Arbeitsverzeichnis für Hugo
WORKDIR /src

# Klone das GitHub-Repository
ARG GIT_REPO_URL
ARG GIT_BRANCH=main
RUN git clone --branch $GIT_BRANCH $GIT_REPO_URL .

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
