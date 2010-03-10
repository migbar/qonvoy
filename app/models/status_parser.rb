class StatusParser
  QUALIFIERS = %w[awesome great good tasty]
  PLACE_DELIMITERS = %w[from at in]
  RATING_DELIMITERS = %w[: - ,]
  
  # define_rating /.../
  # define_rating /.../
  
  # define_recomenndation /.../
  # define_recomenndation /.../
  
  class << self
    def parse(message)
      # regex = /(#{dish_qualifiers}\s+)?(.*?)(#{place_delimiters}\s+)(.*?)(#{rating_delimiters}\s*)?(\d{1,2})\s+out\s+of\s+(\d{1,2})/i
      
      # m = regex.match(message)
      # {
      #   :qualifier => m[1].try(:strip),
      #   :dish => m[2].strip,
      #   :place => m[4].strip,
      #   :rating => m[6],
      #   :scale => m[7],
      #   :type => :rating
      # }
      # 
      format_processor, match = *match_format(message)
      
      format_processor.call(match)
    end
    
    def match_format(message)
      results = FORMATS.map do |regex, processor|
        if match = regex.match(message)
          [processor, match]
        else
          nil
        end
      end.compact
      
      results.first || [lambda { {} }, nil]
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
  
  FORMATS = {
    /(#{dish_qualifiers}\s+)?(.*?)(#{place_delimiters}\s+)(.*?)(#{rating_delimiters}\s*)?(\d{1,2})\s+out\s+of\s+(\d{1,2})/i => lambda do |m|
      {
        :qualifier => m[1].try(:strip),
        :dish => m[2].strip,
        :place => m[4].strip,
        :rating => m[6],
        :scale => m[7],
        :type => :rating
      }
    end,
    /(\d{1,2})\/(\d{1,2})\s+for\s+the\s+(.*?)at\s+(.*)/i => lambda do |m|
      {
        :qualifier => nil,
        :rating => m[1],
        :scale => m[2],
        :dish => m[3].strip,
        :place => m[4].strip,
        :type => :rating
      }
    end
  }
end