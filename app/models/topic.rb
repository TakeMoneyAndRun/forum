class Topic < ActiveRecord::Base

  attr_accessible :name, :forum_id

  belongs_to :user
  belongs_to :forum
  has_many :posts

end
