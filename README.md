Taiga Issues Clone amb Ruby on Rails de

Students:

* Adrián Ferrer

* Oscar Cerezo

* Jan Santos

* Francesc Pérez

####
Implementación de GitHub OAuth

Cuando estemos listos para implementar la autenticación con GitHub (implentar encima de la gem Devise que ya existe)

1. Descomentar las gemas de OmniAuth en el Gemfile
2. Ejecutar `bundle install`
3. Generar la migración para añadir `provider` y `uid` a usuarios
4. Actualizar el modelo User con el módulo omniauthable
5. Crear el controlador de callbacks de OmniAuth
6. Actualizar las rutas de Devise
7. Configurar las claves de GitHub en variables de entorno
8. Ajustar las vistas para incluir el botón de GitHub
9. Probar el flujo completo de autenticación

Link Render: https://waslab04-5b3h.onrender.com/
