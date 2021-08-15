class TightenSocialGraphConstraints < ActiveRecord::Migration[8.1]
  def up
    execute 'UPDATE posts SET likes_count = 0 WHERE likes_count IS NULL'
    execute 'UPDATE posts SET comments_count = 0 WHERE comments_count IS NULL'
    change_column :posts, :likes_count, :integer, default: 0, null: false
    change_column :posts, :comments_count, :integer, default: 0, null: false

    remove_duplicates :likes, %w[user_id post_id]
    remove_duplicates :followers, %w[follower_id following_id]
    add_index :likes, %i[user_id post_id], unique: true
    add_index :followers, %i[follower_id following_id], unique: true

    add_foreign_key :posts, :users
    add_foreign_key :comments, :posts
    add_foreign_key :comments, :users
    add_foreign_key :likes, :posts
    add_foreign_key :likes, :users
    add_foreign_key :followers, :users, column: :follower_id
    add_foreign_key :followers, :users, column: :following_id
  end

  def down
    remove_foreign_key :followers, column: :following_id
    remove_foreign_key :followers, column: :follower_id
    remove_foreign_key :likes, :users
    remove_foreign_key :likes, :posts
    remove_foreign_key :comments, :users
    remove_foreign_key :comments, :posts
    remove_foreign_key :posts, :users
    remove_index :followers, %i[follower_id following_id]
    remove_index :likes, %i[user_id post_id]
    change_column :posts, :comments_count, :integer, default: nil, null: true
    change_column :posts, :likes_count, :integer, default: nil, null: true
  end

  private

  def remove_duplicates(table, columns)
    key = columns.join(', ')
    execute <<~SQL
      DELETE FROM #{table} WHERE id IN (
        SELECT id FROM (
          SELECT id, ROW_NUMBER() OVER (PARTITION BY #{key} ORDER BY id) AS n FROM #{table}
        ) ranked WHERE n > 1
      )
    SQL
  end
end
