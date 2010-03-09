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
  belongs_to :user
  
  class << self
    def create_and_process(options)
      Status.create!(options).process
    end
  end
  
  def process
    StatusParser.parse(body)
  end
end
