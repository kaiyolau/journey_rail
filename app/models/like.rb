class Like < ApplicationRecord
  belongs_to :user
  belongs_to :journey

  validates :journey_id, uniqueness: {scope: :user_id, message: "Has already been liked!"}
  #the scope means that the combination of journeyt_id and user_id must be unique.
end
