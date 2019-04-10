class AddUserIdToTasks < ActiveRecord::Migration[5.2]
  def change
  	add_column :tasks, :user_id, :integer, :default => "admin"
  end
end
