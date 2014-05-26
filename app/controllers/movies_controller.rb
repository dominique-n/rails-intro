class MoviesController < ApplicationController
	#include Movies::IndexTools
	#include MoviesHelper

	def show
		id = params[:id] # retrieve movie ID from URI route
		@movie = Movie.find(id) # look up movie by unique ID
		# will render app/views/movies/show.<extension> by default
	end

	def index
		@movies = Movie.select("*")

		@decor_title = nil
		@decor_release_date = nil
		if !params[:sorted_by].nil?
			instance_variable_set("@decor_#{params[:sorted_by]}", "hilite")
			@movies = @movies.order("#{params[:sorted_by]} ASC")
		end
	end

	def new
		# default: render 'new' template
	end

	def create
		@movie = Movie.create!(params[:movie])
		flash[:notice] = "#{@movie.title} was successfully created."
		redirect_to movies_path
	end

	def edit
		@movie = Movie.find params[:id]
	end

	def update
		@movie = Movie.find params[:id]
		@movie.update_attributes!(params[:movie])
		flash[:notice] = "#{@movie.title} was successfully updated."
		redirect_to movie_path(@movie)
	end

	def destroy
		@movie = Movie.find(params[:id])
		@movie.destroy
		flash[:notice] = "Movie '#{@movie.title}' deleted."
		redirect_to movies_path
	end

	def index_ordered_by
	end

end
