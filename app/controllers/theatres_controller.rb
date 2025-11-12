class TheatresController < ApplicationController
  before_action :authorize_request
  before_action :require_admin
  before_action :set_theatre, only: [:show, :update, :destroy]

  def index
    render json: Theatre.active.map { |t| theatre_json(t) }
  end

  def show
    render json: theatre_json(@theatre)
  end

  def create
    @theatre = Theatre.new(theatre_params)
    if @theatre.save
      render json: theatre_json(@theatre), status: :created
    else
      render json: { errors: @theatre.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @theatre.update(theatre_params)
      render json: theatre_json(@theatre)
    else
      render json: { errors: @theatre.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @theatre.destroy
    render json: { message: "Theatre deleted successfully" }
  end
  private

  def theatre_params
    params.require(:theatre).permit(:name, :address, :city, :state, :country, :rating)
  end

  def theatre_json(theatre)
    theatre.slice(:id, :name, :address, :city, :state, :country, :rating)
  end

  def set_theatre
    @theatre = Theatre.active.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Theatre not found" }, status: :not_found
  end
end