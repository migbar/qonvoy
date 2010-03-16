# == Schema Information
#
# Table name: places
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     indexed
#  address    :text
#  latitude   :decimal(10, 8)
#  longitude  :decimal(12, 8)
#  created_at :datetime
#  updated_at :datetime
#

class Place < ActiveRecord::Base
  validates_presence_of :name
  has_many :dishes
  
  def missing_information?
    address.blank?
  end
end
