FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine as builder

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

RUN \
    arch=$(arch | awk -F'-' '{print $NF}') && \
    case "$arch" in \
        "x86_64" ) ARCH="x64";;\
        "aarch64") ARCH="arm64";;\
        "armv7l") ARCH="armhf";;\
        *) echo >&2 "$arch is not a support architecture"; exit 1 ;; \
    esac; \
    git clone https://github.com/jellyfin/jellyfin.git && \
    cd jellyfin && \
    dotnet publish Jellyfin.Server --configuration Release --self-contained --runtime linux-musl-$ARCH --output /output -p:DebugSymbols=false -p:DebugType=none -p:UseAppHost=true

FROM jellyfin/jellyfin as web
FROM alpine

RUN \
apk --no-cache add ffmpeg catatonit bash procps icu && \
apk --no-cache add --virtual .build-deps git && \
mkdir -p \
/opt/jellyfin /data/data data/cache data/config data/log && \
git clone --depth 1 https://github.com/sevenrats/bash-signal-proxy.git && \
mv bash-signal-proxy/signalproxy.sh / && \
apk del .build-deps && \
rm -rf \
    bash-signal-proxy \
    /tmp/* /var/cache \
    /opt/jellyfin/jellyfin_10.8.8_amd64-musl.tar.gz

COPY --from=builder /output /opt/jellyfin/jellyfin
COPY --from=web /jellyfin/jellyfin-web /opt/jellyfin/jellyfin/jellyfin-web
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["catatonit", "/entrypoint.sh"]
