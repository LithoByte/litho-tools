module DeepLinks
  class AppleDeepLinkController < ApplicationController
    skip_before_action :verify_authenticity_token, raise: false

    def apple_app_site_association
      render json: { applinks: 
        { apps: [], 
          details: [{ appID: "CHANGE_ME",
                      paths: ["accept_invite/*"] }]
        } 
      }
    end
  end
end
