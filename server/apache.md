---
title: Utils Apache
description: Tips para Apache
published: true
date: 2020-01-22T14:07:43.517Z
tags: 
---

# Tips	

## Configurar Enlace Simbolico

Puede estar dentro del ambito general de la configuracion de apache o dentro de virtualhost

        AliasMatch "^/pathWeb/(.*)$" "/path/folder/real/$1"
        AliasMatch "/pathWeb/" "/path/folder/real/"
        <Directory "/path/folder/real/">
                Require all granted
        </Directory>
