# == Schema Information
#
# Table name: dishes
#
#  id         :integer(4)      not null, primary key
#  place_id   :integer(4)      indexed => [name], indexed
#  name       :string(255)     indexed, indexed => [place_id]
#  rating     :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Dish < ActiveRecord::Base
  belongs_to :place
  has_many :ratings
  has_many :statuses
  
  def add_rating(value, scale)
    new_rating = Rating.normalize(value, scale)
    returning(ratings.create(:value => new_rating)) do
      update_rating(new_rating)
      save!
    end
  end
  
  def rating
    _rating / 10.0
  end
  
  def latest_status
    statuses.descend_by_created_at.first
  end
  
  private
    def update_rating(value)
      size = ratings.size
      self.rating = (((_rating || 0) * (size - 1)) + value) / size
    end
    
    def _rating
      read_attribute(:rating)
    end
end
