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
#

class Status < ActiveRecord::Base
  include ActionController::UrlWriter
  
  belongs_to :user
  
  class << self
    def create_and_process(options)
      Status.create!(options).process
    end
  end
  
  def process
    result = StatusParser.parse(body)
    place = Place.find_or_create_by_name(result[:place])
    
    if place.missing_information?
      message = help_out_message(place)
      RatingBird.update(message)
    end
    
    # record the rating
    # tweet out rating on behalf of the user
  end
  
  private
  
  def help_out_message(place)
    "@#{sender_screen_name} We don't know much about #{place.name} yet. Could you help out? #{edit_place_url(place, :host => Settings.host)}"
  end
  
end
