#!/bin/sh
#v288p.sh CÓDIGO ORIGINAL
#################################################################################################

v_entrada="${1}"
txt_l1="${2}"
txt_l2="${3}"
ruta="${v_entrada%/*}/"
nom_f="${v_entrada##*/}"
ext_f=".${nom_f##*.}"
nom_f="${nom_f%.*}"
logo="/mnt/e/Pictures/logo-cam_53x26_50a.png"
v_salida="${ruta}${nom_f}_h264_288p_crf30_aac_q1_ac1${ext_f}"
fontfile="/mnt/c/Windows/Fonts/impact.ttf"

ffmpeg -y \
	-i "${v_entrada}" \
	-i "${logo}" \
	-filter_complex \
		"
			[0:v]
				scale=
					-2:
					288:
					flags=bicubic,
				drawtext=
					fontfile=${fontfile}:
					text=${txt_l1}:
					fontcolor=white:
					borderw=1:
					fontsize=18:
					alpha=0.67:
					x=(w-tw)/2:
					y=(th/4),
				drawtext=
					fontfile=${fontfile}:
					text=${txt_l2}:
					fontcolor=white:
					borderw=1:
					fontsize=18:
					alpha=0.67:
					x=(w-tw)/2:
					y=(3*th/2)
			[txt];
			[1:v]
				format=argb,
				colorchannelmixer=
					aa=0.5
			[logo];
			[txt][logo]
				overlay=
					x=(main_w-overlay_w-5):
					y=(main_h-overlay_h-5)
			[v]
		" \
	-map '[v]' \
	-map '0:a' \
	-c:a aac \
	-q:a 1 \
	-ac 1 \
	-c:v h264 \
	-crf 30 \
	"${v_salida}"