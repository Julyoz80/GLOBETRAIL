class MessagesController < ApplicationController
  def new
    @travel = Travel.find(params[:travel_id])
    @message = Message.new
  end


  SYSTEM_PROMPT = "You are a travel planner who creates personalized travel itineraries for any type of traveler.\n\n
  I am a traveler with the following preferences: country, budget, trip duration, and number of travelers.\n\n
  Based on these preferences, generate a daily itinerary.\n\n
  Format your response as a day-by-day list and include specific url links to go on the website (3 proposals for each categories).\n\n
  You will use this information to suggest the best trip.\n\n
  Finally, edit a short summary of my trip."



  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params.merge(role: "user", chat: @chat))
    if @message.save
      build_conversation_history
      @response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      if @chat.title == "Untitled"
        @chat.generate_title_from_first_message
      end
      Message.create(role: "assistant", content: @response.content, chat: @chat)
      redirect_to travel_chat_path(@chat.travel.id, @chat)
    else
      render :show, status: :unprocessable_entity
    end
  end

  def build_conversation_history
    @ruby_llm_chat = RubyLLM.chat
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message({
        role: message.role,
        content: message.content
      })
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
    "Here is the context of the trip request: country:#{@chat.travel.country}, budget: #{@chat.travel.budget}, duration: #{@chat.travel.trip_duration}, number of travellers: #{@chat.travel.number_of_travellers}."
  end

  def instructions
    [SYSTEM_PROMPT, travel_context].compact.join("\n\n")
  end

end
