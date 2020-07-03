#!/bin/sh

case $# in
0)
	url=$(xclip -o)
	case "$url" in
		*youtube.com/watch*) echo try again with playlist url ;;
		*youtube.com/playlist*)
			youtube-dl --download-archive ~/Music/downloads.txt --add-metadata -x --audio-format flac -o '~/Music/%(uploader)s/%(playlist_title)s/%(playlist_index)d - %(title)s.%(ext)s' $url ;;
		*.bandcamp.com/) wget -q -O - "$url" | grep -o -P "/album/\K[^\"]+" | while read album ; do youtube-dl --download-archive ~/Music/downloads.txt --add-metadata -x --audio-format flac -o "~/Music/%(uploader)s/%(playlist_title)s/%(playlist_index)d - %(title)s.%(ext)s" "${url}/album/${album}"; done;;
		*) echo "no valid url in clipboard" ;;
	esac
	;;
*)
	echo 'bad args message'
	;;
esac
