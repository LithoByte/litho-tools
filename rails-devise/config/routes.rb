Rails.application.routes.draw do
    scope "/api/v1" do
      devise_for :users,
        path: "",
        path_names: {
          sign_in: "login",
          sign_out: "logout",
          registration: "signup",
        },
        controllers: {
          sessions: "sessions",
          registrations: "registrations",
          invitations: "invitations",
        }
      post "reset_password", to: "passwords#request_reset", as: "request_reset"
      patch "reset_password", to: "passwords#reset_password", as: "reset_password"
    end

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
    end
  end
  
  get ".well-known/apple-app-site-association", to: "deep_links/apple_deep_link#apple_app_site_association"
end
