#!/bin/bash
#set -x

# Test and assign some required variables for rtsp-to-jpegs
_imagePath=0
_rtspPath=0
while [ -n "$1" ]; do # while loop starts
	case "$1" in
	--imagepath)
		shift
		echo "--imagepath of $1 was passed..."
		_imagePath=$1
		;;
	--rtsppath)
		shift
		echo "--rtsppath of $1 was passed..."
		_rtspPath=$1
		;;
	--usage)
		echo
		echo "######################################### Required parameters #########################################"
		echo "  --imagepath       - path to store images"
		echo "  --rtsppath        - path of the rtsp stream in the form rtsp://username:password@ipaddress/blah/blah/"
		echo
		exit 0
		;;
	*) echo "Option $1 not recognized" ;; # In case you typed a different option other than a,b,c
	esac
	shift
done

if [ ${_imagePath} != "0" ] && [ ${_rtspPath} != "0" ]; then
	echo "I: All parameters were passed!"
	# Assume the camera number the last octect of the ipv4 address
	_cameraNum=$(echo ${_rtspPath} |sed -n 's/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/\nip&\n/gp'  | grep ip | sed 's/ip//' | awk -F. '{print $4}')
	if [ ! -d ${_imagePath}/${_cameraNum} ]
	then
		mkdir -p ${_imagePath}/${_cameraNum}
	fi
	echo $$ > ${_imagePath}/${_cameraNum}/pid
	if [ -f ${_imagePath}/${_cameraNum}/log ]
	then
		mv ${_imagePath}/${_cameraNum}/log ${_imagePath}/${_cameraNum}/$(date +%Y%m%d%H%M%S).log
	fi
	echo "I: Attempting to spawn ffmpeg rtsp collection and images housekeeper." > ${_imagePath}/${_cameraNum}/log
	_spawnCount=0
	while true
	do
		_spawnCount=$((${_spawnCount} +1))
		ffmpeg -y -rtsp_transport tcp -stimeout 2000000 -i ${_rtspPath} -vf fps=fps=10 ${_imagePath}/${_cameraNum}/%1d.jpg  >/dev/null 2>&1 < /dev/null &
		_PID=$!
		echo "$(date +%Y%m%d%H%M%S) I: Spawning ffmpeg - spawn count of ${_spawnCount} and pid of ${_PID} ." >> ${_imagePath}/${_cameraNum}/log
		sleep 45
		while true
		do
			if ! find ${_imagePath}/${_cameraNum}/ -name "*.jpg" -type f | grep -qs jpg
			then
				echo "$(date +%Y%m%d%H%M%S) E: Appears no jpg files found! Killing ffmpeg and sending break to respawn." >> ${_imagePath}/${_cameraNum}/log
				kill -9 ${_PID}
				sleep 5
				break
			else
				find ${_imagePath}/${_cameraNum}/ -name "*.jpg" -type f -mmin +1 -delete
				sleep 30
			fi
		done
	done
else
	echo "E: Not enough parameters passed! Please see --usage."
	exit 0
fi
