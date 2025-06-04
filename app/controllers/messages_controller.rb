class MessagesController < ApplicationController
  def new
    @travel = Travel.find(params[:travel_id])
    @message = Message.new
  end

  SYSTEM_PROMPT = "You are a travel planner who creates personalized travel plans for any type of traveller.\nI am a traveller with the following preferences: country, a budget, a trip duration and number of travellers.\nBased on the user's preferences.\nFormat the response in markdown as a list per days including, specific real links of many accommodations not only hostels, recommended many restaurants and suggested activities to do."

  def create
    @travel = Travel.find(params[:travel_id])
    @message = Message.new(role: "user", content: params[:message][:content], travel: @travel)
    if @message.save
      @chat = RubyLLM.chat
      response = @chat.with_instructions(instructions).ask(@message.content)
    Message.create(role: "assistant", content: response.content, travel: @travel)
    redirect_to travel_messages_path(@travel)
    else
      render :new
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  def index
    @travel = Travel.find(params[:travel_id])
    @messages = Message.all
  end

  private

  def message_params
    params.require(:message).permit(:country, :number_of_travellers, :trip_duration, :budget)
  end

  def travel_context
    "Here is the context of the trip request: #{@travel.country} #{@travel.budget} #{@travel.trip_duration} #{@travel.number_of_travellers}."
  end

  def instructions
    [SYSTEM_PROMPT, travel_context].compact.join("\n\n")
  end

end
