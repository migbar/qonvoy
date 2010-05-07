class MapPresenter
  include ActionView::Helpers::RecordIdentificationHelper

  attr_reader :mappable, :map, :controller
  
  delegate :div, :to => :map              
  
  class <<self
    def logger
      Rails.logger
    end
  end             
  
  def logger
    self.class.logger
  end
  
  def initialize(object, options={})
    @mappable = object
    @controller = options.delete(:controller) 
             logger.debug(">> map presenter initialized")
    setup_map
  end
  
  def to_html_with_header
    GMap.header + to_html
  end
  
  def to_html
    %Q{
      <script type="text/javascript">
      MapController.init(function () {
        #{map.to_html(:no_load => true, :no_script_tag => true)};
        return map;
      });
      </script>
    }
  end
  
  private
    def mappable_type
      @mappable_type ||= mappable.class.name.underscore
    end
    
    def bounds  
      [ [mappable.sw_bounds[:latitude], mappable.sw_bounds[:longitude] ], [ mappable.ne_bounds[:latitude], mappable.ne_bounds[:longitude] ] ]
    end
    
    def setup_map
      @map = GMap.new(dom_id(mappable, :map))
      @map.control_init(:large_map => false, :small_map => true, :scale => true)
      # @map.center_zoom_init([mappable.latitude, mappable.longitude], 13)  
      @map.center_zoom_on_bounds_init(bounds)                
      bubble_content = controller.send(:render_to_string, :partial => "#{mappable_type.pluralize}/small_bubble", :locals => { mappable_type.to_sym => mappable })
      marker = GrbMarker.new([mappable.latitude, mappable.longitude], :title => mappable.name, :info_window => bubble_content)
      @map.overlay_init(marker)
    end
end