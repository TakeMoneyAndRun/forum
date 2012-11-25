class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
          :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  attr_accessible :email, :password, :nickname, :password_confirmation, :remember_me, :avatar, :avatar_cache, :remove_avatar, :role_ids, :roles

  has_many :posts
  has_many :topics
  has_many :bookmarks
  has_many :notes
  has_one :ban
  has_many :users_roles
  has_many :roles, :through => :users_roles

  scope :bannable, includes(:roles).where(:roles => {:id => 1})


  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end


end
