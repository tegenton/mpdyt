#!/bin/sh

function parseUrl() {
	case "$1" in
		*youtube.com/watch*) echo try again with playlist url ;;
		*youtube.com/playlist*)
			youtube-dl --download-archive ~/Music/downloads.txt --add-metadata -x --audio-format flac -o '~/Music/%(uploader)s/%(playlist_title)s/%(playlist_index)d - %(title)s.%(ext)s' $url ;;
		*.bandcamp.com/) wget -q -O - "$url" | grep -o -P "/album/\K[^\"]+" | while read album ; do youtube-dl --download-archive ~/Music/downloads.txt --add-metadata -x --audio-format flac -o "~/Music/%(uploader)s/%(playlist_title)s/%(playlist_index)d - %(title)s.%(ext)s" "${url}/album/${album}"; done;;
		*) echo "invalid url" ;;
	esac
}

OPTIONS=a:u:
LONGOPTS=artist:,url:

case $# in
0)
	url=$(xclip -o)
	parseUrl "$url"
	;;
*)
	echo 'bad args message'
	;;
esac
