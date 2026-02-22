@ECHO OFF
:: Proyecto: VIDEOENC.BAT (v1.0 Retro-Mierdas)
:: Motor compatible: XingMPEG Encoder (XING.EXE / XNGMPEG.EXE)
:: Licencia: CC BY-NC 4.0 (Atribución-NoComercial)
:: Adaptado para MS-DOS 5.0+ por [Tu Alias]
CLS
ECHO =========================================
ECHO   VIDEOENC V1.0 - El terror del 8086
ECHO =========================================

:: Intentar detectar CPU con herramienta externa (opcional)
IF EXIST SYSCHK.EXE SYSCHK /C > CPU.TMP
IF NOT EXIST CPU.TMP ECHO CPU: Desconocida (8086/286 asumido)

:MENU
ECHO.
ECHO  1. SELECCIONAR MOTOR (XingMPEG Detectado)
ECHO  2. ESTIMAR TIEMPO SEGUN CPU (Notas de Sufrimiento)
ECHO  3. COMENZAR CODIFICACION (REQUIERE VIDEO.RAW)
ECHO  4. SALIR
ECHO.
CHOICE /C:1234 /N "Elija opcion [1-4]: "

IF ERRORLEVEL 4 GOTO FIN
IF ERRORLEVEL 3 GOTO START
IF ERRORLEVEL 2 GOTO INFO
IF ERRORLEVEL 1 GOTO MOTOR

:MOTOR
ECHO.
ECHO CONFIGURACION DE SALIDA XING:
ECHO 1. MODO VCD (352x240 - 1150kbps)
ECHO 2. MODO CUSTOM (MPEG-1 High Res)
CHOICE /C:12 /N "Seleccion: "
IF ERRORLEVEL 2 SET M_OPT=/V /S /VCD
IF ERRORLEVEL 1 SET M_OPT=/V /VCD
ECHO Parametros guardados.
PAUSE
GOTO MENU

:INFO
CLS
ECHO ===========================================================================
ECHO   NOTAS DE SUFRIMIENTO (Pelicula 90 min)
ECHO ===========================================================================
ECHO - Intel 8086 Mi primera colonia digo primer pc y derivados desde 4.77 MHz ~450 dias "Comprate un 486, por favor".
ECHO - Intel 286 producto para ricos y derivados desde 6 MHz ~120 dias "Aun no termina el primer frame".
ECHO - Intel 386 SX-DX Mejoramos y derivados desde 12 MHz ~15 dias "Ponme un ventilador HdP".
ECHO - Intel 486 SX-DX Las cosas se ponen serias y derivados desde 16 MHz ~4 dias "Ya casi vemos el logo de inicio".
ECHO - Pentium (P5) Primer gran salto y derivados El "Original" desde (60/66MHz) ~5 - 7 dias "Cuidado con el bug de division FDIV".
ECHO - Pentium Pro El Rey de los Servidores sueno humedo ~3 - 4 dias Optimizado para 32 bits (Windows NT).
ECHO - Pentium MMX Instrucciones Multimedia todos los tuvimos ~2 - 3 dias El MMX ayudaba mucho con el color del video.
ECHO - Pentium II Cartucho "Klamath" Ya tenemos 3d ~30 - 40 horas Empezamos a ver la luz al final del tunel.
ECHO - Pentium III Instrucciones SSE Fin de una era ~18 - 24 horas !Casi tiempo real! (El estandar del DivX).
ECHO ===========================================================================
PAUSE
GOTO MENU

:START
ECHO.
ECHO *** BUSCANDO MOTOR XINGMPEG (XING.EXE o XNGMPEG.EXE) ***
set E_EXE=NONE
IF EXIST XING.EXE set E_EXE=XING.EXE
IF EXIST XNGMPEG.EXE set E_EXE=XNGMPEG.EXE

IF "%E_EXE%"=="NONE" GOTO ERROR_MOTOR

ECHO.
ECHO ADVERTENCIA: El sistema se congelara. Asegurate de tener VIDEO.RAW.
ECHO Ejecutando %E_EXE% %M_OPT% ...
%E_EXE% VIDEO.RAW /O PELI.MPG %M_OPT%

IF ERRORLEVEL 1 GOTO ERROR_EXEC
ECHO.
ECHO !!! PROCESO FINALIZADO !!!
ECHO Si el PC no ha implosionado, ya tienes tu pelicula en MPEG-1.
PAUSE
GOTO MENU

:ERROR_MOTOR
ECHO [ERROR] No se encuentra XING.EXE o XNGMPEG.EXE en esta carpeta.
PAUSE
GOTO MENU

:ERROR_EXEC
ECHO [ERROR] El encoder ha fallado. ¿Falta RAM? ¿VIDEO.RAW corrupto?
PAUSE
GOTO MENU

:FIN
CLS
ECHO "640K deberian ser suficientes para cualquiera" - Bill G.
ECHO Repositorio: mis mierdas varias
ECHO Gracias por usar VIDEOENC.BAT
