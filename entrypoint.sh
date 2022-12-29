#!/usr/bin/env bash
echo "I'm about to call the signalproxy"
# Proxy signals
sp_processes=("jellyfin")
. ./signalproxy.sh

# Overload Traps
  #none

# Launch App

  JELLYFINDIR="/opt/jellyfin"
  FFMPEGDIR="/usr/share/jellyfin-ffmpeg"
  $JELLYFINDIR/jellyfin/jellyfin \
  -d $JELLYFINDIR/data \
  -C $JELLYFINDIR/cache \
  -c $JELLYFINDIR/config \
  -l $JELLYFINDIR/log \
  --ffmpeg $FFMPEGDIR/ffmpeg & \
  wait -n