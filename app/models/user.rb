class User < ActiveRecord::Base
  has_many :favorites #needed
  has_many :pieces, through: :favorites #needed
  has_many :owned_pieces,  foreign_key: "user_id", class_name: "Piece" #needed


  def love(p)
    self.favorites.create(piece_id: p.id)
  end

end
