class TravelsController < ApplicationController
  def index
    @travels = Travel.all
  end

  def new
    @travel = Travel.new
  end

  def create
    @travel = Travel.new(travel_params)
    @travel.user = current_user
    if @travel.save
      redirect_to travel_path(@travel)
    else
      puts @travel.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @travel = Travel.find(params[:id])
  end

  private

  def travel_params
    params.require(:travel).permit(:country, :number_of_travellers, :trip_duration, :budget)
  end
end
