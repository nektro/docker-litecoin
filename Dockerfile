ARG version=0.18.1
ARG file=litecoin-${version}-x86_64-linux-gnu.tar.gz
ARG folder=litecoin-${version}

FROM debian:stable as stage1
ARG version
ARG file
ARG folder
WORKDIR /the/workdir
RUN apt update
RUN apt install -y wget
RUN wget https://download.litecoin.org/${folder}/linux/${file}
RUN tar -vxf ${file}
RUN chmod +x /the/workdir/${folder}/bin/litecoind

FROM photon
ARG folder
COPY --from=stage1 /the/workdir/${folder}/bin/litecoind /app/litecoind
VOLUME /data
EXPOSE 9332
ENTRYPOINT [ "/app/litecoind", "-datadir=/data", "-server", "-rpcport=9332", "-rpcuser=litecoin", "-rpcpassword=password" ]
