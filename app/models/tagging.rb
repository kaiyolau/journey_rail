class Tagging < ApplicationRecord
  belongs_to :journey
  belongs_to :tag

  validates :tag_id, presence: true, uniqueness: {scope: :journey_id}
end
