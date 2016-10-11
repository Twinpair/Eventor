class EventsController < ApplicationController
	before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

	def index
		@upcoming_events = Event.upcoming
    @past_events =  Event.past
	end

  def new
  	@event = Event.new
  end

  def create
  	@event = current_user.events.build(event_params)
  	if @event.save
      current_user.attend(@event)
  		redirect_to @event
  	else
  		render :new
  	end
  end

  def show
  	@event = Event.find(params[:id])
    @creator = User.find(@event.user_id)
  end

  def edit
    @event = Event.find(params[:id])
    authorized?(@event)
  end

  def update
    @event = Event.find(params[:id])
    authorized?(@event)
    if @event.update(event_params)
      redirect_to @event
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:success] = "Event Deleted"
    redirect_to events_path
  end

  def attendees
    @event  = Event.find(params[:id])
    @users = @event.attendees.paginate(page: params[:page])
  end

private

	def event_params
		params.require(:event).permit(:title, :description, :date)
	end
end
