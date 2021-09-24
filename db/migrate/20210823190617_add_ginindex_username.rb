class AddGinindexUsername < ActiveRecord::Migration[5.2]
  def change
    execute 'CREATE INDEX username_gin_index ON users USING gin (username gin_trgm_ops);'
  end
end
