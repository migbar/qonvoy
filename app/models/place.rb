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
#  z_food     :integer(4)
#  z_decor    :integer(4)
#  z_service  :integer(4)
#  z_price    :integer(4)
#

class Place < ActiveRecord::Base
  validates_presence_of :name
  has_many :dishes
  
  def missing_information?
    address.blank?
  end
  
  def to_s
    name
  end
  
  def rating
    z_food / 3
  end
end
