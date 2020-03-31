---
title: Google Chrome
description: 
published: true
date: 2020-01-10T00:03:10.483Z
tags: 
---

# Debug remoto con Google Chrome
## Configuración en Android
1. Abre configuración.
1. Desplázate hasta la parte inferior y selecciona Acerca del teléfono.
1. Desplázate hasta la parte inferior y presiona Número de compilación 7 veces.
1. Ya estarán habilitadas las opciones de desarrollador

## Configuración en Google Chrome
1. Abre DevTools.
2. En DevTools, haz clic en el menú principal menú principal y selecciona **More tools > Remote devices.**
![open-remote-devices.png](/open-remote-devices.png)
1. En DevTools, abre la pestaña Settings.
1. Asegúrate de que la casilla de verificación Discover USB devices esté habilitada.
![discover-usb-devices.png](/discover-usb-devices.png)

Conecta el dispositivo Android directamente al equipo de desarrollo con un cable USB. La primera vez que haces esto, normalmente, ves que DevTools detecta un dispositivo desconocido. Si ves un punto verde y el texto Connected debajo del nombre del modelo de tu dispositivo Android, significa que DevTools se ha conectado correctamente con el dispositivo.