
# ASW_Copia_Issues_Taiga_Backend_StaticSite

Project developed during the 6th Trimester for the Applications and Web Services (ASW) subject. (https://www.fib.upc.edu/en/studies/bachelors-degrees/bachelor-degree-informatics-engineering/curriculum/syllabus/ASW) at the FIB University in Barcelona. It was implemented using Ruby on Rails (RoR) as the backend framework and HTML + CSS for the static views, applying concepts and elements learned throughout the course.

The project has been done by:
* Adrián Ferrer
* Oscar Cerezo
* Jan Santos
* Francesc Pérez


The taiga related to the project to organize it: https://tree.taiga.io/project/jansanbas-it13a_project/timeline

The project is hosted in Render:
🔗 [https://waslab04-uscf.onrender.com/issues](https://waslab04-uscf.onrender.com/issues)
 

## Api calls

To test the API calls using the Swagger Editor and the api.yaml file located in the project, you will need an authentication key. This key can be obtained by accessing your profile through the site's views, where a unique API key is generated for every user on the platform. Without it, you will receive a 401/403 error.

![alt text](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/image1.png)
![alt text](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/iamge2.png)
![alt text](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/iamge3.png)


## User Manual

### How to test it 
There are two ways to test this project:

### ✅ Option 1: Use the deployed version on Render

You can directly test the app using this link (please note that Render may take 1–2 minutes to load initially):  
🔗 [https://waslab04-uscf.onrender.com/issues](https://waslab04-uscf.onrender.com/issues)

---

### 🖥️ Option 2: Run it locally on your machine (Linux instructions)

#### 1. Install Ruby 3.3.6

```bash
sudo apt-get update
sudo apt-get install -y curl gpg gnupg2 software-properties-common
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys \
  409B6B1796C275462A1703113804BB82D39DC0E3 \
  7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 3.3.6
rvm use 3.3.6 --default
echo "gem: --no-document" >> ~/.gemrc
gem install bundler -v 2.6.2

```

Configure git if not done before

```bash
git config --global user.name "YourGitHubUsername"
git config --global user.email your_github_email@example.com

```

Configure the ssh acces to Github

```bash
ssh-keygen -t ed25519 -C "your_github_email@example.com"
```

Press ENTER to all questions in command line
Then Execute

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

Copy the key starting with ssh-ed25519 that appears in the terminal.
Then go to GitHub > Settings > SSH and GPG keys, click "New SSH key", and paste it there.

Go to the project page on GitHub, click "Code", choose the SSH option, and copy the link. Then run:

```bash
git clone git@github.com:your_username/your_project.git
```


Accept the prompt by typing ```yes```

Set up the project

```bash
cd ASW_Copia_Issues_Taiga_Backend_StaticSite
bundle config set --local without 'production'
bundle install
bundle lock --add-platform x86_64-linux
```

Remove the encrypted credentials and create new ones

```bash
rm config/credentials.yml.enc
rm config/master.key
EDITOR="code --wait" bin/rails credentials:edit
```

Set up the database and run the web

```bash
rails db:drop db:create db:migrate db:seed 
rails server
```



## Images of the static site
![alt text](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/config.png)
![alt text](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/newIssue.png)
![alt text](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/Issues.png)
![alt text](https://github.com/it13aprojecte1/ASW_Copia_Issues_Taiga_Backend_StaticSite/blob/main/Profile.png)

## Project Summary

This project is a simplified version of Taiga's issue tracker, developed using Ruby on Rails, a framework we learned during the course.

It features static views for direct use, as well as API endpoints that enable a separate web application to consume its data (as demonstrated in another repository where we built a React-based web app). Development was conducted within Amazon Cloud9, leveraging the AWS Learning Academy service to familiarize ourselves with the AWS environment. We also utilized Amazon S3 for storing project images; however, this presented a challenge as the S3 keys from the AWS Academy server required renewal every 4 hours.
