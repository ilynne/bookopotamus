class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :ratings
  has_many :books
  has_many :follows
  has_one :email_prefs

  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qat')
      break token unless User.exists?(api_key: token)
    end
  end

  def update_api_key
    update_attribute(:api_key, generate_api_key)
  end

end
