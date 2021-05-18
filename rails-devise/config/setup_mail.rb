if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    user_name: ENV["SENDGRID_USERNAME"],
    password: ENV["SENDGRID_PASSWORD"],
    address: ENV["SENDGRID_SMTP_SERVER"],
    port: ENV["SENDGRID_SMTP_PORT"],
    authentication: :plain,
    enable_starttls_auto: true,
  }
end
