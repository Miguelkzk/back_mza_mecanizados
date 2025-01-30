class EventsController < ApplicationController
  before_action :set_event, only: %i[update destroy]
  before_action :authenticate_user!
  def index
    authorize Event
    render json: Event.all
  end

  def create
    authorize Event
    event = Event.new(event_params)
    if event.save
      render json: event
    else
      render json: { errors: event.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event
    if @event.destroy
      render json: @event
    else
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize @event
    if @event.update(event_params)
      render json: @event
    else
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :start, :end, :all_day)
  end
end
