class LikesController < ApplicationController

  def create
    @journey = Journey.find params[:journey_id]
    @like = Like.new(journey: @journey, user: current_user)

   if cannot?(:like, @journey)
    flash[:alert] = "You can't like your own journey!"
   elsif @like.save
    flash[:notice] = "Journey liked!"
   else
    flash[:alert] = @like.errors.full_messages.join(", ")
   end
   redirect_to journey_path(@journey)
  end

  def destroy
    @like = current_user.likes.find params[:id]

    if cannot?(:destroy, @like)
     flash[:alert] = "You can't destroy a like you don't own!"
    elsif @like.destroy
     flash[:notice] = "Journey unliked"
    else
     flash[:alert] = "Couldn't unlike journey"
    end
    redirect_to journey_path(@like.journey)
  end


end
