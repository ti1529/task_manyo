class AddColumnPriorityToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :priority, :integer, null: false
  end
end
