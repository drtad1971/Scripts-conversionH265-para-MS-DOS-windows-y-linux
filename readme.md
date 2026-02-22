# 🎬 Optimización de Video h265 Main 10 (v4.1.0)

Scripts automatizados para convertir tu colección de video a **H.265 (HEVC) de 10 bits** manteniendo la máxima calidad y ahorrando hasta un 70% de espacio. Disponibles para **Windows** (Batch/PowerShell) y **Debian/Ubuntu** (Bash).

---

## 🚀 Características (v4.1.0)
- **Detección Automática de Hardware:** Identifica si tienes GPU **NVIDIA, AMD o Intel** para usar aceleración por hardware.
- **Modo CPU Ultra:** Optimizado para usar todos los hilos de tu procesador.
- **Menú de Presets (1-9):** Tú eliges entre velocidad extrema o compresión máxima.
- **Remux Inteligente:** Conserva audios, subtítulos y capítulos originales usando `mkvmerge`.
- **Reporte Detallado:** Calcula el ahorro de espacio en MB/GB y porcentaje tras cada conversión.
- **Bloqueo de "Obsolescencia Programada" (Windows):** El script desactiva automáticamente la GPU en hardware antiguo para evitar errores de driver.

---

## 📜 Historial de Evolución (Changelog)

### v1.0.0 - Arqueología Digital
*   **Origen:** Creada originalmente para fines condones, digo preservativos (es humor, no me matéis), esta versión la encontré recientemente en un **disquete** perdido.
*   **Estado:** La he actualizado lo que he podido, pero me faltan los conversores de video de la época que se han perdido en el tiempo. 
*   **🔍 SOS:** Si alguien conserva los conversores originales de finales de los 80, los 90 y principios de los 2000 en especial el cmpeg encoder de Christian michel , que me contacte por favor en mi mail (está al final).

### v2.0.0 - El Big Bang de la Compresión
*   Nacimiento del script base después de muchas pruebas en la versión basura 1.0 al ser una versión que hice en su dia para MS-DOS y win9x para pasar video a xvid (divx), para **FFmpeg**.
*   Conversión simple a h265 8-bit.

### v3.0.0 - Salto al "Main 10"
*   Implementación de **10 bits (Main 10)** para evitar el banding.
*   Inclusión de **mkvtoolnix** para no perder ni un solo subtítulo.

### v4.0.0 - El Cerebro de la Bestia
*   Introducción del **Menú Interactivo (1-9)**.
*   **Aceleración por Hardware (NVENC/VAAPI)**.

### v4.1.0 - La Versión Definitiva (Actual)
*   **Detección inteligente de hardware**: El script ahora "ve" tu GPU antes que tú.
*   **Ajuste por "Sugerencia" de Fabricante**: En Windows, si detecta una **NVIDIA 1080 o inferior** (o una **Radeon RX 480 o inferior**), la codificación por GPU h265 se desactiva. 
    *   *Nota:* Aunque la serie 1000 y 1600 tienen potencia de sobra para esto, NVIDIA y Microsoft han decidido "capar" los drivers para que actualices a una GPU más moderna por el bien de su cartera y por tu bien según ellos, necesitan tus dineros para dar de comer a sus churumbeles. El script te ahorra el pantallazo azul forzando el modo CPU.

Viva Obsole$cencia De$programada, no espera Obsolescencia "Sugerida", espera me equivoco, Obsolescencia Pre-pago tampoco es asi, Obsol€$cencia Forzada no creo que sea asi tampoco, OBSOLESCENCIA PROGRAMADA
*   **Reporte de ahorro real**: Te presume cuántos GB le has ganado al disco duro tras el procesado.

---

## 🛠️ Requisitos e Instalación

### 🪟 Windows (Portátil y Directo)
Debido a que Microsoft prefiere apoyar a creadores de software de pago (muchas veces llenos de bugs) para que gastes tu dinero en vez de usar versiones open que la mayoría de las veces funciona mucho mejor, **`winget` no baja las últimas versiones de FFmpeg y directamente ignora MKVToolNix**. 

Por ello:
1. **He incluido los binarios actualizados dentro del archivo comprimido**.
2. El script usará las versiones adjuntas para asegurar que todo funcione a la primera.
3. **Aviso de Hardware:** En hardware "vintage" (GTX 1080 / RX 480 o inferior), el script usará CPU por defecto.

### 🐧 Debian / Ubuntu
Aquí todo funciona a las mil maravillas, como es de esperar en un sistema serio:
```bash
sudo apt update && sudo apt install -y ffmpeg mkvtoolnix bc lshw```

📩 Contacto y Resistencia
Si tienes los conversores que busco, si el script ha salvado a tu GPU del "sacrificio planificado", o si simplemente quieres enviarle un saludo (de los que llevan un dedo levantado) a los CEOs de NVIDIA y Microsoft:
📬 Email: Drtad.j.l@gmail.com

⚖️ Descargo de Responsabilidad (El rincón de los abogados)

    No me hago responsable si NVIDIA o AMD decide que tu tarjeta es "demasiado vieja para existir" y te manda una actualización de drivers que la convierta en un pisapapeles.
    Si tu CPU empieza a emitir señales de humo en Modo Ultra, es que por fin está trabajando de verdad. Abre la ventana y disfruta del olor a eficiencia.
    Este script es Open Source de verdad: sin trampa, sin cartón, sin suscripciones mensuales y sin que nadie te robe los datos para entrenar una IA que luego te cobrará por saludarte.

⚖️ Licencia y Atribución (Anti-Lucro)
Este script es Software Libre No Comercial. Su uso está sujeto a las siguientes condiciones:

    Prohibición de Venta: Este script es completamente gratuito. Queda terminantemente prohibido cobrar por este script, por su uso, o por su distribución. Si has pagado por él, te han estafado.
    Restricción Comercial: No se permite el uso de este código (ni de forma íntegra ni parcial) en ningún software, producto o servicio comercial, de pago o bajo suscripción.
    Atribución Obligatoria: Si compartes o modificas este trabajo, debes nombrar al autor original y proporcionar un enlace visible a este repositorio/trabajo original.
    Uso de Herramientas de Terceros: Este proyecto es posible gracias al trabajo increíble de las comunidades de:
        FFmpeg: ffmpeg.org (Bajo licencia LGPL/GPL).
        MKVToolNix: mkvtoolnix.download (Desarrollado por Moritz Bunkus, bajo licencia GPL).
        Nota: Este script es solo una interfaz (wrapper) para facilitar el uso de estas herramientas; el mérito de la compresión es suyo.

## ⚖️ Licencia y Atribución (Anti-Corporativa)

Este trabajo está bajo una licencia [Creative Commons Atribución-NoComercial-CompartirIgual 4.0 Internacional](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.es).

1.  **Reconocimiento:** Debes citar mi autoría y proporcionar un enlace a este repositorio original.
2.  **Uso No Comercial:** Este script es gratuito. Prohibida su venta o integración en software comercial/de pago. Las corporaciones no tienen permiso para lucrarse con este código.
3.  **Compartir Igual:** Si mejoras el script, debes liberar la mejora bajo esta misma licencia "rebelde".

---
### 🛠️ Créditos a las herramientas base
Este script es un "wrapper" que utiliza el motor de:
*   **FFmpeg**: [ffmpeg.org](https://ffmpeg.org) - El estándar de oro para el tratamiento de video (LGPL/GPL).
*   **MKVToolNix**: [mkvtoolnix.download](https://mkvtoolnix.download) - Por Moritz Bunkus (GPL).
Sin su trabajo open-source, este script no sería más que un archivo de texto vacío.
