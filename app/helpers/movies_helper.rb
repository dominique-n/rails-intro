module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def where_or_string(attr_name, n_values)
	  (1..n_values).map do |v|
		  "#{attr_name} = ?"
	  end.join(" OR ")
  end
end
