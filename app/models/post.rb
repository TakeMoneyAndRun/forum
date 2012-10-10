class Post < ActiveRecord::Base

  attr_accessible :body

  belongs_to :topic
  belongs_to :user

  validates_presence_of :body

  self.per_page = 4

  scope :published, where(:note => false)

end
