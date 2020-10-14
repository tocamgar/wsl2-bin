#!/bin/sh
#v288p.sh CÓDIGO ORIGINAL
# 01 INTRODUCIMOS LA VARIABLE filter_complex
# 02 INTRODUCIMOS LA VARIABLE f_logo
#################################################################################################

v_entrada="${1}"			# RUTA COMPLETA DEL VIDEO DE ENTRADA
txt_l1="${2}"				# LINEA 1 DE TEXTO A INCRUSTAR
txt_l2="${3}"				# LINEA 2 DE TEXTO A INCRUSTAR
ruta="${v_entrada%/*}/"		# SOLO LA RUTA DEL FICHERO
nom_f="${v_entrada##*/}"	# NOMBRE DEL FICHERO CON EXTENSIÓN
ext_f=".${nom_f##*.}"		# EXTENSIÓN DEL FICHERO CON . DELANTE
nom_f="${nom_f%.*}"			# NOMBRE DEL FICHERO SIN EXTENSIÓN
logo="/mnt/e/Pictures/logo-cam_53x26.png"	# RUTA COMPLETA DE LA MARCA DE AGUA A INCRUSTAR
v_salida="${ruta}${nom_f}_h264_288p_crf30_aac_q1_ac1_02${ext_f}"	# RUTA COMPLETA DEL VIDEO DE SALIDA
fontfile="/mnt/c/Windows/Fonts/impact.ttf"	# UBICACIÓN DE LA FUENTE DE TEXTO A EMPLEAR
filter_complex="
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
[txt]
"
f_logo=";
[1:v]
  format=argb,
  colorchannelmixer=
	aa=0.25
[logo];
[txt][logo]
  overlay=
	x=(main_w-overlay_w-5):
	y=(main_h-overlay_h-5)
[v]
"

##########
# FFMPEG #
##########

ffmpeg -y \
	-i "${v_entrada}" \
	-i "${logo}" \
	-filter_complex "${filter_complex}${f_logo}" \
	-map '[v]' \
	-map '0:a' \
	-c:a aac \
	-q:a 1 \
	-ac 1 \
	-c:v h264 \
	-crf 30 \
	"${v_salida}"