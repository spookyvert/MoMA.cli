class Piece < ActiveRecord::Base
  belongs_to :user
  has_many :favorites, through: :user




end
