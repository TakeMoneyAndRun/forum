class Topic < ActiveRecord::Base

  belongs_to :user
  belongs_to :forum
  has_many :posts

  attr_accessible :name, :forum_id
end
