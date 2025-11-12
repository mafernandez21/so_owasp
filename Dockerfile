FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    iproute2 \
    openssl \
    python3 \
    python3-pip \
    sqlite3 \
    && pip3 install bcrypt \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /lab

COPY lab /lab

CMD ["/bin/bash"]
