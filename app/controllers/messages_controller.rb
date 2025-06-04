class MessagesController < ApplicationController
  def new
    @travel = Travel.find(params[:travel_id])
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    if @message.save
      redirect_to message_path(@message)
    else
      puts @message.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  private

  def message_params
    params.require(:message).permit(:country, :number_of_travellers, :trip_duration, :budget)
  end

end
