class UsersController < ApplicationController

  skip_before_action :login_required, only: [:new, :create]
  before_action :correct_user, only: [:show, :edit, :destroy]
  before_action :set_user, only: [:show, :edit, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
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

  end

  def destroy
    # 後ほど作成
    # @user.destroy

    # flash[:notice] = "アカウント削除"
    # redirect_to new_session_path
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
    redirect_to current_user unless current_user?(@user)
  end

end