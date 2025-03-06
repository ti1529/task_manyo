class Label < ApplicationRecord
  has_many :tasks_labels, dependent: :destroy
  has_many :tasks, through: :tasks_labels
  belongs_to :user

  validates :name, presence: true
end
