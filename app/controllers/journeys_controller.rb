class JourneysController < ApplicationController
  # skip_before_action :verify_authenticity_token
  before_action :find_journey, only: [:edit, :update, :show, :destroy, :liker]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user!, only:[:edit, :update, :destroy]

  # =============CREATE========================
  def new
    # Because Rails form helper methods need an instance of a model to work, we create a new instance
    @journey = Journey.new
    @tag = Tag.first
  end

  def create
    @journey = Journey.new(journey_params)
    @journey.user = current_user

    @journey.images.attach(params[:journey][:images])
    if @journey.save
      flash[:notice]= "journey created successfully!"
      redirect_to journey_path(@journey)
    else
      render :new
    end
  end

  def index
    if params[:tag]
      @tag = Tag.find_or_initialize_by(name: params[:tag])
      @journeys = @tag.journeys.order(updated_at: :desc).all.with_attached_images
    else
      @journeys = Journey.all.with_attached_images.order(created_at: :desc)

      respond_to do |format|
        format.html { render }
        format.json { render json: @journeys}
      end
    end

  end

  def show
    @comments = @journey.comments.order(created_at: :desc)
    @comment = Comment.new
    @like = @journey.likes.find_by(user: current_user)
    @likers = @journey.likers


  end

  # ===============UPDATE==========================
  def edit
    @tag = Tag.first
  end

  def update
    if @journey.update(journey_params)
      redirect_to journey_path(@journey)
    else
      render :edit
    end
  end

  # ================DELETE=========================

  def destroy
    @journey.destroy
    redirect_to journeys_path
  end

  # ================CUSTOM=========================
  # def timeNow
  #   @journey = Journey.find(params[:journey_id])
  #   @journey.send(params[:timming] = Time.now
  #   @journey.save
  #   redirect_to journeys_path(params[:journey_id])
  # end

  def liked
    @journeys = current_user.liked_journeys
  end

  private

  def authorize_user!
    redirect_to root_path, alert: "Not authorized" unless can?(:crud, @journey)
  end

  def find_journey
    @journey = Journey.find params[:id]
  end

  #As an added layer of protection to our database,
  #and to prevent malicious SQL injection, we only permit users
  #to inject data for the required params in the form,
  #related to the given model:

  def journey_params
    params.require(:journey).permit(:title, :body, :weather, :timing,:address,:latitude,:longitude, :tag_names, images:[])
    # get the data from the form and add it into DB
    # Use the 'require' on the params object to retrieve the nested hash of a key
    # usually corresponding the key-value pairs of a form
    # 'permit' to specify all input names are allowed to submit to the DB
  end

end
