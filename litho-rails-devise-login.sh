#!/bin/bash

project_name=""
last_arg=""
for arg in "$@"
do
    if [[ $arg == "-h" ]] || [[ $arg == "--help" ]] || [[ $arg == "help" ]] || [[ $arg == "-?" ]]; then
        echo "Usage of litho-rails-login"
        echo "cd into the project root directory and run this script."
        echo "litho-rails-devise-login.sh -n ProjectName"
        exit 0
    fi
    if [[ $last_arg == "-n" ]]; then
        project_name=$arg
    fi
    
    last_arg=$arg
done

rails new $project_name --api --database=postgresql -m https://raw.githubusercontent.com/ThryvInc/litho-tools/master/rails-devise/template.rb

cd $project_name

bundle _2.2.11_ install
bundle lock --add-platform x86_64-linux

git add .
git commit -m "after rails new --api litho template"
git branch -M main

SCRIPT_DIR=`dirname "$BASH_SOURCE"`
echo $SCRIPT_DIR

mkdir .circleci

cp "$SCRIPT_DIR/rails-devise/.circleci/config.yml" ./.circleci/
cp "$SCRIPT_DIR/rails-devise/.env.docker" ./
cp "$SCRIPT_DIR/rails-devise/.env.test" ./
cp "$SCRIPT_DIR/rails-devise/.env.development" ./
cp "$SCRIPT_DIR/rails-devise/.gitignore" ./

cp -r "$SCRIPT_DIR/rails-devise/config/routes.rb" ./config/routes.rb
cp -r "$SCRIPT_DIR/rails-devise/config/sidekiq.yml" ./config/sidekiq.yml
cp -r "$SCRIPT_DIR/rails-devise/config/devise.rb" ./config/initializers/devise.rb
cp -r "$SCRIPT_DIR/rails-devise/config/sidekiq.rb" ./config/initializers/sidekiq.rb

cp -r "$SCRIPT_DIR/rails-devise/controllers/" ./app/controllers/

cp -r "$SCRIPT_DIR/rails-devise/mailers/user_mailer.rb" ./app/mailers/user_mailer.rb

cp -r "$SCRIPT_DIR/rails-devise/models/user.rb" ./app/models/user.rb

cp -r "$SCRIPT_DIR/rails-devise/views/" ./app/views/

cp -r "$SCRIPT_DIR/rails-devise/spec/" ./spec/

rake db:create
rake db:migrate

echo "-----------------------------------------------------------"
echo "|Remember to add these lines to your application.rb:      |"
echo "|config.active_job.queue_adapter = :sidekiq               |"
echo "|config.x.api_host = ENV.fetch(\"API_HOST\")              |"
echo "|config.x.mobile_app_link = ENV.fetch(\"MOBILE_APP_LINK\")|"
echo "-----------------------------------------------------------"
