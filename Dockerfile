FROM debian:bookworm as build
LABEL org.opencontainers.image.authors="chris@hardc0re.org.uk"
LABEL org.opencontainers.image.version="05e9c2d"

ARG DEBIAN_FRONTEND=noninteractive
ARG BINARY_ARTIFACTS=https://phoboslab.org/files/wipeout-data-v01.zip

ENV BUILD_OUTPUT_PATH /output

RUN mkdir /output

RUN apt update && apt install -y \
    git \
    make \
    libx11-dev \
    libxcursor-dev \
    libxi-dev \
    libasound2-dev \
	ca-certificates \
	unzip \
	sed \
	p7zip-full \
    emscripten \
	coffeescript \
	xz-utils \
	wget \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# Git clone HEAD
RUN cd / \
    && git clone https://github.com/phoboslab/wipeout-rewrite.git \
    && cd wipeout-rewrite

# Copy the Wipeout binary artifacts into the build directory
RUN cd /tmp \
    && wget $BINARY_ARTIFACTS \
    && unzip wipeout*.zip -d wipeout \
    && cp -r wipeout/* /wipeout-rewrite

# Build the WASM code
RUN cd wipeout-rewrite \
    && make wasm

# Arrange build outputs into /output directory
RUN cp /wipeout-rewrite/build/wasm/* /output \
    && cp /wipeout-rewrite/src/wasm-index.html /output/index.html \
    && cp -r /wipeout-rewrite/wipeout /output

FROM nginx:mainline-alpine-slim
LABEL org.opencontainers.image.authors="chris@hardc0re.org.uk"
COPY --from=build /output /usr/share/nginx/html

ENV ROOT_WWW_PATH /usr/share/nginx/html

WORKDIR ${ROOT_WWW_PATH}

