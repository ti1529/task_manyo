class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  enum priority: { low: 0, middle: 1, high: 2 }
  enum status: { not_started: 0, in_progress: 1, completed: 2}

  scope :order_by_deadline_asc, -> { order(deadline_on: "ASC")}
  scope :order_by_priority_desc, -> { order(priority: "DESC")}
  
  scope :order_by_created_desc, -> {order(created_at: "DESC")}

  scope :search_by_title, -> (title){ where("title LIKE ?", "%#{title}%")}
  scope :search_by_status, -> (status){ where(status: status)}


end
