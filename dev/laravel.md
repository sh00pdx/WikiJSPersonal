---
title: Tips Laravel
description: 
published: true
date: 2020-08-06T02:20:42.195Z
tags: 
---

# Tips de Laravel

## Librerias utiles
[reliese/laravel](https://github.com/reliese/laravel) es una libreria que te permite crear los Models desde una base de datos pre existente, [ver ejemplo](reliese)

## Setear Valor por defecto en where de model

```php
protected static function boot(){
        parent::boot();

        static::addGlobalScope('condicion', function (Builder $builder) {
            $builder->where('condicion', '=', 'valor');
        });
}
```