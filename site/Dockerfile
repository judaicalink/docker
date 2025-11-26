# Verwende das Hugo-Image für den Build
FROM klakegg/hugo:ext-alpine AS hugo-build

# Arbeitsverzeichnis für Hugo
WORKDIR /app

# Klone das GitHub-Repository
ARG GIT_REPO_URL=https://github.com/judaicalink/judaicalink-site
ARG GIT_BRANCH=master
RUN git clone --branch $GIT_BRANCH $GIT_REPO_URL .

# Fetch the latest release tag and clone
#RUN LATEST_TAG=$(curl -s https://api.github.com/repos/GIT_REPO_URL/releases/latest | grep tag_name | cut -d '"' -f 4) && \
#    git clone --depth 1 --branch $LATEST_TAG https://github.com/GIT_REPO_URL.git . && \
#    echo "Cloned latest release: $LATEST_TAG"

# Copy Hugo site
COPY . .

COPY run.sh /app/run.sh

# Make script executable
RUN chmod +x run.sh

ENTRYPOINT []

# Run custom script
CMD ["/app/run.sh"]