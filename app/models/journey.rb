class Journey < ApplicationRecord

  geocoded_by :address
  #We are stating here that we are converting the address to geocode
  #when a user saves an address, it will automatically convert it to latitude and longitude as well
  after_validation :geocode

  # Initialize > Validate > Save > Commit
  # after_initialize :set_defaults

  before_save :capitalize_title

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many_attached :images, :dependent => :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings#, source: :tag
  #since the tags is the plural of the model tag, we can omit the source.
  has_many :comments


  validates :title, presence: { message: "Title must be provided" }, uniqueness: true, length: { minimum: 2, maximum: 200, too_short: "Title must be 2 characters minimum." }
  validates :body, presence: { message: "Body must be provided" }, uniqueness: {message: "please provide a unique content"}
  # validates :weather, presence: { message: "Body must be provided" }


  #-------------ADD CUSTOM TAG METHODS TO GET OR SET TAGS WITH SELECTIZE---------------->

  #Getter Method


  # def weather
  #   self.weather
  # end

  def tag_names
    self.tags.map(&:name).join(", ")
    #The & symbol is used to tell Ruby that the following argument
    #should be given as a block to the method. So the line
    #self.tags.map(&:name).join(", ") is equal to
    #self.tags.map { |t| t.name.join(", ")}
    #So the above will iterate over the collection of self.tags
    #and build an array of results of the name method
    #called on every item
  end

  #Setter
  #This is simnilar to implementing an attribute writer "attr_writer"
  #Appending = at the end of a method name allows us to implement a setter
  #A setter is a method that is assignable, for example:
  #q.tag_names = 'another new tag name'
  def tag_names=(rhs)
    self.tags = rhs.strip.split(/\s*, \s*/).map do |tag_name|
      Tag.find_or_initialize_by(name: tag_name)
    end
  end





  private


  def capitalize_title
      self.title.capitalize!
  end

end
