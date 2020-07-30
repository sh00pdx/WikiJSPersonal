---
title: Utilidades Javascript
description: Trozos de codigo
published: true
date: 2020-07-30T18:23:02.839Z
tags: 
---

# Como se hace
## Verificar CheckBox

```javascript
if ( $( 'selector' ).is(':checked') ) {
   check = true;
}else{
   check = false;
}
```

## Opción de Excel y PDF en DataTable()
```javascript
 $('#table').DataTable({
			stateSave: true,
			order: [ 2, 'desc' ],
			pageLength: 50,
			select:{
				    	responsive: true,
				    	dom: '<\"html5buttons\"B>lTfgitp',
				    	buttons: [
				    		{extend: 'excel', title: 'ExampleFile',
                 		exportOptions: {
                           columns: ':visible:not(:last-child)',
                           		format: {
                                 body: function ( data, row, column, node ) {
                                 return isNaN(data) ? data.replace(/(&nbsp;<([^>]+)>)/ig, '') : data.replace('.', ',');
                                   		}
                                   }
                }
             },
				    	  {extend: 'print',
				    			customize: function (win){
				    				$(win.document.body).addClass('white-bg');
				    				$(win.document.body).css('font-size', '10px');
				    				$(win.document.body).find('table').addClass('compact').css('font-size', 'inherit');
				    			}
				    		}
				    	]
});
```

---

## Deshabilitar Chosen en vista mobile
1. Se comenta (Linea: 170 app):
```javascript
 }, AbstractChosen.browser_is_supported = function() {
            return "Microsoft Internet Explorer" === window.navigator.appName ? document.documentMode >= 8 : /iP(od|hone)/i.test(window.navigator.userAgent) ? !1 : /Android/i.test(window.navigator.userAgent) && /Mobile/i.test(window.navigator.userAgent) ? !1 : !0
} 
```
2. Se reemplaza por:
```javascript
 }, AbstractChosen.browser_is_supported = function() {
  if (window.navigator.appName === "Microsoft Internet Explorer") {
		return document.documentMode >= 8;
	}
	if (/iP(od|hone)/i.test(window.navigator.userAgent)) {
		return false;
	}
	if (/Android/i.test(window.navigator.userAgent)) {
			if (/Mobile/i.test(window.navigator.userAgent)) {
				return false;
			}
	}
	return true;
}
```
## Mover Scroll a elemento especifico
Esta funcion alineara la parte superior del elemento con el borde superior de la pantalla, si recibe true, si recibe false lo alineara con las partes inferiores
```javascript
document.getElementById('id_selector').scrollIntoView(bool);
```

## Centrar Elemento en la pantalla
Esta funcion recibe el id del elemento a centrar en pantalla
```javascript
function centerScroll (elem) {
    var element = document.getElementById('tr_198');
    var elementRect = element.getBoundingClientRect();
    var absoluteElementTop = elementRect.top + window.pageYOffset;
    var middle = absoluteElementTop - (window.innerHeight / 2);
    window.scrollTo(0, middle);
};
```

## Saber si un Elemento esta Visible
```javascript
function esVisible(elem){
    /* Ventana de Visualización*/
    var posTopView = $(window).scrollTop();
    var posButView = posTopView + $(window).height();
    /* Elemento a validar*/
    var elemTop = $(elem).offset().top;
    var elemBottom = elemTop + $(elem).outerHeight();
    /* Comparamos los dos valores tanto del elemento como de la ventana*/
    return ((elemBottom < posButView && elemBottom > posTopView) || (elemTop >posTopView && elemTop< posButView));
}

$("button").on("click", function() {
  	var ele = document.getElementById('holamundo');
  	console.log(esVisible(ele));
});
```

## crear shortcuts
Se necesita la libreria keymaster.js (https://github.com/madrobby/keymaster)

```javascript
key.setScope('issues'); // se seta el Scope en el cual funcionara el shorcut

key('⌘+a, ctrl+a', 'issues', function(){ 
			window.setTimeout(function () {
				$('#btn_nextRowAsientoTr').click();
				$('[data-toggle=\"tooltip\"]').tooltip('hide');
			},500);
			return false;
}); // se setean las combinaciones de teclas que aceptara y la funcion que realizara

key('⌘+r, ctrl+r', 'issues', function(){ 
			$('#btn_replicarDetalle').click();
			$('[data-toggle=\"tooltip\"]').tooltip('hide');
			return false;
});// se setean las combinaciones de teclas que aceptara y la funcion que realizara
```

## crear tooltip que se muestren al precionar un boton 
Ideal para combinarlo con los shurcuts

	<button 
		type="button" 
		class="btn btn-primary btn-sm" 
		id="btn_nextRowAsientoTr" 
		data-trigger="manual" data-toggle="tooltip" 
    data-container=".modal-body" 
    data-placement="top" data-html="true" 
    data-title="<span>CTRL+A <br> <small>(añadir linea)</small</span>"
		onclick="
			jaxon_addRowAsientoTr({$indice})
			$(this).attr('disabled','true');
    "
		>
 			A&ntilde;adir&nbsp;Linea
	</button>

```javascript
$(document).keydown(function(){ 
			if (event.ctrlKey) { // se ejecutara cuando la tecla presionada sea ctrl
				$('[data-toggle=\"tooltip\"]').tooltip('show');
				console.log('mostrar popover');
			}
});
```

## Templetas literales.
Haciendo uso de el caracter "Grave accent" y "${}" se puede "concatenar" texto con variables o funciones javascript

* Ejemplo
```javascript
var nombre = 'Juan';

console.log(`Hola ${nombre}`);
// output: Hola Juan
```

## Funciones de Flecha
Se escribe una funcion como que fuera una variable.

* Formar Larga
```javascript
let saludar = (nombre) => {
	return `Hola ${nombre}`;
}
```

* Forma Corta
```javascript
let saludar = (nombre) =>  `Hola ${nombre}`;
```

## Callbacks
Creando callbacks personalizados.

* ejemplo
```javascript
let empleados = [
    {
        id: 1,
        nombre: 'Marcos'
    },{
        id: 2,
        nombre: 'Felipe'
    },{
        id: 3,
        nombre: 'Francisco'
    }
];

let getEmpleadoById = (id, callback) => {
    var empleadoDB = empleados.find( empleado => id === empleado.id);

    if(!empleadoDB){
        //ERROR
        // se le pasa solo un parametro (el error)
        callback(`No se ha encontrado el empleado con id ${id}`);
    }else{
    		// se le pasa el primer parametro en null para indicar que no existe error y el segundo parametro que es el objeto.
        callback(null, empleadoDB);
    }
};

//Llamamos a la funcion getEmpleado que ejecutara un callbacks con funcion anonima de flechas.

getEmpleadoById(
    3, 
    (err ,empleadoDB) => {
        if(err){
            return console.log(err);
        }
        console.log(empleadoDB)
})

// llamando a getEmpleadosById con funcion anonima normal
getEmpleadoById(3, function (err ,empleadoDB) {
    if(err){
        return console.log(err);
    }

    getSalarioByEmpleado(empleadoDB, (err, empleado) =>{
        if(err){
            return console.log(err);
        }
        console.log(empleado);
    })
})
```

## Promesas
* Teniendo
```javascript
let empleados = [
    {
        id: 1,
        nombre: 'Marcos'
    },{
        id: 2,
        nombre: 'Felipe'
    },{
        id: 3,
        nombre: 'Francisco'
    }
];
```
* Se crea la promesa para buscar empleados 
```javascript
	let getEmpleadoById = (id) => {
    
    //return new Promise( function (resolve, reject){
    //});

    return new Promise( (resolve, reject) => {
        var empleadoDB = empleados.find( empleado => id === empleado.id);

        if(!empleadoDB){
            //ERROR
            reject(`No se ha encontrado el empleado con id ${id}`);
        }else{
            resolve(empleadoDB);
        }
    });
    
};

```
* Se llama a la promesa
```javascript
getEmpleadoById(10).then(
    //funcion en caso de ejecucion correcta
    (empleado) => console.log(empleado),
    //funcion en caso de error
    (err) => console.log(err)
);
```

## Promesas Encadenadas

* Teniendo 
```javascript
let empleados = [
    {
        id: 1,
        nombre: 'Marcos'
    },{
        id: 2,
        nombre: 'Felipe'
    },{
        id: 3,
        nombre: 'Francisco'
    }
];

let salarios = [
    {
        id: 1,
        salario: 100000
    },{
        id: 2,
        salario: 1000
    }
];
```

* Se crea la promesa para buscar empleados y buscar sueldos segun empleados
```javascript
	let getEmpleadoById = (id) => {
    return new Promise( (resolve, reject) => {
        var empleadoDB = empleados.find( empleado => id === empleado.id);
        if(!empleadoDB){
            //ERROR
            reject(`No se ha encontrado el empleado con id ${id}`);
        }else{
            resolve(empleadoDB);
        }
    });
};

let getSalarioByEmpleado = (empleado) => {
    return new Promise( (resolve, reject) => {
let salarioEmpleado = salarios.find(salario => salario.id === empleado.id);
    
        if(!salarioEmpleado){
            reject(`No se ha encontrado Salario para el empleado ${empleado.nombre}`)
        }else{
            empleado.salario = salarioEmpleado.salario;
            resolve(empleado);
        }
    });
};
```
* Se llama a la promesa
```javascript

getEmpleadoById(3).then(
		// ejecuta la accion del resolve de la primera promesa, retornando la llamada a la segunda promesa.
    empleado => { return getSalarioByEmpleado(empleado); }
).then(
		// se ejecuta la accion del resolve de la segunda promesa
    (empleadoSalario) => {console.log(empleadoSalario)}
).catch(
		// se programa el catch el cual resolvera el error de cualquiera promesa llamada anteriormente
    (err) => console.log(err)
);
```

## Tipos de Redondeo

### Redondeo


Math.round() redondeará el valor al entero más cercano usando la mitad redondeada hacia arriba para romper los lazos.

```javascript
var a = Math.round(2.3);       // a is now 2  
var b = Math.round(2.7);       // b is now 3
var c = Math.round(2.5);       // c is now 3
```
Pero

```javascript
var c = Math.round(-2.7);       // c is now -3
var c = Math.round(-2.5);       // c is now -2
```

Observe cómo -2.5 se redondea a -2 . Esto se debe a que los valores intermedios siempre se redondean hacia arriba, es decir, se redondean al entero con el siguiente valor más alto.

### Redondeando hacia arriba


Math.ceil() redondeará el valor hacia arriba.

```javascript
var a = Math.ceil(2.3);        // a is now 3
var b = Math.ceil(2.7);        // b is now 3
```

ceil a un número negativo se redondeará hacia cero

```javascript
var c = Math.ceil(-1.1);       // c is now 1
```

### Redondeando hacia abajo


Math.floor() redondeará el valor hacia abajo.

```javascript
var a = Math.floor(2.3);        // a is now 2
var b = Math.floor(2.7);        // b is now 2
```

floor coloca un número negativo, se redondeará lejos de cero.

```javascript
var c = Math.floor(-1.1);       // c is now -1
```

### Truncando


Advertencia : el uso de operadores bitwise (excepto >>> ) solo se aplica a los números entre -2147483649 y 2147483648 .

```
2.3  | 0;                       // 2 (floor)
-2.3 | 0;                       // -2 (ceil)
NaN  | 0;                       // 0
```


Math.trunc()

```javascript
Math.trunc(2.3);                // 2 (floor)
Math.trunc(-2.3);               // -2 (ceil)
Math.trunc(2147483648.1);       // 2147483648 (floor)
Math.trunc(-2147483649.1);      // -2147483649 (ceil)
Math.trunc(NaN);                // NaN
```

### Redondeo a decimales

Math.floor , Math.ceil() y Math.round() se pueden usar para redondear a un número de decimales

Para redondear a 2 decimales:

```javascript
 var myNum = 2/3;               // 0.6666666666666666
 var multiplier = 100;
 var a = Math.round(myNum * multiplier) / multiplier;  // 0.67
 var b = Math.ceil (myNum * multiplier) / multiplier;  // 0.67
 var c = Math.floor(myNum * multiplier) / multiplier;  // 0.66
```

También puede redondear a un número de dígitos:

```javascript
 var myNum = 10000/3;           // 3333.3333333333335
 var multiplier = 1/100;
 var a = Math.round(myNum * multiplier) / multiplier;  // 3300
 var b = Math.ceil (myNum * multiplier) / multiplier;  // 3400
 var c = Math.floor(myNum * multiplier) / multiplier;  // 3300
```

Como una función más utilizable:

```javascript
 // value is the value to round
 // places if positive the number of decimal places to round to
 // places if negative the number of digits to round to
 function roundTo(value, places){
     var power = Math.pow(10, places);
     return Math.round(value * power) / power;
 }
 var myNum = 10000/3;    // 3333.3333333333335
 roundTo(myNum, 2);  // 3333.33
 roundTo(myNum, 0);  // 3333
 roundTo(myNum, -2); // 3300
```

Y las variantes para ceil y floor :

```javascript
 function ceilTo(value, places){
     var power = Math.pow(10, places);
     return Math.ceil(value * power) / power;
 }
 function floorTo(value, places){
     var power = Math.pow(10, places);
     return Math.floor(value * power) / power;
 }
```
## Recorrer un Json

Teniendo un Json con formato 
```json
[{key : value, key2 : value2, key3 : value3, key : { key : value, key2 : value2, key3 : value3} },{key : value, key2 : value2, key3 : value3,...}]
```

se recorre 

```javascript
let items = Object.values(data);
items.map(value => {
	 console.log(value.key);
   console.log(value.key2);
   console.log(value.key3);
});
```
# TIPS
## Debug DataTable()
Escribir en consola del Navegador
```javascript
var n = document.createElement('script');
n.setAttribute('language', 'JavaScript');
n.setAttribute('src', 'https://debug.datatables.net/debug.js');
document.body.appendChild(n);
```
## Solución DataTable() fixedColumn
Superposición de la tabla y/o columna.(soluciona solo cuando se utiliza en una columna izquierda)
```javascript
//Option
fixedColumns: true

$('.DTFC_LeftBodyLiner').css('background-color','#fff'); //Fondo Blanco
$('.DTFC_LeftBodyLiner').css('top','-8px'); //Se sube la columna
```
