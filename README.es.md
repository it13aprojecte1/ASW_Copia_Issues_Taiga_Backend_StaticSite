
<p align="center">
  <a href="./README.md">English</a> •
  <a href="./README.es.md">Español</a>
</p>

# ASW Copia Issues Taiga 🐞

**Sistema de seguimiento de tareas inspirado en Taiga, desarrollado con Ruby on Rails, vistas estáticas y una API REST.**

[![Ruby](https://img.shields.io/badge/Ruby-3.3.6-red.svg)](https://www.ruby-lang.org) [![Rails](https://img.shields.io/badge/Ruby_on_Rails-7.1-red.svg)](https://rubyonrails.org) [![Estado](https://img.shields.io/badge/estado-terminado-green.svg)](https://shields.io/)

---

### 📖 Tabla de contenidos

- [📌 Descripción del proyecto](#-descripción-del-proyecto)
- [🔑 Funcionalidades principales](#-funcionalidades-principales)
- [🌐 Demostración en línea](#-demostración-en-línea)
- [🛠️ Tecnologías utilizadas](#-tecnologías-utilizadas)
- [🚀 Cómo empezar](#-cómo-empezar)
  - [Requisitos previos](#requisitos-previos)
  - [Instalación y puesta en marcha](#instalación-y-puesta-en-marcha)
- [🧪 Test de la API](#-test-de-la-api)
- [🖼️ Capturas de pantalla](#-capturas-de-pantalla)
- [👨‍💻 Equipo de desarrollo](#-equipo-de-desarrollo)

---

### 📌 Descripción del proyecto

Este proyecto fue desarrollado durante el 6º trimestre de la asignatura *Aplicaciones y Servicios Web (ASW)* en la [FIB - UPC](https://www.fib.upc.edu/ca/estudis/graus/grau-enginyeria-informatica/pla-d-estudis/assignatures/ASW).

Es una versión simplificada del sistema de gestión de tareas Taiga, construida con **Ruby on Rails** para el backend y **HTML/CSS** para las vistas estáticas. Incluye una interfaz de usuario y una API REST.

Tablero del proyecto en Taiga:  
🔗 [Timeline del proyecto en Taiga](https://tree.taiga.io/project/jansanbas-it13a_project/timeline)

---

### 🔑 Funcionalidades principales

- **Autenticación de usuarios** con clave API única.
- **Vistas estáticas** para listados, creación y perfil de usuario.
- **API RESTful** para integración con aplicaciones externas.
- **Base de datos predefinida** para pruebas rápidas.
- **Deploy en Render** con datos persistentes.

---

### 🌐 Demostración en línea

Prueba el proyecto en línea:  
🔗 [https://waslab04-uscf.onrender.com/issues](https://waslab04-uscf.onrender.com/issues)  
⚠️ Puede tardar 1–2 minutos en cargar inicialmente.

---

### 🛠️ Tecnologías utilizadas

- **Backend**: Ruby on Rails
- **Frontend**: HTML, CSS (vistas estáticas)
- **Deploy**: Render.com
- **Base de datos**: PostgreSQL
- **Entorno de desarrollo**: AWS Cloud9 (vía AWS Academy)

---

### 🚀 Cómo empezar

#### Requisitos previos

- Ruby 3.3.6
- Git
- Acceso SSH configurado en GitHub

#### Instalación y puesta en marcha (Linux)

```bash
# 1. Instalar Ruby y RVM
sudo apt-get update
sudo apt-get install -y curl gpg gnupg2 software-properties-common
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys   409B6B1796C275462A1703113804BB82D39DC0E3   7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 3.3.6
rvm use 3.3.6 --default
gem install bundler -v 2.6.2
```

```bash
# 2. Configurar Git y SSH
git config --global user.name "TuNombre"
git config --global user.email tucorreo@example.com
ssh-keygen -t ed25519 -C "tucorreo@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub  # Añádelo a GitHub
```

```bash
# 3. Clonar el repositorio
git clone git@github.com:tu_usuario/ASW_Copia_Issues_Taiga_Backend_StaticSite.git
cd ASW_Copia_Issues_Taiga_Backend_StaticSite
```

```bash
# 4. Instalar dependencias
bundle config set --local without 'production'
bundle install
bundle lock --add-platform x86_64-linux
```

```bash
# 5. Regenerar credenciales
rm config/credentials.yml.enc
rm config/master.key
EDITOR="code --wait" bin/rails credentials:edit
```

```bash
# 6. Inicializar la base de datos
rails db:drop db:create db:migrate db:seed
rails server
```

---

### 🧪 Test de la API

Puedes probar la API REST con [Swagger Editor](https://editor.swagger.io/) usando el archivo `api.yaml`.

> 🔐 **Autenticación necesaria**:  
> Cada usuario tiene una clave API única accesible en su perfil. Sin esta clave, obtendrás errores `401` o `403`.

---

### 🖼️ Capturas de pantalla

**Vista de perfil**  
![Perfil](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/Profile.png)

**Lista de tareas**  
![Issues](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/Issues.png)

**Formulario de nueva tarea**  
![Nueva Tarea](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/newIssue.png)

**Archivo de configuración**  
![Config](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/config.png)

---

### 👨‍💻 Equipo de desarrollo

**ASW — Aplicaciones y Servicios Web, FIB - UPC**

**Miembros del equipo:**

- Adrián Ferrer  
- Oscar Cerezo  
- Jan Santos  
- Francesc Pérez
