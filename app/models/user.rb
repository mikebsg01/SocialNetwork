class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth['provider'], uid: auth['uid']).first_or_create do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']

      if auth['info'].present?
        # user.email = auth['info']['email']
        user.name = auth['info']['name']
      end

      if auth['extra']['raw_info']['username'].present?
        user.username = auth['extra']['raw_info']['username']
      end

      if auth['extra']['raw_info']['first_name'].present?
        user.first_name = auth['extra']['raw_info']['first_name']
      end

      if auth['extra']['raw_info']['last_name'].present?
        user.last_name = auth['extra']['raw_info']['last_name']
      end

      if user.name.nil?
          user.name = '#{user.first_name} #{user.last_name}'
      end

      user.password = Devise.friendly_token[0, 20]
    end
  end
end