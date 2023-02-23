class CommentsController < ApplicationController
  before_action :find_journey
  before_action :authenticate_user!
  # create / destroy

  def create
    @comment = Comment.new(params.require(:comment).permit(:body))
    @comment.journey = @journey
    @comment.user = current_user
    if @comment.save
      # CommentMailer.hello_world.deliver_now
      # CommentMailer.new_comment(@comment).deliver_now
      # CommentMailer.new_comment(@comment).deliver_later
      # CommentMailer.delay(run_at: 30.seconds.from_now).new_comment(@comment)
      redirect_to journey_path(@journey), notice: "comment created!"
      # if saved successfully then redirect to the show page of the journey
      # otherwise still go to this show page but using render
      # the difference between redirect and render
      # redirect is sending a get request '/journeys/:id'
      # render is rendering the page
    else
      # we want to stay on this page
      @comments = @journey.comments.order(created_at: :desc)
      # '/journeys/show' is not the action
      # it's the page /journeys/show.html.erb
      render '/journeys/show', status: 303
    end
  end

  def destroy
    @comment = Comment.find params[:id]
    if can?(:crud, @comment)
      @comment.destroy
      redirect_to journey_path(@journey), notice: "comment deleted"
    else
      redirect_to root_path, alert: "Not authorized"
    end
  end

  private

  def find_journey
    @journey = Journey.find params[:journey_id]
  end

end
