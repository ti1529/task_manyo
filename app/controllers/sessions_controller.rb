class SessionsController < ApplicationController

  skip_before_action :login_required, only: [:new, :create]
  before_action :logout_required, only: [:new]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      # ログイン成功時の場合
      log_in(user)
      flash[:notice] = t(".notice")
      redirect_to tasks_path
    else
      # ログイン失敗時の場合
      flash.now[:danger] = t(".danger")
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = t(".notice")
    redirect_to new_session_path

  end



end
