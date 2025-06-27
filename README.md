
# ASW_Copia_Issues_Taiga_Backend_StaticSite

Project developed during the 6th Trimester for the Applications and Web Services (ASW) subject. (https://www.fib.upc.edu/en/studies/bachelors-degrees/bachelor-degree-informatics-engineering/curriculum/syllabus/ASW) at the FIB University in Barcelona. It was implemented using Ruby on Rails (RoR) as the backend framework and HTML + CSS for the static views, applying concepts and elements learned throughout the course.

The project has been done by:
* Adrián Ferrer
* Oscar Cerezo
* Jan Santos
* Francesc Pérez


The taiga related to the project to organize it: https://tree.taiga.io/project/jansanbas-it13a_project/timeline

The project is hosted in Render:
 https://waslab04-p1hk.onrender.com     



## Api calls

To test the API calls using the Swagger Editor and the api.yaml file located in the project, you will need an authentication key. This key can be obtained by accessing your profile through the site's views, where a unique API key is generated for every user on the platform. Without it, you will receive a 401/403 error.


## User Manual

### How to test it 
* There are 2 ways of testing it, first one is to use this link where the page is aleready deployed in render ( take into account that render may take 1-2 minutes to open) "https://waslab04-p1hk.onrender.com"

The second one is to host it yourself in your machine, to do that you need to follow the next steps(windows):

* Download the last version of ruby if you don't have it already installed (https://www.ruby-lang.org/en/downloads/) and also download 
* Download from "https://sqlite.org/download.html" From the "Precompiled Binaries for Windows", donwload "sqlite-dll-win-x64-3500100.zip" (current version when writing this), we use sqlite in the development environment.
* Paste the sqlite3.dll and sqlite3.def into the "C:\Windows\System32" folder
* Clone the repo in your machine
* "bundle config set --local without 'production'"
* Install dependencies with "Bundle Install"
* Install rails "gem install rails -v 8.0.1"
* Create the development DataBase with "rails db:create", "rails db:migrate" and optionaly "rails db:seed" to add default values to the database.
 
### How to make changes
* Clone the repo and make the changes with the unity editor version 6.0 or above.




## Images of the static site
## Project Summary

This project is a simplified version of Taiga's issue tracker, developed using Ruby on Rails, a framework we learned during the course.

It features static views for direct use, as well as API endpoints that enable a separate web application to consume its data (as demonstrated in another repository where we built a React-based web app). Development was conducted within Amazon Cloud9, leveraging the AWS Learning Academy service to familiarize ourselves with the AWS environment. We also utilized Amazon S3 for storing project images; however, this presented a challenge as the S3 keys from the AWS Academy server required renewal every 4 hours.
