module SessionsHelper

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user?(user)
    user == current_user
  end

  #このtaskのuser_idは、ログインユーザのidと等しいですか？
  def current_users_task?(task)
    current_user.id == task.user_id
  end

end
