@echo off
:: ================================================================
:: PROYECTO: BETA 4.1.0 WINDOWS (PS-CORE) - h265 Main 10
:: ================================================================
setlocal enabledelayedexpansion
color 1f

:: Definir escape: B (Brillo blanco sobre azul), N (Reset a blanco sobre azul)
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "B=!ESC![1;97;44m"
set "N=!ESC![0;37;44m"

:detectar_hardware
cls
echo %B%================================================================%N%
echo   DETECTANDO HARDWARE V4.1.0 - TEST DE COMPATIBILIDAD REAL
echo %B%================================================================%N%

powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).Name" > "%temp%\cpu.tmp"
set /p cpu_name=<"%temp%\cpu.tmp"

:: ================================================================
:: BLOQUE DE DETECCIÓN AVANZADA (NVIDIA / AMD / INTEL)
:: ================================================================
set "has_nv=0"
set "has_amd=0"
set "has_intel=0"
set "gpu_list="

powershell -NoProfile -Command "(Get-CimInstance Win32_VideoController).Name" > "%temp%\gpus.tmp"

for /f "usebackq tokens=*" %%g in ("%temp%\gpus.tmp") do (
    set "gpu_current=%%g"
    set "status=[NO APTO]"

    :: ============================================================
    :: NVIDIA — Test HEVC 8‑bit y Main10
    :: ============================================================
    echo %%g | findstr /i "NVIDIA" >nul && (

        :: Test HEVC 8‑bit
        ffmpeg.exe -hide_banner -loglevel error ^
            -f lavfi -i color=c=black:s=64x64 ^
            -frames:v 1 -c:v hevc_nvenc -y nul 2>nv8.log

        set "nv8=0"
        findstr /i "InitializeEncoder" nv8.log >nul
        if errorlevel 1 set "nv8=1"
        del "nv8.log" >nul 2>&1

        :: Test HEVC Main10
        ffmpeg.exe -hide_banner -loglevel error ^
            -f lavfi -i color=c=black:s=64x64 ^
            -pix_fmt yuv420p10le -frames:v 1 -c:v hevc_nvenc -y nul 2>nv10.log

        set "nv10=0"
        findstr /i "InitializeEncoder" nv10.log >nul
        if errorlevel 1 set "nv10=1"
        del "nv10.log" >nul 2>&1

        if !nv8!==1 (
            set "has_nv=1"
            if !nv10!==1 (
                set "status=[OK] (HEVC Main10)"
            ) else (
                set "status=[OK] (HEVC 8-bit)"
            )
        ) else (
            set "status=[NO APTO]"
        )
    )

    :: ============================================================
    :: AMD — Test HEVC 8‑bit y Main10
    :: ============================================================
    echo %%g | findstr /i "AMD ATI" >nul && (

        :: Test HEVC 8‑bit
        ffmpeg.exe -hide_banner -loglevel error ^
            -f lavfi -i color=c=black:s=64x64 ^
            -frames:v 1 -c:v hevc_amf -y nul 2>amf8.log

        set "amd8=0"
        findstr /i "Initialize" amf8.log >nul
        if errorlevel 1 set "amd8=1"
        del "amf8.log" >nul 2>&1

        :: Test HEVC Main10
        ffmpeg.exe -hide_banner -loglevel error ^
            -f lavfi -i color=c=black:s=64x64 ^
            -pix_fmt yuv420p10le -frames:v 1 -c:v hevc_amf -y nul 2>amf10.log

        set "amd10=0"
        findstr /i "Initialize" amf10.log >nul
        if errorlevel 1 set "amd10=1"
        del "amf10.log" >nul 2>&1

        if !amd8!==1 (
            set "has_amd=1"
            if !amd10!==1 (
                set "status=[OK] (HEVC Main10)"
            ) else (
                set "status=[OK] (HEVC 8-bit)"
            )
        ) else (
            set "status=[NO APTO]"
        )
    )

    :: ============================================================
    :: INTEL — Test HEVC 8‑bit y Main10
    :: ============================================================
    echo %%g | findstr /i "Intel" >nul && (

        :: Test HEVC 8‑bit
        ffmpeg.exe -hide_banner -loglevel error ^
            -f lavfi -i color=c=black:s=64x64 ^
            -frames:v 1 -c:v hevc_qsv -y nul 2>qsv8.log

        set "qsv8=0"
        findstr /i "Error" qsv8.log >nul
        if errorlevel 1 set "qsv8=1"
        del "qsv8.log" >nul 2>&1

        :: Test HEVC Main10
        ffmpeg.exe -hide_banner -loglevel error ^
            -f lavfi -i color=c=black:s=64x64 ^
            -pix_fmt yuv420p10le -frames:v 1 -c:v hevc_qsv -y nul 2>qsv10.log

        set "qsv10=0"
        findstr /i "Error" qsv10.log >nul
        if errorlevel 1 set "qsv10=1"
        del "qsv10.log" >nul 2>&1

        if !qsv8!==1 (
            set "has_intel=1"
            if !qsv10!==1 (
                set "status=[OK] (HEVC Main10)"
            ) else (
                set "status=[OK] (HEVC 8-bit)"
            )
        ) else (
            set "status=[NO APTO]"
        )
    )

    set "gpu_list=!gpu_list! -- !gpu_current! !status!"
)

del "%temp%\cpu.tmp" "%temp%\gpus.tmp" >nul 2>&1

set "modo=NINGUNO" & set "codec=" & set "params="
:inicio
cls
echo %B%================================================================%N%
echo   BETA 4.1.0 : h265 Main 10
echo %B%================================================================%N%
echo  CPU DETECTADA: %cpu_name%
echo  GPU DETECTADA: %gpu_list%
echo %B%================================================================%N%
echo.
echo  [*] PASOS A SEGUIR:
echo      1. Selecciona el MOTOR (Opcion 1).
echo      2. Define las RUTAS de Origen/Destino (Opcion 2).
echo      3. Inicia la CONVERSION (Opcion 3).
echo.
echo  1. Elegir motor de codificado: [%modo%]
echo  2. Introducir directorios
echo  3. CONVERTIR VIDEOS A MKV h265
echo  4. Salir
echo.
echo  Origen:  "%origen%"
echo  Destino: "%destino%"
echo.
set /p var="> Seleccione una opcion [1-4]: "
if "%var%"=="1" goto menu_motor
if "%var%"=="2" goto op1
if "%var%"=="3" (
    if "%modo%"=="NINGUNO" (
        echo [ERROR] DEBES SELECCIONAR UN MOTOR EN LA OPCION 1 PRIMERO.
        pause
        goto inicio
    )
    goto op2
)
if "%var%"=="4" exit
goto inicio

:menu_motor
cls
echo %B%================================================================%N%
echo   MOTORES DISPONIBLES:
echo %B%================================================================%N%
echo   1. CPU libx265
if "%has_nv%"=="1" (echo   2. GPU NVIDIA NVENC) else (echo   [X] NVIDIA: No disponible)
if "%has_amd%"=="1" (echo   3. GPU AMD AMF) else (echo   [X] AMD: No disponible)
if "%has_intel%"=="1" (echo   4. INTEL QSV) else (echo   [X] INTEL: No disponible)
echo %B%================================================================%N%
set /p mot="> Motor [1-4]: "
set "motor_ok=0"
if "%mot%"=="1" set "modo=CPU" & set "codec=libx265" & set "motor_ok=1"
if "%mot%"=="2" if "%has_nv%"=="1" set "modo=GPU NVIDIA" & set "codec=hevc_nvenc" & set "motor_ok=1"
if "%mot%"=="3" if "%has_amd%"=="1" set "modo=GPU AMD" & set "codec=hevc_amf" & set "motor_ok=1"
if "%mot%"=="4" if "%has_intel%"=="1" set "modo=GPU INTEL" & set "codec=hevc_qsv" & set "motor_ok=1"
if "%motor_ok%"=="0" (echo No valido. & pause & goto inicio)

:menu_presets
cls
echo %B%================================================================%N%
echo   CONFIGURAR VELOCIDAD PARA: %modo%
echo %B%================================================================%N%
echo   1. Ultrafast
echo   2. Superfast
echo   3. Veryfast
echo   4. Faster
echo   5. Fast
echo   6. Medium
echo   7. Slow
echo   8. Slower
echo   9. Veryslow
echo %B%================================================================%N%
set /p pre="> Seleccione preset [1-9]: "
if "%pre%"=="1" set "p_cpu=ultrafast" & set "p_nv=p1" & set "p_amd=speed"
if "%pre%"=="2" set "p_cpu=superfast" & set "p_nv=p2" & set "p_amd=speed"
if "%pre%"=="3" set "p_cpu=veryfast"  & set "p_nv=p3" & set "p_amd=speed"
if "%pre%"=="4" set "p_cpu=faster"    & set "p_nv=p4" & set "p_amd=balanced"
if "%pre%"=="5" set "p_cpu=fast"      & set "p_nv=p4" & set "p_amd=balanced"
if "%pre%"=="6" set "p_cpu=medium"    & set "p_nv=p5" & set "p_amd=balanced"
if "%pre%"=="7" set "p_cpu=slow"      & set "p_nv=p6" & set "p_amd=quality"
if "%pre%"=="8" set "p_cpu=slower"    & set "p_nv=p7" & set "p_amd=quality"
if "%pre%"=="9" set "p_cpu=veryslow"  & set "p_nv=p7" & set "p_amd=quality"

if "%modo%"=="CPU"        set "params=-crf 23 -preset %p_cpu% -x265-params pools=+:frame-threads=0"
if "%modo%"=="GPU NVIDIA" set "params=-rc vbr -cq 23 -b:v 0 -preset %p_nv%"
if "%modo%"=="GPU AMD"    set "params=-rc cqp -qp_p 23 -qp_i 23 -quality %p_amd% -usage transcoding"
if "%modo%"=="GPU INTEL"  set "params=-global_quality 23 -preset %p_cpu%"
goto inicio
:op1
cls
set /p origen="Origen: "
set /p destino="Destino: "
set "origen=%origen:"=%" & set "destino=%destino:"=%"
goto inicio

:op2
if "%origen%"=="" goto op1
cls
set "reporte=%destino%\peliculas ripeadas.txt"
if exist "%reporte%" del "%reporte%"

set "total_archivos=0"
for %%e in (mkv mp4 mov avi mpeg mpg ogv) do (
    for %%f in ("%origen%\*.%%e") do (
        set /a total_archivos+=1
    )
)

echo ================================================= >> "%reporte%"
echo   REPORTE DE CONVERSION V4.1.0 - %DATE% %TIME% >> "%reporte%"
echo   MOTOR UTILIZADO: %modo% >> "%reporte%"
echo   TOTAL ARCHIVOS A PROCESAR: %total_archivos% >> "%reporte%"
echo   LISTADO: >> "%reporte%"
for %%e in (mkv mp4 mov avi mpeg mpg ogv) do (
    for %%f in ("%origen%\*.%%e") do (
        echo   - %%~nxf >> "%reporte%"
    )
)
echo ================================================= >> "%reporte%"

set "actual=0"
for %%e in (mkv mp4 mov avi mpeg mpg ogv) do (
    for %%f in ("%origen%\*.%%e") do (

        set /a actual+=1
        set "archivo=%%~nxf"
        set "purename=%%~nf"

        echo Procesando [!actual!/%total_archivos%]: "!archivo!"

        for /f %%a in ('powershell -command "[math]::round((Get-Item -LiteralPath '%%f').Length / 1MB, 2)"') do (
            set "size_orig=%%a"
        )

        set "t_inicio=!time!"
        echo ARCHIVO: !archivo! >> "%reporte%"
        echo - Inicio: !t_inicio! >> "%reporte%"
        echo - Tamano Original: !size_orig! MB >> "%reporte%"

        ffmpeg.exe -i "%%f" -an -sn -pix_fmt yuv420p10le -c:v %codec% %params% -profile:v main10 -level:v 5.1 "%destino%\video_!archivo!.mkv" -y

        mkvmerge.exe -o "%destino%\!purename!.mkv" -D "%%f" -A -S -T -M -B --no-chapters "%destino%\video_!archivo!.mkv"

        del "%destino%\video_!archivo!.mkv" >nul 2>&1

        set "t_fin=!time!"

        for /f %%a in ('powershell -command "[math]::round((Get-Item -LiteralPath '%destino%\!purename!.mkv').Length / 1MB, 2)"') do (
            set "size_final=%%a"
        )

        set "s_orig_ps=!size_orig:,=.!"
        set "s_final_ps=!size_final:,=.!"

        for /f "tokens=1,2,3" %%a in ('
            powershell -command "
                $i=[datetime]::Parse('!t_inicio!'.Trim().Replace(',','.'));
                $f=[datetime]::Parse('!t_fin!'.Trim().Replace(',','.'));
                if($f -lt $i){$f=$f.AddDays(1)}
                $dur=$f-$i;
                $ahorro=[math]::round(!s_orig_ps! - !s_final_ps!, 2);
                $perc=[math]::round(($ahorro/!s_orig_ps!)*100, 2);
                write-host ($dur.ToString('hh\:mm\:ss') + ' ' + $ahorro + ' ' + $perc)
            "
        ') do (
            set "duracion=%%a"
            set "ahorro_mb=%%b"
            set "porcentaje=%%c"
        )

        echo - Finalizado: !t_fin! >> "%reporte%"
        echo - Duracion: !duracion! >> "%reporte%"
        echo - Tamano Final: !size_final! MB >> "%reporte%"
        echo - Ahorro: !ahorro_mb! MB ^(!porcentaje!%%^) >> "%reporte%"
        echo ------------------------------------------------- >> "%reporte%"

    )
)

echo.
echo PROCESO COMPLETADO V4.1.0.
pause
goto inicio