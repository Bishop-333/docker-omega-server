# Build the game in a base container
FROM debian:stable-slim AS builder

ADD ./omega-engine /omega-engine
WORKDIR /omega-engine
RUN apt-get update && apt-get install -y make gcc git
RUN git clone --recurse-submodules https://github.com/Bishop-333/OmegA-engine .
RUN apt-get install -y debhelper pkgconf libgl-dev libvulkan-dev \
    libcurl4-openssl-dev libjpeg-dev libopenal-dev libsdl3-dev \
    libogg-dev libvorbis-dev libmad0-dev libflac-dev zlib1g-dev
RUN chmod +x debian/rules && dpkg-buildpackage -b -us -uc

# Copy the game files from the builder container to a new image to minimise size
FROM debian:stable-slim AS omgded

COPY --from=builder /*.deb /tmp/
RUN apt-get update && apt-get install -y /tmp/omega-engine_*.deb && rm -rf /tmp/*.deb /var/lib/apt/lists/*

RUN useradd -m omgded
ADD --chown=omgded files/ /opt/openarena/

USER omgded
EXPOSE 27960/udp
CMD ["/opt/openarena/entrypoint.sh"]
