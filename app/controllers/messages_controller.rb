class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    ## @messages = Message.get_messages_for_current_user
    ## @messages = self.get_messages_for_current_user
    puts "MessageController::Index"
    @messages = Message.where("to_user_id = #{current_user.id}")
    puts "Message count #{@messages.count}"
    if @messages.count == 0 then
      puts "No messages, creating one"
      Message.deliver_welcome_message current_user.id
      @messages = Message.where("to_user_id = #{current_user.id}")
      puts "Message count #{@messages.count}"
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    if not @message.read_at then
      @message.read_at = Time.now
      @message.save!
    end
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:to_user_id, :from_user_id, :subject, :text, :sent_at, :read_at)
    end
end
