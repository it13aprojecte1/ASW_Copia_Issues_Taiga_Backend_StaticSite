<p align="center">
  <a href="./README.md">English</a> •
  <a href="./README.es.md">Español</a>
</p>

# ASW Còpia Issues Taiga 🐞

**Sistema de seguiment de tasques inspirat en Taiga, desenvolupat amb Ruby on Rails, vistes estàtiques i una API REST.**

[![Ruby](https://img.shields.io/badge/Ruby-3.3.6-red.svg)](https://www.ruby-lang.org) [![Rails](https://img.shields.io/badge/Ruby_on_Rails-7.1-red.svg)](https://rubyonrails.org) [![Estat](https://img.shields.io/badge/estat-acabat-green.svg)](https://shields.io/)

---

### 📖 Taula de continguts

- [📌 Descripció del projecte](#-descripció-del-projecte)
- [🔑 Funcionalitats principals](#-funcionalitats-principals)
- [🌐 Demostració en línia](#-demostració-en-línia)
- [🛠️ Tecnologies utilitzades](#-tecnologies-utilitzades)
- [🚀 Com començar](#-com-començar)
  - [Requisits previs](#requisits-previs)
  - [Instal·lació i posada en marxa](#instal·lació-i-posada-en-marxa)
- [🧪 Test de l'API](#-test-de-lapi)
- [🖼️ Captures de pantalla](#-captures-de-pantalla)
- [👨‍💻 Equip de desenvolupament](#-equip-de-desenvolupament)

---

### 📌 Descripció del projecte

Aquest projecte va ser desenvolupat durant el 6è trimestre de l’assignatura *Aplicacions i Serveis Web (ASW)* a la [FIB - UPC](https://www.fib.upc.edu/ca/estudis/graus/grau-enginyeria-informatica/pla-d-estudis/assignatures/ASW).

És una versió simplificada del sistema de gestió de tasques Taiga, construït amb **Ruby on Rails** per al backend i **HTML/CSS** per a les vistes estàtiques. Inclou una interfície d’usuari i una API REST.

Tauler del projecte a Taiga:  
🔗 [Timeline del projecte a Taiga](https://tree.taiga.io/project/jansanbas-it13a_project/timeline)

---

### 🔑 Funcionalitats principals

- **Autenticació d'usuaris** amb clau API única.
- **Vistes estàtiques** per a llistats, creació i perfil d’usuari.
- **API RESTful** per a integració amb aplicacions externes.
- **Base de dades predefinida** per a proves ràpides.
- **Deploy a Render** amb dades persistents.

---

### 🌐 Demostració en línia

Prova el projecte en línia:  
🔗 [https://waslab04-uscf.onrender.com/issues](https://waslab04-uscf.onrender.com/issues)  
⚠️ Pot trigar 1–2 minuts a carregar inicialment.

---

### 🛠️ Tecnologies utilitzades

- **Backend**: Ruby on Rails
- **Frontend**: HTML, CSS (vistes estàtiques)
- **Deploy**: Render.com
- **Base de dades**: PostgreSQL
- **Entorn de desenvolupament**: AWS Cloud9 (via AWS Academy)

---

### 🚀 Com començar

#### Requisits previs

- Ruby 3.3.6
- Git
- Accés SSH configurat a GitHub

#### Instal·lació i posada en marxa (Linux)

```bash
# 1. Instal·lar Ruby i RVM
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
# 2. Configurar Git i SSH
git config --global user.name "ElTeuNom"
git config --global user.email elteucorreu@example.com
ssh-keygen -t ed25519 -C "elteucorreu@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub  # Afegeix-lo a GitHub
```

```bash
# 3. Clonar el repositori
git clone git@github.com:el_teu_usuari/ASW_Copia_Issues_Taiga_Backend_StaticSite.git
cd ASW_Copia_Issues_Taiga_Backend_StaticSite
```

```bash
# 4. Instal·lar dependències
bundle config set --local without 'production'
bundle install
bundle lock --add-platform x86_64-linux
```

```bash
# 5. Regenerar credencials
rm config/credentials.yml.enc
rm config/master.key
EDITOR="code --wait" bin/rails credentials:edit
```

```bash
# 6. Inicialitzar la base de dades
rails db:drop db:create db:migrate db:seed
rails server
```

---

### 🧪 Test de l'API

Pots provar l’API REST amb [Swagger Editor](https://editor.swagger.io/) usant el fitxer `api.yaml`.

> 🔐 **Autenticació necessària**:  
> Cada usuari té una clau API única accessible al seu perfil. Sense aquesta clau, obtindràs errors `401` o `403`.

---

### 🖼️ Captures de pantalla

**Vista de perfil**  
![Perfil](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/Profile.png)

**Llista de tasques**  
![Issues](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/Issues.png)

**Formulari de nova tasca**  
![Nova Tasca](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/newIssue.png)

**Fitxer de configuració**  
![Config](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/config.png)

---

### 👨‍💻 Equip de desenvolupament

**ASW — Aplicacions i Serveis Web, FIB - UPC**

**Membres de l’equip:**

- Adrián Ferrer  
- Oscar Cerezo  
- Jan Santos  
- Francesc Pérez
