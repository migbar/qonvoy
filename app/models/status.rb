# == Schema Information
#
# Table name: statuses
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)      indexed
#  sender_screen_name :string(255)
#  sender_id          :integer(8)
#  body               :string(1000)
#  kind               :string(40)
#  status_created_at  :datetime
#  message_id         :integer(8)      indexed
#  raw                :text
#  created_at         :datetime
#  updated_at         :datetime
#  dish_id            :integer(4)      indexed
#  place_id           :integer(4)      indexed
#  rating_id          :integer(4)
#

class Status < ActiveRecord::Base
  include ActionController::UrlWriter
  
  belongs_to :user
  belongs_to :dish
  belongs_to :place
  belongs_to :rating
  
  class << self
    def create_and_process(options)
      Status.create!(options).process
    end
  end
  
  def process
    result = StatusParser.parse(body)
    self.place = Place.find_or_create_by_name(result[:place])
    
    if place.missing_information?
      message = help_out_message(place)
      RatingBird.update(message)
    end
    
    self.dish = place.dishes.find_or_create_by_name(result[:dish])
    self.rating = dish.add_rating(result[:rating], result[:scale])
    
    # tweet out rating on behalf of the user
    # 1. find user by screen name
    
    self.user = User.find_by_twitter_uid(sender_id)
    user.update_status_with_rating(self)
    
    # 2. tell that user to update their status with the vote
    
    # TODO: associate the status with the place, the dish, the rating and the user
    save!
  end
  
  private
  
  def help_out_message(place)
    "@#{sender_screen_name} We don't know much about #{place.name} yet. Could you help out? #{place_url(place, :host => Settings.host)}"
  end
  
end
