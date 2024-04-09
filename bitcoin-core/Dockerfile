# Minimal alpine bitcoin-core image based on  https://bitcoincore.org/en/download/ verification instruction 
ARG BITCOIN_CORE_VERSION=26.1

## download and verify image 
## see https://bitcoincore.org/en/download/ > 'Linux verification instructions'
FROM debian:stable-slim as downloadverify
ARG BITCOIN_CORE_VERSION
RUN apt update 
RUN apt install -y wget git gpg
# download release
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CORE_VERSION}/bitcoin-${BITCOIN_CORE_VERSION}-x86_64-linux-gnu.tar.gz
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CORE_VERSION}/SHA256SUMS
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CORE_VERSION}/SHA256SUMS.asc
RUN sha256sum --ignore-missing --check SHA256SUMS
RUN git clone https://github.com/bitcoin-core/guix.sigs
# verify
RUN gpg --import guix.sigs/builder-keys/*
RUN gpg --verify SHA256SUMS.asc
RUN tar -xvzf bitcoin-${BITCOIN_CORE_VERSION}-x86_64-linux-gnu.tar.gz

# https://bitcoin.org/en/full-node#linux-instructions
FROM debian:stable-slim  as final
ARG BITCOIN_CORE_VERSION
ARG USER=bitcoind
ARG DIR=/data
COPY  --from=downloadverify /bitcoin-${BITCOIN_CORE_VERSION}/bin /usr/local/bin
COPY  --from=downloadverify /bitcoin-${BITCOIN_CORE_VERSION}/share /usr/local/share
COPY  --from=downloadverify /bitcoin-${BITCOIN_CORE_VERSION}/lib /usr/local/lib
COPY  --from=downloadverify /bitcoin-${BITCOIN_CORE_VERSION}/bitcoin.conf /etc/bitcoin.conf
# https://github.com/bitcoin/bitcoin/blob/master/doc/dependencies.md
RUN apt update 
RUN apt install -y libboost-dev dlang-libevent libc6 libnatpmp-dev

# NOTE: Default GID == UID == 1000
RUN adduser --disabled-password \
            --home "$DIR/" \
            --gecos "" \
            "$USER"

USER $USER

# Prevents `VOLUME $DIR/.bitcoind/` being created as owned by `root`
RUN mkdir -p "$DIR/.bitcoin/"

# Expose volume containing all `bitcoind` data
VOLUME $DIR/.bitcoin/

# REST interface
EXPOSE 8080

# P2P network (mainnet, testnet & regnet respectively)
EXPOSE 8333 18333 18444

# RPC interface (mainnet, testnet & regnet respectively)
EXPOSE 8332 18332 18443

# ZMQ ports (for transactions & blocks respectively)
EXPOSE 28332 28333

ENTRYPOINT ["/usr/local/bin/bitcoind"]

CMD ["-zmqpubrawblock=tcp://0.0.0.0:28332", "-zmqpubrawtx=tcp://0.0.0.0:28333"]
