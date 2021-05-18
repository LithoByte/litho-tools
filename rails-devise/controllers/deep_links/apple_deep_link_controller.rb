module DeepLinks
  class AppleDeepLinkController < ApplicationController
    skip_before_action :verify_authenticity_token, raise: false

    def apple_app_site_association
      render json: { applinks: 
        { apps: [], 
          details: [{ appID: ENV["APPLE_APP_ID"],
                      paths: ["accept_invite/*", "password_reset/*"] }]
        } 
      }
    end
  end
end
