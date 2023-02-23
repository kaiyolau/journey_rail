class LikersController < ApplicationController

  def index
    @journey = Journey.find(params[:journey_id])
    # debugger
    @likers = @journey.likers
  end

  def show

  end

end
