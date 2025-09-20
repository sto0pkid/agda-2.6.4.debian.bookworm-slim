# ---- Build stage ----
FROM debian:bookworm-slim AS build

# Install build dependencies
RUN apt-get update && apt-get install -y \
    ghc cabal-install git wget curl \
    build-essential zlib1g-dev libncurses-dev libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Agda
ARG AGDA_VER=2.6.4
WORKDIR /tmp

# fetch the source
RUN wget -qO- https://hackage.haskell.org/package/Agda-${AGDA_VER}/Agda-${AGDA_VER}.tar.gz | tar xz

WORKDIR /tmp/Agda-${AGDA_VER}

RUN mkdir -p /opt/agda/bin && \
    cabal update && \
    cabal v2-install exe:agda --installdir=/opt/agda/bin --overwrite-policy=always --install-method=copy && \
    strip /opt/agda/bin/*

# Copy Agda's data dir
RUN mkdir -p /opt/agda/data && \
    cp -r /root/.cabal/store/ghc-9.0.2/Agda-2.6.4*/share/lib \
          /opt/agda/data/lib/

# Install stdlib
ARG STDLIB_VER=1.7.2
RUN mkdir -p /opt/agda/lib && \
    wget -qO- "https://github.com/agda/agda-stdlib/archive/refs/tags/v${STDLIB_VER}.tar.gz" \
    | tar xz -C /opt/agda/lib && \
    mkdir -p /root/.agda && \
    echo "/opt/agda/lib/agda-stdlib-${STDLIB_VER}/standard-library.agda-lib" > /root/.agda/libraries && \
    echo "standard-library" > /root/.agda/defaults

# ---- Runtime stage ----
FROM debian:bookworm-slim AS final

RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

COPY --from=build /opt /opt
ENV PATH="/opt/agda/bin:$PATH"
ENV Agda_datadir=/opt/agda/data

# Workspace + entrypoint
COPY ./proofbounty/docker /work
WORKDIR /work
RUN mkdir /root/.agda \
    && echo "/opt/agda/lib/agda-stdlib-1.7.2/standard-library.agda-lib" > /root/.agda/libraries \
    && echo "standard-library" > /root/.agda/defaults
RUN chmod +x /work/check && mkdir -p /work/Input /output

ENTRYPOINT ["/work/check"]
