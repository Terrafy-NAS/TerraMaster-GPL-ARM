#!/bin/sh
#$1 is source
#$2 is FHD, HD, SD

do_transcode() 
{
Statistics=TRUE

case $3 in
    "AVI") demuxer=avidemux
      ;;

    "BDAV") demuxer=tsdemux
      ;;

    "MPEG-4") demuxer=qtdemux
      ;;

    "Matroska") demuxer=matroskademux
      ;;

    "RealMedia") demuxer=rmdemux
      ;;

    "Windows Media") demuxer=asfdemux
      ;;
esac

case $5 in 
    "2") vdecode="mpegvideoparse ! omxmpeg2videodec"
      ;;

    "avc1")  vdecode=omxh264dec
      ;;

    "RV40") vdecode=omxrvdec
      ;;

    "V_MPEG2") vdecode="mpegvideoparse ! omxmpeg2videodec"
      ;;

    "V_MPEG4/ISO/AVC") vdecode=omxh264dec
      ;;
	
    "V_MPEGH/ISO/HEVC")  vdecode=omxh265dec
      ;;

    "WMV3") vdecode=omxwmvdec
      ;;

    "XVID") vdecode=omxmpeg4videodec
      ;;
esac

case $6 in
    "AAC") adecode=faad
      ;;

    "AC-3") adecode="ac3parse ! avdec_ac3"
      ;;
	
    "Cooker") adecode=avdec_cook
      ;;

    "MPEG Audio") adecode=avdec_mp3
      ;;

    "WMA") adecode=avdec_wmapro
      ;;

    *) adecode=unknown
      ;;
esac

filename="${1%.*}"

trcmd="time gst-launch-1.0 filesrc location=\"$1\" ! typefind ! $demuxer name=demuxer \
demuxer. ! queue2 max-size-time=0 max-size-buffers=0 max-size-bytes=0 ! $vdecode autoResize=$2 ! videoconvert ! \
omxh264enc fps_statistics=$Statistics i-frame-interval=1 bitrate=5120000 !  h264parse disable-passthrough=true ! mp4mux name=mux mux. ! \
filesink location=\"${filename}_${4}_${2}_transcoded.mp4\""

if [ "$adecode" != "unknown" ]; then 
    trcmd="${trcmd} demuxer. ! queue2  max-size-time=0 max-size-buffers=0 max-size-bytes=0 ! $adecode ! audioconvert ! faac ! mux."
fi
eval $trcmd
}

if [ $# -ne 2 ]; then
    echo "$0 Source_File FHD|HD|SD"
else
    Metadata=`/usr/bin/mediainfo --Output=file:///etc/template.txt $1`
    IFS=:
    do_transcode $1 $2 $Metadata
fi
