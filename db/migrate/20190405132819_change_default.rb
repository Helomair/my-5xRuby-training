class ChangeDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :status, :integer, null:false, :default => "1" 
  end
end
