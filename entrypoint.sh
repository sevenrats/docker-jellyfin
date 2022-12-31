#!/usr/bin/env bash
set -ex
# Proxy signals
sp_processes=("jellyfin")
. /signalproxy.sh

# Overload Traps
  #none

# Configure Stuff
JELLYFINDIR="/opt/jellyfin"
FFMPEGDIR="/usr/share/jellyfin-ffmpeg"
DATADIR="/data/jellyfin"

  # support migration from lsio
if [ -d "/config" ]; then
  ln -sf /config/log $DATADIR/log
  ln -sf /config/cache $DATADIR/cache
  ln -sf /config/data $DATADIR/data
  find /config -maxdepth 1 -not \
    \( -wholename "/data" -o -wholename "/cache" -o -wholename "/log" -o -wholename "/config" \)\
    -exec ln -sf {} $DATADIR/config \;
fi

# Launch App
  $JELLYFINDIR/jellyfin/jellyfin \
  -d $DATADIR/data \
  -C $DATADIR/cache \
  -c $DATADIR/config \
  -l $DATADIR/log \
  --ffmpeg $FFMPEGDIR/ffmpeg & \
  wait -n