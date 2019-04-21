class AddTagsIntoTasks < ActiveRecord::Migration[5.2]
  def change
  	add_column :tasks, :tag_public, :integer, :default => "0"
  	add_column :tasks, :tag_private, :integer, :default => "0"
	add_column :tasks, :tag_urgent, :integer, :default => "0"
  end
end
