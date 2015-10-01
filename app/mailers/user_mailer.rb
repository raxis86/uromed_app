class UserMailer < ApplicationMailer

	def registration_confirmation(user)
		@user = user
		@url = email_confirm_user_url(@user.confirm_token)
		mail(to: @user.email, subject: "Спасибо за регистрацию на сайте www.uromed-lkc.ru!")
	end

end
