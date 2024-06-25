# **`nv-dind`**

Run nested docker containers (containers that run inside a docker-in-docker
container) with access to the NVIDIA GPUs of the host system.

---

This docker image is based on the [NVIDIA
CUDA](https://hub.docker.com/r/nvidia/cuda) image, but installs docker and its
required runtime deps too. This can be run easilily with docker, assuming you
already have the [container
toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
installed and setup on the docker engine host.

To run the image, the following command can be run:
```
docker run --rm -it --privileged --gpus all \
  --name nvdind ghcr.io/willfantom/nv-dind:<TAG>
```

## Tags

Tags can be found in the relevant GitHub Package for this project and a named by
the Docker version and CUDA version used for the image. For example, if using
Docker `v26.0` and CUDA `12.5.0`, the tag would be `v26.0-12.5.0`.
