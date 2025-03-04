class ApplicationController < ActionController::Base

  include SessionsHelper
  before_action :login_required

  private

  def login_required
    unless current_user
      flash[:notice] = "ログインしてください"
      redirect_to new_session_path
    end
  end

  def logout_required
    if current_user
      flash[:notice] = "ログアウトしてください"
      redirect_to tasks_path
    end
  end

  def admin_required
    unless current_user.admin?
      flash[:notice] = "管理者以外アクセスできません"
      redirect_to tasks_path
    end
  end

end
