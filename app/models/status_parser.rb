class StatusParser
  QUALIFIERS = %w[awesome great good tasty]
  PLACE_DELIMITERS = %w[from at in]
  RATING_DELIMITERS = %w[: - ,]
  
  # define_rating /.../
  # define_rating /.../
  
  # define_recomendation /.../
  # define_recomendation /.../
  
  
  class << self
    def parse(message)
      regex = /(#{dish_qualifiers}\s+)?(.*?)(#{place_delimiters}\s+)(.*?)(#{rating_delimiters}\s*)?(\d{1,2})\s+out\s+of\s+(\d{1,2})/i
      m = regex.match(message)
      {
        :qualifier => m[1].try(:strip),
        :dish => m[2].strip,
        :place => m[4].strip,
        :rating => m[6],
        :scale => m[7],
        :type => :rating
      }
    end
    
    def delimiters(values)
      joined_delimiters = values.map { |v| Regexp.escape(v) }.join("|")
      "#{joined_delimiters}"
    end
    
    def dish_qualifiers
      delimiters(QUALIFIERS)
    end
    
    def place_delimiters
      delimiters(PLACE_DELIMITERS)
    end
    
    def rating_delimiters
      "[#{RATING_DELIMITERS.map {|v| Regexp.escape(v)}}]"
    end
  end
end