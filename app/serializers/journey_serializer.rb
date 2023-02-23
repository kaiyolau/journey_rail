class JourneySerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :address, :latitude, :longitude, :tag_names, :weather

  #customized method:
    #rename user to author to make it more understandable for the person requesting data from our api
    def author_full_name
      object.user&.full_name
    end

  #======Associations=========>
  #To include associated models, we can use the same methods in Rails like "beloongs_to" and "has_many"
  has_many :comments

  # To customize serialization for associated models, we can define a serializer
  # within the current serializer. This would replace any global serializer
  # whenever we are serializing questions.

  belongs_to :user, key: :author


  class AnswerSerializer < ActiveModel::Serializer
    attributes :id, :author_full_name, :body, :created_at

    # #customized method:
    # #rename user to author to make it more understandable for the person requesting data from our api
    def author_full_name
      object.user&.full_name
    end
  end

  class UserSerializer < ActiveModel::Serializer
    #We can rename the association with "key" in the serialized output
    attributes :id, :first_name, :last_name, :full_name
  end

  class LikeSerializer < ActiveModel::Serializer
    #We can rename the association with "key" in the serialized output
    attributes :id, :user_id, :journey_id
  end

  class TaggingSerializer < ActiveModel::Serializer
    attributes :id, :journey_id, :tag_id

    # #customized method:
    # #rename user to author to make it more understandable for the person requesting data from our api
    def author_full_name
      object.user&.full_name
    end
  end

end
