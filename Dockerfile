ARG CUDA_VERSION=12.5.0
ARG UBUNTU_VERSION=22.04
FROM docker.io/nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_VERSION}

ARG DOCKER_CE_VERSION=26.0

RUN apt-get update -q && \
    apt-get install -yq \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && \
    curl -fsSL https://get.docker.com -o /tmp/docker-install.sh && \
    chmod +x /tmp/docker-install.sh && \
    /tmp/docker-install.sh --version ${DOCKER_CE_VERSION} && \
    rm /tmp/docker-install.sh

RUN apt-get install -yq \
    btrfs-progs \
    e2fsprogs \
    fuse-overlayfs \
    git \
    iptables \
    openssl \
    pigz \
    wget \
    xfsprogs \
    xz-utils \
    zfsutils-linux

RUN set -x \
    && addgroup --system dockremap \
    && adduser --system -ingroup dockremap dockremap \
    && echo 'dockremap:165536:65536' >> /etc/subuid \
    && echo 'dockremap:165536:65536' >> /etc/subgid

ARG DIND_VERSION=v27.0.1

RUN set -eux; \
    wget -O /usr/local/bin/dind "https://raw.githubusercontent.com/moby/moby/${DIND_VERSION}/hack/dind"; \
    chmod +x /usr/local/bin/dind

RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list && \
    apt-get update -q && \
    apt-get install -yq nvidia-container-toolkit && \
    nvidia-ctk runtime configure --runtime=docker

## USEFUL TOOLS
RUN apt-get install -yq \
    iproute2 \
    iputils-ping \
    tmux \
    nano \
    vim

ENTRYPOINT [ "dind", "dockerd", "--host=unix:///var/run/docker.sock"]
