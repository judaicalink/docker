# Use a lightweight base image with Git and Bash
FROM alpine:latest

# Install Git and Bash
RUN apk add --no-cache git bash

# Set working directory
WORKDIR /app

# Define build arguments for the GitHub repository URL and branch
ARG GIT_REPO_URL
ARG GIT_BRANCH

# Clone the specified branch of the repository
RUN git config --global http.postBuffer 524288000 && \
    git config --global core.compression 0 && \
    git clone -b $GIT_BRANCH $GIT_REPO_URL /app/

# Make all bash scripts executable
RUN chmod +x *.sh
#
# Set the default command to bash, allowing you to run scripts interactively
CMD ["/bin/bash"]
