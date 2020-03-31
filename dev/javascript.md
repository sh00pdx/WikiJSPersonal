---
title: Utilidades Javascript
description: Trozos de codigo 
published: true
date: 2020-01-23T17:50:02.441Z
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
