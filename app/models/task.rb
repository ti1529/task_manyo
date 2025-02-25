class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  enum priority: { low: 0, middle: 1, high: 2 }
  enum status: { not_started: 0, in_progress: 1, completed: 2}
end
