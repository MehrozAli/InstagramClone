class AddAccountTypeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :isPrivate, :boolean, default: false
  end
end
