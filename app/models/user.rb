class User < ApplicationRecord
 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook, :azure_activedirectory_v2, :github]
  
  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0, 20]
  #     user.full_name = auth.info.name # assuming the user model has a name
  #     user.avatar_url = auth.info.image # assuming the user model has an image
  
  #   end
  # end
 
    # def self.from_omniauth(auth)
    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #   user.email = auth.info.email
    #   user.password = Devise.friendly_token[0,20]
    #   user.full_name = auth.info.name  
    #   # user.avatar_url = auth.info.image
    #   end
    # end

    # def self.new_with_session(params, session)
    #   super.tap do |user|
    #     if data = session["devise.github"] && session["devise.github_data"]["extra"]["raw_info"]
    #       user.email = data["email"] if user.email.blank?
    #     end
    #     if data = session["devise.google_oauth2"] && session["devise.google_oauth2_data"]["extra"]["raw_info"]
    #       user.email = data["email"] if user.email.blank?
    #     end
    #     if data = session["devise.facebook"] && session["devise.facebook_data"]["extra"]["raw_info"]
    #       user.email = data["email"] if user.email.blank?
    #     end
    #     if data = session["devise.azure_activedirectory_v2"] && session["devise.azure_activedirectory_v2_data"]["extra"]["raw_info"]
    #       user.email = data["email"] if user.email.blank?
    #     end
    #   end
    # end

  def self.from_omniauth(auth)
    puts "from_omniauth==========#{auth}"
    user = User.find_by(email: auth.info.email)
      if user
        user.provider = auth.provider
        user.uid = auth.uid
        user.save
      else
        user = User.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
          user.email = auth.info.email
          user.full_name = auth.info.name
          user.avatar_url = auth.info.image
          user.password = Devise.friendly_token[0,20]
        end
      end
      user
    end

end
