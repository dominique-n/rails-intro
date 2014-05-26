class MoviesController < ApplicationController
	#include Movies::IndexTools
	include MoviesHelper::MoviesController

	#session :on

	def show
		id = params[:id] # retrieve movie ID from URI route
		@movie = Movie.find(id) # look up movie by unique ID
		# will render app/views/movies/show.<extension> by default
	end

	def index

		logger.info "--PARAMS = #{params}"
		logger.info "--SESSION = #{session.empty?}"
		logger.info "--FLASH = #{flash.empty?}"
		
		#no-cookied hit
		@box_states = Hash.new(0)
		@all_ratings = Movie.ratings_uniq_get
		@all_ratings.each{|r| @box_states[r]=1}
		@movies = Movie.select("*")

		if session.empty?
			logger.info "--INTO EMPTY SESSION"
			session[:sorted_by] = "none"
			session[:ratings] = @box_states
			logger.info "--INTO EMPTY SESSION - session = #{session}"
			return
		end

		#test params completeness else redirect with updated params <- session
		if params[:sorted_by].nil? || params[:ratings].nil?
			params[:sorted_by] = session[:sorted_by] if params[:sorted_by].nil?
			params[:ratings] = session[:ratings] if params[:ratings].nil?
			redirect_to movies_path(params)
		end

		##sort ascending per title or release_date

		@decor_title = nil 
		@decor_release_date = nil 
		if params[:sorted_by] != "none"
			instance_variable_set("@decor_#{params[:sorted_by]}", "hilite")
			@movies = @movies.order("#{params[:sorted_by]} ASC")
			session[:sorted_by] = params[:sorted_by]
		end

		@movies = @movies.where(where_or_string(:rating, params[:ratings].keys.length), *params[:ratings].keys)
		@box_states.each{|k,v| @box_states[k] = 0 if !params[:ratings].has_key?(k)}
		session[:ratings] = params[:ratings]
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
