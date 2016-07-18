#!/bin/bash

#Add PostgreSQL to apt-get
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

#Update Repos
sudo apt-get -y update

#install PostgreSQL
sudo apt-get install -y postgresql-9.4
#change password to 'password'
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password 'password';"

sudo -u postgres psql -U postgres -d postgres -c "CREATE TABLE user_vectors (id Int, features jsonb);"
sudo -u postgres psql -U postgres -d postgres -c "CREATE TABLE movie_vectors (id Int, features jsonb);"
