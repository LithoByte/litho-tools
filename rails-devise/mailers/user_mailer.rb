class UserMailer < Devise::Mailer
  def reset_password_instructions(user, _token, _opts = {})
    @password_reset_url = "#{ENV['API_HOST']}password_reset/#{user.reset_password_token}"
    mail(to: user.email, subject: "Reset Password", from: "support@changeme.com")
  end
end
