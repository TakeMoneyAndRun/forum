class Complain < ActiveRecord::Base

  attr_accessible :reason

  belongs_to :user
  belongs_to :post

end
