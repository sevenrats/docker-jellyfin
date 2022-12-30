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

# Launch App
  $JELLYFINDIR/jellyfin/jellyfin \
  -d $DATADIR/data \
  -C $DATADIR/cache \
  -c $DATADIR/config \
  -l $DATADIR/log \
  --ffmpeg $FFMPEGDIR/ffmpeg & \
  wait -n