class UpdateUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :rich ,:boolean
  end
end
