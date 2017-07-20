#!/bin/bash
#===============================================================================
# DESCRIPTION: Convert MKV files to AVI. Define your directory with MKV files
# AUTHOR: Armando Uch, jahrmando@gmail.com
#	REQUIREMENTS: mencoder
#===============================================================================

usage() {
  echo "Usage: $0 /my/directory/"
}


convert() {
	## Remove spaces in the name's file
	while [[ true ]]; do
		rename ' ' '_' *.mkv
		if [[ ! $? -eq '0' ]]; then
			break
		fi
	done
	for video_mkv in $(ls); do
		echo $video_mkv
		mencoder $video_mkv -ovc xvid -oac mp3lame -oac mp3lame -lameopts abr:br=192 -xvidencopts pass=2:bitrate=-700000 -o "$video_mkv.avi" && \
		mv $video_mkv videos_temp/ && echo "Done!"
	done
	mv videos_temp/* . && rm -rf videos_temp/
	rename '.mkv.' '.' *.avi
}

if [[ -n $1 ]]; then
	cd $1 && mkdir videos_temp && convert
else
	usage
fi
