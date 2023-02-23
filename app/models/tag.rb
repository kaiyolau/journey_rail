class Tag < ApplicationRecord
  before_save :downcase_name

  has_many :taggings, dependent: :destroy
  has_many :journeys, through: :taggings#, source: :journeys

  validates :name, presence: true, uniqueness: true

  private

  def downcase_name
    self.name&.downcase!
  end
end
