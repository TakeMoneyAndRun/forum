class Post < ActiveRecord::Base

  attr_accessible :body

  belongs_to :topic
  belongs_to :user

  has_many :complains
  has_many :votes

  validates_presence_of :body

  self.per_page = 4

  scope :published, where(:note => false)
  scope :unpublished, where(:note => true)
  scope :complained, where(:complained => true)


end
