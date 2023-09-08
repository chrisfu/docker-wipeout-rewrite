# wipEout Rewrite... in Docker

This is a Docker packaged version of the [PhobosLab](https://github.com/phoboslab/wipeout-rewrite) re-implementation of the the 1995 PSX game wipEout.

What you find here will enable you to self-host what you can find at https://phoboslab.org/wipegame/ within Docker.

## Building the Docker image

The provided Dockerfile is multi-stage:

1. The build stage is based upon `debian:bookworm` and stashes all output WASM material, oven-ready within `/output`.
2. The final stage is based upon the official Nginx releases (specifically `nginx:mainline-alpine-slim`) and does little to modify that images original behavior. `/output` is copied to `/usr/share/nginx/html`, and we're done!

To build, simply run:

```sh
# Simple single-platform build
docker build -t docker-wipeout-rewrite:latest .
# ...or for a multi-platform build
docker buildx build --platform=linux/amd64,linux/arm64 -t docker-wipeout-rewrite:latest .
```

## Running the Docker image

```sh
# Run a new container called "wipeout" based on the image we just built
docker run -d -p 8080:80 --name wipeout docker-wipeout-rewrite:latest
# Visit http://localhost:8080 and give it a spin
# Stop and delete the container when you're finished with it
docker stop wipeout && docker rm wipeout
```

## TODO

* ~~Add a Kubernetes Helm Chart~~ **DONE** Please see [here](https://artifacthub.io/packages/helm/chrisfu/wipeout-rewrite). 

# License

None. This is continuing in the spirit of [PhobosLab](https://github.com/phoboslab/wipeout-rewrite)'s stance on not slapping a license on what once was a copyrighted product. Please see https://github.com/phoboslab/wipeout-rewrite/blob/master/README.md for more.