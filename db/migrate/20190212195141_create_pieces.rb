class CreatePieces < ActiveRecord::Migration[5.2]
  def change
    create_table :pieces do |t|
      t.string :title
      t.string :desc
      t.integer :user_id

    end
  end
end
