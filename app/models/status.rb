# == Schema Information
#
# Table name: statuses
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)      indexed, indexed, indexed
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
#  processed_at       :datetime        indexed
#

class Status < ActiveRecord::Base
  include ActionController::UrlWriter
  
  belongs_to :user
  belongs_to :dish
  belongs_to :place
  belongs_to :rating
  
  named_scope :processed, :conditions => "#{Status.table_name}.processed_at is not null"
  
  class << self
    def create_and_process(options)
      Status.create!(options).process
    end
    
    def try_parsing(a_body)
      result = StatusParser.parse(a_body)
      [check_rating_options(result), result]
    end
    
    def check_rating_options(result)
      [:place, :dish, :rating].all? { |k| result[k] }
    end
  end
  
  def to_s
    body
  end
  
  def process
    self.user = User.find_by_twitter_uid(sender_id)
    result = StatusParser.parse(body)
    
    case result[:type].try(:to_sym)
    when :rating
      if self.class.check_rating_options(result)
        process_rating(result)
      else
        parsing_failure
      end
    else
      parsing_failure
    end
    
    save!
  end
  
  def process_updated_status!
    success, result = self.class.try_parsing(body)
    if success
      process_rating(result, false)
      save!
    end
  end
  
  def processed?
    !!processed_at
  end
  
  def process_rating(result, ask_for_place_info=true)
    self.place = Place.find_or_create_by_name(result[:place])
    
    if place.missing_information? && ask_for_place_info
      message = help_out_message(place)
      RatingBird.update(message)
    end
    
    self.dish = place.dishes.find_or_create_by_name(result[:dish])
    self.rating = dish.add_rating(result[:rating], result[:scale])
    
    user.update_status_with_rating(self)
    self.processed_at = Time.now
  end
  
  private
  
  def parsing_failure
    RatingBird.update(failure_message)
  end
  
  def help_out_message(place)
    "@#{sender_screen_name} We don't know much about #{place.name} yet. Could you help out? #{edit_place_url(place, :host => Settings.host)}"
  end
  
  def failure_message
    "@#{sender_screen_name} We could not understand what you meant. Could you help out? #{edit_status_url(self, :host => Settings.host)}"
  end
end
