<p align="center">
  <a href="./README.es.md">Español</a> •
  <a href="./README.ca.md">Català</a>
</p>

# ASW Copia Issues Taiga 🐞

**Simplified issue tracker inspired by Taiga, developed in Ruby on Rails with static views and REST API integration.**

[![Ruby](https://img.shields.io/badge/Ruby-3.3.6-red.svg)](https://www.ruby-lang.org) [![Rails](https://img.shields.io/badge/Ruby_on_Rails-7.1-red.svg)](https://rubyonrails.org) [![Status](https://img.shields.io/badge/status-finished-green.svg)](https://shields.io/)

---

### 📖 Table of Contents

- [📝 Project Description](#-project-description)
- [🧩 Key Features](#-key-features)
- [🌐 Live Demo](#-live-demo)
- [🔧 Tech Stack](#-tech-stack)
- [🚀 Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation and Setup](#installation-and-setup)
- [🧪 API Testing](#-api-testing)
- [🖼️ Screenshots](#-screenshots)
- [👨‍💻 Development Team](#-development-team)

---

### 📝 Project Description

This project was developed during the 6th trimester of the *Applications and Web Services (ASW)* course at [FIB - UPC](https://www.fib.upc.edu/en/studies/bachelors-degrees/bachelor-degree-informatics-engineering/curriculum/syllabus/ASW).

It is a simplified clone of the Taiga issue tracking system, built using **Ruby on Rails** for the backend and **HTML/CSS** for static views. The application includes both a user-facing interface and a RESTful API.

Project Taiga board:  
🔗 [Taiga Timeline](https://tree.taiga.io/project/jansanbas-it13a_project/timeline)

---

### 🧩 Key Features

- **User Authentication** with unique API key generation.
- **Static Views** for issues, user profiles, and issue creation.
- **RESTful API** for full integration with external applications.
- **Database Seeding** for quick testing.
- **Deployed to Render** with persistent data.

---

### 🌐 Live Demo

You can test the project online (CURRENTLY NOT WORKING, YOU CAN WATCH THE IMAGES BELOW TO GET AN IDEA HOW IS IT DONE):  
🔗 [https://waslab04-uscf.onrender.com/issues](https://waslab04-uscf.onrender.com/issues)  
⚠️ Note: Render may take 1–2 minutes to spin up the server.

---

### 🔧 Tech Stack

- **Backend**: Ruby on Rails
- **Frontend**: HTML, CSS (static)
- **Deployment**: Render.com
- **Database**: PostgreSQL
- **Development Env**: AWS Cloud9 via AWS Academy

---

### 🚀 Getting Started

#### Prerequisites

- Ruby 3.3.6
- Git
- SSH access configured with GitHub

#### Installation and Setup (Linux)

```bash
# 1. Install Ruby and RVM
sudo apt-get update
sudo apt-get install -y curl gpg gnupg2 software-properties-common
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys \
  409B6B1796C275462A1703113804BB82D39DC0E3 \
  7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 3.3.6
rvm use 3.3.6 --default
gem install bundler -v 2.6.2
```

```bash
# 2. Git & SSH setup
git config --global user.name "YourGitHubUsername"
git config --global user.email your_email@example.com
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub  # Add this to GitHub SSH keys
```

```bash
# 3. Clone the repository
git clone git@github.com:your_username/ASW_Copia_Issues_Taiga_Backend_StaticSite.git
cd ASW_Copia_Issues_Taiga_Backend_StaticSite
```

```bash
# 4. Install dependencies and setup
bundle config set --local without 'production'
bundle install
bundle lock --add-platform x86_64-linux
```

```bash
# 5. Regenerate credentials
rm config/credentials.yml.enc
rm config/master.key
EDITOR="code --wait" bin/rails credentials:edit
```

```bash
# 6. Setup the database
rails db:drop db:create db:migrate db:seed
rails server
```

---

### 🧪 API Testing

You can test the RESTful API using [Swagger Editor](https://editor.swagger.io/) with the provided `api.yaml` file.

> 🔐 **Authentication Required**:  
> Each user has a unique API key available in their profile view. Without it, you'll get `401` or `403` errors.

---

### 🖼️ Screenshots

**Profile View**  
![Profile](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/Profile.png)

**Issue List**  
![Issues](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/Issues.png)

**New Issue Form**  
![New Issue](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/newIssue.png)

**Configuration File**  
![Config](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/config.png)

---

### 👨‍💻 Development Team

**ASW — Aplicaciones y Servicios Web, FIB - UPC**

**Group Members:**

- Adrián Ferrer  
- Oscar Cerezo  
- Jan Santos  
- Francesc Pérez
