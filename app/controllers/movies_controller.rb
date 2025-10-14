class MoviesController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :require_admin, only: [:create, :update, :destroy]
  before_action :set_movie, only: [:show, :update, :destroy, :showtimes]


  def index
    movies = Movie.active.map { |m| movie_json(m) rescue nil }.compact
    render json: movies
  end

  def show
    render json: movie_json(@movie)
  end

  def create
    @movie = Movie.new(movie_params.except(:tag_ids, :new_tags))

    if @movie.save
      ActiveRecord::Base.transaction do
        attach_tags(@movie, params[:movie][:tag_ids])
        attach_new_tags(@movie, params[:movie][:new_tags])
      end
      render json: movie_json(@movie), status: :created
    else
      render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @movie.update(movie_params.except(:tag_ids, :new_tags))
      ActiveRecord::Base.transaction do
        attach_tags(@movie, params[:movie][:tag_ids])
        attach_new_tags(@movie, params[:movie][:new_tags])
      end
      render json: movie_json(@movie)
    else
      render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.soft_delete
    render json: { message: "Movie deleted" }
  end

  # Fetches active showtimes for this movie, including associated screens
  def showtimes
    showtimes = @movie.showtimes.active.includes(:screen)
    render json: showtimes.map do |st|
      {
        id: st.id,
        movie_id: st.movie_id,
        screen_id: st.screen_id,
        screen_name: st.screen.name,
        start_time: st.start_time,
        end_time: st.end_time,
        language: st.language,
        available_seats: st.available_seats
      }
    end
  end

  private

  def set_movie
    @movie = Movie.find_by(id: params[:id])
    render(json: { error: "Movie not found" }, status: 404) unless @movie
  end

  def movie_params
    params.require(:movie).permit(:title, :description, :poster_image, :release_date, :duration, :rating, tag_ids: [], new_tags: [])
  end

  def movie_json(movie)
    {
      id: movie.id,
      title: movie.title,
      description: movie.description,
      poster_image: view_context.asset_path("movies/#{movie.poster_image}"),
      release_date: movie.release_date,
      duration: movie.duration,
      rating: movie.rating,
      tags: movie.tags.map { |t| { id: t.id, name: t.name } }
    }
  end

  def attach_tags(movie, tag_ids)
    return unless tag_ids.present?
    movie.tag_ids = tag_ids
  end

  def attach_new_tags(movie, new_tags)
    return unless new_tags.present?
    new_tags.each do |name|
      tag = Tag.find_or_create_by(name: name.strip)
      movie.tags << tag unless movie.tags.include?(tag)
    end
  end
end
