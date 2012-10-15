class User < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader

  attr_accessible :email, :nickname, :password, :password_confirmation, :permission_level, :avatar, :avatar_cache, :remove_avatar
  attr_accessor :password

  before_save :encrypt_password

  has_many :posts
  has_many :topics
  has_many :bookmarks
  has_many :notes
  has_one :ban

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :nickname
  validates_uniqueness_of :email, :nickname


  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_valid?(password)
      user
    else
      nil
    end
  end

  def password_valid?(password)
    password_hash == BCrypt::Engine.hash_secret(password, password_salt)
  end


  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

end