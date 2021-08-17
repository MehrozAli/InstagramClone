class AddProfileImgToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :profileImg, :string
  end
end
