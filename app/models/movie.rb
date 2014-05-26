class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

  def self.ratings_uniq_get
	  find(:all,
			 :select => "DISTINCT(rating)",
			 :order => "rating ASC").map(&:rating)
  end


end
