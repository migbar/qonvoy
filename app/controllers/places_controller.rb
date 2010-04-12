class PlacesController < ApplicationController
  include ActionView::Helpers::RecordIdentificationHelper
  
  before_filter :find_place
  
  def show
    @dishes = @place.dishes.descend_by_rating
    @map = GMap.new(dom_id(@place))
    @map.control_init(:large_map => false, :small_map => true, :scale => true)
    @map.center_zoom_init([@place.latitude, @place.longitude], 11)
    bubble_content = render_to_string(:partial => "bubble", :locals => { :place => @place })
    @map.overlay_init(GMarker.new([@place.latitude, @place.longitude], :title => @place.name, :info_window => bubble_content))
  end
  
  def edit
    render
  end
  
  private
    def find_place
      @place = Place.find(params[:id])
    end
end