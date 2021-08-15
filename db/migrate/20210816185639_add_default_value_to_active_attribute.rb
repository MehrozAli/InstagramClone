class AddDefaultValueToActiveAttribute < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :active, :boolean, default: true
  end
end
