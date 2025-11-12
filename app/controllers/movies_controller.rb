class MoviesController < ApplicationController
  before_action :authorize_request, except: [:index, :show, :upcoming_movies]
  before_action :require_admin, only: [:create, :update, :destroy]
  before_action :set_movie, only: [:show, :update, :destroy, :showtimes]

  def index
    movies = Movie.active
                  .where("release_date <= ?", Date.today)
                  .order(:release_date)
                  .map { |movie| movie_json(movie) }

    render json: movies
  end

  def show
    render json: movie_json(@movie)
  end


  def create
    @movie = Movie.new(movie_params.except(:tag_ids, :new_tags))
    if @movie.save
      ActiveRecord::Base.transaction do
        attach_tags(@movie, movie_params[:tag_ids])
        attach_new_tags(@movie, movie_params[:new_tags])
      end
      render json: movie_json(@movie), status: :created
    else
      render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update
    if @movie.update(movie_params.except(:tag_ids, :new_tags))
      ActiveRecord::Base.transaction do
        attach_tags(@movie, movie_params[:tag_ids])
        attach_new_tags(@movie, movie_params[:new_tags])
      end
      render json: movie_json(@movie)
    else
      render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    render json: { message: "Movie deleted successfully" }
  end

  def showtimes
    if @movie.release_date > Date.today
      return render json: { error: "This movie has not been released yet." }, status: :forbidden
    end

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

  def upcoming_movies
    upcoming = Movie.active
                    .where("release_date > ?", Date.today)
                    .order(:release_date)
                    .map { |movie| movie_json(movie) }

    render json: upcoming
  end


  private

  def set_movie
    @movie = Movie.find_by(id: params[:id])
    render(json: { error: "Movie not found" }, status: :not_found) unless @movie
  end

  def movie_params
    params.require(:movie)
          .permit(:title, :description, :poster_image, :release_date, :duration, :rating, tag_ids: [], new_tags: [])
          .tap do |whitelisted|
      if whitelisted[:poster_image].present?
        whitelisted[:poster_image] = File.basename(whitelisted[:poster_image])
      end
    end
  end

  def attach_tags(movie, tag_ids)
    movie.tag_ids = tag_ids if tag_ids.present?
  end

  def attach_new_tags(movie, new_tags)
    return unless new_tags.present?
    new_tags.map(&:strip).uniq.each do |name|
      tag = Tag.find_or_create_by(name: name)
      movie.tags << tag unless movie.tags.include?(tag)
    end
  end

  def movie_json(movie)
    movie.as_json(
      only: [:id, :title, :description, :release_date, :duration, :rating]
    ).merge(
      poster_image: "/movies/#{movie.poster_image}",
      tags: movie.tags.map { |t| { id: t.id, name: t.name } }
    )
  end
end
