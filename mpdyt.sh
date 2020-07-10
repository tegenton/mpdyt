#!/bin/sh

function parseUrl() {
	outputFormat="~/Music/${artist:-%(uploader)s}/%(playlist_title)s/%(playlist_index)d - %(title)s.%(ext)s"
	case "$1" in
		*youtube.com/watch*) echo try again with playlist url ;;
		*youtube.com/playlist*)
			youtube-dl --download-archive ~/Music/downloads.txt --add-metadata -x --audio-format flac -o "$outputFormat" "$1" ;;
		*.bandcamp.com/) wget -q -O - "$url" | grep -o -P "/album/\K[^\"]+" | while read album ; do youtube-dl --download-archive ~/Music/downloads.txt --add-metadata -x --audio-format flac -o "$outputFormat" "${1}/album/${album}"; done;;
		*) echo "invalid url" ; return 1 ;;
	esac
}

OPTIONS=a:u:
LONGOPTS=artist:,urls:

PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")

eval set -- "$PARSED"

while true; do
	case $1 in
		-a|--artist)
			artist="$2"
			shift 2
			;;
		-u|--urls)
			urlfile="$2"
			shift 2
			;;
		--)
			shift
			break
			;;
		*)
			echo 'bad args message'
			;;
	esac
done

[ "${urlfile:-w}" != "w" -o -t 0 -o "$url" = "-" ] || { while read line; do
	[ ${line:-w} = "w" ]
	parseUrl "$line"
done < "${urlfile:-/dev/stdin}"; exit; }

[ $# -eq 1 ] && url="$1"

[ "${url:-w}" = "w" ] && { parseUrl "$(xclip -o)"; exit; } || { parseUrl "$url"; exit; }
