class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit approve reject update destroy]
  before_action :require_user!, except: %i[index show new create]

  # GET /events or /events.json
  def index
    @events = Event.approved
    if params[:tag].present? && params[:tag].in?(Event::TAGS)
      @events = @events.tagged_with(params[:tag])
    end
  end

  def list
    @events = Event.upcoming.pending
  end

  def approve
    @event.status = "approved"
    @event.approved_by_id = current_user.id
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully approved." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :show, status: :unprocessable_entity, notice: "Event was not approved." }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def reject
    @event.status = "rejected"
    @event.approved_by_id = current_user.id
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully rejected." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :show, status: :unprocessable_entity, notice: "Event was not rejected." }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    params[:event][:tags].compact_blank!
    # Set the status to "pending" by default
    event_params[:status] = "pending"
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    event_params[:tags].compact_blank!
    respond_to do |format|
      if @event.update(event_params)
        @event.tags.compact_blank!
        @event.save
        format.html { redirect_to @event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:location, :latitude, :longitude, :start_time, :end_time, :title, :url, :description, :cost, :pre_registration_required, tags: [])
  end
end
