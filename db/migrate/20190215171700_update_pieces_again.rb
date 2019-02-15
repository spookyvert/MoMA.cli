class UpdatePiecesAgain < ActiveRecord::Migration[5.2]
  def change
    remove_column :pieces, :favorite_id
  end
end
