class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("app.mailers.user.account_activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("app.mailers.user.password_reset")
  end
end
