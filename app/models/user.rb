# == Schema Information
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  name                 :string(255)
#  icon_file_name       :string(255)
#  icon_content_type    :string(255)
#  icon_file_size       :integer
#  icon_updated_at      :datetime
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  has_attached_file :icon, :styles => {
    :thumb => ["100x100#", :png],
    :icon => ["32x32#", :png],
  }

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :icon

  has_many :topics
  has_many :posts

  has_many :managements
  has_many :manageable_boards, 
    :through => :managements,
    :source => :manageable,
    :source_type => 'Board'
  has_many :manageable_categories, 
    :through => :managements,
    :source => :manageable,
    :source_type => 'Category'

  validates_presence_of :name
  validates_uniqueness_of :name

  def ban
    self.banned=true
    save
  end

  def unban
    self.banned=false
    save
  end

  # Hack: prevent devise to destroy user
  protected
  def destroy_guard
    raise "User Cannot be Deleted"
  end
  before_destroy :destroy_guard

end

