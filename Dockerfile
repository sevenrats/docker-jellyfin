FROM alpine

RUN \
apk --no-cache add ffmpeg catatonit bash procps icu && \
apk --no-cache --virtual add wget tar && \
mkdir -p /opt/jellyfin && \
cd /opt/jellyfin && \
wget https://repo.jellyfin.org/releases/server/linux/stable/combined/jellyfin_10.8.8_amd64-musl.tar.gz && \
tar -xvzf jellyfin_10.8.8_amd64-musl.tar.gz && \
ln -s jellyfin_10.8.8 jellyfin && \
mkdir data cache config log && \
cd / && \
wget https://raw.githubusercontent.com/sevenrats/signalproxy.sh/main/signalproxy.sh && \
rm -rf \
    /tmp/* \
    /opt/jellyfin/jellyfin_10.8.8_amd64-musl.tar.gz

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["catatonit", "/entrypoint.sh"]
