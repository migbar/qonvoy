class MapPresenter
  include ActionView::Helpers::RecordIdentificationHelper

  attr_reader :mappable, :map, :controller
  
  delegate :to_html, :div, :to => :map
  
  def initialize(object, options={})
    @mappable = object
    @controller = options.delete(:controller)
    setup_map
  end
  
  def to_html_with_header
    GMap.header + to_html
  end
  
  private
    def mappable_type
      @mappable_type ||= mappable.class.name.underscore
    end
    
    def bounds
      bounds = mappable.bounds
      
      [ [bounds[:sw][:latitude], bounds[:sw][:longitude] ], [ bounds[:ne][:latitude], bounds[:ne][:longitude] ] ]
    end
    
    def setup_map
      @map = GMap.new(dom_id(mappable, :map))
      @map.control_init(:large_map => false, :small_map => true, :scale => true)
      # @map.center_zoom_init([mappable.latitude, mappable.longitude], 13)
      @map.center_zoom_on_bounds_init(bounds)
      bubble_content = controller.send(:render_to_string, :partial => "#{mappable_type.pluralize}/small_bubble", :locals => { mappable_type.to_sym => mappable })
      marker = GMarker.new([mappable.latitude, mappable.longitude], :title => mappable.name, :info_window => bubble_content)
      @map.overlay_init(marker)
    end
end