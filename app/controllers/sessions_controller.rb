class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			if user.email_confirmed
				sign_in user
				redirect_back_or user
			else
				flash.now[:notice] = 'Вы не завершили регистрацию! 
				Для завершения регистрации перейдите по ссылке в письме,
				отправленном на ваш Email.'
				render 'new'
			end
		else
			flash.now[:error] = 'Неправильный Email/Пароль'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
