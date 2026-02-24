#!/bin/bash
# ================================================================
# PROYECTO: BETA 4.1.0 LINUX - h265 Main 10
# REPOSITORIO: ://github.com[TU_USUARIO]/mis-mierdas-varias
# LICENCIA: CC BY-NC 4.0 (Atribución-NoComercial)
# Prohibida su venta o uso comercial. ¡Nombra al autor original!
# ================================================================

# --- CONFIGURACIÓN DE COLORES ---
BG_AZUL='\033[44m\033[97m'
BLANCO_B='\033[1;97m'
VERDE='\033[1;32m'
ROJO='\033[1;31m'
CIAN='\033[1;36m'
TEXTO_MATE='\033[0;37;44m'
MARCO_BRILLO='\033[1;97;44m'
NC='\033[0m'

pintar_fondo() {
    echo -ne "${BG_AZUL}"
    clear
}

salir_limpio() {
    echo -ne "${NC}"
    clear
    exit 0
}

# --- FUNCIÓN DE DEPENDENCIAS ---
comprobar_dependencias() {
    echo -e "${CIAN}Verificando herramientas...${NC}"
    for dep in ffmpeg mkvmerge bc; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${ROJO}Falta: $dep. Instalando...${NC}"
            sudo apt update && sudo apt install -y ffmpeg mkvtoolnix bc
        fi
    done
}

detectar_hardware() {
    pintar_fondo
    echo -e "${BLANCO_B}================================================================${BG_AZUL}"
    echo -e "${BLANCO_B}   DETECTANDO HARDWARE (V4.1.0) - TEST REAL 10-BIT${BG_AZUL}"
    echo -e "${BLANCO_B}================================================================${BG_AZUL}"

    cpu_name=$(grep -m 1 "model name" /proc/cpuinfo | cut -d':' -f2 | sed -e 's/^[[:space:]]*//')
    [ -z "$cpu_name" ] && cpu_name=$(lscpu | grep -iE "Nombre del modelo|Model name" | head -1 | cut -d':' -f2 | xargs)

    gpu_list=""; has_nv=0; has_amd=0; has_intel=0
    gpus=$(lspci | grep -iE "vga|3d|display")
    
    while IFS= read -r line; do
        gpu_current=$(echo "$line" | cut -d':' -f3 | sed -e 's/^[[:space:]]*//')
        status="[NO APTO 10-BIT]"
        
        if echo "$line" | grep -iq "NVIDIA"; then
            ffmpeg -f lavfi -i color=c=black:s=64x64:n=1 -pix_fmt yuv420p10le -vframes 1 -c:v hevc_nvenc -f null - &>/dev/null && { has_nv=1; status="[OK 10-BIT]"; }
            gpu_list="$gpu_list -- $gpu_current $status"
        elif echo "$line" | grep -iqE "AMD|ATI"; then
            ffmpeg -f lavfi -i color=c=black:s=64x64:n=1 -pix_fmt yuv420p10le -vframes 1 -c:v hevc_amf -f null - &>/dev/null && { has_amd=1; status="[OK 10-BIT]"; }
            gpu_list="$gpu_list -- $gpu_current $status"
        elif echo "$line" | grep -iq "Intel"; then
            ffmpeg -f lavfi -i color=c=black:s=64x64:n=1 -pix_fmt yuv420p10le -vframes 1 -c:v hevc_qsv -f null - &>/dev/null && { has_intel=1; status="[OK 10-BIT]"; }
            gpu_list="$gpu_list -- $gpu_current $status"
        fi
    done <<< "$gpus"

    modo="NINGUNO"
    codec=""
    params=""
}

menu_motor() {
    pintar_fondo
    echo -e "${BLANCO_B}================================================================${BG_AZUL}"
    echo -e "   SELECCIONE MOTOR DE CODIFICADO${BG_AZUL}"
    echo -e "${BLANCO_B}================================================================${BG_AZUL}"
    echo "1. CPU (libx265) : OK"
    [[ $has_nv -eq 1 ]] && echo "2. GPU NVIDIA NVENC : OK 10-BIT" || echo "[X] NVIDIA NVENC : No disponible o no 10-bit"
    [[ $has_amd -eq 1 ]] && echo "3. GPU AMD AMF : OK 10-BIT" || echo "[X] AMD AMF : No disponible o no 10-bit"
    [[ $has_intel -eq 1 ]] && echo "4. GPU INTEL QuickSync : OK 10-BIT" || echo "[X] INTEL QSV : No disponible o no 10-bit"
    echo ""
    read -p "Seleccione motor [1-4]: " mot

    motor_ok=0
    case $mot in
        1) modo="CPU"; codec="libx265"; motor_ok=1 ;;
        2) [[ $has_nv -eq 1 ]] && { modo="GPU NVIDIA"; codec="hevc_nvenc"; motor_ok=1; } ;;
        3) [[ $has_amd -eq 1 ]] && { modo="GPU AMD"; codec="hevc_amf"; motor_ok=1; } ;;
        4) [[ $has_intel -eq 1 ]] && { modo="GPU INTEL"; codec="hevc_qsv"; motor_ok=1; } ;;
    esac

    if [ $motor_ok -eq 1 ]; then
        pintar_fondo
        echo -e "${BLANCO_B}================================================================${BG_AZUL}"
        echo -e "   CONFIGURAR VELOCIDAD PARA: $modo${BG_AZUL}"
        echo -e "${BLANCO_B}================================================================${BG_AZUL}"
        echo "  1. Ultrafast"
        echo "  2. Superfast"
        echo "  3. Veryfast"
        echo "  4. Faster"
        echo "  5. Fast"
        echo "  6. Medium"
        echo "  7. Slow"
        echo "  8. Slower"
        echo "  9. Veryslow"
        echo -e "${BLANCO_B}================================================================${BG_AZUL}"
        read -p "> Seleccione preset [1-9]: " pre_opt
        case $pre_opt in
            1) p_cpu="ultrafast"; p_nv="p1"; p_amd="speed" ;;
            2) p_cpu="superfast"; p_nv="p2"; p_amd="speed" ;;
            3) p_cpu="veryfast";  p_nv="p3"; p_amd="speed" ;;
            4) p_cpu="faster";    p_nv="p4"; p_amd="balanced" ;;
            5) p_cpu="fast";      p_nv="p4"; p_amd="balanced" ;;
            6) p_cpu="medium";    p_nv="p5"; p_amd="balanced" ;;
            7) p_cpu="slow";      p_nv="p6"; p_amd="quality" ;;
            8) p_cpu="slower";    p_nv="p7"; p_amd="quality" ;;
            9) p_cpu="veryslow";  p_nv="p7"; p_amd="quality" ;;
            *) p_cpu="medium";    p_nv="p5"; p_amd="balanced" ;;
        esac

        case $modo in
            "CPU")        params="-crf 23 -preset $p_cpu -x265-params pools=+:frame-threads=0" ;;
            "GPU NVIDIA") params="-rc vbr -cq 23 -b:v 0 -preset $p_nv -profile:v main10" ;;
            "GPU AMD")    params="-rc cqp -qp_p 23 -qp_i 23 -quality $p_amd -usage transcoding -profile main10" ;;
            "GPU INTEL")  params="-global_quality 23 -preset $p_cpu -profile:v main10" ;;
        esac
    else
        echo -e "${ROJO}Selección no válida o hardware no detectado.${NC}"
        sleep 2
    fi
}

detectar_hardware
trap salir_limpio INT TERM
comprobar_dependencias

while true; do
    pintar_fondo
    echo -e "${BLANCO_B}================================================================${BG_AZUL}"
    echo -e "${BLANCO_B}   BETA 4.1.0 LINUX: h265 Main 10 ${BG_AZUL}"
    echo -e "${BLANCO_B}================================================================${BG_AZUL}"
    echo -e " CPU DETECTADA: $cpu_name"
    echo -e " GPU DETECTADA: $gpu_list"
    echo -e "${BLANCO_B}================================================================${BG_AZUL}"
    echo -e ""
    echo -e "  [*] PASOS A SEGUIR:"
    echo -e "      1. Selecciona el MOTOR (Opcion 1)."
    echo -e "      2. Define las RUTAS de Origen/Destino (Opcion 2)."
    echo -e "      3. Inicia la CONVERSION (Opcion 3)."
    echo -e ""
    echo -e "  1. Elegir motor de codificado: [${VERDE}$modo${NC}${BG_AZUL}]"
    echo -e "  2. Introducir directorios"
    echo -e "  3. CONVERTIR TODO A MKV h265"
    echo -e "  4. Salir"
    echo ""
    echo -e "  Origen:  ${origen:-No definido}"
    echo -e "  Destino: ${destino:-No definido}"
    echo ""
    read -p "> Seleccione opción [1-4]: " var

    case $var in
        1) menu_motor ;;
        2) 
            read -p "Introduce el directorio de origen: " origen
            read -p "Introduce el directorio de destino: " destino
            origen="${origen%/}"; destino="${destino%/}"
            ;;
        3) 
            if [ "$modo" == "NINGUNO" ]; then
                echo -e "${ROJO}[ERROR] DEBES SELECCIONAR UN MOTOR EN LA OPCIÓN 1 PRIMERO.${NC}"
                sleep 2
                continue
            fi
            [[ -z "$origen" || -z "$destino" ]] && { echo -e "${ROJO}Error: Rutas vacías.${NC}"; sleep 2; continue; }
            reporte="$destino/peliculas ripeadas.txt"
            
            shopt -s nullglob nocaseglob
            files=("$origen"/*.{mkv,mp4,mov,avi,mpeg,mpg,ogv})
            total=${#files[@]}
            [ "$total" -eq 0 ] && { echo -e "${ROJO}No hay archivos.${NC}"; sleep 2; continue; }

            echo "=================================================" > "$reporte"
            echo "  REPORTE DE CONVERSION V4.1.0 - $(date '+%d/%m/%Y %H:%M:%S')" >> "$reporte"
            echo "  MOTOR UTILIZADO: $modo" >> "$reporte"
            echo "  TOTAL ARCHIVOS A PROCESAR: $total" >> "$reporte"
            echo "  LISTADO:" >> "$reporte"
            for f in "${files[@]}"; do echo "  - $(basename "$f")" >> "$reporte"; done
            echo "=================================================" >> "$reporte"

            actual_peli=0
            for f in "${files[@]}"; do
                ((actual_peli++))
                fname=$(basename "$f"); bname="${fname%.*}"
                
                size_in_kb=$(du -k "$f" | cut -f1)
                size_in_mb=$(echo "scale=2; $size_in_kb / 1024" | bc)
                avail_kb=$(df -k "$destino" | tail -1 | awk '{print $4}')
                req_kb=$(echo "$size_in_kb * 1.05" | bc | cut -d'.' -f1)

                pintar_fondo
                echo -e "${MARCO_BRILLO}================================================================${BG_AZUL}"
                echo -e " PROCESANDO ($actual_peli de $total): $fname"
                echo -e " MOTOR: $modo"
                echo -e " DISP: $((avail_kb/1024))MB | REQ: $((req_kb/1024))MB"
                echo -e "${MARCO_BRILLO}================================================================${BG_AZUL}"

                if [ "$avail_kb" -lt "$req_kb" ]; then
                    echo -e "${ROJO}ERROR: ESPACIO INSUFICIENTE. SALTANDO...${NC}"
                    echo "ARCHIVO: $fname" >> "$reporte"
                    echo "  - [SALTADO] Sin espacio disponible" >> "$reporte"
                    echo "-------------------------------------------------" >> "$reporte"
                    sleep 2; continue
                fi

                t_inicio=$(date '+%H:%M:%S')
                inicio_seg=$SECONDS
                
                echo "ARCHIVO: $fname" >> "$reporte"
                echo " - Inicio: $t_inicio" >> "$reporte"
                echo " - Tamano Original: $size_in_mb MB" >> "$reporte"

                echo -e "${CIAN}Codificando... (Presiona 'q' para saltar archivo)${BLANCO_B}"
                ffmpeg -v error -stats -i "$f" -an -sn -pix_fmt yuv420p10le -c:v $codec $params -profile:v main10 -level:v 5.1 "$destino/v_tmp_$fname.mkv" -y
                
                echo -e "\n${VERDE}Remezclando con MKVMerge...${NC}"
                mkvmerge -o "$destino/$bname.mkv" -D "$f" -A -S -T -M -B --no-chapters "$destino/v_tmp_$fname.mkv" &>/dev/null
                rm -f "$destino/v_tmp_$fname.mkv"
                
                t_fin=$(date '+%H:%M:%S')
                duracion_seg=$(( SECONDS - inicio_seg ))
                duracion_fmt=$(printf '%02d:%02d:%02d' $((duracion_seg/3600)) $((duracion_seg%3600/60)) $((duracion_seg%60)))
                
                size_out_kb=$(du -k "$destino/$bname.mkv" | cut -f1)
                size_out_mb=$(echo "scale=2; $size_out_kb / 1024" | bc)
                
                ahorro_mb=$(echo "scale=2; $size_in_mb - $size_out_mb" | bc)
                porcentaje=$(echo "scale=2; ($ahorro_mb / $size_in_mb) * 100" | bc)

                echo " - Finalizado: $t_fin" >> "$reporte"
                echo " - Duracion: $duracion_fmt" >> "$reporte"
                echo " - Tamano Final: $size_out_mb MB" >> "$reporte"
                echo " - Ahorro: $ahorro_mb MB ($porcentaje%)" >> "$reporte"
                echo "-------------------------------------------------" >> "$reporte"
            done
            
            read -p "Proceso finalizado. Reporte generado en '$reporte'. Enter..." ;;
        4) salir_limpio ;;
    esac
done
