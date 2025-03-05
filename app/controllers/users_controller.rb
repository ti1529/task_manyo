class UsersController < ApplicationController

  skip_before_action :login_required, only: [:new, :create]
  before_action :correct_user, only: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logout_required, only: [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:notice] = "アカウントを登録しました"
      redirect_to tasks_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:notice] = t(".notice")
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end




  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to tasks_path unless current_user?(@user)
  end

end