class Admin::UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_required

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = t(".notice")
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def index
    @users = User.includes(:tasks)    
  end

  def show
    @tasks = @user.tasks
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = t(".notice")
      redirect_to admin_users_path
    else
      render :edit
    end
  end


  def destroy
    if @user.destroy
      flash[:notice] = t(".notice")
      redirect_to admin_users_path
    else
      @users = User.includes(:tasks)
      render :index
    end

  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

end