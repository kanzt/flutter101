# Node Stock Workshop
- npm i

## Database

- npm install sequelize
- npm install -g sequelize-cli
- sequelize --help

* init database

  1. sequelize init
     - config, contains config file, which tells CLI how to connect with database
     - models, contains all models for your project
     - migrations, contains all migration files
     - seeders, contains all seed files
  2. config database sqlite for development (config folder)
  3. cd to current path (migrations, models, seeders)
  4. sequelize model:generate --name Products --attributes "name:string, image:string, stock:integer, price:integer" --underscored true
  5. edit models support
     - freezeTableName: true
     - underscoreAll: true
     - underscored: true
     - createdAt: "created_at"
     - updatedAt: "updated_at"
  6. sequelize seed:generate --name seed-Products
  7. implement seed

* migrate database
  - sequelize db:migrate
  - sequelize db:seed:all

docker run --name demo-mysql -e MYSQL_ROOT_PASSWORD=Tel1234! -p 1112:3306 -d mysql:8.0

docker run --name demo-mssql -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Tel1234!' -p 1112:1433 -d mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-16.04

> npx cross-env NODE_ENV=test nodemon app.js

## Deploy Heroku

- create Procfile
  > web: NODE_ENV=development node app.js
- migrate and seed SQLite Database
