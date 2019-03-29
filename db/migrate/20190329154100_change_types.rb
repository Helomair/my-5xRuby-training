class ChangeTypes < ActiveRecord::Migration[5.2]
  def change
      change_column :tasks, :title, :string
  end
end
