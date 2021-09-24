class AddTypeToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :post_type, :string, default: 'post'
  end
end
