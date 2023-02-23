class User < ApplicationRecord
  # geocoded_by :address //
  # #We are stating here that we are converting the address to geocode
  # #when a user saves an address, it will automatically convert it to latitude and longitude as well
  # after_validation :geocode //


  has_secure_password
  # provide 2 attributes here: password, password_confirmation
  # add a validation for password field
  # provides us a method named "authentication"

  has_many :journeys, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :likes, dependent: :destroy
  has_many :liked_journeys, through: :likes, source: :journey

  # has_and_belongs_to_many(
  #   :liked_questions, #The name we can set it whatever we want
  #   {
  #       class_name: "Question", # the model that associating to
  #       join_table: "likes", # the join table
  #       association_foreign_key: "question_id", # the foreign key for the associated table
  #       foreign_key: "user_id" # foreign key for the current table(Question)
  #   }
  # )

  def full_name
    self.first_name + " " + self.last_name
  end


  #OmniAuth User Setup
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #something@something.com
  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX, unless: :from_oauth?

  def from_oauth?
    uid.present? && provider.present?
  end

  def self.create_from_oauth(oauth_data)
    name = oauth_data["info"]["name"]&.split || oauth_data["info"]["nickname"]
    self.create(
      first_name: name[0],
      last_name: name[1],
      uid: oauth_data["uid"],
      provider: oauth_data["provider"],
      oauth_raw_data: oauth_data,
      password: SecureRandom.hex(32)
    )
  end

  def self.find_by_oauth(oauth_data)
    self.find_by(
      uid: oauth_data["uid"],
      provider: oauth_data["provider"]
    )
  end



end
