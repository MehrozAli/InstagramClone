class RenameLikesCommentsColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :posts, :likes, :likes_count
    rename_column :posts, :comments, :comments_count
  end
end
