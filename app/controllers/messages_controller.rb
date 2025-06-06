class MessagesController < ApplicationController
  def new
    @travel = Travel.find(params[:travel_id])
    @message = Message.new
  end

  SYSTEM_PROMPT = "You are a travel planner who creates personalized travel itineraries for any type of traveler. I am a traveler with the following preferences: country, budget, trip duration, and number of travelers.\n\n
  Based on these preferences (only if I give you preferences), generate a daily itinerary.\n\n
  Format your response as a day-by-day list and include specific real links (2 ou 3 links for each categories) to a variety of accommodations—not just hostels."

  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params.merge(role: "user", chat: @chat))
    if @message.save
      @response = RubyLLM.chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: @response.content, chat: @chat)
      redirect_to travel_chat_path(@chat.travel.id, @chat)
    else
      render :show, status: :unprocessable_entity
    end
  end

      #   build_conversation_history
      # @response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

  def build_conversation_history
    @ruby_llm_chat = RubyLLM.chat
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
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
