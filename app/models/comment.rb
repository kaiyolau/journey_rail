class Comment < ApplicationRecord
  belongs_to :journey
  belongs_to :user

  validates :body, length: {minimum: 3, maximum:200}
end
