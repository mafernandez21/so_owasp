# Imagen del laboratorio OWASP Top 10:2025 - Sistemas Operativos (FACET - UNT)
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apache2 \
    ca-certificates \
    curl \
    gnupg \
    iproute2 \
    less \
    nano \
    openssl \
    procps \
    python3 \
    python3-bcrypt \
    sqlite3 \
    tcpdump \
    && rm -rf /var/lib/apt/lists/*

# Usuarios sin privilegios para los ejercicios de permisos (A06, A07, A10)
RUN useradd -m -s /bin/bash alumno \
    && useradd -m -s /bin/bash docente

WORKDIR /lab

COPY lab /lab

CMD ["/bin/bash"]
