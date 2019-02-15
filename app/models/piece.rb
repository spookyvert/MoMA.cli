class Piece < ActiveRecord::Base
  belongs_to :user #needed

  # has_many :favorites
  # has_many :users, through: :favorites  





end
