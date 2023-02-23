class Api::V1::JourneysController < Api::ApplicationController

  before_action :authentication_user!, except: [:index, :show, :create]

  def index
    journeys = Journey.order(created_at: :desc)
    render(json: journeys, each_serializer: JourneyCollectionSerializer)
  end

  def show
    journey = Journey.find(params[:id])
    render(json: journey)
  end

  #we dont need the new action for api, because we past the value directly instead of passing by a form/view template.
  def create
    journey = Journey.new(journey_params)
    #the api application contorller is inherit from application controller, so current_user still work here
    journey.user = current_user
    if journey.save!
        render json: { id: journey.id }
    else
        render(
            json: { errors: journey.errors.messages },
            status: 422 #unprocessable entity HTTP status code
        )
    end
    # journey.save!
    # render json: { id: journey.id }
  end

  def update
    journey = Journey.find(params[:id])
    if journey.update(journey_params)
      render json: {id: journey.id}
    else
      render(
        json:{errors: journey.errors.messages},
        status: 422
      )
    end
  end

  def destroy
    journey = Journey.find(params[:id])
    if journey.destroy
      render(json: {status: 200})
    else
      render(json: {status: 500})
    end
  end

    private

    def journey_params
      params.require(:journey).permit(:title, :body, :tag_names, :location, :latitude, :longitude, :images, :weather)
    end


end
