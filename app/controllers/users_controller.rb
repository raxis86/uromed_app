class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :index_user,     only: :index
  before_action :show_user,      only: :show
  
  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      flash[:success] = "На указанный email отправлено письмо с дальнейшими инструкциями!"
      redirect_to signin_url
      #sign_in @user
      #flash[:success] = "Поздравляем с регистрацией на uromed-lkc.ru!"
      #redirect_to @user
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Профиль успешно отредактирован!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    usdel = User.find(params[:id]).name
    User.find(params[:id]).destroy
    flash[:success] = "Пользователь #{usdel} удалён!"
    redirect_to users_url
  end

  def email_confirm
    user = User.find_by_confirm_token(params[:id])
    if user && user.email_activate
      flash[:success] = "Ваш email успешно подтвержден! Регистрация завершена! Теперь вы можете войти!"
      redirect_to signin_url
    else
      flash[:error] = "Ссылка недействительна! Возможно пользователь уже подтвердил регистрацию."
      redirect_to root_url
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Пожалуйста, авторизуйтесь"
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user.admin? && !current_user?(@user)
    end

    def index_user
      redirect_to(root_url) unless current_user.admin?
    end

    def show_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless  current_user.admin? || current_user?(@user)
    end
end
