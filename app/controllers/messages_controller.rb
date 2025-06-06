class MessagesController < ApplicationController
  def new
    @travel = Travel.find(params[:travel_id])
    @message = Message.new
  end

  SYSTEM_PROMPT = "You are a travel planner who creates personalized travel plans for any type of traveller.\n\nI am a traveller with the following preferences: country, a budget,
      a trip duration and number of travellers.\n\nBased on the user's preferences.\n\nFormat the response as a list per days including,
      specific real links of many accommodations not only hostels."

  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params.merge(role: "user", chat: @chat))
    if @message.save
      if @chat.title == "Untitled"
        @chat.generate_title_from_first_message
      end
      @response = RubyLLM.chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: @response.content, chat: @chat)
      redirect_to travel_chat_path(@chat.travel.id, @chat)
    else
      render :show, status: :unprocessable_entity
    end
  end

  def show
    @travel = Travel.find(params[:travel_id])
    @message = Message.find(params[:id])
  end

  def index
    @travel = Travel.find(params[:travel_id])
    @messages = Message.all
  end

  private

  def message_params
    params.require(:message).permit(:country, :content, :number_of_travellers, :trip_duration, :budget)
  end

  def travel_context
    "Here is the context of the trip request: #{@chat.travel.country} #{@chat.travel.budget} #{@chat.travel.trip_duration} #{@chat.travel.number_of_travellers}."
  end

  def instructions
    [SYSTEM_PROMPT, travel_context].compact.join("\n\n")
  end

end
