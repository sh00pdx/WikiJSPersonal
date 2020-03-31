---
title: Utilidades  PHP
description: Trozos de Codigo
published: true
date: 2020-03-19T12:47:54.247Z
tags: 
---

# Funciones Varias
## Funcion para verificar si Array es multiArray
```php
function is_multi($array) {
		return (count($array) != count($array, 1));
}
```

---

## Funcion de Revisión
Recibe 
1. $arr: arreglo asociativo a revisar *(puede ser multiarray)*
> [
>'id' => '1',
> 'gl_nombre' => 'Juan Perez'
> ]
{.is-info}

2. $arr_revision: arreglo asociativo que se utilizara para revisar $arr *(puede ser multiarray)*
> [
>'id' => 'fnSoloNumeros',
> 'gl_nombre' => 'fnVacio'
> ]
{.is-info}
3. $arr_names: arreglo asociativo que contiene los nombres del campo que se le muestran al usuario. solo se utiliza si es que se espera recibir un script que contenga el mensaje para mostrar al usuario *(puede ser multiarray)*
> [
> 'gl_nombre' => 'Nombre Completo'
> ]
{.is-info}

El resto de las variables que recibe se utilizan en caso de que se necesite llamar recursivamente a la funcion, para no perder el contenido de las mismas.

Retorna
1. Array: contiene el mensaje de error, script a ejecutar, y booleano de error
> 
> [
> 			'msg_error' => $msg_error,
> 			'script' => $script, 
> 			'bo_error' => $bo_error
>				'result' => $arr
> ];
{.is-danger}


```php
function revision($arr, $arr_revision, $arr_names = [], $msg_error = '', $script = '', $bo_error = false){
	
		$resp = [
			'msg_error' => $msg_error,
			'script' => $script, 
			'bo_error' => $bo_error
		];
        
        $row_fnFechas = ['fnIsDate_ddmmyyyyConGuion'];

		foreach($arr_revision as $key => $value) {
			if(!is_array($value)){
				if($value($arr[$key],"")!=""){
					$msg_error .= $value($arr[$key], empty($arr_names[$key]) ? '' : $arr_names[$key]);
					$script .= "$('#div_".$key."').addClass('has-error text-danger');";
					$bo_error = true;
				}else{
                    $script = "$('#div_".$key."').removeClass('has-error text-danger');";
                    if(in_array($value, $row_fnFechas)){
                        $arr[$key] =  date('Y-m-d', strtotime( $arr[$key]));
                    }
				}
			}else{
				if(is_multi($arr[$key])){
					foreach ($arr[$key] as $k => &$v) {
						$arr_resp = revision($v,$value, $arr_names[$key], $msg_error, $script, $bo_error);
						$msg_error = $arr_resp['msg_error'];
						$script = $arr_resp['script'];
						$bo_error = $arr_resp['bo_error'];
					}
				}else{
					$arr_resp = revision($arr[$key],$value, $arr_names, $msg_error, $script, $bo_error);
					$msg_error = $arr_resp['msg_error'];
					$script = $arr_resp['script'];
					$bo_error = $arr_resp['bo_error'];
				}
			}
		}
	
		$resp['msg_error'] = $msg_error;
		$resp['script'] = $script;
		$resp['bo_error'] = $bo_error;
		$resp['result'] = $arr;
    
    return $resp;
}
```
## revisar Array de forma recursiva para sanitizar 

```php
function revisarArray($arr){
    $response = [];
    foreach($arr as $key => $value){
        if(!is_array($value)){
            $response[$key] = revisarString(trim($value));
        }else{
            $response[$key] = revisarArray($value);
        }
    }
    return $response;
}
```

## funcion SendFiles

Retorna un Booleano (true si fue correcto y false si fallo)

```php
function sendFile($destination, $user, $pass, $srcFile , $dstFile , $port = 22){
        
        $connection = ssh2_connect($destination, $port);
        ssh2_auth_password($connection, $user, $pass);
         
        $return = ssh2_scp_send($connection, $srcFile, $dstFile, 0644);
         
        ssh2_exec($connection, 'exit');
         
        return $return;
}
```

Esta funcion necesita instalar la dependencia de ssh2 para php 

```bash
wget https://github.com/Sean-Der/pecl-networking-ssh2/archive/php7.zip
tar xzvf php7.zip
yum install unzip
unzip php7.zip
cd pecl-networking-ssh2-php7/
phpize
./configure
make
make install
service httpd restart

yum install  php70-php-pecl-ssh2.x86_64

```
o siguiendo este tutorial 
https://www.php.net/manual/es/ssh2.installation.php
# Tips

## Variable Como Funcion
En PHP se puede utilizar una variable para guardar el nombre de una funcion y utilizarla para llamarla.

```php
function suma($a, $b){
	return $a + $b;
}

$foo = 'suma';

echo 'la suma de 1 + 3 es:'.$foo(1,3);
```
 
retornara:
> la suma de 1 + 3 es: 4
{.is-success}


---


## Recibiendo argumentos de forma dinamica

PHP permite a una funcion recibir argumentos de forma dinamica, quiere decir que si no se puede saber de forma certera cuantos argumentos recibira la funcion, php aun asi soportara

```php
function sum(...$numbers) {
    $acc = 0;
    foreach ($numbers as $n) {
        $acc += $n;
    }
    return $acc;
}

echo sum(1, 2, 3, 4);
```

## Ultimo dia de cualquier mes

```php
$fecha = new DateTime();
$fecha->modify('last day of this month');
echo $fecha->format('d');
```

## Formatear Fecha desde String

```php
$fecha = date('Y-m-d', strtotime('01-01-2019'));
```

## Sumar/Restar dias a Fecha
```php
#restar 30 dias 
$fecha = date('d-m-Y', strtotime('01-01-2020-30 days'));

#sumar 30 dias
$fecha = date('d-m-Y', strtotime('01-01-2020+30 days'));
```

## GROUP_CONCAT to Array
```php
$result -> "select GROUP_CONCAT(value) from table"

$arr = [];
while ($row = $conn->fetch_assoc($result)){
	$value = $row['value'];
}

$arr = explode(",",$value);
...

return $arr;
```

# PHP spreadsheet 
## celdas con valores numericos como texto en vez de numero

Excel transforma cualquier valor dentro de una celda que sol ocontenga numeros a una celda con valor numérico, con un máximo de 15 digitos, dejando el resto de los dígitos como 0

1234567890123456789 -> 1234567890123450000

para evitar esto es necesario formatear el valor de la celda y luego asignar el valor.

El unico problema aun a resolver es que si se edita el valor de la celda este cambia a numérico, y se pierde el formato.

Ejemplo:

```php


require_once $_SERVER['DOCUMENT_ROOT'].'/util/phpSpreadsheet/src/Bootstrap.php';

use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;


class CASPagoBanco{
	
	public function crearXlsxEgresos($id_periodoPago, $arr_pagosDeSocios){
		
		$response = array(
			'bo' 	=> true,
			'msg'	=> '',
			'file'	=> ''
		);
		
		$spreadsheet = new Spreadsheet();
		$spreadsheet->getProperties()->setCreator('CAS ERP')
			->setLastModifiedBy('Sistema CAS ERP')
			->setTitle('Egresos CAS')
			->setSubject('Pagos Santander')
			->setDescription('Este documento es para realizar el pago de banco Santander.')
			->setKeywords('Egresos CAS')
			->setCategory('Egresos');
		
		## Cabeceras segun formato CAS
		$spreadsheet->setActiveSheetIndex(0)
			->setCellValue('A1', 'Cta_origen')
			->setCellValue('B1', 'mon_origen')
			->setCellValue('C1', 'Cta_destino')
			->setCellValue('D1', 'mon_destino')
			->setCellValue('E1', 'Cod_banco')
			->setCellValue('F1', 'RUT benef.')
			->setCellValue('G1', 'nombre benef.')
			->setCellValue('H1', 'Mto Total')
			->setCellValue('I1', 'Glosa TEF')
			->setCellValue('J1', 'Correo')
			->setCellValue('K1', 'Glosa Correo')
			->setCellValue('L1', 'Glosa Cartola Cliente')
			->setCellValue('M1', 'Glosa Cartola Beneficiario');
		
		
		
		## FORMATO Y VALOR DE CADA CELDA
		## TODO: mejorar asignacion de formato a celda ya que al editar esta pierde el formato texto y muestra como formato numerico
		
		$nr_fila = 2;
		$spreadsheet->setActiveSheetIndex(0);
		foreach( $arr_pagosDeSocios as $pagoDeSocio ){
			$spreadsheet->getActiveSheet()->setCellValueExplicit('A'.$nr_fila, (string)$pagoDeSocio['gl_cuentaOrigen'], 				\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('B'.$nr_fila, (string)$pagoDeSocio['gl_monedaOrigen'], 				\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('C'.$nr_fila, (string)$pagoDeSocio['gl_cuentaDestino'], 				\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('D'.$nr_fila, (string)$pagoDeSocio['gl_monedaDestino'], 				\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('E'.$nr_fila, (string)$pagoDeSocio['gl_codigoBanco'], 					\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('F'.$nr_fila, (string)$pagoDeSocio['gl_rutSocio'], 					\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('G'.$nr_fila, (string)$pagoDeSocio['gl_nombreSocio'], 					\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('H'.$nr_fila, (string)$pagoDeSocio['nr_montoTotal'], 					\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('I'.$nr_fila, (string)$pagoDeSocio['gl_glosaTEF'], 					\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('J'.$nr_fila, (string)$pagoDeSocio['gl_correoSocio'], 					\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('K'.$nr_fila, (string)$pagoDeSocio['gl_glosaCorreo'],					\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('L'.$nr_fila, (string)$pagoDeSocio['gl_glosaCartolaCliente'], 			\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			$spreadsheet->getActiveSheet()->setCellValueExplicit('M'.$nr_fila, (string)$pagoDeSocio['gl_glosaCartolaBeneficiario'], 	\PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
		
			$nr_fila++;
		}
		
		## AJUSTE DE ANCHO PARA CADA COLUMNA
		$spreadsheet->getActiveSheet()->getColumnDimension('A')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('B')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('C')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('D')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('E')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('F')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('G')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('H')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('I')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('J')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('K')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('L')->setAutoSize(true);
		$spreadsheet->getActiveSheet()->getColumnDimension('M')->setAutoSize(true);
		
		## Nombre de documento
		$gl_nombreDocumento = 'EgresosCAS_PeriodoPago_'.$id_periodoPago;
		$gl_directorio = $_SERVER['DOCUMENT_ROOT'].'/upl/periodosPago/periodoPago_'.$id_periodoPago;
		
		$spreadsheet->getActiveSheet()->setTitle($gl_nombreDocumento);
		
		$spreadsheet->setActiveSheetIndex(0);
		
		## Descarga del archivo generado
		header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
		header('Content-Disposition: attachment;filename="'.$gl_nombreDocumento.'"');
		header('Cache-Control: max-age=0');
		## next line is IE9 compatibility requirement
		header('Cache-Control: max-age=1');
		
		## IE over SSL compatibility requirement
		header('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past
		header('Last-Modified: ' . gmdate('D, d M Y H:i:s') . ' GMT'); // always modified
		header('Cache-Control: cache, must-revalidate'); // HTTP/1.1
		header('Pragma: public'); // HTTP/1.0
		
		$writer = IOFactory::createWriter($spreadsheet, 'Xls');
		
		## verifico existencia de ruta
		## $gl_directorio = $_SERVER['DOCUMENT_ROOT'].'/upl/periodosPago/periodoPago_'.$id_periodoPago;
		$rutaDestino = $gl_directorio.'/';
		
		if (!file_exists($rutaDestino)) {
			mkdir($rutaDestino, 0777, true);
		}
			
		## guarda archivo en directorio
		$writer->save($gl_directorio.'/'.$gl_nombreDocumento.'.Xls');
		
		$response['file'] = $gl_nombreDocumento.'.Xls';
		
		return $response;
	}

}
```
# Enlaces Utiles.
https://www.phptoday.org/
https://hotexamples.com/

