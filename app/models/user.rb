class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable\
  has_many :user_cohorts
  has_many :cohorts, through: :user_cohorts
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.find_for_google_oauth2(auth)
    data = auth.info
    if validate_email(auth)
      User.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.token = 
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
      end
    else
      return nil
    end
    # user = User.find_by(email: data.email)
    # if user
    #   user.provider = access_token.provider
    #   user.uid = access_token.uid
    #   user.token = access_token.credentials.token
    #   user.save
    #   user
    # else
    #   redirect_to root_path, notice: "Google Calendar Authorization Error."
    # end
  end

  def active_cohort
    if !UserCohort.where("user_id = ? AND active = ?", self.id, true).empty?
      UserCohort.where("user_id = ? AND active = ?", self.id, true).first.cohort
    end
  end

  def has_cohort
    self.cohorts.length > 0
  end

  def self.validate_email(auth)
    auth.info.email.split("@").last == "flatironschool.com"
  end
end