class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies=Movie.all
    @all_ratings=Movie.ratings
    if params[:ratings]
      @ratings=params[:ratings]
    elsif session[:ratings]
      @ratings=session[:ratings]
    else
      @ratings=Hash[@all_ratings.map {|rating|[rating,rating]}]
    end
    if params[:sort]
      @sort=params[:sort]
    elsif session[:sort]
      @sort=session[:sort]
    end
    @movies=Movie.where(rating:@ratings.keys).order(@sort)
    if params[:ratings]!=session[:ratings]
      session[:ratings]=@ratings
      session[:sort]=@sort
      flash.keep
      redirect_to movies_path(ratings:session[:ratings],sort:session[:sort])
    elsif params[:sort]!=session[:sort]
      session[:sort]=@sort
      session[:ratings]=@ratings
      flash.keep
      redirect_to movies_path(ratings:session[:ratings],sort:session[:sort])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
