#!/bin/bash

project_name=""
last_arg=""
for arg in "$@"
do
    if [[ $arg == "-h" ]] || [[ $arg == "--help" ]] || [[ $arg == "help" ]] || [[ $arg == "-?" ]]; then
        echo "Usage of litho-rails-login"
        echo "cd into the project root directory and run this script."
        echo "litho-rails-devise-login.sh -n ProjectName"
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

#bundle add jbuilder
#bundle add devise
#bundle add devise-async
#bundle add devise-jwt
#bundle add devise_invitable
#
#bundle add axe-matchers --group "development, test"
#bundle add bullet --group "development, test"
#bundle add bundler-audit --group "development, test"
#bundle add dotenv-rails --group "development, test"
#bundle add rspec --group "development, test"
#bundle add factory_bot_rails --group "development, test"
#bundle add gnar-style --group "development, test"
#bundle add json_matchers --group "development, test"
#bundle add pronto-brakeman --group "development, test"
#bundle add pronto-rubocop --group "development, test"
#bundle add pry-byebug --group "development, test"
#bundle add pry-rails --group "development, test"
#bundle add rspec-its --group "development, test"
#bundle add rspec-rails --group "development, test"
#bundle add shoulda-matchers --group "development, test"
#bundle add simplecov --group "development, test"

#rails g devise:install
#rails g devise_invitable:install
#rails g devise user
#rails g devise_invitable user
#rails g migration AddNameToUsers first_name:string last_name:string
#rails g model JwtBlacklist jti:string:index

SCRIPT_DIR=`dirname "$BASH_SOURCE"`
echo $SCRIPT_DIR

#echo "default: &default" > ./config/database.yml
#echo "  adapter: postgresql" >> ./config/database.yml
#echo "  pool: <%= ENV.fetch(\"RAILS_MAX_THREADS\") { 5 } %>" >> ./config/database.yml
#echo "  database: <%= ENV['DATABASE_NAME'] %>" >> ./config/database.yml
#echo "  username: <%= ENV['DATABASE_USERNAME'] %>" >> ./config/database.yml
#echo "  password: <%= ENV['DATABASE_PASSWORD'] %>" >> ./config/database.yml
#echo "  host: <%= ENV['DATABASE_HOST'] %>" >> ./config/database.yml
#echo "  port: <%= ENV['DATABASE_PORT'] %>" >> ./config/database.yml
#echo "  timeout: 5000" >> ./config/database.yml
#echo "" >> ./config/database.yml
#echo "development:" >> ./config/database.yml
#echo "  <<: *default" >> ./config/database.yml
#echo "  database: db/${project_name}_development" >> ./config/database.yml
#echo "" >> ./config/database.yml
#echo "test:" >> ./config/database.yml
#echo "  <<: *default" >> ./config/database.yml
#echo "  database: db/${project_name}_test" >> ./config/database.yml
#echo "" >> ./config/database.yml
#echo "production:" >> ./config/database.yml
#echo "  <<: *default" >> ./config/database.yml
#echo "  database: db/${project_name}_production" >> ./config/database.yml
#
#echo "DATABASE_NAME=${project_name}_test" > .env.test
#echo "DATABASE_USERNAME=postgres" >> .env.test
#echo "DATABASE_PASSWORD=""" >> .env.test
#echo "DATABASE_HOST=localhost" >> .env.test
#echo "DATABASE_PORT=5432" >> .env.test
#echo "DEVISE_JWT_SECRET_KEY=85d1458f067d11da6ec25853d50225528df6e5fdfd32e0642d74809c2496db30cc78043aeba10a624557ea95b4b5d190061bd9f609123f6767dfed4035a7be42" >> .env.test
#
#echo "DATABASE_NAME=${project_name}_development" > .env.development
#echo "DATABASE_USERNAME=postgres" >> .env.development
#echo "DATABASE_PASSWORD=""" >> .env.development
#echo "DATABASE_HOST=localhost" >> .env.development
#echo "DATABASE_PORT=5432" >> .env.development

mkdir .circleci

cp "$SCRIPT_DIR/rails-devise/.circleci/config.yml" ./.circleci/
cp "$SCRIPT_DIR/rails-devise/.env.docker" ./
cp "$SCRIPT_DIR/rails-devise/.gitignore" ./

cp -r "$SCRIPT_DIR/rails-devise/config/routes.rb" ./config/routes.rb
cp -r "$SCRIPT_DIR/rails-devise/config/devise.rb" ./config/initializers/devise.rb

cp -r "$SCRIPT_DIR/rails-devise/controllers/" ./app/controllers/

cp -r "$SCRIPT_DIR/rails-devise/mailers/user_mailer.rb" ./app/mailers/user_mailer.rb

cp -r "$SCRIPT_DIR/rails-devise/models/user.rb" ./app/models/user.rb

cp -r "$SCRIPT_DIR/rails-devise/views/" ./app/views/

cp -r "$SCRIPT_DIR/rails-devise/spec/" ./spec/

rake db:create
rake db:migrate

rspec

#rm spec/models/jwt_blacklist_spec.rb
#rm -rf test
