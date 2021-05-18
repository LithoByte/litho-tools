gem "jbuilder"
gem "devise"
gem "devise-async"
gem "devise-jwt"
gem "devise_invitable"
gem "sidekiq"
gem "json_schema_builder"

gem_group :development, :test do
  gem "axe-matchers"
  gem "bullet"
  gem "bundler-audit"
  gem "dotenv-rails"
  gem "rspec"
  gem "factory_bot_rails"
  gem "gnar-style"
  gem "json_matchers"
  gem "pronto-brakeman"
  gem "pronto-rubocop"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-its"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "simplecov"
end

generate "devise:install"
generate "devise_invitable:install"
generate "devise", "user"
generate "devise_invitable", "user"
generate "migration", "AddNameToUsers first_name:string last_name:string"
generate "model", "JwtBlacklist jti:string:index"

run "rm config/database.yml"
create_file "config/database.yml", <<-FILE
default: &default
  adapter: postgresql
  pool: <%= ENV.fetch(\"RAILS_MAX_THREADS\") { 5 } %>
  database: <%= ENV['DATABASE_NAME'] %>
  username: <%= ENV['DATABASE_USERNAME'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
  host: <%= ENV['DATABASE_HOST'] %>
  port: <%= ENV['DATABASE_PORT'] %>
  timeout: 5000

development:
  <<: *default
  database: db/${project_name}_development

test:
  <<: *default
  database: db/${project_name}_test

production:
  <<: *default
  database: db/${project_name}_production
FILE
                      
create_file ".env.test", <<-FILE
DATABASE_NAME=${project_name}_test
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=""
DATABASE_HOST=localhost
DATABASE_PORT=5432
DEVISE_JWT_SECRET_KEY=85d1458f067d11da6ec25853d50225528df6e5fdfd32e0642d74809c2496db30cc78043aeba10a624557ea95b4b5d190061bd9f609123f6767dfed4035a7be42
FILE
                      
create_file ".env.development", <<-FILE
DATABASE_NAME=${project_name}_development
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=""
DATABASE_HOST=localhost
DATABASE_PORT=5432
FILE

run "rm -rf test"
run "rm spec/models/jwt_blacklist_spec.rb"
