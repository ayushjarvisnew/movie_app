class ScreensController < ApplicationController
  before_action :authorize_request
  before_action :require_admin, only: [:create, :update, :destroy]
  before_action :set_screen, only: [:show, :update, :destroy]

  def index
      # screens = Screen.includes(:theatre).all
      # render json: screens.as_json(include: { theatre: { only: [:id, :name] } }, only: [:id, :name, :total_seats, :screen_type])
      render json: Screen.active.includes(:theatre).map { |s| screen_json(s) }
  end

  def show
    render json: screen_json(@screen)
  end

  def create
    @screen = Screen.new(screen_params)
    if @screen.save
      render json: screen_json(@screen), status: :created
    else
      render json: { errors: @screen.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @screen.update(screen_params)
      render json: screen_json(@screen)
    else
      render json: { errors: @screen.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @screen.update(deleted_at: Time.current)
      render json: { message: "Screen soft-deleted successfully" }
    else
      render json: { errors: @screen.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_screen
    @screen = Screen.active.find_by(id: params[:id])
    render(json: { error: "Screen not found" }, status: :not_found) unless @screen
  end

  def screen_params
    params.require(:screen).permit(:name, :total_seats, :screen_type, :theatre_id)
  end

  def screen_json(screen)
    {
      id: screen.id,
      name: screen.name,
      seats: screen.total_seats,
      screen_type: screen.screen_type,
      theatre: { id: screen.theatre.id, name: screen.theatre.name }
    }
  end
end
