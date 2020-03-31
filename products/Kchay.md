---
title: Kchay Gestión Empresarial
description: 
published: true
date: 2020-01-22T16:10:42.592Z
tags: 
---

# Kchay Gestión Empresarial
## Puntos Pendientes
https://docs.google.com/spreadsheets/d/1WXOn_Q-H90EaPkf9MuvRsIkeE5z7PMN6y9lRMWCEfa8/edit?ts=5c2e5bb3#gid=1740988248

---
## Diagrama de Red de Solución Web Kchay

![erp.png](/erp.png =700x)

---

## Colores Funcionalidades Kchay
![kchay_colors_funcionalidades.jpg](/kchay_colors_funcionalidades.jpg =700x)

---

## Versiónes Logos Kchay
![kchay_logos_negro.png](/kchay_logos_negro.png =200x)![kchay_logos_blanco.png](/kchay_logos_blanco.png =200x)![kchay_logos_originales1.png](/kchay_logos_originales1.png =200x)

![kchay_logos_originales5.png](/kchay_logos_originales5.png =200x) ![kchay-blanco.png](/kchay-blanco.png =200x) ![kchay-color.png](/kchay-color.png =200x)

## Solucion para Dias de Licencias 
El problema surge porque existen meses con 28, 29, 30 y 31 dias y esto afecta al sistema para calcular los dias trabajados, ya que se utiliza la base de 30 dias mensuales de trabajo.
para resolverlo es necesario realizar el siguiente ejercicio

	30 - [dias reales del mes] = x 
	[dias calculados de faltas] + (x * (-1)) = [dias reales faltados(con base 30)]
  
Ejemplo
> 	licencia: 07-01-2020 -> 31-01-2020 = 25 dias faltados (6 dias trabajados)
{.is-info}

> el sistema lo intenta calcular como 30 - 25 = 5 (dias trabajados)
{.is-success}

la formula se aplicaria asi: 
> 	30 - 31 = (-1)
>   25 + (-1 * (-1)) = 24
>   30 - 24 = 6 (dias trabajados reales)
{.is-success}

```sql
SELECT (SUM(DATEDIFF('2019-02-28', '2019-02-01')+1))  + ((DATE_FORMAT(LAST_DAY('2019-02-05'), '%d') - 30 ) * -1)
```

> return 30
{.is-info}

  
# Version Bomberos
Modificacion del sistema para adaptarlo a los procesos de los cuerpos de bomberos de chile

## Modulo Presupuesto
Modulo encargado de gestionar el presupuesto anual de los cuerpos de bomberos
### Requerimientos Planificacion presupuesto
OLD:
El cuerpo de bomberos de valparaiso, requiere realizar modificacion al sistema de contabilidad y presupuesto, ya que en primera instancia no se incluyo en 
los requerimientos, por parte de ellos, el poder planificar el presupuesto para el año entrante. A raiz de esto se necesita modificar el modelo de datos y 
generar nuevas funcionalidades. 

El modelo de datos, del modulo de presupuesto, al dia de hoy funciona para un flujo especifico, que es el cargar de forma manual el presupuesto para el proximo 
año, ahora se necesita que cada Centro de Costo rellene el formulario de planificacion de presupuesto, indicando los articulos o items que requieren comprar y 
su monto aproximado.
Este formulario a su vez alimentara la propuesta de presupuesto, la cual debe ser modificable por el responsanble dentro de la organizacion. Y tambien sera 
el punto de comparacion para las futuras ordenes de adquisicion que envie cada centro de costo, de forma que si no existe en su planificacion no se pueda enviar 
la orden de adquisicion

Se requiere que un centro de costo solo vea las cuentas de presupuesto a la cual se le asignen permisos.

03/01/2020:
1. generar un formulario donde los voluntarios autorizados (de cada centro de costo) indiquen en que va a gastar el dinero para el siguiente año 
(siguiendo la planilla excel que mando latorre), de forma de poder planificar  los gastos y alimentar el presupuesto (peticion de presupuesto)

1. al momento de generar una solicitud de adquisicion debe indicar cual es el gasto vinculado (de los ingresados en la peticion de presupuesto)

1. la planificacion debe estar asociada a un centro de costo y a un item de presupuesto (cada centro de costo tiene uno o mas items de presupuesto asociados)

1. notificar solicitudes de adquisicion sin gestionar, segun el perfil de cada usuario

1. desde presupuesto ver el listado de gastos asociados a cada item de presupuesto 

### Modelo de Datos
![modelo_presupuesto.png](/modelo_presupuesto.png)

# TODO
- [ ] Recuperar Boletas de Honorarios desde SII
- [ ] Mover gestion de Usuarios a Clientes
- [ ] Rehacer Modulo de Proyectos
- [ ] Flujo de Cajas
- [ ] Resumen por estados de DTE
- [ ] Edicion Multiple de Dtes 
- [ ] No insertar Registros de asiento diario que vallan con valores 0
- [ ] Gestion de Pagos (conciliacion bancaria)
- [ ] Gestion de Pagos y Conbranzas (mostrar alertas y enviar correos electronicos)
- [ ] Busqueda por Serial Number en Modulo Pañol
- [ ] Busqueda por Serial Number en Inventario
- [ ] Facturacion Electronica 
- [x] Modulo POS