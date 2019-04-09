class AddEndTime < ActiveRecord::Migration[5.2]
  def change
  	add_column :tasks, :end_time, :datetime
  end
end
