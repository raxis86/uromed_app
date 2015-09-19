class UserMailer < ApplicationMailer

	def welcome_email(user)
		@user = user
		@url = "www.uromed-lkc.ru/signin"#signin_url
		mail(to: @user.email, subject: "Спасибо за регистрацию на сайте www.uromed-lkc.ru!")
	end

end
