class AddLikesCommentsCount < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :likes, :integer
    add_column :posts, :comments, :integer
  end
end
