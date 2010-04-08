# == Schema Information
#
# Table name: ratings
#
#  id         :integer(4)      not null, primary key
#  dish_id    :integer(4)      indexed
#  value      :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Rating < ActiveRecord::Base
  belongs_to :dish
  
  class << self
    def normalize(value, scale=nil)
      scale = scale && scale.to_f || 10
      (value.to_f * 100 / scale).round
    end
  end
  
  def to_s
    (value / 10.0).to_s
  end
end
