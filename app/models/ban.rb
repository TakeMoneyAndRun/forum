class Ban < ActiveRecord::Base

  attr_accessible :expires_at, :reason

  belongs_to :user

end
