class ChatsController < ApplicationController
  def index
    @travel = Travel.find(params[:travel_id])
    @chats =  current_user.chats.where(travel: @travel)
    @chat = Chat.new
  end

  def create
    @travel = Travel.find(params[:travel_id])
    @chat = Chat.new(title: "Untitled", model_id: "gpt-4.1-nano")
    @chat.travel = @travel
    @chat.user = current_user
    if @chat.save
      redirect_to travel_chat_path(@travel, @chat)
    else
      render :index
    end
  end

  def show
    @travel = Travel.find(params[:travel_id])
    @chat = Chat.find(params[:id])
    @message = Message.new
  end

end
