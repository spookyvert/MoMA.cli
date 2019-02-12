class User < ActiveRecord::Base
  has_many :favorites
  has_many :pieces, through: :favorites
  has_many :owned_pieces, class_name: 'piece'


  def love(p)
    Favorite.create(user_id: self.id, piece_id: p.id)
  end

end
