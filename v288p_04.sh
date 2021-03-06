#! /bin/bash
# v288p.sh CÓDIGO ORIGINAL
# 02 Se añaden mensajes de entrada para video de entrada textos
# 04 Se añaden t_ini y t_fin con lectura desde read y valores por defecto
# añado ? en -map '0:a?' para que ignore la ausencia de flujo de audio
#################################################################################################
echo -n "Introduce el video de entrada: "
read -e v_entrada			# RUTA COMPLETA DEL VÍDEO DE ENTRADA
ruta="${v_entrada%/*}/"
nom_f="${v_entrada##*/}"
ext_f=".${nom_f##*.}"
nom_f="${nom_f%.*}"

fontfile="/mnt/c/Windows/Fonts/impact.ttf"

read -ep "Introduce el inicio de la secuencia (00:00:00.000): " -i "00:00:00.000" t_ini

#v_dur=$(ffmpeg -i "${v_entrada}" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") # Calcula la duración del vídeo
v_dur=$(ffprobe -v error -show_entries format=duration -sexagesimal -of default=noprint_wrappers=1:nokey=1 "${v_entrada}") 
read -ep "Introduce el final de la secuencia (${v_dur}): " -i "${v_dur}" t_fin

read -p "Introduce el titular 1: " txt_l1		# LINEA 1 DE TEXTO A INCRUSTAR

read -p "Introduce el titular 2: " txt_l2		# LINEA 2 DE TEXTO A INCRUSTAR

logo="/mnt/e/Pictures/logo-cam_53x26.png"

v_salida="${ruta}${nom_f}_h264_288p_crf30_aac_q1_ac1.mp4"

f_resolucion="
	[0:v]
		scale=
			width=-2:
			height=288:
			flags=bicubic
	"
f_txt_l1="
,
  drawtext=
		fontfile='${fontfile}':
		text='${txt_l1}':
		fontcolor=white:
		borderw=1:
		fontsize=18:
		alpha=0.67:
		x=(w-tw)/2:
		y=(th/4)
"
f_txt_l2="
,
  drawtext=
		fontfile='${fontfile}':
		text='${txt_l2}':
		fontcolor=white:
		borderw=1:
		fontsize=18:
		alpha=0.67:
		x=(w-tw)/2:
		y=(6*(th/4))
	[txt]
"
f_logo="
;
	[1:v]
		format=argb,
		colorchannelmixer=
			aa=0.33
	[logo]
;
	[txt][logo]
		overlay=
		x=(main_w-overlay_w-5):
		y=(main_h-overlay_h-5)
	[v]
"
filter_complex="${f_resolucion}${f_txt_l1}${f_txt_l2}${f_logo}"

##########
# FFMPEG #
##########

ffmpeg -y \
	-ss "${t_ini}" \
	-to "${t_fin}" \
	-i "${v_entrada}" \
	-i "${logo}" \
	-filter_complex "${filter_complex}" \
	-map '[v]' \
	-map '0:a?' \
	-c:a aac \
	-q:a 1 \
	-ac 1 \
	-c:v h264 \
	-crf 30 \
	"${v_salida}"