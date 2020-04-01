---
title: Git
description: Comandos de git
published: true
date: 2020-03-31T12:53:34.829Z
tags: 
---

# Git

## Instalacion

### En el Servidor 

Instalar y habilitar git 
```bash
[root@git-server ~] yum install -y git
[root@git-server ~] echo "/bin/git-shell" >> /etc/shells
```

Agregar Usuario
```batch
[root@git-server ~]# useradd git
[root@git-server ~]# passwd git
```

Iniciar sesion con usuario git y configurar ambiente 
```batch
[root@git-server ~] su - git
[git@git-server ~]$ mkdir ~/repo
[git@git-server ~]$ cd ~/repo
[git@git-server repo]$ git init --bare --shared project1
```

### En el Cliente

Instalar git para el SO que se utiliza

y en la consola de git hacer lo siguiente

```batch
[ahmer@git-client ~]$ ssh-keygen
[ahmer@git-client ~]$ ssh-copy-id git@url-remote-git.com
[ahmer@git-client ~]$ ssh git@url-remote-git.com

[ahmer@git-client ~]$ git config --global user.name "username"
[ahmer@git-client ~]$ git config --global user.email "user@email.com"
```

## Preparar Ambientes

### En el Servidor

Para el ERP tenemos 2 servidores (qa, prd) con sus propios vhost por cada version del erp (bomberil y generica) por lo que necesitamos llevar ambas versiones a un solo repositorio git.

Los repositorios los guardaremos en /home/git/repo/

1. Creamos el repositorio inicial 
```batch
[root@APPERPQA repo]# mkdir erp
[root@APPERPQA repo]# chmod 777 erp 
[root@APPERPQA repo]# chown git:git erp
[root@APPERPQA repo]# cd erp
[root@APPERPQA repo]# git init 
```
2. Copiamos y añadimos al repositorio los archivos desde el vhost del erp generico

```batch
[root@APPERPQA repo]# cd erp
[root@APPERPQA erp]# sudo cp -R --preserve=ownership,context /var/www/html/vhost/dynworkKchay/* .
[root@APPERPQA erp]# git add .
[root@APPERPQA erp]# git commit -m "initial commit"
```
3. creamos una nueva rama para la version bomberil 

```batch
[root@APPERPQA erp]# git checkout -b master-cbv
[root@APPERPQA erp]# git rm --cached -r .
[root@APPERPQA erp]# git --work-tree=/var/www/html/vhost/cbvKchay/ add .
[root@APPERPQA erp]# git commit -m "initial commit cbv version"
```
Con esto conseguimos manejar ambas versiones del proyecto con un solo repositorio, cada rama representa a una version, con archivos totalmente indepedientes ( a menos que se decidan fusionar )

Ahora necesitamos poder enviar los archivos desde el repositorio al vhost correspondiente (cada rama representa un vhost)

Git tiene scripts, llamados hooks,  que se ejecutan al recibir ciertos comandos de propios de git,estos se encuentran en .git/hooks, entre ellos existe uno llamado  post-receive el cual nos servira para esta tarea.

4. Creamos el script *"post-receive"* 

```batch
[root@APPERPQA hooks]# nano post-receive
```
y le pegamos el siguiente codigo batch 

```batch
#!/bin/bash

echo "determining branch"

read refname

branch=${refname##*/}

echo "branch is $branch"


if [ "master" == "$branch" ]; then
    echo "checkout $branch"
    git --work-tree=/var/www/gitweb/erp checkout -f $branch
    #archivos a con su propia configuracion en qa, prd y local, son copiados con su nombre sin la extencion
    mv /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn.php.local /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn.php
    mv /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_sop.php.local /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_sop.php
    mv /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_cli.php.local /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_cli.php
fi

if [ "master-cbv" == "$branch" ]; then
    echo "checkout $branch"
    git --work-tree=/var/www/gitweb/cbv checkout -f $branch
    #archivos a con su propia configuracion en qa, prd y local, son copiados con su nombre sin la extencion
    mv /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn.php.local /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn.php
    mv /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_sop.php.local /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_sop.php
    mv /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_cli.php.local /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_cli.php
fi

echo "done"


```

con esto podemos detectar que branch es a la que se le esta haciendo push y asi saber a que vhost enviarlo sirve para qa y prd, hace falta un hook para cuando se genera un git reset (volver a un commit anterior)

solo nos falta darle permiso de ejecucon y el repositorio estara listo para ayudarnos en el deploy 
```batch
[root@APPERPQA hooks]# sudo chmod a+x post-receive 
```


### En el Cliente
Instalar el cliente de git descargandolo desde la [pagina oficial](https://git-scm.com/downloads) 

## Uso como Cliente 

### Configuracion del repositorio local


1. Una vez instalado Git es necesario clonar el repositorio al cliente 
```batch
git clone git@172.31.1.51:~/repo/kchay kchay
cd kchay
```
Esto dentro del directorio de REPOSITORIOS

2. Crearemos un Hook post-marge
 para eso es necesario ir a .git->hooks 
```shell
cd .git/hooks
nano post-merge
```
dentro del archivo se debe pegar el siguiente script y le damos permisos de ejecucion

```batch
#!/bin/sh; C:/Program\ Files/Git/usr/bin/sh.exe

# Get the current branch name
branch_name=$(git branch | grep "*" | sed "s/\* //")

# Get the name of the branch that was just merged
reflog_message=$(git reflog -1)
merged_branch_name=$(echo $reflog_message | cut -d" " -f 4 | sed "s/://")

# if the merged branch was master - don't do anything
if [[ $merged_branch_name = "master" ]]; then
    exit 0
fi

if [[ $merged_branch_name = "master-cbv" ]]; then
    exit 0
fi

# Begin output
echo " "
echo "Fusionando branch \"$merged_branch_name\" en \"$branch_name\". "


if [ "dev-master" == "$branch_name" ]; then
    echo "checkout $branch_name"
    git --work-tree='/c/xampp/htdocs/vhost/dynworkKchay/' checkout -f $branch_name
    #archivos a con su propia configuracion en qa, prd y local, son copiados con su nombre sin la extencion
    mv /c/xampp/htdocs/vhost/dynworkKchay/dac/class.conn.php.local /c/xampp/htdocs/vhost/dynworkKchay/dac/class.conn.php
    mv /c/xampp/htdocs/vhost/dynworkKchay/dac/class.conn_sop.php.local /c/xampp/htdocs/vhost/dynworkKchay/dac/class.conn_sop.php
    mv /c/xampp/htdocs/vhost/dynworkKchay/dac/class.conn_cli.php.local /c/xampp/htdocs/vhost/dynworkKchay/dac/class.conn_cli.php
fi

if [ "dev-master-cbv" == "$branch_name" ]; then
    echo "checkout $branch_name"
    git --work-tree='/c/xampp/htdocs/vhost/cbvKchay/' checkout -f $branch_name
    #archivos a con su propia configuracion en qa, prd y local, son copiados con su nombre sin la extencion
    mv /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn.php.local /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn.php
    mv /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_sop.php.local /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_sop.php
    mv /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_cli.php.local /c/xampp/htdocs/vhost/cbvKchay/dac/class.conn_cli.php
fi

# Ask the question
#read -p "Estas seguro de borrar \"$merged_branch_name\" branch local? (y/N) " answer

# Check if the answer is a single lowercase Y
#if [[ "$answer" == "y" ]]; then
#if ask "Estas seguro de borrar \"$merged_branch_name\" branch local? (y/N) "; then
#    # Delete the local branch
#    echo "Borrando branch local \"$merged_branch_name\""
#    git branch -d $merged_branch_name
#
#   # read -p "Estas seguro de borrar \"$merged_branch_name\" branch remote? (y/N) " answer
#
#    #if [[ "$answer" == "y" ]]; then
#    if ask "Estas seguro de borrar \"$merged_branch_name\" branch remote? (y/N) "; then
#    # Delete the remote branch
#        echo "Deleting remote branch"
#        git push origin --delete $merged_branch_name
#    fi
#
#    exit 1
#else
#    echo "No se borrara \"$merged_branch_name\" branch"
#fi
```

```
chmod a+x post-merge
```

este Script es suceptible a mejoras, por lo cual recomiendo estar atento a los cambios.

****

***Como ejemplo pondremos la configuracion para kchay erp***

El flujo a seguir para el desarrollo dentro de kchay es: 
1. Crear una nueva Rama apartir de la version del codigo que se utilizara (master [dynworkKchay] y master-cbv [cbvKchay]), por ejemplo si se trabajara en muchas funcionalidades durante el dia el nombre de la nueva rama puede ser fix24032020, o se puede poner el nombre de la funcionalidad especifica a trabajar

2. una vez que se desarrolle la funcionalidad se debe realizar un commit en la rama 
3. despues del commit se debe cambiar a la rama master correspondiente y realizar un merge, esta accion ejecutara el hook post-merge que realizara el paso de los archivos al vhost.

***con esto estamos listos para poder trabajar de forma local***
****

## Plugins

VSCode: 
+ **Git Graph**: permite ver de forma grafica el arbol de ramas que se va construyendo y manejarlo de forma mas grafica.
+ **GitLens — Git supercharged**: Permite ver dentro del mismo archivo linea por linea quien y cuando se hicieron las modificaciones, incluye un navegador grafico por cada commit que se ha realizado, entre otras cosas.
+ **Git Extension Pack**: permite manejar de forma rapida los comandos mas utilizados de git (commit, branch, merge, push, pull, entre otros)
 **********