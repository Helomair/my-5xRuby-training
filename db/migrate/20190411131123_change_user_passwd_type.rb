class ChangeUserPasswdType < ActiveRecord::Migration[5.2]
  def change
  	rename_column :users, :passwd, :password_digest
  end
end
