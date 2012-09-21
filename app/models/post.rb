class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user
  attr_accessible :body
  validates_presence_of :body
  self.per_page = 4


end
