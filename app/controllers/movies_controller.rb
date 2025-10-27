class MoviesController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :require_admin, only: [:create, :update, :destroy]
  before_action :set_movie, only: [:show, :update, :destroy, :showtimes]

  # GET /api/movies
  def index
    movies = Movie.active.map do |movie|
      movie.as_json(
        only: [:id, :title, :description, :release_date, :duration, :rating]
      ).merge(
        poster_image: "/movies/#{movie.poster_image}",
        tags: movie.tags.map { |t| { id: t.id, name: t.name } }
      )
    end
    render json: movies
  end

  # GET /api/movies/:id
  def show
    render json: @movie.as_json(
      only: [:id, :title, :description, :release_date, :duration, :rating]
    ).merge(
      poster_image: "/movies/#{@movie.poster_image}",
      tags: @movie.tags.map { |t| { id: t.id, name: t.name } }
    )
  end

  # POST /api/movies
  def create
    @movie = Movie.new(movie_params.except(:tag_ids, :new_tags))

    if @movie.save
      ActiveRecord::Base.transaction do
        attach_tags(@movie, movie_params[:tag_ids])
        attach_new_tags(@movie, movie_params[:new_tags])
      end

      render json: @movie.as_json(
        only: [:id, :title, :description, :release_date, :duration, :rating]
      ).merge(
        poster_image: "/movies/#{@movie.poster_image}",
        tags: @movie.tags.map { |t| { id: t.id, name: t.name } }
      ), status: :created
    else
      render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /api/movies/:id
  def update
    if @movie.update(movie_params.except(:tag_ids, :new_tags))
      ActiveRecord::Base.transaction do
        attach_tags(@movie, movie_params[:tag_ids])
        attach_new_tags(@movie, movie_params[:new_tags])
      end

      render json: @movie.as_json(
        only: [:id, :title, :description, :release_date, :duration, :rating]
      ).merge(
        poster_image: "/movies/#{@movie.poster_image}",
        tags: @movie.tags.map { |t| { id: t.id, name: t.name } }
      )
    else
      render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/movies/:id
  def destroy
    @movie.soft_delete
    head :no_content
  end

  # GET /api/movies/:id/showtimes
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
    params.require(:movie)
          .permit(:title, :description, :poster_image, :release_date, :duration, :rating, tag_ids: [], new_tags: [])
          .tap do |whitelisted|
      if whitelisted[:poster_image].present?
        # Only keep the filename, remove any path like '/movies/...'
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
end
