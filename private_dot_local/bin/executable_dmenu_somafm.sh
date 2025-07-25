#!/usr/bin/env bash
set -e

# Fetch and process the channel data from SomaFM
get_channels() {
  curl -s https://somafm.com/channels.json
}

# Present the channel titles to the user via dmenu
choose_channel() {
  jq -r '.channels[] | .title'
}

# Get the stream URL for the selected channel
get_stream_url() {
  local selected_channel="$1"
  jq -r --arg channel_title "$selected_channel" '.channels[] | select(.title == $channel_title) | .playlists[] | select((.format == "aac" or .format == "aacp") and .quality == "highest") | .url'
}

# Main execution
channels_json=$(get_channels)
selected=$(echo "$channels_json" | choose_channel | walker -d -f -k -p "SomaFM Channels: 2>/dev/null")

if [ -n "$selected" ]; then
  stream_url=$(echo "$channels_json" | get_stream_url "$selected")
  mpv "$stream_url"
fi
