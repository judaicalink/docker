# Use a lightweight base image
FROM alpine:latest

# Install wget to download data
RUN apk add --no-cache wget

# Create the /data/cm directory structure
RUN mkdir -p /data/cm/txt /data/cm/cm /data/cm/metadata

# Set working directory
WORKDIR /data/cm

# Define environment variables for the download URLs
#ENV URL_TXT=https://web.judaicalink.org/fulltexts/txt/
#ENV URL_CM=https://web.judaicalink.org/fulltexts/cm/
ENV URL_METADATA=https://web.judaicalink.org/fulltexts/metadata/

# Download data into respective folders using wget
# The -q flag suppresses non-error output, -c continues partially downloaded files
# --show-progress gives a progress bar for visibility
CMD wget -q --show-progress -r -np -nH -P metadata $URL_METADATA
    #wget -q --show-progress -r -np -nH -P txt $URL_TXT && \
    #wget -q --show-progress -r -np -nH -P cm $URL_CM && \

