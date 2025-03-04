class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  before_validation { email.downcase! }
  before_destroy :check_admin_count_destroy
  before_update :check_admin_count_update


  validates :name, presence: true
  validates :email, presence: true, uniqueness: true # format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, length: { minimum: 6 }

  has_secure_password


  private

  # ユーザが、残り1人のadminである場合、アクションをキャンセル
  # destoryのエラーメッセージ表示がうまくできない
  def check_admin_count_destroy
    if User.where(admin: true).count == 1 && User.find(id).admin?
      errors.add :base, message: "管理者が0人になるため削除できません"
      throw :abort
    end
  end

  def check_admin_count_update
    if User.where(admin: true).count == 1 && User.find(id).admin? && admin == false
      errors.add :base, message: "管理者が0人になるため権限を変更できません"
      throw :abort
    end
  end
  

end
