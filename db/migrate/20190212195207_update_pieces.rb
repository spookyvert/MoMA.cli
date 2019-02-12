class UpdatePieces < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces,:favorite_id ,:integer
    add_column :pieces,:artist ,:string
    add_column :pieces,:date ,:string
  end
end
